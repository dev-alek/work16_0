/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запустить любую команду операционной системы или выполнить действие по умолчания для файла

Автор: Перваков Михаил Сергеевич
Дата создания: 04/05/06
Author: Mikhail Pervakov
Creation date: 04/05/06

Действие аналогично открытию пункта меню Start/Run/Команда

*/

define input parameter p-file-name as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

do
on error undo, return error return-value
:
  os-command no-wait value ('start ' + p-file-name).
end.