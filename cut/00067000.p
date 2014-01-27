/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 67.

Автор: Бахтадзе Наталья Викторовна
Дата создания: 06/23/06
Author: Bakhtadze Natalya
Creation date: 06/23/06


Обработка таблиц:
country
c-country
countr-attr
c-country-attr
c-regions
regions
regions-attr

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 67.".

{ cmp/str-glbl.i }

define buffer old-country for src.country.
define buffer new-country for dst.country.
define buffer old-c-country for src.c-country.
define buffer new-c-country for dst.c-country.
define buffer old-country-attr for src.country-attr.
define buffer new-country-attr for dst.country-attr.
define buffer old-c-country-attr for src.c-country-attr.
define buffer new-c-country-attr for dst.c-country-attr.

define buffer old-c-regions      for src.c-regions   .
define buffer old-regions        for src.regions     .
define buffer old-regions-attr   for src.regions-attr.

define buffer new-c-regions      for dst.c-regions   .
define buffer new-regions        for dst.regions     .
define buffer new-regions-attr   for dst.regions-attr.

do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
{ utl/00000001.i }
on WRITE of dst.country override do: end.
on WRITE of dst.c-country override do: end.
on WRITE of dst.country-attr override do: end.
on WRITE of dst.c-country-attr override do: end.
on WRITE of dst.c-regions      override do: end.
on WRITE of dst.regions        override do: end.
on WRITE of dst.regions-attr   override do: end.


{ utl/00000002.i country }
if varstay-history then do:
  { utl/00000002.i c-country }
end.
{ utl/00000002.i country-attr }
if varstay-history then do:
  { utl/00000002.i c-country-attr }
end.

{ utl/00000002.i regions      }
{ utl/00000002.i regions-attr }

if varstay-history then do:
  { utl/00000002.i c-regions }
end.

output stream str-gen close.
return "Произведен экспорт таблиц: country c-country country-attr c-country-attr " +
"~
c-regions ~
regions ~
regions-attr ~
.".
end.