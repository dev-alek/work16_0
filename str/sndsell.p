/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

пересылка продавцов на кассу - пускальник0

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/24/06
Author: Bakhtadze Natalya
Creation date: 03/24/06

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter i-obj-code like ub.shop.obj-code no-undo.
define input parameter mode as char no-undo .

/*"U' "D" "R" - справочник*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "пересылка продавцов на кассу - пускальник".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/stf-list.i "NEW SHARED" }

 run str/diallog.w (
        input parParentProc
      , input this-procedure
      , input "str/sendsell.p":U
      , input (string(i-obj-code) + {&delim-par} + mode)
      , input no /*p-auto-go*/
      , input "":U
      , input substitute("Отсылка продацов на кассы магазина &1", i-obj-code)
  ) no-error.