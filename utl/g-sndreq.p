/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Выбрать объекты для отправки запроса распределённой проверки целостности остатков по товарам

Автор: Перваков Михаил Сергеевич
Дата создания: 08/10/04
Author: Mikhail Pervakov
Creation date: 08/10/04

*/

define input parameter parparentproc as handle           no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Выбрать объекты для отправки запроса распределённой проверки целостности остатков по товарам".
{ cmp/vssrevis.i    }
{ cmp/trg-def.i     }
{ cmp/r-page1.i new }

do
on error undo, return error
:
  run rep/d-report.w
    (input parparentproc
    ,input 'utl/e-sndreq.p'
    ,input "Отправить запрос для распределённой проверки целостности остатков по товарам"
    ,input 0
    ,input ""
    ,input "*"
    ,input ""
    ,input ""
    ,input "all"
    ,input true
    ).
end.