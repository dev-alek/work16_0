 
/*------------------------------------------------------------------------
   File        : 
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Tue Sep 29 15:51:19 MSK 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.str.*.



class ibs.th.str.InfoSectionsTotal: 

{ cmp/str-glbl.i class}

  define private buffer buf_doc-line  for ub.doc-line.
  define private buffer buf_doc-line-attr for ub.doc-line-attr.
  define private buffer buf_goods  for ub.goods.

  define private temp-table ttObjInfoSecProp no-undo
    field iSecNum as integer
    field objInfoSecProp as class Progress.Lang.Object
    index pi is primary unique iSecNum .

  define property TrnDocNum as character no-undo
    get.
    private set.

  define property GdsCode as integer no-undo
    get.
    private set.

  define property FlagTrn as logical no-undo
    get.
    set.

  define property SectionNum as integer no-undo
    get.
    private set.

  define property InfoSectionProp as class InfoSection no-undo
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

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  method public void Initialization (inTrnDocNum as char, inGdsCode as int):
    
    assign
      TrnDocNum = inTrnDocNum
      GdsCode = inGdsCode
    .
		
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

      InfoSectionProp = new InfoSection().
      
      for each buf_doc-line-attr where buf_doc-line-attr.doc-code = TrnDocNum 
        and buf_doc-line-attr.gds-code = GdsCode
        and not buf_doc-line-attr.attr-code = "n" 
        and (SectionNum = 1 or (num-entries (buf_doc-line-attr.attr-code, {&delim-par}) > 1 and (entry (2, buf_doc-line-attr.attr-code, {&delim-par})) = string (ii) and SectionNum > 1)):
        
        def var attrCode as char no-undo.
        assign
          attrCode = entry (1, buf_doc-line-attr.attr-code, {&delim-par}) no-error.
        if error-status:error then next.
        
        InfoSectionProp:SetProp (attrCode, buf_doc-line-attr.attr-value).

      end.

      if SectionNum = 1
      then do:
        find first buf_goods no-lock where buf_goods.gds-code = GdsCode. 
        find first buf_doc-line no-lock where
                                   buf_doc-line.doc-code = TrnDocNum 
                               and buf_goods.artic= buf_doc-line.artic
                               and buf_goods.prod-code = buf_doc-line.prod-code
                               and buf_goods.prod-type = buf_doc-line.prod-type no-error.
        if available (buf_doc-line) then 
          assign
            InfoSectionProp:CliQnty = buf_doc-line.cli-qnty
            InfoSectionProp:FactQnty = buf_doc-line.fact-qnty
            InfoSectionProp:DocDensity = buf_doc-line.doc-density
            InfoSectionProp:DocQnty = buf_doc-line.doc-qnty
            InfoSectionProp:FactDensity = buf_doc-line.fact-density
            InfoSectionProp:FactKgQnty = buf_doc-line.fact-density * buf_doc-line.fact-qnty
          .
      end.
      
      create ttObjInfoSecProp.
      assign
        ttObjInfoSecProp.iSecNum = ii 
        ttObjInfoSecProp.objInfoSecProp = cast (InfoSectionProp, Progress.Lang.Object).
      
    end.
    CalculateTotal ().


  end method.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void NewSection(  ):
    
    InfoSectionProp = new InfoSection().
    assign 
      SectionNum = SectionNum + 1.
    create ttObjInfoSecProp.
    assign
      ttObjInfoSecProp.iSecNum = SectionNum
      ttObjInfoSecProp.objInfoSecProp = InfoSectionProp
    .

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public class InfoSection GetInfoSectionProp (inSecNum as integer):
    
    for first ttObjInfoSecProp where ttObjInfoSecProp.iSecNum = inSecNum:
      return cast ( ttObjInfoSecProp.objInfoSecProp, InfoSection ).
    end.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void DeleteSection( inNum as int  ):
    
    def var ii as integer no-undo.
    
    find first ttObjInfoSecProp where ttObjInfoSecProp.iSecNum = inNum.
    delete object ttObjInfoSecProp.objInfoSecProp.
    delete ttObjInfoSecProp.
    ii = 0.
    for each ttObjInfoSecProp use-index pi:
      assign
        ii = ii + 1
        ttObjInfoSecProp.iSecNum = ii.
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
    .
    do ii = 1 to SectionNum :
      assign
        GetInfoSectionProp(ii):CliQnty = GetInfoSectionProp(ii):DocDensity * GetInfoSectionProp(ii):DocQnty
        CarVolTotal = GetInfoSectionProp(ii):CarVol + CarVolTotal
        TankVolTotal = GetInfoSectionProp(ii):TankVol + TankVolTotal
        TankWaterVolTotal = GetInfoSectionProp(ii):TankWater + TankWaterVolTotal
        TankWeightTotal = GetInfoSectionProp(ii):TankWeight + TankWeightTotal
        DocQntyTotal = GetInfoSectionProp(ii):DocQnty + DocQntyTotal
        FactQntyTotal = GetInfoSectionProp(ii):FactQnty + FactQntyTotal
        FactKgQntyTotal = GetInfoSectionProp(ii):FactKgQnty + FactKgQntyTotal
      .
      CliQntyTotal = GetInfoSectionProp(ii):CliQnty + CliQntyTotal.
      if StartRealDate = ? or datetime (GetInfoSectionProp(ii):DateStart, GetInfoSectionProp(ii):TimeStart) < datetime (StartRealDate, StartRealTime) 
      then do:
        assign
          StartRealTime = GetInfoSectionProp(ii):TimeStart
          StartRealDate = GetInfoSectionProp(ii):DateStart
        .
      end.
      if EndRealDate = ? or datetime (GetInfoSectionProp(ii):DateEnd, GetInfoSectionProp(ii):TimeEnd) > datetime (EndRealDate, EndRealTime)
      then do:
        assign
          EndRealTime = GetInfoSectionProp(ii):TimeEnd
          EndRealDate = GetInfoSectionProp(ii):DateEnd
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
      return error substitute ("Ћини€ по накладной не существует. Ќе возможно сохранить в базу данных данные по секци€м дл€ накладной &1 товар артикул &2 произовдитель &3&4", TrnDocNum, buf_goods.artic, buf_goods.prod-type, buf_goods.prod-code).                             
    end.
                           

    create buf_doc-line-attr.
    assign
      buf_doc-line-attr.doc-code = TrnDocNum
      buf_doc-line-attr.gds-code = GdsCode
      buf_doc-line-attr.attr-code = "n"
      buf_doc-line-attr.attr-value = string (SectionNum)
    .
    
    do ii = 1 to SectionNum:
      
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'car-vol' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (GetInfoSectionProp(ii):CarVol).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tests' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (GetInfoSectionProp(ii):Tests).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'certif-fuel' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = GetInfoSectionProp(ii):CertifFuel.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'norm-doc' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = GetInfoSectionProp(ii):NormDoc.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'num-passport' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = GetInfoSectionProp(ii):NumPassport.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'validity-certif' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = GetInfoSectionProp(ii):ValidityCertif.      
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'passport-plotn' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = GetInfoSectionProp(ii):PassportPlotn.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'place-si' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (GetInfoSectionProp(ii):PlaceSi).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'date-pov-plotn' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (GetInfoSectionProp(ii):DatePovPlotn).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'num-plotn' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = GetInfoSectionProp(ii):NumPlotn.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'date-start' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string (GetInfoSectionProp(ii):DateStart).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'time-start' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TimeStart ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'date-end' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):DateEnd ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'time-end' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TimeEnd ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-vol' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TankVol ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-temp' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TankTemp ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-water' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TankWater ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-density' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TankDensity ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-weight' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TankWeight ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'mouth' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):Mouth ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'a-b-tarir' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):ABTarir ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'diameter' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):Diameter ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-density-pomi' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TankDensityPomi ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'tank-vol-pomi' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):TankVolPomi ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'dens-temp' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):DensTemp ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'section-name' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = GetInfoSectionProp(ii):SectionName.
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'doc-qnty' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):DocQnty ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'doc-dens' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):DocDensity ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'fact-dens' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):FactDensity ).
      create buf_doc-line-attr.
      assign
        buf_doc-line-attr.doc-code = TrnDocNum
        buf_doc-line-attr.gds-code = GdsCode
        buf_doc-line-attr.attr-code = 'fact-qnty' + if SectionNum > 1 then {&delim-par} + string (ii) else "".
      buf_doc-line-attr.attr-value = string ( GetInfoSectionProp(ii):FactQnty).

    end.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public InfoSectionsTotal ( ):

    clearObj().

  end destructor.



end class.