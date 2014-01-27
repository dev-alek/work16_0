/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Показания уровнемера за смену

Автор: Белоусов Илья Александрович
Дата создания: 09/12/07
Author: Ilia Belousov
Creation date: 09/12/07

Input:

Output:

*/
define input parameter parparentproc as widget-handle no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Показания уровнемера за смену".
{ cmp/vssrevis.i    }
{ cmp/str-glbl.i    }
{ cmp/r-page1.i new }

do
on error undo, return error
:
run rep/d-report.w
    ( input parparentproc                     /* 0 */
    , input 'rep/r-plcsht.p'                      /* 1 */
    , input "Показания уровнемера за смену"   /* 2 */
    , input 7                                 /* 3 date 7 - одна смена */
    , input ""                                /* 4 */
    , input "{&o-currency}"                      /* 5 */
    , input ""                                /* 6 */
    , input ""                                /* 7 */
    , input "{&Excel-yes}"                    /* 8 */
    , input yes                               /* 9 */
    ).
end.