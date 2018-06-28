 
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

  define property ConPar as character no-undo /*без &1*/ 
    get.
    set (arg as char):
      ConPar = replace (arg, "&1", ""). 
    end.

  define property isUpdShm as logical no-undo 
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

    
  constructor public updschm (input inConPar as char):

    obsrvdbObj = new observupd ().
    
    CurrDBShm   = obsrvdbObj:CurrDBShm.  
    CurrDB0Shm  = obsrvdbObj:CurrDB0Shm. 
    DbNum       = obsrvdbObj:DbNum.      
    TargetDBShm = obsrvdbObj:TargetDBShm.
    ConPar      = inConPar.
    isNeedUpd = obsrvdbObj:isneedupg().
    if obsrvdbObj:IsErr
    then do:
      Msg = obsrvdbObj:Msg.
      IsErr = true.
    end.
    delete object obsrvdbObj.
    
  end constructor.

  method public void upddbshm ():
    
    disconnect value ('ub').
    
    define variable v-user-passwd       as character no-undo .
    assign
      v-user-passwd = substitute("-U &1 -P &2":U
                                ,"sysadm"
                                ,"sysadm"
                                )
    .
    
    loadDFProcFile = search ("ibs/th/adm/upd/loaddf.r").
    if loadDFProcFile <> ?
    then isRcode = true.
    else loadDFProcFile = search ("ibs/th/adm/upd/loaddf.p").
     
    if CurrDBShm < TargetDBShm
    then do:
      upddbshm-1().
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
    end.
    connect value(substitute(ConPar + " &1", v-user-passwd)).  
    NewCurrDBShm = 1.
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
    disconnect value ("ub").
    isUpdShm = true.
  end method.
  
  method private void upddbshm-1 ():

    define variable v-int as integer no-undo.
    
    if CurrDBShm < 1
    then do:
      loaddf ("cmp/18051601.df").
      if IsErr = true
        then return.
        
    end.
    
  end method.

  method private void loaddf (input inFileDF as char):
    
    def var v-filedfname as character no-undo.
    def var v-prowin32FileName as character no-undo.
    def var v-cmd-comm as character no-undo.

    v-prowin32FileName =  search ("bin/prowin32.exe").
    
    v-filedfname = search (inFileDF).
    if v-filedfname = ?
    then do:
      Msg = substitute ( "Файл &1 обновления схемы БД не найден. Работа с ней запрещена!", inFileDF).
      IsErr = true.
      return.
    end.
    if isRcode
    then v-cmd-comm = substitute ("&4 &1 -U sysadm -P sysadm -rx -p &2 -param &3,yes", ConPar, loadDFprocFile, v-filedfname, v-prowin32FileName).
    else v-cmd-comm = substitute ("&4 &1 -U sysadm -P sysadm -p &2 -param &3,yes", ConPar, loadDFprocFile, v-filedfname, v-prowin32FileName).
    os-command silent value (v-cmd-comm).
  
  end.

end class.