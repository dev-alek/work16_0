/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс содержащий структуру для создания конкретного объекта содержащий связку и ее свойтсва (egais-info).

Автор: Морозов Александр Сергеевич
Дата создания: 15/03/16
Author: Alexandr Morozov
Creation date: 15/03/16

*/

using Progress.Lang.*.


class ibs.th.bge.egais.ExtGdsValue: 
  
  define property CliRegIdProd as character no-undo
    get.
    set.
  
  define property CliEgaisTypeProd as character no-undo
    get.
    set.
  
  define property INNProd as character no-undo
    get.
    set.
  
  define property KPPProd as character no-undo
    get.
    set.
  
  define property FullNameProd as character no-undo
    get.
    set.
  
  define property CountryProd as character no-undo
    get.
    set.
    
  define property RegionProd as character no-undo
    get.
    set.
  
  define property DescrProd as character no-undo
    get.
    set.

  define property CliRegIdImpor as character no-undo
    get.
    set.

  define property CliEgaisTypeImpor as character no-undo
    get.
    set.
  
  define property INNImpor as character no-undo
    get.
    set.
  
  define property KPPImpor as character no-undo
    get.
    set.
  
  define property FullNameImpor as character no-undo
    get.
    set.
  
  define property CountryImpor as character no-undo
    get.
    set.
    
  define property RegionImpor as character no-undo
    get.
    set.
  
  define property DescrImpor as character no-undo
    get.
    set.

  define property FullNameGds as character no-undo
    get.
    set.

  define property GdsCode as integer no-undo init 0
    get.
    set.

  define property AlcCode as character no-undo
    get.
    set.

end class.