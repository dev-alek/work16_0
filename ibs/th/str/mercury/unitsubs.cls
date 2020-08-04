/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Коллекция Сущностей TH ВСД


Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18


*/

using Progress.Lang.*.
using ibs.th.gbl.collection.*.
using ibs.th.str.mercury.*.


class ibs.th.str.mercury.unitsubs inherits asubjects: 
  
  define property UnitObjCurr as class unitsub no-undo
    get:
      return cast (SubjectObjCurr, unitsub).
    end.

end class.
