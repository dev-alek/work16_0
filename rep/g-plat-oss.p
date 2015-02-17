/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет Платежи ОСС

Автор: Кривошеин Александр Николаевич
Дата создания: 02/09/14
Author: Krivoshein Alexander
Creation date: 02/09/14

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision: $":U .
define variable vss-author      as character no-undo init "$Author: $":U .
define variable vss-date        as character no-undo init "$Date: $":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет Платежи ОСС".

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }


run rep/d-report.w
    (
    input parParentProc ,
    input 'rep/e-plat-oss.w',
    "Платежи ОСС",
    4,
    "",
    "*",
    "" ,
    "",
    "all,{&format-folder},{&Excel-yes}",
    no).
