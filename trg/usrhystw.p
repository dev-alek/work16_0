/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на запись истории пользователя.

Автор: Белоусов Илья Александрович
Дата создания: 04/01/08
Author: Ilia Belousov
Creation date: 04/01/08

Input:

Output:

*/
TRIGGER PROCEDURE FOR WRITE OF ub.c-user-log.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Триггер на запись истории пользователя.".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }

do
on error undo, return error
:

end.