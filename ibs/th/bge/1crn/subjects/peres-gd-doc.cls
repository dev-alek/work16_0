/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт сообщения с накладаной в 1С ERPRN inv-gd-doc

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
using ibs.th.str.*.

block-level on error undo, throw.

class ibs.th.bge.1crn.subjects.peres-gd-doc implements iexpsubject:

  { cmp/str-glbl.i class }
  { str/lib-trn.i  class }
  { str/trdcalib.i class }
  
  define buffer bf_trn-doc         for ub.trn-doc.
  define buffer bf_doc-line        for ub.doc-line.
  define buffer bf_goods           for ub.goods.
  define buffer bf-plus_doc-line   for ub.doc-line.
  define buffer bf-plus_goods      for ub.goods.
  define buffer bf_parts           for ub.parts.
  define buffer bf-plus_parts      for ub.parts.
  define buffer bf_parts-root      for ub.parts-root.

  define temp-table tt-doc-line-cashe no-undo
  field doc-code  like ub.doc-line.doc-code
  field artic     like ub.doc-line.artic
  field prod-type like ub.doc-line.prod-type
  field prod-code like ub.doc-line.prod-code
  field qnty      as   decimal
  field sum-rubl  as   decimal
  field sum-base  as   decimal
  field vat-rubl  as   decimal
  field vat-base  as   decimal
  index pi is unique primary doc-code artic prod-type prod-code.
  
  define temp-table tt-doc-line-cashe-plus no-undo
  field doc-code     like ub.doc-line.doc-code
  field wf-artic     like ub.doc-line.artic
  field wf-prod-type like ub.doc-line.prod-type
  field wf-prod-code like ub.doc-line.prod-code
  field artic     like ub.doc-line.artic
  field prod-type like ub.doc-line.prod-type
  field prod-code like ub.doc-line.prod-code
  field qnty               as decimal
  field sum-rubl           as decimal
  field sum-base           as decimal
  field vat-rubl           as decimal
  field vat-base           as decimal
  FIELD write-off-qnty     AS DECIMAL
  FIELD write-off-sum-rubl AS DECIMAL
  FIELD write-off-sum-base AS DECIMAL
  index pi is unique primary doc-code wf-artic wf-prod-type wf-prod-code artic prod-type prod-code.
  
  define temp-table tt-clcparts no-undo like ub.parts
  field part-cur-base like ub.gds-dtl.price-base
  field part-cur-road-tax like ub.gds-dtl.price-base
  field part-cur-excise like ub.gds-dtl.price-base
  .
  
define temp-table tt-allsum no-undo
field sum-type           as   character                /*тип сумм {&sum-general[-sign]}   - основна
                                                                  {&sum-repayment[-sign]} - выкуп
                                                                  {&sum-old-consignation[-sign]} - старая консигнаци
                                                                  {&sum-cons_acc[-sign]}  - консигнация покрывающая оплате поставщику
                                                                  {&sum-cons_benf[-sign]} - консигнация по выгоде (с нее мы платим НДС государству)
                                                                  {&sum-resp_stor[-sign]} - ответственное хранение
                                                                  {&sum-office[-sign]}    - услуги */
field fact-qnty             as decimal /*фактическое количество*/
field cli-qnty              as decimal /*кол-во поставщика*/
field sum-dsc-base-doc      as decimal /*цены документа*/
field sum-dsc-rubl-doc      as decimal
field dsc-base-doc          as decimal
field dsc-rubl-doc          as decimal
field vat-base-doc          as decimal
field vat-rubl-doc          as decimal
field vat-base-buyer-doc    as decimal
field vat-rubl-buyer-doc    as decimal
field slt-base-doc          as decimal
field slt-rubl-doc          as decimal
field road-tax-base-doc     as decimal
field road-tax-rubl-doc     as decimal
field excise-base-doc       as decimal
field excise-rubl-doc       as decimal

