/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать журнала продаж  MainProc_d

Автор: Бахтадзе Наталья Викторовна
Дата создания: 12/05/05
Author: Bakhtadze Natalya
Creation date: 12/05/05

*/

define input parameter parparentproc as widget-handle no-undo .
define output parameter p-frame-width as integer no-undo .

define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "Журнал продаж" .
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-pril.i }
{ cmp/r-page1.i }
{ cmp/operlist.i }
{ rep/e-sjall.i " SHARED " }

{ rep/e-sj-df.i "SHARED" }

{ rep/e-sjdn.i }
{ cmp/breakstr.i }
{ rep/e-sjfg.i }

run main no-error.
if error-status:error then return error.
return.

Procedure main.
define variable v-salesman-name as character no-undo .
define buffer buf_saleman for ub.clients.
{ rep/e-sjmn.i sj-adv.discnt sj-base-d sj-full-d }
ENd procedure. /*end of main*/


PROCEDURE ProdGrpProc_d.
define variable v-salesman-name as character no-undo .
define buffer buf_saleman for ub.clients.
{ rep/e-sjpr.i sj-adv.discnt sj-base-d sj-full-d }
END PROCEDURE. /*end of ProdGrpProc_d*/

PROCEDURE SimpleProc_d.
define variable v-salesman-name as character no-undo .
define buffer buf_saleman for ub.clients.
{ rep/e-sjsp.i sj-adv.discnt sj-base-d sj-full-d }
END PROCEDURE. /*end of SimpleProc_d*/