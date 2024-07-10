/*

$Revision: e455fc319afd, 3602, rls $
$Author: ARostovtsev $
$Date: 2023/12/28 12:56:37 $
$Workfile: send-promo.p $
$Archive: str/send-promo.p $

пересылка QR-code на кассу

Автор: Шкляр Елена
Дата создания: 09/20/05
Author: Shklyar Elena
Creation date: 09/20/05

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter i-obj-code like ub.shop.obj-code no-undo.
DEFINE INPUT PARAMETER action as char no-undo.
DEFINE INPUT PARAMETER selective as integer no-undo.
define input parameter recid-list as character no-undo .
define input parameter p-log-file-name as character no-undo .
define input-output parameter p-view-log as logical no-undo .

define variable vss-revision    as character no-undo init "$Revision: e455fc319afd, 3602, rls $":U .
define variable vss-author      as character no-undo init "$Author: ARostovtsev $":U .
define variable vss-date        as character no-undo init "$Date: 2023/12/28 12:56:37 $":U .
define variable vss-workfile    as character no-undo init "$Workfile: send-qr.p $":U .
define variable vss-archive     as character no-undo init "$Archive: str/send-qr.p $":U .
define variable vss-description as character no-undo init "Пересылка QR-code на кассы".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }
{ bge/bgelib.i }
{ str/cd-xml.i }
{ str/cdsnddef.i }
{ ref/cp-attr.i }
/*{ str/cp-isuse.i }*/
/*{ ref/gds-attr.i }*/

DEFINE VARIABLE kassa-rub-code       as integer.
DEFINE VARIABLE ibmnalc              as integer   no-undo .
define variable multicurr            as logical   no-undo .
define variable conf-attr            as character no-undo .
DEFINE VARIABLE conf-par             as character no-undo.                  /* для чтения параметра конфигурации */
DEFINE VARIABLE par-type             as character no-undo.
DEFINE VARIABLE dopi                 as decimal   no-undo.
DEFINE VARIABLE ii                   as integer   no-undo.
define variable v-host-code          like ub.sysconf.host-code no-undo .
define variable v-cp-is-use          as logical   no-undo .
define variable mariapayg            as character no-undo .
define variable mariapayp            as character no-undo .
/*список соответствий по скидкам для кассы мария */
define variable dr-list              as character no-undo .
/*список приоритетов шаблонов правл скидок для скидок по группе товара*/
define variable drcprank             as character no-undo .
define variable v-record             as character no-undo .
define variable v-found-maria-discnt as logical   no-undo .
define stream finp.
define buffer buf_cash-desk-attr for ub.cash-desk-attr .


