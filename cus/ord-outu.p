/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

толкач для процедуры корректировки внутреннего расходного - приходного запроса

Автор: Чернова Светлана Александровна
Дата создания: 09/12/05
Author: Svetlana Chernova
Creation date: 09/12/05

*/
define input parameter parparentproc   as   handle no-undo.
define input parameter par-recid as recid no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "толкач для процедуры корректировки внутреннего расходного - приходного запроса   ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i  }

define new shared buffer t-doc for ub.trn-doc .
define new shared query br-docs for t-doc scrolling.
define variable varnext-prev as logical no-undo.
define variable varline-rec  as recid   no-undo.
find first t-doc no-lock where recid(t-doc ) = par-recid no-error .
if available t-doc then do:
    run str/out-doc.w
    (input parparentproc,
      input-output par-recid,
      input {&update},
      input ?,
      input ?,
      input ?,
      input-output varnext-prev,
      input t-doc.ext-doc-type,
      input ?,
      input-output varline-rec,
      input ?,
      input ?,
      input {&inquiry}).
end.