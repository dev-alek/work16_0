/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Остатки по датам разлива

Автор: Хныкин Павел Андреевич
Дата создания: 12/16/05
Author: Pavel Khnykin
Creation date: 12/16/05

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Остатки по датам разлива ".
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new  }

run rep/d-report.w
    (
      input parParentProc ,
      input 'rep/e-alcost.p' ,
      "Остатки по датам разлива" ,
      1 ,
      "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":U,
      "*" ,
      "" ,
      "" ,
      "all,{&Excel-yes}" ,
      yes
    ) no-error.
if error-status :error then do:
  message
    vss-workfile vss-revision vss-description skip
    error-status :get-message(1) skip
    return-value skip
    "Ошибка вызова"
    view-as alert-box error
  .
end.