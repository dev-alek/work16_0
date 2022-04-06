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

  define variable GrayZoneQnty  as integer no-undo .
  { gbl/thbj-def.i }
  
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
    
    define variable v-value-character     as character     no-undo .
    define variable v-value-decimal       as decimal       no-undo .
    define variable v-value-integer       as integer       no-undo .
    define variable v-value-logical       as logical       no-undo .
    define variable v-value-type          as character     no-undo .
    define variable v-value-date          as date          no-undo .
    
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
      validate utd no-error.
      if error-status:error
      then
         undo, throw new Progress.Lang.AppError(substitute("&1 &2",return-value,error-status:get-message (1))) .
         
   end.
   if objImp:obj-load eq "edi-doc-stts"
   then do:
      utd.sts  = ObjSrv:Env:Utd:Sts:th:GetKeyIntDB(objImp:edoc-stts).
      for each utd-marking-lines where utd-marking-lines.db-num    eq utd.db-num
                                   and utd-marking-lines.doc-id    eq utd.doc-id
                                   and utd-marking-lines.doc-level eq 1
      exclusive-lock:
         addMark(buffer utd-marking-lines ).
                     find first marking exclusive-lock where marking.mark = utd-marking-lines.mark no-error .
                       if available (marking) then do:
                       if marking.unit-ext <> "UNIT" and utd.EDocType = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB 
                       and marking.sts = objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB then
                       marking.sts = objSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB.
                       end. 
      end.
   end.
   else do:
      assign
         utd.comment  = objImp:comment
         utd.CounteragentId  = objImp:contr-code                  when objImp:contr-code ne ?
         utd.contract-code  = objImp:dog-code                     when objImp:dog-code ne ? 
         utd.DocumentDate  = objImp:edoc-date
         utd.DocumentNumber  = objImp:edoc-num
         utd.sts  = ObjSrv:Env:Utd:Sts:th:GetKeyIntDB(objImp:edoc-stts)
         utd.sts-edi  = ObjSrv:Env:Utd:Sts:EDI:Verification:KeyIntDB
         utd.EDocType  = ObjSrv:Env:Utd:edoctype:GetKeyIntDB(objImp:edoc-type)
         utd.parentDocumentExt  = objImp:orig-edoc-id             when objImp:orig-edoc-id ne ?
         utd.PackageId          = objImp:orig-edoc-id             when objImp:orig-edoc-id ne ?
         utd.total  = objImp:sum                                  when objImp:sum ne ?
         utd.vat  = utd.total - objImp:sum-nonds                  when objImp:sum ne ? and objImp:sum-nonds ne ?
      .
      
      define variable vflag as logical no-undo.
      for first buf_clients no-lock
            where buf_clients.obj-type = {&cmp}
              and buf_clients.obj-code = int(objImp:contr-code) :
         assign 
            utd.cli-type   = buf_clients.obj-type
            utd.cli-code   = buf_clients.obj-code
           vflag = yes
         .
      end.
      if  not vflag
      then
         undo, throw new Progress.Lang.AppError(substitute("Не найдена организация с кодом &1 в БД &2",int(objImp:contr-code),ibs.th.gbl.gbl-var:g#db-num)) .
      for first buf_clients no-lock
            where buf_clients.db-num   = ibs.th.gbl.gbl-var:g#db-num
              and buf_clients.obj-type = {&shop}
              and buf_clients.stts     = {&bef-current-status-int} :
         assign
            utd.obj-type   = buf_clients.obj-type
            utd.obj-code   = buf_clients.obj-code
            utd.host-code  = buf_clients.host-code
            
         .
          run adm/shattri.p (
               input "get":U
               ,input utd.obj-type
               ,input utd.obj-code
               ,input {&attr-marking}
               ,input "gray_zone_qnty"
               ,output v-value-character
               ,output v-value-date
               ,output v-value-decimal
               ,output v-value-integer
               ,output v-value-logical
               ,output v-value-type
               ,input-output TABLE thbjattr_thbj-attr
               ) no-error .
           if v-value-integer <> ?
           then
              GrayZoneQnty = v-value-integer
           . 

         find first shop where shop.obj-code eq buf_clients.obj-code
         no-lock no-error.
         if available shop
         then
            utd.obj-info = shop.addres1.
      end.
      find first contract  where contract.host-code eq utd.host-code
                             and contract.contract-code eq utd.contract-code
      no-lock no-error.
      if     contract.cli-type  ne utd.cli-type
         or  contract.cli-code  ne utd.cli-code
      then
         undo, throw new Progress.Lang.AppError(substitute("В договоре &1 и в УПД разные контр агенты",utd.contract-code)) .
      Utd.BaseDocumentNumber = contract.contract-prn-code.
      utd.BaseDocumentDate       = contract-date.                      
      /*define variable VContractEdo as logical no-undo init yes.
      VContractEdo = contract.whole-send-news eq 1. /* договор Едо*/
      if not VContractEdo
      then
         undo, throw new Progress.Lang.AppError(substitute("Договор с кодом &1 не ЭДО",utd.contract-code)).
      */
     /* find first contract-attr exclusive-lock where contract-attr.contract-code = contract.contract-code
                                                and contract-attr.host-code    = contract.host-code 
                                                and contract-attr.attr-code = "contract-edi" no-error .
      if    not available contract-attr
         or logical(contract-attr.attr-value) ne yes
      then 
         undo, throw new Progress.Lang.AppError(substitute("Договор с кодом &1 не ЭДО",utd.contract-code)).
     */
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
            utd-lines.TaxRate = v-gds-gd:nds-code.
            if v-gds-gd:gds-code ne ?
            then do:
               find first goods where goods.gds-code eq v-gds-gd:gds-code
               no-lock no-error.
               if not available goods
               then
                  undo, throw new Progress.Lang.AppError(substitute("Нет товара с кодом &1",v-gds-gd:gds-code)).
            end.
            assign
               utd-lines.Price     = v-gds-gd:price-nonds
               utd-lines.Quantity  = v-gds-gd:qnty-ttn
               utd-lines.Total     = v-gds-gd:sum
               utd-lines.gds-code  = v-gds-gd:gds-code
            .
            if available  goods
            then
               assign
                  
                  utd-lines.UnitCode  = goods.unit-base
                  utd-lines.GdsName   = goods.gds-name
               .
            release goods.
            
            
            if v-gds-gd:sum-nds eq ?
            then
               assign
                  utd-lines.TotalWithVatExcluded  = utd-lines.Price * utd-lines.Quantity
               .
            else
               assign
                  utd-lines.Vat                   = v-gds-gd:sum-nds 
                  utd-lines.TotalWithVatExcluded  = utd-lines.Total - utd-lines.Vat
               .
            
            if v-gds-gd:stts-desc ne ?
            then
               AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"Load1C","stts-desc-line",v-gds-gd:stts-desc + {&delim-par} + string( utd-lines.LineNum)).
            if v-gds-gd:Qnty-accepted ne ?
            then
               setattrutdlines(utd-lines.db-num, utd-lines.doc-id, utd-lines.lineNum,"QuantityBarCode",string(v-gds-gd:Qnty-accepted)).
            define variable vqnty as integer no-undo.
            vqnty = 0.
            define variable vGdsCode as integer no-undo.
            v-objlistmark = v-gds-gd:marks .
            if valid-object(v-objlistmark) 
            then do :
               vGdsCode = 0.
            
               v-i-counter2 = v-objlistmark:iCounter .
               /*if v-i-counter2 < 1
               then
                  AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"loadUtd","NotMarkForLine",string(utd-lines.LineNum ) ).
                 */ 
               for each tt-mark:
                  delete tt-mark.
               end.
                  
               do v-i-num2 = 1 to v-i-counter2 :
                  v-objlistmark:Get(v-i-num2) .
                  v-marks-mark = cast(v-objlistmark:SubjectObjCurr, ibs.th.bge.1crn.subjects.mark) .
                  define variable vmark as character no-undo.
                  vmark = repTegforDm(v-marks-mark:mark-code).
                  find first utd-marking-lines where utd-marking-lines.db-num  eq utd-lines.db-num
                                                 and utd-marking-lines.doc-id  eq utd-lines.doc-id
                                                 and utd-marking-lines.LineNum eq utd-lines.LineNum
                                                 and utd-marking-lines.mark    eq vmark
                  exclusive-lock no-error.
                  find first marking where marking.mark eq vmark
                     no-lock no-error.
                  if not available marking
                  then
                     undo, throw new Progress.Lang.AppError(substitute("Нет марки &1 .",v-marks-mark:mark-code)) .
                  if not available utd-marking-lines
                  then do:
                     create utd-marking-lines.
                     assign
                        utd-marking-lines.db-num  = utd-lines.db-num
                        utd-marking-lines.doc-id  = utd-lines.doc-id
                        utd-marking-lines.LineNum = utd-lines.LineNum
                        utd-marking-lines.mark    = vmark
                        utd-marking-lines.doc-level = 1
                        utd-marking-lines.gds-code  = marking.gds-code       
                     .
                  end.
                  
                  if     vGdsCode eq 0
                     and utd-marking-lines.gds-code ne ?
                  then
                     vGdsCode = utd-marking-lines.gds-code.
                  else if      utd-marking-lines.gds-code ne ?
                      and vGdsCode ne utd-marking-lines.gds-code
                  then
                     vGdsCode = ?.
                  
                  if utd-marking-lines.doc-level eq 1
                  then
                     vqnty = vqnty + marking.box-qnty.
                  define variable vsts as integer no-undo.
                  vsts = ObjSrv:Env:marking:Sts:mark:GetKeyIntDB(v-marks-mark:stts).
                  if     vsts = ObjSrv:Env:marking:Sts:mark:DeliveryControl:KeyIntDB
                     or  vsts = ObjSrv:Env:marking:Sts:mark:GrayZone:KeyIntDB
                  then
                     utd-marking-lines.sts = ObjSrv:Env:marking:Sts:mark:PendingVerification:KeyIntDB.
                  else 
                     utd-marking-lines.sts = vsts.
                  
                  if v-marks-mark:stts-desc ne ?
                  then
                     AddUtdErr(utd.db-num,utd.doc-id,buffer utd-marking-lines:handle,"Load1C","stts-desc-mark",v-marks-mark:stts-desc + {&delim-par} + string( utd-lines.LineNum) + {&delim-par} +  vmark).
                  create tt-mark.
                  tt-mark.mark = utd-marking-lines.mark .
                  release utd-marking-lines.
               end.
               if     v-gds-gd:stts-desc eq ?
                  and utd-lines.Quantity ne vqnty
               then
                   AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"loadUtd","Qnty",string(utd-lines.LineNum ) + {&delim-par} + string(utd-lines.Quantity) + {&delim-par} + string(vqnty)).                        
                  
   
               for each utd-marking-lines where utd-marking-lines.db-num  eq utd-lines.db-num
                                            and utd-marking-lines.doc-id  eq utd-lines.doc-id
                                            and utd-marking-lines.LineNum eq utd-lines.LineNum
                                            and utd-marking-lines.doc-level = 1 
               exclusive-lock:
                  
                  find first tt-mark where tt-mark.mark = utd-marking-lines.mark
                  no-error.
                  if not available tt-mark
                  then do:
                     delMark(buffer utd-marking-lines).
                     delete utd-marking-lines.
                  end.
                  else do:
                     MarkGray(utd-marking-lines.mark).
                     addMark( buffer utd-marking-lines).
                       find first marking exclusive-lock where marking.mark = utd-marking-lines.mark no-error .
                       if available (marking) then do:
                       if marking.unit-ext <> "UNIT" and utd.EDocType = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB 
                       and marking.sts = objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB then
                       marking.sts = objSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB.
                       end. 
                  end.
                     
               end.
               if     vGdsCode     eq ?
                  and v-i-counter2 > 0
               then
                  utd-lines.gds-code = ?.
               
            
            end. //
           /* else
               AddUtdErr(utd.db-num,utd.doc-id,buffer utd-lines:handle,"loadUtd","NotMarkForLine",string(utd-lines.LineNum ) ).
      */   
            release utd-lines.
         end.
      end.
   end.
   CheckMarkUtd(utd.db-num,utd.doc-id).
   CheckMarking(utd.db-num,utd.doc-id,"CheckСontract").
