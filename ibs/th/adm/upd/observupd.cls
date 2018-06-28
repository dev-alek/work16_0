/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Наблюдатель за обновлениями TH и схемы БД

Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/

using Progress.Lang.*.
using ibs.th.adm.upd.*.


class ibs.th.adm.upd.observupd: 
  
  {cmp/str-glbl.i class}
  
  define property List1 as character init "vsd,gds-mercury,c-vsd,c-gds-mercury" no-undo 
    get.

  define property TargetDBShm as integer init 1 no-undo 
    get.

  define property CurrDBShm as integer  no-undo 
    get.
    private set.

  define property CurrDB0Shm as integer  no-undo 
    get.
    private set.

  define property isUpdShm as logical no-undo 
    get.
    private set.

  define property DbNum as integer init ?  no-undo 
    get.
    private set.

  define property IsErr as logical no-undo
    get.
    private set.

  define property Msg as character no-undo
    get.
    private set.

  constructor observupd ():
    
    define buffer buf_sys-ctrl for ub.sys-ctrl.
    define buffer buf_db for ub.db.
    find first buf_sys-ctrl no-lock.

    DbNum = buf_sys-ctrl.db-num.
    
    find first buf_db no-lock where buf_db.db-num = DbNum.
    CurrDBShm = integer (buf_db.reserve1-char) no-error.
    if CurrDBShm = ?
      then CurrDBShm = 0.
    
    find first buf_db no-lock where buf_db.db-num = 0.
    CurrDB0Shm = integer (buf_db.reserve1-char) no-error.
    if CurrDB0Shm = ?
      then CurrDB0Shm = 0.
    
    release buf_db.
    release buf_sys-ctrl.
    
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:  проверка списка и исключение из него баз данных, которые не обновили схему по таблице
  ------------------------------------------------------------------------------*/
  method public void dbexcept( input-output inListDb as char, input inTableName as char ):
    
    def var ii as int no-undo.
    def var iDB as int no-undo.
    def var numentr as int no-undo.
    def var newListDB as char no-undo init "NULL".
    def var dBShm0 as integer no-undo.
    def var TempInt as integer no-undo.
    define buffer buf_db for ub.db.

    if DbNum <> 0 
        then return. /* в ГБД всегда новости отправляем */
    dbShm0 = CurrDB0Shm.
    numentr = num-entries (inListDb, {&delim-nws}) no-error.
    if numentr = ? 
    then do:
      return .
    end.
    if lookup (inTableName, List1) > 0
    then do:
      do ii = 1 to numentr:
        TempInt = 0.
        iDB = integer (entry (ii, inListDb, {&delim-nws} )) no-error.
        for each buf_db where buf_db.db-num = iDB and buf_db.db-num <> 0:
          TempInt = integer (buf_db.reserve1-char) no-error.
          if TempInt = ?
            then TempInt = 0.
          if TempInt = 1
          then do:
            if newListDB = "NULL"
              then newListDB = "".
            newListDB = newListDB + {&delim-nws} + string (iDB).
          end.
        end.
      end.
      inListDb = trim (newListDB, {&delim-nws}).
    end.
    
    return.

  end method.


  
  method private logical chkdbforupd ():

    define variable v-process-id as integer no-undo.
    define variable v-process-list as character no-undo.

    run gbl/getprcid.p ( output v-process-id ) no-error.
    if error-status:error 
    then do:
      Msg = ( "Невозможно получить PID процесса. Обновление схемы БД невозможно. Работа с ней запрещена!" ).
      IsErr = true.
      return false.
    end.
    
    for each _Connect where _Connect._Connect-Type = "REMC" and _Connect._Connect-Pid <> ? and _Connect._Connect-Pid <> v-process-id:
      v-process-list = v-process-list + {&new-line} + string (_Connect._Connect-Pid) + " - " + _Connect._Connect-Name +  " - " + _Connect._Connect-Device.
    end.
    if v-process-list <> ""
    then do:
      Msg = substitute ( "Для обновления схемы БД завершите процессы. &1",  v-process-list).
      IsErr = true.
      return false.
    end.
    
    return true.
    
  end.
  
  method public void writeResult (input inShm as integer):

    define buffer buf_db for ub.db.
    define buffer buf_sys-ctrl for ub.sys-ctrl.
    on write of ub.db override do: end.
    
    if inShm > 0
    then do:
      find first _file no-lock where _file._file-name = 'gds-mercury' no-error.
      if not available (_file)
        then do:
          Msg = substitute ( "Обновление схемы БД до версии 1 завершилось неудачно. Работа с ней запрещена!" ).
          IsErr = true.
          return.
        end.
    end.
    
    find first buf_sys-ctrl no-lock.
    find first buf_db exclusive-lock where buf_db.db-num = buf_sys-ctrl.db-num no-error.
    buf_db.reserve1-char = string (inShm).
    buf_db.reserve2-char = "deferred-callnews".
    release buf_db.
    isUpdShm = true.
    
  end.
  
  method public logical isneedupg ():
    
    define variable updschmObj as class updschm no-undo.
  
    if CurrDBShm < TargetDBShm
      then 
    do:
      if not chkdbforupd ()
        then return ?.
      
      return true.
  
    end.
    return false.
    
  end.
  
end class.

