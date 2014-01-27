/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Импорт накладных из временной таблицы

Автор: Чернова Светлана Александровна
Дата создания: 04/05/06
Author: Svetlana Chernova
Creation date: 04/05/06

*/

{ utl/tt516.i    }

&glob pt1_cost 'TSFCST':U
&glob pt2_sale 'TSFRET':U
&glob pt3_mpl  'TSFOPT':U
&glob pt4_rms  'TSFPRC':U

define input  parameter parparentproc as widget-handle no-undo .
define input  parameter p-log-handle  as handle no-undo .
define input  PARAMETER TABLE FOR  temp_trn-doc.
define input  PARAMETER TABLE FOR  temp_doc-line.
define output parameter p-ok-doc as integer   no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Импорт накладных из временной таблицы".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ str/lib-trn.i  }
{ cmp/df-sub.i   }
{ str/doc-code.i }
{ gbl/waitfram.i }
{ cmp/croslist.i }
{ gbl/clntattr.i }
{ cmp/strcodec.i }
{ str/lib-def.i  }
{ str/hvrdtax.i  }
{ str/lib-calc.i }
{ str/plgdsfnd.i }
{ cus/copyinqu.i }
{ gbl/getcntxt.i def }
{ str/getctxtp.i def }
{ utl/ora-icli.i }
{ trg/factord.i }
{ cmp/gds-list.i gds-list def "new shared" }
{ gbl/getsect.i def }
{ str/in-vatp.i def  }




define temp-table tt2-doc-line      no-undo like lib-trn_ret-line.
define temp-table anlz-bc no-undo
field b-c as integer
index pi b-c.

define variable v-end-message as character no-undo .

define variable v-cntxt-cash-pay as integer   no-undo .
define variable v-cntxt-in-ov as logical   no-undo .
define variable v-cntxt-base-code as integer   no-undo .
define variable v-cntxt-rsrv-time  as integer   no-undo .
define variable v-cntxt-load-time  as integer   no-undo .
define variable v-cntxt-holidays  as character no-undo .

define variable v-ext-doc-type as character no-undo .
define variable v-specif as logical   no-undo .


define buffer new_trn-doc  for ub.trn-doc  .
define buffer new_doc-line for ub.doc-line .
define buffer new_gds-dtl  for ub.gds-dtl .

define buffer t_trn-doc  for ub.trn-doc  .
define buffer t_doc-line for ub.doc-line .
define buffer t_gds-dtl  for ub.gds-dtl .
define buffer buf_goods  for ub.goods .
define buffer buf_contract for ub.contract  .

define variable parrec-doc      as recid    no-undo .
define variable parrecalc-price as logical  no-undo init false .
define variable parhandle       as handle   no-undo .
define variable v-root-node     as integer  no-undo .
define variable par-doc-code as character no-undo .

define variable p-type             as character no-undo .
define variable v-stroka-protocol  as character no-undo .
define variable v-protocol-date    as date      no-undo .
define variable v-protocol-time    as integer   no-undo .
define variable v-logical          as logical   no-undo .
define variable n-d as character no-undo .
define variable v-ret-supp as logical   no-undo .
define variable v-doc-type as character no-undo .
define variable v-purch-code-ch as character no-undo .
define variable v-purch-code as integer   no-undo .
define variable v-purch-code-name as character no-undo .
define variable v-discnt-type  as character no-undo .
define variable v-status_     as character no-undo .
define variable v-print-rubl as logical   no-undo .
define variable v-curr-r-b as character no-undo .
define variable vt-host-code as integer   no-undo .
define variable vt-obj-type as character no-undo .
define variable vt-obj-code      as integer   no-undo .
define variable line-rec as recid no-undo .
define buffer bufo_clients for ub.clients  .
define variable  k as integer   no-undo .
define variable v-str-txt as character no-undo .

 /*Для МПЛ*/
define variable v-fact-order as decimal   no-undo .
define variable v-plt-id as integer   no-undo .
define variable v-plt-db-num as integer   no-undo .
define variable v-pdf-id as integer   no-undo .
define variable v-pdf-db as integer   no-undo .
define variable v-sale-price-base as decimal   no-undo .
define variable v-sale-price-rubl as decimal   no-undo .
define variable v-road-tax-base as decimal   no-undo .
define variable v-road-tax-rubl as decimal   no-undo .
define variable v-excise-base as decimal   no-undo .
define variable v-excise-rubl as decimal   no-undo .
define variable v-main-b-code as integer   no-undo .



MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

   for each  temp_trn-doc :
       for each temp_doc-line where
                temp_doc-line.line-num = temp_trn-doc.line-num :
           if temp_doc-line.doc-code <> temp_trn-doc.doc-code then do:
              assign
                  v-end-message =  substitute("Не верно указан doc-code &1 &2  товар &3" ,
                  temp_doc-line.doc-code ,
                  temp_trn-doc.doc-code ,
                  temp_doc-line.gds-code
                  ).
              run pcall-log-file in p-log-handle (input v-end-message) .
              undo, return error v-end-message.
           end.
       end.
   end.

    run get-db-num in parparentproc (output v-cntxt-db-num ) .
    run get-userid in parparentproc (output v-cntxt-userid ) .

    { gbl/curr-r-b.i
      v-curr-r-b
    }
    if v-curr-r-b = {&r-b-base} then v-print-rubl = false .
    else v-print-rubl = true .

p-ok-doc = 0 .

