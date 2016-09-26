/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс содержащий структуру для создания конкретного объекта содержащий связку справки 1 и товара ЕГАИС и ее свойтсва (egais-info).

Автор: Морозов Александр Сергеевич
Дата создания: 15/03/16
Author: Alexandr Morozov
Creation date: 15/03/16

*/

using Progress.Lang.*.


class ibs.th.bge.egais.ExtFormF1Value: 
  
  define property CliRegIdOrigCli as character no-undo
    get.
    set.

  define property CliEgaisTypeOrigCli as character no-undo
    get.
    set.
  
  define property INNOrigCli as character no-undo
    get.
    set.
  
  define property KPPOrigCli as character no-undo
    get.
    set.
  
  define property FullNameOrigCli as character no-undo
    get.
    set.
  
  define property CountryOrigCli as character no-undo
    get.
    set.
    
  define property RegionOrigCli as character no-undo
    get.
    set.
  
  define property DescrOrigCli as character no-undo
    get.
    set.


  define property FormF1Code as character no-undo
    get.
    set.

  define property AlcCode as character no-undo
    get.
    set.

end class.