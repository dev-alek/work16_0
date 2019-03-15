/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пересылка на кассы после импорта откуда-нибудь

Автор: Бахтадзе Наталья Викторовна
Дата создания: 02/27/09
Author: Bakhtadze Natalya
Creation date: 02/27/09

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{ cmp/gds-list.i gds-list def "new shared" }
{ cmp/dc-list.i  dc-list  def " new shared "  } /*не должен использоваться в load-rec.p*/
{ cmp/dcp-list.i  dcp-list  def " new shared "  } /*не должен использоваться в load-rec.p*/
{ cmp/stpllist.i stpl-list  def " new shared "  }
{ cmp/pbc-list.i pbc-list def new } /*не должен использоваться в load-rec.p*/
{ cmp/bc-list.i bc-list def new }  /*не должен использоваться в load-rec.p*/
{ cmp/gdsolist.i gdsolist def "new shared" } /*не должен использоваться в load-rec.p*/
{ str/defc-txn.i "new shared" } /*не должен использоваться в load-rec.p*/
{ str/defc-txr.i "new shared" } /*не должен использоваться в load-rec.p*/
{ str/pdf-list.i pdf-list def "new shared" }

procedure send-to-cash:
  if not can-find(first ub.cash-desk where
                  ub.cash-desk.db-num = ibs.th.gbl.gbl-var:g#db-num AND
                  ub.cash-desk.cash-on = yes) then return.


  do
  on error  undo , return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
  on stop   undo , return error substitute( "&1. stop", vss-workfile )
  on endkey undo , return error substitute( "&1. endkey", vss-workfile )
  :
    if can-find(first gds-list no-lock)
    or can-find(first gdsolist no-lock)
    or can-find(first bc-list no-lock)
    or can-find(first pbc-list no-lock)
    or can-find(first cash-txn no-lock)
    or can-find(first cash-txr no-lock)
    or can-find(first dc-list no-lock)
    or can-find(first stpl-list no-lock)
    or can-find(first pdf-list no-lock)
    then do:
      run str/diallog.w (
                         &if "{&imp2cd_parparentproc}" <> '' &then
                         input {&imp2cd_parparentproc}
                         &else
                         input ?
                         &endif
                        ,input ?
                        ,input 'str/sendnall.p':U
                        ,input string(ibs.th.gbl.gbl-var:g#db-num)
                        ,input yes /*p-auto-go*/
                        ,input '':U
                        ,input 'Отправка информации на кассу') no-error .
    end.
  end.
end procedure.


procedure fill-gds-list :
define parameter buffer buf_goods for ub.goods.

do
on error undo, return error
:
  if not can-find(gds-list where gds-list.gds-code     = buf_goods.gds-code
                          no-lock)
  then do:
    create gds-list.
    buffer-copy buf_goods to gds-list.
    release gds-list.
  end.
end.

end procedure. /* fill-gds-list */


procedure fill-dc-list :
define parameter buffer buf_dis-card for ub.dis-card .

do
on error undo, return error
:
  find first dc-list where
            dc-list.d-card = buf_dis-card.d-card no-lock no-error.
  if not available dc-list then do:
    create dc-list.
    buffer-copy buf_dis-card to dc-list.
    release dc-list.
  end.
end.
end procedure. /* fill-dc-list */

procedure fill-dc-list-attr :
define input parameter p-d-card as character no-undo .
define input parameter p-emitent-host-code as integer no-undo .

do
on error undo, return error
:
  find first dc-list where
            dc-list.d-card = p-d-card no-error .
  if not avail dc-list then do:
    create dc-list.
    assign
    dc-list.d-card = p-d-card
    dc-list.emitent-host-code = p-emitent-host-code
    .
    release dc-list.
  end.
end.
end procedure. /* fill-dc-list */

procedure fill-g-list :
define input parameter p-gds-code as integer no-undo .
define input parameter p-obj-type as character no-undo .
define input parameter p-obj-code as integer no-undo .
define buffer buf_goods for ub.goods.

do
on error undo, return error
:
  find first gds-list where
            gds-list.gds-code = p-gds-code no-error .
  if not avail gds-list then do:
    if p-obj-type = {&shop} then do:
      find first gdsolist where
                gdsolist.gds-code = p-gds-code
          AND  gdsolist.obj-type = p-obj-type
          AND  gdsolist.obj-code = p-obj-code   no-error .
    end.
    else do:
      find first buf_goods no-lock where
                  buf_goods.gds-code = p-gds-code no-error .
      create gds-list.
      buffer-copy buf_goods to gds-list.
    end.
  end.
  if p-obj-type = {&shop} and not avail gdsolist then do:
    find first gdsolist where
              gdsolist.gds-code = p-gds-code
        AND  gdsolist.obj-type = p-obj-type
        AND  gdsolist.obj-code = p-obj-code   no-error .
    if not available gdsolist then do:
      find first buf_goods no-lock where
                  buf_goods.gds-code = p-gds-code no-error .
      if avail buf_goods then do:
        create gdsolist.
        buffer-copy buf_goods to gdsolist
        assign
        gdsolist.obj-type = p-obj-type
        gdsolist.obj-code = p-obj-code
        .
      end.
    end.
  end.
  if avail gdsolist then do:
    assign
    gdsolist.to-del = no
    .
    release gdsolist.
  end.
  if avail gds-list then do:
    assign
    gds-list.to-del = no
    .
    release gds-list.
  end.
end.
end procedure. /* fill-g-list */

procedure fill-cash-txn :
define parameter buffer buf_tax for ub.tax.

do
on error undo, return error
:
  if not can-find( cash-txn where
                  cash-txn.tax-code = buf_tax.tax-code
              and cash-txn.tax-name = buf_tax.tax-name
                 ) then do:
    create cash-txn.
    assign
    cash-txn.tax-code = buf_tax.tax-code
    cash-txn.tax-name = buf_tax.tax-name
    .
    release cash-txn.
  end.
end.

end procedure. /* fill-cash-txn */

procedure fill-cash-txr :
define input parameter p-tax-code as integer no-undo .
define input parameter p-rate-code as integer no-undo .
define input parameter p-status_ as character no-undo .
define input parameter p-host-code as integer no-undo .
define input parameter p-obj-type as character no-undo .
define input parameter p-obj-code as integer no-undo .
define input parameter p-tax-type as character no-undo .
define input parameter p-value as decimal no-undo .
define input parameter p-crf as integer no-undo .
define input parameter p-rec as recid no-undo .
define buffer buf_tax for ub.tax.
do
on error undo, return error
:
  find first cash-txr where
          cash-txr.tax-code = p-tax-code
      AND cash-txr.host-code = p-host-code
      AND cash-txr.rate-code = p-rate-code
      AND cash-txr.obj-type = p-obj-type
      AND cash-txr.obj-code = p-obj-code
      /* AND (p-status_ = ? or cash-txr.status_ = p-status_) */
      AND cash-txr.rc = p-rec no-error .
  if not avail cash-txr then do:
    find first  cash-txn where
                    cash-txn.tax-code = p-tax-code no-error .
    if not available cash-txn then do:
      find first buf_tax no-lock where buf_tax.tax-code = p-tax-code.
      create cash-txn.
      assign
      cash-txn.tax-code = buf_tax.tax-code
      cash-txn.tax-name = buf_tax.tax-name
      .
      release cash-txn.
      define variable II as integer no-undo.
      find last  cash-txr where cash-txr.crf > 0 no-error.
      if available cash-txr
      then 
         II = cash-txr.crf + 1.
      else 
         II = 1. 
       /* отправим все ствки по налогу */
         _tax-rate:  
      FOR EACH ub.tax-rate NO-LOCK WHERE
                          ub.tax-rate.tax-code = buf_tax.tax-code
                      and ub.tax-rate.status_  <>   {&deleted-status-int-full}:
                        create cash-txr.
                        assign
                        cash-txr.tax-code = tax-rate.tax-code
                        cash-txr.rate-code = tax-rate.rate-code
                        cash-txr.tax-type = buf_tax.tax-type
                        cash-txr.host-code = p-host-code
                        cash-txr.obj-type = p-obj-type
                        cash-txr.obj-code = p-obj-code
                        cash-txr.status_ = tax-rate.status_
                        cash-txr.rc = RECID(tax-rate)
                        cash-txr.crf = ii
                        ii = ii + 1
                        .
                        
                        { gbl/pftaxval.i recid(ub.tax-rate) 0 0 ? p-host-code p-obj-type p-obj-code cash-txr.rate-value no-error }
                        if error-status:error then next _tax-rate.
       END.
       
    end.
    else do:
       for each cash-txr where cash-txr.tax-code = tax-rate.tax-code:
          delete cash-txr.
       end.
       _tax-rate2:
        FOR EACH ub.tax-rate NO-LOCK WHERE
                          ub.tax-rate.tax-code = buf_tax.tax-code
                      and ub.tax-rate.status_  <>   {&deleted-status-int-full}:
                        create cash-txr.
                        assign
                        cash-txr.tax-code = tax-rate.tax-code
                        cash-txr.rate-code = tax-rate.rate-code
                        cash-txr.tax-type = buf_tax.tax-type
                        cash-txr.host-code = p-host-code
                        cash-txr.obj-type = p-obj-type
                        cash-txr.obj-code = p-obj-code
                        cash-txr.status_ = tax-rate.status_
                        cash-txr.rc = RECID(tax-rate)
                        cash-txr.crf = ii
                        ii = ii + 1
                        .
                        
                        { gbl/pftaxval.i recid(ub.tax-rate) 0 0 ? p-host-code p-obj-type p-obj-code cash-txr.rate-value no-error }
                        if error-status:error then next _tax-rate2.
       END.
    end.   
    /* обработаем пришедшую стаку которой нет еще в базе */   
    find first cash-txr where
          cash-txr.tax-code = p-tax-code
      AND cash-txr.rate-code = p-rate-code
     /* AND cash-txr.host-code = p-host-code
      AND cash-txr.obj-type = p-obj-type
      AND cash-txr.obj-code = p-obj-code
      AND cash-txr.rc = p-rec*/ no-error .
    if not avail cash-txr and  p-status_ <> {&deleted-status-int-full} 
    then do:        
       create cash-txr.
       assign
       cash-txr.tax-code  = p-tax-code
       cash-txr.rate-code = p-rate-code
       cash-txr.host-code = p-host-code
       cash-txr.obj-type  = p-obj-type
       cash-txr.obj-code  = p-obj-code
       cash-txr.tax-type  = p-tax-type
       cash-txr.crf       = p-crf
       cash-txr.rc        = p-rec
       cash-txr.status_   = (if p-status_ = ? then {&current-status} else p-status_)
       .
    
    end.
    if  avail cash-txr 
    then do: 
       if p-status_ eq {&deleted-status-int-full}
       then
          delete cash-txr.
       else assign
       cash-txr.tax-code  = p-tax-code
       cash-txr.rate-code = p-rate-code
       cash-txr.host-code = p-host-code
       cash-txr.obj-type  = p-obj-type
       cash-txr.obj-code  = p-obj-code
       cash-txr.tax-type  = p-tax-type
       cash-txr.crf       = p-crf
       cash-txr.rc        = p-rec
       cash-txr.status_   = (if p-status_ = ? then {&current-status} else p-status_)
       .
       
    end.   
    release cash-txr.
  end.
end.

end procedure. /* fill-cash-txr */

procedure fill-stpl-list :
define parameter buffer buf_stop-list for ub.stop-list.

do
on error undo, return error
:
  find first stpl-list where
            stpl-list.classif-type =  buf_stop-list.classif-type
        and stpl-list.stop-list-code = buf_stop-list.stop-list-code no-error .
  if not avail stpl-list then do:
    create stpl-list.
    buffer-copy buf_stop-list
    to stpl-list.
    release stpl-list.
  end.
end.

end procedure. /* fill-stop-list */

procedure fill-pbc-list :
define input parameter p-rc as recid no-undo .
define input parameter p-gds-code as integer no-undo .
define input parameter p-b-code as integer no-undo .
define input parameter p-b-str as character no-undo .
define input parameter p-bc-on as logical no-undo .
define input parameter p-del as logical no-undo .

do
on error undo, return error
:
  if p-bc-on = false
  or p-del = yes
  or not can-find(gds-list where gds-list.gds-code     = p-gds-code
                            no-lock ) then do:
    find first pbc-list where pbc-list.rc = p-rc no-error.
    if not available pbc-list then do:
      create pbc-list.
    end.
    assign
    pbc-list.b-code = p-b-code
    pbc-list.b-str = p-b-str
    pbc-list.rc = p-rc
    pbc-list.bc-on = p-bc-on
    pbc-list.del = p-del
    .
    release pbc-list .
  end.
end.
end procedure. /* fill-pbc-list */

procedure fill-bar-code :
define input parameter p-b-code as integer no-undo .
define input parameter p-gds-code as integer no-undo .
define input parameter p-del as logical no-undo .
define input parameter p-node-code as integer no-undo .
define input parameter p-in-code as character no-undo .
define input parameter p-part-code as character no-undo .
define input parameter p-cli-base-rate as decimal no-undo .
define input parameter p-unit-cli as character no-undo .

do
on error undo, return error
:

  if p-del = yes
  or not can-find(gds-list where gds-list.gds-code     = p-gds-code
                            no-lock ) then do:
    find first bc-list where
            bc-list.b-code = p-b-code and bc-list.del = p-del no-error.
    if not avail bc-list then do:
      create bc-list.
      assign
      bc-list.gds-code = p-gds-code
      bc-list.b-code = p-b-code
      bc-list.node-code = p-node-code
      bc-list.in-code = p-in-code
      bc-list.part-code = p-part-code
      bc-list.cli-base-rate = p-cli-base-rate
      bc-list.unit-cli = p-unit-cli
      bc-list.del = p-del
      .
    end.
  end.
end.

end procedure. /* fill-bar-code */

procedure fill-pdf :
define input parameter p-plt-id as integer no-undo .
define input parameter p-plt-db-num as integer no-undo .
define input parameter p-pdf-id as integer no-undo .
define input parameter p-pdf-db-num as integer no-undo .
define input parameter p-del as logical no-undo .
define buffer buf_pdf-list for pdf-list.

do
on error undo, return error
:
  find first pdf-list where
           pdf-list.plt-id = p-plt-id
       and pdf-list.plt-db-num = p-plt-db-num
       and pdf-list.pdf-id = p-pdf-id
       and pdf-list.pdf-db = p-pdf-db-num no-error.
  if not available pdf-list then do:
    find last buf_pdf-list use-index oi no-error.
    create pdf-list.
    assign
    pdf-list.plt-id = p-plt-id
    pdf-list.plt-db-num = p-plt-db-num
    pdf-list.pdf-id = p-pdf-id
    pdf-list.pdf-db = p-pdf-db-num
    pdf-list.to-del = p-del
    pdf-list.order-num = (if available buf_pdf-list then buf_pdf-list.order-num + 1 else 1)
    .
    release pdf-list.
  end.
end.

end procedure. /* fill-pdf */

/* $Workfile$ e n d */