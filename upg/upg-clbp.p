/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

удаление всех записей BatchProcess с типом {&btpr-type-autoupg}

Автор: Уханов Дмитрий Юрьевич
Дата создания: 03/22/02
Author: Dmitry Ukhanov
Creation date: 03/22/02

*/

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "удаление всех записей BatchProcess с типом {&btpr-type-autoupg}".

{ cmp/str-glbl.i }

do
on error undo, return error
:
  define buffer buf_BatchProcess for BatchProcess.

  for each buf_BatchProcess
    where buf_BatchProcess.BP_Type = {&btpr-type-autoupg}
  on error undo, return error
  :
    delete buf_BatchProcess .
  end.

end.

/* $Workfile$ end */