/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 18 окт. 2019 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 18 окт. 2019 г.

*/
define input  parameter parparentproc as handle no-undo.
define input  parameter ICashbook     as int64 no-undo.
define input  parameter iBegDate      as date no-undo.

define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/str-glbl.i }
{ cmp/vssrevis.i }
{ gbl/getcntxt.i def }
define variable mFactOrder as decimal no-undo.
{ gbl/getcntxt.i get }
{ cmp/library.i  }
{ trg/factord.i  }
{ gbl/thbjattr.i }

run day-begin-fact-order in this-procedure
    ( input date (1,1,year(iBegDate))
     ,output mFactOrder
    ).
define variable mlisttype as character no-undo.

define variable mi as integer no-undo.
define variable mOldYear as integer no-undo.
define variable mcount as integer no-undo.
define variable mValue as character no-undo.
define variable mask as character no-undo.
define variable v-cashbookrule-key-rec as character no-undo.

define variable objKeyRec as ibs.th.gbl.keyrec no-undo.
define variable objCount  as ibs.th.ref.counter.counterstorage no-undo.

define buffer buf_fin-doc for fin-doc.
define variable v-value-character like ub.thbj-attr.property-value-character no-undo .
define variable v-value-date      like ub.thbj-attr.property-value-date no-undo .
define variable v-value-decimal   like ub.thbj-attr.property-value-decimal no-undo .
define variable v-value-logical   like ub.thbj-attr.property-value-logical no-undo .
define variable v-value-integer   like ub.thbj-attr.property-value-integer no-undo .
define variable v-recount         as logical   no-undo .
define variable varcontract-type  as character no-undo .
define variable v-mastc           as logical   no-undo init false .
    run adm/shattri.p (
      input "get":U
      ,input v-cntxt-obj-type
      ,input v-cntxt-obj-code
      ,input {&attr-contr-in}
      ,input  "contr-recount"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-recount
      ,output varcontract-type
      ,INPUT-OUTPUT TABLE thbjattr_thbj-attr
      ) no-error .
      if error-status :error then
      message
        vss-workfile vss-revision vss-description skip
        error-status :get-message(1) skip
        return-value skip
        "adm/shattri.p"
        view-as alert-box error
      .
      if v-recount <> true then return no-apply .
subscribe   to "getCounter" anywhere run-procedure "Mycounter". 
mlisttype = {&FDEDT_Income_Cash} + "," + {&FDEDT_Expense_Cash}.

objKeyRec = new ibs.th.gbl.keyrec().
objCount  = new ibs.th.ref.counter.counterstorage().

for each cashbook where CashBook.id eq ICashbook no-lock:
   do mi = 1 to num-entries (mlisttype):
      
      find first CashBookRule where CashBookRule.CashBookID eq cashbook.id
                                and CashBookRule.Obj-type   eq v-cntxt-obj-type
                                and CashBookRule.Obj-code   eq v-cntxt-obj-code
                                and CashBookRule.Code       eq entry(mi,"PkoMask,RkoMask")
      no-lock no-error.
      if available CashBookRule
      then
         mask = CashBookRule.RuleValue.
      else
          mask = "[NNNN]/[obj-code]".
      mcount = 0.
      do trans:
         for each fin-doc where fin-doc.CashBookId   eq CashBook.id
                            and fin-doc.obj-type     eq v-cntxt-obj-type
                            and fin-doc.obj-code     eq v-cntxt-obj-code
                            and fin-doc.fin-doc-type eq entry(mi,mlisttype)
                            and fin-doc.fact-order  >= mFactOrder
         exclusive-lock:
             if mOldYear ne year(fin-doc.fact-date)
             then assign
                mOldYear =  year(fin-doc.fact-date)
                mcount   = 0
             .
             run utl/maskproc.p(parparentproc, mask, "cashbook", fin-doc.CashBookId, output fin-doc.prn-doc-code).
             /*if fin-doc.prn-doc-code ne mValue
             then do trans:
                find first buf_fin-doc where recid(buf_fin-doc) eq recid(fin-doc)
                exclusive-lock no-error.
                if available buf_fin-doc
                then do:
                   buf_fin-doc
                end.
             end.*/
              
         end.
         find first CashBookRule where CashBookRule.CashBookID eq cashbook.id
                                and CashBookRule.Obj-type   eq v-cntxt-obj-type
                                and CashBookRule.Obj-code   eq v-cntxt-obj-code
                                and CashBookRule.Code       eq entry(mi,"currPko,currRko") 
      no-lock no-error.
         objKeyRec:GenKeyRec ( input {&table_cashbookrule}
                                            ,input buffer ub.cashbookrule:handle
                                            ,output v-cashbookrule-key-rec).
        find first clients where clients.obj-type eq cashbookrule.obj-type
                             and clients.obj-code eq cashbookrule.obj-code
                             no-lock no-error.
         if     available clients
            and clients.db-num ne ?
         then                    
            objcount:SetCountValue(clients.db-num,"cashbookrule",v-cashbookrule-key-rec,if mi eq 1 then "currPKO" else "currRKO",mcount).
         
      end.
   end.
end.      
delete object objKeyRec.
delete object objCount.    
unsubscribe to "getCounter".

 procedure Mycounter:
define input  parameter iFileName as character no-undo.
define input  parameter ikey      as character no-undo.
define input  parameter icode     as character no-undo.
define output parameter oCount    as int64 no-undo.
assign
   mcount = mcount + 1
   oCount = mcount
. 
end procedure.