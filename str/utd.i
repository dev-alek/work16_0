
{ref/extclass.i}
define temp-table tt-utd-mark like utd-marking-lines
  field side as character.
{utl/gtin.i {1}}

&if "{1}" ne "class"
&then
function GetAttrUtdlines returns char 

(idb-num   as integer,
 idoc-id   as integer,
 ilinenum  as integer, 
 iattrcode as character ) forward.

function setAttrUtdlines returns logical 

(idb-num    as integer,
 idoc-id    as integer,
 ilinenum   as integer, 
 iattrcode  as character,
 iattrvalue as character ) forward.

&endif

&if "{1}" = "class"
&then
method public logical getObgFns
&else
function getObgFns return logical 
&endif
(input iDocumentNumber   as character ,
 input iFnsParticipantId as character ,
 input ikpp              as character ,
 output ohost-code       as integer,
 output oobj-type        as character ,
 output oobj-code        as integer ,
 output otext            as character  ):
    define buffer ext-classif   for ext-classif. 
    define buffer clients       for clients.
    define buffer buf_clients   for clients.
    define buffer clients-attr  for clients-attr.
    find first ext-classif where ext-classif.classif-name  eq {&extclass_code_id_diadok_client}
                             and ext-classif.charkey_three eq iFnsParticipantId
    no-lock no-error.
    if available ext-classif
    then do:
       if ext-classif.CharKey_One eq {&shop}
       then do:
          assign 
             oobj-type = ext-classif.CharKey_One
             oobj-code = ext-classif.Key#_One
          .
          find first clients 
               where clients.obj-type   = ext-classif.CharKey_One
                 and clients.obj-code   = ext-classif.Key#_One
          no-lock no-error .
          if available clients
          then
             ohost-code =  clients.host-code.
       end.
       else do:
          find first clients 
               where clients.obj-type   = ext-classif.CharKey_One
                 and clients.obj-code   = ext-classif.Key#_One
                 and can-find(first ub.sysconf where ub.sysconf.host-code = clients.obj-code)
          no-lock no-error .
          if not available clients
          then do:
             otext = substitute("По &1 получатель  &2 не наша фирма." ,iDocumentNumber, iFnsParticipantId) .
             return no.
          end.
          ohost-code = ext-classif.Key#_One.
          block-cl:
          for each clients-attr 
             where clients-attr.attr-code  = {&attr-kpp} 
               and clients-attr.obj-type   = {&shop}
               and clients-attr.attr-value = ikpp
               and can-find(buf_clients where buf_clients.obj-type   = clients-attr.obj-type
                                          and buf_clients.obj-code   = clients-attr.obj-code
                                          and buf_clients.host-code  = ohost-code) 
          no-lock :
             leave block-cl.
          end.
                     
          if     available clients
             and clients.obj-type eq {&shop}
          then do:
             assign 
                oobj-type = clients.obj-type
                oobj-code = clients.obj-code
             .
          end.
          else if available clients-attr 
          then do:
             assign 
                oobj-type = clients-attr.obj-type
                oobj-code = clients-attr.obj-code
             .
          end.
          else do:
             otext = substitute("По &1 не найден объект по КПП &2." ,iDocumentNumber, ikpp ).
             return yes.
          end.
       end.
    end.
    else do:
       otext = substitute("По &1 не найден получатель  &2." ,iDocumentNumber, iFnsParticipantId) .
       return no.
                  
    end.
    return ?.
end.
&if "{1}" = "class"
&then
method public logical CheckUcdForReturn
&else
function CheckUcdForReturn return logical 
&endif
(input idb-numUcd as integer,
 input idoc-idUcd as integer,
 input idb-numRet as integer,
 input idoc-idRet as integer  ):
    for each utd-marking-lines where utd-marking-lines.db-num eq idb-numUcd
                                 and utd-marking-lines.doc-id eq idoc-idUcd
                                 and utd-marking-lines.doc-level eq 1
    no-lock:
       create tt-utd-mark.
       buffer-copy utd-marking-lines to tt-utd-mark
       assign
          tt-utd-mark.side = "+"
       .
    end.
    for each utd-marking-lines where utd-marking-lines.db-num eq idb-numRet
                                 and utd-marking-lines.doc-id eq idoc-idRet
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
       AddUtdErrForTab(utd.db-num, utd.doc-id, "utd-marking-lines", buffer tt-utd-mark:handle, "UCDСompar", "NotMark" + tt-utd-mark.side, tt-utd-mark.mark).
    end.
