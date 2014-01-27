/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сводный отчет по движению СТ. НТФ-8.10 (Кедр-М) (g-файл)

Автор: Комаров Иван Сергеевич
Дата создания: 02/05/10
Author: Ivan Komarov
Creation date: 02/05/10

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Сводный отчет по движению СТ. НТФ-8.10".
{ cmp/vssrevis.i }

define input  parameter parParentProc  as widget-handle no-undo.
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}
run rep/d-report.w ( 
                    input parParentProc
                   ,input 'rep/r-trg810.p'
                   ,input "Сводный отчет по движению СТ. НТФ-8.10"
                   ,input 8
                   ,input "{&g-grp}":U
                   ,input "*"
                   ,input ""
                   ,input ""
                   ,input "all,{&Excel-yes},{&Arc-ot-yes}"
                   ,input yes
                   ).