/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вызов истории по документу из истории пользовател

Автор: Белоусов Илья Александрович
Дата создания: 05/08/08
Author: Ilia Belousov
Creation date: 05/08/08

Input:

Output:

*/
define input parameter parparentproc    as handle           no-undo.
define input parameter p-table-name     as character        no-undo.
define input parameter p-unique-key-rec as character        no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Вызов истории по документу из истории пользователя".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/key-rec.i  }

    define variable v-field-list        as character    no-undo.
    define variable v-field-value-list  as character    no-undo.
do
on error undo, return error
:
    run gen-key-fv in this-procedure (
          input p-unique-key-rec
        , output v-field-list
        , output v-field-value-list
    ).
    case p-table-name
    :
        when "c-fbr-doc":U
        then do:
            run str/fbrdocsh.w (
                  input parparentproc
                , input entry( 1, v-field-value-list, {&delim-key} )
            ).
        end.        /* when "fbr-doc":U */
        when "c-sht-hist":U
        then do:
             DEFINE VARIABLE v-rid-list AS CHARACTER NO-UNDO.    
             run ref/cshthist.w (
                  INPUT parParentProc
                 ,input ''
                 ,input ?
                 ,input '':U /* bttns  */
                 ,input 'one':U /*p-mode  */
                 ,INPUT entry( 1, v-field-value-list, {&delim-key} )
                 ,INPUT entry( 2, v-field-value-list, {&delim-key} )
                 ,INPUT entry( 3, v-field-value-list, {&delim-key} )
                 ,INPUT entry( 4, v-field-value-list, {&delim-key} )
                 ,INPUT '':U /*p-subject*/
                 ,INPUT-OUTPUT v-rid-list) NO-ERROR.
         end.        
    end case.       /* case p-table-name */
end.