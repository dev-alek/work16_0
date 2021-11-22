/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 8 окт. 2019 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 8 окт. 2019 г.

*/ 
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/db-attr.i  }

define buffer buf_sys-ctrl for ub.sys-ctrl.
define buffer buf_db for ub.db.
find first buf_sys-ctrl no-lock no-error.
if available buf_sys-ctrl
then do:
   find first buf_db no-lock where buf_db.db-num = buf_sys-ctrl.db-num no-error.
   define variable updschmObj      as class ibs.th.adm.upd.updschm no-undo.
   updschmObj = new ibs.th.adm.upd.updschm ().
   if     buf_db.reserve1-char begins "updto:"
       or updschmObj:CurrDBShm ne int(buf_db.reserve1-char)
   then do trans:
      find first buf_db exclusive-lock where buf_db.db-num = buf_sys-ctrl.db-num no-error.
      buf_db.reserve1-char = string(updschmObj:CurrDBShm). 
   end.
   delete object updschmObj no-error.
end.

define variable mfile    as character no-undo.
define variable mfilemd5 as character no-undo.
define variable v-md5-signature  as character no-undo.
define variable vimport as class ibs.th.bge.xmlimpexp no-undo.
define variable mTxt as character no-undo.
define variable mfilever as char no-undo init ?.
define variable m-type as character no-undo.
define variable mdbver as integer no-undo.
define variable mdbver_old as integer no-undo.
define stream md5in.
run db-attr-value in this-procedure 
           (input ibs.th.gbl.gbl-var:g#db-num
           ,input {&attr-ver-met}
           ,output mTxt
           ,output m-type 
           ) no-error .
mdbver = int(mtxt) no-error.
if mdbver_old eq ?
then
   mdbver_old = 0.
 find first code  where  ub.Code.parent = "" and ub.Code.code = "okei-kkt" no-error.

vimport= new ibs.th.bge.xmlimpexp().
block-upd:
do mdbver = mdbver_old + 1 to 999999999:
   mfile    = search(substitute("upd/&1.xml",string(mdbver,"999999999"))).
   mfilemd5 = search(substitute("upd/&1.md5",string(mdbver,"999999999"))).
   if    mfile    eq ? 
      or mfilemd5 eq ?
   then 
      leave block-upd.
   input  stream md5in from value (mfilemd5).
   import stream md5in mtxt no-error.
   input  stream md5in close.
   run gbl/md5.p (
          input  mfile
         ,output v-md5-signature /* p-md5-signature */
         ) .
   if mtxt eq {utl/chekmd5.i v-md5-signature } 
   then do:
      vimport:xmldom-load-ver  ( mfile,? ) no-error.
      if error-status:error
      then
         return error return-value.
      vimport:updatetablefordb() no-error.
      if error-status:error
      then
         return error return-value + " " + error-status:get-message(1).
      vimport:xmldom-clear().
   end.
   else
      return error substitute("Файл &1 имеет не правильную сигнатуру md5.", mfile).
    
   
end.
mdbver = mdbver - 1.
if mdbver gt mdbver_old
then
   run db-attr-write in this-procedure ( input ibs.th.gbl.gbl-var:g#db-num
                                       , input {&attr-ver-met}
                                       , input string (mdbver)
                                       ) no-error .   
mfile    = search("upd/code.xml").
mfilemd5 = search("upd/code.md5").
  /*проверим md5*/
if mfile ne ? and mfilemd5 ne ? 
then do:
   input  stream md5in from value (mfilemd5).
   import stream md5in mtxt no-error.
   input  stream md5in close.
   run gbl/md5.p (
          input  mfile
         ,output v-md5-signature /* p-md5-signature */
         ) .
   if mtxt ne {utl/chekmd5.i v-md5-signature }  
   then 
      return error substitute("Файл &1 имеет не правильную сигнатуру md5.", mfile).

   mfilever = vimport:xmldom-load-ver  ( "cmp/code.xml",? ) no-error.
   if error-status:error
   then
      return error return-value.
   vimport:updatetablefordb() no-error.
   if error-status:error
   then
      return error return-value  + " " + error-status:get-message(1).
   else 
      run db-attr-write in this-procedure ( input ibs.th.gbl.gbl-var:g#db-num
                                          , input {&attr-ver-code}
                                          , input mfilever
                                          ) no-error .
   vimport:xmldom-clear().
end.
finally:
   if valid-object(vimport)
   then
      delete object vimport.
end finally.
