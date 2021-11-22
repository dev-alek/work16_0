/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$


Автор: Рубан Дмитрий Андреевич
Дата создания: 13/10/2020

*/
 
/*session:system-alert-boxes = yes.
session:appl-alert-boxes = yes.
session:debug-alert = yes.*/
session:error-stack-trace=yes.
def var vprocname as char no-undo.
def var vdir      as char no-undo.
def var vi        as int  no-undo.

vprocname = search(this-procedure:name).
vprocname = replace(vprocname,"/","\").
do vi = 1 to num-entries(vprocname,"\") - 2 .
   vdir = vdir + "\" + entry(vi,vprocname,"\").
end.
vdir = substring(vdir,2).
propath = vdir + "," + propath.
run runth\runstart.p.