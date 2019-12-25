{utl/mkstrglb.p &iscompil = yes}
define variable mliststrfile as character no-undo.
define variable mi as integer no-undo.
define variable mfilenew as character no-undo.
define variable v-md5-signature as character no-undo.

mliststrfile = "cmp/actn.txt,cmp/menu.txt".

   do mi = 1 to num-entries(mliststrfile):
      mfile = entry(mi,mliststrfile).
      mfile = search(mfile).
      mfilenew = replace (mfile,".txt",".enc").
      run utl/filecrypnodb.p ( input mfile
                               , input "sysadm"
                               , input yes
                               , input mfileNew
                              ) .
   end.
   mliststrfile = "cmp/code.xml".
   do mi = 1 to num-entries(mliststrfile):
      
      mfile = entry(mi,mliststrfile).
      if search (mfile) ne ?
      then do:
         
         run gbl/md5.p(mfile,output v-md5-signature).
         mfileNew = search (mfile).
         entry(num-entries(mfileNew,"."),mfileNew,".")= "md5".
         output to value(mfileNew).
         put unformatted v-md5-signature.
         output close.
      end.
   end.
   run utl/crpwd.p (yes ).