/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Справочник типов продукции

Автор: Молотков Сергей Михайлович
Дата создания: 05/16/18
Author: Molotkov Sergey
Creation date: 05/16/18

*/
define input parameter parparentproc as handle no-undo .
define input parameter p-mode as character no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Справочник типов продукции".
{ cmp/vssrevis.i }
/*{ cmp/showinf.i }*/
{ cmp/str-glbl.i }

if p-mode <> "update" then do:
  message substitute("Неверное значение параметра p-mode=&1 при вызове из меню", p-mode)
  view-as alert-box .
  return.
end.

  run bge/merq-ref-tnved.w (parparentproc, {&update}, "") .
