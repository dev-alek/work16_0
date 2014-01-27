/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Декларация об объемах розничной продажи алкогольной продукции (Йошкар-Ола)

Автор: Хныкин Павел Андреевич
Дата создания: 03/17/08
Author: Pavel Khnykin
Creation date: 03/17/08

*/

define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Декларация об объемах розничной продажи алкогольной продукции (Йошкар-Ола)".
{ cmp/vssrevis.i      }
{ cmp/str-glbl.i      }
{ cmp/r-page1.i new   }

run rep/d-report.w
    ( input parParentProc
    , input 'rep/alcdcl05.p'
    , input "Декларация об объемах розничной продажи алкогольной продукции":U
    , input 1
    , input ""
    , input "{&o-firm},{&o-currency},{&o-choice}"
    , input ""
    , input ""
    , input "all,{&Arc-stk-yes}"
    , input yes
    ).