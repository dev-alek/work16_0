/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/04/07
Author: Bakhtadze Natalya
Creation date: 04/04/07

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
define output parameter p-string as character no-undo .
define variable v-date as date no-undo .
define variable v-decimal as decimal no-undo .
define variable v-integer as integer no-undo .
define variable v-logical as logical no-undo .
assign
v-date = date({1}) no-error .
if not error-status:error then do:
  p-string = {1}.
  return.
end.
assign
v-decimal = decimal({1}) no-error .
if not error-status:error then do:
  p-string = {1}.
  return.
end.
assign
v-integer = integer({1}) no-error .
if not error-status:error then do:
  p-string = {1}.
  return.
end.
p-string = substitute("'&1'", {1}).
