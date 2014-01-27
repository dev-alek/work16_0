/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Харитонов Владимир Александрович
Дата создания: 12/02/08
Author: Alexey Demin
Creation date: 12/02/08

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Суточные сводки (ТамбовНП)".
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
    , input "rep/r-tdsum.p"
    , input vss-description
    , input 4
    , input "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod},{&g-spis}":U
    , input "*"
    , input ""
    , input ""
    , input "all,{&Arc-OT-yes}":U
    , input yes ).

end.