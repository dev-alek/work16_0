/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 9 марта 2020 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 9 марта 2020 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
define input  parameter IBuff as handle no-undo.
define variable mPwd as character no-undo.

run adm/pswd-enc.p
    (input  encode(g#passwd)
    ,output mPwd
    ) no-error .
IBuff::Usr = g#userid.
IBuff::Pwd = mPwd.
if g#userid eq ""
then
   return error.
else
   return.

