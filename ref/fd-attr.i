/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Атрибуты ПЛАТЕЖА и УДАЛЕННОГО ПЛАТЕЖА

Автор: Бахтадзе Наталья Викторовна
Дата создания: 12/09/04
Author: Bakhtadze Natalya
Creation date: 12/09/04

АТРИБУТЫ ОДИНАКОВЫЕ
ПРОЦЕДУРЫ РАЗНЫЕ

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

/* Ппример */

/*
&scop bef-fd-attr-test test
&glob fd-attr-test '{&bef-fd-attr-test}':U
&scop type-fd-attr-test {&type-int}
&scop format-fd-attr-test "99"
&scop label-fd-attr-test "П.смены"
&scop tooltip-fd-attr-test "П.смены"
&scop user-can-edit-fd-attr-test false
&scop output-display-fd-attr-test true
&scop other-fd-attr-test '':u
&scop news-fd-attr-test no


&glob fd-attr-list '{&bef-fd-attr-shift-name}':u

*/


&glob fd-attr-list '':u

&scop attr-temp-code ~
  when ~{&~{&attr-code~}~} then do: ~
    assign ~
    p-tooltip = ~{&tooltip-~{&attr-code~}~} ~
    p-label = ~{&label-~{&attr-code~}~} . ~
  end.

&scop attr-temp-full-code ~
  when ~{&~{&attr-code~}~} then do: ~
    assign ~
    p-label = ~{&label-~{&attr-code~}~} ~
    p-type = ~{&type-~{&attr-code~}~}  ~
    p-format = ~{&format-~{&attr-code~}~} ~
    p-label = ~{&label-~{&attr-code~}~} ~
    p-user-can-edit  = ~{&user-can-edit-~{&attr-code~}~} ~
    p-output-display = ~{&output-display-~{&attr-code~}~} ~
    p-other = ~{&other-~{&attr-code~}~}  ~
    . ~
  end.

&scop attr-news-code ~
  when ~{&~{&attr-code~}~} then do: ~
    assign ~
    p-news = ~{&news-~{&attr-code~}~}. ~
  end.



procedure fd-attr-code :

  do
  on error undo, return error
  :
    define input  parameter p-code           as character no-undo . /* код атрибута */
    define output parameter p-type           as character no-undo . /* тип атрибута */
    define output parameter p-format         as character no-undo . /* формат атрибута */
    define output parameter p-label          as character no-undo . /* лабел атрибута */
    define output parameter p-user-can-edit  as logical   no-undo . /* пользователь может изменять в броусе */
    define output parameter p-output-display as logical   no-undo . /* виден в броусе */
    define output parameter p-other          as character no-undo . /* еще чего - нибудь */

    case p-code :



      /* сюда добавлять новые параметры */
      otherwise do:
        undo, return error "неизвестный атрибут платежа" + " " + p-code .
      end.
    end.
  end.
end procedure.

procedure fd-attr-tooltip :

  do
  on error undo, return error
  :

    define input  parameter p-code    as character no-undo .
    define output parameter p-tooltip as character no-undo .
    define output parameter p-label   as character no-undo .

    case p-code :

      /* сюда добавлять новые параметры */
      otherwise do:
        undo, return error "неизвестный атрибут платежа" + " " + p-code .
      end.
    end.
  end.

end procedure.


procedure fin-doc-attr-write :
 do
 on error undo, return error return-value
 :
define input parameter p-host-code     like ub.fin-doc-attr.host-code  no-undo .
define input parameter p-fin-doc-code  like ub.fin-doc-attr.fin-doc-code   no-undo .
define input parameter p-attr-code     like ub.fin-doc-attr.attr-code  no-undo .
define input parameter p-attr-value    like ub.fin-doc-attr.attr-value no-undo .

define variable  v-format         as character no-undo .
define variable  v-label          as character no-undo .
define variable  v-user-can-edit  as logical   no-undo .
define variable  v-output-display as logical   no-undo .
define variable  v-other          as character no-undo .
define variable  v-type           as character no-undo .
define buffer buf_fin-doc-attr for ub.fin-doc-attr.

