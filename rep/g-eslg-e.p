/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск отчета 'Расширеный оперативный (ежедневный) отчет по закончив. наименованиям'

Автор: Хныкин Павел Андреевич
Дата создания: 02/12/10
Author: Pavel Khnykin
Creation date: 02/12/10

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск отчета 'Расширеный оперативный (ежедневный) отчет по закончив. наименованиям'".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

do
on error undo, return error return-value
:
  run rep/d-report.w ( input parParentProc
                     , input 'rep/e-eslg-e.w'
                     , input 'Расширеный оперативный (ежедневный) отчет по закончившимся наименованиям'
                     , input 1
                     , input ""
                     , input "{&o-currency}"
                     , input ""
                     , input ""
                     , input "all,{&Arc-stk-yes},{&Arc-ot-yes}"
                     , input no
                     ).
end.