for each  temp_trn-doc :
  run clear-tt .
  find first bufo_clients no-lock where
             bufo_clients.obj-type  = temp_trn-doc.obj-type  and
             bufo_clients.obj-code  = temp_trn-doc.obj-code  no-error .

      if error-status :error then do:
              assign
              v-end-message =  substitute(" Не найден объект &1 &2 &3 &4" , temp_trn-doc.obj-type , temp_trn-doc.obj-code , error-status :get-message(1) , return-value )
              .
              run pcall-log-file in p-log-handle (input v-end-message) .
              undo, return error v-end-message.
      end.

    { gbl/hostcode.i
      temp_trn-doc.obj-type
      temp_trn-doc.obj-code
      temp_trn-doc.host-code
      no-error }
      if error-status :error then do:
        assign
            v-end-message =  substitute("Не верно указан объект &1 &2 " ,
            temp_trn-doc.obj-type ,
            temp_trn-doc.obj-code ).

        run pcall-log-file in p-log-handle (input v-end-message) .
        undo, return error v-end-message.
      end.

      assign
        vt-host-code          = temp_trn-doc.host-code
        vt-obj-type           = temp_trn-doc.obj-type
        vt-obj-code           = temp_trn-doc.obj-code
        v-cntxt-host-code-obj = temp_trn-doc.host-code
        v-cntxt-obj-code      = temp_trn-doc.obj-code
        v-cntxt-obj-type      = temp_trn-doc.obj-type
        .
        if temp_trn-doc.vat-type = "" or
           temp_trn-doc.vat-type = ? then do:

      { gbl/getsect.i run v-cntxt-obj-type v-cntxt-obj-code {&attr-nakl_par} }

      for each thbjattr_thbj-attr :
        if thbjattr_thbj-attr.prop-code = 'type-vat' then v-value-integer = thbjattr_thbj-attr.property-value-integer.
      end.
          case v-value-integer:
          when 1 or when ? then do:
            assign
              temp_trn-doc.vat-type = {&inc-vat}.
          end.
          when 2 then do:
            assign
              temp_trn-doc.vat-type = {&no-vat}.
          end.
          when 3 then do:
            assign
              temp_trn-doc.vat-type = {&without-vat}.
          end.
          otherwise do:
              v-end-message =  substitute(" Не верно задан атрибут 'Тип заведения НДС' (type-vat). &1 &2 &3 &4 &5" , temp_trn-doc.obj-type , temp_trn-doc.obj-code , error-status :get-message(1) , return-value , v-value-integer ) .
              run pcall-log-file in p-log-handle (input v-end-message) .
              undo, return error v-end-message.
          end.
          end case.
      end.

    { gbl/curobjdt.i
      temp_trn-doc.obj-type
      temp_trn-doc.obj-code
      to-day
      no-error }

      if error-status :error then do:
              assign
              v-end-message =  substitute(" Ошибка &1 &2 &3 &4" , temp_trn-doc.obj-type , temp_trn-doc.obj-code , error-status :get-message(1) , return-value )
              .
              run pcall-log-file in p-log-handle (input v-end-message) .
              undo, return error v-end-message.
      end.

     if vt-host-code <>   v-cntxt-host-code-obj then do:
                  assign
                  v-end-message =  substitute(" Не верно указан код фирмы: &1 ( по объектам должен быть :&2) " , temp_trn-doc.host-code , v-cntxt-host-code-obj  )
                  .
                  run pcall-log-file in p-log-handle (input v-end-message) .
                  undo, return error v-end-message.
     end.

    find first buf_contract no-lock where
               temp_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh} and
               buf_contract.contract-code =  temp_trn-doc.cli-code and
               buf_contract.host-code     =  temp_trn-doc.host-code no-error .
   if not available  buf_contract then do:
      temp_trn-doc.contract-code =  0 .
   end.
   else do:
      temp_trn-doc.contract-code =  buf_contract.contract-code .
   end.
   v-specif = false .

   if temp_trn-doc.contract-code  > 0 then do:
      find first  ub.contract-specif no-lock where
                  ub.contract-specif.contract-num = temp_trn-doc.contract-code and
                  ub.contract-specif.host-code    = temp_trn-doc.host-code
                  no-error .
      if available ub.contract-specif then
      assign
        v-specif = true
        temp_trn-doc.vat-type = ub.contract-specif.VAT-type
      .

   end.


   if temp_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh} then do:
      if available buf_contract then do:
         if buf_contract.curr-code <> temp_trn-doc.exch-code then do:
                    v-end-message =  substitute("По договору &3   ожидалась валюта &1  пришла &2 " ,
                    buf_contract.curr-code,
                    temp_trn-doc.exch-code,
                    temp_trn-doc.contract-code ) .
                    run pcall-log-file in p-log-handle (input v-end-message) .
                    undo, return error v-end-message.
      end.
      end.
   end.


      run who-cli-ora in this-procedure (
          input  temp_trn-doc.cli-code ,
          output temp_trn-doc.cli-type ,
          output temp_trn-doc.cli-code
          ) no-error .
          if error-status :error then return error return-value .

/* *******************************88888   */
/*
            temp_trn-doc.wrkr         =  .
            temp_trn-doc.agnt         =  .
            temp_trn-doc.boss         =  .
            */

  /* Если не приход то все принимаем в национальной валюте */
  if temp_trn-doc.ext-doc-type <> {&TDEDT_Pri_Vnesh} then do:
     temp_trn-doc.exch-code = 0 .
     temp_trn-doc.exch-rate  = 1.
     temp_trn-doc.exch-scale = 1.
  end.

  if temp_trn-doc.exch-code = ? then do:
      assign
        temp_trn-doc.exch-code = 0
        temp_trn-doc.exch-rate  = 1
        temp_trn-doc.exch-scale = 1
      .
      v-end-message =  substitute("Предупреждение !!! Не верно введена валюта ПОСТВЩИКА код &1 , меняю на национальную " ,              temp_trn-doc.exch-code   ) .
      run pcall-log-file in p-log-handle (input v-end-message) .

  end.


  if temp_trn-doc.exch-rate  = 0 or
     temp_trn-doc.exch-rate  = ? then do:
          assign
            temp_trn-doc.exch-code = 0
            temp_trn-doc.exch-rate  = 1
            temp_trn-doc.exch-scale = 1
          .
      v-end-message =  substitute("Предупреждение !!! Не верно введен курс = &2 валюты ПОСТВЩИКА код &1 , меняю на национальную " ,              temp_trn-doc.exch-code , temp_trn-doc.exch-rate ) .
      run pcall-log-file in p-log-handle (input v-end-message) .

  end.
  if temp_trn-doc.exch-scale  = 0 or
     temp_trn-doc.exch-scale  = ? then do:
          assign
            temp_trn-doc.exch-code = 0
            temp_trn-doc.exch-rate  = 1
            temp_trn-doc.exch-scale = 1
          .
      v-end-message =  substitute("Предупреждение !!! Не верно введен масштаб = &2 валюты ПОСТВЩИКА код &1 , меняю на национальную " ,              temp_trn-doc.exch-code , temp_trn-doc.exch-scale ) .
      run pcall-log-file in p-log-handle (input v-end-message) .

  end.

    find first ub.currency where ub.currency.curr-code = temp_trn-doc.exch-code no-error .
    if error-status :error then do:
              v-end-message =  substitute("Нет валюты с кодом &1  (&2)" ,
              temp_trn-doc.exch-code , error-status :get-message(1)   ) .
            run pcall-log-file in p-log-handle (input v-end-message) .
            undo, return error v-end-message.
        end.


    { str/getctxtp.i get this-procedure }
    case temp_trn-doc.ext-doc-type :
      when {&TDEDT_Ras_Vnesh} then do:
       assign
          v-ext-doc-type = {&TDEDT_Ras_Vnesh}
          v-doc-type     = {&expense}
          v-ret-supp     = false
          v-discnt-type    = {&percent}
          v-status_        = {&inquiry}
          .
      end.
      when {&TDEDT_Pri_Vnesh} then do:
       assign
          v-ext-doc-type   = {&TDEDT_Pri_Vnesh}
          v-doc-type = {&income}
          v-ret-supp     = false
          v-status_ = {&wayb}
          v-discnt-type    = ""
          .
      end.
      when {&TDEDT_Vozvrat_Vnesh} then do:
       assign
          v-ext-doc-type   = {&TDEDT_Vozvrat_Vnesh}
          v-doc-type = {&return}
          v-ret-supp     = false
          v-status_ = {&wayb}
          v-discnt-type    = {&percent}
          .
      end.
      otherwise do:
          assign
          v-end-message =  substitute(" Не верный расширенный тип документа &1 &2 &3 &4" , temp_trn-doc.ext-doc-type , temp_trn-doc.obj-type , temp_trn-doc.obj-code , temp_trn-doc.doc-code )
          .
          run pcall-log-file in p-log-handle (input v-end-message) .
          undo, return error v-end-message.
      end.
    end case.


