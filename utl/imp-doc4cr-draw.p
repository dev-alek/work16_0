{utl/imp-parts.i }
define input  parameter iUtil        as class ibs.th.utl.method-for-draw-utility no-undo.
define input  parameter iosn-fname   as character no-undo.
define input  parameter iart-fname   as character no-undo.
define input  parameter iretry-fname as character no-undo.
define input  parameter table for tt-imp-parts .


 define variable v-count-err as integer no-undo .
  run utl/imp-doc4cr.p ( iUtil:parparentproc
                       , this-procedure // хронометраж через write-log-and-file()
                       , ""             // имя лог-файла, в который выводится хронометраж
                       , iUtil:Obj-code
                       , iUtil:Obj-type
                       , true // закрывать созданные документы
                       , iosn-fname // список соответствия поставщиков
                       , iart-fname // список соответствия товаров
                       , iretry-fname // файл для повторного импорта
                       , input table tt-imp-parts
                     , output v-count-err  
                       ) .
                       
procedure write-log-and-file :
define input parameter p1 as integer no-undo .
define input parameter p2 as character no-undo .
define input parameter p3 as integer no-undo .
define input parameter p-message as character no-undo .
  iutil:put-log(p-message) .  
end procedure.                       