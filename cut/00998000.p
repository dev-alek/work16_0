/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 98.

Автор: Чернова Светлана Александровна
Дата создания: 08/05/09
Author: Svetlana Chernova
Creation date: 08/05/09

Обработка таблиц:
rep
rep-line
doc-fact-num
doc-fact-num-attr

*/

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Файл пирога обрезания. Относится к категории 98.":U .

{ cmp/str-glbl.i }

define buffer old-rep              for src.rep              .
define buffer new-rep              for dst.rep              .
define buffer old-rep-line         for src.rep-line         .
define buffer new-rep-line         for dst.rep-line         .

define buffer old-doc-fact-num        for src.doc-fact-num        .
define buffer new-doc-fact-num        for dst.doc-fact-num        .
define buffer old-doc-fact-num-attr        for src.doc-fact-num-attr        .
define buffer new-doc-fact-num-attr        for dst.doc-fact-num-attr        .

do
on error undo, return error SUBSTITUTE( "&1 &2 &3"
                                      , return-value
                                      , error-status :get-message( 1 )
                                      , error-status :get-message( 2 )
                                      )
:
  { utl/00000001.i }
  on CREATE of dst.rep              override do: end.
  on CREATE of dst.rep-line         override do: end.
  on CREATE of dst.doc-fact-num        override do: end.
  on CREATE of dst.doc-fact-num-attr        override do: end.

  on WRITE  of dst.rep              override do: end.
  on WRITE  of dst.rep-line         override do: end.
  on WRITE of dst.doc-fact-num        override do: end.
  on WRITE of dst.doc-fact-num-attr        override do: end.

  { utl/00000002.i rep              }
  { utl/00000002.i rep-line         }

  { utl/00000002.i doc-fact-num }
  { utl/00000002.i doc-fact-num-attr }

  output stream str-gen close.
  return "Произведен экспорт таблиц: rep-line " .
end.