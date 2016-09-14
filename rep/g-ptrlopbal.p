/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Контрольно-накопительная ведомость учета излишек и недостач НП. Главная программа запуска отчета r-ptrlopbal.p из меню

Автор: Гридчина Полина Дмитриевна
Дата создания: 20/12/2014
Author: Polina Gridchina
Creation date: 20/12/2014

*/
define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Главная программа запуска Контрольно-накопительная ведомость учета излишек и недостач НП".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
run rep/d-report.w (


                input parParentProc ,
                input 'rep/e-ptrlopbal.w',
                input "Контрольно-накопительная ведомость учета излишек и недостач НП",
                input 8,
                input "{&g-choice}",
                input "{&o-currency}",
                input "",
                input "",
                input "all,{&Excel-yes}",
                input no).