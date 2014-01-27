/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Расшифровка реализации к сменному отчету

Автор: Кочетков Михаил Юрьевич
Дата создания: 10/10/07
Author: Michael Kochetkov
Creation date: 10/10/07

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Расшифровка реализации к сменному отчету".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i   new   }

run rep/d-report.w (
                 input parparentproc
                ,input 'cus/r-shft3f.p'
                ,input "Расшифровка реализации к сменному отчету"
                ,input 8
                ,input ""
                ,input "{&o-currency}"
                ,input ""
                ,input ""
                ,input ""
                ,input yes).