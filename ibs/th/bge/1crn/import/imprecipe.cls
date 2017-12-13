&scoped-define impclass recipe
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных {&impclass} из 1С

Автор: Молотков Сергей
Дата создания: 25/10/17
Author: Molotkov Sergey
Creation date: 25/10/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.enum-recipe-type.
using ibs.th.bge.1crn.subjects.*.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.imp{&impclass} implements ibs.th.bge.1crn.import.iimpsubject: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
    define variable v-mode       as character no-undo . /* create/update */
    define variable objImp       as class {&impclass} no-undo.
    define variable v-gds-list   as class subjects no-undo .
    define variable v-recipe-gd  as class recipe-gd no-undo .
    define variable v-retfl      as logical no-undo .
    
    define variable v-recipe-code as character no-undo . /* like ub.recipe.recipe-code */
    define variable v-recipe-name as character no-undo . /* like up.recipe.recipe-name */
    define variable v-gds-code    as integer no-undo .   /* like ub.goods.gds-code */
    
    define buffer buf_recipe     for ub.recipe .
    define buffer buf_recipe-gds for ub.recipe-gds .
    define buffer buf_fbr-line   for ub.fbr-line .
    define buffer buf_fbr-doc    for ub.fbr-doc .
    
    
    objImp = cast (subjectObj, {&impclass}).
    
    assign
      v-recipe-code = objImp:recipe-code
      v-recipe-name = objImp:recipe-name
      v-gds-code    = integer(objImp:gd-code)
      Msg           = "":U
    .
    if v-recipe-code > "" then . else undo, throw new Progress.Lang.AppError("Не задан ид. рецепта") .
    
    if objImp:del-f > 0 then do:
      find first buf_fbr-line no-lock
           where buf_fbr-line.recipe-code = v-recipe-code no-error.
      if available buf_fbr-line then do:
        find first buf_fbr-doc no-lock
             where buf_fbr-doc.doc-code = buf_fbr-line.doc-code no-error.
        if available buf_fbr-doc then
          Msg = substitute( "Удаление рецепта [&1] невозможно: рецепт используется в производственных операциях." +
                            " Документ: &2 &3 от &4",
                            v-recipe-code, ub.fbr-doc.doc-type, ub.fbr-doc.doc-code, ub.fbr-doc.doc-date ) .
        else Msg = substitute( "Удаление рецепта [&1] невозможно: рецепт используется в производственных операциях." +
                               " Документ: [&2]",
                            v-recipe-code, buf_fbr-line.doc-code ) .
        v-retfl = false .
        return false. /* уходит в finally, где перевозвращает v-retfl вместо false */
      end .
      Msg = "физическое удаление рецептов не предусмотрено".
      v-retfl = false .
      return false. /* уходит в finally, где перевозвращает v-retfl вместо false */
