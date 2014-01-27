/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Автоматизированное формирование списка дисконтных карт - толкач  для меню

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/24/06
Author: Bakhtadze Natalya
Creation date: 03/24/06

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter parhost-code like ub.sysconf.host-code no-undo .
define input parameter parobj-type like ub.clients.obj-type no-undo .
define input parameter parobj-code like ub.clients.obj-code no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ cmp/dc-list.i dc-list def "new shared" }
run str/dc-list.w (
               input parparentproc
              ,input parhost-code
              ,input parobj-type
              ,input parobj-code).


/* $Workfile$ e n d */