field sum-dsc-base-acc      as decimal /*учетные цена*/
field sum-dsc-rubl-acc      as decimal
field sum-dsc-cli-acc       as decimal
field dsc-base-acc          as decimal
field dsc-rubl-acc          as decimal
field dsc-cli-acc           as decimal
field vat-base-acc          as decimal
field vat-rubl-acc          as decimal
field vat-cli-acc           as decimal
field slt-base-acc          as decimal
field slt-rubl-acc          as decimal
field slt-cli-acc           as decimal
field road-tax-base-acc     as decimal
field road-tax-rubl-acc     as decimal
field road-tax-cli-acc      as decimal
field excise-base-acc       as decimal
field excise-rubl-acc       as decimal
field excise-cli-acc        as decimal
field transport-base-acc    as decimal
field transport-rubl-acc    as decimal
field transport-cli-acc     as decimal
field other-base-acc        as decimal
field other-rubl-acc        as decimal
field other-cli-acc         as decimal
field sum-dsc-base-cur      as decimal /*текущие цены*/
field sum-dsc-rubl-cur      as decimal
field dsc-base-cur          as decimal
field dsc-rubl-cur          as decimal
field vat-base-cur          as decimal
field vat-rubl-cur          as decimal
field vat-base-buyer-cur    as decimal
field vat-rubl-buyer-cur    as decimal
field slt-base-cur          as decimal
field slt-rubl-cur          as decimal
field road-tax-base-cur     as decimal
field road-tax-rubl-cur     as decimal
field excise-base-cur       as decimal
field excise-rubl-cur       as decimal

index sum-type is primary unique sum-type.

  define property Msg as character no-undo
    get:
      return trim (Msg, {&new-line}).
    end.
    private set (inArg as char):
      Msg = Msg + {&new-line} + inArg.
    end.
    
  define property InitSecTag as character no-undo init "peres-gd-docs"
    get.

  define property DocCode as character no-undo
    get.
    set.
  
  define variable sw               as handle    no-undo.
  define variable isDel            as logical   no-undo.
  define variable varinvclcwt      as logical   no-undo.
  define variable varinvclcas      as logical   no-undo.
  define variable varinvclcex      as logical   no-undo.
  define variable varinvclcms      as logical   no-undo.
  define variable varinvclcbef     as logical   no-undo.
  define variable prtvalue         as character no-undo.
  define variable varinvclcspvalue as character no-undo.
  define variable varr-b           as character no-undo.
  define variable is-cdinv         as character no-undo .
  define variable clcprtsl-hndl    as handle    no-undo .

  method public void CrContentToSW (insw as handle):
    
    sw = insw.
    
    find first bf_trn-doc no-lock where bf_trn-doc.doc-code = DocCode no-error.
    if not available (bf_trn-doc)
      then return.
    isDel = false.
    run str/clcprtsl.p persistent (output clcprtsl-hndl).
    StartDocInv().
    GdsLine().
    EndDocInv().
    delete procedure clcprtsl-hndl.
    
  end.


  method private void GdsLine ():
    
    
    
    for each bf_doc-line 
      where bf_doc-line.doc-code = DocCode no-lock,
      first bf_goods where bf_goods.artic = bf_doc-line.artic     
      and bf_goods.prod-type = bf_doc-line.prod-type 
      and bf_goods.prod-code = bf_doc-line.prod-code no-lock,
      first bf_parts where bf_parts.out-code  = bf_doc-line.doc-code  
      and bf_parts.obj-type  = bf_doc-line.obj-type  
      and bf_parts.obj-code  = bf_doc-line.obj-code  
      and bf_parts.artic = bf_doc-line.artic     
      and bf_parts.prod-type = bf_doc-line.prod-type 
      and bf_parts.prod-code = bf_doc-line.prod-code
      and bf_parts.fact-qnty < 0 no-lock:
        
      sw:start-element ("gds").        
      for each bf-plus_doc-line 
        where bf-plus_doc-line.doc-code = DocCode no-lock,
        first bf-plus_goods where bf-plus_goods.artic = bf-plus_doc-line.artic     
        and bf-plus_goods.prod-type = bf-plus_doc-line.prod-type 
        and bf-plus_goods.prod-code = bf-plus_doc-line.prod-code no-lock,
        first bf_parts-root where bf_parts-root.doc-code = bf-plus_doc-line.doc-code
        and bf_parts-root.gds-code = bf-plus_goods.gds-code    
        and bf_parts-root.orig-gds-code = bf_goods.gds-code no-lock:
        sw:start-element ("gd").
          write-data-element ("gd-code-from", string-mth (bf_goods.gds-code)).
          write-data-element ("gd-code-to", string-mth (bf-plus_goods.gds-code)).
          write-data-element ("qnty", string-mth (round (bf-plus_doc-line.fact-qnty, 3))).
          write-data-element ("sum-from", string-mth (round (get-write-off-sum-rubl (buffer bf_doc-line), 3))).
          write-data-element ("sum-to", string-mth (round (get-income-sum-rbl (buffer bf_doc-line, buffer bf-plus_doc-line ), 3))).
        sw:end-element ("gd").
      end.
      sw:end-element ("gds").
    end.
        
  end.

  
  method private void StartDocInv ():
      sw:start-element ("peres-gd-doc") .
        write-data-element ("doc-code", bf_trn-doc.doc-code).
        write-data-element ("doc-num", bf_trn-doc.doc-code).
        write-data-element ("del-f", string (isDel, "1/0") ).
        write-data-element ("doc-date", if bf_trn-doc.doc-date = ? then "" else iso-date (datetime (bf_trn-doc.doc-date, bf_trn-doc.sys-time-int))).
        write-data-element ("fact-date", if bf_trn-doc.fact-date = ? then "" else iso-date (date (bf_trn-doc.fact-date))).
        write-data-element ("shift-date", if bf_trn-doc.shift-date = ? then "" else iso-date (date (bf_trn-doc.shift-date))).
        write-data-element ("shift-num", if bf_trn-doc.shift-num = ? then "0" else string-mth (bf_trn-doc.shift-num)).
  end.

  method private void EndDocInv ():
    
    sw:end-element ("peres-gd-doc") .
