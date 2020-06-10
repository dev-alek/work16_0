&scoped-define vssseq {&sequence}
def var vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{gbl\objsrv.i {1}}

&if "{1}" = "class"
&then
method private logical AddUtdErrForTab
&else
function AddUtdErrForTab returns logical
&endif
(idb-num         as integer ,
 idoc-id         as integer ,
 iTab            as character,
 iObj            as handle ,
 iCheckType      as character,
 iCodeErr        as character,
 iCheckObj       as character ):
   define buffer utd-err for utd-err.
   define variable vRecKey as character no-undo.
   &if "{1}" = "class"
      &then
         define variable objKeyRec as class ibs.th.gbl.keyrec no-undo.
         objKeyRec = new ibs.th.gbl.keyrec().
         objKeyRec:GenKeyRec ( input iTab
                              ,input iObj
                              ,output vRecKey).
         delete object objKeyRec.
                            
      &else
         run gen-key-rec (input iTab, 
                          input  iObj, 
                          output vRecKey).
      &endif
   find first utd-err where utd-err.db-num     eq idb-num
                        and utd-err.doc-id     eq idoc-id 
                        and utd-err.CheckType  eq iCheckType
                        and utd-err.CodeErr    eq iCodeErr
                        and utd-err.CheckObj   eq iCheckObj
   exclusive-lock no-error.
   if not available utd-err
   then do:
      create utd-err.
      assign
         utd-err.db-num         = idb-num
         utd-err.doc-id         = idoc-id  
         utd-err.CheckType      = iCheckType
         utd-err.CodeErr        = iCodeErr
         utd-err.CheckObj       = if iCheckObj eq ? then "?" else iCheckObj
         utd-err.reckey         = vRecKey
         utd-err.qnty           = 1
      .
   end.
   else
      utd-err.qnty = utd-err.qnty + 1.
   return utd-err.qnty eq 1.
end.

&if "{1}" = "class"
&then
method private logical AddUtdErr
&else
function AddUtdErr returns logical
&endif
(idb-num         as integer ,
 idoc-id         as integer ,
 iObj            as handle ,
 iCheckType      as character,
 iCodeErr        as character,
 iCheckObj       as character ):

   AddUtdErrForTab
      (idb-num,
       idoc-id,
       iObj:table,
       iObj,
       iCheckType,
       iCodeErr,
       iCheckObj).
end.


&if "{1}" = "class"
&then
method private void ClearUtdErr
&else
function ClearUtdErr returns logical
&endif
(idb-num         as integer,
 idoc-id         as integer ,
 iCheckType      as character
 ):
   define buffer utd-err for utd-err.
   if    iCheckType eq "*"
      or iCheckType eq ?
   then do:
      for each utd-err where utd-err.db-num  eq idb-num
                         and utd-err.doc-id  eq idoc-id 
      exclusive-lock:
         delete utd-err.
      end.
   end.
   else do:
      for each utd-err where utd-err.db-num     eq idb-num
                         and utd-err.doc-id     eq idoc-id 
                         and utd-err.CheckType  eq iCheckType
      exclusive-lock:
         delete utd-err.
      end.
   end.
end.

&if "{1}" = "class"
&then
method private character GetMesError
&else
function GetMesError returns character
&endif
(itxt as character, 
 iobj as character ):
 define variable vi as integer no-undo.
 do vi = num-entries(iobj ,{&delim-par} ) to 1 by -1 :
    itxt = replace(itxt,"&" + string(vi),entry(vi,iobj,{&delim-par})).
 end.   
 return itxt.
end.

&if "{1}" = "class"
&then
method private character GetTextError
&else
function GetTextError returns character
&endif
(iCheckType as character, 
 iCodeErr   as character,
 iChechObj  as character ):
   define buffer code    for code.
   define variable vError as character no-undo.
   find first code where code.parent eq "CodeError" +  {&delim-par}  + "UTD" +  {&delim-par} + iCheckType
                     and code.code   eq iCodeErr
   no-lock no-error.
   if available code
   then
      vError = GetMesError(Code.CodeValue,iChechObj).
   else
      vError =  iCodeErr + ":" + replace (iChechObj,{&delim-par},"|").   
   return vError.
end.



/*function GetErrXmlForUtd returns character 

(idb-num     as integer ,
 idoc-id     as integer ,
 iCheckType  as character
 ) forward.
*/




&if "{1}" = "class"
&then
method private character GetErrForUtdstr
&else
function GetErrForUtdStr returns character 
&endif
(idb-num     as integer ,
 idoc-id     as integer ,
 iCheckType  as character
 ):
