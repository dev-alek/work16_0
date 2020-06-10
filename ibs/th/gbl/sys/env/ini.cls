 
 /*------------------------------------------------------------------------
    File        : ini
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Thu Feb 20 04:08:48 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.env.ini.section.val.


class ibs.th.gbl.sys.env.ini: 

  define public property SystemLogFileName as val no-undo 
    get.
    private set. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  constructor public ini (  ):
    super ().
    SystemLogFileName = getKeyValue("SystemTH", "SysLogFileName", "systh.log").
    
    
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method private class val getKeyValue(inSecName as char, inKeyName as char, inValueDefault as char):
    def var value_ as character no-undo.
    def var val as class val no-undo.
    get-key-value
      section inSecName
      key inKeyName
      value value_.
    val = new val().
    assign
      val:SectionName = inSecName
      val:KeyName = inKeyName
      val:Value_ = (if value_ = ? then inValueDefault else value_)
    .
    return val.

  end method.
  
  



end class.