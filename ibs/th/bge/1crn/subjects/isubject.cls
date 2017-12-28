/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

инерфейс сущности 1С ERPRN

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.

interface ibs.th.bge.1crn.subjects.isubject:  
  
  define public property InitTag as character no-undo
    get.  
  method public void SetProp (inTag as char, inValue as char).
  
end interface.