/*    GetErrXmlForUtd(iOrganizationId,iDocumentId,iCheckType).*/
   define buffer utd-err for utd-err.
   define buffer code    for code.
   define variable vHQry as handle no-undo.
   define variable vError as longchar no-undo.
   define variable oError as character no-undo.
   create query vHQry.
   vHQry:set-buffers(buffer utd-err:handle).
   vHQry:query-prepare("for each utd-err where utd-err.db-num         eq " + QUOTER(idb-num) 
                            +            " and utd-err.doc-id         eq " + QUOTER(idoc-id)  
                            + if    iCheckType eq "*" 
                                 or iCheckType eq ? 
                              then       "" 
                              else       " and utd-err.CheckType      eq " + QUOTER(iCheckType)).
   vHQry:query-open().
   vHQry:get-first().

   QRY-BLOCK:
   repeat while not vHQry:query-off-end:
      
      vError = vError + ", " + GetTextError(utd-err.CheckType,utd-err.CodeErr,utd-err.CheckObj).
      
      vHQry:get-next().
   end.
   oError = substring(vError,3,4002).
   return oError.
end.

&if "{1}" = "class"
&then
method private character GetErrJsonForUtd
&else
function GetErrJsonForUtd returns character 
&endif
(idb-num         as integer ,
 idoc-id         as integer ,
 iCheckType      as character
 ):
   define buffer utd-err for utd-err.
   define variable vHQry as handle no-undo.
   define variable vError as longchar no-undo.
   define variable oError as character no-undo.
   create query vHQry.
   define variable vi as integer no-undo.
   vHQry:set-buffers(buffer utd-err:handle).
   vHQry:query-prepare("for each utd-err where utd-err.db-num         eq " + QUOTER(idb-num) 
                            +            " and utd-err.doc-id         eq " + QUOTER(idoc-id)  
                            + if    iCheckType eq "*" 
                                 or iCheckType eq ? 
                              then       "" 
                              else       " and utd-err.CheckType      eq " + QUOTER(iCheckType)).
   vHQry:query-open().
   vHQry:get-first().

   QRY-BLOCK:
   repeat while not vHQry:query-off-end:
      vi = vi + 1.  
      vError = vError + ',"Ошибка_' + string(vi) +  '":~{"КодОш":"'    + utd-err.CheckType + "_" + utd-err.CodeErr 
                      + '","ОбъектОш":"' + replace(utd-err.CheckObj,{&delim-par},"|") 
                      + '","ТекстОш":"' + GetTextError(utd-err.CheckType,utd-err.CodeErr,utd-err.CheckObj) + '"}'.
      vHQry:get-next().
   end.
   for first utd where utd.db-num eq idb-num
                   and utd.doc-id eq idoc-id
                   and utd.sts    eq ObjSrv:Env:Utd:Sts:th:DeliveryCodeMismatch:KeyIntDB
   no-lock,
      each utd-marking-lines where utd-marking-lines.db-num eq idb-num
                               and utd-marking-lines.doc-id eq idoc-id
                               and utd-marking-lines.doc-level eq 1
   no-lock,
      first marking where marking.mark eq utd-marking-lines.mark
                      and marking.sts  eq ObjSrv:Env:Marking:Sts:Mark:NotAvailable:KeyIntDB
   no-lock:
      vError = vError + ',"Ошибка_' + string(vi) +  '":~{"КодОш":"'    + "CheckShip" + "_" + "NotMark" 
                      + '","ОбъектОш":"' + marking.mark 
                      + '","ТекстОш":"' + GetTextError("CheckShip","NotMark",marking.mark) + '"}'.
   end.
   if vError ne ""
   then
      oError = '"Ошибки":~{' + substring(vError,2,31002) + "}".
   /* output to "c:\11\diadoc\error.xml".
   put unformatted oError.
   output close. */
   return oError.
end.

&if "{1}" = "class"
&then
method private character GetErrJsonForUtdReturn
&else
function GetErrJsonForUtdReturn returns character 
&endif
(idb-num         as integer ,
 idoc-id         as integer ,
 iCheckType      as character
 ):
   define buffer utd-err for utd-err.
   define variable vHQry as handle no-undo.
   define variable vError as longchar no-undo.
   define variable oError as character no-undo.
   define variable vi as integer no-undo.
   create query vHQry.
   vHQry:set-buffers(buffer utd-err:handle).
   vHQry:query-prepare("for each utd-err where utd-err.db-num         eq " + QUOTER(idb-num) 
                            +            " and utd-err.doc-id         eq " + QUOTER(idoc-id)  
                            + if    iCheckType eq "*" 
                                 or iCheckType eq ? 
                              then       "" 
                              else       " and utd-err.CheckType      eq " + QUOTER(iCheckType)).
   vHQry:query-open().
   vHQry:get-first().

   QRY-BLOCK:
   repeat while not vHQry:query-off-end:
      vi = vi + 1.
      vError = vError + ',"Возврат_' + string(vi) +  '":~{"КодВозр":"'    + utd-err.CheckType + "_" + utd-err.CodeErr 
                      + '","ОбъектВозр":"' + replace(utd-err.CheckObj,{&delim-par},"|") 
                      + '","ТекстВозр":"' + GetTextError(utd-err.CheckType,utd-err.CodeErr,utd-err.CheckObj) + '"}'.
      vHQry:get-next().
   end.
   if vError ne ""
   then 
      oError = '"Возвраты":~{' + substring(vError,2,31002) + "}".
   /* output to "c:\11\diadoc\error.xml".
   put unformatted oError.
   output close. */
   return oError.
end.

