/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

утилита закачки весовых кодов для уже ИМЕЮЩИХСЯ в БД товаров - толкач

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

run utl/easyimp.w ("Импорт  весовых кодов", "utl/ucvespbc.p") no-error.