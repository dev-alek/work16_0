/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сводный отчет о реализованных талонах (старт)

Автор: Белоусов Илья Александрович
Дата создания: 05/07/08
Author: Ilia Belousov
Creation date: 05/07/08

Input:

Output:

*/
define input  parameter       parparentproc      as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Сводный отчет о реализованных талонах (старт)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
do
on error undo, return error
:
    run rep/d-report.w ( input parparentproc
                       , input "rep/e-wthcom.w":U
                       , input "Сводный отчет о реализованных талонах":U
                       , input 2
                       , input "":U
                       , input "":U
                       , input "":U
                       , input "":U
                       , input "all,{&Excel-yes}":U
                       , input no
                       ) .
end.