run fd-attr-code in this-procedure
                                  (input  p-attr-code           /* p-code           */
                                  ,output v-type           /* p-type           */
                                  ,output v-format         /* p-format         */
                                  ,output v-label          /* p-label          */
                                  ,output v-user-can-edit  /* p-user-can-edit  */
                                  ,output v-output-display /* p-output-display */
                                  ,output v-other          /* p-other          */
                                  ) no-error .
if error-status :error then do:
  undo, return error return-value .
end.



find first buf_fin-doc-attr  exclusive-lock  where
          buf_fin-doc-attr.attr-code    = p-attr-code
      AND buf_fin-doc-attr.host-code    = p-host-code
      AND buf_fin-doc-attr.fin-doc-code     = p-fin-doc-code  no-error .
  if not available  buf_fin-doc-attr then do:
      create buf_fin-doc-attr.
      assign
      buf_fin-doc-attr.attr-code    = p-attr-code
      buf_fin-doc-attr.attr-value   = p-attr-value
      buf_fin-doc-attr.host-code    = p-host-code
      buf_fin-doc-attr.fin-doc-code     = p-fin-doc-code
      .

  end.
  else do:
&if "{1}" = "force-history" &then
     if buf_fin-doc-attr.attr-value = p-attr-value then do:
       run write-fin-doc-attr-proc  in this-procedure (buffer buf_fin-doc-attr ).
     end.
     else do:
&endif
       assign
       buf_fin-doc-attr.attr-value = p-attr-value.
&if "{1}" = "force-history" &then
     end.
&endif

  end.
 end. /* do */
end procedure. /* fin-doc-attr-write */


procedure fd-attr-exist :

  do
  on error undo, return error
  :
    define input parameter p-host-code     like ub.fin-doc-attr.host-code  no-undo .
    define input parameter p-fin-doc-code  like ub.fin-doc-attr.fin-doc-code   no-undo .
    define input parameter p-code          like ub.fin-doc-attr.attr-code  no-undo .
    define output parameter p-exist   as logical  no-undo .

    define buffer buf_fin-doc-attr for {&db-name}.fin-doc-attr .

    define variable  v-type           as character no-undo .
    define variable  v-format         as character no-undo .
    define variable  v-label          as character no-undo .
    define variable  v-user-can-edit  as logical   no-undo .
    define variable  v-output-display as logical   no-undo .
    define variable  v-other          as character no-undo .

    run fd-attr-code in this-procedure
      (input  p-code           /* p-code           */
      ,output v-type           /* p-type           */
      ,output v-format         /* p-format         */
      ,output v-label          /* p-label          */
      ,output v-user-can-edit  /* p-user-can-edit  */
      ,output v-output-display /* p-output-display */
      ,output v-other          /* p-other          */
      ) no-error .
    if error-status :error then do:
      undo, return error return-value .
    end.

    find first buf_fin-doc-attr exclusive-lock
      where buf_fin-doc-attr.host-code  = p-host-code
        and buf_fin-doc-attr.fin-doc-code  = p-fin-doc-code
        and buf_fin-doc-attr.attr-code = p-code
      no-error .

    if  available buf_fin-doc-attr then do:
      p-exist = yes.
    end.
  end.

end procedure.



