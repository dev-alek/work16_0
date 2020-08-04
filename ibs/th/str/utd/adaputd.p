/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

using ibs.th.skt.*.
using ibs.th.skt.Adapters.*.
using ibs.th.gbl.env.utd.

{ cmp/str-glbl.i }
{ cmp/library.i  }
{ ibs/th/str/utd/trn/tt516.i}
{ gbl/getcntxt.i def }

/*define shared variable g#auto-user-id as character no-undo .*/

define input  parameter  p-db-num as integer no-undo.
define input  parameter  p-doc-id as integer no-undo.
define input  parameter  p-userId as character no-undo.


/*define input  parameter table for  TempTrnDoc.       */
/*define input  parameter table for  TempDocLine.      */
/*define input  parameter userId_ as character no-undo.*/


define variable iDbNum as integer no-undo.

MAIN-BLOCK:
do:
  define variable num-rec-ok as logical no-undo.
  define variable ii         as integer no-undo.
/*  define variable logWrite   as class   LogWrite no-undo.*/
  
  def buffer buf_utd for ub.utd.
  def buffer buf_utd-lines for ub.utd-lines.
  def buffer buf_utd-marking-lines for ub.utd-marking-lines.
  def buffer buf_mark-lines for ub.marking-lines.
  def buffer buf_marking for ub.marking.
  
  def var objSrv as class ibs.th.gbl.sys.objsrv no-undo.
  run gbl/getobjsrvhndl.p (input-output ObjSrv).
  
/*  logWrite = new LogWrite().*/
  
  find first buf_utd where buf_utd.db-num = p-db-num and buf_utd.doc-id = p-doc-id no-error.
  if not available (buf_utd)
    then undo, return error "Не найден УТД - " + string(p-db-num) + "," + string(p-doc-id).
  
  if buf_utd.sts ne objSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB
  then do:
    undo, return error "Неверный статус документа УТД " + string(p-db-num) + "," +  string(p-doc-id) + " - " + objSrv:Env:Utd:Sts:TH:GetLabel(buf_utd.sts).
  end.
  
  if buf_utd.doc-code <> "" and can-find (first ub.trn-doc where ub.trn-doc.doc-code = buf_utd.doc-code)
  then do:
    undo, return error "Для документа уже создана накладная " + string(p-db-num) + "," + string(p-doc-id) + " - " + buf_utd.doc-code.
  end.


  create temp_trn-doc.
  assign
    temp_trn-doc.line-num      = ii
    temp_trn-doc.utdDocumentExt = buf_utd.DocumentExt
    temp_trn-doc.utdOrganizationExt = buf_utd.OrganizationExt
    temp_trn-doc.db-num = buf_utd.db-num
    temp_trn-doc.doc-id = buf_utd.doc-id
    temp_trn-doc.doc-date      = buf_utd.DocumentDate
    temp_trn-doc.ps            = buf_utd.comment
    temp_trn-doc.doc-code      = buf_utd.DocumentNumber
    temp_trn-doc.ext-doc-type  = "ie"
    temp_trn-doc.cli-type      = buf_utd.cli-type
    temp_trn-doc.cli-code      = buf_utd.cli-code
    temp_trn-doc.obj-type      = buf_utd.obj-type
    temp_trn-doc.obj-code      = buf_utd.obj-code
    temp_trn-doc.exch-code     = 0
    temp_trn-doc.exch-rate     = 1
    temp_trn-doc.exch-scale    = 1
    temp_trn-doc.contract-code = buf_utd.contract-code
    temp_trn-doc.host-code = buf_utd.host-code
/*      temp_trn-doc.price-type    = if TempTrnDoc.ext-doc-type = {&TDEDT_Ras_Vnesh } then "TSFTSD" else ""*/
    .
  

  fe_:
  for each buf_utd-lines where buf_utd-lines.db-num = buf_utd.db-num and
  buf_utd-lines.doc-id = buf_utd.doc-id and buf_utd-lines.sts ne objSrv:Env:Utd:Sts:TH:LoadError:KeyIntDB
  no-lock:
    
    def var sum-vat as decimal no-undo.
    def var v-q as decimal no-undo.
    v-q = 0.
/*    if buf_utd.EDocType = objSrv:Env:Utd:EDocType:EDoc:KeyIntDB*/
/*    then                                                       */

    if ObjSrv:Env:ParametrsOfSection:GetSectionEDO(buf_utd.obj-type, buf_utd.obj-code):GetIsMarkingForType("tabak")
    then do:
      for each buf_utd-marking-lines where buf_utd-marking-lines.db-num = buf_utd-lines.db-num
        and buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id
        and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum
        :
        
        find first buf_marking where buf_marking.mark = buf_utd-marking-lines.mark and buf_marking.unit-ext = "UNIT"
          and buf_marking.sts = objSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB no-error.
        if available (buf_marking)
          then v-q = v-q + 1.
      end.
    end.
    else do:
      for each buf_utd-marking-lines where buf_utd-marking-lines.db-num = buf_utd-lines.db-num
        and buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id
        and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum
        and buf_utd-marking-lines.doc-level = 1
        :
        find first buf_marking where buf_marking.mark = buf_utd-marking-lines.mark
                    and buf_marking.sts = objSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB and buf_marking.box-qnty <> ? no-lock no-error.
        if available (buf_marking)
          then v-q = v-q + buf_marking.box-qnty.
      end.      
    end. 
