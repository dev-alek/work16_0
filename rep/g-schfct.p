/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Журнал регистрации полученных счетов фактур

Автор: Комаров Иван Сергеевич
Дата создания: 12/23/09
Author: Ivan Komarov
Creation date: 12/23/09

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Журнал регистрации полученных счетов фактур".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/r-page1.i new }

do
on error undo, return error return-value
:

  run rep/d-report.w
    (input  parparentproc                                  /* parParentProc  */
    ,input  'rep/e-schfct.w'                               /* procname       */
    ,input  "ЖУРНАЛ РЕГИСТРАЦИИ ПОЛУЧЕННЫХ СЧЕТОВ-ФАКТУР"  /* namereport     */
    ,input  2                                              /* param-date     */
    ,input  ""                                             /* param-goods    */
    ,input  "{&o-firm},{&o-currency},{&o-choice},{&o-all}" /* param-obj      */
    ,input  ""                                             /* param-pay      */
    ,input  ""                                             /* param-pay-hide */
    ,input  "all,{&customer-yes}"                          /* param-universal*/
    ,input  false                                          /* param-alon     */
    ).
end.