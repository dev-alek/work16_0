 
 /*------------------------------------------------------------------------
    File        : flagsdocline
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Thu Mar 07 21:11:56 MSK 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.*.
block-level on error undo, throw.


class ibs.th.skt.ControlledClients.flagsdocline inherits flags: 
  
  define property isEditManualFullQnty as logical no-undo /*в ручную можно установить только полное кол-во раное документарному*/
    get:
      return logical (get-bits (FlagsToInt, 1, 1)).
    end.
    set (arg as log):
      put-bits (FlagsToInt, 1, 1) = int(arg).
      isEditManualFullQnty = arg.
    end.

  define property isNotEditManualQnty as logical no-undo /*в ручную устанавливать кол-во запрещено*/
    get:
      return logical (get-bits (FlagsToInt, 2, 1)).
    end.
    set (arg as log):
      put-bits (FlagsToInt, 2, 1) = int(arg).
      isNotEditManualQnty = arg.
    end.

    define property isMarkOn as logical no-undo /*Строка с товары требующие обязательной маркировки*/
    get:
      return logical (get-bits (FlagsToInt, 3, 1)).
    end.
    set (arg as log):
      put-bits (FlagsToInt, 3, 1) = int(arg).
      isMarkOn = arg.
    end.
    
    define property isVarietalVolumeOn as logical no-undo /*Строка с товары требующие объемно сортовой учет */
    get:
      return logical (get-bits (FlagsToInt, 4, 1)).
    end.
    set (arg as log):
      put-bits (FlagsToInt, 4, 1) = int(arg).
      isVarietalVolumeOn = arg.
    end.
 


end class.
