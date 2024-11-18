/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получить всю секцию с настройками подключения к ГИС МТ

Автор: Белова Марина Михайловна
Дата создания: 25/10/2023
Author: Marina Belova
Creation date: 25/10/2023

*/

&if "{1}" = "def"  &then
{ gbl/thbj-def.i  }

 define variable gismt-AdressPort   as character no-undo.
 define variable gismt-DopParam     as character no-undo.
 define variable gismt-GisAdress    as character no-undo.
 define variable gismt-ProxyLogin   as character no-undo.
 define variable gismt-ProxyPswd    as character no-undo.
 define variable gismt-MaxTime      as integer   no-undo.
 define variable gismt-RegKey       as character no-undo.
 define variable gismt-TimeFalStart as integer   no-undo.
 define variable gismt-WaitTime     as decimal   no-undo. 
 define variable gismt-CrashSituat  as logical   no-undo.
 define variable gismt-BanDate      as integer   no-undo.
 define variable gismt-cdnTurnOn    as logical   no-undo.
 define variable gismt-cdnAdress    as character no-undo.
 define variable gismt-cdnRepeat    as logical   no-undo.
 define variable gismt-cdnChange    as logical   no-undo.
 define variable gismt-cdnTimeUpd   as integer   no-undo.
 define variable gismt-UpdateRequest as logical   no-undo.
 define variable gismt-OflineAdress  as character no-undo.
 define variable gismt-OflineAutoriz as character no-undo.
 define variable gismt-OflineLogin   as character no-undo.
 define variable gismt-OflinePswd    as character no-undo.
 define variable gismt-OflineDate    as date      no-undo.

{ def/funcmet.i get-gismt-prop character }
(input p-obj-type as char,
 input p-obj-code as int):       

    define variable v-param-type      as character no-undo.
    define variable v-value-character as character no-undo .
    define variable v-value-date      as date      no-undo .
    define variable v-value-decimal   as decimal   no-undo .
    define variable v-value-integer   as integer   no-undo .
    define variable v-value-logical   as logical   no-undo .
    def buffer buf_code for ub.code. 

    for each thbjattr_thbj-attr:
      delete thbjattr_thbj-attr.
    end.
    run adm/shattri.p (
      input "get":U
      ,input  p-obj-type
      ,input  p-obj-code
      ,input  {&attr-gisMT}
      ,input  "":U
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-param-type
      ,INPUT-OUTPUT table thbjattr_thbj-attr
      )  no-error.
      

    for each thbjattr_thbj-attr
    on error undo, return error return-value
    :
        
      case thbjattr_thbj-attr.prop-code :
        when {&attr-gisMT_AdressPort} then do:
          gismt-AdressPort = thbjattr_thbj-attr.property-value-character.
        end.
        when {&attr-gisMT_dopParam} then do:
          gismt-DopParam = thbjattr_thbj-attr.property-value-character.
        end.   
        when {&attr-gisMT_gisAdress} then do: 
          gismt-GisAdress = thbjattr_thbj-attr.property-value-character.
        end.  
        when {&attr-gisMT_proxyLogin} then do:
          gismt-ProxyLogin = thbjattr_thbj-attr.property-value-character.
        end.  
        when {&attr-gisMT_proxyPswd} then do:
          gismt-ProxyPswd = thbjattr_thbj-attr.property-value-character.
        end.  
        when {&attr-gisMT_maxTime} then do:           
          gismt-MaxTime = thbjattr_thbj-attr.property-value-integer.
        end.  
        when {&attr-gisMT_regKey} then do: 
          gismt-RegKey = thbjattr_thbj-attr.property-value-character.
        end.  
        when {&attr-gisMT_timeFalStart} then do: 
          gismt-TimeFalStart = thbjattr_thbj-attr.property-value-integer.
        end.  
        when {&attr-gisMT_waitTime} then do: 
          gismt-WaitTime = thbjattr_thbj-attr.property-value-decimal.
        end.  
        when {&attr-gisMT_crashSituat} then do: 
          gismt-CrashSituat = thbjattr_thbj-attr.property-value-logical.
        end.  
        when {&attr-gisMT_banDate} then do:
          gismt-BanDate = thbjattr_thbj-attr.property-value-integer.
        end.  
        when {&attr-gisMT_cdnTurnOn} THEN DO:
           gismt-cdnTurnOn = thbjattr_thbj-attr.property-value-logical.           
        end.    
        when {&attr-gisMT_cdnAdress} THEN DO:
           gismt-cdnAdress = thbjattr_thbj-attr.property-value-character.           
        end.
        when {&attr-gisMT_cdnRepeat} THEN DO:
           gismt-cdnRepeat = thbjattr_thbj-attr.property-value-logical.           
        end.
        when {&attr-gisMT_cdnChange} THEN DO:
           gismt-cdnChange = thbjattr_thbj-attr.property-value-logical.           
        end. 
        when {&attr-gisMT_cdnTimeUpdate} THEN DO:
           gismt-cdnTimeUpd = thbjattr_thbj-attr.property-value-integer.           
        end.    
        when {&attr-gisMT_UpdateRequest} THEN DO:
           gismt-UpdateRequest = thbjattr_thbj-attr.property-value-logical.           
        end.               
        when {&attr-gisMT_OflineAdress} THEN DO:
           gismt-OflineAdress = thbjattr_thbj-attr.property-value-character.           
        end.        
        when {&attr-gisMT_OflineLogin} THEN DO:
           gismt-OflineLogin = thbjattr_thbj-attr.property-value-character.           
        end.
        when {&attr-gisMT_OflinePswd} THEN DO:
           gismt-OflinePswd = thbjattr_thbj-attr.property-value-character.           
        end.
        
      end case.
      delete thbjattr_thbj-attr.
    end.
    if gismt-OflineLogin <> "" and gismt-OflinePswd <> "" 
    then gismt-OflineAutoriz = ConvBase64(gismt-OflineLogin + ":" + gismt-OflinePswd).
    
    find first buf_code no-lock where 
               buf_code.parent eq "GisMtOffline"
           and buf_code.code   eq string(p-obj-code)
       no-error.
    if not avail buf_code then    
    find first buf_code no-lock where 
               buf_code.parent eq "GisMtOffline"
           and buf_code.code   eq "0"
       no-error.
    if avail buf_code then  gismt-OflineDate = date(buf_code.CodeValue) no-error.
    else gismt-OflineDate = today. 
  return "".
end. /* get-gismt-prop */

{ def/funcmet.i ConvBase64 character }
(input iString as char): 
             
  define variable vSize       as integer   no-undo.
  define variable vDataDc1    as memptr    no-undo.
  define variable vDataDc2    as memptr    no-undo.
  define variable vEnCode     as character no-undo. 
  define variable vBase64Str  as character no-undo.    
  do
  on error undo, return error return-value
  :    
    if iString = ?
    then return "".
        
    vSize  = length(iString).
    SET-SIZE(vDataDc1 ) = vSize + 1.
    SET-SIZE(vDataDc2 ) = vSize.
    
    put-string(vDataDc1, 1, vSize) = iString.
    copy-lob from vDataDc1 starting at 1 for vSize to vDataDc2 no-convert.
    
    vEnCode =  base64-encode (vDataDc2).
    
    vBase64Str = substring(vEnCode,1).

    SET-SIZE(vDataDc1)  = 0 no-error.
    SET-SIZE(vDataDc2)  = 0 no-error.
  end.
  return vBase64Str. 
end.     
&endif



/* $Workfile$ e n d */