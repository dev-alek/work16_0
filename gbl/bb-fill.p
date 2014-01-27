/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Формирование списка кодов по фильтру

Автор: Бахтадзе Наталья Викторовна
Дата создания: 12/11/09
Author: Bakhtadze Natalya
Creation date: 12/11/09

*/


define input parameter par-run-names as character no-undo .
define input parameter Rs-list-method as character no-undo .
define input parameter Rs-status as character no-undo .
define input parameter line-mode as character no-undo .
define input parameter p-filter-var as character no-undo .
define output parameter lns-cnt as integer no-undo .
define output parameter line-rec as recid no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Формирование списка кодов по фильтру".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }

{ gbl/bb-fill.i bb-list }