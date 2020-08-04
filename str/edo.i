&glob xdebug yes

&scoped-define vssseq {&sequence}
def var vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

define variable mDiadocApi as component-handle no-undo.
define variable mDiadocConnection as component-handle no-undo.
define variable m-sys-key as character no-undo.
define variable marpar-type as character no-undo.
define variable mPublishHand as handle  no-undo.
define variable mFlaftest as logical no-undo.
/*define variable mdiadoc as logical no-undo.*/

   create "Diadoc.DiadocClient":U mDiadocApi no-error.
/*   mdiadoc = yes.*/
{gbl\objsrv.i}
define variable mySeqUtd as int64 no-undo init ?.
if mDiadocApi eq ?
then do:
   if  log-manager:logfile-name ne ?
   then
      log-manager:write-message("Нетбиблиотеки Diadoc или не удалось создать объект Diadoc.DiadocClient", "EDOError"). 
end.

&if "{1}" = "class"
&then
&else
{ gbl/key-rec.i }
    
&endif
{cmp/str-glbl.i {1}}

{str/utd-err.i {1} &*}
{str/utd.i {1}}
{ gbl/attr-lib.i {1}}
{ cmp/library.i {1}}
{str\ucd.i {1}}
&if "{1}" = "class"
&then
method public character  PutMes
&else
function PutMes returns character
&endif
(idext as character ):
   if valid-handle(mPublishHand)
   then
      publish "PutErr" from mPublishHand (idext).
   else do:
      if idext begins "error"
      then
         message substring (idext,6)
            view-as alert-box.
      output to "diadoc_user.log" append.
      put unformatted now " " idext skip.
      output close. 
   end.
end.

&if "{1}" = "class"
&then
method public logical  chekStop
&else
function chekStop returns logical
&endif
( ):
   define variable oStop as logical no-undo.
   if valid-handle(mPublishHand)
   then
      publish "StopProc" from mPublishHand (output oStop).
   return oStop.
end.

define temp-table tt-pack no-undo
          field orgid as char
          field docid as char
          field packid as char
          field stamp as datetime
          index pi packid   stamp   orgid  docid 
          .


define temp-table tt-recid no-undo
          field orgid as char
          field docid as char
          field parent as char
          field stamp as datetime
          index pi orgid docid 
          index parent parent  stamp.
{ref/extclass.i}
define variable Mext-sys as integer no-undo init ?.
define stream File-stream.
define variable mdb-num-local as integer no-undo.
run gbl/getdbnum.p (output mdb-num-local).

&if "{1}" = "class"
&then
method private integer   getextsys
&else
function  getExtSys returns integer 
&endif
():
   define buffer ext-system      for ext-system.
   define buffer ext-system-attr for ext-system-attr.
   Mext-sys = ?.
   block-sys-obj:
   for each ext-system where ext-system.esys-type eq {&bef-openxml-type-is_diadoc}
                         and ext-system.db-num    eq mdb-num-local
   no-lock:
       find first ext-system-attr where ext-system-attr.db-num  eq ext-system.db-num
                                    and ext-system-attr.esys-id eq ext-system.esys-id
                                    and ext-system-attr.esya-attr-code eq {&attr-esys-obj}
                                    
       no-lock no-error.
       if     available ext-system-attr
          and           ext-system-attr.esya-attr-value eq v-cntxt-obj-type + string(v-cntxt-obj-code)
       then do:
          Mext-sys = ext-system-attr.esys-id.
          leave block-sys-obj.
       end.                            
   end.
   if Mext-sys eq ? 
   then do:
      block-sys-host:
      for each ext-system where ext-system.esys-type eq {&bef-openxml-type-is_diadoc}
                            and ext-system.db-num    eq mdb-num-local
      no-lock:
          find first ext-system-attr where ext-system-attr.db-num  eq ext-system.db-num
                                       and ext-system-attr.esys-id eq ext-system.esys-id
                                       and ext-system-attr.esya-attr-code eq {&attr-esys-host-code}
                                       
          no-lock no-error.
          if     available ext-system-attr
             and           ext-system-attr.esya-attr-value eq string(v-cntxt-host-code-obj)
          then do:
             Mext-sys = ext-system-attr.esys-id.
             leave block-sys-host.
          end.                            
      end.
   end.
   return Mext-sys.
end.  

&if "{1}" = "class"
&then
method private character  getextattr
&else
function  getExtAttr returns character
&endif
(input icode as character ):
   define variable oValue as character no-undo.
   define variable vtype as character no-undo.
   define buffer ext-system for ext-system.
   get-key-value section "ProxyServ" key icode value oValue.
   if oValue eq ?
   then do:
   
      if Mext-sys eq ?
      then
         getExtSys ().  
      find first ext-system no-lock where ext-system.db-num  eq mdb-num-local
                                      and ext-system.esys-id eq Mext-sys no-error.
      if available ext-system
      then do:
      &scop proc-name ext-system-attr-value
       {&run_proc_attr-lib}
         (ext-system.esys-id,
          mdb-num-local,
          icode,
          output oValue,
          output vtype) no-error.
       end.
   end.
  
   return oValue.
end.

&if "{1}" = "class"
&then
method private character  Setextattr
&else
function  SetExtAttr returns character
&endif
(input icode   as character,
 input iValue  as character):
   define variable vtype as character no-undo.
   define buffer ext-system for ext-system.  
   if Mext-sys eq ?
   then
      getExtSys ().  
   find first ext-system no-lock where ext-system.db-num  eq mdb-num-local
                                   and ext-system.esys-id eq Mext-sys no-error.
   if available ext-system
   then do:
   &scop proc-name ext-system-attr-write
    {&run_proc_attr-lib}
      (ext-system.esys-id,
       mdb-num-local,
       icode,
       iValue) no-error.
    end.
    
/*   return oValue.*/
end.
/* получение описания объекта */
&if "{1}" = "class"
&then
method private logical getdesc
&else
function  getdesc returns logical
&endif
(input iObj as component-handle):
   if iObj eq ? then return false.
   &if defined(debug)
   &then
   output stream File-stream to "c:\temp\diadoc_load.txt" append.
   define variable vReflector as component-handle no-undo.
   define variable vDescobj  as component-handle no-undo.
   define variable vPropertyNames  as component-handle no-undo.
   define variable vMethodsNames as component-handle no-undo.
   define variable vMethodDesc as component-handle no-undo.
   define variable vMethodsName as character  no-undo.
   define variable vPropertyValue as char no-undo.
   
   create "Diadoc.Reflector" vReflector.
   vDescobj = vReflector:Describe(iObj).
   
  put   stream File-stream  unformatted skip (1)
   "------------------------------------------" skip
   vDescobj:GetInterfaceName() skip. 
   define variable vPropertyName as character no-undo.
   define variable vPropertyType as character no-undo.
   .
   
   define variable vi as integer no-undo.
   define variable vii as integer no-undo.
  put stream File-stream  unformatted skip "property" skip.
  vPropertyNames = vDescobj:GetPropertiesNames().
   vi= vPropertyNames:count.
   do vi= 1 to vPropertyNames:count :
      vPropertyName = "".
      vPropertyType = "".
      vPropertyValue = "".
      vPropertyName  = vPropertyNames:GetItem(vi - 1) no-error.
      vPropertyType  = vDescobj:GetPropertyType(vPropertyName) no-error .
      vPropertyValue = substring((vDescobj:GetProperty(vPropertyName)),1,4000) no-error.
     put stream File-stream  unformatted vPropertyName " " vPropertyType  " " vPropertyValue skip.
   end.
   put stream File-stream  unformatted skip "method" skip.
   vMethodsNames = vDescobj:GetMethodsNames().
   vi = vMethodsNames:count.
   do vi = 1 to vMethodsNames:count :
      vMethodsName = "".
      vMethodDesc = "".
      vMethodsName = vMethodsNames:GetItem(vi - 1)no-error.
      vMethodDesc  = vDescobj:GetMethodDesc(vMethodsName)no-error.
      put stream File-stream  unformatted vMethodsName  " retval " vMethodDesc:RetVal skip.
      do vii  = 1 to vMethodDesc:args:count:
         define variable varg as character no-undo.
         varg = "".
         varg = vMethodDesc:args:GetItem(vii - 1) no-error.
         put stream File-stream  unformatted " args " varg  skip .
      end. 
   end.
   put stream File-stream  unformatted "end---------------------------------------" skip.
   output stream File-stream close.
   release object vReflector.
   &endif
   return true.
end.

