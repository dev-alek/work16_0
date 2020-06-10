/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 3 авг. 2019 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 3 авг. 2019 г.

*/



using Progress.Lang.*.

block-level on error undo, throw.

class ibs.th.bge.xmlimpexp final: 
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   define variable vss-revision    as character no-undo init "$Revision:$":U .
   define variable vss-author      as character no-undo init "$Author:$":U .
   define variable vss-date        as character no-undo init "$Date:$":U .
   define variable vss-workfile    as character no-undo init "$Workfile:$":U .
   define variable vss-archive     as character no-undo init "$Archive:$":U .
   define variable vss-description as character no-undo init "".
   {cmp\str-glbl.i class }  
   {GBL\xmldom.i class }
   define variable objKeyRec as ibs.th.gbl.keyrec no-undo.
   define variable iAll as logical no-undo.
   constructor public xmlimpexp (  ):
      super ().
      objKeyRec = new ibs.th.gbl.keyrec().
     
   /*   .savecode().
      .xmldom-save  ( "c:\11\111.xml" ).
      
      .xmldom-clear().
      .xmldom-load ( "c:\11\111.xml" ).
     .updatetablefordb(). */
   end constructor.

   destructor public xmlimpexp ( ):
       delete object objKeyRec.
   end destructor.

   method public void  savecode():
      define variable hQuery   as handle  no-undo .
      define buffer Buf_code for code.
      create query hQuery.
      hQuery:set-buffers(buffer Buf_code :HANDLE). 
      hQuery:query-prepare("FOR EACH Buf_code ").
      hQuery:query-open ().
      updatetableforxml(hQuery).
      delete object hQuery. 
   end.
