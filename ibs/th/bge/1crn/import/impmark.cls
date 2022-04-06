/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

 ласс ипорта данных kass-book (типы кассовых книг) из 1—

јвтор: ћолотков —ергей
ƒата создани€: 13/02/19
Author: Molotkov Sergey
Creation date: 13/02/19

*/
&scoped-define impclass mark
using ibs.th.bge.1crn.subjects.subjects.
using ibs.th.bge.1crn.subjects.{&impclass}.

block-level on error undo, throw.

class ibs.th.bge.1crn.import.imp{&impclass} inherits ibs.th.gbl.sys.objth implements ibs.th.bge.1crn.import.iimpsubject : 

  
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
    define variable objImp    as class ibs.th.bge.1crn.subjects.mark no-undo.
    define variable v-retfl   as logical no-undo .
    define variable v-mode    as character no-undo. /* create/update */
   
    define variable v-i-counter as integer no-undo .
    define variable v-i-num     as integer no-undo .
    define variable v-stub      as integer no-undo .
    
    define variable v-host-code  as integer no-undo .
    define buffer buf_bar-code    for ub.bar-code .
    define buffer buf_goods      for ub.goods .
    define buffer marking for marking.
    define buffer marking-attr for ub.marking-attr .


    objImp = cast (subjectObj, {&impclass}).

    if objImp:del-f > 0 then
      undo, throw new Progress.Lang.AppError("физичесткое удаление edi-doc не предусмотрено") .    
    
    /* если код не задан:
         - если пришла с признаком "основна€" - то обновл€ем CashBook.id = 0 и не грузим секцию с товарами;
         - если пришла без признака "основна€" - то режим создани€ с автоматическим присвоением кода;
       если код задан:
         - признак "основна€" игнорируетс€;
         - если код присутствует в Ѕƒ - режим обновлени€;
         - если код отсутствует в Ѕƒ - режим создани€;
       логическое удаление - только, если код задан, присутствует в Ѕƒ, и CashBook.id <> 0.
       
       чтобы при изменении записи не затирать пол€, которые не приход€т из 1—, значени€ми по умолчанию -
       читаем их значени€ из исходной записи;
       чтобы при изменении записи не затирать пол€ из необ€зательных тегов, которые пришли из 1—, пустыми значени€ми -
       читаем их значени€ из исходной записи.
    */
   if objImp:obj-load ne "mark"
   then
      undo, throw new Progress.Lang.AppError(substitute("«агрузка &1 не предусмотрена",objImp:obj-load)) .
   define variable vmark as character no-undo.
  
   vmark = repTegforDm(objImp:mark-code).
   find first marking where marking.mark eq vmark
   exclusive-lock no-error.
   if not available marking
   then do:
      
      create marking.
      marking.mark     = vmark.
      
   end.
     
   if objImp:gds-code ne ?
   then do:
      find first buf_goods  where buf_goods.gds-code eq objImp:gds-code
      no-lock no-error.
      if not available buf_goods
      then
         undo, throw new Progress.Lang.AppError(substitute("Ќе известный товар &1",objImp:gds-code)) .
   end.
   if objImp:gtin ne ? and objImp:gds-code ne ?
   then do:
      find first prod-bc  where prod-bc.b-str eq objImp:gtin
      no-lock no-error.
      if not available prod-bc
      then .
/*          undo, throw new Progress.Lang.AppError(substitute("Ќе известный GTIN &1",objImp:gtin)) .*/
      else do:
         find buf_bar-code where buf_bar-code.b-code = ub.prod-bc.b-code no-lock no-error .
         if    not available buf_bar-code
            or buf_bar-code.gds-code ne objImp:gds-code
         then
            undo, throw new Progress.Lang.AppError(substitute("GTIN &1 не принадлежит товару &2 ", objImp:gtin , objImp:gds-code)) . 
      end.
   end.
   assign
      marking.gds-code     = objImp:gds-code
      marking.gds-ext-id   = objImp:GTIN
      marking.mark-parent  = repTegforDm(objImp:mark-parent) when objImp:mark-parent ne ? 
      marking.box-qnty     = objImp:qnty-box
      marking.sts          = ObjSrv:Env:marking:Sts:mark:GetKeyIntDB(objImp:stts)
      marking.unit-ext     = objImp:unit-ext
   .
   if marking.gds-code eq 0
   then 
      marking.gds-code = ?.
   if marking.sts eq ? then
      undo, throw new Progress.Lang.AppError(substitute("Ќе известный статус марки &1",objImp:stts)) .
   
   if marking.sts ne objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB
   then do:
   if    marking.box-qnty < 1
      or marking.box-qnty eq ? 
   then
      undo, throw new Progress.Lang.AppError(substitute("«начение qnty-box должно быть больше 0")) .
   define variable vgtin as character no-undo.
   vgtin = getGtinByDM(marking.mark).
   if vgtin eq ""
   then
      vgtin = ?.
   if marking.gds-ext-id ne vgtin
   then
      undo, throw new Progress.Lang.AppError(substitute("«начение Gitn &1 макрки не равен &2",getGtinByDM(marking.mark),marking.gds-ext-id)) .
   if marking.gds-code ne getGdsCodeByGtin(marking.gds-ext-id)
   then
      undo, throw new Progress.Lang.AppError(substitute("«начение Gitn &1 макрки относитс€ к товару &2, в файле товар &3",marking.gds-ext-id,getGdsCodeByGtin(marking.gds-ext-id),marking.gds-code)) .
   
   if     objImp:mrc ne 0 
      and objImp:mrc ne ?
   then do:
      find first marking-attr where marking-attr.mark      eq marking.mark
                                and marking-attr.attr-code eq "MRC"
         exclusive-lock no-error.
      if not avail marking-attr
      then do:
         create marking-attr.
         assign
            marking-attr.mark =  marking.mark
            marking-attr.attr-code = "MRC"
                
                                 no-error.
      end.
      marking-attr.attr-value = string(objImp:mrc).
      release marking-attr no-error.
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
