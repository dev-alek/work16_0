/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сущность TH bpa


Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/

using Progress.Lang.*.
using ibs.th.gbl.collection.*.
USING ibs.th.ref.bpa.*.

class ibs.th.ref.bpa.BpaActionsSubs inherits asubjects: 
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Объект платежных агентов/операторов.". 

define property bpaActionObjCurr as class bpaActionSub
get:
  return cast (SubjectObjCurr, bpaActionSub) .
end.  
  
end class.