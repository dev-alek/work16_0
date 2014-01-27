/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура заполнения таблицы истории пользователя.

Автор: Белоусов Илья Александрович
Дата создания: 03/27/08
Author: Ilia Belousov
Creation date: 03/27/08

Input:

Output:

*/
define input parameter p-action         as character        no-undo.
define input parameter p-tbl-name       as character        no-undo.
define input parameter p-table-handle  as handle           no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Процедура заполнения таблицы истории пользователя.".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ trg/userlog.i  }
{ gbl/schemlib.i }
{ gbl/key-rec.i }

    define variable v-field-handle          as handle       no-undo.
    define variable v-corr-user-db-num      as integer      no-undo.
    define variable v-parent-name           as character    no-undo.
    define variable v-field-list            as character    no-undo.
    define variable v-value-list            as character    no-undo.
    define variable v-field-counter         as integer      no-undo.
    define variable v-counter               as integer      no-undo.
    define variable v-parent-buffer-handle  as handle       no-undo.
    define variable v-parent-unique-key-rec as character    no-undo.
    define variable v-unique-key-rec        as character    no-undo.
    define variable v-corr-date             as date         no-undo.
    define variable v-corr-time             as integer      no-undo.
    define variable v-corr-user-name        as character    no-undo.

    define buffer buf_c-user-log            for c-user-log.
    define buffer buf_temp_userlog-bush     for temp_userlog-bush.
do
for buf_c-user-log
  , buf_temp_userlog-bush
on error undo, return error
:
    if not p-table-handle :available
    then do:
        undo, return error substitute( "&1. Ошибка задания входных параметров. Переданый буфер таблицы &2 не доступен", vss-description, p-tbl-name ).
    end.
    if not valid-handle( p-table-handle :buffer-field( "corr-user-db-num":U ) )
    then do:
        undo, return error substitute( "&1. Ошибка структуры c-таблицы. В таблице &2 нет поля corr-user-db-num", vss-description, p-tbl-name ).
    end.
    if not valid-handle( p-table-handle :buffer-field( "corr-date":U ) )
    then do:
        undo, return error substitute( "&1. Ошибка структуры c-таблицы. В таблице &2 нет поля corr-date", vss-description, p-tbl-name ).
    end.
    if not valid-handle( p-table-handle :buffer-field( "corr-time":U ) )
    then do:
        undo, return error substitute( "&1. Ошибка структуры c-таблицы. В таблице &2 нет поля corr-time", vss-description, p-tbl-name ).
    end.
    run gen-key-rec in this-procedure (
          input p-tbl-name
        , input p-table-handle
        , output v-unique-key-rec
    ) no-error.
    if error-status :error
    then do:
        return error substitute( "&1. Ошибка при генерации уникального ключа. &2. Имя таблицы &3.", vss-workfile, return-value, p-tbl-name ).
    end.
    if v-unique-key-rec = ?
    or v-unique-key-rec = ""
    then do:
        return error substitute( "&1. Уникальный ключ имеет неопределенное значение. Имя таблицы &2.", vss-workfile, p-tbl-name ).
    end.
    assign
        v-corr-user-db-num = p-table-handle :buffer-field( "corr-user-db-num":U ) :buffer-value
        v-corr-date        = p-table-handle :buffer-field( "corr-date":U ) :buffer-value
        v-corr-time        = p-table-handle :buffer-field( "corr-time":U ) :buffer-value
        v-corr-user-name   = p-table-handle :buffer-field( "corr-user-name":U ) :buffer-value
    .
    if v-corr-user-db-num   = ?
    or v-corr-date          = ?
    or v-corr-time          = ?
    or v-corr-user-name     = ?
    then do:        /* Возможно, в c-таблицу пытаются сделать запись без corr-user-db-num и т.п. - такие записи не регистрируем...  */
