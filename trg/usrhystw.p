/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на запись истории пользователя.

Автор: Гюнтнер Виктор Арнольдович
Дата создания: 04/01/08
Author: Victor Guntner
Creation date: 04/01/08

Input:

Output:

*/
&Glob main-tbl c-user-log
trigger procedure for write of ub.{&main-tbl}
  new buffer new-{&main-tbl}
  old buffer old-{&main-tbl}
.

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo init "Тригер изменение {&main-tbl}". 

{ trg/trghistnws.i 
  &nws  = yes
  &nobufhist = yes
  
}
