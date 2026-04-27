block-level on error undo, throw.
/*

Вывод лога по проблемным товарам с НДС 22%
Автор: Ростовцев Александр
Дата создания: 14/01/26
Author: Rostovtsev Aleksandr
Creation date: 14/01/26

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
{ cmp/library.i  }
{ trg/factord.i }

define variable p-db-num      as integer   no-undo .
define variable p-from-db-num as integer   no-undo .
define variable p-file-num    as integer   no-undo .
define variable v-is-petrol   as logical   no-undo.
define variable v-is-pieces   as logical   no-undo.
define variable v-res         as character no-undo.
define variable v-ok          as character no-undo.
define variable nws-exch-dir  as character no-undo .
define variable v-file        as character no-undo .
define variable v-file-name   as character no-undo .
define variable v-file-logs   as character no-undo .
define stream sProt.

define buffer buf_goods for ub.goods .
define buffer buf_bar-code for ub.bar-code .
define buffer buf_prod-bc for ub.prod-bc .

get-key-value section "news"
                  key "nws-exch-dir"
                value nws-exch-dir.
                
find first sys-ctrl no-lock .   

v-file-name = "utl_2205_" + string(sys-ctrl.db-num) + ".txt".
v-file = nws-exch-dir + chr(92) + string(sys-ctrl.db-num, "999") + "-000" 
                      + chr(92) + v-file-name .
v-file-logs = "C:\Trade_House16x\Logs\" + v-file-name.

Output stream sProt to value(v-file).

{utl/nds22corr.i}

output stream sProt close.

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