/*получение  xsd схемы*/
&if "{1}" = "class"
&then
method private logical getxsddocum
&else
function getxsddocum returns logical 
&endif
(iOrganization as component-handle):
   if iOrganization eq ? then return false.
   /* олучение чsd схемы */
   define variable vDocumentTypes as component-handle no-undo.
   define variable vDocumentType as component-handle no-undo.
   define variable vFunctions as component-handle no-undo.
   define variable vFunction as component-handle no-undo.
   define variable vVersions as component-handle no-undo.
   define variable vVersion as component-handle no-undo.
   define variable vTitles as component-handle no-undo.
   define variable vTitle as component-handle no-undo.
   define variable vi as integer no-undo.
   define variable vii as integer no-undo.
   define variable viii as integer no-undo.
   define variable viiii as integer no-undo.
   &if defined(debug)
   &then
   output stream File-stream to "c:\temp\diadoc_doc.txt" append.
   vDocumentTypes = iOrganization:GetDocumentTypes().
   do vi =1 to vDocumentTypes:count:
      vDocumentType = vDocumentTypes:GetItem(vi - 1).
      put stream File-stream  unformatted "DocumentType -> NAme " vDocumentType:name skip.
      put stream File-stream  unformatted "DocumentType -> Title " vDocumentType:Title skip.
      vFunctions = vDocumentType:Functions.
      do vii =1 to vFunctions:count:
         vFunction = vFunctions:GetItem(vii - 1 ).
         put stream File-stream  unformatted "DocumentType -> Function -> NAme " vFunction:name skip.
         
         vVersions = vFunction:Versions.
         do viii =1 to vVersions:count:
            vVersion = vVersions:GetItem(viii - 1 ).
            put stream File-stream  unformatted "DocumentType -> Function -> Version -> version " vVersion:version skip.
            put stream File-stream  unformatted "DocumentType -> Function -> Version -> IsActual " vVersion:IsActual skip.
            vTitles  = vVersion:Titles.
            do viiii =1 to vTitles:count:
               vTitle = vTitles:GetItem(viiii - 1 ).
               put stream File-stream  unformatted "DocumentType -> Function -> Version -> Title -> IsFormal " vTitle:IsFormal skip.
               put stream File-stream  unformatted "DocumentType -> Function -> Version -> Title -> XsdUrl " vTitle:XsdUrl skip.
               put stream File-stream  unformatted "DocumentType -> Function -> Version -> Title -> HaveUserDataXSD " vTitle:HaveUserDataXSD skip.
               
            end.
            if vDocumentType:name eq "UniversalTransferDocument"
            then
            iOrganization:SaveUserDataXSD(vDocumentType:name, vFunction:name, vVersion:version, "Seller", "c:\11\diadoc\" + "upd_" + vFunction:name + ".xsd").    
         end.
      end.
   end.
   
   /* mOrganization.SaveUserDataXSD(TitleName, mFunction:name, Version, DocflowSide, FilePath).*/ 
   put stream File-stream  unformatted "--------------------------------------------------- " skip.
  output stream File-stream close.
  &endif
   return true.
  
end.


/* Заполнение справочников */
define temp-table tt-type no-undo
          field id as char
          field name as character 
          index pi id .
          
define temp-table tt-Class no-undo like tt-type.

/*define temp-table tt-Status no-undo like tt-type.*/
&if "{1}" = "class"
&then
method public void crcode
&else
function crcode returns character 
&endif
():

   define variable vtypelist as character no-undo.
   define variable vtypename as character no-undo.
   define variable vi as integer no-undo.

   vtypelist = /*"Nonformalized|"
             + "Invoice|"
             /*+ "InvoiceRevision|"*/
/*             + "InvoiceCorrection|"*/
/*             + "InvoiceCorrectionRevision|"*/
             + "Torg12|"
             + "XmlTorg12|"
             + "AcceptanceCertificate|"
             + "XmlAcceptanceCertificate|"
             + "TrustConnectionRequest|"
             + "PriceListAgreement|"
             + "CertificateRegistry|"
             + "ReconciliationAct|"
             + "Contract|"
             + "ProformaInvoice|"
             + "ServiceDetails|"
             + "UniversalTransferDocument|"
             + "UniversalTransferDocumentRevision|"
/*             + "UniversalCorrectionDocumen|"*/
/*             + "UniversalCorrectionDocumentRevision|"*/
             + "AnyInvoiceDocumentType|"
             + "AnyBilateralDocumentType|"
             + "AnyUnilateralDocumentType|"
             +*/ "Any"
             .
   vtypename = /*"неформализованный документ|"
             + "счет-фактура|"
           /*  + "исправление счета-фактуры|"*/
/*             + "корректировочный счет-фактура|"*/
/*             + "исправление корректировочного счета-фактуры|"*/
            + "неформализованная накладная ТОРГ-12|"
             + "формализованная накладная ТОРГ-12|"
             + "неформализованный акт о выполнении работ|"
             + "формализованный акт о выполнении работ|"
             + "предложение партнёрских отношений|"
             + "протокол согласования цены|"
             + "реестр сертификатов|"
             + "акт сверки|"
             + "договор|"
             + "счет на оплату|"
             + "детализация|"
             + "УПД|"
             + "исправление УПД|"
             + "УКД|"
             + "исправление УКД|"
             + "соответствует набору из четырех типов документов: Invoice, InvoiceRevision, InvoiceCorrection, InvoiceCorrectionRevision|"
             + "соответствует любому типу двусторонних документов: Nonformalized, Torg12, AcceptanceCertificate, XmlTorg12, XmlAcceptanceCertificate, TrustConnectionRequest, PriceList, PriceListAgreement CertificateRegistry ReconciliationAct Contract Torg13|"
             + "соответствует любому типу односторонних документов: ProformaInvoice, ServiceDetails|"
             +*/ "любому типу документа|"
             .
          
          
   do vi = 1 to num-entries(vtypelist,"|"):
      create tt-type.
      assign
         tt-type.id   =  entry(vi,vtypelist,"|")
         tt-type.name =  entry(vi,vtypename,"|")
      .
   end.

   vtypelist = "Inbound|"
/*             + "Outbound|"*/
/*             + "Internal|"*/
             + "Proxy". 
   
   vtypename = "входящий документ|"
            /* + "исходящий документ|"
             + "внутренний документ|"*/
             + "документ, переданный через промежуточного получателя|".
   do vi = 1 to num-entries(vtypelist,"|"):
      create tt-Class.
      assign
         tt-Class.id   =  entry(vi,vtypelist,"|")
         tt-Class.name =  entry(vi,vtypename,"|")
      .
   end. 
   /*
   vtypelist = "NotRead|"
             + "NoRecipientSignatureRequest|"
             + "WaitingForRecipientSignature|"
             + "WithRecipientSignature|"
             + "WithSenderSignature|"
             + "RecipientSignatureRequestRejected|"
             + "WaitingForSenderSignature|"
             + "InvalidSenderSignature|"
             + "InvalidRecipientSignature|"
             + "Approved|"
             + "Disapproved|"
             + "WaitingForResolution|"
             + "SignatureRequestRejected|"
             + "Finished|"
             + "HaveToCreateReceip|"
             + "NotFinished|"
             + "InvoiceAmendmentRequested|"
             + "RevocationIsRequestedByMe|"
             + "RequestsMyRevocation|"
             + "RevocationAccepted|"
             + "RevocationRejected|"
             + "RevocationApproved|"
             + "RevocationDisapproved|"
             + "WaitingForRevocationApprovement|"
             + "NotRevoked|"
             + "WaitingForProxySignature|"
             + "WithProxySignature|"
             + "InvalidProxySignature|"
             + "ProxySignatureRejected|"
             + "WaitingForInvoiceReceipt|"
             + "WaitingForReceipt|"
             + "RequestsMySignature|"
             + "RoamingNotificationError".




   vtypename = "документ не прочитан|"
             + "документ без запроса ответной подписи|"
             + "документ в ожидании ответной подписи|"
             + "документ с ответной подписью|"
             + "документ с подписью отправителя|"
             + "документ с отказом от формирования ответной подписи|"
             + "документ, требующий подписания и отправки|"
             + "документ с невалидной подписью отправителя, требующий повторного подписания и отправки|"
             + "документ с невалидной подписью получателя, требующий повторного подписания и отправки|"
             + "согласованный документ|"
             + "документ с отказом согласования|"
             + "документ, находящийся на согласовании или подписи|"
             + "документ с отказом в запросе подписи сотруднику|"
             + "документ с завершенным документооборотом|"
             + "требуется подписать извещение о получении|"
             + "документ с незавершенным документооборотом|"
             + "имеет смысл только для счетов-фактур; документ, по которому было запрошено уточнение|"
             + "документ, по которому было запрошено аннулирование|"
             + "документ, по которому контрагент запросил аннулирование|"
             + "аннулированный документ|"
             + "документ, запрос на аннулирование которого был отклонен|"
             + "документ, запрос на аннулирование которого был согласован|"
             + "документ с отказом согласования запроса на аннулирование|"
             + "документ, находящийся на согласовании запроса аннулирования|"
             + "неаннулированный документ|"
             + "документ в ожидании подписи промежуточного получателя|"
             + "документ с подписью промежуточного получателя|"
             + "документ с невалидной подписью промежуточного получателя, требующий повторного подписания и отправки|"
             + "документ с отказом от формирования подписи промежуточным получателем|"
             + "документ в ожидании получения извещения о получении счета-фактуры|"
             + "документ в ожидании получения извещения о получении|"
             + "документ, по которому контрагент запросил подпись|"
             + "документ, с ошибкой доставки в роуминге".
             
   do vi = 1 to num-entries(vtypelist,"|"):
      create tt-Status.
      assign
         tt-Status.id   =  entry(vi,vtypelist,"|")
         tt-Status.name =  entry(vi,vtypename,"|")
      .
   end.        
     */        
end.     
/* ЗАГРУЖАЕМ СПРАВОЧНИК */
crcode().

/*Получене информации по контр огену*/
&if "{1}" = "class"
&then
method public void getOrganizationInfo
&else
function getOrganizationInfo returns character 
&endif
(input iContAgent as component-handle,
                                                output oinn as character,  
                                                output oKpp as character,
                                                output oFnsParticipantId as character,
                                                output oOrgName as character,
                                                output OarddrRus as character  
                                                 ):
    
   define variable vi as integer no-undo.
   define variable vContAgentOrganizationDetails   as component-handle no-undo.
   define variable vContAgentOrganizationReference as component-handle no-undo.
   define variable vAddrRus                        as component-handle no-undo.
   
   if iContAgent ne ?
   then do: 
      getdesc(iContAgent).
      vContAgentOrganizationDetails = iContAgent:OrganizationDetails.
      
      oinn = vContAgentOrganizationDetails:Inn.
      oKpp = vContAgentOrganizationDetails:Kpp.
      oFnsParticipantId = vContAgentOrganizationDetails:FnsParticipantId.
      
      getdesc(vContAgentOrganizationDetails).
      oOrgName = vContAgentOrganizationDetails:OrgName. 
      getdesc(vContAgentOrganizationDetails:Address).
      vAddrRus = vContAgentOrganizationDetails:Address:RussianAddress.
      getdesc(vContAgentOrganizationDetails:Address:RussianAddress).
      if vAddrRus ne ?
      then do:
         if vAddrRus:ZipCode ne ""
         then
            OarddrRus = OarddrRus + " " + vAddrRus:ZipCode.
         if vAddrRus:Region ne ""
         then
            OarddrRus = OarddrRus + " Регион: " + vAddrRus:Region.
         if vAddrRus:Territory ne ""
         then
            OarddrRus = OarddrRus + " Область: " + vAddrRus:Territory.
         if vAddrRus:City ne ""
         then
            OarddrRus = OarddrRus + " Город: " + vAddrRus:City.
         if vAddrRus:Locality ne ""
         then
            OarddrRus = OarddrRus + " Район: " + vAddrRus:Locality.
         if vAddrRus:Street ne ""
         then
            OarddrRus = OarddrRus + " Улица: " + vAddrRus:Street.
         if vAddrRus:Block ne ""
         then
            OarddrRus = OarddrRus + " Стр: " + vAddrRus:Block.
         if vAddrRus:Building ne ""
         then
            OarddrRus = OarddrRus + " Дом: " + vAddrRus:Building.
         if vAddrRus:Apartment ne ""
         then
            OarddrRus = OarddrRus + " Квартира: " + vAddrRus:Apartment.
       
         
      end.
      /*getdesc(vContAgentOrganizationDetails:Address:ForeignAddress).
      vContAgentOrganizationReference = iContAgent:OrganizationReference.
      getdesc(vContAgentOrganizationReference).
      */
   end.
end.




/* Подключение по сертификату */
&if "{1}" = "class"
&then
method public component-handle ConectByCertif
&else
function ConectByCertif return component-handle 
&endif
(iThumbprint as character ):
  if mDiadocApi eq ? then return ?.
  if iThumbprint eq "" 
  then do:
     release object mDiadocConnection no-error.
     return ?.
  end.
   /*Задаем параметры подлючения к серверу*/
   mDiadocApi:ApiClientId =  getextAttr({&attr-esys-diadoc-key}). /*"api-e781e743-064b-47a7-8119-f0b1264636ab".  Ключь разработчика  */
   mDiadocApi:ServerUrl   =  getextAttr({&attr-esys-server-addr}). /*"https://diadoc-api.kontur.ru:443".*/

   if mDiadocApi:ApiClientId eq ""
      or  mDiadocApi:ServerUrl eq ""
   then do:
     message "Не задан адрес сервера или ключ разработчика для внешей системы Диадок"
     view-as alert-box.
     release object mDiadocConnection no-error.
     return ?.
  end. 
  
  /* Настройки прокси*/
  define variable VProxy as character no-undo.
   vProxy =  getextAttr({&attr-esys-proxy-addr}).
   if     vProxy ne "" 
      and vProxy ne ? 
   then do:
      mDiadocApi:ProxyMode =  "UseProxy". 
      mDiadocApi:ProxySettings:Url = vProxy.
      mDiadocApi:ProxySettings:Login    = getextAttr({&attr-esys-proxy-login}).
      mDiadocApi:ProxySettings:Password = getextAttr({&attr-esys-proxy-pswd}).
   end. 
   /*Получение списка сертификатов*/
  /* 
   vCertificates = mDiadocApi:GetPersonalCertificates(true).
   vCertSham = vCertificates:GetItem(1):Thumbprint.*/
/*Создание соединения*/
   define variable vtest as component-handle no-undo.
   vtest = mDiadocApi:TestConnection2().
   if not vtest:ConnectionSuccess
   then
      message vtest:ErrorText
      view-as alert-box.
   else
      mDiadocConnection = mDiadocApi:CreateConnectionByCertificate(iThumbprint,"") no-error.
   return mDiadocConnection.
end.

/* Подключение по сертификату */
&if "{1}" = "class"
&then
method public component-handle ConectByLogin
&else
function ConectByLogin return component-handle 
&endif
():
   if mDiadocApi eq ? then return ?.
   /*Задаем параметры подлючения к серверу*/
   mDiadocApi:ApiClientId = getextAttr({&attr-esys-diadoc-key}). /*"api-e781e743-064b-47a7-8119-f0b1264636ab".  Ключь разработчика  */
   mDiadocApi:ServerUrl   = getextAttr({&attr-esys-server-addr}).
   /*Получение списка сертификатов*/
   if mDiadocApi:ApiClientId eq ""
      or  mDiadocApi:ServerUrl eq ""
   then do:
     PutMes( "Error Не задан адрес сервера или ключ разработчика для внешей системы Диадок").
     
     release object mDiadocConnection no-error.
     return ?.
  end. 
  
  /* Настройки прокси*/
  define variable VProxy as character no-undo.
   vProxy =  getextAttr({&attr-esys-proxy-addr}).
   if     vProxy ne "" 
      and vProxy ne ? 
   then do:
      mDiadocApi:ProxyMode =  "UseProxy". 
      mDiadocApi:ProxySettings:Url = vProxy.
      mDiadocApi:ProxySettings:Login    = getextAttr({&attr-esys-proxy-login}).
      mDiadocApi:ProxySettings:Password = getextAttr({&attr-esys-proxy-pswd}).
   end. 
   mDiadocConnection = mDiadocAPI:CreateConnectionByLogin(getextAttr({&attr-esys-diadoc-user}),getextAttr({&attr-esys-diadoc-pwd})) no-error. /*"sibintek-pnpo@yandex.ru","987654321Aa"*/
   return mDiadocConnection.
end.    

/*запуск отправки служебных сообщение повсему письмам подключеных ящиков*/
&if "{1}" = "class"
&then
method public void ProcessSystemMessStart 
&else
function ProcessSystemMessStart return component-handle 
&endif
(IStartStop as logical):
   if mDiadocConnection eq ? then
   define variable vOrganizationList as component-handle no-undo.
   define variable vOrganization as component-handle no-undo.
   define variable vReceiptGenerationProcess as component-handle no-undo.
   define variable vi as integer no-undo.
   if mDiadocConnection ne ? 
   then do:
      vOrganizationList = mDiadocConnection:GetOrganizationList().
   
       /* Получение конкретной организации */
       do vi = 1 to vOrganizationList:count:
          vOrganization = vOrganizationList:GetItem(vi - 1 ). 
          vReceiptGenerationProcess = vOrganization:GetReceiptGenerationProcess().
          if IStartStop
          then
             vReceiptGenerationProcess:Start().
          else
             vReceiptGenerationProcess:Stop().
       end.
   end.
end.

&if "{1}" = "class"
&then
method private character SendAccept  
 (itype as character ,
  iReplyTask as component-handle,
  iOrganizationId as character ,
  iWorkflowId as integer,
  output oOperationCode as character  ): 
&else
procedure SendAccept:
   define input  parameter itype as character no-undo.
   define input  parameter iReplyTask as component-handle no-undo.
   define input  parameter iOrganizationId as character no-undo.
   define input  parameter iWorkflowId as integer no-undo.
   define output parameter oOperationCode as character no-undo.                                   
&endif
                                      

  
   define variable vContentItems as component-handle no-undo.
   define variable vContentItem  as component-handle no-undo.
   define variable vSigner       as component-handle no-undo.
   define variable vBuyerTitle   as component-handle no-undo.
   define variable vEmployee     as component-handle no-undo.
   define variable vContentOperCode as component-handle no-undo.
   define variable vOrganization   as component-handle no-undo.
   define variable vi as integer no-undo.

  define variable vdate as date no-undo.
  define variable vDocumentCreator as character no-undo.
  define variable vDocumentCreatorBase as character no-undo.
  define variable vOperationCode as character no-undo.
  define variable vOperationContenttext as character no-undo.
  define variable vOperationContent as character no-undo.

  define buffer user-account for user-account.

  vOrganization = mDiadocConnection:GetOrganizationById(iOrganizationId) no-error.
  if vOrganization eq ?
  then do:
     run str\utdacp.w (output vdate, output  vDocumentCreator, output vDocumentCreatorBase, output vOperationCode, output vOperationContent) no-error.
     if vdate eq ?
     then
        return error "".
  end. 
  else do:
     
     vOperationContent = if itype eq "AcceptDocumentWithDisc" then "2" else if itype eq "AcceptDocumentNotAccepted" then "3" else "1".
     vdate = today.
     vDocumentCreator = substitute("&1, ИНН~/КПП &2~/&3", vOrganization:name , vOrganization:inn , vOrganization:kpp).
  end.
     
  
                      
   if (   iWorkflowId = 3
      or iWorkflowId = 5
      or iWorkflowId = 8
      or iWorkflowId = 11)
      and iReplyTask ne ?
   then do:
      getdesc(iReplyTask).
      vContentItems = iReplyTask:ContentItems.
      getdesc(vContentItems).
      do vi = 1 to vContentItems:count:
         getdesc(vContentItems:GetItem(vi - 1 )).
         getdesc(vContentItems:GetItem(vi - 1 ):document).
         vContentItem = vContentItems:GetItem(vi - 1 ):Content.
         getdesc(vContentItem).
         release object vBuyerTitle no-error.
         vBuyerTitle = vContentItem:UniversalTransferDocumentBuyerTitle no-error.
         if vBuyerTitle eq ?
         then do:
            vBuyerTitle = vContentItem:UniversalCorrectionDocumentBuyerTitle.
            getdesc(vBuyerTitle).
            vOperationContenttext = "C изменением стоимости согласен".
         end.
         else do:
            oOperationCode = vOperationContent.
   vOperationContenttext = if vOperationContent eq "1"
                       then "Принято без разногласий"
                       else if vOperationContent eq "2"
                       then "Принято с разногласиями"
                       else if vOperationContent eq "3"
                       then "Товары не приняты"
                       else vOperationContent.
            getdesc(vBuyerTitle).
            vEmployee = vBuyerTitle:Employee.
            getdesc(vEmployee).
            find first user-account 
              where user-account.user-id = v-cntxt-userid 
              no-lock no-error .
               
            if available user-account
            then do:
               if    user-account.position eq ""
               or user-account.first-name eq ""
               or user-account.last-name eq ""
            then do:
               putmes("error Незаполнено должность или фамилия или имя").
               return error "Незаполнено должность или фамилия или имя".
            end.
               vEmployee:position        = user-account.position    . /* должность работника */
               vEmployee:FirstName       = user-account.first-name  . /* фамилия */
               vEmployee:LastName        = user-account.last-name   . /* имя */
               vEmployee:MiddleName      = user-account.second-name . /* отчество */
      /*         vEmployee:EmployeeInfo     = /* иные сведения, идентифицирующие физическое лицо */   */
               vEmployee:EmployeeBase     = "Должностные обязанности". /* основание полномочий представителя */ 
            end.
            
            getdesc(mDiadocConnection:Certificate).
   
            
            getdesc(vContentItem:UniversalTransferDocumentBuyerTitle).
            getdesc(vBuyerTitle:ContentOperCode).
            vContentOperCode = vBuyerTitle:ContentOperCode. /* КодСодОпер */
         /*   vContentOperCode:IdDiscrepDocument = "IdDiscrepDocument". /* ИдФайлДокРасх */
            vContentOperCode:DateDiscrepDocument = string(today,"99.99.9999"). /* ДатаДокРасх */
            vContentOperCode:NumberDiscrepDocument = "NumberDiscrepDocument". /* НомДокРасх */
            vContentOperCode:TypeDiscrepDocument = "3".                       /* ВидДокРасх Принимает значение: 
   2 – документ о приемке с расхождениями   |
   3 – документ о расхождениях
            */
            vContentOperCode:NameDiscrepDocument = "NameDiscrepDocument". /* НаимДокРасх */ */
            vContentOperCode:TotalCode = vOperationContent. /* КодИтога  Принимает значение:
   1 – товары (работы, услуги, права) приняты без расхождений (претензий)   |
   2 – товары (работы, услуги, права) приняты с расхождениями (претензией)   |
   3 – товары (работы, услуги, права) не приняты
            */
            vBuyerTitle:OperationCode   = vOperationCode. /*"вид операции".*/
         end. 
         vBuyerTitle:DocumentCreator = vDocumentCreator . /*"составитель файла обмена счета-фактуры (информации покупателя)".*/
         vBuyerTitle:DocumentCreatorBase     = vDocumentCreatorBase. /*"основание, по которому экономический субъект является составителем файла обмена счета-фактуры".*/
         
         vBuyerTitle:OperationContent =  vOperationContenttext. /* "содержание операции".*/
         vBuyerTitle:AcceptanceDate   = vdate. /*"Дата, чтение/запись - дата принятия товаров (результатов выполненных работ) или имущественных прав (подтверждения факта оказания услуг)" */
         /* mContentItem:Comment = "Норм".*/
         getdesc(vBuyerTitle).
         getdesc(vBuyerTitle:Signers).
         
         vSigner = vBuyerTitle:Signers:additems().
         getdesc(vSigner).
         getdesc(vSigner:SignerReference).
         getdesc(vSigner:SignerDetails).
         
   /*      для подписи должнобыть заполнено только одно из либо vSigner:SignerReference либо vSigner:SignerDetails
   
   
   vSigner:SignerDetails:Firstname    = "Фамилия1".
         vSigner:SignerDetails:LastName  = "Имя2".
         vSigner:SignerDetails:middlename = "Отчество3".
         vSigner:SignerDetails:SignerStatus = "SellerEmployee" .
   /*Значение Status Описание
   SellerEmployee работник организации продавца товаров (работ, услуг, имущественных прав)
   InformationCreatorEmployee работник организации - составителя информации продавца
   OtherOrganizationEmployee  работник иной уполномоченной организации
   AuthorizedPerson  уполномоченное физическое лицо (в том числе индивидуальный предприниматель)
   BuyerEmployee  работник организации покупателя товаров (работ, услуг, имущественных прав)
   InformationCreatorBuyerEmployee  работник организации - составителя информации покупателя*/
   vSigner:SignerDetails:SignerPowers = "PersonMadeOperation".
   /*Значение Powers Описание
   InvoiceSigner  лицо, ответственное за подписание счетов-фактур
   PersonMadeOperation  лицо, совершившее сделку, операцию
   MadeAndSignOperation лицо, совершившее сделку, операцию и ответственное за её оформление
   PersonDocumentedOperation  лицо, ответственное за оформление свершившегося события
   MadeOperationAndSignedInvoice лицо, совершившее сделку, операцию и ответственное за подписание счетов-фактур
   MadeAndResponsibleForOperationAndSignedInvoice  лицо, совершившее сделку, операцию и ответственное за её оформление и за подписание счетов-фактур
   ResponsibleForOperationAndSignerForInvoice   лицо, ответственное за оформление свершившегося события и за подписание счетов-фактур*/
   vSigner:SignerDetails:SignerOrgPowersBase = " основания полномочий (доверия) организации" .
   vSigner:SignerDetails:SignerPowersBase = "основания полномочий (доверия)".
   vSigner:SignerDetails:SignerInfo = "иные сведения, идентифицирующие физическое лицо".
   vSigner:SignerDetails:SignerOrganizationName = "наименование организации" .
   vSigner:SignerDetails:SignerType = "LegalEntity".
   /* LegalEntity представитель юридического лица
   IndividualEntity  индивидуальный предприниматель
   PhysicalPerson физическое лицо
   */
   vSigner:SignerDetails:RegistrationCertificate = "реквизиты свидетельства о регистрации ИП". 
   vSigner:SignerDetails:Inn = mDiadocConnection:Certificate:inn.
   
         
         
   */
   
   
         
        
         vSigner:SignerReference:CertificateThumbprint = mDiadocConnection:Certificate:Thumbprint.
         vSigner:SignerReference:boxid = iOrganizationId.
         getdesc(vSigner:SignerReference).
      end.
   end.
   


end.

&if "{1}" = "class"
&then
method private void SendAnswer
&else
function SendAnswer returns character  
&endif
(iReplyTask as component-handle,iorg as char,iTypeAnswer as character,imes as longchar ):

   define variable vContent       as component-handle no-undo.
   define variable vContentItems  as component-handle no-undo.
   define variable vSigner        as component-handle no-undo.
   define variable vSignTask      as component-handle no-undo.
   define variable vOrganization  as component-handle no-undo. 
   define variable vi as integer no-undo.
   
   if     itypeAnswer ne "AcceptRevocation" 
      and iReplyTask  ne ? 
   then do:
      getdesc(iReplyTask).
      vContentItems = iReplyTask:ContentItems.
      getdesc(vContentItems).
      do vi = 1 to vContentItems:count:
         getdesc(vContentItems:GetItem(vi - 1 )).
         getdesc(vContentItems:GetItem(vi - 1 ):document).
         vContent = vContentItems:GetItem(vi - 1 ):Content.
         /*vContent:comment = "отказ".*/
       /*  define variable vii as integer no-undo.
         define variable txt as longchar no-undo.
         do vii = 1 to 800:
            txt = txt + "1234567890" no-error.
         end.
         */
         vContent:comment =  imes.
         /*   не нужно должно быть подпи серетификатом */
        
        getdesc(vContent).
         vSigner = vContent:Signer.
         getdesc(vSigner).
         find first user-account 
           where user-account.user-id = v-cntxt-userid 
           no-lock no-error .
         
         if available user-account
         then do:
             if    user-account.position eq ""
            or user-account.first-name eq ""
            or user-account.last-name eq ""
         then do:
            putmes("error Незаполнено должность или фамилия или имя").
            return error "".
         end.   
         
            vSigner:JobTitle        = user-account.position    . /* должность работника */
            vSigner:Surname       = user-account.first-name  . /* фамилия */
            vSigner:FirstName        = user-account.last-name   . /* имя */
            vSigner:Patronymic      = user-account.second-name . /* отчество */
            vOrganization = mDiadocConnection:GetOrganizationById(iOrg) no-error.
            vSigner:Inn        = vOrganization:inn.
         end.
         else do:
         vSigner:Surname    = entry (1,mDiadocConnection:Certificate:name, " ").
         vSigner:FirstName  = entry (2,mDiadocConnection:Certificate:name, " ")no-error.
         vSigner:Patronymic = entry (3,mDiadocConnection:Certificate:name, " ")no-error.
         vSigner:JobTitle   = mDiadocConnection:Certificate:JobTitle.
          vSigner:Inn        = mDiadocConnection:Certificate:inn.
         end.
         
      end.
   end.
   
end.

&if "{1}" = "class"
&then
method public void Send
(iDocument as component-handle,iTypeAnswer as character,icomment as character,output oOperationCode as character  ):
&else
procedure send:
   define input  parameter iDocument as component-handle no-undo.
   define input  parameter iTypeAnswer as character no-undo.
   define input  parameter icomment as character no-undo. 
   define output parameter oOperationCode as character no-undo.
&endif

   define variable vReplyTask    as component-handle no-undo.
   define variable vTypeAnswer as character no-undo.
   define variable vTypeAnswer_orig as character no-undo.
   define variable Vmes as longchar  no-undo.
   define variable vOrganizationid as character no-undo.
   define variable vDocumentid as character no-undo.
   define variable vi as integer no-undo.
   if iDocument ne ? 
   then do:
      case iTypeAnswer:
         when "Подписания"                 then vTypeAnswer =  "AcceptDocument".
         when "отказ подписи"              then vTypeAnswer =  "RejectDocument".
         when "запрос коректировки"        then vTypeAnswer =  "CorrectionRequest".
         when "Запрос анулирование"        then vTypeAnswer =  "RevocationRequest".
         when "Подтверждение анулирования" then vTypeAnswer =  "AcceptRevocation".
         when "отказ анулирования"         then vTypeAnswer =  "RejectRevocation".
         when "подписать с расхождениями"  then vTypeAnswer =  "AcceptDocumentWithDisc".
         when "подписать товар не принят"  then vTypeAnswer =  "AcceptDocumentNotAccepted".
         otherwise vTypeAnswer = iTypeAnswer .
      end case.
      
      vTypeAnswer_orig = vTypeAnswer.
      if    vTypeAnswer =  "AcceptDocumentWithDisc"
         or vTypeAnswer =  "AcceptDocumentNotAccepted"
      then
         vTypeAnswer =  "AcceptDocument".  
      if mDiadocConnection:AuthenticateType ne "Certificate" then return error "не сертификат".
      vReplyTask = iDocument:CreateReplySendTask2(vTypeAnswer).
      vOrganizationid = iDocument:OrganizationId.
      vDocumentid     = iDocument:DocumentId.
      if vTypeAnswer =  "AcceptDocument" 
      then do:
         &if "{1}" = "class"
         &then
             sendAccept  (vTypeAnswer_orig,vReplyTask,iDocument:OrganizationId,iDocument:WorkflowId,output oOperationCode ) no-error.
         &else
         run sendAccept in this-procedure (vTypeAnswer_orig,vReplyTask,iDocument:OrganizationId,iDocument:WorkflowId,output oOperationCode ) no-error.
         &endif
         if error-status:error
         then
            return error "".
      end.
      else do:
         
    /*         if vDocumentid ne "1ee3b874-3819-4eca-8f50-47232a192c36057cd390-615f-4942-b8b9-7272ae719422" then next.*/
         find first utd where utd.DocumentExt     = vDocumentid
                          and utd.OrganizationExt = vOrganizationid
         no-lock no-error.
         if available utd
         then do:
            if   vTypeAnswer ne  "CorrectionRequest"
                and vTypeAnswer ne  "RejectDocument"
            then 
               icomment = "".  
                   
            Vmes = GetErrForUtd(utd.db-num,utd.doc-id,?) .
            Vmes = GetErrComText(icomment,Vmes).
            if mFlaftest
            then do:
               output to "SendAnswer.txt" .
               put unformatted string(Vmes).
               output close.
               message "сформирован файл " search("SendAnswer.txt")
               view-as alert-box.
               return error "ничего не отправляем".
            end.
            else  
               SendAnswer(vReplyTask,iDocument:OrganizationId, iTypeAnswer,Vmes) no-error.
            if error-status:error
            then
               return error "".
            end.
         end.
         if not mFlaftest
         then do:
            vReplyTask:Send() no-error.
            if error-status:num-messages > 0 then do:
            do vi = 1 to error-status:num-messages:
               PutMes(substitute("Error Ошибка при выполнение действия по документу &1 Ошибка: &2. ", vDocumentid ,error-status:get-message(vi))).
               
            end.
            return error "Ошибка при выполнение дейстия с документом".
         end.
         /*do trans:
            find first utd where utd.DocumentExt     = vDocumentid
                             and utd.OrganizationExt = vOrganizationid
            exclusive-lock no-error.
            if available utd
            then do:
               case iTypeAnswer:
                  when   "AcceptDocument"               then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRecipient:KeyIntDB.
                  when   "RejectDocument"               then utd.sts-edi = if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:SignatureAutoRejected:KeyIntDB
                                                                           then ObjSrv:Env:Utd:Sts:edi:sendAutoRejected:KeyIntDB
                                                                           else ObjSrv:Env:Utd:Sts:edi:sendRejected:KeyIntDB.
                  when   "CorrectionRequest"            then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendAdjustment:KeyIntDB.
/*                  when   "RevocationRequest"          then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:CorrectionRequested:KeyIntDB.*/
                  when   "AcceptRevocation"             then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRevocation:KeyIntDB.
                  when   "RejectRevocation"             then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRevocation:KeyIntDB.
                  when   "AcceptDocumentWithDisc"       then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRecipient:KeyIntDB.
                  when   "AcceptDocumentNotAccepted"    then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRecipient:KeyIntDB.
                   
               end case.
               if iTypeAnswer eq "CorrectionRequest"
               then
                  utd.sts = ObjSrv:Env:Utd:Sts:th:CorrectionRequested:KeyIntDB.
            end.
         end.*/ 
      end.
   end.
end.
&if "{1}" = "class"
&then
method public character  GetDocumforid
&else
function GetDocumforid returns character
&endif
(input  iorg as character ,
 input  idoc-id as character ,
 output oDocument      as component-handle
  ):
   define variable vOrganization  as component-handle no-undo.
   define variable vDocument      as component-handle no-undo.
   define buffer utd           for ub.utd.
   
   if     
          iorg  ne ?
      and iorg  ne ""
      and idoc-id ne ?
      and idoc-id ne ""
   then do:
      vOrganization = mDiadocConnection:GetOrganizationById(iorg) no-error.
      if vOrganization ne ?
      then
         oDocument = vOrganization:GetDocumentById(idoc-id,false).
      else do:
         PutMes(substitute("Error Нет доступа к организации &1 по документу &2. ", iorg,idoc-id)).
         return "Нет доступа к организации " + iorg.
      end.
   end.
   else
      return "Нет доступа к организации не ЭДО".
   
   release object vOrganization no-error.
   return "". 
end.

&if "{1}" = "class"
&then
method public character  GetDocum
&else
function GetDocum returns character
&endif
(input  idb-num as integer,
 input  idoc-id as integer,
 output oDocument      as component-handle
  ):
   define variable vOrganization  as component-handle no-undo.
   define variable vDocument      as component-handle no-undo.
   define buffer utd           for ub.utd.
   find first utd where utd.db-num eq idb-num
                    and utd.doc-id eq idoc-id
   no-lock no-error.
   if     available utd
      and utd.OrganizationExt ne ?
      and utd.OrganizationExt ne ""
      and utd.DocumentExt ne ?
      and utd.DocumentExt ne ""
   then do:
      vOrganization = mDiadocConnection:GetOrganizationById(utd.OrganizationExt) no-error.
      if vOrganization ne ?
      then
         oDocument = vOrganization:GetDocumentById(utd.DocumentExt,false).
      else do:
         PutMes(substitute("Error Нет доступа к организации &1 по документу &2. ", utd.OrganizationExt,utd.DocumentNumber)).
         return "Нет доступа к организации " + utd.OrganizationExt.
      end.
   end.
   else
      return "Нет доступа к организации не ЭДО".
   
   release object vOrganization no-error.
   return "". 
end.



&if "{1}" = "class"
&then
method public logical GetFirstUTDinPack
&else
function GetFirstUTDinPack returns logical 
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
         find first buf_utd where Buf_utd.PackageId eq utd.PackageId
                              and Buf_utd.EDocType  eq objSrv:Env:Utd:EDocType:UTD:KeyIntDB
                              
         no-lock.
         assign
            odb-num = buf_utd.db-num
            odoc-id = buf_utd.doc-id
         .
         
         return if available buf_utd then (recid(utd) eq recid(buf_utd)) else no.
      end.  
   end.
   return ?.
end.

&if "{1}" = "class"
&then
method public logical CheckLoad
&else
function CheckLoad returns logical 
&endif
(iDocument as component-handle,
 output ohost-code as integer ,
 output oObj-type  as character  ,
 output oObj-code  as integer ):
   define variable vFlag as logical no-undo.
   
   define variable vDocumentChild as component-handle no-undo.
   define variable vContent as component-handle no-undo.
   define variable vConsignees as component-handle no-undo.
   
   oObj-type  = ?.
   oObj-code  = ?.
   ohost-code = ?.
   
   
   define buffer ext-classif   for ext-classif. 
   define buffer clients       for clients.
   define buffer buf_clients   for clients.
   define buffer clients-attr  for clients-attr.
   if   iDocument:type eq "UniversalTransferDocument"
     or iDocument:type eq "UniversalTransferDocumentRevision"
   then main-block :
   do on error undo main-block, return error:
      if iDocument:Direction eq "Inbound"
      then do:
         getdesc(iDocument).
         define variable vOrganizationid as character no-undo.
         define variable vDocumentid as character no-undo.
         vOrganizationid = iDocument:OrganizationId.
         vDocumentid     = iDocument:DocumentId.
         find first utd where utd.DocumentExt     = vDocumentid
                          and utd.OrganizationExt = vOrganizationid
         no-lock no-error .
         if available utd
         then do:
            assign
               Oobj-type = utd.obj-type
               Oobj-code = utd.obj-code
               ohost-code = utd.host-code.
            .
         end.
         vDocumentChild = iDocument:GetDynamicContent("Seller") no-error.
       
         if    (Oobj-code  ne 0 and Oobj-code  ne ?
            and ohost-code ne 0 and ohost-code ne ?)
         then vFlag = no.
         if    (Oobj-code  ne 0 and Oobj-code  ne ?
            and (ohost-code eq 0 and ohost-code eq ?))
         then do:
             find first clients  where clients.obj-type   = Oobj-type
                                   and clients.obj-code   = Oobj-code
             no-lock no-error .
             if available clients
             then
                ohost-code =  clients.host-code.
             vFlag = no.
         end.
         else if vDocumentChild ne ?
         then do:
            vContent = vDocumentChild:UniversalTransferDocumentWithHyphens no-error. /* табличная часть счета фактуры */
            
            if vContent ne ?
            then do:
               define variable vFnsParticipantId as character no-undo.
               define variable vinn as character no-undo.
               define variable vkpp as character no-undo.
               define variable vorgname as character no-undo.
               define variable vAddrOrg as character no-undo.
               
               vConsignees = vContent:Consignees.
               if vConsignees:Consignee:count > 0
               then
                  getOrganizationInfo(vConsignees:Consignee:GetItem(0),output vinn,output vkpp,vFnsParticipantId, output vorgname, output vAddrOrg).
               vFnsParticipantId =  vContent:SenderFnsParticipantId.
               find first ext-classif where ext-classif.classif-name  eq {&extclass_code_id_diadok_client}
                                        and ext-classif.charkey_three eq vFnsParticipantId
               no-lock no-error.
               if available ext-classif
               then do:
                  find first clients 
                    where clients.obj-type   = ext-classif.CharKey_One
                      and clients.obj-code   = ext-classif.Key#_One
                      and not can-find(first ub.sysconf where ub.sysconf.host-code = clients.obj-code)
                  no-lock no-error .
                  if not available clients
                  then do:
                     PutMes(substitute("По &1 отправитель &2 наша фирма." ,iDocument:DocumentNumber, vFnsParticipantId) ).
                     return no.
                  end.
               end.
               else do:
                  PutMes(substitute("По &1 не найден отправитель  &2." ,iDocument:DocumentNumber, vFnsParticipantId) ).
                  return no.
                  
               end.
               vFnsParticipantId = vContent:RecipientFnsParticipantId.
               find first ext-classif where ext-classif.classif-name  eq {&extclass_code_id_diadok_client}
                                        and ext-classif.charkey_three eq vFnsParticipantId
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
                        PutMes(substitute("По &1 получатель  &2 не наша фирма." ,iDocument:DocumentNumber, vFnsParticipantId) ).
                        return no.
                     end.
                     ohost-code = ext-classif.Key#_One.
                     block-cl:
                     for each clients-attr 
                        where clients-attr.attr-code  = {&attr-kpp} 
                          and clients-attr.obj-type   = {&shop}
                          and clients-attr.attr-value = vkpp
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
                        PutMes(substitute("По &1 не найден объект по КПП &2." ,iDocument:DocumentNumber, vkpp )).
                        vFlag = yes.
                     end.
                  end.
               end.
               else do:
                  PutMes(substitute("По &1 не найден получатель  &2." ,iDocument:DocumentNumber, vFnsParticipantId) ).
                  return no.
                  
               end.
            end.
            else do:
               PutMes("Error Ошибка получения данных из Диадок UniversalTransferDocumentWithHyphens").
               return no.
            end.
         end.
         else do:
            PutMes("Error Ошибка получения данных из Диадок Seller").
            return no.
         end.
      end.
      else
         vFlag = yes.
      if ohost-code eq ? or ohost-code eq 0
      then do: 
         PutMes(substitute("По &1 не удалось определить фирму по получателю  &2." ,iDocument:DocumentNumber, vFnsParticipantId) ).
         return no.
      end.
        
   end.
   else do:
      define variable vdb-num as integer no-undo.
      define variable vdoc-id as integer no-undo.
      GetLastUTDForPac(iDocument:PackageId,iDocument:Timestamp,output vdb-num,output vdoc-id ).
      define buffer     utd for utd.
      find first utd where utd.db-num eq vdb-num
                       and utd.doc-id eq vdoc-id
      no-lock no-error.
      if available utd
      then do:
         assign
            oobj-type  = utd.obj-type
            oobj-code  = utd.obj-code
            ohost-code = utd.host-code
         .
      end.
      else
         vFlag = yes.
      
   end.
   if not vFlag
   then do:
      define variable v-tth as handle no-undo .
      define variable v-value-character as character no-undo.
      define variable v-value-date as date no-undo.
      define variable v-value-decimal as decimal no-undo.
      define variable v-value-integer as integer no-undo.
      define variable v-param-type as character no-undo.
      define variable v-FlagEdo as logical no-undo.
      run adm/shattri.p (
         input "get":U
         ,input  oobj-type /*p-obj-type*/
         ,input   oobj-code /*p-obj-code*/
         ,input  {&attr-marking}
         ,input  {&attr-marking_marking-EDO} /*p-param-code*/
         ,output v-value-character
         ,output v-value-date
         ,output v-value-decimal
         ,output v-value-integer
         ,output v-FlagEdo
         ,output v-param-type
         ,input-output table-handle v-tth
      ) no-error .
      if not error-status:error and v-FlagEdo ne ? 
      then do:
         vFlag = v-FlagEdo.
         if not vFlag
         then
            PutMes(substitute("На объекте &1&2 не установлен параметр работы с ЭДО.",oobj-type,oobj-code)).
      end.
   end.
   
   return vFlag.
end.



&if "{1}" = "class"
&then
method public void UpdateUTDInformOne
&else
function UpdateUTDInformOne returns logical 
&endif
(iDocument as component-handle):
   define variable vOrganizationid as character no-undo.
   define variable vDocumentId as character no-undo.
   define variable vi as integer no-undo.
   define variable vii as integer no-undo.
   define variable viii as integer no-undo.
   define variable vtext as longchar no-undo.
   
   define buffer utd           for ub.utd.
   define buffer old_utd           for ub.utd.
   
   define buffer utd-lines      for ub.utd-lines.
   define buffer marking       for ub.marking.
   define buffer marking-lines for ub.marking-lines.
   define buffer utd-marking-lines for ub.utd-marking-lines.
   define buffer buf_utd-marking-lines for ub.utd-marking-lines.
   
   
   
   define variable vDocumentChild               as component-handle no-undo.
   define variable vContent                     as component-handle no-undo.
   define variable vValues                      as component-handle no-undo.
   define variable vSellers                     as component-handle no-undo.
   define variable vConsignees                  as component-handle no-undo.
   define variable vInvoiceTable                as component-handle no-undo.
   define variable vItems                       as component-handle no-undo. 
   define variable vExtendedInvoiceItem         as component-handle no-undo.
   define variable vItemIdentificationNumber    as component-handle no-undo.
   define variable vTransferBaseCol             as component-handle no-undo.
   define variable vTransferBase                as component-handle no-undo.
   define variable vorgname as character no-undo.
   define variable vAddrOrg as character no-undo.
   define variable volddb-num as integer no-undo.
   define variable volddoc-id as integer no-undo.
                  
                  
   define variable vunits  as component-handle no-undo.
   define variable vunit   as component-handle no-undo.
   define variable VValue  as character        no-undo.
   define variable vNewUtd as logical          no-undo.
   if iDocument eq ?
   then
     return no.
   vOrganizationid = iDocument:OrganizationId.
   vDocumentid     = iDocument:DocumentId.
   find first utd where utd.DocumentExt     = vDocumentid
                    and utd.OrganizationExt = vOrganizationid
   no-lock no-error .
      
   find first tt-recid where tt-recid.orgid eq vOrganizationid
                         and tt-recid.docid eq vDocumentid
   
   no-lock no-error.
   if not available tt-recid
   then do trans:   
      if iDocument  ne ?
         and (
                  iDocument:type eq "UniversalTransferDocument"
               or iDocument:type eq "UniversalTransferDocumentRevision"
               or iDocument:type eq "UniversalCorrectionDocument"
              )
      then do:
         PutMes(substitute("Загрузка документа  &1." ,iDocument:DocumentNumber) ).
         define variable vhost-code as integer   no-undo.
         define variable vobj-type  as character no-undo.
         define variable vobj-code  as integer   no-undo.
         if not CheckLoad(iDocument,output vhost-code,output vobj-type,output  vobj-code )
         then do:
            PutMes(substitute("Документ &1 пропущен." ,iDocument:DocumentNumber) ).
            create tt-recid.
            assign
               tt-recid.orgid = vOrganizationid
               tt-recid.docid = vDocumentid
            . 
            return no. 
         end.
      
         
/*         run gbl/inidebug.p.*/
         find first utd where utd.DocumentExt     = vDocumentid
                          and utd.OrganizationExt = vOrganizationid
         no-lock no-error /* no-wait */ .
         if available utd 
         then do:
            if     utd.sts-edi > ObjSrv:Env:Utd:Sts:edi:StatFinesh
               and iDocument:RevocationStatus ne "RequestsMyRevocation"
            then do:
               create tt-recid.
               assign
                  tt-recid.orgid = vOrganizationid.
                  tt-recid.docid = vDocumentid
               .
               PutMes(substitute("Документ &1 в конечном статусе. Документ пропущен." ,iDocument:DocumentNumber) ).
/*               return false.*/
            end.
      /*         if vDocumentid ne "1ee3b874-3819-4eca-8f50-47232a192c36057cd390-615f-4942-b8b9-7272ae719422" then next.*/
            find current utd exclusive-lock no-error  no-wait  .
            
            if  not available  utd
            
            then do:
               PutMes(substitute("Документ &1 заблокирован и будет пропущен." ,iDocument:DocumentNumber )).
               return false.
            end.
         end.
         subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
         MySeqUtd = ?.
         if     not available  utd
            
         then do:
            create utd.
            assign
               utd.DocumentExt      = vDocumentid
               utd.OrganizationExt  = vOrganizationid
/*               utd.LoadDate         = today*/
               vNewUtd              = yes
               
            .
            validate utd. /* необходимо для заполнения db-num  и doc-id */
         end.
         assign 
            utd.host-code = vhost-code when vhost-code ne ? and vhost-code ne 0
            utd.obj-code  = vobj-code  when vobj-code  ne ? and vobj-code  ne 0
            utd.obj-type  = vobj-type  when vobj-type  ne ? and vobj-type  ne ""
         .
            
       /*  if iDocument:DocumentNumber eq "21_4"
         then
            message "222ddd"
            view-as alert-box. */
         
         
         
         
        /* if    utd.ReceiptStatus    ne iDocument:RecipientReceiptMetadata:ReceiptStatus
            or utd.RevocationStatus ne iDocument:RevocationStatus
            or utd.RecipientResponseStatus          ne iDocument:RecipientResponseStatus
         then
            utd.sts-edi = ?. */
         setattrutd (utd.db-num,utd.doc-id,"FileName",iDocument:FileName).
         utd.RevocationStatus = iDocument:RevocationStatus.
         utd.RecipientResponseStatus          = iDocument:RecipientResponseStatus.
         utd.TypeId           = iDocument:type.
         utd.CounteragentId   = iDocument:Counteragent:id.
         utd.CustomDocumentId = iDocument:CustomDocumentId.
     /*    utd.obj-type         = "".
         utd.obj-code         = 0.
         utd.host-code        = 0.
         utd.contract-code    = 0.
         utd.cli-type         = "".
         utd.cli-code         = 0.
       */  
         
         
         utd.DocumentNumber = iDocument:DocumentNumber.
         utd.DocumentDate   = date(iDocument:DocumentDate).
         utd.Timestamp      = datetime(iDocument:Timestamp) .
         utd.ReceiptStatus  = iDocument:RecipientReceiptMetadata:ReceiptStatus. 
         utd.Direction      = iDocument:Direction.
         utd.ModifyDate = today.
/*         utd.PackageId = iDocument:PackageId.*/
         utd.flagRI     =    utd.ReceiptStatus eq "GeneralReceiptStatusNotAcceptable" or utd.ReceiptStatus eq "Finished". 
         utd.EDocType = if   iDocument:type eq "UniversalTransferDocument"
                          or iDocument:type eq "UniversalTransferDocumentRevision"
                        then objSrv:Env:Utd:EDocType:UTD:KeyIntDB
                        else objSrv:Env:Utd:EDocType:UCD:KeyIntDB.
         
         
         getdesc(iDocument).
         getdesc(iDocument:Counteragent).   
         getdesc(iDocument:RecipientReceiptMetadata).
         getdesc(iDocument:ConfirmationMetadata).
         utd.AmendmentRequested = logical(iDocument:AmendmentRequested). /*Булево, чтение - признак, был ли запрос на уточнение*/
         if iDocument:type ne "UniversalTransferDocumentRevision"
         then do:
                utd.Revised = logical(iDocument:Revised). /*Булево, чтение - признак, было ли исправление данного документа*/
                utd.Corrected = logical(iDocument:Corrected).
         end.
      /*   getdesc(iDocument:RecipientResponseStatus).*/
   
         /*mDocument:SendReceiptsAsync().
            */
            /*mDocument:MarkAsRead().*/
                     /*mDocumentchaldList = mDocument:SubordinateDocumentIds.
            vii = mDocumentchildList:Count.*/
         vDocumentChild = iDocument:GetDynamicContent("Seller").
         getdesc(vDocumentChild).
         if   iDocument:type eq "UniversalTransferDocument"
           or iDocument:type eq "UniversalTransferDocumentRevision"
         then do:
            utd.Total = iDocument:total.
            utd.Vat = iDocument:Vat. 
         end.
         else do:
            utd.Total = decimal (iDocument:TotalInc) - decimal (iDocument:TotalDec).
            utd.Vat = decimal (iDocument:VatInc) - decimal (iDocument:VatDec).  
               
         end.
   /*            Создание Reflector'а*/
         find first utd-lines where utd-lines.db-num     = utd.db-num
                                and utd-lines.doc-id     = utd.doc-id
                                no-lock no-error.
         if     (   vNewUtd 
                 or utd.Direction ne "Inbound"
                 or not available utd-lines)
            and vDocumentChild ne ?
         then do:
            if utd.EDocType eq objSrv:Env:Utd:EDocType:UTD:KeyIntDB
            then do:
                
               vContent = vDocumentChild:UniversalTransferDocumentWithHyphens no-error. /* табличная часть счета фактуры */
               if vContent ne ?
               then do:
                  getdesc(vContent).
                  /* дополнительная информация по договору 
                  getdesc(vContent:AdditionalInfoId).
                  getdesc(vContent:AdditionalInfoId:AdditionalInfo).
                  getdesc(vContent:AdditionalInfoId:AdditionalInfo:getitem(0)). */
                  getdesc(vContent:TransferInfo).
                  getdesc(vContent:TransferInfo:TransferBases).
                  vTransferBasecol = vContent:TransferInfo:TransferBases:TransferBase.
                  getdesc(vTransferBasecol).
                  do vi = 1 to min(vTransferBasecol:count,1):
                     vTransferBase = vTransferBasecol:getitem(vi - 1).
                     getdesc(vTransferBase).
                     utd.BaseDocumentNumber = vTransferBase:BaseDocumentNumber.
                     utd.BaseDocumentName   = vTransferBase:BaseDocumentName.
                     utd.BaseDocumentDate   = date(vTransferBase:BaseDocumentDate).
                  end.
                  
                  vSellers = vContent:Sellers.
                  getdesc(vSellers).
                  
                  getdesc(vSellers:Seller:GetItem(0)).
                  if vSellers:Seller:count > 0
                  then
                     getOrganizationInfo(vSellers:Seller:GetItem(0),output utd.cli-inn,output utd.cli-kpp,utd.cli-FnsParticipantId, output vorgname, output vAddrOrg).
                  utd.cli-FnsParticipantId = vContent:SenderFnsParticipantId.
                  utd.cli-info = vorgname + " " + vAddrOrg.
                  vConsignees = vContent:Consignees.
                  getdesc(vConsignees).
                    /* mBuyerCol = mBuyers:Buyer. */
         /*         getdesc(vBuyers:Buyer:getitem(0)).*/
                  if vConsignees:Consignee:count > 0
                  then
                     getOrganizationInfo(vConsignees:Consignee:GetItem(0),output utd.obj-inn,output utd.obj-kpp,utd.obj-FnsParticipantId, output vorgname, output vAddrOrg).
                  utd.obj-info = vorgname + " " + vAddrOrg + " ИНН: " + utd.obj-inn + " КПП: " + utd.obj-kpp.
                  
                  utd.obj-FnsParticipantId = vContent:RecipientFnsParticipantId.
                  vInvoiceTable = vContent:Table.
                  getdesc(vInvoiceTable).
                  vItems = vInvoiceTable:Item.
                  do vi = 1 to vItems:Count: /* Документы потомки */
                     vExtendedInvoiceItem= vItems:GetItem(vi - 1).
                       /* if VIII = 1 then*/ 
                     getdesc(vExtendedInvoiceItem).
                     find first utd-lines where utd-lines.db-num     = utd.db-num
                                            and utd-lines.doc-id     = utd.doc-id
                                            and utd-lines.LineNum    = vi 
                     exclusive-lock no-error.
                     if not available  utd-lines
                     then do:
                        create utd-lines.
                        assign
                           utd-lines.db-num   = utd.db-num
                           utd-lines.doc-id   = utd.doc-id
                           utd-lines.Linenum  = vi
                        .
                        
                     end.
                     utd-lines.ProductCode = vExtendedInvoiceItem:Product.
                     utd-lines.UnitCode    = vExtendedInvoiceItem:UnitnAME.
                     utd-lines.Quantity    = vExtendedInvoiceItem:Quantity.
                     utd-lines.Price       = vExtendedInvoiceItem:Price.
                     utd-lines.TotalWithVatExcluded   = vExtendedInvoiceItem:SubtotalWithVatExcluded.
         /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
                     utd-lines.TaxRate   =   if  vExtendedInvoiceItem:TaxRate eq "без ндс" then -1 else decimal(trim(entry(1,vExtendedInvoiceItem:TaxRate,"/"),"%")).
                     utd-lines.Vat       = vExtendedInvoiceItem:Vat.
                     utd-lines.Total     = vExtendedInvoiceItem:Subtotal.
                     utd-lines.Article   = vExtendedInvoiceItem:ItemVendorCode. /* ??? */
            
                       
                     getdesc(vExtendedInvoiceItem:CustomsDeclarations).
                     getdesc(vExtendedInvoiceItem:CustomsDeclarations:CustomsDeclaration).
                     if vExtendedInvoiceItem:CustomsDeclarations:CustomsDeclaration:COUNT >= 1
                     then
                        getdesc(vExtendedInvoiceItem:CustomsDeclarations:CustomsDeclaration:GETITEM(0)).
                     getdesc(vExtendedInvoiceItem:AdditionalInfos).
                     getdesc(vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo).
                     if vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo:COUNT >= 1
                     then
                        getdesc(vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo:GETITEM(0)).
                     getdesc(vExtendedInvoiceItem:ItemTracingInfos).
                     getdesc(vExtendedInvoiceItem:ItemTracingInfos:ItemTracingInfo ).
                     if vExtendedInvoiceItem:ItemTracingInfos:ItemTracingInfo:COUNT >= 1
                     then
                        getdesc(vExtendedInvoiceItem:ItemTracingInfos:ItemTracingInfo:GETITEM(0) ).
                     getdesc(vExtendedInvoiceItem:ItemIdentificationNumbers).
                     getdesc(vExtendedInvoiceItem:ItemIdentificationNumbers:ItemIdentificationNumber).
                     do vii = 1 to vExtendedInvoiceItem:ItemIdentificationNumbers:ItemIdentificationNumber:COUNT:
                        
                        vItemIdentificationNumber = vExtendedInvoiceItem:ItemIdentificationNumbers:ItemIdentificationNumber:GETITEM(vii - 1).
                        getdesc(vItemIdentificationNumber).
                        getdesc(vItemIdentificationNumber:Unit).
                        if vItemIdentificationNumber:TransPackageId ne ? and vItemIdentificationNumber:TransPackageId ne ""
                        then do:
                           VValue = repSpecSimbforDm(vItemIdentificationNumber:TransPackageId).
                           find first marking where marking.mark eq VValue exclusive-lock no-error.
                           if not available marking
                           then do:
                              create marking.
                              marking.mark       = vValue.
                              marking.unit-ext   = getLevelMotpByCodId(marking.mark) .
                              marking.box-qnty   = getQntyUTDByCodId(marking.mark) .
                              marking.unit       = getLevelUTDByCodId(marking.mark) .
                              
                               
                                    
                           end.
                           marking.unit-ext   = getLevelMotpByCodId(marking.mark) .
                           marking.box-qnty   = getQntyUTDByCodId(marking.mark) .
                           marking.unit       = getLevelUTDByCodId(marking.mark) .
                           marking.unit-ext = utd-lines.UnitCode .
                           if marking.sts = objSrv:Env:marking:Sts:Mark:MarkError:KeyIntDB
                              or (     iDocument:type eq "UniversalTransferDocument"
                                  and marking.sts = objSrv:Env:marking:Sts:Mark:NotAvailable:KeyIntDB)
                           then
                              marking.sts = ?.
                           find first utd-marking-lines where utd-marking-lines.mark       = marking.mark
                                                          and utd-marking-lines.db-num     = utd-lines.db-num     
                                                          and utd-marking-lines.doc-id     = utd-lines.doc-id 
                                                          and utd-marking-lines.Linenum    = utd-lines.Linenum        
                           no-lock no-error.
                           if not available utd-marking-lines
                           then do:
                              create utd-marking-lines.
                              assign
                                 utd-marking-lines.mark      = marking.mark
                                 utd-marking-lines.db-num    = utd-lines.db-num     
                                 utd-marking-lines.doc-id    = utd-lines.doc-id 
                                 utd-marking-lines.Linenum   = utd-lines.Linenum
                                 utd-marking-lines.doc-level = 1        
                              .
                               
                           end.
                        
                        end. 
                        vunit = vItemIdentificationNumber:Unit.
                        do viii = 1 to vunit:count:
                           vValue = vunit:GETITEM(viii - 1).
                           VValue = repSpecSimbforDm(VValue).
                           find first marking where marking.mark eq VValue exclusive-lock no-error.
                           if not available marking
                           then do:
                              create marking.
                              marking.mark       = vValue.
                              marking.unit-ext   = getLevelMotpByCodId(marking.mark) .
                              marking.box-qnty   = getQntyUTDByCodId(marking.mark) .
                              marking.unit       = getLevelUTDByCodId(marking.mark) .
                              define variable vMRC as decimal no-undo.
                              vMRC =  getMRCByDM (vValue).
                              if     vMRC ne 0 
                                 and vMRC ne ?
                              then do:
                                 create marking-attr.
                                 assign
                                    marking-attr.mark =  vValue
                                    marking-attr.attr-code = "MRC"
                                    marking-attr.attr-value = string(vMRC)
                                 no-error.
                                 release marking-attr no-error.
                              end. 
                                    
                           end.
                           marking.unit-ext   = getLevelMotpByCodId(marking.mark) .
                              marking.box-qnty   = getQntyUTDByCodId(marking.mark) .
                              marking.unit       = getLevelUTDByCodId(marking.mark) .
                           marking.unit-ext = utd-lines.UnitCode .
                           if marking.sts = objSrv:Env:marking:Sts:Mark:MarkError:KeyIntDB
                              or (     iDocument:type eq "UniversalTransferDocument"
                                  and marking.sts = objSrv:Env:marking:Sts:Mark:NotAvailable:KeyIntDB)
                           then
                              marking.sts = ?.
                           find first utd-marking-lines where utd-marking-lines.mark       = marking.mark
                                                          and utd-marking-lines.db-num     = utd-lines.db-num     
                                                          and utd-marking-lines.doc-id     = utd-lines.doc-id 
                                                          and utd-marking-lines.Linenum    = utd-lines.Linenum        
                           no-lock no-error.
                           if not available utd-marking-lines
                           then do:
                              create utd-marking-lines.
                              assign
                                 utd-marking-lines.mark      = marking.mark
                                 utd-marking-lines.db-num    = utd-lines.db-num     
                                 utd-marking-lines.doc-id    = utd-lines.doc-id 
                                 utd-marking-lines.Linenum   = utd-lines.Linenum
                                 utd-marking-lines.doc-level = 1        
                              .
                               
                           end.
                        end.
                        
                        getdesc(vItemIdentificationNumber:PackageId).
                        vunit = vItemIdentificationNumber:PackageId.
                                        
                        do viii = 1 to vunit:count:
                           VValue = vunit:GETITEM(viii - 1).
                           VValue = repSpecSimbforDm(VValue).
                           find first marking where marking.mark eq VValue exclusive-lock no-error.
                           if not available marking
                           then do:
                              create marking.
                              marking.mark        = VValue.
                              marking.unit-ext    = getLevelMotpByCodId(marking.mark) .
                              marking.box-qnty    = getQntyUTDByCodId(marking.mark) .
                              marking.unit        = getLevelUTDByCodId(marking.mark) .
                              vMRC =  getMRCByDM (vValue).
                              if     vMRC ne 0 
                                 and vMRC ne ?
                              then do:
                                 create marking-attr.
                                 assign
                                    marking-attr.mark =  vValue
                                    marking-attr.attr-code = "MRC"
                                    marking-attr.attr-value = string(vMRC)
                                 no-error.
                                 release marking-attr no-error.
                              end.
                           end.
                          marking.unit-ext   = getLevelMotpByCodId(marking.mark) .
                              marking.box-qnty   = getQntyUTDByCodId(marking.mark) .
                              marking.unit       = getLevelUTDByCodId(marking.mark) .
                           marking.unit = utd-lines.UnitCode .
                           if    marking.sts = objSrv:Env:marking:Sts:Mark:MarkError:KeyIntDB
                             or (     iDocument:type eq "UniversalTransferDocument"
                                  and marking.sts = objSrv:Env:marking:Sts:Mark:NotAvailable:KeyIntDB)
                           then
                              marking.sts = ?.
                           find first utd-marking-lines where utd-marking-lines.mark       = marking.mark
                                                          and utd-marking-lines.db-num     = utd-lines.db-num     
                                                          and utd-marking-lines.doc-id     = utd-lines.doc-id 
                                                          and utd-marking-lines.Linenum    = utd-lines.Linenum        
                           no-lock no-error.
                           if not available utd-marking-lines
                           then do:
                              create utd-marking-lines.
                              assign
                                 utd-marking-lines.mark       = marking.mark
                                 utd-marking-lines.db-num     = utd-lines.db-num     
                                 utd-marking-lines.doc-id     = utd-lines.doc-id 
                                 utd-marking-lines.Linenum    = utd-lines.Linenum
                                 utd-marking-lines.doc-level  = 1
                                 
                              .
                             
                           end.
                        end.
                     end.
                     release utd-lines.   
                  end.
                  validate utd. /* необходимо для привязки марок */
                  
               end.
               else do:
                  PutMes("Ошибка получения данных из Диадок UniversalTransferDocumentWithHyphens").
                  return error no.
               end.
               
            end. /*упд*/
            else do:

               
               vContent = vDocumentChild:UniversalCorrectionDocument.
               if vContent ne ?
               then do:
                  getdesc(vContent).
                  getdesc(vContent:Seller).
                  getdesc(vContent:EventContent).
                  getdesc(vContent:EventContent:CorrectionBase).
                  
                    /* mSellerCol = mSellers:Seller. */
                  getOrganizationInfo(vContent:Seller,output utd.cli-inn,output utd.cli-kpp,utd.cli-FnsParticipantId, output vorgname, output vAddrOrg).
                  utd.cli-info = vorgname + " " + vAddrOrg.
                  
                  do:
                      vInvoiceTable = vContent:Table.
                      getdesc(vInvoiceTable).
                      
                      getdesc(vInvoiceTable:TotalsInc).
                      getdesc(vInvoiceTable:TotalsDec).
                      getdesc(vInvoiceTable:Items).
                      getdesc(vInvoiceTable:Items:item).
                      
                  
                      vItems = vInvoiceTable:Items:item.
                      do vi = 1 to vItems:Count: /* Документы потомки */
             /*            put stream File-stream  unformatted skip vi skip.*/
                         vExtendedInvoiceItem= vItems:GetItem(vi - 1).
                           /* if VIII = 1 then*/ 
                         getdesc(vExtendedInvoiceItem).
                         getdesc(vExtendedInvoiceItem:OriginalValues ).
                         getdesc(vExtendedInvoiceItem:CorrectedValues ).
                         getdesc(vExtendedInvoiceItem:AmountsInc ).
                         getdesc(vExtendedInvoiceItem:AmountsDec ).
                         getdesc(vExtendedInvoiceItem:AdditionalInfos ).
                         getdesc(vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo ).
                      /*   getdesc(vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo:getItem(0) ).
                         getdesc(vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo:getItem(1) ).
                         getdesc(vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo:getItem(2) ).
                         getdesc(vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo:getItem(3) ).
                        */ 
                         find first utd-lines where utd-lines.db-num     = utd.db-num
                                                and utd-lines.doc-id     = utd.doc-id
                                                and utd-lines.LineNum    = vi 
                         exclusive-lock no-error.
                         if not available  utd-lines
                         then do:
                            create utd-lines.
                            assign
                               utd-lines.db-num   = utd.db-num
                               utd-lines.doc-id   = utd.doc-id
                               utd-lines.Linenum  = vi
                            .
                            
                         end.
                         utd-lines.ProductCode = vExtendedInvoiceItem:Product.
/*                         utd-lines.UnitCode    = vExtendedInvoiceItem:UnitnAME.*/
                         vValues = vExtendedInvoiceItem:CorrectedValues.
                         utd-lines.Quantity    = vValues:Quantity.
                         utd-lines.Price       = vValues:Price.
                         utd-lines.TotalWithVatExcluded   = vValues:SubtotalWithVatExcluded.
             /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
                         utd-lines.TaxRate   =   if  vValues:TaxRate eq "без ндс" then -1 else decimal(trim(entry(1,vValues:TaxRate,"/"),"%")).
                         utd-lines.Vat       = vValues:Vat.
                         utd-lines.Total     = vValues:Subtotal.
/*                         utd-lines.Article   = vExtendedInvoiceItem:ItemVendorCode. /* ??? */*/
                         vValues = vExtendedInvoiceItem:OriginalValues.
                         utd-lines.Quantity    = utd-lines.Quantity - vValues:Quantity.
                         utd-lines.Price       = utd-lines.Price - vValues:Price.
                         utd-lines.Vat       = utd-lines.Vat - vValues:Vat.
                         utd-lines.Total     = utd-lines.Total  - vValues:Subtotal.
                         utd-lines.TotalWithVatExcluded   = utd-lines.TotalWithVatExcluded - vValues:SubtotalWithVatExcluded.
                         setAttrUtdLines(utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"Quantity_old",string( vValues:Quantity)).
                         setAttrUtdLines(utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"Price_old"   ,string( vValues:Price)).
                         setAttrUtdLines(utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"TotalWithVatExcluded", string( vValues:SubtotalWithVatExcluded)).
             /*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
                         setAttrUtdLines(utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"TaxRate_old", string(  if  vValues:TaxRate eq "без ндс" then -1 else decimal(trim(entry(1,vValues:TaxRate,"/"),"%")))).
                         setAttrUtdLines(utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"Vat_old"    , string( vValues:Vat)).
                         setAttrUtdLines(utd-lines.db-num,utd-lines.doc-id,utd-lines.Linenum,"Total_old",       string( vValues:Subtotal)).
                         
                         vunits = vExtendedInvoiceItem:AdditionalInfos:AdditionalInfo.
                         do vii = 1 to vunits:count:
                            vunit = vunits:GETITEM(vii - 1).
                            if     vunit:Id eq "cis"
                               or vunit:Id eq "cis_до"
                               or vunit:Id eq "sscc"
                               or vunit:Id eq "sscc_до"
                            then do:
                               
                               vtext = vunit:Value.
                               if vtext ne "-"
                               then do viii = 1 to num-entries(vtext," "):
                                  VValue = entry(viii,vtext," ").
                                  VValue = repSpecSimbforDm(VValue).
                                  find first marking where marking.mark eq VValue exclusive-lock no-error.
                                  if not available marking
                                  then do:
                                     create marking.
                                     marking.mark = vValue.
                                     marking.box-qnty = getQntyUTDByDM(marking.mark).
                                  end.
                               
                                 /* if marking.sts = objSrv:Env:marking:Sts:Mark:MarkError:KeyIntDB
                                  then
                                     marking.sts = ?. */
                                     define variable vsite as character no-undo.
                                     vsite = if     vunit:Id eq "cis" or vunit:Id eq "sscc" then "+" else "-".
                                  find first utd-marking-lines where utd-marking-lines.mark       = marking.mark
                                                                 and utd-marking-lines.db-num     = utd-lines.db-num     
                                                                 and utd-marking-lines.doc-id     = utd-lines.doc-id 
                                                                 and utd-marking-lines.Linenum    = utd-lines.Linenum        
                                  exclusive-lock no-error.
                                  if not available utd-marking-lines
                                  then do:
                                     create utd-marking-lines.
                                     assign
                                        utd-marking-lines.mark      = marking.mark
                                        utd-marking-lines.db-num    = utd-lines.db-num     
                                        utd-marking-lines.doc-id    = utd-lines.doc-id 
                                        utd-marking-lines.Linenum   = utd-lines.Linenum
                                        utd-marking-lines.site      = vsite
                                        utd-marking-lines.doc-level = 1        
                                     .
                                     release utd-marking-lines. 
                                  end.
                                  else do:
                                     if    (vsite eq "-"
                                        and utd-marking-lines.site eq "+")
                                        or
                                        (vsite eq "+"
                                        and utd-marking-lines.site eq "-")
                                     then 
                                        delete utd-marking-lines.
                                  end.
                                  
                               end.
                            end.
                         end.
                         release utd-lines.   
                      end.
                  end.
                  validate utd. /* необходимо для привязки марок */
               end.
               else do:
                  create tt-recid.
                  assign
                     tt-recid.orgid = vOrganizationid
                     tt-recid.docid = vDocumentid
                  .
                  PutMes("Error Ошибка получения данных из Диадок UniversalCorrectionDocument").
                  return error no.
               end.
            end.
            
         
            
         end.
         define variable vsetPAck as logical no-undo.
         define variable vcli-type as character no-undo.
         define variable vcli-code as integer no-undo.
         find first ext-classif where ext-classif.classif-name  eq {&extclass_code_id_diadok_client}
                                  and ext-classif.charkey_three eq utd.cli-FnsParticipantId
         no-lock no-error.
         if available ext-classif
         then do:
            assign 
               vcli-type = ext-classif.CharKey_One
               vcli-code = ext-classif.Key#_One
            .
            define variable vPack as character no-undo.
            if   iDocument:type eq "UniversalTransferDocument"
            then
               vPack = substitute("&1|&2|&3|&4",vcli-type,vcli-code,utd.DocumentNumber,utd.DocumentDate).
            else if iDocument:type eq "UniversalTransferDocumentRevision"
            then
               vPack = substitute("&1|&2|&3|&4",vcli-type,vcli-code,iDocument:OriginalDocumentNumber,date(iDocument:OriginalDocumentDate)).
            else
               vPack = substitute("&1|&2|&3|&4",vcli-type,vcli-code,iDocument:OriginalInvoiceNumber,date(iDocument:OriginalInvoiceDate)).
            if vPack ne utd.PackageId
            then 
               assign
                  vsetPAck      = yes
                  utd.PackageId = vPack
               . 
         end.
         if vNewUtd or vsetPAck then do:
            if utd.EDocType eq objSrv:Env:Utd:EDocType:UTD:KeyIntDB
            then do:
               if vNewUtd  then do:
                  GetLastUTDinPackbef(utd.db-num,utd.doc-id,volddb-num,volddoc-id).
                  find first old_utd where old_utd.db-num eq volddb-num
                                       and old_utd.doc-id eq volddoc-id
                     no-lock no-error.
                  for each utd-marking-lines where utd-marking-lines.db-num eq utd.db-num
                                               and utd-marking-lines.db-num eq utd.db-num
                  exclusive-lock:
                  
                     if available old_utd
                        and utd.db-num ne volddb-num
                        and utd.doc-id ne volddoc-id
                     then
                        find first buf_utd-marking-lines where buf_utd-marking-lines.mark       = marking.mark
                                                           and buf_utd-marking-lines.db-num     = old_utd.db-num     
                                                           and buf_utd-marking-lines.doc-id     = old_utd.doc-id
                        no-lock no-error.
                     utd-marking-lines.sts = if available buf_utd-marking-lines then buf_utd-marking-lines.sts else  objSrv:Env:marking:Sts:Mark:PendingVerification:KeyIntDB.
                  end.
                  SaturateAndCheckUTD( utd.db-num, utd.doc-id).
               end.
            end.
            else do:
               GetLastUTDinPack (utd.db-num,utd.doc-id,volddb-num,volddoc-id).
               find first old_utd where old_utd.db-num eq volddb-num
                                    and old_utd.doc-id eq volddoc-id
               no-lock no-error.
               if not available old_utd
                  or (   utd.db-num eq volddb-num
                     and utd.doc-id eq volddoc-id)
               then
                  AddUtdErr(utd.db-num,utd.doc-id,buffer utd:handle,"loadUtd","NoAvailDoc",string(utd.PackageId) + {&delim-par} + string(utd.db-num) + {&delim-par} + string(utd.doc-id)).
               else do:
                   assign
                       utd.obj-inn               = old_utd.obj-inn
                       utd.obj-kpp               = old_utd.obj-kpp
                       utd.obj-FnsParticipantId  = old_utd.obj-FnsParticipantId
                       utd.obj-info              = old_utd.obj-info
                       utd.parentDocumentExt     = old_utd.DocumentExt
                       utd.parentOrganizationExt = old_utd.OrganizationExt
                       utd.contract-code         = old_utd.contract-code
                   .
               end.
               SaturateAndCheckUTD( utd.db-num, utd.doc-id).
            end.
            
         end.   
         GetLastUTDinPack (utd.db-num,utd.doc-id,volddb-num,volddoc-id).
         find first old_utd where old_utd.db-num eq volddb-num
                              and old_utd.doc-id eq volddoc-id
         no-lock no-error.
         if available old_utd
         then 
            assign
               utd.parentDocumentExt     = old_utd.DocumentExt
               utd.parentOrganizationExt = old_utd.OrganizationExt
            .
        /* if utd.DocumentNumber eq "1103_3"
         then
            run gbl/inidebug.p.*/
         create tt-recid.
         assign
            tt-recid.orgid = vOrganizationid
            tt-recid.docid = vDocumentid
         .
         if utd.EDocType = objSrv:Env:Utd:EDocType:UCD:KeyIntDB
         then do:
            tt-recid.parent = utd.PackageId.
            tt-recid.stamp  = utd.Timestamp.
         end.
         release utd. /* необходимо для сохранения истории */
         unsubscribe "getNextseq". 
         PutMes(substitute("Документ &1 загружен." ,iDocument:DocumentNumber) ).
      end.
   end.
end.

&if "{1}" = "class"
&then
method public date pacetupdd
&else
function packetupdd returns date 
&endif
(iOrganization as component-handle, iDocument as component-handle):
   define variable VPack as character no-undo.
   define variable vorgid as character no-undo.
   define variable vdocid as character no-undo.
   define variable vstamp as datetime no-undo.
   define variable VPack2 as character no-undo.
   define variable vorgid2 as character no-undo.
   define variable vdocid2 as character no-undo.
   define variable vstamp2 as datetime no-undo.
   
   define variable VPackage as component-handle no-undo.
   define variable vi as integer no-undo.
   define variable vDocument as component-handle no-undo.
   define variable vDocuments as component-handle no-undo.
   
   
      VPack = iDocument:PackageId.
      vorgid = iDocument:OrganizationId.
      vdocid = iDocument:DocumentId.
      vstamp = iDocument:Timestamp.
  
      find first tt-pack where tt-pack.packid eq VPack
                           and tt-pack.stamp  eq vstamp
                           and tt-pack.orgid  eq vorgid
                           and tt-pack.docid  eq vdocid
      no-lock no-error.
      if not available tt-pack
      then do:
         create tt-pack.
         assign
            tt-pack.packid = VPack
            tt-pack.stamp  = vstamp
            tt-pack.orgid  = vorgid
            tt-pack.docid  = vdocid
         .
      end.
      getdesc(iDocument ).
      getdesc(iDocument:InitialDocumentIds ).
         
        /* VPackage = iDocument:GetDocumentPackage().
         getdesc(VPackage ).
         vDocuments = VPackage:Documents.*/
      vDocuments = iDocument:InitialDocumentIds.
         
      do vi= 1 to vDocuments:Count:
         vDocument = iOrganization:GetDocumentById(vDocuments:GetItem(vi - 1),false).
         getdesc(vDocument ).
         vorgid2 = vDocument:OrganizationId.
         vdocid2 = vDocument:DocumentId.
         vstamp2 = vDocument:Timestamp.
         find first tt-pack where tt-pack.packid eq VPack
                              and tt-pack.stamp  eq vstamp2
                              and tt-pack.orgid  eq vorgid2
                              and tt-pack.docid  eq vdocid2
         no-lock no-error.
         if not available tt-pack
         then do:
            create tt-pack.
            assign
               tt-pack.packid = VPack
               tt-pack.stamp  = vstamp2
               tt-pack.orgid  = vorgid2
               tt-pack.docid  = vdocid2
            .
         
         end.
      end.
end.
  

&if "{1}" = "class"
&then
method public date UpdateUTDInform
&else
function UpdateUTDInform returns date 
&endif
(ibeg-date as date,iend-date as date):
   define variable vOrganizationList as component-handle no-undo.
   define variable vOrganization as component-handle no-undo.
   define variable vDocumentsTask as component-handle no-undo.
   define variable vDocumentList  as component-handle no-undo.
   define variable vDocumentchildList  as component-handle no-undo.
   define variable vDocument       as component-handle no-undo.
   define variable vdatelast as date no-undo.
   
   define buffer ext-classif_obj for ext-classif.
   define buffer ext-classif_Cli  for ext-classif.
   
   define variable vi  as integer no-undo.
   define variable vii as integer no-undo.
   vdatelast = ibeg-date.
   vOrganizationList = mDiadocConnection:GetOrganizationList() no-error.
   if vOrganizationList eq ? then return error ?.
   vi = vOrganizationList:Count()no-error.
   if vi eq ?
   then
      return error ?.
   for each tt-recid:
      delete tt-recid.
   end.
   for each tt-pack:
      delete tt-pack.
   end.
   do vi = 1 to vOrganizationList:Count() :
   /*     Получение конкретной организации*/
      vOrganization = vOrganizationList:GetItem(vi - 1 ).
      getdesc(vOrganization).
   
      vDocumentsTask = vOrganization:GetDocumentsTask().
     /* for each ext-classif_Cli where ext-classif_Cli.classif-name  eq {&extclass_code_id_diadok_client}
      no-lock:
         find first clients 
                 where clients.obj-type   = ext-classif_cli.CharKey_One
                   and clients.obj-code   = ext-classif_cli.Key#_One
                   and not can-find(first ub.sysconf where ub.sysconf.host-code = clients.obj-code)
         no-lock no-error .
         if available  clients
         then do:
            for each ext-classif_obj where ext-classif_obj.classif-name  eq {&extclass_code_id_diadok_client}
            no-lock:
               find first clients 
                    where clients.obj-type   = ext-classif_obj.CharKey_One
                      and clients.obj-code   = ext-classif_obj.Key#_One
                      and can-find(first ub.sysconf where ub.sysconf.host-code = clients.obj-code)
               no-lock no-error .
               if available  clients
               then do:*/
       /*    Заполняем параметры отбора документов*/
                  vDocumentsTask:FromSendDate = ibeg-date  .
                  vDocumentsTask:ToSendDate   = iend-date.
                  
                              /* mDocumentsTask:Category     = "XmlTorg12.InboundWaitingForRecipientSignature".*/
                  for each tt-type, each tt-Class:
                    /* if tt-Class.id eq "Inbound"
                     then do:
                        vDocumentsTask:ToDepartmentId   = ext-classif_obj.charkey_three .
                        vDocumentsTask:FromDepartmentId = ext-classif_Cli.charkey_three .
                     end.
                     else if tt-Class.id eq "Outbound"
                     then do:
                        vDocumentsTask:ToDepartmentId   = ext-classif_Cli.charkey_three.
                        vDocumentsTask:FromDepartmentId = ext-classif_obj.charkey_three.
                     end.*/
                      vDocumentsTask:Category     = tt-type.id + "." + tt-Class.id.
                     PutMes(substitute("Загрузка документов за период с &2 по &3  &1Категория: &4 &5",
                                       /*"Загрузка документов за период с &2 по &3  &1Отправитель &4&1Получатель &5&1Категория &6.&7",*/
                                       {&new-line},    
                                       ibeg-date ,
                                       iend-date,
                                    /*   vDocumentsTask:FromDepartmentId,
                                       vDocumentsTask:ToDepartmentId,*/
                                       
                                       if tt-type .id eq "Any" then "" else tt-type.name,
                                       tt-Class.name)). 
                  /*       Получаем коллекцию документов*/
          
                      vDocumentList = vDocumentsTask:GetDocuments() no-error.
                      if vDocumentList ne ?
                      then do vii= 1 to vDocumentList:Count:
                          if chekStop() then return ?.
                         vDocument = vDocumentList:GetItem(vii - 1).
/*                         message vDocument:DocumentNumber                     view-as alert-box.*/
                         vdatelast = max(vdatelast,vDocument:DocumentDate) no-error.
                         packetupdd(vOrganization, vDocument).
                         
                      end.
                   end.
                   for each tt-pack :
                       if chekStop() then return ?.
                      if GetDocumforid (tt-pack.orgid, tt-pack.docid, output vDocument) eq "" /* Получим обновленный объект */
                      then
                         UpdateUTDInformOne(vDocument).    
                  end.
              /*  end.
             end.
          end.
      end.*/
   end.
   return vdatelast.
   /*pause 60.*/
end.

&if "{1}" = "class"
&then
method public void SendAnsver
(idb-num as integer ,
 idoc-id as integer, 
 iTypeAnswer as character,
 iComment as character   ):
&else
procedure SendAnsver:
   define input  parameter idb-num as integer no-undo.
   define input  parameter idoc-id as integer no-undo.
   define input  parameter iTypeAnswer as character no-undo.
   define input  parameter iComment as character no-undo. 
&endif

   define variable vSendcode as character no-undo.
   define variable vDocument as component-handle no-undo.
   define buffer utd for utd.
   if getdocum (idb-num, idoc-id, output vDocument ) eq ""
   then do:
      PutMes(substitute("Обработка запроса &3 по документу ДБ &1 ID &2",idb-num,idoc-id,iTypeAnswer)).
      /*if     logical(vDocument:AmendmentRequested)
         and iTypeAnswer eq "CorrectionRequest"
      then 
         iTypeAnswer = "RejectDocument".*/
      &if "{1}" = "class"
      &then
      send(vDocument,iTypeAnswer,iComment,output vSendcode) no-error.
      &else
      run send in this-procedure (vDocument,iTypeAnswer,iComment,output vSendcode) no-error.
      &endif
      if error-status:error
      then
         return error return-value.
      PutMes(substitute("Обработка запроса &3 по документу ДБ &1 ID &2 Завершина",idb-num,idoc-id,iTypeAnswer)).
      if     vSendcode ne ?
         and vSendcode ne ""
      then
         setattrutd (idb-num,idoc-id,"sendcode",vSendcode).
      if not mFlaftest
      then do:
         if getdocum (idb-num, idoc-id, output vDocument) eq "" /* Получим обновленный объект */
         then
            UpdateUTDInformOne(vDocument).
         if    iTypeAnswer eq "CorrectionRequest" /* запрошена коректировка */ 
            or iTypeAnswer eq "AcceptRevocation" /* подпись ануляции */
            or iTypeAnswer eq "RejectRevocation" /* отказано ануляции */
            or iTypeAnswer eq "RejectDocument" /* отказ по документу */
            or iTypeAnswer eq "AcceptDocument" /* подписать документ*/
            or iTypeAnswer eq "AcceptDocumentWithDisc"
            or iTypeAnswer eq "AcceptDocumentNotAccepted"
         then do:
            if getdocum (idb-num, idoc-id, output vDocument) eq "" /* Получим обновленный объект */
            then
               UpdateUTDInformOne(vDocument).
            if   not mFlaftest  
               
            then do trans:
               find first utd where utd.db-num eq idb-num
                                and utd.doc-id eq idoc-id
                                and utd.sts-edi < ObjSrv:Env:Utd:Sts:edi:StatFinesh /*только не по завершенным документам*/
               exclusive-lock no-error.
               if available utd
               then do :
                  
                  case iTypeAnswer:
                     when   "AcceptDocument"               then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRecipient:KeyIntDB.
                     when   "RejectDocument"               then utd.sts-edi = if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:AutoRejected:KeyIntDB
                                                                              then ObjSrv:Env:Utd:Sts:edi:sendAutoRejected:KeyIntDB
                                                                              else ObjSrv:Env:Utd:Sts:edi:sendRejected:KeyIntDB.
                     when   "CorrectionRequest"            then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendAdjustment:KeyIntDB.
   /*                  when   "RevocationRequest"          then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:CorrectionRequested:KeyIntDB.*/
                     when   "AcceptRevocation"             then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRevocation:KeyIntDB.
                     when   "RejectRevocation"             then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRevocation:KeyIntDB.
                     when   "AcceptDocumentWithDisc"       then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRecipient:KeyIntDB.
                     when   "AcceptDocumentNotAccepted"    then utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:sendRecipient:KeyIntDB.
                      
                  end case.
                  if iTypeAnswer eq "CorrectionRequest"
                  then do:
                     utd.sts = ObjSrv:Env:Utd:Sts:th:CorrectionRequested:KeyIntDB.
                     if     utd.sts-edi < ObjSrv:Env:Utd:Sts:edi:StatFinesh
                     then do:

                        &if "{1}" = "class"
                        &then
                        SendAnsver(idb-num,idoc-id,"AcceptDocumentWithDisc",iComment).
                        &else
                        run SendAnsver(idb-num,idoc-id,"AcceptDocumentWithDisc",iComment).
                        &endif
                     end.
                  end.
               end.
            end.
         end.
      end.
   end.
end.
&if "{1}" = "class"
&then
method public void SendReceiptsAsync
&else
function SendReceiptsAsync returns logical 
&endif
(idb-num as integer ,
 idoc-id as integer  ):
   define variable vDocument as component-handle no-undo.
   define buffer utd for utd.
   if getdocum (idb-num, idoc-id, output vDocument ) eq ""
   then do:
      PutMes(substitute("Обработка подписи ИОП по документу ДБ &1 ID &2",idb-num,idoc-id)).
      vDocument:SendReceiptsAsync().
      PutMes(substitute("Запущена асинхронная обработка ИОП по документу ДБ &1 ID &2",idb-num,idoc-id)).
      find first utd where utd.db-num eq idb-num 
                       and utd.doc-id eq idoc-id
      exclusive-lock no-error.
      if available utd
      then do:
         if getdocum (idb-num, idoc-id, output vDocument) eq "" /* Получим обновленный объект */
         then
            UpdateUTDInformOne(vDocument).
         utd.flagRI = yes.
         SaturateAndCheckUTD( utd.db-num, utd.doc-id).
      end.
      if getdocum (idb-num, idoc-id, output vDocument) eq "" /* Получим обновленный объект */
      then
         UpdateUTDInformOne(vDocument).
   end.

end.
&if "{1}" = "class"
&then
method public void SendResponse
(idb-num as integer ,
 idoc-id as integer,
 iAccept as logical,
 itestMod as logical):
&else
procedure  SendResponse :
   define input  parameter idb-num as integer no-undo.
   define input  parameter idoc-id as integer no-undo.
   define input  parameter iAccept as logical no-undo.
   define input  parameter itestMod as logical no-undo.
   
&endif
 
    define buffer utd for utd.
    define buffer buf_utd for utd.
    itestMod = not itestMod.
    
    define variable vreturn as logical no-undo.
    find first utd where utd.db-num eq idb-num
                     and utd.doc-id eq idoc-id
    no-lock no-error.
    if available utd
    then do:
       if utd.EDocType              = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB
       then do:
          if     iAccept
             and utd.sts-edi     ne objSrv:Env:Utd:sts:edi:WithRecipientSignature:KeyIntDB
          then do:
             vreturn = yes.
             if itestMod
             then do:
                for each buf_utd where buf_utd.PackageId eq utd.PackageId
                                   and buf_utd.EDocType  eq objSrv:Env:Utd:EDocType:ucd:KeyIntDB
                                   and buf_utd.Timestamp     <= utd.Timestamp
                                   and buf_utd.sts-edi     ne objSrv:Env:Utd:sts:edi:WithRecipientSignature:KeyIntDB
                no-lock :
                   &if "{1}" = "class"
                   &then
                   SendAnsver(buf_utd.db-num,buf_utd.doc-id,"AcceptDocument","")no-error.
                   &else
                   run SendAnsver in this-procedure (buf_utd.db-num,buf_utd.doc-id,"AcceptDocument","")no-error.
                   &endif
                   if error-status:error then return error return-value.
   /*                */
                end.
                 
             end.
          end.
       end.
       else if utd.EDocType              = objSrv:Env:Utd:EDocType:returns:KeyIntDB
       then do:
          if iAccept
          then do:
             vreturn = yes.
             if itestMod
             then do:
                find first buf_utd where buf_utd.OrganizationExt eq utd.parentOrganizationExt
                                     and buf_utd.DocumentExt     eq utd.parentDocumentExt
                no-lock no-error.
                &if "{1}" = "class"
                &then
                SendAnsver(buf_utd.db-num,buf_utd.doc-id,"RejectDocument",GetErrForUtd(utd.db-num,utd.doc-id,"return"))no-error.
                &else
                run SendAnsver in this-procedure (buf_utd.db-num,buf_utd.doc-id,"CorrectionRequest",GetErrForUtd(utd.db-num,utd.doc-id,"return"))no-error.
                &endif
                if error-status:error then return error return-value.
/*                */
                do trans :
                   find first utd where utd.db-num eq idb-num
                                    and utd.doc-id eq idoc-id
                   exclusive-lock no-error.
                   utd.sts-edi = ObjSrv:Env:Utd:Sts:edi:WithRecipientSignature:KeyIntDB.
                end.
             end.
          end.
       end.
       else if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:HaveToCreateReceipt:KeyIntDB /*"Требует подписи ИОП"*/
       then do:
          if iAccept
          then do:
             vreturn = yes.
             if itestMod
             then
                SendReceiptsAsync(idb-num,idoc-id).
          end.
          /*else
             vreturn = no.*/
       end.
       else if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:Verification:KeyIntDB /*проверка"*/
       then do:
          if not iAccept
          then do:
             vreturn = yes.
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"RejectDocument","") no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"RejectDocument","") no-error.
                &endif
                if error-status:error then return error return-value.
             end.
          end.
          /*else
             vreturn = no.*/
       end.
       else if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:RequestsMyRevocation:KeyIntDB /*"Получено предложение об аннулировании документа"*/
       then do:
          vreturn = yes.
          if iAccept
          then do:
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"AcceptRevocation","")no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"AcceptRevocation","") no-error.
                &endif
                if error-status:error then return error return-value.
             end.
          end.
          else do:
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"RejectRevocation","")no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"RejectRevocation","")no-error.
                &endif
                if error-status:error then return error return-value.
             end.
          end.
       end.
       else if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:WaitingForRecipientSignature:KeyIntDB /*"Ожидается ответное действие получателя"*/
       then do:
          
          if iAccept
          then do:
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"AcceptDocument","")no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"AcceptDocument","")no-error.
                &endif
                if error-status:error then return error return-value.
             end.
          end.
          else do:
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"RejectDocument","")no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"RejectDocument","") no-error.
                &endif
                if error-status:error then return error return-value.
             end.
          end.
       end.
       else if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:AutoRejected:KeyIntDB /*"Подписать отказ"*/
       then do:
          if iAccept
          then do:
             vreturn = yes.
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"RejectDocument","")no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"RejectDocument","") no-error.
                &endif
                if error-status:error then return error return-value.
             end.
          end.
       end.
       else if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:SignatureAdjustment:KeyIntDB /*"Подписать коректировку"*/
       then do:
          if iAccept
          then do:
             vreturn = yes.
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"CorrectionRequest","")no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"CorrectionRequest","")no-error.
                &endif
                if error-status:error then return error return-value.
             end.   
          end.
       end.
       else if utd.sts-edi eq  ObjSrv:Env:Utd:Sts:edi:SignatureNotAccepted:KeyIntDB /*"Подписать с отказом"*/
       then do:
          if iAccept
          then do:
             vreturn = yes.
             if itestMod
             then do:
                &if "{1}" = "class"
                &then
                SendAnsver(idb-num,idoc-id,"AcceptDocumentNotAccepted","")no-error.
                &else
                run SendAnsver in this-procedure (idb-num,idoc-id,"AcceptDocumentNotAccepted","")no-error.
                &endif
                if error-status:error then return error return-value.
             end.   
          end.
       end.

    end.
    return string(vreturn).