/* физическое удаление рецептов:
  if not available ub.fbr-line then "Удаление выбранного рецепта не повлияет на сформированные по этому рецепту документы,"
  find first b-recipe exclusive-lock where recid( b-recipe ) = recid( ub.recipe )    .
  delete b-recipe .
  run fbrlib-set-default-recipe in this-procedure (
                      input p-store-type
                    , input p-store-code
                    , input ub.goods.gds-code
  ).
*/      
    end.
    /* По справочникам ..., Рецепты, ... при логическом удалении записей на стороне ТН никаких действий не производится,
       а при передаче из 1С к названию добавляется фраза «УДАЛЕНО» (или аналог). */
    

    /* чтобы при изменении записи не перезатирать поля, которые не приходят из 1С, значениями по умолчанию -
       читаем их значения из исходной записи;
       чтобы при изменении записи не затирать пустыми значениями поля из необязательных тегов, которые пришли из 1С, -
       читаем их значения из исходной записи */
    find first buf_recipe no-lock where buf_recipe.recipe-code = v-recipe-code no-error .
    if available buf_recipe then do:
      if v-recipe-name > "" then . else v-recipe-name = buf_recipe.recipe-name .

      assign
        v-mode = {&update}
      .
    end . /* end_of update */
    else do:
      assign
        v-mode = {&add-def}
      .
    end . /* end_of create */

      
    /* ----- создание/обновление рецепта ----- */
    define variable proc-fbrlib   as class ibs.th.str.fbrlib no-undo .

    /* Создание и изменение рецепта */
    proc-fbrlib = new ibs.th.str.fbrlib () .
    proc-fbrlib:create-new-recipe
    (input v-mode            /* p-mode character {&add-def} или {&update} */
    /* все рецепты создаются глобальными,
       код рецепта в обязательном порядке формируется во внешней системе */
    ,input v-recipe-code                       /* p-recipe-code character код (id) рецепта */
    ,input mapRecipeTypes (objImp:recipe-type) /* p-recipe-type character тип рецепта */
    ,input v-recipe-name                       /* p-recipe-name character наименование рецепта */
    ,input objImp:recipe-num                   /* p-recipe-num  character Номер рецепта по справочнику рецептур */
    ,input v-gds-code        /* p-gds-code integer код товара производимого по рецепту */
    ,input objImp:qnty-netto /* p-qnty-netto decimal Количество нетто */
    ,input objImp:qnty       /* p-portion-qnty integer Количество порций */
    ,input objImp:weight     /* p-portion-weight Вес порции */
    ) .
      
      /* делать рецепт установленным по умолчанию?
    if v-recipe-code <> "":U  then do:        /* ri = recid( recipe ) */
        run fbrlib-set-default-recipe in this-procedure (
              input p-store-type
            , input p-store-code
            , input buf_goods.gds-code
        ).
    end.
      */
      
    /* Добавление/обновление товаров в рецепте: 
1. для режима добавления - просто добавить товар
2. для режима обновления:
  а) если товара не было - создать его
  б) если товар был - обновить его
  в) оставшиеся товары были, но теперь не пришли. Удалить их.         
    */
    define variable v-rgds  as character no-undo . /* список обработанных товаров рецепта */
    define variable v-ii    as integer no-undo .
    define variable v-rowid as rowid no-undo .
    
    assign
      v-gds-list = objImp:recipe-gds
      v-rgds     = ""      
    .
    do v-ii = 1 to v-gds-list:Get(v-ii):
      v-recipe-gd = cast (v-gds-list:SubjectObjCurr, recipe-gd) .
      v-gds-code = integer (v-recipe-gd:gd-code) .
      v-rowid = proc-fbrlib:create-new-recipe-gds
      (input v-recipe-code
      ,input v-gds-code
      ,input v-recipe-gd:qnty-net
      ,input v-recipe-gd:qnty-gross
      ,input v-recipe-gd:lf /* внутри для новой записи = 0, далее присваивается только если gd:lf определено (gd:lf <> ?) */
      ,input v-recipe-gd:gds-recipe-code /* внутри присваивается только если значение определено (gds-recipe-code <> ?) */
      ) .
      if (v-mode = {&update}) then v-rgds = v-rgds + "," + string(v-rowid) . 
    end . /* end_of do_in_gds-list */
    v-rgds = substring(v-rgds, 2) .
      
    if (v-mode = {&update}) and (v-rgds > "") then do:
      /* уничтожение лишних записей */
      for each buf_recipe-gds exclusive-lock
         where buf_recipe-gds.recipe-code = v-recipe-code
           and can-do (  v-rgds,  string(rowid(buf_recipe-gds))  ) = false:
        assign
          buf_recipe-gds.nws-self    = yes
        .
        delete buf_recipe-gds .
      end.
      
    end. /* end_of clear recipe-gds */

    v-retfl = true .
    /* ----- end_of создание/обновление рецепта ----- */


    catch exAppErrors as class Progress.Lang.AppError :
      Msg = exAppErrors:ReturnValue .
      if Msg = "" then Msg = exAppErrors:GetMessage(1) .
      v-retfl = false.
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      Msg = exProErrors:GetMessage(1) . 
      v-retfl = false.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error occurred..." .
      v-retfl = false.
      undo, throw exAnyErrors .
    end catch .
    finally :
      if valid-object(proc-fbrlib) then delete object proc-fbrlib .
      return v-retfl.
    end finally .
  end method. /* end_of Excute */


  /* маппинг типов рецептов наших на 1с */
  method private character mapRecipeTypes (p-recipe-type as enum-recipe-type) :
    /* mapping:
       коды в enum - согласно протоколу взаимодействия с 1С;
    */
    define variable v-th-recipe-type as character no-undo .
    case p-recipe-type :
      when enum-recipe-type:enmanufacturing then v-th-recipe-type = {&manufacturing} .
      when enum-recipe-type:engathering     then v-th-recipe-type = {&gathering} . 
      when enum-recipe-type:enalternative   then v-th-recipe-type = {&alternative} . 
      otherwise v-th-recipe-type = "":U .
    end case .
    return v-th-recipe-type .
  end method .  /* end_of mapping */


end class.