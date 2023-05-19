/*
  $Revision:$
  $Author:$
  $Date:$
  $Workfile:$
  $Archive:$
  
  Автор: Рубан Дмитрий Андреевич 
  Дата создания: 9 янв. 2023 г.
  Author:  Ruban Dmitriy Andreevich
  Creation date: 9 янв. 2023 г.
  
  */

using Progress.Lang.*.
using ibs.th.gbl.propmap.
using ibs.th.gbl.TypeMap.


class ibs.th.str.marking.Types inherits TypeMap:
  define override public property vss-revision    as character no-undo init "$Revision:$":U get .
  define override public property vss-author      as character no-undo init "$Author:$":U get.
  define override public property vss-date        as character no-undo init "$Date:$":U get.
  define override public property vss-workfile    as character no-undo init "$Workfile:$":U get.
  define override public property vss-archive     as character no-undo init "$Archive:$":U get.
  define override public property vss-description as character no-undo init "Типы маркировки" get.
   
  define public property  tabak      as class propmap no-undo get.  protected set.
  define public property  shoes      as class propmap no-undo get.  protected set.
  define public property  perfume    as class propmap no-undo get.  protected set.
  define public property  industry   as class propmap no-undo get.  protected set.
  define public property  tires      as class propmap no-undo get.  protected set.
  define public property  apteka     as class propmap no-undo get.  protected set.
  define public property  photo      as class propmap no-undo get.  protected set.
  define public property  milk       as class propmap no-undo get.  protected set.
  define public property  water      as class propmap no-undo get.  protected set.
  define public property  stiki      as class propmap no-undo get.  protected set.
  define public property  milk-40    as class propmap no-undo get.  protected set.
  define public property  NSJ        as class propmap no-undo get.  protected set.
  define public property  Bad        as class propmap no-undo get.  protected set.
  define public property  antiseptic as class propmap no-undo get.  protected set.
  
  constructor public Types ():
    /* типы маркировки */
    super().
    tabak            = crProp(01,"tabak",             "Табачная продукция").
    shoes            = crProp(02,"shoes",             "Обувь").
    perfume          = crProp(03,"perfume",           "Духи и парфюмерия").
    industry         = crProp(04,"industry",          "Легпром").
    tires            = crProp(05,"tires",             "Шины").
    apteka           = crProp(06,"apteka",            "Лекарства").
    photo            = crProp(07,"photo",             "Фотокамеры/фотовспышки").
    milk             = crProp(08,"milk",              "Молочная продукция > 40").
    water            = crProp(09,"water",             "Упакованная вода").
    stiki            = crProp(10,"stiki",             "Стики").
    milk-40          = crProp(11,"milk-40",           "Молочная продукция <= 40").
    NSJ              = crProp(12,"NSJ",               "Никотинсодержащие жидкости и ЭСДН").
    Bad              = crProp(13,"Bad",               "БАД").
    antiseptic       = crProp(14,"antiseptic",        "Антисептики").
    
    Unknow:Label_  = "Неизвестный тип маркировки.".
    
  end.
  
end class.