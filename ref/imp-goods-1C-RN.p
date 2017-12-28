
/*------------------------------------------------------------------------
    File        : imp-goods-1C-RN.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Oct 26 18:13:10 AST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Загрузка товара из ERP 1C RN".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ rul/garbcoll.i }
{ gbl/cur-time.i }
{ nws/lib-nws.i }
{ trg/new-bcod.i }
{ ref/send-ref.i }
&glob cmd-proc-handle p-cmd-proc-handle
&glob cmd-code p-cmd-code
{ nws/temp-cmd.i "SHARED" }
{ rul/cl-hist.i "shared" }
{ rul/library-cls.i "non-class-part" }
{ gbl/key-rec.i }
{ rul/tempcxml.i "shared" }
{ gbl/gate-clb.i }
{ ref/grplib.i }
{ bge/tmpcxmlh.i }
{ bge/getoxmlh.i }
{ gbl/xmlchar.i }
{ gbl/tmpreldf.i }
{ gbl/tmpreld2.i }
{ ref/extclass.i }
{ str/tt-tax.i "new SHARED" tt-tax full }
{ gbl/orapreps.i }
{ cmp/t-tnved.i "new"  }
{ nws/db-rec.i }
{ gbl/getcntxa.i }
{ ref/gds-attr.i}
{ ref/gdsoattr.i }

define input parameter p-GdsObj         as class goods .

define buffer buf_goods for ub.goods.
define buffer buf_goods-attr for ub.goods-attr .
      
define buffer buf_units for ub.units.
define buffer buf_units-cli for ub.units.
define buffer buf_gds-prt for ub.gds-prt .
define buffer first_gds-grp for ub.gds-grp.

define buffer base-bar-code for ub.bar-code.
define buffer buf_bar-code for ub.bar-code.
define buffer buf_prod-bc for ub.prod-bc.

define variable v-barcode as class goods_barcode .
define variable v-barcodes as class subjects .

define variable parparentproc     as widget-handle no-undo .
define variable v-stts            as integer      no-undo .
define variable v-rid             as recid        no-undo .
define variable v-bc-rid          as recid        no-undo .
define variable v-rid-pbc         as recid        no-undo .
define variable v-gds-mode        as character    no-undo .
define variable v-node-code       as integer      no-undo .
define variable v-nbc             as integer      no-undo .
define variable v-attr-del        as logical      no-undo .
define variable v-ok              as logical      no-undo .
define variable v-err-mess        as character    no-undo .
define variable v-nds-rate-code   as integer      no-undo .
define variable v-b-str as character no-undo .
DEFINE VARIABLE v-today as date no-undo .
DEFINE VARIABLE v-time as integer no-undo .
define variable v-taxvalue as decimal no-undo .
define variable v-bc-mode as character no-undo .
define variable ii as integer no-undo .
define variable par-recid-fbr as recid no-undo .
define buffer buf-clients for clients.

define variable v-fuel-type as character no-undo .
define variable v-srvc-type as character no-undo .
define variable v-neu-l     as decimal no-undo .
define variable v-neu-z     as decimal no-undo .
define variable v-unit-spl-code as character no-undo .
define variable v-is-petrl as logical no-undo .
define variable v-barcode-list as longchar no-undo .

  define variable v-cntxt-db-num        as integer   no-undo . /* текущая БД            */
  define variable v-cntxt-userid        as character no-undo . /* текущий пользователь  */
  define variable v-cntxt-level         as character no-undo . /* уровень контекста     */
  define variable v-cntxt-host-code-obj as integer   no-undo . /* текущая фирма         */
  define variable v-cntxt-obj-type      as character no-undo . /* тип текущего объекта  */
  define variable v-cntxt-obj-code      as integer   no-undo . /* код текущего объекта  */
  define variable v-cntxt-db-num-obj    as integer   no-undo . /* база текущего объекта */
  define variable v-cntxt-is-admin      as logical   no-undo . /* база текущего объекта */

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

  parparentproc = this-procedure:handle .
  
  v-barcodes = p-GdsObj:barcode .
  
  v-unit-spl-code = p-GdsObj:unit-spl-code no-error.
  if v-unit-spl-code = ? or v-unit-spl-code = "" then v-unit-spl-code = p-GdsObj:unit-code .
  
  find first ub.clients no-lock where ub.clients.db-num = g#db-num
                                  and ub.clients.obj-type = {&shop}
                                  and ub.clients.stts = 0 .
  
  for first buf_gds-prt field (node-code) no-lock
      where buf_gds-prt.root = true
        and buf_gds-prt.node-name = {&empty-scale} :
      assign
        v-node-code = buf_gds-prt.node-code
        v-ok = yes
      .
  end.
  if not v-ok
  then do:
      undo, return error substitute("&1 не найдена", {&empty-scale} ) .
  end.
  
  find first buf_goods no-lock where buf_goods.gds-code = integer(p-GdsObj:code_) no-error.
  if not available buf_goods
  then do :
      assign
        v-gds-mode = {&add-def}
        v-rid = ?
      .
  end.
  else do :
      assign
        v-gds-mode = {&update}
        v-rid = recid(buf_goods)
      .
  end.
  
  find first buf_units no-lock where buf_units.unit-name = p-GdsObj:unit-code no-error.
  if not available buf_units
  then do :
      undo, return error ("Нет единицы измерения " + p-GdsObj:unit-code) .
  end.
  assign v-is-petrl = ( if lookup( {&petrolium}, buf_units.type ) > 0 then yes else no ).
  if lookup( {&pieces}, buf_units.type ) = 0 then do:
      if v-is-petrl = yes and lookup( {&divisional}, buf_units.type ) = 0 then do:
        undo, return error substitute( 'Неверная связка типов единиц измерения для топлива: "&1" .',
                                       buf_units.type ).
      end.
  end.
  if p-GdsObj:gds-type = "н" and not v-is-petrl
  then do :
      undo, return error ("Тип товара в файле - нефтепродукт, но указана нетопливная единица измерения. Товар с кодом " + p-GdsObj:code_) .
  end.
