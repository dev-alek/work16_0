/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск списка настраиваемых полей

Автор: Бахтадзе Наталья Викторовна
Дата создания: 07/07/07
Author: Bakhtadze Natalya
Creation date: 07/07/07

*/

DEFINE INPUT PARAMETER parparentproc AS WIDGET-HANDLE NO-UNDO.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск списка настраиваемых полей".
{ cmp/vssrevis.i }

define variable v-rid-list as character no-undo .

run utl/cuslbls.w ( input parparentproc
                   ,input 'b-add':U
                   ,input '':U /*p-list-code*/
                   ,input-output v-rid-list ) no-error.