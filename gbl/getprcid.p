/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получить PID текущей сессии progress

Автор: Перваков Михаил Сергеевич
Дата создания: 03/06/06
Author: Mikhail Pervakov
Creation date: 03/06/06

*/

define output parameter p-process-id as integer   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Получить PID текущей сессии progress".
{ cmp/vssrevis.i }

do
on error undo, return error return-value
:
  run GetCurrentProcessID (output p-process-id) .
end.


PROCEDURE GetCurrentProcessId EXTERNAL "kernel32.dll" :
  DEFINE RETURN PARAMETER RetVal          AS LONG.
END PROCEDURE.