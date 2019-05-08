
/*{ gbl/waitfram.i }*/

define variable v-waitfram-action01         as character no-undo .
define variable v-waitfram-action02         as character no-undo .
define variable v-waitfram-action03         as character no-undo .
define variable v-waitfram-prev-left-margin as integer   no-undo init 0 .

define frame waitfram
  v-waitfram-action01 format "x(72)" no-label skip
  v-waitfram-action02 format "x(72)" no-label skip
  v-waitfram-action03 format "x(72)" no-label skip
  with view-as dialog-box side-labels three-d
  .

procedure waitfram-hide :

  do
  on error undo, return error return-value
  :
    pause 0 before-hide .
    hide frame waitfram .

&if "{1}" = "" &then
    process events .
&endif
  end.

end procedure. /* waitfram-hide */


procedure waitfram-show :

  define input  parameter p-message as character no-undo .

  define variable v-left-margin as integer   no-undo .

  do
  on error undo, return error return-value
  :
    if length(p-message) <= 70 then do:
      assign
        v-left-margin = integer((70 - length(p-message)) / 2)
      .
      assign
        v-left-margin = max(0, v-left-margin - (v-left-margin mod 5))
      .
      if abs(v-left-margin - v-waitfram-prev-left-margin) > 5 then do:
        assign
          v-waitfram-prev-left-margin = v-left-margin
        .
      end.

      assign
        v-waitfram-action01 = " "
        v-waitfram-action02 = " "
                                 + fill(" ", v-waitfram-prev-left-margin)
                                 + p-message
        v-waitfram-action03 = " "
      .
    end.
    else do:
      if length(p-message) <= 140 then do:
        assign
          v-waitfram-action01 = " "
          v-waitfram-action02 = " " + substring(p-message,   1, 70)
          v-waitfram-action03 = " " + substring(p-message,  71, 70)
        .
      end.
      else do:
        assign
          v-waitfram-action01 = " " + substring(p-message,   1, 70)
          v-waitfram-action02 = " " + substring(p-message,  71, 70)
          v-waitfram-action03 = " " + substring(p-message, 141, 70)
        .
      end.
    end.

    display
      v-waitfram-action01 skip
      v-waitfram-action02 skip
      v-waitfram-action03 skip
      with frame waitfram .
&if "{1}" = "" &then
    process events .
&endif
  end.

end procedure. /* waitfram-show */

/*session:debug-alert = yes.*/
define variable vTableList as character no-undo.
vTableList = trim(session:parameter,'"').

define variable vi as integer no-undo.
 
function copytable returns logical (itable_old as character, itable_new as character ) forward.
run waitfram-show in this-procedure ("Копирование данных в новую структуру...").
def var mtablename as char no-undo.
do vi = 1 to num-entries (vTableList,"|"):
   mtablename  = entry(vi,vTableList,"|").
   run waitfram-show in this-procedure ("Копирование данных в новую структуру. Обработка таблицы " + mtablename ).
   copytable(mtablename + "_old", mtablename).
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
      
      run waitfram-show in this-procedure ("Копирование данных в новую структуру. Oбработка таблицы " + itable_new + ". Обработано записей : " + string (vi)).
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
