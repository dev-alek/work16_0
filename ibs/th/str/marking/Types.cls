 
 /*------------------------------------------------------------------------
    File        : mark
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : asmorozov
    Created     : Mon Feb 24 19:25:41 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.gbl.propmap.
using ibs.th.gbl.TypeMap.


class ibs.th.str.marking.Types inherits TypeMap:
  
  define public property  tabak as class propmap no-undo get.  protected set.
  define public property  shoes  as class propmap no-undo get.  protected set.
  define public property  perfume  as class propmap no-undo get.  protected set.
  define public property  industry as class propmap no-undo get.  protected set.
  define public property  tires as class propmap no-undo get.  protected set.
  define public property  apteka as class propmap no-undo get.  protected set.
  define public property  photo  as class propmap no-undo get.  protected set.
  define public property  milk as class propmap no-undo get.  protected set.
  define public property  water as class propmap no-undo get.  protected set.
  define public property  stiki as class propmap no-undo get.  protected set.
  define public property  milk-40 as class propmap no-undo get.  protected set.
  
  constructor public Types ():
    /* типы маркировки */
    super().
    tabak            = crProp(01,"tabak",     "Табачная продукция").
    shoes            = crProp(02,"shoes",     "Обувь").
    perfume          = crProp(03,"perfume",   "Духи и парфюмерия").
    industry         = crProp(04,"industry",  "Легпром").
    tires            = crProp(05,"tires","Шины").
    apteka           = crProp(06,"apteka","Лекарства").
    photo            = crProp(07,"photo","Фотокамеры/фотовспышки").
    milk             = crProp(08,"milk","Молочная продукция > 40").
    water            = crProp(09,"water","Упакованная вода").
    stiki            = crProp(10,"stiki","Стики").
    milk-40          = crProp(11,"milk-40","Молочная продукция <= 40").
    
    Unknow:Label_  = "Неизвестный тип маркировки.".
    
  end.
  
end class.