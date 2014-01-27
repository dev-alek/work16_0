/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск импорта по ДК

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/16/07
Author: Bakhtadze Natalya
Creation date: 04/16/07

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск импорта по ДК".
{ cmp/vssrevis.i }

run str/diallog.w (
      input parParentProc
    , input this-procedure
    , input "utl/imp-dcrd.w":U
    , input '':U /*parameter*/
    , input no /*p-auto-go*/
    , input "&Стоп"
    , input substitute("Импорт данных по ДК")
) no-error.

