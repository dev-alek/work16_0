/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Очистка истории по архиву

Автор: Белоусов Илья Александрович
Дата создания: 07/16/07
Author: Ilia Belousov
Creation date: 07/16/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 04/01/04

*/

define input  parameter p-obj-type              as character no-undo .
define input  parameter p-obj-code              as integer   no-undo .
define input  parameter p-archive-type          as character no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Очистка истории по архиву".
{ cmp/vssrevis.i "substitute('&1|&2|&3':u,p-obj-type,p-obj-code,p-archive-type)" }
{ cmp/trg-def.i  }

define buffer buf_archive-history for ub.archive-history .

do
on error undo, return error return-value
:

  for each buf_archive-history exclusive-lock
    where buf_archive-history.obj-type     = p-obj-type
      and buf_archive-history.obj-code     = p-obj-code
      and buf_archive-history.archive-type = p-archive-type
  on error undo, return error return-value
  :
    delete buf_archive-history .
  end.
end.