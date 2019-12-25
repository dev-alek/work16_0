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

define variable v-xmldom-key       as integer      no-undo.

/*==========================================================================*/
&if "{1}" eq "class"
&then
method public void   xmldom-clear ():
&else
procedure xmldom-clear :
&endif
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
        v-xmldom-key = 0
    .
end.
end . /* xmldom-clear */


/*==========================================================================*/
&if "{1}" eq "class"
&then
method public void xmldom-add(p-node-name      as character,
                               p-entity-name    as character,
                               p-entity-value   as character):
&else
procedure xmldom-add :

define input parameter p-node-name      as character        no-undo.
define input parameter p-entity-name    as character        no-undo.
define input parameter p-entity-value   as character        no-undo.
&endif
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
            v-xmldom-key = 0
        .
    end.
    else do:
        assign
            v-xmldom-key = buf_temp_testXML-node.xmh-key
        .
    end.
    find last buf_temp_testXML-entity
    use-index pi
    no-error.
    if available buf_temp_testXML-entity
    then do:
        assign
            v-xmldom-key = max(v-xmldom-key,buf_temp_testXML-entity.xme-key)
        .
    end.
    find first buf_temp_testXML-node
         where buf_temp_testXML-node.xmhNodName = p-node-name
    no-error.
    if not available buf_temp_testXML-node
    then do:
        assign
            v-xmldom-key = v-xmldom-key + 1
        .
        create buf_temp_testXML-node.
        assign
            buf_temp_testXML-node.xmh-key    = v-xmldom-key
            buf_temp_testXML-node.xmhNodName = p-node-name
        .
    end.
    assign
        v-xmldom-key = v-xmldom-key + 1
    .
    create buf_temp_testXML-entity.
    assign
        buf_temp_testXML-entity.xme-key      = v-xmldom-key
        buf_temp_testXML-entity.xmh-key      = buf_temp_testXML-node.xmh-key
        buf_temp_testXML-entity.xmeEntName   = p-entity-name
        buf_temp_testXML-entity.xmeEntValue  = p-entity-value
    .
end.
end. /* xmldom-add */
/*===========================*/
&if "{1}" eq "class"
&then
method public void  xmldom-save-next-level
&else
function  xmldom-save-next-level  returns character 
&endif
   ( iKey         as integer,
   i-doc-handle as handle,
   i-row-handle as handle):
   
   define buffer buf_temp_testXML-entity       for temp_testXML-entity.
   define variable v-field-handle  as handle           no-undo.
   define variable v-text-handle   as handle           no-undo.
   
   create x-noderef v-field-handle.
   create x-noderef v-text-handle.
   
   for each buf_temp_testXML-entity
      where buf_temp_testXML-entity.xmh-key = iKey
        and not buf_temp_testXML-entity.xmeEntName begins "#"
   on error undo, return error:
      i-doc-handle :create-node ( v-field-handle, buf_temp_testXML-entity.xmeEntName , "ELEMENT" ).
      i-row-handle :append-child ( v-field-handle ).
      i-doc-handle :create-node ( v-text-handle, buf_temp_testXML-entity.xmeEntValue, "TEXT" ).
      v-field-handle :append-child ( v-text-handle ).
      v-text-handle :node-value = buf_temp_testXML-entity.xmeEntValue.
     xmldom-save-next-level(buf_temp_testXML-entity.xme-key, i-doc-handle,v-field-handle).
   end.        /* for each buf_temp_testXML-entity */
   delete object v-field-handle.
   delete object v-text-handle.
end. 
/*==========================================================================*/
&if "{1}" eq "class"
&then
method public void  xmldom-save(p-full-filename  as character):
&else
procedure xmldom-save :
define input parameter p-full-filename  as character        no-undo.
&endif
    define variable v-doc-handle    as handle           no-undo.
    define variable v-root-handle   as handle           no-undo.
    define variable v-row-handle    as handle           no-undo.
    
    define variable v-buf-handle    as handle           no-undo.
/*    define variable v-dbfld-handle  as handle           no-undo.*/
/*    define variable v-counter    as integer      no-undo.*/

    define buffer buf_temp_testXML-node         for temp_testXML-node.
    
do
for buf_temp_testXML-node
 
