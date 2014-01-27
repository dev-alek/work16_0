/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборот приходных партий товаров поставщика

Автор: Чернова Светлана Александровна
Дата создания: 09/09/05
Author: Svetlana Chernova
Creation date: 09/09/05

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Оборот приходных партий товаров поставщика".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/e-prpost.w","Оборот приходных партий товаров поставщика",
input                        2,
input                        "*",
input                        "*",
input                        "",
input                        "{&v-RUBL},{&v-base}",
input                        "all,{&Arc-supp-yes},{&Arc-stk-yes},{&format-folder}",
input                        no).