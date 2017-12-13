
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных good-grps в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.good-grps: 

    define property code_       as character    no-undo get. set.
    define property rn-code     as character    no-undo get. set.
    define property del-l       as integer      no-undo get. set.
    define property del-f       as integer      no-undo get. set.
    define property upper-code  as character    no-undo get. set.
    define property name_       as character    no-undo get. set.

end class.