block-level on error undo, throw.
/*

$Revision: 89f1b7b46375, 2926, rls $
$Author: DRuban $
$Date: Пн ноя 22 19:49:14 2021 +0300 $
$Workfile: ThRun.p $
$Archive: runth/ThRun.p $


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