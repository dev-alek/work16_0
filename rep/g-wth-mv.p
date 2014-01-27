/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Автор: Гридчина Полина Дмитриевна
Дата создания: 09/09/05
Author: Polina Gridchina
Creation date: 09/09/05

*/

define input  parameter parParentProc  as widget-handle no-undo.

{ cmp/str-glbl.i }
{ cmp/r-page0.i NEW}

run rep/d-report.w (   input parParentProc
                  ,input "rep/e-wth-mv.w"
                  ,input "Движение материальных ценностей на АЗК"
                  ,input 5
                  ,input ""
                  ,input ""
                  ,input ""
                  ,input ""
                  ,input "all"
                  ,input no
              )
    .