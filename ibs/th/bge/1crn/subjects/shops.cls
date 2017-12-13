/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных shops (АЗК/АЗС) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.shops: 

  define property code_ as character no-undo
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
  define property frm-code as character no-undo
    get.
    set.
  define property grp-code as character no-undo
    get.
    set.
  define property address as character no-undo
    get.
    set.
  define property tel as character no-undo
    get.
    set.
  define property director as character no-undo
    get.
    set.
  define property accr as character no-undo
    get.
    set.

end class.