/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборотка по типу приобретениЯ (ТПСИ)

Автор: Чернова Светлана Александровна
Дата создания: 09/16/05
Author: Svetlana Chernova
Creation date: 09/16/05

Creation date: 11/20/02 2:40

*/
define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Оборотка по типу приобретения (ТПСИ)    ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW }


run rep/d-report.w (
    input parParentProc ,
    input "rep/e-otpsy.w","Оборотная ведомость - ТПСИ",
    input 2,
    input "*":u,
    input "{&o-firm},{&o-currency},{&o-choice}":u,
    input "",
    input "{&v-rubl},{&v-base}",
    input "all,{&Arc-aht-yes},{&excel-yes},{&show-sale},{&show-crsa},{&show-cost},{&format-folder}",
    input no).