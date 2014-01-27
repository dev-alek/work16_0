/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Блокировка ВС

Автор: Бахтадзе Наталья Викторовна
Дата создания: 02/12/09
Author: Bakhtadze Natalya
Creation date: 02/12/09

*/

define input parameter p-esys-id as integer no-undo .
define input parameter p-db-num as integer no-undo .
define parameter buffer buf_ext-system for ub.ext-system .
define output parameter p-success       as logical          no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Блокировка ВС".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

find first buf_ext-system exclusive-lock
      where buf_ext-system.esys-id = p-esys-id
      and buf_ext-system.db-num = p-db-num
no-error no-wait.
if not available buf_ext-system
then do:
    assign
        p-success = no
    .
    if locked( buf_ext-system )
    then do:
        return  substitute( "&1. Другой пользователь работает с ВС &2!"
                                , vss-workfile
                                , p-esys-id ) .
    end.
    else do:
        return substitute( "&1. ВС &2 не найдена!!!", vss-workfile, p-esys-id ) .
    end.
end.
else do:
    assign
        p-success = yes
    .
    return ''.
end.
