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
define variable mfile as character no-undo.
define variable v-md5-signature  as character no-undo.
mfile = search("cmp/code.xml").
  /*проверим md5*/
run gbl/md5.p (
       input  mfile
      ,output v-md5-signature /* p-md5-signature */
      ) .
if "{cmp/code.md5}" ne v-md5-signature 
then 
   return error substitute("Файл &1 имеет не правильную сигнатуру md5.", mfile).

define variable vimport as class ibs.th.bge.xmlimpexp no-undo.
define variable mTxt as character no-undo.
define variable mfilever as integer no-undo init ?.
define variable m-type as character no-undo.
define variable mdbver as integer no-undo.
run db-attr-value in this-procedure 
           (input ibs.th.gbl.gbl-var:g#db-num
           ,input {&attr-ver-code}
           ,output mTxt
           ,output m-type 
           ) no-error .
mdbver = int(mtxt) no-error.
if mdbver eq ?
then
   mdbver = 0.
if mdbver ne {cmp\code.ver}
then do: 
vimport= new ibs.th.bge.xmlimpexp().
mtxt = "". 
mtxt = vimport:xmldom-load-ver  ( "cmp/code.xml",mdbver ) no-error.
if error-status:error
then
   return error return-value.
else
   mfilever = int(mtxt) no-error.
if mfilever ne ?
then do:

   vimport:updatetablefordb() no-error.
   if error-status:error
   then
      return error return-value.
   else if  mdbver ne mfilever
   then
      run db-attr-write in this-procedure ( input ibs.th.gbl.gbl-var:g#db-num
                                           , input {&attr-ver-code}
                                           , input string (mfilever)
                                           ) no-error .
end.
end.
finally:
   if valid-object(vimport)
   then
      delete object vimport.
end finally.