define buffer buf_sysconf for ub.sysconf  .
find first buf_sysconf where buf_sysconf.host-code = v-cntxt-host-code-obj no-lock no-error .
if error-status :error then do:
          assign
          v-end-message =  substitute(" Не верный расширенный тип документа &1 &2 &3 &4" , temp_trn-doc.ext-doc-type , temp_trn-doc.obj-type , temp_trn-doc.obj-code , temp_trn-doc.doc-code )
          .
          run pcall-log-file in p-log-handle (input v-end-message) .
          undo, return error v-end-message.
end.

assign
  v-cntxt-cash-pay   = buf_sysconf.cash-pay
  v-cntxt-base-code  = buf_sysconf.base-code
  v-cntxt-in-ov      = buf_sysconf.in-ov
  v-cntxt-rsrv-time  = buf_sysconf.rsrv-time
  v-cntxt-load-time  = buf_sysconf.load-time
  v-cntxt-holidays   = buf_sysconf.holidays
  v-cntxp-out-pay    = buf_sysconf.out-pay
.
{ str/getctxtp.i get this-procedure }

    run doc-code in this-procedure
      ( input  "main":U,
        input  temp_trn-doc.obj-type,
        input  temp_trn-doc.obj-code,
        input  ? ,
        output n-d ) no-error.

    if error-status:error then do:
      v-end-message =  "Ошибка при генерации номера документа. chip"  + return-value  + error-status :get-message(1) .
      run pcall-log-file in p-log-handle (input v-end-message) .
      undo, return error v-end-message.
    end.

    create  tt-trn-doc.
    buffer-copy  temp_trn-doc  to    tt-trn-doc
      assign
      tt-trn-doc.pay-code             = v-cntxp-out-pay
      tt-trn-doc.status_              = "temp"
      tt-trn-doc.doc-code             = n-d
      tt-trn-doc.doc-date             = to-day
      tt-trn-doc.doc-type             = v-doc-type
      tt-trn-doc.internal             = false
      tt-trn-doc.cr-db-num            = v-cntxt-db-num
      tt-trn-doc.vat-type             = temp_trn-doc.vat-type
      tt-trn-doc.slt-type             = {&without-slt}
      tt-trn-doc.office               = false
      tt-trn-doc.fact-num             = 0
      tt-trn-doc.out-code             = temp_trn-doc.doc-code
      tt-trn-doc.PS                   = substitute("&1 &2 &3 &5&4 ", temp_trn-doc.doc-code , string(temp_trn-doc.doc-date, "99/99/9999") , temp_trn-doc.creid ,temp_trn-doc.ps ,{&new-line} )
      tt-trn-doc.creid                = v-cntxt-userid
      tt-trn-doc.flag_                = false
      tt-trn-doc.ext-doc-type         = v-ext-doc-type
      tt-trn-doc.discnt-type          = v-discnt-type
      tt-trn-doc.ret-supp             = v-ret-supp
      tt-trn-doc.print-rubl           = v-print-rubl
      tt-trn-doc.hold-doc-code-child  = "no-hold":u
      tt-trn-doc.hold-doc-code-parent = "no-hold":u
    .
    { gbl/hostcode.i
      tt-trn-doc.obj-type
      tt-trn-doc.obj-code
      tt-trn-doc.host-code
      }

    { gbl/baserate.i
      tt-trn-doc.host-code
      tt-trn-doc.doc-date
      tt-trn-doc.base-rate
      tt-trn-doc.base-scale
      }
      /* coздание шапки в базе */
    if v-doc-type     = {&expense} then do:
      if tt-trn-doc.contract-code > 0 then do:
        find first buf_contract no-lock where
                   buf_contract.contract-code = tt-trn-doc.contract-code and
                   buf_contract.host-code     = tt-trn-doc.host-code no-error .

         if error-status :error then do:
            v-end-message =  substitute("Нет договора  фирма:&1 номер:&2  &3 &4" , tt-trn-doc.host-code , tt-trn-doc.contract-code , return-value , error-status :get-message(1)  ) .
            run pcall-log-file in p-log-handle ( input v-end-message ) .
            undo, return error v-end-message.
         end.

        { str/purchcon.i
          tt-trn-doc.host-code
          tt-trn-doc.contract-code
          v-purch-code-ch
          v-purch-code-name }

          v-purch-code = integer (v-purch-code-ch) .
        end.
        else do:
            if lookup (string(buf_sysconf.purch-code), {&purchase-input-codes}) = 0 then do:
               v-end-message =   substitute("Неверный код типа приобретения по умолчанию &1 _sysconf " ,buf_sysconf.purch-code ) .
               run pcall-log-file in p-log-handle ( input v-end-message ) .
               undo, return error v-end-message.
            end.
            v-purch-code = buf_sysconf.purch-code .
        end.

      if lookup (string(buf_sysconf.purch-code), {&purchase-input-codes}) = 0 then do:
               v-end-message =  "Неверный код типа приобретения по умолчанию. _sysconf".
               run pcall-log-file in p-log-handle ( input v-end-message ) .
               undo, return error v-end-message.
      end.
    end.

    { str/crtrndoc.i
      tt-trn-doc.acc-date
      tt-trn-doc.bge-date
      tt-trn-doc.base-rate
      tt-trn-doc.base-scale
      tt-trn-doc.cli-code
      tt-trn-doc.cli-type
      tt-trn-doc.cli-name
      tt-trn-doc.cr-db-num
      tt-trn-doc.creid
      tt-trn-doc.discnt-type
      tt-trn-doc.doc-code
      tt-trn-doc.doc-date
      tt-trn-doc.doc-type
      tt-trn-doc.flag_
      tt-trn-doc.host-code
      tt-trn-doc.internal
      tt-trn-doc.obj-code
      tt-trn-doc.obj-type
      tt-trn-doc.office
      tt-trn-doc.pay-code
      tt-trn-doc.ps
      tt-trn-doc.ret-supp
      tt-trn-doc.slt-type
      tt-trn-doc.status_
      tt-trn-doc.vat-type
      tt-trn-doc.ext-doc-type
      buf_sysconf.purch-code
      no-error }
      .
    if error-status :error then do:
        v-end-message =  substitute("Ошибка при создании шапки документа  &1 &2 &3" , temp_trn-doc.doc-code , return-value , error-status :get-message(1)  ) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.
    end.


    find first new_trn-doc where new_trn-doc.doc-code = n-d  exclusive-lock no-error .

    if not available new_trn-doc then do:
      v-end-message = substitute(" Ошибка &1" , error-status :get-message(1)  , return-value) .
      run pcall-log-file in p-log-handle ( input v-end-message ) .
      undo, return error v-end-message.
    end.

    assign
        new_trn-doc.contract-code  = tt-trn-doc.contract-code
        new_trn-doc.exch-rate  = tt-trn-doc.exch-rate
        new_trn-doc.exch-scale = tt-trn-doc.exch-scale
        new_trn-doc.exch-date  = to-day
        new_trn-doc.exch-code  = tt-trn-doc.exch-code
        new_trn-doc.status_    = v-status_
        new_trn-doc.flag_      = ( if v-ext-doc-type = {&TDEDT_Ras_Vnesh} then true else false )
        new_trn-doc.print-rubl = v-print-rubl
        new_trn-doc.hold-doc-code-child  = "no-hold":u
        new_trn-doc.hold-doc-code-parent = "no-hold":u
        new_trn-doc.agnt  = tt-trn-doc.agnt
        new_trn-doc.boss  = tt-trn-doc.boss
        new_trn-doc.wrkr  = tt-trn-doc.wrkr
        new_trn-doc.rcv-code = "not_delete"  /* нельзя будет открыть, чтоб потом изменить или удалить */
        parrec-doc = recid (new_trn-doc)
    .
  k = 0 .

  for each  temp_doc-line  no-lock  where
            temp_doc-line.doc-code = temp_trn-doc.doc-code by temp_doc-line.line-num :

       run ora-ver-goods (temp_doc-line.gds-code )  no-error .
        if error-status :error then do:
            v-end-message = return-value .
            run pcall-log-file in p-log-handle ( input v-end-message ) .
            undo, return error v-end-message.
        end.

      find first buf_goods where buf_goods.gds-code  = temp_doc-line.gds-code
                                 no-lock no-error .

      if error-status :error then do:
          v-end-message = substitute("Ошибка: нет товара &1 &2 &3 " , temp_doc-line.gds-code , error-status :get-message(1)  , return-value) .
          run pcall-log-file in p-log-handle ( input v-end-message ) .
          undo, return error v-end-message.
      end.

      temp_doc-line.artic     = buf_goods.artic .
      temp_doc-line.prod-type = buf_goods.prod-type .
      temp_doc-line.prod-code = buf_goods.prod-code .

      if v-specif = true and temp_trn-doc.ext-doc-type = {&TDEDT_Pri_Vnesh}  then do:
        find first ub.contract-specif no-lock where
                    ub.contract-specif.gds-code = buf_goods.gds-code and
                    ub.contract-specif.contract-num = temp_trn-doc.contract-code and
                    ub.contract-specif.host-code     = temp_trn-doc.host-code no-error .
        if not available ub.contract-specif then do:
          v-end-message =  substitute(" Товара &1 &2 нет в спецификации &3" ,
                            buf_goods.gds-code,
                            buf_goods.gds-name,
                            temp_trn-doc.contract-code ) .
          run pcall-log-file in p-log-handle (input v-end-message) .
          undo, return error v-end-message.
        end.
      end.

      assign
        temp_doc-line.artic      = buf_goods.artic
        temp_doc-line.prod-type  = buf_goods.prod-type
        temp_doc-line.prod-code  = buf_goods.prod-code
        .

    { gbl/gdsobjcr.i
      tt-trn-doc.obj-type
      tt-trn-doc.obj-code
      buf_goods.artic
      buf_goods.prod-type
      buf_goods.prod-code
      ub.gds-obj
      no-error }
  /* Если не приход то все принимаем в национальной валюте */
  if temp_trn-doc.ext-doc-type <> {&TDEDT_Pri_Vnesh} then do:
     temp_doc-line.price-cli  = temp_doc-line.price-rubl .
  end.
  v-str-txt = "" .

      if not available ub.gds-obj then do:
        find first ub.gds-obj no-lock where
              ub.gds-obj.obj-type = tt-trn-doc.obj-type and
              ub.gds-obj.obj-code = tt-trn-doc.obj-code and
              ub.gds-obj.gds-code = buf_goods.gds-code no-error .
              if not available ub.gds-obj then do:
                  v-end-message =  substitute("Товар &1 &2 &3  &4 &5" ,
                                    buf_goods.gds-code,
                                    buf_goods.artic,
                                    buf_goods.gds-name,
                                    error-status :get-message(1) ,
                                    return-value  ) .
                  run pcall-log-file in p-log-handle (input v-end-message) .
                  undo, return error v-end-message.
              end.
      end.

      if ub.gds-obj.inv-on = true then do:
            v-end-message =  substitute("Товар &1 &2 &3  Находиться в инвентаризации. Прием документов невозможен." ,
                              buf_goods.gds-code ,
                              buf_goods.artic ,
                              buf_goods.gds-name
                              ) .
            run pcall-log-file in p-log-handle (input v-end-message) .
            undo, return error v-end-message.
      end.

     if temp_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh} then do:
     case temp_trn-doc.price-type :
     when  {&pt4_rms} /* от rms */
     then do:
        v-str-txt = "Цена из RMS".
     end.
     when  {&pt1_cost} /* Учетная */
     then do:
       temp_doc-line.price-cli  = ub.gds-obj.avrg-rubl.
       v-str-txt = "Цена учетная".
     end.
     when  {&pt2_sale} /* Продажная переоценки */
     then do:
       temp_doc-line.price-cli  = ub.gds-obj.price-sale.
       v-str-txt = "Цена переоценки по объекту на момент создания".
     end.
     when  {&pt3_mpl} /* МПЛ */
     then do:
       run factord-end-day in this-procedure (input new_trn-doc.doc-date , output v-fact-order ).
       /* баркод по главному коду*/
       { gbl/gdsbcode.i buf_goods.gds-code ? v-main-b-code }
       /* узнаем цену не по переоценке а по МПЛ */
        run str/set-mppr.p (
           input  true
          ,input  new_trn-doc.cli-type
          ,input  new_trn-doc.cli-code
          ,input  v-main-b-code
          ,input  v-main-b-code
          ,input  new_trn-doc.obj-type
          ,input  new_trn-doc.obj-code
          ,input  temp_doc-line.fact-qnty
          ,input  0
          ,input  string(new_trn-doc.pay-code)
          ,input  ""
          ,input  v-fact-order
          ,output v-plt-id
          ,output v-plt-db-num
          ,output v-pdf-id
          ,output v-pdf-db
          ,output v-sale-price-base
          ,output v-sale-price-rubl
          ,output v-road-tax-base
          ,output v-road-tax-rubl
          ,output v-excise-base
          ,output v-excise-rubl
          ) no-error .
          temp_doc-line.price-cli  = v-sale-price-rubl.
          v-str-txt = substitute("Цена по МПЛ  ТПЛ &1(БД&2) ДНЦ &3(БД&4)",v-plt-id,v-plt-db-num, v-pdf-id,v-pdf-db).
     end.
     otherwise do:
          v-end-message =  substitute(" trn-doc.Line-num &1 №Документа &2 не корректное значение поля price-type = &3" ,
                            temp_trn-doc.line-num,
                            temp_trn-doc.doc-code,
                            temp_trn-doc.price-type ) .
          run pcall-log-file in p-log-handle (input v-end-message) .
          undo, return error v-end-message.

     end.
     end case.
     end.

        { gbl/rootnode.i
          temp_doc-line.artic
          temp_doc-line.prod-type
          temp_doc-line.prod-code
          v-root-node
          }
        k = k + 1  .
        create tt2-doc-line .
        BUFFER-COPY temp_doc-line  to tt2-doc-line
          assign
            tt2-doc-line.cli-qnty       = temp_doc-line.fact-qnty
            tt2-doc-line.doc-qnty       = temp_doc-line.fact-qnty
            tt2-doc-line.fact-qnty      = temp_doc-line.fact-qnty
            tt2-doc-line.price-cli      = temp_doc-line.price-cli
            tt2-doc-line.price-rubl     = tt2-doc-line.price-cli  * new_trn-doc.exch-rate / new_trn-doc.exch-scale
            tt2-doc-line.price-base     = tt2-doc-line.price-rubl / new_trn-doc.base-rate * new_trn-doc.base-scale

            tt2-doc-line.doc-code       = n-d
            tt2-doc-line.status_        = "temp"
            tt2-doc-line.ext-doc-type   = v-ext-doc-type
            tt2-doc-line.slt-pc         = 0
            tt2-doc-line.cli-base-rate  = 1
            tt2-doc-line.line-num       = next-value (s-line-num, {&db-name_schema})
            tt2-doc-line.prt-root       = buf_goods.prt-root
            tt2-doc-line.unit-cli       = buf_goods.unit-base
            tt2-doc-line.doc-density    = 1 / tt2-doc-line.cli-base-rate
            tt2-doc-line.fact-density   = 1 / tt2-doc-line.cli-base-rate
            tt2-doc-line.obj-code       = tt-trn-doc.obj-code
            tt2-doc-line.obj-type       = tt-trn-doc.obj-type
            .

        create tt-gds-dtl.
        BUFFER-COPY tt2-doc-line  to tt-gds-dtl
          assign
            tt-gds-dtl.doc-qnty  = temp_doc-line.fact-qnty
            tt-gds-dtl.fact-qnty = temp_doc-line.fact-qnty
            tt-gds-dtl.prt-code  = v-root-node
            tt-gds-dtl.ov = yes     /*  yes  зафиксируем цены для внутреннего перемещения . Они определены в заказе */
                                    /*  no - будет спрашивать */
          .
          /* признаки  для расходной только корневые */
  end. /*temp_doc-line*/

  for each tt2-doc-line :
      create tt-parts.
      buffer-copy tt2-doc-line except tt2-doc-line.status_ to tt-parts .
        assign
          tt-parts.prod-type      = tt2-doc-line.prod-type
          tt-parts.prod-code      = tt2-doc-line.prod-code
          tt-parts.artic          = tt2-doc-line.artic
          tt-parts.in-code        = new_trn-doc.doc-code
          tt-parts.out-code       = new_trn-doc.doc-code
          tt-parts.price-cli      = tt2-doc-line.price-cli
          tt-parts.price-rubl     = tt2-doc-line.price-cli  * new_trn-doc.exch-rate / new_trn-doc.exch-scale
          tt-parts.price-base     = tt2-doc-line.price-rubl / new_trn-doc.base-rate * new_trn-doc.base-scale
          tt-parts.qnty           = tt2-doc-line.fact-qnty
          tt-parts.obj-type       = new_trn-doc.obj-type
          tt-parts.obj-code       = new_trn-doc.obj-code
          tt-parts.fact-date      = new_trn-doc.fact-date
          tt-parts.fact-num       = new_trn-doc.fact-num
          tt-parts.VAT-pc         = tt2-doc-line.vat-pc
          tt-parts.part-code      = ""
          tt-parts.PS             = ""
          tt-parts.pay-code       = new_trn-doc.pay-code
          tt-parts.status_        = no
          tt-parts.fact-qnty      = tt2-doc-line.fact-qnty
          tt-parts.supp-type      = new_trn-doc.cli-type
          tt-parts.supp-code      = new_trn-doc.cli-code
          tt-parts.rsrv-free      = ?
          tt-parts.doc-type       = new_trn-doc.doc-type
          tt-parts.cli-qnty       = tt2-doc-line.fact-qnty
          tt-parts.pl-code        = ?
          tt-parts.VAT-type       = temp_trn-doc.vat-type
          tt-parts.exch-code      = 0
          tt-parts.cli-base-rate  = 1
          tt-parts.SLT-pc         = 0
          tt-parts.host-code      = new_trn-doc.host-code
          tt-parts.is-supp        = yes
          tt-parts.SLT-type       = {&without-slt}
          tt-parts.cst-code       = ""
          tt-parts.last-date      = ?
          tt-parts.road-tax-base  = 0
          tt-parts.road-tax-rubl  = 0
          tt-parts.transport-base = 0
          tt-parts.transport-rubl = 0
          tt-parts.other-base     = 0
          tt-parts.other-rubl     = 0
          tt-parts.purch-code     = new_trn-doc.purch-code
          tt-parts.contract-code  = new_trn-doc.contract-code
          no-error.
          if error-status:error then do :
              v-end-message = substitute(" Ошибка &1 &2 " , error-status :get-message(1)  , return-value) .
              run pcall-log-file in p-log-handle ( input v-end-message ) .
              undo, return error v-end-message.
          end.
