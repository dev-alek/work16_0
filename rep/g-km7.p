/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

вызов отчета "сведения о показаниях счетчиков ККМ и выручке КМ-7"

Автор: Комаров Иван Сергеевич
Дата создания: 06/30/10
Author: Ivan Komarov
Creation date: 06/30/10

Автор1: Белоусов Илья Александрович

*/
define input parameter parParentProc    AS WIDGET-HANDLE    NO-UNDO .

define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "вызов отчета КМ-7" .
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ cmp/r-page1.i new }
{ gbl/getcntxt.i def }

define NEW SHARED variable cas-shft as logical no-undo init no.

/*найдем параметр - использовать смены на кассе или нет*/
{ gbl/getcntxt.i get }
{ gbl/cas-shft.i v-cntxt-obj-type v-cntxt-obj-code cas-shft }

run rep/d-report.w
    ( input parParentProc                    /* 0 */
    , input 'rep/r-km7r.p'                   /* 1 RUN           */
    , input "КМ-7":U                         /* 2 Title */
    , input ( if cas-shft then 7 else 1 )    /* 3 dates         */
    , input ""                               /* 4 goods */
    , input "{&o-currency}"                  /* 5 objects       */
    , input ""                               /* 6 Price */
    , input ""                               /* 7 currency      */
    , input "{&shop},{&send-check}"          /* 8 object type   */
    , input yes                              /* 9 одна закладка */
      ).
