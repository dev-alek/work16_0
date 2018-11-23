
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Запускалка браузера техпроливов

Автор: Сергей Палагин
Дата создания: 21/10/18
Author: Sergey Palagin
Creation date: 21/10/18

*/

using utl.*.

block-level on error undo, throw.

define input parameter parParentProc as handle no-undo .

define variable mForm as class gpwdbrw no-undo.

// compile utl/flt-condition.cls.

if ibs.th.gbl.gbl-var:g#db-num <> 0 then
do:
   System.Windows.Forms.MessageBox:Show(
      "Пункт меню доступен только в ГБД.",
      "Внимание!",
      System.Windows.Forms.MessageBoxButtons:OK,
      System.Windows.Forms.MessageBoxIcon:Error).
   return.
end.

assign
   session:debug-alert = yes
   session:error-stack-trace = yes
   gpwdbrw:parParentProc = parParentProc
   gpwdfrm:parParentProc = parParentProc
.


mForm = new utl.gpwdbrw().

if valid-object(mForm) then
    mForm:Wait().
    
catch mErr as Progress.Lang.Error :
   System.Windows.Forms.MessageBox:Show(
      mErr:GetMessage(1) + " " +
      mErr:GetMessage(2) + " " + 
      mErr:GetMessage(3) + mErr:CallStack,
      "Ошибка!",
      System.Windows.Forms.MessageBoxButtons:OK,
      System.Windows.Forms.MessageBoxIcon:Error).
   
end catch.

finally:
   mForm:DisposeForm().   
end finally.