end.
/*

for each tt2-doc-line :
    message
           'doc-line' skip
            n-d tt2-doc-line.artic skip
            'cli-qnty ' tt2-doc-line.cli-qnty skip
            'price-rub'tt2-doc-line.price-rubl skip
            'fact-qnty' tt2-doc-line.fact-qnty   skip
            'doc-qnty ' tt2-doc-line.doc-qnty     skip
        .
end.
for each tt-gds-dtl :
    message
    'gds-dtl' skip
    n-d
    tt-gds-dtl.artic skip
    tt-gds-dtl.fact-qnty    tt-gds-dtl.doc-qnty skip
            'price-rubl' tt-gds-dtl.price-rubl skip
            .
end.
for each tt-parts:
    message
    'parts'  skip
    n-d  skip
    tt-parts.artic skip
    tt-parts.cli-qnty tt-parts.fact-qnty tt-parts.qnty   skip
    'price-rubl' tt-parts.price-rubl skip
    .
end.
*/
  case v-ext-doc-type :
      when  {&TDEDT_Pri_Vnesh} then do:

          /* проверка спецификаций */
           for each tt-parts          :
              find first buf_goods no-lock  where
                    tt-parts.artic     = buf_goods.artic    and
                    tt-parts.prod-type = buf_goods.prod-type  and
                    tt-parts.prod-code = buf_goods.prod-code
                    no-error .

              { str/ckcntspc.i
                tt-parts.host-code
                tt-parts.contract-code
                buf_goods.gds-code
                tt-parts.price-cli
                tt-parts.VAT-type
                tt-parts.VAT-pc
                no-error
              }
          end.
          if error-status :error then do:
            v-end-message = substitute("Ошибка  &1 &2 " , error-status :get-message(1)  , return-value ) .
            run pcall-log-file in p-log-handle ( input v-end-message ) .
            undo, return error v-end-message.
          end.
       /* копирование */
     { str/copy-in.i
          this-procedure
          recid(new_trn-doc)
          tt-trn-doc
          tt2-doc-line
          tt-doc-line-attr
          tt-gds-dtl
          tt-parts
          no
          no
          no
          yes
          this-procedure
          no-error }
          if error-status:error then do :
              v-end-message = substitute(" Ошибка &1 &2 " , error-status :get-message(1)  , return-value) .
              run pcall-log-file in p-log-handle ( input v-end-message ) .
              undo, return error v-end-message.
          end.

          run gbl/calc-trn.p ( this-procedure  , recid(new_trn-doc)) no-error .
          if error-status :error then do:
            v-end-message = substitute(" Ошибка пересчета &1 &2 " , error-status :get-message(1)  , return-value ) .
            run pcall-log-file in p-log-handle ( input v-end-message ) .
            undo, return error v-end-message.
          end.



          find current new_trn-doc exclusive-lock .
              new_trn-doc.tot-cli =  new_trn-doc.tot-calc.
      end.
      when {&TDEDT_Ras_Vnesh}    or
      when {&TDEDT_Vozvrat_Vnesh}    then do:
          { str/copy-ret.i
            this-procedure
            new_trn-doc.doc-code
            new_trn-doc.doc-type
            new_trn-doc.status_
            new_trn-doc.internal
            new_trn-doc.cli-type
            new_trn-doc.cli-code
            new_trn-doc.discnt-type
            new_trn-doc.tot-calc
            new_trn-doc.discnt-pc
            new_trn-doc.agnt
            new_trn-doc.boss
            new_trn-doc.wrkr
            new_trn-doc.base-rate
            new_trn-doc.base-scale
            new_trn-doc.exch-code
            new_trn-doc.vat-type
            new_trn-doc.doc-code
            no
            new_trn-doc.discnt-pc
            new_trn-doc.agnt
            new_trn-doc.boss
            new_trn-doc.wrkr
            new_trn-doc.base-rate
            new_trn-doc.base-scale
            v-cntxt-cash-pay
            v-cntxt-base-code
            tt2-doc-line
            tt-gds-dtl
            tt-parts
            no
            yes
            yes
            yes
            no-error }

            if error-status:error then do :
                v-end-message = substitute(" Ошибка &1 &2" , error-status :get-message(1)  , return-value) .
                run pcall-log-file in p-log-handle ( input v-end-message ) .
                undo, return error v-end-message.
            end.


            run gbl/calc-trn.p (  this-procedure , recid(new_trn-doc)) no-error .
            if error-status :error then do:
              v-end-message = substitute(" Ошибка пересчета шапки &1 &2" , error-status :get-message(1)  , return-value) .
              run pcall-log-file in p-log-handle ( input v-end-message ) .
              undo, return error v-end-message.
            end.

            if v-ext-doc-type = {&TDEDT_Ras_Vnesh} then do:
            /* "Создание НАКЛ- " + caps({&expense})) . */
            run clos-trn in this-procedure (new_trn-doc.doc-code) no-error .
                if error-status:error then do :
                   v-end-message = substitute(" Ошибка &1 &2" , error-status :get-message(1)  , return-value) .
                   run pcall-log-file in p-log-handle ( input v-end-message ) .
                   undo, return error v-end-message.
                end.

                if temp_trn-doc.price-type   = {&pt1_cost} then do:
                  run calc-cost-price (new_trn-doc.doc-code) no-error .
                  if error-status :error then do:
                      v-end-message = substitute(" Ошибка пересчета учетных цен &1 &2" , error-status :get-message(1)  , return-value) .
                      run pcall-log-file in p-log-handle ( input v-end-message ) .
                      undo, return error v-end-message.
                  end.
                end.

            run clos-trn2 in this-procedure (new_trn-doc.doc-code) no-error .
                if error-status:error then do :
                   v-end-message = substitute(" Ошибка &1 &2" , error-status :get-message(1)  , return-value) .
                   run pcall-log-file in p-log-handle ( input v-end-message ) .
                   undo, return error v-end-message.
                end.

            end.
          assign
            new_trn-doc.PS  = trim(new_trn-doc.PS) + " " + v-str-txt .
      end.
   end case.


  if new_trn-doc.vat-type = "" or new_trn-doc.vat-type = ? or
     new_trn-doc.slt-type = "" or new_trn-doc.slt-type = ? then do:
        v-end-message = substitute(" Не настроено значение тип НДС или тип НсП !!! АРМ Администратор/Глобальные параметры/ &1 &2" , error-status :get-message(1)  , return-value) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.

  end.

   run add-nn (new_trn-doc.doc-code , temp_trn-doc.doc-code ) no-error .
    if error-status:error then do :
        v-end-message = substitute(" Ошибка записи атрибута документа &1 &2" , error-status :get-message(1)  , return-value) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.
    end.
   run clos-trn2 in this-procedure (new_trn-doc.doc-code) no-error .
    if error-status:error then do :
        v-end-message = substitute(" Ошибка при закрытиии документа &1 &2" , error-status :get-message(1)  , return-value) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.
    end.

    if new_trn-doc.ext-doc-type = {&TDEDT_Vozvrat_Vnesh}    then do:
        v-end-message = substitute("Закрытиии внешнего возврата &1 на статус РАЗР " , new_trn-doc.doc-code) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        run clos-trn2 in this-procedure (new_trn-doc.doc-code) no-error .
        if error-status:error then do :
            v-end-message = substitute(" Ошибка при закрытиии внешнего возврата на статус РАЗР &1 &2" , error-status :get-message(1)  , return-value) .
            run pcall-log-file in p-log-handle ( input v-end-message ) .
            undo, return error v-end-message.
        end.
        v-end-message = substitute("Закрытиии внешнего возврата &1 на статус ФАКТ ", new_trn-doc.doc-code ) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        run clos-trn2 in this-procedure (new_trn-doc.doc-code) no-error .
        if error-status:error then do :
            v-end-message = substitute(" Ошибка при закрытиии внешнего возврата на статус ФАКТ &1 &2" , error-status :get-message(1)  , return-value) .
            run pcall-log-file in p-log-handle ( input v-end-message ) .
            undo, return error v-end-message.
        end.
    end.
    assign
        v-end-message =  string(temp_trn-doc.obj-type) + string(temp_trn-doc.obj-code)
                    + {&tabulation} + "Документ:" + string(new_trn-doc.doc-code) + " / " + string(temp_trn-doc.doc-code) + {&tabulation} + string( k ) + " товаров"
                    .

     run pcall-log-file in p-log-handle (input v-end-message) .
     p-ok-doc = p-ok-doc + 1.

