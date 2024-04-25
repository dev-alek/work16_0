/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Белова Марина Михайловна 
Дата создания: 1 апреля 2024 г.
Author:  Belova Marina 
Creation date: 1 april 2024 г.

*/
using ibs.th.skt.ControlledClients.GisMtCDN.
 
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
define variable mError as logical no-undo.
{ cmp/vssrevis.i }
{ utl/proc-async.i proc_def}
{ utl/search.i  class }

define variable thGisMtCdn as class GisMtCDN no-undo .

define variable mParam as character no-undo.
mParam = GetPARAMAsunc( 1).
if mParam eq ? then do:
   run PutMesAsunc( "error   Получение данных было прервано пользователем." ).
   { utl/proc-async.i proc_end}
   return.
end.

thGisMtCdn =  new GisMtCDN().
thGisMtCdn:GetListCdn().
        
delete object thGisMtCdn.  