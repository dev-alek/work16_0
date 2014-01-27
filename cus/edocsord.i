/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедуры перевода статусов при отправке и приеме заказов по EDOC-NN

Автор: Чернова Светлана Александровна
Дата создания: 10/02/08
Author: Svetlana Chernova
Creation date: 10/02/08

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
{ cus/ord-code.i def }
{ ref/extclass.i }
{ gbl/key-rec.i }
{ cus/cr-edist.i }

&if "{1}" <> "edi" &then
/* для заказа */
define temp-table temp-ord-line no-undo
field doc-code      as character
field trn-doc      as character
field cliart        as character
field artth         as character
field nameth        as character
field quantityquant as decimal
field pricequant    as decimal
field status_       as character
field desstatus     as character
field code39        as character
index pi  doc-code cliart trn-doc
.

&endif

/* для заказа */

/* для поставок  */
define temp-table temp-rcv-line-new no-undo like ub.ord-line-rcv .

procedure edocsord_export :
define parameter buffer buf_ord-doc for ub.ord-doc.
define input parameter p-ext-rcv-code as character no-undo .
define input parameter p-status_ as integer no-undo .
do
on error undo, return error
:

  define buffer buf_ord-doc-rcv for ub.ord-doc-rcv  .

    find first buf_ord-doc-rcv exclusive-lock where
             buf_ord-doc-rcv.doc-code = buf_ord-doc.doc-code
         and buf_ord-doc-rcv.sub-par begins string(trim(p-ext-rcv-code) + {&delim-par}) no-error .
  if available buf_ord-doc-rcv then do:
     assign
      buf_ord-doc-rcv.ord-int1 = p-status_
     .
  end.

  assign
    buf_ord-doc.ord-int1 = p-status_
  .
end.
end procedure.


&if "{1}" <> "edi" &then
procedure edocsord_import :
define parameter buffer buf_ord-doc for ub.ord-doc.
define input parameter p-ext-status as character no-undo .
define input parameter p-trn-code as character no-undo .
define input parameter p-ps as character no-undo .
define buffer buf_ord-list for ord-list.
do
on error undo, return error
:
/* Проверка на статус */
  case p-ext-status :
    when {&edoc-ext-stk-ok} or
    when {&edoc-ext-rpl}    or
    when {&edoc-ext-acc-ok} or
    when {&edoc-ext-pst}
    then do:
       if (p-ext-status = {&edoc-ext-pst}
       and buf_ord-doc.ord-int1 < integer({&edoc-acc-ok}) )
       or (p-ext-status <> {&edoc-ext-pst}
          and buf_ord-doc.ord-int1 <> lookup ( p-ext-status , {&edoc-spis-e} ) - 1) then do:
          find first buf_ord-list where
                     buf_ord-list.doc-code = buf_ord-doc.doc-code no-error.
          buf_ord-list.ord-int1 = buf_ord-doc.ord-int1 .
          for each temp-ord-line where
                   temp-ord-line.doc-code = buf_ord-doc.doc-code:
            delete temp-ord-line.
          end.
          &scop order-stts-int1 string(buf_ord-doc.ord-int1)
          return error substitute("Статус заказа &1 в БД = &2(&3), принять данные о статусе &4(&5) от поставщика еще/уже не можем"
                                  ,buf_ord-doc.doc-code
                                  ,{&edoc-stts-name}
                                  ,{&edoc-stts-ex}
                                  ,entry(lookup(p-ext-status, {&edoc-spis-e}), {&edoc-spis-f})
                                  ,p-ext-status
                                  ).
       end.
    end.
  end case.


  case p-ext-status :
    when {&edoc-ext-stk-ok} or
    when {&edoc-ext-err} or
    when {&edoc-ext-acc-ok}
    then do:
      run proc-ord in this-procedure ( input p-ext-status
                                      ,input buf_ord-doc.doc-code
                                      ,input ''
                                      ,input p-ps
                                      ) .
      for each temp-ord-line where
               temp-ord-line.doc-code = buf_ord-doc.doc-code:
        delete temp-ord-line.
      end.
       /*ничего не надо отправлять обратно - стираем ord-list*/
      find first buf_ord-list where
                buf_ord-list.doc-code = buf_ord-doc.doc-code no-error.
      if available buf_ord-list then do:
        delete buf_ord-list.
      end.
    end.
    when {&edoc-ext-rpl}
    then do:
      run proc-reply in this-procedure (
                                          input p-ext-status
                                         ,input buf_ord-doc.doc-code)  .
      for each temp-ord-line where
               temp-ord-line.doc-code = buf_ord-doc.doc-code:
        delete temp-ord-line.
      end.
      find first buf_ord-list where
                buf_ord-list.doc-code = buf_ord-doc.doc-code no-error.
      if available buf_ord-list then
      assign
      buf_ord-list.ord-int1 = integer({&edoc-rpl-ok})
      buf_ord-list.sel-order = 1
      buf_ord-list.dm = integer({&doc-dm-edoc-nn})
      .
      /*надо отправить ответ rpl-ok*/
    end.
    when {&edoc-ext-pst}
    then do:
      run proc-gen-rcv in this-procedure ( input p-ext-status
                                          ,input buf_ord-doc.doc-code
                                          ,input p-trn-code
                                          ,input buf_ord-doc.ship-date
                                          )  no-error.
      if error-status:error then do:
        for each temp-rcv-line-new:
          delete temp-rcv-line-new.
        end.
        undo, return error substitute("Ошибка при приеме поставки &1&2&3&2&4"
                                   , p-trn-code
                                   , {&new-line}
                                   , error-status:get-message(1)
                                   , return-value
                                   ).
      end.
      for each temp-ord-line where
               temp-ord-line.doc-code = buf_ord-doc.doc-code and
               temp-ord-line.trn-doc = p-trn-code:
        delete temp-ord-line.
      end.
      /*надо отправить ответ pst-ok*/
      find first buf_ord-list where
                buf_ord-list.doc-code = buf_ord-doc.doc-code
             and buf_ord-list.trn-doc = p-trn-code     no-error.
      if available buf_ord-list then
      assign
      buf_ord-list.ord-int1 = integer({&edoc-pst-ok})
      buf_ord-list.sel-order = 1
      buf_ord-list.dm = integer({&doc-dm-edoc-nn})
      .
    end.
    otherwise do:
      return error substitute("От поставщика получен статус &1 (&2), что непредусмотрено протоколом"
                             ,p-ext-status
                             ,entry(lookup(p-ext-status, {&edoc-spis-e}), {&edoc-spis-f})
                             ).
    end.
  end case.
end.
end procedure. /* edocsord_import */
&endif

&if "{1}" = "edi" &then

procedure edocsord_edi-import :
define parameter buffer buf_ord-doc for ub.ord-doc.
define input parameter p-cli-out-doc as character no-undo . /*номер дата время*/
define input parameter p-trn-code as character no-undo .
define input parameter p-status as integer no-undo .
define input parameter p-ship-date as date no-undo .
define input parameter p-ps as character no-undo .
define input parameter p-pack-num-chr as character no-undo .
define input parameter p-ediinterchangeid as character no-undo .
define output parameter p-new-ps as character no-undo .
define output parameter p-new-st as integer no-undo .

define variable v-permitted-status-list as character no-undo .
define variable v-uniq-key-rec as character no-undo .
define variable v-number as character no-undo .
define variable v-cli-doc-date-chr as character no-undo .
define variable v-transport-cli-type-code as character no-undo .
define variable v-without as logical no-undo .
define variable v-edist-mess as character no-undo .
define buffer buf_ext-classif for ub.ext-classif.
define buffer buf_clients for ub.clients.
&if "{2}" <> " " &then
define buffer buf_pos for {2}.
&endif
main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:
  if num-entries(p-trn-code, {&delim-par} ) > 1 then do:
    v-cli-doc-date-chr = entry(2, p-trn-code, {&delim-par} ).
  end.
  if num-entries(p-trn-code, {&delim-par} ) > 2 then do:
    v-transport-cli-type-code = entry(3, p-trn-code, {&delim-par} ).
  end.
  p-trn-code = entry(1, p-trn-code, {&delim-par} ).
