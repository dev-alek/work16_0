/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Расчет себестоимости за день  на АЗС

Автор: Чернова Светлана Александровна
Дата создания: 03/03/06
Author: Svetlana Chernova
Creation date: 03/03/06

Дата создания: 06/15/05
*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Расчет себестоимости за день".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/r-seb1c.p',
    "Выгрузка данных по реализации в учетных ценах (.dbf)",
    2,
    "":U,
    "{&o-firm},{&o-currency},{&o-choice}",
    "" ,
    "",
    "all,{&Excel-yes},{&Arc-stk-yes}",
    yes).