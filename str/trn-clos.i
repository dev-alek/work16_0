/*

$Revision: aea5316774be, 0, rls $
$Author: expertek $
$Date: Mon Jan 27 18:27:46 2014 +0400 $
$Workfile: trn-clos.i $
$Archive: str/trn-clos.i $

Триггеры на b-open и b-close в списке документов a l l - d o c s . w

Автор: Чернова Светлана Александровна
Дата создания: 10/10/06
Author: Svetlana Chernova
Creation date: 10/10/06

create: Суслов Алексей Юрьевич

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile: trn-clos.i $ $Revision: aea5316774be, 0, rls $".
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

  if t-doc.doc-type = {&inventory} and t-doc.status_ = {&permitted} then do:
    /* Проверка на заполнение атрибутов */
  define variable is-pos as logical no-undo .
  define variable is-date as logical no-undo .
  define variable is-fio as logical no-undo .
  define variable is-check as logical no-undo .
  define variable is-mes as character no-undo .

  define buffer fio_inv-doc-attr for ub.inv-doc-attr .
  define buffer prikaz_inv-doc-attr for ub.inv-doc-attr .
  
    find first ub.inv-doc-attr no-lock where ub.inv-doc-attr.doc-code = t-doc.doc-code and
    ub.inv-doc-attr.attr-code = "invTech" and
    ub.inv-doc-attr.attr-value = string(true) no-error .
    if not available (ub.inv-doc-attr) then do:
      if not can-find (first prikaz_inv-doc-attr no-lock where prikaz_inv-doc-attr.doc-code = t-doc.doc-code and
      prikaz_inv-doc-attr.attr-code = {&trdcattr-prikaz-date} and
      prikaz_inv-doc-attr.attr-value <> "") then do:
      is-date = true .
      is-check = true .
      end.
      if not can-find (first fio_inv-doc-attr no-lock where fio_inv-doc-attr.doc-code = t-doc.doc-code and
      (fio_inv-doc-attr.attr-code = {&trdcattr-fio-agent} or
      fio_inv-doc-attr.attr-code = {&trdcattr-fio-player1} or
      fio_inv-doc-attr.attr-code = {&trdcattr-fio-player2} or
      fio_inv-doc-attr.attr-code = {&trdcattr-fio-player3}) and
      fio_inv-doc-attr.attr-value <> "") then do:
      is-fio = true .
      is-check = true .
      end.
      if not can-find (first fio_inv-doc-attr no-lock where fio_inv-doc-attr.doc-code = t-doc.doc-code and
      (fio_inv-doc-attr.attr-code = {&trdcattr-pos-agent} or
      fio_inv-doc-attr.attr-code = {&trdcattr-pos-player1} or
      fio_inv-doc-attr.attr-code = {&trdcattr-pos-player2} or
      fio_inv-doc-attr.attr-code = {&trdcattr-pos-player3}) and
      fio_inv-doc-attr.attr-value <> "")then do:
      is-pos = true .
      is-check = true .
      end.
      
      if is-check then do:

        is-mes = "Ошибка при закрытии документа инвентаризации." .

      if is-date then do:
        is-mes = is-mes + {&new-line} + "Не указана дата приказа." .
      end.
      if is-fio then do:
        is-mes = is-mes + {&new-line} + "Не указана фамилия." .
      end.
      if is-pos then do:
        is-mes = is-mes + {&new-line} + "Не указана должность." .
      end.
      message
      is-mes
      view-as alert-box .
      return no-apply.
      end.
    end.                 
  end .
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

/* $Workfile: trn-clos.i $   E n d */