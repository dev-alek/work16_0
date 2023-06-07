/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Динамика показаний уровнемера

Автор: Уханов Дмитрий Юрьевич
Дата создания: 07/14/10
Author: Dmitry Ukhanov
Creation date: 07/14/10

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Динамика показаний уровнемера".
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

do
on error undo, return error
:
run rep/d-report.w
    ( input parparentproc
    , input 'rep/r-rvsdin.p'
    , input "Динамика показаний уровнемера":U
    , input 8
    , input "{&g-choice}"
    , input "{&o-currency}"
    , input ""
    , input ""
    , input "all" /*,{&Excel-yes}*/
    , input yes
    ).
end.