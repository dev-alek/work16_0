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
def var v-full-proc-name as character no-undo.

if search ("exe/msg.exe") <> ? then do:
	  v-full-proc-name = search ("exe/msg.exe").
	  os-command no-wait value (search ("exe/msg.exe") + " * " +  p-msg).
end.

else do:

v-file-name = string (guid(generate-uuid)) + ".txt".
output to value (v-file-name).
export p-msg. 
output close.
file-info:file-name = (v-file-name).    
if search ("utl/w-msg.r") <> ?
then do:
  v-full-proc-name = search ("utl/w-msg.r").
end.
else do:
  v-full-proc-name = search ("utl/w-msg.w").
end.

if v-full-proc-name = ?
then do:
  message "Файл не найден - utl/w-msg.w" view-as alert-box.
end.

os-command no-wait value (search ("bin/prowin32.exe") + " -p " + v-full-proc-name + ' -param "FullFileName?' + file-info:full-pathname + '"').

end.
