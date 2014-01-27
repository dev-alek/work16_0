/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Закачка в ГДБ стран и т.п.

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/08/05
Author: Bakhtadze Natalya
Creation date: 09/08/05

!!! Должно распространяться по всем БД через СПН !!!

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Закачка в ГДБ стран и т.п.".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
define variable utl-path as char no-undo.
define variable v-curr-db-num like ub.db.db-num no-undo .
{ gbl/curdbnum.i v-curr-db-num }
if v-curr-db-num <> 0 then do:
    message "Данная утилита может работать только в ГБД." view-as alert-box.
    return.
end.

utl-path = search("cmp/countris.txt").

if utl-path = ? then do:
    message "Не найден файл для закачки справочника стран COUNTRIS.TXT!"
    view-as alert-box ERROR.
    return.
end.

input from value(utl-path).

REPEAT:
    CREATE ub.country.
    IMPORT ub.country.
END.

INPUT CLOSE.

message "Закачка справочника стран закончена"
view-as alert-box.