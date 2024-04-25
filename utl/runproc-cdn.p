
/*------------------------------------------------------------------------
    File        : runproc-cdn.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Belova Marina
    Created     : Mon Apr 08 11:31:14 MSK 2024
    Notes       :
  ----------------------------------------------------------------------*/
  
/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "Асинхронные процессы" .
{ cmp/vssrevis.i }

{cmp\str-glbl.i}

define variable mAsyncHelper as class ibs.th.file.asynchelperTh no-undo.
define variable vParams      as character no-undo.
define variable vwaitfile    as character no-undo.
define variable vParamSession as character no-undo.

{adm/auto-def-log.i new}
{utl/asuncprocauto.i &starterasunc = yes}

assign
   vParams = "*"
   vparamSession = ""
   .
   
  subscribe "PutFileLogAsunc" anywhere run-procedure "WriteLogAsync".

    mAsyncHelper = new ibs.th.file.AsyncHelperth().

    mAsyncHelper:mProcPublish   = this-procedure.
    
    mAsyncHelper:setCurrentUserPasswd().
    
    mAsyncHelper:MyBachMode     = session:batch-mode.
    mAsyncHelper:SaveFile       = yes.
    mAsyncHelper:paramSession   = vparamSession.
       
   /* mAsyncHelper:WaitFile = vwaitfile.*/

    
    mAsyncHelper:AsyncProc("utl/proc-gismtcdn", vParams, 1).
    
    /*delete object mAsyncHelper.
    unsubscribe "PutFileLogAsunc".*/
    
    /*
    define variable mAsyncHelper as class ibs.th.file.AsyncHelperth no-undo.
   define variable v-old-propath   as character        no-undo .
   mAsyncHelper = new ibs.th.file.AsyncHelperth().
   
   mAsyncHelper:MyBachMode = session:batch-mode.
   mAsyncHelper:SaveFile = yes. 
   /*mAsyncHelper:MyWorkDir  = IWorkdir.
   file-information:file-name = Iviewdir.*/
   mAsyncHelper:AsyncProc("utl/proc-gismtcdn", "", 1).
   message "1" view-as alert-box.
   /*mAsyncHelper:WaitFor("proc-view-proc", 1).*/
   delete object mAsyncHelper.
   
*/