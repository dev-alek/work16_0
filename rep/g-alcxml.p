/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Декларация об объемах розничной продажи алкогольной продукции в XML (Москва)

Автор: Хныкин Павел Андреевич
Дата создания: 01/22/08
Author: Pavel Khnykin
Creation date: 01/22/08

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Декларация об объемах розничной продажи алкогольной продукции в XML (Москва)".
{ cmp/vssrevis.i      }
{ cmp/str-glbl.i      }
{ cmp/r-page1.i new   }

run rep/d-report.w
    ( input parParentProc
    , input 'rep/e-alcxml.w'
    , input "Декларация об объемах розничной продажи алкогольной продукции. Экспорт в XML ":U
    , input 1
    , input ""
    , input "{&o-currency}"
    , input ""
    , input ""
    , input "all,{&Arc-stk-yes},{&Arc-OT-yes}"
    , input no
    ).