/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Находит необходимый шаблон печати, на который устанавливается броуз шаблонов

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/12/06
Author: Bakhtadze Natalya
Creation date: 04/12/06

*/

define input parameter c-p as character no-undo .
define output parameter p-flt-rec as recid no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Находит необходимый шаблон печати, на который устанавливается броуз шаблонов".
{ cmp/vssrevis.i "substitute('&1',c-p)"}
{ cmp/trg-def.i }

find ubflt.usr-flt no-lock
  where ubflt.usr-flt.user-name = g#userid
    and ubflt.usr-flt.call-point = c-p
  no-error .
if available ubflt.usr-flt then do:
  find ubflt.filter no-lock
    where ubflt.filter.call-point = ubflt.usr-flt.call-point
      and ubflt.filter.naim       = ubflt.usr-flt.naim
    no-error .
  if available ubflt.filter then do:
    assign
     p-flt-rec = recid (ubflt.filter)
    .
  end.
  else do:
    assign
    p-flt-rec = ?
    .
  end.
end.
else do:
  assign
  p-flt-rec = ?
  .
end.