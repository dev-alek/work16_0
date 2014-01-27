/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Ручной толкатель отчета Реализация и остатки (Кедр)

Автор: Хныкин Павел Андреевич
Дата создания: 04/16/09
Author: Pavel Khnykin
Creation date: 04/16/09

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$date: $":u .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Ручной толкатель отчета Реализация и остатки (Кедр)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i  }


do
on error undo, return error return-value
:
  run rep/r-kfreba.p ( input my-handle
                     , input no
                     , input ?
                     , input ?
                     ).
end.