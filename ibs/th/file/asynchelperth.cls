 
 /*------------------------------------------------------------------------
    File        : AsyncHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Fri Aug 24 08:22:40 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.



class ibs.th.file.AsyncHelperth: 
   { cmp/str-glbl.i class}
   {utl/ttprocdef.i}
   {utl/ttfileList.i  ttfile  }
 /*  {utl/setpwd.i class}*/
/*define temp-table ttfileTarget no-undo like ttfile.*/
define temp-table ttfileList no-undo like ttfile.

      

   define stream sReadDir.
   define stream sReadfile.
   
define variable v-path-tls-dir-delim as character no-undo init "\":u.

define public variable mShowFrame   as logical    no-undo.
define public variable SaveFile     as logical    no-undo.
define public variable paramSession as character  no-undo.
define public variable WaitFile     as character  no-undo.
define public variable mProcPublish as handle     no-undo.
define public property MyParamStart as character  no-undo
get.

    set (arg as char):
      if arg eq ""
      then
         MyParamStart = " -ininame "  + GetStartupParam("-ininame").
      
      else if arg ne ?
      then
         MyParamStart = arg.
    end.

define public property ConPar as character  no-undo init ?
get:
   define variable vconpar as character no-undo.
   if ConPar ne ?
   then 
      return ConPar.
   else do:
      get-key-value section "REP-SETS" key "ConPar" value vConPar.
      return vConPar.
   end.
end.
    set .
   
define public variable MyBachMode as logical no-undo init yes.
/*method private void GetOSErrorText (input iSourseDir as char,input iTargetDir as char,input cleadir as logical ):


end.*/
define public property m-prowin32FileName as character no-undo
get.
    set (arg as char):
      if arg eq ""
      then
         arg = "bin/prowin32.exe".
      arg = search(arg).
      if arg ne ?
      then
         m-prowin32FileName = arg.
    end.
    define public property MyWorkDir as character no-undo
    get():
        return (if MyWorkDir  ne "" then( MyWorkDir + v-path-tls-dir-delim ) else "").
    end.    
    set (arg as char):
      if arg ne ?
      then
         if  arg eq "pid_"
         then do:
            define variable vpid as int64 no-undo.
            run utl/getpid.p(output vpid).
            if vpid ne 0 and vpid ne ?
            then do:
               
               MyWorkDir = substitute("pid_&1_&2" , string(vpid) , string(random(1,9999999))).
               os-create-dir VALUE(MyWorkDir).
            end. 
         end.
         else
            MyWorkDir = arg.
      
    end.
    
    define public property myTimeOut as int no-undo
    get.
    set.
    define temp-table tt-User no-undo
       field usr as character 
       field pwd as character
    index usr usr.
    
    define public property userDB as logical no-undo 
    get.
    set.
    
    define public property user-passwd as character initial ? no-undo 
    get:
       if user-passwd eq ?
       then do: 
          if not available tt-User
          then 
             create tt-User.
          run utl/syspwd.p(input buffer tt-User:handle).
          userDB = yes.
          return  substitute("-U &1 -P &2",tt-User.usr,tt-User.pwd).  
       end.
       else 
          return user-passwd.
    end.
    set (arg as char):
       if arg eq "current"
       then do:
          if not available tt-User
          then 
             create tt-User.
          run utl/getuserpwdauto.p(input buffer tt-User:handle) no-error.
          if not error-status:error
          then do:
             user-passwd =  substitute("U:&1,P:&2",tt-User.usr,tt-User.pwd).
          end.
          else do:
             run utl/getuserpwd.p( input buffer tt-User:handle) no-error.
             if not error-status:error
             then do:
                user-passwd =  substitute("U:&1,P:&2",tt-User.usr,tt-User.pwd).
             end.
             else
                user-passwd = substitute("U:&1,P:&2",GetStartupParam("-U"),GetStartupParam("-P")).
          end.
          
       end.
       else do:
          user-passwd = arg.
          if trim(arg) begins "-U"
          then
             userDB = yes.
       end.
    end.
    define public property TaskName as character no-undo
    get.
    set.
    
   constructor AsyncHelperth ( ):
   
      super ().
      m-prowin32FileName =  search ("bin/prowin32.exe").
/*      MyWorkDir = "pid_".*/
    /*  creatTTForDir("c:\11").
      updateFolder("c:\22", input table ttfile).
      message "ok"
         view-as alert-box.*/
         
   end constructor.
   
   destructor public AsyncHelperth ( ):
      delworkdir().
      
   end destructor.
   method public character  SaveArh ():
      return SaveArh("").
   end.
   method public character  SaveArh (itext as character ):
      define variable mDir as character no-undo.
      define variable marh as character no-undo.
      
      mdir = trim(MyWorkDir,v-path-tls-dir-delim).
      marh = mdir + itext + ".zip".
      run utl\arh7z.p(marh,mdir).
      marh =objExists(marh,"F").
      return marh .
   end.
   
