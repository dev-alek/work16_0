/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт справочных данных для АТД клиента

Автор: Курбет Антон
Дата создания: 23/07/18
Author: Kurbet Anton
Creation date: 23/07/18

*/
using ibs.th.bge.atd.*.

define input parameter parparentproc    as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экспорт справочных данных для АТД клиента".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }

{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }

define variable vExp       as class dict-atd-exp no-undo.
define variable vDir       as character no-undo.
define variable vInitDir   as character no-undo.

do on error undo, return error return-value:
   
   vInitDir = os-getenv("userprofile").
   system-dialog get-dir vDir initial-dir vInitDir title "Папка для экспорта".
   if vDir > "" then do:
      vExp = new dict-atd-exp(vDir,
                              v-cntxt-db-num,
                              v-cntxt-obj-type,
                              v-cntxt-obj-code).
      vExp:RunFileTask().
      delete object vExp. 
   end.
end. 