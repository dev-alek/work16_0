 
 /*------------------------------------------------------------------------
    File        : updschm
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Wed Jun 20 17:45:11 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.adm.upd.*.


class ibs.th.adm.upd.updschm: 

  {cmp/str-glbl.i class}
  
  
  define variable loadDFprocFile as character no-undo.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  define property TargetDBShm as integer no-undo 
    get.
    private set.
    
  define property CurrDBShm as integer  no-undo 
    get.
    private set.

  define property NewCurrDBShm as integer  no-undo 
    get.
    private set.

  define property CurrDB0Shm as integer  no-undo 
    get.
    private set.
    
  define property IsComp as logical no-undo
    get.
    set.
    
  define property ConPar as character no-undo /*без &1*/ 
    get.
    set (arg as char):
      if arg begins "iscomp|"
      then do:
         iscomp = yes.
         arg = entry(2,arg,"|").
      end.
      ConPar = replace (arg, "&1", ""). 
    end.

  define property isUpdShm as logical no-undo init yes 
    get.
    private set.
    
  define property isNeedUpd as logical no-undo 
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
  
  
    
  define variable isRcode as logical init false no-undo.
  define variable obsrvdbObj as class observupd no-undo.
  define variable analisdfObj as class analisdf no-undo.
  define private variable m-user-passwd       as character no-undo .
  define private variable m-prowin32FileName  as character no-undo.
  define private variable m-FileDf            as character no-undo.
  define private variable m-Batch             as logical   no-undo.
  define variable mDfUpdaLL as character no-undo.
  
    
  constructor public updschm (input inConPar as char):
    obsrvdbObj = new observupd ().
    ConPar      = inConPar.
    obsrvdbObj:IsComp = IsComp. 
    CurrDBShm   = obsrvdbObj:CurrDBShm.  
    CurrDB0Shm  = obsrvdbObj:CurrDB0Shm. 
    DbNum       = obsrvdbObj:DbNum.      
    TargetDBShm = obsrvdbObj:TargetDBShm.
    
    mDfUpdaLL   = obsrvdbObj:upd-all-list-df.
   
    m-FileDf    = obsrvdbObj:upd-df.
    define variable vupd as logical no-undo.
    loadDFProcFile = search ("ibs/th/adm/upd/loaddf.r").
    if loadDFProcFile <> ?
    then isRcode = true.
    else loadDFProcFile = search ("ibs/th/adm/upd/loaddf.p").
    if not IsComp and not isRcode and CurrDBShm < TargetDBShm 
    then do:
       message "Обновить базу с версии " CurrDBShm  " до " TargetDBShm "?" view-as alert-box question 
          buttons yes-no title "[ ВНИМАНИЕ! ]" update vupd.
       if not vupd
       then
          return.
    end.
    isNeedUpd = obsrvdbObj:isneedupg().
    if obsrvdbObj:IsErr
    then do:
      Msg = obsrvdbObj:Msg.
      IsErr = true.
    end.
    assign
      m-user-passwd = substitute("-U &1 -P &2":U
                                ,"sysadm"
                                ,obsrvdbObj:pwd 
                                )
    .
    
    m-prowin32FileName =  search ("bin/prowin32.exe").
    delete object obsrvdbObj.
    
  end constructor.

  method public void upddbshm ():
    define variable vI as integer no-undo.
    define variable vdbconect as logical no-undo.
    if  CurrDBShm eq TargetDBShm
    then
       vdbconect = yes.
    
    upddbshmall().
    /* загрузка df файлов */
    if isUpdShm  /* загрузка df файлов коректировки выполняется всегда*/
       and not IsComp
    then do:
      /* if vdbconect
         
      then */
         disconnect value ('ub').
