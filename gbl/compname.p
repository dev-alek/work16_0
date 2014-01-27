/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получить текущее имя компьютера

Автор: Перваков Михаил Сергеевич
Дата создания: 01/27/06
Author: Mikhail Pervakov
Creation date: 01/27/06

*/

define output parameter p-computer-name as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Получить текущее имя компьютера".
{ cmp/vssrevis.i }

define variable v-computer-name-max-size as integer   no-undo .
define variable v-memptr-computer-name   as memptr    no-undo .
define variable v-error-value            as integer   no-undo .
define variable v-result                 as integer   no-undo .

do
on error undo, return error return-value
:
  assign
    v-computer-name-max-size = 1024
  .
  assign
    set-size(v-memptr-computer-name) = v-computer-name-max-size + 5
  .

  assign
    put-long(v-memptr-computer-name, 1) = v-computer-name-max-size
  .

  run GetComputerNameA
    (input  get-pointer-value(v-memptr-computer-name) + 4
    ,input  get-pointer-value(v-memptr-computer-name)
    ,output v-result
    ) .
  if v-result = 0
  then do:
    run GetLastError
      (output v-error-value
      ) .
  end.
  else do:
    assign
      p-computer-name = get-string(v-memptr-computer-name, 5)
    .
  end.

  assign
    set-size(v-memptr-computer-name) = 0
  .

  if v-result = 0
  then do:
    undo, return error
      substitute("Ошибка при определении текущего имени компьютера. Номер ошибки &1"
                ,v-error-value
                ) .
  end.

end.




PROCEDURE GetComputerNameA EXTERNAL "kernel32.dll"
:
   DEFINE INPUT        PARAMETER lpBuffer AS LONG .
   DEFINE INPUT        PARAMETER lpnSize  AS LONG .
   DEFINE RETURN       PARAMETER RetParam  AS LONG .
END PROCEDURE .


PROCEDURE GetLastError EXTERNAL "kernel32.dll"
:
    DEFINE RETURN       PARAMETER RetParam  AS LONG .
END PROCEDURE. /* GetLastError */