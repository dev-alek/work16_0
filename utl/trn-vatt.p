/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

толкач для Утилиты коррекции партий внешнего прихода закрытого на факт

Автор: Чернова Светлана Александровна
Дата создания: 02/21/08
Author: Svetlana Chernova
Creation date: 02/21/08

*/

define input parameter parparentproc as handle no-undo.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "толкач для Утилиты коррекции партий внешнего прихода закрытого на факт".
{ cmp/vssrevis.i }

run utl/trn-vat.p ( parparentproc , '' ) .