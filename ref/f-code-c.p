/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

вызов справочников фин кодов

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 10/07/03 12:26

*/
def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "вызов справочников фин кодов ".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/showinf.i  }
define input parameter parParentProc  AS WIDGET-HANDLE NO-UNDO.
define input parameter number-menu as integer no-undo .
define input parameter par-host-code like ub.clients.obj-code no-undo.
define variable  bttns  as char   no-undo .
define variable  par-mode      as char   no-undo .
define variable  pardoc-rec    as recid no-undo.
define variable  rid-list       as  char no-undo . /* список recid'ов выбранных */

par-mode = {&company}       .
bttns    = "b-mark,b-del,b-add,b-chg"   .

case number-menu :
  when 1 then do:
        run ref/fwcode-1.w
        (   input parParentProc ,
            input bttns        ,
            input par-mode     ,
            input pardoc-rec   ,
            input par-host-code,
            output rid-list    )  .
  end.
  when 2 then do:
        run ref/fwcode-2.w
        (   input parParentProc , input bttns        ,
            input par-mode     ,
            input pardoc-rec   ,
            input par-host-code,
            output rid-list    )  .
  end.
  when 3 then do:
        run ref/fwcode-3.w
        (   input parParentProc , input bttns        ,
            input par-mode     ,
            input pardoc-rec   ,
            input par-host-code,
            output rid-list    )  .
  end.
end case.