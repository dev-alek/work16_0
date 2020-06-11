/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 27 апр. 2020 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 27 апр. 2020 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }

{rul\send1cerp.i}

procedure local-proc-main:
   define variable Vobj as class ibs.th.bge.1crn.subjects.exp-mark no-undo .
   Vobj = new ibs.th.bge.1crn.subjects.exp-mark().
   Vobj:BufHandle = m-oldbh.
   
   SubObj = cast (vobj ,ibs.th.bge.1crn.subjects.iexpsubject).
end.

procedure local-load-ruleset-context:
    case p-ruleset-id:
      when {&edoc-proc_18_event_mark_165} 
      then do:
          if    m-has-newbh
            and m-newbh:table <> {&table_marking} 
          then 
            undo, return error substitute("Передан неверный буфер вместо буфера для &1",  {&table_marking}).
          
          if    m-has-oldbh
            and m-oldbh:table <> {&table_marking} 
/*            and m-oldbh:table <> "tt-fin"*/
          then
            undo, return error substitute("Передан неверный буфер вместо буфера для &1",  {&table_marking}).
          
        end.
      otherwise 
      do:
        undo, return error substitute("Неверный вызов &1 для набора правил &2", vss-workfile , p-ruleset-id).
      end.
    end case.
end.