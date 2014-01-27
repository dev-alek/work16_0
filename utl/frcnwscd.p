/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Форсированная передача касс по новостям

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/


define input parameter p-install as logical no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Форсированная передача касс по новостям".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }



if not p-install then do:
  message vss-workfile vss-revision vss-description skip
  "Вы уверены, что хотите запустить пересылку данных по кассам по новостям"
  view-as alert-box question buttons yes-no update loc#log as logical  .
  if not loc#log then return.
end.



do on error undo, return error
:
  for each ub.cash-desk no-lock
  on error undo, return error
  :
      run str/callnews.p
        ( input "cash-desk":u
         ,input (buffer ub.cash-desk:handle)
        ) .
  end.
end.

if not p-install then do:

  message "Завершилась утилита пересылки касс по новостям"
  view-as alert-box .


end.