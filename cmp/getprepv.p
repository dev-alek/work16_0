/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Распознавание препроцессинга на ходу

Автор: Бахтадзе Наталья Викторовна
Дата создания: 11/28/05
Author: Bakhtadze Natalya
Creation date: 11/28/05

*/

define output parameter p-prep-value as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Распознавание препроцессинга на ходу".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

P-PREP-VALUE = "{1}".
