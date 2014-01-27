/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Группы ORACLE RETAIL

Автор: Бахтадзе Наталья Викторовна
Дата создания: 02/21/09
Author: Bakhtadze Natalya
Creation date: 02/21/09

*/

define input  parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Группы ORACLE RETAIL".
{ cmp/vssrevis.i }

define variable v-rid-list as character no-undo .
run utl/rpm-ggr.w ( input parparentproc
                   ,input '' /*bttns*/
                   ,input '' /*p-list-mode*/
                   ,input-output v-rid-list) no-error.
