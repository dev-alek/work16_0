/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать платежа с выбором форм - запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/14/10
Author: Bakhtadze Natalya
Creation date: 04/14/10


*/

define input parameter parparentproc        as widget-handle    no-undo.
define input parameter p-call-handle        as handle           no-undo.
define input parameter p-rid-list           as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать платежа с выбором форм - запуск.".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }


define temp-table temp_fin-doc-code no-undo
field host-code as integer
field fin-doc-code as integer
index pi is primary unique
host-code
fin-doc-code
.
define variable lok as logical no-undo .

define buffer buf_fin-doc               for ub.fin-doc.
define buffer buf_temp_fin-doc-code     for temp_fin-doc-code.

define variable ii as integer   no-undo .
define variable v-kol as integer   no-undo .

main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
:


  assign
  ii = 0
  v-kol = num-entries (p-rid-list) .
  .
  repeat ii = 1 to v-kol :
    find first  buf_fin-doc no-lock
        where recid( buf_fin-doc ) = int(entry(ii, p-rid-list)) no-error
    .
    if available  buf_fin-doc then do:
      create buf_temp_fin-doc-code .
      assign
      buf_temp_fin-doc-code.host-code    = buf_fin-doc.host-code
      buf_temp_fin-doc-code.fin-doc-code = buf_fin-doc.fin-doc-code
      .
    end.
  end.

  run rep/d-fdocm.w (
        input parparentproc
      , input p-call-handle
      , input table buf_temp_fin-doc-code
  ) no-error.
  if error-status :error  then do:
    message
    skip "Ошибка печати финдокумента."
    skip (1)
    skip return-value
    skip trim( error-status :get-message( 1 ) )
    view-as alert-box error.
    undo main-block, return error.
  end.
end.