 
 /*------------------------------------------------------------------------
    File        : paramCol
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sun Jan 08 01:12:48 MSK 2023
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Ibs.Th.Gbl.TypeMap.
using ibs.th.gbl.propmap.
block-level on error undo, throw.

class ibs.th.gbl.collection.paramCol inherits TypeMap: 
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
      
   constructor public paramCol (  ):
      super ().
      Unknow:Label_ = ?.
   end constructor.

   destructor public paramCol ( ):

   end destructor.
   
   define variable countParam as integer no-undo.
   
   method public void setParam(iName as character, iValue as char):
      define variable vParam as class propmap no-undo.
      vparam = GetProp(iName).
      if vParam eq Unknow
      then do:
         countParam = countParam + 1.
         crProp(countParam, iName, iValue).
      end.
      else
         vParam:Label_ = iValue.
   end.
   
   method public character getParamValue (iName as char):
      return GetLabel(iName).
   end.
   
end class.