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
&scoped-define impclass edi-doc
using ibs.th.bge.1crn.subjects.subjects.
using ibs.th.bge.1crn.subjects.{&impclass}.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.imp{&impclass} inherits ibs.th.gbl.sys.objth implements ibs.th.bge.1crn.import.iimpsubject : 

  
  { cmp/str-glbl.i class } /* &add-def, &update, &deletion, &shop, &attr-cash-book-id, &attr-oper-serv-id */
  /* { gbl/attr-lib.i class } gds-attr-write() заинлайнена */
  {str\utd-err.i class}
  {str\utd.i class}
  define private temp-table tt-mark no-undo 
     field mark as character case-sensitive 
  .
/*  define private temp-table tt-operserv no-undo like ub.OperServ .*/
  
  define property Msg as character no-undo
    get. 
    set.

  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
    define variable objImp    as class ibs.th.bge.1crn.subjects.edi-doc no-undo.
    define variable v-retfl   as logical no-undo .
    define variable v-mode    as character no-undo. /* create/update */
   
    define variable v-objlist   as class ibs.th.bge.1crn.subjects.subjects no-undo . // imp:kb-gds[]
    define variable v-gds-gd    as class ibs.th.bge.1crn.subjects.edi-gd no-undo .
    define variable v-objlistmark   as class ibs.th.bge.1crn.subjects.subjects no-undo . // imp:kb-gds[]
    define variable v-marks-mark    as class ibs.th.bge.1crn.subjects.mark no-undo .
    define variable v-i-counter as integer no-undo .
    define variable v-i-num     as integer no-undo .
    define variable v-i-counter2 as integer no-undo .
    define variable v-i-num2     as integer no-undo .
    
    define variable v-stub      as integer no-undo .
    
    define variable v-host-code  as integer no-undo .
    define buffer buf_clients    for ub.clients .
    define buffer buf_goods      for ub.goods .
    define buffer buf_goods-attr for ub.goods-attr .
