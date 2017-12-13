
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных contracts в 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.contracts: 

    define property code_       as character    no-undo get. set.
    define property del-l       as integer      no-undo get. set.
    define property del-f       as integer      no-undo get. set.
    define property org-code    as character    no-undo get. set.
    define property cont-code   as character    no-undo get. set.
    define property date-srt    as date         no-undo get. set.
    define property date-end    as date         no-undo get. set.

end class.