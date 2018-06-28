/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Парсер ВСД

Автор: Сливенко Сергей
Дата создания: 05/03/18
Author: Slivenko Sergey
Creation date: 05/03/18


*/


using ibs.th.str.gds.*.
using ibs.th.str.mercury.*.
using ibs.th.gbl.storage.*.
using ibs.th.str.clients.*.


define variable v-appId as character no-undo .
define variable v-status as character no-undo .
define variable v-mess as character no-undo .
define variable v-issuerId as character no-undo .

define variable v-parsesub as character no-undo .
define variable v-parsesub2 as character no-undo .

define variable vsdStorage as class vsdtostorage.
define variable vsdsTHObj as class vsdsubs.
define variable temp-vsdsTHObj as class vsdsubs.
define variable vsdTHObj as class vsdsub.
define variable vsdStsType as class vsdstatustype. 

define variable v-statusVSD as character no-undo .
define variable v-statusVSD2 as character no-undo .
define variable v-typeVSD as character no-undo .

define variable v-dateCr as character no-undo .
define variable v-year as character no-undo .
define variable v-month as character no-undo .
define variable v-day as character no-undo .
define variable v-hour as character no-undo .

define variable v-ignorSect as logical no-undo initial no .

define buffer buf_vsd for ub.vsd .


procedure getData:
  define output parameter p-appId as character no-undo .
  define output parameter p-status as character no-undo .
  define output parameter p-mess as character no-undo .
  
  assign
    p-appId = v-appId
    p-status = v-status
    p-mess = v-mess
  .
end procedure.

procedure getVsds:
  define output parameter p-appId as character no-undo .
  define output parameter p-status as character no-undo .
  define output parameter p-mess as character no-undo .
  define output parameter p-Vsds as class vsdsubs.
  
  assign
    p-appId = v-appId
    p-status = v-status
    p-mess = v-mess
  .
  p-Vsds = vsdsTHObj .
  
/*  delete object vsdsTHObj no-error. */
/*  delete object vsdStorage no-error.*/
/*  delete object vsdsTHObj no-error. */
/*  delete object vsdStsType no-error.*/
end procedure.

DEFINE VARIABLE gcCurrentElement AS CHARACTER NO-UNDO.

procedure StartElement:
DEFINE INPUT PARAMETER namespaceURI AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER localName    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER qname        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER hAttributes  AS HANDLE NO-UNDO.

  gcCurrentElement = qname .
  case qname :
    when "merc:stockEntry" then v-ignorSect = yes .
    
    when "message" then v-mess = "" .
    when "applicationId" then v-appId = "" .
    when "status" then v-status = "" .
    when "issuerId" THEN v-issuerId = "" .
    when "vd:vetDocument" or
    when "merc:vetDocument"
    then do :
      if v-ignorSect then return .
      
      if not valid-object(vsdsTHObj)
      then vsdsTHObj = new vsdsubs ().
      
      if not valid-object(vsdStorage)
      then vsdStorage = new vsdtostorage ().
      
      if not valid-object(vsdStsType)
      then vsdStsType = new vsdstatustype ().
      
      v-parsesub = "vetDocument" .
    end. 
/*    when "merc:vetDocument"       */
/*    then do :                     */
/*      v-parsesub = "vetDocument" .*/
/*    end .                         */
    when "bs:uuid"
    then do :
      case v-parsesub :
/*        when "vetDocument" then vsdsTHObj:VsdObjCurr:UUID = "" .*/
        otherwise do :
          
        end.
      end case.
    end.
    when "vd:productItem" then v-parsesub = "productItem" .
    when "vd:product" then v-parsesub = "product" .
    when "vd:subProduct" then v-parsesub = "subProduct" .
    when "vd:unit" then v-parsesub = "unit" .
    when "vd:country" then v-parsesub = "country" .
    when "dt:businessEntity" then v-parsesub = "businessEntity" .
    when "dt:enterprise" then v-parsesub = "enterprise" .
    when "vd:purpose" then v-parsesub = "purpose" .
    when "vd:dateOfProduction" then v-parsesub2 = "dateOfProduction" .
    when "vd:expiryDate" then v-parsesub2 = "expiryDate" .
    when "vd:consignor" then v-parsesub2 = "consignor" .
    when "vd:consignee" then v-parsesub2 = "consignee" .
    when "vd:producer" then v-parsesub2 = "producer" .
    when "vd:referencedDocument" then v-parsesub2 = "referencedDocument" .
    when "vd:authentication" then v-parsesub2 = "authentication" .
    when "vd:firstDate"
    then do :
      v-parsesub = "firstDate" .
      v-year = "" .
      v-month = "" .
      v-day = "" .
      v-hour = "" .
    end.
  end case.

