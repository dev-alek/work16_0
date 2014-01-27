/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление чеков по инвентаризации

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/03/06
Author: Bakhtadze Natalya
Creation date: 09/03/06

*/

define input parameter p-doc-code as character no-undo .
define input parameter p-obj-type as character no-undo .
define input parameter p-obj-code as integer no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Удаление чеков по инвентаризации".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
define variable ii as integer no-undo .

_main:
do
on error  undo _main, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
:

{ str/del-sale.i p-doc-code p-obj-type p-obj-code ii " " " " "inv" }

end.
