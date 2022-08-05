/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Восстановление удаленного чека

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/16/06
Author: Bakhtadze Natalya
Creation date: 09/16/06

*/

define input parameter p-doc-code like ub.c-chk-doc.doc-code no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Восстановление удаленного чека".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }

define variable v-obj-db-num as integer no-undo .

define buffer buf_c-chk-doc for ub.c-chk-doc.
define buffer buf_c-chk-gds for ub.c-chk-gds.
define buffer buf_c-chk-pay for ub.c-chk-pay.
define buffer buf_c-chk-discnt for ub.c-chk-discnt.
define buffer buf_c-chk-doc-attr for ub.c-chk-doc-attr.
define buffer buf2_c-chk-doc for ub.c-chk-doc.
define buffer buf2_c-chk-gds for ub.c-chk-gds.
define buffer buf2_c-chk-pay for ub.c-chk-pay.
define buffer buf2_c-chk-discnt for ub.c-chk-discnt.
define buffer buf2_c-chk-doc-attr for ub.c-chk-doc-attr.
define buffer buf_chk-doc for ub.chk-doc.
define buffer buf_chk-gds for ub.chk-gds.
define buffer buf_chk-pay for ub.chk-pay.
define buffer buf_chk-discnt for ub.chk-discnt.
define buffer buf_chk-doc-attr for ub.chk-doc-attr.




main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:


  find last buf_c-chk-doc exclusive-lock where
          buf_c-chk-doc.doc-code = p-doc-code use-index pi.
  if buf_c-chk-doc.is-del = no then do:
    undo main-block, return error substitute("Нельзя восстановить чек &1 по истории - чек не был удален", p-doc-code).
  end.
  { gbl/objdbnum.i buf_c-chk-doc.obj-type buf_c-chk-doc.obj-code v-obj-db-num }
  if v-obj-db-num <> g#db-num then do:
    undo main-block, return error substitute("Нельзя восстановить чек &1 по истории&2" +
                                              "чек объекта &3&4, принадлежащего БД &5" +
                                              "текущая БД - &6"
                                              , p-doc-code
                                              , {&new-line}
                                              , buf_c-chk-doc.obj-type
                                              , buf_c-chk-doc.obj-code
                                              , v-obj-db-num
                                              , g#db-num
                                              ).
  end.
  if buf_c-chk-doc.out-code <> '':U
  and buf_c-chk-doc.out-code <> ? then do:
     undo main-block, return error substitute("Нельзя восстановить чек &1 по истории&2" +
                                               "в выбранном срезе истории &3 чек привязан к документу продажи"
                                               , buf_c-chk-doc.doc-code
                                               , {&new-line}
                                               , buf_c-chk-doc.chip-num).
  end.

  FIND  buf_chk-doc where
        buf_chk-doc.obj-type = buf_c-chk-doc.obj-type
    and buf_chk-doc.obj-code = buf_c-chk-doc.obj-code
    and buf_chk-doc.chk-date = buf_c-chk-doc.chk-date
    and buf_chk-doc.pay-desk = buf_c-chk-doc.pay-desk
    and buf_chk-doc.chk-time = buf_c-chk-doc.chk-time
    and buf_chk-doc.chk-num = buf_c-chk-doc.chk-num
    and buf_chk-doc.sales-man = buf_c-chk-doc.sales-man NO-ERROR NO-WAIT.
   IF NOT AVAIL buf_chk-doc
   AND NOT LOCKED buf_chk-doc  AND NOT AMBIGUOUS buf_chk-doc then do:
     create buf_chk-doc.
     buffer-copy buf_c-chk-doc to buf_chk-doc.
     create buf2_c-chk-doc.
     buffer-copy buf_c-chk-doc
     except is-del chip-num
     to buf2_c-chk-doc
     assign
     buf2_c-chk-doc.is-del = ?
     buf2_c-chk-doc.chip-num = buf_c-chk-doc.chip-num + 1
     .
     for each buf_c-chk-gds no-lock where
            buf_c-chk-gds.doc-code = buf_c-chk-doc.doc-code
        and buf_c-chk-gds.chip-num = buf_c-chk-doc.chip-num
     on error undo main-block, return error:
       create buf_chk-gds.
       buffer-copy buf_c-chk-gds to buf_chk-gds
       assign
         buf_chk-gds.depart-type = ""
         buf_chk-gds.depart-code = 0
       .
       create buf2_c-chk-gds.
       buffer-copy buf_c-chk-gds
       except chip-num to buf2_c-chk-gds
       assign
       buf2_c-chk-gds.chip-num = buf2_c-chk-doc.chip-num
       buf2_c-chk-gds.depart-type = ""
       buf2_c-chk-gds.depart-code = 0
       .
     end.
     for each buf_c-chk-discnt no-lock where
            buf_c-chk-discnt.doc-code = buf_c-chk-doc.doc-code
        and buf_c-chk-discnt.chip-num = buf_c-chk-doc.chip-num
     on error undo main-block, return error:
       create buf_chk-discnt.
       buffer-copy buf_c-chk-discnt to buf_chk-discnt.
       create buf2_c-chk-discnt.
       buffer-copy buf_c-chk-discnt
       except chip-num to buf2_c-chk-discnt
       assign
       buf2_c-chk-discnt.chip-num = buf2_c-chk-doc.chip-num
       .
     end.
     for each buf_c-chk-pay no-lock where
            buf_c-chk-pay.doc-code = buf_c-chk-doc.doc-code
        and buf_c-chk-pay.chip-num = buf_c-chk-doc.chip-num
     on error undo main-block, return error:
       create buf_chk-pay.
       buffer-copy buf_c-chk-pay to buf_chk-pay.
       create buf2_c-chk-pay.
       buffer-copy buf_c-chk-pay
       except chip-num to buf2_c-chk-pay
       assign
       buf2_c-chk-pay.chip-num = buf2_c-chk-doc.chip-num
       .
     end.
     for each buf_c-chk-doc-attr no-lock where
            buf_c-chk-doc-attr.doc-code = buf_c-chk-doc.doc-code
        and buf_c-chk-doc-attr.chip-num = buf_c-chk-doc.chip-num
     on error undo main-block, return error:
       create buf_chk-doc-attr.
       buffer-copy buf_c-chk-doc-attr to buf_chk-doc-attr.
       create buf2_c-chk-doc-attr.
       buffer-copy buf_c-chk-doc-attr
       except chip-num to buf2_c-chk-doc-attr
       assign
       buf2_c-chk-doc-attr.chip-num = buf2_c-chk-doc.chip-num
       .
     end.
   end.
   else do:
     undo main-block, return error substitute("Нельзя восстановить чек &1 по истории&2" +
                             "такой чек уже существует либо проверка его отсутствия не удалась"
                             , p-doc-code
                             , {&new-line}).
   end.




end. /*doe*/