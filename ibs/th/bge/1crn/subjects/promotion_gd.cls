 
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


class ibs.th.bge.1crn.subjects.promotion_gd inherits ibs.th.bge.1crn.subjects.asubject: 
  define property gd-code      as character    no-undo get. private set.
  
  define override property InitTag as character no-undo init "gd"
    get.
    
  method override protected void SetPropProtected (inTag as char, inValue as char) :
     case inTag:     
      when "gd-code" then 
        do:
          assign 
            gd-code = inValue .
        end.
    end case.
  end method.
  
  method override protected void CheckData ():
    def var v-str as char no-undo.
    
    assign
      v-str = "gd-code" when gd-code = ?
    .
    v-str = trim (v-str, ",").
    
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("“еги &1 не могут иметь неопределное значение", v-str)).
  
  end method .
      
  method override protected void ClearSub():
    assign
        gd-code = ?
    .    
  end method .   

end class.