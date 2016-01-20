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

{ cmp/str-glbl.i }
{ cmp/library.i  }
{ utl/tt516.i}
{ gbl/getcntxt.i def }

{ibs/th/bge/egais/wb-egais.i}

define input  parameter table for  tt-wb-header.
define input  parameter table for  tt-wb-gds-EG.
define input  parameter userId_ as character no-undo.
define input  parameter Mode as character no-undo.
define input-output parameter doc-code as character no-undo.


define variable iDbNum as integer no-undo.
define variable MsgLog as character no-undo.

define buffer buf_goods for ub.goods.

MAIN-BLOCK:
do:
  
  define variable num-rec-ok as logical no-undo.
  define variable ii         as integer no-undo.
  define variable jj         as integer no-undo.
  define variable logWrite   as class   LogWrite no-undo.

  for each tt-wb-header no-lock:
    
    ii = ii + 1.

    create temp_trn-doc.
    assign
      temp_trn-doc.line-num      = ii
      temp_trn-doc.doc-date      = tt-wb-header.wb-date
      temp_trn-doc.ps            = tt-wb-header.ps
      temp_trn-doc.doc-code      = tt-wb-header.wbregid + {&delim-cmd} + tt-wb-header.uniq-key-rec 
      temp_trn-doc.ext-doc-type  = tt-wb-header.wb-type
      temp_trn-doc.cli-type      = tt-wb-header.cli-type
      temp_trn-doc.cli-code      = tt-wb-header.cli-code
      temp_trn-doc.obj-type      = tt-wb-header.obj-type
      temp_trn-doc.obj-code      = tt-wb-header.obj-code
      temp_trn-doc.exch-code     = 0
      temp_trn-doc.exch-rate     = 1
      temp_trn-doc.exch-scale    = 1
      temp_trn-doc.contract-code = ?
      temp_trn-doc.price-type    = if tt-wb-header.wb-type = {&TDEDT_Ras_Vnesh } then "TSFTSD" else ""
      .
    
  end.
  jj = 0.
  for each tt-wb-gds-EG no-lock:
    
    jj = jj + 1.
    create temp_doc-line.
    
    assign
      temp_doc-line.line-num   = jj
      temp_doc-line.gds-code   = tt-wb-gds-EG.gds-code
      temp_doc-line.fact-qnty  = tt-wb-gds-EG.doc-qnty
      temp_doc-line.doc-qnty   = tt-wb-gds-EG.doc-qnty
      temp_doc-line.price-cli  = tt-wb-gds-EG.price
      temp_doc-line.price-rubl = tt-wb-gds-EG.price
      temp_doc-line.doc-code   = temp_trn-doc.doc-code
      temp_doc-line.RefA = tt-wb-gds-EG.RefA
      temp_doc-line.RefB = tt-wb-gds-EG.RefB
      temp_doc-line.importer-th = tt-wb-gds-EG.importer-th
      .
    
  end.
  
  { gbl/getcurus.i
    iDbNum
    userId_
    no-error
  }
  
  if Mode = "set-refAB"
  then do:
    run set-refAB no-error.
    if error-status:error 
    then do: 
      return error return-value .
    end.
  end.
  else do:
    run utl/ora-i516.p (
      input this-procedure ,
      input this-procedure ,
      input table temp_trn-doc ,
      input table temp_doc-line ,
      output num-rec-ok
      ) no-error .
    if error-status:error 
    then do: 
      return error MsgLog.
    end.
  end.
  

end.


procedure pcall-log-file:
  
  define input parameter msg as character no-undo.
  
  if msg begins "n-d" then do:
    doc-code = entry (2, msg, "=").
  end.
  else do: 
  assign 
    MsgLog = msg + {&new-line}
    .
  end.
  

end.


procedure get-db-num:
  
  define output parameter pDbNum as integer no-undo.
  
  pDbNum = iDbNum.

end.

procedure get-userid:

  define output parameter pUserId as character no-undo.
  assign
    pUserId = userId_ + ",egais"
    .
  
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
    p-cntxt-userid          =  userId_
    p-cntxt-level           =  v-cntxt-level
    p-cntxt-host-code-obj   =  vt-host-code
    p-cntxt-obj-type        =  temp_trn-doc.obj-type
    p-cntxt-obj-code        =  temp_trn-doc.obj-code
    p-cntxt-is-admin        =  v-cntxt-is-admin
  .

  end.
end procedure. /* mainmenu_getcntxt */

procedure set-refAB:
  
    for each ub.parts exclusive-lock
      where ub.parts.in-code   = doc-code
        and ub.parts.artic     = ub.doc-line.artic
        and ub.parts.prod-type = ub.doc-line.prod-type
        and ub.parts.prod-code = ub.doc-line.prod-code:

      find next temp_doc-line where temp_doc-line.gds-code = buf_goods.gds-code and temp_doc-line.doc-qnty =  ub.parts.qnty no-lock no-error.
      if not available (temp_doc-line) then do:
        find first temp_doc-line where  temp_doc-line.gds-code = buf_goods.gds-code and temp_doc-line.doc-qnty =  ub.parts.qnty no-lock no-error.
      end.
      
      run trg/partps.p ( input buf_goods.gds-code
                       , input parts.in-code
                       , input parts.part-code
                       , input iDbNum
                       , input ?
                       , input ?
                       , input temp_doc-line.refA + ',' + temp_doc-line.refB
                       , input ""
                       , input ""
                       , if temp_doc-line.importer <> "" then substring (temp_doc-line.importer-th, 1, 3) else ""
                       , if temp_doc-line.importer <> "" then substring (temp_doc-line.importer-th, 4, 2) else ""
                       ) no-error .
      if error-status :error
      then do:
        message
          "Ошибка при вызове процедуры partps.p" skip
          error-status :get-message(1) skip
          return-value skip
          view-as alert-box error .
        undo, return no-apply .
      end.
    end.  

end procedure.