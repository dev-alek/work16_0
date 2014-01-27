/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать документа измреения погрешности счетчиков ТРК

Автор: Бахтадзе Наталья Викторовна
Дата создания: 07/27/07
Author: Bakhtadze Natalya
Creation date: 07/27/07

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-recid as recid no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать документа измреения погрешности счетчиков ТРК".
{ cmp/vssrevis.i }

message
"Не предусмотрено печатной формы для документа"  skip
"СМ. СМЕННЫЙ ОТЧЕТ"
view-as alert-box .