/* Проверка на статус */
  case p-status :
    when integer({&edi-orders-sts}) then do:
      assign
      v-permitted-status-list = {&edi-orders}.
      v-number = buf_ord-doc.doc-code.
    end.
    when integer({&edi-ordrsp})  then do:
      /*в зависимости от того по полной схеме или нет надо проверить предыдущий статус*/
      find first buf_clients no-lock where
                buf_clients.obj-type = buf_ord-doc.cli-type
            and buf_clients.obj-code = buf_ord-doc.cli-code.
      run gen-key-rec in this-procedure ( input {&table_clients}
                                          ,input (buffer buf_clients:handle)
                                          ,output v-uniq-key-rec
                                          ).
      find first buf_ext-classif no-lock where
                  buf_ext-classif.classif-subject = {&table_clients}
              and buf_ext-classif.classif-name = {&extclass_clients_exite-edi}
              and buf_ext-classif.uniq-key-rec = v-uniq-key-rec no-error.
      if not available buf_ext-classif then do:
         v-permitted-status-list = ''.
      end.
      if buf_ext-classif.charkey_one = {&exite-edi-without-ordrsp} then do:
        v-permitted-status-list = ''.
        v-without = yes.
      end.
      else do:
        assign
        v-permitted-status-list = {&edi-orders} + {&comma-char} +
                                  {&edi-orders-sts} + {&comma-char} +
                                  {&edi-ordrsp-no}
                                  .
        v-number = entry(1, p-cli-out-doc, {&delim-par}).
      end.
    end.
    when integer({&edi-ordrsp-sts})  then do:
      find first buf_clients no-lock where
                buf_clients.obj-type = buf_ord-doc.cli-type
            and buf_clients.obj-code = buf_ord-doc.cli-code.
      run gen-key-rec in this-procedure ( input {&table_clients}
                                          ,input (buffer buf_clients:handle)
                                          ,output v-uniq-key-rec
                                          ).
      find first buf_ext-classif no-lock where
                  buf_ext-classif.classif-subject = {&table_clients}
              and buf_ext-classif.classif-name = {&extclass_clients_exite-edi}
              and buf_ext-classif.uniq-key-rec = v-uniq-key-rec no-error.
      if not available buf_ext-classif then do:
         v-permitted-status-list = ''.
      end.
      if buf_ext-classif.charkey_one = {&exite-edi-without-ordrsp} then do:
        v-permitted-status-list = ''.
        v-without = yes.
      end.
      else do:
        assign
        v-permitted-status-list = {&edi-orders} + {&comma-char} + /*если не ходит status*/
                                  {&edi-orders-sts} + {&comma-char} +
                                  {&edi-ordrsp-no}
                                  .
        v-number = entry(1, p-cli-out-doc, {&delim-par}).
      end.
    end.
    when integer({&edi-desadv}) then do:
      if buf_ord-doc.status_ = {&ord-rejection} or buf_ord-doc.status_ = {&ord-close} or buf_ord-doc.status_ = {&fact}
      then do:
        v-edist-mess = ''.
        v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}
                                             , substitute("Статус заказа TH &1 в БД &2, принять поставку от поставщика не можем ", buf_ord-doc.doc-code, buf_ord-doc.status_ )).
        run create-edi-statett in this-procedure (
                                                input {&table_ord-doc}                    /* p-tbl-name */
                                              , input buf_ord-doc.doc-code               /* p-doc-code */
                                              , input buf_ord-doc.cli-type                /* p-cli-type */
                                              , input buf_ord-doc.cli-code                /* p-cli-code */
                                              , input {&update}                           /* p-act      */
                                              , input -1                                  /* p-state    */
                                              , input integer({&severity-extreme})        /* p-err      */
                                              , input v-edist-mess                        /* p-des      */
                                              , input ''                                  /* p-mess     */
                                              , input integer({&doc-dm-edi})              /* p-dm */
                                              ).
        p-new-st = ?.
        return cr-edist_get-mess-mean( input v-edist-mess).
      end.
      v-number = p-trn-code.
      /*в зависимости от того по полной схеме или нет надо проверить предыдущий статус*/
      find first buf_clients no-lock where
                buf_clients.obj-type = buf_ord-doc.cli-type
            and buf_clients.obj-code = buf_ord-doc.cli-code.
      run gen-key-rec in this-procedure ( input {&table_clients}
                                          ,input (buffer buf_clients:handle)
                                          ,output v-uniq-key-rec
                                          ).
      find first buf_ext-classif no-lock where
                  buf_ext-classif.classif-subject = {&table_clients}
              and buf_ext-classif.classif-name = {&extclass_clients_exite-edi}
              and buf_ext-classif.uniq-key-rec = v-uniq-key-rec no-error.
      if not available buf_ext-classif then do:
         v-permitted-status-list = ''.
      end.
      if buf_ext-classif.charkey_one = {&exite-edi-without-ordrsp} then do:
        assign
        v-permitted-status-list = {&edi-orders} + {&comma-char} + /*если не ходит status*/
                                  {&edi-orders-sts} + {&comma-char} +
                                  {&edi-desadv-sts} + {&comma-char} +
                                  {&edi-recadv} + {&comma-char} +
                                  {&edi-desadv} + {&comma-char} +
                                  {&edi-recadv-sts} /*одна из ПН уже могла прийти*/
        .
      end.
      else do:
        assign
        v-permitted-status-list = {&edi-ordrsp-yes}  + {&comma-char} +
                                  {&edi-ordrsp-sts}  + {&comma-char} +
                                  {&edi-desadv-sts} + {&comma-char} +
                                  {&edi-desadv} + {&comma-char} +
                                  {&edi-recadv-sts}  /*одна из ПН уже могла прийти*/
        .
      end.
    end.
    when integer({&edi-recadv-sts}) then do:
      v-number = p-trn-code.
      assign
      v-permitted-status-list = {&edi-recadv} + {&comma-char} +
                                {&edi-desadv-sts}  + {&comma-char} +
                                {&edi-recadv-sts} /*поставка вклинилась между ПН*/ .
    end.
    when integer({&edi-err}) then do:
      assign
      v-permitted-status-list = {&edi-orders} + {&comma-char} + /*если не ходит status*/
                                {&edi-orders-sts} + {&comma-char} +
                                {&edi-ordrsp-no}
     .                           .
    end.
  end case.
  if lookup(string(buf_ord-doc.ord-int1), v-permitted-status-list) = 0 then do:
    &if "{2}" <> " " &then
    for each buf_pos where
              buf_pos.number = v-number
    on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
    on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
    on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
    :
      delete buf_pos.
    end.
    &endif
    &scop order-stts-int1 string(buf_ord-doc.ord-int1)
    if v-without then do:
      return error substitute("Не предусмотрен прием документа ORDRSP для поставщика &1&2"
                              , buf_ord-doc.cli-type
                              , buf_ord-doc.cli-code
                              ).
    end.
    else do:
      return error substitute("Статус заказа &1 в БД = &2, принять данные о статусе &3 от поставщика еще/уже не можем"
                              ,buf_ord-doc.doc-code
                              ,{&edi-stts-name}
                              &scop order-stts-int1 string(p-status)
                              ,{&edi-stts-name}
                              ).
    end.
  end.
  case p-status :
    when integer({&edi-orders-sts}) or
    when integer({&edi-err}) or
    when integer({&edi-ordrsp-sts}) or
    when integer({&edi-recadv-sts})
    then do:
      p-new-st = p-status.
      run proc-ord in this-procedure ( input string(p-status)
                                      ,input buf_ord-doc.doc-code
                                      ,input p-cli-out-doc
                                      ,input p-ps
                                      ) no-error .
     if error-status:error then p-new-st = ?.
     &if "{2}" <> " " &then
      for each buf_pos where
               buf_pos.number = entry(1, p-cli-out-doc, {&delim-par})
      on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
      on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
      on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
      :
        delete buf_pos.
      end.
      &endif
      if p-new-st = ? then undo main-block, return error return-value .
       /*ничего не надо отправлять обратно*/
    end. /*when integer({&edi-orders-sts}) or*/
    when integer({&edi-ordrsp})
    then do:
      define variable v-new-status as integer   no-undo .
      &if "{1}" = "edi" and  "{3}" = "proc-edi-reply-process" &then
      run proc-edi-reply-process in this-procedure (
                                          buffer buf_ord-doc
                                         ,input p-status
                                         ,input buf_ord-doc.doc-code
                                         ,input p-cli-out-doc
                                         ,input p-ship-date
                                         ,output p-new-st
                                         ) no-error  .
      /*новый статус может быть
      edi-err - все позиции по нулям или p-status = 27
      ordrsp-sts  - p-status = 29 или p-status = 5
      ordrsp - p-status  = 5

      */
      if error-status:error then do:
         undo, return error return-value .
      end.
      &endif
      &if "{2}" <> " " &then
      for each buf_pos where
               buf_pos.number = entry(1, p-cli-out-doc, {&delim-par})
     on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
     on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
     on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
     :
        delete buf_pos.
      end.
      &endif
       /*ничего не надо отправлять обратно - должен менеджер подтвердить*/
    end. /*when integer({&edi-ordrsp})*/
    when integer({&edi-desadv})
    then do:
      p-new-st = p-status.
      &if "{1}" = "edi" and "{3}" = "proc-edi-gen-rcv" &then
      run proc-edi-gen-rcv in this-procedure ( buffer buf_ord-doc
                                          ,input p-status
                                          ,input buf_ord-doc.doc-code
                                          ,input p-trn-code
                                          ,input buf_ord-doc.ship-date
                                          ,input buf_ord-doc.ship-time
                                          ,input date(v-cli-doc-date-chr)
                                          ,input v-transport-cli-type-code
                                          ,input p-pack-num-chr
                                          ,input p-ediinterchangeid
                                          ,output p-new-ps /*здесь лежит rcv-code*/
                                          ,output p-new-st
                                          )  no-error.
      if error-status:error then do:
        for each temp-rcv-line-new:
          delete temp-rcv-line-new.
        end.
        undo, return error substitute("Ошибка при приеме поставки &1&2&3&2&4"
                                   , p-trn-code
                                   , {&new-line}
                                   , error-status:get-message(1)
                                   , return-value
                                   ).
      end.
      &endif
      &if "{2}" <> " " &then
      for each buf_pos where
               buf_pos.number = entry(1, p-cli-out-doc, {&delim-par})
      on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
      on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
      on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
      :
        delete buf_pos.
      end.
      &endif
      for each temp-rcv-line-new:
        delete temp-rcv-line-new.
      end.
      /*надо отправить ответ desadv-sts*/
    end. /*when integer({&edi-desadv})*/
    otherwise do:
      &scop order-stts-int1 string(p-status)
      return error substitute("От поставщика получен статус &1, что непредусмотрено протоколом"
                             ,{&edi-stts-name}
                             ).
    end.
  end case.
