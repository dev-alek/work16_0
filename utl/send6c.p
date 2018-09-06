
/*------------------------------------------------------------------------
    File        : send6c.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Thu Mar 15 18:52:18 MSK 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */


{ cmp/trg-def.i  }
{ cmp/library.i  }


if not valid-handle (ibs.th.gbl.gbl-hndllib:g#lib-trn)
    then run str/lib-trn.p persistent no-error .
if not valid-handle (ibs.th.gbl.gbl-hndllib:g#lib-trn2)
    then run str/lib-trn2.p persistent no-error .
if not valid-handle (ibs.th.gbl.gbl-hndllib:g#lib-trn3)
    then run str/lib-trn3.p persistent no-error .
if not valid-handle (ibs.th.gbl.gbl-hndllib:g#lib-trn4)
    then run str/lib-trn4.p persistent no-error .
if not valid-handle (ibs.th.gbl.gbl-hndllib:g#trdcalib)
    then run str/trdcalib.p persistent no-error .


define temp-table tt-fbr like ub.fbr-doc.
define var v-doc-code as char no-undo.

DEFINE FRAME frame1
  v-doc-code format "x(15)"
  with view-as dialog-box
  title "¬ведите номер документа производства"
.

update v-doc-code with frame frame1.

find first ub.fbr-doc where ub.fbr-doc.doc-code = v-doc-code no-error.

if not available (ub.fbr-doc)
  then do:
    message "ƒокумент производства не найден: номер " v-doc-code view-as alert-box.
    return.
  end.


buffer-copy fbr-doc except fbr-doc.status_ to tt-fbr  assign tt-fbr.status_ = "накл". /* дл€ имитации изменени€ статуса на факт */

{ gbl/rum-runa.i
  ?
  this-procedure:handle
  ?
  {&edoc-proc_event_fbr-doc}
  " buffer tt-fbr:handle "
  " buffer ub.fbr-doc:handle "  ''
  ''
  no-error
}
if error-status:error 
then do:
  message return-value view-as alert-box.
end.
else do:
  message fbr-doc.doc-code " отправлен" view-as alert-box.
end.
