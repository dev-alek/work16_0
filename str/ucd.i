
&if "{1}" = "class"
&then
method public logical CheckUcdForReturn
&else
function CheckedocMark return logical 
&endif
(input idb-numorig as integer,
 input idoc-idorig as integer,
 input idb-numedoc as integer,
 input idoc-idedoc as integer  ):
    define variable VChekOk as logical no-undo init yes.
    
    for each utd-marking-lines where utd-marking-lines.db-num    eq idb-numorig
                                 and utd-marking-lines.doc-id    eq idoc-idorig
                                 and utd-marking-lines.doc-level eq 1
                                 and utd-marking-lines.sts       eq objSrv:Env:marking:Sts:Mark:Checked_:KeyIntDB
    no-lock:
       create tt-utd-mark.
       buffer-copy utd-marking-lines to tt-utd-mark
       assign
          tt-utd-mark.side = "+"
       .
    end.
    for each utd-marking-lines where utd-marking-lines.db-num eq idb-numedoc
                                 and utd-marking-lines.doc-id eq idoc-idedoc
                                 and utd-marking-lines.doc-level eq 1
    no-lock:
       find first tt-utd-mark where tt-utd-mark.mark eq utd-marking-lines.mark
       no-lock no-error.
       if available tt-utd-mark
       then
          tt-utd-mark.side = "".
       else do:
          create tt-utd-mark.
          buffer-copy utd-marking-lines to tt-utd-mark
          assign
             tt-utd-mark.side = "-"
          .
       end.
    end.
    for each tt-utd-mark where  tt-utd-mark.side ne ""
    no-lock:
       AddUtdErrForTab(idb-numedoc, idoc-idedoc, "utd-marking-lines", buffer tt-utd-mark:handle, "edoc", "MarkOrig" + tt-utd-mark.side, tt-utd-mark.mark).
       VChekOk = no.
    end.
end.



&if "{1}" = "class"
&then
method private character CheckEdoc
&else
function CheckEdoc returns character  
&endif
(idb-numOrig as integer ,
 idoc-idOrig as integer,
 idb-num as integer ,
 idoc-id as integer ):
   define buffer utd  for ub.utd. 
   define buffer utd-lines  for ub.utd-lines.
   define buffer utd-marking-lines  for ub.utd-marking-lines.
   define buffer edoc-lines for ub.utd-lines.
   define variable vSts as integer no-undo.
   vSts = objSrv:Env:utd:Sts:th:ReceivedFromSupplier:KeyIntDB.
   for each utd-lines where utd-lines.db-num eq idb-num
                         and utd-lines.doc-id eq idoc-id
    exclusive-lock:
       
       find first utd-marking-lines where utd-marking-lines.db-num  eq utd-lines.db-num
                                      and utd-marking-lines.doc-id  eq utd-lines.doc-id
                                      and utd-marking-lines.linenum eq utd-lines.LineNum
       no-lock no-error.
       
       if available utd-marking-lines
       then do:
          if    utd-lines.Price                eq 0
             or utd-lines.Total                eq 0
             or utd-lines.TotalWithVatExcluded eq 0
             or utd-lines.Quantity             eq 0
          then
             AddUtdErr(utd-lines.db-num,utd-lines.doc-id,buffer utd-lines:handle,"Edoc","Amount" , string(utd-lines.LineNum )).
       end.
       else do:
          if    utd-lines.Total                ne 0
