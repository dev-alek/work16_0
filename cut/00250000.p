/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 230.

Автор: Чернова Светлана Александровна
Дата создания: 06/01/09
Author: Svetlana Chernova
Creation date: 06/01/09

Обработка таблиц:

c-place-io
c-point-io
place-io
place-io-attr
point-io
point-io-attr
point-place-rel
c-point-place-rel
c-point-point-rel
point-point-rel

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 230.".
{ cmp/str-glbl.i }

define buffer old-c-place-io      for src.c-place-io    .
define buffer old-c-point-io      for src.c-point-io    .
define buffer old-place-io        for src.place-io      .
define buffer old-place-io-attr   for src.place-io-attr .
define buffer old-point-io        for src.point-io      .
define buffer old-point-io-attr   for src.point-io-attr .
define buffer old-point-place-rel for src.point-place-rel  .
define buffer old-c-point-place-rel for src.c-point-place-rel  .
define buffer old-point-point-rel   for src.point-point-rel      .
define buffer old-c-point-point-rel   for src.c-point-point-rel      .

define buffer new-c-place-io     for dst.c-place-io     .
define buffer new-c-point-io     for dst.c-point-io     .
define buffer new-place-io       for dst.place-io       .
define buffer new-place-io-attr  for dst.place-io-attr  .
define buffer new-point-io       for dst.point-io       .
define buffer new-point-io-attr  for dst.point-io-attr  .
define buffer new-point-place-rel for dst.point-place-rel  .
define buffer new-c-point-place-rel for dst.c-point-place-rel  .
define buffer new-point-point-rel   for dst.point-point-rel       .
define buffer new-c-point-point-rel   for dst.c-point-point-rel       .

do
on error undo, return error
:
  { utl/00000001.i }

on WRITE of dst.c-place-io     override do: end.
on WRITE of dst.c-point-io     override do: end.
on WRITE of dst.place-io       override do: end.
on WRITE of dst.place-io-attr  override do: end.
on WRITE of dst.point-io       override do: end.
on WRITE of dst.point-io-attr  override do: end.
on WRITE of dst.point-place-rel override do: end.
on WRITE of dst.c-point-place-rel override do: end.
on WRITE of dst.point-point-rel    override do: end.
on WRITE of dst.c-point-point-rel  override do: end.

{ utl/00000002.i place-io         }
{ utl/00000002.i place-io-attr    }
{ utl/00000002.i point-io         }
{ utl/00000002.i point-io-attr    }
{ utl/00000002.i point-place-rel  }
{ utl/00000002.i point-point-rel  }

  if varstay-history = yes then do:
      { utl/00000002.i c-place-io  }
      { utl/00000002.i c-point-io  }
      { utl/00000002.i c-point-place-rel  }
      { utl/00000002.i c-point-point-rel  }
  end.
output stream str-gen close.

return "Произведен экспорт таблиц: ~
  c-place-io ~
  c-point-io ~
  place-io ~
  place-io-attr ~
  point-io ~
  point-io-attr ~
  point-place-rel ~
  c-point-place-rel ~
  ".

end.