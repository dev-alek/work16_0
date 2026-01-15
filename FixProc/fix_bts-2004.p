/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-2004. Исправляет размазывание оплаты по чеку 7/1218721 .

Автор: Белова М.М.
Дата создания: 10.10.2025
Author: 
Creation date: 

*/

{ utl/runpro.i }

define buffer buf_chk-gds-pay  for ub.chk-gds-pay. 

define variable vOk   as logical no-undo.
define variable vDisc as decimal no-undo.

do transaction:
    
    for each buf_chk-gds-pay exclusive-lock
        where buf_chk-gds-pay.doc-code = "7/1218721"        
          and buf_chk-gds-pay.line-num >= 1  
          and buf_chk-gds-pay.line-num <= 2
    :        
        assign
          buf_chk-gds-pay.eff-doc-qnty = round(buf_chk-gds-pay.eff-doc-qnty, 2)
          buf_chk-gds-pay.tot-r-b = buf_chk-gds-pay.eff-doc-qnty * buf_chk-gds-pay.price-base           
          .              
        if error-status:error then vOk = no.
        else vOk = yes.  
          
    end.     
end.    

if vOk then
MESSAGE "Успешно. Оплата по чеку 7/1218721 сконвертирована."
VIEW-AS ALERT-BOX.


