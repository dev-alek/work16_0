&scoped-define vssseq {&sequence}
def var vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{gbl\objsrv.i {1}}
{ gbl/attr-lib.i {1}}
{str/utd-attr.i {1} }
define temp-table TT-err no-undo
  field code_ as character 
  field text_ as character
index code_ code_.
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
method private character GetTextErrorType
&else
function GetTextErrorType returns character
&endif
(iCheckType as character, 
 iCodeErr   as character,
 iChechObj  as character,
 iType      as character  ):
   define buffer code    for code.
   define variable vError as character no-undo.
   find first code where code.parent eq "CodeError" +  {&delim-par}  + "UTD" +  {&delim-par} + iCheckType
                     and code.code   eq iCodeErr
   no-lock no-error.
   if available code
   then do:
      case itype:
         when "error" 
         then do:
            if int(code.misc3) eq 0
            then
               vError = GetMesError(Code.CodeValue,iChechObj).
         end.
         when "warning" 
         then do:
            if int(code.misc3) <= 1
            then
               vError = GetMesError(Code.CodeValue,iChechObj).
         end.
         otherwise do:
            vError = GetMesError(Code.CodeValue,iChechObj).
         end.
      end.
   end.
   else
      vError =  iCodeErr + ":" + replace (iChechObj,{&delim-par},"|").   
   return vError.
end.

&if "{1}" = "class"
&then
method private integer  GetTypeError
&else
function GetTypeError returns integer 
&endif
(iCheckType as character, 
 iCodeErr   as character):
   define buffer code    for code.
   find first code where code.parent eq "CodeError" +  {&delim-par}  + "UTD" +  {&delim-par} + iCheckType
                     and code.code   eq iCodeErr
   no-lock no-error.
   return if available code then int(code.misc3) else 0.
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
   return GetTextErrortype(iCheckType,iCodeErr,iChechObj,"warning").
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
   define variable vErrorOne as longchar  no-undo.
   
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
      vErrorOne = GetTextErrorType(utd-err.CheckType,utd-err.CodeErr,utd-err.CheckObj,"error").
      if     vErrorOne ne ""
         and vErrorOne ne ?
      then
         vError = vError + ", " + vErrorOne.
      
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
   define variable vErrorOne as longchar  no-undo.
   
   define variable oError as character no-undo.
   create query vHQry.
   define variable vi as integer no-undo.
   for each tt-err :
      delete tt-err.
   end. 
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
      vErrorOne = GetTextErrorType(utd-err.CheckType,utd-err.CodeErr,utd-err.CheckObj,"error").
      if     vErrorOne ne ?
         and vErrorOne ne ""
      then do:
         vi = vi + 1.  
         vError = vError + ',"Ошибка_' + string(vi) +  '":~{"КодОш":"'    + utd-err.CheckType + "_" + utd-err.CodeErr 
                         + '","ОбъектОш":"' + replace(utd-err.CheckObj,{&delim-par},"|") 
                         + '","ТекстОш":"' + vErrorOne + '"}'.
      end.
      vHQry:get-next().
   end.
   define variable vMarkUtd as logical no-undo.
   define buffer buf_utd-attr for utd-attr.
   find first buf_utd-attr no-lock where buf_utd-attr.doc-id = idoc-id
                                     and buf_utd-attr.db-num = idb-num
                                     and buf_utd-attr.attr-code = "MarkUtd"
                                     no-error .
   if available buf_utd-attr
   then do :                                 
      vMarkUtd = logical(buf_utd-attr.attr-value) .                             
   end .
   else do :
      vMarkUtd = yes .
   end.
   if vMarkUtd
   then do:
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
         vErrorOne = GetTextErrortype("CheckShip","NotMark",marking.mark,"error").
         if     vErrorOne ne ?
            and vErrorOne ne ""
         then do:
         
            vError = vError + ',"Ошибка_' + string(vi) +  '":~{"КодОш":"'    + "CheckShip" + "_" + "NotMark" 
                            + '","ОбъектОш":"' + marking.mark 
                            + '","ТекстОш":"' + vErrorOne + '"}'.
         end.
      end.
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
      define variable vErrorOne as character no-undo.
      vErrorOne = GetTextErrorType(utd-err.CheckType,utd-err.CodeErr,utd-err.CheckObj,"error").
      if     vErrorOne ne ?
         and vErrorOne ne ""
      then do:
         vi = vi + 1.
         vError = vError + ',"Возврат_' + string(vi) +  '":~{"КодВозр":"'    + utd-err.CheckType + "_" + utd-err.CodeErr 
                         + '","ОбъектВозр":"' + replace(utd-err.CheckObj,{&delim-par},"|") 
                         + '","ТекстВозр":"' + GetTextError(utd-err.CheckType,utd-err.CodeErr,utd-err.CheckObj) + '"}'.
      end.
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
   then do:
      if     int(Code.misc3) > 0
      then
         oCode = ?.
      else if     Code.misc1 ne ?
              and Code.misc1 ne ""
      then
         assign
            oCode  = GetMesError(Code.misc1,iChechObj)
            ovalue = GetMesError(Code.misc2,iChechObj)
         .
   end.   
      
     
   return if oCode eq ""
          then "" 
          else (oCode + "_" + ovalue).
          
