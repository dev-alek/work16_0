/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$


Автор: Суслов Алексей Юрьевич
Дата создания: 04/11/06
Author: Alexey Suslov
Creation date: 04/11/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

DO counter = 1 TO l-counter
on error  undo, return error
on endkey undo, return error :

  { nws/imps-nws.i rec-full }

  assign
    rec-name = entry( 1, rec-full, {&delim-nws} )
    .

  {&test-count}

  CASE rec-name :
    when "shift-staff" then do:
      create locb-shift-staff.
      { nws/impl-nws.i "shift-staff" "locb-" }
    end.
    when "shift-cash" then do:
      create locb-shift-cash.
      { nws/impl-nws.i "shift-cash" "locb-" }
    end.
    when "c-shift-staff" then do:
      create locb-c-shift-staff.
      { nws/impl-nws.i "c-shift-staff" "locb-" }
    end.
    when "c-sht-hist" then do:
      create locb-c-sht-hist.
      { nws/impl-nws.i "c-sht-hist" "locb-" }
    end.
    when "c-shift-obj" then do:
      create locb-c-shift-obj.
      { nws/impl-nws.i "c-shift-obj" "locb-" }
    end.
    otherwise do:
      message "Не предусмотрен прием таблицы " rec-name skip
              "в составе смен на объекте."
              view-as alert-box error.
      return error.
    end.
  END CASE.
end.

for each buf_shift-staff where buf_shift-staff.obj-type   = wt-shift-obj.obj-type
                           and buf_shift-staff.obj-code   = wt-shift-obj.obj-code
                           and buf_shift-staff.shift-date = wt-shift-obj.shift-date
                           and buf_shift-staff.shift-num  = wt-shift-obj.shift-num
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete buf_shift-staff.
end.
for each locb-shift-staff where locb-shift-staff.obj-type   = wt-shift-obj.obj-type
                            and locb-shift-staff.obj-code   = wt-shift-obj.obj-code
                            and locb-shift-staff.shift-date = wt-shift-obj.shift-date
                            and locb-shift-staff.shift-num  = wt-shift-obj.shift-num
                       no-lock
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  create buf_shift-staff.
  buffer-copy locb-shift-staff to buf_shift-staff.
end.

for each buf_shift-cash where buf_shift-cash.obj-type   = wt-shift-obj.obj-type
                           and buf_shift-cash.obj-code   = wt-shift-obj.obj-code
                           and buf_shift-cash.shift-date = wt-shift-obj.shift-date
                           and buf_shift-cash.shift-num  = wt-shift-obj.shift-num
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete buf_shift-cash.
end.
for each locb-shift-cash where locb-shift-cash.obj-type   = wt-shift-obj.obj-type
                            and locb-shift-cash.obj-code   = wt-shift-obj.obj-code
                            and locb-shift-cash.shift-date = wt-shift-obj.shift-date
                            and locb-shift-cash.shift-num  = wt-shift-obj.shift-num
                       no-lock
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  create buf_shift-cash.
  buffer-copy locb-shift-cash to buf_shift-cash.
end.


for each buf_c-shift-staff where buf_c-shift-staff.obj-type   = wt-shift-obj.obj-type
                           and buf_c-shift-staff.obj-code   = wt-shift-obj.obj-code
                           and buf_c-shift-staff.shift-date = wt-shift-obj.shift-date
                           and buf_c-shift-staff.shift-num  = wt-shift-obj.shift-num
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete buf_c-shift-staff.
end.
for each locb-c-shift-staff where locb-c-shift-staff.obj-type   = wt-shift-obj.obj-type
                            and locb-c-shift-staff.obj-code   = wt-shift-obj.obj-code
                            and locb-c-shift-staff.shift-date = wt-shift-obj.shift-date
                            and locb-c-shift-staff.shift-num  = wt-shift-obj.shift-num
                       no-lock
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  create buf_c-shift-staff.
  buffer-copy locb-c-shift-staff to buf_c-shift-staff.
end.

for each buf_c-sht-hist where buf_c-sht-hist.obj-type   = wt-shift-obj.obj-type
                           and buf_c-sht-hist.obj-code   = wt-shift-obj.obj-code
                           and buf_c-sht-hist.shift-date = wt-shift-obj.shift-date
                           and buf_c-sht-hist.shift-num  = wt-shift-obj.shift-num
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete buf_c-sht-hist.
end.
for each locb-c-sht-hist where locb-c-sht-hist.obj-type   = wt-shift-obj.obj-type
                            and locb-c-sht-hist.obj-code   = wt-shift-obj.obj-code
                            and locb-c-sht-hist.shift-date = wt-shift-obj.shift-date
                            and locb-c-sht-hist.shift-num  = wt-shift-obj.shift-num
                       no-lock
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  create buf_c-sht-hist.
  buffer-copy locb-c-sht-hist to buf_c-sht-hist.
end.

for each buf_c-shift-obj where buf_c-shift-obj.obj-type   = wt-shift-obj.obj-type
                           and buf_c-shift-obj.obj-code   = wt-shift-obj.obj-code
                           and buf_c-shift-obj.shift-date = wt-shift-obj.shift-date
                           and buf_c-shift-obj.shift-num  = wt-shift-obj.shift-num
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete buf_c-shift-obj.
end.
for each locb-c-shift-obj where locb-c-shift-obj.obj-type   = wt-shift-obj.obj-type
                            and locb-c-shift-obj.obj-code   = wt-shift-obj.obj-code
                            and locb-c-shift-obj.shift-date = wt-shift-obj.shift-date
                            and locb-c-shift-obj.shift-num  = wt-shift-obj.shift-num
                       no-lock
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  create buf_c-shift-obj.
  buffer-copy locb-c-shift-obj to buf_c-shift-obj.
end.



if not available tb-shift-obj then do:
  create tb-shift-obj.
end.
buffer-copy wt-shift-obj to tb-shift-obj.

/* -------------------- почистим за собой ------------------------ */
for each locb-shift-staff
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete locb-shift-staff.
end.

for each locb-shift-cash
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete locb-shift-cash.
end.

for each locb-c-shift-staff
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete locb-c-shift-staff.
end.

for each locb-c-sht-hist
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete locb-c-sht-hist.
end.

for each locb-c-shift-obj
on error  undo, return error
on stop   undo, return error
on endkey undo, return error :
  delete locb-c-shift-obj.
end.
/* $Workfile$ e n d */