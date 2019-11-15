/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс работы с секциями по топливу.

Автор: Морозов Александр Сергеевич
Дата создания: 09/29/2015
Author: Alexandr Morozov
Creation date: 09/29/2015

*/ 

using Progress.Lang.*.
using ibs.th.str.*.
using ibs.th.gbl.storage.*.
using ibs.th.ref.*.
using ibs.th.gbl.ptrl.par.*.



class ibs.th.str.InfoSectionsTotal: 

{ cmp/str-glbl.i class}
{ gbl/attr-lib.i class}

  define private buffer buf_doc-line  for ub.doc-line.
  define private buffer buf_doc-line-attr for ub.doc-line-attr.
  define private buffer buf_goods  for ub.goods.
  define private buffer buf_trn  for ub.trn-doc.
  
  define stream log-algo.
  define stream outstream.
  
  define private temp-table ttObjInfoSecProp no-undo
    field iSecNum as integer
    field objInfoSecProp as class Progress.Lang.Object
    index pi is primary unique iSecNum .

  define property TrnDocNum as character no-undo
    get.
    private set.

  define property Parentproc as handle no-undo
    get.
    set.
    
  define property Mode as character no-undo
    get.
    private set.    

  define property WasSetting as logical no-undo
    get.
    set.

  define property GdsCode as integer no-undo
    get.
    private set.

  define property FlagTrn as logical no-undo
    get.
    set.

  define property Sts as character no-undo
    get.
    set.

  define property SectionNum as integer no-undo
    get.
    private set.

  define property idSecCurr as integer no-undo
    get.
    private set.

  define property InfoSectionCurr as class InfoSection no-undo
    get.
    set.
   
  define property TankWeightTotal as decimal no-undo
    get.
    set.

  define property TankVolTotal as decimal no-undo
    get.
    set.

  define property CarVolTotal as decimal no-undo
    get.
    set.

  define property DocQntyTotal as decimal no-undo
    get.
    set.

  define property CliQntyTotal as decimal no-undo
    get.
    set.

  define property FactQntyTotal as decimal no-undo
    get.
    set.

  define property FactKgQntyTotal as decimal no-undo
    get.
    set.

  define property TankWaterVolTotal as decimal no-undo
    get.
    set.

  define property DocDensityAvg as decimal no-undo
    get.
    set.

  define property DocQntyLine as decimal no-undo
    get.
    set.

  define property DocDensLine as decimal no-undo
    get.
    set.

  define property DocCliLine as decimal no-undo
    get.
    set.

  define property StartRealDate as date no-undo
    get.
    private set.

  define property StartRealTime as integer no-undo
    get.
    private set.

  define property EndRealDate as date no-undo
    get.
    private set.

  define property EndRealTime as integer no-undo
    get.
    private set.

  define property CliQntyInput as logical no-undo
    get.
    set.

  define property DensityInput  as logical no-undo
    get.
    set.

  define property DocQntyInput as logical no-undo
    get.
    set.
    
  define property NormalWastage as decimal no-undo
    get.
    set.

  define property IsRNAlgo as logical no-undo
    get.
    set.
    
  define property PercAcc as decimal no-undo
    get.
    set.

  define property IsActnComm as logical no-undo init false
    get.
    set.

  define property AccShip as decimal no-undo
    get.
    set.    

  define property CarNum as character no-undo
    get.
    set.    

  define property IsFlagKPChg as logical no-undo
    get.
    set.    

  define property RdcDnstvalue as character no-undo
    get.
    set.

  define property ObjType as character no-undo
    get.
    set.
    
  define property ObjCode as integer no-undo
    get.
    set.

  define property ParNl as class partpnloss no-undo
    get.
    set.
    
  define property TPNormPLSum as decimal no-undo
    get.
    set.

  define property TPNormAutoSum as decimal no-undo
    get.
    set.
    
  define property TPNormSum as decimal no-undo
    get.
    set.

  define property PrtlPropObj as class ptrlprop no-undo
    get.
    private set.

  define property FuelType as character no-undo
    get.
    private set.

  define property TempForPomi as decimal no-undo
    get:
      if PrtlPropObj:ptrlprop-temp-for-pomi = 1
        then return 15.
        else return 20.
    end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  
  define private variable NLStorage as class normloss no-undo.
  
  
  constructor public InfoSectionsTotal (inTrnDocNum as char, inGdsCode as int, inMode as char):
    
    Mode = inMode.
    
    Initialization (inTrnDocNum, inGdsCode).
    
  end.

  constructor public InfoSectionsTotal ():
    
  end.
  
  method public void Initialization (inTrnDocNum as char, inGdsCode as int):
    
    define variable rdc-dnstvalue as character no-undo.
    define variable rdc-dnsttype as character no-undo.
    define variable v-gds-attr-value as character no-undo .
    define variable v-gds-attr-type  as character no-undo .

    assign
      TrnDocNum = inTrnDocNum
      GdsCode = inGdsCode
    .
    find first buf_trn no-lock where buf_trn.doc-code = TrnDocNum.
    ObjCode = buf_trn.obj-code.
    ObjType = buf_trn.obj-type.

    NLStorage = new normloss ().
    
    Parnl = new partpnloss ().
    PrtlPropObj = ptrlpropproc:GetPropPtrl(ObjType, ObjCode).

    &scop proc-name gds-attr-value
    {&run_proc_attr-lib}
      (input  GdsCode
      ,input  {&attr-fuel-type}
      ,output v-gds-attr-value
      ,output v-gds-attr-type
      ) no-error .
    if error-status :error
    then do:
      FuelType = "".
    end.
    else FuelType = v-gds-attr-value.
    run gbl/conf-rd.p ("rdc-dnst", "", "", 0, "", "", "", no, output rdc-dnstvalue, output rdc-dnsttype) no-error.
    if error-status:error or lookup (FuelType, "metan,propan") > 0 then 
    do:
      rdc-dnstvalue = "not".
    end.
    RdcDnstvalue = rdc-dnstvalue.
		
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  method public void Initialization (inTrnDocNum as char, inArtic as char, inObjType as char, inObjCode as int):
    
    find first buf_goods no-lock where
                               buf_goods.artic= inArtic
                           and buf_goods.prod-code = inObjCode
                           and buf_goods.prod-type = inObjType no-error.
                           
    Initialization (inTrnDocNum, buf_goods.gds-code).
    
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void GetDBAllAttr():
    
    define variable ii as integer no-undo.
    clearObj().

    find first buf_doc-line-attr where buf_doc-line-attr.doc-code = TrnDocNum 
      and buf_doc-line-attr.gds-code = GdsCode 
      and buf_doc-line-attr.attr-code = "n" no-error.
    
    if available (buf_doc-line-attr)
      then assign SectionNum = integer (buf_doc-line-attr.attr-value).
    else SectionNum = 1.
    
    if available (buf_doc-line-attr) and buf_doc-line-attr.attr-value = '0'  
      then SectionNum = 1.

    do ii = 1 to SectionNum :

      InfoSectionCurr = new InfoSection().
      InfoSectionCurr:infoSectionTotal = this-object.
      
      InfoSectionCurr:idSec = ii.
      
      for each buf_doc-line-attr where buf_doc-line-attr.doc-code = TrnDocNum 
        and buf_doc-line-attr.gds-code = GdsCode
        and not buf_doc-line-attr.attr-code = "n" 
        and (SectionNum = 1 or (num-entries (buf_doc-line-attr.attr-code, {&delim-par}) > 1 and (entry (2, buf_doc-line-attr.attr-code, {&delim-par})) = string (ii) and SectionNum > 1)):
        
        def var attrCode as char no-undo.
        assign
          attrCode = entry (1, buf_doc-line-attr.attr-code, {&delim-par}) no-error.
        if error-status:error then next.
        
        InfoSectionCurr:SetProp (attrCode, buf_doc-line-attr.attr-value).

      end.

      /*if SectionNum = 1
      then do:
        find first buf_goods no-lock where buf_goods.gds-code = GdsCode no-error. 
        find first buf_doc-line no-lock where
                                   buf_doc-line.doc-code = TrnDocNum 
                               and buf_goods.artic= buf_doc-line.artic
                               and buf_goods.prod-code = buf_doc-line.prod-code
                               and buf_goods.prod-type = buf_doc-line.prod-type no-error.
        if available (buf_doc-line) then 
          assign
            InfoSectionCurr:CliQnty = buf_doc-line.cli-qnty
/*            InfoSectionCurr:FactQnty = buf_doc-line.fact-qnty*/
            InfoSectionCurr:DocDensity = buf_doc-line.doc-density
            InfoSectionCurr:DocQnty = buf_doc-line.doc-qnty
