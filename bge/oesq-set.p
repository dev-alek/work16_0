/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Установить sequence атрибут текущей базы для выгрузки в Oracle Retail

Автор: Хныкин Павел Андреевич
Дата создания: 01/26/09
Author: Pavel Khnykin
Creation date: 01/26/09

*/

define input  parameter p-ora-exp-seq as integer   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Установить sequence атрибут текущей базы для выгрузки в Oracle Retail".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/db-attr.i  }

define buffer buf_sys-ctrl for ub.sys-ctrl.

define variable v-db-attr-value as character no-undo .

do for
  buf_sys-ctrl
on error undo, return error return-value
:
  find first buf_sys-ctrl no-lock no-error .
  if not available buf_sys-ctrl
  then do:
    undo , return error "Не найдена запись sys-ctrl!" .
  end.

  if p-ora-exp-seq < 1
  then do:

    undo , return error substitute( "Ошибка записи параметра номера выгрузки Oracle Retail &1 для БД &2, значение параметра &3.&4Значение параметра не должно быть меньше 1"
                                  , {&attr-ora-exp-seq}
                                  , buf_sys-ctrl.db-num
                                  , p-ora-exp-seq
                                  , {&new-line}
                                  ).
  end.

  assign
    v-db-attr-value = string(p-ora-exp-seq)
  .

  run db-attr-write in this-procedure ( input buf_sys-ctrl.db-num
                                      , input {&attr-ora-exp-seq}
                                      , input v-db-attr-value
                                      ) no-error .
  if error-status :error
  then do:
    undo , return error substitute( "Ошибка записи параметра номера выгрузки Oracle Retail &1 для БД &2, значение параметра &3"
                                  , {&attr-ora-exp-seq}
                                  , buf_sys-ctrl.db-num
                                  , v-db-attr-value
                                  ).
  end.

end.