end.
end procedure. /* edocsord_edi-import */
&endif

define variable p-status-ord as character no-undo .
/* stk-ok */


procedure proc-ord :
define input  parameter p-stts     as character no-undo .
define input  parameter p-doc-code as character no-undo .
define input  parameter p-cli-out-doc as character no-undo .
define input  parameter p-ps as character no-undo .

define variable v-edist-mess as character no-undo .

define buffer buf_ord-doc for ub.ord-doc  .
  do
  on error undo, return error return-value
  :
  find first buf_ord-doc exclusive-lock where
             buf_ord-doc.doc-code = p-doc-code no-error .
    if available buf_ord-doc  then do:
    if buf_ord-doc.whole-send-news = integer({&doc-dm-edi}) then do:
      assign
      buf_ord-doc.ord-int1 = integer(p-stts)
      buf_ord-doc.cli-out-doc = p-cli-out-doc
      .
      if p-stts = {&edi-ordrsp-sts} then do:
        run cus/ord-clos.p
          ( input  parParentProc
          , input  recid(buf_ord-doc)
          , input  buf_ord-doc.obj-type
          , input  buf_ord-doc.obj-code
          , input  g#db-num
          , input  false /*p-ask*/
          , input  "yes" /*p-param-list пока тока один параметр, говорит что edi или не edi*/
          ) no-error .
        if error-status:error then do:
          v-edist-mess = ''.
          v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}
                                               , substitute("Ошибка при переводе заказа в статус ПОСТАВКА&1&2&1&3"
                                               , {&new-line}
                                               , error-status:get-message(1)
                                               , return-value )).
          run create-edi-statett in this-procedure (
                                                input {&table_ord-doc}                    /* p-tbl-name */
                                              , input buf_ord-doc.doc-code                /* p-doc-code */
                                              , input buf_ord-doc.cli-type                /* p-cli-type */
                                              , input buf_ord-doc.cli-code                /* p-cli-code */
                                              , input {&update}                           /* p-act      */
                                              , input -1                                  /* p-state    */
                                              , input integer({&severity-extreme})        /* p-err      */
                                              , input v-edist-mess                        /* p-des      */
                                              , input ''                                  /* p-mess     */
                                              , input integer({&doc-dm-edi})              /* p-dm */
                                              ).
          undo, return error cr-edist_get-mess-mean( input  v-edist-mess).
        end.
      end.
      if p-stts = {&edi-err} then do:
        buf_ord-doc.status_ = {&ord-rejection} .
        buf_ord-doc.ps = p-ps.
        buf_ord-doc.cli-out-doc = p-cli-out-doc.
      end.
    end.
    else do:
       assign
         buf_ord-doc.ord-int1 = lookup ( p-stts , {&edoc-spis-e} )
       .
       if p-stts = {&edoc-ext-err} then do:
          buf_ord-doc.status_ = {&ord-rejection} .
          buf_ord-doc.ps = p-ps.
       end.
    end.
  end.
end.

end procedure. /* proc-ord */

procedure proc-trn :
define input  parameter p-stts     as character no-undo .
define input  parameter p-doc-code as character no-undo .
define input  parameter p-trn-code as character no-undo .

define buffer buf_ord-doc     for ub.ord-doc  .
define buffer buf_ord-doc-rcv for ub.ord-doc-rcv  .
define buffer buf_ord-chain   for ub.ord-chain  .
define buffer buf_trn-doc     for ub.trn-doc  .
main-block:
  do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
  :

  find first buf_ord-doc-rcv no-lock  where
             buf_ord-doc-rcv.doc-code = p-doc-code and
             entry(1, buf_ord-doc-rcv.sub-par,{&delim-par}) = p-trn-code
    no-error .
    if available buf_ord-doc-rcv  then do:
       for each buf_ord-chain  no-lock where
                buf_ord-chain.doc-code = buf_ord-doc-rcv.rcv-code and
                buf_ord-chain.doc-type = 'rcv' and
            buf_ord-chain.rel-doc-type = 'trn'
    on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
    on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
    on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
    :
            find first buf_trn-doc no-lock where
                       buf_trn-doc.doc-code = buf_ord-chain.rel-doc-code no-error .
            if available buf_trn-doc then do:
               /* в атрибут накладной */
            end.
       end.
  end. /**if available buf_ord-doc-rcv  then do*/
end. /*doe*/

end procedure. /* proc-trn */

&if "{1}" <> "edi" &then
/* Прием поставки от поставщика */
procedure proc-gen-rcv :
define input  parameter p-stts as character no-undo .
define input  parameter p-doc-code as character no-undo .
define input  parameter p-trn-code as character no-undo .
define input  parameter p-ship-date as date      no-undo .

define buffer buf_ord-doc for ub.ord-doc  .
define buffer buf_ord-doc-rcv for ub.ord-doc-rcv  .
define buffer buf_ord-line for ub.ord-line  .
define buffer buf_ord-line-rcv for ub.ord-line-rcv  .
define variable v-all as logical   no-undo .
define variable v-psq as logical   no-undo .
define variable v-prc-diff as decimal   no-undo .
define variable v-param-type      as character  no-undo .
define variable v-value-character as character  no-undo .
define variable v-value-date      as date       no-undo .
define variable v-value-decimal   as decimal    no-undo .
define variable v-value-integer   as integer    no-undo .
define variable v-value-logical   as logical    no-undo .
define variable v-tth             as handle     no-undo .
define buffer buf_goods for ub.goods  .
define buffer buf_units for ub.units  .


  do
  on error undo, return error return-value
  :

  find first buf_ord-doc no-lock where
           buf_ord-doc.doc-code = p-doc-code no-error .
  if error-status :error then do:
     return error .
  end.
  run adm/shattri.p ( input "get":U
                    , input  buf_ord-doc.obj-type
                    , input  buf_ord-doc.obj-code
                    , input  {&attr-ord-obj}
                    , input  {&attr-ord-obj_ord-wgt-div-prc}
                    , output v-value-character
                    , output v-value-date
                    , output v-value-decimal
                    , output v-value-integer
                    , output v-value-logical
                    , output v-param-type
                    , input-output table-handle v-tth
                    ) no-error .
  if error-status :error then v-prc-diff = 0 .
  else do:
    v-prc-diff = v-value-decimal .
  end.
  delete object v-tth.

  for each temp-rcv-line-new :
    delete temp-rcv-line-new.
  end.

