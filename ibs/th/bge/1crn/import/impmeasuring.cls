&scoped-define impclass measuring
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных {&impclass} из 1С

Автор: Молотков Сергей
Дата создания: 04/12/17
Author: Molotkov Sergey
Creation date: 04/12/17

*/

using Progress.Lang.*.
/*using ibs.th.gbl.gbl-var.*/
using ibs.th.bge.1crn.enum-ms-type.
using ibs.th.bge.1crn.enum-ms-tk-type.
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
    define variable objImp       as class {&impclass} no-undo.
    define variable v-retfl      as logical no-undo .

    define variable v-ms-code    as integer no-undo .   /* like ub.sr-izmerenia.node-code */
    define buffer buf_sr-izmerenia for ub.sr-izmerenia .

        
    objImp = cast (subjectObj, {&impclass}).
  
    assign
      v-ms-code = integer(objImp:code_)
    .
    if v-ms-code > 0 then . else undo, throw new Progress.Lang.AppError("Не задан код средства измерения") .
    
    /* По справочникам ...,  ... при логическом удалении записей на стороне ТН никаких действий не производится,
       а при передаче из 1С к названию добавляется фраза «УДАЛЕНО» (или аналог).
       05/XII-2017 Средства измерения тоже добавили к этому перечню.
    */
    if objImp:del-f > 0 then do:
      run ref/sr-izm03.p ( input v-ms-code ) .
    end .
    else do:
      run ref/sr-izm01.p
      (input v-ms-code /* p-node-code (int) */
      ,input objImp:name_ /* p-sr-model (chr) */
      ,input mapMsType (objImp:ms-type) /* p-sr-type-id (int) */
      ,input objImp:me-np /* p-sr-abs-err-neft-water (dec) */
      ,input objImp:me-wtr /* p-sr-abs-err-water (dec) */
      ,input objImp:me-dnsty /* p-sr-abs-err-dens (dec) */
      ,input objImp:me-tmp-amnt /* p-sr-abs-err-temp-vol (dec) */
      ,input objImp:me-tmp-dnsty /* p-sr-abs-err-temp-dens (dec) */
      ,input objImp:limit /* p-sr-otnos (dec) */
      ,input mapMsTkType (objImp:tk) /* p-sr-temp-line (dec) */
      ) .
    end .
    assign
      Msg = "":U
      v-retfl = true
    .
    
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
      return v-retfl.
    end finally .
  end method. /* end_of Excute */


  /* mapping:
     коды в enum - согласно протоколу взаимодействия с 1С;
  */
  /* маппинг кодов типов средств измерения */
  method private integer mapMsType (p-ms-type as enum-ms-type) :
    define variable v-ms-type as integer no-undo .
    case p-ms-type :
      when enum-ms-type:enare15 then v-ms-type = 1 . 
      when enum-ms-type:enare20 then v-ms-type = 2 . 
      when enum-ms-type:endensflow then v-ms-type = 3 . 
      when enum-ms-type:endenssubm then v-ms-type = 4 . 
      when enum-ms-type:enchannelfl then v-ms-type = 5 . 
      when enum-ms-type:enchannelno then v-ms-type = 6 . 
      otherwise v-ms-type = 1 .
    end case .
    return v-ms-type .
  end method .
  method private decimal mapMsTkType (p-ms-tk-type as enum-ms-tk-type) :
    define variable v-ms-tk-type-value as decimal no-undo .
    case p-ms-tk-type :
      when enum-ms-tk-type:enalumin then v-ms-tk-type-value = 0.000023 . 
                               otherwise v-ms-tk-type-value = 0.0000125 . /* :ensteel */
    end case .
    return v-ms-tk-type-value .
  end method .
  /* end_of mapping */

end class.