end.

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
   for each tt-err :
      delete tt-err.
   end. 
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
      if vcode ne ?
      then do:
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
      vHQry:get-next().
   end.
   define variable vMarkUtd as logical no-undo.
   define buffer buf_utd-attr for utd-attr.
   find first buf_utd-attr no-lock where buf_utd-attr.doc-id = idoc-id
                                     and buf_utd-attr.db-num = idb-num
                                     and buf_utd-attr.attr-code = "MarkUtd"
                                     no-error .
   if available buf_utd-attr
   then do :                                 
      vMarkUtd = logical(buf_utd-attr.attr-value) .                             
   end .
   else do :
      vMarkUtd = yes .
   end.
   if vMarkUtd
   then do:
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
   end.
   else do:
      define buffer cancel_utd-lines for utd-lines.
      for each cancel_utd-lines where cancel_utd-lines.db-num eq idb-num
                                  and cancel_utd-lines.doc-id eq idoc-id
      no-lock:
         define variable vqnty as decimal no-undo.
         vqnty = decimal(GetAttrUtdlines(cancel_utd-lines.db-num,cancel_utd-lines.doc-id,cancel_utd-lines.linenum,"QuantityBarCode")).
         if vqnty eq ? then vqnty = 0.
         if vqnty ne cancel_utd-lines.Quantity
         then do:
            GetCodeTextError ("CheckShip", "NotAcceptQuantity", string(cancel_utd-lines.LineNum) + {&delim-par} + string(cancel_utd-lines.Quantity - vqnty), output vcode, output vvalue).
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
      end.
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
&if "{1}" = "class"
&then
method private logical  CheckErrForLine
&else
function CheckErrForLine returns logical 
&endif
(iObj            as handle ):
   define variable vRecKey-line     as character no-undo.
   define variable vRecKey-markLine as character no-undo.
     define buffer buf_utd-err for utd-err.
     define variable vUtdlineError as logical no-undo.
     &if "{1}" = "class"
      &then
         define variable objKeyRec as class ibs.th.gbl.keyrec no-undo.
         objKeyRec = new ibs.th.gbl.keyrec().
         objKeyRec:GenKeyRec ( input "utd-lines"
                              ,input iObj
                              ,output vRecKey-line).
         delete object objKeyRec.
                            
      &else
         run gen-key-rec (input "utd-lines", 
                          input  iObj, 
                          output vRecKey-line).
      &endif
      define variable vdb-num as integer no-undo.
      define variable vdoc-id as integer no-undo.
      define variable vlinenum as integer no-undo.
      vdb-num = iObj::db-num.
      vdoc-id = iObj::doc-id.
      vlinenum = iObj::linenum.
      block-err:
      for each buf_utd-err  where  buf_utd-err.doc-id = vdoc-id
                               and buf_utd-err.db-num = vdb-num
                               and buf_utd-err.reckey = vRecKey-line
                                  
      no-lock:
         define variable vErrorOne as character no-undo.
         vErrorOne = GetTextErrorType(buf_utd-err.CheckType,buf_utd-err.CodeErr,buf_utd-err.CheckObj,"error").
         if     vErrorOne ne ?
            and vErrorOne ne ""
         then do:
            vUtdlineError = yes.
            leave block-err.
         end.
      end.
      if  not vUtdlineError
      then do:
         define variable vGoodMark as logical no-undo.
         find first utd-marking-lines where utd-marking-lines.db-num  eq vdb-num
                                        and utd-marking-lines.doc-id  eq vdoc-id
                                        and utd-marking-lines.LineNum eq vLineNum
         no-lock no-error.
         vGoodMark = not available utd-marking-lines.
         block-line-err:
         for each utd-marking-lines where utd-marking-lines.db-num  eq vdb-num
                                      and utd-marking-lines.doc-id  eq vdoc-id
                                      and utd-marking-lines.LineNum eq vLineNum
         no-lock:
            &if "{1}" = "class"
            &then
               objKeyRec = new ibs.th.gbl.keyrec().
               objKeyRec:GenKeyRec ( input "utd-lines"
                                    ,input iObj
                                    ,output vRecKey-line).
               delete object objKeyRec.
                            
            &else
               run gen-key-rec (input "utd-marking-lines", 
                                input  buffer utd-marking-lines:handle, 
                                output vRecKey-markLine).
            &endif
            vGoodMark = yes.
            block-mark-err:
            for each buf_utd-err  where  buf_utd-err.doc-id = vdoc-id
                                     and buf_utd-err.db-num = vdb-num
                                     and buf_utd-err.reckey = vRecKey-markLine
                                        
            no-lock:
               vErrorOne = GetTextErrorType(buf_utd-err.CheckType,buf_utd-err.CodeErr,buf_utd-err.CheckObj,"error").
               if     vErrorOne ne ?
                  and vErrorOne ne ""
               then do:
                  vGoodMark = no.
                  leave block-mark-err.
               end.
            end.
            if vGoodMark
            then
               leave block-line-err.
         end.
         vUtdlineError = not vGoodMark. 
      end.
   
   return vUtdlineError.
