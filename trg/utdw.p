/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на изменение таблицы abc-analysis-doc-attr

Автор: 
Дата создания: 
Author: 
Creation date: 

*/

&Glob main-tbl utd
trigger procedure for write of ub.{&main-tbl}
  new buffer new-{&main-tbl}
  old buffer old-{&main-tbl}
.


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Триггер на изменение таблицы abc-analysis-doc-attr".


{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ gbl/cur-time.i }
&glob trghistnwsdef
define variable v-date      as date      no-undo .
define variable v-time      as integer   no-undo .
define variable v-field-chg as character no-undo .
define variable v-Seq       as int64     no-undo init ?.
define buffer buf_c-{&main-tbl}  for ub.c-{&main-tbl} .
&glob globobjSrv yes
def var objSrv as class ibs.th.gbl.sys.objsrv no-undo.
def var utdTHSts as class ibs.th.str.utd.sts.th no-undo.
def var utdEDISts as class ibs.th.str.utd.sts.edi no-undo.
define variable volddb-num as integer no-undo.
define variable volddoc-id as integer no-undo.
{ gbl/key-rec.i }
{str/utd-err.i}
{str/utd.i}
define buffer buf_utd for ub.utd.
main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, chr(10), error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:
  if available (old-utd) and old-utd.doc-id = 0 and not g#news
  then do:
    new-{&main-tbl}.db-num = g#db-num.
    new-{&main-tbl}.doc-id = next-value (s-utd-doc-code, {&db-name_schema}).
    new-{&main-tbl}.LoadDate = date (now).
    new-{&main-tbl}.LoadTime = time.
    new-{&main-tbl}.ModifyDate = date (now).
    new-{&main-tbl}.ModifyTime = time.
  end.
  if new-{&main-tbl}.Timestamp eq ?
  then
     new-{&main-tbl}.Timestamp = now.
  run gbl/getobjsrvhndl.p (input-output ObjSrv).

  utdTHSts = objSrv:Env:Utd:Sts:TH.
  utdEDISts = objSrv:Env:Utd:Sts:EDI.
  
  define variable vOldSts as integer no-undo.
  vOldSts = new-{&main-tbl}.sts-edi.
  
  if not g#news  
  then do:
     if not GetLastUTDinPack (new-{&main-tbl}.db-num, new-{&main-tbl}.doc-id, volddb-num, volddoc-id)
     then
         new-{&main-tbl}.sts-edi =   ObjSrv:Env:utd:Sts:edi:Changed:KeyIntDB.
      
      else if    new-{&main-tbl}.EDocType = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB
         or new-{&main-tbl}.EDocType = objSrv:Env:Utd:EDocType:Receipt:KeyIntDB
         
      then
         new-{&main-tbl}.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:RecipientResponseStatusNotAccep:KeyIntDB.
      else if new-{&main-tbl}.EDocType = objSrv:Env:Utd:EDocType:returns:KeyIntDB
      then do:
         find first buf_utd where buf_utd.OrganizationExt eq new-{&main-tbl}.parentOrganizationExt
                              and buf_utd.DocumentExt     eq new-{&main-tbl}.parentDocumentExt
                   no-lock no-error.
         if buf_utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:RecipientSignatureRequestReject:KeyIntDB
         then           
            new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:WithRecipientSignature:KeyIntDB.
         else
            new-{&main-tbl}.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:RecipientResponseStatusNotAccep:KeyIntDB.
      end.
      else if     (new-{&main-tbl}.sts-edi ne  ObjSrv:Env:Utd:Sts:edi:AutoRejected:KeyIntDB
               and new-{&main-tbl}.sts-edi < ObjSrv:Env:Utd:Sts:edi:StatFinesh)
         or new-{&main-tbl}.sts-edi eq ?
      then do:
         new-{&main-tbl}.sts-edi =    ObjSrv:Env:Utd:Sts:edi:GetKeyIntDB(new-{&main-tbl}.RevocationStatus).
         if new-{&main-tbl}.sts-edi eq ?
         then
            new-{&main-tbl}.sts-edi =    ObjSrv:Env:Utd:Sts:edi:GetKeyIntDB(new-{&main-tbl}.ReceiptStatus).
         if     new-{&main-tbl}.sts-edi < ObjSrv:Env:Utd:Sts:edi:StatFinesh
             or new-{&main-tbl}.sts-edi eq ?
         then do:
            if   new-{&main-tbl}.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:SignatureAdjustment:KeyIntDB
            then
               new-{&main-tbl}.sts-edi = new-{&main-tbl}.sts-edi.
            else if     new-{&main-tbl}.sts eq  ObjSrv:Env:utd:Sts:th:CorrectionRequested:KeyIntDB
                    and not new-{&main-tbl}.AmendmentRequested
            then
               new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:SignatureAdjustment:KeyIntDB.
            if new-{&main-tbl}.sts-edi eq ?
            then
               new-{&main-tbl}.sts-edi =    ObjSrv:Env:Utd:Sts:edi:GetKeyIntDB(new-{&main-tbl}.RecipientResponseStatus).
            if      new-{&main-tbl}.sts-edi eq ObjSrv:Env:Utd:Sts:edi:WaitingForRecipientSignature:KeyIntDB
            then do:
               if new-{&main-tbl}.sts eq  ObjSrv:Env:utd:Sts:th:Rejection:KeyIntDB
               then
                  new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:AutoRejected:KeyIntDB.
               else /*if new-{&main-tbl}.sts eq  ObjSrv:Env:utd:Sts:th:LoadError:KeyIntDB
               then
                  new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:SignatureAdjustment:KeyIntDB. 
               else*/  if new-{&main-tbl}.sts ne  ObjSrv:Env:utd:Sts:th:SignatureRequired:KeyIntDB
               then
                  new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:Verification:KeyIntDB.
            end.
         end.
      end.
      if      new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:WithRecipientSignature:KeyIntDB
          and new-{&main-tbl}.sts     = utdTHSts:SignatureRequired:KeyIntDB
      then
         new-{&main-tbl}.sts = utdTHSts:AwaitingConfirmation:KeyIntDB.
      
      if     vOldSts  >= ObjSrv:Env:Utd:Sts:edi:StatChangLoanOnlyBeg
         and vOldSts  <= ObjSrv:Env:Utd:Sts:edi:StatChangLoanOnlyEnd
         and new-{&main-tbl}.sts-edi <= ObjSrv:Env:Utd:Sts:edi:StatFinesh
      then 
         new-{&main-tbl}.sts-edi = vOldSts.
         
      if      new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:RecipientSignatureRequestReject:KeyIntDB
      then
         new-{&main-tbl}.sts = utdTHSts:Rejection:KeyIntDB.
      else if      new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:RevocationAccepted:KeyIntDB
      then
         new-{&main-tbl}.sts = utdTHSts:Canceled:KeyIntDB.
      if      new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:edi:AutoRejected:KeyIntDB
      then
         new-{&main-tbl}.sts = utdTHSts:Rejection:KeyIntDB.
      if new-{&main-tbl}.sts-edi eq ?
      then
         new-{&main-tbl}.sts-edi =    old-{&main-tbl}.sts-edi.
   end.
    
   for each ub.utd-marking-lines 
               where ub.utd-marking-lines.db-num  = new-{&main-tbl}.db-num 
                 and ub.utd-marking-lines.doc-id  = new-{&main-tbl}.doc-id
   no-lock:
      addMark(buffer ub.utd-marking-lines ).
   end.
   SetLockUTDMark(new-{&main-tbl}.db-num,new-{&main-tbl}.doc-id).
   
   changSts(new-{&main-tbl}.db-num, new-{&main-tbl}.doc-id, old-utd.RevocationStatus , new-{&main-tbl}.RevocationStatus).
   changSts(new-{&main-tbl}.db-num, new-{&main-tbl}.doc-id, old-utd.RecipientResponseStatus , new-{&main-tbl}.RecipientResponseStatus). 
