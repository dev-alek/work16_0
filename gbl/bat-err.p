/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запись ошибки в файл на диске для обмена между приложениями

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/01/06
Author: Bakhtadze Natalya
Creation date: 04/01/06

*/

define input parameter p-file      as character no-undo .
define input parameter p-is-err    as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запись ошибки в файл на диске".
{ cmp/vssrevis.i }

OS-DELETE value(p-file).
output to value(p-file).
PUT UNFORMATTED p-is-err SKIP.
output close.