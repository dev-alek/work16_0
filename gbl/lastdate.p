/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вычисление последней даты месяца для указанной даты

Автор: Перваков Михаил Сергеевич
Дата создания: 04/11/06
Author: Mikhail Pervakov
Creation date: 04/11/06

*/

def input  parameter in-date  as date no-undo .
def output parameter LastDate as date no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Вычисление последней даты месяца для указанной даты".
{ cmp/vssrevis.i "substitute('&1':u,in-date)" }
{ gbl/lastdate.i }

run lastdate in this-procedure
  (input  in-date
  ,output LastDate
  ) no-error .
if error-status :error then do:
  message
    vss-workfile vss-revision vss-description skip
    "Ошибка при определении последнего дня месяца"
    view-as alert-box error .
  undo, return error .
end.