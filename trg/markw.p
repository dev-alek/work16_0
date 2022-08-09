/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на изменение таблицы ub.marking

Автор: 
Дата создания: 
Author: 
Creation date: 

*/

TRIGGER PROCEDURE FOR WRITE OF ub.marking old old-marking.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Триггер на изменение таблицы abc-analysis-doc-attr".


{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ gbl/cur-time.i }

main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, chr(10), error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:

{ gbl/objsrv.i }
   
if (old-marking.sts = objSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:FreeZone:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:OutZone:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:SaleLock:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:SaleWaitLock:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:ReturnLock:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:ReturnWaitLock:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB
  or old-marking.sts = objSrv:Env:Marking:Sts:Mark:Reserved:KeyIntDB)
  and
   not (ub.marking.sts = objSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:FreeZone:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:OutZone:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:SaleLock:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:SaleWaitLock:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:ReturnLock:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:ReturnWaitLock:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:Reserved:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:NotAvailable:KeyIntDB)
then do:
  ub.marking.sts = old-marking.sts.
end.

if ub.marking.sts <> old-marking.sts then do:
   find first ub.marking-attr exclusive-lock where ub.marking-attr.mark = ub.marking.mark and 
                                                   ub.marking-attr.attr-code = "sts-date" no-error .
   if available (ub.marking-attr) then ub.marking-attr.attr-value = string(today) .          
   else do:
      create ub.marking-attr .
      assign
      ub.marking-attr.mark = ub.marking.mark
      ub.marking-attr.attr-code = "sts-date"
      ub.marking-attr.attr-value = string(today)
      .
   end.  
   find first ub.marking-attr exclusive-lock where ub.marking-attr.mark = ub.marking.mark and 
                                                   ub.marking-attr.attr-code = "sts-time" no-error .
   if available (ub.marking-attr) then ub.marking-attr.attr-value = string(time) .          
   else do:
      create ub.marking-attr .
      assign
      ub.marking-attr.mark = ub.marking.mark
      ub.marking-attr.attr-code = "sts-time"
      ub.marking-attr.attr-value = string(time)
      .
   end.                                          
end .   

end. /* main-block */
