/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 
Объект подаркок акции

Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: 
Creation date: 11/07/18

*/
 
using Progress.Lang.*.
using ibs.th.gbl.storage.*.
using ibs.th.gbl.*.



class ibs.th.ref.promo.PromoGiftSub implements ithsub: 
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Объект подаркок акции.". 
  
  { cmp/str-glbl.i class}
  
  define property Msg as character no-undo
    get.
    set.
    
    define property StatusErr as logical no-undo
    get:
      def var err as log no-undo.
      err = StatusErr.
      StatusErr = false.
      return err.
    end.
    private set.
    
  define property ID as int64  no-undo
    get.
    set (ID-arg as int64):
      ID = ID-arg.
/*      if ID <> ID            */
/*      then do:               */
/*        setFlagChange (true).*/
/*      end.                   */
    end.
    
  define property idCrit as int64 no-undo
    get.
    SET (arg as int64):
      if arg <> idCrit
      then do:
        idCrit = arg.
        setFlagChange (true).
      end.
    END.  
  
  define property idAction as int64 no-undo
    get.
    set(arg as int64):
      if arg <> idAction
      then do:
        idAction = arg.
        setFlagChange (true).
      end.
    END. 
  
  define property db-num as integer  no-undo
    get.
    set(arg as integer ):
      if arg <> db-num
      then do:
        db-num = arg.
        setFlagChange (true).
      end.
    end. 
  define property GdsCode as integer no-undo
    get.
    set(arg as integer):
      if arg <> GdsCode
      then do:
        GdsCode = arg.
        setFlagChange (true).
      end.
    END.
    
    define buffer bf_gds for ub.goods.
    define property GdsName as character no-undo
    get:
      if available (bf_gds)
      then do:
        return bf_gds.gds-name.
      end.
      else do:
        find first bf_gds no-lock 
          where bf_gds.gds-code = GdsCode no-error.
        if available (bf_gds)
        then do:
          return bf_gds.gds-name.
        end.
        else return "".
      end.
    end.
    
    define property qnty as dec no-undo
    get.
    set(arg as dec):
      if arg <> qnty
      then do:
        qnty = arg.
        setFlagChange (true).
      end.
    END.
    
    define property mess as char no-undo
    get.
    set(arg as char):
      if arg <> mess
      then do:
        mess = arg.
        setFlagChange (true).
      end.
    END.
    
    define property Mode as char no-undo init "{&h-update}"
    get.
    set.
    
    define property Changed as logical no-undo
    get.
    set.
    /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public promogiftsub (  ):
  end constructor.

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