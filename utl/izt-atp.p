/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита по объектам

Автор: Чернова Светлана Александровна
Дата создания: 11/07/08
Author: Svetlana Chernova
Creation date: 11/07/08

*/

define input  parameter parParentProc as handle no-undo .
define variable p-install     as logical no-undo init no .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

run utl/ord-atru.w ( parParentProc , "izt" ) .