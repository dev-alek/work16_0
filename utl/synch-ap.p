/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Синхронизация Ассортиментной политики ГБД и УБД

Автор: Чернова Светлана Александровна
Дата создания: 05/26/08
Author: Svetlana Chernova
Creation date: 05/26/08

*/
define input  parameter parparentproc as widget-handle no-undo .
define input  parameter p-install     as logical no-undo init no .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Синхронизация Ассортиментной политики ГБД и УБД".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ gbl/waitfram.i }

if g#db-num <> 0 then do:
   message "Утилита для ГБД !!!"  view-as alert-box information .
   return .
end.

for each ub.assortment-matrix no-lock :
run waitfram-show (substitute("Шапка Ассортиментной матрицы  &1 &2" , ub.assortment-matrix.obj-type, ub.assortment-matrix.obj-code ) ).
    run str/callnews.p
      (input "assortment-matrix"
      ,input (buffer ub.assortment-matrix:handle)
      ) no-error .
end.
for each ub.assortment-matrix-goods no-lock :
run waitfram-show (substitute("Ассортиментная матрица  &1 &2 код товара &3"  , ub.assortment-matrix-goods.obj-type, ub.assortment-matrix-goods.obj-code, ub.assortment-matrix-goods.gds-code ) ).
    run str/callnews.p
      (input "assortment-matrix-goods"
      ,input (buffer ub.assortment-matrix-goods:handle)
      ) no-error .
end.

for each ub.gds-obj-prop no-lock :
run waitfram-show (substitute("ИЖТ  &1 &2 код товара &3"  , ub.gds-obj-prop.obj-type, ub.gds-obj-prop.obj-code, ub.gds-obj-prop.gds-code ) ).
    run str/callnews.p
      (input "gds-obj-prop"
      ,input (buffer ub.gds-obj-prop:handle)
      ) no-error .
end.

message "Все" view-as alert-box information .