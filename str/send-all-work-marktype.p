/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Ростовцев Александр 
Дата создания: 08.04.2024
Author:  Rostovtsev Aleksandr
Creation date: 08.04.2024

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
&Scoped-define source "1"
define variable mdb-num   as integer   no-undo.
define variable mObjType  as character no-undo.
define variable mObjCode  as integer   no-undo.
define variable mPostType as character no-undo.
define variable mCashNum  as integer   no-undo.

{ gbl/cd-attr.i}

procedure putc :
   define input parameter iSAXWriter as handle no-undo .
   define input parameter i-action   as character  no-undo .
   define input parameter p-value    as character  no-undo .
   define output parameter oSend      as logical    no-undo.
   
   define variable vTypesForKass as character no-undo.
   define variable vTimeDate as character no-undo.
   define variable vCount        as integer   no-undo.
   define buffer buf_code for ub.code.
   
   for each buf_code where 
            buf_code.parent = "MarkType"
        and logical(buf_code.misc2)
       no-lock by int(buf_code.code):
      vTypesForKass = substitute("&1,&2", vTypesForKass, buf_code.code).     
   end.
   if vTypesForKass <> "" then
   do:
      vTypesForKass = substring(vTypesForKass,2). 
      iSAXWriter:start-element("Param") .
        iSAXWriter:insert-attribute("ctrl", "ADD").
        iSAXWriter:insert-attribute("group", "GS1").
        iSAXWriter:insert-attribute("key", "MACC_Types").
   
        iSAXWriter:write-data-element("ParamValue" , vTypesForKass ) .
        iSAXWriter:write-data-element("ParamDesc" , "Типы маркированной продукции для проверка по БД").
      iSAXWriter:end-element("Param" ).
      
      iSAXWriter:start-element("Param") .
        iSAXWriter:insert-attribute("ctrl", "ADD").
        iSAXWriter:insert-attribute("group", "GS1").
        iSAXWriter:insert-attribute("key", "MARK_REQ_TYPES").
   
        iSAXWriter:write-data-element("ParamValue" , vTypesForKass ) .
        iSAXWriter:write-data-element("ParamDesc" , "Типы, подлежашие обязательной маркировке").
      iSAXWriter:end-element("Param" ).
   
      do vCount = 1 to num-entries(vTypesForKass):
         find first buf_code where 
                    buf_code.parent = "MarkType"
                and buf_code.code   = entry(vCount, vTypesForKass)
              no-lock no-error.
         vTimeDate = substitute("&1 &2", 
           string(int(buf_code.misc4),"HH:MM"), 
           string(date(buf_code.misc3),"99.99.9999")).
         iSAXWriter:start-element("Param") .
            iSAXWriter:insert-attribute("ctrl", "ADD").
            iSAXWriter:insert-attribute("group", "GS1").
            iSAXWriter:insert-attribute("key", "MARK_REQ_DATE_" + buf_code.code).
       
            iSAXWriter:write-data-element("ParamValue" , vTimeDate) .
            iSAXWriter:write-data-element("ParamDesc" , "Время и Дата начала обязательной маркировки").
         iSAXWriter:end-element("Param" ).
      end.
   end.
   oSend = true.
end procedure.

/* Invoked to report a warning. */
procedure Warning:
  define input parameter ErrMessage as character no-undo.
  message "The following WARNING was generated:~n" + ErrMessage
       view-as alert-box info buttons ok.
end procedure.
    
/* Invoked to report an error encountered by the parser while parsing the XML document. */
procedure Error:
  define input parameter ErrMessage as character no-undo.
  message "The following NONFATAL ERROR was generated:~n" + ErrMessage
       view-as alert-box info buttons ok.
end procedure.

/* Invoked to report a fatal error. */
procedure FatalError:
  define input parameter ErrMessage as character no-undo.
  return error "The following FATAL ERROR was generated:~n" + ErrMessage.
end procedure.

 