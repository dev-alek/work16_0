/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск отчета по розничной реализации нефтепродуктов на АЗК (Украина)

Автор: Уханов Дмитрий Юрьевич
Дата создания: 05/05/06
Author: Dmitry Ukhanov
Creation date: 05/05/06

*/

define input parameter p-parent-proc as widget-handle no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Запуск отчета по розничной реализации нефтепродуктов на АЗК (Украина)":U .

{ cmp/vssrevis.i     }
{ cmp/str-glbl.i     }
{ cmp/r-page1.i  new }

run rep/d-report.w
  ( input p-parent-proc
  , input 'rep/r-slptlu.p'
  , input "Отчет по розничной реализации нефтепродуктов на АЗК"
  , input 4
  , input "":U
  , input "{&o-choice}"
  , input "":U
  , input "":U
  , input "{&Excel-yes}"
  , input yes
  ) .
