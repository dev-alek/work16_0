/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Декларация об объемах розничной продажи алкогольной продукции

Автор: Хныкин Павел Андреевич
Дата создания: 07/05/06
Author: Pavel Khnykin
Creation date: 07/05/06

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Декларация об объемах розничной продажи алкогольной продукции".

{ cmp/vssrevis.i      }
{ cmp/str-glbl.i      }
{ cmp/r-page1.i new   }

run rep/d-report.w
    ( input parParentProc
    , input 'rep/alcdcl01.p'
    , input "Декларация об объемах розничной продажи алкогольной продукции":U
    , input 1
    , input ""
    , input "{&o-firm},{&o-currency},{&o-choice}"
    , input "{&p-cost},{&p-crsa}"
    , input "{&v-rubl}"
    , input "all,{&Arc-stk-yes},{&Arc-OT-yes},X-SET_PAY_TYPE=2,{&Excel-yes}"
    , input yes
    ).