define variable v-ps as character no-undo .
v-ps = "".
v-all = true .
v-psq = false  .
  for each buf_ord-line no-lock where
           buf_ord-line.doc-code = p-doc-code ,
     first temp-ord-line where
           temp-ord-line.doc-code = buf_ord-line.doc-code and
           temp-ord-line.trn-doc = p-trn-code  and
           temp-ord-line.cliart   = buf_ord-line.cli-art  and
           temp-ord-line.artth    = buf_ord-line.artic
           :
           find first buf_goods no-lock where
                      buf_goods.artic     = buf_ord-line.artic     and
                      buf_goods.prod-code = buf_ord-line.prod-code and
                      buf_goods.prod-type = buf_ord-line.prod-type no-error .
                if error-status :error then do:
                   return error substitute( "По артикулу &1 &2&3 не найден товар в справочнике " , buf_ord-line.artic, buf_ord-line.prod-code, buf_ord-line.prod-type ).
                end.

            find first buf_units no-lock
              where buf_units.unit-name = buf_goods.unit-base
              no-error .
              if error-status :error then do:
        return error substitute( "По артикулу &1 не найдена ед.изм &2 " , buf_ord-line.artic,  buf_goods.unit-base  ).
              end.

           if v-prc-diff <> 0 and lookup({&weight}, buf_units.type) > 0 then do:
              if ( buf_ord-line.cli-qnty  * ( 100 + v-prc-diff ) / 100 ) < temp-ord-line.quantityquant  then do:
              return error substitute('Для весового товара количество по поставке &1 не может превышать количество по заказу &2 более чем на &3%.&4Максимальное допустимое значение &5.':u
                                          , temp-ord-line.quantityquant
                                          , buf_ord-line.cli-qnty
                                          , v-prc-diff
                                          , {&new-line}
                                          , (buf_ord-line.cli-qnty  * ( 100 + v-prc-diff ) / 100 )
                                          ).
              end.
           end.

            if not (buf_ord-line.cli-qnty   = temp-ord-line.quantityquant ) then do:
               v-psq = true .
            end.

          if not ( buf_ord-line.price-cli  = temp-ord-line.pricequant ) then do:
            if v-all = true  then do :
            if length (v-ps) >= 2000  then do:
               assign
               v-ps = v-ps + "Есть еще информация о несовпадении цены, она не помещается в поле ПРИМЕЧАНИЕ "
               v-all = false .
            end.
            else do:
            v-ps = v-ps + substitute("Не совпадает цена для товара &1 &2&3 (артикул пост-ка &4) &5"
                        , buf_ord-line.artic
                        , buf_ord-line.prod-type
                        , buf_ord-line.prod-code
                        , buf_ord-line.cli-art
                        , {&new-line}
                        ).
            end.
          end.
     end.
     create temp-rcv-line-new.
     buffer-copy buf_ord-line to temp-rcv-line-new
     assign
     temp-rcv-line-new.sub-par    = temp-ord-line.code39
     temp-rcv-line-new.cli-qnty   = temp-ord-line.quantityquant
     temp-rcv-line-new.price-cli  = temp-ord-line.pricequant
     temp-rcv-line-new.price-rubl = temp-rcv-line-new.price-cli * buf_ord-doc.exch-rate / buf_ord-doc.exch-scale / buf_ord-line.cli-base-rate
     temp-rcv-line-new.qnty       = temp-rcv-line-new.cli-qnty  * buf_ord-line.cli-base-rate
     temp-rcv-line-new.price-base = temp-rcv-line-new.price-rubl / buf_ord-doc.base-rate * buf_ord-doc.base-scale
     temp-rcv-line-new.sum-rubl   = temp-rcv-line-new.price-rubl * temp-rcv-line-new.qnty
     temp-rcv-line-new.sum-base   = temp-rcv-line-new.price-base * temp-rcv-line-new.qnty
     temp-rcv-line-new.sum-cli    = temp-rcv-line-new.price-cli  * temp-rcv-line-new.cli-qnty
     .
   end.
/*  создание поставки  */
define variable loc-rcv-num as character no-undo .

define variable v-i-doc as character no-undo .
{ cus/ord-code.i
    'main'
    g#db-num
    buf_ord-doc.obj-type
    buf_ord-doc.obj-code
    v-i-doc
    loc-rcv-num
    }

define variable ks as integer   no-undo init 0 .

  for each temp-rcv-line-new
  by temp-rcv-line-new.line-num :
  ks = ks + 1.
  create buf_ord-line-rcv.
  buffer-copy temp-rcv-line-new to buf_ord-line-rcv
  assign
    buf_ord-line-rcv.rcv-code  = loc-rcv-num
    buf_ord-line-rcv.line-num  = ks
    buf_ord-line-rcv.cli-qnty  = temp-rcv-line-new.cli-qnty
    buf_ord-line-rcv.qnty      = buf_ord-line-rcv.cli-qnty * temp-rcv-line-new.cli-base-rate
    .
end.

/* Шапка поставки */
create buf_ord-doc-rcv.
 buffer-copy buf_ord-doc to buf_ord-doc-rcv
   assign
      buf_ord-doc-rcv.rcv-code  = loc-rcv-num
      buf_ord-doc-rcv.doc-type  = "out":u
      buf_ord-doc-rcv.doc-date  = today
      buf_ord-doc-rcv.status_   = {&ord-rcv}
      buf_ord-doc-rcv.ord-int1  = lookup ( p-stts , {&edoc-spis-e} )
      buf_ord-doc-rcv.ord-int2  = 0
  buf_ord-doc-rcv.whole-send-news = buf_ord-doc.whole-send-news
   .
    if v-psq = true then v-ps = "Есть несовпадения по количествам . " + trim( v-ps ) .
    if v-ps <> "" then do:
        assign
          buf_ord-doc-rcv.ord-int2 = integer({&edoc-diff})
          buf_ord-doc-rcv.PS       = v-ps
        .
    end.

    if p-ship-date <> ? then buf_ord-doc-rcv.ship-date = p-ship-date .

    buf_ord-doc-rcv.sub-par = trim(p-trn-code) + {&delim-par} + trim(buf_ord-doc.vat-type) + {&delim-par} .
    assign
    buf_ord-doc.ord-int1 = integer({&edoc-pst})
    .
   find first ord-list where
              ord-list.doc-code = buf_ord-doc.doc-code and
              ord-list.trn-doc = p-trn-code.

   assign
      ord-list.ord-int1 = integer({&edoc-pst-ok})
  ord-list.dm = integer({&doc-dm-edoc-nn})
   .
   release ord-list.
  end.

end procedure. /* proc-gen-rcv */
&endif

&if "{1}" = "edi" and "{3}" = "proc-edi-gen-rcv" &then
/* Прием поставки от поставщика EDI*/
procedure proc-edi-gen-rcv :
define parameter buffer buf_ord-doc for ub.ord-doc.
define input  parameter p-stts as integer no-undo .
define input  parameter p-doc-code as character no-undo .
define input  parameter p-trn-code as character no-undo .
define input  parameter p-ship-date as date      no-undo .
define input  parameter p-ship-time as integer   no-undo .
define input  parameter p-cli-doc-date as date no-undo .
define input  parameter p-transport-cli-type-code as character no-undo .
define input  parameter p-pack-num-chr as character no-undo .
define input  parameter p-ediinterchangeid as character no-undo .
define output parameter p-rcv-code as character no-undo .
define output parameter p-new-sts as integer no-undo .

define buffer buf_ord-doc-rcv for ub.ord-doc-rcv  .
define buffer buf_ord-line for ub.ord-line  .
define buffer buf_ord-line-rcv for ub.ord-line-rcv  .
define variable v-all as logical   no-undo .
define variable v-psq as logical   no-undo .
define variable v-prc-diff as decimal   no-undo .
define variable v-param-type      as character  no-undo .
define variable v-value-character as character  no-undo .
define variable v-value-date      as date       no-undo .
define variable v-value-decimal   as decimal    no-undo .
define variable v-value-integer   as integer    no-undo .
define variable v-value-logical   as logical    no-undo .
define variable v-tth             as handle     no-undo .
define variable v-found as logical no-undo .
define variable v-edist-mess as character no-undo .
define variable v-mess as character no-undo .
define variable v-edist-mess2 as character no-undo .
define variable v-b-str as character no-undo .
define variable v-type as character no-undo .
define variable loc-sum-rcv as decimal no-undo .
define variable v-found-unit-cli as logical no-undo .
define variable v-fatal as logical no-undo .
define buffer buf_goods for ub.goods  .
define buffer buf_units for ub.units  .
define buffer buf_pos for {2}.

