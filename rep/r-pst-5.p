/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

вызов отчета

Автор: Чернова Светлана Александровна
Дата создания: 03/20/06
Author: Svetlana Chernova
Creation date: 03/20/06

*/
&glob fr-name "&framename='oborot':U"
&glob r-sort "&b3 = temp-t-post-stk-line.gds-name"         /* поле сортировки  */
{ rep/r-pst-mn.i {&fr-name} {&r-sort} }
{ rep/r-pst-dp.i }