end.
end.


/* перевод запроса в накл - */
procedure clos-trn :

  do
  on error undo, return error return-value
  :
define input parameter p-trn-code as character no-undo .


define buffer buf_s-trn-doc for ub.trn-doc.
define variable varmode            as   character           no-undo.
define variable varstatus          like ub.trn-doc.status_  no-undo.
define variable varflag            like ub.trn-doc.flag     no-undo.
define variable varcopystatus      like ub.trn-doc.status_  no-undo.
define variable varcopyflag        like ub.trn-doc.flag     no-undo.
define variable varcheck-return as logical no-undo .
define variable varchg-inv as logical no-undo .
assign
  varmode         = {&close-doc}
  varstatus       = {&inquiry}
  varflag         = true
  varcopystatus   = {&g___new}
  varcopyflag     = false
  varcheck-return = true
  varchg-inv      = true
  .

run str/trn-graf.p
  ( input  p-trn-code ,
    input  v-cntxt-db-num ,
    input  varmode ,
    output varstatus ,
    output varflag ,
    output varcopystatus ,
    output varcopyflag
  ) no-error .

    if error-status:error then do :
        v-end-message = substitute(" Ошибка &1 &2" , error-status :get-message(1)  , return-value) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.
    end.

run str/trn-stat.p (
    input  parparentproc ,
    input  this-procedure ,
    input  varmode,
    input  p-trn-code,
    input  varcheck-return,
    input  v-cntxt-db-num,
    input  v-cntxt-in-ov,
    input  v-cntxt-rsrv-time,
    input  v-cntxt-load-time,
    input  v-cntxt-holidays,
    input  NO,
    output varchg-inv,
    output table gds-list)
    no-error.
    if error-status:error then do :
        v-end-message = substitute(" Ошибка &1 &2" , error-status :get-message(1)  , return-value) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.
    end.

  end.

