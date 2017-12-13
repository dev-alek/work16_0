/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обёртка для использования процедур из str/fbrlib.i в классах 

Автор: Молотков Сергей Михайлович
Дата создания: 25/10/17
Author: Molotkov Sergey
Creation date: 25/10/17

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Создание рецептов, действия с рецептами".
{ cmp/str-glbl.i } /* {&new-line} */  
{ cmp/library.i  } /* g#library */
{ str/fbrcode.i }
{ str/fbrlib.i  }