/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-1934. Проставляет номер карты лояльности у чеков за смену из истории.

Автор: Ростовцев А.М.
Дата создания: 16.09.2025
Author: 
Creation date: 

*/

{ utl/runpro.i }
define input parameter iShiftDate as character no-undo.
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }

define buffer c-chk-doc for ub.c-chk-doc.
define buffer chk-doc for ub.chk-doc.
define buffer c-chk-discnt for ub.c-chk-discnt.
define buffer chk-discnt for ub.chk-discnt.

define variable vShiftDate as date no-undo.

define variable vCount as int no-undo.

vShiftDate =  date(iShiftDate) no-error.
if error-status:error then
do:
  message "Не верно задана дата" view-as alert-box.
  return. 
end.

for each c-chk-doc where
         c-chk-doc.shift-date = vShiftDate
    no-lock,
    first chk-doc where 
          chk-doc.obj-type = c-chk-doc.obj-type      
      and chk-doc.obj-code = c-chk-doc.obj-code      
      and chk-doc.chk-type = c-chk-doc.chk-type 
      and chk-doc.chk-num  = c-chk-doc.chk-num 
      and chk-doc.pay-desk  = c-chk-doc.pay-desk 
      and chk-doc.shift-date = c-chk-doc.shift-date 
      and chk-doc.shift-num  = c-chk-doc.shift-num 
    exclusive-lock
    :
   if c-chk-doc.d-card <> "" /*and chk-doc.d-card = "" закомментил, чтобы отрабатывала при повторном запуске */ 
   then do:
     assign
       chk-doc.d-card     = c-chk-doc.d-card
       chk-doc.src-d-card = c-chk-doc.src-d-card
       vCount = vCount + 1
     .
     /* восстановим информацию о начисленных бонусах для секции <chk-bonus-ps> */
     for each c-chk-discnt no-lock
        where c-chk-discnt.doc-code    = c-chk-doc.doc-code
          and c-chk-discnt.record-type = 4
          and c-chk-discnt.discnt-value-abs <> 0:
       find first chk-discnt no-lock
            where chk-discnt.doc-code = chk-doc.doc-code
              and chk-discnt.record-type = c-chk-discnt.record-type
              and chk-discnt.line-num = c-chk-discnt.line-num
              and chk-discnt.discnt-id = c-chk-discnt.discnt-id
              and chk-discnt.object-line-num = c-chk-discnt.object-line-num no-error.
       if not avail chk-discnt then
       do:
         create chk-discnt.
         buffer-copy c-chk-discnt except chip-num corr-user-db-num doc-code to chk-discnt
         assign
           chk-discnt.doc-code = chk-doc.doc-code.
       end.
     end.
   end. 
end.

MESSAGE substitute("Успешно.~nУстановлены номера карт лояльности у смены за &1 для &2",vShiftDate, vCount) skip
        "чеков и восстановлено начисление бонусов для секции <chk-bonus-ps>"
VIEW-AS ALERT-BOX.


