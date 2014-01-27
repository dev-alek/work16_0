/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление всех persistent процедур

Автор: Перваков Михаил Сергеевич
Дата создания: 09/20/02
Author: Mikhail Pervakov
Creation date: 09/20/02

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Удаление всех persistent процедур".
{ cmp/vssrevis.i }

run utl/ttp.p ( input "utl/del-pers.p").
do while valid-handle( session :first-procedure)
on error undo, return error
:
  define variable v-procedure-handle as handle    no-undo .
  assign
    v-procedure-handle = session :first-procedure
  .
  apply 'delete':u to v-procedure-handle .
  delete procedure v-procedure-handle .
end.
run utl/ttq.p ( input "utl/del-pers.p").
run utl/tto.p ( input "utl/del-pers.p").