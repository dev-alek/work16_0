/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных clients (контрагенты) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.clients: 

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
  define property full-name as character no-undo
    get. 
    set.
  define property grp-code as character no-undo
    get.
    set.
  define property city as character no-undo
    get.
    set.
  define property ind as character no-undo
    get.
    set.
  define property inn as character no-undo
    get.
    set.
  define property kpp as character no-undo
    get.
    set.
  define property agnt as character no-undo
    get.
    set.
  define property post-adr as character no-undo
    get.
    set.
  define property e-mail as character no-undo
    get.
    set.
  define property leg-adr as character no-undo
    get.
    set.
  define property okpo as character no-undo
    get.
    set.

end class.