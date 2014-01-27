/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Инициализация фин. архива arh-trn-doc-contract

Автор: Кочетков Михаил Юрьевич
Дата создания: 07/05/07
Author: Michael Kochetkov
Creation date: 07/05/07

*/
define input  parameter parParentProc as handle    no-undo .

{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

run rep/d-report.w
    ( input parParentProc ,
      input 'initcont.p',
      "Инициализация фин. архива arh-trn-doc-contract",
      1,
      "":U,
      "*",
      "",
      "",
      "",
      yes).