/*   method public void  CopyDirstruct (input iDirS as char,input iDirT as char):
      creatTTForDir(iDirS).
      updateFolder(iDirT).
   end.
   method public void  getListfile (input iDir as char,input ilist as character,output table ttfilelist):
      creatTTForDir(idir,ilist).
         
   end.
   method public void  Copyfile (input iDirS as char,input iDirT as char,input ilistCopy as character):
      creatTTForDir(idirs,ilistCopy).
      for each ttfilelist :
         os-copy value(iDirs + v-path-tls-dir-delim + ttfilelist.fulllocalpach )
                 value(iDirt + v-path-tls-dir-delim + ttfilelist.fulllocalpach ).
         if not objExists (iDirt + v-path-tls-dir-delim + ttfilelist.fulllocalpach)
         then
            os-copy value(iDirs + v-path-tls-dir-delim + ttfilelist.fulllocalpach )
                    value(iDirt + v-path-tls-dir-delim + ttfilelist.fulllocalpach ).        
      end.   
   end.
   method private void  creatTTForDir (input iDir as char):
      creatTTForDir(idir,"").
   end.
   method public void  creatTTForDir (input iDir as char,output table ttfile):
      creatTTForDir(idir,"").
   end.    
   method private void  creatTTForDir (input iDir as char,input ilistCopy as character):
      for each ttfile:
         delete ttfile.
      end.   
      for each ttfileTarget:
         delete ttfileTarget.
      end.   
   
      creatTTForDir(idir,"",ilistCopy).
      
   end.   
method private void  creatTTForDir (input iDir as char,input iLoaclPath as character,input ilistCopy as character  ):
   define var vPureName  as char    no-undo.
   define var vFullPath  as char    no-undo.
   define var vFileType  as char    no-undo.
   
   
   iDir = trim(idir,v-path-tls-dir-delim).
   
   input STREAM sReadDir FROM os-dir(iDir + v-path-tls-dir-delim + iLoaclPath ).
   repeat:
      import stream sReadDir vPureName vFullPath vFileType.
      if vPureName begins  "."   then next.
      if vFileType =  "d" then do:
         
         create ttfile.
         assign
            ttfile.fnAME       = vPureName
            ttfile.fullpach    = iDir
            ttfile.localPach   = iLoaclPath
            ttfile.fulllocalpach = trim(ttfile.localPach + v-path-tls-dir-delim + ttfile.fnAME,v-path-tls-dir-delim)
            ttfile.fLevel      = num-entries(ttfile.fulllocalpach,v-path-tls-dir-delim) 
            .
      end.
      else if     ilistCopy ne "" 
              and vFileType =  "F"
              /*and num-entries(vPureName,".")  eq 2*/
              and can-do (ilistCopy,entry(num-entries(vPureName,"."),vPureName,"."))
      then do:
         create ttfilelist.
         assign
         ttfilelist.fnAME         = vPureName
         ttfilelist.fullpach      = iDir
         ttfilelist.localPach     = iLoaclPath
         ttfilelist.fulllocalpach = trim(ttfilelist.localPach + v-path-tls-dir-delim + ttfilelist.fnAME,v-path-tls-dir-delim)
         ttfilelist.fLevel        = num-entries(ttfilelist.fulllocalpach,v-path-tls-dir-delim) 
            .
      end.   
   end.
    
   input close.
   for each ttfile where not ttfile.NotNew
      and ttfile.fLevel eq (num-entries(iLoaclPath,v-path-tls-dir-delim) + 1):
      ttfile.NotNew = yes.
      creatTTForDir(iDir,ttfile.fulllocalpach,ilistCopy).
   end.   