end procedure. /* clos-trn */


procedure clos-trn2 :
define input parameter p-trn-code as character no-undo .
  do
  on error undo, return error return-value
  :
define buffer buf_s-trn-doc for ub.trn-doc.
define variable varmode            as   character           no-undo.
define variable varstatus          like ub.trn-doc.status_  no-undo.
define variable varflag            like ub.trn-doc.flag     no-undo.
define variable varcopystatus      like ub.trn-doc.status_  no-undo.
define variable varcopyflag        like ub.trn-doc.flag     no-undo.
define variable varcheck-return as logical no-undo .
define variable varchg-inv as logical no-undo .

run str/trn-stat.p (
    input  parparentproc ,
    input  this-procedure ,
    input  {&close-doc} ,
    input  p-trn-code,
    input  false /* проверка старого возврата */ ,
    input  v-cntxt-db-num,
    input  false /* проверка переоценки */,
    input  v-cntxt-rsrv-time,
    input  v-cntxt-load-time,
    input  v-cntxt-holidays,
    input  false ,
    output varchg-inv ,
    output table gds-list)
    no-error.
    if error-status:error then do :
        v-end-message = substitute(" Ошибка &1 &2" , error-status :get-message(1)  , return-value) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.
    end.
  end.
end procedure. /* clos-trn2 */