/*    else v-q = buf_utd-lines.Quantity.*/
    
    sum-vat = (buf_utd-lines.Total - buf_utd-lines.TotalWithVatExcluded) / buf_utd-lines.Quantity. 
    
    create temp_doc-line.
    
    assign
      temp_doc-line.line-num   = buf_utd-lines.LineNum
      temp_doc-line.db-num = buf_utd-lines.db-num
      temp_doc-line.doc-id = buf_utd-lines.doc-id
      temp_doc-line.gds-code   = buf_utd-lines.gds-code
      temp_doc-line.fact-qnty  = v-q
      temp_doc-line.doc-qnty   = v-q
      temp_doc-line.price-cli  = buf_utd-lines.Total / buf_utd-lines.Quantity
      temp_doc-line.price-rubl = buf_utd-lines.Total / buf_utd-lines.Quantity 
      temp_doc-line.doc-code   = temp_trn-doc.doc-code
      temp_doc-line.vat-pc     = 100 * sum-vat / (buf_utd-lines.TotalWithVatExcluded / buf_utd-lines.Quantity)
      .
    
  end.
  { gbl/curdbnum.i
      iDbNum
    }
  def var v-msg as character no-undo.
    
  run ibs/th/str/utd/trnutd.p (
    input this-procedure ,
    input this-procedure ,
    input table temp_trn-doc ,
    input table temp_doc-line ,
    input table tt-excisemarks,
    output v-msg,
    output num-rec-ok
    ) no-error .
  if error-status:error 
    then do:
      return error (return-value + " " + v-msg).
    end.
  if iDbNum ne 0
  then do:
    run nws/cmdchgutd.p (buffer buf_utd) no-error.
    if error-status:error
    then do:
      undo, return error return-value.
    end.
  end.
  return v-msg.

end.

procedure pcall-log-file:
  
  define input parameter msg as character no-undo.
  
/*  assign                                                 */
/*    LogWrite:LogStr = LogWrite:LogStr + {&new-line} + msg*/
/*    .                                                    */

end.


procedure get-db-num:
  
  define output parameter pDbNum as integer no-undo.
  
  pDbNum = iDbNum.

end.

procedure get-userid:

  define output parameter pUserId as character no-undo.

  find first ub.user-login where ub.user-login.db-num = iDbNum and ub.user-login.user-id = p-userId no-error.
  
  if available ub.user-login
  then 
  do:
    assign
      pUserId  = p-userId
      .
  end.
  else 
  do:
    assign
      pUserId = p-userId
      .
  end.
  
end.

procedure mainmenu_getcntxt :
define output parameter p-cntxt-db-num                as integer   no-undo . /* текущая БД            */
define output parameter p-cntxt-userid                as character no-undo . /* текущий пользователь  */
define output parameter p-cntxt-level                 as character no-undo . /* уровень контекста     */
define output parameter p-cntxt-host-code-obj         as integer   no-undo . /* текущая фирма         */
define output parameter p-cntxt-obj-type              as character no-undo . /* тип текущего объекта  */
define output parameter p-cntxt-obj-code              as integer   no-undo . /* код текущего объекта  */
define output parameter p-cntxt-db-num-obj            as integer   no-undo . /* база текущего объекта */
define output parameter p-cntxt-is-admin              as logical   no-undo . /* база текущего объекта */

  do
  on error undo, return error return-value
  :
  define variable vt-host-code as integer   no-undo .

  find first temp_trn-doc no-error.

  { gbl/objdbnum.i
     temp_trn-doc.obj-type
     temp_trn-doc.obj-code
     p-cntxt-db-num-obj
     }

  { gbl/hostcode.i
     temp_trn-doc.obj-type
     temp_trn-doc.obj-code
     vt-host-code
     }

  assign
    p-cntxt-db-num          =  p-cntxt-db-num-obj
    p-cntxt-userid          =  p-userId
    p-cntxt-level           =  v-cntxt-level
    p-cntxt-host-code-obj   =  vt-host-code
    p-cntxt-obj-type        =  temp_trn-doc.obj-type
    p-cntxt-obj-code        =  temp_trn-doc.obj-code
    p-cntxt-is-admin        =  v-cntxt-is-admin
  .

  end.
end procedure. /* mainmenu_getcntxt */
