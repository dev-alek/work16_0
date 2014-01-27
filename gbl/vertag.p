/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получить версию и тэг системы

Автор: Белоусов Илья Александрович
Дата создания: 04/08/08
Author: Ilia Belousov
Creation date: 04/08/08

Input:

Output:

*/
define output parameter p-version         as character        no-undo.
define output parameter p-locale          as character        no-undo.
define output parameter p-SVNRev          as integer          no-undo.
define output parameter p-compilerVersion as character        no-undo.
define output parameter p-date            as date             no-undo.
define output parameter p-time            as integer          no-undo.
define output parameter p-comment         as character        no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Получить версию и тэг системы".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/xmldom.i   }

    define variable v-enc-file          as character    no-undo.
    define variable v-ver-file          as character    no-undo.
    define variable v-found             as logical      no-undo.
    define variable v-SVNRev-string     as character    no-undo.
    define variable v-date-string       as character    no-undo.
    define variable v-time-string       as character    no-undo.

do
on error undo, return error return-value
:
    assign
        p-version           = "":U
        p-locale            = "":U
        p-SVNRev            = 0
        p-compilerVersion   = "":U
        p-date              = ?
        p-time              = 0
        p-comment           = "":U
    .
    assign
        v-enc-file = search( "cmp/vertag.enc":U )
    .
    if v-enc-file = ?
    then do:
        /* Нет файла с параметрами версии. */
    end.
    else do:
        run gbl/_tmpfile.p ( input "cp":U  , input ".ver":U, output v-ver-file ).
        run utl/filecryp.p (
              input v-enc-file
            , input "sysadm":U
            , input no
            , input v-ver-file
        ).
        run xmldom-clear in this-procedure.
        run xmldom-load in this-procedure ( v-ver-file ) no-error.
        if error-status :error
        then do:
            /* Неверный формат файла версии */
        end.
        else do:
            run xmldom-read-unique in this-procedure ( input "TradeHouse":U, input "version":U         , output p-version            , output v-found   ).
            run xmldom-read-unique in this-procedure ( input "TradeHouse":U, input "locale":U          , output p-locale             , output v-found   ).
            run xmldom-read-unique in this-procedure ( input "TradeHouse":U, input "SVNRev":U          , output v-SVNRev-string      , output v-found   ).
            run xmldom-read-unique in this-procedure ( input "TradeHouse":U, input "compilerVersion":U , output p-compilerVersion    , output v-found   ).
            run xmldom-read-unique in this-procedure ( input "TradeHouse":U, input "date":U            , output v-date-string        , output v-found   ).
            run xmldom-read-unique in this-procedure ( input "TradeHouse":U, input "time":U            , output v-time-string        , output v-found   ).
            run xmldom-read-unique in this-procedure ( input "TradeHouse":U, input "comment":U         , output p-comment            , output v-found   ).
            assign
                p-SVNRev = integer( v-SVNRev-string )
            no-error.
            if error-status :error
            then do:
                assign
                    p-SVNRev = 0
                .
            end.
            assign
                p-date   = date( v-date-string )
            no-error.
            if error-status :error
            then do:
                assign
                    p-date   = ?
                .
            end.
            assign
                p-time   = integer( v-time-string )
            no-error.
            if error-status :error
            then do:
                assign
                    p-time   = 0
                .
            end.
        end.
        os-delete value( v-ver-file ).
    end.
end.