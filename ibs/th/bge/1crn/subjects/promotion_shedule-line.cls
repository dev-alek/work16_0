 
 /*------------------------------------------------------------------------
    File        : price-doc_gds-sale
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : SSlivenko
    Created     : Fri Nov 03 13:58:05 AST 2017
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.


class ibs.th.bge.1crn.subjects.promotion_shedule-line inherits ibs.th.bge.1crn.subjects.asubject: 
  define property day_      as character    no-undo get. private set.
  define property strt-time as character    no-undo get. private set.  
  define property end-time  as character    no-undo get. private set.
  
  define override property InitTag as character no-undo init "schedule-line"
    get.
    
  method override protected void SetPropProtected (inTag as char, inValue as char) :
     case inTag:     
      when "day" then 
        do:
          assign 
            day_ = inValue .
        end.
      when "strt-time" then 
        do:
          assign 
            strt-time = inValue.
        end.
      when "end-time" then 
        do:
          assign 
            end-time = inValue.
        end.
    end case.
  end method.
  
  method override protected void CheckData ():
    def var v-str as char no-undo.
    
    assign
      v-str = "day" when day_ = ?
      v-str = v-str + ",strt-time" when strt-time = ?
      v-str = v-str + ",end-time" when end-time = ?
    .
    v-str = trim (v-str, ",").
    
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("“еги &1 не могут иметь неопределное значение", v-str)).
  
  end method .
      
  method override protected void ClearSub():
    assign
        day_ = ?
        strt-time = ?
        end-time = ?
    .    
  end method .   

end class.