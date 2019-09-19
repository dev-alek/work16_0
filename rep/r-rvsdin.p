/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет Динамика показаний уровнемера

Автор: Уханов Дмитрий Юрьевич
Дата создания: 07/15/10
Author: Dmitry Ukhanov
Creation date: 07/15/10

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отчет Динамика показаний уровнемера".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i  }
{ cmp/r-pril.i   }
{ rep/r-sym.i    }
{ trg/factord.i  }

do
on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
on stop   undo, return error substitute( "&1. stop", vss-workfile )
on endkey undo, return error substitute( "&1. endkey", vss-workfile )
:

  define buffer buf_shift-obj for ub.shift-obj .
  define buffer buf_rvs-doc   for ub.rvs-doc .
  define buffer buf_rvs-line  for ub.rvs-line .
  define buffer buf_goods     for ub.goods .

  define variable g#report-num  as integer      no-undo .

  define variable last-fo as decimal no-undo init 0.
  define variable prev-fo as decimal no-undo init 0.

  define variable v-rvs-type  as character no-undo .
  define variable v-rvs-count as integer   no-undo .
  define variable v-ind       as integer   no-undo .

  define temp-table tt_places no-undo
    field rvs-count as integer
    field rvs-code  like ub.rvs-line.rvs-code
    field gds-code  like ub.rvs-line.gds-code
    field pl-code   like ub.rvs-line.pl-code
    field qnty      like ub.rvs-line.measure-qnty
    index pi is unique primary rvs-code gds-code pl-code
    index gds-pl   gds-code pl-code
    index gds-pl-c rvs-code gds-code rvs-count
    .

  define stream out-stream.

  for each tt_places
  :
    delete tt_places.
  end.

  /* только текущий объект */
  find first obj-list no-lock
      no-error .
  if not available obj-list then do:
    message
      "Не определен объект для формирования отчета"
      view-as alert-box information .
    return error.
  end.

  find first gds-list no-lock
    no-error .
  if not available gds-list then do:
    message
      "Не определен товар для формирования отчета"
      view-as alert-box information .
    return error.
  end.

  run get-report-num in my-handle
    ( output g#report-num
    ).

  { cmp/open-out.i stream out-stream " " {&LS_PS_A4} }

  run factord-max-fact-order in this-procedure
    ( output last-fo ).

  find first buf_shift-obj share-lock
    where buf_shift-obj.obj-type   = obj-list.obj-type
      and buf_shift-obj.obj-code   = obj-list.obj-code
      and buf_shift-obj.shift-date = x-date-end
      and buf_shift-obj.shift-num  = x-shift-end
      no-error.
  if available buf_shift-obj then do:
    if buf_shift-obj.status_  = {&sht-closed} then do:
      assign
        last-fo = buf_shift-obj.fact-order
      .
    end.
  end.

  find last buf_shift-obj share-lock
    where buf_shift-obj.obj-type = obj-list.obj-type
      and buf_shift-obj.obj-code = obj-list.obj-code
      and buf_shift-obj.status_  = {&sht-closed}
      and ( ( buf_shift-obj.shift-date = x-date-start
             and buf_shift-obj.shift-num < x-shift-start
            )
            or buf_shift-obj.shift-date < x-date-start
          )
      use-index pi no-error.
  if available buf_shift-obj then do:
    assign
      prev-fo = buf_shift-obj.fact-order
    .
  end.

  for each buf_rvs-doc no-lock
    where buf_rvs-doc.obj-type   =  obj-list.obj-type
      and buf_rvs-doc.obj-code   =  obj-list.obj-code
      and buf_rvs-doc.status_    =  {&fact}
      and buf_rvs-doc.fact-order >  prev-fo
      and buf_rvs-doc.fact-order <= last-fo
    ,each buf_rvs-line no-lock
    where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
      and buf_rvs-line.gds-code = gds-list.gds-code
    break by buf_rvs-doc.fact-order by buf_rvs-line.gds-code by buf_rvs-line.pl-code
  :
    find first tt_places no-lock
      where tt_places.rvs-code = buf_rvs-line.rvs-code
        and tt_places.gds-code = buf_rvs-line.gds-code
        and tt_places.pl-code  = buf_rvs-line.pl-code
      no-error .
    if not available tt_places then do:
      create tt_places .
      assign
        tt_places.rvs-code = buf_rvs-line.rvs-code
        tt_places.gds-code = buf_rvs-line.gds-code
        tt_places.pl-code  = buf_rvs-line.pl-code
        tt_places.qnty     = buf_rvs-line.measure-qnty
      .
    end.
  end.

  assign
    v-rvs-count = 0
  .
  &scop beg-title "| Дата   | Время  | Тип сверки |  Топливо  |"
