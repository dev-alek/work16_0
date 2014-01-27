 /*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Представленность матрицы товаров на объекте- запуск

Автор: Демин Алексей Сергеевич
Дата создания: 09/03/07
Author: Alexey Demin
Creation date: 09/03/07

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Представленность матрицы товаров на объекте - запуск".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

run rep/d-report.w (
                  input parparentproc
                  ,input 'rep/e-mattov.w'
                  ,input ('Представленность матрицы товаров на объекте')
                  ,input 0  /*param-date*/
                  ,input "*" /*param-goods*/
                  ,input ""  /*param-obj*/
                  ,input ""  /*param-pay*/
                  ,input ""  /*param-pay-hide*/
                  ,input ""
                  ,input no).