end procedure. /* end_of StartElement */

PROCEDURE Characters:
  DEFINE INPUT PARAMETER ppText AS MEMPTR NO-UNDO.
  DEFINE INPUT PARAMETER piNumChars AS INTEGER NO-UNDO.

  define variable v-str as character no-undo .
  if v-ignorSect then return .
  
  v-str = GET-STRING(ppText,1) .

  case gcCurrentElement :
    when "message" or
    when "apl:error"
    then do :
      v-mess = v-mess + chr(10) + v-str .
      v-mess = left-trim(v-mess, chr(10)) .
    end.
    when "applicationId" THEN v-appId = v-str .
    when "status" THEN v-status = v-str .
    when "issuerId" THEN v-issuerId = v-str .
    when "bs:uuid"
    then do :
      case v-parsesub :
        when "vetDocument"
        then do :
          find first buf_vsd no-lock where buf_vsd.UUID = v-str no-error.
          if not available buf_vsd
          then do :
            vsdTHObj = new vsdsub ().
            
            vsdsTHObj:AddItem(vsdTHObj) .
            vsdsTHObj:VsdObjCurr:UUID = caps(v-str) .
            vsdsTHObj:VsdObjCurr:EconomicSub = v-issuerId .
            vsdsTHObj:VsdObjCurr:FactDatetime = now .
          end.
          else do :
            temp-vsdsTHObj = new vsdsubs (). 
            temp-vsdsTHObj = vsdStorage:getVSDsubs(buffer buf_vsd) .
            vsdsTHObj:AddItem(temp-vsdsTHObj:VsdObjCurr) .
            vsdsTHObj:VsdObjCurr:EconomicSub = v-issuerId .
          end .
        end.
      end case.
    end.
    when "vd:vetDType"
    then do :
      v-typeVSD = v-str .
      case v-typeVSD :
        when "INCOMING" then vsdsTHObj:VsdObjCurr:VSDType = 1 .
        when "OUTGOING" then vsdsTHObj:VsdObjCurr:VSDType = 2 .
        when "PRODUCTIVE" then vsdsTHObj:VsdObjCurr:VSDType = 3 .
        when "RETURNABLE" then vsdsTHObj:VsdObjCurr:VSDType = 4 .
        when "TRANSPORT" then vsdsTHObj:VsdObjCurr:VSDType = 5 .
      end case .
    end.
    when "vd:vetDStatus"
    then do :
      v-statusVSD = v-str .
    end.
    when "vd:status"
    then do :
      v-statusVSD2 = v-str .
    end.     
    when "bs:guid"
    then do :
      
      case v-parsesub :
        when "businessEntity"
        then do :
          case v-parsesub2 :
            when "consignor" then vsdsTHObj:VsdObjCurr:CliBeGuid = v-str .
            when "consignee" then vsdsTHObj:VsdObjCurr:ObjBeGuid = v-str .
          end case.  
        end.
        when "enterprise"
        then do :
          case v-parsesub2 :
            when "consignor" then vsdsTHObj:VsdObjCurr:CliEntGuid = v-str .
            when "consignee" then vsdsTHObj:VsdObjCurr:ObjEntGuid = v-str .
            when "producer" then vsdsTHObj:VsdObjCurr:ProducerGuid = v-str .
          end case.  
        end.
        when "productItem"
        then do :
          vsdsTHObj:VsdObjCurr:GdsGuid = v-str .
        end.
        when "product"
        then do :
          vsdsTHObj:VsdObjCurr:ProductGuid = v-str .
        end.
        when "subProduct"
        then do :
          vsdsTHObj:VsdObjCurr:SubProductGuid = v-str .
        end.
        when "unit" then vsdsTHObj:VsdObjCurr:UnitGuid = v-str .
        when "country" then vsdsTHObj:VsdObjCurr:OrigCountryGuid = v-str .
        when "purpose" then vsdsTHObj:VsdObjCurr:PurposeGuid = v-str .
      end case.
    end. 
    when "dt:name"
    then do :
      case v-parsesub :
        when "productItem"
        then do :
          vsdsTHObj:VsdObjCurr:GdsName = v-str .
        end.
      end case.
    end.
    when "vd:issueDate"
    then do :
      v-dateCr = v-str .
      case v-parsesub2 :
        when "referencedDocument" then vsdsTHObj:VsdObjCurr:TTNissueDate = v-str .
        when "authentication" then do : end .
        otherwise do :
          vsdsTHObj:VsdObjCurr:DateCr = date(integer(substring(v-dateCr, 6,2)), integer(substring(v-dateCr, 9,2)), integer(substring(v-dateCr, 1,4))) .
        end .
      end case .
    end.
    when "vd:perishable" then vsdsTHObj:VsdObjCurr:Perishable = v-str .
    when "vd:vehicleNumber" or
    when "vd:wagonNumber" or
    when "vd:shipName" or
    when "vd:flightNumber"
    then vsdsTHObj:VsdObjCurr:CarNum = v-str.
    when "vd:containerNumber" then vsdsTHObj:VsdObjCurr:ContainerNum = v-str .
    when "vd:trailerNumber" then vsdsTHObj:VsdObjCurr:TrailerNum = v-str .
    when "vd:transportStorageType" then vsdsTHObj:VsdObjCurr:TransportType = v-str .
    when "vd:transportType" then vsdsTHObj:VsdObjCurr:Transport = v-str .
    when "vd:volume" then vsdsTHObj:VsdObjCurr:Qnty = decimal(v-str) .
    when "vd:batchId" then vsdsTHObj:VsdObjCurr:NumPart = v-str . 
    when "vd:productType" then vsdsTHObj:VsdObjCurr:TypeProd = v-str .
    when "dt:year" then v-year = v-str .
    when "dt:month" then v-month = v-str .
    when "dt:day" then v-day = v-str no-error.
    when "dt:hour" then v-hour = v-str no-error.
    when "dt:role"
    then do :
      case v-parsesub2 :
        when "producer" then vsdsTHObj:VsdObjCurr:ProducerRole = v-str .
        otherwise do :
          
        end .
      end case .
    end.
    when "vd:issueNumber"
    then do :
      case v-parsesub2 :
        when "referencedDocument" then vsdsTHObj:VsdObjCurr:TTNissueNumber = v-str .
        otherwise do :
          
        end .
      end case .
    end.
    when "vd:issueSeries"
    then do :
      case v-parsesub2 :
        when "referencedDocument" then vsdsTHObj:VsdObjCurr:TTNissueSeries = v-str .
        otherwise do :
          
        end .
      end case .
    end.
    when "vd:type"
    then do :
      case v-parsesub2 :
        when "referencedDocument" then vsdsTHObj:VsdObjCurr:TTNtype = v-str .
        otherwise do :
          
        end .
      end case .
    end.
    when "vd:relationshipType"
    then do :
      case v-parsesub2 :
        when "referencedDocument" then vsdsTHObj:VsdObjCurr:TTNrelationshipType = v-str .
        otherwise do :
          
        end .
      end case .
    end.
    when "vd:cargoInspected"
    then do :
      case v-parsesub2 :
        when "authentication" then vsdsTHObj:VsdObjCurr:CargoInspected = v-str .
        otherwise do :
          
        end .
      end case .
    end.
    when "vd:cargoExpertized"
    then do :
      case v-parsesub2 :
        when "authentication" then vsdsTHObj:VsdObjCurr:CargoExpertized = v-str .
        otherwise do :
          
        end .
      end case .
    end.
    when "vd:locationProsperity"
    then do :
      case v-parsesub2 :
        when "authentication" then vsdsTHObj:VsdObjCurr:LocationProsperity = v-str .
        otherwise do :
          
        end .
      end case .
    end.
  end case .