end.

&if "{1}" = "class"
&then
method public void updOneUTD
&else
function updOneUTD returns logical 
&endif
(idb-num as integer ,
 idoc-id as integer  ):
   define variable vDocument as component-handle no-undo.
   define buffer utd for utd.
   for each tt-recid:
      delete tt-recid.
   end.
   if getdocum (idb-num, idoc-id, output vDocument) eq "" /* Получим обновленный объект */
   then
      UpdateUTDInformOne(vDocument).
   
end.

&if "{1}" = "class"
&then
method public void getNewUpd
&else
function getNewUpd return character
&endif 
():
   define variable VLastDate as date no-undo init ?.
   define variable vOrganization as component-handle no-undo.
   define variable vDocument     as component-handle no-undo.
   define buffer utd for utd.
   VLastDate = date( getextAttr({&attr-esys-diadoc-lastload})) no-error.
   
   for each tt-recid:
      delete tt-recid.
   end.
   if chekStop() then return "Остановка пользователем".
   VLastDate = UpdateUTDInform(if VLastDate eq ? then today - 365 else VLastDate - 3,today + 1 ).
   if chekStop() then return "Остановка пользователем".
   if VLastDate ne ?
   then
      setextAttr({&attr-esys-diadoc-lastload},string(VLastDate)).
   block-rec:
   for each tt-recid break by tt-recid.parent descending by tt-recid.stamp descending :
      if  tt-recid.parent eq ""
      then next  block-rec.
      if first-of (tt-recid.parent)
      then do:
         for each utd where utd.PackageId eq tt-recid.parent
         no-lock break by utd.PackageId descending by utd.Timestamp descending :
            if chekStop() then return "Остановка пользователем".
            if utd.EDocType = objSrv:Env:Utd:EDocType:UCD:KeyIntDB
            then do:
               subscribe "getNextseq" anywhere run-procedure "MySeqForUtd".
               MySeqUtd = ?.
          
               CrEdoc(utd.PackageId,utd.Timestamp).
               unsubscribe "getNextseq".
               next block-rec.
            end.
         end.
      end.
   end.
   PutMes("Обновление информации по ранее загруженным документам ").
   define variable vobj as character no-undo.
   vobj = getExtAttr({&attr-esys-host-code}).
   if vobj ne "0"
   then
       for each utd where utd.sts-edi < ObjSrv:Env:Utd:Sts:edi:StatFinesh  
                      and utd.host-code eq int(vobj)
       no-lock break by utd.OrganizationExt:
          if chekStop() then return "Остановка пользователем".
          find first tt-recid where tt-recid.orgid = utd.OrganizationExt
                                and tt-recid.docid = utd.DocumentExt
                 no-error.
          if     not available tt-recid
             and getdocum (utd.db-num, utd.doc-id, output vDocument) eq "" /* Получим обновленный объект */
          then do:
             UpdateUTDInformOne(vDocument).
             release object vDocument no-error.
          end.
       end.
   
   vobj = getExtAttr({&attr-esys-obj}).
   if vobj ne ""
   then
       for each utd where utd.sts-edi < ObjSrv:Env:Utd:Sts:edi:StatFinesh  
                      and utd.obj-type + string(utd.obj-code) eq vobj
       no-lock break by utd.OrganizationExt:
          if chekStop() then return "Остановка пользователем".
          find first tt-recid where tt-recid.orgid = utd.OrganizationExt
                                and tt-recid.docid = utd.DocumentExt
                 no-error.
          if     not available tt-recid
             and getdocum (utd.db-num, utd.doc-id, output vDocument) eq "" /* Получим обновленный объект */
          then do:
             UpdateUTDInformOne(vDocument).
             release object vDocument no-error.
          end.
       end.
