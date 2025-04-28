block-level on error undo, throw.
/*

$Revision: 43079881fc1c, 3306, rls $
$Author: Ostroukhov $
$Date: 2023/05/19 13:37:06 $
$Workfile: unitgds-news.p $
$Archive: FixProc/unitgds-news.p $

Утилита для изменения ед.измерения с блк на бл по новостям
Автор: Шкляр Елена
Дата создания: 07/23/08
Author: Shklyar Elena
Creation date: 07/23/08

*/

define input parameter parparentproc    as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle     as handle no-undo .
define input parameter p-parameter      as character no-undo .

define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

define variable mdbverd as integer   no-undo.
define variable mdbveri as integer   no-undo.
define variable mdbver  as integer   no-undo.
define variable v-char  as character no-undo.

{ cmp/trg-def.i }
{ nws/bintrnpr.i }
{ trg/new-bcod.i }
define variable v-log         as logical no-undo .
define variable var-bc-code   as integer no-undo .


define buffer buf_bar-code for ub.bar-code .
define buffer buf_bar-code-bl for ub.bar-code .
    
for each buf_bar-code no-lock where buf_bar-code.unit-cli = "блк":
  find first buf_bar-code-bl where buf_bar-code-bl.gds-code eq buf_bar-code.gds-code
                               and buf_bar-code-bl.unit-cli      = "бл":U
                               no-lock no-error.
  if not available buf_bar-code-bl
  then do:
     run gen-b-code IN THIS-PROCEDURE (
       input {&gbl-bc-code}
       ,output var-bc-code
       ).
       
     create ub.bar-code .
     assign
       ub.bar-code.b-code        = var-bc-code
       ub.bar-code.node-code     = buf_bar-code.node-code
       ub.bar-code.gds-code      = buf_bar-code.gds-code
       ub.bar-code.in-code       = "":U
       ub.bar-code.part-code     = "":U
       ub.bar-code.unit-cli      = "бл":U
       ub.bar-code.cli-base-rate = buf_bar-code.cli-base-rate
       .
     release ub.bar-code .
  end. 
end.