procedure fd-attr-delete :
  do
  on error undo, return error
  :
  define input parameter p-host-code     like ub.fin-doc-attr.host-code  no-undo .
  define input parameter p-fin-doc-code  like ub.fin-doc-attr.fin-doc-code   no-undo .
  define input parameter p-code          like ub.fin-doc-attr.attr-code  no-undo .
  define output parameter p-deleted  as logical no-undo.

    define buffer buf_fin-doc-attr for {&db-name}.fin-doc-attr .

    define variable  v-type           as character no-undo .
    define variable  v-format         as character no-undo .
    define variable  v-label          as character no-undo .
    define variable  v-user-can-edit  as logical   no-undo .
    define variable  v-output-display as logical   no-undo .
    define variable  v-other          as character no-undo .

    run fd-attr-code in this-procedure
      (input  p-code           /* p-code           */
      ,output v-type           /* p-type           */
      ,output v-format         /* p-format         */
      ,output v-label          /* p-label          */
      ,output v-user-can-edit  /* p-user-can-edit  */
      ,output v-output-display /* p-output-display */
      ,output v-other          /* p-other          */
      ) no-error .
    if error-status :error then do:
      undo, return error return-value .
    end.
    find first buf_fin-doc-attr exclusive-lock
      where buf_fin-doc-attr.host-code  = p-host-code
        and buf_fin-doc-attr.fin-doc-code  = p-fin-doc-code
        and buf_fin-doc-attr.attr-code = p-code
      no-error NO-WAIT.
    if not available buf_fin-doc-attr then do:
      p-deleted = no.
    end.
    else do:
      delete buf_fin-doc-attr no-error .
      if error-status:error then do:
        undo, return error return-value .
      end.
      p-deleted = yes.
    end.
  end.

end procedure.



procedure fin-doc-attr-value :
 do
 on error undo, return error return-value
 :
define input  parameter p-host-code    like ub.fin-doc-attr.host-code    no-undo .
define input  parameter p-fin-doc-code like ub.fin-doc-attr.fin-doc-code     no-undo .
define input  parameter p-attr-code    like ub.fin-doc-attr.attr-code    no-undo .
define output parameter p-attr-value   like ub.fin-doc-attr.attr-value   no-undo .

define variable  v-format         as character no-undo .
define variable  v-label          as character no-undo .
define variable  v-user-can-edit  as logical   no-undo .
define variable  v-output-display as logical   no-undo .
define variable  v-other          as character no-undo .
define variable  v-type           as character no-undo .
define buffer buf_fin-doc-attr for ub.fin-doc-attr.

run fd-attr-code in this-procedure
  (input  p-attr-code       /* p-code           */
  ,output v-type           /* p-type           */
  ,output v-format         /* p-format         */
  ,output v-label          /* p-label          */
  ,output v-user-can-edit  /* p-user-can-edit  */
  ,output v-output-display /* p-output-display */
  ,output v-other          /* p-other          */
  ) no-error .
if error-status :error then do:
  undo, return error return-value .
end.

find first buf_fin-doc-attr no-lock where
          buf_fin-doc-attr.attr-code    = p-attr-code
      AND buf_fin-doc-attr.host-code     = p-host-code
      AND buf_fin-doc-attr.fin-doc-code = p-fin-doc-code      no-error .
  if available  buf_fin-doc-attr then do:
    assign
    p-attr-value = buf_fin-doc-attr.attr-value
    .
  end.
  else do:
    p-attr-value = ? .
  end.


 end. /* do */
end procedure. /* fin-doc-attr-value */

procedure fd-attr-news :

  do
  on error undo, return error
  :
    define input  parameter p-code           as character no-undo . /* код атрибута */
    define output parameter p-news           as logical   no-undo . /* ходит в новости */

    case p-code :

      /* сюда добавлять новые параметры */
      otherwise do:
        undo, return error "неизвестный атрибут платежа " + " " + p-code .
      end.
    end.
  end.
end procedure.


procedure c-fin-doc-attr-write :
 do
 on error undo, return error return-value
 :
define input parameter p-host-code     like ub.c-fin-doc-attr.host-code  no-undo .
define input parameter p-fin-doc-code  like ub.c-fin-doc-attr.fin-doc-code   no-undo .
define input parameter p-corr-user-db-num  like ub.c-fin-doc-attr.corr-user-db-num   no-undo .
define input parameter p-chip-num      like ub.c-fin-doc-attr.chip-num   no-undo .
define input parameter p-attr-code     like ub.c-fin-doc-attr.attr-code  no-undo .
define input parameter p-attr-value    like ub.c-fin-doc-attr.attr-value no-undo .

