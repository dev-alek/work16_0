/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Общие определения для касс и чтения чеков

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/13/05
Author: Bakhtadze Natalya
Creation date: 10/13/05

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{ cmp/trg-def.i }
{ gbl/cd-attr.i }
define {1} shared variable base-cass as int no-undo.
define {1} shared variable right-curs as log no-undo.
define {1} shared variable curr-list as char no-undo.
define {1} shared variable pay-list as character no-undo.
define {1} shared variable nal as integer no-undo.
define {1} shared variable kassa-rub-code      as  integer  no-undo .
define {1} shared variable unq-artc as logical no-undo init no. /*настройка - уникальный цифровой артикул + ДОПБК = артикулу*/
define {1} shared variable val-abbr as character no-undo.
define {1} shared variable val-cass as character no-undo.
define {1} shared variable val-shop as character no-undo.
define {1} shared variable pay-val as character no-undo.
define {1} shared variable pay-cass as character no-undo.
define {1} shared variable pay-shop as character no-undo.
define {1} shared variable nal-rub as integer no-undo.
define {1} shared variable abbr as character no-undo.
define {1} shared variable pay-nal as integer no-undo.
define {1} shared variable cass-card as character no-undo.
define {1} shared variable trade-card as character no-undo.
define {1} shared variable curr-card as character no-undo.
define {1} shared variable not-nal as integer no-undo. /* Безнал опл р_убли , то "rubl" */
define {1} shared variable lll as int no-undo initial 0. /*счетчик принятых чеков*/
define {1} shared variable ibmspool as character no-undo . /*тип спула IBM*/
define {1} shared variable ibmgroup as logical no-undo init yes. /*настройка - читать чеки с продажей по группам - касса IBM*/
define {1} SHARED variable specgrp as character no-undo init '':U. /*настройка - спец суммовые групп касса IBM IBm-XML*/

define {1} shared variable varscales-pref as character no-undo .
define {1} shared variable varpgscales-pref as character no-undo .

&if "{1}" = "new" &then
{ str/sclspref.i varscales-pref varpgscales-pref }
&endif

 

define variable os-er as integer.
/* для чтения параметра конфигурации */
define variable v-index as integer no-undo .
define variable conf-attr as character no-undo.
define variable conf-par as character no-undo.
define variable par-type as character no-undo.

define {1} SHARED temp-table chk_doc no-undo
field doc-code as char
field chk-date as date
field chk-time as int
field chk-num as int
field g-lines as int
field p-lines as int
.

define temp-table tt-sum-grp no-undo
like  ub.sum-grp
field code-2 as integer
field gtype as integer
.

procedure get-last-check-date-time :
define input parameter p-db-num like ub.cash-desk.db-num no-undo .
define input parameter p-obj-code like ub.cash-desk.obj-code no-undo .
define input parameter p-pos-type like ub.cash-desk.pos-type no-undo .
define input parameter p-cash-num like ub.cash-desk.cash-num no-undo .
define output parameter p-date like ub.chk-doc.chk-date no-undo .
define output parameter p-time like ub.chk-doc.chk-time no-undo .

define variable v-last-date like ub.chk-doc.chk-date no-undo .
define variable v-last-time like ub.chk-doc.chk-date no-undo .
define variable v-character as character no-undo .
define variable v-date as date no-undo .
define variable v-decimal as decimal no-undo .
define variable v-integer as integer no-undo .
define variable v-logical as logical no-undo .
define variable v-attr-type as character no-undo .
define buffer buf_chk-doc for ub.chk-doc.
define buffer buf_c-cash-desk for ub.c-cash-desk.


  do
  on error undo, return error
  :
      run cd-attr-value in this-procedure (
                                                 input g#db-num
                                                ,input p-obj-code
                                                ,input p-pos-type
                                                ,input p-cash-num
                                                ,input {&cda-magia-xml_operative}
                                                ,input {&cda-magia-xml_operative_last-check-date-time}
                                                ,output v-character
                                                ,output v-date
                                                ,output v-decimal
                                                ,output v-integer
                                                ,output v-logical
                                                ,output v-attr-type     ) no-error.
      if v-character = "":U
      or v-character = ?
      then do:
        FIND FIRST BUF_c-CASh-DESK NO-LOCK where
                   buf_c-cash-desk.db-num = g#db-num
               AND buf_c-cash-desk.pos-type = p-pos-type
               AND buf_c-cash-desk.cash-num = p-cash-num
               AND buf_c-cash-desk.subject  = {&table_cash-desk}
               and buf_c-cash-desk.action = integer({&hn-create}) use-index pi no-error .
       if available buf_c-cash-desk then do:
        assign
        p-date = buf_c-cash-desk.corr-date
        p-time = buf_c-cash-desk.corr-time
        .
       end.
       else do:
          find first buf_chk-doc no-lock where
                  buf_chk-doc.obj-type = {&shop}
              AND buf_chk-doc.obj-code = p-obj-code no-error.
          if not available buf_chk-doc then do:
            return error.
          end.
          assign
          p-date = buf_chk-doc.chk-date - 1
          p-time = buf_chk-doc.chk-time
          .
        end.
      end.
      else do:
        assign
        p-date =  cd-attr-parse-date-time( v-character, output p-time )
        no-error .
        if error-status:error then return error .
      end.
  end.

