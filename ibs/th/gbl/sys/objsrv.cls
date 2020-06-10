 
/*------------------------------------------------------------------------
   File        : objsrv
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Mon Feb 10 23:38:06 MSK 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objsrv.
using ibs.th.gbl.sys.objth.
using ibs.th.gbl.env.
using ibs.th.gbl.logger.
using ibs.th.gbl.logger.putout.
using ibs.th.gbl.sys.env.ini.
using ibs.th.gbl.lib.


class ibs.th.gbl.sys.objsrv:
  
  define temp-table tt-objth no-undo
    field iNum      as integer
    field objhndl   as integer
    field objname   as character
    field objparent as integer
    .
  
  define public property Env as class env no-undo
    get.
    private set.

  define public property Lib as class lib no-undo
    get.
    private set.

  define public property SysLog as class logger no-undo
    get.
    private set.
  
  define private variable out as class putout.
  
  define property SysINI as class ini no-undo
    get.
    private set. 
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/


  constructor public objsrv (  ):
    super ().
    SysINI = new ini().
    out = new putout (SysINI:SystemLogFileName:Value_).
    SysLog = new logger (out) .
    SysLog:EventHndlr("Родился objsrv").
  end constructor.
  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void Initialization(  ):
    Env = new env().
    Lib = new lib().
    return.
  end method.

  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
  method public void Regobj( obj as Progress.Lang.Object ):
    
    if valid-object (obj)
      then 
    do:
      create tt-objth.
      assign
        tt-objth.objname = obj:ToString()
        .
      SysLog:EventHndlr("Зарегистрирован - " + obj:ToString()).
    end.

    return.

  end method.
  
  method public void Delobj( obj as Progress.Lang.Object ):
    
    /*    find first tt-objth exclusive-lock where tt-objth.objhndl = integer(obj).*/
    /*    delete tt-objth.                                                         */
    /*    message "Разрегистрация" view-as alert-box.*/
    if not valid-object (obj)
      then do:
        SysLog:EventHndlr("Че то объекта нет").
        return.
      end.
    find first tt-objth where tt-objth.objname = obj:ToString() no-error.
    if not available (tt-objth)
    then do:
      SysLog:EventHndlr("Че то не то - " + obj:ToString()).
    end.
    else SysLog:EventHndlr("Разрегистрирован - " + obj:ToString()).
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void view_(  ):
    for each tt-objth:
    /*      message valid-object (tt-objth.objhndl) tt-objth.objhndl view-as alert-box.*/
    end.
    return.

  end method.
  
  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

  /*  method public void GetBufTTCol(input-output buffer bf_tt-objth for tt-objth ):*/
  /*    for each tt-objth:                                                               */
  /*/*      message valid-object (tt-objth.objhndl) tt-objth.objhndl view-as alert-box.*/*/
  /*    end.                                                                             */
  /*    return.                                                                          */

  /*  end method.*/

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public objsrv ( ):
    def var hndl as handle no-undo.
    /*    for each tt-objth:                        */
    /*      delete object handle (tt-objth.objhndl).*/
    /*    end.                                      */
    SysLog:EventHndlr("Умирает objsrv").
  end destructor.

  method public void GetTable(input-output table for tt-objth):
    
    

  end method.

  

end class.