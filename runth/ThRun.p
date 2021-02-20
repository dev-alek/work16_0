/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Промо-акции

Автор: Рубан Дмитрий Андреевич
Дата создания: 13/10/2020

*/
 
using System.Windows.Forms.* from assembly.
block-level on error undo, throw.
/*session:system-alert-boxes = yes.
session:appl-alert-boxes = yes.
session:debug-alert = yes.*/
session:error-stack-trace=yes.
  define variable v-listth-brw as class runth.ThStart no-undo .
  do trans:
  v-listth-brw = new runth.ThStart (  ).
  wait-for  v-listth-brw:ShowDialog() .
  end.
  quit.
define variable v-err-msg as character no-undo .  
  catch exAppErrors as class Progress.Lang.AppError :
    v-err-msg = exAppErrors:ReturnValue .
    if v-err-msg > "" then . else do :
      v-err-msg = exAppErrors:GetMessage(1) .
      if v-err-msg > "" then . else v-err-msg = "AppError в модуле {&FILE-NAME}" .
    end .
    message v-err-msg  view-as alert-box.
  end catch .
  catch exProErrors as class Progress.Lang.ProError :
    v-err-msg = exProErrors:GetMessage(1) . 
    if v-err-msg > "" then . else v-err-msg = "ProError в модуле {&FILE-NAME}" .
    message "ProError" skip(1) v-err-msg /*skip exProErrors:CallStack*/ view-as alert-box.
  end catch .
  catch exAnyErrors as class Progress.Lang.Error:
    v-err-msg = "Unexpected error в модуле {&FILE-NAME} " + exAnyErrors:GetMessage(1).
    message "LangError" skip(1) v-err-msg /*skip exAnyErrors:CallStack*/ view-as alert-box.
  end catch .
finally:
    session:error-stack-trace=no. 
   if valid-object(v-listth-brw) then delete object v-listth-brw no-error .
end finally.  
/*
finally:
    SESSION:ERROR-STACK-TRACE=no. 
    if valid-object(vPromoTrg) 
    then 
       delete object vPromoTrg no-error .
  end finally.
*/