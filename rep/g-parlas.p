/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вызов редактирования сроков годности по партиям товара

Автор: Чернова Светлана Александровна
Дата создания: 03/21/08
Author: Svetlana Chernova
Creation date: 03/21/08


*/

define input parameter parparentproc as handle           no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет по срокам годности товаров.".
{ cmp/vssrevis.i    }
{ cmp/trg-def.i     }
{ cmp/r-page1.i new }
{ gbl/getcntxt.i def }

do
on error undo, return error
:

  { gbl/getcntxt.i get }

  define variable v-ok as logical   no-undo .
  { gbl/chk-actg.i
    v-cntxt-db-num
    v-cntxt-userid
    {&action-head-code-main}
    'actn_income_update-last-date':U
    {&cntxt-object}
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    0
    0
    0
    true
    v-ok
  }
  if v-ok <> true
  then do:
    undo, return error return-value .
  end.

  run rep/d-report.w
    (input parparentproc
    ,input 'rep/e-parlas.w'
    ,input "Редактирование сроков годности партий товара"
    ,input 0
    ,input "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":U
    ,input "*"
    ,input ""
    ,input ""
    ,input "all"
    ,input no
    ).
end.