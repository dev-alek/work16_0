/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Форма №2 взаиморасчет с контрагентами

Автор: Хныкин Павел Андреевич
Дата создания: 08/22/07
Author: Pavel Khnykin
Creation date: 08/22/07

*/
define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Форма №2 взаиморасчет с контрагентами".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new   }
{ gbl/getcntxt.i def  }


define variable v-object-select as character no-undo .
{ gbl/getcntxt.i get }
assign
  my-handle = parparentproc
.
if v-cntxt-db-num = 0 then do:
  assign
    v-object-select = "{&o-firm}"
  .
end.

run rep/d-report.w
    ( input parparentproc
    , input 'rep/e-fincl1.w'
    , input "Форма №2 взаиморасчет с контрагентами":U
    , input 2
    , input ""
    , input v-object-select
    , input ""
    , input "{&v-rubl},{&v-base}"
    , input "all,{&Excel-yes}" + ',' + substitute( "parent-handle=&1" , this-procedure )
    , input no
    ).

/* ============================================================================== */
procedure get-report-proc-name :

define output parameter p-proc-name as character no-undo .

do
on error undo, return error return-value
:

  assign
    p-proc-name = "rep/r-fincl2.p"
  .
end.

end procedure. /* get-report-proc-name */