/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита пересчета переоценок

Автор: Чернова Светлана Александровна
Дата создания: 04/12/06
Author: Svetlana Chernova
Creation date: 04/12/06

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Утилита пересчета переоценок".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }

define buffer buf_price-doc for price-doc.

for each buf_price-doc where buf_price-doc.status_ = {&act-overvalue} :
    run str/pr-oldd.p (buf_price-doc.doc-num )  .
end.