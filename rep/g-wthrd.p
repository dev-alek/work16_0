/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Реестр документов движения серийных МЦ (старт)

Автор: Демин Алексей Сергеевич
Дата создания: 06/19/08
Author: Alexey Demin
Creation date: 06/19/08

*/
define input  parameter       parparentproc      as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Реестр документов движения серийных МЦ (старт)".
{ cmp/vssrevis.i }
{ cmp/r-page1.i new}

    run rep/d-report.w ( input parparentproc
                       , input "rep/e-wthrd.w":U
                       , input "Реестр документов движения серийных МЦ":U
                       , input 2
                       , input "":U
                       , input "":U
                       , input "":U
                       , input "":U
                       , input "{&customer-yes}":U
                       , input no
                       ) .