main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:

  /*надо убедиться что эту поставку мы еще не закачивали*/
  /*теперь принимаем несколько поставок на один заказ
    for each buf_ord-doc-rcv no-lock where
          buf_ord-doc-rcv.doc-code = buf_ord-doc.doc-code:
    if entry(1, buf_ord-doc-rcv.sub-par, {&delim-par}) = p-trn-code then do:
      v-edist-mess = ''.
      v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}
                                           , substitute("Уже импортированы данные о поставке с № от поставщика &1", entry(1, buf_ord-doc-rcv.sub-par, {&delim-par}))).
      run create-edi-statett in this-procedure (
                                              input {&table_ord-doc}                    /* p-tbl-name */
                                            , input buf_ord-doc.doc-code                /* p-doc-code */
                                            , input buf_ord-doc.cli-type                /* p-cli-type */
                                            , input buf_ord-doc.cli-code                /* p-cli-code */
                                            , input {&update}                           /* p-act      */
                                            , input -1                                  /* p-state    */
                                            , input integer({&severity-extreme})        /* p-err      */
                                            , input v-edist-mess                        /* p-des      */
                                            , input ''                                  /* p-mess     */
                                            , input integer({&doc-dm-edi})              /* p-dm */
                                            ).
      p-new-sts = ?.
      return cr-edist_get-mess-mean( input v-edist-mess).
    end.
  end.*/

  run adm/shattri.p ( input "get":U
                    , input  buf_ord-doc.obj-type
                    , input  buf_ord-doc.obj-code
                    , input  {&attr-ord-obj}
                    , input  {&attr-ord-obj_ord-wgt-div-prc}
                    , output v-value-character
                    , output v-value-date
                    , output v-value-decimal
                    , output v-value-integer
                    , output v-value-logical
                    , output v-param-type
                    , input-output table-handle v-tth
                    ) no-error .
  if error-status :error then v-prc-diff = 0 .
  else do:
    v-prc-diff = v-value-decimal .
  end.
  delete object v-tth.

  for each temp-rcv-line-new :
    delete temp-rcv-line-new.
  end.

  define variable v-ps as character no-undo .
   /* Проверка на лишние строки */
   for each buf_pos  where
           buf_pos.number = p-trn-code
   on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
   on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
   on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
   :
      find first buf_ord-line  no-lock  where
              buf_ord-line.doc-code = p-doc-code
         and  buf_ord-line.gds-code = integer(buf_pos.productidbuyer)
         /*and  buf_ord-line.cli-art  = buf_pos.productidsupplier*/    no-error .
     if not available buf_ord-line then do:
       v-found = yes.
       p-new-sts  = ? . /* нельзя принимать пакет!*/
       v-edist-mess = ''.
       v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps},
                                          substitute("? товар Арт.Поставщика &1, АртикулТН &2, Количество &3 ;"
                                                    ,buf_pos.productidsupplier
                                                    ,buf_pos.productidbuyer
                                                    ,buf_pos.deliveredquantity
                                                    )).
       run create-edi-statett in this-procedure (
                                              input {&table_ord-doc}                    /* p-tbl-name */
                                            , input (buf_ord-doc.doc-code + {&delim-par} + string( - buf_pos.positionnumber))  /* p-doc-code */
                                            , input buf_ord-doc.cli-type                /* p-cli-type */
                                            , input buf_ord-doc.cli-code                /* p-cli-code */
                                            , input {&update}                           /* p-act      */
                                            , input buf_ord-doc.ord-int1                /* p-state    */
                                            , input integer({&severity-extreme})        /* p-err      */
                                            , input v-edist-mess                        /* p-des      */
                                            , input ''                                  /* p-mess     */
                                            , input integer({&doc-dm-edi})              /* p-dm */
                                            ).
     end. /*if not available buf_ord-line then do:*/
   end. /*   for each buf_pos  where */
   if v-found then do:
      p-new-sts = ?.
      v-edist-mess = ''.
      v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps},
                                             "Пришли товары, неуказанные в заказе").
      run create-edi-statett in this-procedure (
                                            input {&table_ord-doc}                    /* p-tbl-name */
                                          , input buf_ord-doc.doc-code                /* p-doc-code */
                                          , input buf_ord-doc.cli-type                /* p-cli-type */
                                          , input buf_ord-doc.cli-code                /* p-cli-code */
                                          , input {&update}                           /* p-act      */
                                          , input -1                                  /* p-state    */
                                          , input integer({&severity-extreme})        /* p-err      */
                                          , input v-edist-mess                        /* p-des      */
                                          , input ''                                  /* p-mess     */
                                          , input integer({&doc-dm-edi})              /* p-dm */
                                          ).
    return cr-edist_get-mess-mean( input v-edist-mess).
  end.
  v-found = no.
  v-found-unit-cli = no.
  v-ps = "".
  v-all = true .
  v-psq = false  .
  for each buf_ord-line share-lock where
           buf_ord-line.doc-code = p-doc-code ,
     first buf_pos where
           buf_pos.number = p-trn-code
       /*and buf_pos.productidsupplier  = buf_ord-line.cli-art*/
       and buf_pos.productidbuyer  = string(buf_ord-line.gds-code)
  on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
  on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
  on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
  :
    v-fatal = no.
    if buf_ord-line.initial-cli-qnty = 0 then do:
      assign
      buf_ord-line.initial-cli-qnty = buf_ord-line.cli-qnty
      buf_ord-line.order-cli-qnty   = buf_ord-line.cli-qnty
      buf_ord-line.ord-dec1         = buf_ord-line.price-cli
      .
    end.

    find first buf_goods no-lock where
              buf_goods.artic     = buf_ord-line.artic     and
              buf_goods.prod-code = buf_ord-line.prod-code and
              buf_goods.prod-type = buf_ord-line.prod-type no-error .
    if error-status :error then do:
        undo main-block, return error substitute( "По артикулу &1 &2&3 не найден товар в справочнике " , buf_ord-line.artic, buf_ord-line.prod-code, buf_ord-line.prod-type ).
    end.
    v-edist-mess = ''.
    find first buf_units no-lock
          where buf_units.unit-name = buf_goods.unit-base
       no-error .
    if error-status :error then do:
        undo main-block, return error substitute( "По артикулу &1 не найдена ед.изм &2 " , buf_ord-line.artic,  buf_goods.unit-base  ).
    end.
    loc-sum-rcv = 0.
    for each buf_ord-line-rcv where
            buf_ord-line-rcv.doc-code  = buf_ord-line.doc-code
        and buf_ord-line-rcv.artic     = buf_ord-line.artic
        and buf_ord-line-rcv.prod-type = buf_ord-line.prod-type
        and buf_ord-line-rcv.prod-code = buf_ord-line.prod-code no-lock  :
      loc-sum-rcv = loc-sum-rcv  + buf_ord-line-rcv.qnty .
    end.
    if v-prc-diff <> 0 and lookup({&weight}, buf_units.type) > 0 then do:
      if ( buf_ord-line.cli-qnty  * ( 100 + v-prc-diff ) / 100 ) < (loc-sum-rcv + buf_pos.deliveredquantity) then do:
        v-mess = substitute('Для весового товара количество по всем поставкам &1 не может превышать количество по заказу &2 более чем на &3%.&4Максимальное допустимое значение &5.':u
                            , loc-sum-rcv + buf_pos.deliveredquantity
                            , buf_ord-line.cli-qnty
                            , v-prc-diff
                            , {&new-line}
                            , (buf_ord-line.cli-qnty  * ( 100 + v-prc-diff ) / 100 )
                            ).
        v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, v-mess).
        v-found = yes.
        v-fatal = yes.
      end.
    end.
    else do:
      if buf_ord-line.cli-qnty < (loc-sum-rcv + buf_pos.deliveredquantity) then do:
        v-mess = substitute('Количество по всем поставкам заказа &1 не может превышать количество по заказу &2.':u
                            , loc-sum-rcv + buf_pos.deliveredquantity
                            , buf_ord-line.cli-qnty
                            ).
        v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, v-mess).
        v-found = yes.
        v-fatal = yes.
      end.
    end.
    if buf_pos.orderunit <> buf_ord-line.unit-cli then do:
      v-found-unit-cli = yes.
      v-fatal = yes.
      v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, "Ошибка в ед.изм.заказа").
    end.
    if buf_pos.deliveredunit <> buf_ord-line.unit-cli then do:
       v-found-unit-cli = yes.
       v-fatal = yes.
       v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, "Ошибка в ед.изм.поставки").
    end.
    /*найдем разницу*/
    v-b-str = ''.
    RUN ordlineattr-value  IN THIS-PROCEDURE ( input  buf_ord-line.doc-code
                                              ,input  buf_ord-line.gds-code
                                              ,input  {&attr-order-ean13}
                                              ,output v-b-str
                                              ,output v-type
                                              ) NO-ERROR.
    if v-b-str <> buf_pos.product then do:
        v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_bstr-change}, string(v-b-str) + {&delim-par} + string(buf_pos.product) ).
    end.
    if buf_ord-line.cli-qnty   <  loc-sum-rcv  + buf_pos.deliveredquantity  then do:
      v-fatal = yes.
      v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_qnty-down}, string(buf_ord-line.cli-qnty) + {&delim-par} + string(loc-sum-rcv + buf_pos.deliveredquantity) ).
    end.
    if buf_ord-line.cli-qnty   > buf_pos.deliveredquantity  then do:
      v-psq = yes.
      v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_qnty-down}, string(buf_ord-line.cli-qnty) + {&delim-par} + string(buf_pos.deliveredquantity) ).
    end.
    if v-edist-mess <> '' then do:
      run create-edi-statett in this-procedure (
                                              input {&table_ord-line}                    /* p-tbl-name */
                                            , input (buf_ord-line.doc-code  + {&delim-par}
                                                    + string(buf_ord-line.gds-code))     /* p-doc-code */
                                            , input buf_ord-doc.cli-type                 /* p-cli-type */
                                            , input buf_ord-doc.cli-code                 /* p-cli-code */
                                            , input {&update}                            /* p-act      */
                                            , input (if v-found or v-found-unit-cli then -1 else 0)  /* p-state    */
                                            , input (if v-fatal
                                                     then integer({&severity-extreme})
                                                     else integer({&severity-no-error})) /* p-err      */
                                            , input v-edist-mess                         /* p-des      */
                                            , input ''                                   /* p-mess     */
                                            , input integer({&doc-dm-edi})               /* p-dm */
                                            ).
    end.
    create temp-rcv-line-new.
    buffer-copy buf_ord-line to temp-rcv-line-new.
    
    /* refs #2706 добавление цены из поля DESADV */
    if buf_pos.PRICEQUANT <> 0 then 
        temp-rcv-line-new.price-cli = buf_pos.PRICEQUANT.
    else
        temp-rcv-line-new.price-cli = buf_ord-line.price-cli.
        
    assign
    temp-rcv-line-new.cli-qnty   = buf_pos.deliveredquantity
    temp-rcv-line-new.price-rubl = temp-rcv-line-new.price-cli * buf_ord-doc.exch-rate / buf_ord-doc.exch-scale / buf_ord-line.cli-base-rate
    temp-rcv-line-new.qnty       = temp-rcv-line-new.cli-qnty  * buf_ord-line.cli-base-rate
    temp-rcv-line-new.price-base = temp-rcv-line-new.price-rubl / buf_ord-doc.base-rate * buf_ord-doc.base-scale
    temp-rcv-line-new.sum-rubl   = temp-rcv-line-new.price-rubl * temp-rcv-line-new.qnty
    temp-rcv-line-new.sum-base   = temp-rcv-line-new.price-base * temp-rcv-line-new.qnty
    temp-rcv-line-new.sum-cli    = temp-rcv-line-new.price-cli  * temp-rcv-line-new.cli-qnty
    .
  end.
  if v-found then do:
    v-edist-mess = ''.
    v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, "Превышение заказанного кол-ва").
  end.
  if v-found-unit-cli then do:
    v-edist-mess = ''.
    v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, "Ошибка в ед изм.").
  end.
  if v-found or v-found-unit-cli then do:
    run create-edi-statett in this-procedure (
                                            input {&table_ord-line}                   /* p-tbl-name */
                                          , input buf_ord-doc.doc-code                /* p-doc-code */
                                          , input buf_ord-doc.cli-type                /* p-cli-type */
                                          , input buf_ord-doc.cli-code                /* p-cli-code */
                                          , input {&update}                           /* p-act      */
                                          , input -1                                  /* p-state    */
                                          , input integer({&severity-extreme})        /* p-err      */
                                          , input v-edist-mess                        /* p-des      */
                                          , input ''                                  /* p-mess     */
                                          , input integer({&doc-dm-edi})              /* p-dm */
                                          ).
    p-new-sts = ?.
    return cr-edist_get-mess-mean( input v-edist-mess).
  end.
  /*  создание поставки  */
  define variable loc-rcv-num as character no-undo .

  define variable v-i-doc as character no-undo .
  { cus/ord-code.i
    'main'
    g#db-num
    buf_ord-doc.obj-type
    buf_ord-doc.obj-code
    v-i-doc
    loc-rcv-num
    }

  define variable ks as integer   no-undo init 0 .

  for each temp-rcv-line-new
  by temp-rcv-line-new.line-num :
    ks = ks + 1.
    create buf_ord-line-rcv.
    buffer-copy temp-rcv-line-new to buf_ord-line-rcv
    assign
    buf_ord-line-rcv.rcv-code  = loc-rcv-num
    buf_ord-line-rcv.line-num  = ks
    buf_ord-line-rcv.cli-qnty  = temp-rcv-line-new.cli-qnty
    buf_ord-line-rcv.qnty      = buf_ord-line-rcv.cli-qnty * temp-rcv-line-new.cli-base-rate
    .
  end.
  /* Шапка поставки */
  create buf_ord-doc-rcv.
  buffer-copy buf_ord-doc to buf_ord-doc-rcv
  assign
  buf_ord-doc-rcv.rcv-code  = loc-rcv-num
  buf_ord-doc-rcv.doc-type  = "out":u
  buf_ord-doc-rcv.doc-date  = p-cli-doc-date
  buf_ord-doc-rcv.status_   = {&ord-rcv}
  buf_ord-doc-rcv.ord-int1  = p-stts
  buf_ord-doc-rcv.ord-int2  = 0
  buf_ord-doc-rcv.whole-send-news = buf_ord-doc.whole-send-news
  buf_ord-doc-rcv.transport-cli-type = (if substring(p-transport-cli-type-code, 1, 3) = {&cmp}
                                        or substring(p-transport-cli-type-code, 1, 3) = {&prs}
                                        then substring(p-transport-cli-type-code, 1, 3)
                                        else '')

  buf_ord-doc-rcv.transport-cli-code = (if substring(p-transport-cli-type-code, 1, 3) = {&cmp}
                                        or substring(p-transport-cli-type-code, 1, 3) = {&prs}
                                        then integer(substring(p-transport-cli-type-code, 4))
                                        else 0)
  p-rcv-code = loc-rcv-num
  .
  if v-psq = true then v-ps = "Есть несовпадения по количествам . " + trim( v-ps ) .
  if v-ps <> "" then do:
    assign
    buf_ord-doc-rcv.ord-int2 = integer({&edi-diff})
    buf_ord-doc-rcv.PS       = v-ps
    .
  end.
  if p-ship-date <> ? then buf_ord-doc-rcv.ship-date = p-ship-date .

  buf_ord-doc-rcv.sub-par = trim(p-trn-code) + {&delim-par} + trim(buf_ord-doc.vat-type) + {&delim-par} .
  assign
  buf_ord-doc.ord-int1 = integer({&edi-desadv})
  buf_ord-doc.status_ = (if buf_ord-doc.status_ = {&g___new}
                        then {&ord-rcv}
                        else buf_ord-doc.status_)
  .
  DEFINE VARIABLE v-date as date no-undo .
  DEFINE VARIABLE v-time as integer no-undo .
  v-date = ?.
  /*делаем в этом месте записб в БД - потому что срабатывает триггер на ord-doc-rcv и не видит ediinterchangeid
  которые записан в edi-status*/
  v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, v-ps).
  v-edist-mess2 = "".
  v-edist-mess2 = cr-edist_add-edist-mess( v-edist-mess2, {&edist_pack-num}, "->" + p-pack-num-chr ).
  v-edist-mess2 = cr-edist_add-edist-mess( v-edist-mess2, {&edist_ediinterchangeid}, p-ediinterchangeid).
  run create-edi-state in this-procedure (
    input {&table_ord-doc-rcv}                      /* p-tbl-name */
  , input buf_ord-doc-rcv.rcv-code                  /* p-doc-code */
  , input buf_ord-doc-rcv.cli-type                  /* p-cli-type */
  , input buf_ord-doc-rcv.cli-code                  /* p-cli-code */
  , input {&add-def}                                /* p-act      */
  , input {&edi-desadv}                             /* p-state    */
  , input (if v-ps <> ''
          then integer({&severity-extreme})
          else integer({&severity-no-error}) )      /* p-err      */
  , input v-edist-mess                              /* p-des      */
  , input v-edist-mess2                             /* p-mess     */
  , input integer({&doc-dm-edi})
  , input-output v-date
  , input-output v-time
  ).