end.
&if "{1}" = "class"
&then
method public logical CheckMarkUtd
&else
function CheckMarkUtd return logical 
&endif
 (input idb-num as integer, 
 input idoc-id as integer):
 define buffer utd                   for utd.
 define buffer utd-lines             for utd-lines.
 define buffer utd-marking-lines     for utd-marking-lines.
 
 define variable v-par-type as character no-undo.
 define variable vgdsNoMark as logical no-undo.
 define variable EDOParSec as class ibs.th.gbl.env.prmtrs.edo .
 
   define variable v-par-val  as character no-undo.
   find first utd where utd.db-num eq idb-num
                    and utd.doc-id eq idoc-id
   no-lock no-error.
   if available utd
   then do:
      if     utd.obj-code ne ?
         and utd.obj-type ne ?
      then do:
         EDOParSec = ObjSrv:Env:ParametrsOfSection:GetSectionEDO(utd.obj-type, utd.obj-code).
         Block-utd-lines:
         for each utd-lines where utd-lines.db-num eq idb-num
                              and utd-lines.doc-id eq idoc-id
         no-lock:
            if     utd-lines.gds-code ne ?
               and utd-lines.gds-code ne 0
            then do:
               &scop proc-name gds-attr-value
                {&run_proc_attr-lib}
                    ( utd-lines.gds-code,
                      {&attr-mark-type},
                       output v-par-val,
                       output v-par-type
                    ).
               if     EDOParSec:IsEdo 
                  and EDOParSec:GetIsMarkingForTypeEDO(v-par-val)  
               then do:
            
                  find first utd-marking-lines where utd-marking-lines.db-num  eq utd-lines.db-num
                                                 and utd-marking-lines.doc-id  eq utd-lines.doc-id
                                                 and utd-marking-lines.LineNum eq utd-lines.LineNum
                                                 and length(utd-marking-lines.mark) > 13
                  no-lock no-error.
                  if     avail utd-marking-lines 
                     and not CheckErrForLine(buffer utd-lines:handle)
                  then
                     leave Block-utd-lines.
               end.
               else
                  vgdsNoMark = yes.
            end.
         end.
         setattrutd (utd.db-num,utd.doc-id,"MarkUtd",if vgdsNoMark then string(available utd-lines) else "yes").
         if vgdsNoMark then return available utd-lines . else return yes .
      end.
   end.
   return yes.
end.

&if "{1}" = "class"
&then
method public logical CheckMarking
&else
function CheckMarking return logical 
&endif
 (input idb-num as integer, 
 input idoc-id as integer,
 input iTypeErr as character ):
  define variable vMarkutd as logical no-undo.
  define variable vCrErr   as logical no-undo.
  define buffer utd-lines         for utd-lines.
  define buffer utd-err           for utd-err.
  define buffer utd-marking-lines for utd-marking-lines.
  define buffer marking           for marking.
  for each utd-err where utd-err.db-num     eq idb-num
                     and utd-err.doc-id     eq idoc-id 
                     and utd-err.CheckType  eq iTypeErr
                     and utd-err.CodeErr    eq "NotMark"
  exclusive-lock:
     delete utd-err.
  end.
  CheckMarkUtd(idb-num,idoc-id).
  vMarkutd = logical(getattrutdex (idb-num,idoc-id,"MarkUtd","yes")).
  if vMarkutd
  then do: 
      block-line:
      for each utd-lines where utd-lines.db-num eq idb-num
                           and utd-lines.doc-id eq idoc-id
      no-lock:
         for each utd-marking-lines 
                  where utd-marking-lines.db-num  = utd-lines.db-num 
                    and utd-marking-lines.doc-id  = utd-lines.doc-id
                    and utd-marking-lines.LineNum = utd-lines.LineNum
         no-lock:
            find first marking where marking.mark eq utd-marking-lines.mark
            no-lock no-error.
            if not available marking
            then do:
               AddUtdErr(utd-lines.db-num,utd-lines.doc-id,buffer utd-lines:handle,iTypeErr,"NotMark",string(utd-lines.LineNum)).
               vCrErr = yes.
               next block-line.
            end.
         end.      
      end.
   end.
   return vCrErr.
end.