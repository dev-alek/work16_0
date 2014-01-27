/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Определение временной таблицы для заполнения истории для механизмов списков

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/17/05
Author: Bakhtadze Natalya
Creation date: 09/17/05

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

define  {2}  temp-table {1}-hist no-undo
field list-table as character
field id as integer
field line as integer
field hist-mode as character
field des as character
field num-recs as integer
field option_ as character
field item_ as character
field status_ as character
field num-add as integer
field num-ignored as integer
field done as logical
field err_ as logical
field err-mes as character
index pi is primary
id
line
index isdone
done
.


/* $Workfile$ e n d */