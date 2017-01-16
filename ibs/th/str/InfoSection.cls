 
/*------------------------------------------------------------------------
   File        : InfoSection
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Thu Oct 08 20:06:08 MSK 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.str.*.

class ibs.th.str.InfoSection:
  
  define property CarVol as decimal no-undo
    get.
    set.

  define property Tests as character no-undo
    get.
    set.

  define property CertifFuel as character no-undo
    get.
    set.

  define property NormDoc as character no-undo
    get.
    set.

  define property NumPassport as character no-undo
    get.
    set.

  define property ValidityCertif as character no-undo
    get.
    set.
	
  define property PassportPlotn as character no-undo
    get.
    set.

  define property DatePovPlotn as date no-undo
    get.
    set.

  define property NumPlotn as character no-undo
    get.
    set.

  define property DateStart as date no-undo
    get.
    set.

  define property TimeStart as integer no-undo
    get.
    set.

  define property DateEnd as date no-undo
    get.
    set.

  define property TimeEnd as integer no-undo
    get.
    set.

  define property TankVol as decimal no-undo
    get.
    set.

  define property TankTemp as decimal no-undo
    get.
    set.

  define property TankWater as decimal no-undo
    get.
    set.

  define property TankDensity as decimal no-undo
    get.
    set.

  define property TankWeight as decimal no-undo
    get.
    set.

  define property Mouth as decimal no-undo
    get.
    set.

  define property ABTarir as decimal no-undo
    get.
    set.

  define property Diameter as character no-undo
    get.
    set.

  define property PlaceSi as integer no-undo
    get.
    set.

  define property TankDensityPomi as decimal no-undo
    get.
    set.

  define property TankVolPomi as decimal no-undo
    get.
    set.

  define property DensTemp as decimal no-undo
    get.
    set.

  define property SectionName as character no-undo
    get.
    set.

  define property DocQnty as decimal no-undo
    get.
    set.

  define property DocDensity as decimal no-undo
    get.
    set.

  define property FactDensity as decimal no-undo
    get.
    set.

  define property FactQnty as decimal no-undo
    get.
    set.

  define property FactKgQnty as decimal no-undo
    get.
    set.
    
  define property CliQnty as decimal no-undo
    get.
    set.

  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
		
  constructor InfoSection (  ):
	  
		
  end constructor.

	
	
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public void SetProp( input inAttrCode as character,  input inAttrValue as character ):
		
    case inAttrCode:
      when 'car-vol' then 
        do:
          assign
            CarVol = decimal (inAttrValue) no-error.
        end.
      when 'tests' then 
        do:
          assign
            Tests = inAttrValue no-error.
        end.
      when 'certif-fuel' then
        do:
          assign
            CertifFuel = inAttrValue .
        end.
      when 'norm-doc' then 
        do:
          assign
            NormDoc = inAttrValue no-error.
        end.
      when 'num-passport' then 
        do:
          assign
            NumPassport = inAttrValue no-error.
        end.
      when 'validity-certif' then 
        do:
          assign
            ValidityCertif = inAttrValue no-error.
        end.
      when 'passport-plotn' then 
        do:
          assign
            PassportPlotn = inAttrValue no-error.
        end.
      when 'place-si' then 
        do:
          assign
            PlaceSi = integer (inAttrValue) no-error.
        end.
      when 'date-pov-plotn' then 
        do:
          assign
            DatePovPlotn = date (inAttrValue) no-error.
        end.
      when 'num-plotn' then 
        do:
          assign
            NumPlotn = inAttrValue no-error.
        end.
      when 'date-start' then 
        do:
          assign
            DateStart = date (inAttrValue) no-error.
        end.
      when 'time-start' then 
        do:
          assign
            TimeStart = integer (inAttrValue) no-error.
        end.
      when 'date-end' then 
        do:
          assign
            DateEnd = date (inAttrValue) no-error.
        end.
      when 'time-end' then 
        do:
          assign
            TimeEnd = integer (inAttrValue) no-error.
        end.
      when 'tank-vol' then 
        do:
          assign
            TankVol = decimal (inAttrValue) no-error.
        end.
      when 'tank-temp' then 
        do:
          assign
            TankTemp = decimal (inAttrValue) no-error.
        end.
      when 'tank-water' then 
        do:
          assign
            TankWater = decimal (inAttrValue) no-error.
        end.
      when 'tank-density' then 
        do:
          assign
            TankDensity = decimal (inAttrValue) 
          no-error.
        end.
      when 'tank-weight' then 
        do:
          assign
            TankWeight = decimal (inAttrValue) no-error.
        end.
      when 'mouth' then 
        do:
          assign
            Mouth = decimal (inAttrValue) no-error.
        end.
      when 'a-b-tarir' then 
        do:
          assign
            ABTarir = decimal (inAttrValue) no-error.
        end.
      when 'diameter' then 
        do:
          assign
            Diameter =  (inAttrValue) no-error.
        end.
      when 'tank-density-pomi' then 
        do:
          assign
            TankDensityPomi = decimal (inAttrValue) no-error.
        end.
      when 'tank-vol-pomi' then 
        do:
          assign
            TankVolPomi = decimal (inAttrValue) no-error.
        end.
      when 'dens-temp' then 
        do:
          assign
            DensTemp = decimal (inAttrValue) no-error.
        end.
      when 'section-name' then 
        do:
          assign
            SectionName = inAttrValue no-error.
        end.
      when 'doc-qnty' then 
        do:
          assign
            DocQnty = decimal (inAttrValue) no-error.
        end.
      when 'fact-qnty' then 
        do:
          assign
            FactQnty = decimal (inAttrValue) 
            CliQnty = DocDensity * FactQnty 
            FactKgQnty = FactQnty * FactDensity no-error.
        end.
      when 'doc-dens' then 
        do:
          assign
            DocDensity = decimal (inAttrValue) 
            CliQnty = DocDensity * FactQnty no-error.
        end.
      when 'fact-dens' then 
        do:
          assign
            FactDensity = decimal (inAttrValue) 
            FactKgQnty = FactQnty * FactDensity no-error.
        end.
        
    end case.
		

  end method.    

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  destructor public InfoSection ( ):


  end destructor.
   

end class.