/*            or utd-lines.TotalWithVatExcluded ne 0*/
             or utd-lines.Quantity             ne 0
          then
             AddUtdErr(utd-lines.db-num,utd-lines.doc-id,buffer utd-lines:handle,"Edoc","Mark" ,string(utd-lines.LineNum)).
          else
             delete utd-lines.
       end.
    end.
   find first utd-marking-lines where utd-marking-lines.db-num eq idb-numOrig
                                  and utd-marking-lines.doc-id eq idoc-idOrig
                                  and utd-marking-lines.sts    eq objSrv:Env:marking:Sts:Mark:Checked_:KeyIntDB
   no-lock no-error.
   if available utd-marking-lines
   then do:
      
      for each utd-lines where utd-lines.db-num eq idb-numOrig
                           and utd-lines.doc-id eq idoc-idOrig
      no-lock:
         find first edoc-lines where edoc-lines.db-num eq idb-numOrig
                                 and edoc-lines.doc-id eq idoc-idOrig
                                 and edoc-lines.LineNum eq utd-lines.LineNum
         no-lock no-error.
         if     available edoc-lines
            and edoc-lines.Quantity ne 0
         then do:
            if edoc-lines.Price ne utd-lines.Price
            then
               AddUtdErr(edoc-lines.db-num,edoc-lines.doc-id,buffer edoc-lines:handle,"Edoc","Price" ,string(edoc-lines.LineNum)).
         end.
      end.
      vSts = objSrv:Env:utd:Sts:th:SignatureRequired:KeyIntDB. /* Требует подписания */
      CheckedocMark(idb-numOrig , idoc-idOrig , idb-num , idoc-id).
   end.
   
   define variable vError as character no-undo.
   vError = GetErrForUtdstr(idb-num,idoc-id,"edoc").
   if vError ne ""
   then
      vSts = objSrv:Env:utd:Sts:th:edocError:KeyIntDB.
   else
      vSts = objSrv:Env:utd:Sts:th:SignatureRequired:KeyIntDB.
   find first utd where utd.db-num eq idb-num
                    and utd.doc-id eq idoc-id
   exclusive-lock no-error.
   if available utd 
   then do:
      utd.sts = vsts.
/*      utd.AdditInfo = vError.*/
   end.
   
end.
&if "{1}" = "class"
&then
method public char getattrUtdlines
&else
function getattrUtdlines returns char 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 ilinenum  as integer, 
 iattrcode as character ):
   define buffer utd-attr for utd-attr.
   find first utd-lines-attr where utd-lines-attr.db-num    eq idb-num
                               and utd-lines-attr.doc-id    eq idoc-id
                               and utd-lines-attr.lineNum   eq ilineNum
                               and utd-lines-attr.attr-code eq iattrcode
   no-lock no-error.
   if  available utd-lines-attr
   then 
      return
         utd-lines-attr.attr-value
      . 
   
end.
&if "{1}" = "class"
&then
method private void CrEdoc
&else
function CrEdoc returns character  
&endif
(iPack as character ,
 iTimestamp as datetime):
   define variable vdb-num as integer no-undo.
   define variable vdoc-id as integer no-undo.
   
   define buffer utd  for ub.utd.
   define buffer edoc for ub.utd.
   define buffer utd-attr  for ub.utd-attr.
   define buffer edoc-attr for ub.utd-attr.
   define buffer utd-lines  for ub.utd-lines.
   define buffer edoc-lines for ub.utd-lines.
   define buffer utd-lines-attr  for ub.utd-lines-attr.
   define buffer edoc-lines-attr for ub.utd-lines-attr.
   define buffer utd-marking-lines  for ub.utd-marking-lines.
   define buffer edoc-marking-lines for ub.utd-marking-lines.
   define buffer utd-marking-lines-attr for ub.utd-marking-lines-attr.
   define buffer edoc-marking-lines-attr for ub.utd-marking-lines-attr.
   
   define variable vTimestamp  as datetime no-undo.
