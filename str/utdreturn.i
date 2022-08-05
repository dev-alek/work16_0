{cmp\str-glbl.i {1}}
{str\utd-err.i {1}}
&if defined(globobjSrv) eq 0
&then 
&glob globobjSrv yes
def var objSrv as class ibs.th.gbl.sys.objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).
&endif
define temp-table tt-return
  field db-num as integer 
  field doc-id as integer
  field mark like marking.mark
index docid db-num doc-id.
&if "{1}" = "class"
&then
method private logical canUtdReturn
&else
function  canUtdReturn returns logical
&endif
(input idoc-code as character ):
   define variable Vflag as logical no-undo.
   find first trn-doc where trn-doc.doc-code     eq idoc-code
                        and (trn-doc.ext-doc-type eq {&TDEDT_Ras_Vnesh_VP}
                             or trn-doc.ext-doc-type eq {&TDEDT_Ras_Vnesh}) 
   no-lock no-error.
   find first utd where utd.doc-code eq trn-doc.doc-code
                    and utd.EDocType eq objSrv:Env:Utd:EDocType:returns:KeyIntDB no-lock no-error.
   if         available trn-doc
      and not available utd
   then
      Vflag = yes.
      
   
   return Vflag.
end.

define variable mySeqUtd as int64 no-undo init ?.
procedure MySeqForUtd:
   define input  parameter iTable       as character no-undo.
   define input  parameter iseqnamehist as character no-undo.
   define input  parameter idb-name     as character no-undo.
   define output parameter Oseq         as int64 no-undo.
   if iTable begins "utd"
   then do:
      if myseqUtd eq ?
      then 
         myseqUtd = dynamic-next-value(iseqnamehist,idb-name).
      Oseq = myseqUtd.
   end.
   else
      Oseq = ?. 
   return.
end.