end.

&if "{1}" = "class"
&then
method public logical SaturateAndCheckUTD
&else
function GetLastUTDinPackAft returns logical 
(input idb-num as integer, 
 input idoc-id as integer,
 output odb-num as integer,
 output odoc-id as integer ) forward.
 
function SaturateAndCheckUTD return logical 
&endif
(input idb-num as integer,
 input idoc-id as integer  ):
   define buffer clients-attr          for clients-attr.
   define buffer clients               for clients.
   define buffer Utd                   for Utd.
   define buffer utd_ret               for ub.utd.
   define buffer utd-lines             for utd-lines.
   define buffer buf_utd-lines         for utd-lines.
   define buffer marking               for marking.
   define buffer marking-lines         for marking-lines.
   define buffer Buf_utd-marking-lines for utd-marking-lines.
   define buffer contract              for contract.
   define variable vError as character no-undo.
   define variable vGdsCode as integer no-undo.
   
   define variable vcli-type as character no-undo.
   define variable vcli-code as integer no-undo.
   define variable vhost-code as integer no-undo init ?.
   define variable vcontract-code as integer no-undo.
   define variable vobj-type as character no-undo init ?.
   define variable vobj-code as integer no-undo init ?.
   
   define variable volddb-num as integer no-undo.
   define variable volddoc-id as integer no-undo.
   define variable vMark as logical no-undo.
   define variable VUcd as logical no-undo.
   
   find first Utd where utd.db-num eq idb-num
                    and utd.doc-id eq idoc-id
   no-lock no-error. 
   if available Utd
   then do:
      VUcd = utd.EDocType eq objSrv:Env:Utd:EDocType:UCD:KeyIntDB.
      ClearUtdErr(utd.db-num,utd.doc-id,"loadUtd").
      assign
            vobj-type  = utd.obj-type
            vobj-code  = utd.obj-code
            vhost-code = utd.host-code
      .
      do:
         
         block-line:
         for each utd-lines where utd-lines.db-num eq utd.db-num
                              and utd-lines.doc-id eq utd.doc-id
         no-lock:
            if not VUcd
            then do:
               find first utd-marking-lines 
                    where utd-marking-lines.db-num  = utd-lines.db-num 
                      and utd-marking-lines.doc-id  = utd-lines.doc-id
                      and utd-marking-lines.LineNum = utd-lines.LineNum
               no-lock no-error.
               if not available utd-marking-lines
               then do:
                  AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"loadUtd","NotMarkForLine",string(utd-lines.LineNum)).
                  next block-line.
               end.
            end.
            vGdsCode = ?.
            define variable vqnty as integer no-undo.
            vqnty = 0.
            block-mark:
            for each utd-marking-lines 
               where utd-marking-lines.db-num  = utd-lines.db-num 
                 and utd-marking-lines.doc-id  = utd-lines.doc-id
                 and utd-marking-lines.LineNum = utd-lines.LineNum
            no-lock:
               vMark = yes.
               find first marking where marking.mark eq utd-marking-lines.mark
               
               no-lock no-error.
               if not available marking
               then do:
                  AddUtdErr(utd.db-num,utd.doc-id,buffer utd-marking-lines:handle,"loadUtd","NotMark",utd-marking-lines.mark).
                  next block-mark.
               end.
               if utd-marking-lines.doc-level eq 1
               then do:
                  if marking.box-qnty eq ?
                  then
                     AddUtdErr(utd.db-num,utd.doc-id,buffer utd-marking-lines:handle,"loadUtd","MarkNotFormat",string(utd-lines.LineNum ) + {&delim-par} + marking.mark).
                  else
                     vqnty = vqnty + marking.box-qnty. 
               end.
               define variable vnewGdsCode as integer no-undo.
               vnewGdsCode = getGdsCodeByDM(marking.mark).
               if    marking.gds-code eq 0 
                  or marking.gds-code eq ?
                  or marking.sts eq 0
                  or  marking.sts eq ?
                  or (marking.gds-code ne vnewGdsCode
                      and vnewGdsCode ne ?
                      and vnewGdsCode ne 0)
               then do:
                  find first marking where marking.mark eq utd-marking-lines.mark
                  exclusive-lock no-error.
                  marking.gds-ext-id           = getGtinByDM(marking.mark).
                  marking.gds-code             = GetGdsCodeByGtin(marking.gds-ext-id).
                  
                  if    marking.gds-ext-id eq ""
                     or marking.gds-ext-id eq ?
                  then do:
                     marking.sts = objSrv:Env:marking:Sts:Mark:MarkError:KeyIntDB.
                     AddUtdErr(utd.db-num,utd.doc-id,buffer utd-marking-lines:handle,"loadUtd","NoGtinForMark",string(utd-lines.LineNum ) + {&delim-par} + marking.mark).
                  end.
                  else if    marking.gds-code eq 0
                          or marking.gds-code eq ?
                  then
                     AddUtdErr(utd.db-num,utd.doc-id,buffer utd-marking-lines:handle,"loadUtd","NoBarcodForGtin",string(utd-lines.LineNum ) + {&delim-par} + marking.gds-ext-id).
                  else if     marking.sts eq 0
                          or  marking.sts eq ?
                  then
                     marking.sts = objSrv:Env:marking:Sts:Mark:PendingVerification:KeyIntDB. 
               end.
               if    utd-marking-lines.gds-code eq 0 
                  or utd-marking-lines.gds-code eq ?
                  or utd-marking-lines.sts ne marking.sts
                  or utd-marking-lines.gds-code ne marking.gds-code
               then do:
                  find first buf_utd-marking-lines 
                       where buf_utd-marking-lines.db-num   = utd-marking-lines.db-num 
                         and buf_utd-marking-lines.doc-id   = utd-marking-lines.doc-id
                         and buf_utd-marking-lines.LineNum  = utd-marking-lines.LineNum
                         and buf_utd-marking-lines.mark     = utd-marking-lines.mark
                  exclusive-lock no-error.
                  if available buf_utd-marking-lines
                  then do:
                     buf_utd-marking-lines.gds-code = marking.gds-code.
