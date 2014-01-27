/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

ОТЧЕТ Документы возврата в разрезе накладных поставщика и ГТД

Автор: Чернова Светлана Александровна
Дата создания: 07/14/09
Author: Svetlana Chernova
Creation date: 07/14/09

*/
define input  parameter parParentProc  as widget-handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "ОТЧЕТ Документы возврата в разрезе накладных поставщика и ГТД".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

run rep/d-report.w
( input parParentProc,
  input "rep/r-cstvz.p",
  input "Документы возврата в разрезе накладных поставщика и ГТД" ,
  input 2,
  input "",
  input "*",
  input "{&p-sale}" ,
  input "{&v-RUBL},{&v-base}",
  input "all,{&Excel-yes}",
  input yes
  ).