/*PROCEDURE putc-gds.*/
/*разнящийся вывод для разных типов касс*/
procedure putc-61 :
  define input parameter p-pos-type as character no-undo .
  define variable v-value              as character no-undo .
  define variable v-type               as character no-undo .
  define variable v-index              as integer   no-undo .
  define variable v-ii                 as integer   no-undo .
  define variable v-jj                 as integer   no-undo .
  define variable v-plu                as character no-undo .
  define variable v-dop                as character no-undo .
  define variable v-dop2               as character no-undo .
  define variable v-cp-attr-code       as character no-undo .
  define variable attr-value           as character no-undo .
  define variable attr-type            as character no-undo .
  define variable v-maria-rule-num     as integer   no-undo .
  define variable v-maria-discnt-value as character no-undo .
  define variable v-skip-fields        as integer   no-undo .
  define variable v-version-dec        as decimal   no-undo .
  define variable v-paymentetc         as character no-undo .
  define buffer BUF_DIS-RULE      for UB.DIS-RULE.
  define buffer buf_dis-cp-rule   for ub.dis-cp-rule.
  define buffer buf_cash-pay-attr for ub.cash-pay-attr.

  define variable v-mode         as character no-undo . /* create/update */
  define variable v-retfl        as logical   no-undo .
      
  define variable v-i-num        as integer   no-undo .
  define variable v-i-counter    as integer   no-undo .
  define variable v-j-num        as integer   no-undo .
  define variable v-j-counter    as integer   no-undo .
  define variable v-stub         as integer   no-undo .
  define variable vTypePay       as character no-undo.
  define variable vIp            as integer   no-undo.
  define VARIABLE name-cash      as character no-undo.
  define VARIABLE name-cash1     as character no-undo.
  define VARIABLE name-cash2     as character no-undo.
  define variable ufo-passwd     as character no-undo.
  define variable ufo-enc20      as character format "x(20)" no-undo.
  define variable enc-passwd     as character no-undo.
  define variable v-psswd        as character no-undo .
  /* 23/V-2018 на время input throught ... появляется консольное окно;
               вместо этого делаем os-command no-console ... с выводом в файл */
  define variable v-shadow-fname as character no-undo .
  define buffer buf_clients for ub.clients .

  define variable v-attr-type as character no-undo .
  do
    on error undo, return error
    :
    if selective = 0 then 
    do:
    end.
    else 
    do:
      do ii = 0 to num-entries(recid-list,{&comma-char}):
        FIND FIRST ub.staff-attr No-LOCK WHERE
          recid(ub.staff-attr) = integer(entry(ii,recid-list,{&comma-char})) No-ERROR.
        IF avail ub.staff-attr then
        do:
          v-shadow-fname = substitute( "pass&1.dat" , string(random(1, 80000), "99999") ) .
          find first ub.staff no-lock where ub.staff.staff-code = ub.staff-attr.staff-code and
            ub.staff.role-level = ub.staff-attr.role-level and
            ub.staff.role = ub.staff-attr.role no-error .
          find first ub.person where ub.person.psn-code = ub.staff.psn-code no-error.

          run bgelib-tag-open in this-procedure ( input 2, input "Cashier", input substitute("ctrl='&1' tms='&2' code='&3'"
            , (if action = "U":U
            then "ADD":U
            else "DEL":U)
            , OS2-time
            , ub.staff.psn-code)).

          if available ub.person
            then 
          do:                       
            find FIRST buf_clients no-lock WHERE
              buf_clients.obj-type = {&prs}
              AND buf_clients.obj-code = ub.person.psn-code no-error .                                                            
            name-cash1 = if ub.person.name1 <> "" then (substring(ub.person.name1,1,1) + '.') else ''.
            name-cash2 = if ub.person.name2 <> "" then (substring(ub.person.name2,1,1) + '.') else ''.
            name-cash = buf_clients.obj-name + ' ' + name-cash1 + ' ' + name-cash2 .
          end.

          run bgelib-tag-put in this-procedure ( input 3, input "CashierName"         , input name-cash, input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "CashierParol"        , input ub.staff.password, input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "CashierLock"         , input if staff.date-end < today then 1 else 0, input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "CashierINN"          , input if available person then string(person.inn) else "", input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "CashierShadow"       , input enc-passwd, input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "CashierQRCode"       , input ub.staff-attr.attr-value, input 1 ).
          run bgelib-tag-close in this-procedure ( input 2, input "Cashier").
        END.
      end.
    END.
  end.

end procedure. /* putc-61 */

/*PROCEDURE for-cash-cycle*/
/*пройдем цикл по всем кассам одного типа*/

{ str/cd-cycl61.i }

/*PROCEDURE SENDING.*/

{ str/cd-send61.i }

assign
  log-file-name = p-log-file-name
  .

{ gbl/hostcode.i {&shop} i-obj-code v-host-code }
if action = "D" and not g#esys and not g#news and selective <> 1
  then 
do:
  message
    "Вы действительно хотите удалить с кассы записи промоакций?"
    view-as alert-box QUESTION buttons YES-NO update glog.
  if not glog then return.
end.
if action = 'D':U then 
do:
  assign
    v-cp-is-use = no.
end.

RUN SENDING no-error.
if error-status:error then 
do:
  run write-log-and-file in p-log-handle (
    input 1
    , input log-file-name
    , input 1
    , input substitute( "!!!Ошибки при отсылке промоакций на кассы  маг&1:&2&3 &4"
    , i-obj-code
    , {&new-line}
    , error-status:get-message(1)
    , return-value
    )
    ).

  assign
    v-view-log = yes
    .
end.
run write-log-and-file in p-log-handle (
  input 1
  , input log-file-name
  , input 1
  , input substitute("Сформированы файлы для касс объекта &1&2", {&shop}, i-obj-code)
  ).