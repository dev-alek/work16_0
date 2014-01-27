/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Изменение статуса налога

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
def var vss-description as character no-undo init "Изменение статуса налога".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }

DEFINE VARIABLE loc#log as logical no-undo .
DEFINE BUFFER bf-tax for ub.tax.

FIND FIRST bf-tax WHERE
           recid(bf-tax) = par-recid No-ERROR.
if not avail bf-tax then return error.
loc#log = no.
CASE bf-tax.status_:
  when {&current-status} then do:
      message "Вы действительно хотите удалить (логически) запись о налоге" bf-tax.tax-name "?"
      view-as alert-box QUESTION buttons YES-NO
      update loc#log.
  end.
  when {&deleted-status} then do:
      message "Запись о налоге" bf-tax.tax-name "уже (логически) удалена" skip
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
assign
bf-tax.status_ = (if bf-tax.status_ = {&deleted-status}
                            then {&current-status}
                            else {&deleted-status}).