/*    sw:end-element ("peres-gd-docs") .*/
    
  end.

  method private void write-data-element (inTag as char, inValue as char):
    
    if inValue = ?
    then do:
      Msg = substitute ('Предупреждение отладки: тег &1 иммет неопределнное значение. Работа будет продолжена...', inTag).
    end.

    if inTag = ?
    then do:
      Msg = substitute ('Предупреждение отладки: Имя тега не может быть пустым...').
      return.
    end.

    inTag = lc (InTag).

    if inValue = ?
      then sw:write-empty-element (inTag).
      else sw:write-data-element (inTag, inValue).
  
  end.

  method private character string-mth (inValue as integer):
    
    def var v-str as character no-undo.
    
    if inValue = ?
      then v-str = "0".
      else v-str = string (inValue). 
    
    return v-str.
    
  end.

  method private character string-mth (inValue as decimal):
    
    def var v-str as character no-undo.
    
    if inValue = ?
      then v-str = "0".
    
    if string (inValue) begins "."
      then v-str = "0" + string (inValue).
      else v-str = string (inValue).
    return v-str.
    
  end.

  method private decimal get-write-off-sum-rubl ( buffer local-doc-line for ub.doc-line ) :
      FIND FIRST tt-doc-line-cashe WHERE tt-doc-line-cashe.doc-code  = local-doc-line.doc-code  AND
                                         tt-doc-line-cashe.artic     = local-doc-line.artic     AND
                                         tt-doc-line-cashe.prod-type = local-doc-line.prod-type AND
                                         tt-doc-line-cashe.prod-code = local-doc-line.prod-code NO-ERROR.
      IF NOT AVAILABLE tt-doc-line-cashe THEN DO:
        proc-get-write-off (BUFFER local-doc-line).
        FIND FIRST tt-doc-line-cashe WHERE tt-doc-line-cashe.doc-code  = local-doc-line.doc-code  AND
                                           tt-doc-line-cashe.artic     = local-doc-line.artic     AND
                                           tt-doc-line-cashe.prod-type = local-doc-line.prod-type AND
                                           tt-doc-line-cashe.prod-code = local-doc-line.prod-code .
      END.
      RETURN tt-doc-line-cashe.sum-rubl.
      
  end.
  
  method private decimal get-income-sum-rbl ( BUFFER local-doc-line FOR ub.doc-line, BUFFER local-doc-line-plus FOR ub.doc-line  ) :
     FIND FIRST tt-doc-line-cashe-plus WHERE tt-doc-line-cashe-plus.doc-code     = local-doc-line.doc-code       AND
                                             tt-doc-line-cashe-plus.wf-artic     = local-doc-line.artic          AND
                                             tt-doc-line-cashe-plus.wf-prod-type = local-doc-line.prod-type      AND
                                             tt-doc-line-cashe-plus.wf-prod-code = local-doc-line.prod-code      and
                                             tt-doc-line-cashe-plus.artic        = local-doc-line-plus.artic     AND
                                             tt-doc-line-cashe-plus.prod-type    = local-doc-line-plus.prod-type AND
                                             tt-doc-line-cashe-plus.prod-code    = local-doc-line-plus.prod-code NO-ERROR.
     IF NOT AVAILABLE tt-doc-line-cashe-plus THEN DO:
       proc-get-write-off (BUFFER local-doc-line).
       FIND FIRST tt-doc-line-cashe-plus WHERE tt-doc-line-cashe-plus.doc-code     = local-doc-line.doc-code       AND
                                               tt-doc-line-cashe-plus.wf-artic     = local-doc-line.artic          AND
                                               tt-doc-line-cashe-plus.wf-prod-type = local-doc-line.prod-type      AND
                                               tt-doc-line-cashe-plus.wf-prod-code = local-doc-line.prod-code      and
                                               tt-doc-line-cashe-plus.artic        = local-doc-line-plus.artic     AND
                                               tt-doc-line-cashe-plus.prod-type    = local-doc-line-plus.prod-type AND
                                               tt-doc-line-cashe-plus.prod-code    = local-doc-line-plus.prod-code .
     END.
     RETURN tt-doc-line-cashe-plus.sum-rubl.
  end.
  
  method private void proc-get-write-off ( buffer bf-loc_doc-line for ub.doc-line ) :
    
    DEFINE BUFFER bf-loc-plus_doc-line FOR ub.doc-line.
    DEFINE BUFFER bf-loc_parts         FOR ub.parts.
    DEFINE BUFFER bf-loc_parts-root    FOR ub.parts-root.
    DEFINE BUFFER bf-loc-plus_parts    FOR ub.parts.
    DEFINE BUFFER bf-loc_goods         FOR ub.goods.
    DEFINE BUFFER bf-loc-plus_goods    FOR ub.goods.
    DEFINE VARIABLE varprice-rubl-parts AS DECIMAL NO-UNDO.
    DEFINE VARIABLE varprice-base-parts AS DECIMAL NO-UNDO.
    FIND FIRST bf-loc_goods WHERE bf-loc_goods.artic     = bf-loc_doc-line.artic     AND
                                  bf-loc_goods.prod-type = bf-loc_doc-line.prod-type AND
                                  bf-loc_goods.prod-code = bf-loc_doc-line.prod-code NO-LOCK.
    FIND FIRST tt-doc-line-cashe WHERE tt-doc-line-cashe.doc-code  = bf-loc_doc-line.doc-code  AND
                                       tt-doc-line-cashe.artic     = bf-loc_doc-line.artic     AND
                                       tt-doc-line-cashe.prod-type = bf-loc_doc-line.prod-type AND
                                       tt-doc-line-cashe.prod-code = bf-loc_doc-line.prod-code NO-ERROR.
    IF NOT AVAILABLE tt-doc-line-cashe THEN DO:
      CREATE tt-doc-line-cashe.
      ASSIGN
        tt-doc-line-cashe.doc-code  = bf-loc_doc-line.doc-code
        tt-doc-line-cashe.artic     = bf-loc_doc-line.artic
        tt-doc-line-cashe.prod-type = bf-loc_doc-line.prod-type
        tt-doc-line-cashe.prod-code = bf-loc_doc-line.prod-code .
    END.
    ELSE DO:
      ASSIGN
        tt-doc-line-cashe.qnty     = 0.00
        tt-doc-line-cashe.sum-rubl = 0.00
        tt-doc-line-cashe.sum-base = 0.00
        tt-doc-line-cashe.vat-rubl = 0.00
        tt-doc-line-cashe.vat-base = 0.00.
      FOR EACH tt-doc-line-cashe-plus WHERE tt-doc-line-cashe-plus.doc-code     = tt-doc-line-cashe.doc-code  AND
                                            tt-doc-line-cashe-plus.wf-artic     = tt-doc-line-cashe.artic     AND
                                            tt-doc-line-cashe-plus.wf-prod-type = tt-doc-line-cashe.prod-type AND
                                            tt-doc-line-cashe-plus.wf-prod-code = tt-doc-line-cashe.prod-code :
        DELETE tt-doc-line-cashe-plus.
      END.
    END.
    FOR EACH bf-loc_parts WHERE bf-loc_parts.out-code  = bf-loc_doc-line.doc-code  AND
                                bf-loc_parts.obj-type  = bf-loc_doc-line.obj-type  AND
                                bf-loc_parts.obj-code  = bf-loc_doc-line.obj-code  AND
                                bf-loc_parts.artic     = bf-loc_doc-line.artic     AND
                                bf-loc_parts.prod-type = bf-loc_doc-line.prod-type AND
                                bf-loc_parts.prod-code = bf-loc_doc-line.prod-code AND
                                bf-loc_parts.fact-qnty < 0 NO-LOCK :
      FOR EACH tt-clcparts :
        DELETE tt-clcparts.
      END.
      CREATE tt-clcparts.
      BUFFER-COPY bf-loc_parts TO tt-clcparts.
      run clcprtsl_calc-parts-inkaps in clcprtsl-hndl (
                                      input-output table tt-clcparts
                                    , input-output table tt-allsum
                                    , input yes
                                    , input no
                                    , input bf-loc_doc-line.road-tax     /* parroad-tax      */
                                    , input bf-loc_doc-line.excise       /* parexcise        */
                                    , input bf-loc_doc-line.VAT-pc       /* parvat-pc        */
                                    , input bf-loc_doc-line.cons-vat-pc  /* parcons-vat-pc   */
                                    , input bf-loc_doc-line.SLT-pc       /* parslt-pc        */
                                    , input bf_trn-doc.base-rate         /* parbase-rate     */
                                    , input bf_trn-doc.base-scale        /* parbase-scale    */
                                    , input "":U                         /* parr-b           */
                                    , input 0.0                          /* parcur-base      */
                                    , input 0.0                          /* parcurroad-tax   */
                                    , input 0.0                          /* parcurexcise     */
                                    , input 0.0                          /* parcurvat-pc     */
                                    , input 0.0                          /* parcurcons-vat-pc*/
                                    , input 0.0                          /* parcurslt-pc     */
                                ).
      FIND FIRST tt-allsum WHERE tt-allsum.sum-type = {&sum-general} NO-ERROR.
      if available tt-allsum then do:
        ASSIGN
          tt-doc-line-cashe.qnty     = tt-doc-line-cashe.qnty     - tt-allsum.fact-qnty
          tt-doc-line-cashe.sum-rubl = tt-doc-line-cashe.sum-rubl - tt-allsum.sum-dsc-rubl-doc
          tt-doc-line-cashe.sum-base = tt-doc-line-cashe.sum-base - tt-allsum.sum-dsc-base-doc
          tt-doc-line-cashe.vat-rubl = tt-doc-line-cashe.vat-rubl - tt-allsum.vat-rubl-doc
          tt-doc-line-cashe.vat-base = tt-doc-line-cashe.vat-base - tt-allsum.vat-base-doc.
        ASSIGN
          varprice-rubl-parts = tt-allsum.sum-dsc-rubl-doc / tt-allsum.fact-qnty
          varprice-base-parts = tt-allsum.sum-dsc-base-doc / tt-allsum.fact-qnty.
        FOR EACH bf-loc_parts-root WHERE bf-loc_parts-root.doc-code       = bf-loc_parts.out-code   AND
                                         bf-loc_parts-root.orig-in-code   = bf-loc_parts.in-code    AND
                                         bf-loc_parts-root.orig-gds-code  = bf-loc_goods.gds-code   AND
                                         bf-loc_parts-root.orig-part-code = bf-loc_parts.part-code  NO-LOCK :
          FIND FIRST bf-loc-plus_goods WHERE bf-loc-plus_goods.gds-code  = bf-loc_parts-root.gds-code NO-LOCK.
          FIND FIRST bf-loc-plus_parts WHERE bf-loc-plus_parts.obj-type  = bf-loc_doc-line.obj-type    AND
                                             bf-loc-plus_parts.obj-code  = bf-loc_doc-line.obj-code    AND
                                             bf-loc-plus_parts.artic     = bf-loc-plus_goods.artic     AND
                                             bf-loc-plus_parts.prod-type = bf-loc-plus_goods.prod-type AND
                                             bf-loc-plus_parts.prod-code = bf-loc-plus_goods.prod-code AND
                                             bf-loc-plus_parts.in-code   = bf-loc_parts-root.in-code   AND
                                             bf-loc-plus_parts.out-code  = bf-loc_doc-line.doc-code    AND
                                             bf-loc-plus_parts.part-code = bf-loc_parts-root.part-code NO-LOCK.
          FIND FIRST bf-loc-plus_doc-line WHERE bf-loc-plus_doc-line.doc-code  = bf-loc-plus_parts.out-code  AND
                                                bf-loc-plus_doc-line.artic     = bf-loc-plus_parts.artic     AND
                                                bf-loc-plus_doc-line.prod-type = bf-loc-plus_parts.prod-type AND
                                                bf-loc-plus_doc-line.prod-code = bf-loc-plus_parts.prod-code .
          FIND FIRST tt-doc-line-cashe-plus WHERE tt-doc-line-cashe-plus.doc-code     = tt-doc-line-cashe.doc-code  AND
                                                  tt-doc-line-cashe-plus.wf-artic     = tt-doc-line-cashe.artic     AND
                                                  tt-doc-line-cashe-plus.wf-prod-type = tt-doc-line-cashe.prod-type AND
                                                  tt-doc-line-cashe-plus.wf-prod-code = tt-doc-line-cashe.prod-code AND
                                                  tt-doc-line-cashe-plus.artic        = bf-loc-plus_goods.artic      AND
                                                  tt-doc-line-cashe-plus.prod-type    = bf-loc-plus_goods.prod-type  AND
                                                  tt-doc-line-cashe-plus.prod-code    = bf-loc-plus_goods.prod-code  NO-ERROR.
          IF NOT AVAILABLE tt-doc-line-cashe-plus THEN DO:
            create tt-doc-line-cashe-plus.
            ASSIGN
              tt-doc-line-cashe-plus.doc-code     = tt-doc-line-cashe.doc-code
              tt-doc-line-cashe-plus.wf-artic     = tt-doc-line-cashe.artic
              tt-doc-line-cashe-plus.wf-prod-type = tt-doc-line-cashe.prod-type
              tt-doc-line-cashe-plus.wf-prod-code = tt-doc-line-cashe.prod-code
              tt-doc-line-cashe-plus.artic        = bf-loc-plus_goods.artic
              tt-doc-line-cashe-plus.prod-type    = bf-loc-plus_goods.prod-type
              tt-doc-line-cashe-plus.prod-code    = bf-loc-plus_goods.prod-code .
          END.
          FOR EACH tt-clcparts :
            DELETE tt-clcparts.
          END.
          CREATE tt-clcparts.
          BUFFER-COPY bf-loc-plus_parts TO tt-clcparts.
          run clcprtsl_calc-parts-inkaps in clcprtsl-hndl (
                                          input-output table tt-clcparts
                                        , input-output table tt-allsum
                                        , input yes
                                        , input no
                                        , input bf-loc-plus_doc-line.road-tax     /* parroad-tax      */
                                        , input bf-loc-plus_doc-line.excise       /* parexcise        */
                                        , input bf-loc-plus_doc-line.VAT-pc       /* parvat-pc        */
                                        , input bf-loc-plus_doc-line.cons-vat-pc  /* parcons-vat-pc   */
                                        , input bf-loc-plus_doc-line.SLT-pc       /* parslt-pc        */
                                        , input bf_trn-doc.base-rate              /* parbase-rate     */
                                        , input bf_trn-doc.base-scale             /* parbase-scale    */
                                        , input "":U                              /* parr-b           */
                                        , input 0.0                               /* parcur-base      */
                                        , input 0.0                               /* parcurroad-tax   */
                                        , input 0.0                               /* parcurexcise     */
                                        , input 0.0                               /* parcurvat-pc     */
                                        , input 0.0                               /* parcurcons-vat-pc*/
                                        , input 0.0                               /* parcurslt-pc     */
                                    ).
          FIND FIRST tt-allsum WHERE tt-allsum.sum-type = {&sum-general} NO-ERROR.
          find first tt-clcparts.
          if available tt-allsum then do:
            ASSIGN
              tt-doc-line-cashe-plus.qnty               = tt-doc-line-cashe-plus.qnty               + tt-allsum.fact-qnty
              tt-doc-line-cashe-plus.sum-rubl           = tt-doc-line-cashe-plus.sum-rubl           + tt-allsum.sum-dsc-rubl-doc
              tt-doc-line-cashe-plus.sum-base           = tt-doc-line-cashe-plus.sum-base           + tt-allsum.sum-dsc-base-doc
              tt-doc-line-cashe-plus.vat-rubl           = tt-doc-line-cashe-plus.vat-rubl           + tt-allsum.vat-rubl-doc
              tt-doc-line-cashe-plus.vat-base           = tt-doc-line-cashe-plus.vat-base           + tt-allsum.vat-base-doc
              tt-doc-line-cashe-plus.write-off-qnty     = tt-doc-line-cashe-plus.write-off-qnty     + tt-clcparts.real-qnty
              tt-doc-line-cashe-plus.write-off-sum-rubl = tt-doc-line-cashe-plus.write-off-sum-rubl + varprice-rubl-parts * tt-clcparts.real-qnty
              tt-doc-line-cashe-plus.write-off-sum-base = tt-doc-line-cashe-plus.write-off-sum-base + varprice-base-parts * tt-clcparts.real-qnty
            .
          END.
        END.
      END.
    END.
    
    
  end.
  
  

end class.