&Glob main-tbl utd
{ trg/trghistnws.i 
  &hist = yes 
  &seqnamehist = "s-c-utd-chip-num"
  &histheadtbl = "c-utd-head"
  
} 
  if not g#news and not (buffer new-{&main-tbl}:handle:buffer-compare (buffer old-utd:handle)) 
  then do:
    new-{&main-tbl}.ModifyDate = date (now).
    new-{&main-tbl}.ModifyTime = time.
    if g#db-num = 0 and 
      (
      (new-{&main-tbl}.sts <> old-utd.sts
      and (
            new-{&main-tbl}.sts = utdTHSts:AwaitingDelivery:KeyIntDB
        or  old-utd.sts = utdTHSts:AwaitingDelivery:KeyIntDB
        or  new-{&main-tbl}.sts = utdTHSts:Confirmed:KeyIntDB
        or  old-utd.sts = utdTHSts:Confirmed:KeyIntDB
      ))
/*      or                               */
/*      (                                */
/*      new-{&main-tbl}.sts-edi <> old-utd.sts-edi*/
/*      and                                             */
/*      new-{&main-tbl}.sts-edi = ObjSrv:Env:Utd:Sts:EDI:Intoduce*/
/*      )*/
      )
    then do: 
      run str/callnews.p
        (input {&table_utd}
        ,input (buffer new-{&main-tbl}:handle)
        ) no-error .
      if error-status:error then do:
        undo main-block,  return error return-value .
      end.
    end.
    if not g#db-num = 0 and 
      (new-{&main-tbl}.sts <> old-utd.sts
      and (
            new-{&main-tbl}.sts ne utdTHSts:NewStatus:KeyIntDB
         
      ))
    then do: 
      run str/callnews.p
        (input {&table_utd}
        ,input (buffer new-{&main-tbl}:handle)
        ) no-error .
      if error-status:error then do:
        undo main-block,  return error return-value .
      end.
    end.
    if g#db-num = 0 and (new-{&main-tbl}.sts-edi <> old-utd.sts-edi
      and (
            new-{&main-tbl}.sts = utdEDISts:RevocationAccepted:KeyIntDB
      ))
    then do:
      run nws/cmdchgutd.p (buffer new-{&main-tbl}).
    end.
    if g#db-num ne 0 and (new-{&main-tbl}.sts-edi <> old-utd.sts-edi)
    then do:
      run nws/cmdchgutd.p (buffer new-{&main-tbl}).
    end.
    
  end.


end. /* main-block */
