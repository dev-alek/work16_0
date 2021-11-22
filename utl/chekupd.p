/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 3 марта 2021 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 3 марта 2021 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "Проверка обновления".
{cmp\str-glbl.i }
{ cmp/vssrevis.i }
{ cmp/trg-def.i  new}
define input  parameter iChek as logical no-undo.
define input  parameter iTarg as integer no-undo.
define output parameter oUpd  as logical no-undo.
define variable mdb-ver as integer  no-undo init ?.
define variable mdbverd as integer no-undo.
define variable mdbveri as integer no-undo.
find first sys-ctrl no-lock no-error.
if not available sys-ctrl then do: oUpd = yes. return. end. 
g#db-num = sys-ctrl.db-num.
find first db-attr where db-attr.db-num    eq sys-ctrl.db-num
                     and db-attr.attr-code eq  {&attr-ver-db}
no-lock no-error.
if available db-attr then mdb-ver = integer (db-attr.attr-value) no-error.
release db-attr.
release sys-ctrl.
if    iChek
then
   oUpd = mdb-ver ne ? and mdb-ver < iTarg.
else do:
   if mdb-ver eq ? or mdb-ver >= iTarg  
   then do:
      oUpd = true.
      return.
   end.
   define variable v-process-id   as integer   no-undo.
   define variable v-process-list as character no-undo.
   define variable vUserIgnor     as character no-undo.
   define variable Msg            as character no-undo.
   
   run gbl/getprcid.p ( output v-process-id ) no-error.
   if error-status:error 
   then do:
      Msg = ( "Невозможно получить PID процесса. Обновление схемы БД невозможно. Работа с ней запрещена!" ).
      return Msg.
   end.
       
   vUserIgnor = "nws".
    
   for each _Connect where _Connect._Connect-Type = "REMC" 
                       and _Connect._Connect-Pid <> ? 
                       and _Connect._Connect-Pid <> v-process-id
                       and not can-do(vUserIgnor,_Connect._Connect-Name)
   no-lock:
      v-process-list = v-process-list + {&new-line} + string (_Connect._Connect-Pid) + " - " + _Connect._Connect-Name +  " - " + _Connect._Connect-Device.
   end.
   if v-process-list <> ""
   then do:
      Msg = substitute ( "Для обновления схемы БД завершите процессы. &1",  v-process-list).
      return Msg.
   end.
   find first sys-ctrl.
   find first db no-lock where db.db-num = sys-ctrl.db-num no-error.
       
   find first _file no-lock where _file._file-name = "db"  no-error.
   if available _file
   then do:
      find first _field of _file where _field._Field-Name =  "reserve1-char" no-lock no-error.
      release _file.
   end.
   mdbverd = int(db.reserve1-char) no-error.
   release db.
   mdbveri = int(_field._initial ) no-error.
   release _field.
   do trans:
      if mdbverd > mdb-ver
      then do:
         find first db where db.db-num = sys-ctrl.db-num.
         db.reserve1-char = string(mdb-ver).
         release db.
      end.
      if mdbveri > mdb-ver
      then do:
         find first _file no-lock where _file._file-name = "db"  no-error.
         if available _file
         then do:
            find first _field of _file where _field._Field-Name =  "reserve1-char"  no-error.
            _field._initial = string(mdb-ver).
            release _file.
            release _field.
         end.
      end.
      find first db-attr where db-attr.db-num    eq sys-ctrl.db-num
                           and db-attr.attr-code eq  {&attr-ver-db}
      exclusive-lock.
      
      delete db-attr.
      release sys-ctrl.
      return "Для обновление структуры базы запустите TH еще раз.".
   end.
   
   
      
end.    