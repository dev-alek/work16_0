/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

кодирование списка прав

Автор: Белоусов Илья Александрович
Дата создания: 05/16/07
Author: Ilia Belousov
Creation date: 05/16/07

Input:

Output:

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "кодирование списка прав".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }

DO
ON ERROR UNDO, RETURN ERROR
:
   run utl/filecryp.p ( INPUT "cmp/actn.txt":U
                      , INPUT "sysadm"
                      , INPUT YES
                      , INPUT "cmp/actn.enc":U
                      ) .

   MESSAGE "Шифрование окончено"
   VIEW-AS ALERT-BOX.

END.