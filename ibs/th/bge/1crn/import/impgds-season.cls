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

class ibs.th.bge.1crn.import.impgds-season implements ibs.th.bge.1crn.import.iimpsubject:
  
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
		define buffer buf_gds-season for ub.gds-season .
    define variable objGds-season as class     gds-season no-undo.
    objGds-season = cast (subjectObj, gds-season).

		
    if objGds-season:del-f = 1
    or objGds-season:del-l = 1
    then
    do:
      find first buf_gds-season where buf_gds-season.sea-code = integer(objGds-season:Tbg-code) 
                                 and buf_gds-season.gds-code = integer(objGds-season:gds-code) no-error .
      if AVAILABLE buf_gds-season then
      do:
        delete buf_gds-season .
      end.  		
    end.
    else
    do:
      find first buf_season where buf_season.sea-code = integer(objGds-season:Tbg-code) no-error .
      if AVAILABLE buf_season then 
      do:
        find first buf_gds-season where buf_gds-season.sea-code = integer(objGds-season:Tbg-code) 
                                    and buf_gds-season.gds-code = integer(objGds-season:gds-code) no-error .
        if not available buf_gds-season
        then do :
          create buf_gds-season .
          assign
            buf_gds-season.db-num   = gbl-var:g#db-num
            buf_gds-season.sea-code = integer(objGds-season:Tbg-code)
            buf_gds-season.gds-code = integer(objGds-season:gds-code)
          .
        end .  
        assign buf_gds-season.min-stock = 0 .                          
      end.                                
      else 
      do:
        Msg = "Не найдена коллекция с кодом " + objGds-season:Tbg-code .
        return false .
      end.

      return true.

    end.
  end method.

end class.