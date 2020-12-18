/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Движение денежных средств

Автор: Комаров Иван Сергеевич
Дата создания: 04/29/10
Author: Ivan Komarov
Creation date: 04/29/10

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Движение денежных средств".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.

{ cmp/str-glbl.i }

run rep/dreport.p (
                input parParentProc ,
                input 'ibs.th.rep.eddinam',"Движение денежных средств",
                input 4,
                input "",
                input "*",
                input "",
                input "",
                input "all,{&Excel-yes}",
                input no).
