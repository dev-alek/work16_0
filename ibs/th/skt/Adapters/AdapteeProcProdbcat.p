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

define parameter buffer buf_prod-bc for ub.prod-bc.
define output parameter l-is-petrol-code as logical no-undo.

{ cmp/library.i  }

{ gbl/prodbcat.i buf_prod-bc 'petrolium=request' l-is-petrol-code NO-ERROR }