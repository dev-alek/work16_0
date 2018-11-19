/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Простая пересылка товаров на кассу по списку товаров

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/24/06
Author: Bakhtadze Natalya
Creation date: 03/24/06

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Простая пересылка товаров на кассу по списку товаров":U.
{ cmp/vssrevis.i }
{cmp/str-glbl.i} 
{ cmp/library.i  } 
{str/imp2cd.i &imp2cd_parparentproc = parparentproc}
for each ub.goods no-lock:
    run fill-gds-list(buffer ub.goods).
end.
run send-to-cash.   