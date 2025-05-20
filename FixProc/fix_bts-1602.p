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

on write of utd-marking-lines override do: end.


define buffer utd-lines         for ub.utd-lines .
define buffer utd-marking-lines for ub.utd-marking-lines .

{ cmp/str-glbl.i }
{ gbl/getcntxt.i def }

for each utd-lines no-lock where
         utd-lines.db-num = 19
     and utd-lines.doc-id = 954
    :

  for each utd-marking-lines where
           utd-marking-lines.db-num = 19
       and utd-marking-lines.doc-id = 954
       and utd-marking-lines.LineNum = utd-lines.LineNum
      :
    if utd-lines.gds-code <> utd-marking-lines.gds-code then
      utd-marking-lines.gds-code = utd-lines.gds-code.
  end.
end.

message 
  "Успешно!" 
  view-as alert-box .

