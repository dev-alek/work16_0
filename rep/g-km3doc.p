/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

вызов документа "сведения о показаниях счетчиков ККМ и выручке КМ-3"

Автор: Комаров Иван Сергеевич
Дата создания: 05/13/10
Author: Ivan Komarov
Creation date: 05/13/10

*/

define input parameter parParentProc    AS WIDGET-HANDLE    NO-UNDO .

define variable vss-revision    as character no-undo init "$Revision$":u .
define variable vss-author      as character no-undo init "$Author$":u .
define variable vss-date        as character no-undo init "$Date$":u .
define variable vss-workfile    as character no-undo init "$Workfile$":u .
define variable vss-archive     as character no-undo init "$Archive$":u .
define variable vss-description as character no-undo init "вызов документа КМ-3" .
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ cmp/r-page1.i new }
{ gbl/getcntxt.i def }

 define NEW SHARED variable cas-shft as logical no-undo init no.
 define NEW SHARED variable is-doc   as logical no-undo init YES.

 /*найдем параметр - использовать смены на кассе или нет*/
 { gbl/getcntxt.i get }

 { gbl/cas-shft.i v-cntxt-obj-type v-cntxt-obj-code cas-shft }

run rep/d-report.w
       ( input parParentProc
       , input 'rep/e-km3.w'
       , input "КМ-3":U
       , input ( if cas-shft then 7 else 1 )
       , input ""
       , input "{&o-currency}"
       , input ""
       , input ""
       , input "{&shop},{&send-check}"
       , input no
       ).