end.

&if "{1}" = "class"
&then
method public void CRnewDocum
&else
function CRnewDocum return character
&endif 
(
 iDocument as component-handle):

/*(Organization, Counteragent)*/
define variable vOrganization as component-handle no-undo.
define variable vSendTask as component-handle no-undo.
define variable vDocumentToSend as component-handle no-undo.
    vOrganization = mDiadocConnection:GetOrganizationById(iDocument:Organizationid) no-error.
    if vOrganization ne ?
    then do:
    /* Создание задания на отправку */
       vSendTask = vOrganization:CreatePackageSendTask2().
       getdesc(vSendTask).
/*       vSendTask:CounterAgentId = iDocument:Counteragent:Id.*/
   
       /* Добавление документа для заполнения контента средствами компоненты */
       /* Предполагаем, что процедура заполнения контента уже существует */
       vDocumentToSend = vSendTask:AddDocument("UniversalTransferDocument", "СЧФДОП", "utd820_05_01_01").
       vDocumentToSend = vSendTask:AddDocument("Nonformalized", "default", "v1").
       message 
       view-as alert-box.
       getdesc(vDocumentToSend).
       vDocumentToSend:Comment = "Это УПД с заполнением контента средствами компоненты".
/*       ЗаполнитьДинамическийКонтентДокумента(First_DocumentToSend.Content);

    // Добавление документа УПД с контентом, взятым из файла
    Second_DocumentToSend = SendTask.AddDocumentFromFile("UniversalTransferDocument", "СЧФДОП", "utd820_05_01_01", "С:\\Moй УПД.xml");
    Second_DocumentToSend.Comment = "Это УПД с контентом, загруженным из файла";

    // Добавление неформализованного документа
    Third_DocumentToSend = SendTask.AddDocumentFromFile("Nonformalized", "default", "v1", "С:\\Документ.pdf");
    Third_DocumentToSend.Comment = "Это неформализованный документ";
    MetaDataItem = Third_DocumentToSend.AddMetadata();
    MetaDataItem.Key   = "FileName";
    MetaDataItem.Value = "Имя Файла Для Передачи.xml";

    ОтправленныеДокументы = SendTask.Send();

КонецПроцедуры
*/
   end.
