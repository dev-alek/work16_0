/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по оплате заказов по нетоварным позициям

Автор: Чернова Светлана Александровна
Дата создания: 03/03/06
Author: Svetlana Chernova
Creation date: 03/03/06

Дата создания: 01/21/05
*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по оплате заказов по нетоварным позициям".
{ cmp/vssrevis.i }
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/r-flor3.p',"Отчет по оплате заказов по нетоварным позициям",2,
    "":U,
    "*",
    "" ,
    "",
    "all,{&Excel-yes}", yes).