/*        message*/
/*            "X2"*/
/*            skip*/
/*        view-as alert-box information.*/
        undo, return .
    end.
    run userlog-hist-table-init (
          input p-tbl-name
    ).
    /* Обработка несвязанных таблиц истории */
    for each buf_temp_userlog-bush
       where buf_temp_userlog-bush.ulbType = {&userlog-type-simple}
         and buf_temp_userlog-bush.ulbTableName = p-tbl-name
    on error undo, return error
    :
        if buf_temp_userlog-bush.ulbParentKey = 0
        then do:        /* История головной таблицы. В историю пишется unique-key-rec самой таблицы как родительский */
            assign
                v-parent-unique-key-rec = v-unique-key-rec
                v-parent-name           = p-tbl-name
            .
        end.        /* if buf_temp_userlog-bush.ulbParentKey = 0 */
        else do:
            run userlog-get-table-name in this-procedure (
                  input buf_temp_userlog-bush.ulbParentKey
                , output v-parent-name
            ).
            if v-parent-name = p-tbl-name
            then do:
                assign
                    v-parent-unique-key-rec = v-unique-key-rec
                .
            end.        /* if v-parent-name = p-tbl-name  */
            else do:
                run schemlib-get-index-fields in this-procedure (
                    input v-parent-name
                    , output v-field-list
                ) no-error.
                if error-status :error
                or v-field-list = "":U
                then do:
                    undo, return error substitute( "&1. Ошибка вычисления первичного ключа родительской таблицы '&2' для таблицы '&3'", vss-description, v-parent-name, p-tbl-name ).
                end.
                assign
                    v-field-counter = num-entries( v-field-list )
                .
                do v-counter = 1 to v-field-counter
                on error undo, return error
                :
                    assign
                        v-field-handle = p-table-handle :buffer-field( entry( v-counter, v-field-list ) )
                    .
                    if not valid-handle( v-field-handle )
                    then do:
                        undo, return error substitute( "&1. В таблице '&2' нет поля, соответствующего полю '&3' в родительской таблице '&4'"
                            , vss-description
                            , v-parent-name
                            , entry( v-counter, v-field-list )
                            , v-parent-name
                        ).
                    end.
                    assign
                        v-value-list = substitute( "&1&2&3":U
                                        , v-value-list
                                        , ( if v-value-list = "":U then "":U else ",":U )
                                        , v-field-handle :buffer-value
                                        )
                    .
                end.        /* do */
                run schemlib-set-buffer in this-procedure (
                    input v-parent-name
                    , input v-field-list
                    , input v-value-list
                    , output v-parent-buffer-handle
                ).
                run gen-key-rec in this-procedure (
                    input v-parent-name
                    , input v-parent-buffer-handle
                    , output v-parent-unique-key-rec
                ) no-error.
                if error-status :error
                then do:
                    return error substitute( "&1. Ошибка при генерации уникального ключа. &2. Имя таблицы &3.", vss-workfile, return-value, v-parent-name ).
                end.
                if v-parent-unique-key-rec = ?
                or v-parent-unique-key-rec = ""
                then do:
                    return error substitute( "&1. Уникальный ключ имеет неопределенное значение. Имя таблицы &2.", vss-workfile, v-parent-name ).
                end.
            end.        /* NOT ( if v-parent-name = p-tbl-name  ) */
        end.        /* NOT ( if buf_temp_userlog-bush.ulbParentKey = 0 ) */
        create buf_c-user-log.
        assign
            buf_c-user-log.corr-user-db-num = v-corr-user-db-num
            buf_c-user-log.cusr-id          = next-value( s-user-history )
            buf_c-user-log.chip-num         = 0
            buf_c-user-log.corr-date        = p-table-handle :buffer-field( "corr-date":U ) :buffer-value
            buf_c-user-log.corr-time        = p-table-handle :buffer-field( "corr-time":U ) :buffer-value
            buf_c-user-log.corr-user-name   = p-table-handle :buffer-field( "corr-user-name":U ) :buffer-value
            buf_c-user-log.des              = substitute( "&1 &2 &3":U
                                                , ( if p-action = {&nwsdochs_action_delete} then "Удаление" else "Изменение" )
                                                , buf_temp_userlog-bush.ulbDesc
                                                , buf_temp_userlog-bush.ulbParentDesc
                                            )
            buf_c-user-log.have-screen      = yes
            buf_c-user-log.head-table-key   = v-parent-unique-key-rec
            buf_c-user-log.head-table       = v-parent-name
            buf_c-user-log.uniq-key-rec     = v-unique-key-rec
        .
    end.
    /* Обработка таблиц истории, связанных в кусты */
    for each buf_temp_userlog-bush
       where buf_temp_userlog-bush.ulbType      = {&userlog-type-bush}
         and buf_temp_userlog-bush.ulbTableName = p-tbl-name
         and buf_temp_userlog-bush.ulbParentKey <> 0
    on error undo, return error
    :
        run userlog-get-table-name in this-procedure (
              input buf_temp_userlog-bush.ulbParentKey
            , output v-parent-name
        ).
        if v-parent-name = p-tbl-name
        then do:        /* История самой головной таблицы не пишется. */

        end.        /* if v-parent-name = p-tbl-name  */
        else do:
            run schemlib-get-index-fields in this-procedure (
                  input v-parent-name
                , output v-field-list
            ) no-error.
            if error-status :error
            or v-field-list = "":U
            then do:
                undo, return error substitute( "&1. Ошибка вычисления первичного ключа родительской таблицы '&2' для таблицы '&3'", vss-description, v-parent-name, p-tbl-name ).
            end.
            assign
                v-value-list = string( p-table-handle :buffer-field( "subject":U ) :buffer-value )
            .
            run schemlib-set-buffer in this-procedure (
                  input v-parent-name
                , input v-field-list
                , input v-value-list
                , output v-parent-buffer-handle
            ).
            run gen-key-rec in this-procedure (
                  input v-parent-name
                , input v-parent-buffer-handle
                , output v-parent-unique-key-rec
            ) no-error.
            if error-status :error
            then do:
                return error substitute( "&1. Ошибка при генерации уникального ключа. &2. Имя таблицы &3.", vss-workfile, return-value, v-parent-name ).
            end.
            create buf_c-user-log.
            assign
                buf_c-user-log.corr-user-db-num = v-corr-user-db-num
                buf_c-user-log.cusr-id          = next-value( s-user-history )
                buf_c-user-log.chip-num         = 0
                buf_c-user-log.corr-date        = p-table-handle :buffer-field( "corr-date":U ) :buffer-value
                buf_c-user-log.corr-time        = p-table-handle :buffer-field( "corr-time":U ) :buffer-value
                buf_c-user-log.corr-user-name   = p-table-handle :buffer-field( "corr-user-name":U ) :buffer-value
                buf_c-user-log.des              = substitute( "&1 &2 &3":U
                                                    , ( if p-action = {&nwsdochs_action_delete} then "Удаление" else "Изменение" )
                                                    , buf_temp_userlog-bush.ulbDesc
                                                    , buf_temp_userlog-bush.ulbParentDesc
                                                )
                buf_c-user-log.have-screen      = yes
                buf_c-user-log.head-table-key   = v-parent-unique-key-rec
                buf_c-user-log.head-table       = v-parent-name
                buf_c-user-log.uniq-key-rec     = v-unique-key-rec
            .
        end.
    end.
    if valid-handle( v-parent-buffer-handle )
    then do:
        delete object v-parent-buffer-handle.
    end.
end.