 
 /*------------------------------------------------------------------------
    File        : analisdf
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Fri Feb 15 01:12:23 MSK 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.adm.upd.*.

block-level on error undo, throw.

class ibs.th.adm.upd.analisdf final: 
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
    {cmp/str-glbl.i class}  
    define variable obsrvdbObj as class observupd no-undo.
    
    define property TargetDBShm as integer no-undo 
    get.
    private set.
    
    define property IsComp as logical no-undo
    get.
    set.
    
    define public variable mFileDf   as character no-undo.
    define public variable mUpdateTo as integer   no-undo.
    
   constructor public analisdf (  ):
      obsrvdbObj = new observupd ().
    
     /* CurrDBShm   = obsrvdbObj:CurrDBShm.  
    CurrDB0Shm  = obsrvdbObj:CurrDB0Shm. 
    DbNum       = obsrvdbObj:DbNum.  */    
    TargetDBShm = obsrvdbObj:TargetDBShm.
      
   end constructor.

   destructor public analisdf ( ):
      delete object obsrvdbObj.
   end destructor.

 define stream sReadfile.
/*  define variable mMode as character no-undo.*/
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
        if not obsrvdbObj:m-upd-list-df[vi    ] begins "proc:"
        then do:
           vFlagDf = yes.
           if readDF(obsrvdbObj:m-upd-list-df[vi])
           then
              return no.
        end.
        else do:
           mFileDf   = obsrvdbObj:m-upd-list-df[vi    ].
           mUpdateTo = vi.
           return yes. 
        end.
        if vi >= TargetDBShm 
           or (        obsrvdbObj:m-upd-list-df[vi    ] begins "proc:")
               or
               (    not obsrvdbObj:m-upd-list-df[vi    ] begins "proc:"
                and     obsrvdbObj:m-upd-list-df[vi + 1] begins "proc:"               
                
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
            vTableWhere = if vMode eq "rename" then entry(5,istr, " ") else entry(5 + vSdvig,istr, " ") no-error.
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
               then do:
                  ChangeTable(mBuffer::{&prefixfil}Name , entry(5,istr, " ")).
                  mBuffer::{&prefixfil}Name = entry(5,istr, " ").
               end.
               else
                  mBuffer::{&prefixfil}Name = entry(7,istr, " ").
                  return no.
            end.    
            else if      mBuffer::{&prefixfil}mode eq "rename" 
                      or (    vMode eq "rename"
                          and vmode eq "update")
            then do:
               vposih = mBuffer::{&prefixfil}localIndex + 1.
               mBuffer:buffer-release ().
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
            if vMode eq "rename" 
            then 
               mBuffer::{&prefixfil}NewName = if mbuffername eq "table"
                                              then entry(5,istr, " ") 
                                              else entry(7,istr, " ").
         end.
         if VPrimary 
         then
           mBuffer:buffer-field("{&prefixfil}PRIMARY"):BUFFER-VALUE () = "{&logicalfield}".
         if    mBufferName eq "field"
            or mBufferName eq "index"
         then 
            mBuffer::{&prefixfil}table = vTableWhere.
         if    mBufferName eq "field"
            and vMode ne "rename"
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
             then substitute ("&1 FIELD &2 OF &3 &4&5",
                              vBuffer::{&prefixfil}mode,
                              vBuffer::{&prefixfil}name,
                              vBuffer::{&prefixfil}table,
                              if vBuffer::{&prefixfil}mode eq "rename" then " TO " + vBuffer::{&prefixfil}NewName else "",
                              if vBuffer::{&prefixfil}Data-Type ne "" then "AS " + vBuffer::{&prefixfil}Data-Type else "")
             else if vBuffer:name eq "{&prefixtt}index" 
             then substitute ("&1 INDEX &2&3 ON &4",
                              vBuffer::{&prefixfil}mode,
                              vBuffer::{&prefixfil}name,
                              if vBuffer::{&prefixfil}mode eq "rename" then " TO " + vBuffer::{&prefixfil}table  else "",
                              if vBuffer::{&prefixfil}mode eq "rename" then vBuffer::{&prefixfil}NewName else vBuffer::{&prefixfil}table)
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
   /* message "!!!!!!"
               view-as alert-box.*/
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
   define variable oOkl     as logical no-undo init yes.
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
                  vFieldValue = replace(trim(vField:buffer-value," "),'"','').
                  vValuedb = replace(vBufferDB:buffer-field(vFieldName):buffer-value,'"','').
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
         else if     not vBufferDB:available
                 and vBuffer::{&prefixfil}mode eq "drop"
         then          
            vOk = yes.
           
         if vOk
         then
            vBuffer:buffer-delete ().
         else do:
            oOkl = no.
           /* message "!!!!!!"
               view-as alert-box.*/
         end.    
         vQuery:get-next().
         
      end.
   end.
   ookl = not verror and oOkl.
   vQuery:query-close().

   delete object vQuery.
   output close.
   finally:
      return oOkl.
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

method private void ChangeAreahist(iTableName as character ):
   
   for each {&prefixtt}Index where {&prefixtt}Index.{&prefixfil}table eq iTableName :
      {&prefixtt}Index.{&prefixfil}area = replace({&prefixtt}Index.{&prefixfil}area, '"Primary_index"' , '"History_Index"').
   end. 
end method.
method private void addindexHist(iTableName as character ):
   define buffer buf_{&prefixtt}Index for {&prefixtt}Index.
   
   for each {&prefixtt}Index where {&prefixtt}Index.{&prefixfil}localIndex ne 0  :
      create buf_{&prefixtt}Index.
      buffer-copy {&prefixtt}Index except {&prefixfil}PRIMARY {&prefixfil}UNIQUE {&prefixfil}localIndex  {&prefixfil}Name to buf_{&prefixtt}Index
      assign
      buf_{&prefixtt}Index.{&prefixfil}Name = '"' + trim({&prefixtt}Index.{&prefixfil}Name,'"') + '-2"'
      .
      assign 
         buf_{&prefixtt}Index.{&prefixfil}INDEX-FIELD = buf_{&prefixtt}Index.{&prefixfil}INDEX-FIELD 
                                                      + {&delim-par} + '"corr-date" ASCENDING'
                                                      + {&delim-par} + '"corr-time" ASCENDING'
                                                      + {&delim-par} + '"corr-user-db-num" ASCENDING'
                                                     
             {&prefixtt}Index.{&prefixfil}INDEX-FIELD =     {&prefixtt}Index.{&prefixfil}INDEX-FIELD 
                                                      + {&delim-par} + '"corr-user-db-num" ASCENDING'
                                                      + {&delim-par} + '"chip-num" ASCENDING'
      .
      


      
   end.
   create {&prefixtt}Index.
   assign
      {&prefixtt}Index.{&prefixfil}mode        = "ADD"
      {&prefixtt}Index.{&prefixfil}Table       = iTableName
      {&prefixtt}Index.{&prefixfil}Name        = '"corr-user-db-num"'
      {&prefixtt}Index.{&prefixfil}AREA        = '"History_Index"'
      {&prefixtt}Index.{&prefixfil}INDEX-FIELD = '"corr-user-db-num" ASCENDING'
   .
   
   create {&prefixtt}Index.
   assign
      {&prefixtt}Index.{&prefixfil}mode        = "ADD"
      {&prefixtt}Index.{&prefixfil}Table       = iTableName
      {&prefixtt}Index.{&prefixfil}Name        = '"corr-user-name"'
      {&prefixtt}Index.{&prefixfil}AREA        = '"History_Index"'
      {&prefixtt}Index.{&prefixfil}INDEX-FIELD = '"corr-user-name" ASCENDING' + {&delim-par} + '"corr-user-db-num" ASCENDING'
   .
end method.
method private void addFieldHist(iTableName as character ):
   define variable vORDER    as integer no-undo.
   define variable vPOSITION as integer no-undo. 
   for each {&prefixtt}FIELD where {&prefixtt}FIELD.{&prefixfil}table eq iTableName:
      assign
         vORDER    = max(vORDER   ,int({&prefixtt}FIELD.{&prefixfil}ORDER    ))
         vPOSITION = max(vPOSITION,int({&prefixtt}FIELD.{&prefixfil}POSITION ))
      .
   end.
   /* ADD FIELD "chip-num" OF "c-PromoCriterion" AS integer*/
   create {&prefixtt}FIELD.
   assign
      vORDER                                  = vORDER + 10
      vPOSITION                               = vPOSITION + 1
      {&prefixtt}FIELD.{&prefixfil}localIndex = 1
      {&prefixtt}FIELD.{&prefixfil}mode       = "ADD"
      {&prefixtt}FIELD.{&prefixfil}Table      = iTableName
      {&prefixtt}FIELD.{&prefixfil}Name       ='"chip-num"'
      {&prefixtt}FIELD.{&prefixfil}Data-Type  = "integer"
      {&prefixtt}FIELD.{&prefixfil}FORMAT     = '"->,>>>,>>9"'
      {&prefixtt}FIELD.{&prefixfil}INITIAL    = '"0"'
      {&prefixtt}FIELD.{&prefixfil}POSITION   = string(vPOSITION)
      {&prefixtt}FIELD.{&prefixfil}MAX-WIDTH  = "4"
      {&prefixtt}FIELD.{&prefixfil}ORDER      = string (vORDER)
      {&prefixtt}FIELD.{&prefixfil}MANDATORY  = "{&logicalfield}"
   .

   /*ADD FIELD "corr-date" OF "c-PromoCriterion" AS date */
   create {&prefixtt}FIELD.
   assign
      vORDER                                  = vORDER + 10
      vPOSITION                               = vPOSITION + 1
      {&prefixtt}FIELD.{&prefixfil}localIndex = 1
      {&prefixtt}FIELD.{&prefixfil}mode       = "ADD"
      {&prefixtt}FIELD.{&prefixfil}Table      = iTableName
      {&prefixtt}FIELD.{&prefixfil}Name       = '"corr-date"'
      {&prefixtt}FIELD.{&prefixfil}Data-Type  = "date"
      {&prefixtt}FIELD.{&prefixfil}POSITION   = string(vPOSITION)
      {&prefixtt}FIELD.{&prefixfil}ORDER      = string (vORDER)
      {&prefixtt}FIELD.{&prefixfil}FORMAT     = '"99/99/99"'
      {&prefixtt}FIELD.{&prefixfil}INITIAL    = '?'
      {&prefixtt}FIELD.{&prefixfil}MAX-WIDTH  = '4'
   .

   /* ADD FIELD "corr-time" OF "c-PromoCriterion" AS integer */
   create {&prefixtt}FIELD.
   assign
      vORDER                                  = vORDER + 10
      vPOSITION                               = vPOSITION + 1
      {&prefixtt}FIELD.{&prefixfil}localIndex = 1
      {&prefixtt}FIELD.{&prefixfil}mode       = "ADD"
      {&prefixtt}FIELD.{&prefixfil}Table      = iTableName
      {&prefixtt}FIELD.{&prefixfil}Name       = '"corr-time"'
      {&prefixtt}FIELD.{&prefixfil}Data-Type  = "integer"
      {&prefixtt}FIELD.{&prefixfil}POSITION   = string(vPOSITION)
      {&prefixtt}FIELD.{&prefixfil}ORDER      = string (vORDER)
      {&prefixtt}FIELD.{&prefixfil}FORMAT     = '"->,>>>,>>9"'
      {&prefixtt}FIELD.{&prefixfil}INITIAL    = '"0"'
      {&prefixtt}FIELD.{&prefixfil}MAX-WIDTH  = '4'
   .
  
   /*ADD FIELD "corr-user-db-num" OF "c-PromoCriterion" AS integer */
   create {&prefixtt}FIELD.
   assign
      vORDER                                  = vORDER + 10
      vPOSITION                               = vPOSITION + 1
      {&prefixtt}FIELD.{&prefixfil}localIndex = 1
      {&prefixtt}FIELD.{&prefixfil}mode       = "ADD"
      {&prefixtt}FIELD.{&prefixfil}Table      = iTableName
      {&prefixtt}FIELD.{&prefixfil}Name       = '"corr-user-db-num"'
      {&prefixtt}FIELD.{&prefixfil}Data-Type  = "integer"
      {&prefixtt}FIELD.{&prefixfil}POSITION   = string(vPOSITION)
      {&prefixtt}FIELD.{&prefixfil}ORDER      = string (vORDER)
      {&prefixtt}FIELD.{&prefixfil}FORMAT     = '"->,>>>,>>9"'
      {&prefixtt}FIELD.{&prefixfil}INITIAL    = '"0"'
      {&prefixtt}FIELD.{&prefixfil}MAX-WIDTH  = '4'
      {&prefixtt}FIELD.{&prefixfil}MANDATORY  = "{&logicalfield}"
   .

    /*ADD FIELD "corr-user-name" OF "c-PromoCriterion" AS character */
   create {&prefixtt}FIELD.
   assign
      vORDER                                  = vORDER + 10
      vPOSITION                               = vPOSITION + 1
      {&prefixtt}FIELD.{&prefixfil}localIndex = 1
      {&prefixtt}FIELD.{&prefixfil}mode       = "ADD"
      {&prefixtt}FIELD.{&prefixfil}Table      = iTableName
      {&prefixtt}FIELD.{&prefixfil}Name       = '"corr-user-name"'
      {&prefixtt}FIELD.{&prefixfil}Data-Type  = "character"
      {&prefixtt}FIELD.{&prefixfil}POSITION   = string(vPOSITION)
      {&prefixtt}FIELD.{&prefixfil}ORDER      = string (vORDER)
      {&prefixtt}FIELD.{&prefixfil}FORMAT     = '"x(8)"'
      {&prefixtt}FIELD.{&prefixfil}INITIAL    = '""'
      {&prefixtt}FIELD.{&prefixfil}MAX-WIDTH  = '16'
  .
  
  /*ADD FIELD "action" OF "c-promo-schedule-week" AS integer*/ 
  create {&prefixtt}FIELD.
   assign
      vORDER                                  = vORDER + 10
      vPOSITION                               = vPOSITION + 1
      {&prefixtt}FIELD.{&prefixfil}localIndex = 1
      {&prefixtt}FIELD.{&prefixfil}mode       = "ADD"
      {&prefixtt}FIELD.{&prefixfil}Table      = iTableName
      {&prefixtt}FIELD.{&prefixfil}Name       = '"action"'
      {&prefixtt}FIELD.{&prefixfil}Data-Type  = "integer"
      {&prefixtt}FIELD.{&prefixfil}POSITION   = string(vPOSITION)
      {&prefixtt}FIELD.{&prefixfil}ORDER      = string (vORDER)
      {&prefixtt}FIELD.{&prefixfil}DESCRIPTION =  '"Описание действия"'
      {&prefixtt}FIELD.{&prefixfil}FORMAT      = '"99"'
      {&prefixtt}FIELD.{&prefixfil}INITIAL     = '"0"'
      {&prefixtt}FIELD.{&prefixfil}LABEL       = '"Описание действия"'
      {&prefixtt}FIELD.{&prefixfil}MAX-WIDTH   = '4'
   .

/*ADD FIELD "is-del" OF "c-promo-schedule-week" AS logical*/
   create {&prefixtt}FIELD.
   assign
      vORDER                                  = vORDER + 10
      vPOSITION                               = vPOSITION + 1
      {&prefixtt}FIELD.{&prefixfil}localIndex = 1
      {&prefixtt}FIELD.{&prefixfil}mode       = "ADD"
      {&prefixtt}FIELD.{&prefixfil}Table      = iTableName
      {&prefixtt}FIELD.{&prefixfil}Name       = '"is-del"'
      {&prefixtt}FIELD.{&prefixfil}Data-Type  = "logical"
      {&prefixtt}FIELD.{&prefixfil}POSITION   = string(vPOSITION)
      {&prefixtt}FIELD.{&prefixfil}ORDER      = string (vORDER) 
      {&prefixtt}FIELD.{&prefixfil}FORMAT     = '"yes/no"'
      {&prefixtt}FIELD.{&prefixfil}INITIAL    = '"no"'
      {&prefixtt}FIELD.{&prefixfil}LABEL      = '""'
      {&prefixtt}FIELD.{&prefixfil}MAX-WIDTH  = '16'
   .
      
end method.

method public void crtablehist(iTableName as character ):
   empty temp-table {&prefixtt}TABLE.
   empty temp-table {&prefixtt}FIELD.
   empty temp-table {&prefixtt}Index.
   empty temp-table {&prefixtt}SEQUENCE.
   run prodict/dump_df.p   (iTableName,
                            iTableName + ".df",
                            "").
   readDF(iTableName + ".df").
   define variable vnewName   as character no-undo.
   define variable vnewNameno as character no-undo.
   for each {&prefixtt}TABLE where not ( {&prefixtt}TABLE.{&prefixfil}Name begins "c-") :
      vnewNameno = "c-" + trim({&prefixtt}TABLE.{&prefixfil}Name,'"').
      vnewName = '"' + vnewNameno + '"'.
      ChangeTable({&prefixtt}TABLE.{&prefixfil}Name,vnewName).
      {&prefixtt}TABLE.{&prefixfil}Area = replace({&prefixtt}TABLE.{&prefixfil}Area, '"Primary_data"' , '"History"').
      ChangeAreahist (vnewName).
      addFieldHist (vnewName).
      addIndexHist (vnewName).
      {&prefixtt}TABLE.{&prefixfil}Name     = vnewName.
      {&prefixtt}TABLE.{&prefixfil}DUMP-NAME = '"' + lc(vnewNameno) + '"'.
     /* create {&prefixtt}SEQUENCE.
      assign
         {&prefixtt}SEQUENCE.{&prefixfil}mode           = "add"
         {&prefixtt}SEQUENCE.{&prefixfil}Name           = "s-" + vnewNameno + "-chip-num"
         {&prefixtt}SEQUENCE.{&prefixfil}INITIAL        = '0'
         {&prefixtt}SEQUENCE.{&prefixfil}INCREMENT      = '1'
         {&prefixtt}SEQUENCE.{&prefixfil}CYCLE-ON-LIMIT = 'no'
      . */
      
   end.
   dumpTable ("c-" + iTableName + ".df"). 
   message "c-" + iTableName + ".df"
   view-as alert-box. 
 end method.
end class.