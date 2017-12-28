
/*------------------------------------------------------------------------
    File        : iexpsubject
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Sat Oct 21 19:11:39 MSK 2017
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface ibs.th.bge.1crn.subjects.iexpsubject:

  define property Msg as character no-undo
    get.

  define property InitSecTag as character no-undo
    get.

  method public void CrContentToSW (sw as handle).
  
end interface.