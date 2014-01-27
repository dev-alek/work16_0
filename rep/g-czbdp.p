/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Служебная записка о выдаче денежных средств

Автор: Чернова Светлана Александровна
Дата создания: 08/11/04
Author: Svetlana Chernova
Creation date: 08/11/04

*/

define input parameter parParentProc as handle    no-undo .
define input parameter par-host-code as integer no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Служебная записка о выдаче денежных средств".
{ cmp/vssrevis.i }
{ cmp/trg-def.i }
{ cmp/r-page1.i new }

run rep/d-report.w
    (
    input parParentProc ,
    input "rep/r-czbdp.p " + string (parParentProc) ,
    input "Служебная записка о выдаче денежных средств",
    input 1  ,
    input "" ,
    input "{&o-firm}",
    input "" ,
    input "{&v-RUBL},{&v-base}",
    input "all,{&Excel-yes},{&customer-yes},X-CUSTOMER-NAME=ПОСТАВЩИКИ,X-CUSTOMER-TYPE=" + {&cmp} ,
    input yes ) .