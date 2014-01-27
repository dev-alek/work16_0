/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет о выполнении РЦ заказов на товары

Автор: Чернова Светлана Александровна
Дата создания: 04/20/06
Author: Svetlana Chernova
Creation date: 04/20/06

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет о выполнении РЦ заказов на товары".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/r-page1.i new }

run rep/d-report.w
( input parparentproc ,
  input "cus/e-ordrc1.w" ,
  input "Отчет о выполнении РЦ заказов на товары" ,
  input 2 ,
  input "{&g-all},{&g-choice},{&g-one},{&g-grp-prod}":U ,
  input "{&o-all},{&o-choice},{&o-firm}" ,
  input ""  ,
  input ""  ,
  input "all,{&Excel-yes}" ,
  input no ) .