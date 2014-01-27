 /*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Дни продажи товара - отчет для Марии - запуск

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/14/04
Author: Bakhtadze Natalya
Creation date: 04/14/04

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Дни продажи товара - отчет для Марии:запуск".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page0.i new }


run rep/d-report.w (
                            input parparentproc
                            ,input 'cus/e-mar1.w'
                            ,input ('Дни продажи товара')
                            ,input 2  /* с по*/
                            ,input "*"  /*все варианты выбора товаров*/
                            ,input "*"  /*все варианты выбора объектов*/
                            ,input ""   /*тип цен не показывать*/
                            ,input ""   /*тип валют не показывать*/
                            ,input "all,{&Excel-yes}"   /*все типы объектов*/
                            ,input no).