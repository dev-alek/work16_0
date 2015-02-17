/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Детализированный отчет по бонусам и картам ЛНР

Автор: Соломко Дмитрий Владимирович
Дата создания: 10/02/2014 
Author: Solomko Dmitry
Creation date: 10/02/2014 
Переименован из отчёта: "Отчет по картам ЛНР" по ТН-3114 16.01.2015г Арн.
*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Детализированный отчет по бонусам и картам ЛНР".

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

do
on error undo, return error
:

assign
  my-handle = parparentproc
.

run rep/d-report.w
    ( input parparentproc
    , input "rep/e-xldlnr.w"
    , input vss-description
    , input 4
    , input "{&g-all},{&g-choice},{&g-one}":U
    , input "*"
    , input ""
    , input ""
    , input "all":U
    , input no ).

end.