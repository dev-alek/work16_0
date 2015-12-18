/*


*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по бонусам".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-page1.i new }

 run rep/d-report.w (            input parparentproc
                            ,input "rep/e-bonus-ot.w "
                            ,input ('Отчет по бонусам')
                            ,input 4
                            ,input  "{&g-all},{&g-grp},{&g-choice},{&g-one}":U
                            ,input "*"
                            ,input ""
                            ,input " "
                            ,input "all,{&Excel-yes}"
                            ,input no).