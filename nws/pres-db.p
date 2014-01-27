/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Создание списка выгруженных и работающих УБД

Автор: Уханов Дмитрий Юрьевич
Дата создания: 03/23/04
Author: Dmitry Ukhanov
Creation date: 03/23/04

*/

define output parameter p-pres-db-list as character no-undo .
define output parameter p-message      as character no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Создание списка выгруженных и работающих УБД ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

do
on error undo, return error
:
  define buffer buf_db for ub.db .

  define variable v-unpres-db-list as character no-undo .

  assign
    p-pres-db-list   = "":U
    p-message        = "":U
    v-unpres-db-list = "":U
  .

  for each buf_db no-lock
    where buf_db.db-num > 0
  on error undo, return error
  :
    if trim( buf_db.db-key ) <> "":U
      and buf_db.db-key <> ?
    then do:
      if p-pres-db-list = "":U then do:
        assign
          p-pres-db-list = string( buf_db.db-num )
        .
      end.
      else do:
        assign
          p-pres-db-list = p-pres-db-list + ",":U + string( buf_db.db-num )
        .
      end.
    end.
    else do:
      if v-unpres-db-list = "":U then do:
        assign
          v-unpres-db-list = string( buf_db.db-num )
        .
      end.
      else do:
        assign
          v-unpres-db-list = v-unpres-db-list + ",":U + string( buf_db.db-num )
        .
      end.
    end.
  end.
  if v-unpres-db-list <> "":U then do:
    assign
      p-message = substitute( "Работа СПН с БД &1 не производится", v-unpres-db-list )
    .
  end.
end.

/* $Workfile$ end */