end method.
   method public void  updateFolder (input iDir as char):
      updateFolder(idir,"",input table ttfile).
   end. 
   method private void  updateFolder (input iDir as char,input Table ttfile):
      updateFolder(idir,"",input table ttfile by-reference).
   end.   
   method private void  updateFolder (input iDir as char,input iLoaclPath as character ,input Table ttfile):
      define var vPureName as char no-undo.
      define var vFullPath as char no-undo.
      define var vFileType as char no-undo.
      define variable vLevel as integer no-undo.
   
      iDir = trim(idir,v-path-tls-dir-delim).
   
      input STREAM sReadDir FROM os-dir(iDir + v-path-tls-dir-delim + iLoaclPath ).
      repeat:
         import stream sReadDir vPureName vFullPath vFileType.
         if vPureName begins "." then next.
         if vFileType =  "d" then 
         do:
            find first ttfile where ttfile.localPach = iLoaclPath 
                                and ttfile.fnAME     = vPureName
             no-error.
            if available ttfile
            then do:
               
               create ttfileTarget.
               assign
                  ttfileTarget.fnAME         = vPureName
                  ttfileTarget.fullpach      = iDir
                  ttfileTarget.localPach     = iLoaclPath
                  ttfileTarget.fulllocalpach = trim(ttfile.localPach + v-path-tls-dir-delim + ttfile.fnAME,v-path-tls-dir-delim)
                  ttfileTarget.fLevel        = num-entries(ttfile.fulllocalpach,v-path-tls-dir-delim) 
               .
               delete ttfile.
             end.
             else
                put unformatted "Не удален каталог " vFullPath skip.
                /* os-delete value(vFullPath) RECURSIVE.*/
         end.
      end.
      
      for each   ttfile where ttfile.localpach eq iLoaclPath
      and ttfile.fLevel eq (num-entries(iLoaclPath,v-path-tls-dir-delim) + 1):
         os-create-dir VALUE(iDir + v-path-tls-dir-delim + ttfile.fulllocalpach).
         put unformatted 
            "Создан каталог " iDir + v-path-tls-dir-delim + ttfile.fulllocalpach skip.
         
         create ttfileTarget.
         assign
            ttfileTarget.fnAME         = ttfile.fnAME
            ttfileTarget.fullpach      = iDir
            ttfileTarget.localPach     = iLoaclPath
            ttfileTarget.fulllocalpach = trim(ttfile.localPach + v-path-tls-dir-delim + ttfile.fnAME,v-path-tls-dir-delim)
            ttfileTarget.fLevel        = num-entries(ttfile.fulllocalpach,v-path-tls-dir-delim) 
            .
         delete ttfile.
      end.
      
      input close.
      for each ttfileTarget where ttfileTarget.fLevel eq (num-entries(iLoaclPath,v-path-tls-dir-delim) + 1)
                              and not ttfileTarget.NotNew:
         ttfileTarget.NotNew = yes.
         updateFolder(iDir,ttfileTarget.fulllocalpach,input table ttfile by-reference).
        /* delete ttfileTarget.*/
      end.
       
         
   end method.
   */
   define variable mIniFile as character no-undo.
   define variable mFirstrun as logical no-undo init yes.
         
   method public int64 AsyncProc (
      iProc    as character,
      iParam   as character,
      iCount as int64):
      if mFirstrun
      then do: /*создадим рабочуюю директорию */ 
         MyWorkDir = "pid_".
         mFirstrun = no.
      end.
      define variable vi as integer no-undo.
      define variable vj as integer no-undo.
      define variable vTask as character no-undo.
      define variable vMax  as integer no-undo.
      define variable vList as character no-undo.  
      define variable vprocname as character no-undo.
      define variable v-user-passwd       as character no-undo . 
      mIniFile = " -ininame "  + GetStartupParam("-ininame")  .
      
      iProc = right-trim(iProc,".r").
      iProc = right-trim(iProc,".p").
      vprocname = replace (iProc ,"/",v-path-tls-dir-delim).
      vprocname =   entry(num-entries(vprocname,v-path-tls-dir-delim),vprocname,v-path-tls-dir-delim).
      
      TaskName = vprocname.
      v-user-passwd = user-passwd.
      ConPar = substitute(ConPar, v-user-passwd).
      if not FileExists  (MyWorkDir + vprocname + ".txt" )
      then do:
         
         output to value(MyWorkDir + vprocname + ".txt").
         put unformatted "InitProc " now.
         output close.
         
         output to value(MyWorkDir + "prof.pf").
         put unformatted substitute('-DESCRIPTION "&2"&1 -LISTINGS .&1 -FILENAME prof.out&1 ',{&new-line},TaskName) .
         output close.
         
         
         do vi = 1 to iCount:
           vTask = vprocname + string(vi).
           os-delete value (MyWorkDir + vTask) recursive.
           if not  FolderExists  ( MyWorkDir + vTask) 
           then
             os-create-dir VALUE(MyWorkDir + vTask ).
           os-copy value(MyWorkDir + "assemblies.xml" )
                 value(MyWorkDir + vTask + v-path-tls-dir-delim + "assemblies.xml").  
           output to value(MyWorkDir + vTask + v-path-tls-dir-delim + "param.txt").
             SavePARAM("numSession",string(vi)).
             SavePARAM("countSession",string(iCount)).
             SavePARAM("UserDB",string(UserDB)).
             do vj = 1 to num-entries(iParam, {&delim-par} ):
                SavePARAM("ParamProc_" + string(vj),entry(vj,iParam, {&delim-par} )).
             end.
           output close.
           output to value(MyWorkDir + vTask + v-path-tls-dir-delim +  "error.log").
                
           put unformatted "error Ошибка запуска сессии." skip.
           output close.
           output to value(MyWorkDir + vTask + v-path-tls-dir-delim + "stop.txt").
            output close.
            AsyncRun(vTask, iProc).
            create ttrun.
            assign
               ttrun.proc = vprocname
               ttrun.num  = vi
               ttrun.runtime = now
            .
            
         end.
         
          
      end.
      else
         message "Процедура " iProc "уже запущена в паралельном режиме."
         view-as alert-box.      
         
   end.
   define public variable WAIT-FOR-COMPLETE as logical no-undo.
   define public variable vCountend as integer   no-undo.
  
   method public logical  WaitForfile ( input ifile as character):
      define variable mfilesize    as integer   no-undo.
      if ifile eq ? 
      then return yes.
      ifile = objExists(ifile,"F").
      if ifile ne ? 
      then do:
         file-information:file-name = ifile.
         mfilesize = file-info:file-size.
         pause 3 no-message.
         file-information:file-name = ifile.
         return mfilesize eq file-info:file-size.
      end.
      else
         return no.
   end.
      
   method public integer  WaitForOne ( input iSched as character):
      if iSched eq ?
      then 
         iSched = taskname.
     define variable vFile as character no-undo.
     define variable vCount as character  no-undo. 
     define variable oCount as integer no-undo. 
     define variable vtime as int  no-undo.
     block-ttrun:
     for each ttrun where ttrun.proc eq iSched no-lock:
        vFile = MyWorkDir + ttrun.proc + string(ttrun.num) + "/procinfo.txt".
        vtime =  (now - ttrun.runtime) / 1000.
       /* message vtime view-as alert-box. */
         /* ждем 2 минуты если процес не создал файл  считаем что произошла ошибка запуска */ 
        /*vvv = vvv and not FileExists(vFile).*/
        if FileExists(vFile)
        then do:
           input STREAM sReadfile FROM  VALUE(vFile). 
           repeat:
              import stream sReadfile unformatted vCount.
              if vCount ne ""
              then do:
                 assign
                    ttrun.fpid = int(entry(1,vCount, "~001"))
                    ttrun.fmaxitem  =  int(entry(2,vCount, "~001")) 
                    ttRun.num       =  int(entry(3,vCount, "~001"))
                    ttrun.fmax      = int(entry(4,vCount, "~001"))
                 no-error.
              end.
           end.
           input close.
        end.
        else if    vtime > 120
        then do:
           vFile = MyWorkDir + ttrun.proc + string(ttrun.num) + "/endproc.txt".
           output to value(vFile).
           output close.
        end.
            
        vFile = MyWorkDir + ttrun.proc + string(ttrun.num) + "/procrec.txt".
        if FileExists(vFile)
        then do:
           input STREAM sReadfile FROM  VALUE(vFile). 
           repeat:
              import stream sReadfile unformatted vCount.
              if vCount ne ""
              then do:
                 oCount = oCount +  int(vCount) no-error.
              end.
           end.
           input close.
        end.  
        vFile = MyWorkDir + ttrun.proc + string(ttrun.num) + "/endproc.txt".
        if FileExists(vFile)
        then do:
           define variable vFlfileWait as logical no-undo.
           define variable vi as integer no-undo.
           define variable vfileWait as character no-undo.
           
           do vi = 1 to num-entries(WaitFile):
              vfileWait = MyWorkDir + ttrun.proc + string(ttrun.num) + "/" + entry(vi,waitFile).
              vFlfileWait = WaitForfile(vfileWait).
              if not vFlfileWait
              then 
                 next block-ttrun.
           end.
           vCountEnd = vCountend +   int(vCount) no-error.
           copylog(ttrun.proc ,ttrun.num).
          /* os-delete value(vFile).*/
          if not SaveFile
          then do:
             os-delete value (MyWorkDir + ttrun.proc + string(ttrun.num)) recursive.
             os-delete value (MyWorkDir + ttrun.proc + string(ttrun.num) + ".bat").
          end.
          delete ttrun.
        end. 
        else do:
           vFile = MyWorkDir + ttrun.proc + string(ttrun.num) + "/procstatus.txt".
           if FileExists(vFile)
             then do:
               define variable vtxt as character no-undo.
               input STREAM sReadfile FROM  VALUE(vFile). 
               repeat:
                  import stream sReadfile unformatted vtxt.
                  
                  ttrun.fstatus =  vtxt   .
               end.
               input close.
            end.
        end.       
     end.
     WAIT-FOR-COMPLETE = yes.
     for each ttrun where ttrun.proc eq iSched no-lock:
        WAIT-FOR-COMPLETE = no.
        leave.
     end.
     if WAIT-FOR-COMPLETE
     then do:
        os-delete  value( MyWorkDir + iSched + "/stop.txt") .
        os-delete  value( MyWorkDir + iSched + ".txt") .
     end.
     return oCount.     
   end.  
   
   method public character  getErrLog (iSched as character):
      if iSched eq ?
      then 
         iSched = taskname.
       return MyWorkDir + iSched + "error.log".
   end.
   
   method public character  getProcDir (iSched as character):
      if iSched eq ?
      then 
         iSched = taskname.
       return MyWorkDir + iSched .
   end.
    
   method public logical copylog ( input iSched as character,input iItem as integer ):
      if iSched eq ?
      then 
         iSched = taskname.
      define variable vStr as character no-undo.
      output to value (getErrLog(iSched)) append.
      
      if FileExists(MyWorkDir + iSched + string (iItem) + "/error.log")
         then 
      do:
         input STREAM sReadfile FROM  VALUE(MyWorkDir + iSched + string (iItem) + "/error.log").
         repeat:
            import stream sReadfile unformatted vStr.
            put unformatted vStr skip.
         end.
      end.
      output close.
   end. 
   define public variable mStop as logical no-undo. 
   
    
   method public logical WaitFor ( input iSched as character, input ipInterval as int64):
      if iSched eq ?
      then 
         iSched = taskname.
       define variable vNowTask as character  no-undo.
       define variable vCountOld as integer init -1 no-undo.
       define variable vCount as integer no-undo.
       define variable vOK as logical no-undo initial true.
       
      output to value (getErrLog(iSched) ).
      define variable vStart  as datetime-tz no-undo.
      vStart = now.
      output close.
       vCountend = 0. 
       vNowTask          = iSched.
       WAIT-FOR-COMPLETE = false.      /* на всякий случай */
       mstop = no.
      output to value(MyWorkDir + "Stop.txt").
      output close.
       do while not WAIT-FOR-COMPLETE:
          /*if not WaitFor (vNowTask, ipInterval, true) then return false.*/
          
          WAIT-FOR-COMPLETE = true.
          vCount = vCountEnd + WaitForOne(iSched) .
          if (not WAIT-FOR-COMPLETE 
           and not FileExists(MyWorkDir + "Stop.txt")
           or (    myTimeOut    ne 0
               and myTimeOut    ne ?
               and vCountOld    = vCount
               and dec(now - vStart) / 1000 > myTimeOut
              )) or mstop
          then do:
             if WaitForStop (iSched)
             then do:
                vOK = false.
                WAIT-FOR-COMPLETE = true. /* процес завис */
             end.
          end.   
          else
             vCountOld = vCount.
          if not WAIT-FOR-COMPLETE
          then
             AsyncRunpause(ipInterval).
       end. 
       return vOK.
   end method.
   method public logical WaitForStop ( input iSched as character):
      if iSched eq ?
      then 
         iSched = taskname.
      define variable vi as integer no-undo.
      define variable vfileWait as character no-undo.
      define variable vFlfileWait as logical no-undo.
     
      for each ttrun where ttrun.proc eq iSched no-lock:
         os-delete value (MyWorkDir + ttrun.proc + string(ttrun.num) + "/stop.txt") recursive. /* Пытаемся остановить процес*/ 
         do vi = 1 to num-entries(WaitFile):
              vfileWait = MyWorkDir + ttrun.proc + string(ttrun.num) + "/" + entry(vi,waitFile).
              vFlfileWait = WaitForfile(vfileWait).
              if not vFlfileWait
              then 
                 return no.
           end.
      end.
      
      /*message "Процес " iSched "подвис. Процесы будут прерваны."
      view-as alert-box.*/
      for each ttrun where ttrun.proc eq iSched no-lock:
         if not SaveFile
         then
            os-delete value (MyWorkDir + ttrun.proc + string(ttrun.num)) recursive. /* удаляем директории процесов */ 
         os-delete   value(MyWorkDir + ttrun.proc + string(ttrun.num) + ".bat"). 
      end.
      os-delete value (MyWorkDir + iSched + ".txt") recursive.
      /* ждем чтобы процесы успели остановиться*/
      pause 3 no-message.
      return yes.
