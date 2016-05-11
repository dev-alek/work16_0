/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

сменный отчет - разброс чеков ЮКОС лист 2-4,8

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/07/05
Author: Bakhtadze Natalya
Creation date: 09/07/05

*/

DEFINE INPUT PARAMETER pobj-type    like ub.shift-obj.obj-type   no-undo.
DEFINE INPUT PARAMETER pobj-code    like ub.shift-obj.obj-code   no-undo.
DEFINE INPUT PARAMETER pshift-date  like ub.shift-obj.shift-date no-undo.
DEFINE INPUT PARAMETER pshift-num   like ub.shift-obj.shift-num  no-undo.
DEFINE INPUT PARAMETER pshift-date1 like ub.shift-obj.shift-date no-undo.
DEFINE INPUT PARAMETER pshift-num1  like ub.shift-obj.shift-num  no-undo.
DEFINE INPUT PARAMETER SHEETS       as integer                   no-undo.
/*закодировано какие листы печатаем в отчете*/
DEFINE INPUT PARAMETER SHEET2       as logical                   no-undo.
DEFINE INPUT PARAMETER SHEET3       as logical                   no-undo.
DEFINE INPUT PARAMETER SHEET4       as logical                   no-undo.
DEFINE INPUT PARAMETER SHEET8       as logical                   no-undo.
define input parameter pclassify    as logical                   no-undo.
define input parameter pselectgood  as logical                   no-undo.
define input parameter p-batch      as integer                   no-undo.

define variable vss-revision    AS CHAR NO-UNDO INIT "$Revision$":U.
define variable vss-author      AS CHAR NO-UNDO INIT "$Author$":U.
define variable vss-date        AS CHAR NO-UNDO INIT "$Date$":U.
define variable vss-workfile    AS CHAR NO-UNDO INIT "$Workfile$":U.
define variable vss-archive     AS CHAR NO-UNDO INIT "$Archive$":U.
define variable vss-description AS CHAR NO-UNDO INIT "Сменный отчет - алгоритм разброса чеков - лист 2-4":U.

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i }
{ str/lib-trn.i }
{ rep/rl-2df-1.i SHARED }
{ rep/rl-3df-1.i SHARED }
{ rep/rl-4df-1.i SHARED }
{ rep/rl-8df-1.i SHARED }
{ rep/icm-3df.i  SHARED }
{ rep/r-pychk0.i defalgo }
{ gbl/ggoattr.i }

define variable v-curr-r-b   as character no-undo .
define variable v-cli-type   as character no-undo .
define variable v-cli-code   as integer   no-undo .
define variable v-base-code  like ub.sysconf.base-code no-undo .
define variable v-host-code  as integer   no-undo .
define variable v-doc-code-r as character no-undo .
define variable v-doc-code-v as character no-undo .
define variable v-doc-code   as character no-undo .
define variable v-density    as decimal   no-undo .
define variable v-value      as character no-undo .
define variable v-type       as character no-undo .
define variable v-upper-code as integer   no-undo .
define variable v-p-accsup  as character no-undo .

define buffer buf_dis-card    for ub.dis-card.
define buffer buf_doc-line    for ub.doc-line.
define buffer buf_goods       for ub.goods.
define buffer buf_gds-grp     for ub.gds-grp.
define buffer buf_bar-code    for ub.bar-code.
define buffer buf_cash-pay    for ub.cash-pay.
define buffer buf_chk-gds-pay for ub.chk-gds-pay.
define buffer ras-doc         for ub.trn-doc.
define buffer ret-doc         for ub.trn-doc.

DEFINE BUFFER b-treal-2      for treal-2.
DEFINE BUFFER b-treal-3      for treal-3.
DEFINE BUFFER b-treal-4      for treal-4.
define buffer buf_t-3        for t-3.
define buffer cp-gds-treal-8 for treal-8.
define buffer gds-treal-8    for treal-8.
define buffer cp-treal-8     for treal-8.
define buffer cli-treal-8    for treal-8.

/* Учет расходных материалов */
{ gbl/conf-rd.i
  "'accsup'"
  "''"
  "''"
  0
  "''"
  "''"
  "''"
  no
  v-p-accsup
  v-type
  no-error
}

{ gbl/curr-r-b.i
  v-curr-r-b
}

