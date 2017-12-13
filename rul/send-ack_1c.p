
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

{ cmp/trg-def.i }
{ bge/esallatr.i  work }
{ bge/esysattr.i }
{ gbl/db-attr.i  }

define variable sw as handle no-undo.
define variable v-sender-id as character no-undo .
define variable v-receiver-id as character no-undo .
define variable v-filename as character no-undo .
define variable v-ftp-path-out as character no-undo .
define variable v-target as character no-undo .
define variable v-source as character no-undo .
define variable v-file-no-ext as character no-undo .
define variable v-type as character no-undo .
/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

run db-attr-value in this-procedure 
           (input g#db-num
           ,input {&attr-int-point}
           ,output v-sender-id
           ,output v-type
           ) no-error .

v-receiver-id = '00000' .

run ext-system-attr-value in this-procedure ( input p-esys-id
                                                    ,input 0
                                                    ,input {&attr-esys-ftp-path-out}
                                                    ,output v-ftp-path-out
                                                    ,output v-type) no-error. 
v-ftp-path-out = trim(v-ftp-path-out, "\").
v-file-no-ext = "ack_" + v-sender-id + "_00000_" + string(p-pck-num) + "_"
                          + string(day(now), "99") + string(month(now), "99") + string(year(now), "9999")
                          + substring(string(TIME, "HH:MM:SS"), 1, 2)
                          + substring(string(TIME, "HH:MM:SS"), 4, 2)
                          + substring(string(TIME, "HH:MM:SS"), 7, 2) .
v-filename = v-ftp-path-out + "\" + v-file-no-ext + ".xml" .                                                            

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
            value( v-ftp-path-out + "\" + v-file-no-ext + ".zip"  )
            value( v-ftp-path-out + "\" + v-file-no-ext + ".*"  )
          .
    os-delete value(v-filename) .