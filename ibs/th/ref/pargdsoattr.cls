 
/*------------------------------------------------------------------------
   File        : pargdsoattr
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Wed Oct 10 23:20:50 MSK 2018
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.


class ibs.th.ref.pargdsoattr:
  
  define property GdsCode  as integer      no-undo get. set.
  define property ObjType  as character    no-undo get. set.
  define property ObjCode  as integer      no-undo get. set.
  define property OnDate   as date         init ? no-undo get. set. 

end class.