end procedure. /* get-last-closed-check-by-cash-desk */


procedure get-last-check-params :
define input parameter p-db-num like ub.cash-desk.db-num no-undo .
define input parameter p-obj-code like ub.cash-desk.obj-code no-undo .
define input parameter p-pos-type like ub.cash-desk.pos-type no-undo .
define input parameter p-cash-num like ub.cash-desk.cash-num no-undo .
define output parameter p-date like ub.chk-doc.chk-date no-undo .
define output parameter p-time like ub.chk-doc.chk-time no-undo .
define output parameter p-shift-num like ub.chk-doc.shift-num no-undo init 0.
define output parameter p-z-count like ub.chk-doc.z-number no-undo init 0.
define output parameter p-chk-num like ub.chk-doc.chk-num no-undo init 0.

define variable v-last-date like ub.chk-doc.chk-date no-undo .
define variable v-last-time like ub.chk-doc.chk-date no-undo .
define variable v-character as character no-undo .
define variable v-date as date no-undo .
define variable v-decimal as decimal no-undo .
define variable v-integer as integer no-undo .
define variable v-logical as logical no-undo .
define variable v-attr-type as character no-undo .
define buffer buf_chk-doc for ub.chk-doc.
define buffer buf_c-cash-desk for ub.c-cash-desk.


  do
  on error undo, return error
  :
      run cd-attr-value in this-procedure (
                                                 input g#db-num
                                                ,input p-obj-code
                                                ,input p-pos-type
                                                ,input p-cash-num
                                                ,input {&cda-ibm-xml_operative}
                                                ,input {&cda-ibm-xml_operative_last-check-params}
                                                ,output v-character
                                                ,output v-date
                                                ,output v-decimal
                                                ,output v-integer
                                                ,output v-logical
                                                ,output v-attr-type     ) no-error.
      if v-character = "":U
      or v-character = ?
      then do:
        FIND FIRST BUF_c-CASh-DESK NO-LOCK where
                   buf_c-cash-desk.db-num = g#db-num
               AND buf_c-cash-desk.pos-type = p-pos-type
               AND buf_c-cash-desk.cash-num = p-cash-num
               AND buf_c-cash-desk.subject  = {&table_cash-desk}
               and buf_c-cash-desk.action = integer({&hn-create}) use-index pi no-error .
       if available buf_c-cash-desk then do:
        assign
        p-date = buf_c-cash-desk.corr-date
        p-time = buf_c-cash-desk.corr-time
        .
       end.
       else do:
          find first buf_chk-doc no-lock where
                  buf_chk-doc.obj-type = {&shop}
              AND buf_chk-doc.obj-code = p-obj-code no-error.
          if not available buf_chk-doc then do:
            return error.
          end.
          assign
          p-date = buf_chk-doc.chk-date - 1
          p-time = buf_chk-doc.chk-time
          p-shift-num = buf_chk-doc.shift-num
          p-z-count = buf_chk-doc.z-number
          p-chk-num = buf_chk-doc.chk-num
          .
        end.
      end.
      else do:
        assign
        p-date =  cd-attr-parse-date-time( substring(v-character, 1, 19), output p-time )
        p-shift-num = integer(entry(3, v-character, {&space-char} ))
        p-shift-num = (if p-shift-num = ? then 0 else p-shift-num)
        p-z-count = integer(entry(4, v-character, {&space-char} ))
        p-z-count = (if p-z-count = ? then 0 else p-z-count)
        p-chk-num = integer(entry(5, v-character, {&space-char} ))
        no-error .
        if error-status:error then return error .
      end.
  end.

end procedure. /* get-last-closed-check-by-cash-desk */


