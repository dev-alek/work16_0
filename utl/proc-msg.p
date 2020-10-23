/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сообщение в отдельной сессии.

Автор: Морозов Александр Сергеевич
Дата создания: 10/14/20
Author: Alexandr Morozov
Creation date: 20/14/20

*/

define input parameter p-msg as character no-undo.

def var v-file-name as character no-undo.

v-file-name = string (guid(generate-uuid)) + ".txt".
output to value (v-file-name).
export p-msg. 
output close.
file-info:file-name = (v-file-name).    
os-command no-wait value (search ("bin/prowin32.exe") + " -p " + search ("utl/msg.p") + ' -param "FullFileName?' + file-info:full-pathname + '"').