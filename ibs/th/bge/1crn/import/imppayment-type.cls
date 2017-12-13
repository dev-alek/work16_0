/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных payment-type-group из 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
USING ibs.th.ref.cpattr FROM PROPATH.
USING ibs.th.gbl.getcntxt FROM PROPATH.
class ibs.th.bge.1crn.import.imppayment-type implements ibs.th.bge.1crn.import.iimpsubject:
  
  { cmp/str-glbl.i class }
    
  
define variable cpattr    as class cpattr   no-undo .
define variable getcntxt  as class getcntxt no-undo .

  define property Msg as character no-undo
    get. 
    set.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
		
		define var  v-rec as recid no-undo .
    define var  parparentproc as widget-handle no-undo .
    define var  v-delete as logical no-undo .
    define var  v-dop-doc as character no-undo .
    
    define variable objPaymentType as class payment-type no-undo.
    run gbl/inidebug.p.
    objPaymentType = cast (subjectObj, payment-type).
    
    if objPaymentType:del-f = 1 then 
    do:
      /*проверять не используется ли данные где-то в другом месте - не сделано*/
		  
      find first ub.cash-pay where ub.cash-pay.cdpay-code = integer(objPaymentType:code_)
        and ub.cash-pay.curr-code = integer(objPaymentType:curr-code) no-error .
      if AVAILABLE ub.cash-pay then 
      do:
        for each ub.cash-pay-attr where ub.cash-pay-attr.cdpay-code = ub.cash-pay.cdpay-code
          and ub.cash-pay-attr.curr-code = ub.cash-pay.curr-code:
          
         CpAttr:CpAttrDelete(ub.cash-pay-attr.cdpay-code,
                             ub.cash-pay-attr.curr-code,
                             ub.cash-pay-attr.host-code,
                             ub.cash-pay-attr.obj-type,
                             ub.cash-pay-attr.obj-code,
                             ub.cash-pay-attr.attr-code,
                             output v-delete
                             ).
                             
        end.
        delete ub.cash-pay .
      end. 		                                                       
    end.  
		else do:
      find first ub.cash-pay where ub.cash-pay.cdpay-code = integer(objPaymentType:code_)
        and ub.cash-pay.curr-code = integer(objPaymentType:curr-code) no-error .
        if AVAILABLE ub.cash-pay then do:
          v-rec = recid(ub.cash-pay) .
 run ref/cashpay1.p (
                  input parparentproc
                 ,input no
                 ,input-output v-rec
                 ,input {&update}
                 ,input ub.cash-pay.cdpay-code
                 ,input objPaymentType:name_
                 ,input ub.cash-pay.curr-code
                 ,input integer(objPaymentType:ptg-code)
                 ,input 0 /*Код МЦ*/
                 ,input 0 /*Предел без авторизации*/
                 ,input objPaymentType:pmt-cash
                 ,input (if objPaymentType:enbl-zd = 1 then yes else no) 
                 ,input (if objPaymentType:enbl-trf = 1 then yes else no) 
                 ,input (if objPaymentType:mst-slip = 1 then yes else no) 
                 ,input no
                 ,input (if objPaymentType:mst-online = 1 then yes else no) 
                 ,input no
                 ,input objPaymentType:pmt-fuel
                 ,input no
                 ,input objPaymentType:prfx
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input objPaymentType:pmt-service
                 ,input objPaymentType:kbo
                 ,input 0
                 ,input 0
                 ,input 0
                 ,input 0
                 ,input ""
                 ,input ""
                 ,input objPaymentType:pmt-ved
                 ) no-error .
     
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
        
        for each ub.cash-pay-attr where ub.cash-pay-attr.cdpay-code = ub.cash-pay.cdpay-code
          and ub.cash-pay-attr.curr-code = ub.cash-pay.curr-code:
          
         CpAttr:CpAttrDelete(ub.cash-pay-attr.cdpay-code,
                             ub.cash-pay-attr.curr-code,
                             ub.cash-pay-attr.host-code,
                             ub.cash-pay-attr.obj-type,
                             ub.cash-pay-attr.obj-code,
                             ub.cash-pay-attr.attr-code,
                             output v-delete
                             ).
         end.
         
         case  objPaymentType:doc-type:
           when 1 then v-dop-doc = "swo" . 
           when 2 then v-dop-doc = "trf".
           when 3 then v-dop-doc = "vir".
           when 4 then v-dop-doc = "" .
         end case.   
         
         if objPaymentType:cnt-code <> "" then do:
           find first ub.clients where ub.clients.obj-code = integer(objPaymentType:cnt-code)
                                   and ub.clients.obj-type = {&cmp} no-error .
            if not AVAILABLE ub.clients then do:
              Msg = "Не найден контрагент с кодом:" + objPaymentType:cnt-code .
              return false.
            end.
            else do:
              v-dop-doc = v-dop-doc + (if v-dop-doc <> "" then "," else "") + {&cmp} + "," + objPaymentType:cnt-code .
            end.    
         end.
         CpAttr:CpAttrWrite( integer(objPaymentType:code_),
                             integer(objPaymentType:curr-code),
                             ub.clients.host-code,
                             {&cmp},
                             integer(objPaymentType:cnt-code),
                             "dop-doc",
                             v-dop-doc
                             ).            
                             

         CpAttr:CpAttrWrite( integer(objPaymentType:code_),
                             integer(objPaymentType:curr-code),
                             ub.clients.host-code,
                             {&cmp},                             
                             integer(objPaymentType:cnt-code),
                             "form_km3",
                             string(if objPaymentType:use-km3 = 1 then "yes" else "no")
                             ).            

         CpAttr:CpAttrWrite( integer(objPaymentType:code_),
                             integer(objPaymentType:curr-code),
                             ub.clients.host-code,
                             {&cmp},
                             integer(objPaymentType:cnt-code),
                             "bal_malina",
                             string(if objPaymentType:malina = 1 then "yes" else "no")
                             ).            
        end.
      else do:		
        create ub.cash-pay .
        v-rec = recid(ub.cash-pay) .
      run ref/cashpay1.p (
                  input parparentproc
                 ,input no
                 ,input-output v-rec
                 ,input {&add-def}
                 ,input ub.cash-pay.cdpay-code
                 ,input objPaymentType:name_
                 ,input ub.cash-pay.curr-code
                 ,input integer(objPaymentType:ptg-code)
                 ,input 0 /*Код МЦ*/
                 ,input 0 /*Предел без авторизации*/
                 ,input objPaymentType:pmt-cash
                 ,input (if objPaymentType:enbl-zd = 1 then yes else no) 
                 ,input (if objPaymentType:enbl-trf = 1 then yes else no) 
                 ,input (if objPaymentType:mst-slip = 1 then yes else no) 
                 ,input no
                 ,input (if objPaymentType:mst-online = 1 then yes else no) 
                 ,input no
                 ,input objPaymentType:pmt-fuel
                 ,input no
                 ,input objPaymentType:prfx
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input no
                 ,input objPaymentType:pmt-service
                 ,input objPaymentType:kbo
                 ,input 0
                 ,input 0
                 ,input 0
                 ,input 0
                 ,input ""
                 ,input ""
                 ,input objPaymentType:pmt-ved
                 ) no-error .
     
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
        
         case  objPaymentType:doc-type:
           when 1 then v-dop-doc = "swo" . 
           when 2 then v-dop-doc = "trf".
           when 3 then v-dop-doc = "vir".
           when 4 then v-dop-doc = "" .
         end case.   
         
         if objPaymentType:cnt-code <> "" then do:
           find first ub.clients where ub.clients.obj-code = integer(objPaymentType:cnt-code)
                                   and ub.clients.obj-type = {&cmp} no-error .
            if not AVAILABLE ub.clients then do:
              Msg = "Не найден контрагент с кодом:" + objPaymentType:cnt-code .
              return false.
            end.
            else do:
              v-dop-doc = v-dop-doc + (if v-dop-doc <> "" then "," else "") + {&cmp} + "," + objPaymentType:cnt-code .
            end.    
         end.
           
         CpAttr:CpAttrWrite( integer(objPaymentType:code_),
                             integer(objPaymentType:curr-code),
                             ub.clients.host-code,
                             {&cmp},
                             integer(objPaymentType:cnt-code),
                             "dop-doc",
                             v-dop-doc
                             ).            
                             

         CpAttr:CpAttrWrite( integer(objPaymentType:code_),
                             integer(objPaymentType:curr-code),
                             ub.clients.host-code,
                             {&cmp},
                             integer(objPaymentType:cnt-code),
                             "form_km3",
                             string(if objPaymentType:use-km3 = 1 then "yes" else "no")
                             ).            

         CpAttr:CpAttrWrite( integer(objPaymentType:code_),
                             integer(objPaymentType:curr-code),
                             ub.clients.host-code,
                             {&cmp},
                             integer(objPaymentType:cnt-code),
                             "bal_malina",
                             string(if objPaymentType:malina = 1 then "yes" else "no")
                             ).            
        if error-status:error then do:
          Msg = return-value.
          return false.
        end.
      end.
		return true.
    end.
	end method.

  method public logical CashPayAttr ():
  end METHOD .
end class.

