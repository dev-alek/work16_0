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
&glob Select-Post  ""and~ can-find(first g#post~
  where ~
 post-stk-line.cli-type = g#post.obj-type and ~
 post-stk-line.cli-code = g#post.obj-code ) = TRUE ""
&glob SSS "&p1 =  {&Select-Post}"
&glob fr-name "&framename = 'oborot-pri':U"
&glob r-sort "&b3 = temp-t-post-stk-line.gds-code"         /* поле сортировки  */

{ rep/r-pst-mn.i {&fr-name} {&r-sort} {&SSS} }
{ rep/r-ppr-dp.i }