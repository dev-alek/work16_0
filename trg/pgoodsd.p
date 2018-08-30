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

&scoped-define main-tbl PromoGoods
TRIGGER PROCEDURE FOR DELETE OF ub.{&main-tbl}.
define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo init "Тригер удаления {&main-tbl}". 
{ cmp/vssrevis.i }

{ cmp/str-glbl.i } /* &db-name_schema, &hn-delete */
{ gbl/cur-time.i } /* cur-time() */
define buffer buf_c-{&main-tbl} for ub.c-{&main-tbl} .
define variable v-date as date no-undo .
define variable v-time as integer no-undo .


  if not ibs.th.gbl.gbl-var:g#news then do :
    run cur-time in this-procedure (output v-date, output v-time).

    /* пишем историю */
    create buf_c-{&main-tbl}.
    buffer-copy ub.{&main-tbl} to buf_c-{&main-tbl}
    assign
      buf_c-{&main-tbl}.chip-num           = next-value (s-promo-chip, {&db-name_schema})
      buf_c-{&main-tbl}.corr-date          = v-date
      buf_c-{&main-tbl}.corr-time          = v-time
      buf_c-{&main-tbl}.corr-user-db-num   = ibs.th.gbl.gbl-var:g#db-num
      buf_c-{&main-tbl}.corr-user-name     = ibs.th.gbl.gbl-var:g#userid
      // 14/VIII-2018 - поле отсутствует buf_c-{&main-tbl}.action             = {&hn-delete}
      // 14/VIII-2018 - поле отсутствует buf_c-{&main-tbl}.is-del             = true
    .
  end. /* end_of not-g-news */
