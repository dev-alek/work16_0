/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

АКТ учета нефтепродуктов при выполнении работ по проверке погрешности ТРК

Автор: Уханов Дмитрий Юрьевич
Дата создания: 11/22/05
Author: Dmitry Ukhanov
Creation date: 11/22/05

*/

/* Parameter Definitions */
define input parameter p-parent-proc as widget-handle no-undo.

/* VSS Variable Definitions ---                                         */
define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "АКТ учета нефтепродуктов при выполнении работ по проверке погрешности ТРК":U.

/* Common Definitions */
{ cmp/vssrevis.i     }
{ cmp/str-glbl.i     }
{ cmp/r-page1.i  new }

/* ***************************  Main Block  *************************** */
run rep/d-report.w ( input p-parent-proc,
                 input "rep/r-ptrpmp.p":U,
                 input "АКТ учета нефтепродуктов при выполнении работ по проверке погрешности ТРК":U,
                 input 1,
                 input "":U,
                 input "*":U,
                 input "":U,
                 input "":U,
                 input "all,{&Excel-yes}":U,
                 input yes                                 ).

/* $Workfile$   E n d */
