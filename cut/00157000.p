/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 157.

Автор: Чернова Светлана Александровна
Дата создания: 05/26/09
Author: Svetlana Chernova
Creation date: 05/26/09

Обработка таблиц:
s-f-doc
scf-dtl
scf-VAT
pay-doc
pay-VAT

*/

define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Файл пирога обрезания. Относится к категории 157.":U.

{ cmp/str-glbl.i }


do on error undo, return error SUBSTITUTE( "&1 &2 &3", return-value,
                                                       error-status :get-message( 1 ),
                                                       error-status :get-message( 2 ) ) :
  { utl/00000001.i }
output stream str-gen close.
  return "Произведен экспорт таблиц по счет фактурам: .".
end.