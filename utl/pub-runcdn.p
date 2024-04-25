/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Белова Марина Михайловна 
Дата создания: 10 апреля 2024 г.
Author:  Belova Marina 
Creation date: 10 april 2024 г.

*/

/*using ibs.th.skt.ControlledClients.GisMtCDN.*/
 
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

def buffer buf_code for ub.code.

find first buf_code where 
           buf_code.parent = "CDN_GisMt" 
       and buf_code.code = "CDN_Upd"              
    no-lock no-error.
 if not avail buf_code then do:
   create buf_code.
   assign
      buf_code.parent = "CDN_GisMt" 
      buf_code.code = "CDN_Upd"
      buf_code.codename = "Запущен процесс обновления площадок ГИС МТ"
      buf_code.codeval = string(now)   
      .
   publish "runCdn".     
end.          


