/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает последний день текущего года/месяца по входной дате.

Автор: Чернова Светлана Александровна
Дата создания: 04/13/06
Author: Svetlana Chernova
Creation date: 04/13/06

Author:  VGC - Черных Виктор Георгиевич.
Created: 05.06.1995.

*/

define  input parameter in-date as date    no-undo. /* входная дата */
define output parameter lastday as integer no-undo. /* последний день текущего года/месяца */

define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Возвращает последний день текущего года/месяца по входной дате":U.

{ cmp/vssrevis.i }

define variable tt_date as date no-undo.

do on error undo, return error :
  assign tt_date = date( month( in-date ), 28, year( in-date ) ) + 4.
  assign lastday = day( tt_date - day( tt_date ) ).
end.
