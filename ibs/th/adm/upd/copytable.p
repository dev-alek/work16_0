
{ gbl/waitfram.i }

define variable vTableList as character no-undo.
vTableList = session:parameter.

define variable vi as integer no-undo.
 
function copytable returns logical (itable_old as character, itable_new as character ) forward.
run waitfram-show in this-procedure ("Копирование данных в новую структуру...").
do vi = 1 to num-entries (vTableList,"|"):
   run waitfram-show in this-procedure ("Копирование данных в новую структуру. Обработка таблицы " + entry(vi,vTableList,"|") ).
   copytable(entry(vi,vTableList,"|") + "_old", entry(vi,vTableList,"|")).
end.
run waitfram-hide in this-procedure .
quit.

function copytable returns logical (itable_old as character, itable_new as character ):
   define variable vBufTargetTable as handle no-undo.
   define variable vBufSourseTable as handle no-undo.
   define variable vQuery          as handle no-undo.
   
   define variable vi as int64 no-undo.
    
   create buffer vBufTargetTable for table itable_new.
   vBufTargetTable:disable-load-triggers (false).
   create buffer vBufSourseTable for table itable_old.
   create query vQuery.

   vQuery:set-buffers(vBufSourseTable).
   vQuery:query-prepare("preselect EACH " + vBufSourseTable:name + " no-lock").
   vQuery:query-open().
   vQuery:get-first().
   
   do while vBufSourseTable:available:
      
      run waitfram-show in this-procedure ("Копирование данных в новую структуру. Oбработка таблицы " + entry(vi,vTableList,"|") + ". Обработано записей : " + string (vi)).
      do transaction:
         vBufTargetTable:buffer-create ().
         vBufTargetTable:buffer-copy (vBufSourseTable).
         vBufTargetTable:buffer-release ().
         vBufSourseTable:find-current (exclusive-lock).
         vBufSourseTable:buffer-delete ().  
      end.
      vi = vi + 1.
      vQuery:get-next().
   end.
   vQuery:query-close().
   delete object vQuery.
   delete object vBufTargetTable.
   delete object vBufSourseTable.
end.
