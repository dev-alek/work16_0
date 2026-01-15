/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита для BTS-2103. Исправляет размазывание оплаты по чеку 244/4860839 .

Автор: Белова М.М.
Дата создания: 19.11.2025
Author: 
Creation date: 

*/

{ utl/runpro.i }

define buffer buf_chk-discnt  for ub.chk-discnt. 

define variable vOk   as logical no-undo.

do transaction:
    
    for each buf_chk-discnt exclusive-lock
        where buf_chk-discnt.doc-code = "244/4860839"  
        and   buf_chk-discnt.record-type = 10
    :        
        if buf_chk-discnt.line-num = 5 then
           assign
              buf_chk-discnt.discnt-value-abs = 149.19
              buf_chk-discnt.discnt-value-pcnt = 1
              .               
        else  
           assign
              buf_chk-discnt.discnt-value-abs = 3.5
              buf_chk-discnt.discnt-value-pcnt = 1
              .
        vOk = yes.      
    end.
          
end.    

if vOk then
MESSAGE "Успешно. Распределение платежей по чеку 244/4860839 сконвертированы."
VIEW-AS ALERT-BOX.


