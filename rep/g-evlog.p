/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вызов отчета по логированию кассы TH POS

Автор: Комаров Иван Сергеевич
Дата создания: 09/07/10
Author: Ivan Komarov
Creation date: 09/07/10

Автор1: Белоусов Илья Александрович
Дата создания1: 12/16/08

Input:

Output:

*/
define input  parameter parparentproc      as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Вызоотчета по логированию".
{ cmp/r-page0.i new }
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
do
on error undo, return error
:
   run rep/d-report.w
      ( input parparentproc                     /* 0 */
      , input 'rep/e-evlog.w'                   /* 1 */
      , input "Журнал событий на кассе TH POS"  /* 2 */
      , input 2                                 /* 3 */
      , input "{&g-all},{&g-choice},{&g-one}"   /* 4 */
      , input "{&o-currency},{&o-all}"          /* 5 */
      , input ""                                /* 6 */
      , input ""                                /* 7 */
      , input "shop,{&Excel-yes}"               /* 8 */
      , input NO                                /* 9 */
      ).

end.