end.

&if "{1}" = "class"
&then
method public void sendauto ():
&else
procedure  SendAuto:
&endif

 define variable vOrganization as component-handle no-undo.
 define variable vOrganizationList as component-handle no-undo.
 define variable vi as integer no-undo.
   if mDiadocConnection eq ?
   then do:
      message "По данному сертификату не удалось подключиться к Диадок" 
      view-as alert-box.
   end.
   else do:
      for each tt-recid:
         delete tt-recid.
      end.
      vOrganizationList = mDiadocConnection:GetOrganizationList() no-error.
      if vOrganizationList eq ? then return error ?.
      vi = vOrganizationList:Count()no-error.
      if vi eq ?
      then
         return error ?.
   
      do vi = 1 to vOrganizationList:Count() :
   /*     Получение конкретной организации*/
         vOrganization = vOrganizationList:GetItem(vi - 1 ).
         define variable vorgid as character no-undo.
         vorgid = vOrganization:id.
         for each utd where utd.sts-edi   eq ObjSrv:Env:Utd:Sts:edi:HaveToCreateReceipt:KeyIntDB
                        and utd.host-code eq v-cntxt-host-code-obj
                        and utd.OrganizationExt eq vorgid
         no-lock:
            SendReceiptsAsync(utd.db-num,utd.doc-id).
         end.
         /*
         for each utd where utd.sts-edi   eq ObjSrv:Env:Utd:Sts:edi:AutoRejected:KeyIntDB
                        and utd.host-code eq v-cntxt-host-code-obj
                        and utd.OrganizationExt eq vorgid
         no-lock:
            run SendResponse in this-procedure (utd.db-num,utd.doc-id,yes,no).
         end.
         */
     /*    for each utd where utd.sts-edi   eq ObjSrv:Env:Utd:Sts:edi:SignatureNotAccepted:KeyIntDB
                        and utd.host-code eq v-cntxt-host-code-obj
                        and utd.OrganizationExt eq vorgid
         no-lock:
            run SendResponse in this-procedure (utd.db-num,utd.doc-id,yes,no).
         end.
     */
         for each utd where utd.sts-edi   eq ObjSrv:Env:Utd:Sts:edi:HaveToCreateReceipt:KeyIntDB
                        and utd.host-code eq v-cntxt-host-code-obj
                        and utd.OrganizationExt eq vorgid
         no-lock:
            updOneUTD(utd.db-num,utd.doc-id).
         end.
      end.
   end.
end.

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