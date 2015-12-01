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


define variable iDbNum as integer no-undo.
define variable MsgLog as character no-undo.

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
      temp_trn-doc.doc-code      = tt-wb-header.num
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
      .
    
  end.
  
  { gbl/getcurus.i
    iDbNum
    userId_
    no-error
  }
  
  run utl/ora-i516.p (
    input this-procedure ,
    input this-procedure ,
    input table temp_trn-doc ,
    input table temp_doc-line ,
    output num-rec-ok
    ) no-error .
  MsgLog = return-value + {&new-line} . 
  if error-status:error 
    then return error MsgLog.
  
  

end.


procedure pcall-log-file:
  
  define input parameter msg as character no-undo.
  
  assign 
    MsgLog = msg + {&new-line}
    .

end.


procedure get-db-num:
  
  define output parameter pDbNum as integer no-undo.
  
  pDbNum = iDbNum.

end.

procedure get-userid:

  define output parameter pUserId as character no-undo.
  assign
    pUserId = userId_
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
