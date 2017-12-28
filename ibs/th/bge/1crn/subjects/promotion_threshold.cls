 
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


class ibs.th.bge.1crn.subjects.promotion_threshold inherits ibs.th.bge.1crn.subjects.asubject: 
  define property value_      as decimal    no-undo get. private set.
  define property dscnt       as decimal    no-undo get. private set.  
  
  define override property InitTag as character no-undo init "threshold"
    get.
    
  method override protected void SetPropProtected (inTag as char, inValue as char) :
     case inTag:     
      when "value" then 
        do:
          assign 
            value_ = decimal(inValue) .
        end.
      when "dscnt" then 
        do:
          assign 
            dscnt = decimal(inValue) .
        end.
    end case.
  end method.
  
  method override protected void CheckData ():
    def var v-str as char no-undo.
    
    assign
      v-str = "value" when value_ = ?
      v-str = v-str + ",dscnt" when dscnt = ?
    .
    v-str = trim (v-str, ",").
    
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("“еги &1 не могут иметь неопределное значение", v-str)).
  
  end method .
      
  method override protected void ClearSub():
    assign
        value_ = ?
        dscnt = ?
    .    
  end method .   

end class.