/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет о комиссионном вознаграждении Оборотная ведомость по товарам, принятым на комиссию

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 03/26/03 4:00

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Оборотная ведомость по товарам, принятым на комиссию".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW }

run rep/d-report.w
(   input parParentProc ,
    input "rep/t-comiss.w",
    input "Оборотная ведомость по товарам, принятым на комиссию",
    input 2,
    input "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":u,
    input "*":u,
    input "",
    input "{&v-rubl},{&v-base}",
    input "all,{&Arc-aht-yes},{&excel-yes},{&show-sale},{&show-crsa},{&show-cost},{&format-folder},name-sale=Комиссия",
    input false ).