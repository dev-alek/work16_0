 
 /*------------------------------------------------------------------------
    File        : goods
    Purpose     : 
    Syntax      : 
    Description : Структура данных по товарам из 1С
    Author(s)   : SSlivenko
    Created     : Fri Oct 20 13:06:14 AST 2017
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.subjects from propath.
using ibs.th.bge.1crn.subjects.goods_barcode from propath.

class ibs.th.bge.1crn.subjects.goods inherits ibs.th.bge.1crn.subjects.asubject: 
  define property code_         as character    no-undo get. private set.
  define property del-l         as integer      no-undo get. private set.
  define property del-f         as integer      no-undo get. private set.
  define property grp-code      as character    no-undo get. private set.
  define property name_         as character    no-undo get. private set.
  define property label-name    as character    no-undo get. private set.
  define property chk-name      as character    no-undo get. private set.
  define property artic         as character    no-undo get. private set.
  define property unit-code     as character    no-undo get. private set.
  define property prod-code     as character    no-undo get. private set.
  define property wt            as decimal      no-undo get. private set.
  define property ms            as decimal      no-undo get. private set.
  define property gds-type      as character    no-undo get. private set.
  define property img           as longchar     no-undo get. private set.
  define property unit-spl-code as character    no-undo get. private set.
  define property unit-k        as decimal      no-undo get. private set.
  define property nds-code      as integer      no-undo get. private set.
  define property enbl-ne       as integer      no-undo get. private set.
  define property enbl-zc       as integer      no-undo get. private set.
  define property enbl-exc      as integer      no-undo get. private set.
  define property srvc-type     as integer      no-undo get. private set.
  define property fuel-type     as character    no-undo get. private set.
  define property max-dnsty     as decimal      no-undo get. private set.
  define property min-dnsty     as decimal      no-undo get. private set.
  define property pay-trk       as integer      no-undo get. private set.
  define property neu-z         as decimal      no-undo get. private set.
  define property neu-l         as decimal      no-undo get. private set.
  define property proteins      as decimal      no-undo get. private set.
  define property fats          as decimal      no-undo get. private set.
  define property carbohydrates as decimal      no-undo get. private set.
  define property calories      as decimal      no-undo get. private set.
  define property vad-gds       as integer      no-undo get. private set.
  define property barcode       as subjects     no-undo get. private set.
  
  
  define override property InitTag as character no-undo init "good"
    get. 
    
  constructor public goods ():
    InitListTag = "barcode".
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
      when "grp-code" then 
        do:
          assign 
            grp-code = inValue.
        end.
      when "name" then 
        do:
          assign 
            name_ = inValue.
        end.
      when "label-name" then 
        do:
          assign 
            label-name = inValue.
        end.
      when "chk-name" then 
        do:
          assign 
            chk-name = inValue.
        end.
      when "artic" then 
        do:
          assign 
            artic = inValue.
        end.
      when "unit-code" then 
        do:
          assign 
            unit-code = inValue.
        end.
      when "prod-code" then 
        do:
          assign 
            prod-code = inValue.
        end.
      when "wt" then 
        do:
          assign 
            wt = decimal(inValue).
        end.
      when "ms" then 
        do:
          assign 
            ms = decimal(inValue).
        end.
      when "gds-type" then 
        do:
          assign 
            gds-type = inValue.
        end.
      when "img" then 
        do:
          assign 
            img = inValue.
        end.
      when "unit-spl-code" then 
        do:
          assign 
            unit-spl-code = inValue.
        end.
      when "unit-k" then 
        do:
          assign 
            unit-k = decimal(inValue).
        end.
      when "nds-code" then 
        do:
          assign 
            nds-code = integer(inValue).
        end.
      when "enbl-ne" then 
        do:
          assign 
            enbl-ne = integer(inValue).
        end.
      when "enbl-zc" then 
        do:
          assign 
            enbl-zc = integer(inValue).
        end.
      when "enbl-exc" then 
        do:
          assign 
            enbl-exc = integer(inValue).
        end.
      when "srvc-type" then 
        do:
          assign 
            srvc-type = integer(inValue).
        end.
      when "fuel-type" then 
        do:
          assign 
            fuel-type = inValue.
        end.
      when "max-dnsty" then 
        do:
          assign 
            max-dnsty = decimal(inValue).
        end.
      when "min-dnsty" then 
        do:
          assign 
            min-dnsty = decimal(inValue).
        end.
      when "pay-trk" then 
        do:
          assign 
            pay-trk = integer(inValue).
        end.
      when "neu-z" then 
        do:
          assign 
            neu-z = decimal(inValue).
        end.
      when "neu-l" then 
        do:
          assign 
            neu-l = decimal(inValue).
        end.
      when "proteins" then 
        do:
          assign 
            proteins = decimal(inValue).
        end.
      when "fats" then 
        do:
          assign 
            fats = decimal(inValue).
        end.
      when "carbohydrates" then 
        do:
          assign 
            carbohydrates = decimal(inValue).
        end.
      when "calories" then 
        do:
          assign 
            calories = decimal(inValue).
        end.
      when "vad-gds" then 
        do:
          assign 
            vad-gds = integer(inValue).
        end.
    end case.
  end method.
  
  method override protected void SetPropProtected(SubsObj as subjects):

    case SubsObj:InitTag:   
      when "barcode" then
        do:
          barcode = SubsObj.            
        end.
    end case.

  end.
  
  method override protected void CheckData ():
    def var v-str as char no-undo.
    
    assign
      v-str = "code" when code_ = ?
      v-str = v-str + ",grp-code" when grp-code = ?
      v-str = v-str + ",name" when name_ = ?
      v-str = v-str + ",label-name" when label-name = ?
      v-str = v-str + ",chk-name" when label-name = ?
    .
    v-str = trim (v-str, ",").
    
    if v-str > ''
    then 
      undo, throw new Progress.Lang.AppError( substitute ("Теги &1 не могут иметь неопределное значение", v-str)).
        
  end method .
      
  method override protected void ClearSub():
    assign
        code_         = ?
        del-l         = ?
        del-f         = ?
        grp-code      = ?
        name_         = ?
        label-name    = ?
        chk-name      = ?
        artic         = ?
        unit-code     = ?
        prod-code     = ?
        wt            = ?
        ms            = ?
        gds-type      = ?
        img           = ?
        unit-spl-code = ?
        unit-k        = ?
        nds-code      = ?
        enbl-ne       = ?
        enbl-zc       = ?
        enbl-exc      = ?
        srvc-type     = ?
        fuel-type     = ?
        max-dnsty     = ?
        min-dnsty     = ?
        pay-trk       = ?
        neu-z         = ?
        neu-l         = ? 
        proteins      = ?
        fats          = ?
        carbohydrates = ?
        calories      = ?
        vad-gds       = ?
    .   
    delete object barcode no-error . 
  end method .    
      
end class.