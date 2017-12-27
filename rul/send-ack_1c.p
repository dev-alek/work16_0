
/*------------------------------------------------------------------------
    File        : send-ack_1c.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : SSlivenko
    Created     : Tue Nov 28 01:01:54 AST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define input parameter p-pck-num as integer no-undo .
define input parameter p-status_ as integer no-undo .
define input parameter p-error   as character no-undo .
define input parameter p-esys-id like ub.ext-system-attr.esys-id    no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Генерация и отправка файла-ответа для 1С РН".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ bge/esallatr.i  work }
{ bge/esysattr.i }
{ gbl/db-attr.i  }
{ bge/oxml-def.i }

function esys-id-format returns character ( input p-esys-id as integer):
  return string(p-esys-id, "99999").
end.

FUNCTION nws-db-format returns character ( input p-db-num as integer):
  define variable v-nws-db-format as character no-undo .
  assign
    v-nws-db-format = string( p-db-num,  (if p-db-num > 999 then "99999":U else "999":U ) )
  .
  return v-nws-db-format.
END FUNCTION.

define variable sw as handle no-undo.
define variable v-sender-id as character no-undo .
define variable v-receiver-id as character no-undo .
define variable v-work-dir as character no-undo .
define variable v-filename as character no-undo .
define variable v-target-dir as character no-undo .
define variable v-target as character no-undo .
define variable v-source as character no-undo .
define variable v-file-no-ext as character no-undo .
define variable v-type as character no-undo .
define variable v-mess as character no-undo .
/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

run db-attr-value in this-procedure 
           (input g#db-num
           ,input {&attr-int-point}
           ,output v-sender-id
           ,output v-type
           ) no-error .

v-receiver-id = '00000' .

v-work-dir   = nws-db-format( g#db-num ) + "-":U + "ES" + esys-id-format( p-esys-id ) .
v-target-dir = oxml-exch-dir + {&back-slash-char} + v-work-dir .

v-file-no-ext = "ack_" + v-sender-id + "_00000_" + string(p-pck-num) + "_"
                          + string(day(now), "99") + string(month(now), "99") + string(year(now), "9999")
                          + substring(string(TIME, "HH:MM:SS"), 1, 2)
                          + substring(string(TIME, "HH:MM:SS"), 4, 2)
                          + substring(string(TIME, "HH:MM:SS"), 7, 2) .
v-filename = v-target-dir + {&back-slash-char} + v-file-no-ext + ".xml" .           

assign
  file-info:file-name = v-target-dir
.
if file-info:file-type = ?
  or not ( file-info:file-type begins "D":U ) then do:
  os-create-dir value( v-target-dir ).
  if os-error <> 0 then do:
     run gbl/os-errnm.p ( input os-error
                         ,output v-mess) .
     undo, return error substitute("&1 Каталог &2 отсутствует, а создать его не удалось.&3&4"
                           ,vss-workfile
                           ,v-target-dir
                           ,{&new-line}
                           ,v-mess
                         ).
  end.
end.                                                 

    create sax-writer sw.
    sw:formatted = true.
    sw:set-output-destination ("file", v-filename).
   
    sw:encoding = "UTF-8".
    sw:start-document () .
    
    sw:start-element ("GC-ERPRN-ACK") .
    
    
    sw:insert-attribute ("xmlns", "http://www.rosneft.ru/GasComplex/Retail") .
    sw:insert-attribute ("xmlns:xs", "http://www.w3.org/2001/XMLSchema") .
    sw:insert-attribute ("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance") .
        sw:write-data-element ("num", string(p-pck-num)) .
        sw:write-data-element ("sender-id", v-sender-id) .
        sw:write-data-element ("reciever-id", v-receiver-id) .
        sw:write-data-element ("created-date", iso-date (now)) .
        sw:write-data-element ("status", string(p-status_)) .
        sw:write-data-element ("error", p-error) .
    sw:end-element ("GC-ERPRN-ACK") .

    sw:end-document () .
    
    os-command silent
            value( search('exe/pkzipc.exe':U) )
            value( "-add -path=none -span=700 ":U )
            value( v-target-dir + "\" + v-file-no-ext + ".zip"  )
            value( v-target-dir + "\" + v-file-no-ext + ".*"  )
          .
    os-delete value(v-filename) .