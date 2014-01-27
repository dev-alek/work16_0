/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура ПРИЕМа ответов и прописания статусов EDOC-nn

Автор: Чернова Светлана Александровна
Дата создания: 10/02/08
Author: Svetlana Chernova
Creation date: 10/02/08

*/

define input  parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Процедура приема ответов и прописания статусов EDOC-nn".

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/trg-def.i }

{ gbl/key-rec.i  }

define buffer buf_ord-doc for ub.ord-doc.
define buffer buf_trn-doc for ub.trn-doc.
message
"Прием документов по электронному документообороту проводится автоматически подсистемой OXML" skip
"Обновите список заказов нажатием клавиши F5, чтобы увидеть изменения состояния заказов"
view-as alert-box .

