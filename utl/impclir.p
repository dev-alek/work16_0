/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск импорта клиентов

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/23/08
Author: Bakhtadze Natalya
Creation date: 09/23/08

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск импорта клиентов".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/cli-list.i cli-list def "NEW SHARED" } /*нужно для rum*/

run str/diallog.w (
      input parParentProc
    , input this-procedure
    , input "utl/thbjrumr.w":U
    , input {&table_clients} + {&delim-par} +
             /*parameter - второй элемент списка - это radio-buttons rs-ruleset d thbjrumr*/
           {&clients-proc_text-import} + {&comma-char} +
           {&clients-proc_xml-file-import}     /*parameter - второй элемент списка - это radio-buttons rs-ruleset d thbjrumr*/
    , input no /*p-auto-go*/
    , input "&Стоп"
    , input substitute("Операции над клиентами") ) no-error .