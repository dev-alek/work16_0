/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Прайс-лист с фотографиями товаров

Автор: Чернова Светлана Александровна
Дата создания: 05/05/10
Author: Svetlana Chernova
Creation date: 05/05/10

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Прайс-лист с фотографиями товаров".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page0.i new }
run rep/d-report.w (
      input parparentproc
      ,input 'rep/e-prphot.w'
      ,input 'Прайс-лист с фото товаров'
      ,input 1
      ,input "{&g-choice},{&g-one},{&g-grp-prod}"  /*товары*/
      ,input "{&o-currency}"
      ,input "{&p-crsa}"
      ,input ""
      ,input "all"
      ,input no ).