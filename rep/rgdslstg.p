/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать списка gds-list

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/24/04
Author: Bakhtadze Natalya
Creation date: 06/24/04

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define input parameter p-sorttype as character no-undo .
define input parameter p-classify as character no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Печать списка gds-list".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }

{ gbl/cur-time.i }
{ cmp/r-pril.i new }
{ gbl/prn-lib.i }
{ rep/wt-zap.i   }
{ ref/gdsoattr.i }
{ cmp/gds-list.i gds-list def shared }
{ gbl/waitfram.i }

{ rep/rgdslst0.i gds-list }