/*                     buf_utd-marking-lines.sts = objSrv:Env:marking:Sts:Mark:PendingVerification:KeyIntDB.*/
                  end. 
               end.
               
               if vGdsCode eq ?
               then
                  vGdsCode = marking.gds-code.
                 
               if vGdsCode ne marking.gds-code
               then do:
                  vGdsCode = -1.

               end.
                
            end.
            if      not vucd
               and vGdsCode > 0 and vGdsCode ne ? 
            then do:
               define variable vValText as character no-undo.
               define variable vValDec  as decimal no-undo.
               VValText = GetAttrUtdlines (utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"Quantity").
               if VValText = ?
               then do:
                  vValDec = utd-lines.Quantity.
                  setAttrUtdLines(utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"Quantity",string(utd-lines.Quantity)).
               end.
               else
                  vValDec = dec(VValText).         
               find first bar-code where bar-code.gds-code  eq vGdsCode
                                     and bar-code.unit-cli eq utd-lines.UnitCode
               no-lock no-error.
               if utd-lines.Quantity ne vValDec * (if avail bar-code then bar-code.cli-base-rate else 1)
               then do:
                  find first  buf_utd-lines where buf_utd-lines.db-num  eq utd-lines.db-num
                                              and buf_utd-lines.doc-id  eq utd-lines.doc-id
                                              and buf_utd-lines.LineNum eq utd-lines.LineNum
                  exclusive-lock no-error.
                  if available buf_utd-lines
                  then do:
                     buf_utd-lines.Quantity = vValDec * (if avail bar-code then bar-code.cli-base-rate else 1).
                     release buf_utd-lines.
                  end.
               end.
               if utd-lines.Quantity  ne vqnty
               then                        
                  AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"loadUtd","Qnty",string(utd-lines.LineNum ) + {&delim-par} + string(utd-lines.Quantity * (if avail bar-code then bar-code.cli-base-rate else 1)) + {&delim-par} + string(vqnty)).
            end.
            if  vGdsCode = -1
            then do:
               vGdsCode = ?.
               
               AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"loadUtd","MultGtinForLine",string(utd-lines.LineNum )).
   /*            vError = vError + "," + "К линии " + string(utd-lines.LineNum) + " привязаны марки от разных товаров." no-error.*/
               next block-line.
            end.
            if utd-lines.gds-code ne vGdsCode
            then do:
               find first  buf_utd-lines where buf_utd-lines.db-num  eq utd-lines.db-num
                                           and buf_utd-lines.doc-id  eq utd-lines.doc-id
                                           and buf_utd-lines.LineNum eq utd-lines.LineNum
               exclusive-lock no-error.
               if available buf_utd-lines
               then
                  buf_utd-lines.gds-code = vGdsCode.
               
               release buf_utd-lines.
            end.
            if vGdsCode eq ? and utd-lines.gds-code eq ?
               and not VUcd
            then
               AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"loadUtd","NoBarCodeForLine",string(utd-lines.LineNum )).
                
         end.
         find first ext-classif where ext-classif.classif-name  eq {&extclass_code_id_diadok_client}
                                  and ext-classif.charkey_three eq utd.cli-FnsParticipantId
         no-lock no-error.
         if available ext-classif
         then
            assign 
               vcli-type = ext-classif.CharKey_One
               vcli-code = ext-classif.Key#_One
            .
         else do:
            assign 
              vcli-type = ?
              vcli-code = ?
            .
            AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoSuppForId",utd.cli-FnsParticipantId ).
   /*          vError = vError + "," + "не найден поставщик " + utd.FnsParticipantId-cli.*/
         end.
         
         define variable vtext       as character no-undo.
         define variable vhost-code1 as integer   no-undo.
         define variable vobj-type1  as character no-undo.
         define variable vobj-code1  as integer   no-undo.
          getObgFns 
                    (input utd.DocumentNumber ,
                     input utd.obj-FnsParticipantId ,
                     input utd.obj-kpp,
                     output vhost-code1,
                     output vobj-type1,
                     output vobj-code1,
                     output vtext ).
         assign
            vobj-type  = vobj-type1   when vobj-type  eq ? or vobj-type  eq ""
            vobj-code  = vobj-code1   when vobj-code  eq ? or vobj-code  eq 0
            vhost-code = vhost-code1  when vhost-code eq ? or vhost-code eq 0
         .
       
         find first contract  where contract.host-code eq vhost-code
                                and contract.cli-type  eq vcli-type
                                and contract.cli-code  eq vcli-code
                                and contract.contract-prn-code eq Utd.BaseDocumentNumber
         no-lock no-error.
         define variable VContractEdo as logical no-undo init yes.
         if available contract
         then do:
            for first contract-attr no-lock where contract-attr.host-code     = contract.host-code 
                                              and contract-attr.contract-code = contract.contract-code 
                                              and contract-attr.attr-code     = "contract-edi":
                VContractEdo = logical (contract-attr.attr-value) .
            end.
            assign
               vcontract-code = contract.contract-code
            .
            if not VContractEdo
            then
               AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoEdoDoc", Utd.BaseDocumentNumber).
         end.
         else do:
            vcontract-code = ?.
            
   /*           vError = vError + "," + "не найдена договор " + utd.BaseDocumentNumber.*/
         end.
      end.
      
      
      if not GetLastUTDinPackAft (utd.db-num, utd.doc-id, volddb-num, volddoc-id)
      then do:
         /*ClearUtdErr(utd.db-num,utd.doc-id,"loadUtd").*/
         AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoLastDoc",string(utd.PackageId) + {&delim-par} + string(volddb-num) + {&delim-par} + string(volddoc-id)).
      end.
      define variable vdoc-code as character no-undo init ?.
      if utd.EDocType              eq objSrv:Env:Utd:EDocType:returns:KeyIntDB
      then do:
         find first utd_ret where utd_ret.parentDocumentExt     eq utd.parentDocumentExt
                              and utd_ret.parentOrganizationExt eq utd.parentOrganizationExt
                              and utd_ret.EDocType              eq objSrv:Env:Utd:EDocType:returns:KeyIntDB
         no-lock no-error.
         if available utd_ret 
         then do:
            vdoc-code = utd_ret.doc-code.
            CheckUcdForReturn(utd.db-num,utd.doc-id,utd_ret.db-num,utd_ret.doc-id).
         end.
         else
            AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoAvailDocRet", string(utd.db-num) + {&delim-par} + string(utd.doc-id)). 
      end.                
   end.
   
  
   find current utd exclusive-lock no-error.
   if available utd 
   then do:
      assign
         utd.cli-type      = vcli-type      when vcli-type      ne ?
         utd.cli-code      = vcli-code      when vcli-type      ne ?
         utd.host-code     = vhost-code     when vhost-code     ne ? and vhost-code     ne 0
         utd.contract-code = vcontract-code when vcontract-code ne ?
         utd.obj-type      = vobj-type      when vobj-type      ne ? and vobj-type      ne ""
         utd.obj-code      = vobj-code      when vobj-code      ne ? and vobj-code      ne 0
         utd.doc-code      = vdoc-code      when vdoc-code      ne ?
      .
      if    utd.contract-code eq ?
         or utd.contract-code eq 0
      then
         AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoContForFirmId",(if utd.host-code eq ? then "?" else string (utd.host-code)) + {&delim-par} +  utd.BaseDocumentNumber).
      if utd.host-code eq ?
         or utd.host-code eq 0
      then
         AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoFirmForId",if utd.obj-FnsParticipantId eq ? then "?" else utd.obj-FnsParticipantId ).
      if utd.obj-code eq ?
         or utd.obj-code eq 0
      then 
         AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoShopForKpp",utd.obj-kpp).
   end.
   vError = GetErrForUtdstr(utd.db-num,utd.doc-id,"loadUtd").
   if vError eq ""
   then do:
      if utd.sts eq 0 or utd.sts eq ?
      then
         utd.sts = if VUcd
                   then ObjSrv:Env:Utd:Sts:th:ConfirmedUcd:KeyIntDB
                   else ObjSrv:Env:Utd:Sts:th:ReceivedFromSupplier:KeyIntDB.
      if utd.sts = ObjSrv:Env:Utd:Sts:th:LoadError:KeyIntDB
      then
         utd.sts = ObjSrv:Env:Utd:Sts:th:ReceivedFromSupplier:KeyIntDB.
      
       
      
          
