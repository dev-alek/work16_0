/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-1650. Исправляет тип НДС у документа.

Автор: Ростовцев А.М.
Дата создания: 30.04.2025
Author: 
Creation date: 

*/


{ utl/runpro.i }
define input parameter parparentproc    as widget-handle no-undo .
define input parameter iDocCode         as character     no-undo .
define input parameter iType            as character     no-undo .

on write of ub.trn-doc override do: end.


define buffer trn-doc for ub.trn-doc .

{ cmp/str-glbl.i }
{ gbl/getcntxt.i def }

find first trn-doc where
           trn-doc.doc-code  = iDocCode  
     no-lock no-error.

if not avail trn-doc then do:
  message 
    "Документ с номером" iDocCode "не найден!"
    view-as alert-box.
  return.  
end.

for first trn-doc where
          trn-doc.doc-code  = iDocCode
    exclusive-lock:
  trn-doc.slt-type = iType. 
end.

message 
  "Успешно!" 
  view-as alert-box .

