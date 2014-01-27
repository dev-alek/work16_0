/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Точкач  получения архива чеков с кассы NCR за предыдущий операционный день

Автор: Бахтадзе Наталья Викторовна
Дата создания: 12/23/03
Author: Bakhtadze Natalya
Creation date: 12/23/03

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Точкач  получения архива чеков с кассы NCR за предыдущий операционный день".
{ cmp/vssrevis.i }


{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }

run str/diallog.w (
                 parparentproc
               , this-procedure
               , 'str/getncrye.p':U
               , (v-cntxt-obj-type + {&delim-par} + string(v-cntxt-obj-code))
               , no
               , ''
               , 'Получение архива чеков с касс NCR за предыдущий операционный день').