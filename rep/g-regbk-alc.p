
/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Журнал учёта объёма розничной продажи алкогольной и спиртосодержащей продукции

Автор: Шутилов Арнольд Валерьевич
Дата создания: 02/02/10
Author: Arnold Shutilov
Creation date: 15/10/14

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Журнал учёта розничной продажи алкоголя".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

define input  parameter parParentProc as widget-handle no-undo.

run rep/d-report.w (
                input parParentProc,
                input "rep/r-regbk-alc2015.p " + string(parParentProc), /* Вызываем файл отчёта + Параметр к нему. (Вообще, если работаем с 1 закладкой, то сразу, если есть 2 закладки, то вызов при переходе с 1-й на 2-ю закладку) */
                input "Журнал учёта розничной продажи алкоголя",    /* Наименование окна rep/s-object.w (которое вызовется из d-report.w */
                input 2,                                            /* Используется две даты (задание периода отчёта) */
                input "{&g-all},{&g-grp}",
                input "{&o-currency},{&o-choice}",
                input "",                                           /* Форма для выбора товара - здесь не используется. */
                input "",
                input "all,{&Excel-yes}",                           /* На всякий случай вывод галочки для excel (было в образце) */
                input yes).                                         /* Используем одну закладку */