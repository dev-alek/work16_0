/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск печати

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/15/10
Author: Bakhtadze Natalya
Creation date: 04/15/10

*/

DEFINE INPUT PARAMETER parParentProc  AS WIDGET-HANDLE NO-UNDO.
define input parameter p-recid as recid no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

define variable v-format as character no-undo .
define buffer buf_fin-doc for ub.fin-doc.
find first buf_fin-doc share-lock where
          recid(buf_fin-doc) = p-recid.

run rep/pre-vedom.p (
                  INPUT parParentProc
                ,input buf_fin-doc.host-code
                ,input buf_fin-doc.fin-doc-code
              ) no-error.
if error-status:error then do:
  return error.
end.