/*            InfoSectionCurr:FactDensity = buf_doc-line.fact-density*/
/*            InfoSectionCurr:FactKgQnty = buf_doc-line.fact-density * buf_doc-line.fact-qnty*/
          .
      end.*/
      
      create ttObjInfoSecProp.
      assign
        ttObjInfoSecProp.iSecNum = ii 
        ttObjInfoSecProp.objInfoSecProp = cast (InfoSectionCurr, Progress.Lang.Object).
      
    end.
    CalculateTotal ().


  end method.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void NewSection(  ):

    InfoSectionCurr = new InfoSection().
    assign 
      SectionNum = SectionNum + 1.
    create ttObjInfoSecProp.
    assign
      ttObjInfoSecProp.iSecNum = SectionNum
      ttObjInfoSecProp.objInfoSecProp = InfoSectionCurr
    .
    idSecCurr = SectionNum.
    InfoSectionCurr:idSec = SectionNum.
    InfoSectionCurr:infoSectionTotal = this-object.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  method public class InfoSection GetInfoSectionProp ():
    
    return GetInfoSectionProp (1).
    
  end.

  method public class InfoSection GetInfoSectionProp (inSecNum as integer):
    
    define variable objInfoSec as class InfoSection.
    
    for first ttObjInfoSecProp where ttObjInfoSecProp.iSecNum = inSecNum:
      objInfoSec = cast ( ttObjInfoSecProp.objInfoSecProp, InfoSection ).
      InfoSectionCurr = objInfoSec.
      idSecCurr = inSecNum.
      return objInfoSec.
    end.

  end method.
  
  method public character GetInfoSectionProp (inTankCord1 as char):
    define variable objInfoSec as class InfoSection no-undo.
    define variable listIdSec as character no-undo.
    listIdSec = "".
    for each ttObjInfoSecProp :
      objInfoSec = cast ( ttObjInfoSecProp.objInfoSecProp, InfoSection ).
      InfoSectionCurr = objInfoSec.
      if InfoSectionCurr:ListTank = inTankCord1
      then do:
        listIdSec = listIdSec + {&delim-par} + string (ttObjInfoSecProp.iSecNum).