END.

PROCEDURE EndElement:
  DEFINE INPUT PARAMETER pcNamespaceURI AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcLocalName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcElementName AS CHARACTER NO-UNDO.

  case pcElementName :
/*    when "message" then v-mess = "" .       */
/*    when "applicationId" then v-appId = "" .*/
/*    when "status" then v-status = "" .      */
    when "merc:stockEntry" then v-ignorSect = no .
    
    when "vd:firstDate"
    then do :
      if v-ignorSect then return .
      case v-parsesub2 :
        when "dateOfProduction" then vsdsTHObj:VsdObjCurr:DateOut = v-year + ":" + v-month + ":" + v-day + ":" + v-hour .
        when "expiryDate" then vsdsTHObj:VsdObjCurr:ExpiryDate = v-year + ":" + v-month + ":" + v-day + ":" + v-hour .
      end case.
    end.
    when "vd:secondDate"
    then do :
      if v-ignorSect then return .
      case v-parsesub2 :
        when "dateOfProduction" then vsdsTHObj:VsdObjCurr:ExpiryOutDate = v-year + ":" + v-month + ":" + v-day + ":" + v-hour .
        when "expiryDate" then vsdsTHObj:VsdObjCurr:ExpiryDate2 = v-year + ":" + v-month + ":" + v-day + ":" + v-hour .
      end case.
    end.
    when "application"
    then do :
      
    end.
    when "vd:productItem"
    then do :
