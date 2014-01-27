/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по заказам РЦ

Автор: Чернова Светлана Александровна
Дата создания: 04/20/06
Author: Svetlana Chernova
Creation date: 04/20/06

*/

define input  parameter parParentProc  as widget-handle no-undo.
define input  parameter p-mode as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по заказам РЦ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i   new }

run rep/d-report.w
( input parparentproc ,
  input "cus/e-ordrc2.w" ,
  input (if p-mode = "RC":U then "2.ОТЧЕТ ПО ЗАКАЗАМ ОРЦ на РЦ" else "1.ОТЧЕТ ПО ЗАКАЗАМ ОРЦ на объекте") ,
  input 2 ,
  input "{&g-all},{&g-choice}":U ,
  input "{&o-currency}" ,
  input ""  ,
  input ""  ,
  input "all,{&Excel-yes}" ,
  input no ) .