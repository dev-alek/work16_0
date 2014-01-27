/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Изменение статуса ставки налога

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/20/04
Author: Bakhtadze Natalya
Creation date: 01/20/04

*/

/*
Мастеръ Гамбсъ этимъ полукресломъ
начинаетъ новую партiю мебели.
1865 г.
Санктъ-Петербургъ.

ОТДЕЛЕНИЕ БИЗНЕС-ЛОГИКИ ОТ ИНТЕРФЕЙСА!!!!!

*/

define input parameter par-recid as recid no-undo.
def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Изменение статуса ставки налога".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }

DEFINE VARIABLE loc#log as logical no-undo .
DEFINE BUFFER bf-tax-rate for ub.tax-rate.

FIND FIRST bf-tax-rate WHERE
           recid(bf-tax-rate) = par-recid No-ERROR.
if not avail bf-tax-rate then return error.
loc#log = no.

CASE bf-tax-rate.status_:
  when {&current-status} then do:
      message "Вы действительно хотите удалить (логически) запись о ставке налога" bf-tax-rate.rate-name "?"
      view-as alert-box QUESTION buttons YES-NO
      update loc#log.
  end.
  when {&deleted-status} then do:
      message "Запись о ставке налоге" bf-tax-rate.rate-name "уже (логически) удалена" skip
      "Восстановить?"
      view-as alert-box QUESTION buttons YES-NO
      update loc#log.
  end.
  otherwise do:
      BELL.
      return error.
  end.
END CASE.

if not loc#log then return error.

do
on error undo, return error
:

if bf-tax-rate.status_ = {&current-status} then do:
  /*значит собираемся удалять*/
  if can-find(first ub.tax-rate-value No-LOCK WHERE
                    ub.tax-rate-value.tax-code = bf-tax-rate.tax-code AND
                    ub.tax-rate-value.rate-code = bf-tax-rate.rate-code AND
                    ub.tax-rate-value.status_ = {&current-status}) then do:
    message
    "Нельзя удалить ставку если есть неудаленные значения к ставке" skip
    view-as alert-box error .
    return error .
  end.
end.

assign
bf-tax-rate.status_ = (if bf-tax-rate.status_ = {&deleted-status}
                            then {&current-status}
                            else {&deleted-status}).

release bf-tax-rate no-error .
if error-status:error then do:
  message
  "Ошибка при сохранении записи СТАВКА НАЛОГА" skip
  error-status:get-message(1) skip
  return-value
  view-as alert-box error .
  undo , return error .
end.
end. /*doe*/