/*      find first gds-mercury no-lock where gds-mercury.GUID = gdsMercsubObj:GUID_ no-error .*/
/*      if not available gds-mercury                                                          */
/*      then do :                                                                             */
/*        gdsMercsubObj:GdsCode = vsdsTHObj:VsdObjCurr:GdsCode .                              */
/*        gdsMercstrObj:insertDB(gdsMercsubObj) .                                             */
/*      end.                                                                                  */
    end.
    when "vd:vetDocument" or
    when "merc:vetDocument"
    then do :
      if v-ignorSect then return .
      if v-statusVSD2 = "CONFIRMED"
      then do :
        if v-statusVSD = "CONFIRMED" then vsdsTHObj:VsdObjCurr:Status_ = vsdStsType:IsNeedUtilized .
        if v-statusVSD = "UTILIZED" then vsdsTHObj:VsdObjCurr:Status_ = vsdStsType:IsUtilized .
      end.
      else
      if v-statusVSD2 = "UTILIZED"
      then do :
        if v-statusVSD = "UTILIZED" then vsdsTHObj:VsdObjCurr:Status_ = vsdStsType:IsUtilized .
      end.
      else do :
        if v-statusVSD = "CONFIRMED" then vsdsTHObj:VsdObjCurr:Status_ = vsdStsType:IsErrCheck .
        if v-statusVSD = "UTILIZED" then vsdsTHObj:VsdObjCurr:Status_ = vsdStsType:IsErrUtilized .
        vsdsTHObj:VsdObjCurr:MsgErr = v-mess .
      end.  
      v-parsesub = "" .
    end.
/*    when "merc:vetDocument"*/
/*    then do :              */
/*      v-parsesub = "" .    */
/*    end.                   */
    when "vd:productItem" then v-parsesub = "" .
    when "vd:product" then v-parsesub = "" .
    when "vd:subProduct" then v-parsesub = "" .
    when "vd:unit" then v-parsesub = "" .
    when "vd:country" then v-parsesub = "" .
    when "dt:businessEntity" then v-parsesub = "" .
    when "dt:enterprise" then v-parsesub = "" .
    when "vd:purpose" then v-parsesub = "" .
    when "vd:dateOfProduction" then v-parsesub2 = "" .
    when "vd:expiryDate" then v-parsesub2 = "" .
    when "vd:consignor" then v-parsesub2 = "" .
    when "vd:consignee" then v-parsesub2 = "" .
    when "vd:producer" then v-parsesub2 = "" .
    when "vd:referencedDocument" then v-parsesub2 = "" .
    when "vd:authentication" then v-parsesub2 = "" .
  end case.
END.