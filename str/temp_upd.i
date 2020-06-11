
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Таблицы с УПД

Автор: Шкляр Елена  
Дата создания: 10/10/08
Author: Shklyar Elena
Creation date: 10/10/08
*/


/* ***************************  Definitions  ************************** */

/* ********************  Preprocessor Definitions  ******************** */
 
/* ***************************  Main Block  *************************** */

define temp-table tt-utd like ub.utd 
  field stts        as character
  field stts-edi    as character
  field cli-name    as character
  field EDoTypeName as character
  field ModifyTime_ as character
  field orig-code   as character
  field GrayZone    as logical
  field obj-name    as character
  .


define temp-table tt-utd-lines like ub.utd-lines
  field qnty-scan as integer 
  field qnty-mark as integer
  field stts      as character
  field gds-name  as character
  field TaxRate_  as character
  field fact-qnty as decimal
  field sts_err   as logical
  .
  
define temp-table tt-marking-lines like ub.marking-lines
  field mark-parent as character 
  field stts        as character
  field sts-utd     as integer
  field stts-utd    as character
  field unit        as character
  field unit-ext    as character
  field site        as character
  field box-qnty    as decimal
  field gds-name    as character
  field db-num      as integer
  field doc-id      as integer
  field LineNum     as integer
  field GrayZone    as logical 
  index pi  doc-level   sts
  index pi2 mark-parent sts
  index pi3 unit-ext
  .
      
define temp-table tt-mark-line like ub.marking-lines 
  field date_    as date
  field doc-type as character
  field type     as integer
  field doc-id   as integer
  field db-num   as integer
  field EdocType as integer
  index pi mark out-code doc-type .
  
define temp-table tt-marking like ub.marking 
  .
  
define temp-table tt-utd-marking-lines like ub.utd-marking-lines
  .    
  
define temp-table tt-inv-marking no-undo 
  field gds-code      as integer
  field gds-name      as character
  field qnty          as decimal
  field qnty-scan     as integer
  field qnty-confirm  as integer
  field qnty-scan-not as integer
  field qnty-not      as integer
  index pi gds-code
  .  
  
define temp-table tt-tech-mark no-undo 
  field gds-code      as integer
  field gds-name      as character
  field qnty-fact     as integer
  field qnty-doc      as integer
  field doc-code      as character
  field line-num      as integer
  index pi as UNIQUE doc-code line-num gds-code
  .  
  
define temp-table tt-utd-err like ub.utd-err
  field descr as character
  field gds-code as integer
  field LineNum  as integer
  .  