&if "{1}" = "class"
&then
method private logical crUtdReturn
&else
function  crUtdReturn returns logical
&endif
(input idoc-code as character ):
   define buffer trn-doc               for trn-doc.
   define buffer parts                 for parts.
   define buffer goods                 for goods.
   define buffer marking-lines         for marking-lines.
   define buffer marking               for marking.
   define buffer utd                   for utd.
   define buffer Buf_utd               for utd.
   define buffer utd-lines             for utd-lines.
   define buffer Buf_utd-lines         for utd-lines.
   define buffer utd-marking-lines     for utd-marking-lines.
   define buffer Buf_utd-marking-lines for utd-marking-lines.
   define variable vi as integer no-undo.
   define variable vFlag as logical no-undo.
   define variable vdb-num as integer no-undo.
   define variable vdoc-id as integer no-undo.
   
   find first trn-doc where trn-doc.doc-code     eq idoc-code
                        and (  trn-doc.ext-doc-type eq {&TDEDT_Ras_Vnesh_VP}
                            or trn-doc.ext-doc-type eq {&TDEDT_Ras_Vnesh})    
   no-lock no-error.
   find first utd where utd.doc-code eq trn-doc.doc-code
                    and utd.EDocType eq objSrv:Env:Utd:EDocType:returns:KeyIntDB no-lock no-error.
   if         available trn-doc
      and not available utd
   then do:
      block-part:
      for each parts where parts.out-code eq trn-doc.doc-code
      no-lock break by parts.in-code  :
         find first goods where goods.artic eq parts.artic
                            and goods.prod-type eq parts.prod-type
                            and goods.prod-code eq parts.prod-code
         no-lock no-error.
         if not available goods
         then do:
            message "Не найден товар по помтавщику " parts.prod-type  parts.prod-code " с аркиклом "  parts.artic
               view-as alert-box.
            next block-part. 
         end.
         else do:
            find first marking-lines where marking-lines.gds-code   = goods.gds-code
                                     and marking-lines.obj-type   = parts.obj-type
                                     and marking-lines.obj-code   = parts.obj-code
                                     and marking-lines.in-code    = parts.in-code
                                     and marking-lines.out-code   = parts.out-code
                                     and marking-lines.part-code  = parts.part-code
                                     and marking-lines.prt-code   = parts.prt-code
                                     and marking-lines.doc-level  = 1
            no-lock no-error.
            subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
            if available marking-lines
            then do trans:
               
               find first utd where utd.doc-code eq parts.in-code no-lock no-error.
               if available utd
               then do:
                  if first-of(parts.in-code)
                  then do:
                     
                     MySeqUtd = ?.
                     vFlag = yes.
                     create buf_utd.
                     buffer-copy utd  except Timestamp  
                                             RevocationStatus 
                                             RecipientResponseStatus 
                                             ReceiptStatus 
                                             OrganizationExt  
                                             ModifyTime 
                                             ModifyDate  
                                             LoadTime  
                                             LoadDate 
                                             EDocType  
                                             DocumentExt 
                                             db-num 
                                             doc-id
                                             AdditInfo
                                             doc-code
                                             sts 
                     to buf_utd
                     assign
                        buf_utd.parentDocumentExt     = utd.DocumentExt
                        buf_utd.parentOrganizationExt = utd.OrganizationExt
                        buf_utd.doc-code              = trn-doc.doc-code
                        buf_utd.EDocType              = objSrv:Env:Utd:EDocType:returns:KeyIntDB
                        buf_utd.DocumentDate    = today
                        buf_utd.DocumentNumber  = "Возврат по " + utd.DocumentNumber + " за " + string(utd.DocumentDate,"99/99/9999")
                           
                        
                     .
                     validate buf_utd.
                     Buf_utd.sts                   = ObjSrv:Env:Utd:Sts:th:SignatureRequired:KeyIntDB. /* меняе после получения doc-id */ 
                     Buf_utd.sts-edi               = if utd.AmendmentRequested 
                                                     then ObjSrv:Env:Utd:Sts:edi:AvailAdjustment:KeyIntDB 
                                                     else ObjSrv:Env:Utd:Sts:edi:WaitingForRecipientSignature:KeyIntDB.
                     assign 
                        vdb-num = Buf_utd.db-num
                        vdoc-id = Buf_utd.doc-id
                     .
                  end.
                  else
                     find first Buf_utd where Buf_utd.db-num eq vdb-num
                                          and Buf_utd.doc-id eq vdoc-id
                                          exclusive-lock.
                  for each marking-lines where marking-lines.gds-code   = goods.gds-code
                                           and marking-lines.obj-type   = parts.obj-type
                                           and marking-lines.obj-code   = parts.obj-code
                                           and marking-lines.in-code    = parts.in-code
                                           and marking-lines.out-code   = parts.out-code
                                           and marking-lines.part-code  = parts.part-code
                                           and marking-lines.prt-code   = parts.prt-code
                                           and marking-lines.doc-level  = 1 
                  no-lock:
                     find first utd-marking-lines where utd-marking-lines.db-num eq utd.db-num
                                                    and utd-marking-lines.doc-id eq utd.doc-id
                                                    and utd-marking-lines.mark   eq marking-lines.mark
                     no-lock no-error.
                     if available utd-marking-lines
                     then do:
                        create buf_utd-marking-lines.
                        buffer-copy utd-marking-lines  except db-num 
                                                              doc-id 
                        to buf_utd-marking-lines
                        assign
                           buf_utd-marking-lines.db-num     = buf_utd.db-num
                           buf_utd-marking-lines.doc-id     = buf_utd.doc-id
                           buf_utd-marking-lines.site       = "-"
                           buf_utd-marking-lines.doc-level  = marking-lines.doc-level
                        .
                        find first buf_utd-lines where buf_utd-lines.db-num  eq buf_utd.db-num
                                                   and buf_utd-lines.doc-id  eq buf_utd.doc-id
                                                   and buf_utd-lines.LineNum eq utd-marking-lines.LineNum
                        no-lock no-error.
                        if not available buf_utd-lines
                        then do:
                           find first utd-lines where utd-lines.db-num  eq utd-marking-lines.db-num
                                                  and utd-lines.doc-id  eq utd-marking-lines.doc-id
                                                  and utd-lines.LineNum eq utd-marking-lines.LineNum
                           no-lock no-error.
                           if available utd-lines
                           then do:
                              create buf_utd-lines.
                              buffer-copy utd-lines  except db-num 
                                                            doc-id
                              to buf_utd-lines
                              assign
                                 buf_utd-lines.db-num     = buf_utd.db-num
                                 buf_utd-lines.doc-id     = buf_utd.doc-id
                              .
                              buf_utd-lines.Total =  utd-lines.Total / utd-lines.Quantity * parts.fact-qnty.
                              buf_utd-lines.TotalWithVatExcluded =  utd-lines.TotalWithVatExcluded / utd-lines.Quantity * parts.fact-qnty.
                              buf_utd-lines.Vat =   utd-lines.vat / utd-lines.Quantity * parts.fact-qnty.
                              buf_utd-lines.Quantity = parts.fact-qnty.
                           
                           end.
                           release buf_utd-lines.     
                        end.
                        
                        if buf_utd-marking-lines.doc-level eq 1
                        then do:
                           AddUtdErr(buf_utd.db-num,
                                  buf_utd.doc-id,
                                  buffer buf_utd-marking-lines:handle,
                                  "return",
                                  "Mark",
                                  buf_utd-marking-lines.mark + {&delim-par} + (if available buf_utd-lines then  buf_utd-lines.ProductCode else goods.gds-name)). 
                        end.
                     end.
                     release buf_utd-marking-lines. 
                  end.
                  if last-of(parts.in-code)
                  then do:
                     buf_utd.Total = 0.
                     buf_utd.Vat   = 0.
                     for each buf_utd-lines where buf_utd-lines.db-num eq buf_utd.db-num
                                              and buf_utd-lines.doc-id eq buf_utd.doc-id
                     no-lock:
                        buf_utd.Total = buf_utd.Total + buf_utd-lines.Total.
                        buf_utd.Vat   = buf_utd.Vat   + buf_utd-lines.Vat.
                     end.
                  
                     release buf_utd.
                  end.
                  
               end.
               else do:
                  if first-of(parts.in-code)
                  then do:
                     MySeqUtd = ?.
                     vFlag = yes. 
                     create buf_utd.
                     assign
                        buf_utd.contract-code   = parts.contract-code
                        buf_utd.doc-code        = trn-doc.doc-code
                        buf_utd.DocumentDate    = today
                        buf_utd.DocumentNumber  = "Возврат по накладной " + parts.in-code
                        buf_utd.EDocType        = objSrv:Env:Utd:EDocType:returns:KeyIntDB
                        buf_utd.host-code       = parts.host-code
                        buf_utd.obj-type        = parts.obj-type
                        buf_utd.obj-code        = parts.obj-code
                        buf_utd.cli-type        = trn-doc.cli-type
                        buf_utd.cli-code        = trn-doc.cli-code
                        
                        vi = 0
                     .
                     validate buf_utd.
                     define variable conf-par as character no-undo.
                     define variable mode-erprn as logical no-undo.
                     define variable par-type as character no-undo.
                      { gbl/conf-rd.i
                        "'is-erpRN'"
                         0
                         "''"
                         0
                         "''"
                         "''"
                         "''"
                         NO
                         conf-par
                         par-type
                         no-error
                         }
                     if not error-status:error and conf-par = "yes":U then mode-erprn = yes.
                     else mode-erprn = no.
                   buf_utd.sts             = if mode-erprn  
                                             then ObjSrv:Env:Utd:Sts:th:Confirmed:KeyIntDB
                                             else ObjSrv:Env:Utd:Sts:th:SignatureRequired:KeyIntDB.
                     
                     
                     Buf_utd.sts-edi         = if mode-erprn  
                                               then ObjSrv:Env:Utd:Sts:EDI:Verification:KeyIntDB
                                               else ObjSrv:Env:Utd:Sts:edi:WaitingForRecipientSignature:KeyIntDB.
                  
                     assign 
                        vdb-num = Buf_utd.db-num
                        vdoc-id = Buf_utd.doc-id
                     .
                  end.
                  else
                     find first Buf_utd where Buf_utd.db-num eq vdb-num
                                          and Buf_utd.doc-id eq vdoc-id
                                          exclusive-lock.
                  create buf_utd-lines.
                  assign
                     vi                      = vi + 1
                     buf_utd-lines.Article   = parts.artic
                     buf_utd-lines.db-num    = buf_utd.db-num
                     buf_utd-lines.doc-id    = buf_utd.doc-id
                     buf_utd-lines.LineNum   = vi
                     buf_utd-lines.gds-code     = goods.gds-code
                     buf_utd-lines.ProductCode  = goods.gds-name
                     buf_utd-lines.Quantity     = parts.fact-qnty
                     buf_utd-lines.Price        = parts.price-cli
                     buf_utd-lines.TaxRate      = parts.VAT-pc
                     buf_utd-lines.Total        = parts.price-cli * parts.fact-qnty
                     buf_utd-lines.UnitCode     = goods.unit-cli
                     buf_utd-lines.Vat          = buf_utd-lines.Total * parts.VAT-pc / 100
                     buf_utd-lines.TotalWithVatExcluded = buf_utd-lines.Total  - buf_utd-lines.Vat
                  .
                  for each marking-lines where marking-lines.gds-code   = goods.gds-code
                                           and marking-lines.obj-type   = parts.obj-type
                                           and marking-lines.obj-code   = parts.obj-code
                                           and marking-lines.in-code    = parts.in-code
                                           and marking-lines.out-code   = parts.out-code
                                           and marking-lines.part-code  = parts.part-code
                                           and marking-lines.prt-code   = parts.prt-code
                                           and marking-lines.doc-level  = 1
                  no-lock:
                     create buf_utd-marking-lines.
                     assign
                        buf_utd-marking-lines.db-num     = buf_utd.db-num
                        buf_utd-marking-lines.doc-id     = buf_utd.doc-id
                        buf_utd-marking-lines.site       = "-"
                        buf_utd-marking-lines.doc-level  = marking-lines.doc-level
                        buf_utd-marking-lines.gds-code   = goods.gds-code
                        buf_utd-marking-lines.LineNum    = buf_utd-lines.LineNum
                        buf_utd-marking-lines.mark       = marking-lines.mark
                        buf_utd-marking-lines.sts        = marking-lines.sts
                     .
                     if buf_utd-marking-lines.doc-level eq 1
                     then 
                        AddUtdErr(buf_utd.db-num,buf_utd.doc-id,buffer buf_utd-marking-lines:handle,"return","Mark",marking-lines.mark + {&delim-par} + buf_utd-lines.ProductCode).
                     release buf_utd-marking-lines.
                  end.
                  release buf_utd-lines.
                  if last-of(parts.in-code)
                  then do:
                     buf_utd.Total = 0.
                     buf_utd.Vat   = 0.
                     for each buf_utd-lines where buf_utd-lines.db-num eq buf_utd.db-num
                                           and buf_utd-lines.doc-id eq buf_utd.doc-id
                     no-lock:
                        buf_utd.Total = buf_utd.Total + buf_utd-lines.Total.
                        buf_utd.Vat   = buf_utd.Vat   + buf_utd-lines.Vat.
                     end.
                     release buf_utd.
                  end.
               end.
               
               
            end.
            unsubscribe "getNextseq".
         end.
      end.
   end.
   return vFlag.
end.