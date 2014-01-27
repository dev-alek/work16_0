/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Ссылка на библиотеку работы с документами

Автор: Чернова Светлана Александровна
Дата создания: 10/09/06
Author: Svetlana Chernova
Creation date: 10/09/06

create : Суслов Алексей Юрьевич

*/
&if defined (include_lib-trn) = 0 &then
&glob include_lib-trn yes
define new global shared variable g#lib-trn  as handle no-undo .
define new global shared variable g#lib-trn2 as handle no-undo .
define new global shared variable g#lib-trn3 as handle no-undo .
define new global shared variable g#lib-trn4 as handle no-undo .

&glob check_lib-trn if (valid-handle(g#lib-trn) <> true) then do: ~
  run str/lib-trn.p persistent no-error . ~
  if error-status :error or (valid-handle(g#lib-trn) <> true) then do: ~
    message ~
      "Error starting lib-trn.p" skip ~
      g#lib-trn skip ~
      g#lib-trn :type skip ~
      g#lib-trn :file-name skip ~
      error-status :get-message(1) skip ~
      return-value skip ~
      view-as alert-box error . ~
    stop . ~
  end. ~
end.

&glob check_lib-trn2 if (valid-handle(g#lib-trn2) <> true) then do: ~
  run str/lib-trn2.p persistent no-error . ~
  if error-status :error or (valid-handle(g#lib-trn2) <> true) then do: ~
    message ~
      "Error starting lib-trn2.p" skip ~
      g#lib-trn2 skip ~
      g#lib-trn2 :type skip ~
      g#lib-trn2 :file-name skip ~
      error-status :get-message(1) skip ~
      return-value skip ~
      view-as alert-box error . ~
    stop . ~
  end. ~
end.

&glob check_lib-trn3 if (valid-handle(g#lib-trn3) <> true) then do: ~
  run str/lib-trn3.p persistent no-error . ~
  if error-status :error or (valid-handle(g#lib-trn3) <> true) then do: ~
    message ~
      "Error starting lib-trn3.p" skip ~
      g#lib-trn3 skip ~
      g#lib-trn3 :type skip ~
      g#lib-trn3 :file-name skip ~
      error-status :get-message(1) skip ~
      return-value skip ~
      view-as alert-box error . ~
    stop . ~
  end. ~
end.

&glob check_lib-trn4 if (valid-handle(g#lib-trn4) <> true) then do: ~
  run str/lib-trn4.p persistent no-error . ~
  if error-status :error or (valid-handle(g#lib-trn4) <> true) then do: ~
    message ~
      "Error starting lib-trn4.p" skip ~
      g#lib-trn4 skip ~
      g#lib-trn4 :type skip ~
      g#lib-trn4 :file-name skip ~
      error-status :get-message(1) skip ~
      return-value skip ~
      view-as alert-box error . ~
    stop . ~
  end. ~
end.

&glob run_proc_lib-trn {&check_lib-trn} ~
run ~{&proc-name~} in g#lib-trn

&glob run_proc_lib-trn2 {&check_lib-trn2} ~
run ~{&proc-name~} in g#lib-trn2

&glob run_proc_lib-trn3 {&check_lib-trn3} ~
run ~{&proc-name~} in g#lib-trn3

&glob run_proc_lib-trn4 {&check_lib-trn4} ~
run ~{&proc-name~} in g#lib-trn4

&endif
/* $Workfile$ e n d */