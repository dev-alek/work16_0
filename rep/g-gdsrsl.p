/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск реестра документов по поставщикам в продажных ценах

Автор: Булгаков Андрей Николаевич
Дата создания: 07/24/06
Author: Andrew Bulgakoff
Creation date: 07/24/06

*/

define input parameter p-parent-proc as widget-handle no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Запуск реестра документов по поставщикам в продажных ценах":U .

{ cmp/vssrevis.i     }
{ cmp/str-glbl.i     }
{ cmp/r-page1.i  new }

assign
  my-handle = p-parent-proc
.
run rep/d-report.w
  ( input p-parent-proc
  , input 'rep/e-gdsrsl.w'
  , input "Товарный отчет (реестр документов) по поставщикам в продажных ценах"
  , input 2
  , input "":U
  , input "{&o-currency}"
  , input "":U
  , input "":U /* "{&v-rubl},{&v-base}":U */
  , input "{&Arc-stk-yes},{&Arc-supp-yes}"
  , input no
  ) .
