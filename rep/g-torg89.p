/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по движению СТ. НТФ-8.9 (Кедр-М)

Автор: Комаров Иван Сергеевич
Дата создания: 02/05/10
Author: Ivan Komarov
Creation date: 02/05/10

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по движению СТ. НТФ-8.9 (Кедр-М)".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
                input parParentProc ,
                input 'rep/r-torg89.p',"Отчет по движению сопутствующих товаров на АЗС\АЗК (ТОРГ8.9)",
                input 8,
                input "{&g-grp}":U,
                input "{&o-currency}":U,
                input "",
                input "",
                input "all,{&Excel-yes},{&Arc-ot-yes}",
                input yes).