end.

end procedure. /* proc-edi-gen-rcv */
&endif

&if "{1}" <> "edi" &then
procedure proc-reply :
define input  parameter p-status_ as character no-undo .
define input  parameter p-doc-code as character no-undo .

define buffer buf_ord-doc for ub.ord-doc  .
define buffer buf_ord-line for ub.ord-line  .

  do
  on error undo, return error return-value
  :

  find first buf_ord-doc no-lock where buf_ord-doc.doc-code = p-doc-code no-error .
  if error-status :error then do:
     return error .
  end.


  for each buf_ord-line exclusive-lock where
           buf_ord-line.doc-code   = buf_ord-doc.doc-code
  on error  undo , return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
  on stop   undo , return error substitute( "&1. stop", vss-workfile )
  on endkey undo , return error substitute( "&1. endkey", vss-workfile )
  :

        /* Запомним то что запрашивали */
        assign
          buf_ord-line.order-cli-qnty   = buf_ord-line.cli-qnty
          buf_ord-line.ord-dec1         = buf_ord-line.price-cli
        .

          find first temp-ord-line where
                temp-ord-line.doc-code = buf_ord-line.doc-code and
                temp-ord-line.artth    = buf_ord-line.artic    and
                temp-ord-line.cliart   = buf_ord-line.cli-art no-error .
         if available temp-ord-line then do:
           /* Исправим по принятым */
           assign
              buf_ord-line.cli-qnty         = temp-ord-line.quantityquant
              buf_ord-line.price-cli        = temp-ord-line.pricequant
              buf_ord-line.sub-par          = if temp-ord-line.status_    = '1' then ( temp-ord-line.desstatus + {&delim-par}) else {&delim-par}
              buf_ord-line.price-rubl       = buf_ord-line.price-cli * buf_ord-doc.exch-rate / buf_ord-doc.exch-scale / buf_ord-line.cli-base-rate
              buf_ord-line.qnty             = buf_ord-line.cli-qnty  * buf_ord-line.cli-base-rate
              buf_ord-line.price-base       = buf_ord-line.price-rubl / buf_ord-doc.base-rate * buf_ord-doc.base-scale
              buf_ord-line.sum-rubl         = buf_ord-line.price-rubl * buf_ord-line.qnty
              buf_ord-line.sum-base         = buf_ord-line.price-base * buf_ord-line.qnty
              buf_ord-line.sum-cli          = buf_ord-line.price-cli  * buf_ord-line.cli-qnty
           .
           end.
           else do:
              /* А этого нет в принятом */
              assign
                  buf_ord-line.cli-qnty         = 0
                  buf_ord-line.price-cli        = buf_ord-line.ord-dec1
                  buf_ord-line.sub-par          = "Строка удалена Поставщиком"
                  buf_ord-line.price-rubl       = buf_ord-line.price-cli * buf_ord-doc.exch-rate / buf_ord-doc.exch-scale / buf_ord-line.cli-base-rate
                  buf_ord-line.qnty             = buf_ord-line.cli-qnty  * buf_ord-line.cli-base-rate
                  buf_ord-line.price-base       = buf_ord-line.price-rubl / buf_ord-doc.base-rate * buf_ord-doc.base-scale
                  buf_ord-line.sum-rubl         = buf_ord-line.price-rubl * buf_ord-line.qnty
                  buf_ord-line.sum-base         = buf_ord-line.price-base * buf_ord-line.qnty
                  buf_ord-line.sum-cli          = buf_ord-line.price-cli  * buf_ord-line.cli-qnty
              .
           end.
   end.

   find first buf_ord-doc exclusive-lock where buf_ord-doc.doc-code = p-doc-code no-error .
   assign
     buf_ord-doc.ord-int1  = lookup(p-status_,{&edoc-spis-e})
   .
   /* Проверка на лишние строки */
   define variable strerr as character no-undo .
   define variable v-all2 as logical   no-undo .
   strerr = "" .
   v-all2 = true .
   for each temp-ord-line  where temp-ord-line.doc-code = p-doc-code :
       find first buf_ord-line  no-lock  where
              buf_ord-line.doc-code = temp-ord-line.doc-code   and
              buf_ord-line.artic    = temp-ord-line.artth      and
              buf_ord-line.cli-art  = temp-ord-line.cliart    no-error .
   if not available buf_ord-line then do:
     if v-all2 = true  then do :
      assign
        strerr = strerr +
        substitute(" Арт.Поставщика &1, АртикулТН &2, &3, Количество &4, Цена &5 ;",
                      temp-ord-line.cliart,
                      temp-ord-line.artth ,
                      temp-ord-line.nameth,
                      temp-ord-line.quantityquant,
                      temp-ord-line.pricequant  ) .
       if length (strerr) >= 2000 then do:
          strerr = strerr + "Есть еще информация о товарах неуказанных в заказе..." .
          v-all2 = false .
       end.
      end.
      end.
   end.
   if strerr <> "" then do:
       buf_ord-doc.ord-int1  = integer({&edoc-empty}). /* Снова Новый на корректировку */
       buf_ord-doc.PS        = "EDOC:Пришли товары неуказанные в заказе: " + {&new-line} +
                               strerr + {&new-line} +
                               buf_ord-doc.PS.
   end.

   find first ord-list where
              ord-list.doc-code = buf_ord-doc.doc-code.
   assign
   ord-list.ord-int1 = integer({&edoc-rpl-ok})
   ord-list.dm = integer({&doc-dm-edoc-nn})
   .
   release ord-list.
  end.