{ gbl/hostcode.i pobj-type pobj-code v-host-code }
{ gbl/basecode.i v-host-code v-base-code }

if pclassify then do:
  FIND FIRST t-3 where t-3.grp-code = 0 No-ERROR.
end.

/*НАДО УБЕДИТЬСЯ ЧТО ВСЕ РАЗМАЗАНО!!*/
run rep/rpychk0.p ( input "r-shftc2"
                    ,input pobj-type
                    ,input pobj-code
                    ,input ? /*p-date-from*/
                    ,input ? /*p-date-to*/
                    ,input pshift-date /*p-shift-date-from*/
                    ,input pshift-date1 /*p-shift-date-to*/
                    ,input pshift-num /*p-shift-num-start*/
                    ,input pshift-num1 /*p-shift-num-end*/
                    ,input ? /*p-inkas-code*/
                    ).
_chk-doc:
FOR EACH ub.chk-doc No-LOCK WHERE
         ub.chk-doc.obj-type = pobj-type AND
         ub.chk-doc.obj-code = pobj-code AND
         ub.chk-doc.shift-date >= pshift-date AND
         ub.chk-doc.shift-date <= pshift-date1 AND
         ub.chk-doc.out-code <> ?
:
  if ub.chk-doc.shift-date = pshift-date  and ub.chk-doc.shift-num < pshift-num  then next _chk-doc.
  if ub.chk-doc.shift-date = pshift-date1 and ub.chk-doc.shift-num > pshift-num1 then next _chk-doc.
  if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0 then next _chk-doc.

  if sheet2 then do:
    if lookup(string(ub.chk-doc.chk-type), {&sale-in-receipt-codes}) > 0
    then do:
      if v-doc-code-r <> ub.chk-doc.out-code
      then do:
        find first ras-doc no-lock
          where ras-doc.doc-code = ub.chk-doc.out-code
          no-error .
        if not available ras-doc then do:
          message
          substitute("Отсутствует документ расхода по чеку &1"
                      , ub.chk-doc.doc-code
                      )   skip
          "ЭКСПОРТ НЕ МОЖЕТ БЫТЬ ОСУЩЕСТВЛЕН" SKIP
          view-as alert-box error .
          return error .
        end.
        assign v-doc-code-r = ras-doc.doc-code.
        
        /*
        first ret-doc no-lock where
                      ret-doc.doc-code = replace(ras-doc.out-code,"у","") no-error .
        
        
        if not available(ret-doc) then do:
            find first ret-doc no-lock where
                   ret-doc.doc-code = ras-doc.out-code no-error.
        end.
        
        if not available ret-doc then do:
          message
          substitute("Отсутствует документ возврата &1 по чеку &2"
                    , ras-doc.out-code
                    , ub.chk-doc.doc-code
                    )   skip
          "ЭКСПОРТ НЕ МОЖЕТ БЫТЬ ОСУЩЕСТВЛЕН" SKIP
          view-as alert-box error .
          return error .
        end.
        assign v-doc-code-v = ret-doc.doc-code.
        */
        
      end.
      assign
      v-doc-code = v-doc-code-v
      .
    end. /*if ub.chk-doc.netto < 0 then do:*/
    else do:
      assign
      v-doc-code = ub.chk-doc.out-code
      .
    end.
  end.
  _chk-doc:
  for each buf_chk-gds-pay where
          buf_chk-gds-pay.doc-code = ub.chk-doc.doc-code
      and buf_chk-gds-pay.algo-num = {&current-algo-1},
      FIRST buf_bar-code No-LOCK WHERE
              buf_bar-code.b-code =  buf_chk-gds-pay.b-code,
    first buf_cash-pay no-lock where
          buf_cash-pay.cdpay-code = buf_chk-gds-pay.pay-code
    and buf_cash-pay.curr-code = buf_chk-gds-pay.curr-code
    /*and (
          (buf_chk-gds-pay.pay-code = 1 and buf_cash-pay.curr-code = 0)
          or
          (buf_chk-gds-pay.pay-code > 1 and buf_cash-pay.curr-code = buf_chk-gds-pay.curr-code)
        )*/   :
    CASE entry(1, buf_chk-gds-pay.line-type, {&delim-par}):
      WHEN {&petrolium} then do:
        if sheet2 then do:
          FIND FIRST treal-2 No-LOCK WHERE
                    treal-2.gds-code = buf_bar-code.gds-code
                AND treal-2.cpay-code = buf_chk-gds-pay.pay-code
                AND treal-2.curr-code = buf_chk-gds-pay.curr-code
                AND treal-2.is-pay = yes No-ERROR.
          IF NOT AVAIL treal-2 then do:
            FIND last b-treal-2 No-LOCK WHERE
                      b-treal-2.gds-code = buf_bar-code.gds-code use-index vi No-ERROR.
            create treal-2.
            assign
            treal-2.gds-code = buf_bar-code.gds-code
            treal-2.cpay-code = buf_chk-gds-pay.pay-code
            treal-2.curr-code = buf_chk-gds-pay.curr-code
            treal-2.qnty1 = 0
            treal-2.qnty2 = 0
            treal-2.netto = 0
            treal-2.out-name = buf_cash-pay.obj-name
            treal-2.is-pay = yes
            treal-2.ii = (if avail b-treal-2
                          then b-treal-2.ii + 1
                          else 1)
            .
          END.
          find first buf_goods    no-lock where buf_goods.gds-code  =
                  buf_bar-code.gds-code no-error.
            v-density = 0.       
          if lookup(string(ub.chk-doc.chk-type), {&sale-in-receipt-codes}) > 0 then do: /* если чек возврата,то ищем хитро его документ */
              ret-doc:
            for each ret-doc fields( ret-doc.doc-code ret-doc.out-code ) no-lock where ret-doc.out-code = ub.chk-doc.out-code,
                first buf_doc-line no-lock where 
                  buf_doc-line.doc-code = ret-doc.doc-code AND
                  buf_doc-line.artic     = buf_goods.artic AND
                  buf_doc-line.prod-type = buf_goods.prod-type AND
                  buf_doc-line.prod-code = buf_goods.prod-code :
                      
               v-density =  buf_doc-line.fact-density
                            .
                   
                  leave ret-doc.           
            end.   
          end. 
          else do:
          find first buf_doc-line no-lock where
                    buf_doc-line.doc-code  = v-doc-code
                and buf_doc-line.artic     = buf_goods.artic
                and buf_doc-line.prod-type = buf_goods.prod-type
                and buf_doc-line.prod-code = buf_goods.prod-code  no-error.
          assign
          v-density = ( if available buf_doc-line
                            then buf_doc-line.fact-density
                            else 0 ).
          end.  
          assign
          treal-2.netto = treal-2.netto +
                                          (if v-curr-r-b = {&r-b-base}
                                          or v-base-code = 0
                                          then buf_chk-gds-pay.tot-r-b
                                          else (if  buf_chk-gds-pay.tot-r-b = 0
                                                then 0
                                                else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate))
          /*netto всегда в б.в.*/
          treal-2.qnty1 = treal-2.qnty1 + buf_chk-gds-pay.eff-doc-qnty
          treal-2.qnty2 = treal-2.qnty2 + buf_chk-gds-pay.eff-doc-qnty * v-density
          .
        end.
        if sheet8
        and ub.chk-doc.d-card <> '':U
        then do:
          if buf_cash-pay.register > 0 then do:
            if ub.chk-doc.cli-type = ?
            or ub.chk-doc.cli-code = ?
            or ub.chk-doc.cli-type = '':U
            or ub.chk-doc.cli-code = 0 then do:
              find first buf_dis-card no-lock where
                        buf_dis-card.d-card = ub.chk-doc.d-card no-error .
              if available buf_dis-card then do:
                assign
                v-cli-type = buf_dis-card.cli-type
                v-cli-code = buf_dis-card.cli-code
                .
              end.
            end.
            else do:
              assign
              v-cli-type = ub.chk-doc.cli-type
              v-cli-code = ub.chk-doc.cli-code
              .
            end.
            FIND FIRST treal-8 No-LOCK WHERE
                      treal-8.gds-code = buf_bar-code.gds-code
                  AND treal-8.cpay-code = 0
                  AND treal-8.curr-code = 0
                  AND treal-8.cli-type = v-cli-type
                  AND treal-8.cli-code = v-cli-code  No-ERROR.
            IF NOT AVAIL treal-8 then do:
              create treal-8.
              assign
              treal-8.gds-code = buf_bar-code.gds-code
              treal-8.cpay-code = 0
              treal-8.curr-code = 0
              treal-8.qnty1  =  0
              treal-8.netto = 0
              treal-8.cli-type = v-cli-type
              treal-8.cli-code = v-cli-code
              .
            END.
            assign
            treal-8.netto = treal-8.netto +  (if v-curr-r-b = {&r-b-base}
                                              or v-base-code = 0
                                              then buf_chk-gds-pay.tot-r-b
                                              else (if buf_chk-gds-pay.tot-r-b = 0
                                                    then 0
                                                    else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate))

            treal-8.qnty1 = treal-8.qnty1 + buf_chk-gds-pay.eff-doc-qnty
            treal-8.netto-rubl = treal-8.netto-rubl +  (if v-curr-r-b = {&r-b-rubl}
                                                        or v-base-code = 0
                                                        then buf_chk-gds-pay.tot-r-b
                                                        else (buf_chk-gds-pay.tot-r-b * buf_chk-gds-pay.eff-base-rate))

            .
            FIND FIRST cp-gds-treal-8 No-LOCK WHERE
                      cp-gds-treal-8.gds-code = buf_bar-code.gds-code
                  AND cp-gds-treal-8.cpay-code = buf_chk-gds-pay.pay-code
                  AND cp-gds-treal-8.curr-code = buf_chk-gds-pay.curr-code
                  AND cp-gds-treal-8.cli-type = '':U
                  AND cp-gds-treal-8.cli-code = 0  No-ERROR.
            if not available cp-gds-treal-8 then do:
              create cp-gds-treal-8.
              assign
              cp-gds-treal-8.gds-code = buf_bar-code.gds-code
              cp-gds-treal-8.cpay-code = buf_chk-gds-pay.pay-code
              cp-gds-treal-8.curr-code = buf_chk-gds-pay.curr-code
              cp-gds-treal-8.qnty1  =  0
              cp-gds-treal-8.netto = 0
              cp-gds-treal-8.cli-type = '':U
              cp-gds-treal-8.cli-code = 0
              .
            end.
            assign
            cp-gds-treal-8.netto = cp-gds-treal-8.netto +  (if v-curr-r-b = {&r-b-base}
                                              or v-base-code = 0
                                              then buf_chk-gds-pay.tot-r-b
                                              else (if buf_chk-gds-pay.tot-r-b = 0
                                                    then 0
                                                    else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate))
            cp-gds-treal-8.qnty1 = cp-gds-treal-8.qnty1 + buf_chk-gds-pay.eff-doc-qnty
            cp-gds-treal-8.netto-rubl = cp-gds-treal-8.netto-rubl +  (if v-curr-r-b = {&r-b-rubl}
                                                        or v-base-code = 0
                                                        then buf_chk-gds-pay.tot-r-b
                                                        else (buf_chk-gds-pay.tot-r-b * buf_chk-gds-pay.eff-base-rate))

            .
            FIND FIRST gds-treal-8 No-LOCK WHERE
                      gds-treal-8.gds-code = buf_bar-code.gds-code
                  AND gds-treal-8.cpay-code = 0
                  AND gds-treal-8.curr-code = 0
                  AND gds-treal-8.cli-type = '':U
                  AND gds-treal-8.cli-code = 0  No-ERROR.
            if not available gds-treal-8 then do:
              create gds-treal-8.
              assign
              gds-treal-8.gds-code = buf_bar-code.gds-code
              gds-treal-8.cpay-code = 0
              gds-treal-8.curr-code = 0
              gds-treal-8.qnty1  =  0
              gds-treal-8.netto = 0
              gds-treal-8.cli-type = '':U
              gds-treal-8.cli-code = 0
              .
            end.
            assign
            gds-treal-8.netto = gds-treal-8.netto +  (if v-curr-r-b = {&r-b-base}
                                              or v-base-code = 0
                                              then buf_chk-gds-pay.tot-r-b
                                              else (if buf_chk-gds-pay.tot-r-b = 0
                                                    then 0
                                                    else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate))

            gds-treal-8.qnty1 = gds-treal-8.qnty1 + buf_chk-gds-pay.eff-doc-qnty
            gds-treal-8.netto-rubl = gds-treal-8.netto-rubl +  (if v-curr-r-b = {&r-b-rubl}
                                                        or v-base-code = 0
                                                        then buf_chk-gds-pay.tot-r-b
                                                        else (buf_chk-gds-pay.tot-r-b * buf_chk-gds-pay.eff-base-rate))
            .
            FIND FIRST cp-treal-8 No-LOCK WHERE
                      cp-treal-8.gds-code = 0
                  AND cp-treal-8.cpay-code = buf_chk-gds-pay.pay-code
                  AND cp-treal-8.curr-code = buf_chk-gds-pay.curr-code
                  AND cp-treal-8.cli-type = '':U
                  AND cp-treal-8.cli-code = 0  No-ERROR.
            if not available cp-treal-8 then do:
              create cp-treal-8.
              assign
              cp-treal-8.gds-code = 0
              cp-treal-8.cpay-code = buf_chk-gds-pay.pay-code
              cp-treal-8.curr-code = buf_chk-gds-pay.curr-code
              cp-treal-8.qnty1  =  0
              cp-treal-8.netto = 0
              cp-treal-8.cli-type = '':U
              cp-treal-8.cli-code = 0
              .
            end.
            assign
            cp-treal-8.netto = cp-treal-8.netto +  (if v-curr-r-b = {&r-b-base}
                                              or v-base-code = 0
                                              then buf_chk-gds-pay.tot-r-b
                                              else (if buf_chk-gds-pay.tot-r-b = 0
                                                    then 0
                                                    else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate))
            cp-treal-8.qnty1 = cp-treal-8.qnty1 + buf_chk-gds-pay.eff-doc-qnty
            cp-treal-8.netto-rubl = cp-treal-8.netto-rubl +  (if v-curr-r-b = {&r-b-rubl}
                                                        or v-base-code = 0
                                                        then buf_chk-gds-pay.tot-r-b
                                                        else (buf_chk-gds-pay.tot-r-b * buf_chk-gds-pay.eff-base-rate))

            .
            FIND FIRST cli-treal-8 No-LOCK WHERE
                      cli-treal-8.gds-code = 0
                  AND cli-treal-8.cpay-code = 0
                  AND cli-treal-8.curr-code = 0
                  AND cli-treal-8.cli-type = v-cli-type
                  AND cli-treal-8.cli-code = v-cli-code  No-ERROR.
            if not available cli-treal-8 then do:
              create cli-treal-8.
              assign
              cli-treal-8.gds-code = 0
              cli-treal-8.cpay-code = 0
              cli-treal-8.curr-code = 0
              cli-treal-8.qnty1  =  0
              cli-treal-8.netto = 0
              cli-treal-8.cli-type = v-cli-type
              cli-treal-8.cli-code = v-cli-code
              .
            end.
            assign
            cli-treal-8.netto = cli-treal-8.netto +  (if v-curr-r-b = {&r-b-base}
                                              or v-base-code = 0
                                              then buf_chk-gds-pay.tot-r-b
                                              else (if buf_chk-gds-pay.tot-r-b = 0
                                                    then 0
                                                    else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate))
            cli-treal-8.qnty1 = cli-treal-8.qnty1 + buf_chk-gds-pay.eff-doc-qnty
            cli-treal-8.netto-rubl = cli-treal-8.netto-rubl +  (if v-curr-r-b = {&r-b-rubl}
                                                        or v-base-code = 0
                                                        then buf_chk-gds-pay.tot-r-b
                                                        else (buf_chk-gds-pay.tot-r-b * buf_chk-gds-pay.eff-base-rate))

            .
          end. /*if available temp-cash-pay-attr then do:*/
        end. /*if sheet8*/
      END.
      WHEN {&gds-goods} then do:
        if sheet3 then do:
          FIND FIRST buf_goods No-LOCK WHERE
                      buf_goods.gds-code = buf_bar-code.gds-code No-ERROR.
          if pclassify then do:
            if pselectgood then do:
              FIND FIRST buf_t-3 where
                        buf_goods.grp-name begins buf_t-3.serv-name No-ERROR.
              if not avail buf_t-3 then do:
              end.
            end.
          end.
          else dO:
            FIND FIRST t-3 where
                      buf_goods.grp-name begins t-3.serv-name No-ERROR.
            if not avail t-3 then do:
            end.
          end.
          
          /* #2789 Если есть атрибут группы товара Не учитывать в автоматической отчетности, то пропускаем товар */
          v-upper-code = buf_goods.grp-code.
          v-value = "".
          do while v-upper-code > 0 and v-p-accsup = "yes" and p-batch > 0:      
              find first ub.gds-grp where ub.gds-grp.node-code = v-upper-code.
              
              run ggoattr-value(
                input ub.gds-grp.node-code,
                input 0,
                input "",
                input 0,
                input {&ggoattr-no-inc-auto-rep},
                output v-value,
                output v-type
              ).
              
              if v-value = "yes" then
                leave.
              else
                v-upper-code = ub.gds-grp.upper-code.
          end. 
          /* ------ */
          
          if avail t-3 and v-value <> "yes"  then do:
            FIND FIRST treal-3 No-LOCK WHERE
                      treal-3.grp-code = t-3.grp-code-sheet
                  AND treal-3.cpay-code = buf_chk-gds-pay.pay-code
                  AND treal-3.curr-code = buf_chk-gds-pay.curr-code
                      No-ERROR.
            IF NOT AVAIL treal-3 then do:
              FIND last b-treal-3 No-LOCK WHERE
                        b-treal-3.grp-code-sheet = t-3.grp-code-sheet use-index vi No-ERROR.
              create treal-3.
              assign
              treal-3.grp-code-sheet = t-3.grp-code-sheet
              treal-3.cpay-code = buf_chk-gds-pay.pay-code
              treal-3.curr-code = buf_chk-gds-pay.curr-code
              treal-3.qnty1  =  0
              treal-3.netto = 0
              treal-3.is-pay = yes
              treal-3.out-name = buf_cash-pay.obj-name
              treal-3.ii = (if avail b-treal-3
                            then b-treal-3.ii + 1
                            else 1)
              .
            END.
            assign
            treal-3.netto = treal-3.netto + (if v-curr-r-b = {&r-b-base}
                                              or v-base-code = 0
                                              then buf_chk-gds-pay.tot-r-b
                                              else (if buf_chk-gds-pay.tot-r-b = 0
                                                    then 0
                                                    else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate)
                                              )
            treal-3.qnty1 = treal-3.qnty1 + buf_chk-gds-pay.eff-doc-qnty
            .
          end. /*if avail t-3*/
        END.
      END.
      WHEN {&gds-office} then do:
        if sheet4 then do:
          FIND FIRST treal-4 No-LOCK WHERE
                    treal-4.gds-code = buf_bar-code.gds-code
                AND  treal-4.cpay-code = buf_chk-gds-pay.pay-code
                AND  treal-4.curr-code = buf_chk-gds-pay.curr-code
                AND  treal-4.is-pay = yes
                    No-ERROR.
          IF NOT AVAIL treal-4 then do:
            FIND last b-treal-4 No-LOCK WHERE
                      b-treal-4.gds-code = buf_bar-code.gds-code use-index vi No-ERROR.

            create treal-4.
            assign
            treal-4.gds-code = buf_bar-code.gds-code
            treal-4.cpay-code = buf_chk-gds-pay.pay-code
            treal-4.curr-code = buf_chk-gds-pay.curr-code
            treal-4.qnty1  =  0
            treal-4.netto = 0
            treal-4.out-name = buf_cash-pay.obj-name
            treal-4.is-pay = yes
            treal-4.ii =  (if avail b-treal-4
                          then b-treal-4.ii + 1
                          else 1)
            .
          END.
          assign
          treal-4.netto = treal-4.netto + (if v-curr-r-b = {&r-b-base}
                                              or v-base-code = 0
                                              then buf_chk-gds-pay.tot-r-b
                                              else (if buf_chk-gds-pay.tot-r-b = 0
                                                    then 0
                                                    else buf_chk-gds-pay.tot-r-b / buf_chk-gds-pay.eff-base-rate)
                                              )
          treal-4.qnty1 = treal-4.qnty1 + buf_chk-gds-pay.eff-doc-qnty
          .
          END.
      END.
    END CASE.
  end. /*    for each buf_chk-gds-pay where*/

END. /*FOR EACH ub.chk-doc No-LOCK WHERE*/