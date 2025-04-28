/*

$Revision: aea5316774be, 0, rls $
$Author: expertek $
$Date: Mon Jan 27 18:27:46 2014 +0400 $
$Workfile: tt-date.i $
$Archive: rep/tt-date.i $

*/

define temp-table  tt-dateZakaz     no-undo
field id as integer 
field dateStart as date
field dateEnd as date
index pi id
    .


DEFINE TEMP-TABLE tt-typeDocChoose NO-UNDO 
  field type-code as character
  field typeName  as character.
  
define temp-table gds-list like ub.goods
  field minZapas as decimal 
  field contract as character
  index pi contract gds-code.