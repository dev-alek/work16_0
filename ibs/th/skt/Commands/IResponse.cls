/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/


class ibs.th.skt.Commands.IResponse abstract: 

   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   define public variable STSlist as ibs.th.skt.Commands.ICommandStatus no-undo.   
   constructor public IResponse (  ):
      super ().
      STSlist = new ibs.th.skt.Commands.ICommandStatus().
   end constructor.
 
  
   define public property condition as char no-undo 
   get.
   set(arg as char):
      if STSlist:GetProp(arg) ne STSlist:Unknow
      then
         condition = arg.
   end.
   
   define public property ContentLength as int64 no-undo 
   get.
   set.
   
   define public property Content as memptr no-undo 
   get.
   set(arg as memptr):
      Content = arg.
      ContentLength = get-size(Content).
   end.
   
   define public property ParamWait as char no-undo 
   get.
   set.
   
   method public void setContent(arg as longchar ):
      set-size(Content) = 0.
      arg = arg + chr(13) + chr(10).
      set-size(Content) = length(arg,"raw").
      copy-lob
      from object arg
      to object Content
      convert target codepage "UTF-8".
      ContentLength = length(arg,"raw").
      
   end.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public IResponse ( ):
      delete object STSlist.
	end destructor.
 
    
end class.