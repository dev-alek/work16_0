/*

$Revision: b51c2b536354, 3586, rls $
$Author: ARostovtsev $
$Date: 2023/12/28 12:56:36 $
$Workfile: IResponse.cls $
$Archive: ibs/th/skt/Commands/IResponse.cls $



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/

block-level on error undo, throw.
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
   
   
   define public property Content-Type as character  no-undo init "text/html; charset=UTF-8" 
   get.
   set.
   
   define public property content-disposition as character  no-undo 
   get.
   set.
  
   define public property saveFile as character  no-undo 
   set (arg as char):
      content-disposition = substitute ('attachment; filename="&1"',arg).
   end.
   
   define variable mAddctrf as logical no-undo.
   
   define public property ConvertPage as character  no-undo 
   get.
   set.
   define public property ContentLongChar as longchar no-undo 
   get.
   private set .
   define public property Content as memptr no-undo 
   get.
   set(arg as memptr):
      Content = arg.
      mAddctrf = no.
   end.
   define public property ContentLength as int64 no-undo 
   get : return get-size(Content) - if mAddctrf then 2 else 0 . end.
   
   define public property ParamWait as char no-undo 
   get.
   set.
   method public void setContent(arg as longchar ):
      setContent(arg, false).
   end.
   method public void setContent(arg as longchar, addNull as logical ):
      set-size(Content) = 0.
      arg = arg + chr(13) + chr(10).
      ContentLongChar = arg.
      set-size(Content) = length(arg,"raw") + if addNull then 1 else 0.
      if ConvertPage eq ""
      then
         copy-lob
         from object arg
         to object Content.
      else do:
         define variable pagecode as character no-undo.
         if ConvertPage begins "windows-"
         then
            pagecode = substring (ConvertPage,9).
         else
            pagecode = ConvertPage.
         copy-lob
         from object arg
         to object Content OVERLAY AT 1 convert target codepage pagecode.
      end.
      mAddctrf = not addNull.
   end.
   
   method public void setContent(arg as char ):
      set-size(Content) = 0.
      ContentLongChar = arg + chr(13) + chr(10).
      set-size(Content) = length(ContentLongChar,"raw").
      if ConvertPage eq ""
      then
         copy-lob
         from object ContentLongChar
         to object Content.
      else do:
         define variable pagecode as character no-undo.
         if ConvertPage begins "windows-"
         then
            pagecode = substring (ConvertPage,9).
         else
            pagecode = ConvertPage.
         copy-lob
         from object ContentLongChar
         to object Content convert target codepage ConvertPage.
      end.
      mAddctrf = yes.
   end.
   method public void setFile(arg as char ):
      setFile(arg,"").
   end.
   method public void setFile(arg as char,iparam as char ):
      define variable vtype    as character no-undo.
      define variable vConType as character no-undo.
      define variable vRas     as character no-undo.
      file-information:file-name = "cmp/" + arg.
      vtype = file-information:file-type.
      if    file-information:file-name eq "" 
         or vtype eq ?
         or index( vtype, "F") = 0
      then
         file-information:file-name = "cmp/dontknow.jpg".
      vRas = entry(2,file-information:file-name,".").
      case vRas:
         when "icon" then vConType = "image/vnd.microsoft.icon". 
         when "jpg"  then vConType = "image/jpeg".
         when "jpeg" then vConType = "image/jpeg".
         when "png"  then vConType = "image/png". 
         when "txt" 
      or when "xml"  then vConType = "text/xml".
         when "json" then vConType = "application/json".
         when "html" then vConType = "text/html".
      end.
      set-size(Content) = 0.
      set-size(Content) = file-information:file-size + 1.    
      copy-lob from file file-information:full-pathname to Content.
      Content-Type = vConType.
      if iparam = "savefile"
      then do:
         define variable vSaveFile  as character no-undo.
         define variable vpos       as integer no-undo.
         vSaveFile = replace (file-information:file-name,"\","/").
         vpos = index(vSaveFile,"/").
         vSaveFile = substring (vSaveFile,vpos + 1).
         vSaveFile = replace (vSaveFile,"/","_").
         saveFile = vSaveFile.
      end.
   end.
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	destructor public IResponse ( ):
	   set-size(Content) = 0.
      delete object STSlist.
	end destructor.
 
    
end class.
