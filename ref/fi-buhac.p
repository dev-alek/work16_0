/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Импорт из Текстового файла корреспондирующих счетов.

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 11/17/03 1:19

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Импорт из бухгалтерии Корреспондирующих счетов.    ".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ ref/crfincd.i  ub.fin-code-cor-acc}
{ gbl/waitfram.i }

 define input-output parameter  rr            as recid no-undo .
 define input parameter         par-host-code as integer no-undo .

message "АРМ Бухгалтерия не поддерживается "  view-as alert-box information .
return .

/* todo сделать из текстового файла */