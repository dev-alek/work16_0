/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оболочка для вызова restseq.p

Автор: Бахтадзе Наталья Викторовна
Дата создания: 07/02/08
Author: Bakhtadze Natalya
Creation date: 07/02/08

*/

define input parameter p-action    as character no-undo.
  /* "check" - проверка, "rest" - восстановление */
  /* "check-no-msg" - проверка, без сообщения в конце, "rest-no-msg" - восстановление, без сообщения в конце*/
define input parameter p-seq-list  as character no-undo .
  /*пусто - все sequence или список нужных*/
define input parameter p-first-err as logical no-undo .
  /*yes - работа до первой ошибки, no - ошибки игнорируются */


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Оболочка для вызова restseq.p".
{ cmp/vssrevis.i }

create alias restseq    for database value( ldbname( "ub":U ) ) .
create alias restseqflt for database value( ldbname( "ubflt":U ) ) .
run adm/restseq.p
  ( input p-action
    ,input p-seq-list
    ,input p-first-err
  ) no-error .
if error-status :error then do:
  delete alias restseqflt.
  delete alias restseq.
  return error return-value .
end.
delete alias restseqflt.
delete alias restseq.