define variable  v-format         as character no-undo .
define variable  v-label          as character no-undo .
define variable  v-user-can-edit  as logical   no-undo .
define variable  v-output-display as logical   no-undo .
define variable  v-other          as character no-undo .
define variable  v-type           as character no-undo .
define buffer buf_c-fin-doc-attr for ub.c-fin-doc-attr.

run fd-attr-code in this-procedure
                                  (input  p-attr-code           /* p-code           */
                                  ,output v-type           /* p-type           */
                                  ,output v-format         /* p-format         */
                                  ,output v-label          /* p-label          */
                                  ,output v-user-can-edit  /* p-user-can-edit  */
                                  ,output v-output-display /* p-output-display */
                                  ,output v-other          /* p-other          */
                                  ) no-error .
if error-status :error then do:
  undo, return error return-value .
end.



find first buf_c-fin-doc-attr  exclusive-lock  where
          buf_c-fin-doc-attr.attr-code    = p-attr-code
      AND buf_c-fin-doc-attr.host-code    = p-host-code
      AND buf_c-fin-doc-attr.fin-doc-code     = p-fin-doc-code
      AND buf_c-fin-doc-attr.corr-user-db-num = p-corr-user-db-num
      AND buf_c-fin-doc-attr.chip-num         = p-chip-num      no-error .
  if not available  buf_c-fin-doc-attr then do:
      create buf_c-fin-doc-attr.
      assign
      buf_c-fin-doc-attr.attr-code    = p-attr-code
      buf_c-fin-doc-attr.attr-value   = p-attr-value
      buf_c-fin-doc-attr.host-code    = p-host-code
      buf_c-fin-doc-attr.fin-doc-code     = p-fin-doc-code
      .

  end.
  else do:
        buf_c-fin-doc-attr.attr-value   = p-attr-value .
  end.
 end. /* do */
end procedure. /* c-fin-doc-attr-write */



procedure c-fin-doc-attr-value :
 do
 on error undo, return error return-value
 :
define input  parameter p-host-code    like ub.c-fin-doc-attr.host-code    no-undo .
define input  parameter p-fin-doc-code like ub.c-fin-doc-attr.fin-doc-code     no-undo .
define input parameter p-corr-user-db-num  like ub.c-fin-doc-attr.corr-user-db-num   no-undo .
define input parameter p-chip-num      like ub.c-fin-doc-attr.chip-num   no-undo .
define input  parameter p-attr-code    like ub.c-fin-doc-attr.attr-code    no-undo .
define output parameter p-attr-value   like ub.c-fin-doc-attr.attr-value   no-undo .

define variable  v-format         as character no-undo .
define variable  v-label          as character no-undo .
define variable  v-user-can-edit  as logical   no-undo .
define variable  v-output-display as logical   no-undo .
define variable  v-other          as character no-undo .
define variable  v-type           as character no-undo .
define buffer buf_c-fin-doc-attr for ub.c-fin-doc-attr.

run fd-attr-code in this-procedure
  (input  p-attr-code       /* p-code           */
  ,output v-type           /* p-type           */
  ,output v-format         /* p-format         */
  ,output v-label          /* p-label          */
  ,output v-user-can-edit  /* p-user-can-edit  */
  ,output v-output-display /* p-output-display */
  ,output v-other          /* p-other          */
  ) no-error .
if error-status :error then do:
  undo, return error return-value .
end.

find first buf_c-fin-doc-attr no-lock where
          buf_c-fin-doc-attr.attr-code    = p-attr-code
      AND buf_c-fin-doc-attr.fin-doc-code      = p-fin-doc-code
      AND buf_c-fin-doc-attr.host-code      = p-host-code
      AND buf_c-fin-doc-attr.corr-user-db-num = p-corr-user-db-num
      AND buf_c-fin-doc-attr.chip-num         = p-chip-num      no-error .

  if available  buf_c-fin-doc-attr then do:
    assign
    p-attr-value = buf_c-fin-doc-attr.attr-value
    .
  end.
  else do:
    p-attr-value = ? .
  end.


 end. /* do */
end procedure. /* c-fin-doc-attr-value */


