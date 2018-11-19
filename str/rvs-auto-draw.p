/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Автоматическое создание контрольной сверки
АВТОМАТИЧЕСКИЙ ОПРОС ТРК ОТКЛЮЧЕН, ТАК КАК КОЛОНКИ ВСТАЮТ ЕСЛИ ОПРОС ИДЕТ ВО ВРЕМЯ НАЛИВА

Автор: Уханов Дмитрий Юрьевич
Дата создания: 11/29/06
Author: Dmitry Ukhanov
Creation date: 11/29/06

Автор1: Булгаков Андрей Николаевич
Дата создания1: 11/28/05

*/

define input  parameter iUtil as class ibs.th.utl.method-for-draw-utility no-undo.

define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Автоматическое создание контрольной сверки":U.

{ cmp/vssrevis.i }
{ adm/auto-def.i new }

run adm/autoinit.p ("","").
subscribe   to "RvsParam" anywhere run-procedure "ParamRvs".
subscribe   to "getObjList" anywhere run-procedure "ObjList".
run str/rvs-auto.p (iUtil:parparentproc,this-procedure,this-procedure,ibs.th.gbl.gbl-var:g#db-num,?,?,ibs.th.gbl.gbl-var:g#db-num).
unsubscribe to "getObjList".
unsubscribe to "RvsParam".

procedure ObjList:
   define output parameter oAnswer as char no-undo.
   oAnswer = substitute("&1*&2",iUtil:Obj-type,iUtil:Obj-code).
end procedure. 
procedure ParamRvs:
   define output parameter oAnswer as char no-undo.
   // нулевая сверка 
   oAnswer = "yes".
end procedure.