/* для подсовывания trn-clos  и прочим */
procedure mainmenu_getcntxt :
define output parameter p-cntxt-db-num                as integer   no-undo . /* текущая БД            */
define output parameter p-cntxt-userid                as character no-undo . /* текущий пользователь  */
define output parameter p-cntxt-level                 as character no-undo . /* уровень контекста     */
define output parameter p-cntxt-host-code-obj         as integer   no-undo . /* текущая фирма         */
define output parameter p-cntxt-obj-type              as character no-undo . /* тип текущего объекта  */
define output parameter p-cntxt-obj-code              as integer   no-undo . /* код текущего объекта  */
define output parameter p-cntxt-db-num-obj            as integer   no-undo . /* база текущего объекта */
define output parameter p-cntxt-is-admin              as logical   no-undo . /* база текущего объекта */

  do
  on error undo, return error return-value
  :
  { gbl/objdbnum.i
     vt-obj-type
     vt-obj-code
     p-cntxt-db-num-obj
     }

  assign
    p-cntxt-db-num          =  v-cntxt-db-num
    p-cntxt-userid          =  v-cntxt-userid
    p-cntxt-level           =  v-cntxt-level
    p-cntxt-host-code-obj   =  vt-host-code
    p-cntxt-obj-type        =  vt-obj-type
    p-cntxt-obj-code        =  vt-obj-code
    p-cntxt-is-admin        =  v-cntxt-is-admin
  .

  end.
 end procedure. /* mainmenu_getcntxt */


 procedure get-report-num :
  define output parameter p-report-num as integer no-undo .
   do
   on error undo, return error return-value
   :
    assign
      p-report-num = 1
    .
   end.

 end procedure. /* get-report-num */

