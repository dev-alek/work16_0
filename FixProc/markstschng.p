/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Ростовцев Александр 
Дата: создания: 29.01.2024
Author:  Rostovtsev Aleksandr
Created: 29.01.2024
Modified: 05.02.2024

Description: Утилита для смены статусов марок
*/

define input parameter parparentproc    as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle     as handle no-undo .
define input parameter p-parameter      as character no-undo .

define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
define variable v-curr-r-b as character no-undo .
define variable v-base-code like ub.sysconf.base-code no-undo .
&glob main-tbl marking

{ trg/trghistnws.i }
{ nws/bintrnpr.i }

define variable p-db-num      as integer   no-undo .
define variable p-from-db-num as integer   no-undo .
define variable p-file-num    as integer   no-undo .
define variable sts-old       as integer   no-undo.
define variable sts-new       as integer   no-undo.
define variable cnt           as int64     no-undo. 
define variable res           as character no-undo.
define buffer buf_marking      for ub.marking.
define buffer buf_ext-file-par for ext-file-par.

on write of ub.marking
   new buffer new-{&main-tbl}
   old buffer old-{&main-tbl}
override
do:
    { trg/trghistnws.i
      &hist = yes
      &seqnamehist = "s-c-mark-chip-num"
    }
end.

assign
   p-db-num             = integer(entry(1, p-parameter, {&delim-par}))
   p-from-db-num        = integer(entry(2, p-parameter, {&delim-par}))
   p-file-num           = integer(entry(3, p-parameter, {&delim-par}))
no-error.
if error-status:error then do:
  return error substitute("Ошибка передачи входных параметров в процедуру &1&2&3&2"
                       , (this-procedure:filename)
                       , {&new-line}
                       , error-status:get-message(1)).
end.

for each buf_ext-file-par where
         buf_ext-file-par.db-num = p-db-num
     and buf_ext-file-par.from-db-num = p-from-db-num
     and buf_ext-file-par.file-num = file-num
    no-lock:
  if buf_ext-file-par.param-type = "I" then do:
    if buf_ext-file-par.param-num = 1 then
      sts-old = int(buf_ext-file-par.param-int-value).
    if buf_ext-file-par.param-num = 2 then
      sts-new = int(buf_ext-file-par.param-int-value).
  end.
end.

if sts-old = 0 or sts-new = 0 then do:
  return error substitute("Ошибка передачи параметров в процедуру &1&2&3&2"
                        , (this-procedure:filename)
                        , {&new-line}
                        , "Значения переданных статусов должно быть больше 0.").
end.

for each buf_marking where
         buf_marking.sts = sts-old:
  assign
    buf_marking.sts = sts-new
    cnt = cnt + 1
  .
end.

res = substitute(
        "БД: &1; Время запуска: &2 &3; Изменено статусов марок: &4.",
        p-db-num, string(today, "99/99/9999"), string(time, "HH:MM:SS"), cnt
      ).

run ext-file-par-write-and-send (
      input  p-db-num
      ,input  p-from-db-num
      ,input  p-file-num
      ,input -1 /*p-param-num      */
      ,input {&type-char} /*p-value-type */
      ,input "Результат" /* p-value-name */
      ,input res /*p-value-char */
      ,input ? /*p-value-date */
      ,input 0 /* p-value-integer */
      ,input 0 /* p-value-decimal */
      ,input no /*p-value-logical */
      ,input yes /*p-send*/
      ,input string(g#news-source-db)
   ) no-error .

return res.