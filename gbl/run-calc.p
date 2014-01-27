/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запуск калькулятора windows

Автор: Перваков Михаил Сергеевич
Дата создания: 04/05/06
Author: Mikhail Pervakov
Creation date: 04/05/06

*/

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Запуск калькулятора windows".
{ cmp/vssrevis.i }

do
on error undo, return error return-value
:
  run gbl/open_url.p ( "calc.exe" ).
end.