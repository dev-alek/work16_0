/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт документов прихода и расхода. Заказная программа выгрузки для Востока с Западом.

Автор: Белоусов Илья Александрович
Дата создания: 04/12/06
Author: Ilia Belousov
Creation date: 04/12/06

Input:

Output:

*/
do
on error undo, return error
:

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экспорт документов прихода и расхода. Заказная программа выгрузки для Востока с Западом.".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
    /* период экспорта */
define variable v-par-value     as character        no-undo.
define variable v-par-type      as character        no-undo.

    { gbl/conf-rd.i
        "'is-bge'"
        "''"
        "''"
        0
        "''"
        "''"
        "''"
        yes
        v-par-value
        v-par-type
        no-error
    }
    if error-status:error
    or v-par-type <> "L"
    or v-par-value <> "yes"
    then do:
        message
            skip "Для экспорта должен быть включен"
            skip "АРМ Внешняя Бухгалтерия."
            skip(1)
            skip "Обратитесь к администратору системы."
            skip return-value
            skip trim(error-status :get-message(1))
                 trim(error-status :get-message(2))
                 trim(error-status :get-message(3))
        view-as alert-box error.
        undo, return error .
    end.
    run bge/bge.p (
          input this-procedure :handle
        , input 'tree'
        , input "util,g-expie":U
    ) no-error.
    if error-status :error
    then do:
        message
            vss-workfile vss-revision vss-description
            skip "Ошибка основной процедуры экспорта."
            skip return-value
            skip trim(error-status :get-message(1))
                 trim(error-status :get-message(2))
                 trim(error-status :get-message(3))
                 trim(error-status :get-message(4))
                 trim(error-status :get-message(5))
        view-as alert-box error.
        undo, return error .
    end.

end.