/*        idSecCurr = ttObjInfoSecProp.iSecNum.*/
      end.  
    end.
    listIdSec = trim (listIdSec, {&delim-par}).
    return listIdSec.
  end method.  
  
  
  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void DeleteSection( inNum as int  ):
    
    def var ii as integer no-undo.
    define variable objInfoSec as class InfoSection.
        
    find first ttObjInfoSecProp where ttObjInfoSecProp.iSecNum = inNum.
    delete object ttObjInfoSecProp.objInfoSecProp.
    delete ttObjInfoSecProp.
    ii = 0.
    for each ttObjInfoSecProp use-index pi:
      assign
        ii = ii + 1
        ttObjInfoSecProp.iSecNum = ii.
        idSecCurr = ttObjInfoSecProp.iSecNum.
        objInfoSec = cast ( ttObjInfoSecProp.objInfoSecProp, InfoSection ).
        objInfoSec:idSec = ii.
    end.
    SectionNum = SectionNum - 1.


  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void CalculateTotal ():
    
    def var ii as integer no-undo.
    
    assign
      CarVolTotal = 0
      TankVolTotal = 0
      TankWaterVolTotal = 0
      TankWeightTotal = 0
      DocQntyTotal = 0
      CliQntyTotal = 0
      FactQntyTotal = 0
      FactKgQntyTotal = 0
      DocDensityAvg = 0
      EndRealDate = ?
      EndRealTime = ?
      StartRealTime = ?
      StartRealDate = ?
      TPNormPLSum = 0
      TPNormAutoSum = 0
      TPNormSum = 0
    .
    do ii = 1 to SectionNum :
      GetInfoSectionProp (ii).
      if not CliQntyInput
      then do:
        InfoSectionCurr:CliQnty = InfoSectionCurr:DocDensity * InfoSectionCurr:DocQnty.
      end.
      else do:
        InfoSectionCurr:DocDensity = InfoSectionCurr:CliQnty / InfoSectionCurr:DocQnty.
      end.
      assign
        CarVolTotal = InfoSectionCurr:CarVol + CarVolTotal
        TankVolTotal = InfoSectionCurr:TankVol + TankVolTotal
        TankWaterVolTotal = InfoSectionCurr:TankWater + TankWaterVolTotal
        TankWeightTotal = InfoSectionCurr:TankWeight + TankWeightTotal
        DocQntyTotal = InfoSectionCurr:DocQnty + DocQntyTotal
        FactQntyTotal = InfoSectionCurr:FactQnty + FactQntyTotal
        FactKgQntyTotal = InfoSectionCurr:FactKgQnty + FactKgQntyTotal
        TPNormPLSum = InfoSectionCurr:TPNormPL + TPNormPLSum
        TPNormAutoSum = InfoSectionCurr:TPNormAuto + TPNormAutoSum
        TPNormSum = InfoSectionCurr:TPNorm + TPNormSum
      .
      CliQntyTotal = InfoSectionCurr:CliQnty + CliQntyTotal.
      if StartRealDate = ? or datetime (InfoSectionCurr:DateStart, InfoSectionCurr:TimeStart) < datetime (StartRealDate, StartRealTime) 
      then do:
        assign
          StartRealTime = InfoSectionCurr:TimeStart
          StartRealDate = InfoSectionCurr:DateStart
        .
      end.
      if EndRealDate = ? or datetime (InfoSectionCurr:DateEnd, InfoSectionCurr:TimeEnd) > datetime (EndRealDate, EndRealTime)
      then do:
        assign
          EndRealTime = InfoSectionCurr:TimeEnd
          EndRealDate = InfoSectionCurr:DateEnd
        .
      end.
    end.
    DocDensityAvg = CliQntyTotal / DocQntyTotal .


  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void clearObj ():
    
    release buf_doc-line-attr.
    for each ttObjInfoSecProp use-index pi:
      delete object ttObjInfoSecProp.objInfoSecProp.
      delete ttObjInfoSecProp.
    end.
    SectionNum = 0.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private void putheader(input inpGetInfoSectionProp as class InfoSection ):

    put stream log-algo unformatted
          {&new-line}
          "-----------------------------------------------"
          {&new-line}
          now {&new-line}
          "Номер документа: " TrnDocNum {&new-line}
          "Секция: " inpGetInfoSectionProp:SectionName {&new-line}
          "Флаг комиссионного приема: " inpGetInfoSectionProp:IsKP {&new-line}
          inpGetInfoSectionProp:RnAlgo {&new-line}.
  
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void SaveDB(  ):

    define variable ii as integer no-undo.
    
    for each buf_doc-line-attr where buf_doc-line-attr.doc-code = TrnDocNum 
      and buf_doc-line-attr.gds-code = GdsCode 
      :
      
      delete buf_doc-line-attr.
      
    end.

    find first buf_goods no-lock where buf_goods.gds-code = GdsCode. 
    if not can-find (first buf_doc-line no-lock where
                               buf_doc-line.doc-code = TrnDocNum 
                           and buf_goods.artic = buf_doc-line.artic
                           and buf_goods.prod-code = buf_doc-line.prod-code
                           and buf_goods.prod-type = buf_doc-line.prod-type) 
    then do:
      return error substitute ("Линия по накладной не существует. Не возможно сохранить в базу данных данные по секциям для накладной &1 товар артикул &2 произовдитель &3&4", TrnDocNum, buf_goods.artic, buf_goods.prod-type, buf_goods.prod-code).                             
    end.
                           

    create buf_doc-line-attr.
    assign
      buf_doc-line-attr.doc-code = TrnDocNum
      buf_doc-line-attr.gds-code = GdsCode
      buf_doc-line-attr.attr-code = "n"
      buf_doc-line-attr.attr-value = string (SectionNum)
    .
    
    do ii = 1 to SectionNum:
      GetInfoSectionProp (ii).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'car-vol' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:CarVol).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tests' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:Tests).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'certif-fuel' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = InfoSectionCurr:CertifFuel.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'norm-doc' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = InfoSectionCurr:NormDoc.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'num-passport' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = InfoSectionCurr:NumPassport.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'validity-certif' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = InfoSectionCurr:ValidityCertif.      
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'passport-plotn' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = InfoSectionCurr:PassportPlotn.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'place-si' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:PlaceSi).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'kol-prob' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:KolProb).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'num-print-prob' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:NumPrintProb).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'date-prob' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:DateProb).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'hour-prob' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:HourProb).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'min-prob' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:MinProb).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'date-pov-plotn' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:DatePovPlotn).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'num-plotn' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = InfoSectionCurr:NumPlotn.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'date-start' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (InfoSectionCurr:DateStart).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'time-start' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TimeStart ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'date-end' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:DateEnd ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'time-end' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TimeEnd ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-vol' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TankVol ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-temp' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TankTemp ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-water' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TankWater ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-density' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TankDensity ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-weight' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TankWeight ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'mouth' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:Mouth ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'a-b-tarir' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:ABTarir ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'diameter' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:Diameter ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-density-pomi' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TankDensityPomi ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-vol-pomi' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TankVolPomi ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'dens-temp' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:DensTemp ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'section-name' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = InfoSectionCurr:SectionName.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'doc-qnty' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:DocQnty ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'doc-dens' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:DocDensity ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'fact-dens' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:FactDensity ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'fact-qnty' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:FactQnty).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'acc-pomi' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:AccPOMI).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'acc-ship' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:AccShip).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'rn-algo' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:RnAlgo).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'dop-info' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:AccAbsFact) + ',' + string ( InfoSectionCurr:NaturalLoss) 
              + ',' + (if InfoSectionCurr:Deficit <> 0 then string ( - InfoSectionCurr:Deficit) else string ( InfoSectionCurr:Excess)).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'is-kp' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:IsKP).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'list-tank' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:ListTank).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'ttn-temp' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TTNTemp ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tp-norm-pl' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TPNormPL).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tp-norm-auto' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( InfoSectionCurr:TPNormAuto).      
      
      release buf_doc-line-attr.
      
    end.

  end method.

  method public void RNAlgo (ii as int, output MP as decimal):

    RNAlgo(ii, MP, no).
    
  end.
  
  
  method public void RNAlgo (ii as int, output MP as decimal, IsManual as log):

    def var dMP  as decimal no-undo.
    def var MF   as decimal no-undo.
    def var dMF  as decimal no-undo.
    def var MTTH as decimal no-undo.
    def var md   as decimal no-undo.
    def var dmd  as decimal no-undo.
    def var dF   as decimal no-undo.
    def var NPE  as decimal no-undo.
    def var ME   as decimal no-undo.
    def var dMEd as decimal no-undo.
    def var I    as decimal no-undo.
    def var H    as decimal no-undo.
    def var v-ok as logical no-undo.
    
    assign
      MTTH = InfoSectionCurr:DocQnty * InfoSectionCurr:DocDensity
      MF = InfoSectionCurr:TankWeight
      dF = InfoSectionCurr:AccPomi
      NPE = NormalWastage
      dmd = MF * dF * 0.01
      dMP = MF - MTTH
      dMEd = MTTH * NPE * 0.001.
      ME = MTTH - MF - dmd.
    .
    

    if not InfoSectionCurr:IsKP or IsManual
    then do: 
      if abs (dMP) <= dmd /* условие (22) */
      then do:
        MP = MTTH.
        InfoSectionCurr:AccAbsFact = dmd.
        InfoSectionCurr:RnAlgo = "условие 22".
        output stream log-algo to value ("log-algo-pomi.txt") append.
        putheader(InfoSectionCurr).
        put stream log-algo unformatted
          "MTTH  = " string(MTTH) {&new-line}
          "MF  = " string(MF) {&new-line}
          "dF  = " string(dF) {&new-line}
          "NPE  = " string(NPE) {&new-line}
          "dmd  = " string(dmd) {&new-line}
          "dMP  = " string(dMP) {&new-line}
          "dMEd  = " string(dMEd) {&new-line}
          "ME = " string(ME) {&new-line}
        .
        output stream log-algo close.
        return.
      end.
      
      if abs (dMP) <= dmd + dMed /* условие (25) */
      then do:
        MP = MTTH - ME.
        InfoSectionCurr:AccAbsFact = dmd + dMed.
        InfoSectionCurr:NaturalLoss = ME.
        InfoSectionCurr:RnAlgo = "условие 25".
        output stream log-algo to value ("log-algo-pomi.txt") append.
        putheader(InfoSectionCurr).
        put stream log-algo unformatted
          "MTTH  = " string(MTTH) {&new-line}
          "MF  = " string(MF) {&new-line}
          "dF  = " string(dF) {&new-line}
          "NPE  = " string(NPE) {&new-line}
          "dmd  = " string(dmd) {&new-line}
          "dMP  = " string(dMP) {&new-line}
          "dMEd  = " string(dMEd) {&new-line}
          "ME = " string(ME) {&new-line}
        .
        output stream log-algo close.
        return.
      end.
    end.

    if not InfoSectionCurr:IsKP and not isManual
    then do: 
      message substitute ("Выявлено сверхнормативное расхождение Данных ТТН с данными в АЦ. Требуется комиссионный прием. Продолжить (необходимо подать заявку в соответсвии с принятой схемой обращения)?")
      view-as alert-box question buttons yes-no title "Вопрос" update v-ok .
      if not v-ok
      then do:
        MP = ?.
        return.
      end.
      IsFlagKPChg = true.
      assign
        InfoSectionCurr:IsKP = true
      .
      MP = ?.
      return.
    end.
    
    IsFlagKPChg = false.
    
    if not IsActnComm
    then do:
      message substitute ( "По секции &1 включен комиссионный прием нефтепродукта. У пользователя отсутвует право <<Комиссионный прием нефтепродукта>>. Продолжение невозможно.", ii ).
      MP = ?.
      return.
    end.
    
    def var MKP      as decimal no-undo.
    def var dMKP     as decimal no-undo.
    def var dmKPd    as decimal no-undo.
    def var delKP    as decimal no-undo.
    def var delTTH   as decimal no-undo.
    def var dTTH     as decimal no-undo.
    def var dKP      as decimal no-undo.
    def var MKPK     as decimal no-undo.
    def var dmTTHd   as decimal no-undo.
    def var X1       as decimal no-undo.
    def var X2       as decimal no-undo.
    def var X3       as decimal no-undo.
    def var X4       as decimal no-undo.
    def var NTruck   as decimal no-undo.
    def var NStorage as decimal no-undo.

    MKP = MF.
    dMKP = MKP - MTTH.
    dKP = InfoSectionCurr:AccPomi. /*if AccComm = ? then 0 else AccComm.*/
    
    dmKPd = MKP * dF * 0.01.
    delKP = dF * MKP * 0.01. /*одно и тоже для наглядности с документацией*/


    if abs(dMKP) <= dmKPd /* условие (30) */
    then do:
      MP = MTTH.
      InfoSectionCurr:AccAbsFact = dmKPd.
      InfoSectionCurr:RnAlgo = "условие 30".
      output stream log-algo to value ("log-algo-pomi.txt") append.
      putheader(InfoSectionCurr).
      put stream log-algo unformatted
        "MTTH  = " string(MTTH) {&new-line}
        "MF  = " string(MF) {&new-line}
        "dF  = " string(dF) {&new-line}
        "NPE  = " string(NPE) {&new-line}
        "dmd  = " string(dmd) {&new-line}
        "dMP  = " string(dMP) {&new-line}
        "dMEd  = " string(dMEd) {&new-line}
        "ME = " string(ME) {&new-line}
        "MKP = " string(MKP) {&new-line}
        "dMKP = " string(dMKP) {&new-line}
        "dmKPd = " string(dmKPd) {&new-line}
        "delKP = " string(delKP) {&new-line}
        "delTTH = " string(delTTH) {&new-line}
        "dTTH = " string(dTTH) {&new-line}
        "dKP = " string(dKP) {&new-line}
        "MKPK = " string(MKPK) {&new-line}
        "dmTTHd = " string(dmTTHd) {&new-line}
        "X1 = " string(X1) {&new-line}
        "X2 = " string(X2) {&new-line}
        "X3 = " string(X3) {&new-line}
        "X4 = " string(X4) {&new-line}
        "MP = " string(MP) {&new-line}
        "I = " string(I) {&new-line}
        "H = " string(H) {&new-line}
      .
      output stream log-algo close.
      return.
    end.
    
    
    dTTH = InfoSectionCurr:AccShip.
    dmTTHd = MTTH * dTTH * 0.01.
    

    
    X3 = MKP - dmKPd.
    X4 = MTTH + dmTTHd.
    
    delTTH = dTTH * MTTH * 0.01.
    
    MKPK = X3 + dF * ((X4 - X3) / (dTTH + dF)).
    
    
    if abs (dMKP) <= delTTH + delKP /* условие (32)*/ and MTTH < MKP /* условие (35) */
    then do: 
      I = MKPK - MTTH.
      MP = MKPK.
      InfoSectionCurr:AccAbsFact = delTTH + delKP.
      InfoSectionCurr:Excess = I.
      InfoSectionCurr:RnAlgo = "условие 32 и условие 35".
      output stream log-algo to value ("log-algo-pomi.txt") append.
      putheader(InfoSectionCurr).
      put stream log-algo unformatted
        "MTTH  = " string(MTTH) {&new-line}
        "MF  = " string(MF) {&new-line}
        "dF  = " string(dF) {&new-line}
        "NPE  = " string(NPE) {&new-line}
        "dmd  = " string(dmd) {&new-line}
        "dMP  = " string(dMP) {&new-line}
        "dMEd  = " string(dMEd) {&new-line}
        "ME = " string(ME) {&new-line}
        "MKP = " string(MKP) {&new-line}
        "dMKP = " string(dMKP) {&new-line}
        "dmKPd = " string(dmKPd) {&new-line}
        "delKP = " string(delKP) {&new-line}
        "delTTH = " string(delTTH) {&new-line}
        "dTTH = " string(dTTH) {&new-line}
        "dKP = " string(dKP) {&new-line}
        "MKPK = " string(MKPK) {&new-line}
        "dmTTHd = " string(dmTTHd) {&new-line}
        "X1 = " string(X1) {&new-line}
        "X2 = " string(X2) {&new-line}
        "X3 = " string(X3) {&new-line}
        "X4 = " string(X4) {&new-line}
        "MP = " string(MP) {&new-line}
        "I = " string(I) {&new-line}
        "H = " string(H) {&new-line}
      .
      output stream log-algo close.
      return.
    end.


    if not abs (dmKP) <= delTTH + delKP /* условие (32)*/ and MTTH < MKP /* условие (35) */
    then do: 
      MP = MKP - delKP.
      I = MKP - MTTH - delKP.
      InfoSectionCurr:AccAbsFact = delTTH + delKP.
      InfoSectionCurr:Excess = I.
      InfoSectionCurr:RnAlgo = "нет условие 32 и условие 35".
      output stream log-algo to value ("log-algo-pomi.txt") append.
      putheader(InfoSectionCurr).
      put stream log-algo unformatted
        "MTTH  = " string(MTTH) {&new-line}
        "MF  = " string(MF) {&new-line}
        "dF  = " string(dF) {&new-line}
        "NPE  = " string(NPE) {&new-line}
        "dmd  = " string(dmd) {&new-line}
        "dMP  = " string(dMP) {&new-line}
        "dMEd  = " string(dMEd) {&new-line}
        "ME = " string(ME) {&new-line}
        "MKP = " string(MKP) {&new-line}
        "dMKP = " string(dMKP) {&new-line}
        "dmKPd = " string(dmKPd) {&new-line}
        "delKP = " string(delKP) {&new-line}
        "delTTH = " string(delTTH) {&new-line}
        "dTTH = " string(dTTH) {&new-line}
        "dKP = " string(dKP) {&new-line}
        "MKPK = " string(MKPK) {&new-line}
        "dmTTHd = " string(dmTTHd) {&new-line}
        "X1 = " string(X1) {&new-line}
        "X2 = " string(X2) {&new-line}
        "X3 = " string(X3) {&new-line}
        "X4 = " string(X4) {&new-line}
        "MP = " string(MP) {&new-line}
        "I = " string(I) {&new-line}
        "H = " string(H) {&new-line}
      .
      output stream log-algo close.
      return.
    end.
    
    if abs (dmKP) <= delTTH + delKP /* условие (32)*/ and MTTH > MKP /* условие (44) */
    then do: 
      if abs (dMKP) <= dmKPd + dMed /* условие (45) */
      then do:
        ME = MTTH - MKP - dmKPd.
        MP = MTTH - ME.
        InfoSectionCurr:AccAbsFact = dmKPd + dMed.
        InfoSectionCurr:NaturalLoss = ME.
        InfoSectionCurr:RnAlgo = "условие 32 и условие 44 и условие 45".
        output stream log-algo to value ("log-algo-pomi.txt") append.
        putheader(InfoSectionCurr).
        put stream log-algo unformatted
          "MTTH  = " string(MTTH) {&new-line}
          "MF  = " string(MF) {&new-line}
          "dF  = " string(dF) {&new-line}
          "NPE  = " string(NPE) {&new-line}
          "dmd  = " string(dmd) {&new-line}
          "dMP  = " string(dMP) {&new-line}
          "dMEd  = " string(dMEd) {&new-line}
          "ME = " string(ME) {&new-line}
          "MKP = " string(MKP) {&new-line}
          "dMKP = " string(dMKP) {&new-line}
          "dmKPd = " string(dmKPd) {&new-line}
          "delKP = " string(delKP) {&new-line}
          "delTTH = " string(delTTH) {&new-line}
          "dTTH = " string(dTTH) {&new-line}
          "dKP = " string(dKP) {&new-line}
          "MKPK = " string(MKPK) {&new-line}
          "dmTTHd = " string(dmTTHd) {&new-line}
          "X1 = " string(X1) {&new-line}
          "X2 = " string(X2) {&new-line}
          "X3 = " string(X3) {&new-line}
          "X4 = " string(X4) {&new-line}
          "MP = " string(MP) {&new-line}
          "I = " string(I) {&new-line}
          "H = " string(H) {&new-line}
        .
        output stream log-algo close.
        return.
      end.
      else do:
        
        X1 = MTTH - dmTTHd.
        X2 = MKP + dmKPd.
        
        MKPK = X1 + dTTH * ((X2 - X1) / (dTTH + dKP)).
        
        MP = MKPK.
        ME = dMEd.
        H = MTTH - MKPK - ME.
        InfoSectionCurr:AccAbsFact = dmKPd + dMed.
        InfoSectionCurr:NaturalLoss = ME.
        InfoSectionCurr:Deficit = H.
        InfoSectionCurr:RnAlgo = "условие 32 и условие 44 и нет условие 45".
        output stream log-algo to value ("log-algo-pomi.txt") append.
        putheader(InfoSectionCurr).
        put stream log-algo unformatted
          "MTTH  = " string(MTTH) {&new-line}
          "MF  = " string(MF) {&new-line}
          "dF  = " string(dF) {&new-line}
          "NPE  = " string(NPE) {&new-line}
          "dmd  = " string(dmd) {&new-line}
          "dMP  = " string(dMP) {&new-line}
          "dMEd  = " string(dMEd) {&new-line}
          "ME = " string(ME) {&new-line}
          "MKP = " string(MKP) {&new-line}
          "dMKP = " string(dMKP) {&new-line}
          "dmKPd = " string(dmKPd) {&new-line}
          "delKP = " string(delKP) {&new-line}
          "delTTH = " string(delTTH) {&new-line}
          "dTTH = " string(dTTH) {&new-line}
          "dKP = " string(dKP) {&new-line}
          "MKPK = " string(MKPK) {&new-line}
          "dmTTHd = " string(dmTTHd) {&new-line}
          "X1 = " string(X1) {&new-line}
          "X2 = " string(X2) {&new-line}
          "X3 = " string(X3) {&new-line}
          "X4 = " string(X4) {&new-line}
          "MP = " string(MP) {&new-line}
          "I = " string(I) {&new-line}
          "H = " string(H) {&new-line}
        .
        output stream log-algo close.
        return.
      end.

    end.

    if not ( abs (dmKP) <= delTTH + delKP ) /* условие (32)*/ and MTTH > MKP /* условие (44) */
    then do:
      ME = dMEd.
      MP = MKP + delKP.
      H = MTTH - MKP - delKP - ME.
      InfoSectionCurr:AccAbsFact = delTTH + delKP.
      InfoSectionCurr:NaturalLoss = ME.
      InfoSectionCurr:Deficit = H.
      InfoSectionCurr:RnAlgo =  "нет условие 32 и условие 44".
      output stream log-algo to value ("log-algo-pomi.txt") append.
      putheader(InfoSectionCurr).
      put stream log-algo unformatted
        "MTTH  = " string(MTTH) {&new-line}
        "MF  = " string(MF) {&new-line}
        "dF  = " string(dF) {&new-line}
        "NPE  = " string(NPE) {&new-line}
        "dmd  = " string(dmd) {&new-line}
        "dMP  = " string(dMP) {&new-line}
        "dMEd  = " string(dMEd) {&new-line}
        "ME = " string(ME) {&new-line}
        "MKP = " string(MKP) {&new-line}
        "dMKP = " string(dMKP) {&new-line}
        "dmKPd = " string(dmKPd) {&new-line}
        "delKP = " string(delKP) {&new-line}
        "delTTH = " string(delTTH) {&new-line}
        "dTTH = " string(dTTH) {&new-line}
        "dKP = " string(dKP) {&new-line}
        "MKPK = " string(MKPK) {&new-line}
        "dmTTHd = " string(dmTTHd) {&new-line}
        "X1 = " string(X1) {&new-line}
        "X2 = " string(X2) {&new-line}
        "X3 = " string(X3) {&new-line}
        "X4 = " string(X4) {&new-line}
        "MP = " string(MP) {&new-line}
        "I = " string(I) {&new-line}
        "H = " string(H) {&new-line}
      .
      output stream log-algo close.
      return.
    end.

    finally:
      
      find first ub.place no-lock where ub.place.obj-type = ObjType and ub.place.obj-code = ObjCode and ub.place.loc1 = InfoSectionCurr:ListTank no-error. 
      if available (ub.place)
      then do:
        assign
          Parnl:ObjType = ObjType 
          Parnl:ObjCode = ObjCode
          Parnl:GdsCode = GdsCode
          Parnl:AutoNum = CarNum
          Parnl:OnDate = buf_trn.doc-date
        .
        
        Parnl:PlCode = ub.place.pl-code no-error.
        release ub.place.
        Parnl:SecNum = InfoSectionCurr:SectionName.
        NLStorage:getNormLoss(Parnl).
        InfoSectionCurr:TPNormAuto = Parnl:AutoNormLoss.
        InfoSectionCurr:TPNormPL = (InfoSectionCurr:TankWeight / 1000 * ParNl:PLNormLoss).
        output stream log-algo to value ("log-algo-pomi.txt") append.
        put stream log-algo unformatted
          "MTP = " InfoSectionCurr:TPNorm {&new-line}
          "NHH = " string(Parnl:AutoNormLoss) {&new-line}
          "NPR = " string(Parnl:PLNormLoss) {&new-line}.
        output stream log-algo close.      
      end.
    end finally.
      
    

  end method.
  
  method public void CalcWeight ():  
      define variable ToolType                as integer no-undo.
    define variable DeltaAbs_R              as decimal no-undo.
    define variable DeltaAbs_Tv             as decimal no-undo.
    define variable DeltaAbs_Tr             as decimal no-undo.
    define variable NeckType                as integer no-undo.
    define variable Dgor                    as decimal no-undo.
    define variable NeckWidth               as decimal no-undo.
    define variable NeckHeight              as decimal no-undo.
    define variable error-string            as character no-undo.
    define variable v-mm as com-handle.
    define variable v-proc as character no-undo.
    define variable v-TankVol-m3            as decimal decimals 10 no-undo .
  /*  define buffer buf_clob-bind    for ub.clob-bind.*/
    define buffer buf_sr-izmerenia    for ub.sr-izmerenia .
