/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Список объектов

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

*/
&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
def {1} shared temp-table &if "{2}" <> "" &then {2} &else obj-list &endif NO-UNDO
  field obj-type like ub.clients.obj-type
  field obj-code like ub.clients.obj-code
  field obj-name like ub.clients.obj-name
  field obj-id   as integer
  field db-num   as integer
  index pi is primary unique obj-id
  index ie1 obj-type obj-code
  index ie2 obj-name
.

&if "{2}" = "" &then

/* Процедура создания записи в ТТ obj-list */
procedure create_obj-list{2} :
 do
 on error undo, return error return-value
 :
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define buffer cli-obj for ub.clients .
define variable p-var as integer no-undo .

define buffer buf_obj-list for obj-list .

find last buf_obj-list  use-index pi no-error .
      if available buf_obj-list then p-var = buf_obj-list.obj-id + 1.
                            else p-var = 1.

find FIRST cli-obj where
           cli-obj.obj-type = p-obj-type
       and cli-obj.obj-code = p-obj-code
     no-lock no-error.

if available cli-obj then do:
    create buf_obj-list.
    assign
        buf_obj-list.obj-id   = p-var
        buf_obj-list.obj-code = cli-obj.obj-code
        buf_obj-list.obj-type = cli-obj.obj-type
        buf_obj-list.obj-name = cli-obj.obj-name
        buf_obj-list.db-num   = cli-obj.db-num
        .
end.

 end. /* do */
end procedure. /* create_obj-list */
&endif

/* $Workfile$ e n d */