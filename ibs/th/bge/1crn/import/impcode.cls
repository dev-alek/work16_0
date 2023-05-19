/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных kass-book (типы кассовых книг) из 1С

Автор: Молотков Сергей
Дата создания: 13/02/19
Author: Molotkov Sergey
Creation date: 13/02/19

*/
&scoped-define impclass code
using ibs.th.bge.1crn.subjects.subjects.
using ibs.th.bge.1crn.subjects.{&impclass}.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.impCode inherits ibs.th.gbl.sys.objth implements ibs.th.bge.1crn.import.iimpsubject : 

  
  { cmp/str-glbl.i class } /* &add-def, &update, &deletion, &shop, &attr-cash-book-id, &attr-oper-serv-id */
  /* { gbl/attr-lib.i class } gds-attr-write() заинлайнена */
  {utl\gtin.i class}
  define private temp-table tt-mark no-undo 
     field mark as character case-sensitive 
  .
/*  define private temp-table tt-operserv no-undo like ub.OperServ .*/
  
  define property Msg as character no-undo
    get. 
    set.

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
    define variable objImp    as class ibs.th.bge.1crn.subjects.{&impclass} no-undo.
    define variable v-retfl   as logical no-undo .
    define variable v-mode    as character no-undo. /* create/update */
    define variable v-del-f as logical no-undo.
    define buffer code for ub.code .


    objImp = cast (subjectObj, {&impclass}).
    v-del-f = objImp:del-f > 0.
    if v-del-f eq ?
    then
       v-del-f = false.
    find first code where Code.parent eq objImp:old_parent_
                      and code.code   eq objImp:old_code_
    exclusive-lock no-error.  
    if available code 
    then do:
       if v-del-f
       then
          delete Code.
       
    end.
    else do:
       if not v-del-f
       then
          create code.
    end.  
    if not v-del-f
    then assign
       code.code      = objImp:code_
       Code.parent    = objImp:parent_
       Code.CodeName  = objImp:codeName
       Code.CodeValue = objImp:codeValue
       Code.status_   = objImp:status_
       Code.misc1     = objImp:misc1
    .
    define variable mImp2CdH as handle no-undo.
    run str/imp2cdgeth.p(output mImp2CdH).
    run fill-code in mImp2CdH (objImp:old_parent_,
                               objImp:old_code_).    
    
    run fill-code in mImp2CdH (objImp:parent_,
                               objImp:code_).    
    v-retfl = true .
    define variable i as integer no-undo .
    catch exAppErrors as class Progress.Lang.AppError :
      Msg = exAppErrors:ReturnValue .
      if Msg > "" then . else do :
        do i = 1 to exAppErrors:NumMessages :
          Msg = Msg + {&new-line} + exAppErrors:GetMessage(i) .
        end .
        if Msg > "" then . else Msg = "AppError в mark" .
      end .
      v-retfl = false .
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      do i = 1 to exProErrors:NumMessages :
        Msg = Msg + {&new-line} + exProErrors:GetMessage(i) .
      end .
      if Msg > "" then . else Msg = "ProError в mark" .
      v-retfl = false.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error в mark" .
      v-retfl = false .
      undo, throw exAnyErrors .
    end catch .
    finally :
      
      return v-retfl .
    end finally .
  end method. /* end_of Excute */
    
end class.
