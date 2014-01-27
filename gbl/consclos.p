/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Закрыть консольное окно приложени

Автор: Перваков Михаил Сергеевич
Дата создания: 02/08/06
Author: Mikhail Pervakov
Creation date: 02/08/06

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

define variable v-result                as integer   no-undo .

do
on error undo, return error return-value
:
  run FreeConsole
    (output v-result
    ) .

end.

PROCEDURE FreeConsole EXTERNAL "kernel32.dll"
:
   DEFINE RETURN PARAMETER RetParam  AS LONG .
END PROCEDURE .