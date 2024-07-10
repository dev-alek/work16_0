/*

$Revision: b5a32018f067, 3235, rls $
$Author: Ostroukhov $
$Date: 2022/12/27 12:54:29 $
$Workfile: cd-send16.i $
$Archive: str/cd-send16.i $

отсылка промоакций на кассы - процедура отсылки

Автор: Шкляр Елена
Дата создания: 02/19/06
Author: Shklyar Elena
Creation date: 02/19/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile: cd-send16.i $ $Revision: b5a32018f067, 3235, rls $".

PROCEDURE SENDING:
  DEFINE VARIABLE fq   as integer no-undo .
  define variable glog as logical no-undo .
  FOR EACH ub.cash-desk NO-LOCK WHERE
    ub.cash-desk.db-num = g#db-num
    AND ub.cash-desk.obj-code = i-obj-code
    and ub.cash-desk.pos-type = {&cd-type-IBM-XML}
    AND ub.cash-desk.cash-on
    BREAK
    By ub.cash-desk.pos-type :
    if not can-find (first buf_cash-desk-attr no-lock
      where buf_cash-desk-attr.db-num   = ub.cash-desk.db-num
      and buf_cash-desk-attr.obj-code = ub.cash-desk.obj-code
      and buf_cash-desk-attr.pos-type = ub.cash-desk.pos-type
      and buf_cash-desk-attr.cash-num = ub.cash-desk.cash-num
      and buf_cash-desk-attr.upper-attr-code = ub.cash-desk.pos-type + "_operative":U
      and buf_cash-desk-attr.attr-code       = "device-kind":U 
      and buf_cash-desk-attr.attr-value-integer = 4) then return .
    /*выполним действия, разнящиеся для разных типов касс -
    разные настройки в progress.ini - разные операции со spool-dir и т.д.*/
    IF FIRST-OF(ub.cash-desk.pos-type) then 
    do:
      { str/cdg-gen.i
      &cd-buffer=ub.cash-desk
      &subject=pay
      &data-by=object
      &cdt-ibm=no
      &cdt-ibm-xml=yes
      &cdt-maria=no

      }
/*пройдем цикл по всем кассам одного типа*/
RUN for-cash-cycle no-error.

END. /*IF FIRST-OF(ub.cash-desk.pos-type*/

/*выполним действия, разнящиеся для разных типов касс - подчистки, сообщения и т.д.*/

IF LAST-OF(ub.cash-desk.pos-type) then 
do:
  { str/cds-gen.i
      &cd-buffer=ub.cash-desk
      &subject=pay
      &data-by=object
      &cdt-ibm=no
      &cdt-ibm-xml=yes
      &cdt-maria=no
      &out-title="'Передача промоакций '"
      &out-title-add="'добавление промоакций '"
      &out-title-del="'удаление промоакций '"
      }
END.
END. /*FOR EACH cash-desk*/

END PROCEDURE.

/* $Workfile: cd-send16.i $ e n d */