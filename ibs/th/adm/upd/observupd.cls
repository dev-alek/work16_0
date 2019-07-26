/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Наблюдатель за обновлениями TH и схемы БД`

Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/

using Progress.Lang.*.
using ibs.th.adm.upd.*.


class ibs.th.adm.upd.observupd:
  
  {cmp/str-glbl.i class}
  {utl/setpwd.i class}
  
  define property List1 as character init "vsd,gds-mercury,c-vsd,c-gds-mercury" no-undo 
    get.

  define property TargetDBShm as integer no-undo 
    get.
    private set.

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
    
  define property IsComp as logical no-undo
    get.
    set.

  define public variable pwd as character no-undo.

  &scop NumWorkBase 9
  define public property  m-upd-list-df      as character extent {&NumWorkBase} no-undo
    initial ["cmp/18051601.df"  
            ,"cmp/18062801.df"
            ,"cmp/18091701.df"
            ,"cmp/18091901.df"
            ,"cmp/18091902.df"
            ,"cmp/18101701_1.df"
            ,"cmp/18102101.df"
            ,"cmp/18102102.df"
            ,"cmp/18112201.df"

            /*,"up2.df"
            ,"up3.df"
            ,"proc:ibs/th/adm/upd/copytable.p;tax-rate-value"
            ,"up4.df"*/
            
            ] 
     get.
  define public property m-upd-list-chk      as character extent {&NumWorkBase} no-undo
    initial ["TABLE:gds-mercury"
            ,"TABLE:PromoAction"
            ,"FIELD:chk-gds-pay.density"
            ,"FIELD:chk-gds.VAT-pc"
            ,"TABLE:norm-loss"
            ,"FIELD:norm-loss.sec-vol1"
            ,"TABLE:tech-prol-pwd" 
            ,"FIELD:c-norm-loss.sec-vol1"
            ,"FIELD:tech-prol-pwd.f-cash-num"

            /*,"TABLE:tax-rate-value_old"
            ,"TABLE:tax-rate-value"
            ,"proc:ibs/th/adm/upd/chkemptable.p;tax-rate-value_old"
            ,""*/
            ] 
    get.
  define public property  upd-all-list-df      as character  no-undo /* список df файлов которые грузятся всегда. */ 
    initial "proc:utl/set-range-bcgb.p"  
    get.
               
  define property upd-df as character no-undo
  get():
    return if extent (m-upd-list-df) > CurrDBShm
           then m-upd-list-df[CurrDBShm + 1] 
           else "".
  end.
  
  /* define property upd-list-chk as character no-undo
  get():
    return if extent (m-upd-list-chk) > CurrDBShm
           then m-upd-list-chk[CurrDBShm + 1]  + if m-upd-list-chk[CurrDBShm + 1] begins "proc:" then "" else ",Initial:db.reserve1-char="
           else "".
  end. */
  
 /* define property upd-list-chk-1 as character no-undo
  get():
    return if extent (m-upd-list-chk) > CurrDBShm
           then m-upd-list-chk[CurrDBShm]  + if m-upd-list-chk[CurrDBShm   ] begins "proc:" then "" else ",Initial:db.reserve1-char="
           else "".
  end. */
  
  constructor observupd ():
    
    define buffer buf_sys-ctrl for ub.sys-ctrl.
    define buffer buf_db for ub.db.
    
    TargetDBShm = extent(m-upd-list-df).
    find first buf_sys-ctrl no-lock no-error.
    if available buf_sys-ctrl
    then do:
       DbNum = buf_sys-ctrl.db-num. 
    
       find first buf_db no-lock where buf_db.db-num = DbNum no-error.
       CurrDBShm = integer (buf_db.reserve1-char) no-error.
    end.
    if     error-status:error
       or not available buf_db
       or buf_db.reserve1-char eq ""
    then do: find first _file no-lock where _file._file-name = "db"  no-error.
        if available _file
        then do:
           find first _field of _file where _field._Field-Name =  "reserve1-char" no-lock no-error.
           if available (_field)
           then do:
              CurrDBShm = integer (_field._initial) no-error.
              /* нужно если не происходит откат загрузки при ошибке */
              /*writeResult (CurrDBShm).*/
              release _field.
           end.
           release _file.
        end.
    end.
   /* CurrDBShm = 8.*/
    find first buf_db no-lock where buf_db.db-num = 0 no-error.
    CurrDB0Shm = integer (buf_db.reserve1-char) no-error.
    pwd = {&paswordcur}.
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

    define variable v-process-id   as integer   no-undo.
    define variable v-process-list as character no-undo.
    define variable vUserIgnor     as character no-undo.
    
    define buffer buf_thbj-attr for ub.thbj-attr.
    
    run gbl/getprcid.p ( output v-process-id ) no-error.
    if error-status:error 
    then do:
      Msg = ( "Невозможно получить PID процесса. Обновление схемы БД невозможно. Работа с ней запрещена!" ).
      IsErr = true.
      return false.
    end.
       
    /*вместо run adm/shattri.p так как потом не получится отконектиться от базы*/
    find first buf_thbj-attr no-lock
       where buf_thbj-attr.obj-type        = {&db}
         and buf_thbj-attr.obj-code        = DbNum 
         and buf_thbj-attr.upper-prop-code = {&attr-auto-task}
         and buf_thbj-attr.prop-code       = {&attr-auto-task_user-list}
    no-error.
    if available buf_thbj-attr
    then do:
       vUserIgnor = buf_thbj-attr.property-value-character.
       release buf_thbj-attr.
    end.
    else
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
      IsErr = true.
      return false.
    end.
    
    return true.
    
  end.
  
  method public void writeResult (input inShm as integer):
    
    define variable vI       as integer no-undo.
    define variable vStrChk  as character no-undo.
    define variable vAttr    as character no-undo.
    define variable vSearch  as character no-undo.
    define variable vValue   as character no-undo.
    define variable vProc    as character no-undo.
    define variable vparam   as character no-undo.
    define variable vOK      as logical   no-undo.
    define variable VTestStr as character no-undo.
    
    define buffer buf_db for ub.db.
    define buffer buf_sys-ctrl for ub.sys-ctrl.
    on write of ub.db override do: end.
    if inShm > 0
    then do:
    VTestStr = m-upd-list-chk[inShm] + if m-upd-list-chk[inShm   ] begins "proc:" then "" else (",Initial:db.reserve1-char=" + string(inShm)).
    
       do vi = 1 to num-entries(VTestStr):
         assign
           vStrChk = entry(vi,VTestStr)
           vattr   = ""
           vValue  = ""
           vSearch = entry(1,vStrChk,":")
           vStrChk = substring(vStrChk,length(vSearch) + 2)
           vValue  = entry (2,vStrChk,"=")
           vStrChk = entry (1,vStrChk,"=")
         no-error.
        /* if entry(vi,upd-list-chk-1) eq "Initial:db.reserve1-char=" then vValue = string(inShm).*/
         if    can-do("Desc,Help,Valmsg,Valexp,Order,Column-label,Decimals,Extent,Data-Type,Initial,Mandatory",vSearch)
         then assign
            vattr = "_" + vSearch 
            vSearch = "FIELD".
          .  
         if vSearch eq "proc"
         then do:
            assign
               vProc  = entry(1,vStrChk,";")
               vParam = entry(2,vStrChk,";")
            no-error.
            run value(vProc) (vParam, output vOk).
            if not vOk
            then do:
               Msg = substitute ( "Обновление схемы БД до версии &1 завершилось неудачно. Не прошла провека '&2' c параметрром '&3'. Работа с ней запрещена!",inShm,Vproc,vParam ).
               IsErr = true.
               return. 
            end.
            
         end.
         else if vSearch eq "TABLE"
         then do:
            
           find first _file no-lock where _file._file-name = vStrChk  no-error.
           if not available (_file)
           then do:
             Msg = substitute ( "Обновление схемы БД до версии &1 завершилось неудачно. Отсутствует таблица &2. Работа с ней запрещена!",inShm,vStrChk ).
             IsErr = true.
             return. 
           end.
         end.  
         else if vSearch eq "FIELD"
         then do:
           find first _file no-lock where _file._file-name = entry(1,vStrChk,".")  no-error.
           if available _file
           then
              find first _field of _file where _field._Field-Name =  entry(2,vStrChk,".") no-lock no-error.
           if not available (_field)
           then do:
             Msg = substitute ( "Обновление схемы БД до версии &1 завершилось неудачно. Отсутствует поле &2. Работа с ней запрещена!", inShm,vStrChk ).
             IsErr = true.
             return.
           end.
           else do:
             define variable vBuffHandle as handle no-undo.
             vBuffHandle = buffer _field:handle.
             if     vattr ne ""
                and vBuffHandle:buffer-field(vattr):buffer-value ne vvalue  
             then do:
               Msg = substitute ( "Обновление схемы БД до версии &1 завершилось неудачно. У поля &2 реквизит &3 не равен &4. Работа с ней запрещена!", inShm,vStrChk,vAttr,vValue ).
               IsErr = true.
               return.
             end.
           end.   
           
         end.
       end.
    end.
    if not iscomp
    then do:
       find first buf_sys-ctrl no-lock no-error.
       if available buf_sys-ctrl 
       then do:
          find first buf_db exclusive-lock where buf_db.db-num = buf_sys-ctrl.db-num no-error.
          buf_db.reserve1-char = string (inShm).
          CurrDBShm = inShm.
          buf_db.reserve2-char = "deferred-callnews".
          release buf_db.
       end.
    end.
    CurrDBShm = inShm.
    isUpdShm = true.
    
  end.
  
  method public logical isneedupg ():
    
    
    if CurrDBShm < TargetDBShm
      then 
    do:
      if not chkdbforupd ()
        then return ?.
      
      return true.
  
    end.
    if upd-all-list-df ne "" and not IsComp then return true.
    return false.
    
  end.
  /*
 
*/
end class.

