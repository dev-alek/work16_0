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
define variable mfilesize    as integer no-undo.
define variable msizeinfile  as integer no-undo.
define variable mfile        as character no-undo.


if search("adm/l-i.r") eq ?
then do:
   
   mliststrfile = "cmp/str-glb2.p,cmp/str-glb3.p,cmp/str-glb4.p,cmp/str-glb5.p,cmp/str-glbl.p,cmp/str-glbt.p".
   if search ("{&fileparam}") ne ?
   then do:
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
         assign 
            msizeinfile = 0  
            msizeinfile = int(getParam("{&fileparam}",mfile))
         no-error.
         if msizeinfile ne mfilesize
         then do:
            changstr = yes.
            leave block-file. 
         end.
      end.
   end.
   else
      changstr = yes.
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
      run utl/mkstrglb.p.
      output to "{&fileparam}".
      do mi = 1 to num-entries(mliststrfile):
         mfile = entry(mi,mliststrfile).
         file-info:file-name = search (mfile).
         saveparam(mfile,string(file-info:file-size)).
      end.
      output close.
   end.   
end.

   