procedure get-last-check-maria :
define input parameter p-db-num like ub.cash-desk.db-num no-undo .
define input parameter p-obj-code like ub.cash-desk.obj-code no-undo .
define input parameter p-cash-num like ub.cash-desk.cash-num no-undo .
define output parameter p-date like ub.chk-doc.chk-date no-undo .
define output parameter p-z-count like ub.chk-doc.z-number no-undo init 0.
define output parameter p-num-recs as integer no-undo .
define output parameter p-p-date like ub.chk-doc.chk-date no-undo .
define output parameter p-p-z-count like ub.chk-doc.z-number no-undo init 0.
define output parameter p-p-num-recs as integer no-undo .


define variable v-last-date like ub.chk-doc.chk-date no-undo .
define variable v-last-time like ub.chk-doc.chk-date no-undo .
define variable v-character as character no-undo .
define variable v-date as date no-undo .
define variable v-decimal as decimal no-undo .
define variable v-integer as integer no-undo .
define variable v-logical as logical no-undo .
define variable v-attr-type as character no-undo .
define buffer buf_chk-doc for ub.chk-doc.
define buffer buf_c-cash-desk for ub.c-cash-desk.


  do
  on error undo, return error
  :
      run cd-attr-value in this-procedure (
                                                 input p-db-num
                                                ,input p-obj-code
                                                ,input {&cd-type-maria}
                                                ,input p-cash-num
                                                ,input {&cda-maria_operative}
                                                ,input {&cda-maria_operative_last-check-maria}
                                                ,output v-character
                                                ,output v-date
                                                ,output v-decimal
                                                ,output v-integer
                                                ,output v-logical
                                                ,output v-attr-type     ) no-error.
      if v-character = "":U
      or v-character = ?
      then do:
        FIND FIRST BUF_c-CASh-DESK NO-LOCK where
                   buf_c-cash-desk.db-num = p-db-num
               AND buf_c-cash-desk.pos-type = {&cd-type-maria}
               AND buf_c-cash-desk.cash-num = p-cash-num
               AND buf_c-cash-desk.subject  = {&table_cash-desk}
               and buf_c-cash-desk.action = integer({&hn-create}) use-index pi no-error .
       if available buf_c-cash-desk then do:
        assign
        p-date = buf_c-cash-desk.corr-date
        p-p-date = buf_c-cash-desk.corr-date
        .
       end.
       else do:
          find first buf_chk-doc no-lock where
                  buf_chk-doc.obj-type = {&shop}
              AND buf_chk-doc.obj-code = p-obj-code no-error.
          if not available buf_chk-doc then do:
            assign
            p-date = 01/01/1990
            p-z-count = 1
            p-num-recs = 0
            p-p-date = 01/01/1990
            p-p-z-count = 1
            p-p-num-recs = 0
            .
          end.
          assign
          p-date = buf_chk-doc.chk-date - 1
          p-z-count = (if buf_chk-doc.z-number = ? then 1 else  buf_chk-doc.z-number)
          p-num-recs = 0
          p-p-date = buf_chk-doc.chk-date - 1
          p-p-z-count = (if buf_chk-doc.z-number = ? then 1 else  buf_chk-doc.z-number)
          p-p-num-recs = 0
          .
        end.
      end.
      else do:
        assign
        p-date =  date( integer(entry(2, entry(1, v-character, {&space-char}), '-':U))
                      ,integer(entry(3, entry(1, v-character, {&space-char}), '-':U))
                      ,integer(entry(1, entry(1, v-character, {&space-char}), '-':U))
                      )
        p-z-count = integer(entry(2, v-character, {&space-char} ))
        p-z-count = (if p-z-count = ? then 0 else p-z-count)
        p-num-recs = integer(entry(3, v-character, {&space-char} ))
        p-num-recs = (if p-num-recs = ? then 0 else p-num-recs)
        p-p-date =  date( integer(entry(2, entry(4, v-character, {&space-char}), '-':U))
                      ,integer(entry(3, entry(4, v-character, {&space-char}), '-':U))
                      ,integer(entry(1, entry(4, v-character, {&space-char}), '-':U))
                      )
        p-p-z-count = integer(entry(5, v-character, {&space-char} ))
        p-p-z-count = (if p-z-count = ? then 0 else p-z-count)
        p-p-num-recs = integer(entry(6, v-character, {&space-char} ))
        p-p-num-recs = (if p-p-num-recs = ? then 0 else p-p-num-recs)
        no-error .
        if error-status:error then return error .
      end.
  end.

end procedure. /* get-last-check-maria */


/* $Workfile$ e n d */