/*    run save-page.*/
/*    assign        */
/*    f-car-vol     */
/*    f-tank-vol    */
/*    f-a-b-tarir   */
/*    f-size        */
/*    f-tank-temp   */
/*    f-tank-density*/
/*    f-dens-temp   */
/*    f-place-si    */
/*    .             */
  
  
    case RdcDnstvalue:
      when "pomi-rn" then do:
        _trpomi :
          do on error undo, return no-apply :
    
  
            /*данные по средству измерения резервуара для ПО МИ*/
          find first buf_sr-izmerenia no-lock where buf_sr-izmerenia.node-code = InfoSectionCurr:PlaceSi no-error.
          if not available buf_sr-izmerenia then do :
            message
              substitute( 'Не найдено средство измерения с кодом &1', InfoSectionCurr:PlaceSi ) skip
            view-as alert-box error.
            undo _trpomi, return no-apply  .
          end.
          else do :
            assign
              ToolType               = buf_sr-izmerenia.sr-type
              DeltaAbs_R             = buf_sr-izmerenia.sr-abs-err-dens
              DeltaAbs_Tv            = buf_sr-izmerenia.sr-abs-err-temp-vol
              DeltaAbs_Tr            = buf_sr-izmerenia.sr-abs-err-temp-dens
              .
          end.
          /*..........................................*/
          v-proc = "Rosneft.MethodOfMetering31" .
    
          release object v-mm no-error.
          v-mm = ?.
    
          create value("Rosneft.MethodOfMetering31") v-mm no-error.
          if error-status:error
          or not VALID-HANDLE(v-mm)
          then do:
            release object v-mm no-error.
            v-mm = ?.
            message
              substitute( 'Не удается подключиться к COM-серверу библиотеки для работы с ПО МИ ' ) skip
            view-as alert-box error.
            undo _trpomi, return no-apply .
          end.
          else do :
            if InfoSectionCurr:CarVol = ? or InfoSectionCurr:CarVol = 0 then do :
              message
                "Заполнены не все поля, необходимые " skip
                "для работы библиотеки ПО МИ"         skip
                "Введите Объем по паспорту в литрах"  skip
              view-as alert-box error.