/*  &scop beg-title "| Дата   | Время  | Тип сверки |"*/

  put stream out-stream unformatted {&beg-title} .

  for each tt_places
    break by tt_places.gds-code by tt_places.pl-code
  :
    if first-of( tt_places.pl-code ) then do:
      assign
        v-rvs-count = v-rvs-count + 1
      .
      put stream out-stream unformatted
        substitute( "рез. &1", tt_places.pl-code ) format "X(15)"
        "|":U
        .
    end.
    assign
      tt_places.rvs-count = v-rvs-count
    .
  end.
  put stream out-stream unformatted skip.

  for each buf_rvs-doc no-lock
    where buf_rvs-doc.obj-type   =  obj-list.obj-type
      and buf_rvs-doc.obj-code   =  obj-list.obj-code
      and buf_rvs-doc.status_    =  {&fact}
      and buf_rvs-doc.fact-order >  prev-fo
      and buf_rvs-doc.fact-order <= last-fo
    ,each buf_rvs-line no-lock
    where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
      and buf_rvs-line.gds-code = gds-list.gds-code
    ,first buf_goods no-lock
    where buf_goods.gds-code = buf_rvs-line.gds-code
    break by buf_rvs-doc.fact-order by buf_rvs-line.gds-code
  :
    if first-of( buf_rvs-line.gds-code ) then do:
      case buf_rvs-doc.rvs-type:
        when {&rvs-after-doc} then do:
          assign
            v-rvs-type = "после приема"
          .
        end.
        when {&rvs-before-doc} then do:
          assign
            v-rvs-type = "до приема"
          .
        end.
        when {&rvs-shift} then do:
          assign
            v-rvs-type = "смена"
          .
        end.
        when {&rvs-control} then do:
          assign
            v-rvs-type = "контроль"
          .
          if buf_rvs-doc.is-full = true then do:
            assign
              v-rvs-type = substitute( "&1 (п)", v-rvs-type )
            .
          end.
        end.
      end case.

      put stream out-stream unformatted
        "|":U buf_rvs-doc.fact-date                       format "99/99/99"
        "|":U string( buf_rvs-doc.fact-time, "HH:MM:SS" ) format "X(8)"
        "|":U v-rvs-type                                  format "X(12)"
        "|":U buf_goods.artic                             format "X(11)"
      .

      do v-ind = 1 to v-rvs-count
      :
        put stream out-stream unformatted
          "|":U
          .
        find first tt_places no-lock
          where tt_places.rvs-code  = buf_rvs-doc.rvs-code
            and tt_places.gds-code  = buf_rvs-line.gds-code
            and tt_places.rvs-count = v-ind
          no-error .

        if available tt_places then do:
          put stream out-stream unformatted
            tt_places.qnty format "->>>>>>>>>9.999"
            .
        end.
        else do:
          put stream out-stream unformatted
            space(15)
            .
        end.
      end.
      put stream out-stream unformatted
        "|":U skip
        .
    end.
  end.

  for each tt_places
  :
    delete tt_places.
  end.

  output stream out-stream close.

  define variable v-user-action   as character no-undo .
  define variable v-printed       as logical   no-undo .

  run gbl/prnfilen.w
        ( input  ""
        , input  8
        , input  string(session :temp-directory) + {&DF_Name} + string( g#report-num )
        , input  ReportFontNum
        , output v-user-action
        , output v-printed
        ) .

  return .

end.