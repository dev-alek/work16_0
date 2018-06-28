/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/10/06
Author: Bakhtadze Natalya
Creation date: 04/10/06

*/

define output parameter this-proc-hndl as handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Удаление пользовательских параметров настройки интерфейса для всех окон".


do:
  
  this-proc-hndl = this-procedure.
  
end.

{ gbl/key-rec.i  }