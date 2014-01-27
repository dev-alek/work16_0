/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса по объектам

Автор: Демин Алексей Сергеевич
Дата создания: 03/27/06
Author: Alexey Demin
Creation date: 03/27/06

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Состояние запаса по объектам".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}

run rep/d-report.w
(
input parParentProc ,
'rep/e-bent55.w',
"Состояние запаса по объектам",
 1,
"*":U,
"*":U,
"{&p-cost},{&p-crsa}" ,
"{&v-RUBL},{&v-base}",
"all,{&Arc-stk-yes},{&Excel-yes}",no).