/*   vMarkUtd =*/
   CheckMarkUtd(utd.db-num,utd.doc-id).
   if ibs.th.gbl.gbl-var:g#db-num ne 0 and utd.doc-code = "" and utd.sts = objSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB 
      and (utd.EDocType = objSrv:Env:Utd:EDocType:UTD:KeyIntDB )
     then 
   do:
     def var v-file-name as character no-undo.
     def var v-msg       as character no-undo.
     run ibs\th\str\utd\adaputd.p
       (utd.db-num, /*db-num*/
       utd.doc-id, /* doc-id*/
       ibs.th.gbl.gbl-var:g#userid /*User-Id*/
       ) no-error.
     if not error-status:error
       then 
     do:
      if return-value matches "*ошибка*"
       then v-msg = substitute ('MsgBox "Документ № &1 от &2. Сформирована ПН: &3. &4", ,"Получен УПД"', utd.DocumentNumber, string (utd.DocumentDate) , utd.doc-code, return-value).
       else v-msg = substitute ('MsgBox "Документ № &1 от &2. Сформирована ПН: &3. &5 &4", ,"Получен УПД"', utd.DocumentNumber, string (utd.DocumentDate) , utd.doc-code, return-value, "Товары данной поставки можно продавать на кассе.").
     end.
     else v-msg = substitute ('MsgBox "Документ: &1 от &2. Ошибка при формировании ПН. &3. &4", ,"Получен УПД"', utd.DocumentNumber, string (utd.DocumentDate), trim(return-value, ".")).
     
     v-file-name = string (guid(generate-uuid)) + ".vbs".
     output to value (v-file-name).
     put unformatted v-msg. 
     output close.
     file-info:file-name = (v-file-name).    
     os-command no-wait value (file-info:full-pathname).
   
   end.

   if ibs.th.gbl.gbl-var:g#db-num ne 0 and utd.sts = objSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB and utd.EDocType = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB
   then do:
       v-msg = substitute ('MsgBox "Докумет № &1 от &2. ", ,"Получен документ первоначального ввода"', utd.DocumentNumber, string (utd.DocumentDate)).
       v-file-name = string (guid(generate-uuid)) + ".vbs".
       output to value (v-file-name).
       put unformatted v-msg. 
       output close.
       file-info:file-name = (v-file-name).    
       os-command no-wait value (file-info:full-pathname).
   end.
   release utd.
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
      Msg = "Unexpected error в edi-doc" .
      v-retfl = false .
      undo, throw exAnyErrors .
    end catch .
    finally :
      
      return v-retfl .
    end finally .
  end method. /* end_of Excute */
  
  method public void MarkGray(imark as char):
     define buffer marking for marking.
     define buffer BuF_marking for marking.
     define variable vAllQnty as integer no-undo init ?.
     define variable vQnty as integer no-undo.
     find first marking where marking.mark eq imark
     no-lock no-error.
     if available marking
        and marking.box-qnty ne 1
     then do:
        for each buf_marking where buf_marking.mark-parent eq marking.mark
        no-lock:
           if vAllQnty eq ?
           then
              vAllQnty = marking.box-qnty / buf_marking.box-qnty.
           vQnty = vQnty + 1.
        end.
        if vAllQnty <> vQnty and GrayZoneQnty <> 100
        then do:
           find current marking exclusive-lock.
           marking.sts = if vAllQnty - vQnty <= GrayZoneQnty 
                         then objSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB
                         else objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB .
        end.
     end.
  end.
end class.
