 
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
using ibs.th.gbl.systemsetting.


class ibs.th.gbl.sys.objsrv:
  
  define temp-table tt-objth no-undo
    field iNum      as integer
    field objhndl   as Progress.Lang.Object
    field objname   as character
    field objparent as character
    
    .
  &glob GlobObjSrv yes
  define public property Env as class env no-undo
    get.
    private set.

  define public property Lib as class lib no-undo
    get.
    private set.

  define public property SystemSetting as class systemsetting no-undo
    get.
    private set.

  define public property SysLog as class logger no-undo
    get.
    private set.
  
  define private variable out as class putout no-undo.
  
  define property SysINI as class ini no-undo
    get.
    private set. 
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/


  constructor public objsrv (  ):
    super ().
    SysLog = new logger (out). 
    SysLog:EventHndlr("Родился objsrv").
  end constructor.
  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void Initialization(  ):
    {utl\objreg.i SysINI ini}
    {utl\objreg.i out putout "SysINI:SystemLogFileName:Value_" }
    {utl\objreg.i Env env }
    {utl\objreg.i Lib lib}.
    define variable vtext as character no-undo.
    vtext = {utlcomp/keypub.i}.
    {utl\objreg.i SystemSetting systemsetting vtext}.
    return.
  end method.

  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
  method public void Regobj( iobj as Progress.Lang.Object ):
    define variable IdObj as character  no-undo.
    
    if valid-object (iobj)
      then 
    do:
       IdObj = iobj:ToString().
       find first tt-objth where tt-objth.objname eq IdObj no-error.
       if not available tt-objth
       then do:
          create tt-objth.
          assign
             tt-objth.objname = IdObj
             tt-objth.objhndl = iobj
             tt-objth.objparent = cast (this-object, Progress.Lang.Object):ToString()
          .
       end.
      SysLog:EventHndlr("Зарегистрирован - " + iobj:ToString()).
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
    DelobjChild(obj:ToString()).
    find first tt-objth where tt-objth.objname = obj:ToString() no-error.
    if not available (tt-objth)
    then do:
      SysLog:EventHndlr("Че то не то - " + obj:ToString()).
    end.
    else do:
       SysLog:EventHndlr("Разрегистрирован - " + obj:ToString()).
       delete tt-objth.
    end.
    
    return.

  end method.

method public void DelobjChild( iParent as character  ):
    define buffer tt-objth for tt-objth.
    /*    find first tt-objth exclusive-lock where tt-objth.objhndl = integer(obj).*/
    /*    delete tt-objth.                                                         */
    /*    message "Разрегистрация" view-as alert-box.*/
    find first tt-objth where tt-objth.objparent = iParent no-error.
    do while  available  tt-objth:
       DelobjChild(tt-objth.objname).
       delete object tt-objth.objhndl no-error.
       if avail tt-objth then delete tt-objth. /* если не УДАЛИМ В В DELOBJ */
       find first tt-objth where tt-objth.objparent = iParent no-error.
    
    end.    
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

  method public void Regobj(iobjparen as Progress.Lang.Object, iobj as Progress.Lang.Object ):
    define variable IdObj as character  no-undo.
    if valid-object (iobj)
    then do:
       IdObj = iobj:ToString().
       find first tt-objth where tt-objth.objname eq IdObj no-error.
       if not available tt-objth
       then do:
          create tt-objth.
          assign
             tt-objth.objname = IdObj
             tt-objth.objhndl = iobj
          .
       end.
       tt-objth.objparent = iobjparen:ToString().
       SysLog:EventHndlr("Зарегистрирован - " + IdObj).
    end.

    return.

  end method.
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
    delobj(this-object).
    
    /* удалим все ссылки на объекты, а то при отключении от базы будет беда */
    for each tt-objth where tt-objth.objname ne SysLog:ToString() :
       SysLog:EventHndlr("Забыли удалить " + tt-objth.objname) .
/*       message "Забыли удалить " + tt-objth.objname       view-as alert-box.*/
       delete tt-objth.
    end.
    delete object SysLog no-error.
  end destructor.

  method public void GetTable(input-output table for tt-objth):
    
    

  end method.

  method public void Dispose ():
    
    delete object Lib:MarkingTree no-error.

  end method.
  

end class.
