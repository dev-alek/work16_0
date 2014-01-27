/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса по типу приобретени

Автор: Чернова Светлана Александровна
Дата создания: 09/13/05
Author: Svetlana Chernova
Creation date: 09/13/05

11/22/02 12:05

*/
define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Состояние запаса по типу приобретени     ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/etpzapas.w',"Состояние запаса по типу приобретения", 1 ,
    "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":U,
    "*",
    "{&p-cost},{&p-crsa}" ,
    "{&v-RUBL},{&v-base}",
    "all,{&Excel-yes},{&Arc-aht-yes},{&format-folder}", no)
    .