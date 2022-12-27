/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по пересменкам

Автор: 
Дата создания: 08/09/07
Author: Dmitry Ukhanov
Creation date: 08/09/07

Автор1: 
Дата создания: 04/13/06

*/

define input parameter parparentproc as widget-handle no-undo .
/*define input parameter custom-par    as character     no-undo .*/
define variable custom-par as character no-undo .
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "запуск Сводный отчет по поставкам топлива":U .

{ cmp/str-glbl.i     }
{ cmp/r-page0.i  new }
{ cmp/vssrevis.i     }

&scop ttl " Отчет по анализу длительности пересменка (Простой реализации до первого чека) "
custom-par = "all,{&Arc-OT-yes},{&Arc-Supp-yes},{&Arc-stk-yes},{&Excel-yes}" + {&comma-char} + "TOG-Shift-2 = yes" + {&comma-char} + custom-par.
run rep/d-report.w (
                input parparentproc ,
                input 'rep/e-preal.w',
                {&ttl},
                input 4,
                "", /* выбор товара */
                input "{&o-firm},{&o-currency},{&o-choice}",  /* выбор объекта */
                input "",
                input "",
                input custom-par,
                input no).

/* $Workfile$   E n d */