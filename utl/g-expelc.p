/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт данных в систему Элкос-Талон

Автор: Хныкин Павел Андреевич
Дата создания: 07/17/07
Author: Pavel Khnykin
Creation date: 07/17/07

*/
define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".

{ cmp/vssrevis.i      }
{ cmp/str-glbl.i      }
{ cmp/r-page1.i new   }
{ gbl/getcntxt.i def  }


define variable v-object-select as character no-undo .
{ gbl/getcntxt.i get }
assign
  my-handle     = parparentproc
.
if v-cntxt-db-num = 0 then do:
  assign
    v-object-select = "{&o-currency},{&o-choice},{&o-all}"
  .
end.
else do:
  assign
    v-object-select = "{&o-currency}"
  .
end.

run rep/d-report.w
    ( input parparentproc
    , input 'utl/e-expelc.w'
    , input "Экспорт данных в систему Элкос-Талон":U
    , input 2
    , input ""
    , input v-object-select
    , input ""
    , input ""
    , input "all"
    , input no
    ).