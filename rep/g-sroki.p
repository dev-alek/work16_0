/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по срокам годности товаров

Автор: Чернова Светлана Александровна
Дата создания: 11/20/09
Author: Svetlana Chernova
Creation date: 11/20/09

Автор1: Гюнтнер Виктор Арнольдович
Дата создания: 04/12/06

*/

define input parameter p-mainmenu-handle as handle           no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по срокам годности товаров.".
{ cmp/vssrevis.i    }
{ cmp/trg-def.i     }
{ cmp/r-page1.i new }

do
on error undo, return error
:
    run rep/d-report.w (
      input p-mainmenu-handle
    , input "rep/e-sroki.w"
    , input "Сроки годности товаров"
    , input 0
    , input "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-grp-prod}":U
    , input "*"
    , input ""
    , input ""
    , input "all,{&format-folder},{&Excel-yes}"
    , input no
    ).
end.