/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

*/


&Glob main-tbl code
trigger procedure for write of ub.{&main-tbl}
  new buffer new-{&main-tbl}
  old buffer old-{&main-tbl}
.

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo init "Тригер изменение {&main-tbl}". 
{ trg/trghistnws.i}
/*
{ trg/trghistnws.i 
  &hist = yes 
  &seqnamehist = "s-c-code"
}
*/
define buffer buf_code for code.
if     new-{&main-tbl}.nwsgbd ne old-{&main-tbl}.nwsgbd
   and new-{&main-tbl}.nwsubd ne old-{&main-tbl}.nwsubd
then do:
   for each buf_code where buf_code.parent begins new-{&main-tbl}.code
   exclusive-lock:
      buf_code.nwsgbd = new-{&main-tbl}.nwsgbd.
      buf_code.nwsubd = new-{&main-tbl}.nwsubd.
   end.
end.

if    (    g#db-num eq 0 
       and new-{&main-tbl}.nwsgbd )
   or (    g#db-num eq 0 
       and new-{&main-tbl}.nwsubd )
then do:
   { trg/trghistnws.i 
     &nws  = yes
   }
end.