/*      utd.AdditInfo = "".*/
         
   end.
   else do:
      if utd.sts ne ObjSrv:Env:Utd:Sts:th:CorrectionRequested:KeyIntDB
      then 
         utd.sts = ObjSrv:Env:Utd:Sts:th:LoadError:KeyIntDB.
/*      utd.AdditInfo = vError.*/
      
   end.
   if     utd.sts-edi  >= ObjSrv:Env:Utd:Sts:edi:StatChangLoanOnlyBeg
      and utd.sts-edi  <= ObjSrv:Env:Utd:Sts:edi:StatChangLoanOnlyEnd
   then
      utd.sts-edi = ?.
   else if     (not vMark and  not vucd) or not VContractEdo
           and utd.sts-edi < ObjSrv:Env:Utd:Sts:edi:StatChangLoanOnlyBeg
   then
      utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:AutoRejected:KeyIntDB.
   release utd.
 
   return vError eq "".
end.
&if "{1}" = "class"
&then
method public logical ReCheck
&else
function ReCheck returns logical 
&endif
(idb-num as integer,
 idoc-id as integer ):
   define buffer buf_c-utd for ub.c-utd .
   define buffer buf_utd   for ub.utd .
   find first buf_utd where buf_utd.db-num eq idb-num
                        and buf_utd.doc-id eq idoc-id
   exclusive-lock no-error.
   if available buf_utd
   then do:
      if buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:loaderror:KeyIntDB
      then do:
         SaturateAndCheckUTD(buf_utd.db-num, buf_utd.doc-id) no-error .        
         if  error-status:error then 
         do: 
            message return-value view-as alert-box.
         end.
      end.

      if    buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:InconsistencyWithSupplyContract:KeyIntDB 
         or buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:DeliveryCodeMismatch:KeyIntDB 
         or buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:LackOfMarkingCodesInCirculation:KeyIntDB 
      then do:
         find last buf_c-utd no-lock where buf_c-utd.db-num eq buf_utd.db-num and 
                                           buf_c-utd.doc-id eq buf_utd.doc-id and 
                                           buf_c-utd.sts    eq buf_utd.sts and
                                           buf_c-utd.sts    eq ObjSrv:Env:Utd:Sts:TH:NewStatus:KeyIntDB 
         no-error .
         if available (buf_c-utd) 
         then do:
            buf_utd.sts = buf_c-utd.sts .
            buf_utd.sts-edi = buf_c-utd.sts-edi .
         end.
         else do:
            if buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:InconsistencyWithSupplyContract:KeyIntDB 
            then 
               buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:VerificationPassed:KeyIntDB .
            else 
               buf_utd.sts = ObjSrv:Env:Utd:Sts:TH:ReceivedFromSupplier:KeyIntDB .
            buf_utd.sts-edi = ObjSrv:Env:Utd:Sts:EDI:Verification:KeyIntDB .
         end.  
      end. 
      if buf_utd.sts = objSrv:Env:Utd:Sts:TH:VerificationPassed:KeyIntDB 
      then do:       
         run utl/utd-checkSpec.p (input buf_utd.db-num,
                                  input buf_utd.doc-id) .  
      end.
   end.
   release buf_utd.
