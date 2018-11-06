 
/*------------------------------------------------------------------------
   File        : normwastsub
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Wed Oct 10 18:13:11 MSK 2018
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.ref.*.


class ibs.th.ref.normwastsub: 

  define property ParGdsOAttr as class ibs.th.ref.pargdsoattr no-undo get. set.

  define property NormalWastageWinter as decimal no-undo init 0 get. set. /*ест. убыль зимой*/
  define property NormalWastageSummer as decimal no-undo init 0 get. set. /*ест. убыль летом*/
  define property NormalWastageTransWinter as decimal no-undo init 0 get. set. /*ест. убыль зимой*/
  define property NormalWastageTransSummer as decimal no-undo init 0 get. set. /*ест. убыль летом*/
  define property NormalWastageDate as decimal no-undo init 0 get. set. /*ест. убыль на указанную дату если p-date не ?*/
  define property NormalWastageTransDate as decimal no-undo init 0 get. set. /*ест. убыль на указанную дату если p-date не ?*/

  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
  constructor public normwastsub (  ):
    
    ParGdsOAttr = new pargdsoattr ().
    
  end constructor.


end class.