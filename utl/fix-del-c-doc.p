/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Поправка поля corr-user-db-num на текущую базу.
Раньше всё время был 0 т.к. подцеплялось инитовое значение.
Триггеры не отключал, чтобы всё в новости ушло.

Автор: Кирюхин Сергей
Дата создания: 23/04/14
Author: SKiryxin
Creation date: 23/04/14

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Поправка поля corr-user-db-num на текущую базу".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }

for each c-trn-doc where c-trn-doc.is-del = yes:
    c-trn-doc.corr-user-db-num = g#db-num.
end.