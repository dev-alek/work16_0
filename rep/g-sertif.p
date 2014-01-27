/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по сертификатам (скидкам)

Автор: Шальнев Иван Сергеевич
Дата создания: 31/05/11
Author: Shalnev ivan
Creation date: 31/05/11

*/
define input  parameter parParentProc  as widget-handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по сертификатам (скидкам)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i NEW}
run rep/d-report.w (
input parParentProc ,
input                   "rep/e-sertif.w",
input                   "Отчет по сертификатам (скидкам)",
input                   2,
input                   "":U,
input                   "{&o-currency},{&o-choice}":U,
input                   "",
input                   "{&v-rubl},{&v-base}",
input                   "{&Excel-yes}",
input                   no).