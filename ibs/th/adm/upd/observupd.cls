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
  &scop NumWorkBase 9
  define private variable  m-upd-list-df      as character extent {&NumWorkBase} no-undo
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
            
            ] .
  define private variable  m-upd-list-chk      as character extent {&NumWorkBase} no-undo
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
            ] .
  define public property  upd-all-list-df      as character  no-undo /* список df файлов которые грузятся всегда. */ 
    initial ""  
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
  define public variable mFileDf as character no-undo.
  define public variable mUpdateTo as integer no-undo.
  
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
           end.
        end.
    end.
   /* CurrDBShm = 8.*/
    find first buf_db no-lock where buf_db.db-num = 0 no-error.
    CurrDB0Shm = integer (buf_db.reserve1-char) no-error.
    
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
    
    define variable updschmObj as class updschm no-undo.
    if upd-all-list-df ne "" then return true.
    if CurrDBShm < TargetDBShm
      then 
    do:
      if not chkdbforupd ()
        then return ?.
      
      return true.
  
    end.
    return false.
    
  end.
  define stream sReadfile.
  //define variable mMode as character no-undo. 
  define variable mBuffer     as handle    no-undo.
  define variable mBufferName as character no-undo.
  define variable mName       as character no-undo.
  
  &glob prefixtt tt-
  &glob prefixfil f-
  &glob logicalfield логическое_поле 
  define temp-table {&prefixtt}TABLE
     field {&prefixfil}mode as char
     field {&prefixfil}Name as char
     field {&prefixfil}NewName as char
     
     field {&prefixfil}AREA as char
     field {&prefixfil}LABEL as char
     field {&prefixfil}CAN-CREATE as char
     field {&prefixfil}CAN-DELETE as char
     field {&prefixfil}CAN-READ as char
     field {&prefixfil}CAN-WRITE as char
     field {&prefixfil}CAN-DUMP as char
     field {&prefixfil}CAN-LOAD as char
     field {&prefixfil}DESCRIPTION as char
     field {&prefixfil}DUMP-NAME as char
     field {&prefixfil}TABLE-TRIGGER as char
     
     field {&prefixfil}localIndex as integer
     index {&prefixfil}localIndex {&prefixfil}localIndex
 .

   define temp-table {&prefixtt}FIELD
      field {&prefixfil}mode as char
      field {&prefixfil}Name as char
      field {&prefixfil}NewName as char
      
      field {&prefixfil}Table as char
      field {&prefixfil}Data-Type  as char
      
      field {&prefixfil}DESCRIPTION as char
      field {&prefixfil}FORMAT as char
      field {&prefixfil}INITIAL as char
      field {&prefixfil}LABEL as char
      field {&prefixfil}POSITION as char
      field {&prefixfil}MAX-WIDTH as char
      field {&prefixfil}COLUMN-LABEL as char
      field {&prefixfil}DECIMALS as char
      field {&prefixfil}HELP as char
      field {&prefixfil}ORDER as char
      field {&prefixfil}MANDATORY as char
      field {&prefixfil}NULL-ALLOWED as char
      
      field {&prefixfil}localIndex as integer 
     index {&prefixfil}localIndex {&prefixfil}localIndex
   .

