 
 /*------------------------------------------------------------------------
    File        : markingtype
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Mar 30 14:11:07 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.


class ibs.th.gbl.env.conf.markingtype inherits objth. 

  define public property Shoes as logical initial false no-undo 
    get.
    private set. 

  define public property Perfume as logical initial false no-undo 
    get.
    private set. 

  define public property Industry as logical initial false no-undo 
    get.
    private set. 

  define public property Tires as logical initial false no-undo 
    get.
    private set. 
    
  define public property Apteka as logical initial false no-undo 
    get.
    private set. 
    
  define public property Photo as logical initial false no-undo 
    get.
    private set. 

  define public property Tabak as logical initial false no-undo 
    get.
    private set.      

  define public property NotType as logical initial false no-undo 
    get.
    private set.

  define public property ConfVal as character initial "" no-undo 
    get.
    private set.

  define public property IsMarking as logical initial false no-undo 
    get.
    private set.
      
  constructor public markingtype ( conf_val as char ):
    ConfVal = conf_val.
    if conf_val = ""
    then IsMarking = false.
    else do:
      IsMarking = true.
      case true:
        when lookup (conf_val, "not-type") > 0 then do:
          NotType = true.
        end.
        when  lookup (conf_val, "tabak") > 0 then do:
          Tabak = true.
        end.
        when  lookup (conf_val, "shoes") > 0 then do:
          Shoes = true.
        end.
        when  lookup (conf_val, "perfume") > 0 then do:
          Perfume = true.
        end.
        when  lookup (conf_val, "industry") > 0 then do:
          Industry = true.
        end.
        when  lookup (conf_val, "tires") > 0 then do:
          Tires = true.
        end.
        when  lookup (conf_val, "apteka") > 0 then do:
          Apteka = true.
        end.
        when  lookup (conf_val, "photo") > 0 then do:
          Photo = true.
        end.
        otherwise do:
          IsMarking = false.
        end.
      end.
    end.
    
  end constructor.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical GetValForType(arg as char):

    if lookup (arg, ConfVal) > 0
      then return true.
      else return false.

  end method.  
  
  
  
end class.