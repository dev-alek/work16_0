/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Проверка корректности закрытия смены на объекте с точки зрения кассы и продаж

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/18/06
Author: Bakhtadze Natalya
Creation date: 01/18/06

*/
using ibs.th.gbl.sys.*.
using ibs.th.str.marking.sts.*.

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-silent as logical no-undo .
DEFINE INPUT PARAMETER p-obj-type like shift-obj.obj-type no-undo.
DEFINE INPUT PARAMETER p-obj-code like shift-obj.obj-code no-undo.
DEFINE INPUT PARAMETER p-shift-date like shift-obj.shift-date no-undo.
DEFINE INPUT PARAMETER p-shift-num like shift-obj.shift-num no-undo.
define input parameter p-shift-name like shift-obj.shift-name no-undo .


define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "Проверка корректности закрытия смены на объекте с точки зрения кассы и продаж" .
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
/*{ gbl/getcntxt.i def } 01/IV-2019 */

define variable last-date like ub.chk-doc.chk-date no-undo.
define variable last-time like ub.chk-doc.chk-time no-undo.
define variable last-shift-date like ub.chk-doc.shift-date no-undo.
define variable last-shift-num like ub.chk-doc.shift-num no-undo.
define variable oldshift as logical no-undo.
define variable vreason as character no-undo.
define variable v-recid as recid no-undo.
define variable dflt-cd as character no-undo .
define variable conf-attr as character no-undo .
define variable conf-par as character no-undo .
define variable par-type as character no-undo .
define variable varshift-name-num as character no-undo.

define buffer buf_chk-doc for ub.chk-doc.

define buffer buf_shift-cash for ub.shift-cash.
define buffer buf_cash-desk for ub.cash-desk.
define buffer buf_marking for ub.marking .
def var Marking as class mark no-undo .
define variable objSrv as class objsrv no-undo .
run gbl/getobjsrvhndl.p (input-output ObjSrv). 
/*докачать все чеки*/
/*если это не маркетер*/
do
on error undo, return error
:

  { gbl/dflt-cd.i p-obj-type p-obj-code dflt-cd }

end. /*doe*/

  run str/diallog.w (
                  input parparentproc
                , input this-procedure
                , input 'str/get-chkf.p':U
                , input (p-obj-type + {&delim-par} + string(p-obj-code) + {&delim-par} +
                string(0)  + {&delim-par} + string(0) + {&delim-par} + string(1))
                , input (if p-silent then yes else no)
                , input '':U
                , input 'Прием чеков с касс') no-error .
IF error-status:error then do:
    return error "Ошибка при получении почты с касс".
end.


assign
varshift-name-num = (if p-shift-num = integer(p-shift-name)
                     then p-shift-name
                     else p-shift-name + "(" + string(p-shift-num) + ")").

/*все ли чеки вкачаны в продажу*/
FOR EACH buf_chk-doc No-LOCK WHERE
        buf_chk-doc.obj-type = p-obj-type
    AND buf_chk-doc.obj-code = p-obj-code
    AND buf_chk-doc.shift-date = p-shift-date
    AND buf_chk-doc.shift-num = p-shift-num use-index shift:
  if buf_chk-doc.out-code = ? then do:
    vReason = substitute("Не все чеки по смене № &1 от &2 закачаны в продажу"
                        ,varshift-name-num
                        ,string(p-shift-date, "99/99/9999")
                        ).
    return error vreason.
  end.
END.

for each buf_chk-doc No-lock where
        buf_chk-doc.obj-type = p-obj-type
    AND buf_chk-doc.obj-code = p-obj-code
    AND buf_chk-doc.shift-date = p-shift-date
    AND buf_chk-doc.shift-num = 0:
  if buf_chk-doc.out-code = ?
  and buf_chk-doc.shift-name = p-shift-name
  then do:
    vReason = substitute("Не все чеки по смене № &1 от &2 закачаны в продажу&3имеются чеки с непроставленным порядковым номером смены"
                        ,varshift-name-num
                        ,string(p-shift-date, "99/99/9999")
                        ).
    return error vreason.
  end.
end.



if ObjSrv:Env:ParametrsOfSection:GetSectionEDO(p-obj-type, p-obj-code):IsMarking then do:
/*проверка марок*/
  Marking = ObjSrv:Env:Marking:Sts:Mark.
for first buf_marking no-lock where 
          buf_marking.obj-code = p-obj-code and 
          buf_marking.obj-type = p-obj-type and
          buf_marking.sts = Marking:SaleLock:KeyIntDB:
     vReason = substitute("Не все чеки с маркированной табачной продукцией загружены в смену. Закрытие смены № &1 от &2 не возможно"
                        ,varshift-name-num
                        ,string(p-shift-date, "99/99/9999")
                        ).
    return error vreason.         
 
