/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборотная ведомость серийных МЦ по контрагентам

Автор: Хныкин Павел Андреевич
Дата создания: 12/25/07
Author: Pavel Khnykin
Creation date: 12/25/07

*/
define input  parameter parparentproc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Оборотная ведомость серийных МЦ по контрагентам":U.
{ cmp/vssrevis.i }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

do
on error undo, return error
:
    run rep/d-report.w ( input parparentproc
                       , input "rep/e-wthobr.w":U
                       , input "Оборотная ведомость серийных МЦ по контрагентам":U
                       , input 2
                       , input "":U
                       , input "{&o-firm}":U
                       , input "":U
                       , input "":U
                       , input "all,{&Excel-yes}":U
                       , input no
                       ) .
end.