end.

define public event MyPause   /*10 прогрес не поддерживает публикацию событий */
    signature void ( input pcInterval as int64 ). 
   method public void AsyncRunpause (input iInterval as int64):
     define variable vStart  as datetime-tz no-undo.
     define variable vend    as datetime-tz no-undo.
     define variable vint as int64 no-undo.
     
     vStart = now.
     vend   = vStart.
     if valid-handle(mProcPublish)
     then
        publish "MyPause" from mProcPublish (iInterval ).
     MyPause:PUBLISH (iInterval).
     vend   =  now.
     vint = vend - vStart.
     vint = iInterval - vint / 1000.
     if not mStop
        and vint > 0
     then
        pause vint no-message. 
         
    /* do while vint / 1000   < iInterval:
        
       vend   =  now.
       vint = vend - vStart.
       
     end. */
     
   end.
   method private int64 AsyncRun (
      iSchedId as character,
      iProc    as character
     ):
      define variable v-cmd-comm  as character no-undo.
      define variable isRcode  as logical no-undo.
      define variable mProcFile as character no-undo.
      define variable mAsuncProc as character no-undo.
      mProcFile = search (iProc + ".r").
      if mProcFile <> ?
      then 
         isRcode = true.
      else 
         mProcFile = search (iProc + ".p").
      
      if isRcode
      then
         mAsuncProc = search("utl\proc-async.r").
      else
         mAsuncProc = search("utl\proc-async.p").
      if MyParamStart ne ""
      then 
         mIniFile = MyParamStart.
      define variable vSesPar as character no-undo.
      define variable vUserPas as character no-undo.
      vUserPas = user-passwd. /* получем пользователя так как в этт момент может переопределиться парамтр подключения */
      if    UserDB 
         or vUserPas eq ""
         or vUserPas eq ""
      then
         vSesPar =  substitute("-param R:&1 &2 ",                mProcFile, paramSession).
      else
         vSesPar =  substitute("-param &1,R:&2 &3", user-passwd, mProcFile, paramSession).
      if UserDB
      then
         v-cmd-comm = substitute ("&1 &2  &3  -p &4 &5 &6", m-prowin32FileName, if MyBachMode then "-b" else "", mIniFile, mAsuncProc,vSesPar, conpar).
      else 
         v-cmd-comm = substitute ("&1 &2  &3  -p &4 &5", m-prowin32FileName, if MyBachMode then "-b" else "", mIniFile, mAsuncProc,vsespar).
      define variable vruncomand as character no-undo.
      vruncomand =  iSchedId + " & " + v-cmd-comm + " & rename stop.txt endproc.txt  & exit".
      if ( not isRcode or session:debug-alert ) 
