/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на удаление документа сверки

Автор: Уханов Дмитрий Юрьевич
Дата создания: 10/09/07
Author: Dmitry Ukhanov
Creation date: 10/09/07

Автор1: Суслов Алексей Юрьевич
Дата создания1: 04/04/06

*/

TRIGGER PROCEDURE FOR DELETE OF ub.rvs-doc.

define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Триггер на удаление документа сверки ":U.

{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ gbl/thbj-def.i }
{ ref/xobjgrp.i  }

define variable v-mess as character no-undo .
define variable v-value-character as character no-undo .
define variable v-date-close-period as date      no-undo .
define variable v-value-decimal as decimal   no-undo .
define variable v-value-integer as integer   no-undo .
define variable v-value-logical as logical   no-undo .
define variable v-value-type as character no-undo .


Main-Block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:

  /* Проверяем статус документа, в котором мы можем удалять документ */
  if ( ub.rvs-doc.status_ = {&fact}
      and ub.rvs-doc.is-del <> true
     )
    or ( g#news = false
         and ub.rvs-doc.status_ <> {&g___new}
         and ub.rvs-doc.status_ <> {&fact}
        )
  then do:
    assign
      v-mess = substitute( "&1 &2&3"
                           + "Документ сверки может быть удален только в статусе новый или факт&3"
                           + "Сверка &4&3"
                           + "Складской документ &5&3"
                           + "Тип сверки &6&3"
                           + "Статус сверки &7&3"
                           , vss-workfile
                           , vss-revision
                           , {&new-line}
                           , ub.rvs-doc.rvs-code
                           , ub.rvs-doc.out-code
                           , ub.rvs-doc.rvs-type
                           , ub.rvs-doc.status_
                         )
    .
    if g#news = false then do:
      message
        v-mess skip
        view-as alert-box error .
    end.

    undo Main-Block, return error v-mess .
  end.


  if ub.rvs-doc.status_ = {&fact} then do:
  run adm/shattri.p (
       input "get":U
      ,input ub.rvs-doc.obj-type
      ,input ub.rvs-doc.obj-code
      ,input {&attr-nakl_par}
      ,input  "date-close-period"
      ,output v-value-character
      ,output v-date-close-period
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,INPUT-OUTPUT TABLE thbjattr_thbj-attr
      ) no-error .
  if error-status :error then v-date-close-period = date('').
      if v-date-close-period <> date('') then do:
          if ub.rvs-doc.fact-date < v-date-close-period
          then do:
            message  substitute(
              "Дата закрытия сверки &1 более ранняя, чем дата закрытия периода &2
              Дата закрытия сверки     &3 &2
              Дата закрытия периода    &4 &2
              Объект &5 &6 "
              ,
              ub.rvs-doc.rvs-code  ,
              {&new-line}  ,
              string ( ub.rvs-doc.fact-date , "99/99/9999" ) ,
              string ( v-date-close-period,   "99/99/9999") ,
                        x_obj-group.obj-type ,
                        x_obj-group.obj-code  ) view-as alert-box information .
              return.
          end.
      end.


  end.

  for each ub.doc-attr exclusive-lock
    where ub.doc-attr.doc-code = ub.rvs-doc.rvs-code
  on error undo Main-Block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    delete ub.doc-attr.
  end.

  /* удаляем связанные таблицы */
  for each ub.rvs-line exclusive-lock
    where ub.rvs-line.rvs-code = ub.rvs-doc.rvs-code
  on error undo Main-Block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    delete ub.rvs-line.
  end.

  for each ub.rvs-line-pump exclusive-lock
    where ub.rvs-line-pump.rvs-code = ub.rvs-doc.rvs-code
  on error undo Main-Block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    delete ub.rvs-line-pump.
  end.

  /* посылаем команду на удаление документа сверки */
  if g#db-num <> 0 then do:
    run nws/cmd-del.p
      ( input "rvs-doc":U
       ,input (buffer ub.rvs-doc:handle)
       ,input "":U
      ) no-error .
    if error-status :error then do:
      undo, return error substitute( "&1. Ошибка при отправке в новости команды на удаление записи. &2&3&2&4", vss-workfile, {&new-line}, return-value, error-status :get-message ( 1 ) ).
    end.
  end.

  if g#oxml = yes then do:
    run str/calloxml.p
      ( input {&nwsdochs_action_delete}
       ,input {&table_rvs-doc}
       ,input ( buffer ub.rvs-doc:handle )
      ) no-error.
    if error-status :error then do:
      undo, return error substitute( "&2&1Ошибка при отправке в систему OpenXML команды на удаление записи&1&3&1&4"
                                    ,{&new-line}
                                    ,vss-workfile
                                    ,return-value
                                    ,error-status :get-message ( 1 )
                                   ).
    end.
  end.
end. /* Main-Block */