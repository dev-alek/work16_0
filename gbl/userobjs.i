/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Библиотека для выбора объекта или списка объекта

Автор: Белоусов Илья Александрович
Дата создания: 05/08/07
Author: Ilia Belousov
Creation date: 05/08/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 04/20/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

&global-define include_userobjs ok

define temp-table userobjs_temp-user-obj no-undo
  field obj-type as character
  field obj-code as integer

  index xpk is primary unique obj-type obj-code
  .

procedure userobjs_clear :

  define buffer buf_userobjs_temp-user-obj for userobjs_temp-user-obj .

  do
  on error undo, return error return-value
  :
    for each buf_userobjs_temp-user-obj
    on error undo, return error return-value
    :
      delete buf_userobjs_temp-user-obj .
    end.
  end.

end procedure. /* userobjs_clear */

procedure userobjs_object-count :

  define output parameter p-total-count as integer   no-undo .

  define buffer buf_userobjs_temp-user-obj for userobjs_temp-user-obj .

  do
  on error undo, return error return-value
  :
    assign
      p-total-count = 0
    .

    for each buf_userobjs_temp-user-obj
    on error undo, return error return-value
    :
      assign
        p-total-count = p-total-count + 1
      .
    end.
  end.

end procedure. /* userobjs_object-count */

procedure userobjs_append :

  define input  parameter p-obj-type as character no-undo .
  define input  parameter p-obj-code as integer   no-undo .

  define buffer buf_userobjs_temp-user-obj for userobjs_temp-user-obj .

  do
  on error undo, return error return-value
  :
    find first buf_userobjs_temp-user-obj
      where buf_userobjs_temp-user-obj.obj-type = p-obj-type
        and buf_userobjs_temp-user-obj.obj-code = p-obj-code
      no-error .
    if not available buf_userobjs_temp-user-obj
    then do:
      create buf_userobjs_temp-user-obj .
      assign
        buf_userobjs_temp-user-obj.obj-type = p-obj-type
        buf_userobjs_temp-user-obj.obj-code = p-obj-code
      .
    end.
  end.

end procedure. /* userobjs_append */


procedure userobjs_object-exist :

  define output parameter p-object-exist as logical   no-undo .

  define buffer buf_userobjs_temp-user-obj for userobjs_temp-user-obj .

  do
  on error undo, return error return-value
  :
    find first buf_userobjs_temp-user-obj
      no-error .
    if not available buf_userobjs_temp-user-obj
    then do:
      assign
        p-object-exist = false
      .
    end.
    else do:
      assign
        p-object-exist = true
      .
    end.
  end.

end procedure. /* userobjs_object-exist */


procedure userobjs_transfer :

  define input  parameter p-callback-handle as handle no-undo .

  define variable vss-description as character no-undo init "userobjs_transfer: Передача списка объектов".

  define buffer buf_userobjs_temp-user-obj for userobjs_temp-user-obj .

  do
  on error undo, return error return-value
  :
    if valid-handle(p-callback-handle) <> true
    then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка задания входных параметров" skip
        "Неизвестный указатель на процедуру" skip
        view-as alert-box error .
      undo, return error return-value .
    end.
    if p-callback-handle :get-signature("userobjs_append") = ""
    then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка задания входных параметров" skip
        substitute("В процедуре &1 не найдена внутренняя процедура userobjs_append"
                  ,p-callback-handle :file-name
                  ) skip
        view-as alert-box error .
      undo, return error return-value .
    end.

    for each buf_userobjs_temp-user-obj
    on error undo, return error return-value
    :
      run userobjs_append in p-callback-handle
        (input  buf_userobjs_temp-user-obj.obj-type
        ,input  buf_userobjs_temp-user-obj.obj-code
        ) .
    end.
  end.

end procedure. /* userobjs_iterate */


procedure userobjs_select-one :

  define input  parameter parparentproc     as widget-handle no-undo .
  define input  parameter p-db-num          as integer   no-undo .
  define input  parameter p-user-id         as character no-undo .
  define input  parameter p-host-code-obj   as integer   no-undo .
  define input  parameter p-obj-type        as character no-undo .
  define input  parameter p-obj-code        as integer   no-undo .
  define output parameter p-user-select     as logical   no-undo .
  define output parameter p-select-obj-type as character no-undo .
  define output parameter p-select-obj-code as character no-undo .

  do
  on error undo, return error return-value
  :
    run gbl/userobjs.w
      (input  parparentproc          /* parparentproc        */
      ,input  this-procedure :handle /* p-callback-handle    */
      ,input  p-db-num               /* p-db-num             */
      ,input  p-user-id              /* p-user-id            */
      ,input  p-host-code-obj        /* p-curr-host-code-obj */
      ,input  p-obj-type             /* p-curr-obj-type      */
      ,input  p-obj-code             /* p-curr-obj-code      */
      ,INPUT  "b-sel"                /* p-bttn               */
      ,output p-user-select          /* p-user-select        */
      ,output p-select-obj-type      /* p-select-obj-type    */
      ,output p-select-obj-code      /* p-select-obj-code    */
      ) .
  end.

end procedure. /* userobjs_select-one */

procedure userobjs_select-many :

  define input  parameter parparentproc   as widget-handle no-undo .
  define input  parameter p-db-num        as integer   no-undo .
  define input  parameter p-user-id       as character no-undo .
  define input  parameter p-host-code-obj as integer   no-undo .
  define input  parameter p-obj-type      as character no-undo .
  define input  parameter p-obj-code      as integer   no-undo .
  define output parameter p-user-select   as logical   no-undo .

  define variable v-select-obj-type as character no-undo .
  define variable v-select-obj-code as integer   no-undo .

  do
  on error undo, return error return-value
  :
    run gbl/userobjs.w
      (input  parparentproc          /* parparentproc        */
      ,input  this-procedure :handle /* p-callback-handle    */
      ,input  p-db-num               /* p-db-num             */
      ,input  p-user-id              /* p-user-id            */
      ,input  p-host-code-obj        /* p-curr-host-code-obj */
      ,input  p-obj-type             /* p-curr-obj-type      */
      ,input  p-obj-code             /* p-curr-obj-code      */
      ,INPUT  "b-sel,b-mark"         /* p-bttn               */
      ,output p-user-select          /* p-user-select        */
      ,output v-select-obj-type      /* p-select-obj-type    */
      ,output v-select-obj-code      /* p-select-obj-code    */
      ) .

  end.

end procedure. /* userobjs_select-many */




/* $Workfile$ e n d */