/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск отчета "История действий пользователей"

Автор: Хныкин Павел Андреевич
Дата создания: 07/06/09
Author: Pavel Khnykin
Creation date: 07/06/09

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "История действий пользователей".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i      }
{ cmp/r-page1.i new   }

run rep/d-report.w
    ( input parParentProc
    , input 'rep/e-user_hist.w'
    , input "История действий пользователей":U
    , input 2
    , input "":U /* {&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod} */
    , input "{&o-firm},{&o-currency},{&o-choice}"
    , input ""
    , input ""
    , input ""
    , input no
    ).