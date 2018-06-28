/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сущность TH ВСД


Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/

using Progress.Lang.*.
using ibs.th.gbl.storage.*.
using ibs.th.gbl.*.
using ibs.th.str.clients.*.
using ibs.th.str.mercury.*.


class ibs.th.str.mercury.vsdsub implements ithsub: 
  
  { cmp/str-glbl.i class}
  
  define variable vsdSts as class vsdstatustype no-undo.
  define buffer bf_gdsmerc for ub.gds-mercury.

  define property Msg as character no-undo
    get.
    private set.

  define property ID as integer init ?  no-undo
    get.
    set (ID-arg as int):
      ID = ID-arg.
/*      if ID <> ID            */
/*      then do:               */
/*        setFlagChange (true).*/
/*      end.                   */
    end.
    
  define property DBNum as integer init ? no-undo
    get.
    set.  

  define property Consignee as class climercsub no-undo
    get.
    set.

  define property Consignor as class climercsub no-undo
    get.
    set.

  define property GdsMerc as class gdsmercsub no-undo
    get.
    set.

  define property GdsCode as integer no-undo
    get.
    set (arg as int):
      if arg <> GdsCode
      then do:
        GdsCode = arg.
        setFlagChange (true).
      end.
    end.

  define property GdsMercGUID as character no-undo
    get:
      if available (bf_gdsmerc)
      then do:
        return bf_gdsmerc.GUID.
      end.
      else do:
        find first bf_gdsmerc no-lock 
          where bf_gdsmerc.gds-code = GdsCode no-error.
        if available (bf_gdsmerc)
        then do:
          return bf_gdsmerc.GUID.
        end.
        else return "".
      end.
    end.
    
  define property GdsMercName as character no-undo
    get:
      if available (bf_gdsmerc)
      then do:
        return bf_gdsmerc.merc-name.
      end.
      else do:
        find first bf_gdsmerc no-lock 
          where bf_gdsmerc.gds-code = GdsCode no-error.
        if available (bf_gdsmerc)
        then do:
          return bf_gdsmerc.merc-name.
        end.
        else return "".
      end.
    end.

  define property FactDatetime as datetime-tz no-undo
    get.
    set (arg as datetime-tz):
      if arg <> FactDatetime
      then do:
        FactDatetime = arg.
        setFlagChange (true).
      end.
    end.

  define property VSDType as integer no-undo
    get.
    set (arg as int):
      if arg <> VSDType
      then do:
        VSDType = arg.
        setFlagChange (true).
      end.
    end.

  define property VSDTypeLbl as character no-undo
    get:
      return vsdSts:VSDTypeLbl( input VSDType ).
    end.

  define property ObjCode as integer no-undo
    get.
    set (arg as int):
      if arg <> ObjCode
      then do:
        ObjCode = arg.
        setFlagChange (true).
      end.
    end.  

  define property ObjType as character no-undo
    get.
    set (arg as char):
      if arg <> ObjType
      then do:
        ObjType = arg.
        setFlagChange (true).
      end.
    end.

  define property UUID as character no-undo
    get.
    set ( uuid-arg as char):
      if uuid-arg = "" or checkuuid (input-output uuid-arg)
        then do: 
          if UUID <> uuid-arg
          then do:
            UUID = uuid-arg.
            setFlagChange (true).
          end.
        end.
        else do:
          UUID = UUID.
          message Msg view-as alert-box.
          setStatusErr(true).
        end.
    end.

  define property UUIDUsr as character no-undo
    get:
      def var ii as int no-undo.
      def var str as char no-undo.
      str = string (replace (UUID, "-", "")).
      return str .
    end.


  define property EconomicSub as character no-undo
    get.
    set (arg as char):
      if arg <> EconomicSub
      then do:
        EconomicSub = arg.
        setFlagChange (true).
      end.
    end.

    
  define property DateCr as date no-undo
    get.
    set (arg as date):
      if arg <> DateCr
      then do:
        DateCr = arg.
        setFlagChange (true).
      end.
    end.
    
  define property DateOut as character no-undo
    get.
    set (arg as character):
      if arg <> DateOut
      then do:
        DateOut = arg.
        setFlagChange (true).
      end.
    end.

  define property TypeProd as character no-undo
    get.
    set (arg as char):
      if arg <> TypeProd
      then do:
        TypeProd = arg.
        setFlagChange (true).
      end.
    end.

  define property ExpiryOutDate as character no-undo
    get.
    set (arg as character):
      if arg <> ExpiryOutDate
      then do:
        ExpiryOutDate = arg.
        setFlagChange (true).
      end.
    end.

  define property ExpiryDate as character no-undo
    get.
    set (arg as character):
      if arg <> ExpiryDate
      then do:
        ExpiryDate = arg.
        setFlagChange (true).
      end.
    end.

  define property ExpiryDate2 as character no-undo
    get.
    set (arg as character):
      if arg <> ExpiryDate2
      then do:
        ExpiryDate2 = arg.
        setFlagChange (true).
      end.
    end.

  define property Qnty as decimal no-undo
    get.
    set (arg as decimal):
      if arg <> Qnty
      then do:
        Qnty = arg.
        setFlagChange (true).
      end.
    end.

  define property VsdNum as character no-undo
    get.
    set (arg as char):
      if arg <> VsdNum
      then do:
        VsdNum = arg.
        setFlagChange (true).
      end.
    end.

  define property NumPart as character no-undo
    get.
    set (arg as char):
      if arg <> NumPart
      then do:
        NumPart = arg.
        setFlagChange (true).
      end.
    end.

  define property Note as character no-undo
    get.
    set (arg as char):
      if arg <> Note
      then do:
        Note = arg.
        setFlagChange (true).
      end.
    end.

  define property MsgErr as character no-undo
    get.
    set.

  define property Status_ as integer no-undo
    get.
    set.
  
  define property StatusLbl as character no-undo
    get:
      return vsdSts:StatusLbl(Status_).
    end.
    private set.
    
  define property PendingRepayment as logical no-undo
    get:
      return vsdSts:PendingRepayment(Status_).
    end.
    private set.  

  define property PartKey as character no-undo
    get.
    set.

  define property Changed as logical no-undo
    get.
    set.
    
  define property CliType as character no-undo
    get.
    set (arg as char):
      if arg <> CliType
      then do:
        CliType = arg.
        setFlagChange (true).
      end.
    end.  

  define property CliCode as integer no-undo
    get.
    set (arg as int):
      if arg <> CliCode
      then do:
        CliCode = arg.
        setFlagChange (true).
      end.
    end.
    
  define property GdsGuid as character no-undo
    get.
    set (arg as char):
      if arg <> GdsGuid
      then do:
        GdsGuid = arg.
        setFlagChange (true).
      end.
    end.  

  define property GdsName as character no-undo
    get.
    set.
  
  define property TransportType as character no-undo
    get.
    set.
   
  define property Transport as character no-undo
    get.
    set.
      
  define property CarNum as character no-undo
    get.
    set.
  
  define property ContainerNum as character no-undo
    get.
    set.
    
  define property TrailerNum as character no-undo
    get.
    set.
        
  define property OrigCountryGuid as character no-undo
    get.
    set. 
    
  define property ProducerGuid as character no-undo
    get.
    set. 
    
  define property ProducerRole as character no-undo
    get.
    set.
    
  define property ProductGuid as character no-undo
    get.
    set.
  
  define property SubProductGuid as character no-undo
    get.
    set.
  
  define property UnitGuid as character no-undo
    get.
    set.
    
  define property CliBeGuid as character no-undo
    get.
    set.
    
  define property CliEntGuid as character no-undo
    get.
    set.
  
  define property ObjBeGuid as character no-undo
    get.
    set.
    
  define property ObjEntGuid as character no-undo
    get.
    set.
  
  define property Perishable as character no-undo
    get.
    set.

  define property TTNissueSeries as character no-undo
    get.
    set.
      
  define property TTNissueNumber as character no-undo
    get.
    set.
    
  define property TTNissueDate as character no-undo
    get.
    set.
    
  define property TTNtype as character no-undo
    get.
    set.
  
  define property TTNrelationshipType as character no-undo
    get.
    set.
    
  define property PurposeGuid as character no-undo
    get.
    set.
    
  define property CargoInspected as character no-undo
    get.
    set.
    
  define property CargoExpertized as character no-undo
    get.
    set.
    
  define property LocationProsperity as character no-undo
    get.
    set.

  define property TrnDoc as character no-undo
    get:
      def var trnDoc as character no-undo.
      trnDoc = entry (7, PartKey, {&delim-key}) no-error.
      return trnDoc. 
    end.

  define property VsdRecid as recid init ? no-undo
    get.
    set (arg as recid):
      if VsdRecid = ?
      then do:
        VsdRecid = arg.
      end.
      else do:
        message "Recid уже присвоен. Запрещено присваивать recid не из vsdstorage" view-as alert-box.
      end.
    end.  

  define property StatusErr as logical no-undo
    get:
      def var err as log no-undo.
      err = StatusErr.
      StatusErr = false.
      return err.
    end.
    private set.

  define property keyRecObj as class keyrec no-undo
    get.
    private set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public vsdsub (  ):
    prepareobj ().
  end constructor.

  method private void prepareobj ():
    vsdSts = new vsdstatustype ().
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical checkuuid( input-output uuid as character ):
    def var ii as int no-undo.
    def var err as logical no-undo.
    def var str as character no-undo.
    def var numentr as integer no-undo.
    
    numentr = num-entries (uuid, "-") no-error.
    if numentr = 8
    then do:
      do ii = 1 to numentr:
        if length (trim (entry (ii, uuid, "-"))) <> 4
          then err = true.
        str = str + trim (entry (ii, uuid, "-")).
      
        if ii = 2 or ii = 3 or ii = 4 or ii = 5
        then do:
          str = str + "-".
        end.
      end.
      uuid = str.
    end.
    
    numentr = num-entries (uuid, "-") no-error.
    
    do ii = 1 to numentr:
      
      case ii:
      when 1 then do:
        if length (trim (entry (ii, uuid, "-"))) <> 8
          then err = true.
      end.
      when 2 or when 3 or when 4 then do:
        if length (entry (ii, uuid, "-")) <> 4
          then err = true.
      end.
      when 5 then do:
        if length (entry (ii, uuid, "-")) <> 12
          then err = true.
      end.
      end case.
      

    end.
    if ii <> 6 
      then err = true. 
    if err
      then do:
        Msg = "Неверный формат UUID - " + uuid.
        return false.
      end.
    return true.
    
  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void setMsg( arg as character ):
    
    Msg = arg.
    
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void setStatusErr( arg as logical ):
    
    StatusErr = arg.
    
  end.
  
  method public void setFlagChange( arg as logical ):
    
    Changed = arg.
    
  end.


end class.