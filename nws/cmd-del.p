/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

создание маршрутизации с командой на удаление записи

Автор: Уханов Дмитрий Юрьевич
Дата создания: 03/23/05
Author: Dmitry Ukhanov
Creation date: 03/23/05

*/

using ibs.th.adm.upd.*.

define input parameter p-tbl-name   as character no-undo .
define input parameter p-tbl-handle as handle    no-undo .
define input parameter p-db-list    as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "создание маршрутизации с командой на удаление записи".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/trg-def.i  }
{ gbl/key-rec.i  }

do
on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
on stop   undo, return error substitute( "&1. stop", vss-workfile )
on endkey undo, return error substitute( "&1. endkey", vss-workfile )
:
  define variable v-key-rec as character no-undo .

  define buffer buf_sys-ctrl for ub.sys-ctrl .
  define buffer buf_db       for ub.db .

  run gen-key-rec in this-procedure
    ( input p-tbl-name
     ,input p-tbl-handle
     ,output v-key-rec
    ) no-error .
  if error-status :error then do:
    return error substitute( "&1. Ошибка при генерации уникального ключа по таблице &2. &3&4&3&5"
                             ,vss-workfile
                             ,p-tbl-name
                             ,{&new-line}
                             ,return-value
                             ,error-status :get-message ( error-status :num-messages )
                           ).
  end.

  find first buf_sys-ctrl no-lock .

  if buf_sys-ctrl.db-num = 0
    or ( buf_sys-ctrl.db-num <> 0
         and g#news <> true
        )
  then do:
    if trim( p-db-list ) = "":U
      or p-db-list = ?
    then do:
      assign
        p-db-list = "":U
      .
      if buf_sys-ctrl.db-num = 0 then do:
        for each buf_db no-lock
          where buf_db.db-num > 0
        on error undo, return error
        :
          assign
            p-db-list = p-db-list + {&delim-nws} + string( buf_db.db-num )
          .
        end.
        assign
          p-db-list = left-trim( p-db-list, {&delim-nws} )
        .
      end.
      else do:
        assign
          p-db-list = "0":U
        .
      end.
    end.
    
    define variable observupdObj as class observupd no-undo.
    if g#db-num = 0 /* на гбд отправляем в любом случае так как схема БД должна быть обязатльно обновлена*/
    then do:
    
      observupdObj = new observupd ().
    
      /*исключение из списка бд маршуртизации обновленных таблиц, где схема бд не обновилась туда не уходит*/
    
      observupdObj:dbexcept(input-output p-db-list, input p-tbl-name).
    
      delete object observupdObj no-error.
      if p-db-list = "NULL" 
        then return.
    end.

    run nws/cr-route.p
      ( input {&send-cmd}
       ,input "command":U + {&delim-nws} + "delete":U + {&delim-nws} + v-key-rec
       ,input ?
       ,input p-db-list
      ) no-error .
    if error-status :error then do:
      return error substitute( "&1. Ошибка при маршрутизации команды на удаление записи &2. &3&4&3&5"
                              ,vss-workfile
                              ,v-key-rec
                              ,{&new-line}
                              ,return-value
                              ,error-status :get-message ( error-status :num-messages )
                            ).
    end.
  end.
end.

/* $Workfile$ end */