 
 /*------------------------------------------------------------------------
    File        : systemseting
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Tue Feb 22 00:07:11 MSK 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

class ibs.th.gbl.systemsetting:
   define variable vss-revision    as character no-undo init "$Revision:$":U .
   define variable vss-author      as character no-undo init "$Author:$":U .
   define variable vss-date        as character no-undo init "$Date:$":U .
   define variable vss-workfile    as character no-undo init "$Workfile:$":U .
   define variable vss-archive     as character no-undo init "$Archive:$":U .
   define variable vss-description as character no-undo init "".
    
   { cmp/str-glbl.i class }  
   { GBL/xmldom.i   class }
   { cmp/library.i class }
   define public property PumpTxtRead as logical no-undo 
   get.
   private set.
    
   define public property GetCashCurl as logical no-undo 
   get.
   private set.
    
   define public property DeveloperMode as logical no-undo 
   get.
   private set.
    
   define public property CrLogin as character no-undo 
   get.
   private set.
    
   define public property CrPswd as character no-undo 
   get.
   private set.
   
   define public property SystemKey as character no-undo 
   get.
   private set.
   
   
   constructor public systemsetting (input ikey as character ):
      define variable vFilesetting as character no-undo.
      define variable vFound as logical no-undo.
      define variable vText as character no-undo.
      { gbl/currsysk.i
      SystemKey
      no-error
   }
 
      vFilesetting = SearchFile("ibs/th/gbl/systemsetting.xml").
      if      vFileSetting ne ?
          and (   ikey + {utlcomp/keypriv.i} eq { utlcomp/keyset.i }
               or SystemKey eq 'IBS')    
      then do:
         
         xmldom-load(vFileSetting).
         xmldom-read-unique("settings","PumpTxtRead",output vText, output vFound).
         PumpTxtRead = logical(vText)no-error.
         xmldom-read-unique("settings","GetCashCurl",output vText, output vFound).
         GetCashCurl = logical(vText)no-error.
         xmldom-read-unique("settings","DeveloperMode",output vText, output vFound).
         DeveloperMode = logical(vText)no-error.
         xmldom-read-unique("settings","CrLogin",output CrLogin, output vFound).
         xmldom-read-unique("settings","CrPswd" ,output CrPswd , output vFound).
      end.
   end constructor.
  
    
    { utl/search.i class }
end class.