/* Если есть edoc позже */
   find last utd where utd.PackageId eq iPack
                   and utd.EDocType  eq objSrv:Env:Utd:EDocType:edoc:KeyIntDB
                   and utd.Timestamp ge iTimestamp
   no-lock no-error.
   if available utd
   then
      return "Есть документ позже".
      
   find last utd where utd.PackageId eq iPack
                   and utd.EDocType  eq objSrv:Env:Utd:EDocType:ucd:KeyIntDB
                   and utd.Timestamp le iTimestamp
   no-lock no-error.
   if not available utd
   then
      return "Не найден УКД".
   define variable vdb-numOrig as integer no-undo.
   define variable vdoc-idOrig as integer no-undo.  
   find last utd where utd.PackageId eq iPack
                   and utd.EDocType  eq objSrv:Env:Utd:EDocType:UTD:KeyIntDB
                   and utd.Timestamp le iTimestamp
   no-lock no-error.
   if available utd
   then do:
      /* Копируем оригенальный документ */
      subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
      MySeqUtd = ?.
      vTimestamp = utd.Timestamp.
      create edoc.
      vdb-num = utd.db-num.
      vdoc-id = utd.doc-id.
      
      buffer-copy utd except doc-id db-num DocumentExt OrganizationExt to edoc
      assign
         edoc.EDocType = objSrv:Env:Utd:EDocType:edoc:KeyIntDB
         edoc.Timestamp = iTimestamp + 1
         edoc.AmendmentRequested = no
         edoc.sts-edi  = objSrv:Env:Utd:sts:edi:WaitingForRecipientSignature:KeyIntDB
      .
      validate edoc.
      for each utd-attr where utd-attr.db-num eq vdb-num 
                          and utd-attr.doc-id eq vdoc-id
                          and utd-attr.attr-code ne "ststhbeforeCorrection"
                          and utd-attr.attr-code ne "sendcode"
      no-lock:
         create edoc-attr.
         buffer-copy utd-attr except doc-id db-num to edoc-attr
         assign
            edoc-attr.db-num = edoc.db-num
            edoc-attr.doc-id = edoc.doc-id
            
         .
      end.
      for each utd-lines where utd-lines.db-num eq vdb-num 
                           and utd-lines.doc-id eq vdoc-id
      no-lock:
         create edoc-lines.
         buffer-copy utd-lines except doc-id db-num to edoc-lines
         assign
            edoc-lines.db-num = edoc.db-num
            edoc-lines.doc-id = edoc.doc-id
         .
      end.
      for each utd-lines-attr where utd-lines-attr.db-num eq vdb-num 
                                and utd-lines-attr.doc-id eq vdoc-id
      no-lock:
         create edoc-lines-attr.
         buffer-copy utd-lines-attr except doc-id db-num to edoc-lines-attr
         assign
            edoc-lines-attr.db-num = edoc.db-num
            edoc-lines-attr.doc-id = edoc.doc-id
         .
      end.
      for each utd-marking-lines where utd-marking-lines.db-num eq vdb-num 
                                   and utd-marking-lines.doc-id eq vdoc-id
      no-lock:
         create edoc-marking-lines.
         buffer-copy utd-marking-lines except doc-id db-num to edoc-marking-lines
         assign
            edoc-marking-lines.db-num = edoc.db-num
            edoc-marking-lines.doc-id = edoc.doc-id
         .
      end.
      for each utd-marking-lines-attr where utd-marking-lines-attr.db-num eq vdb-num 
                                        and utd-marking-lines-attr.doc-id eq vdoc-id
      no-lock:
         create edoc-marking-lines-attr.
         buffer-copy utd-marking-lines-attr except doc-id db-num to edoc-marking-lines-attr
         assign
            edoc-marking-lines-attr.db-num = vdb-num
            edoc-marking-lines-attr.doc-id = vdoc-id
         .
      end.
/* Добавляем разницу укд */
      for each utd where utd.PackageId eq iPack
                     and utd.EDocType  eq objSrv:Env:Utd:EDocType:Ucd:KeyIntDB
                     and utd.Timestamp gt vTimestamp
                     and utd.Timestamp le iTimestamp
