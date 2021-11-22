/*

$Revision: $
$Author: $
$Date: $
$Workfile: $
$Archive: $

Список кассовых документов

Автор: Рукавишников Вадим
Дата создания: 27/01/21
Author: Rukavishnikov Vadim
Creation date: 27/01/21

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Список кассовых документов".
{cmp/vssrevis.i}
{cmp/str-glbl.i}
{cmp/r-page1.i new}

run rep/d-report.w
  ( input parParentProc,
    input "rep/e-fin-doc-list.w",
    input "Список кассовых документов",
    input 4,
    input "",
    input "{&o-firm},{&o-currency},{&o-choice}",
    input "",
    input "",
    input "all,{&Excel-yes}",
    no ) no-error .
    if error-status:error then
    message
      vss-workfile vss-revision vss-description skip
      error-status:get-message(1) skip
      return-value skip
      "Ошибка вызова"
      view-as alert-box error
    .
