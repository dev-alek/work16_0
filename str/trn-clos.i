/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггеры на b-open и b-close в списке документов a l l - d o c s . w

Автор: Чернова Светлана Александровна
Дата создания: 10/10/06
Author: Svetlana Chernova
Creation date: 10/10/06

create: Суслов Алексей Юрьевич

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
on choose of b-open in frame {&frame-name} /* Откр */
do:
  {&net-proc}
  assign
    pardoc-rec = recid (t-doc)
  .
  { gbl/int-open.i
    parparentproc
    t-doc.doc-code
    gds-list
    no-error
  }
  if error-status :error
  then do:
    find t-doc no-lock
      where recid( t-doc) = pardoc-rec
      .
    return no-apply.
  end.
  find t-doc no-lock
    where recid( t-doc) = pardoc-rec
    .
  run UI-on in this-procedure ( input "open" ).
  return no-apply.
END.

&Scop if-not-clos if not varlog then do: find t-doc where recid( t-doc ) = pardoc-rec. return error. end.

/* --------------------------------------------- начало триггера b-close ------------------------------------------- */
ON CHOOSE OF b-close IN FRAME {&frame-name} /* Закр */
DO:
  {&net-proc}
  assign
    pardoc-rec = recid (t-doc)
  .
  { gbl/int-clos.i
    parparentproc
    t-doc.doc-code
    gds-list
    no-error
  }
  if error-status :error
  then do:
    find t-doc no-lock
      where recid( t-doc) = pardoc-rec
      .
    return no-apply.
  end.
  find t-doc
    no-lock where recid( t-doc ) = pardoc-rec.

  run UI-on in this-procedure ( input "open" ) .
  reposition {&browse-name} to recid pardoc-rec no-error.

END.

/* --------------------------------------------- конец триггера b-close ------------------------------------------- */

{ str/plgdsfnd.i }

/* $Workfile$   E n d */