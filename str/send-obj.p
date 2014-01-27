/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пересылка объектов системы  КМ-ру IBM

Автор: Бахтадзе Наталья Викторовна
Дата создания: 12/04/03
Author: Bakhtadze Natalya
Creation date: 12/04/03

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-parameter   as character no-undo .

/*
p-parameter включает
define input parameter p-db-num like ub.db.db-num no-undo .
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
DEFINE INPUT PARAMETER action as char no-undo.
*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Пересылка объектов системы КМ-ру IBM".
{ cmp/vssrevis.i }


{ cmp/trg-def.i }
define variable  p-db-num like ub.db.db-num no-undo .
/*эти параметры не имеют смысла тут
МАГИЯ работает как кассовый сервер на БД
а подразеделния одинаковы для всей БД
но ПУСТЬ БУДУТ!!*/
define variable p-obj-code like ub.clients.obj-code no-undo .
define variable action     as character no-undo .

assign
p-db-num = integer(entry(1, p-parameter, {&delim-par}))
p-obj-code = integer(entry(2, p-parameter, {&delim-par}))
action     = entry(3, p-parameter, {&delim-par})
no-error
.
if error-status:error then return error.

{ bge/bgelib.i }
{ str/cd-xml.i }
{ str/defc-obj.i "SHARED" }
{ str/cdsnddef.i }


/*PROCEDURE putc-dept.*/
/*разнящийся вывод для разных типов касс*/
{ str/putc-obj.i }


/*PROCEDURE for-cash-cycle*/
/*пройдем цикл по всем кассам одного типа*/
{ str/cd-cyobj.i }

/*PROCEDURE SENDING.*/
{ str/cd-seobj.i }

run write-log-and-file in p-log-handle (
      input 1
    , input log-file-name
    , input 1
    , input substitute("Пересылка на кассы &1 БД &2 информации по объектам БД", {&cd-type-IBM-XML}, p-db-num)
                                          ).



RUN SENDING no-error.
if error-status:error then do:
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute( "!!!Ошибки при отсылке информации по объектам БД на кассы  БД &1"
                         , p-db-num
                        )
                                        ).

  assign
  v-view-log = yes
  .
end.
if v-view-log then return error .