/*       and not UserDB*/
      then do:
         output to value(MyWorkDir + iSchedId + ".bat").                                                                                                                          
         put unformatted "cd " replace (vruncomand,"&","~n":U) skip.
         output close.
      end.
      vruncomand =  "cd " + MyWorkDir + vruncomand.
      os-command no-wait value (vruncomand  ).
   end.
   
   method public void delworkdir():
      if MyWorkDir ne ""
      then
      os-delete   value(trim(MyWorkDir,v-path-tls-dir-delim )) RECURSIVE.
     
   end method.    
   
   method public character GetStartupParam (input iParam as character  ):
      
   define variable vStartupParameters as character no-undo.
   vStartupParameters = session:startup-parameters.
   define variable vNumStartupParameters as integer no-undo.
   vNumStartupParameters = num-entries( vStartupParameters ).

   define variable i as integer no-undo.
      block-par:
   do i = 1 to vNumStartupParameters:
      define variable vParameter as character no-undo.
      vParameter = entry( i, vStartupParameters ).
      if vParameter begins iParam then
      do:
         define variable vList as character no-undo.
         vList  = entry(2,vParameter,' ').
        /* vList  = vList + " " +  vParameter.*/
        /* leave block-par.*/
      end.
   end.
      return vList.
   end method.  
   method public logical FolderExists  (input  ifolder as character ):
      return objExists(ifolder,"D") ne ?.
   end. 
   method public logical FileExists  (input  ifolder as character ):
      return objExists(ifolder,"F") ne ?.
   end.
   method public logical  objExists  (input  ifile as character):
      return    (objExists(ifile,"D") ne ?) or ( objExists(ifile,"F") ne ?) .                                  
   end.   
                                            
   method public character  objExists  (input  ifolder as character,
                                     input  iType   as character  ):
      define variable vPureName  as character no-undo.
      define variable vFullPath as character no-undo.
      define variable vFileType as character no-undo.                                  
      file-information:file-name = ifolder.
      if index( file-information:file-type, iType ) > 0 then return file-information:full-pathname .
      file-information:file-name = "./" + ifolder.
      if index( file-information:file-type, iType ) > 0 then return file-information:full-pathname .

      return ? .
