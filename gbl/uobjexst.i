/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Проверить, что выбран хотя бы один объект

Автор: Перваков Михаил Сергеевич
Дата создания: 04/25/06
Author: Mikhail Pervakov
Creation date: 04/25/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

&if defined(include_userobjs) = 0 &then
  &message need include gbl/userobjs.i
&endif
run userobjs_object-exist in this-procedure
  (output {1} /* p-user-select   */
  ) {2} .
/* $Workfile$ e n d */