/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обёртка для использования процедур из str/findtank.i в классах 

Автор: Молотков Сергей Михайлович
Дата создания: 10/11/17
Author: Molotkov Sergey
Creation date: 10/11/17

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Поиск резервуара и пистолета по марке топлива".
{ cmp/trg-def.i  } /* &current-status */
{ str/findtank.i }