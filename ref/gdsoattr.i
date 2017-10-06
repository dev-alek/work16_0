/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Библиотека для работы с атрибутами товара на объекте

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

&if defined (include_attr-lib) = 0 &then
{ gbl/attr-lib.i }
&endif

procedure gdsoattr-name :

  define input  parameter p-code           as character no-undo . /* код атрибута */
  define output parameter p-type           as character no-undo . /* тип атрибута */
  define output parameter p-format         as character no-undo . /* формат атрибута */
  define output parameter p-label          as character no-undo . /* лабел атрибута */
  define output parameter p-user-can-edit  as logical   no-undo . /* пользователь может изменять в броусе */
  define output parameter p-output-display as logical   no-undo . /* виден в броусе */
  define output parameter p-other          as character no-undo . /* еще чего - нибудь */

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-name
    {&run_proc_attr-lib}
      (input  p-code
      ,output p-type
      ,output p-format
      ,output p-label
      ,output p-user-can-edit
      ,output p-output-display
      ,output p-other
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.
end procedure.

procedure gdsoattr-tooltip :

  define input  parameter p-code    as character no-undo .
  define output parameter p-tooltip as character no-undo .
  define output parameter p-label   as character no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-tooltip
    {&run_proc_attr-lib}
      (input  p-code
      ,output p-tooltip
      ,output p-label
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.
end procedure.


procedure gdsoattr-value :

  define input  parameter p-code     like ub.gds-obj-attr.attr-code  no-undo .
  define input  parameter p-gds-code like ub.gds-obj-attr.gds-code   no-undo .
  define input  parameter p-obj-type like ub.gds-obj-attr.obj-type   no-undo .
  define input  parameter p-obj-code like ub.gds-obj-attr.obj-code   no-undo .
  define output parameter p-value    like ub.gds-obj-attr.attr-value no-undo .
  define output parameter p-type     as character no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-value
    {&run_proc_attr-lib}
      (input  p-code
      ,input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,output p-value
      ,output p-type
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure.


procedure gdsoattr-write :

  define input parameter p-gds-code like ub.gds-obj-attr.gds-code   no-undo .
  define input parameter p-obj-type like ub.gds-obj-attr.obj-type   no-undo .
  define input parameter p-obj-code like ub.gds-obj-attr.obj-code   no-undo .
  define input parameter p-code     like ub.gds-obj-attr.attr-code  no-undo .
  define input parameter p-value    like ub.gds-obj-attr.attr-value no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-write
    {&run_proc_attr-lib}
      (input p-gds-code
      ,input p-obj-type
      ,input p-obj-code
      ,input p-code
      ,input p-value
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure.


procedure gdsoattr-exist :

  define input  parameter p-gds-code like ub.gds-obj-attr.gds-code   no-undo .
  define input  parameter p-obj-type like ub.gds-obj-attr.obj-type   no-undo .
  define input  parameter p-obj-code like ub.gds-obj-attr.obj-code   no-undo .
  define input  parameter p-code     like ub.gds-obj-attr.attr-code  no-undo .
  define output parameter p-exist    as logical no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-exist
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,input  p-code
      ,output p-exist
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure.

procedure gdsoattr-delete :

  define input  parameter p-gds-code like ub.gds-obj-attr.gds-code   no-undo .
  define input  parameter p-obj-type like ub.gds-obj-attr.obj-type   no-undo .
  define input  parameter p-obj-code like ub.gds-obj-attr.obj-code   no-undo .
  define input  parameter p-code     like ub.gds-obj-attr.attr-code  no-undo .
  define output parameter p-deleted  as logical no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-delete
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,input  p-code
      ,output p-deleted
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure.

procedure gds-obj-doc-tickets :

  define input  parameter p-gds-code    like ub.gds-obj-attr.gds-code no-undo .
  define input  parameter p-obj-type    like ub.gds-obj-attr.obj-type no-undo .
  define input  parameter p-obj-code    like ub.gds-obj-attr.obj-code no-undo .
  define input-output parameter p-value as character no-undo .
  define output parameter p-setted      as logical no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-obj-doc-tickets
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,input-output p-value
      ,output p-setted
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-gds-margin */

procedure gds-obj-dop-alt-name :

  define input  parameter p-gds-code    like ub.gds-obj-attr.gds-code no-undo .
  define input  parameter p-obj-type    like ub.gds-obj-attr.obj-type no-undo .
  define input  parameter p-obj-code    like ub.gds-obj-attr.obj-code no-undo .
  define input-output parameter p-value as character no-undo .
  define output parameter p-setted      as logical no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-obj-dop-alt-name
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,input-output p-value
      ,output p-setted
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-dop-alt-name */

procedure gds-obj-gds-margins :

  define input  parameter p-gds-code    like ub.gds-obj-attr.gds-code no-undo .
  define input  parameter p-obj-type    like ub.gds-obj-attr.obj-type no-undo .
  define input  parameter p-obj-code    like ub.gds-obj-attr.obj-code no-undo .
  define input-output parameter p-value as character no-undo .
  define output parameter p-setted      as logical no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-obj-gds-margins
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,input-output p-value
      ,output p-setted
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-gds-margin */

procedure gds-attr-margin-value :

  define input  parameter p-gds-code         as integer   no-undo .
  define input  parameter p-obj-type         as character no-undo .
  define input  parameter p-obj-code         as integer   no-undo .
  define output parameter p-min-value        as decimal   no-undo initial ? .
  define output parameter p-max-value        as decimal   no-undo initial ? .
  define output parameter p-increase-pc      as decimal   no-undo initial ? .
  define output parameter p-rmethod          as character no-undo initial '':U .
  define output parameter p-base             as decimal   no-undo initial ? .
  define output parameter p-range-margin     as integer   no-undo .
  define output parameter p-exists-margin    as logical   no-undo .
  define output parameter p-range-increase   as integer   no-undo .
  define output parameter p-exists-increase  as logical   no-undo .
  define output parameter p-range-rmethod    as integer   no-undo .
  define output parameter p-exists-rmethod   as logical   no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-attr-margin-value
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,output p-min-value
      ,output p-max-value
      ,output p-increase-pc
      ,output p-rmethod
      ,output p-base
      ,output p-range-margin
      ,output p-exists-margin
      ,output p-range-increase
      ,output p-exists-increase
      ,output p-range-rmethod
      ,output p-exists-rmethod
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.
end procedure.

procedure gds-o-normal-wastage-value :
do
on error undo, return error
:
  define input parameter p-gds-code  as integer      no-undo.
  define input parameter p-obj-type  as character    no-undo.
  define input parameter p-obj-code  as integer      no-undo.
  define input parameter p-date      as date         no-undo.
  define output parameter p-normal-wastage-winter as decimal      no-undo init ?. /*ест. убыль зимой*/
  define output parameter p-normal-wastage-summer as decimal      no-undo init ?. /*ест. убыль летом*/
  define output parameter p-normal-wastage-date   as decimal      no-undo init ?. /*ест. убыль на указанную дату если p-date не ?*/
    &scop proc-name gds-o-normal-wastage-value
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,input  p-date
      ,output p-normal-wastage-winter
      ,output p-normal-wastage-summer
      ,output p-normal-wastage-date
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.
end.

procedure gdsoattr-copy :

  define input  parameter p-code as character no-undo . /* код атрибута */
  define output parameter p-copy as logical   no-undo . /* копируется при копировании товара - если включены соответ настройки */

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-copy
    {&run_proc_attr-lib}
      (input  p-code
      ,output p-copy
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.
end procedure.


&if "{1}" = "interface" or "{1}" = "trigger"  &then

/*секция pop-up меню при ручном редактировании */

procedure gdsoattr-manual-edit :

  define input  parameter p-code        as character no-undo . /* код атрибута */
  define output parameter p-section-num as integer no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-manual-edit
    {&run_proc_attr-lib}
      (input  p-code
      ,output p-section-num
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.
end procedure.
&endif

&if "{1}" = "interface" &then
procedure gdsoattr-batch-edit :

  define input  parameter p-code        as character no-undo . /* код атрибута */
  define output parameter p-section-num as integer   no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gdsoattr-batch-edit
    {&run_proc_attr-lib}
      (input  p-code
      ,output p-section-num
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.
end procedure.

procedure gds-obj-sum-grps :

  define input  parameter p-gds-code like ub.gds-obj-attr.gds-code no-undo .
  define input  parameter p-obj-type like ub.gds-obj-attr.obj-type no-undo .
  define input  parameter p-obj-code like ub.gds-obj-attr.obj-code no-undo .
  define input-output parameter p-value as character no-undo .
  define output parameter p-setted as logical no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-obj-sum-grps
    {&run_proc_attr-lib}
      (input {2}
      ,input p-gds-code
      ,input p-obj-type
      ,input p-obj-code
      ,input-output p-value
      ,output p-setted
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-sum-grps */


procedure gds-obj-init-increase-pc :

  define input  parameter p-gds-code like ub.goods.gds-code   no-undo .
  define input  parameter p-obj-type like ub.gds-obj.obj-type no-undo .
  define input  parameter p-obj-code like ub.gds-obj.obj-code no-undo .
  define output parameter p-value    as character no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-obj-init-increase-pc
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,output p-value
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-init-increase-pc */


procedure gds-obj-round-method :

  define input parameter p-gds-code like ub.gds-obj-attr.gds-code no-undo .
  define input parameter p-obj-type like ub.gds-obj-attr.obj-type no-undo .
  define input parameter p-obj-code like ub.gds-obj-attr.obj-code no-undo .
  define input-output parameter p-value as character no-undo .
  define output parameter p-setted as logical no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-obj-round-method
    {&run_proc_attr-lib}
      (input p-gds-code
      ,input p-obj-type
      ,input p-obj-code
      ,input-output p-value
      ,output p-setted
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-round-method */


procedure gds-obj-taracode :

  define input parameter p-gds-code like ub.gds-obj-attr.gds-code no-undo .
  define input parameter p-obj-type like ub.gds-obj-attr.obj-type no-undo .
  define input parameter p-obj-code like ub.gds-obj-attr.obj-code no-undo .
  define input-output parameter p-value as character no-undo .
  define output parameter p-setted as logical no-undo .

  do
  on error undo, return error return-value
  :
    &scop proc-name gds-obj-taracode
    {&run_proc_attr-lib}
      (input {2}
      ,input p-gds-code
      ,input p-obj-type
      ,input p-obj-code
      ,input-output p-value
      ,output p-setted
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-taracode */


procedure gds-obj-attr_check-ptrl-divis :

  define input  parameter p-gds-code like ub.goods.gds-code   no-undo .
  define input  parameter p-obj-type like ub.gds-obj.obj-type no-undo .
  define input  parameter p-obj-code like ub.gds-obj.obj-code no-undo .
  define input  parameter p-value       as character no-undo .
  define input  parameter p-mode        as character no-undo .
  define output parameter p-correct     as logical   no-undo .
  define output parameter p-error-code  as character no-undo .

  do
  on error undo, return error
  :
    &scop proc-name gds-obj-attr_check-ptrl-divis
    {&run_proc_attr-lib}
      (input  p-gds-code
      ,input  p-obj-type
      ,input  p-obj-code
      ,output p-correct
      ,output p-error-code
      ) no-error .
    if error-status :error
    then do:
      undo, return error return-value .
    end.
  end.

end procedure. /* gds-obj-attr_check-ptrl-divis */

&endif

/* $Workfile$ e n d */