/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Чернова Светлана Александровна
Дата создания: 06/25/09
Author: Svetlana Chernova
Creation date: 06/25/09

*/

define input  parameter parparentproc as handle no-undo .
define input  parameter p-obj-type as character no-undo .
define input  parameter p-obj-code as integer   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }

define stream rpt .
output stream rpt to "price.txt" .


define buffer buf_gds-obj   for ub.gds-obj.
define buffer buf_bar-code  for ub.bar-code.
define buffer buf_goods     for ub.goods .
define buffer buf_price-doc for ub.price-doc  .

define variable v-price as decimal   no-undo .
define variable     v-cur-dn as character no-undo .
define variable     v-cur-rt as decimal   no-undo .
define variable     v-cur-ex as decimal   no-undo .

for each buf_gds-obj no-lock where
         buf_gds-obj.obj-type = p-obj-type and
         buf_gds-obj.obj-code = p-obj-code :
  for each buf_bar-code no-lock where
           buf_bar-code.gds-code = buf_gds-obj.gds-code :

{ gbl/bcodeprc.i
    buf_gds-obj.obj-type
    buf_gds-obj.obj-code
    buf_bar-code.b-code
    0
    0
    v-cur-dn
    v-price
    v-cur-rt
    v-cur-ex
    no-error }
    if error-status :error then next.
    if v-price = 0 or v-price = ? then next.

       Put stream  rpt unformatted
        buf_bar-code.b-code ";" v-price  skip.
  end.
end.
output stream rpt close.
message "все Смотри: price.txt".