define input  parameter inst     as logical   no-undo . /* YES - вопросы задавать */
define input  parameter p-create-adm as logical   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
find first sys-ctrl.
run adm\init-adm.p(inst,sys-ctrl.db-num,p-create-adm). 