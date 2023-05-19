/*
  $Revision:$
  $Author:$
  $Date:$
  $Workfile:$
  $Archive:$
  
  Автор: Рубан Дмитрий Андреевич 
  Дата создания: 9 янв. 2023 г.
  Author:  Ruban Dmitriy Andreevich
  Creation date: 9 янв. 2023 г.
  
  */

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.

class ibs.th.gbl.env.conf.markingtype inherits objth. 
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "Настрока для типов маркировки" get.
   
  
  define public property ConfVal as character initial "" no-undo 
    get.
    private set.

  constructor public markingtype ( conf_val as char ):
    super().
    ConfVal = conf_val.
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical GetValForType(arg as char):

    if     arg     ne ? and arg     ne ""
       and ConfVal ne ? and ConfVal ne ""
       and lookup (arg, ConfVal) > 0
      then return true.
      else return false.

  end method.  
  
  
  
end class.