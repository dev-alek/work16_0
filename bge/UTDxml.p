
/*------------------------------------------------------------------------
    File        : UTDxml.p

    Description : Выгрузка УПД в XML

    Author(s)   : Shklyar Elena
    Created     : Mon Dec 10 12:01:39 MSK 2012
    Notes       :
        
    $Revision$
    $Author$
    $Date$
    $Workfile$
    $Archive$
    
  ----------------------------------------------------------------------*/
/*                                                                                                 */
define variable vss-revision as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Выгрузка УПД в XML".

/* ********************  Preprocessor Definitions  ******************** */

/* ***************************  Includes  ************************** */

{cmp/vssrevis.i}

/* ***************************  Definitions  ************************** */

/* Input parameters */
define input  parameter parparentproc as handle no-undo.
/*define input parameter iDiadocApi as component-handle no-undo.*/
define input parameter iDiadocConnection as component-handle no-undo.
define input  parameter iORGGuid as character no-undo.
define input  parameter iContGuid as character no-undo.
define input  parameter iTypeUTD as character no-undo. /* "СЧФДОП", "Доп" */
define input parameter i-db-num as integer no-undo.
define input parameter p-doc-id as integer no-undo.
function  getdesc returns logical
(input iObj as component-handle) in source-procedure.
{cmp/str-glbl.i}
{cmp/trg-def.i}
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ utl/gtin.i }

/* Input таблица с объектами */

/* Buffers */
define buffer buf_utd               for ub.utd .
define buffer buf_utd-file          for ub.utd-attr .
define buffer buf_utd-lines         for ub.utd-lines .
define buffer buf_utd-lines-attr    for ub.utd-lines-attr .
define buffer buf_utd-marking-lines for ub.utd-marking-lines .
define buffer buf_code              for ub.Code .
define buffer buf_marking           for ub.marking .
define buffer buf_marking-lines     for ub.marking-lines .
define buffer buf_firm              for ub.firm .
define buffer buf_shop              for ub.shop .
define buffer buf_clients           for ub.clients . 
define buffer buf_goods             for ub.goods .
/* Temp-Tables */


/* Variables */
define variable filename_    as character no-undo . /* Имя xml файла */
define variable logname      as character no-undo .
define variable v-nds        as decimal   no-undo .
define variable v-qnty-scan  as decimal   no-undo .
define variable hSAXWriter   as handle    no-undo. /* для создания XML */
define variable v-doc-level  as integer   no-undo .
define variable v-total-min  as decimal   no-undo . /*Сумма уменьшения без НДС*/
define variable v-vat-min    as decimal   no-undo . /*Сумма уменьшения НДС*/
define variable v-sum-after  as decimal   no-undo . /*Сумма после*/
define variable v-total-max  as decimal   no-undo . /*Сумма увеличения без НДС*/
define variable v-vat-max    as decimal   no-undo . /*Сумма увеличения НДС*/

define variable vOrganization as component-handle no-undo.
define variable vUserperm      as component-handle no-undo. 
define variable vUser          as component-handle no-undo. 
define variable vCounteragent as component-handle no-undo.
define variable vCounteragentOrg as component-handle no-undo.   
/* ************************  Function Implementations ***************** */


logname = session:temp-directory + "UPD_" + string(p-doc-id) + "_log.txt".
filename_ = "UPD_" + string(p-doc-id) + ".xml" .

/* Для лога */
/*&scop display-message run write-log-and-file in p_log-handle ~*/
/*    (input 1, input logname, input 1, input ~{&my-message~})  */

/* ***************************  Main Block  *************************** */

/*&scop my-message substitute("Начало выгрузки УПД в XML")*/
/*{&display-message}.                                     */

find first buf_utd no-lock where buf_utd.db-num eq i-db-num and buf_utd.doc-id = p-doc-id no-error .
if not available (buf_utd) then return error .
vOrganization = iDiadocConnection:GetOrganizationById(iORGGuid) no-error.
if vOrganization eq ?
then do:
   message "нет доступа к организации"
   view-as alert-box.
   return.
end.
vCounteragent = vOrganization:GetCounteragentById(iContGuid).
/* **********************  Internal Procedures  *********************** */

/*Магазин*/
find first buf_clients no-lock where buf_clients.obj-code = v-cntxt-obj-code and
   buf_clients.obj-type = v-cntxt-obj-type no-error .

