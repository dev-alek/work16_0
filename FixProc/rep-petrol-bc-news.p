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
define variable v-obj-code    as integer   no-undo .
define variable v-is-petrol   as logical   no-undo.
define variable v-is-pieces   as logical   no-undo.
define variable v-res         as character no-undo.
define variable nws-exch-dir  as character no-undo .
define variable v-file        as character no-undo .
define variable v-file-logs   as character no-undo .
define stream sPut.

define buffer buf_clients for ub.clients .
define buffer buf_goods for ub.goods .
define buffer buf_gds-obj for ub.gds-obj .
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
                      + chr(92) + "bar_active_full.txt" .
v-file-logs = "C:\Trade_House16x\Logs\bar_active_full.txt".

for first buf_clients where
          buf_clients.db-num = sys-ctrl.db-num
      and buf_clients.obj-type = {&shop}
    no-lock:
  v-obj-code = buf_clients.obj-code.    
end.

Output stream sPut to value(v-file).

v-res = substitute(
        "&1 &2;&3",
        string(today, "99/99/9999"), string(time, "HH:MM:SS"), p-db-num
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
     FIND FIRST buf_gds-obj WHERE
                buf_gds-obj.obj-type  = {&shop}           
            AND buf_gds-obj.obj-code  = v-obj-code           
            AND buf_gds-obj.prod-type = buf_goods.prod-type
            AND buf_gds-obj.prod-code = buf_goods.prod-code
            AND buf_gds-obj.artic     = buf_goods.artic     
          NO-LOCK NO-ERROR.
       
     for each buf_bar-code where
              buf_bar-code.gds-code = buf_goods.gds-code
         no-lock,
         each buf_prod-bc where
              buf_prod-bc.b-code = buf_bar-code.b-code
         exclusive-lock:
       if length(buf_prod-bc.b-str) <= 2 then
       do:
          put stream sPut unformatted 
            substitute(
              "&1;&2;&3;&4;&5",
              v-res, buf_goods.gds-code, if avail buf_gds-obj then buf_gds-obj.fact-qnty else 0
              ,buf_prod-bc.b-str, if buf_prod-bc.bc-on then 1 else 0
            )
            skip
          .
       end.     
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
    v-res = v-res + "; Файл сформирован в новостях, но не скопирован в C:\Trade_House16x\Logs".
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