 
 /*------------------------------------------------------------------------
    File        : exp1crn
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Sat Oct 21 19:09:27 MSK 2017
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

block-level on error undo, throw.

class ibs.th.bge.1crn.export.expsubject:
  
  define property Data as memptr no-undo
    get.
    private set.
    
  define property Msg as character no-undo
    get.
    private set.

  define property InitSecTag as character no-undo
    get.
    private set.

  method public void GetContent (expsubject as class ibs.th.bge.1crn.subjects.iexpsubject, inType as char, inFileName as char):

    define variable sw as handle no-undo.
    
    create sax-writer sw.
    sw:formatted = true.
    case inType:
      when "memptr"
        then sw:set-output-destination ("memptr", Data).
      when "file"
        then sw:set-output-destination ("file", inFileName).
    end.
    sw:encoding = "UTF-8".
    sw:fragment = true .
    sw:start-document () .
    expsubject:CrContentToSW (sw).
    InitSecTag = expsubject:InitSecTag.
    sw:end-document () .
    
   end.

   method public void GetContent (expsubject as class ibs.th.bge.1crn.subjects.iexpsubject):
     /*по умолчанию в memptr*/
     GetContent (expsubject, "memptr", ?).
   end.


end class.