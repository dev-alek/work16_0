/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Толкач процедуры Субъекты доставки

Автор: Чернова Светлана Александровна
Дата создания: 08/30/06
Author: Svetlana Chernova
Creation date: 08/30/06

*/
define input  parameter ParParentProc as handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Толкач процедуры Типы доставки".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
define variable v-sts as integer   no-undo .
define variable v-rid-list as character no-undo .

run ref/dlvsubjs.w (input parParentProc
              , v-cntxt-obj-type
              , v-cntxt-obj-code
              , "b-add,b-del,b-chg":U
              , {&all}
              , input-output v-sts
              , input-output v-rid-list ) no-error .