/*              apply "entry" to f-car-vol in frame {&frame-name} .*/
/*              undo _trpomi, return no-apply  .*/
            end.
            
            if InfoSectionCurr:ABTarir = ? then do :
              message
                "Заполнены не все поля, необходимые " skip
                "для работы библиотеки ПО МИ"         skip
                "Введите Уровень цистерны относительно тарировочной планки"  skip
              view-as alert-box error.
/*              apply "entry" to f-a-b-tarir in frame {&frame-name} .*/
/*              undo _trpomi, return no-apply  .                     */
            end.
/*              assign                                         */
/*              f-size              = string (decimal (f-size))*/
/*              f-size:screen-value = string (decimal (f-size))*/
/*              no-error.                                      */
            if error-status:error then 
            do:
              assign
                NeckType = 1
                NeckWidth = decimal (entry (1,InfoSectionCurr:Diameter, "/")) 
                NeckHeight = decimal (entry (2,InfoSectionCurr:Diameter, "/"))
                Dgor = 0
                no-error.
            end.
            else do: 
            assign 
              NeckType = 0 
              Dgor = decimal (InfoSectionCurr:Diameter).
            end.  
            if InfoSectionCurr:Diameter = ? or InfoSectionCurr:Diameter = "0" then do :
              message
                "Заполнены не все поля, необходимые " skip
                "для работы библиотеки ПО МИ"         skip
                "Введите Внутренний диаметр горловины"  skip
              view-as alert-box error.
