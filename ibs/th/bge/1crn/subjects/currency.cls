/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных currency в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

USING Progress.Lang.*.

CLASS ibs.th.bge.1crn.subjects.currency: 
    define property code_       as character    no-undo get. set.
    define property del-l       as integer      no-undo get. set.
    define property del-f       as integer      no-undo get. set.
    define property name_       as character    no-undo get. set.
    define property sym-name    as character    no-undo get. set.

END CLASS.