end.
for first buf_marking no-lock where 
          buf_marking.obj-code = p-obj-code and 
          buf_marking.obj-type = p-obj-type and
          buf_marking.sts = Marking:ReturnLock:KeyIntDB:
     vReason = substitute("Не все чеки с маркированной табачной продукцией загружены в смену. Закрытие смены № &1 от &2 не возможно"
                        ,varshift-name-num
                        ,string(p-shift-date, "99/99/9999")
                        ).
    return error vreason.         
 
end.
for first buf_marking no-lock where 
          buf_marking.obj-code = p-obj-code and 
          buf_marking.obj-type = p-obj-type and
          buf_marking.sts = Marking:SaleWaitLock:KeyIntDB:
     vReason = substitute("Не все чеки с маркированной табачной продукцией загружены в смену. Закрытие смены № &1 от &2 не возможно"
                        ,varshift-name-num
                        ,string(p-shift-date, "99/99/9999")
                        ).
    return error vreason.         
 
end.
for first buf_marking no-lock where 
          buf_marking.obj-code = p-obj-code and 
          buf_marking.obj-type = p-obj-type and
          buf_marking.sts = Marking:ReturnWaitLock:KeyIntDB:
     vReason = substitute("Не все чеки с маркированной табачной продукцией загружены в смену. Закрытие смены № &1 от &2 не возможно"
                        ,varshift-name-num
                        ,string(p-shift-date, "99/99/9999")
                        ).
    return error vreason.         
 
end.
end.

/* 23/III-2019  исключена проверка на всех ли кассах магазина закрыты смены. Задача #4968.
                На станции специально выключают кассу, чтобы избежать докачки чеков и проверки закрытия смены на кассе.
{ gbl/getcntxt.i get }
_cash-desk:
FOR EACH buf_cash-desk No-LOCK WHERE
         buf_cash-desk.obj-code = p-obj-code
     AND buf_cash-desk.db-num = v-cntxt-db-num
     and buf_cash-desk.cash-on = yes:
  if buf_cash-desk.autonomy = integer({&cd-manager})
  then next _cash-desk.
  FIND FIRST buf_shift-cash No-LOCK WHERE
            buf_shift-cash.obj-type = {&shop}
        AND buf_shift-cash.obj-code = buf_cash-desk.obj-code
        AND buf_shift-cash.cash-num = buf_cash-desk.cash-num
        AND buf_shift-cash.shift-date = p-shift-date
        AND buf_shift-cash.shift-num = p-shift-num
  use-index PI No-ERROR.
  IF (NOT avail buf_shift-cash
  and can-find(ub.chk-doc no-lock where
               ub.chk-doc.obj-type = {&shop}
           and ub.chk-doc.obj-code = p-obj-code
           and ub.chk-doc.pay-desk = buf_cash-desk.cash-num
           and ub.chk-doc.shift-date = p-shift-date
           and ub.chk-doc.shift-num = p-shift-num
           ))
  OR (available buf_shift-cash
      and buf_shift-cash.status_ <> {&sht-closed})  then do:
    /*на какой-то кассе смена не закрыта*/
    vReason = substitute("На кассе N &1 не закрыта смена № &2 от &3"
                          ,buf_cash-desk.cash-num
                          ,p-shift-name
                          ,string(p-shift-date, "99/99/9999"))
                      .
    return error vreason.
  end.
  if not (available buf_shift-cash
      and buf_shift-cash.status_ = {&sht-closed}) then do:
      FOR EACH buf_shift-cash No-LOCK WHERE
                buf_shift-cash.obj-type = {&shop}
            AND buf_shift-cash.obj-code = buf_cash-desk.obj-code
            AND buf_shift-cash.cash-num = buf_cash-desk.cash-num
            AND buf_shift-cash.shift-date = p-shift-date
            AND (buf_shift-cash.shift-num = ?
            or
                buf_shift-cash.shift-num = 0)
            :
    
        IF buf_shift-cash.status_ <> {&sht-closed}
        and (buf_shift-cash.shift-name = p-shift-name
        or  buf_shift-cash.shift-name = '':U)
        then do:
          /*на какой-то кассе смена не закрыта*/
          vReason = substitute("На кассе N &1 не закрыта смена <&2> от &3"
                                ,buf_cash-desk.cash-num
                                ,buf_shift-cash.shift-name
                                ,string(p-shift-date, "99/99/9999"))
                            .
          return error vreason.
        end.
      end.
  end. 
END.
*/
