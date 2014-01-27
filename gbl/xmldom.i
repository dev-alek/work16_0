/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Библиотека сохранения и считывания XML-файла (DOM)

Автор: Хныкин Павел Андреевич
Дата создания: 10/25/05
Author: Pavel Khnykin
Creation date: 10/25/05

Required:

Примеры использования.

Запись:

    { gbl/xmldom.i }

    run xmldom-clear in this-procedure.
    run xmldom-add in this-procedure ( "Rec1", "Field1", "Value1" ).
    run xmldom-add in this-procedure ( "Rec1", "Field2", "Value2" ).
    run xmldom-add in this-procedure ( "Rec1", "Field3", "Value3" ).
    run xmldom-add in this-procedure ( "Rec2", "Field21", "Value21" ).
    run xmldom-add in this-procedure ( "Rec3", "Field31", "Value31" ).

    run xmldom-save in this-procedure ( "d:\111.xml" ).


    ( создаётся файл
    <?xml version="1.0" ?>
    - <Root>
        - <Rec1>
            <Field1>Value1</Field1>
            <Field2>Value2</Field2>
            <Field3>Value3</Field3>
        </Rec1>
        - <Rec2>
            <Field21>Value21</Field21>
        </Rec2>
        - <Rec3>
            <Field31>Value31</Field31>
        </Rec3>
    </Root>

Чтение:

    { gbl/xmldom.i }

    run xmldom-load in this-procedure ( "d:\111.xml" ).

    output to D:/test.txt.
    for each temp_testXML-node
    :
        export temp_testXML-node.
        for each temp_testXML-entity
           where temp_testXML-entity.xmh-key = temp_testXML-node.xmh-key
        on error undo, return error
        :
            export temp_testXML-entity.
        end.
    end.
    output close.

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "X(65)" no-undo
initial "@(#)$Workfile$ $Revision$".

define temp-table temp_testXML-node no-undo
    field xmh-key       as integer
    field xmhNodName    as character

    index pi is primary unique
        xmh-key
    index nnm
        xmhNodName
.
define temp-table temp_testXML-entity no-undo
    field xme-key       as integer
    field xmh-key       as integer
    field xmeEntName    as character
    field xmeEntValue   as character

    index pi is primary unique
        xme-key
    index enm
        xmh-key
        xmeEntName
.

define stream xmldom-out.

define variable v-xmldom-xmh-key       as integer      no-undo.
define variable v-xmldom-xme-key       as integer      no-undo.

/*==========================================================================*/
procedure xmldom-clear :

    define buffer buf_temp_testXML-node         for temp_testXML-node.
    define buffer buf_temp_testXML-entity       for temp_testXML-entity.
do
for buf_temp_testXML-node
  , buf_temp_testXML-entity
on error undo, return error
:
    empty temp-table buf_temp_testXML-node   .
    empty temp-table buf_temp_testXML-entity .
    assign
        v-xmldom-xmh-key = 0
        v-xmldom-xme-key = 0
    .
end.
end procedure. /* xmldom-clear */


/*==========================================================================*/
procedure xmldom-add :
define input parameter p-node-name      as character        no-undo.
define input parameter p-entity-name    as character        no-undo.
define input parameter p-entity-value   as character        no-undo.

    define buffer buf_temp_testXML-node         for temp_testXML-node.
    define buffer buf_temp_testXML-entity       for temp_testXML-entity.
do
for buf_temp_testXML-node
  , buf_temp_testXML-entity
on error undo, return error
:
    find last buf_temp_testXML-node
    use-index pi no-error.
    if not available buf_temp_testXML-node
    then do:
        assign
            v-xmldom-xmh-key = 0
        .
    end.
    else do:
        assign
            v-xmldom-xmh-key = buf_temp_testXML-node.xmh-key
        .
    end.
    find last buf_temp_testXML-entity
    use-index pi
    no-error.
    if not available buf_temp_testXML-entity
    then do:
        assign
            v-xmldom-xme-key = 0
        .
    end.
    else do:
        assign
            v-xmldom-xme-key = buf_temp_testXML-entity.xme-key
        .
    end.
    find first buf_temp_testXML-node
         where buf_temp_testXML-node.xmhNodName = p-node-name
    no-error.
    if not available buf_temp_testXML-node
    then do:
        assign
            v-xmldom-xmh-key = v-xmldom-xmh-key + 1
        .
        create buf_temp_testXML-node.
        assign
            buf_temp_testXML-node.xmh-key    = v-xmldom-xmh-key
            buf_temp_testXML-node.xmhNodName = p-node-name
        .
    end.
    assign
        v-xmldom-xme-key = v-xmldom-xme-key + 1
    .
    create buf_temp_testXML-entity.
    assign
        buf_temp_testXML-entity.xme-key      = v-xmldom-xme-key
        buf_temp_testXML-entity.xmh-key      = buf_temp_testXML-node.xmh-key
        buf_temp_testXML-entity.xmeEntName   = p-entity-name
        buf_temp_testXML-entity.xmeEntValue  = p-entity-value
    .
end.
end procedure. /* xmldom-add */

/*==========================================================================*/
procedure xmldom-save :
define input parameter p-full-filename  as character        no-undo.

    define variable v-doc-handle    as handle           no-undo.
    define variable v-root-handle   as handle           no-undo.
    define variable v-row-handle    as handle           no-undo.
    define variable v-field-handle  as handle           no-undo.
    define variable v-text-handle   as handle           no-undo.
    define variable v-buf-handle    as handle           no-undo.
/*    define variable v-dbfld-handle  as handle           no-undo.*/
/*    define variable v-counter    as integer      no-undo.*/

    define buffer buf_temp_testXML-node         for temp_testXML-node.
    define buffer buf_temp_testXML-entity       for temp_testXML-entity.
do
for buf_temp_testXML-node
  , buf_temp_testXML-entity
on error undo, return error
:
    create x-document v-doc-handle.
    assign
        v-doc-handle :encoding = "windows-1251":U
    .
    create x-noderef v-root-handle.
    v-doc-handle :create-node ( v-root-handle, "Root", "ELEMENT" ).
    v-doc-handle :append-child ( v-root-handle ).
    for each buf_temp_testXML-node
    on error undo, return error
    :
        assign
            v-buf-handle = buffer buf_temp_testxml-node :handle
        .
        create x-noderef v-row-handle.
        create x-noderef v-field-handle.
        create x-noderef v-text-handle.
        v-doc-handle :create-node ( v-row-handle, buf_temp_testXML-node.xmhNodName, "ELEMENT" ).
        v-root-handle :append-child ( v-row-handle ).
/*        v-row-handle :SET-ATTRIBUTE ( "Cust-num", STRING ( cust-num ) ).*/
/*        v-row-handle :SET-ATTRIBUTE ( "Name", NAME ).*/

/*  Так записываются все поля таблицы.
        write-fields:
        repeat v-counter = 1 to v-buf-handle :num-fields
        :
            assign
                v-dbfld-handle = v-buf-handle :buffer-field ( v-counter )
            .
            if v-dbfld-handle :name = "Cust-num"
            or v-dbfld-handle :name = "NAME"
            then do:
                undo write-fields, next write-fields.
            end.
            v-doc-handle :create-node ( v-field-handle, v-dbfld-handle :name, "ELEMENT" ).
            v-row-handle :append-child ( v-field-handle ).
            v-doc-handle :create-node ( v-text-handle, "", "TEXT" ).
            v-field-handle :append-child ( v-text-handle ).
            v-text-handle :node-value = STRING ( v-dbfld-handle :buffer-value ).
        end.
*/
        for each buf_temp_testXML-entity
           where buf_temp_testXML-entity.xmh-key = buf_temp_testXML-node.xmh-key
        on error undo, return error
        :
            v-doc-handle :create-node ( v-field-handle, buf_temp_testXML-entity.xmeEntName , "ELEMENT" ).
            v-row-handle :append-child ( v-field-handle ).
            v-doc-handle :create-node ( v-text-handle, buf_temp_testXML-entity.xmeEntValue, "TEXT" ).
            v-field-handle :append-child ( v-text-handle ).
            v-text-handle :node-value = buf_temp_testXML-entity.xmeEntValue.
        end.        /* for each buf_temp_testXML-entity */
        delete object v-row-handle.
        delete object v-field-handle.
        delete object v-text-handle.
    end.        /* for each buf_temp_testXML-node */
/*    v-doc-handle :normalize().*/
    os-delete p-full-filename.
    v-doc-handle :save ( "file", p-full-filename ).
    delete object v-doc-handle.
    delete object v-root-handle.
    output stream xmldom-out to value( p-full-filename ) append.
/*    seek stream xmldom-out to end .*/
    put stream xmldom-out unformatted {&new-line}.
    output stream xmldom-out close.
end.
end procedure. /* xmldom-save */

/*==========================================================================*/
procedure xmldom-load :
define input parameter p-full-filename  as character        no-undo.

    define variable v-doc-handle    as handle           no-undo.
    define variable v-root-handle   as handle           no-undo.
    define variable v-table-handle  as handle           no-undo.
    define variable v-field-handle  as handle           no-undo.
    define variable v-text-handle   as handle           no-undo.

    define variable v-table-counter as integer      no-undo.
    define variable v-field-counter as integer      no-undo.
    define variable v-field-amount  as integer      no-undo.
    define variable v-table-amount  as integer      no-undo.

    define variable v-xme-key       as integer      no-undo.

    define buffer buf_temp_testXML-node         for temp_testXML-node.
    define buffer buf_temp_testXML-entity       for temp_testXML-entity.
do
for buf_temp_testXML-node
  , buf_temp_testXML-entity
on error undo, return error
:
    assign
        p-full-filename = search( p-full-filename )
    .
    if p-full-filename = ?
    then do:        /* Если файл не найден, ничего не предпринимать. */
        undo, return .
    end.
    create x-document v-doc-handle.
    assign
        v-doc-handle :encoding = "windows-1251":U
    .
    create x-noderef v-root-handle.
    create x-noderef v-table-handle.
    create x-noderef v-field-handle.
    create x-noderef v-text-handle.
    v-doc-handle :load ( "file", p-full-filename, true ) no-error.
    if error-status :error
    or not valid-handle ( v-doc-handle )
    or v-doc-handle = ?
    then do:
        undo, return error vss-description + substitute( "Ошибка загрузки XML-файла &1", p-full-filename ).
    end.
    v-doc-handle :get-document-element ( v-root-handle ) no-error.
    if error-status :error
    or not valid-handle ( v-root-handle )
    or v-root-handle = ?
    then do:
        undo, return error vss-description + substitute( "Ошибка чтения корневого тэга XML-файла &1", p-full-filename ).
    end.
    assign
        v-table-amount = v-root-handle :num-children
    no-error.
    if error-status :error
    or v-table-amount = ?
    then do:
        undo, return error vss-description + substitute( ".&1Неверная структура XML-файла &2", {&new-line}, p-full-filename ).
    end.
    repeat v-table-counter = 1 to v-table-amount
    :
        v-root-handle :get-child ( v-table-handle, v-table-counter ).
        create buf_temp_testXML-node.
        assign
            buf_temp_testXML-node.xmh-key       = v-table-counter
            buf_temp_testXML-node.xmhNodName    = v-table-handle :name
        .
/*        cust-num = integer (hTable :GET-ATTRIBUTE ("Cust-num")).*/
/*        NAME = hTable :GET-ATTRIBUTE ("Name").*/
        assign
            v-field-amount = v-table-handle :num-children
        .
        repeat v-field-counter = 1 to v-field-amount
        :
            assign
                v-xme-key = v-xme-key + 1
            .
            create buf_temp_testXML-entity.
            assign
                buf_temp_testXML-entity.xme-key     = v-xme-key
                buf_temp_testXML-entity.xmh-key     = buf_temp_testXML-node.xmh-key
            .
            v-table-handle :get-child ( v-field-handle, v-field-counter ).
            if v-field-handle :num-children < 1
            then do:
                next.
            end.
            v-field-handle :get-child ( v-text-handle, 1 ).
            assign
                buf_temp_testXML-entity.xmeEntName   = v-field-handle :name
                buf_temp_testXML-entity.xmeEntValue  = v-text-handle :node-value
            .
        end.
    end.
/*    output to D:/test.txt.*/
/*    for each buf_temp_testXML-node*/
/*    :*/
/*        export buf_temp_testXML-node.*/
/*        for each buf_temp_testXML-entity*/
/*           where buf_temp_testXML-entity.xmh-key = buf_temp_testXML-node.xmh-key*/
/*        on error undo, return error*/
/*        :*/
/*            export buf_temp_testXML-entity.*/
/*        end.*/
/*    end.*/
/*    output close.*/
    delete object v-text-handle.
    delete object v-field-handle.
    delete object v-root-handle.
    delete object v-doc-handle.
end.
end procedure. /* xmldom-load */

/*==========================================================================
    Получить значение тэга из временной таблицы после xmldom-load,
    при условии, что тэг уникален.
    Точнее, будет найдено первое значение такого тэга.
*/
procedure xmldom-read-unique :
define input parameter p-node-name      as character        no-undo.
define input parameter p-entity-name    as character        no-undo.
define output parameter p-entity-value  as character        no-undo.
define output parameter p-found         as logical          no-undo.

    define buffer buf_temp_testXML-node         for temp_testXML-node.
    define buffer buf_temp_testXML-entity       for temp_testXML-entity.
do
for buf_temp_testXML-node
  , buf_temp_testXML-entity
on error undo, return error
:
    assign
        p-found = yes
    .
    search-all-nodes:
    for each buf_temp_testXML-node
       where buf_temp_testXML-node.xmhNodName = p-node-name
    :
        find first buf_temp_testXML-entity
             where buf_temp_testXML-entity.xmh-key      = buf_temp_testXML-node.xmh-key
               and buf_temp_testXML-entity.xmeEntName   = p-entity-name
        no-error.
        if available buf_temp_testXML-entity
        then do:
            assign
                p-entity-value = buf_temp_testXML-entity.xmeEntValue
                p-found        = yes
            .
        end.
    end.
end.
end procedure. /* xmldom-read-unique */

/* $Workfile$ e n d */