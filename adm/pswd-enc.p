/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Кодировка парол

Автор: Уханов Дмитрий Юрьевич
Дата создания: 03/27/06
Author: Dmitry Ukhanov
Creation date: 03/27/06

*/

define input parameter  pswd     as character no-undo .
define output parameter enc-pswd as character no-undo .

do
on error undo, return error return-value
:
  run pswd-enc-procedure in this-procedure
    (input  pswd
    ,output enc-pswd
    ) .
end.

{ adm/pswd-enc.i
  &proc-name=pswd-enc-procedure
}