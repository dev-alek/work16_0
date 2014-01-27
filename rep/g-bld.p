/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет о реализации блюд и товаров в рознице

Автор: Суслов Алексей Юрьевич
Дата создания: 03/24/06
Author: Alexey Suslov
Creation date: 03/24/06

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет о реализации блюд и товаров в рознице".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w (
input parParentProc ,
input                       'rep/r-bld.p',
input                       'Отчет о реализации блюд и товаров в рознице',
input                        2,
input                        "",
input                        "*",
input                        "",
input                        "",
input                        "all,{&Arc-stk-yes}",
input                        yes).