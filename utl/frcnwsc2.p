/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Форсированная передача ДК и итогов по ним

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
define variable vss-description as character no-undo init "Форсированная передача ДК по новостям".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }



if not p-install then do:
  message vss-workfile vss-revision vss-description skip
  "Вы уверены, что хотите запустить пересылку ДК и итогов по ним по новостям"
  view-as alert-box question buttons yes-no update loc#log as logical  .
  if not loc#log then return.
end.


_fmain:
do on error undo, return error
:
  _main:
  for each ub.dis-card no-lock
  on error undo, return error
  :
      run str/callnews.p
        ( input "dis-card":u
         ,input (buffer ub.dis-card:handle)
        ) .
    for each ub.dis-obj no-lock where ub.dis-obj.d-card = ub.dis-card.d-card
    on error undo _main, return error
    :
        run str/callnews.p
          ( input "dis-obj":u
           ,input (buffer ub.dis-obj:handle)
          ) .
    end.
    for each ub.dis-host no-lock where ub.dis-host.d-card = ub.dis-card.d-card
    on error undo _main, return error
    :
        run str/callnews.p
          ( input "dis-host":u
           ,input (buffer ub.dis-host:handle)
          ) .
    end.
  end.
  for each ub.code-range no-lock
    where ub.code-range.range-type = {&gbl-dc-code}
  on error undo _fmain, return error
  :
      run str/callnews.p
        ( input "code-range":u
         ,input (buffer ub.code-range:handle)
        ) .
  end.

end.

if not p-install then do:

  message "Завершилась утилита пересылки ДК и итогов по ним по новостям"
  view-as alert-box .


end.