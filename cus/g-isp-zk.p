/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет об исполнении заказов

Автор: Кочетков Михаил Юрьевич
Дата создания: 03/27/06
Author: Michael Kochetkov
Creation date: 03/27/06

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет об исполнении заказов".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w (
  input   parParentProc ,
  input   "cus/e-isp-zk.w",
  input   "Отчет об исполнении заказов",
  input   2 ,
  input   "{&g-all},{&g-choice},{&g-one}":U,
  input   "{&o-firm},{&o-currency},{&o-choice},{&o-all}":U,
  input   "" ,
  input   "{&v-rubl},{&v-base}",
  input   "all,{&Excel-yes}",
  input   no ) .