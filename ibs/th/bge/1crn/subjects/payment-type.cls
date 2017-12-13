/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Структура данных payment-type в 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

USING Progress.Lang.*.

CLASS ibs.th.bge.1crn.subjects.payment-type: 
  define property code_         as character    no-undo get. set.
  define property del-l         as integer      no-undo get. set.
  define property del-f         as integer      no-undo get. set.
  define property name_         as character    no-undo get. set.
  define property curr-code     as character    no-undo get. set.
  define property ptg-code      as character    no-undo get. set.
  define property pmt-cash      as logical      no-undo get. set.
  define property pmt-fuel      as logical      no-undo get. set.
  define property pmt-service   as logical      no-undo get. set.
  define property cnt-code      as character    no-undo get. set.
  define property enbl-zd       as integer      no-undo get. set.
  define property use-km3       as integer      no-undo get. set.
  define property enbl-trf      as integer      no-undo get. set.
  define property pmt-ved       as integer      no-undo get. set.
  define property doc-type      as integer      no-undo get. set.
  define property mst-online    as integer      no-undo get. set.
  define property mst-slip      as integer      no-undo get. set.
  define property kbo           as integer      no-undo get. set.
  define property malina        as integer      no-undo get. set.
  define property prfx          as character    no-undo get. set.

END CLASS.