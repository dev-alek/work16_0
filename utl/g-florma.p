/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Формирование внешних приходов из внешних расходов

Автор: Чернова Светлана Александровна
Дата создания: 03/30/10
Author: Svetlana Chernova
Creation date: 03/30/10

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Формирование внешних приходов из внешних расходов".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w
  ( input parParentProc ,
    input 'utl/r-florma.p',
    input "Генерация ПН по РН",
    input 2 ,
    input "":U,
    input "*",
    input "" ,
    input "",
    input "all,{&customer-yes}",
    yes ) no-error .
    if error-status :error then
    message
      vss-workfile vss-revision vss-description skip
      error-status :get-message(1) skip
      return-value skip
      "Ошибка вызова"
      view-as alert-box error
    .