/*      input STREAM sReadDir FROM os-dir(".").
      repeat:
         import stream sReadDir vPureName vFullPath vFileType.
         if vPureName begins  "."   then next.
         if vFileType =  "d" then 
         do:
         
            create ttfile.
            assign
               ttfile.fnAME         = vPureName
               ttfile.fullpach      = iDir
               ttfile.localPach     = iLoaclPath
               ttfile.fulllocalpach = trim(ttfile.localPach + v-path-tls-dir-delim + ttfile.fnAME,v-path-tls-dir-delim)
               ttfile.fLevel        = num-entries(ttfile.fulllocalpach,v-path-tls-dir-delim) 
               .
         end.
      end.
    
      input close. */
   end method.
      
   &GLOBAL-DEFINE PARAM-BEG-TAG SUBSTITUTE("<PARAM name='&1'>", iName)
   &GLOBAL-DEFINE PARAM-END-TAG SUBSTITUTE("</PARAM name='&1'>", iName)

   method public  void SavePARAM ( input iName as char, input iValue as char ):
      put unformatted {&PARAM-BEG-TAG}.
      put unformatted iValue.
      put unformatted {&PARAM-END-TAG} skip.
   end method.
   
   method public char GetPARAM (  input iName as char ):
      return GetPARAM("param.txt",iName).
   end.
   
   method public logical ChekStop ():
      return not FileExists("stop.txt").
   end. 
   
   method public logical CheckParam ():
      return FileExists("param.txt").
   end. 
   
     
   method public char GetPARAM ( input iFile as char, input iName as char ):
      def var vLob  as longchar no-undo.
      def var vFrom as int64    no-undo.
      def var vTo   as int64    no-undo.
      if not FileExists (iFile) then return ?.
      copy-lob file iFile to vLob no-error.
      vFrom = index(vLob, {&PARAM-BEG-TAG}).
      if vFrom <= 0 then return ?.
      assign
         vTo = index(vLob, {&PARAM-END-TAG})
         vFrom = vFrom + LENGTH({&PARAM-BEG-TAG}). 
      if vTo < vFrom then return ?.
      return string(substring(vLob, vFrom, vTo - vFrom)).
   end method.
   
  method public void  creatTTForProc (input iDir as char ):
   define var vPureName  as char    no-undo.
   define var vFullPath  as char    no-undo.
   define var vFileType  as char    no-undo.
   
   repeat preselect each ttfile:
       find next ttfile.
         delete ttfile.
      end.   
   repeat preselect each ttfilelist:
       find next ttfilelist.
         delete ttfilelist.
   end.
  for each ttrun:
      ttrun.favail = no. 
  end.    
   iDir = trim(idir,v-path-tls-dir-delim).
   
   input STREAM sReadDir FROM os-dir(iDir).
   repeat:
      import stream sReadDir vPureName vFullPath vFileType.
      if vPureName begins  "."   then next.
      if vFileType =  "d" then do:
         
         create ttfile.
         assign
            ttfile.fnAME       = vPureName
            ttfile.fullpach    = iDir
            
            ttfile.fulllocalpach = trim(ttfile.localPach + v-path-tls-dir-delim + ttfile.fnAME,v-path-tls-dir-delim)
            ttfile.fLevel      = num-entries(ttfile.fulllocalpach,v-path-tls-dir-delim) 
            .
      end.
      else if     vFileType =  "F"
              and can-do ("txt",entry(num-entries(vPureName,"."),vPureName,"."))
      then do:
         create ttfilelist.
         assign
         ttfilelist.fnAME         = vPureName
         ttfilelist.fullpach      = iDir
         ttfilelist.fulllocalpach = trim(ttfilelist.localPach + v-path-tls-dir-delim + ttfilelist.fnAME,v-path-tls-dir-delim)
         ttfilelist.fLevel        = num-entries(ttfilelist.fulllocalpach,v-path-tls-dir-delim) 
            .
      end.   
   end.   
   
    
   input close.
   define variable vProc   as character no-undo.
   define variable vLength as integer no-undo.
   define variable vDir    as character no-undo.
   define variable vFile   as character no-undo.
   define variable vCount  as character no-undo.
   for each ttfilelist:
      assign
         vProc = entry(1,ttfilelist.fnAME,".")
         vLength = length (vProc)
      .
      for each ttfile where ttfile.fnAME  begins vProc:
         vdir = ttfile.fullpach + v-path-tls-dir-delim + ttfile.fnAME + v-path-tls-dir-delim.
         find first ttrun where ttRun.proc = vProc
                            and ttRun.num  = int(substring(ttfile.fnAME,vLength + 1 ))
                            no-error.
         vFile = vdir + "endproc.txt".
         if not FileExists(vFile)
         then do:
            if not available ttrun
            then do:
                create ttRun.
                assign
                   ttRun.proc = vProc
                   ttRun.num  = int(substring(ttfile.fnAME,vLength + 1)) 
                 no-error.
            end.
            ttRun.favail = yes.
            vFile = vdir + "procinfo.txt".
            if FileExists(vFile)
            then do:
               input STREAM sReadfile FROM  VALUE(vFile). 
               repeat:
                  import stream sReadfile unformatted vCount.
                  if vCount ne ""
                  then do:
                     assign
                        ttrun.fpid = int(entry(1,vCount, "~001"))
                        ttrun.fmaxitem  =  int(entry(2,vCount, "~001")) 
                        ttRun.num       =  int(entry(3,vCount, "~001"))
                        ttrun.fmax      = int(entry(4,vCount, "~001"))
                     no-error.
                  end.
               end.
               input close. 
            end.
         
             vFile = vdir + "procrec.txt".
             if FileExists(vFile)
             then do:
               input STREAM sReadfile FROM  VALUE(vFile). 
               repeat:
                  import stream sReadfile unformatted vCount.
                  if vCount ne ""
                  then do:
                     assign
                        ttrun.olditem = ttrun.item
                        ttrun.item =  int(vCount) 
                     no-error.
                  end.
               end.
               input close.
            end.
            vFile = vdir + "procstatus.txt".
             if FileExists(vFile)
             then do:
               input STREAM sReadfile FROM  VALUE(vFile). 
               repeat:
                  import stream sReadfile unformatted vCount.
                  if vCount ne ""
                  then do:
                     assign
                        ttrun.fstatus =  vCount
                     no-error.
                  end.
               end.
               input close.
            end.
         end.
         else do:
             if available ttrun
             then 
                delete ttrun.
         end.
      end.     
   end.    
   repeat preselect each ttrun where ttrun.favail = no:
       find next ttrun .
         delete ttrun .
   end.  
