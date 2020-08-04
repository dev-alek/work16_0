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

class ibs.th.str.mercury.vsdsubs inherits asubjects: 
  
  define property VsdObjCurr as class vsdsub no-undo 
    get:
      return cast (SubjectObjCurr, vsdsub).
    end.

end class.
