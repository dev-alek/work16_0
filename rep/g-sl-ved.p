/*


*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Общая сличислительная ведомость".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/r-page1.i new }

 run rep/d-report.w (            input parparentproc
                            ,input "rep/r-sl-ved.p " + string(parParentProc)
                            ,input ('Общая сличислительная ведомость')
                            ,input 4
                            ,input  "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one}":U
                            ,input "*"
                            ,input "{&p-crsa},{&p-cost}"
                            ,input " "
                            ,input "all,{&Excel-yes}"
                            ,input yes).