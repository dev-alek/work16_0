/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Выбор клиента

Автор: Перваков Михаил Сергеевич
Дата создания: 04/11/06
Author: Mikhail Pervakov
Creation date: 04/11/06

*/

define input parameter parparentproc as widget-handle no-undo .
define input-output parameter p-supp-type like ub.parts.supp-type no-undo .
define input-output parameter p-supp-code like ub.parts.supp-code no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Выбор клиента".
{ cmp/vssrevis.i }


/*  c-types = {&cmp}.  */

def var ref-list as character no-undo .
define variable v-ref-rec as recid no-undo .

find first clients no-lock
  where clients.obj-type = p-supp-type
    and clients.obj-code = p-supp-code
  no-error .
if available clients then do:
  assign
    v-ref-rec = recid(clients)
  .
end.

run ref/cli-all.w
  ( parparentproc
    , input  "b-sel"
    , ?
    , ?
    , ?
    , v-ref-rec
    , ?
    , ?
  ,output ref-list
  ).

if ref-list <> "" then do:
  v-ref-rec = integer (ref-list).
  find clients no-lock
    where recid (clients) = v-ref-rec
    no-error .
  if available clients then do:
    assign
      p-supp-type = clients.obj-type
      p-supp-code = clients.obj-code
    .
    return .
  end.
end.

return error .