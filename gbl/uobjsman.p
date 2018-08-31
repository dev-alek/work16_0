/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Выбор объетов

Автор: Рубан Дмитрий
Дата создания: 17/08/18
Author: Molotkov Sergey
Creation date: 17/08/18

    
*/ 
define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Экранные триггеры промо-акций". 
define input  parameter parparentproc   as handle no-undo .
  define input  parameter p-db-num        as integer   no-undo .
  define input  parameter p-user-id       as character no-undo .
  define input  parameter p-host-code-obj as integer   no-undo .
  define input  parameter p-obj-type      as character no-undo .
  define input  parameter p-obj-code      as integer   no-undo .
  define output parameter p-user-select   as logical   no-undo .
  {gbl/userobjs.i} 
  define output parameter table for userobjs_temp-user-obj .
    

{ gbl/uobjsman.i
    parparentproc
    p-db-num
    p-user-id
    p-host-code-obj
    p-obj-type 
    p-obj-code 
    p-user-select
  }