/*

$Revision: 1eba0946c2d7, 3078, rls $
$Author: DRuban $
$Date: Пт авг 05 19:16:25 2022 +0300 $
$Workfile: TSDTT.i $
$Archive: ibs/th/skt/ControlledClients/TSDTT.i $



Автор: Морозов Александр Сергеевич
Дата создания: 01/30/15
Author: Alexandr Morozov
Creation date: 01/30/15

*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

define temp-table TempTrnDoc no-undo
  field line-num     as integer
  field ext-doc-code as character
  field doc-date     as date
  field ext-doc-type as character
  field cli-type     as character        /* не присылают */
  field cli-code     as integer
  field obj-type     as character
  field obj-code     as integer
  field ps           as character
  field Status_      as character
  field Flags_       as integer
  index pi line-num ext-doc-code .

define temp-table TempTrnDocMT no-undo
  field DocName    as character
  field DocType    as character
  field Complete_  as logical
  field Status_    as character
  field ClientID   as integer
  field ClientType as character
  field ObjectID   as integer
  field ObjectType as character
  field UserID_    as character
  field UserName   as character
  field FactSum    as decimal
  field StartDate  as character
  field Flags_     as integer
  .
  
define temp-table TempDocLine no-undo
  field line-num     as integer
  field gds-code     as integer
  field doc-qnty     as decimal
  field fact-qnty    as decimal
  field price-rubl   as decimal
  field RowSum       as decimal
  field vat-pc       as decimal
  field b-code       as character
  field is-tsd-qnty  as logical   init no
  field aclMarksList as character
  field PartIDTH     as character
  field Flags_       as integer
  field NotDict      as logical
  index pi
  line-num
  gds-code
  .
  
define temp-table TempDocLineTSD no-undo
  field gds-code     as integer
  field doc-qnty     as decimal
  field fact-qnty    as decimal
  field artic        as character
  field prod-code    as integer
  field prod-type    as character
  field Flags_error  as logical
  field mark-type    as character
  field mark         as character
  field mark-parent  as character
  index pi
  artic
  prod-code
  prod-type
  mark
  .
      
define temp-table TempTrnLineMT no-undo
  field lineid    as integer 
  field docname   as character   
  field pos       as integer
  field goodsid   as integer 
  field goodsname as character
  field UnitBC    as character
  field BC        as character
  field Price_    as character
  field DocQnty   as character
  field FactQnty  as character
  field AlcCode   as character
  field PartIDTH  as character
  field NotDict   as logical
  .

define temp-table TempMarkLine no-undo
  field DocName    as character
  field MarkCode   as character
  field PartIDTH   as character
  field Sts        as character
  field MarkParent as character
  field QntyBox    as character
  index pi
  DocName
  MarkCode
  .

define temp-table TempMarkLineMT no-undo
  field LineId   as integer
  field DocName  as character
  field MarkCode as character
  field PartIDTH as character
  field Sts      as character
  field MarkParent as character
  index pi
  DocName
  MarkCode
  .