/*    define buffer buf_OperServ   for ub.OperServ .*/
    define buffer buf_fin-code-cor-acc for ub.fin-code-cor-acc .


    objImp = cast (subjectObj, {&impclass}).

    if objImp:del-f > 0 then
      undo, throw new Progress.Lang.AppError("физичесткое удаление edi-doc не предусмотрено") .    
    
    /* если код не задан:
         - если пришла с признаком "основная" - то обновляем CashBook.id = 0 и не грузим секцию с товарами;
         - если пришла без признака "основная" - то режим создания с автоматическим присвоением кода;
       если код задан:
         - признак "основная" игнорируется;
         - если код присутствует в БД - режим обновления;
         - если код отсутствует в БД - режим создания;
       логическое удаление - только, если код задан, присутствует в БД, и CashBook.id <> 0.
       
       чтобы при изменении записи не затирать поля, которые не приходят из 1С, значениями по умолчанию -
       читаем их значения из исходной записи;
       чтобы при изменении записи не затирать поля из необязательных тегов, которые пришли из 1С, пустыми значениями -
       читаем их значения из исходной записи.
    */
    
   find first utd where utd.OrganizationExt eq ""
                    and utd.DocumentExt     eq objImp:edoc-id
   exclusive-lock no-error.
   if not available utd
   then do:
      if objImp:obj-load ne "edi-doc"
      then
         undo, throw new Progress.Lang.AppError(substitute("Создание &1 не предусмотрено",objImp:obj-load)) .
      create utd.
      utd.DocumentExt     = objImp:edoc-id.
      validate utd.
   end.
   if objImp:obj-load eq "edi-doc-stts"
   then
      utd.sts-edi  = ObjSrv:Env:Utd:Sts:edi:GetKeyIntDB(objImp:edoc-stts).
   else do:
      message 111
      view-as alert-box.
      assign
         utd.comment  = objImp:comment
         utd.CounteragentId  = objImp:contr-code                  when objImp:contr-code ne ?
         utd.contract-code  = objImp:dog-code                     when objImp:dog-code ne ? 
         utd.DocumentDate  = objImp:edoc-date
         utd.DocumentNumber  = objImp:edoc-num
         utd.sts  = ObjSrv:Env:Utd:Sts:th:GetKeyIntDB(objImp:edoc-stts)
         utd.EDocType  = ObjSrv:Env:Utd:edoctype:GetKeyIntDB(objImp:edoc-type)
         utd.parentDocumentExt  = objImp:orig-edoc-id             when objImp:orig-edoc-id ne ?
         utd.PackageId          = objImp:orig-edoc-id             when objImp:orig-edoc-id ne ?
         utd.total  = objImp:sum                                  when objImp:sum ne ?
         utd.vat  = utd.total - objImp:sum-nonds                  when objImp:sum ne ? and objImp:sum-nonds ne ?
      .
     
      for first buf_clients no-lock
            where buf_clients.db-num   = ibs.th.gbl.gbl-var:g#db-num
              and buf_clients.obj-type = {&shop}
              and buf_clients.stts     = {&bef-current-status-int} :
         assign
            utd.obj-type   = buf_clients.obj-type
            utd.obj-code   = buf_clients.obj-code
            utd.host-code  = buf_clients.host-code
         .
      end.
      v-objlist = objImp:gds .
      if valid-object(v-objlist) 
      then do :
         v-i-counter = v-objlist:iCounter .
         do v-i-num = 1 to v-i-counter :
            v-stub = v-objlist:Get(v-i-num) . // возвращает кол-во элементов и переключает currItem
            v-gds-gd = cast(v-objlist:SubjectObjCurr, ibs.th.bge.1crn.subjects.edi-gd) .
            find first utd-lines where utd-lines.db-num  eq utd.db-num
                                   and utd-lines.doc-id  eq utd.doc-id
                                   and utd-lines.LineNum eq v-gds-gd:line-num
            exclusive-lock no-error.
            if not available utd-lines
            then do:
               create utd-lines.
               assign 
                  utd-lines.db-num   = utd.db-num
                  utd-lines.doc-id   = utd.doc-id
                  utd-lines.LineNum  = v-gds-gd:line-num
               .
            end.
            find last tax-rate-value where    /*Значение ставки налога    НДС    */
                        tax-rate-value.tax-code = 1 and
                        tax-rate-value.rate-code = v-gds-gd:nds-code no-lock no-error.
            if available tax-rate-value then do:
                utd-lines.TaxRate = tax-rate-value.rate-value.
            end.
            assign
               utd-lines.gds-code  = v-gds-gd:gds-code
               utd-lines.TaxRate  = v-gds-gd:nds-code
               utd-lines.Price  = v-gds-gd:price-nonds
               utd-lines.Quantity  = v-gds-gd:qnty-ttn
               utd-lines.Total  = v-gds-gd:sum
               utd-lines.TotalWithVatExcluded  = utd-lines.Price * utd-lines.Quantity
            .
            v-objlistmark = v-gds-gd:marks .
            if valid-object(v-objlistmark) 
            then do :
               v-i-counter2 = v-objlistmark:iCounter .
               do v-i-num2 = 1 to v-i-counter2 :
                  v-objlistmark:Get(v-i-num) .
                  v-marks-mark = cast(v-objlistmark:SubjectObjCurr, ibs.th.bge.1crn.subjects.mark) .
                  for each tt-mark:
                     delete tt-mark.
                  end.
                  find first utd-marking-lines where utd-marking-lines.db-num  eq utd-lines.db-num
                                                 and utd-marking-lines.doc-id  eq utd-lines.doc-id
                                                 and utd-marking-lines.LineNum eq utd-lines.LineNum
                                                 and utd-marking-lines.mark    eq v-marks-mark:mark-code
                  exclusive-lock no-error.
                  if not available utd-marking-lines
                  then do:
                     find first marking where marking.mark eq v-marks-mark:mark-code
                     no-lock no-error.
                     if not available marking
                     then
                        undo, throw new Progress.Lang.AppError(substitute("Нет марки &1 .",v-marks-mark:mark-code)) .
                     create utd-marking-lines.
                     assign
                        utd-marking-lines.db-num  = utd-lines.db-num
                        utd-marking-lines.doc-id  = utd-lines.doc-id
                        utd-marking-lines.LineNum = utd-lines.LineNum
                        utd-marking-lines.mark    = v-marks-mark:mark-code
                        utd-marking-lines.doc-level = 1        
                     .
                  end.
                  utd-marking-lines.sts = ObjSrv:Env:marking:Sts:mark:GetKeyIntDB(v-marks-mark:stts).
                  create tt-mark.
                  tt-mark.mark = utd-marking-lines.mark .
               end.
               for each utd-marking-lines where utd-marking-lines.db-num  eq utd-lines.db-num
                                            and utd-marking-lines.doc-id  eq utd-lines.doc-id
                                            and utd-marking-lines.LineNum eq utd-lines.LineNum
               exclusive-lock:
                  
                  find first tt-mark where tt-mark.mark = utd-marking-lines.mark.
                  if not available tt-mark
                  then
                     delete utd-marking-lines.
                  else
                     addMark( buffer utd-marking-lines).
               end.
            end. // 
         end.
      end.
   end.
   v-retfl = true .
    define variable i as integer no-undo .
    catch exAppErrors as class Progress.Lang.AppError :
      Msg = exAppErrors:ReturnValue .
      if Msg > "" then . else do :
        do i = 1 to exAppErrors:NumMessages :
          Msg = Msg + {&new-line} + exAppErrors:GetMessage(i) .
        end .
        if Msg > "" then . else Msg = "AppError в edi-doc" .
      end .
      v-retfl = false .
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      do i = 1 to exProErrors:NumMessages :
        Msg = Msg + {&new-line} + exProErrors:GetMessage(i) .
      end .
      if Msg > "" then . else Msg = "ProError в edi-doc" .
      v-retfl = false.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error в edi-docг" .
      v-retfl = false .
      undo, throw exAnyErrors .
    end catch .
    finally :
      
      return v-retfl .
    end finally .
  end method. /* end_of Excute */
    
end class.
