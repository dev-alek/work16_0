/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита досылки недошедших файлов на кассу IBM-XML - запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/30/05
Author: Bakhtadze Natalya
Creation date: 10/30/05

*/

define input  parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Утилита досылки недошедших файлов на кассу IBM-XML - запуск".
{ cmp/vssrevis.i }

define variable v-dir-name as character no-undo .
define variable v-dir-type as character no-undo .
define variable v-can-write as logical   no-undo .

message
"Выберите каталог, в котором лежат файлы подлежащие пересылке на кассы IBM-XML"
view-as alert-box .
run gbl/dir-sel.p (
              output v-dir-name
             ,output v-dir-type
             ,output v-can-write ) no-error .
if error-status :error
or v-dir-name = '':u then return.



run str/diallog.w (
              input parparentproc
            , input this-procedure
            , input 'str/rsndxibm.p':U
            , input v-dir-name
            , input no
            , input 'Прервать'
            , input 'Досылка сформированных файлов на кассы IBM-XML') no-error .