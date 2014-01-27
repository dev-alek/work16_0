/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на удаление записи свойств атрибута

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/29/07
Author: Bakhtadze Natalya
Creation date: 05/29/07

*/

TRIGGER PROCEDURE FOR DELETE OF ub.attr-prop.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Триггер на удаление записи свойств атрибута".
{ cmp/vssrevis.i "substitute('&1|&2|&3'
                         , ub.attr-prop.table-name
                         , ub.attr-prop.templ-rl-root
                         , ub.attr-prop.node-code
                         ) " }

{ cmp/trg-def.i }

define variable v-start-level as integer no-undo .
define variable level as integer no-undo .
define variable v-p as character no-undo .
define variable v-confirmed as logical no-undo .

main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:


  /*проверим от куда вызвали*/
  assign
  v-start-level = 2
  .
  assign
    level = v-start-level
  .
  _repeat:
  repeat while program-name( level ) <> ? :
    v-p = program-name( level ).
    if substring(v-p, length(v-p) - length("attrprp0.p") + 1) = "attrprp0.p":U
    or substring(v-p, length(v-p) - length("attrprp0.p") + 1) = "attrprp0.r":U
    then do:
      v-confirmed = yes.
      leave _repeat.
    end.
    assign
      level = level + 1
    .
  end.
  if not v-confirmed then do:
    message
      vss-workfile vss-revision vss-description skip
      "Физическое удаление записи конфигурации атрибутов в системе запрещено" skip
      view-as alert-box error .
    undo main-block, return error.
  end.
end.