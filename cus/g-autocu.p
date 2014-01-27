/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по продажам топлива по лотерейным билетам АВТОКУШ

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/03/09
Author: Bakhtadze Natalya
Creation date: 09/03/09

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Запуск отчета по лотерее АВТОКУШ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }


run rep/d-report.w (  input parparentproc
                 ,input 'cus/r-autocu.p'
                 ,input "Отчет о продажах топлива по лотерейным билетам АВТОКУШ"
                 ,input  2
                 ,input ""
                 ,input "{&o-all},{&o-choice}"
                 ,input ""
                 ,input ""
                 ,input "shop,{&send-check},{&Excel-yes}"
                 ,input yes)      .