end method.
method public void  creatProcInfo (input iAllobj as integer,iProcnum as integer,iAllproc as integer   ):
    define variable vMyPid as int64 no-undo.
   run utl/getpid.p (output vMyPid) no-error.
   output to "procinfo.txt".
   put unformatted substitute("&1~001&2~001&3~001&4",vMyPID ,iAllobj,iProcnum,iAllproc) skip.
   output close.
end method.
method public handle  getqueryttrun():
    define variable hQuery   as handle  no-undo .
              
    create query hQuery.    
    
    hQuery:set-buffers(buffer ttrun:HANDLE). 
    hQuery:query-prepare("FOR EACH ttrun").
       
    hQuery:query-open.
    return hQuery.
end.

method public void  Stopprc(input iDir as char ):
    if avail ttrun
    then
       Stopprc(iDir,ttrun.proc,ttrun.num).
end.

method public void  Stopprc(input iDir as character,iProc as character,iNum as integer ):
   os-delete value(substitute("&1\&2&3\stop.txt",iDir,iProc,if iNum  ne 0 then string(iNum) else "")) .
end.    
    
method public void  termprc(input iDir as char ):
   if avail ttrun
   then 
      termprc(iDir,ttrun.proc,ttrun.num).
end.    
method public void  termprc(input iDir as character,iProc as character,iNum as integer ):
   if avail ttrun
   then do:
   if termprc(ttrun.fpid)
   then do:
      output to value (substitute("&1\&2&3\endproc.txt",iDir,iProc,if iNum  ne 0 then string(iNum) else "") ).
      put skip.
      output close.
   end.
   if ttrun.fpid eq 0
   then
   do: 
       output to value (substitute("&1\&2&3\endproc.txt",iDir,iProc,if iNum  ne 0 then string(iNum) else "") ).
      put skip.
      output close.
   end.
   end.       
