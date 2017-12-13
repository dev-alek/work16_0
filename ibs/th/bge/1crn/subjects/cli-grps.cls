/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных cli-grps (группы контрагентов) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.cli-grps: 

  define property code_ as character no-undo
    get. 
    set.
  define property upper-code as character no-undo
    get.
    set.
  define property del-l as integer no-undo 
    get. 
    set.
  define property del-f as integer no-undo 
    get. 
    set.
  define property name_ as character no-undo 
    get. 
    set.

end class.