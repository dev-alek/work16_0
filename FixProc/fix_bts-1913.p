/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-1913. Исправляет ставку и сумму НДС у чеков смены 22/08/2025 .

Автор: Белова М.М.
Дата создания: 03.09.2025
Author: 
Creation date: 

*/


{ utl/runpro.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }

define buffer buf_chk-doc for ub.chk-doc.
define buffer buf_chk-gds for ub.chk-gds.
define buffer b_bar-code for ub.bar-code.
define buffer b_goods for ub.goods.
define buffer buf_chk-gds-pay  for ub.chk-gds-pay. 

define variable v-vat-pc as decimal no-undo.
define variable v-slt-pc as decimal no-undo.
define variable v-host-code like ub.sysconf.host-code no-undo.
define variable v-sum-base as decimal no-undo.
define variable v-Cnt as int no-undo.
define variable v-Cnt-Chk as int no-undo.

v-Cnt-Chk = 0.
for each buf_chk-doc no-lock where 
         buf_chk-doc.shift-date = Date("22/08/2025")    
    and (buf_chk-doc.chk-type = 1 
      or buf_chk-doc.chk-type = 6):                
      
      { gbl/hostcode.i buf_chk-doc.obj-type buf_chk-doc.obj-code v-host-code }  
      
      v-Cnt = 0.                  
      for each buf_chk-gds exclusive-lock where 
               buf_chk-gds.doc-code = buf_chk-doc.doc-code                
           and buf_chk-gds.vat-pc = 0
      :
          FIND FIRST b_bar-code No-LOCK WHERE
                     b_bar-code.b-code = buf_chk-gds.b-code No-ERROR.
          if not avail b_bar-code then next.
          FIND FIRST b_Goods No-LOCK WHERE
                     b_goods.gds-code = b_bar-code.gds-code No-ERROR.
          if not avail b_goods then next.
          
          v-Cnt = v-Cnt + 1.   
     
          v-sum-base =  Round((buf_chk-gds.price-base - buf_chk-gds.discnt) * buf_chk-gds.doc-qnty, 2).
          /* только для продаж, учитываем оплату баллами для уменьшения НДС */
          if v-sum-base > 0 then do:
              find first  buf_chk-gds-pay no-lock where 
                          buf_chk-gds-pay.doc-code = buf_chk-doc.doc-code
                      and buf_chk-gds-pay.pay-code = 104
                      no-error.
              if  avail buf_chk-gds-pay and 
                  v-Cnt = 1 
              then v-sum-base = v-sum-base - buf_chk-gds-pay.tot-r-b.
              if v-sum-base < 0 then next.  
          end.
          
          { gbl/pftxvalg.i b_goods.gds-code {&vat-tax-code}  buf_chk-doc.chk-date v-host-code buf_chk-doc.obj-type buf_chk-doc.obj-code v-vat-pc no-error }
            
          v-slt-pc = ROUND(v-sum-base * v-vat-pc / (100 + v-vat-pc), 2) no-error.
          
          if v-vat-pc <> ? and v-vat-pc <> 0 and  v-slt-pc <> ? then
          assign
             buf_chk-gds.vat-pc = v-vat-pc 
             buf_chk-gds.vat-sum-rubl = v-slt-pc
             .                                            
                    
          if v-Cnt = 1 then v-Cnt-Chk = v-Cnt-Chk + 1.      
      end.   
end.

MESSAGE "Успешно. Установлена ставка НДС и сумма НДС для " v-Cnt-Chk " чеков. "
VIEW-AS ALERT-BOX.


