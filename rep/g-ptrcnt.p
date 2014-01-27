/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по электронным значениям счетчиков ТРК

Автор: Хныкин Павел Андреевич
Дата создания: 02/26/07
Author: Pavel Khnykin
Creation date: 02/26/07

*/

define input parameter p-parent-proc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по электронным значениям счетчиков ТРК".
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

assign
  my-handle = p-parent-proc
.
run rep/d-report.w
    ( input p-parent-proc
    , input 'rep/r-ptrcnt.p'
    , input "Отчет по электронным значениям счетчиков ТРК":U
    , input 8
    , input ""
    , input "{&o-currency}"
    , input ""
    , input ""
    , input "all,{&Excel-yes}"
    , input yes
    ).