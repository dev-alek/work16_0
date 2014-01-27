/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вызов старого отчета "Отчет по расходу товара"

Автор: Чернова Светлана Александровна
Дата создания: 09/07/05
Author: Svetlana Chernova
Creation date: 09/07/05

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "    ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
define input  parameter parParentProc  as widget-handle no-undo.
run cus/xl-inout.w (parParentProc , {&expense}) .