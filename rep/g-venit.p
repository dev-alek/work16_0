/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Специальный заказной отчет для закрытия финансового периода 01.2001 в компании Lukoil Romania

Автор: Суслов Алексей Юрьевич
Дата создания: 04/12/06
Author: Alexey Suslov
Creation date: 04/12/06


*/

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Специальный заказной отчет для закрытия финансового периода 01.2001 в компании Lukoil Romania".
{ cmp/vssrevis.i }
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
                input parParentProc ,
                input 'rep/e-venit.w',
                input "ПРОДАЖИ ЧЕРЕЗ КАССУ",
                input 5,
                input "{&g-grp}",
                input "{&o-currency},{&o-choice}",
                input "",
                input "",
                input "all",
                input no).