/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 


Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: Ruban Dmitriy
Creation date: 11/07/18

*/


&scoped-define main-tbl utd
trigger procedure for delete of ub.{&main-tbl}.

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo init "Тригер удаления {&main-tbl}". 
{ trg/trghistnws.i 
  &hist = yes 
  &seqnamehist = "s-c-utd-chip-num"
  &histheadtbl = "c-utd-head"
  &del  = yes
}

if not g#news 
then do:
  define variable v-list-db as char no-undo.
  if g#db-num = 0
  then do:
    find first ub.clients no-lock where ub.clients.obj-type = {&main-tbl}.obj-type and ub.clients.obj-code = {&main-tbl}.obj-code no-error.
     if avail  ub.clients
     then
        v-list-db = string (ub.clients.db-num).
  end.  
  else do:
    v-list-db = "0".
  end.
  run nws/cmd-del.p
      ( input {&table_utd}
      ,input (buffer {&main-tbl}:handle)
      ,input ""
      ) no-error .
  if error-status :error
  then do:
    return error substitute( "&1. Ошибка при отправке в новости команды на удаление записи. &2&3&2&4", vss-workfile, {&new-line}, return-value, error-status :get-message ( error-status :num-messages ) ).
  end.
end.

for each utd-err where {&main-tbl}-err.db-num eq  {&main-tbl}.db-num
                   and {&main-tbl}-err.doc-id eq  {&main-tbl}.doc-id
exclusive-lock:
   delete {&main-tbl}-err.
end.

for each {&main-tbl}-lines where {&main-tbl}-lines.db-num eq  {&main-tbl}.db-num
                             and {&main-tbl}-lines.doc-id eq  {&main-tbl}.doc-id
exclusive-lock:
   delete {&main-tbl}-lines.
end.

for each {&main-tbl}-marking-lines where {&main-tbl}-marking-lines.db-num eq  {&main-tbl}.db-num
                                     and {&main-tbl}-marking-lines.doc-id eq  {&main-tbl}.doc-id
exclusive-lock:
   delete {&main-tbl}-marking-lines.
end.

for each utd-err-attr where {&main-tbl}-err-attr.db-num eq  {&main-tbl}.db-num
                   and {&main-tbl}-err-attr.doc-id eq  {&main-tbl}.doc-id
exclusive-lock:
   delete {&main-tbl}-err-attr.
end.

for each {&main-tbl}-lines-attr where {&main-tbl}-lines-attr.db-num eq  {&main-tbl}.db-num
                             and {&main-tbl}-lines-attr.doc-id eq  {&main-tbl}.doc-id
exclusive-lock:
   delete {&main-tbl}-lines-attr.
end.

for each {&main-tbl}-marking-lines-attr where {&main-tbl}-marking-lines-attr.db-num eq  {&main-tbl}.db-num
                                     and {&main-tbl}-marking-lines-attr.doc-id eq  {&main-tbl}.doc-id
exclusive-lock:
   delete {&main-tbl}-marking-lines-attr.
end.
