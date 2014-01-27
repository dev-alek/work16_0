/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Динамика движения товара - запуск 2

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/27/03
Author: Bakhtadze Natalya
Creation date: 05/27/03

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Динамика движения товара - запуск 2".
{ cmp/vssrevis.i }

{ cmp/r-page1.i }
define shared buffer buf_goods for ub.goods.

run rep/r-dinamo.w (input my-handle, buf_goods.gds-code) no-error .