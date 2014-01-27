/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Просмотр документа переоценки

Автор: Чернова Светлана Александровна
Дата создания: 09/09/05
Author: Svetlana Chernova
Creation date: 09/09/05


*/

define input  parameter parParentProc as widget-handle no-undo.
define input  parameter t-rid as recid no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Просмотр документа переоценки".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }

do
on error undo, return error return-value
:
  def new shared var br-handle as handle no-undo.
  def new shared buffer p-doc for price-doc.
  define variable next-prev as logical   no-undo init true .

  DEFINE new shared QUERY br-docs FOR p-doc SCROLLING.

  open query br-docs for each p-doc where recid (p-doc) = t-rid no-lock.

  get first br-docs .
  run str/pr-doc.w
( input parParentProc   ,
  input-output  t-rid  ,
  input {&lookup}        ,
  input-output  next-prev ) .

end.