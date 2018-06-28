define input  parameter parParentProc  as handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w ( input parParentProc ,
input                   'rep/e-statusvsd.w',"Отчет для получения информации по статусу ВСД",
input                        2,
input                        "{&g-all},{&g-choice},{&g-one}":U,
input                        "*":U,
input                        "",
input                        "",
input                        "all,{&Excel-yes}",
input                        no).