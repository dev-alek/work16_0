/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отметить меню, как требующее инициализации

Автор: Белоусов Илья Александрович
Дата создания: 05/08/07
Author: Ilia Belousov
Creation date: 05/08/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 01/27/06

*/

define input  parameter p-menu-code as integer   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отметить меню, как требующее инициализации".
{ cmp/vssrevis.i }

define buffer buf_menu-head for ub.menu-head .

do
on error undo, return error return-value
:
  find first buf_menu-head exclusive-lock
    where buf_menu-head.menu-code = p-menu-code
    no-error .
  if available buf_menu-head
  then do:
    assign
      buf_menu-head.control-number = ""
    .
  end.
end.