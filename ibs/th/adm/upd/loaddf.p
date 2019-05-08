/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обновление схемы БД через df 

Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/
//block-level on error undo, throw.
//process events.
//output to "errrrrr.log".
run prodict/load_df.r (session:parameter + ",no") no-error.

//output close.
//process events.
quit.

/*catch exAppErrors as class Progress.Lang.AppError :
    end catch .
  catch exProErrors as class Progress.Lang.ProError :
   end catch .
  catch exAnyErrors as class Progress.Lang.Error:
     
  end catch .*/