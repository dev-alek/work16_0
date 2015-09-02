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

define input parameter p-gds-code as integer no-undo.
define input parameter p-node-code as integer no-undo.
define output parameter p-main-b-code as integer no-undo.

{ cmp/library.i  }

{ gbl/gdsbcode.i p-gds-code ? p-main-b-code NO-ERROR }
  if error-status:error then return "":U.