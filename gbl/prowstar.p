/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск процедуры просмотра сессий Progress

Автор: Перваков Михаил Сергеевич
Дата создания: 06/06/03
Author: Mikhail Pervakov
Creation date: 06/06/03

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
create widget-pool .
define var w-prowstar as widget-handle no-undo.
create window w-prowstar assign
        title              = "Сессии PROGRESS"
        column             = 2
        row                = 2
        height             = 1
        width              = 30
        resize             = false
        scroll-bars        = false
        status-area        = false
        three-d            = true
        message-area       = false
        sensitive          = true
        visible            = true
        .

assign
  current-window = w-prowstar
.

run gbl/prwnshow.p .
quit .