end procedure. /* proc-reply */
&endif

&if "{1}" = "edi" and  "{3}" = "proc-edi-reply-process" &then

procedure proc-edi-reply-process :
define parameter buffer buf_ord-doc for ub.ord-doc.
define input  parameter p-status_ as integer no-undo .
define input  parameter p-doc-code as character no-undo .
define input  parameter p-cli-out-doc as character no-undo . /*№ подвтерждение заказа */
define input  parameter p-ship-date as date no-undo .
define output parameter p-new-status as integer   no-undo .

define variable v-found as logical no-undo .
define variable v-edist-mess as character no-undo .
define variable v-b-str as character no-undo .
define variable v-type as character no-undo .
define buffer buf_ord-line for ub.ord-line  .
define buffer buf_pos for {2}.

main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:

  p-new-status = p-status_.
  v-edist-mess = ''.
  if p-ship-date <> buf_ord-doc.ship-date then do:
    v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_shipdate-change}
                                         , string(buf_ord-doc.ship-date, "99/99/9999")
                                          + {&delim-par}
                                          + string(p-ship-date) ).
  end.
  if entry(1, p-cli-out-doc, {&delim-par}) <> entry(1, buf_ord-doc.cli-out-doc, {&delim-par}) then do:
    v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_clioutdoc-change}
                                         , entry(1, buf_ord-doc.cli-out-doc, {&delim-par})
                                           + {&delim-par}
                                           + entry(1, p-cli-out-doc, {&delim-par})).
  end.
  run create-edi-statett in this-procedure (
                                          input {&table_ord-doc}                    /* p-tbl-name */
                                        , input buf_ord-doc.doc-code                /* p-doc-code */
                                        , input buf_ord-doc.cli-type                /* p-cli-type */
                                        , input buf_ord-doc.cli-code                /* p-cli-code */
                                        , input {&update}                           /* p-act      */
                                        , input p-new-status                        /* p-state    */
                                        , input integer({&severity-no-error})       /* p-err      */
                                        , input v-edist-mess                        /* p-des      */
                                        , input ''                                  /* p-mess     */
                                        , input integer({&doc-dm-edi})              /* p-dm */
                                        ).



  for each buf_ord-line exclusive-lock where
           buf_ord-line.doc-code   = buf_ord-doc.doc-code
  on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
  on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
  on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
  :
    /* Запомним то что запрашивали */
    assign
    buf_ord-line.initial-cli-qnty = (if buf_ord-line.initial-cli-qnty = 0
                                    and (buf_ord-doc.ord-int1 = integer({&edi-orders})
                                         or
                                         buf_ord-doc.ord-int1 = integer({&edi-orders-sts})
                                         )
                                    then buf_ord-line.cli-qnty
                                    else buf_ord-line.initial-cli-qnty)
    buf_ord-line.order-cli-qnty   = buf_ord-line.cli-qnty
    buf_ord-line.ord-dec1         = buf_ord-line.price-cli
    .
    v-b-str = ''.
    v-edist-mess = ''.
    RUN ordlineattr-value  IN THIS-PROCEDURE ( input  buf_ord-line.doc-code
                                              ,input  buf_ord-line.gds-code
                                              ,input  {&attr-order-ean13}
                                              ,output v-b-str
                                              ,output v-type
                                              ) NO-ERROR.
    find first buf_pos where
              buf_pos.number = entry(1, p-cli-out-doc, {&delim-par})
          and buf_pos.productidbuyer = string(buf_ord-line.gds-code)
          /*and buf_pos.productidsupplier = buf_ord-line.cli-art*/ no-error .
    if available buf_pos then do:
      /*найдем разницу*/
      if buf_ord-line.ord-dec1 < buf_pos.price then do:
         v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_price-up}, string(buf_ord-line.ord-dec1) + {&delim-par} + string(buf_pos.price) ).
      end.
      if buf_ord-line.ord-dec1 > buf_pos.price then do:
         v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_price-down}, string(buf_ord-line.ord-dec1) + {&delim-par} + string(buf_pos.price) ).
      end.
      if buf_ord-line.cli-qnty < buf_pos.acceptedquantity then do:
         v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_qnty-up}, string(buf_ord-line.order-cli-qnty) + {&delim-par} + string(buf_pos.acceptedquantity) ).
      end.
      if buf_ord-line.cli-qnty > buf_pos.acceptedquantity then do:
         v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_qnty-down}, string(buf_ord-line.order-cli-qnty) + {&delim-par} + string(buf_pos.acceptedquantity) ).
      end.
      if buf_ord-line.vat-pc <> buf_pos.vat then do:
         v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_vat-change}, string(buf_ord-line.vat-pc) + {&delim-par} + string(buf_pos.vat) ).
      end.
      if v-b-str <> buf_pos.product then do:
         v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_bstr-change}, string(v-b-str) + {&delim-par} + string(buf_pos.product) ).
      end.
      if buf_pos.info <> '' then do:
        v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, buf_pos.info).
      end.
      /* Исправим по принятым */
      &scop edi-line-ordrsp-code string(buf_pos.producttype)
      assign
      buf_ord-line.cli-qnty         = (if buf_pos.producttype = integer({&edi-line-ordrsp-cancel})
                                       then 0
                                       else buf_pos.acceptedquantity
                                       )
      buf_ord-line.price-cli        = buf_pos.price
      buf_ord-line.ord-dec2         = buf_ord-line.cli-qnty
      buf_ord-line.ord-dec3         = buf_ord-line.price-cli
      buf_ord-line.sub-par          = (if buf_pos.producttype <> integer({&edi-line-ordrsp-ok})
                                      then ({&edi-line-ordrsp-name} + {&space-char} + buf_pos.info + {&delim-par})
                                      else (buf_pos.info + {&delim-par}))
      buf_ord-line.price-rubl       = buf_ord-line.price-cli * buf_ord-doc.exch-rate / buf_ord-doc.exch-scale / buf_ord-line.cli-base-rate
      buf_ord-line.qnty             = buf_ord-line.cli-qnty  * buf_ord-line.cli-base-rate
      buf_ord-line.price-base       = buf_ord-line.price-rubl / buf_ord-doc.base-rate * buf_ord-doc.base-scale
      buf_ord-line.sum-rubl         = buf_ord-line.price-rubl * buf_ord-line.qnty
      buf_ord-line.sum-base         = buf_ord-line.price-base * buf_ord-line.qnty
      buf_ord-line.sum-cli          = buf_ord-line.price-cli  * buf_ord-line.cli-qnty
      buf_ord-line.ord-int1         = buf_pos.producttype
      .
      v-found = (buf_ord-line.cli-qnty <> 0).
    end. /*if available temp-ord-line then do:*/
    else do:
      v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps}, "Строка удалена Поставщиком").
      /* А этого нет в принятом */
      assign
      buf_ord-line.cli-qnty         = 0
      buf_ord-line.price-cli        = buf_ord-line.ord-dec1
      buf_ord-line.sub-par          = "Строка удалена Поставщиком"
      buf_ord-line.price-rubl       = buf_ord-line.price-cli * buf_ord-doc.exch-rate / buf_ord-doc.exch-scale / buf_ord-line.cli-base-rate
      buf_ord-line.qnty             = buf_ord-line.cli-qnty  * buf_ord-line.cli-base-rate
      buf_ord-line.price-base       = buf_ord-line.price-rubl / buf_ord-doc.base-rate * buf_ord-doc.base-scale
      buf_ord-line.sum-rubl         = buf_ord-line.price-rubl * buf_ord-line.qnty
      buf_ord-line.sum-base         = buf_ord-line.price-base * buf_ord-line.qnty
      buf_ord-line.sum-cli          = buf_ord-line.price-cli  * buf_ord-line.cli-qnty
      buf_ord-line.ord-int1         = integer({&edi-line-ordrsp-cancel})
      .
    end. /*else if available temp-ord-line then do:*/
    run create-edi-statett in this-procedure (
                                            input {&table_ord-line}                   /* p-tbl-name */
                                          , input (buf_ord-line.doc-code  + {&delim-par}
                                                  + string(buf_ord-line.gds-code))    /* p-doc-code */
                                          , input buf_ord-doc.cli-type                /* p-cli-type */
                                          , input buf_ord-doc.cli-code                /* p-cli-code */
                                          , input {&update}                           /* p-act      */
                                          , input buf_ord-doc.ord-int1                /* p-state    */
                                          , input (if buf_ord-line.ord-int1 = integer({&edi-line-ordrsp-ok})
                                                   then integer({&severity-no-error})
                                                   else  (if buf_ord-line.ord-int1 = integer({&edi-line-ordrsp-diff})
                                                          then integer({&severity-low})
                                                          else integer({&severity-extreme})
                                                         )
                                                   )                                  /* p-err      */
                                          , input v-edist-mess                        /* p-des      */
                                          , input ''                                  /* p-mess     */
                                          , input integer({&doc-dm-edi})              /* p-dm */
                                          ).

  end. /*for each buf_ord-line exclusive-lock where*/
   if not v-found then do:
     p-new-status = integer({&edi-err}).
   end.
   v-found = no.
   /* Проверка на лишние строки */
   for each buf_pos  where
           buf_pos.number = entry(1, p-cli-out-doc, {&delim-par})
   on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
   on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
   on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
   :
      find first buf_ord-line  no-lock  where
              buf_ord-line.doc-code = p-doc-code
         and  buf_ord-line.gds-code = integer(buf_pos.productidbuyer)
         /*and  buf_ord-line.cli-art  = buf_pos.productidsupplier*/    no-error .
     if not available buf_ord-line then do:
       v-found = yes.
       p-new-status  = ? . /* нельзя принимать пакет!*/
       v-edist-mess = ''.
       v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps},
                                          substitute("? Арт.Поставщика &1, АртикулТН &2, &3, Количество &4, Цена &5 ;"
                                                    ,buf_pos.productidsupplier
                                                    ,buf_pos.productidbuyer
                                                    ,buf_pos.description
                                                    ,buf_pos.acceptedquantity
                                                    ,buf_pos.price)).
       run create-edi-statett in this-procedure (
                                              input {&table_ord-doc}                    /* p-tbl-name */
                                            , input (p-doc-code + {&delim-par} + string( - buf_pos.positionnumber))  /* p-doc-code */
                                            , input buf_ord-doc.cli-type                /* p-cli-type */
                                            , input buf_ord-doc.cli-code                /* p-cli-code */
                                            , input {&update}                           /* p-act      */
                                            , input buf_ord-doc.ord-int1                /* p-state    */
                                            , input integer({&severity-extreme})        /* p-err      */
                                            , input v-edist-mess                        /* p-des      */
                                            , input ''                                  /* p-mess     */
                                            , input integer({&doc-dm-edi})              /* p-dm */
                                            ).
     end. /*if not available buf_ord-line then do:*/
   end. /*   for each buf_pos  where */
   if v-found then do:
      p-new-status = ?.
      v-edist-mess = ''.
      v-edist-mess = cr-edist_add-edist-mess( v-edist-mess, {&edist_ps},
                                             "Пришли товары, неуказанные в заказе").
      run create-edi-statett in this-procedure (
                                            input {&table_ord-doc}                    /* p-tbl-name */
                                          , input buf_ord-doc.doc-code                /* p-doc-code */
                                          , input buf_ord-doc.cli-type                /* p-cli-type */
                                          , input buf_ord-doc.cli-code                /* p-cli-code */
                                          , input {&update}                           /* p-act      */
                                          , input -1                                  /* p-state    */
                                          , input integer({&severity-extreme})        /* p-err      */
                                          , input v-edist-mess                        /* p-des      */
                                          , input ''                                  /* p-mess     */
                                          , input integer({&doc-dm-edi})              /* p-dm */
                                          ).
     return cr-edist_get-mess-mean(input v-edist-mess).
   end.
   if p-new-status <> ? then do:
    assign
    buf_ord-doc.ord-int1  =  p-new-status
    buf_ord-doc.cli-out-doc = p-cli-out-doc
    buf_ord-doc.ship-date = p-ship-date
    .
   end.
 end.

end procedure. /* proc-edi-reply-process */

&endif

/* $Workfile$ e n d */