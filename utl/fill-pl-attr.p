/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

утилита  Привязка партий и складских документов к договору поставщика на удаленке

Автор: Кочетков Михаил Юрьевич
Дата создания: 03/27/06
Author: Michael Kochetkov
Creation date: 03/27/06

*/

/* ***************************  Definitions  ************************** */
define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "утилита установки атрибута резервуара на удаленке" .
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ str/placelib.i }

define input  parameter p-obj-type as character   no-undo .
define input  parameter p-obj-code as integer   no-undo .
define input  parameter p-pl-code as integer   no-undo .
define input  parameter p-attr-code as character no-undo .
define input  parameter p-attr-value as character no-undo .

define buffer buf_place for ub.place .
define buffer buf_place-attr for ub.place-attr .

on write of ub.place-attr override do:  end.

find first buf_place no-lock where buf_place.obj-type = p-obj-type
                               and buf_place.obj-code = p-obj-code
                               and buf_place.pl-code  = p-pl-code
                               no-error .
if available buf_place
then do transaction :
  find first buf_place-attr exclusive-lock where buf_place-attr.attr-code   = p-attr-code
                                             and buf_place-attr.obj-code    = buf_place.obj-code
                                             and buf_place-attr.obj-type    = buf_place.obj-type
                                             and buf_place-attr.pl-code     = buf_place.pl-code
                                             no-error .
  if not available buf_place-attr
  then do :
    create buf_place-attr .
    assign
      buf_place-attr.attr-code   = p-attr-code
      buf_place-attr.obj-code    = buf_place.obj-code    
      buf_place-attr.obj-type    = buf_place.obj-type    
      buf_place-attr.pl-code     = buf_place.pl-code   
    .  
  end .
  assign
    buf_place-attr.attr-value = p-attr-value
  . 
end .                               
                               
