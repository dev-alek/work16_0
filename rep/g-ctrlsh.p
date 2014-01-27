/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

√лавна€ программа запуска отчета r-ctrlsh.p из меню

јвтор: ”ханов ƒмитрий ёрьевич
ƒата создани€: 11/08/10
Author: Dmitry Ukhanov
Creation date: 11/08/10

*/

define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "√лавна€ программа запуска отчета r-ctrlsh.p из меню".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }
&scop tt-l "  ќЌ“–ќЋ№Ќјя ¬≈ƒќћќ—“№ ƒ¬»∆≈Ќ»я Ќѕ"
run rep/d-report.w (
                input parParentProc ,
                input 'rep/e-ctrlsh.p',
                {&tt-l},
                input 4,
                input "{&g-one},{&g-choice}",
                input "{&o-currency},{&o-choice}",
                input "",
                input "",
                input "all,{&Excel-yes}",
                input yes).