/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Маленький толкач для просмотра из продажи оборота в учетных ценах - исключает конфликт по t-doc

Автор: Чернова Светлана Александровна
Дата создания: 10/10/06
Author: Svetlana Chernova
Creation date: 10/10/06

create: Суслов Алексей Юрьевич

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter rd as recid.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Маленький толкач для просмотра из продажи оборота в учетных ценах - исключает конфликт по t-doc".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

def new shared buffer t-doc for trn-doc.
find first t-doc where recid(t-doc) = rd no-lock no-error.
if not avail t-doc then return.

run str/docsuppn.w
  (input  parparentproc
  ,input  recid(t-doc)
  ).