end.

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
method public logical GetprevUTDForPac
&else
function GetprevUTDForPac returns logical 
&endif
(iPackegeId as character ,
 iTimestamp as datetime,
 output odb-num as integer,
 output odoc-id as integer ):
   define buffer buf_utd for utd.
   find last buf_utd where Buf_utd.PackageId eq iPackegeId
                             and Buf_utd.EDocType  eq objSrv:Env:Utd:EDocType:UTD:KeyIntDB
                             and Buf_utd.Timestamp < iTimestamp
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
method public logical GetLastUTDinPackAft
&else
function GetLastUTDinPackAft returns logical 
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
            return odoc-id = utd.doc-id.
      end.  
   end.
   return ?.
end.


&if "{1}" = "class"
&then
method public logical GetLastUTDinPackbef
&else
function GetLastUTDinPackbef returns logical 
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
         GetprevUTDForPac(utd.PackageId,utd.Timestamp,output odb-num,output odoc-id ).
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
            return odoc-id = utd.doc-id.
      end.  
   end.
   return ?.
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
         GetLastUTDForPac(utd.PackageId,datetime("01/01/1900"),output odb-num,output odoc-id ).
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
            return odoc-id = utd.doc-id.
      end.  
   end.
   return ?.
end.
&if "{1}" = "class"
&then
method public void delMark
&else
function delMark returns logical 
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
         delMark(buffer buf_utd-marking-line).
         delete buf_utd-marking-line.
      end.
      
   end.
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
/*            buf_utd-marking-line.sts       = marking.sts*/
         .
         
      end.
      addMark(buffer buf_utd-marking-line).
   end.
