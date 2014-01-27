/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборотка по поставщикам по арх

Автор: Чернова Светлана Александровна
Дата создания: 05/06/08
Author: Svetlana Chernova
Creation date: 05/06/08

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Оборотка по поставщикам по арх".
{ cmp/vssrevis.i }
&glob fr-name "&framename='oborot':U"
&glob r-sort "&b3 = temp-t-post-stk-line.gds-name"         /* поле сортировки  */
{ rep/r-pstomn.i {&fr-name} {&r-sort} }
{ rep/r-pst-dp.i }