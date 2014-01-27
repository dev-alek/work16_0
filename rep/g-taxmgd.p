/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

ĞÀÑ×ÅÒ ÍÀËÎÃÎÂ ÏÎ ÒÎÂÀĞÀÌ ÑÏÈÑÊÀ ÄÎÊÓÌÅÍÒÎÂ - çàïóñê

Àâòîğ: Áàõòàäçå Íàòàëüÿ Âèêòîğîâíà
Äàòà ñîçäàíèÿ: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "ĞÀÑ×ÅÒ ÍÀËÎÃÎÂ ÏÎ ÒÎÂÀĞÀÌ ÑÏÈÑÊÀ ÄÎÊÓÌÅÍÒÎÂ - çàïóñê".
{ cmp/vssrevis.i }

DEFINE INPUT PARAMETER p-objects as integer no-undo.
DEFINE INPUT PARAMETER p-FRAME-TITLE as char no-undo.
define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ cmp/r-page1.i new}

DEFINE NEW SHARED VAR objects as integer no-undo.
DEFINE NEW SHARED VAR FRAME-TITLE as char no-undo.
assign
objects = p-objects
frame-title = p-frame-title
.
define variable gLog as logical   no-undo .
{ gbl/getcntxt.i get }
{ gbl/chk-actg.i
v-cntxt-db-num
v-cntxt-userid
{&action-head-code-main}
'actn_tax-settlement_print':U
{&cntxt-firm}
v-cntxt-host-code-obj
'':U
0
0
0
0
true
glog
}

if not gLog then return "NO".

run rep/d-report.w (            input parParentProc ,
                            input 'rep/e-taxmgd.w',
                            input ('ĞÀÑ×ÅÒ ÍÀËÎÃÎÂ ÏÎ ÒÎÂÀĞÀÌ ÑÏÈÑÊÀ ÄÎÊÓÌÅÍÒÎÂ'),
                            2,
                            "{&g-all},{&g-choice}",
                            if objects < 2 then "*" else "",
                            "",
                            "",
                            "shop",
                            no).
