/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

"Планируемые платежи"

Автор: Демин Алексей Сергеевич
Дата создания: 03/24/06
Author: Alexey Demin
Creation date: 03/24/06

*/
define input  parameter parParentProc as handle    no-undo .

{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

run rep/d-report.w
    ( input parParentProc ,
      input 'rep/e-plnsch.w',
      "Планируемые платежи на дату",
      1,
      "":U,
      "",
      "",
      "{&v-rubl},{&v-base}",
      "{&customer-yes}",
      no).