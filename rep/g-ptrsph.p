/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск отчета почасовой статистики продаж ТРК с детализацией по пистолетам

Автор: Уханов Дмитрий Юрьевич
Дата создания: 08/09/07
Author: Dmitry Ukhanov
Creation date: 08/09/07

Автор1: Булгаков Андрей Николаевич
Дата создания: 07/24/06

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Запуск отчета почасовой статистики продаж ТРК с детализацией по пистолетам":U .

{ cmp/vssrevis.i     }
{ cmp/str-glbl.i     }
{ cmp/r-page1.i  new }

assign
  my-handle = parparentproc
.
run rep/d-report.w
  ( input parparentproc
  , input "rep/e-ptrsph.w"
  , input "Почасовая статистика продаж ТРК с детализацией по пистолетам"
  , input 8
  , input "":U
  , input "{&o-currency}"
  , input "":U
  , input "{&v-rubl}":U /* {&v-base} */
  , input "{&Excel-yes}"
  , input no
  ) .