/* Начнём запись в xml */
create sax-writer hSAXWriter.
hSAXWriter:set-output-destination("file":U, filename_ ).
hSAXWriter:formatted = true.
hSAXWriter:encoding = "windows-1251".

hSAXWriter:start-document().

/* 1. Общие данные */


hSAXWriter:start-element ("Файл":U).
define variable mFileName as character no-undo.
block-mark:
for each buf_utd-marking-lines  where 
                     buf_utd-marking-lines.db-num = buf_utd.db-num and
                     buf_utd-marking-lines.doc-id = buf_utd.doc-id
no-lock:
    if ismark(buf_utd-marking-lines.mark)
    then
       leave block-mark.
end.
mFileName = substitute ("ON_NSCHFDOPPR&1_&2_&3_&4&5&6_3440B5E2-B3EA-1EEA-9EE0-52DE60B58235"
                        , if available buf_utd-marking-lines then  "MARK" else ""
                        , vCounteragent:FnsParticipantId 
                        , vOrganization:FnsParticipantId
                        ,STRING(YEAR(TODAY),"9999")
                        ,STRING(monTH(TODAY),"99")
                        ,STRING(DAY(TODAY),"99")
                        ).
          
hSAXWriter:insert-attribute ("ИдФайл", mFileName) no-error.
hSAXWriter:insert-attribute ("ВерсФорм", "5.01") no-error.
hSAXWriter:insert-attribute ("ВерсПрог", "Diadoc 1.0") no-error.
do:
   hSAXWriter:start-element("СвУчДокОбор":U) no-error.
   
   hSAXWriter:insert-attribute ("ИдОтпр":U, string(vOrganization:FnsParticipantId)) no-error.
   hSAXWriter:insert-attribute ("ИдПол":U, string(vCounteragent:FnsParticipantId)) no-error.
   do:
      /*Данные контура, вшиты напрямую - не знаю откуда брать*/
      hSAXWriter:write-empty-element("СвОЭДОтпр":U) no-error.
      hSAXWriter:insert-attribute("ИННЮЛ":U, "6663003127") no-error.
      hSAXWriter:insert-attribute("ИдЭДО":U, "2BM") no-error.
      hSAXWriter:insert-attribute("НаимОрг":U, "АО ПФ СКБ Контур") no-error.
   end.   
   hSAXWriter:end-element("СвУчДокОбор":U) no-error.
   /*Данные документа*/
   hSAXWriter:start-element("Документ":U) no-error.
   hSAXWriter:insert-attribute ("КНД":U, "1115131") no-error. /*обязательное число*/
   hSAXWriter:insert-attribute ("Функция":U, iTypeUTD) no-error. /*СЧФДОП или СЧФ - не понятно как определять*/
   hSAXWriter:insert-attribute ("ПоФактХЖ":U, "Документ об отгрузке товаров (выполнении работ), передаче имущественных прав (документ об оказании услуг)") no-error. /*Наименование документа*/
   hSAXWriter:insert-attribute ("НаимДокОпр":U, "Счет-фактура и документ об отгрузке товаров (выполнении работ), передаче имущественных прав (документ об оказании услуг)") no-error.
   hSAXWriter:insert-attribute ("ДатаИнфПр":U, string(today,"99.99.9999")) no-error.
   hSAXWriter:insert-attribute ("ВремИнфПр":U, replace(string(time,"HH:MM:SS"),":",".")) no-error.
   hSAXWriter:insert-attribute ("НаимЭконСубСост":U, buf_clients.obj-name) no-error. /*Наименование экономического субъекта-составителя - скорее всего наша фирма*/
   do:
            
      hSAXWriter:start-element("СвСчФакт":U) no-error.
      hSAXWriter:insert-attribute ("НомерСчФ":U, buf_utd.DocumentNumber) no-error.
      hSAXWriter:insert-attribute ("ДатаСчФ":U, string(buf_utd.DocumentDate,"99.99.9999")) no-error.
      hSAXWriter:insert-attribute ("КодОКВ":U, "643") no-error.
      do:
         hSAXWriter:write-empty-element("ИспрСчФ":U) no-error.
         hSAXWriter:insert-attribute("ДефНомИспрСчФ":U, "-") no-error.
         hSAXWriter:insert-attribute("ДефДатаИспрСчФ":U, "-") no-error.
         /*Наша компания*/
         /*Не ясно откуда брать сведения этих организаций*/
         hSAXWriter:start-element("СвПрод":U) no-error.
         do:
            /*      hSAXWriter:insert-attribute ("ОКПО":U, buf_utd.cli-FnsParticipantId) no-error.*/
            
            hSAXWriter:start-element("ИдСв":U) no-error.
            
            hSAXWriter:write-empty-element("СвЮЛУч":U) no-error.
            hSAXWriter:insert-attribute("НаимОрг":U, string(vOrganization:name)) no-error.
            hSAXWriter:insert-attribute("ИННЮЛ":U, string(vOrganization:inn)) no-error.
            hSAXWriter:insert-attribute("КПП":U, string(vOrganization:kpp)) no-error.
            hSAXWriter:end-element("ИдСв":U) no-error.
            
            hSAXWriter:start-element("Адрес":U) no-error.
            do:
               vCounteragentOrg = vOrganization:GetCounteragentById(iContGuid).     
               
               getdesc(vCounteragentOrg).
               getdesc(vCounteragentOrg:Address).
               
               
               hSAXWriter:write-empty-element("АдрРФ":U) no-error.
               if vCounteragentOrg:Address:RegionCode ne ""
               then
                  hSAXWriter:insert-attribute("КодРегион":U, string(vCounteragentOrg:Address:RegionCode)) no-error.
               if vCounteragentOrg:Address:Territory ne ""
               then
                  hSAXWriter:insert-attribute("Район":U,     string(vCounteragentOrg:Address:Territory )) no-error.
               if vCounteragentOrg:Address:City ne ""
               then
                  hSAXWriter:insert-attribute("Город":U,     string(vCounteragentOrg:Address:City      )) no-error.
               if vCounteragentOrg:Address:Street ne ""
               then
                  hSAXWriter:insert-attribute("Улица":U,     string(vCounteragentOrg:Address:Street    )) no-error.
               if vCounteragentOrg:Address:Building ne ""
               then
                  hSAXWriter:insert-attribute("Дом":U,       string(vCounteragentOrg:Address:Building )) no-error.
               if vCounteragentOrg:Address:Block ne ""
               then
                  hSAXWriter:insert-attribute("Корпус":U,    string(vCounteragentOrg:Address:Block     )) no-error.
               release object vCounteragentorg.
            end.
            hSAXWriter:end-element("Адрес":U) no-error.
            
            /*      hSAXWriter:start-element("БанкРекв":U) no-error.                                                 */
            /*      hSAXWriter:insert-attribute ("НомерСчета":U, buf_utd.cli-FnsParticipantId) no-error.             */
            /*                                                                                                       */
            /*      hSAXWriter:write-empty-element("СвБанк":U) no-error.                                             */
            /*      hSAXWriter:insert-attribute("НаимБанк":U, string(buf_utd.cli-inn)) no-error.                     */
            /*      hSAXWriter:insert-attribute("БИК":U, string(entry(1,buf_utd.cli-FnsParticipantId,"-"))) no-error.*/
            /*                                                                                                       */
            /*      hSAXWriter:end-element("БанкРекв":U) no-error.                                                   */
         end.
         hSAXWriter:end-element("СвПрод":U) no-error.
         
         /*Компания покупателя*/
         hSAXWriter:start-element("СвПокуп":U) no-error.
         do:
            /*      hSAXWriter:insert-attribute ("ОКПО":U, buf_utd.cli-FnsParticipantId) no-error.*/
            
            hSAXWriter:start-element("ИдСв":U) no-error.
            do:
               hSAXWriter:write-empty-element("СвЮЛУч":U) no-error.
               hSAXWriter:insert-attribute("НаимОрг":U, string(vCounteragent:name)) no-error.
               hSAXWriter:insert-attribute("ИННЮЛ":U,   string(vCounteragent:inn )) no-error.
               hSAXWriter:insert-attribute("КПП":U,     string(vCounteragent:kpp )) no-error.
            end.
            hSAXWriter:end-element("ИдСв":U) no-error.
            
            hSAXWriter:start-element("Адрес":U) no-error.
            do:
               getdesc(vCounteragent).
               getdesc(vCounteragent:Address).
               hSAXWriter:write-empty-element("АдрРФ":U) no-error.
               if vCounteragent:Address:RegionCode ne ?
               then
                  hSAXWriter:insert-attribute("КодРегион":U, string(vCounteragent:Address:RegionCode)) no-error.
               if vCounteragent:Address:Territory ne ""
               then
                  hSAXWriter:insert-attribute("Район":U,     string(vCounteragent:Address:Territory )) no-error.
               if vCounteragent:Address:City ne ""
               then
                  hSAXWriter:insert-attribute("Город":U,     string(vCounteragent:Address:City      )) no-error.
               if vCounteragent:Address:Street ne ""
               then
                  hSAXWriter:insert-attribute("Улица":U,     string(vCounteragent:Address:Street    )) no-error.
               if vCounteragent:Address:Building ne ""
               then
                  hSAXWriter:insert-attribute("Дом":U,       string(vCounteragent:Address:Building  )) no-error.
               if vCounteragent:Address:Block ne ""
               then
                  hSAXWriter:insert-attribute("Корпус":U,    string(vCounteragent:Address:Block     )) no-error.
            end.
            hSAXWriter:end-element("Адрес":U) no-error.
            
            /*      hSAXWriter:start-element("БанкРекв":U) no-error.                                                 */
            /*      hSAXWriter:insert-attribute ("НомерСчета":U, buf_utd.cli-FnsParticipantId) no-error.             */
            /*                                                                                                       */
            /*      hSAXWriter:write-empty-element("СвБанк":U) no-error.                                             */
            /*      hSAXWriter:insert-attribute("НаимБанк":U, string(buf_utd.cli-inn)) no-error.                     */
            /*      hSAXWriter:insert-attribute("БИК":U, string(entry(1,buf_utd.cli-FnsParticipantId,"-"))) no-error.*/
            /*                                                                                                       */
            /*      hSAXWriter:end-element("БанкРекв":U) no-error.                                                   */
         end.
         hSAXWriter:end-element("СвПокуп":U) no-error.
         
         /*hSAXWriter:write-empty-element("ДопСвФХЖ1":U) no-error.*/
         /*hSAXWriter:insert-attribute("НаимОКВ":U, "Российский рубль") no-error.*/
         
         hSAXWriter:start-element("ИнфПолФХЖ1":U) no-error.
         do:
            hSAXWriter:write-empty-element("ТекстИнф":U) no-error.
            hSAXWriter:insert-attribute("Идентиф":U, "id_pack_th") no-error.
            hSAXWriter:insert-attribute("Значен":U, buf_utd.PackageId) no-error.
      
            hSAXWriter:write-empty-element("ТекстИнф":U) no-error.
            hSAXWriter:insert-attribute("Идентиф":U, "id_doc_th") no-error.
            hSAXWriter:insert-attribute("Значен":U, substitute ("&1_&2",buf_utd.db-num,buf_utd.doc-id)) no-error.
               
            /*      hSAXWriter:write-empty-element("ТекстИнф":U) no-error.            */
            /*      hSAXWriter:insert-attribute("Идентиф":U, "дата_заказа" no-error.  */
            /*      hSAXWriter:insert-attribute("Значен":U, string() no-error.        */
            /*                                                                        */
            /*      hSAXWriter:write-empty-element("ТекстИнф":U) no-error.            */
            /*      hSAXWriter:insert-attribute("Идентиф":U, "дата_поставки" no-error.*/
            /*      hSAXWriter:insert-attribute("Значен":U, string() no-error.        */
            
            /*      hSAXWriter:write-empty-element("ТекстИнф":U) no-error.              */
            /*      hSAXWriter:insert-attribute("Идентиф":U, "грузополучатель" no-error.*/
            /*      hSAXWriter:insert-attribute("Значен":U, string() no-error.          */
            /*                                                                          */
            /*      hSAXWriter:write-empty-element("ТекстИнф":U) no-error.              */
            /*      hSAXWriter:insert-attribute("Идентиф":U, "отправитель" no-error.    */
            /*      hSAXWriter:insert-attribute("Значен":U, string() no-error.          */
            /*                                                                          */
            /*      hSAXWriter:write-empty-element("ТекстИнф":U) no-error.              */
            /*      hSAXWriter:insert-attribute("Идентиф":U, "получатель" no-error.     */
            /*      hSAXWriter:insert-attribute("Значен":U, string() no-error.          */
            /*                                                                          */
            /*      hSAXWriter:write-empty-element("ТекстИнф":U) no-error.              */
            /*      hSAXWriter:insert-attribute("Идентиф":U, "номер_накладной" no-error.*/
            /*      hSAXWriter:insert-attribute("Значен":U, string() no-error.          */
            /*                                                                          */
            /*      hSAXWriter:write-empty-element("ТекстИнф":U) no-error.              */
            /*      hSAXWriter:insert-attribute("Идентиф":U, "дата_накладной" no-error. */
            /*      hSAXWriter:insert-attribute("Значен":U, string() no-error.          */
         end.
         hSAXWriter:end-element("ИнфПолФХЖ1":U) no-error.
      end.
      hSAXWriter:end-element("СвСчФакт":U) no-error.
      
      hSAXWriter:start-element("ТаблСчФакт":U) no-error.
      do:
         /*run gbl/inidebug.p.*/
         for each buf_utd-lines no-lock where buf_utd-lines.db-num = buf_utd.db-num and
            buf_utd-lines.doc-id = buf_utd.doc-id:
               
            /*Линии товаров*/
            hSAXWriter:start-element("СведТов":U) no-error.
            hSAXWriter:insert-attribute ("НомСтр":U, string(buf_utd-lines.LineNum)) no-error.
            hSAXWriter:insert-attribute ("НаимТов":U, string(buf_utd-lines.ProductCode)) no-error.
            
            /*   hSAXWriter:insert-attribute ("ПорНомТовВСЧФ":U, string(buf_utd-lines.LineNum)) no-error.*/
            find first units no-lock where units.unit-name = buf_utd-lines.UnitCode no-error .
            if available (units)
               and  units.OKEI ne 0
            then
               hSAXWriter:insert-attribute ("ОКЕИ_Тов":U, string(units.OKEI,"999")) no-error.
            else
              hSAXWriter:insert-attribute ("ДефОКЕИ_Тов":U,  "-") no-error.
            hSAXWriter:insert-attribute ("КолТов":U, string (buf_utd-lines.Quantity)) no-error.
            hSAXWriter:insert-attribute ("ЦенаТов":U, trim(string(buf_utd-lines.Price,">>>>>>>>>>>>9.99"))) no-error.
            hSAXWriter:insert-attribute ("СтТовБезНДС":U, trim(string(buf_utd-lines.Total,">>>>>>>>>>>>9.99"))) no-error.
            hSAXWriter:insert-attribute ("НалСт":U, string(buf_utd-lines.TaxRate) + "%") no-error.
            hSAXWriter:insert-attribute ("СтТовУчНал":U, trim(string(buf_utd-lines.TotalWithVatExcluded,">>>>>>>>>>>>9.99"))) no-error.
            do:
               hSAXWriter:start-element("Акциз":U) no-error.
               do:
                  hSAXWriter:start-element("БезАкциз") no-error. /*не знаю откуда брать*/
                  hsaxwriter:write-characters("без акциза") no-error.
                  hSAXWriter:end-element("БезАкциз":U) no-error.
               end.
               hSAXWriter:end-element("Акциз":U) no-error.
            
               hSAXWriter:start-element("СумНал":U) no-error.
               do:
                  hSAXWriter:start-element("СумНал":U) no-error.
                  hSAXWriter:write-characters (trim(string(buf_utd-lines.Vat,">>>>>>>>>>>>9.99"))) no-error .
                  hSAXWriter:end-element("СумНал":U) no-error.
               end.
               hSAXWriter:end-element("СумНал":U) no-error.
            
               /*   hSAXWriter:end-element("СведТов":U) no-error.                                                        */
               /*                                                                                                        */
               /*                                                                                                        */
               /*   hSAXWriter:write-empty-element("СтТовУчНал":U) no-error.                                             */
               /*   hSAXWriter:insert-attribute("СтоимДоИзм":U, string(buf_utd-lines.Total)) no-error.                   */
               /*   v-sum-after = buf_utd-lines.Price * v-qnty-scan + v-nds .                                            */
               /*   hSAXWriter:insert-attribute("СтоимПослеИзм":U, string(v-sum-after)) no-error.                        */
               /*   hSAXWriter:insert-attribute("СтоимУм":U, string(buf_utd-lines.Total - v-sum-after)) no-error.        */
               /*   v-vat-min = v-vat-min + (buf_utd-lines.Total - v-sum-after) * buf_utd-lines.TaxRate / 100 .          */
               /*   v-total-min = v-total-min + (buf_utd-lines.Total - v-sum-after) .                                    */
               /*                                                                                                        */
               /*                                                                                                        */
               /*                                                                                                        */
               
               hSAXWriter:start-element("ДопСведТов":U) no-error.
               do:
                  find first buf_goods where buf_goods.gds-code eq buf_utd-lines.gds-code no-lock no-error.
                  
                  if available buf_goods or buf_utd-lines.Articl ne ""
                  then
                     hSAXWriter:insert-attribute("АртикулТов":U, string(if available (buf_goods) then buf_goods.artic else buf_utd-lines.Article)) no-error.
                  if available buf_goods or buf_utd-lines.UnitCode ne ""
                  then
                     hSAXWriter:insert-attribute("НаимЕдИзм":U, string(if available (buf_goods) then buf_goods.unit-base else buf_utd-lines.UnitCode)) no-error.
                  hSAXWriter:insert-attribute("ПрТовРаб":U, "1") no-error.
                  define variable Vfrist as logical no-undo.
                  Vfrist = yes.
                  for each buf_utd-marking-lines no-lock where 
                     buf_utd-marking-lines.db-num = buf_utd-lines.db-num and
                     buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id and
                     buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum and 
                     buf_utd-marking-lines.doc-level eq 1:
                     define variable vTeg as character no-undo.
                     if isMark(buf_utd-marking-lines.mark)
                     then do:
                        find first marking where marking.mark eq buf_utd-marking-lines.mark no-lock no-error.
                        if available marking
                           and marking.box-qnty > 1
                        then do:
                           vTeg = "НомУпак".
                           
                        end.
                        else
                           vTeg = "НомУпак".
                     end.
                     else if ISOAD(buf_utd-marking-lines.mark)
                     then
                        vTeg = "НомУпак".
                     else
                        vTeg = "".
                     if vTeg ne ""
                     then do:
                        if vfrist
                        then do:
                           vfrist = no.
                           hSAXWriter:start-element("НомСредИдентТов":U) no-error.
                        end.
                        hSAXWriter:start-element(vTeg) no-error.
                        hSAXWriter:write-characters(buf_utd-marking-lines.mark) no-error.
                        hSAXWriter:end-element(vTeg) no-error.
                       
                     end.
                  end.
                  if not vfrist
                  then
                     hSAXWriter:end-element("НомСредИдентТов":U).
              end.
              hSAXWriter:end-element("ДопСведТов":U).
               /*   hSAXWriter:start-element("НомСредИдентТов":U) no-error.                                         */
               /*   for each buf_marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num and*/
               /*      buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id and                                      */
               /*      buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum and                                    */
               /*      buf_utd-marking-lines.doc-level = v-doc-level:                                               */
               /*      hSAXWriter:start-element("НомУпак":U) no-error.                                              */
               /*      hSAXWriter:write-characters(string(buf_utd-marking-lines.mark)) no-error.                    */
               /*      hSAXWriter:end-element("НомУпак":U) no-error.                                                */
               /*   end.                                                                                            */
               /*   hSAXWriter:end-element("НомСредИдентТов":U) no-error.                                           */
               for each bar-code where bar-code.gds-code eq buf_utd-lines.gds-code no-lock:
                  for each prod-bc where prod-bc.b-code eq bar-code.b-code
                                     and prod-bc.bc-on 
                  no-lock:
                     if    length(prod-bc.b-str) eq 13 
                        or length(prod-bc.b-str) eq 8
                     then do:
                        define variable bar_code as character no-undo.
                        bar_code = substr (prod-bc.b-str, 1, length (prod-bc.b-str) - 1).
                        run str/chk-sum.p
                            (input-output bar_code ) no-error .
                        if prod-bc.b-str ne  bar_code
                        then do:
                           hSAXWriter:write-empty-element("ИнфПолФХЖ2":U) no-error.
                           hSAXWriter:insert-attribute("Идентиф":U, "штрихкод") no-error.
                           hSAXWriter:insert-attribute("Значен":U, prod-bc.b-str) no-error.
                           
                           hSAXWriter:write-empty-element("ИнфПолФХЖ2":U) no-error.
                           hSAXWriter:insert-attribute("Идентиф":U, "EAN") no-error.
                           hSAXWriter:insert-attribute("Значен":U, prod-bc.b-str) no-error.
                        end.
                     end.
                  end.
                end.
            /*   hSAXWriter:write-empty-element("ИнфПолФХЖ2":U) no-error.              */
            /*   hSAXWriter:insert-attribute("Идентиф":U, "вложенность") no-error.     */
            /*   hSAXWriter:insert-attribute("Значен":U, string(v-doc-level)) no-error.*/
            end.
            hSAXWriter:end-element("СведТов":U).
         
         end.
         
         /*Всего*/
         hSAXWriter:start-element("ВсегоОпл":U) no-error.
         hSAXWriter:insert-attribute ("СтТовБезНДСВсего":U, string (buf_utd.Total - buf_utd.Vat)) no-error. /*Не ясно что куда записывать*/
         hSAXWriter:insert-attribute ("СтТовУчНалВсего":U, string (buf_utd.Total)) no-error.  
         do:
         
            hSAXWriter:start-element("СумНалВсего":U) no-error.
            do:
               hSAXWriter:start-element("СумНал":U) no-error.
               hSAXWriter:write-characters(string (buf_utd.Vat)) no-error.
               hSAXWriter:end-element("СумНал":U) no-error.
            end.
            hSAXWriter:end-element("СумНалВсего":U) no-error.
         end.
         hSAXWriter:end-element("ВсегоОпл":U) no-error.
      end.
      hSAXWriter:end-element("ТаблСчФакт":U) no-error.
      
      /*если функция Функция=СЧФДОП тогда должно быть СвПродПер откуда брать данные не понятно*/
      hSAXWriter:start-element("СвПродПер":U) no-error.
      do:
         hSAXWriter:start-element("СвПер":U) no-error.
         hSAXWriter:insert-attribute("СодОпер":U, "Товары переданы") no-error.
         hSAXWriter:insert-attribute("ДатаПер":U, string(today,"99.99.9999")) no-error.
         do:
            hSAXWriter:write-empty-element("ОснПер":U) no-error.
            hSAXWriter:insert-attribute("НаимОсн":U, "договор") no-error.
             find first contract where contract.contract-code eq buf_utd.contract-code no-lock no-error.
             if available contract
             then do: 
               hSAXWriter:insert-attribute("НомОсн":U, contract.contract-prn-code) no-error.
               hSAXWriter:insert-attribute("ДатаОсн":U, string(contract.contract-date,"99.99.9999")) no-error.
            end.
         end.
         hSAXWriter:end-element ("СвПер":U) no-error.
      end.
      hSAXWriter:end-element("СвПродПер":U) no-error.
      
      hSAXWriter:start-element("Подписант":U) no-error.
      hSAXWriter:insert-attribute ("ОснПолн":U, "Должностные обязанности") no-error.
      hSAXWriter:insert-attribute ("ОблПолн":U, "0") no-error.
      hSAXWriter:insert-attribute ("Статус":U, "1") no-error.
      do:
         hSAXWriter:start-element("ЮЛ":U) no-error.
         do:
            vUserperm = vOrganization:GetUserPermissions().
            define variable vJobTitle as character no-undo.
            vJobTitle = vUserperm:JobTitle.
            if    vJobTitle eq ?
               or vJobTitle eq ""
            then
               vJobTitle = iDiadocConnection:Certificate:JobTitle.
            release object vUserperm.
            
            hSAXWriter:insert-attribute ("ИННЮЛ":U, string(vOrganization:Inn)) no-error.
            hSAXWriter:insert-attribute ("Должн":U, vJobTitle) no-error.
            hSAXWriter:insert-attribute ("НаимОрг":U, string(vOrganization:Name)) no-error.
            /*hSAXWriter:insert-attribute ("ИныеСвед":U, buf_utd.cli-FnsParticipantId) no-error.*/
            vUser = iDiadocConnection:GetMyUser().
            hSAXWriter:write-empty-element("ФИО":U) no-error.
            hSAXWriter:insert-attribute("Фамилия":U, string(vUser:LastName)) no-error.
            hSAXWriter:insert-attribute("Имя":U, string(vUser:FirstName)) no-error.
            hSAXWriter:insert-attribute("Отчество":U, string(vUser:MiddleName)) no-error.
            release object vUser.
         end.
         hSAXWriter:end-element("ЮЛ":U) no-error.
      end.
      hSAXWriter:end-element("Подписант":U) no-error.
   end.
   hSAXWriter:end-element("Документ":U) no-error.
end.
hSAXWriter:end-element("Файл":U) no-error.

hSAXWriter:end-document().
release object vOrganization.
release object vCounteragent.
delete object hSAXWriter no-error.


