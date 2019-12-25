{utl/mkstrglb.p &iscompil = yes}
define variable mliststrfile as character no-undo.
define variable mi as integer no-undo.
define variable mfilenew as character no-undo.

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