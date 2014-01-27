/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Продажи за неделю для Nielsen

Автор: Белоусов Илья Александрович
Дата создания: 03/25/09
Author: Ilia Belousov
Creation date: 03/25/09

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "---".
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

do
on error undo, return error
:
run rep/d-report.w ( input parParentProc
               , input 'rep/e-exp-sl.w'
               , input 'Продажи за неделю для Nielsen'
               , input 1
               , input ""
               , input "*"
               , input ""
               , input ""
               , input "shop"
               , input FALSE
               ) .
end.