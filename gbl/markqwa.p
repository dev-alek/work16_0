/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Подтверждение выхода из справочника без сохранения выбранных записей

Автор: Бахтадзе Наталья Викторовна
Дата создания: 07/01/03
Author: Bakhtadze Natalya
Creation date: 07/01/03

*/

define input parameter p-sensitive as logical no-undo .
/*sensitive кнопки b-mark*/
define input parameter p-rid-list as character no-undo .
/*переменная в которой хранится список выбранных recid*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Подтверждение выхода из справочника без сохранения выбранных записей".
{ cmp/vssrevis.i }

define variable v-log as logical no-undo .

if p-sensitive and p-rid-list <> "":U then do:
  message
  "Информация о выбранных элементах будет потеряна" skip
  "Продолжить?"
  view-as alert-box QUESTION buttons YES-NO
  update v-log
  .
  if not v-log then do:
    return error.
  end.
end.