/*  find first buf_units-cli no-lock where buf_units-cli.OKEI = integer(p-GdsObj:unit-spl-code) no-error.*/
/*  if not available buf_units-cli                                                                       */
/*  then do :                                                                                            */
/*      undo, return error ("Нет единицы измерения с кодом ОКЕИ " + string(p-GdsObj:unit-spl-code)) .    */
/*  end.                                                                                                 */
  
  find last ub.tax-rate-value no-lock where ub.tax-rate-value.rate-value = p-GdsObj:nds-code
                                      and ub.tax-rate-value.tax-code = integer({&vat-tax-code})
                                      and ub.tax-rate-value.status_ = {&current-status}
                                      use-index i-status no-error .
  if available ub.tax-rate-value then v-nds-rate-code = ub.tax-rate-value.rate-code .
  
    for each tt-tax:
      delete tt-tax.
    end.
    run ref/dtaxgdss.p (
          input yes /*p-silent*/
        , input /*par-unit-base*/  p-GdsObj:unit-code
        , input /*par-node-code*/  v-node-code
        , input (if v-gds-mode = {&add-def} THEN ? ELSE v-rid)
        , input (if v-gds-mode = {&add-def} THEN ? ELSE v-rid)
        , input /*par-host-code*/  0
        , input /*par-obj-type*/   ''
        , input /*par-obj-code*/  0
          ) no-error.
    if error-status:error then do:
      v-err-mess = substitute("Ошибки при определении налогов на товар:&1&2&1&3"
                               , {&new-line}
                               , error-status:get-message(1)
                               , return-value ).
      undo, return error v-err-mess .
    end.
    find first tt-tax where
              tt-tax.tax-code = integer({&vat-tax-code}).

    run cur-time in this-procedure(output v-today, output v-time).
    { gbl/pftaxval.i ? tt-tax.tax-code tt-tax.rate-code v-today 0 '' 0 v-taxvalue no-error }
    if error-status:error or v-taxvalue = ? then do:
      v-err-mess = substitute("Ошибка при поиске НДС (код ставкм &5) на текущую дату для товара &1&2&3&2&4"
                                , p-GdsObj:code_
                                , {&new-line}
                                , error-status:get-message(1)
                                , return-value
                                , tt-tax.rate-code
                                ).
      undo, return error v-err-mess .
    end.
    if not v-gds-mode = {&add-def} then do:
      tt-tax.fact-date = v-today.
    end.
    assign
    tt-tax.rate-code = v-nds-rate-code
    .
    
  run ref/goods01.p (
                    input parparentproc
                    , input v-gds-mode
                  , input no /*par-copymode */
                  , input 0 /*par-alt-bc-mode as integer нужно ли вводить ДОП БК вместе с товаром*/
                  , input no /*par-manual as logical мз карточки товара - yes*/
                  , input yes /*par-silence as logical  ругаемся вслух или ?*/
                  , input no /* import */
                  , input no /*par-file as logical идет импоррт из файла - из карточки товара*/
                  , input no /*par-single-record as logical надо сохранить только одну запись - потом выход в справ*/
                  , input ub.clients.host-code /*par-host-code like ub.sysconf.host-code */
                  , input ub.clients.obj-type /*par-obj-type like ub.clients.obj-type */
                  , input ub.clients.obj-code /*par-obj-code like ub.clients.obj-code */
                  , input (if p-GdsObj:gds-type = {&gds-goods} or p-GdsObj:gds-type = "н":U or p-GdsObj:gds-type = "б":U or p-GdsObj:gds-type = "р":U  then  yes else no)
                  , input ? /*par-copy-rec as recid recid записи с которой копируем*/
                  , input integer(p-GdsObj:code_)
                  , input p-GdsObj:artic
                  , input "орг"
                  , input integer(p-GdsObj:prod-code)
                  , input v-node-code
                  , input integer(p-GdsObj:grp-code)
                  , input p-GdsObj:name_
                  , input "":U /*par-saved-name like ub.buf_goods.gds-name no-undo */
                  , input "":U /*engl-name */
                  , input p-GdsObj:label-name
                  , input p-GdsObj:chk-name
                  , input "RU" /*buf_temp-goods_.alpha1*/
                  , input p-GdsObj:unit-code /*buf_units.unit-name*/
                  , input v-unit-spl-code /*buf_units-cli.unit-name*/
                  , input 0 /*p-max-rate*/
                  , input 0 /*p-min-rate*/
                  , input p-GdsObj:unit-k 
                  , input 1 /*buf_temp-goods_.qnty-cart*/
                  , input p-GdsObj:ms
                  , input p-GdsObj:wt
                  , input 0 /*buf_temp-goods_.ms-cart*/
                  , input 0 /*buf_temp-goods_.wt-cart*/
                  , input {&pr-calc-grp}
                  , input 0 /*increase-pc*/
                  , input p-GdsObj:enbl-ne
                  , input (if p-GdsObj:gds-type = "у" then 1 else 0) /*price-base*/
                  , input (if p-GdsObj:gds-type = "у" then 1 else 0) /*price-rubl*/
                  , input "" /*buf_temp-goods_.okdp*/
                  , input "" /*buf_temp-goods_.destin*/
                  , input "" /*buf_temp-goods_.attrib*/
                  , input "" /*buf_temp-goods_.user-rule*/
                  , input "" /*buf_temp-goods_.sert*/
                  , input "" /*buf_temp-goods_.struct*/
                  , input "" /*buf_temp-goods_.deadline*/
                  , input 0 /*cond-keep-code*/
                  , input "" /*buf_temp-goods_.sort*/
                  , input 0 /*proof*/
                  , input 0 /*normal-wastage*/
                  , input 0 /*normal-waste*/
                  , input '' /*tnved*/
                  , input "" /*buf_temp-goods_.nationality*/
                  , input v-unit-spl-code /*uniq-cst*/
                  , input p-GdsObj:unit-k /*cst-base-rate*/
                  , input ? /*fbr-grp-code*/
                  , input "" /*buf_temp-goods_.PS*/
                  , input no /*unq-artc*/
                  , input no /*is-jwlr*/
                  , input no /*is-bttl*/
                  , input yes /*is-ptrl*/
                  , input "no" /*custvalue*/
                  , input no
                  , input no
                  , input no /*par-ArtDis  */
                  , input 2 /*par-BarDis  */
                  , input-output v-rid
                  , output v-nbc
                ) no-error .
  if error-status :error then do:
      v-err-mess = substitute("Ошибка при сохранении goods &1&2&3&2&4"
                                , p-GdsObj:code_
                                , {&new-line}
                                , error-status:get-message(1)
                                , return-value ).
      undo, return error v-err-mess .
  end.
  
  if v-nbc = 0 or v-nbc = ? then v-nbc = integer(p-GdsObj:code_) .
  
  case p-GdsObj:fuel-type :
    when "1" then v-fuel-type = "petrol".
    when "2" then v-fuel-type = "diesel-sum" .
    when "3" then v-fuel-type = "diesel-wint" . 
    when "4" then v-fuel-type = "metan" .
    when "5" then v-fuel-type = "propan" .
    otherwise v-fuel-type = ? .
  end case.
  
  if v-fuel-type <> ?
  then do :
    RUN gds-attr-write (v-nbc, {&attr-fuel-type}, v-fuel-type).  
  end.
  else do :
    RUN gds-attr-delete (v-nbc, {&attr-fuel-type}, output v-attr-del).     
  end.
  if v-is-petrl then RUN gds-attr-write (v-nbc, {&attr-dflt-insalepr}, 'yes').
  case p-GdsObj:srvc-type :
    when 1 then v-srvc-type = {&attr-office-type_oss-pay}.
    when 2 then v-srvc-type = {&attr-office-type_card-act} .
    when 3 then v-srvc-type = {&attr-office-type_tso-ret} . 
    otherwise v-srvc-type = ? .
  end case.
  
  if v-srvc-type <> ?
  then do :
    RUN gds-attr-write (v-nbc, {&attr-office-type}, v-srvc-type).  
  end.
  else do :
    RUN gds-attr-delete (v-nbc, {&attr-office-type}, output v-attr-del).     
  end.
  /* Если блюдо поставим атрибуты на объекте, что это блюдо */

  if p-GdsObj:gds-type = "б":U then do:
       for each buf-clients no-lock where buf-clients.db-num = g#db-num
                                  and buf-clients.obj-type = {&shop}
                                  and buf-clients.stts = 0 :

           find first  fbr-gds-obj where fbr-gds-obj.gds-code =  v-nbc 
                                        and fbr-gds-obj.obj-type = buf-clients.obj-type 
                                        and fbr-gds-obj.obj-code = buf-clients.obj-code 
                                        no-lock no-error. 
           par-recid-fbr    =  if available fbr-gds-obj then recid(fbr-gds-obj) else ?.   
              
           run ref/fgdsobj1.p (
                            input-output par-recid-fbr
                        , input (if available fbr-gds-obj
                                    then {&update}
                                    else {&add-def})
                        , input no /*p-silent*/
                        , input v-nbc
                        , input buf-clients.obj-type 
                        , input buf-clients.obj-code
                        , input if available fbr-gds-obj then fbr-gds-obj.fbr-grp-code else 0
                        , input buf-clients.obj-type
                        , input buf-clients.obj-code
                        , input if available fbr-gds-obj then fbr-gds-obj.is-cd else no
                        , input true
                        , input if available fbr-gds-obj then fbr-gds-obj.is-modificator else no
                        , input if available fbr-gds-obj then fbr-gds-obj.is-null-price else no
                        , input if available fbr-gds-obj then fbr-gds-obj.is-season else no
                        , input if available fbr-gds-obj then fbr-gds-obj.is-semi-finished else no
                        ) no-error.
                                                    
       end.                                
  end.   

  v-barcode-list = "" .
  if valid-object (v-barcodes)
  then do :
      find base-bar-code no-lock where
           base-bar-code.b-code = v-nbc.
      find ub.goods no-lock where
           ub.goods.gds-code = base-bar-code.gds-code.
      find ub.gds-prt no-lock where
           ub.gds-prt.node-code = base-bar-code.node-code.
      ii_ :
      do ii = 1 to v-barcodes:iCounter:
        v-barcodes:Get(ii) .
        v-barcode = cast (v-barcodes:SubjectObjCurr, goods_barcode).  
        v-barcode-list = v-barcode-list + v-barcode:bcode + "," .
        find first ub.prod-bc exclusive-lock where ub.prod-bc.b-str = v-barcode:bcode no-error.
        if not available ub.prod-bc
        then do :
            v-bc-mode = {&add-def} .
        end.
        else do :
            find first ub.bar-code no-lock where ub.bar-code.b-code = ub.prod-bc.b-code no-error .
            if not available ub.bar-code
            then do :
                undo, return error
                ("Ошибка при определении баркода для собственного кода " +
                 v-barcode:bcode + " . Товар " + p-GdsObj:code_) .
            end.
            else do :
              if ub.bar-code.gds-code = integer(p-GdsObj:code_)
              then do :
                  ub.prod-bc.bc-on = true .
                  next ii_ .
              end. 
              else do :
                  undo, return error
                  ("Уже есть собственный код " + v-barcode:bcode + 
                   " и он пренадлежит другому товару - " + string(ub.bar-code.gds-code)) .
              end.
            end.
            v-bc-mode = {&update} .
        end.
        if ub.goods.unit-base <> v-barcode:unit-code and v-bc-mode = {&add-def}
        then do :
            find first ub.bar-code where ub.bar-code.gds-code = integer(p-GdsObj:code_)
                                     and ub.bar-code.unit-cli = v-barcode:unit-code 
                                     no-error.
            if not available ub.bar-code
            then do :                         
                run ref/barcode1.p (
                                     input v-bc-mode 
                                    ,input yes /*p-silent*/
                                    ,input ""
                                    ,input ub.goods.gds-code
                                    ,input ub.gds-prt.node-code
                                    ,input base-bar-code.part-code
                                    ,input base-bar-code.in-code
                                    ,input v-barcode:unit-code
                                    ,input v-barcode:coeff
                                    ,output v-bc-rid) no-error.
                if error-status :error
                then do :
                    v-err-mess = substitute("Ошибка при сохранении бар-кода &1&2&3&2&4"
                                        , v-barcode:bcode
                                        , {&new-line}
                                        , error-status:get-message(1)
                                        , return-value ).
                    undo, return error v-err-mess .
                end.
                find first ub.bar-code where recid(ub.bar-code) = v-bc-rid.
                if send-ref
                then do:
                  run str/diallog.w
                    (input  parparentproc
                    ,input  this-procedure
                    ,input  'str/send-bc.p':U
                    ,input  string(recid(ub.bar-code)) + {&delim-par} + 'U':U
                    ,input  yes /* p-auto-go */
                    ,input  '':U
                    ,input  "Пересылка бар-кода на кассы"
                    ) .
                end.
            end.    
            v-b-str = v-barcode:bcode .
            run trg/prod-bc1.p (
                                 input  parparentproc
                                ,input yes /*p-silent*/
                                ,input ? /* dif-pdbc */
                                ,input ? /*pbc-veto*/
                                ,input send-ref
                                ,input if p-GdsObj:gds-type = "н" then {&loc-pt-code} else ""
                                ,input ""
                                ,buffer ub.goods
                                ,input ub.bar-code.b-code
                                ,input-output v-b-str
                                ,output v-rid-pbc
                                ) no-error.
            if error-status :error
            or v-rid-pbc = ? then do:
              v-err-mess = substitute("Ошибка при сохранении бар-кода &1&2&3&2&4"
                                    , v-barcode:bcode
                                    , {&new-line}
                                    , error-status:get-message(1)
                                    , return-value ).
                undo, return error v-err-mess .
            end.
            else do:
              find first buf_prod-bc no-lock
                    where recid(buf_prod-bc) = v-rid-pbc.
              if  buf_prod-bc.bc-on
              and send-ref
              then do:
                run str/diallog.w
                  (input parparentproc
                  ,input this-procedure
                  ,input 'str/s-prodbc.p':U
                  ,input string(v-rid-pbc) + {&delim-par} + "U":U
                  ,input yes /*p-auto-go*/
                  ,input '':U
                  ,input "Пересылка ДопБК на кассы"
                  ) .
              end.
            end.
        end.
        if ub.goods.unit-base = v-barcode:unit-code
        then do :
            v-b-str = v-barcode:bcode .
            run trg/prod-bc1.p (
                                 input  parparentproc
                                ,input yes /*p-silent*/
                                ,input ? /* dif-pdbc */
                                ,input ? /*pbc-veto*/
                                ,input send-ref
                                ,input if p-GdsObj:gds-type = "н" then {&loc-pt-code} else ""
                                ,input ""
                                ,buffer ub.goods
                                ,input base-bar-code.b-code
                                ,input-output v-b-str
                                ,output v-rid-pbc
                                ) no-error.
            if error-status :error
            or v-rid-pbc = ? then do:
              v-err-mess = substitute("Ошибка при сохранении бар-кода &1&2&3&2&4"
                                    , v-barcode:bcode
                                    , {&new-line}
                                    , error-status:get-message(1)
                                    , return-value ).
                undo, return error v-err-mess .
            end.
            else do:
              find first buf_prod-bc no-lock
                    where recid(buf_prod-bc) = v-rid-pbc.
              if  buf_prod-bc.bc-on
              and send-ref
              then do:
                run str/diallog.w
                  (input parparentproc
                  ,input this-procedure
                  ,input 'str/s-prodbc.p':U
                  ,input string(v-rid-pbc) + {&delim-par} + "U":U
                  ,input yes /*p-auto-go*/
                  ,input '':U
                  ,input "Пересылка ДопБК на кассы"
                  ) .
              end.
            end.
        end.
      end.
  end.
  
  for each buf_bar-code no-lock where buf_bar-code.gds-code = integer(p-GdsObj:code_),
    each buf_prod-bc exclusive-lock where buf_prod-bc.b-code = buf_bar-code.b-code :
     if lookup( buf_prod-bc.b-str, v-barcode-list ) = 0
     then do :
       buf_prod-bc.bc-on = false .  
     end.
  end.
  
  if p-GdsObj:enbl-zc = 1
  then do :
    RUN gds-attr-write (v-nbc, {&attr-null-price}, "yes").  
  end.
  else if p-GdsObj:enbl-zc = 0
  then do :
    RUN gds-attr-delete (v-nbc, {&attr-null-price}, output v-attr-del).     
  end.
  
  if p-GdsObj:calories <> ?
  and p-GdsObj:calories <> 0
  then do :
    RUN gds-attr-write (v-nbc, {&attr-calories}, string(p-GdsObj:calories)).  
  end.
  else do :
    RUN gds-attr-delete (v-nbc, {&attr-calories}, output v-attr-del).     
  end.
  
  if p-GdsObj:carbohydrates <> ?
  and p-GdsObj:carbohydrates <> 0
  then do :
    RUN gds-attr-write (v-nbc, {&attr-carbohydrate}, string(p-GdsObj:carbohydrates)).  
  end.
  else do :
    RUN gds-attr-delete (v-nbc, {&attr-carbohydrate}, output v-attr-del).     
  end.
  
  if p-GdsObj:fats <> ?
  and p-GdsObj:fats <> 0
  then do :
    RUN gds-attr-write (v-nbc, {&attr-fat}, string(p-GdsObj:fats)).  
  end.
  else do :
    RUN gds-attr-delete (v-nbc, {&attr-fat}, output v-attr-del).     
  end.
  
  if p-GdsObj:proteins <> ?
  and p-GdsObj:proteins <> 0
  then do :
    RUN gds-attr-write (v-nbc, {&attr-protein}, string(p-GdsObj:proteins)).  
  end.
  else do :
    RUN gds-attr-delete (v-nbc, {&attr-protein}, output v-attr-del).     
  end.
  
  if p-GdsObj:pay-trk = 1
  then do :
    RUN gds-attr-write (v-nbc, {&attr-ptrl-as-good}, "yes").  
  end.
  else if p-GdsObj:pay-trk = 0
  then do :
    RUN gds-attr-delete (v-nbc, {&attr-ptrl-as-good}, output v-attr-del).     
  end.
  
  if p-GdsObj:min-dnsty <> ? and p-GdsObj:min-dnsty <> 0
  and p-GdsObj:max-dnsty <> ? and p-GdsObj:max-dnsty <> 0
  then do :
    RUN gds-attr-write (v-nbc, {&attr-gds-ptrl-densities}, (string(p-GdsObj:min-dnsty) + "-" + string(p-GdsObj:max-dnsty))).  
  end.
  else do :
    RUN gds-attr-delete (v-nbc, {&attr-gds-ptrl-densities}, output v-attr-del).     
  end.
  
  if p-GdsObj:neu-l <> ?
  or p-GdsObj:neu-z <> ?
  then do :
    if p-GdsObj:neu-l = ? then v-neu-l = 0 . else v-neu-l = p-GdsObj:neu-l .
    if p-GdsObj:neu-z = ? then v-neu-z = 0 . else v-neu-z = p-GdsObj:neu-z .
    RUN gdsoattr-write (v-nbc,
                        {&shop},
                        ub.clients.obj-code,
                        {&attr-normal-wastage-o},
                        (string(v-neu-l, "->>>>9.999") + ";" + string(v-neu-z, "->>>>9.999"))
                        ).  
  end.
  else do :
    RUN gdsoattr-delete (v-nbc, {&shop}, ub.clients.obj-code, {&attr-normal-wastage-o}, output v-attr-del).     
  end.
  
  
  procedure mainmenu_getcntxt :
    define output parameter v-cntxt-db-num        as integer   no-undo . /* текущая БД            */   
    define output parameter v-cntxt-userid        as character no-undo . /* текущий пользователь  */   
    define output parameter v-cntxt-level         as character no-undo . /* уровень контекста     */   
    define output parameter v-cntxt-host-code-obj as integer   no-undo . /* текущая фирма         */   
    define output parameter v-cntxt-obj-type      as character no-undo . /* тип текущего объекта  */   
    define output parameter v-cntxt-obj-code      as integer   no-undo . /* код текущего объекта  */   
    define output parameter v-cntxt-db-num-obj    as integer   no-undo . /* база текущего объекта */   
    define output parameter v-cntxt-is-admin      as logical   no-undo . /* база текущего объекта */  
    
    run  get-db-num (output v-cntxt-db-num ) no-error .
    v-cntxt-userid = g#userid .
    v-cntxt-level = ? .
    v-cntxt-host-code-obj = ub.clients.host-code .
    v-cntxt-obj-type = ub.clients.obj-type .
    v-cntxt-obj-code = ub.clients.obj-code .
    v-cntxt-db-num-obj = ub.clients.db-num .
    v-cntxt-is-admin =  ? .
  end procedure .
  
  
