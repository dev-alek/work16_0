/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных impcontracts из 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
USING ibs.th.gbl.*.
USING ibs.th.trg.newbcod from propath.
USING ibs.th.gbl.curdburt from propath.

class ibs.th.bge.1crn.import.impcontracts implements ibs.th.bge.1crn.import.iimpsubject: 
  
  { cmp/str-glbl.i class }
  { cmp/str-glbl.i }
  
  define variable newbcod1  as class newbcod  no-undo .   
  define variable curdburt as class curdburt no-undo .   
   
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
	
    define variable ri     as recid   no-undo .
    define variable f-code as integer no-undo .	
    define buffer b_contract for ub.contract .
    define variable p-sys-date     as date      no-undo .
    define variable p-sys-time     as character no-undo .
    define variable p-sys-time-int as integer   no-undo .
    define variable v-cli-code     as integer   no-undo .
    define variable v-cli-name     as character no-undo .
    define variable v-status       as character no-undo .
    define variable v-curr-code    as integer   no-undo .
    define variable objContracts   as class     contracts no-undo.
    define variable v-user-db-num  as integer   no-undo .
    define variable v-user-name    as character no-undo .
    
      objContracts = cast (subjectObj, contracts).
        
    if objContracts:date-srt <> ? and objContracts:date-end <> ? then 
    do:
      if objContracts:date-srt > objContracts:date-end then 
      do:
        Msg = "Дата начала действия позже даты окончания действия!" .
        return error.
      end.

      if objContracts:cont-code = "" or objContracts:cont-code = ? then 
      do:
        Msg = "Не задан контрагент".
        return error.
      end.

      find first ub.contract EXCLUSIVE-LOCK
        where ub.contract.contract-prn-code = objContracts:code_
        and ub.contract.host-code         = integer(objContracts:org-code)
        and ub.contract.contract-type     = {&contr-buy-sale} /*заглушка*/ 
        no-error .
      if AVAILABLE ub.contract then 
      do:
        assign
          v-status    = if objContracts:del-l = 0 then {&current-contr} else {&close-contr}
          v-cli-code  = ub.contract.cli-code
          v-cli-name  = ub.contract.cli-name
          v-curr-code = ub.contract.curr-code
          .
      end.
      else 
      do:
        newbcod1 = new newbcod () .
        newbcod1:GenBCod(input {&gbl-ct-code},
          output f-code) no-error.
        if error-status:error then 
        do:
          Msg = "Ошибка при генерации внутреннего № договора".
          return error.
        end.
        /*combo-usl-opl = {&contr-pay-nodef} .*/
        /*combo-type-contr = "Купли-продажи". */
          create ub.contract .
          assign
            ub.contract.contract-prn-code = objContracts:code_
            ub.contract.host-code         = integer(objContracts:org-code)
            ub.contract.contract-type     = {&contr-buy-sale} /*заглушка*/ 
          .
        find first ub.clients no-lock where ub.clients.obj-code = integer(objContracts:cont-code)
          and ub.clients.obj-type = {&cmp} no-error .
        if AVAILABLE ub.clients then 
        do:
          assign
            v-cli-code = ub.clients.obj-code
            v-cli-name = ub.clients.obj-name
            .
        end.
        else 
        do:
          /*Создаем нового клиента?*/
          Msg = "Нет такого контрагента" .
          return error.
        end.  
        find first ub.sysconf no-lock where ub.sysconf.host-code = integer(objContracts:org-code) no-error.
        if AVAILABLE ub.sysconf then 
        do:
          v-curr-code = ub.sysconf.base-code .
        end.
        else 
        do:
          Msg = "Не найдены системные настройки для фирмы с кодом:" + objContracts:org-code .
          find first ub.currency no-lock no-error.
          if AVAILABLE ub.currency then 
          do:
            v-curr-code = ub.currency.curr-code .
          end.  
          else 
          do:
            Msg = "Не найден справочник видов оплат".
            return error .
          end.  
        end.     
      end.
      assign
        ub.contract.doc-type          = {&income}
        ub.contract.contract-code     = f-code
        ub.contract.status_           = if objContracts:del-l = 0 then {&current-contr} else {&close-contr}
        ub.contract.curr-code         = v-curr-code /*какую брать валюту*/
        ub.contract.own-name          = {&company} /*Откуда брать?*/
        ub.contract.cli-type          = {&cmp}
        ub.contract.cli-code          = v-cli-code 
        ub.contract.cli-name          = v-cli-name
        ub.contract.db-num            = gbl-var:g#db-num
        ub.contract.user-db-num       = gbl-var:g#db-num
        ub.contract.usl-opl           = {&contr-pay-nodef}
        ub.contract.contract-date     = objContracts:date-srt
        ub.contract.contract-date-beg = objContracts:date-srt
        ub.contract.contract-date-end = objContracts:date-end
        .
    end.
  end method.

end class.