/*                     and utd.sts-edi ne*/
      no-lock by utd.PackageId by utd.EDocType by utd.Timestamp:
         edoc.Total = edoc.Total + utd.total.
         edoc.Vat = edoc.Vat + utd.Vat.
         
         edoc.DocumentDate = utd.DocumentDate.
         edoc.Timestamp = utd.Timestamp + 1.
         for each utd-lines where utd-lines.db-num     = utd.db-num
                              and utd-lines.doc-id     = utd.doc-id
                                
         no-lock:
            find first edoc-lines where edoc-lines.db-num      = edoc.db-num
                                    and edoc-lines.doc-id      = edoc.doc-id
                                    and edoc-lines.ProductCode = utd-lines.ProductCode
            exclusive-lock no-error.
            if not available edoc-lines
            then do: 
               find last edoc-lines where edoc-lines.db-num      = edoc.db-num
                                      and edoc-lines.doc-id      = edoc.doc-id
               no-lock no-error.
               define variable vline as integer no-undo.
               vline = if available edoc-lines then edoc-lines.linenum + 1 else 1.
               create edoc-lines.
               buffer-copy utd-lines except doc-id db-num linenum to edoc-lines
               assign
                  edoc-lines.db-num = edoc.db-num
                  edoc-lines.doc-id = edoc.doc-id
                  edoc-lines.linenum = vline
               .
            end.
            else
               assign
                  edoc-lines.Vat       = dec(getattrUtdlines(utd-lines.db-num,utd-lines.doc-id,utd-lines.LineNum,"Vat_old") )  + utd-lines.Vat
                  edoc-lines.Total     = dec(getattrUtdlines(utd-lines.db-num,utd-lines.doc-id,utd-lines.LineNum,"Total_old") )   + utd-lines.Total
                  edoc-lines.Quantity  = edoc-lines.Quantity + utd-lines.Quantity.
                  edoc-lines.TotalWithVatExcluded = edoc-lines.Total - edoc-lines.Vat.
               .
            for each utd-marking-lines where utd-marking-lines.db-num eq utd-lines.db-num 
                                         and utd-marking-lines.doc-id eq utd-lines.doc-id
                                         and utd-marking-lines.LineNum eq utd-lines.LineNum
            no-lock:
               if utd-marking-lines.site eq "-"
               then do:
                  find first edoc-marking-lines where edoc-marking-lines.db-num eq edoc-lines.db-num 
                                                  and edoc-marking-lines.doc-id eq edoc-lines.doc-id
                                                  and edoc-marking-lines.mark   eq utd-marking-lines.mark
                  exclusive-lock no-error.
                  if available edoc-marking-lines
                  then
                     delete edoc-marking-lines.
                  else
                     AddUtdErr(edoc.db-num,edoc.doc-id,buffer edoc-lines:handle,"edoc","Mark" + utd-marking-lines.site,utd-marking-lines.mark).
               end.
               
               else if utd-marking-lines.site eq "+"
               then do:
                  find first edoc-marking-lines where edoc-marking-lines.db-num eq edoc-lines.db-num 
                                                  and edoc-marking-lines.doc-id eq edoc-lines.doc-id
                                                  and edoc-marking-lines.mark   eq utd-marking-lines.mark
                  no-lock no-error.
                  if not available edoc-marking-lines
                  then do:
                     create edoc-marking-lines.
                     buffer-copy utd-marking-lines except doc-id db-num linenum to edoc-marking-lines
                     assign
                        edoc-marking-lines.db-num  = edoc-lines.db-num
                        edoc-marking-lines.doc-id  = edoc-lines.doc-id
                        edoc-marking-lines.linenum = edoc-lines.linenum
                     .
                  end.
                  else
                     AddUtdErr(edoc.db-num,edoc.doc-id,buffer edoc-lines:handle,"Edoc","Mark" + utd-marking-lines.site,utd-marking-lines.mark).
               end.
            end.
         end.
      end.
      CheckEdoc (vdb-num,vdoc-id,edoc.db-num,edoc.doc-id) .
      for each utd where utd.PackageId eq iPack
                     and utd.EDocType  eq objSrv:Env:Utd:EDocType:edoc:KeyIntDB
                     and utd.Timestamp < iTimestamp
      exclusive-lock:
         utd.sts-edi = objSrv:Env:Utd:sts:edi:Changed:KeyIntDB.
         utd.sts     = objSrv:Env:Utd:sts:th:Rejection:KeyIntDB.
      end.
   
      unsubscribe "getNextseq".
   end.
end.