/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Коллекция Сущностей TH товар меркурия


Автор: Морозов Александр Сергеевич
Дата создания: 04/23/18
Author: Morozov Alexandr
Creation date: 04/23/18

 
*/

using Progress.Lang.*.
using ibs.th.gbl.collection.*.
using ibs.th.str.mercury.*.


class ibs.th.str.mercury.gdsmercsubs inherits asubjects: 
  
  define property GdsMercsubsCurr as class gdsmercsub no-undo
    get:
      return cast (SubjectObjCurr, gdsmercsub).
    end.

end class.