&glob prefix-table "table-"
&glob record-table "record-"
   method public void updatetableforxml(ihquery as handle):
      define variable vBuffer as handle no-undo.
      define variable hField  as handle no-undo.
      define variable VTableName as character no-undo.
      define variable vNodeName as character no-undo.
      define variable vItem as integer no-undo.
      define buffer buf_XML-node   for temp_testXML-node.
      define buffer buf_XML-entity for temp_testXML-entity.
      define buffer buf_XML-field for temp_testXML-entity.
      vNodeName = "File-info".
      find first buf_XML-node
          where buf_XML-node.xmhNodName = vNodeName
      no-error.
      if not available buf_XML-node
      then do:
         assign
            v-xmldom-key = v-xmldom-key + 1
         .
         create buf_XML-node.
         assign
            buf_XML-node.xmh-key    = v-xmldom-key
            buf_XML-node.xmhNodName = vNodeName
            
         .
         assign
            v-xmldom-key = v-xmldom-key + 1
            vNodeName = "version"
         .
         create buf_XML-entity.
         assign
            buf_XML-entity.xme-key      = v-xmldom-key
            buf_XML-entity.xmh-key      = buf_XML-node.xmh-key
            buf_XML-entity.xmeEntName   = vNodeName
            buf_XML-entity.xmeEntValue  = "000"
         .
      end.
      ihquery:get-first().
      vBuffer = ihquery:get-buffer-handle ().
      VTAbleName = vBuffer:table.
      if not ihquery:query-off-end 
      then do:
         vNodeName = {&prefix-table} + VTAbleName.
         find first buf_XML-node
              where buf_XML-node.xmhNodName = vNodeName
         no-error.
         if not available buf_XML-node
         then do:
            assign
               v-xmldom-key = v-xmldom-key + 1
            .
            create buf_XML-node.
            assign
               buf_XML-node.xmh-key    = v-xmldom-key
               buf_XML-node.xmhNodName = vNodeName
            .
         end.
         vNodeName = {&record-table} + VTAbleName.
      end.
       
      do while not ihquery:query-off-end:
         assign
            v-xmldom-key = v-xmldom-key + 1
         .
         create buf_XML-entity.
         assign
            buf_XML-entity.xme-key      = v-xmldom-key
            buf_XML-entity.xmh-key      = buf_XML-node.xmh-key
            buf_XML-entity.xmeEntName   = vNodeName
            buf_XML-entity.xmeEntValue  = ""
         .
         v-xmldom-key = v-xmldom-key + 1.
         create buf_XML-field.
            assign
            buf_XML-field.xme-key      = v-xmldom-key
            buf_XML-field.xmh-key      = buf_XML-entity.xme-key
            buf_XML-field.xmeEntName   = "record-delete"
            buf_XML-field.xmeEntValue  = "no"
         .
         block-field:
         do vItem = 1 to vBuffer:num-fields:
            assign hField = vBuffer:buffer-field(vItem) .
           /* if not valid-handle(hField) then next FND.*/
           if not iAll and hField:buffer-value eq hField:initial then next block-field.
            v-xmldom-key = v-xmldom-key + 1.
            create buf_XML-field.
               assign
               buf_XML-field.xme-key      = v-xmldom-key
               buf_XML-field.xmh-key      = buf_XML-entity.xme-key
               buf_XML-field.xmeEntName   = hField:name
               buf_XML-field.xmeEntValue  = hField:buffer-value
            .
         end.
         
         ihquery:get-next().
      end.
      ihquery:query-close().
      /*delete object ihquery.*/
   end.
   define variable mfirst as logical no-undo init yes.
   method private void put-log (itext as character ):
      output to "xmlimpexp.log" append.
      if mfirst
      then do:
         put unformatted now skip.
         mfirst = no.
      end.
      put unformatted itext skip.
      output close.
    
   end.

   method public void updatetablefordb():
      define buffer buf_XML-node   for temp_testXML-node.
      define buffer buf_XML-entity for temp_testXML-entity.
      define buffer buf_XML-field for temp_testXML-entity.
   
      define variable VTablename as character no-undo.
      define variable Vkey-rec   as character no-undo. 
      define variable VTemp_table-h as handle no-undo.
      define variable VTemp_buffer-h as handle no-undo.
      define variable Vbuffer-h as handle no-undo.
      define variable VTemp_field-h as handle no-undo.
      define variable v-tbl-row as rowid no-undo .
      define variable v-tbl-name as character no-undo .
      
      define variable vtexterr as character no-undo.
      
      define variable vi as integer no-undo.
   
      for each buf_XML-node where buf_xml-node.xmhNodName begins {&prefix-table}
      no-lock:
         VTablename  = substring(buf_xml-node.xmhNodName,length({&prefix-table}) + 1).
         create temp-table VTemp_table-h.
         VTemp_table-h:create-like( substitute('ub.&1',VTablename )) no-error.
         if error-status:error then do:
            vtexterr = substitute( "&1. Ошибка при создании temp-table &2 &3&4&5", vss-workfile,VTablename , return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) ).
            put-log(vtexterr).
            undo, return  error vtexterr.

         end.
         VTemp_table-h:temp-table-prepare( "tt-" + vtablename ) .
         
         VTemp_buffer-h = VTemp_table-h:default-buffer-handle.
         create buffer Vbuffer-h for table substitute('ub.&1', VTablename).
        
         for each buf_XML-entity where buf_XML-entity.xmh-key      = buf_XML-node.xmh-key
                                   and buf_XML-entity.xmeEntName   = {&record-table} + VTablename
         no-lock:
            VTemp_buffer-h:buffer-create() no-error.
            if error-status:error then do:
               vtexterr = substitute( "&1. Ошибка при создании записи в temp-table &2 &3&4&5", VTablename , vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) ).
               put-log(vtexterr).
               undo, return  error vtexterr.

            end.
            do vi = 1 to VTemp_buffer-h:num-fields:
               VTemp_field-h = VTemp_buffer-h:buffer-field(vi).
               find first buf_XML-field where buf_XML-field.xmh-key      = buf_XML-entity.xme-key
                                          and buf_XML-field.xmeEntName   = VTemp_field-h:name
               no-lock no-error.
               if available buf_XML-field
               then
                  VTemp_field-h:buffer-value = buf_XML-field.xmeEntValue .
               
            end.
            objKeyRec:GenKeyRec
              ( input  VTablename
               ,input VTemp_buffer-h
               ,output Vkey-rec
               ) no-error .
            if error-status :error then do:
                vtexterr = substitute( "&1. Ошибка при генерации пропущенного уникального ключа для таблицы &2.&3&4&3&5"
                              ,vss-workfile
                              ,VTablename
                              ,{&new-line}
                              ,return-value
                              ,error-status :get-message ( error-status :num-messages )
                            ).
                put-log(vtexterr).
                undo, return  error vtexterr.
                 
            end.
            objKeyRec:genrowkeyr
               ( input  Vkey-rec
                 ,input ?
                 ,input "ub"
                 ,input ?
                 ,input share-lock
                 ,output v-tbl-row
                 ,output v-tbl-name
               ) no-error .
           if error-status :error then do:
              vtexterr = substitute( "&1. Ошибка при поиске записи по уникальному ключу &2.&3&4&3&5"
                             ,vss-workfile
                             ,Vkey-rec
                             ,{&new-line}
                             ,return-value
                             ,error-status :get-message ( error-status :num-messages )
                           ).
              put-log(vtexterr).
              undo, return  error vtexterr.
              
            end.
 
            if v-tbl-name <> VTablename then do:
               vtexterr = substitute( "&1. Уникальный ключ &2 не соответствует принимаемой записи &3"
                             ,vss-workfile
                             ,Vkey-rec
                             ,VTablename
                           ).
               put-log(vtexterr).
               undo, return  error vtexterr.
               
            end.
            define variable  Vrecord-delete as logical no-undo.
            find first buf_XML-field where buf_XML-field.xmh-key      = buf_XML-entity.xme-key
                                       and buf_XML-field.xmeEntName   = "record-delete"
            no-lock no-error.
            
            assign
               vrecord-delete = no
               vrecord-delete = logical(buf_XML-field.xmeEntValue)
            no-error.
            do trans:

               Vbuffer-h:find-by-rowid( v-tbl-row, exclusive-lock ) no-error.
            
               if vrecord-delete
               then do:
                  if v-tbl-row ne ?
                  then do:
                     Vbuffer-h:buffer-delete() no-error.
                     if error-status:error then do:
                        vtexterr = substitute( "&1. Ошибка при удаление записи &2 с ключем &3 в БД  &4&5&6", vss-workfile, VTablename,Vkey-rec,  return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) ).
                        put-log(vtexterr).
                        undo, return  error vtexterr.

                     end.
                     put-log(substitute( "Запись с ключем &1 успешна удалена.",Vkey-rec)).
                  end.
                  else do:
                     put-log(substitute( "Запись с ключем &1 не существует в бд и не может быть удалена.",Vkey-rec)).
                  end.
               end.
               else do:
                  Vbuffer-h:buffer-copy(VTemp_buffer-h) no-error .

                  if error-status:error then do:
                     vtexterr = substitute( "&1. Ошибка при создание/изменение записи &2 с ключем &3 в БД  &3&4&5", vss-workfile, VTablename, Vkey-rec, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) ).
                     put-log(vtexterr).
                     undo, return  error vtexterr.

                  end.

                  Vbuffer-h:buffer-release no-error .
                  if error-status:error then do:
                     vtexterr = substitute( "&1. Ошибка при копировании записи &2 с ключем &3 в БД  &3&4&5", vss-workfile, VTablename, Vkey-rec, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) ).
                     put-log(vtexterr).
                     undo, return  error vtexterr.

                  end.
                  put-log(substitute( "Запись с ключем &1 успешна обновлена.", Vkey-rec)).
               end.

            end.
            VTemp_buffer-h:buffer-delete() no-error.
         end.
         
         delete object VTemp_table-h.
         delete object Vbuffer-h.
      end.
   end.
end class.