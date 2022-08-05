/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

шифрование файла

Автор: Белоусов Илья Александрович
Дата создания: 05/16/07
Author: Ilia Belousov
Creation date: 05/16/07

Input: p-in-file

Output: p-out-file

*/
define input  parameter i-Text  as longchar no-undo.
define input  parameter i-pasword as character no-undo.
define input  parameter i-encrypt as logical   no-undo.
define output parameter o-Text as longchar no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "шифрование текста".
{ cmp/vssrevis.i }

{ gbl/pencrypt.i defproc_long  }
{ gbl/pdecrypt.i defproc_long  }

do
on error undo, return error
:
   if i-encrypt = ? then do:
      return error "Не опредлено дейcтвие".
   end.

   security-policy:symmetric-encryption-key = generate-pbe-key(i-pasword).
   if i-encrypt 
   then do:
      { gbl/pencrypt.i i-Text o-Text }
   end.
   else do:
      { gbl/pdecrypt.i i-Text o-Text }
   end.

end.