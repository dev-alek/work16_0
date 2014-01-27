/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать одной банковской выписки

Автор: Бахтадзе Наталья Викторовна
Дата создания: 11/20/06
Author: Bakhtadze Natalya
Creation date: 11/20/06

*/

DEFINE INPUT PARAMETER parParentProc  AS WIDGET-HANDLE NO-UNDO.
define input parameter p-host-code like ub.fin-statement.host-code no-undo .
define input parameter p-sttm-code like ub.fin-statement.sttm-code no-undo .
define input parameter p-append as logical no-undo .
define input parameter p-is-last as logical no-undo .
define input-output parameter p-format as integer no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать одной банковской выписки".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

define variable v-format as integer no-undo .
/*1 landscape 0-Portrait*/
define buffer buf_fin-statement for ub.fin-statement.

do
on error undo, return error
:

  assign
  v-format = p-format
  .
  find first buf_fin-statement no-lock where
            buf_fin-statement.host-code = p-host-code
        AND buf_fin-statement.sttm-code = p-sttm-code .
  CASE buf_fin-statement.fins-doc-type:
    when {&standard-sttm} then do:
      run rep/fssttm1p.p (
                      input parParentProc
                      ,buffer buf_fin-statement
                      ,input p-append
                      ,input p-is-last
                      ,input-output v-format
                      ) no-error .
    end.
  END CASE.
  assign
  p-format = v-format
  .
end. /*doe*/
