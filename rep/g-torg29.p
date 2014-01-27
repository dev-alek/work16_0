/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Форма ТОРГ-29 (толкач)

Автор: Хныкин Павел Андреевич
Дата создания: 10/17/07
Author: Pavel Khnykin
Creation date: 10/17/07

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Форма ТОРГ-29 (толкач)".
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

assign
  my-handle = parparentproc
.

run rep/d-report.w
    ( input parparentproc
    , input 'rep/r-torg29.p'
    , input "Форма ТОРГ-29":U
    , input 2
    , input "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one},{&g-grp-prod}":U
    , input "{&o-firm},{&o-currency},{&o-choice}"
    , input "{&p-cost},{&p-crsa},{&p-sale}"
    , input "{&v-rubl},{&v-base}"
    , input "all,{&Arc-OT-yes},{&Excel-yes}"
    , input yes
    ).