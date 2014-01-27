/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 79.

Автор: Чернова Светлана Александровна
Дата создания: 05/25/09
Author: Svetlana Chernova
Creation date: 05/25/09

Обработка таблиц:
archive-history
archive-history-attr
aht-doc
aht-gds
aht-ot-line
aht-ot-tot
aht-stk
aht-stk-line
aht-stk-tot
aht-time
ot-line
ot-tot
stk-line
stk-tot
hst-cli-tot
hst-cli-line
saldo-cli
ot-cli-tot
ot-cli-line
ot-supp-tot
ot-supp-line
stk-supp-tot
stk-supp-line
ot-line-attr
ot-supp-line-attr
ot-supp-tot-attr
ot-tot-attr
aht-doc-attr
aht-gds-attr
aht-ot-line-attr
aht-ot-tot-attr
aht-stk-attr
aht-stk-line-attr
aht-stk-tot-attr
aht-time-attr

stk-line-attr
stk-supp-line-attr
stk-supp-tot-attr
stk-tot-attr

hold-gds-grp-attr
hold-goods-attr
hold-purch-attr
hold-purch-grp-attr
hold-purch-supp-attr
hold-purch-supp-gds-attr
hold-sale-attr
hold-sale-grp-attr
hold-trn-attr
host-lk-attr


*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 14.".
{ cmp/str-glbl.i }

do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2))
:
{ utl/00000001.i }
output stream str-gen close.
return "Таблицы archive-history archive-history-attr aht-doc aht-gds aht-ot-line aht-ot-tot aht-stk aht-stk-line aht-stk-tot aht-time ot-line ot-tot stk-line stk-tot hst-cli-tot hst-cli-line ot-cli-tot ot-cli-line ot-supp-tot ot-supp-line saldo-cli stk-supp-tot stk-supp-line не экспортировались.".
end.