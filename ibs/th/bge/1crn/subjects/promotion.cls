 
 /*------------------------------------------------------------------------
    File        : price-doc-imp
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : SSlivenko
    Created     : Fri Nov 03 13:27:25 AST 2017
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.subjects from propath.
using ibs.th.bge.1crn.subjects.promotion_shedule-line from propath.
using ibs.th.bge.1crn.subjects.promotion_threshold from propath.
using ibs.th.bge.1crn.subjects.promotion_gd from propath.
using ibs.th.bge.1crn.subjects.promotion from propath.


class ibs.th.bge.1crn.subjects.promotion inherits ibs.th.bge.1crn.subjects.asubject: 
  
  define property code_         as character    no-undo get. private set.
  define property del-l         as integer      no-undo get. private set.
  define property del-f         as integer      no-undo get. private set.
  define property status_       as integer      no-undo get. private set.
  define property name_         as character    no-undo get. private set.
  define property strt-date     as character    no-undo get. private set.
  define property end-date      as character    no-undo get. private set.
  define property dscnt-type    as integer      no-undo get. private set.
  define property dscnt-value-type   as integer no-undo get. private set.
  define property pmnt-types    as character    no-undo get. private set.
  define property sch-code      as character    no-undo get. private set.
  
  define property shedule    as subjects no-undo get. 
    private set.
  
  define property thresholds      as subjects no-undo get. 
    private set.
    
  define property gds      as subjects no-undo get. 
    private set.  
   
  define override property InitTag as character no-undo init "promotion"
    get.
  
  constructor public promotion ():
    InitListTag = "thresholds,gds,schedule".
  end constructor.
  
  method override protected void SetPropProtected (inTag as char, inValue as char) :
     case inTag:      
      when "code" then 
        do:
          assign 
            code_ = inValue .
        end.
      when "del-l" then 
        do:
          assign 
            del-l = integer (inValue).
        end.
      when "del-f" then 
        do:
          assign 
            del-f = integer (inValue).
        end.
      when "name" then 
        do:
          assign 
            name_ = inValue.
        end.
      when "status" then 
        do:
          assign 
            status_ = integer (inValue).
        end.
      when "strt-date" then 
        do:
          assign 
            strt-date = inValue.
        end.
      when "end-date" then 
        do:
          assign 
            end-date = inValue.
        end.
      when "dscnt-type" then 
        do:
          assign 
            dscnt-type = integer(inValue).
        end.
      when "dscnt-value-type" then 
        do:
          assign 
            dscnt-value-type = integer(inValue).
        end.
      when "pmnt-types" then 
        do:
          assign 
            pmnt-types = inValue.
        end.
      when "sch-code" then 
        do:
          assign 
            sch-code = inValue.
        end.
    end case.
  end method.

  method override protected void SetPropProtected(SubsObj as subjects):

    case SubsObj:InitTag:   
      when "thresholds" then
        do:
          thresholds = SubsObj.            
        end.
      when "gds" then
        do:
          gds = SubsObj.            
        end.
      when "schedule" then
        do:
          shedule = SubsObj.            
        end.
    end case.

  end.

  
  method override protected void CheckData ():
    def var v-str as char no-undo.
    
/*    assign                                             */
/*      v-str = "code" when code_ = ?                    */
/*      v-str = v-str + ",grp-code" when grp-code = ?    */
/*      v-str = v-str + ",name" when name_ = ?           */
/*      v-str = v-str + ",label-name" when label-name = ?*/
/*      v-str = v-str + ",chk-name" when label-name = ?  */
/*    .                                                  */
/*    v-str = trim (v-str, ",").                         */
    
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("“еги &1 не могут иметь неопределное значение", v-str)).
  
  end method .
  
  method override protected void ClearSub():
    assign
        code_           = ?
        del-l           = ?
        del-f           = ?
        name_           = ?
        strt-date       = ?
        end-date        = ?
        dscnt-type      = ?
        dscnt-value-type  = ?
        pmnt-types      = ?
        status_         = ?
        sch-code        = ?
    .
    delete object shedule no-error.
    delete object thresholds no-error.
    delete object gds no-error.
  end method .
    
end class.