/*         m-Batch = yes.*/
      do vi = 1 to num-entries(mDfUpdaLL):
         
         upddbshm-1(entry(vi,mDfUpdaLL)).
          
         
      end.
      
       
    end.  
    return.
  end. 
  method public void upddbshmall():
    Block-UpdOne:
    do while CurrDBShm < TargetDBShm :
      isUpdShm = no.
      upddbshmAllOneDf().
    /*  isErr = yes.*/
      /*upddbshmOne(). */
      if isErr
      then 
        leave Block-UpdOne.
    end.
    if isErr 
    then do:
       if IsComp 
       then 
          message "Ошибка обновления БД."
            view-as alert-box.
       else do:
          message "Ошибка обновления БД. Попробуем обновить по частям"
          view-as alert-box.
          isErr = no.
          Block-UpdOneTry:
          do while CurrDBShm < TargetDBShm :
             isUpdShm = no.
            
             upddbshmOne().
             if isErr
             then 
                leave Block-UpdOneTry.
          end.
       end.
    end.
   /* else
       disconnect value ('ub'). */
  end method.
  method public void upddbshmAllOneDf ():  
    
    
    
    
    if CurrDBShm < TargetDBShm
    then do:
      analisdfObj = new analisdf ().
      analisdfObj:IsComp = IsComp.
      if  analisdfObj:createDF(CurrDBShm)
      then do:
         assign
            m-FileDf     = analisdfObj:mFileDf
            NewCurrDBShm = analisdfObj:mUpdateTo
         .
      end.
      else
         isErr = yes. 
      
      delete object analisdfObj no-error.
      disconnect value ('ub').
      upddbshm-1(m-FileDf).
      if isErr then 
      do:
        Msg =
          substitute("Ошибка при обновлении схемы базы данных") + {&new-line} +
          error-status :get-message(1) + {&new-line} +
          return-value
          .
        IsErr = true.
        return.
      end.
      connect value(substitute(ConPar + " &1", m-user-passwd)).
    end.
    
    
     analisdfObj = new analisdf ().
     analisdfObj:IsComp = IsComp.
     def var m-FileDf_new as char no-undo.
     if analisdfObj:createDF(CurrDBShm)
     then do:
        m-FileDf     = analisdfObj:mFileDf.
        m-FileDf_new = replace (m-FileDf,"~/","~\").
        entry(num-entries (m-FileDf_new,"~\"),m-FileDf_new,"~\") = "new_" + entry(num-entries (m-FileDf_new,"~\"),m-FileDf_new,"~\").
        if not analisdfObj:CheckTable(m-FileDf_new)
        then do:
           IsErr = true.
           delete object analisdfObj no-error.
           message "Поля не прошедшие проверку выгружены в файл" m-FileDf_new 
           
           view-as alert-box.
           return.
        end.   
     end.
     delete object analisdfObj no-error. 
     obsrvdbObj = new observupd ().
    obsrvdbObj:writeResult(NewCurrDBShm).
    if obsrvdbObj:IsErr
    then do:
      Msg = obsrvdbObj:Msg.
      delete object obsrvdbObj no-error.
      IsErr = true.
      return.  
    end.
    delete object obsrvdbObj no-error.
    CurrDBShm = NewCurrDBShm.
    isUpdShm = true.
  end method.      
  method public void upddbshmOne ():  
    
    
   /* message CurrDBShm
    view-as alert-box. */
    if CurrDBShm < TargetDBShm
    then do:
      analisdfObj = new analisdf ().
      analisdfObj:IsComp = IsComp.
      if  analisdfObj:createDF(CurrDBShm,CurrDBShm + 1)
      then do:
         assign
            m-FileDf     = analisdfObj:mFileDf
            NewCurrDBShm = analisdfObj:mUpdateTo
         .
      end.
      else
         isErr = yes.
      if not m-FileDf begins "proc:"
      then 
         m-FileDf = analisdfObj:addDFNumUpd(m-FileDf,CurrDBShm + 1). 
      delete object analisdfObj no-error.
      disconnect value ('ub').
      upddbshm-1(m-FileDf).
      if isErr then 
      do:
        Msg =
          substitute("Ошибка при обновлении схемы базы данных") + {&new-line} +
          error-status :get-message(1) + {&new-line} +
          return-value
          .
        IsErr = true.
        return.
      end.
      connect value(substitute(ConPar + " &1", m-user-passwd)).
    end.
   /* message 3
    view-as alert-box. */ 
    NewCurrDBShm = CurrDBShm + 1.
    obsrvdbObj = new observupd ().
    obsrvdbObj:writeResult(NewCurrDBShm).
    if obsrvdbObj:IsErr
    then do:
      Msg = obsrvdbObj:Msg.
      delete object obsrvdbObj no-error.
      IsErr = true.
      return.  
    end.
    m-FileDf = obsrvdbObj:upd-df.
    delete object obsrvdbObj no-error.
   /* if NewCurrDBShm eq TargetDBShm
    then
       disconnect value ("ub").*/
    CurrDBShm = NewCurrDBShm.
    isUpdShm = true.
  end method.
  
  method private void upddbshm-1 (input iparam as character ):
    define variable vproc  as character no-undo.
    define variable vparam as character no-undo.
    if iparam begins "proc:"
    then do:
       assign
          iparam = substring (iparam,6) 
          vproc  = entry(1,iparam,";")
          vparam = entry(2,iparam,";")
       no-error.
       vproc = SearchPFile (vproc).
       if vproc ne ?
       then
          runsession (vproc,vparam,yes).
    end.
    else do:
       
       loaddf (iparam).
    end.   
    if IsErr = true
      then return.
  end method.
  
  method private character  SearchPFile (input inFile as char):
     define variable oFile as character no-undo.
     inFile = entry(1,inFile,".").
     oFile = search(inFile + ".r" ).
     if oFile eq ?
     then
        oFile = search(inFile + ".p" ).
     return oFile.
     
  end.
  method private void loaddf (input inFileDF as char):
    
    def var v-filedfname as character no-undo.
    
    
    v-filedfname = search (inFileDF).
    if v-filedfname = ?
    then do:
      Msg = substitute ( "Файл &1 обновления схемы БД не найден. Работа с ней запрещена!", inFileDF).
      IsErr = true.
      return.
    end.
    runsession(loadDFprocFile,v-filedfname).
    
  end.
  method private void runsession (input iProc as char,input iParam as char):
     runsession(iProc,iParam,no).
  end.   
  method private void runsession (input iProc as char,input iParam as char,input Ini as logical ):
     define variable vParamStart as character no-undo.
     if Ini
     then do:
         vParamStart = " -ininame "  + GetStartupParam("-ininame").
     end.
     if iproc eq loadDFprocFile and isRcode
     then 
        vParamStart = vParamStart + " -rx " .
     def var v-cmd-comm as character no-undo.
     if isRcode
     then v-cmd-comm = substitute ("&1 &2 &3 &4 -p &5 &6 &7 &8",m-prowin32FileName, vParamStart, ConPar,m-user-passwd, iProc, if m-Batch then "-b" else "", if iparam eq "" then "" else "-param" , iParam).
     else v-cmd-comm = substitute ("&1 &2 &3 &4 -p &5 &6 &7 &8",m-prowin32FileName, vParamStart, ConPar,m-user-passwd, iProc, if m-Batch then "-b" else "", if iparam eq "" then "" else "-param" , iParam).
    os-command silent value (v-cmd-comm).
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
end class.
