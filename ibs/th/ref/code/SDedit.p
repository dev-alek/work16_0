/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Шкляр Елена
Дата создания: 31 июля 2019 г.
Author:  Shklyar Elena
Creation date: 31 июля 2019 г.

*/
{cmp/str-glbl.i }
{ ibs\th\ref\code\codefrmpar.i }

define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

    define temp-table tt-code-frm like code
    field Frecid as int64 init ?. 

define variable mSDedit as class ibs.th.ref.code.SDedit no-undo.
    
mSDedit = new ibs.th.ref.code.SDedit(iMode).
mSDedit:bindcode:Handle = IBuffer .

  wait-for  mSDedit:ShowDialog() .
OSave = mSDedit:DialogResult = System.Windows.Forms.DialogResult:OK.

finally:
   delete object mSDedit.
end finally. 