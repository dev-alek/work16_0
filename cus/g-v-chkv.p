/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возврат товара

Автор: Чернова Светлана Александровна
Дата создания: 10/20/05
Author: Svetlana Chernova
Creation date: 10/20/05


*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Возврат товара".
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW }
run rep/d-report.w (
input  parParentProc ,
input  "cus/r-a-chkv.p {&rcpt-return}",
input  "Возврат товара",
input  2,
input  "":U,
input  "{&o-currency},{&o-choice}":U,
input  "",
input  "{&v-base}",
input  "shop,{&Excel-yes}",
input  yes).