 
 /*------------------------------------------------------------------------
    File        : edoctype
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Thu Mar 05 21:50:33 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.sys.objth.
using ibs.th.gbl.propmap.
using ibs.th.gbl.map.mapstring.
using ibs.th.gbl.TypeMap.


class ibs.th.str.utd.edoctype inherits TypeMap: 

  define public property  UTD  as class propmap no-undo get.  protected set.
  define public property  Introduce   as class propmap no-undo get.  protected set.
  define public property  Receipt  as class propmap no-undo get.  protected set.
  define public property  UCD  as class propmap no-undo get.  protected set.
  define public property  returns  as class propmap no-undo get.  protected set.
  define public property  AKT  as class propmap no-undo get.  protected set.
/*  define public property  AKTNoMark  as class propmap no-undo get.  protected set.*/
  define public property  EDoc         as class propmap no-undo get.  protected set.
  define public property  LK_RECEIPT   as class propmap no-undo get.  protected set.

   
  constructor public edoctype ():
    super().
    UTD       = crProp(1, "UTD", "УПД").
    Introduce = crProp(2, "Introduce", "Первоначальный ввод КМ").
    Receipt   = crProp(3, "receipt", "Списание (выбытие из оборота)").
    UCD       = crProp(4, "UСD", "УКД").
    Returns   = crProp(5, "return", "Возврат поставщику").
    AKT       = crProp(6, "akt", "Акт приема").
/*    AKTNoMark = crProp(8, "aktnomark", "Акт приема немаркированной продукции").*/
    EDoc      = crProp(7, "EDoc", "еУПД").
    LK_RECEIPT = crProp(9, "LK_RECEIPT", "Вывод из оборота").
  end.


end class.