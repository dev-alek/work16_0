/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборотная ведомость по покупателям

Автор: Комаров Иван Сергеевич
Дата создания: 11/26/09
Author: Ivan Komarov
Creation date: 11/26/09

*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Оборотная ведомость по поставшикам ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/e-obcntr.w","Оборотная ведомость по покупателям",
input                        2,
input                        "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod},{&g-spis}",
input                        "*":U,
input                        "{&p-cost},{&p-sale}",
input                        "{&v-RUBL},{&v-base}",
input                        "all,{&Excel-yes},{&customer-yes},{&Arc-OT-yes}",
input                        no).