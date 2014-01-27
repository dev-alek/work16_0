/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Первоначальный расчет межфирменных архивов по категории 1

Автор: Чернова Светлана Александровна
Дата создания: 07/23/08
Author: Svetlana Chernova
Creation date: 07/23/08

Автор1: Перваков Михаил Сергеевич
Дата создания: 09/16/02

*/

define input parameter p-install as logical   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Первоначальный расчет межфирменных архивов по категории 1".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

define variable v-ok as logical   no-undo .

do
on error undo, return error return-value
:
  if p-install = false then do:
    message
      "Первоначальный расчет межфирменных архивов" skip
      "Вся текущая информация в архивах будет удалена" skip
      "Продолжить?" skip
      view-as alert-box question buttons yes-no update v-ok .
    if v-ok <> true then do:
      return . /* --->>>--- */
    end.
  end.

  run trg/harhcalc.p
    (input {&hold-main-cat-code}
    ,input {&lock-prc-calc-hold}
    ,input {&btpr-type-hold}
    ) .

  message
    "Расчет межфирменных архивов закончен" skip
    view-as alert-box information .
end.