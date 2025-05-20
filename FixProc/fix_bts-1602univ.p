/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-1602. Исправляет код товара у марки УПД.

Автор: Ростовцев А.М.
Дата создания: 30.04.2025
Author: 
Creation date: 

*/


{ utl/runpro.i }
define input parameter parparentproc    as widget-handle no-undo .
define input parameter iUtdNumber       as character     no-undo .

on write of utd-marking-lines override do: end.


define buffer utd               for ub.utd .
define buffer utd-lines         for ub.utd-lines .
define buffer utd-marking-lines for ub.utd-marking-lines .

{ cmp/str-glbl.i }
{ gbl/getcntxt.i def }

if num-entries(iUtdNumber,"_") <> 2 then
do:
  message 
    "Не верно введен номер УПД." skip
    "Необходимо вводить внутренний номер УПД в формате <номер БД>_<id документа в ТН>."
    view-as alert-box.
  return.  
end.


find first utd where
           utd.db-num  = integer(entry(1,iUtdNumber,"_"))  
       and utd.doc-id  = integer(entry(2,iUtdNumber,"_"))
     no-lock no-error.

if not avail utd then do:
  message 
    "УПД с внутренним номером" iUtdNumber "не найдена!"
    view-as alert-box.
  return.  
end.

for each utd-lines no-lock where
         utd-lines.db-num = utd.db-num
     and utd-lines.doc-id = utd.doc-id
    :

  for each utd-marking-lines where
           utd-marking-lines.db-num = utd.db-num
       and utd-marking-lines.doc-id = utd.doc-id
       and utd-marking-lines.LineNum = utd-lines.LineNum
      :
    if utd-lines.gds-code <> utd-marking-lines.gds-code then
    do:
      utd-marking-lines.gds-code = utd-lines.gds-code.
    end.
  end.
end.

message 
  "Успешно!" 
  view-as alert-box .

