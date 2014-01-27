/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет по доставке товара

Автор: Кабоев Валерий Асланович
Дата создания: 19/09/12
Author: Kaboev Valeriy
Creation date: 19/09/12

*/

DEFINE INPUT PARAMETER parparentproc AS WIDGET-HANDLE NO-UNDO .
DEFINE VARIABLE vss-revision    AS CHARACTER NO-UNDO INIT "$Revision$":U .
DEFINE VARIABLE vss-author      AS CHARACTER NO-UNDO INIT "$Author$":U .
DEFINE VARIABLE vss-date        AS CHARACTER NO-UNDO INIT "$Date$":U .
DEFINE VARIABLE vss-workfile    AS CHARACTER NO-UNDO INIT "$Workfile$":U .
DEFINE VARIABLE vss-archive     AS CHARACTER NO-UNDO INIT "$Archive$":U .
DEFINE VARIABLE vss-description AS CHARACTER NO-UNDO INIT "Отчет по доставке товара".

{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ cmp/r-page0.i new }
/*{ cmp/library.i }
{ cmp/r-page0.i new } */ /* определения для стандартной формы отчетов -часть независящая от БД*/

RUN rep/d-report.w (
                            INPUT parparentproc
                            ,INPUT 'rep/e-deliv.w'
                            ,INPUT ('Отчёт по доставке товара')
                            ,INPUT 2
                            ,INPUT "{&g-all},{&g-grp},{&g-prod},{&g-choice},{&g-one}"
                            ,INPUT "*"
                            ,INPUT ""
                            ,INPUT ""
                            ,INPUT "{&excel-yes},{&customer-yes}"
                            ,INPUT NO).