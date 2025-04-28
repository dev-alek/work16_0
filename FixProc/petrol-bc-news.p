block-level on error undo, throw.
/*

$Revision: 43079881fc1c, 3306, rls $
$Author: Rostovtsev $
$Date: 2023/05/19 13:37:06 $
$Workfile: petrol-bc-news.p $
$Archive: FixProc/petrol-bc-news.p $

Утилита включения короткого бар-кода топлива по новостям
Автор: Ростовцев Александр
Дата создания: 09/11/24
Author: R0stovtsev Aleksandr
Creation date: 09/11/24

*/

define input parameter parparentproc    as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle     as handle no-undo .
define input parameter p-parameter      as character no-undo .

define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".

{ cmp/vssrevis.i }
{ cmp/trg-def.i  } 
{ cmp/str-glbl.i }
{ str/lib-trn.i  }
{ nws/bintrnpr.i }

define variable p-db-num      as integer   no-undo .
define variable p-from-db-num as integer   no-undo .
define variable p-file-num    as integer   no-undo .
define variable v-is-petrol   as logical   no-undo.
define variable v-is-pieces   as logical   no-undo.
define variable v-res         as character no-undo.
define variable v-ok          as character no-undo.
define variable nws-exch-dir  as character no-undo .
define variable v-file        as character no-undo .
define variable v-file-logs   as character no-undo .
define stream sPut.

define buffer buf_goods for ub.goods .
define buffer buf_bar-code for ub.bar-code .
define buffer buf_prod-bc for ub.prod-bc .

assign
   p-db-num             = integer(entry(1, p-parameter, {&delim-par}))
   p-from-db-num        = integer(entry(2, p-parameter, {&delim-par}))
   p-file-num           = integer(entry(3, p-parameter, {&delim-par}))
no-error.
if error-status:error then do:
  return error substitute("Ошибка передачи входных параметров в процедуру &1&2&3&2"
                       , (this-procedure:filename)
                       , {&new-line}
                       , error-status:get-message(1)).
end.

get-key-value section "news"
                  key "nws-exch-dir"
                value nws-exch-dir.
                
find first sys-ctrl no-lock .   

v-file = nws-exch-dir + chr(92) + string(sys-ctrl.db-num, "999") + "-000" 
                      + chr(92) + "bar_active.txt" .
v-file-logs = "C:\Trade_House16x\Logs\bar_active_full.txt".

Output stream sPut to value(v-file).

v-res = substitute(
        "&1;&2 &3",
        p-db-num, string(today, "99/99/9999"), string(time, "HH:MM:SS")
      ).
    
for each buf_goods no-lock:
   { str/is-petrl.i
      buf_goods.artic
      buf_goods.prod-type
      buf_goods.prod-code
      v-is-petrol
      v-is-pieces
   }
   if v-is-petrol = yes then do:
     v-ok = "".
     for each buf_bar-code where
              buf_bar-code.gds-code = buf_goods.gds-code
         no-lock,
         each buf_prod-bc where
              buf_prod-bc.b-code = buf_bar-code.b-code
         exclusive-lock:
       if length(buf_prod-bc.b-str) <= 2 then
       do:
          buf_prod-bc.bc-on = true.
          validate buf_prod-bc no-error.
          if error-status:error then do:
            v-ok = "ОШИБКА:" + error-status:get-message(1).  
          end.
          else v-ok = "ОК".
          put stream sPut unformatted 
            substitute(
              "&1;код товара:&2; короткий бар-код:&3; &4",
              v-res,buf_goods.gds-code, buf_prod-bc.b-str, v-ok
            )
            skip
          .
       end.     
     end.
     if v-ok = "" then
     do:
       put stream sPut unformatted 
         substitute(
           "&1;код товара:&2; коротких бар-кодов нет на АЗК", 
           v-res, buf_goods.gds-code
         ) skip
       .
     end.  
   end.
end.    

output stream sPut close.

if search(v-file) <> ? then
do:
  os-copy value(v-file) value(v-file-logs).
  if search(v-file-logs) <> ? then
    v-res = v-res + "; OK".
  else
    v-res = v-res + "; Файл сформирован новостях, но не скопирован в C:\Trade_House16x\Logs".
end.
else
  v-res = v-res + "; Файл не сформирован".

run ext-file-par-write-and-send (
      input  p-db-num
      ,input  p-from-db-num
      ,input  p-file-num
      ,input -1 /*p-param-num      */
      ,input {&type-char} /*p-value-type */
      ,input "Результат" /* p-value-name */
      ,input v-res       /*p-value-char */
      ,input ? /*p-value-date */
      ,input 0 /* p-value-integer */
      ,input 0 /* p-value-decimal */
      ,input no /*p-value-logical */
      ,input yes /*p-send*/
      ,input string(g#news-source-db)
   ) no-error .

return v-res.