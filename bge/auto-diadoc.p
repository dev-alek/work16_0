/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Работа с ФГИС меркурий

Автор: Сливенко Сергей
Дата создания: 05/28/18
Author: Slivenko Sergey
Creation date: 05/28/18

*/

{utl/asuncprocauto.i}

define input  parameter p-list-db       as character no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Работа с ФГИС Диадок".
{ cmp/vssrevis.i }
 
define variable mi as integer no-undo.
p-list-db = trim(p-list-db,",").
do mi = 1 to num-entries (p-list-db):
/*   vAsyncHelper:AsyncProc("Diadoc" +  string(mi),"utl/proc-diadoc", substitute("&1":U ,entry(mi,p-list-db)),1).*/
     run AddTask in this-procedure ("utl/proc-diadoc", substitute("&1":U ,entry(mi,p-list-db))).

end.

run waitproc(substitute("Получение данных из Диадок. По БД &1.", p-list-db)).

/* $Workfile$ end */