/*              apply "entry" to f-size in frame {&frame-name} .*/
/*              undo _trpomi, return no-apply  .                */
            end.
            if InfoSectionCurr:TankTemp = ? then do :
              message
                "Заполнены не все поля, необходимые " skip
                "для работы библиотеки ПО МИ"         skip
                "Введите Температуру"  skip
              view-as alert-box error.
/*              apply "entry" to f-tank-temp in frame {&frame-name} .*/
/*              undo _trpomi, return no-apply  .                     */
            end.
            if InfoSectionCurr:TankDensity = ? or InfoSectionCurr:TankDensity = 0 then do :
              message
                "Заполнены не все поля, необходимые " skip
                "для работы библиотеки ПО МИ"         skip
                "Введите Плотность топлива для ПО МИ"  skip
              view-as alert-box error.
/*              apply "entry" to f-tank-density in frame {&frame-name} .*/
/*              undo _trpomi, return no-apply  .                        */
            end.
            v-TankVol-m3 = (InfoSectionCurr:CarVol / 1000) .
            assign
              v-mm:V_real                 = v-TankVol-m3
              v-mm:DeltaH                 = InfoSectionCurr:ABTarir
              v-mm:Dgor                   = Dgor
              v-mm:NeckType               = NeckType 
              v-mm:NeckWidth              = NeckWidth  
              v-mm:NeckHeight             = NeckHeight  
              v-mm:Tv                     = InfoSectionCurr:TankTemp
              v-mm:Tr                     = InfoSectionCurr:DensTemp
              v-mm:R                      = ( InfoSectionCurr:TankDensity * 1000 )
              v-mm:Tcy                    = TempForPomi
              v-mm:ToolType               = ToolType
              v-mm:A_Reservoir            = 0.0000125
              v-mm:DeltaOtn_V             = 0.4
              v-mm:DeltaAbs_R             = DeltaAbs_R
              v-mm:DeltaAbs_Tv            = DeltaAbs_Tv
              v-mm:DeltaAbs_Tr            = DeltaAbs_Tr
            .
            v-mm:Exec() .
            output stream outstream to value ("pomi.log") append.
            put stream outstream unformatted
              {&new-line}
              "-----------------------------------------------"
              {&new-line}
                                         now                     skip
              'Номер документа:'         TrnDocNum              skip
              'Секция:'                  InfoSectionCurr:SectionName         skip
              'Процедура'                v-proc                  skip
              'V_real                 =' v-TankVol-m3 skip
              'DeltaH                 =' InfoSectionCurr:ABTarir skip
              'Dgor                   =' Dgor                    skip
              'NeckType               =' NeckType                skip 
              'NeckWidth              =' NeckWidth               skip
              'NeckHeight             =' NeckHeight              skip
              'Tv                     =' InfoSectionCurr:TankTemp             skip
              'Tr                     =' InfoSectionCurr:DensTemp             skip
              'R                      =' ( InfoSectionCurr:TankDensity * 1000 ) skip
              'Tcy                    =' TempForPomi           skip
              'ToolType               =' ToolType                skip
              'A_Reservoir            =' string (0.0000125)      skip
              'DeltaOtn_V             =' 0.4                     skip
              'DeltaAbs_R             =' DeltaAbs_R              skip
              'DeltaAbs_Tv            =' DeltaAbs_Tv             skip
              'DeltaAbs_Tr            =' DeltaAbs_Tr             skip
              'Vcy                    =' v-mm:Vcy               skip 
              'Rcy                    =' v-mm:Rcy               skip
              'V                      =' v-mm:V                 skip
              'CTL_base_alt           =' v-mm:CTL_base_alt      skip 
              'CPL_base_alt           =' v-mm:CPL_base_alt      skip 
              'CTPL_base_alt          =' v-mm:CTPL_base_alt     skip
              'Fp_base_alt            =' v-mm:Fp_base_alt       skip
              'CTL_obs_base           =' v-mm:CTL_obs_base      skip
              'CPL_obs_base           =' v-mm:CPL_obs_base      skip
              'CTPL_obs_base          =' v-mm:CTPL_obs_base     skip
              'Fp_obs_base            =' v-mm:Fp_obs_base       skip
              'Rv                     =' v-mm:Rv                skip
              'DeltaOtn_Vcy           =' v-mm:DeltaOtn_Vcy      skip 
              'M                      =' v-mm:M                 skip
              'Mcy                    =' v-mm:Mcy               skip
              'DeltaOtn_M             =' v-mm:DeltaOtn_M        skip
            .
            output stream outstream close.
            if v-mm:Result <> 0 then do :
              error-string = v-mm:ResultDetail .
              output stream outstream to value ("pomi.log") append.
                put stream outstream error-string format "x(1024)" skip.
              output stream outstream close.
              release object v-mm no-error.
              v-mm = ?.
              message
                substitute('Ошибка работы библиотеки ПО МИ &1',error-string) skip
              view-as alert-box error.
              undo _trpomi, return no-apply  .
            end.
            else do :
              assign
                InfoSectionCurr:TankDensityPomi    = decimal(v-mm:Rcy) / 1000
                InfoSectionCurr:TankVolPomi        = v-mm:Vcy * 1000 
                InfoSectionCurr:TankWeight     = v-mm:Mcy * 1000
                InfoSectionCurr:AccPomi = round (v-mm:DeltaOtn_M, 3)
              .
