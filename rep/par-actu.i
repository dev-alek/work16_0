/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

временная таблица для хранения параметров отчетов

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Creation date: 01/17/03 10:25

*/
&if "{1}"   = "" &then
define temp-table param-to-export no-undo
field param-code     as character
field param-sub-code as character
field param-type     as character
field param-value    as character
field param-comment  as character
index pi is unique primary  param-code     param-sub-code
.
&endif

&if "{1}"   = "run-proc" &then
  run create-param-to-export  in this-procedure
  ( input {2}  , /* код параметра */
   input {3}  , /* подкод параметра для списков  */
   input {4}  , /* тип параметра character integer logical data decimal*/
   input {5}  , /* значение параметра */
   input {6} )  /* комментарий по параметру */
  {7}
 .

&endif

&if "{1}"   = "proc" &then
procedure create-param-to-export :
 do
 on error undo, return error return-value
 :
 define input parameter p1 as character no-undo .
 define input parameter p2 as character no-undo .
 define input parameter p3 as character no-undo .
 define input parameter p4 as character no-undo .
 define input parameter p5 as character no-undo .

  create  param-to-export.
  assign
     param-to-export.param-code     =  p1
     param-to-export.param-sub-code =  p2
     param-to-export.param-type     =  p3
     param-to-export.param-value    =  p4
     param-to-export.param-comment  =  p5
  .

 end. /* do */
end procedure. /* create-param-to-export */

&endif



/* $Workfile$ e n d */