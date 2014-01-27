/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Проверка видимости кнопок

Автор: Белоусов Илья Александрович
Дата создания: 07/10/08
Author: Ilia Belousov
Creation date: 07/10/08

Input:

Output:

*/
define input  parameter p-func-name as character        no-undo.
define output parameter p-enable    as logical          no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Проверка видимости кнопок".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
do
on error undo, return error
:
   /* !!! */
   assign
      p-enable = TRUE
   .

end.