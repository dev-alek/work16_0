/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск утилиты смены владельца ДК

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/12/06
Author: Bakhtadze Natalya
Creation date: 05/12/06

*/

define input parameter parparentproc as widget-handle.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск утилиты смены владельца ДК".
{ cmp/vssrevis.i }

run str/diallog.w (
              input parparentproc
            , input this-procedure
            , input 'dc-chown.p':U
            , input '':U
            , input no /*p-auto-go*/
            , input 'Прервать'
            , input 'СМЕНА ВЛАДЕЛЬЦА ДИСКОНТНЫХ КАРТ') no-error .