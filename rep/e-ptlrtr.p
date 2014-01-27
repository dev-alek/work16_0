/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запускалка отчета r-inptl.p

Автор: Уханов Дмитрий Юрьевич
Дата создания: 01/30/09
Author: Dmitry Ukhanov
Creation date: 01/30/09

Автор1: Суслов Алексей Юрьевич
Дата создания1: 03/27/06


*/

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Запускалка отчета r-ptlrtr.p".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i }
IF NOT CAN-FIND(FIRST obj-list) THEN DO:
   message "Вы не выбрали объект." view-as alert-box.
   return.
END.
FIND FIRST obj-list.

IF NOT CAN-FIND(FIRST gds-list) THEN DO:
   message "Вы не выбрали товар." view-as alert-box.
   return.
END.
FIND FIRST gds-list.
define buffer bf-gds-list for gds-list.
IF CAN-FIND(FIRST bf-gds-list where recid(bf-gds-list) <> recid(gds-list)) then do:
   message "The report is printed on one goods." view-as alert-box.
end.

run rep/r-ptlrtr.p (input my-handle,
                input x-radio-task,
                input x-date-start,
                input x-shift-start,
                input x-date-end,
                input x-shift-end,
                input gds-list.gds-code,
                input obj-list.obj-type,
                input obj-list.obj-code).