define temp-table {&prefixtt}INDEX
      field {&prefixfil}mode as char
      field {&prefixfil}Name as char
      field {&prefixfil}NewName as char
      
      field {&prefixfil}Table as char
      field {&prefixfil}AREA as char
      field {&prefixfil}DESCRIPTION as char
      field {&prefixfil}UNIQUE as char
      field {&prefixfil}PRIMARY as char
      field {&prefixfil}INDEX-FIELD as char
      
      field {&prefixfil}localIndex as integer
     index {&prefixfil}localIndex {&prefixfil}localIndex
      
   .
   define temp-table {&prefixtt}SEQUENCE
      field {&prefixfil}mode as char
      field {&prefixfil}Name as char
      field {&prefixfil}NewName as char
      
      field {&prefixfil}INITIAL as char
      field {&prefixfil}INCREMENT as char
      field {&prefixfil}CYCLE-ON-LIMIT as char
      field {&prefixfil}MIN-VAL as char
      field {&prefixfil}MAX-VAL as char
      
      field {&prefixfil}localIndex as integer
     index {&prefixfil}localIndex {&prefixfil}localIndex
   .
  method public logical createDF (iCurrDBShm as integer):
     return createDF(iCurrDBShm,TargetDBShm).
  end method.   
  
  method public logical createDF (iCurrDBShm as integer, iTargetDBShm as integer):
     define variable vi as integer no-undo.
     define variable vFileDf as character no-undo.
     define variable vFlagDf as logical no-undo.
     block-read:
     do  vi = iCurrDBShm + 1 to minimum(iTargetDBShm,TargetDBShm):
        if not m-upd-list-df[vi    ] begins "proc:"
        then do:
           vFlagDf = yes.
           if readDF(m-upd-list-df[vi])
           then
              return no.
        end.
        else do:
           mFileDf   = m-upd-list-df[vi    ].
           mUpdateTo = vi.
           return yes. 
        end.
        if vi >= TargetDBShm 
           or (        m-upd-list-df[vi    ] begins "proc:")
               or
               (    not m-upd-list-df[vi    ] begins "proc:"
                and     m-upd-list-df[vi + 1] begins "proc:"               
                
               )
         then 
            leave block-read.  
     end.
     if vi > minimum(iTargetDBShm,TargetDBShm) 
     then 
        vi = minimum(iTargetDBShm,TargetDBShm).
     create {&prefixtt}FIELD.
     assign
       {&prefixfil}mode       = "UPDATE"   // дополнительные кавычки нужны для выгрузки DF
       {&prefixfil}Name       = '"reserve1-char"'
       {&prefixfil}Table      = '"db"'
       {&prefixfil}initial    = '"' + string(vi) + '"' 
       {&prefixfil}localIndex = 1
     .
     
     vFileDf = substitute ("&1_&2_&3.df","update",iCurrDBShm,vi).
     dumpTable(vFileDf).
     mFileDf   = vFileDf.
     mUpdateTo = vi.
     return yes.   
  end.
  
  method public character  addDFNumUpd (iFileDf as character, num as integer ):
     define variable Vi          as integer no-undo.
     define variable vfiledf     as character no-undo.
     define variable vSTR        as character no-undo.
     define variable vFileDf_new as character no-undo.
     define variable vFirst      as logical no-undo init yes.
     
     
     do vi = 1 to num-entries(iFileDf):
         vFileDf_new = replace( iFileDf, "~\", "~/" ).
         vFileDf_new = entry( num-entries( vFileDf_new, "~/" ), vFileDf_new, "~/" ).
         entry(1,vFileDf_new, ".") =  entry(1,vFileDf_new, ".") + "_" + string (num).
          
         
         vfiledf = search (entry(vi,iFileDf)).
         output to value(vFileDf_new).
         input STREAM sReadfile FROM  VALUE(vfiledf).
         block-file:
         repeat:
             import stream sReadfile unformatted vSTR.
             if      trim (vstr) eq "."
                and vFirst             
             then do:
                vFirst = no.
                put unformatted  'UPDATE FIELD "reserve1-char" OF "db"' skip '  INITIAL "' + string(num) + '"' skip(1).
               
             end.
             if trim(vstr) eq ""
             then
             put unformatted      skip(1) .
             else  
             put unformatted trim (replace (vstr,"  "," ")) skip .
         end.
         
         input STREAM sReadfile CLOSE.
         output close.
         entry(vi,iFileDf) = vFileDf_new.
      end.
     return iFileDf.
  end.   
      
  method public logical readDF (iFileDf as character ):
      define variable vSTR as character no-undo.
      define variable vI as integer no-undo.
      define variable vfiledf as character no-undo.
      
      do vi = 1 to num-entries(iFileDf):
         vfiledf = search (entry(vi,iFileDf)).
         input STREAM sReadfile FROM  VALUE(vfiledf).
         block-file:
         repeat:
             import stream sReadfile unformatted vSTR.
             if trim (vstr) eq "." then leave block-file.
             if parsString(vSTR)
             then 
                return yes.
         end.
         input STREAM sReadfile CLOSE.
      end.
      finally:
      if valid-handle (mBuffer)
         then
            delete object mBuffer.
      end finally.      
  end method.
  
     
   method private logical parsString ( iStr as character ):
      
      define variable vStrTmp     as character no-undo. 
      
      
      define variable vTableWhere as character no-undo.
      define variable vFieldName  as character no-undo.
      define variable vOptionalWhere as character no-undo.
      define variable vMode          as character no-undo.
      define variable vtarget        as character no-undo.
      define variable vposih         as integer no-undo init 1.
      define variable vSdvig         as integer no-undo.
      define variable VPrimary       as logical no-undo.
      
      iStr = trim (replace (istr,"  "," ")).
      if istr eq "" then return no.
      vMode = entry(1,istr, " ").
      
      if can-do("add,update,drop,rename", vMode)
      then do:
         mBufferName = entry(2,istr, " ") no-error.
         if error-status:error
         then do: 
            message "Ошибка структуре df файла не задан объект для метода " vMode
               view-as alert-box.
            return yes.
         end.
         if mBufferName eq "PRIMARY"
         then do:  
             mBufferName = entry(3,istr, " ") no-error.
             if error-status:error
             then do: 
                message "Ошибка структуре df файла не задан объект для метода " vMode
                   view-as alert-box.
                return yes.
             end.
             assign 
                vSdvig   = 1
                VPrimary = yes 
                .
         end.
         if valid-handle( mBuffer)
         then 
            delete object mBuffer.
            
         create buffer mBuffer for table "{&prefixtt}" + mBufferName no-error.
         //mBuffer =  mBuffer:GET-BUFFER-HANDLE ("{&prefixtt}" + vBufferName) no-error.
         if error-status:error
         then do: 
            message "Не известный буфер " "{&prefixtt}" + mBufferName
               view-as alert-box.
            return yes.
         end.

         mName = entry(3 + vSdvig,istr, " ") no-error.
         if error-status:error
         then do: 
            message "Ошибка структуре df файла не задан объект для метода " vMode " для таблицы " "{&prefixtt}" + mBufferName
               view-as alert-box.
            return yes.
         end.
         if    mBufferName eq "field"
            or mBufferName eq "index"
         then do:
            vTableWhere = if vMode eq "rename" then entry(7,istr, " ") else entry(5 + vSdvig,istr, " ") no-error.
            if error-status:error
            then do: 
               message "Ошибка структуре df файла не задан таблица для " mBufferName mName
                  view-as alert-box.
               return yes.
            end.
            else do:
               if vMode eq "rename" then vtarget = entry(5,istr, " ").
               vOptionalWhere = substitute (" and {&prefixtt}&1.{&prefixfil}table eq '&2'",mBufferName,vTableWhere).
               
            end.   
         end.
         else
            vOptionalWhere = "".
         vOptionalWhere = substitute ("where {&prefixtt}&1.{&prefixfil}Name eq '&2' &3",mBufferName,mName,vOptionalWhere).
         mBuffer:find-last(vOptionalWhere, no-lock) no-error.
         if mBuffer:available 
         then do:
            if     vMode                     eq "rename"
               and mBuffer::{&prefixfil}mode eq "add"
            then do:
               if mbuffername eq "table"
               then
                  ChangeTable(mBuffer::{&prefixfil}Name , entry(5,istr, " ")).
               mBuffer::{&prefixfil}Name = entry(5,istr, " ").
            end.    
            else if      mBuffer::{&prefixfil}mode eq "rename" 
                      or (    vMode eq "rename"
                          and vmode eq "update")
            then do:
               vposih = mBuffer::{&prefixfil}localIndex + 1.
               mBuffer:buffer-release ().
               //mBuffer::{&prefixfil}Name = entry(5,istr, " ").
            end.    
            else if vmode eq "add" 
            then do: 
               message "Ошибка структуре df файла объект создан рание " vmode mBufferName mName vTableWhere
                  view-as alert-box.
               return yes.
            end.
            else if vmode eq "drop"
            then do:
               if mBuffer::{&prefixfil}mode eq "add"
               then mBuffer:buffer-delete ().
               else
                  mBuffer::{&prefixfil}mode = vmode.
             
            end.
                
         end.
         if not mBuffer:available 
         then do:
            mBuffer:buffer-create ().
            mBuffer::{&prefixfil}mode       = vmode.
            mBuffer::{&prefixfil}Name       = mName.
            mBuffer::{&prefixfil}localIndex = vposih.
            if vMode eq "rename" then mBuffer::{&prefixfil}NewName = entry(5,istr, " ").
         end.
         if VPrimary 
         then
           mBuffer:buffer-field("{&prefixfil}PRIMARY"):BUFFER-VALUE () = "{&logicalfield}".
         if    mBufferName eq "field"
            or mBufferName eq "index"
         then 
            mBuffer::{&prefixfil}table = vTableWhere.
         if    mBufferName eq "field"
         then do: 
            mBuffer::{&prefixfil}Data-Type = entry(7,istr, " ") no-error.
            if     error-status:error
               and vMode eq "add"
            then do: 
               message "Ошибка структуре df файла не задан таблица для " mBufferName mName
                  view-as alert-box.
               return yes. 
            end.
         end.
      end.             
      else do: // can-do("add,update,drop", vStrTmp)
         if    mBufferName eq "table" and can-do("AREA,LABEL,DESCRIPTION,DUMP-NAME,TABLE-TRIGGER,CAN-CREATE,CAN-DELETE,CAN-READ,CAN-WRITE,CAN-DUMP,CAN-LOAD",trim(vMode,'"'))
            or mBufferName eq "field" and can-do("DESCRIPTION,FORMAT,INITIAL,LABEL,POSITION,MAX-WIDTH,COLUMN-LABEL,DECIMALS,HELP,ORDER,MANDATORY,NULL-ALLOWED",trim(vMode,'"'))
            or mBufferName eq "INDEX" and can-do("AREA,DESCRIPTION,UNIQUE,PRIMARY,INDEX-FIELD",trim(vMode,'"'))          
            or mBufferName eq "SEQUENCE" and can-do("INITIAL,INCREMENT,CYCLE-ON-LIMIT,MIN-VAL,MAX-VAL",trim(vMode,'"'))
         then do:
               vFieldName = "{&prefixfil}" + vMode no-error.
               if error-status:error
               then do: 
                  message "Ошибка структуре df  объекта " mBufferName mName "нет поля в таблице" "{&prefixfil}" + vMode
                     view-as alert-box.
                  return yes.
               end.
               define variable vval as character no-undo.
               vval = trim(
                                                                  (if can-do("INDEX-FIELD,TABLE-TRIGGER" ,vmode)  
                                                                  then mBuffer:buffer-field(vFieldName):BUFFER-VALUE () + {&delim-par}
                                                                  else "")
                                                                + trim (substring (istr,length(vMode) + 2)) 
                                                                ,{&delim-par} ).
               mBuffer:buffer-field(vFieldName):BUFFER-VALUE () = vval   no-error.  
                
               if mBuffer:buffer-field(vFieldName):BUFFER-VALUE () eq "" 
               then 
                  mBuffer:buffer-field(vFieldName):BUFFER-VALUE () = "{&logicalfield}".
               if error-status:error
               then do: 
                  message "2 Ошибка структуре df  объекта " mBufferName mName 
                     view-as alert-box.
                  return yes.
               end.
               if vMode eq "NULL-ALLOWED"
               then
                  mBuffer:buffer-field("{&prefixfil}MANDATORY"):BUFFER-VALUE () = "".
               else if vMode eq "MANDATORY"
               then
                  mBuffer:buffer-field("{&prefixfil}NULL-ALLOWED"):BUFFER-VALUE () = "".
             
         end.       
         else do:
            message "Ошибка структуре df  объекта " mBufferName mName  "неизвестное выражение" vMode
                     view-as alert-box.
               return yes.
         end.
         
      end.     // can-do("add,upddate,drop", vStrTmp)
   
   end method.
   method public void dumpTable(ifile  as character):
      output to value(ifile).
      output close.
      dumpOneTable(ifile,temp-table {&prefixtt}Table:handle ).
      dumpOneTable(ifile,temp-table {&prefixtt}field:handle ).
      dumpOneTable(ifile,temp-table {&prefixtt}index:handle ).
      dumpOneTable(ifile,temp-table {&prefixtt}SEQUENCE:handle ).
      output to value(ifile) append.
      put unformatted "." skip "PSC" skip "cpstream=1251" skip "." skip .
      output close.                                
   end.
   method private void dumpOneTable(ifile  as character,
                                   iTable as  handle):
   
   define var vItm   as int64  no-undo.
   define var vJ   as int64  no-undo.
   define var vField as handle   no-undo.

   define var vQuery  as handle no-undo.
   define var vBuffer as handle no-undo.
   define variable vTxt       as character no-undo.
   define variable vFieldName as character no-undo.
   define variable vFieldPref as integer   no-undo.
   
   vBuffer = iTable:default-buffer-handle.
   output to value(ifile) append.
   create query vQuery.
   vQuery:add-buffer(vBuffer).
   if not vQuery:query-prepare("for EACH " + vBuffer:name) then message "ERROR 1" error-status:get-message(1) view-as alert-box.
   if not vQuery:query-open()                              then message "ERROR 2" error-status:get-message(1) view-as alert-box.
   vQuery:get-first().
   if vBuffer:available
   then do: 
      
      vFieldPref = length("{&prefixfil}") + 1. 
      do while vBuffer:available:
         
         vtxt = if vBuffer:name eq "{&prefixtt}field" 
             then substitute ("&1 FIELD &2&3 OF &4 &5",
                              vBuffer::{&prefixfil}mode,
                              vBuffer::{&prefixfil}name,
                              if vBuffer::{&prefixfil}mode eq "rename" then " TO " + vBuffer::{&prefixfil}NewName else "",
                              vBuffer::{&prefixfil}table,
                              if vBuffer::{&prefixfil}Data-Type ne "" then "AS " + vBuffer::{&prefixfil}Data-Type else "")
             else if vBuffer:name eq "{&prefixtt}index" 
             then substitute ("&1 INDEX &2&3 ON &4",
                              vBuffer::{&prefixfil}mode,
                              vBuffer::{&prefixfil}name,
                              if vBuffer::{&prefixfil}mode eq "rename" then " TO " + vBuffer::{&prefixfil}NewName else "",
                              vBuffer::{&prefixfil}table)
             else substitute ("&1 &2 &3&4",
                              vBuffer::{&prefixfil}mode,
                              substring(vBuffer:name,length("{&prefixtt}") + 1),
                              vBuffer::{&prefixfil}name,
                              if vBuffer::{&prefixfil}mode eq "rename" then " TO " + vBuffer::{&prefixfil}NewName else ""
                              ).
         put unformatted vtxt skip.
         do vItm = 1 to vBuffer:num-fields:
            vField = vBuffer:buffer-field(vItm).
            vFieldName = substring(vField:name,vFieldPref).
            
            if not can-do("mode,name,newname,table,Data-Type,localindex" + (if iscomp then ",area" else "") ,vFieldName)
            then do:
               
               do vj = 1 to if vField:buffer-value eq ? then 1 else num-entries(vField:buffer-value,{&delim-par}):
                  define variable vValue as character no-undo.
                  vValue = entry(vj,vField:buffer-value,{&delim-par}).
                  if vValue eq "{&logicalfield}" then vValue = "". 
                  put unformatted substitute ('  &1 &2',vFieldName,vValue) skip.
               end.    
            end.
         end.
         put unformatted skip(1).
         vQuery:get-next().
      end.
   end.
   vQuery:query-close().

   delete object vQuery.
   output close.
end method.
method public logical CheckTable(ifile  as character):
      define variable vOk as logical no-undo.
      define variable oOK as logical no-undo.
      oOK = CheckOneTable(temp-table {&prefixtt}Table:handle ).
      vOk = CheckOneTable(temp-table {&prefixtt}field:handle ).
      oOK = oOK and vOk.  
      vOk = CheckOneTable(temp-table {&prefixtt}index:handle ).
      oOK = oOK and vOk.
      vOk = CheckOneTable(temp-table {&prefixtt}SEQUENCE:handle ).
      oOK = oOK and vOk.
      
      if not oOK
      then
         dumpTable(ifile).
      return oOK.                                
   end.
method private logical CheckOneTable(iTable as  handle):
   
   define var vItm   as int64  no-undo.
   define var vJ   as int64  no-undo.
   define var vField as handle   no-undo.

   define var vQuery  as handle no-undo.
   define var vBuffer as handle no-undo.
   define var vBufferDB as handle no-undo.
   define variable vTxt       as character no-undo.
   define variable vFieldName as character no-undo.
   define variable vFieldPref as integer   no-undo.
   define variable vFieldValue as character no-undo.
   define variable vBufferName as character no-undo.
   define variable vWhere      as character no-undo.
   define variable vOk     as logical no-undo.
   define variable oOk     as logical no-undo.
   define variable verror  as logical no-undo.
   define variable vFlagEQ as logical no-undo.
   define variable vCheckField as logical no-undo.
   
   vBuffer = iTable:default-buffer-handle.
   create query vQuery.
   vQuery:add-buffer(vBuffer).
   if not vQuery:query-prepare("PRESELECT EACH " + vBuffer:name) 
   then do: 
      message "ERROR 1" error-status:get-message(1) view-as alert-box.
      verror = yes.
   end.   
   if not vQuery:query-open()                              
   then do:
      message "ERROR 2" error-status:get-message(1) view-as alert-box.
      verror = yes.
   end.   
   vQuery:get-first().
   if vBuffer:available
   then do:
      if  vBuffer:name eq "{&prefixtt}TABLE"
      then
         vBufferName = "_file".
      else if  vBuffer:name eq "{&prefixtt}field"
      then  do:
         assign
            vBufferName = "_field"
            vCheckField = yes
         .
         
      end.   
      else if  vBuffer:name eq "{&prefixtt}Index"
      then 
         vBufferName = "_Index".
      else if  vBuffer:name eq "{&prefixtt}Sequence"
      then 
         vBufferName = "_Sequence".
      else
         return no.   
     //    _field._Field-Name
         
      create buffer vBufferDB for table  vBufferName no-error.
      vFieldPref = length("{&prefixfil}") + 1. 
      do while vBuffer:available:
         if  vBuffer:name eq "{&prefixtt}TABLE"
      then
         vWhere      = substitute ("where _file._file-name eq &1 ",vBuffer::{&prefixfil}name).
      else if  vBuffer:name eq "{&prefixtt}field"
      then do:
         define variable vvvv as character no-undo.
         vFieldValue = trim(  vBuffer::{&prefixfil}table, '"').
         find first _file no-lock where _file._file-name = vFieldValue  no-error.
         if available _file
         then 
            vWhere      = substitute ("where _field._file-recid eq &1 and _field._Field-Name eq &2 ",recid(_file),vBuffer::{&prefixfil}name).
      end.   
      else if  vBuffer:name eq "{&prefixtt}Index"
      then do:
         vFieldValue =  trim( vBuffer::{&prefixfil}table, '"').
         find first _file no-lock where _file._file-name = vFieldValue no-error.
         if available _file
         then 
            vWhere      = substitute ("where _Index._file-recid eq &1 and _Index._Index-Name eq &2 ",recid(_file),vBuffer::{&prefixfil}name).
      end.
      else if  vBuffer:name eq "{&prefixtt}Sequence"
      then 
         vWhere      = substitute ("where _Sequence._Seq-Name eq &1 ",vBuffer::{&prefixfil}name).
      else
         return no.
         vBufferDB:find-last(vWhere, no-lock) no-error.
         vOk = no.
         if vBufferDB:available
            and vBuffer::{&prefixfil}mode ne "drop"          
         then do:
            vOk = yes.
            if vCheckField then         
            block-field:
            do vItm = 1 to vBuffer:num-fields:
               vField = vBuffer:buffer-field(vItm).
               vFieldName = "_" + substring(vField:name,vFieldPref).
               if vFieldName eq "_DESCRIPTION"
               then
                  vFieldName = "_DESC".
               else if vFieldName eq "_POSITION"
               then
                  vFieldName = "_field-rpos".
               else if vFieldName eq "_MAX-WIDTH"
               then
                  vFieldName = "_WIDTH".
               else if vFieldName eq "_COLUMN-LABEL"
               then
                  vFieldName = "_Col-label".
                  
               
               if     not can-do("_mode,_name,_table,_localindex",vFieldName)
                  and vField:buffer-value ne "" 
               then do vj = 1 to if vField:buffer-value eq ? then 1 else num-entries(vField:buffer-value,{&delim-par}):
                  define variable vValuedb as character no-undo.
                  vFieldValue = trim(trim(vField:buffer-value," "),'"').
                  vValuedb = vBufferDB:buffer-field(vFieldName):buffer-value.
                  vFlagEQ = if vFieldValue eq "{&logicalfield}" 
                        then 
                           logical (vValuedb) eq yes
                        else
                           vValuedb eq vFieldValue.
                   if vFlagEQ
                   then
                      vField:buffer-value = "".
                   else 
                      vOk = no.           
               end.    
            end.
             
         end.
         if vOk
         then
            vBuffer:buffer-delete ().
         else do:
            oOk = no.
            /*message "!!!!!!"
               view-as alert-box.*/
         end.    
         vQuery:get-next().
         
      end.
   end.
   ook = not verror.
   vQuery:query-close().

   delete object vQuery.
   output close.
   finally:
      return oOk.
   end finally.   
end method.
method private void ChangeTable(OldName as character, NewName as character ):
   for each {&prefixtt}FIELD where {&prefixtt}FIELD.{&prefixfil}table eq oldName:
      {&prefixtt}FIELD.{&prefixfil}table = newName.
   end.
   for each {&prefixtt}Index where {&prefixtt}Index.{&prefixfil}table eq oldName:
      {&prefixtt}Index.{&prefixfil}table = newName.
   end. 
end method.

end class.