/*              display                  */
/*                f-tank-density-pomi    */
/*                f-tank-vol-pomi        */
/*                f-tank-weight          */
/*                f-acc-weight           */
/*              with frame {&frame-name}.*/
              output stream outstream to value ("pomi.log") append.
                put stream outstream
                "v-mm:Rcy" InfoSectionCurr:TankDensityPomi       skip
                "v-mm:Vcy" InfoSectionCurr:TankVolPomi           skip
                "v-mm:Mcy" InfoSectionCurr:TankWeight            skip 
                "v-mm:v-mm:DeltaOtn_M" InfoSectionCurr:AccPomi skip .
              output stream outstream close.
              release object v-mm no-error.
              v-mm = ?.
            end.
          end.
        end.
      end.
      when "th" then do:
          
          def var v-tank-density-pomi as decimal no-undo.
          def var v-tank-vol-pomi as decimal no-undo.
          
          if lookup (FuelType, "petrol,diesel-sum,diesel-wint") > 0
          then do:
            message
              substitute('Ошибка определения типа топлива &1 или не верный тип товлива &2', return-value, FuelType) 
            view-as alert-box error.
            undo, return error return-value .
          end.
          
          run str/rdcdnst.p (input InfoSectionCurr:TankDensityPomi * 1000
                        ,input InfoSectionCurr:DensTemp
                        ,input InfoSectionCurr:TankVol
                        ,input InfoSectionCurr:TankTemp
                        ,input FuelType
                        ,output v-tank-density-pomi 
                        ,output v-tank-vol-pomi)
          no-error.
          if not error-status:error then do:
            InfoSectionCurr:TankDensityPomi = v-tank-density-pomi.
            InfoSectionCurr:TankVolPomi = v-tank-vol-pomi.
            InfoSectionCurr:TankWeight = InfoSectionCurr:TankDensityPomi * InfoSectionCurr:TankVolPomi . 
            
