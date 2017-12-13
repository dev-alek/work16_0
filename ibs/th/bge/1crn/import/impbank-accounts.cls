/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных impbank-accounts из 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
USING ibs.th.trg.newbcod from propath.
USING ibs.th.gbl.curdburt from propath.

class ibs.th.bge.1crn.import.impbank-accounts implements ibs.th.bge.1crn.import.iimpsubject: 
  
  { cmp/str-glbl.i class }
  { cmp/str-glbl.i }
  
  
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
	
    define variable ri as recid no-undo .
    	
    define buffer buf_fin-bank    for ub.fin-bank .
    define buffer buf_fin-schet   for ub.fin-schet .
    define buffer X_schet-clients for ub.clients .
    DEFINE BUFFER X_currency      FOR ub.currency.
    
    define variable v-curr-code      as integer   no-undo .
    define variable v-code-bank      as integer   no-undo .
    define variable v-mode           as character no-undo .
    define variable v-mode-bank      as character no-undo .
    define variable v-doc-rec        as recid     no-undo .
    
    define variable objBank-Accounts as class     bank-accounts no-undo.
    
    objBank-Accounts = cast (subjectObj, bank-accounts).
    
    find first X_schet-clients no-lock where X_schet-clients.obj-code = integer(objBank-Accounts:cont-code) and
      X_schet-clients.obj-type = {&cmp} no-error .
    if not available X_schet-clients then 
    do:
      Msg = "Не найден держатель счета в справочнике клиентов с кодом:" + string(objBank-Accounts:cont-code) .
      return error.
    end.
    
    find first buf_fin-bank no-LOCK where buf_fin-bank.bik = objBank-Accounts:bik
      and buf_fin-bank.host-code = X_schet-clients.host-code no-error . 
    if not available buf_fin-bank then 
    do:
      find last ub.fin-bank no-error.
      if AVAILABLE ub.fin-bank then v-code-bank = ub.fin-bank.code-bank + 1 .
      else v-code-bank = 1 .   
      assign
        v-doc-rec   = ?
        v-mode-bank = {&add-def}
        .
    end.
    else 
    do:
      assign
        v-doc-rec   = recid (buf_fin-bank)
        v-mode-bank = {&add-def}
        v-code-bank = buf_fin-bank.code-bank
        .
    end.
        
    run ref/finbank1.p (
      input-output v-doc-rec
      ,input v-mode-bank
      ,input yes
      ,input "bik" /*p-verify*/
      ,input "":U
      ,input if X_schet-clients.host-code = ? then 0 else X_schet-clients.host-code
      ,input v-code-bank
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.addres else ""
      ,input objBank-Accounts:bank-city
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.addres1 else ""
      ,input objBank-Accounts:bank-name
      ,input objBank-Accounts:bik
      ,input objBank-Accounts:cor-acc
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.e-mail else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.fax else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.inn else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.kpp else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.licenz else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.okato else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.okonx else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.okpo else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.otdel else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.phone else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.PS else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.rkc else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.short-name else ""
      ,input if AVAILABLE buf_fin-bank then buf_fin-bank.cl-bank else ""
      )
      no-error.
    if error-status:error then 
    do:
      Msg = return-value.
      return error.
    end.
  find first buf_fin-bank no-LOCK where buf_fin-bank.code-bank = v-code-bank no-error.
  if AVAILABLE buf_fin-bank then do: 
    find first ub.sysconf no-lock where ub.sysconf.host-code = buf_fin-bank.host-code no-error.
    if AVAILABLE ub.sysconf then 
    do:
      v-curr-code = ub.sysconf.base-code .
    end.
    else 
    do:
      Msg = "Не найдены системные настройки для фирмы с кодом:" + string(buf_fin-bank.host-code) .
      find first X_currency no-lock no-error.
      if AVAILABLE x_currency then 
      do:
        v-curr-code = ub.currency.curr-code .
      end.  
      else 
      do:
        Msg = "Вы не выбрали валюту счета".
        return error .
      end.  
    end.     
    find first buf_fin-schet EXCLUSIVE-LOCK where buf_fin-schet.r-schet = objBank-Accounts:r-schet
      and buf_fin-schet.cli-code = X_schet-clients.obj-code
      and buf_fin-schet.cli-type = X_schet-clients.obj-type no-error .
    if AVAILABLE buf_fin-schet then 
    do:
      v-mode = {&update} .
      ri = recid(buf_fin-schet) .
    end.
    else 
    do:
      v-mode = {&add-def} .
      ri = ? .
    end.    

    run ref/finscht1.p (
      input-output ri
      ,input v-mode
      ,input yes
      ,input "r-schet"
      ,input buf_fin-bank.host-code
      ,input buf_fin-schet.code-schet
      ,input buf_fin-schet.c-schet
      ,input buf_fin-schet.cli-type
      ,input buf_fin-schet.cli-code
      ,input buf_fin-schet.code-bank
      ,input buf_fin-schet.curr-code
      ,INPUT buf_fin-schet.dop1
      ,INPUT buf_fin-schet.dop2
      ,input buf_fin-schet.r-schet
      ,input buf_fin-schet.PS
      )
      no-error.
    if error-status:error then 
    do:
      Msg = return-value.
      return false.
    end.
    end.
  end method.

end class.