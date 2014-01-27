/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Программа обработки виртуальных смен

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/17/06
Author: Bakhtadze Natalya
Creation date: 01/17/06

*/

DEFINE parameter buffer chk-doc for ub.chk-doc.
define input parameter parparentproc as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter par-mode as character no-undo .
DEFINE input parameter shop-code like ub.clients.obj-code no-undo.
DEFINE input parameter shop-type like ub.clients.obj-type no-undo.
DEFINE input parameter v-shft as integer no-undo.
DEFINE input parameter t-shft as integer no-undo.
DEFINE input parameter shift-err as char no-undo.
DEFINE input-output parameter for-chk-type as char no-undo.
DEFINE input-output parameter p-view-log as logical no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

DEFINE buffer for_chk-doc for chk-doc.
define variable choice as integer no-undo.
define variable vrecid as recid no-undo.
define var response as integer no-undo.
define variable log-file-name as character no-undo init "get-chkf.log".

{ str/v-shftg.i chk-doc }