/*            display                  */
/*              f-tank-vol-pomi        */
/*              f-tank-density-pomi    */
/*              f-tank-weight          */
/*            with frame {&frame-name}.*/

          end.
          else do:
            message
              substitute('Ошибка при рассчете приведенных значений плотности и объема: &1', return-value) 
            view-as alert-box error.
            undo, return no-apply  .
          end.
      end.
      when "manual" then do:
        InfoSectionCurr:TankWeight = InfoSectionCurr:TankDensityPomi * InfoSectionCurr:TankVolPomi . 
      end.
      
      
    end case.
    
    
    def var dMP  as decimal no-undo.
    def var MF   as decimal no-undo.
    def var dMF  as decimal no-undo.
    def var MTTH as decimal no-undo.
    def var md   as decimal no-undo.
    def var dmd  as decimal no-undo.
    def var dF   as decimal no-undo.
    def var NPE  as decimal no-undo.
    def var ME   as decimal no-undo.
    def var dMEd as decimal no-undo.
    
    assign
      MTTH = InfoSectionCurr:DocQnty * InfoSectionCurr:DocDensity
      MF = InfoSectionCurr:TankWeight
      dF = InfoSectionCurr:AccPomi
      NPE = NormalWastage
      dmd = MF * dF * 0.01
      dMP = MF - MTTH
      dMEd = MTTH * NPE * 0.001.
      ME = MTTH - MF - dmd.
    .
    if abs(dMP) > dmd + dMed
    then do:
      ME = dMEd.
    end.
    if ME > 0
      then InfoSectionCurr:NaturalLoss = ME.
    
    find first ub.place no-lock where ub.place.obj-type = ObjType and ub.place.obj-code = ObjCode and ub.place.loc1 = InfoSectionCurr:ListTank no-error. 
    if available (ub.place)
    then do:
      assign
        Parnl:ObjType = ObjType 
        Parnl:ObjCode = ObjCode
        Parnl:GdsCode = GdsCode
        Parnl:AutoNum = CarNum
        Parnl:OnDate = buf_trn.doc-date
      .
      
      Parnl:PlCode = ub.place.pl-code no-error.
      release ub.place.
      Parnl:SecNum = InfoSectionCurr:SectionName.
      NLStorage:getNormLoss(Parnl).
      InfoSectionCurr:TPNormAuto = Parnl:AutoNormLoss.
      InfoSectionCurr:TPNormPL = (InfoSectionCurr:TankWeight / 1000 * ParNl:PLNormLoss).
/*      output stream log-algo to value ("log-algo-pomi.txt") append.*/
      output stream outstream to value ("pomi.log") append.
      put stream outstream unformatted
        "MTP = " InfoSectionCurr:TPNorm {&new-line}
        "NHH = " string(Parnl:AutoNormLoss) {&new-line}
        "NPR = " string(Parnl:PLNormLoss) {&new-line}.
      output stream outstream close.
    end.

  
  
  end.
  
  method public logical CheckNameSec (arg1 as int, arg2 as char): /*проверка на совпадения названия секция по все линиям накладной*/
      
      def var ii as int no-undo.
      
      do ii = 1 to this-object:SectionNum:
        this-object:GetInfoSectionProp(ii).
        if this-object:idSecCurr = arg1
          then next.
        if  trim (arg2) <> "" and trim (this-object:InfoSectionCurr:SectionName) = trim (arg2)
        then do:
          return false.
        end. 
      end.
      
      return not can-find (first buf_doc-line-attr no-lock where
            buf_doc-line-attr.doc-code = TrnDocNum
        and buf_doc-line-attr.gds-code <> GdsCode
        and buf_doc-line-attr.attr-code begins "section-name" 
        and trim (arg2) = trim (buf_doc-line-attr.attr-value)).
    
  end.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public InfoSectionsTotal ( ):

    clearObj().

  end destructor.


end class.