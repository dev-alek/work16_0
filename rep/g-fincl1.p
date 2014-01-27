/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Форма №1 взаиморасчет с контрагентами

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
define variable vss-description as character no-undo init "Форма №1 взаиморасчет с контрагентами".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new   }
{ gbl/getcntxt.i def  }

assign
  my-handle = parparentproc
.

run rep/d-report.w
    ( input parparentproc
    , input 'rep/e-fincl1.w'
    , input "Форма №1 взаиморасчет с контрагентами":U
    , input 2
    , input ""
    , input "{&o-firm}"
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
    p-proc-name = "rep/r-fincl1.p"
  .
end.

end procedure. /* get-report-proc-name */