&if "{2}" <> "" &then
procedure fin-doc-temp-attr-write :
 do
 on error undo, return error return-value
 :
define input parameter p-host-code     like ub.fin-doc-attr.host-code  no-undo .
define input parameter p-fin-doc-code  like ub.fin-doc-attr.fin-doc-code   no-undo .
define input parameter p-attr-code     like ub.fin-doc-attr.attr-code  no-undo .
define input parameter p-attr-value    like ub.fin-doc-attr.attr-value no-undo .

define variable  v-format         as character no-undo .
define variable  v-label          as character no-undo .
define variable  v-user-can-edit  as logical   no-undo .
define variable  v-output-display as logical   no-undo .
define variable  v-other          as character no-undo .
define variable  v-type           as character no-undo .
define buffer buf_temp-fin-doc-attr for {2}.

run fd-attr-code in this-procedure
                                  (input  p-attr-code           /* p-code           */
                                  ,output v-type           /* p-type           */
                                  ,output v-format         /* p-format         */
                                  ,output v-label          /* p-label          */
                                  ,output v-user-can-edit  /* p-user-can-edit  */
                                  ,output v-output-display /* p-output-display */
                                  ,output v-other          /* p-other          */
                                  ) no-error .
if error-status :error then do:
  undo, return error return-value .
end.

find first buf_temp-fin-doc-attr  exclusive-lock  where
          buf_temp-fin-doc-attr.attr-code    = p-attr-code
      AND buf_temp-fin-doc-attr.host-code    = p-host-code
      AND buf_temp-fin-doc-attr.fin-doc-code     = p-fin-doc-code  no-error .
  if not available  buf_temp-fin-doc-attr then do:
      create buf_temp-fin-doc-attr.
      assign
      buf_temp-fin-doc-attr.attr-code    = p-attr-code
      buf_temp-fin-doc-attr.attr-value   = p-attr-value
      buf_temp-fin-doc-attr.host-code    = p-host-code
      buf_temp-fin-doc-attr.fin-doc-code     = p-fin-doc-code
      .
  end.
    assign
    buf_temp-fin-doc-attr.attr-value = p-attr-value.
 end. /* do */
end procedure. /* fin-doc-attr-temp-write */

procedure fin-doc-temp-attr-value :
 do
 on error undo, return error return-value
 :
define input  parameter p-host-code    like ub.fin-doc-attr.host-code    no-undo .
define input  parameter p-fin-doc-code like ub.fin-doc-attr.fin-doc-code     no-undo .
define input  parameter p-attr-code    like ub.fin-doc-attr.attr-code    no-undo .
define output parameter p-attr-value   like ub.fin-doc-attr.attr-value   no-undo .

define variable  v-format         as character no-undo .
define variable  v-label          as character no-undo .
define variable  v-user-can-edit  as logical   no-undo .
define variable  v-output-display as logical   no-undo .
define variable  v-other          as character no-undo .
define variable  v-type           as character no-undo .
define buffer buf_fin-doc-attr for {2}.

run fd-attr-code in this-procedure
  (input  p-attr-code       /* p-code           */
  ,output v-type           /* p-type           */
  ,output v-format         /* p-format         */
  ,output v-label          /* p-label          */
  ,output v-user-can-edit  /* p-user-can-edit  */
  ,output v-output-display /* p-output-display */
  ,output v-other          /* p-other          */
  ) no-error .
if error-status :error then do:
  undo, return error return-value .
  end.

find first buf_fin-doc-attr no-lock where
          buf_fin-doc-attr.attr-code    = p-attr-code
      AND buf_fin-doc-attr.host-code     = p-host-code
      AND buf_fin-doc-attr.fin-doc-code = p-fin-doc-code      no-error .
  if available  buf_fin-doc-attr then do:
    assign
    p-attr-value = buf_fin-doc-attr.attr-value
    .
  end.
  else do:
    p-attr-value = ? .
  end.


 end. /* do */
end procedure. /* fin-doc-attr-value */
&endif

/* $Workfile$ e n d */