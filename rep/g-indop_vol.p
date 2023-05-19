/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Прием топлива с превышением предельно допустимого объема резервуара

Автор: 
Дата создания: 08/09/07
Author: Dmitry Ukhanov
Creation date: 08/09/07

*/

define input parameter parparentproc as widget-handle no-undo .
/*define input parameter custom-par    as character     no-undo .*/
define variable custom-par as character no-undo .
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Прием топлива с превышением предельно допустимого объема резервуара":U .

{ cmp/str-glbl.i     }
{ cmp/r-page0.i  new }
{ cmp/vssrevis.i     }

&scop ttl " Прием топлива с превышением предельно допустимого объема резервуара "
custom-par = "all,{&Arc-OT-yes},{&Arc-Supp-yes},{&Arc-stk-yes},{&Excel-yes}" + {&comma-char} + "TOG-Shift-2 = yes" + {&comma-char} + custom-par.
run rep/d-report.w (
                input parparentproc ,
                input 'rep/e-indop_vol.w',
                {&ttl},
                input 4,
                "{&g-all},{&g-choice}:'petrol'", /* выбор товара */
/*                "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one}",  выбор товара */
/*                input "{&o-firm},{&o-currency},{&o-choice}",   выбор объекта */
                input "*",                                       /* выбор объекта все*/
                input "",
                input "",
                input custom-par,
                input no).


/* $Workfile$   E n d */