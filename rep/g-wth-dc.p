/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск отчета о движении материальных ценностей

Автор: Гридчина Полина Дмитриевна
Дата создания: 09/04/06
Author: Polina Gridchina
Creation date: 09/04/06

*/

define input parameter p-parent-proc as widget-handle no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Запуск отчета о движении материальных ценностей":U .

{ cmp/vssrevis.i     }
{ cmp/str-glbl.i     }
{ cmp/r-page1.i  new }

run rep/d-report.w
  ( input p-parent-proc
  , input 'rep/e-wth-dc.w'
  , input "Отчет о движении материальных ценностей"
  , input 5
  , input "":U
  , input "*":U
  , input "":U
  , input "":U
  , input "":U /* "{&Excel-yes}" */
  , input no
  ) .
