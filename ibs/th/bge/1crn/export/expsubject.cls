 
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


class ibs.th.bge.1crn.export.expsubject:
  
  define property Data as memptr no-undo
    get.
    private set.
    
  define property Msg as character no-undo
    get.
    private set.

  define property num as integer no-undo
    get.
    set.

  define property sender-id as character no-undo
    get.
    set.
    
  define property receiver-id as character no-undo
    get.
    set.
    
  define property created-date as character no-undo
    get.
    set.

  
  method public void GetContent (expsubject as class ibs.th.bge.1crn.subjects.iexpsubject, inType as char, inFileName as char):

    define variable sw as handle no-undo.
    
    created-date = iso-date (now).
    sender-id = '00001'.
    receiver-id = '00000'.
    
    
    create sax-writer sw.
    sw:formatted = true.
    case inType:
      when "memptr"
        then sw:set-output-destination ("memptr", Data).
      when "file"
        then sw:set-output-destination ("file", inFileName).
    end.
    sw:encoding = "UTF-8".
    sw:start-document () .
    
    sw:start-element ("GC-ERPRN") .
    
    
    sw:insert-attribute ("xmlns", "http://www.rosneft.ru/GasComplex/Retail") .
    sw:insert-attribute ("xmlns:xs", "http://www.w3.org/2001/XMLSchema") .
    sw:insert-attribute ("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance") .
      sw:start-element ("header") .
        sw:write-data-element ("num", string(num)) .
        sw:write-data-element ("sender-id", sender-id) .
        sw:write-data-element ("reciever-id", receiver-id) .
        sw:write-data-element ("created-date", created-date) .
      sw:end-element ("header") .
      expsubject:CrContentToSW (sw).
    
    sw:end-element ("GC-ERPRN") .

    sw:end-document () .
    
   end.

   method public void GetContent (expsubject as class ibs.th.bge.1crn.subjects.iexpsubject):
     /*по умолчанию в memptr*/
     GetContent (expsubject, "memptr", ?).
   end.


end class.