on error undo, return error
:
    create x-document v-doc-handle.
    assign
        v-doc-handle :encoding = "windows-1251":U
    .
    create x-noderef v-root-handle.
    v-doc-handle :create-node ( v-root-handle, "Root", "ELEMENT" ).
    v-doc-handle :append-child ( v-root-handle ).
    for each buf_temp_testXML-node where not buf_temp_testXML-node.xmhNodName begins "#"
    on error undo, return error
    :
        assign
            v-buf-handle = buffer buf_temp_testxml-node :handle
        .
        create x-noderef v-row-handle.
        
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
        xmldom-save-next-level(buf_temp_testXML-node.xmh-key,v-doc-handle,v-row-handle).
        delete object v-row-handle.
        
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
end . /* xmldom-save */
/*==================================================*/
define variable m-xme-key       as integer      no-undo.
&if "{1}" eq "class"
&then
method public void  xmldom-load-next-level 
&else
function  xmldom-load-next-level returns character 
&endif
   (IParent    as handle,
   iParentkey as integer ):
   define variable v-field-handle  as handle           no-undo.
   define variable v-text-handle   as handle           no-undo.
   define variable v-field-counter as integer          no-undo.
   define variable v-field-amount  as integer          no-undo.
   define buffer buf_temp_testXML-entity       for temp_testXML-entity.
   create x-noderef v-field-handle.
   create x-noderef v-text-handle.
   assign
      v-field-amount = IParent :num-children
   .
   repeat v-field-counter = 1 to v-field-amount:
      IParent :get-child ( v-field-handle, v-field-counter ).
      if v-field-handle :num-children < 1
      then do:
         next.
      end.
      create buf_temp_testXML-entity.
      assign
         m-xme-key = m-xme-key + 1
         buf_temp_testXML-entity.xme-key     = m-xme-key
         buf_temp_testXML-entity.xmh-key     = iParentkey
      .
      
      v-field-handle :get-child ( v-text-handle, 1 ).
      assign
         buf_temp_testXML-entity.xmeEntName   = v-field-handle :name
         buf_temp_testXML-entity.xmeEntValue  = v-text-handle :node-value
      .
       xmldom-load-next-level (v-field-handle,buf_temp_testXML-entity.xme-key).
   end.
   delete object v-text-handle.
   delete object v-field-handle.
end.      

/*==========================================================================*/
&if "{1}" eq "class"
&then
method public void  xmldom-load (p-full-filename as character ):
&else
procedure xmldom-load :
define input parameter p-full-filename  as character        no-undo.
&endif
    define variable v-doc-handle    as handle           no-undo.
    define variable v-root-handle   as handle           no-undo.
    define variable v-table-handle  as handle           no-undo.
    
    define variable v-table-counter as integer      no-undo.
    define variable v-table-amount  as integer      no-undo.
    define buffer buf_temp_testXML-node         for temp_testXML-node.
    
do
for buf_temp_testXML-node
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
    m-xme-key = v-table-amount +  1.
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
        xmldom-load-next-level (v-table-handle,buf_temp_testXML-node.xmh-key).
       
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
    
    delete object v-root-handle.
    delete object v-doc-handle.
end.
end . /* xmldom-load */
/*==========================================*/
&if "{1}" eq "class"
&then
method public void  getEnties 
&else
function getEnties returns character 
&ENDIF
(input  i-parkey      as integer ,
                                         input i-entity-name    as character ,
                                         output o-entity-value  as character,
                                         output o-found         as logical ):
    
    
    define variable v-entity-name       as character no-undo.
    define variable v-entity-name-next  as character no-undo.
    
    define buffer buf_temp_testXML-entity    for temp_testXML-entity.
    v-entity-name     = entry(1,i-entity-name).
    if num-entries(i-entity-name) > 1
    then
       assign
          v-entity-name-next =  substring (i-entity-name,length(v-entity-name) + 2)
       .
    
    find first buf_temp_testXML-entity
             where buf_temp_testXML-entity.xmh-key      = i-parkey
               and buf_temp_testXML-entity.xmeEntName   = v-entity-name
        no-error.
    if available buf_temp_testXML-entity
    then do:
       if v-entity-name-next eq ""
       then assign
          o-entity-value = buf_temp_testXML-entity.xmeEntValue
          o-found        = yes
       .
       else do :
           getEnties(buf_temp_testXML-entity.xme-key,v-entity-name-next,output o-entity-value,output o-found).
       end.
            
    end.
end . /* getEnties */
/*==========================================================================
    Получить значение тэга из временной таблицы после xmldom-load,
    при условии, что тэг уникален.
    Точнее, будет найдено первое значение такого тэга.
*/
&if "{1}" eq "class"
&then
method public void  xmldom-read-unique (input  i-node-name      as character,
                                         input i-entity-name    as character ,
                                         output o-entity-value  as character,
                                         output o-found         as logical ):
&else
procedure xmldom-read-unique :
define input parameter i-node-name      as character        no-undo.
define input parameter i-entity-name    as character        no-undo.
define output parameter o-entity-value  as character        no-undo.
define output parameter o-found         as logical          no-undo.
&endif
define variable v-entity-l1-name  as character no-undo.
define variable v-entity-l2-name  as character no-undo.

    define buffer buf_temp_testXML-node         for temp_testXML-node.
    
do
for buf_temp_testXML-node

on error undo, return error
:
    assign
        o-found = no
    .
    search-all-nodes:
    for each buf_temp_testXML-node
       where buf_temp_testXML-node.xmhNodName = i-node-name
    :
        getEnties(buf_temp_testXML-node.xmh-key,i-entity-name,output o-entity-value,output o-found).
        
   end.
end.
end . /* xmldom-read-unique */


/* $Workfile$ e n d */