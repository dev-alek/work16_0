/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура обновления TH и схемы БД

Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

using ibs.th.adm.upd.*.

{ cmp/str-glbl.i }

define input parameter p-connpar as character no-undo.
define output parameter p-isUpdShm as logical init false no-undo.
define variable updschmObj as class updschm no-undo.
define variable str as character no-undo.

updschmObj = new updschm (input p-connpar).
if updschmObj:IsErr
then do:
  str = updschmObj:Msg.
  delete object updschmObj no-error.
  return error str.  
end.

if updschmObj:isNeedUpd
then do:
  updschmObj:upddbshm().
  if updschmObj:IsErr
  then do:
    str = updschmObj:Msg.
    delete object updschmObj no-error.
    return error str.  
  end.
end.

p-isUpdShm = updschmObj:isUpdShm.
delete object updschmObj.
