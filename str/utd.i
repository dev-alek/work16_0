&if "{1}" = "class"
&then
method public logical GetLastUTDForPac
&else
function GetLastUTDForPac returns logical 
&endif
(iPackegeId as character ,
 iTimestamp as datetime,
 output odb-num as integer,
 output odoc-id as integer ):
   define buffer buf_utd for utd.
   find last buf_utd where Buf_utd.PackageId eq iPackegeId
                             and Buf_utd.EDocType  eq objSrv:Env:Utd:EDocType:UTD:KeyIntDB
                             and Buf_utd.Timestamp gt iTimestamp
   no-lock no-error.
   if available  buf_utd
   then
      assign
         odb-num = buf_utd.db-num
         odoc-id = buf_utd.doc-id
      no-error.
   else
      assign
         odb-num = ?
         odoc-id = ?
      no-error.
end.

&if "{1}" = "class"
&then
method public logical GetLastUTDinPack
&else
function GetLastUTDinPack returns logical 
&endif
(input idb-num as integer, 
 input idoc-id as integer,
 output odb-num as integer,
 output odoc-id as integer ):
   define buffer buf_utd for utd.
   define buffer     utd for utd.
   find first utd where utd.db-num eq idb-num
                    and utd.doc-id eq idoc-id
   no-lock no-error.
   if available utd
   then do:
      if utd.PackageId eq ""
      then do:
         assign
            odb-num = utd.db-num
            odoc-id = utd.doc-id
         .
         return yes.
      end.
      else do:
         GetLastUTDForPac(utd.PackageId,utd.Timestamp,output odb-num,output odoc-id ).
         if    odb-num eq ?
            or odoc-id eq ?
         then do:
            assign
               odb-num = utd.db-num
               odoc-id = utd.doc-id
            .
            return yes.
         end. 
         else
            return no.
      end.  
   end.
   return ?.
end.

&if "{1}" = "class"
&then
method public void addMark
&else
function addMark returns logical 
&endif
( buffer utd-marking-lines for utd-marking-lines ):
   define buffer buf_utd-marking-line for utd-marking-lines.
   for each marking where marking.mark-parent eq utd-marking-lines.mark no-lock:
      find first buf_utd-marking-line where buf_utd-marking-line.db-num    eq utd-marking-lines.db-num
                                        and buf_utd-marking-line.doc-id    eq utd-marking-lines.doc-id
/*                                        and buf_utd-marking-line.linenume  eq utd-marking-lines.LineNum*/
                                        and buf_utd-marking-line.mark      eq marking.mark
      no-lock no-error.
      if available  buf_utd-marking-line
      then do:
         if buf_utd-marking-line.doc-level ne utd-marking-lines.doc-level + 1
         then do:
            find current  buf_utd-marking-line exclusive-lock no-error.
            if available buf_utd-marking-line
            then
               buf_utd-marking-line.doc-level = utd-marking-lines.doc-level + 1.
         end.
      end.
      else do:
         create buf_utd-marking-line.
         buffer-copy utd-marking-lines except doc-level mark sts to buf_utd-marking-line
         assign
            buf_utd-marking-line.doc-level = utd-marking-lines.doc-level + 1
            buf_utd-marking-line.mark      = marking.mark
            buf_utd-marking-line.sts       = marking.sts
         .
         
      end.
      addMark(buffer buf_utd-marking-line).
   end.
end.

&if "{1}" = "class"
&then
method public void unLockUTDMark
&else
function UnLockUTDMark returns logical 
&endif
(idb-num as integer ,idoc-id as integer ):
   define buffer old_utd for utd.
   define variable voldkey    as character no-undo.
 /* снимаем старую блокировку */
   find first old_utd where old_utd.db-num eq idb-num 
                        and old_utd.db-num eq idoc-id
   no-lock no-error.
   if available old_utd
   then do:
      &if "{1}" = "class"
      &then
         define variable objKeyRec as class ibs.th.gbl.keyrec no-undo.
         objKeyRec = new ibs.th.gbl.keyrec().
         objKeyRec:GenKeyRec ( input {&table_utd}
                              ,input buffer old_utd:handle
                              ,output voldkey).
         delete object objKeyRec.
                            
      &else
         run gen-key-rec (input "utd", 
                          input  buffer old_utd:handle, 
                          output voldkey).
      &endif
      for each marking where marking.loc-key eq voldkey
      exclusive-lock:
         marking.loc-key = "".
         marking.sts =  ObjSrv:Env:Marking:Sts:Mark:UnknowSts:KeyIntDB.
      end.
   end.
end.

&if "{1}" = "class"
&then
method public void changSts
&else
function changSts returns logical 
&endif 
(idb-num as integer ,
 idoc-id as integer , 
 old_sts_edo as character , 
 new_sts_edo as character  ):
   if     old_sts_edo ne new_sts_edo
      and ( new_sts_edo eq "RevocationAccepted"
           or  new_sts_edo eq "RecipientSignatureRequestRejected"
           )
   then
      UnLockUTDMark(idb-num,idoc-id).
end.
&if "{1}" = "class"
&then
method public void SetLockUTDMark
&else
function SetLockUTDMark returns logical 
&endif
(idb-num as integer ,idoc-id as integer ):
   define buffer new_utd for utd.
   define buffer old_utd for utd.
   
   define variable volddb-num as integer no-undo.
   define variable volddoc-id as integer no-undo.
   
   define variable voldkey    as character no-undo.
   define variable vnewkey    as character no-undo.
   
   find first new_utd where new_utd.db-num eq idb-num 
                        and new_utd.doc-id eq idoc-id
   no-lock no-error.
   if not GetLastUTDinPack (new_utd.db-num,new_utd.doc-id,volddb-num,volddoc-id)
   then do trans:
      find first old_utd where old_utd.db-num eq volddb-num 
                           and old_utd.doc-id eq volddoc-id
      no-lock no-error.
      &if "{1}" = "class"
      &then
         define variable objKeyRec as class ibs.th.gbl.keyrec no-undo.
         objKeyRec = new ibs.th.gbl.keyrec().
         objKeyRec:GenKeyRec ( input {&table_utd}
                              ,input buffer new_utd:handle
                              ,output vnewkey).
         objKeyRec:GenKeyRec ( input {&table_utd}
                              ,input buffer old_utd:handle
                              ,output voldkey).
         delete object objKeyRec.
                            
      &else
         run gen-key-rec (input "utd", 
                          input  buffer new_utd:handle, 
                          output vnewkey).
         run gen-key-rec (input "utd", 
                          input  buffer old_utd:handle, 
                          output voldkey).
      &endif
      for each utd-marking-lines where utd-marking-lines.db-num eq new_utd.db-num
                                   and utd-marking-lines.doc-id eq new_utd.doc-id
      no-lock:
         find first marking where marking.mark eq utd-marking-lines.mark no-lock no-error.
         if available  marking
         then do:
            if    marking.loc-key eq ""
               or marking.loc-key eq ?
               or marking.loc-key eq voldkey
            then do:
               find current marking exclusive-lock no-error.
               if available marking
               then do:
                  marking.loc-key = vnewkey.
                  release marking.
               end.
            end.
            else if marking.loc-key ne vnewkey
            then do: 
               addutderr(new_utd.db-num,new_utd.doc-id,buffer new_utd:handle,"LoadUtd","MarkLock",marking.mark + {&delim-par} + marking.loc-key).
              
            end.
         end.
         
      end.
      UnLockUTDMark(old_utd.db-num,old_utd.doc-id).
   end.
   
   
   
end.

