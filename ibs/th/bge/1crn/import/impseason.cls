/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных season из 1С

Автор: Александр Морозов
Дата создания: 26/09/17
Author: Morozov Alexandr
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.gbl.gbl-var.
using ibs.th.bge.1crn.subjects.*.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.impseason implements ibs.th.bge.1crn.import.iimpsubject:
  
  { cmp/str-glbl.i class }
  
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
		
		define buffer buf_season for ub.season .
    define variable objSeason as class     season no-undo.
    objSeason = cast (subjectObj, season).

		
    if objSeason:del-f = 1
    or objSeason:del-l = 1
    then
    do:
      find first buf_season where buf_season.sea-code = integer(objSeason:Tbg-code) no-error .
      if AVAILABLE buf_season then
      do:
        delete buf_season .
      end.  		
    end.
    else
    do:
      find first buf_season where buf_season.sea-code = integer(objSeason:Tbg-code) no-error .
      if AVAILABLE buf_season then 
      do:
        assign
          buf_season.sea-name = objSeason:Tb-name 
          buf_season.sea-month-1 = 0
          buf_season.sea-month-2 = 0
        .
      end.                                
      else 
      do:
        create buf_season .		
        assign
          buf_season.db-num   = gbl-var:g#db-num
          buf_season.sea-code = integer(objSeason:Tbg-code)
          buf_season.sea-name = objSeason:Tb-name
          buf_season.sea-month-1 = 0
          buf_season.sea-month-2 = 0
        .
      end.

      return true.

    end.
  end method.

end class.