/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 75.

Автор: Чернова Светлана Александровна
Дата создания: 06/03/09
Author: Svetlana Chernova
Creation date: 06/03/09

Обработка таблиц:
fin-bank
c-fin-bank
fin-bank-attr
c-fin-bank-attr
fin-code-an-uchet
fin-code-an-uchet-attr
c-fin-code-an-uchet
fin-code-cel-nazn
fin-code-cel-nazn-attr
c-fin-code-cel-nazn
fin-code-cor-acc
fin-code-cor-acc-attr
c-fin-code-cor-acc
fin-schet
c-fin-schet
fin-schet-attr
c-fin-schet-attr
cbr-bank
c-cbr-bank
cbr-bank-attr
c-cbr-bank-attr

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 75.".
{ cmp/str-glbl.i }
/*{ utl/tt-objs.i  }*/

define buffer old-c-fin-bank           for src.c-fin-bank          .
define buffer old-c-fin-bank-attr      for src.c-fin-bank-attr     .
define buffer old-c-fin-code-an-uchet  for src.c-fin-code-an-uchet .
define buffer old-c-fin-code-cel-nazn  for src.c-fin-code-cel-nazn .
define buffer old-c-fin-code-cor-acc   for src.c-fin-code-cor-acc  .
define buffer old-c-fin-schet          for src.c-fin-schet         .
define buffer old-c-fin-schet-attr     for src.c-fin-schet-attr    .
define buffer old-fin-bank             for src.fin-bank            .
define buffer old-fin-bank-attr        for src.fin-bank-attr       .
define buffer old-fin-code-an-uchet    for src.fin-code-an-uchet   .
define buffer old-fin-code-cel-nazn    for src.fin-code-cel-nazn   .
define buffer old-fin-code-cor-acc     for src.fin-code-cor-acc    .
define buffer old-fin-code-an-uchet-attr    for src.fin-code-an-uchet-attr   .
define buffer old-fin-code-cel-nazn-attr    for src.fin-code-cel-nazn-attr   .
define buffer old-fin-code-cor-acc-attr     for src.fin-code-cor-acc-attr    .
define buffer old-fin-schet            for src.fin-schet           .
define buffer old-fin-schet-attr       for src.fin-schet-attr      .
define buffer old-cbr-bank             for src.cbr-bank          .
define buffer old-c-cbr-bank           for src.c-cbr-bank          .
define buffer old-cbr-bank-attr        for src.cbr-bank-attr     .
define buffer old-c-cbr-bank-attr      for src.c-cbr-bank-attr     .
define buffer new-c-fin-bank           for dst.c-fin-bank          .
define buffer new-c-fin-bank-attr      for dst.c-fin-bank-attr     .
define buffer new-c-fin-code-an-uchet  for dst.c-fin-code-an-uchet .
define buffer new-c-fin-code-cel-nazn  for dst.c-fin-code-cel-nazn .
define buffer new-c-fin-code-cor-acc   for dst.c-fin-code-cor-acc  .
define buffer new-c-fin-schet          for dst.c-fin-schet         .
define buffer new-c-fin-schet-attr     for dst.c-fin-schet-attr    .
define buffer new-fin-bank             for dst.fin-bank            .
define buffer new-fin-bank-attr        for dst.fin-bank-attr       .
define buffer new-fin-code-an-uchet    for dst.fin-code-an-uchet   .
define buffer new-fin-code-cel-nazn    for dst.fin-code-cel-nazn   .
define buffer new-fin-code-cor-acc     for dst.fin-code-cor-acc    .
define buffer new-fin-code-an-uchet-attr    for dst.fin-code-an-uchet-attr   .
define buffer new-fin-code-cel-nazn-attr    for dst.fin-code-cel-nazn-attr   .
define buffer new-fin-code-cor-acc-attr     for dst.fin-code-cor-acc-attr    .
define buffer new-fin-schet            for dst.fin-schet           .
define buffer new-fin-schet-attr       for dst.fin-schet-attr      .
define buffer new-cbr-bank             for dst.cbr-bank            .
define buffer new-c-cbr-bank           for dst.c-cbr-bank          .
define buffer new-cbr-bank-attr        for dst.cbr-bank-attr       .
define buffer new-c-cbr-bank-attr      for dst.c-cbr-bank-attr     .

do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2))
:
  { utl/00000001.i }

  on WRITE of dst.fin-bank            override do: end.
  on WRITE of dst.c-fin-bank          override do: end.
  on WRITE of dst.fin-bank-attr       override do: end.
  on WRITE of dst.c-fin-bank-attr     override do: end.
  on WRITE of dst.fin-code-an-uchet   override do: end.
  on WRITE of dst.fin-code-an-uchet-attr   override do: end.
  on WRITE of dst.c-fin-code-an-uchet override do: end.
  on WRITE of dst.fin-code-cel-nazn   override do: end.
  on WRITE of dst.fin-code-cel-nazn-attr   override do: end.
  on WRITE of dst.c-fin-code-cel-nazn      override do: end.
  on WRITE of dst.fin-code-cor-acc-attr    override do: end.
  on WRITE of dst.c-fin-code-cor-acc  override do: end.
  on WRITE of dst.fin-code-cor-acc    override do: end.
  on WRITE of dst.fin-schet           override do: end.
  on WRITE of dst.c-fin-schet         override do: end.
  on WRITE of dst.fin-schet-attr      override do: end.
  on WRITE of dst.c-fin-schet-attr    override do: end.
  on WRITE of dst.cbr-bank            override do: end.
  on WRITE of dst.c-cbr-bank          override do: end.
  on WRITE of dst.cbr-bank-attr       override do: end.
  on WRITE of dst.c-cbr-bank-attr     override do: end.


  { utl/00000002.i fin-bank }
  if varstay-history then do:
    { utl/00000002.i c-fin-bank }
  end.
  { utl/00000002.i fin-schet }
  if varstay-history then do:
    { utl/00000002.i c-fin-schet }
  end.
  { utl/00000002.i fin-schet-attr }
  if varstay-history then do:
    { utl/00000002.i c-fin-schet-attr }
  end.
  { utl/00000002.i fin-bank-attr }
  if varstay-history then do:
    { utl/00000002.i c-fin-bank-attr }
  end.
  { utl/00000002.i fin-code-an-uchet }
  { utl/00000002.i fin-code-an-uchet-attr }
  if varstay-history then do:
    { utl/00000002.i c-fin-code-an-uchet }
  end.
  { utl/00000002.i fin-code-cel-nazn }
  { utl/00000002.i fin-code-cel-nazn-attr }
  if varstay-history then do:
    { utl/00000002.i c-fin-code-cel-nazn }
  end.
  { utl/00000002.i fin-code-cor-acc }
  { utl/00000002.i fin-code-cor-acc-attr }
  if varstay-history then do:
    { utl/00000002.i c-fin-code-cor-acc }
  end.
  { utl/00000002.i cbr-bank }
  if varstay-history then do:
    { utl/00000002.i c-cbr-bank }
  end.
  { utl/00000002.i cbr-bank-attr }
  if varstay-history then do:
    { utl/00000002.i c-cbr-bank-attr}
  end.

output stream str-gen close.
  return "Произведен экспорт таблиц: fin-bank c-fin-bank fin-bank-attr c-fin-bank-attr ~
fin-code-an-uchet c-fin-code-an-uchet fin-code-cel-nazn c-fin-code-cel-nazn fin-code-cor-acc c-fin-code-cor-acc ~
fin-schet c-fin-schet fin-schet-attr c-fin-schet-attr cbr-bank c-cbr-bank cbr-bank-attr c-cbr-bank-attr .".
end.