/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Показать информацию о текущем модуле

Автор: Перваков Михаил Сергеевич
Дата создания: 01/14/03
Author: Mikhail Pervakov
Creation date: 01/14/03

*/

on alt-shift-f2 anywhere do:
if ibs.th.gbl.gbl-var:rcode
then
  run gbl\inidebug.p .
end.


on alt-shift-f3 anywhere do:
  run proc-alt-shift-f3 in this-procedure .
end.

procedure proc-alt-shift-f3:
  run gbl/prvssinf.p
    ( input this-procedure
    ) .
end procedure.

define variable v-inform-launched as logical no-undo initial false .

on alt-shift-f4 anywhere do:
  run proc-alt-shift-f4 in this-procedure.
end.

procedure proc-alt-shift-f4:
  define variable v-action as character no-undo .

  if v-inform-launched = false then do:
    assign
      v-inform-launched = true
    .
    run gbl/d-inform.w
      (  input self
      ,  input this-procedure
      , output v-action
      ) no-error .
    run gbl/infrmact.p (input self, input this-procedure, input v-action) no-error .
    assign
      v-inform-launched = false
    .
  end.

end procedure.

on alt-f1 anywhere do:
  run proc-alt-f1 in this-procedure .
end.

procedure proc-alt-f1:
  run gbl/corrhelp.p
    (input this-procedure
    ) .
end procedure.

/* $Workfile$   E n d */
