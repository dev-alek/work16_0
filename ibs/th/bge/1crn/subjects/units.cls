
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных units в 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.units: 

    define property okei-code   as character    no-undo get. set.
    define property del-l       as integer      no-undo get. set.
    define property del-f       as integer      no-undo get. set.
    define property name_       as character    no-undo get. set.
    define property full-name   as character    no-undo get. set.
/*    define property type_   as character    no-undo get. set.*/

end class.