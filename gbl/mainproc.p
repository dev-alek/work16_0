/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пустая персистентная процедура

Автор: Бахтадзе Наталья Викторовна
Дата создания: 02/12/10
Author: Bakhtadze Natalya
Creation date: 02/12/10

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Пустая персистентная процедура".
{ cmp/vssrevis.i }



procedure mainproc_empty :

return.
end procedure. /* mainproc_empty */