end.

&if "{1}" = "class"
&then
method public void unLockUTDMarkbuf
&else
function UnLockUTDMarkbuf returns logical 
&endif
(buffer old_utd for utd ):
   define variable voldkey    as character no-undo.
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

&if "{1}" = "class"
&then
method public void unLockUTDMark
&else
function UnLockUTDMark returns logical 
&endif
(idb-num as integer ,idoc-id as integer ):
   define buffer old_utd for utd.
   
 /* снимаем старую блокировку */
   find first old_utd where old_utd.db-num eq idb-num 
                        and old_utd.db-num eq idoc-id
   no-lock no-error.
   if available old_utd
   then do:
      UnLockUTDMarkbuf(buffer old_utd).
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

&if "{1}" = "class"
&then
method public char getattrUtd
&else
function getattrUtd returns char 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 iattrcode as character ):
   define buffer utd-attr for utd-attr.
   find first utd-attr where utd-attr.db-num eq idb-num
                         and utd-attr.doc-id eq idoc-id
                         and utd-attr.attr-code eq iattrcode
   no-lock no-error.
   return if not available utd-attr  then ?    else  utd-attr.attr-value.     
end.

&if "{1}" = "class"
&then
method public void setattrUtd
&else
function setattrUtd returns logical 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 iattrcode as character, 
 iattrval  as character ):
   define buffer utd-attr for utd-attr.
   find first utd-attr where utd-attr.db-num eq idb-num
                         and utd-attr.doc-id eq idoc-id
                         and utd-attr.attr-code eq iattrcode
   no-lock no-error.
   if not available utd-attr
   then do:
      create utd-attr.
      assign
         utd-attr.db-num    = idb-num
         utd-attr.doc-id    = idoc-id
         utd-attr.attr-code = iattrcode
         utd-attr.attr-value = iattrval
      . 
   end.
   else do:
      if utd-attr.attr-value ne iattrval
      then do:
         find current utd-attr exclusive-lock no-error.
         if available utd-attr
         then
            utd-attr.attr-value = iattrval.
      end.
   end.     
