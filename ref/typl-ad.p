/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обёртка для использования процедур из ref/typl-ad.i в классах 

Автор: Молотков Сергей Михайлович
Дата создания: 01/11/17
Author: Molotkov Sergey
Creation date: 01/11/17

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Процедуры довавления и удаления типов прайс-листов".

{ cmp/str-glbl.i } /* {&pdf-new} */
{ ref/typl-ad.i }
{ ref/obji-ad.i }