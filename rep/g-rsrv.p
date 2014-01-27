/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по зарезервированным товарам.

Автор: Демин Алексей Сергеевич
Дата создания: 04/12/06
Author: Alexey Demin
Creation date: 04/12/06

Input:

Output:

*/

define input parameter p-mainmenu-handle as handle           no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по зарезервированным товарам.".
{ cmp/vssrevis.i    }
{ cmp/trg-def.i     }
{ cmp/r-page1.i new }

do
on error undo, return error
:
    run rep/d-report.w (
          input p-mainmenu-handle
        , input 'rep/e-rsrv.w':U
        , input "Зарезервированные товары"
        , input 0
        , input "{&g-all},{&g-grp},{&g-choice},{&g-one}":U
        , input "*"
        , input ""
        , input "{&v-rubl},{&v-base}"
        , input "all,{&format-folder}"
        , input no
    ).
end.