end.


&if "{1}" = "class"
&then
method public char GetAttrUtdlines
&else
function GetAttrUtdlines returns char 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 ilinenum  as integer, 
 iattrcode as character ):
   define buffer utd-lines-attr for utd-lines-attr.
   find first utd-lines-attr where utd-lines-attr.db-num    eq idb-num
                               and utd-lines-attr.doc-id    eq idoc-id
                               and utd-lines-attr.lineNum   eq ilineNum
                               and utd-lines-attr.attr-code eq iattrcode
   no-lock no-error.
   return if not available utd-lines-attr  then ?    else  utd-lines-attr.attr-value.     
end.


&if "{1}" = "class"
&then
method public void setattrUtdlines
&else
function setattrUtdlines returns logical 
&endif
(idb-num   as integer,
 idoc-id   as integer,
 ilinenum  as integer, 
 iattrcode as character, 
 iattrval  as character ):
   define buffer utd-attr for utd-attr.
   find first utd-lines-attr where utd-lines-attr.db-num    eq idb-num
                               and utd-lines-attr.doc-id    eq idoc-id
                               and utd-lines-attr.lineNum   eq ilineNum
                               and utd-lines-attr.attr-code eq iattrcode
   no-lock no-error.
   if not available utd-lines-attr
   then do:
      create utd-lines-attr.
      assign
         utd-lines-attr.db-num    = idb-num
         utd-lines-attr.doc-id    = idoc-id
         utd-lines-attr.lineNum   = ilineNum
         utd-lines-attr.attr-code = iattrcode
         utd-lines-attr.attr-value = iattrval
      . 
   end.
   else do:
      if utd-lines-attr.attr-value ne iattrval
      then do:
         find current utd-lines-attr exclusive-lock no-error.
         if available utd-lines-attr
         then
            utd-lines-attr.attr-value = iattrval.
      end.
   end.      
end.