/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет протокол заправок

Автор: Хныкин Павел Андреевич
Дата создания: 09/24/07
Author: Pavel Khnykin
Creation date: 09/24/07

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет протокол заправок".
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

run rep/d-report.w
    ( input parparentproc
    , input 'rep/r-azkprt.w'
    , input "Отчет протокол заправок":U
    , input 7
    , input ""
    , input "{&o-currency}"
    , input ""
    , input ""
    , input "all,{&Excel-yes}"
    , input yes
    ).