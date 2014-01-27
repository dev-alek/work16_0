/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получение имени клиента (для person)

Автор: Демин Алексей Сергеевич
Дата создания: 04/12/06
Author: Alexey Demin
Creation date: 04/12/06

Input:

Output:

*/
define input parameter p-psn-code      as integer      no-undo.
define output parameter p-obj-name     as character    no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Получение имени клиента (для person)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

    define buffer buf_clients       for clients.
do
for buf_clients
on error undo, return error
:
    find first buf_clients no-lock
         where buf_clients.obj-type = {&prs}
           and buf_clients.obj-code = p-psn-code
    no-error.
    if not available buf_clients
    then do:
        assign
            p-obj-name = "?"
        .
    end.
    else do:
        assign
            p-obj-name = buf_clients.obj-name
        .
    end.
end.


