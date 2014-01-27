/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Декларация об объемах розничной продажи алкогольной продукции для Москвы

Автор: Белоусов Илья Александрович
Дата создания:
Author: Ilia Belousov
Creation date:

*/

define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":u .
def var vss-author      as character no-undo init "$Author$":u .
def var vss-date        as character no-undo init "$Date$":u .
def var vss-workfile    as character no-undo init "$Workfile$":u .
def var vss-archive     as character no-undo init "$Archive$":u .
def var vss-description as character no-undo init "Декларация об продажах алкоголя для Москвы" .
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

run rep/d-report.w
    ( input parParentProc
    , input 'rep/alcdcl03.p'
    , input "Декларация об объемах розничной продажи алкогольной продукции для Москвы":U
    , input 1
    , input ""
    , input "{&o-firm},{&o-currency},{&o-choice}"
    , input ""
    , input ""
    , input "all,{&Arc-stk-yes},{&Arc-OT-yes},X-SET_PAY_TYPE=2,{&Excel-yes}"
    , input yes
    ).