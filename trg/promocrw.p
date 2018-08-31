/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 


Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: Ruban Dmitriy
Creation date: 11/07/18

*/
block-level on error undo, throw.

&scoped-define main-tbl PromoCriterion
TRIGGER PROCEDURE FOR WRITE OF ub.{&main-tbl}
  NEW BUFFER new-{&main-tbl}
  OLD BUFFER old-{&main-tbl}
.

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo init "Тригер изменение {&main-tbl}". 
{ cmp/vssrevis.i }

{ cmp/str-glbl.i } /* &db-name_schema, &hn-create, &hn-update */
{ gbl/cur-time.i } /* cur-time() */
define buffer buf_c-{&main-tbl} for ub.c-{&main-tbl} .
define variable v-field-chg as character no-undo .
define variable v-date      as date      no-undo .
define variable v-time      as integer   no-undo .


  buffer-compare new-{&main-tbl} to old-{&main-tbl} CASE-SENSITIVE save result in v-field-chg.
  if v-field-chg > "":U then . else return .

  /* 07/III-2018 в историю надо писать и из новостей, и из интерфейса
  if not ibs.th.gbl.gbl-var:g#news then do:
  */
    run cur-time in this-procedure (output v-date, output v-time).

    /* пишем историю */
    create buf_c-{&main-tbl}.
    /* в историю копируется запись до изменений; при создании в историю копирются начальные пустые значения */
    buffer-copy old-{&main-tbl} to buf_c-{&main-tbl}
    assign
      buf_c-{&main-tbl}.id                 = new-{&main-tbl}.id
      buf_c-{&main-tbl}.db-num             = new-{&main-tbl}.db-num

      buf_c-{&main-tbl}.chip-num           = next-value (s-promo-chip, {&db-name_schema})
      buf_c-{&main-tbl}.corr-date          = v-date
      buf_c-{&main-tbl}.corr-time          = v-time
      buf_c-{&main-tbl}.corr-user-db-num   = ibs.th.gbl.gbl-var:g#db-num
      buf_c-{&main-tbl}.corr-user-name     = ibs.th.gbl.gbl-var:g#userid
      // 14/VIII-2018 - поле отсутствует buf_c-{&main-tbl}.action             = if new(new-{&main-tbl}) then {&hn-create} else {&hn-update}
      // 14/VIII-2018 - поле отсутствует buf_c-{&main-tbl}.is-del             = false
    .
  /* end. */
