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

define variable objSrv as class ibs.th.gbl.sys.objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).

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
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:Reserved:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB
  or ub.marking.sts = objSrv:Env:Marking:Sts:Mark:NotAvailable:KeyIntDB)
then do:
  ub.marking.sts = old-marking.sts.
end.

/*define variable objSrv as class ibs.th.gbl.sys.objsrv no-undo.       */
/*run gbl/getobjsrvhndl.p (input-output ObjSrv).                       */
/*                                                                     */
/*if not g#news and ub.marking.sts <> old-marking.sts and              */
/*(ub.marking.sts = objSrv:Env:Marking:Sts:Mark:OutZone:KeyIntDB or    */
/*ub.marking.sts = objSrv:Env:Marking:Sts:Mark:SaleLock:KeyIntDB or    */
/*ub.marking.sts = objSrv:Env:Marking:Sts:Mark:SaleWaitLock:KeyIntDB or*/
/*ub.marking.sts = objSrv:Env:Marking:Sts:Mark:Reserved:KeyIntDB)      */
/*then do:                                                             */
/*  objSrv:Lib:MarkingTree:UnGroupMark(ub.marking.mark).               */
/*end.                                                                 */


/*  return.                                                      */
/*  def var objSrv as class ibs.th.gbl.sys.objsrv no-undo.       */
/*  def var markSts as class ibs.th.str.marking.sts.mark no-undo.*/
/*  run gbl/getobjsrvhndl.p (input-output ObjSrv).               */
/*                                                               */
/*  markSts = objSrv:Env:Marking:Sts:Mark.                       */
/*                                                               */
/*  if ub.marking.sts <> old-marking.sts                         */
/*  and (                                                        */
/*        ub.marking.sts = markSts:FreeZone:KeyIntDB             */
/*    or  ub.marking.sts = markSts:OutZone:KeyIntDB              */
/*    or  ub.marking.sts = markSts:Checked_:KeyIntDB             */
/*    or  ub.marking.sts = markSts:Ungrouped:KeyIntDB            */
/*  )                                                            */
/*  then do:                                                     */
/*    run str/callnews.p                                         */
/*      (input {&table_marking}                                  */
/*      ,input (buffer ub.marking :handle)                       */
/*      ) no-error .                                             */
/*    if error-status:error then do:                             */
/*      undo main-block,  return error return-value .            */
/*    end.                                                       */
/*  end.                                                         */

end. /* main-block */