end.    
 
method public logical  termprc(iPid as integer):
   define variable vOk as logical no-undo.
   if iPid > 0 then do:
      run gbl/termprc.p
          ( input iPid
          ) no-error .
      if error-status :error 
      then do:
         message
            substitute( "Ошибка при остановке сессии : &1", iPid ) skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
          
      end.
      else
         vok = true.
   end.
   return vOk.    
end. 
method public void putStatus (itext as character ):
   output to "procstatus.txt". 
   put unformatted itext skip.
   output close.
end.

method public char getStatus (iSched as character  ):
   if iSched eq ?
   then 
      iSched = taskname.
   define variable vStat as character no-undo.
   for each ttrun where ttrun.proc eq iSched no-lock:
      if ttrun.fstatus ne "" and ttrun.fstatus ne ?
      then
         vStat = vStat + " "  + (if ttrun.fmax ne 1 then string(ttrun.num) + ": " else "") + ttrun.fstatus no-error.
   end.
   return vStat.
end.
/*************************************************/

define variable v-waitfram-action01         as character no-undo .
define variable v-waitfram-action02         as character no-undo .
define variable v-waitfram-action03         as character no-undo .
define variable v-waitfram-prev-left-margin as integer   no-undo init 0 .
define variable mText                       as character no-undo.
define button B-stop auto-end-key
     label "Стоп"
     size 10 by 1 tooltip "Остоновить процесс".
define button B-viewProcInfo
     label "Информация"
     size 15 by 1 tooltip "Информация о процесс".


define frame waitfram
  v-waitfram-action01 format "x(72)" no-label skip
  v-waitfram-action02 format "x(72)" no-label skip
  v-waitfram-action03 format "x(72)" no-label skip
  B-viewProcInfo 
  B-stop at row 4 col 30
  with view-as dialog-box side-labels three-d cancel-button b-stop
  .
on choose of B-stop in frame waitfram /* Добавить в АМ */
do:
  mStop = yes.
  
end.

on choose of B-viewProcInfo in frame waitfram /* Добавить в АМ */
do:
  run ref/runprocview.p (MyWorkDir,MyWorkDir).
end.
  
method private void waitfram-hide () :

  do
  on error undo, return error return-value
  :
    pause 0 before-hide .
    hide frame waitfram .

/*&if "{1}" = "" &then
    process events .
&endif*/
  end.

end method. /* waitfram-hide */
define public variable MstarstProc as datetime-tz no-undo.
method public void waitfram-show (input iInterval as int64  ):
   define variable vtime as int64 no-undo.
   vtime = ( now - MstarstProc ) / 1000 .
   waitfram-show(substitute("&1 Прошло: &2 сек" ,mText , string( vtime)), iInterval).
   
end method.
   
method private void waitfram-show (input p-message as character,input iInterval as int64  ):

  

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
    B-viewProcInfo:visible in frame waitfram = session:debug-alert.
    B-viewProcInfo:sensitive in frame waitfram = session:debug-alert.
    display
      v-waitfram-action01 skip
      v-waitfram-action02 skip
      v-waitfram-action03 skip
      with frame waitfram .
      
      
    B-stop:sensitive   in frame waitfram = yes.   
/*&if "{1}" = "" &then
    process events .
&endif
*/
     wait-for go of frame waitfram pause iInterval.
  end.

end method. /* waitfram-show */

method public logical WaitFor ( input iSched as character, input ipInterval as int64,input itext as character ):
 define variable vFlag as logical no-undo.
  mText = itext.
  MstarstProc = now.
  mShowFrame = yes.
  if not session:batch-mode
  then
     this-object:MyPause:Subscribe(this-object:waitfram-show).
  
  vFlag = WaitFor(iSched,ipInterval).
  return vFlag.
  finally:
     mtext = "".
     waitfram-hide().
     
     if not session:batch-mode
     then
        this-object:MyPause:Unsubscribe(this-object:waitfram-show).
     mShowFrame = no.
  end finally.
  end.
end class.