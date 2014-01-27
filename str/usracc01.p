/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Создание или редактирование записи user-acccount

Автор: Белоусов Илья Александрович
Дата создания: 05/08/07
Author: Ilia Belousov
Creation date: 05/08/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 01/19/07

Input:
    p-mode          - {&add-def}    - новая запись,
                      {&update}     - изменение записи
    p-db-num        - БД, в которой создаётся пользователь. Обязательно задаётся для p-mode = {&add-def}.
    p-user-id-in    - Уникальный ключ записи пользователя. Обязательно задаётся для p-mode = {&update}.
    p-last-name     - Фамилия пользователя.

Output:
    p-user-id-out   - Уникальный ключ записи пользователя.

*/
define input parameter p-mode                   as character        no-undo.
define input parameter p-db-num                 as integer          no-undo.
define input parameter p-user-id-in             as character        no-undo.
define input parameter p-last-name              as character        no-undo.
define input parameter p-first-name             as character        no-undo.
define input parameter p-second-name            as character        no-undo.
define input parameter p-nik                    as character        no-undo.
define input parameter p-phone-number           as character        no-undo.
define input parameter p-mobile-phone-number    as character        no-undo.
define input parameter p-company                as character        no-undo.
define input parameter p-department             as character        no-undo.
define input parameter p-position               as character        no-undo.
define input parameter p-room                   as character        no-undo.
define input parameter p-e-mail                 as character        no-undo.
define input parameter p-internal-phone-number  as character        no-undo.
define input parameter p-PS                     as character        no-undo.
define input parameter p-psn-code               as integer          no-undo.
define output parameter p-user-id-out           as character        no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Создание или редактирование записи user-acccount".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }

define variable v-next-user-id as character no-undo .

define buffer buf_user-account for ub.user-account .

do
on error undo, return error
:
    case p-mode
    :
        when {&add-def}
        then do:
            assign
                v-next-user-id  = substitute( "&1-&2":U
                                        , p-db-num
                                        , next-value( s-user-id ) )
            .
            find first buf_user-account exclusive-lock
                 where buf_user-account.user-id = v-next-user-id
            no-error.
            if available buf_user-account
            then do:
                undo, return error substitute( "Ошибка при создании пользователя (user-account).&1Попытка создания записи с существующим кодом.&1.Код записи: &2"
                                                    , {&new-line}
                                                    , v-next-user-id  ).
            end.
            create buf_user-account .
            assign
                buf_user-account.user-id               = v-next-user-id
                buf_user-account.status_               = {&bef-user-status-normal}
                buf_user-account.last-name             = p-last-name
                buf_user-account.first-name            = p-first-name
                buf_user-account.second-name           = p-second-name
                buf_user-account.nik                   = p-nik
                buf_user-account.phone-number          = p-phone-number
                buf_user-account.mobile-phone-number   = p-mobile-phone-number
                buf_user-account.company               = p-company
                buf_user-account.department            = p-department
                buf_user-account.position              = p-position
                buf_user-account.room                  = p-room
                buf_user-account.e-mail                = p-e-mail
                buf_user-account.internal-phone-number = p-internal-phone-number
                buf_user-account.PS                    = p-PS
                buf_user-account.psn-code              = p-psn-code
            .
            assign
                p-user-id-out   = v-next-user-id
            .
        end.        /* when {&add-def} */
        when {&update}
        then do:
            assign
                p-user-id-out   = p-user-id-in
            .
            find first buf_user-account exclusive-lock
                 where buf_user-account.user-id = p-user-id-in
            no-error.
            if not available buf_user-account
            then do:
                undo, return error substitute( "Ошибка при создании пользователя (user-account).&1Не найдена запись для изменения.&1.Код записи: &2"
                                                    , {&new-line}
                                                    , p-user-id-in  ).
            end.
            assign
                buf_user-account.last-name               = p-last-name
                buf_user-account.first-name              = p-first-name
                buf_user-account.second-name             = p-second-name
                buf_user-account.nik                     = p-nik
                buf_user-account.phone-number            = p-phone-number
                buf_user-account.mobile-phone-number     = p-mobile-phone-number
                buf_user-account.company                 = p-company
                buf_user-account.department              = p-department
                buf_user-account.position                = p-position
                buf_user-account.room                    = p-room
                buf_user-account.e-mail                  = p-e-mail
                buf_user-account.internal-phone-number   = p-internal-phone-number
                buf_user-account.PS                      = p-PS
                buf_user-account.psn-code                = p-psn-code
            .
        end.        /* when {&update} */
    end case.       /* case p-mode */
end.