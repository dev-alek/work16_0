 
 /*------------------------------------------------------------------------
    File        : objth
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Wed Feb 12 16:56:20 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objsrv.


class ibs.th.gbl.sys.objth: 
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  
  { gbl/objsrv.i def}
  
  constructor protected objth ():
/*    message "1" view-as alert-box.*/
    getobjserv().
/*    message string (ObjSrv) "2" view-as alert-box.*/
    if valid-object (ObjSrv)
      then ObjSrv:Regobj(this-object).
/*    message "Рождается objth" view-as alert-box.*/
  end constructor.

  destructor public objth (  ):
    getobjserv().
    if valid-object (ObjSrv)
      then ObjSrv:Delobj(this-object).
/*    message "Умирает objth" view-as alert-box.*/
  end destructor.

  method public void getobjserv():
    { gbl/objsrv.i get}
  end method.

end class.