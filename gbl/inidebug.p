/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Программа запуска отладчика из сессии PROGRESS

Автор: Перваков Михаил Сергеевич
Дата создания: 07/16/07
Author: Mikhail Pervakov
Creation date: 07/16/07

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
/* { cmp/vssrevis.i } */

define variable v-test as integer no-undo .

DEBUGGER:INITIATE().
DEBUGGER:VISIBLE = TRUE.

DEBUGGER:SET-BREAK().
/* please continue execution */
assign
  v-test = v-test + 1
.