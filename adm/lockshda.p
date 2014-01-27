/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Ѕлокировка атрибутов расписания

јвтор: ’ныкин ѕавел јндреевич
ƒата создани€: 06/23/09
Author: Pavel Khnykin
Creation date: 06/23/09

*/
define input parameter  p-db-num         as integer    no-undo .
define input parameter  p-task-type      as character  no-undo.
define input parameter  p-task-num       as integer    no-undo.
define input parameter  p-code           as character  no-undo.
define parameter buffer pbuf_schedule-attr for ub.schedule-attr.


def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Ѕлокировка атрибутов расписания".
{ cmp/vssrevis.i "substitute('&1|&2|&3|&4':u,p-db-num,p-task-type,p-task-num,p-code )" }
{ cmp/str-glbl.i }

do
on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
on stop   undo, return error substitute( "&1. stop", vss-workfile )
on endkey undo, return error substitute( "&1. endkey", vss-workfile )
:
  /* »щем атрибут */
  find first pbuf_schedule-attr exclusive-lock
    where pbuf_schedule-attr.cre-db-num  = p-db-num
      and pbuf_schedule-attr.task-type   = p-task-type
      and pbuf_schedule-attr.task-num    = p-task-num
      and pbuf_schedule-attr.attr-code   = p-code
  no-wait
  no-error .
  if not available pbuf_schedule-attr
  then do:
    if locked pbuf_schedule-attr
    then do:
      return error substitute( "&1. ƒругой пользователь работает с параметрами расписани€. ѕараметры расписани€ &2|&3|&4|&5"
                             , vss-workfile
                             , p-db-num
                             , p-task-type
                             , p-task-num
                             , p-code
                             ) .
    end.
    else do:
      return error substitute( "&1. ѕараметры расписани€ не найдены. &2|&3|&4|&5"
                             , vss-workfile
                             , p-db-num
                             , p-task-type
                             , p-task-num
                             , p-code
                             ) .
    end.
  end.

  find current pbuf_schedule-attr share-lock.
  return.
end.