/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса

Автор: Чернова Светлана Александровна
Дата создания: 09/09/05
Author: Svetlana Chernova
Creation date: 09/09/05

Created: 20/10/00

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Состояние запаса".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w
  ( input parParentProc ,
    input 'rep/e-zapas.w',
    input "Состояние запаса",
    input 1 ,
    input "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":U,
    input "*",
    input "{&p-cost},{&p-crsa}" ,
    input "{&v-RUBL},{&v-base}",
    input "all,{&Excel-yes},{&Arc-stk-yes},{&format-folder},X-SET_PAY_TYPE=2",
    no ) no-error .
    if error-status :error then
    message
      vss-workfile vss-revision vss-description skip
      error-status :get-message(1) skip
      return-value skip
      "Ошибка вызова"
      view-as alert-box error
    .