procedure clear-tt :

  do
  on error undo, return error return-value
  :
   for each tt-trn-doc:
    delete tt-trn-doc.
   end.

    for each tt2-doc-line :
        delete tt2-doc-line .
    end.
    for each tt-doc-line :
        delete tt-doc-line .
    end.
    for each tt-gds-dtl :
        delete tt-gds-dtl .
    end.
    for each tt-parts:
        delete tt-parts .
    end.
    for each lib-trn_ret-doc :
      delete lib-trn_ret-doc.
    end.
    for each lib-trn_ret-line :
      delete lib-trn_ret-line      .
    end.
    for each lib-trn_ret-line-attr :
      delete lib-trn_ret-line.
    end.
    for each lib-trn_ret-dtl :
      delete lib-trn_ret-dtl.
    end.
    for each lib-trn_ret-parts :
      delete lib-trn_ret-parts .
    end.

 end.
end procedure. /* clear-tt */

procedure add-nn :
define input  parameter p-doc-code as character no-undo .
define input  parameter p-doc-out as character no-undo .
  do
  on error undo, return error return-value
  :
  find first ub.doc-attr exclusive-lock where
           ub.doc-attr.doc-code = p-doc-code and
           ub.doc-attr.attr-code = {&trdcattr-nids} no-error .
  if not available ub.doc-attr then create ub.doc-attr.
  assign
    ub.doc-attr.doc-code = p-doc-code
    ub.doc-attr.attr-code = {&trdcattr-nids}
    ub.doc-attr.attr-value = p-doc-out
  .
  end.

end procedure. /* add-nn */


procedure calc-cost-price :
define input  parameter p-doc-code as character no-undo .
define buffer cur-doc-line  for ub.doc-line.
define buffer cur-goods     for ub.goods.
define buffer cur-gds-dtl   for ub.gds-dtl.
define buffer t-doc         for ub.trn-doc  .
define variable varnew-price like ub.doc-line.price-base no-undo.

  do
  on error undo, return error return-value
  :
  v-end-message = substitute("Просчет учетной цены для расходной накладной &1" , p-doc-code) .
  run pcall-log-file in p-log-handle ( input v-end-message ) .

  find first t-doc no-lock where t-doc.doc-code = p-doc-code .

   for each  cur-doc-line where cur-doc-line.doc-code   = t-doc.doc-code         ,
       first cur-goods    where cur-goods.artic         = cur-doc-line.artic     and
                                cur-goods.prod-type     = cur-doc-line.prod-type and
                                cur-goods.prod-code     = cur-doc-line.prod-code no-lock,
       each  cur-gds-dtl  where cur-gds-dtl.doc-code    = cur-doc-line.doc-code  and
                                cur-gds-dtl.artic       = cur-doc-line.artic     and
                                cur-gds-dtl.prod-type   = cur-doc-line.prod-type and
                                cur-gds-dtl.prod-code   = cur-doc-line.prod-code no-lock :

       assign
         line-rec = recid(cur-doc-line)
       .
       { str/in-vatp.i
         calc
         cur-doc-line.
         t-doc.
         g
         }
    assign
      varnew-price = (if t-doc.print-rubl then price-rubl-with-tax-loc
                                          else price-base-with-tax-loc ) .
       run str/out-add.p ( this-procedure ,
                      recid (t-doc),
                      recid (cur-doc-line),
                      recid (cur-gds-dtl),
                      recid (cur-goods),
                      "update-sale-price",
                      string(varnew-price)) no-error.
       if error-status :error then do:
        v-end-message = substitute(" Ошибка при вызове программы out-add &1 &2" , error-status :get-message(1)  , return-value) .
        run pcall-log-file in p-log-handle ( input v-end-message ) .
        undo, return error v-end-message.
       end.
   end.
    run gbl/calc-trn.p (  this-procedure , recid(new_trn-doc)) no-error .
    if error-status :error then do:
      v-end-message = substitute(" Ошибка пересчета шапки &1 &2" , error-status :get-message(1)  , return-value) .
      run pcall-log-file in p-log-handle ( input v-end-message ) .
      undo, return error v-end-message.
    end.

  end.

end procedure. /* calc-cost-price */

procedure cb_cloce-quest-neg :
define output parameter p-is-negostmess as logical   no-undo .
  do
  on error undo, return error return-value
  :

   p-is-negostmess = false .

  end.

end procedure. /* cb_cloce-quest-neg */