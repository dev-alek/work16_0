/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 11 июня 2019 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 11 июня 2019 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "Процедура обновления str-gbl в автоматическом режиме для разработчиков".
{ cmp/vssrevis.i }
{ utl/param.i }
&global-define fileparam filesize.txt 
define variable mliststrfile as character no-undo.
define variable mi           as integer   no-undo.
define variable changstr     as logical   no-undo.
define variable chancript    as logical   no-undo.
define variable changmd5     as logical   no-undo.
define variable mfilesize    as integer   no-undo.
define variable msizeinfile  as integer   no-undo.
define variable mverinfile   as integer   no-undo.
define variable v-md5-signature  as character no-undo.

define variable mfile        as character no-undo.
define variable mfileNew     as character no-undo.

define temp-table tt-file-ver
field  filename as character 
field  filesize as integer 
field  filever as integer init ?
.

if search("adm/l-i.r") eq ?
then do:
   
   mliststrfile = "cmp/str-glb2.p,cmp/str-glb3.p,cmp/str-glb4.p,cmp/str-glb5.p,cmp/str-glbl.p,cmp/str-glbt.p".
   block-file:
   do mi = 1 to num-entries(mliststrfile):
      mfile = entry(mi,mliststrfile).
      if search (mfile ) = ? 
      then
         mfilesize = 0.
      else do:
         file-info:file-name = search (mfile).
         mfilesize = file-info:file-size.
      end.
      create tt-file-ver.
      assign
         tt-file-ver.filename = entry(mi,mliststrfile)
         tt-file-ver.filesize = mfilesize
      .
      if search ("{&fileparam}") ne ?
      then do:
         assign
            msizeinfile = 0  
            msizeinfile = int(getParam("{&fileparam}",mfile))
         no-error.
         if msizeinfile ne mfilesize
         then 
            changstr = yes.
      end.
      else
         changstr = yes.
   end.
   if    changstr
      or search ("cmp/str-glbl.i") eq ?
   then do:
      if search("str-glbl.new") ne ? 
      then do:
         message "Уже начато формирвание str-glbl.i в другой сесссии" skip
            search("str-glbl.new") 
         view-as alert-box.
         return.                                 
      end.
      if search("cmp/str-glbl.i") ne ?
      then do:
         output to value( search("cmp/str-glbl.i")).
               put "удален" skip.
         output close.
      end.
      /*os-delete value( search("cmp/str-glbl.i")).
      if search("cmp/str-glbl.i") ne ? 
      then do:
         message "Неудается удаллить файл str-glbl.i попробуйте удалить его в ручную." skip
            search("cmp/str-glbl.i") 
         view-as alert-box.
         return.                                 
      end.*/
      changstr = yes.
      run utl/mkstrglb.p.
      
   end.
   /* MD5*/
   mliststrfile = "cmp/code.xml".
   do mi = 1 to num-entries(mliststrfile):
      
      mfile = entry(mi,mliststrfile).
      if search (mfile) eq ?
      then
         mfilesize = 0.
      else do:
         file-info:file-name = search (mfile).
         mfilesize = file-info:file-size.
      end.
      create tt-file-ver.
      assign
         tt-file-ver.filename = entry(mi,mliststrfile)
         tt-file-ver.filesize = mfilesize
      .
      if search ("{&fileparam}") ne ?
      then do:
         assign
            msizeinfile = 0  
            msizeinfile = int(getParam("{&fileparam}",mfile))
         no-error.
      end.
      else
         changmd5 = yes.
       mfileNew = search (mfile).
       entry(num-entries(mfileNew,"."),mfileNew,".")= "md5".
      if    msizeinfile ne mfilesize
         or search (mfilenew) eq ?
      then do:
         run gbl/md5.p(tt-file-ver.filename,output v-md5-signature).
        
         output to value(mfileNew).
         put unformatted v-md5-signature.
         output close.
         
         changmd5 = yes.
      end.
      
      
   end.
   mliststrfile = "cmp/actn.txt,cmp/menu.txt".
   do mi = 1 to num-entries(mliststrfile):
      mfile = entry(mi,mliststrfile).
      create tt-file-ver.
      tt-file-ver.filename = mfile.
      mfile = search(mfile).
      run getverfile (mfile, 
                      output tt-file-ver.filesize,
                      output tt-file-ver.filever).
      if search ("{&fileparam}") ne ?
      then do:
         assign
            msizeinfile = 0  
            msizeinfile = int(getParam("{&fileparam}",mfile))
         no-error.
         assign
            mverinfile = 0  
            mverinfile = int(getParam("{&fileparam}",mfile + "|ver"))
         no-error.
         if    msizeinfile ne tt-file-ver.filesize
            or mverinfile  ne tt-file-ver.filever
         then do: 
            chancript = yes.
            
         end.
      end.
      else
         chancript = yes.
      mfilenew = replace (mfile,".txt",".enc").
      if    msizeinfile ne tt-file-ver.filesize
         or mverinfile  ne tt-file-ver.filever
         or search(mfilenew) eq ?
      then do:
          
          run utl/filecrypnodb.p ( input mfile
                               , input "sysadm"
                               , input yes
                               , input mfileNew
                              ) .
      end.
         
      
   end.
   if    changstr
      or chancript
      or changmd5
   then do:
      output to "{&fileparam}".
      for each tt-file-ver:
         
         saveparam(tt-file-ver.filename,string(tt-file-ver.filesize)).
         if tt-file-ver.filever ne ?
         then
            saveparam(tt-file-ver.filename + "|ver" ,string(tt-file-ver.filever)).
      end.
      output close.
   end.
   run utl/crpwd.p(no).   
end.
define stream sinp .
procedure getverfile:
   define input  parameter iFileName as character no-undo.
   define output parameter oFilesize as integer   no-undo.
   define output parameter oFilever  as integer   no-undo.
   define variable vTXt as character no-undo.
   if iFileName eq ? 
   then do:
      ofilesize = 0.
      return.
   end.
   else do:
      file-info:file-name = iFileName.
      ofilesize = file-info:file-size.
   end.
   
   input stream sinp from value(iFileName) .

   import stream sinp unformatted vTXt .
    
   oFilever = integer (trim(vtxt,'"')) no-error.
   input stream sinp close .
   
end.