/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сравнительный отчет по ценам товара на объектах

Автор: Кочетков Михаил Юрьевич
Дата создания: 03/27/06
Author: Michael Kochetkov
Creation date: 03/27/06

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Сравнительный отчет по ценам товара на объектах".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (  input parParentProc ,
input                       'cus/e-z-posr.w',
input                       'Сравнительный отчет по ценам товара на объектах',
input                        1,
input                        "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}",
input                        "*",
input                        "",
input                        "",
input                        "all",
input                        no).