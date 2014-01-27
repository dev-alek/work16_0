/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пересылка персонала - для АРМ ресторан

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/06/06
Author: Bakhtadze Natalya
Creation date: 04/06/06

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define input parameter mode       as character no-undo .
/*"U' "D" "R" - справочник*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Пересылка персонала - для АРМ ресторан".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }


{ cmp/stf-list.i "NEW SHARED" }


 run str/diallog.w (
        input parParentProc
      , input this-procedure
      , input "str/sendstaf.p":U
      , input (p-obj-type +  {&delim-par} + string(p-obj-code) + {&delim-par} + mode)
      , input no /*p-auto-go*/
      , input "":U
      , input substitute("Отсылка персонала на кассы магазина &1", p-obj-code)
  ) no-error.