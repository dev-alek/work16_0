/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

вызов отчета

Автор: Шальнев Иван Сергеевич
Дата создания: 23/07/10
Author: Shalnev ivan
Creation date: 23/07/10

*/
&glob Select-Post  ""and~ can-find(first g#post~
  where ~
 post-stk-line.cli-type = g#post.obj-type and ~
 post-stk-line.cli-code = g#post.obj-code ) = TRUE ""
&glob SSS "&p1 =  {&Select-Post}"
&glob fr-name "&framename='bonus':U"
&glob r-sort "&b3 = tmp-itog.tmp-gds-code"         /* поле сортировки  */
{ rep/r-bn-mn.i {&fr-name} {&r-sort} {&SSS} 'last' }
{ rep/r-bn-dp.i cont-num}