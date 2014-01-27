/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление события на кассе

Автор: Белоусов Илья Александрович
Дата создания: 12/05/08
Author: Ilia Belousov
Creation date: 12/05/08

Input:

Output:

*/
define input  parameter parparentproc  as widget-handle  no-undo .
define input  parameter p-version      as integer          no-undo.
define input  parameter p-id           as integer          no-undo.
define output parameter p-ok           as logical        no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Удаление события на кассе".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }

do
TRANSACTION
on error undo, return error
:
   define buffer buf_cd-events      for ub.cd-events .

   FIND FIRST buf_cd-events
        WHERE buf_cd-events.event-id = p-id
          AND buf_cd-events.version  = p-version
        EXCLUSIVE-LOCK
        .
   DELETE buf_cd-events.
   ASSIGN
      p-ok = TRUE
   .
end.