&if "{1}" = "class"
&then
method private character GetCodeTextError
&else
function GetCodeTextError returns character
&endif
(iCheckType as character, 
 iCodeErr   as character,
 iChechObj  as character,
 output oCode as character, 
 output ovalue as character ):
   define buffer code    for code.
   
   find first code where code.parent eq "CodeError" +  {&delim-par}  + "UTD" +  {&delim-par} + iCheckType
                     and code.code   eq iCodeErr
   no-lock no-error.
   if     available code
      and Code.misc1 ne ?
      and Code.misc1 ne ""
   then
      assign
         oCode  = GetMesError(Code.misc1,iChechObj)
         ovalue = GetMesError(Code.misc2,iChechObj)
      .
     
   return if oCode eq ""
          then "" 
          else (oCode + "_" + ovalue).
          
end.

define temp-table TT-err no-undo
  field code_ as character 
  field text_ as character
index code_ code_.

&if "{1}" = "class"
&then
method private character GetErrTxtForUtd
&else
function GetErrTxtForUtd returns character 
&endif
(idb-num         as integer ,
 idoc-id         as integer ,
 iCheckType      as character
 ):
   define buffer utd-err for utd-err.
   define variable vHQry as handle no-undo.
   
   define variable oError as character no-undo.
   create query vHQry.
   define variable vi as integer no-undo.
   vHQry:set-buffers(buffer utd-err:handle).
   vHQry:query-prepare("for each utd-err where utd-err.db-num         eq " + QUOTER(idb-num) 
                            +            " and utd-err.doc-id         eq " + QUOTER(idoc-id)  
                            + if    iCheckType eq "*" 
                                 or iCheckType eq ? 
                              then       "" 
                              else       " and utd-err.CheckType      eq " + QUOTER(iCheckType)).
   vHQry:query-open().
   vHQry:get-first().
   define variable vcode as character no-undo.
   define variable vvalue as character no-undo.
   QRY-BLOCK:
   repeat while not vHQry:query-off-end:
      vi = vi + 1.
      GetCodeTextError (utd-err.CheckType, utd-err.CodeErr, utd-err.CheckObj, output vcode, output vvalue).
      find first tt-err where tt-err.code eq vcode
      no-error.
      if not available tt-err
      then do:
         create tt-err.
         assign
            tt-err.code_ = vcode
            tt-err.text_ = vvalue
         .
      end.
      else
         tt-err.text_ = tt-err.text_ + "||" + vvalue.
         
      vHQry:get-next().
   end.
   for first utd where utd.db-num eq idb-num
                   and utd.doc-id eq idoc-id
/*                   and utd.sts    eq ObjSrv:Env:Utd:Sts:th:DeliveryCodeMismatch:KeyIntDB */
   no-lock,
      each utd-marking-lines where utd-marking-lines.db-num eq idb-num
                               and utd-marking-lines.doc-id eq idoc-id
                               and utd-marking-lines.doc-level eq 1
   no-lock,
      first marking where marking.mark eq utd-marking-lines.mark
                      and marking.sts  eq ObjSrv:Env:Marking:Sts:Mark:NotAvailable:KeyIntDB
   no-lock:
      GetCodeTextError ("CheckShip", "MARKDECLINED", utd-marking-lines.mark + {&delim-par} + string(utd-marking-lines.LineNum), output vcode, output vvalue).
      find first tt-err where tt-err.code eq vcode
      no-error.
      if not available tt-err
      then do:
         create tt-err.
         assign
            tt-err.code_ = vcode
            tt-err.text_ = vvalue
         .
      end.
      else
         tt-err.text_ = tt-err.text_ + "||" + vvalue.
     
   end.
   for each tt-err:
      oError = oError + substitute("&1|&2|",tt-err.code_ , tt-err.text_ ) + chr(13) + chr(10) .
   end.
   
   return oError.
end.
define variable mFormatErr as character no-undo init "text".
&if "{1}" = "class"
&then
method private character GetErrForUtd
&else
function GetErrForUtd returns character 
&endif
(idb-num         as integer ,
 idoc-id         as integer ,
 iType           as character
 ):
   if mFormatErr eq "text"
   then
      return GetErrTxtForUtd(idb-num,idoc-id,iType).
   else do:
      if itype eq "return"
      then return GetErrJsonForUtdReturn (idb-num,idoc-id,iType).
      else return GetErrJsonForUtd(idb-num,idoc-id,iType).
   end.
end.

&if "{1}" = "class"
&then
method private longchar GetErrComText
&else
function GetErrComText returns longchar 
&endif
(icomment as character,
 itext    as longchar ):
    define variable vText as longchar no-undo.
   if mFormatErr eq "text"
   then do:
      if icomment ne ""
      then
         icomment = substitute("comment:|&1|",icomment).
      vText = icomment + itext.
   end.
   else do:
      icomment = if icomment begins  '"' 
                 then icomment  
                 else  if icomment eq "" then "" else ( '"Коментрии":~{"Коментарий":"' + icomment  + '"}') .
      vText = icomment + "," + itext.
      vText = "~{" + trim(vText,",") + "~}".
   end.
   return vText.
      
end.
