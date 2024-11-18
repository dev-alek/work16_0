/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Обработка документа проверки корректности работы АСИ в резервуаре (заведение, редактирование, просмотр)



Create: SlivenkoSA
01/04/24

*/

define input        parameter parparentproc as handle    no-undo .
define input        parameter pardoc-mode   as character no-undo .
define input        parameter par_test-asi-type   as character no-undo .
define input        parameter parall-place  as logical   no-undo .
define input-output parameter par_test-asi-rec    as recid     no-undo .

define variable varlog          as logical   no-undo.

&scop frame-name       d-rvs
&scop browse-name      br-line

/* ***************************  definitions  ************************** */
define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Обработка документа проверки корректности работы АСИ в резервуаре (заведение, редактирование, просмотр)":U.

{ cmp/vssrevis.i      }
{ cmp/showinf.i       }
{ str/libbcrcn.i      }
{ cmp/str-glbl.i      }
{ cmp/library.i       }
{ gbl/color.i         }
{ gbl/dtm.i           }
{ str/doc-code.i      }
{ gbl/getcntxt.i def  }
{ gbl/getcntxt.i get  }
{ str/lib-rvs.i       }
{ gbl/waitfram.i      }
{ str/rvsttdef.i file }
{ ref/gds-attr.i      }
{ str/is-gas.i        }
{ str/is-sug.i        }
{ str/placelib.i      }
{ gbl/db-attr.i       }
{ gbl/ptrlprop.i def  }

define buffer r-doc             for ub.rvs-doc.
define buffer cur_shift-obj     for ub.shift-obj.
define buffer prev_shift-obj    for ub.shift-obj.
define buffer buf_rvs-line-attr for ub.rvs-line-attr.
define buffer buf_doc-attr      for ub.doc-attr.

define variable v-ref-rec         as recid     no-undo .
define variable ii                as integer   no-undo.
define variable bcol              as handle    extent 37 no-undo.
define variable isMeasurement     as logical   no-undo init no.

/* ********************  preprocessor definitions  ******************** */
&scop open-query-{&browse-name} open query {&browse-name} ~
   for each  ub.rvs-line no-lock where ~
             ub.rvs-line.rvs-code =    r-doc.rvs-code ~
     , first ub.goods        no-lock where ~
             ub.goods.gds-code        = ub.rvs-line.gds-code ~
     , first ub.place                where ~
             ub.place.obj-type        = ub.rvs-line.obj-type and ~
             ub.place.obj-code        = ub.rvs-line.obj-code and ~
             ub.place.pl-code         = ub.rvs-line.pl-code  and ~
             ub.place.status_ <>      {&deleted-status}
             

&scop open-query-{&browse-name}-default {&open-query-{&browse-name}}.


&scop label-clmn_1-br-line  '*'
&scop sort-clmn_1-br-line   get-mark (buffer ub.rvs-line)
&scop label-clmn_2-br-line  'Артикул'
&scop sort-clmn_2-br-line   ub.goods.artic
&scop label-clmn_3-br-line  'Название'
&scop sort-clmn_3-br-line   ub.goods.gds-name
&scop label-clmn_4-br-line  'Скл.место'
&scop sort-clmn_4-br-line   ub.rvs-line.pl-code
&scop label-clmn_5-br-line  'Номер резервуара'
&scop sort-clmn_5-br-line   place.loc1
&scop label-clmn_6-br-line  'Факт остаток'
&scop sort-clmn_6-br-line   ub.rvs-line.state-measure-qnty
&scop label-clmn_7-br-line  'Измер. остаток'
&scop sort-clmn_7-br-line   ub.rvs-line.measure-qnty
&scop label-clmn_8-br-line  'Учет'
&scop sort-clmn_8-br-line   ub.rvs-line.system-qnty
&scop label-clmn_9-br-line  'Первонач.учет'
&scop sort-clmn_9-br-line   ub.rvs-line.orig-system-qnty
&scop label-clmn_10-br-line 'Факт в!трубопроводе'
&scop sort-clmn_10-br-line  ub.rvs-line.state-add-qnty
&scop label-clmn_11-br-line 'Отклонение(факт)'
&scop sort-clmn_11-br-line  deviation-fact(buffer ub.rvs-line)
&scop label-clmn_12-br-line 'Отклонение(измер)'
&scop sort-clmn_12-br-line  deviation-measure(buffer ub.rvs-line)
&scop label-clmn_13-br-line 'Допустимое!отклонение'
&scop sort-clmn_13-br-line  ub.rvs-line.tolerance
&scop label-clmn_14-br-line 'Факт брутто'
&scop sort-clmn_14-br-line  ub.rvs-line.state-brutto-qnty
&scop sort-clmn_15-br-line  ub.rvs-line.brutto-qnty
&scop sort-clmn_16-br-line  ub.rvs-line.state-density
&scop sort-clmn_17-br-line  ub.rvs-line.density
&scop sort-clmn_18-br-line  ub.rvs-line.state-measure-cli-qnty
&scop sort-clmn_19-br-line  ub.rvs-line.measure-cli-qnty
&scop sort-clmn_20-br-line  ub.rvs-line.system-cli-qnty
&scop sort-clmn_21-br-line  ub.rvs-line.orig-system-cli-qnty
&scop sort-clmn_22-br-line  ub.rvs-line.state-brutto-cli-qnty
&scop sort-clmn_23-br-line  ub.rvs-line.brutto-cli-qnty
&scop sort-clmn_24-br-line  ub.rvs-line.state-mh-qnty
&scop sort-clmn_25-br-line  ub.rvs-line.meas-mh-qnty
&scop sort-clmn_26-br-line  ub.rvs-line.state-am-qnty
&scop sort-clmn_27-br-line  ub.rvs-line.meas-am-qnty
&scop sort-clmn_28-br-line  ub.rvs-line.state-cf-qnty
&scop sort-clmn_29-br-line  ub.rvs-line.meas-cf-qnty
&scop sort-clmn_30-br-line  ub.rvs-line.state-level-total
&scop sort-clmn_31-br-line  ub.rvs-line.level-total
&scop sort-clmn_32-br-line  ub.rvs-line.state-level-petrol
&scop sort-clmn_33-br-line  ub.rvs-line.level-petrol
&scop sort-clmn_34-br-line  ub.rvs-line.state-level-water
&scop sort-clmn_35-br-line  ub.rvs-line.level-water
&scop sort-clmn_36-br-line  ub.rvs-line.state-temperature
&scop sort-clmn_37-br-line  ub.rvs-line.temperature
&scop enabled-clmn          {&sort-clmn_37-br-line}

/* ***********************  control definitions  ********************** */
define variable rvs-line-rec      as recid     no-undo.
define variable varartic          like ub.doc-line.artic no-undo initial " ".
define variable ref-list          as character no-undo.
define variable l-g#stat          as character no-undo.
define variable l-g#type          as character no-undo.
define variable l-g#internal      as logical   no-undo.
define variable varres            as logical   no-undo initial ?.
define variable varrecid          as recid     no-undo.
define variable ptoldfilvalue     as character no-undo.
define variable ptoldfiltype      as character no-undo.
define variable varcur-data       as integer   no-undo.
define variable varnum            as integer   no-undo.
define variable varcur-rvs        as integer   no-undo.
define variable varcur-pump       as logical   no-undo.
define variable gds-rec           as recid     no-undo.
define variable notes             as character no-undo.
define variable rep-rec           as recid     no-undo.
define variable lns-cnt           as integer   no-undo.

define variable v-asi-ip          as character no-undo .
define variable v-asi-port        as character no-undo .
define variable v-asi-type        as character no-undo .
define variable v-attr-type       as character no-undo .

define variable vTimeAutoSkip     as integer  no-undo.

define buffer cli-buf      for ub.clients.
define buffer del-rvs-line for ub.rvs-line.

define button b-help
  label "Помощь":U
  size 10 by 1.

define button b-exit auto-go
  label "Выход":U
  size 10 by 1.

define button b-mark
  label "&*":U
  size 3 by 1.

define button b-add
  label "Добавить":U
  size 10 by 1.

define button b-lkp
  label "Просмотр":U
  size 10 by 1.


define button b-chg
  label "Изменить":U
  size 10 by 1.

define button b-del
  label "Удалить":U
  size 10 by 1.

define button b-history
  label "История":U
  size 10 by 1.

define button b-notes
  label "Прим.":U
  size 10 by 1.

define button b-meas
  label "Измерение"
  size 10 by 1.

define menu m-meas
  menu-item m-meas-1 label "Всех резервуаров в документе" accelerator "alt-1"
  menu-item m-meas-3 label "Текущего резервуара"          accelerator "alt-3".


define button r-acc
  image-up          file "btn-down-arrow"
  image-down        file "btn-down-arrow"
  image-insensitive file "btn-down-arrow"
  size 3 by .88.

define button r-agnt     like r-acc.
define button r-boss     like r-acc.
define button r-wrkr     like r-acc.

define variable agnt-name as character format "x(256)":u
  view-as text
  size 11.2 by 1 no-undo.

define variable boss-name as character format "x(256)":u
  view-as text
  size 11.2 by 1 no-undo.

define variable wrkr-name as character format "x(256)":u
  view-as text
  size 11.2 by 1 no-undo.

define variable del-list  as character no-undo.

function get-mark return character (buffer local-rvs-line for ub.rvs-line ).
  if lookup (string (recid (local-rvs-line)), del-list) > 0 then return "*".
  else return "".
end function.

function deviation-fact    return decimal (buffer local-rvs-line for ub.rvs-line ).
  return (local-rvs-line.state-measure-qnty   + local-rvs-line.state-add-qnty - local-rvs-line.system-qnty).
end function.

function deviation-measure return decimal (buffer local-rvs-line for ub.rvs-line ).
  return (local-rvs-line.measure-qnty + local-rvs-line.state-add-qnty - local-rvs-line.system-qnty).
end function.

define query {&browse-name}      for ub.rvs-line, ub.goods, ub.place scrolling.
define browse {&browse-name} query {&browse-name} no-lock display
  {&sort-clmn_1-br-line}  column-label {&label-clmn_1-br-line}  format "x(1)"
  {&sort-clmn_2-br-line}  column-label {&label-clmn_2-br-line}
      {&sort-clmn_3-br-line}  column-label {&label-clmn_3-br-line}  format "x(15)"
      {&sort-clmn_4-br-line}  column-label {&label-clmn_4-br-line}  FORMAT "99999999999":U
      {&sort-clmn_5-br-line}  column-label {&label-clmn_5-br-line}
      {&sort-clmn_6-br-line}  column-label {&label-clmn_6-br-line}
      {&sort-clmn_7-br-line}  column-label {&label-clmn_7-br-line}
      {&sort-clmn_8-br-line}  column-label {&label-clmn_8-br-line}
      {&sort-clmn_9-br-line}  column-label {&label-clmn_9-br-line}
      {&sort-clmn_10-br-line} column-label {&label-clmn_10-br-line} format "->>,>>>,>>>.<<<"
      {&sort-clmn_11-br-line} column-label {&label-clmn_11-br-line} format "->>,>>>,>>>.<<<"
      {&sort-clmn_12-br-line} column-label {&label-clmn_12-br-line}
      {&sort-clmn_13-br-line} column-label {&label-clmn_13-br-line}
      {&sort-clmn_14-br-line} column-label {&label-clmn_14-br-line}
      {&sort-clmn_15-br-line}
      {&sort-clmn_16-br-line}
      {&sort-clmn_17-br-line}
      {&sort-clmn_18-br-line}
      {&sort-clmn_19-br-line}
      {&sort-clmn_20-br-line}
      {&sort-clmn_21-br-line}
      {&sort-clmn_22-br-line}
      {&sort-clmn_23-br-line}
      {&sort-clmn_24-br-line}
      {&sort-clmn_25-br-line}
      {&sort-clmn_26-br-line}
      {&sort-clmn_27-br-line}
      {&sort-clmn_28-br-line}
      {&sort-clmn_29-br-line}
      {&sort-clmn_30-br-line}
      {&sort-clmn_31-br-line}
      {&sort-clmn_32-br-line} format "->>,>>>,>>>.<<<"
      {&sort-clmn_33-br-line}
      {&sort-clmn_34-br-line}
      {&sort-clmn_35-br-line}
      {&sort-clmn_36-br-line}
      {&sort-clmn_37-br-line}
      enable {&enabled-clmn}
    with size 98.75 by 9 separators.


/* ************************  frame definitions  *********************** */
define frame {&frame-name}
  b-exit              at row 1  col 1
  b-notes             at row 1  col 11
  b-history           at row 1  col 71
  b-help              at row 1  col 81
  "Объект:"                         at row 2 col 10
  r-doc.obj-code                    at row 2 col 16   colon-aligned no-label       view-as text size 7    by 1
  r-doc.obj-type                    at row 2 col 23   colon-aligned no-label       view-as text size 7.13 by 1
  ub.clients.obj-name               at row 2 col 33   colon-aligned no-label       view-as text size 40 by 1 fgcolor 4
  r-doc.doc-date                    at row 3 col 40   colon-aligned view-as text
  r-doc.wrkr                        at row 5 col 4.5  colon-aligned format "999999999"  view-as fill-in size 10 by 1
  wrkr-name                         at row 5 col 15   colon-aligned no-label fgcolor 4
  r-wrkr                            at row 5 col 28   no-label
  r-doc.agnt                        at row 6 col 4.5 colon-aligned format "999999999"  view-as fill-in size 10 by 1
  agnt-name                         at row 6 col 15  colon-aligned no-label fgcolor 4
  r-agnt                            at row 6 col 28  no-label
  r-doc.boss                    at row 7 col 4.5   colon-aligned format "999999999"       view-as fill-in size 10 by 1
  boss-name                     at row 7 col 15    colon-aligned no-label                fgcolor 4
  r-boss                        at row 7 col 28    no-label
  b-mark              at row 8  col 1
  b-add               at row 8  col 4
  b-del               at row 8  col 14
  b-meas              at row 8  col 24
  b-lkp               at row 8  col 34
  b-chg               at row 8  col 44
  {&browse-name}      at row 9  col 1
  space(0) skip(0)
  with view-as dialog-box side-labels three-d scrollable keep-tab-order.

/* ***************  runtime attributes and uib settings  ************** */

assign
  frame {&frame-name}:scrollable                                = false
  {&browse-name}     :num-locked-columns in frame {&frame-name} = 5
  b-meas             :popup-menu in frame {&frame-name}         = menu m-meas:handle
  b-meas             :menu-mouse                                = 1.


/* ************************  control triggers  ************************ */
{ gbl/mv-clmn.i
 &ext-col      = 35
 &frame-name   = "{&frame-name}"
 &browse-name  = "{&browse-name}"
 &table-name   = "ub.rvs-line"
 &start-column = 6
}

{ gbl/f2.i {&browse-name} " " " " parparentproc }

{ gbl/hot-key.i b-lkp }
{ gbl/hot-key.i b-chg }
{ gbl/hot-key.i b-del }
{ gbl/hot-key.i b-mark }

on end-error, stop of frame {&frame-name} 
  do:
    apply "choose" to b-exit in frame {&frame-name}.
    return no-apply.
  end.

on choose of b-notes in frame {&frame-name}
  do:
    assign 
      notes = r-doc.ps.
    run gbl/notes.w ( input pardoc-mode, input-output notes ).
    if r-doc.ps <> notes then 
    do:
      do on stop undo, return no-apply :
        find r-doc exclusive-lock where recid (r-doc) = par_test-asi-rec.
        assign 
          r-doc.ps = notes.
      end.
    end.
  end.

on choose of b-history in frame {&frame-name}
  do:
    define variable v-list as character no-undo.

    if available r-doc then 
    do:
      run str/rvscdocs.w ( input        parparentproc,
        input        "":U,
        input        "one":U,
        input        r-doc.rvs-code,
        input-output v-list                  ).
    end.
  end.

on choose of b-exit in frame {&frame-name} /* Вых */
  do:
    if pardoc-mode = {&update}  or
      pardoc-mode = {&add-def} then 
    do:
      if not can-find (first ub.rvs-line where ub.rvs-line.rvs-code = r-doc.rvs-code no-lock) then 
      do:
        varlog = yes.
        message "В документе нет строк, поэтому он удаляется." view-as alert-box
          question buttons ok-cancel update varlog.
        if varlog then 
        do:
          delete r-doc.
          par_test-asi-rec = ?.
          return.
        end.
        else return no-apply.
      end.
      assign r-doc.wrkr r-doc.agnt r-doc.boss.
    end.
  end.

on mouse-select-dblclick, return of r-doc.agnt in frame {&frame-name} /* Эксп */
  do:
    run local-psn-chk in this-procedure ( input "agnt", input "ret-mouse" ).
    apply "entry" to r-doc.boss in frame {&frame-name}.
    return no-apply.
  end.

on mouse-select-dblclick, return of r-doc.boss in frame {&frame-name} /* Нач */
  do:
    run local-psn-chk in this-procedure ( input "boss", input "ret-mouse" ).
    apply "entry" to b-exit in frame {&frame-name}.
    return no-apply.
  end.

on mouse-select-dblclick, return of r-doc.wrkr in frame {&frame-name} /* Исп */
  do:
    run local-psn-chk in this-procedure ( input "wrkr", input "ret-mouse" ).
    apply "entry" to r-doc.agnt in frame {&frame-name}.
    return no-apply.
  end.

on choose of r-agnt in frame {&frame-name} /* agent */
  do:
    run local-psn-chk in this-procedure ( input "agnt", input "button" ).
    apply "entry" to r-doc.boss in frame {&frame-name}.
    return no-apply.
  end.

on choose of r-boss in frame {&frame-name} /* boss */
  do:
    run local-psn-chk in this-procedure ( input "boss", input "button" ).
    apply "entry" to b-exit in frame {&frame-name}.
    return no-apply.
  end.

on choose of r-wrkr in frame {&frame-name} /* worker */
  do:
    run local-psn-chk in this-procedure ( input "wrkr", input "button" ).
    apply "entry" to r-doc.agnt in frame {&frame-name}.
    return no-apply.
  end.

on leave of r-doc.agnt in frame {&frame-name} /* agent */
  do:
    run local-psn-chk in this-procedure ( input "agnt", input "leave" ).
  end.

on leave of r-doc.boss in frame {&frame-name} /* boss */
  do:
    run local-psn-chk in this-procedure ( input "boss", input "leave" ).
  end.

on leave of r-doc.wrkr in frame {&frame-name} /* worker */
  do:
    run local-psn-chk in this-procedure ( input "wrkr", input "leave" ).
  end.

on return, mouse-select-dblclick of {&browse-name} in frame {&frame-name}
  do:
    if b-chg:sensitive then apply "choose" to b-chg in frame {&frame-name}.
    else apply "choose" to b-lkp in frame {&frame-name}.
  end.


on choose of b-mark in frame {&frame-name} 
  do:
    run local-mark in this-procedure.
    varlog = {&browse-name}:select-next-row ().
    apply "entry" to {&browse-name} in frame {&frame-name}.
  end.

on choose of b-add in frame {&frame-name}
do :
  define buffer buf_rvs-line for ub.rvs-line .
  define buffer buf_place    for ub.place .
  define buffer buf_pl-gds   for ub.pl-gds .
  
  define variable place-list as character no-undo .
  
  run ref/pl-list.w (
   input parparentproc
  ,input "b-sel,b-mark"
  ,input r-doc.obj-type
  ,input r-doc.obj-code
  ,input {&g___object}
  ,input-output place-list).
  
  do ii = 1 to num-entries(place-list) :
    find first buf_place no-lock where recid(buf_place) = integer(entry(ii, place-list)) .
    find first buf_pl-gds no-lock where
      buf_pl-gds.obj-type = buf_place.obj-type and
      buf_pl-gds.obj-code = buf_place.obj-code and
      buf_pl-gds.pl-code  = buf_place.pl-code  no-error.
    if not available buf_pl-gds then 
    do:
      message substitute("Ошибка при выборке складского места &1. К нему не привязан товар.", buf_place.loc1)
        view-as alert-box .
      next.
    end.
    find first buf_rvs-line no-lock where
      buf_rvs-line.rvs-code = r-doc.rvs-code and
      buf_rvs-line.gds-code = buf_pl-gds.gds-code       and
      buf_rvs-line.pl-code  = buf_pl-gds.pl-code       no-error.
    if available buf_rvs-line then 
    do:
      message "Складское место " buf_place.loc1
        " уже имеется в данном документе проверки корректности работы АСИ в резервуаре." skip
        view-as alert-box.
      next.
    end.
    
    tr:
    do transaction :
      { str/crrvslin.i
          r-doc.obj-type
          r-doc.obj-code
          r-doc.rvs-code
          r-doc.rvs-type
          buf_pl-gds.pl-code
          buf_pl-gds.gds-code
          ?
          "if available cur_shift-obj then cur_shift-obj.shift-date else ?"
          "if available cur_shift-obj then cur_shift-obj.shift-num else ?"
          no-error
      }
      if error-status :error then 
      do:
        message "Ошибка при создании линии. "
          return-value
          view-as alert-box error.
        undo tr, return no-apply.
      end.
      if return-value begins "GAS!"
      or return-value begins "NMS!"
      or return-value begins "VIR!"
      then do :
        message substring(return-value, 5) view-as alert-box .
        undo tr, next .
      end .
    end. /* transaction */
  end .
  
  run ui-on in this-procedure no-error.
  if error-status :error then 
  do:
    return no-apply.
  end.
  apply "entry" to b-add in frame {&frame-name}.
  return no-apply.
                 
end .

on choose of b-chg in frame {&frame-name} /* Измен */
do:

  do on stop undo, return no-apply :
    if not available ub.rvs-line then 
    do:
      message "Неправильный выбор строки.".
      return no-apply.
    end.
    run local-chg in this-procedure no-error.
    if error-status :error then 
    do: 
      return no-apply. 
    end.
    run ui-on in this-procedure .
  end. /* on stop */
end.

on choose of b-del in frame {&frame-name} /* Удал */
do:
  run del-rvs-line in this-procedure no-error.
  if error-status :error then 
  do: 
    return no-apply. 
  end.
  assign 
    rvs-line-rec = rep-rec.
  run ui-on in this-procedure.
end.

on choose of b-lkp in frame {&frame-name} /* Просм */
do:
  run proc-lkp in this-procedure no-error.
  if error-status :error then 
  do: 
    return no-apply. 
  end.
end.

/* Сверка по всем резервуарам */
on choose of menu-item m-meas-1 in menu m-meas 
do:
  run proc_m-meas-1 in this-procedure no-error.
  if error-status :error then 
  do: 
    return no-apply. 
  end.
end.

/* Сверка по текущему резервуару */
on choose of menu-item m-meas-3 in menu m-meas 
do:
  run proc_m-meas-3 in this-procedure no-error.
  if error-status :error then 
  do: 
    return no-apply. 
  end.
end.

{ gbl/srt-clmn.i
&browse-name = {&browse-name}
&frame-name  = {&frame-name}
&table-name = "ub.rvs-line"
&ext-col = 37
&start-column  = 5
&label-clmn_1  = "{&label-clmn_1-br-line}"
&sort-clmn_1   = "{&sort-clmn_1-br-line}"
&label-clmn_2  = "{&label-clmn_2-br-line}"
&sort-clmn_2   = "{&sort-clmn_2-br-line}"
&label-clmn_3  = "{&label-clmn_3-br-line}"
&sort-clmn_3   = "{&sort-clmn_3-br-line}"
&label-clmn_4  = "{&label-clmn_4-br-line}"
&sort-clmn_4   = "{&sort-clmn_4-br-line}"
&label-clmn_5  = "{&label-clmn_5-br-line}"
&sort-clmn_5   = "{&sort-clmn_5-br-line}"
&label-clmn_6  = "{&label-clmn_6-br-line}"
&sort-clmn_6   = "{&sort-clmn_6-br-line}"
&label-clmn_7  = "{&label-clmn_7-br-line}"
&sort-clmn_7   = "{&sort-clmn_7-br-line}"
&label-clmn_8  = "{&label-clmn_8-br-line}"
&sort-clmn_8   = "{&sort-clmn_8-br-line}"
&label-clmn_9  = "{&label-clmn_9-br-line}"
&sort-clmn_9   = "{&sort-clmn_9-br-line}"
&label-clmn_10 = "{&label-clmn_10-br-line}"
&sort-clmn_10  = "{&sort-clmn_10-br-line}"
&label-clmn_11 = "{&label-clmn_11-br-line}"
&sort-clmn_11  = "{&sort-clmn_11-br-line}"
&label-clmn_12 = "{&label-clmn_12-br-line}"
&sort-clmn_12  = "{&sort-clmn_12-br-line}"
&label-clmn_13 = "{&label-clmn_13-br-line}"
&sort-clmn_13  = "{&sort-clmn_13-br-line}"
&label-clmn_14 = "{&label-clmn_14-br-line}"
&sort-clmn_14  = "{&sort-clmn_14-br-line}"
&sort-clmn_15  = "{&sort-clmn_15-br-line}"
&sort-clmn_16  = "{&sort-clmn_16-br-line}"
&sort-clmn_17  = "{&sort-clmn_17-br-line}"
&sort-clmn_18  = "{&sort-clmn_18-br-line}"
&sort-clmn_19  = "{&sort-clmn_19-br-line}"
&sort-clmn_20  = "{&sort-clmn_20-br-line}"
&sort-clmn_21  = "{&sort-clmn_21-br-line}"
&sort-clmn_22  = "{&sort-clmn_22-br-line}"
&sort-clmn_23  = "{&sort-clmn_23-br-line}"
&sort-clmn_24  = "{&sort-clmn_24-br-line}"
&sort-clmn_25  = "{&sort-clmn_25-br-line}"
&sort-clmn_26  = "{&sort-clmn_26-br-line}"
&sort-clmn_27  = "{&sort-clmn_27-br-line}"
&sort-clmn_28  = "{&sort-clmn_28-br-line}"
&sort-clmn_29  = "{&sort-clmn_29-br-line}"
&sort-clmn_30  = "{&sort-clmn_30-br-line}"
&sort-clmn_31  = "{&sort-clmn_31-br-line}"
&sort-clmn_32  = "{&sort-clmn_32-br-line}"
&sort-clmn_33  = "{&sort-clmn_33-br-line}"
&sort-clmn_34  = "{&sort-clmn_34-br-line}"
&sort-clmn_35  = "{&sort-clmn_35-br-line}"
&sort-clmn_36  = "{&sort-clmn_36-br-line}"
&sort-clmn_37  = "{&sort-clmn_37-br-line}"
&open-query           = "{&open-query-{&browse-name}} by ~{&sort-clmn_~{&clmn_num~}~} ."
&open-query-otherwise = "{&open-query-{&browse-name}-default}"
&re-move-clmn         = "yes"
&mv-brw-default       = "yes"}


on value-changed of {&browse-name} in frame {&frame-name} 
do:
  
end.

ON ROW-DISPLAY OF {&browse-name} IN FRAME {&frame-name} 
  DO:
  END.

/* ***************************  main block  *************************** */
if valid-handle(active-window) and frame {&frame-name}:parent eq ?
  then frame {&frame-name}:parent = active-window.

on window-close of frame {&frame-name} 
  apply "end-error":u to self.

{ gbl/app_help.i }

main-block:
do on error   undo main-block, leave main-block
  on end-key undo main-block, leave main-block
  on stop    undo main-block, leave main-block:
   
  do ii = 1 to 37:
    bcol[ii] = {&browse-name}:get-browse-column(ii).
  end.

  run mode-on in this-procedure
    no-error.
  if error-status :error then 
  do:
    return error return-value .
  end.
  if pardoc-mode <> {&lookup} then 
  do:
    assign
      rvs-line-rec = ?
      .
  end.
  run ui-on in this-procedure.

  wait-for go of frame {&frame-name} focus b-add.
end.
run disable_ui in this-procedure.


/* **********************  internal procedures  *********************** */

procedure disable_ui :
  hide frame {&frame-name}.
end procedure.

procedure ui-on :
  /* ----------------------------------------------------------------------------------------------------------------------------
    purpose:     включение пользовательского интерфейса в нужном режиме
  --------------------------------------------------------------------------------------------------------------------------------- */
  del-list = "".
  find first ub.clients where ub.clients.obj-type = r-doc.obj-type and
    ub.clients.obj-code = r-doc.obj-code no-lock.
  assign 
    frame {&frame-name}:title = "(" + substring (ub.clients.obj-name, 1, 35) +
       ") :   ДОКУМЕНТ проверки корректности работы АСИ в резервуаре - " + r-doc.status_ + " № " + r-doc.rvs-code + "      - " + pardoc-mode.
  disable all with frame {&frame-name}.
  enable b-exit b-help b-lkp {&browse-name} b-history b-notes with frame {&frame-name}.
  assign {&enabled-clmn}:read-only in browse {&browse-name} = yes.
  if r-doc.status_ = {&g___new} and
    (pardoc-mode = {&add-def} or
    pardoc-mode = {&update}        ) then 
  do:
    enable r-doc.wrkr
      r-doc.agnt
      r-doc.boss
      r-wrkr r-agnt r-boss
      b-mark
    with frame {&frame-name}.
    if not isMeasurement then
        enable
          b-add b-del b-chg  b-meas
        with frame {&frame-name}.
  end.
  

  if available ub.clients then disp ub.clients.obj-name with frame {&frame-name}.
  else disp ? @ ub.clients.obj-name with frame {&frame-name}.
  disp r-doc.obj-code
    r-doc.obj-type
    r-doc.doc-date
    with frame {&frame-name}.

  for first ub.user-account-attr no-lock where ub.user-account-attr.user-id = v-cntxt-userid
    and ub.user-account-attr.attr-code = "psn-code"
    :
    if ub.user-account-attr.attr-value <> ""
      and ub.user-account-attr.attr-value <> ?
      and ub.user-account-attr.attr-value <> "0"
      and ub.user-account-attr.attr-value <> "?"
      then 
    do:
      if pardoc-mode = {&add-def}
        then 
      do :
        r-doc.agnt:screen-value in frame {&frame-name} = trim (ub.user-account-attr.attr-value).
        r-doc.wrkr:screen-value in frame {&frame-name} = trim (ub.user-account-attr.attr-value).
        r-doc.boss:screen-value in frame {&frame-name} = trim (ub.user-account-attr.attr-value).
      end.
      if pardoc-mode = {&update}
        then 
      do :
        r-doc.agnt:screen-value in frame {&frame-name} = trim (ub.user-account-attr.attr-value).
      end.
    end. 
  end .    

  { str/psn-chk.i wrkr on r-doc v-ref-rec }
  { str/psn-chk.i agnt on r-doc v-ref-rec }
  { str/psn-chk.i boss on r-doc v-ref-rec }

  {&open-query-{&browse-name}-default}
  if pardoc-mode = {&lookup} then 
  do:
    if rvs-line-rec      <> ? then reposition {&browse-name}      to recid rvs-line-rec      no-error.
  end.
  if pardoc-mode = {&update} then 
  do:
    if not can-find (first ub.rvs-line where ub.rvs-line.rvs-code = r-doc.rvs-code no-lock) then
      apply "entry" to b-add in frame {&frame-name}.
    else 
    do:
      if rvs-line-rec      <> ? then reposition {&browse-name}      to recid rvs-line-rec      no-error.
    end.
  end.


  if num-results( "{&browse-name}" ) > 0 then 
  do:
    if {&browse-name}:refresh() then.
  end.
end procedure.

PROCEDURE local-mark:
  if not available ub.rvs-line then 
  do:
    message "Неправильный выбор строки.".
    return no-apply.
  end.
  { gbl/markstrn.i ub.rvs-line del-list }
  {&browse-name}:refresh() in frame {&frame-name} .
END PROCEDURE.

procedure del-rvs-line:
  if del-list = "" then 
  do:
    /* удаление 1 строки */
    if not available ub.rvs-line then 
    do:
      message "Неправильный выбор строки.".
      return error.
    end.
    varlog = no.
    message "Удалить строку документа проверки корректности работы АСИ в резервуаре ?   Вы уверены ?"
      view-as alert-box question buttons ok-cancel update varlog.
    if not varlog then return error.
    rvs-line-rec = recid (ub.rvs-line).
    del-list     = string (recid (ub.rvs-line)).
    get next {&browse-name}.
    if available ub.rvs-line then rep-rec = recid (ub.rvs-line).
    else 
    do:
      reposition {&browse-name} to recid rvs-line-rec no-error.
      get prev {&browse-name}.
      rep-rec = recid (ub.rvs-line).
    end.
  end.
  else 
  do:
    /* удаление отмеченных строк */
    varlog = ?.
    message "УДАЛЕНИЕ  ПО  ОТМЕТКАМ  строк документа ?" skip (2)
      "yes - удалить все отмеченные строки" skip
      "no - оставить только отмеченные строки и удалить все остальные" skip (2)
      "cancel - ничего не удалять"
      view-as alert-box question buttons yes-no-cancel update varlog.
    if varlog = ? then return error.
    rep-rec = ?.
  end.
  do transaction on error   undo, return error
    on end-key undo, return error
    on stop    undo, return error :
    for each del-rvs-line where del-rvs-line.rvs-code = r-doc.rvs-code no-lock
      :
      if not varlog and     can-do (del-list, string (recid (del-rvs-line))) then next.
      if     varlog and not can-do (del-list, string (recid (del-rvs-line))) then next.
      assign 
        rvs-line-rec = recid(del-rvs-line).
      find ub.rvs-line where recid (ub.rvs-line) = rvs-line-rec exclusive.
      delete ub.rvs-line.
    end.
/*    { str/rvsclchd.i "recid( r-doc )"              */
/*                yes                      no-error }*/
  end.

end procedure.


procedure mode-on :
  /* -----------------------------------------------------------
    purpose:     чтение или создание шапки
  ------------------------------------------------------------- */
  define variable v-shift-date like ub.shift-obj.shift-date no-undo.
  define variable v-shift-num  like ub.shift-obj.shift-num no-undo.
  define variable v-shift-name as character no-undo.
  define variable v-obj-date   as date      no-undo.
  define variable c-value      as character no-undo .
  define variable c-type       as character no-undo .

  define buffer bf_place  for ub.place.
  define buffer bf_r-line for ub.rvs-line.
  define buffer buf_pl-gds   for ub.pl-gds .
  
  { gbl/conf-rd.i
    "'ptoldfil':u"
    v-cntxt-host-code-obj
    v-cntxt-obj-type
    v-cntxt-obj-code
    "''"
    "''"
    "''"
    no
    ptoldfilvalue
    ptoldfiltype
    no-error
  }
  
  if pardoc-mode = {&add-def} or
    pardoc-mode = {&update} then 
  do:
    find first cur_shift-obj
      where cur_shift-obj.obj-type = v-cntxt-obj-type
      and cur_shift-obj.obj-code = v-cntxt-obj-code
      and cur_shift-obj.status_  = {&sht-current}
      use-index pi no-lock no-error .
  
  end .

  case pardoc-mode :
    when {&add-def} then 
      do:
        tr:
        do transaction
          on error undo, return error return-value
          on stop  undo, return error return-value
          on quit  undo, return error return-value
          :
          create r-doc.
          run doc-code in this-procedure
            (input  "main",
            input  v-cntxt-obj-type,
            input  v-cntxt-obj-code,
            input  ?,
            output r-doc.rvs-code ) no-error.
          if error-status :error then 
          do:
            message "Ошибка при генерации номера документа." skip return-value view-as alert-box.
            undo tr, return error.
          end.
          { gbl/curobjdt.i v-cntxt-obj-type v-cntxt-obj-code v-obj-date }
          assign
            r-doc.host-code = v-cntxt-host-code-obj
            r-doc.obj-type  = v-cntxt-obj-type
            r-doc.obj-code  = v-cntxt-obj-code
            r-doc.status_   = {&g___new}
            r-doc.rvs-type  = {&test-asi}
            r-doc.out-code  = ?
            r-doc.creid     = v-cntxt-userid
            r-doc.ps        = "@"
            r-doc.doc-date  = v-obj-date
            .
          if parall-place then
            assign r-doc.is-full = yes.
          
          create buf_doc-attr.
          assign
            buf_doc-attr.doc-code = r-doc.rvs-code
            buf_doc-attr.attr-code = "test-asi-type"
            buf_doc-attr.attr-value = par_test-asi-type
          .  

          /* Следует задать дату смены сразу, чтобы делать выборку баков, задействованных в смене */
          run gbl/factdate.p ( input        r-doc.obj-type
            , input        r-doc.obj-code
            , input-output r-doc.fact-date
            , input-output r-doc.fact-time
            , input-output r-doc.shift-date
            , input-output r-doc.shift-num
            , input-output r-doc.shift-name
            , input        yes
            ) no-error.
          if error-status :error then 
          do:
            message
              "Ошибка при установке даты в документе(rvs-doc)." skip
              view-as alert-box error.
            undo tr, return error.
          end.
          if parall-place 
          then do:
            run waitfram-show in this-procedure ( input "Создаем строки по резервуарам" ).
            { str/place-sh.i
              r-doc.obj-type
              r-doc.obj-code
              r-doc.rvs-code
              r-doc.rvs-type
              ?
              "if available cur_shift-obj then cur_shift-obj.shift-date else ?"
              "if available cur_shift-obj then cur_shift-obj.shift-num else ?"
              no
              no-error
          }
            if error-status :error then 
            do:
              message "Ошибка при создании линий документа проверки корректности работы АСИ в резервуаре." skip
                return-value
                view-as alert-box error.
              run waitfram-hide in this-procedure.
              undo tr, return error.
            end.
            run waitfram-show in this-procedure ( input "Просматриваем измеряемые резервуары" ).
            { str/meas-plc.i
              r-doc.obj-type
              r-doc.obj-code
              tt-meas
              no-error
            }
            if error-status :error then 
            do:
              message "Ошибка при определении резервуаров для измерения."
                return-value
                view-as alert-box error.
              run waitfram-hide in this-procedure.
              undo tr, return error.
            end.
            
            for each tt-meas :
              find first buf_pl-gds no-lock where buf_pl-gds.obj-type = tt-meas.obj-type
                                              and buf_pl-gds.obj-code = tt-meas.obj-code
                                              and buf_pl-gds.pl-code  = tt-meas.pl-code
                                              no-error.
              if not available buf_pl-gds
              then do:
                delete tt-meas .
              end.
              else do :
                &scop proc-name gds-attr-value
                {&run_proc_attr-lib}
                  (input  buf_pl-gds.gds-code
                  ,input  {&attr-fuel-type}
                  ,output c-value
                  ,output c-type)
                no-error.
                if c-value = 'lgas':U
                or c-value = 'metan':U
                or c-value = 'propan':U
                then do :
                  delete tt-meas .
                end .
              end .
            end .
            
            find first sys-ctrl no-lock.
            run db-attr-value(sys-ctrl.db,"AsiIp",output v-asi-ip,output v-attr-type).
            run db-attr-value(sys-ctrl.db,"AsiPort",output v-asi-port,output v-attr-type).
            run db-attr-value(sys-ctrl.db,"AsiType",output v-asi-type,output v-attr-type).
            if trim(v-asi-ip) <> ''
              and trim(v-asi-port) <> ''
              and trim(v-asi-type) <> ''
              then 
            do :
              case v-asi-type :
                when "1"
                then 
                  do :
                    varcur-data = 2 .
                  end.
                when "2"
                then 
                  do :
                    varcur-data = 3 .
                  end.
              end case .
            end.
            else 
            do :
              if ptoldfilvalue = "yes":u then 
              do:
                run gbl/d-askw.w ( input "Выбор источника данных с информацией по резервуарам и ТРК",
                  "Будем читать текущие данные с резервуаров и ТРК или возьмем данные из файла?",
                  "|^",
                  "Текущие данные|Из файлов|Отмена",
                  "Запускается программа для обращения к датчикам резервуаров и ТРК|Берутся уже сохраненные данные из файла|Ничего не делаем",
                  1,
                  3,
                  output varnum
                  ).
                case varnum:
                  when 3 then 
                    do:
                      return error.
                    end.
                  when 2 then 
                    do:
                      assign
                        varcur-data = 0.
                    end.
                  when 1 then 
                    do:
                      assign
                        varcur-data = 1.
                    end.
                end case.
              end.
              else 
              do:
                assign
                  varcur-data = 1.
              end.
            end.
            if can-find(first tt-meas) then 
            do:
              run waitfram-show  in this-procedure ( input "Делаем сверку по всем резервуарам" ).
              { str/rvsplace.i
                r-doc.obj-type
                r-doc.obj-code
                no
                varcur-data
                yes
                no
                tt-meas-file
                tt-meas
                no-error
             }
              if error-status :error then 
              do:
                message "Ошибка при получении данных с приборов на резервуарах." skip
                  return-value
                  view-as alert-box error.
                run waitfram-hide in this-procedure.
                undo tr, return error.
              end.
              run waitfram-hide in this-procedure.
              { str/fall-plc.i
                 r-doc.obj-type
                 r-doc.obj-code
                 r-doc.rvs-code
                 yes
                 no-error
             }
              if error-status :error then 
              do:
                message "Ошибка при заполнении данных с приборов на резервуарах." skip
                  return-value
                  view-as alert-box error.
                run waitfram-hide in this-procedure.
                undo tr, return error.
              end.
            end.
          end.
          assign 
            par_test-asi-rec = recid (r-doc).
        end. /* transaction */
      end.
    when {&update} then 
      do:
        tr:
        do transaction
          on error undo, return error return-value
          on stop  undo, return error return-value
          on quit  undo, return error return-value
          :
          find r-doc where recid (r-doc) = par_test-asi-rec no-error.
          if available r-doc then 
          do:
            if r-doc.status_ = {&fact} then 
            do:
              find r-doc where recid (r-doc) = par_test-asi-rec no-lock.
              message "Документ уже закрыт. Изменение невозможно.".
              undo tr, return error.
            end.
            find r-doc where recid (r-doc) = par_test-asi-rec exclusive.
          end.
        end. /* transaction */
      end.
    when {&lookup} then 
      do:
        find r-doc no-lock where recid (r-doc) = par_test-asi-rec.
      end.
  end case. /* pardoc-mode */
  if not available r-doc then 
  do:
    message "Неправильно выбран документ.".
    undo, return error.
  end.
end procedure.

procedure local-psn-chk:
  define input parameter parman    as character no-undo.
  define input parameter paraction as character no-undo.
  if parman = "agnt" and paraction = "ret-mouse" then 
  do:
    { str/psn-chk.i agnt ret-mouse r-doc v-ref-rec }
  end.
  if parman = "agnt" and paraction = "button" then 
  do:
    { str/psn-chk.i agnt button r-doc v-ref-rec }
  end.
  if parman = "agnt" and paraction = "leave" then 
  do:
    { str/psn-chk.i agnt leave r-doc v-ref-rec }
  end.
  if parman = "boss" and paraction = "ret-mouse" then 
  do:
    { str/psn-chk.i boss ret-mouse r-doc v-ref-rec }
  end.
  if parman = "boss" and paraction = "button" then 
  do:
    { str/psn-chk.i boss button r-doc v-ref-rec }
  end.
  if parman = "boss" and paraction = "leave" then 
  do:
    { str/psn-chk.i boss leave r-doc v-ref-rec }
  end.
  if parman = "wrkr" and paraction = "ret-mouse" then 
  do:
    { str/psn-chk.i wrkr ret-mouse r-doc v-ref-rec }
  end.
  if parman = "wrkr" and paraction = "button" then 
  do:
    { str/psn-chk.i wrkr button r-doc v-ref-rec }
  end.
  if parman = "wrkr" and paraction = "leave" then 
  do:
    { str/psn-chk.i wrkr leave r-doc v-ref-rec }
  end.
end procedure.

{ str/plgdsfnd.i parparentproc }


procedure local-chg:
  define buffer buf_goods for ub.goods.
  define variable pl-rvd-dens      as logical   no-undo .
  define variable pl-rvd-lvl       as logical   no-undo .
  define variable pl-rvd-temp      as logical   no-undo .
  define variable pl-level-sr-izm  as integer   no-undo .
  define variable pl-temp-sr-izm   as integer   no-undo .
  define variable v-sug-sr-izm-err as logical   no-undo .
  define variable v-value          as character no-undo .
  define variable v-ok             as logical   no-undo .
  define variable v-log            as logical   no-undo .
  
  assign 
    rvs-line-rec      = recid(ub.rvs-line)
  .
  
  find first buf_goods where buf_goods.gds-code = ub.rvs-line.gds-code no-lock.
  
  run str/test-asi-lin.w
          (input  parparentproc
          ,input  recid(ub.rvs-line)
          ,input  {&update}
          ,input  " # "     + r-doc.rvs-code +
          " товар " + buf_goods.artic     + " " +
          buf_goods.prod-type + " " +
          string(buf_goods.prod-code) +
          " складское место " + string(ub.rvs-line.pl-code)
          ) no-error.
  if error-status :error then 
  do:
    message "Ошибка при редактировании строки проверки корректности работы АСИ в резервуаре." skip
      return-value skip
      error-status:get-message(1)
      view-as alert-box error.
    return error.
  end.

  find r-doc where recid(r-doc) = par_test-asi-rec.
end procedure.

procedure proc_m-meas-3 :
  define buffer meas-place            for ub.place.
  define buffer olddens_rvs-line-attr for ub.rvs-line-attr .
  define variable VErrorFlag as logical no-undo.
  if available ub.rvs-line then 
  do:
    assign 
      rvs-line-rec      = recid(ub.rvs-line)
    .
    find meas-place where meas-place.obj-type = ub.rvs-line.obj-type and
      meas-place.obj-code = ub.rvs-line.obj-code and
      meas-place.pl-code  = ub.rvs-line.pl-code  no-lock.
    if meas-place.is-meas <> yes then 
    do:
      message "Резервуар " meas-place.pl-code " не измеряется приборами. "
        view-as alert-box error.
      return error.
    end.
    if meas-place.loc1 = "" or meas-place.loc1 = ? then 
    do:
      message "Не указан локальный код на складском месте " meas-place.pl-code
        view-as alert-box error.
      return error.
    end.
    for each tt-meas:
      delete tt-meas.
    end.
    create tt-meas.
    assign 
      tt-meas.obj-type = ub.rvs-line.obj-type
      tt-meas.obj-code = ub.rvs-line.obj-code
      tt-meas.pl-code  = ub.rvs-line.pl-code
      tt-meas.loc1     = meas-place.loc1
    .
    run waitfram-show in this-procedure ( input ("Делаем сверку по резервуару " + meas-place.loc1) ).
    disable b-add b-chg b-del b-meas with frame {&frame-name}.
    isMeasurement = yes.
    tr:
    do transaction on error undo tr, retry tr :
      if retry then 
      do:
        VErrorFlag = yes.
        leave tr.
      end.
      find first sys-ctrl no-lock.
      run db-attr-value(sys-ctrl.db,"AsiIp",output v-asi-ip,output v-attr-type).
      run db-attr-value(sys-ctrl.db,"AsiPort",output v-asi-port,output v-attr-type).
      run db-attr-value(sys-ctrl.db,"AsiType",output v-asi-type,output v-attr-type).
      if trim(v-asi-ip) <> ''
        and trim(v-asi-port) <> ''
        and trim(v-asi-type) <> ''
        then 
      do :
        case v-asi-type :
          when "1"
          then 
            do :
              varcur-rvs = 2 .
            end.
          when "2"
          then 
            do :
              varcur-rvs = 3 .
            end.
        end case .
      end.
      else 
      do :
        if ptoldfilvalue = "yes":u then 
        do:
          run gbl/d-askw.w ( input "Выбор источника данных с информацией по резервуарам",
            "Будем читать текущие данные с резервуаров или возьмем данные из файла?",
            "|^",
            "Текущие данные|Из файлов|Отмена",
            "Запускается программа для обращения к датчикам резервуаров|Берутся уже сохраненные данные из файла|Ничего не делаем",
            1,
            3,
            output varnum
            ).
          case varnum:
            when 3 then 
              do:
                undo tr, leave tr.
              end.
            when 2 then 
              do:
                assign
                  varcur-rvs = 0.
              end.
            when 1 then 
              do:
                assign
                  varcur-rvs = 1.
              end.
          end case.
        end.
        else 
        do:
          assign
            varcur-rvs = 1.
        end.
      end.
      { str/rvsplace.i
         r-doc.obj-type
         r-doc.obj-code
         yes
         varcur-rvs
         yes
         no
         tt-meas-file
         tt-meas
         no-error
      }
      if error-status :error then 
      do:
        message "Ошибка при получении данных с приборов на резервуарах." skip
          return-value
          view-as alert-box error.
        undo tr, retry tr.
      end.
      find current ub.rvs-line exclusive-lock.
      { str/fill1plc.i
          ub.rvs-line.obj-type
          ub.rvs-line.obj-code
          ub.rvs-line.pl-code
          "recid( ub.rvs-line )"
          ub.rvs-line.rvs-prev-code
          tt-meas
          no-error
      }
      if error-status :error then 
      do:
        message "Ошибка при заполнении данных с приборов на резервуарах." skip
          return-value
          view-as alert-box error.
        undo tr, retry tr.
      end.
      
/*      run waitfram-show in this-procedure ( input "Пересчитывем шапку" ).*/
/*      { str/rvsclcln.i "recid( ub.rvs-line )" no-error }                 */
/*      if error-status :error then                                        */
/*      do:                                                                */
/*        message "Ошибка при пересчете линии." skip                       */
/*          return-value                                                   */
/*          view-as alert-box error.                                       */
/*        undo tr,  retry tr.                                              */
/*      end.                                                               */
/*      { str/rvsclchd.i "recid( r-doc )"                                  */
/*                   no                      no-error }                    */
/*      if error-status :error then                                        */
/*      do:                                                                */
/*        message "Ошибка при пересчете документа." skip                   */
/*          return-value                                                   */
/*          view-as alert-box error.                                       */
/*        undo tr,  retry tr.                                              */
/*      end.                                                               */
    end. /* transaction */
    run waitfram-hide in this-procedure.
    isMeasurement = no.
    run ui-on in this-procedure.
    if VErrorFlag 
      then 
      return error.
  end.
  else message "Неверно выбрана строка" view-as alert-box error.
end procedure.


procedure proc-lkp:
  define buffer buf_goods for ub.goods.
  if not available ub.rvs-line then 
  do:
    message "Неправильный выбор строки.".
    return error.
  end.
  assign 
    rvs-line-rec      = recid(ub.rvs-line)
  .
  find first buf_goods where buf_goods.gds-code = ub.rvs-line.gds-code no-lock.
  
  run str/test-asi-lin.w
        (input  parparentproc
        ,input  recid(ub.rvs-line)
        ,input  {&lookup}
        ,input  " # "     + r-doc.rvs-code +
        " товар " + buf_goods.artic     + " " +
        buf_goods.prod-type + " " +
        string(buf_goods.prod-code) +
        " складское место " + string(ub.rvs-line.pl-code)
        ) no-error.
  
  if error-status :error then 
  do:
    message "Ошибка при просмотре строки проверки корректности работы АСИ в резервуаре." skip
      return-value skip
      error-status:get-message(1)
      view-as alert-box error.
    return error.
  end.
  find r-doc where recid(r-doc) = par_test-asi-rec.
  run ui-on in this-procedure .
end procedure.

procedure proc_m-meas-1:
  define buffer meas-place for ub.place.
  define buffer bf_r-line  for ub.rvs-line.
  
  define variable VErrorFlag as logical no-undo.
  
  assign 
    rvs-line-rec      = (if available ub.rvs-line      then recid(ub.rvs-line)      else ?)
  .
  for each tt-meas:
    delete tt-meas.
  end.
  if can-find( first bf_r-line where bf_r-line.rvs-code = r-doc.rvs-code ) then 
  do:
    isMeasurement = yes.
    disable b-add b-chg b-del b-meas with frame {&frame-name}.
    run waitfram-show in this-procedure ( input "Делаем сверку по всем резервуарам" ).
    tr:
    do transaction on error undo tr, retry tr :
      if retry then 
      do:
        VErrorFlag = yes.
        leave tr.
      end.
      find first sys-ctrl no-lock.
      run db-attr-value(sys-ctrl.db,"AsiIp",output v-asi-ip,output v-attr-type).
      run db-attr-value(sys-ctrl.db,"AsiPort",output v-asi-port,output v-attr-type).
      run db-attr-value(sys-ctrl.db,"AsiType",output v-asi-type,output v-attr-type).
      if trim(v-asi-ip) <> ''
        and trim(v-asi-port) <> ''
        and trim(v-asi-type) <> ''
        then 
      do :
        case v-asi-type :
          when "1"
          then 
            do :
              varcur-rvs = 2 .
            end.
          when "2"
          then 
            do :
              varcur-rvs = 3 .
            end.
        end case .
      end.
      else 
      do :
        if ptoldfilvalue = "yes":u then 
        do:
          run gbl/d-askw.w ( input "Выбор источника данных с информацией по резервуарам",
            "Будем читать текущие данные с резервуаров или возьмем данные из файла?",
            "|^",
            "Текущие данные|Из файлов|Отмена",
            "Запускается программа для обращения к датчикам резервуаров|Берутся уже сохраненные данные из файла|Ничего не делаем",
            1,
            3,
            output varnum
            ).
          case varnum:
            when 3 then 
              do:
                undo tr, leave tr.
              end.
            when 2 then 
              do:
                assign
                  varcur-rvs = 0.
              end.
            when 1 then 
              do:
                assign
                  varcur-rvs = 1.
              end.
          end case.
        end.
        else 
        do:
          assign
            varcur-rvs = 1.
        end.
      end.
      
      for each bf_r-line no-lock where
               bf_r-line.rvs-code = r-doc.rvs-code,
         first meas-place no-lock where 
               meas-place.obj-type = bf_r-line.obj-type and
               meas-place.obj-code = bf_r-line.obj-code and
               meas-place.pl-code  = bf_r-line.pl-code
        :    
        create tt-meas.
        assign 
          tt-meas.obj-type = bf_r-line.obj-type
          tt-meas.obj-code = bf_r-line.obj-code
          tt-meas.pl-code  = bf_r-line.pl-code
          tt-meas.loc1     = meas-place.loc1    
        .
        { str/rvsplace.i
           r-doc.obj-type
           r-doc.obj-code
           yes
           varcur-rvs
           yes
           no
           tt-meas-file
           tt-meas
           no-error
        }
        if error-status :error then 
        do:
          message "Ошибка при получении данных с приборов на резервуарах." skip
            return-value
            view-as alert-box error.
          undo tr, retry tr.
        end.
        find first ub.rvs-line where recid(ub.rvs-line) = recid(bf_r-line) exclusive-lock.
        { str/fill1plc.i
            ub.rvs-line.obj-type
            ub.rvs-line.obj-code
            ub.rvs-line.pl-code
            "recid( ub.rvs-line )"
            ub.rvs-line.rvs-prev-code
            tt-meas
            no-error
        }
        if error-status :error then 
        do:
          message "Ошибка при заполнении данных с приборов на резервуарах." skip
            return-value
            view-as alert-box error.
          undo tr, retry tr.
        end.
        
        find first tt-meas exclusive-lock no-error.
        delete tt-meas.
      end.

/*      run waitfram-show in this-procedure ( input "Пересчитывем шапку" ).*/
/*      { str/rvsclchd.i "recid( r-doc )"                                  */
/*                   no                       no-error }                   */
/*      if error-status :error then                                        */
/*      do:                                                                */
/*        message "Ошибка при пересчете документа." skip                   */
/*          return-value                                                   */
/*          view-as alert-box error.                                       */
/*        undo tr, retry tr.                                               */
/*      end.                                                               */
    end. /* transaction */
    isMeasurement = no.
  end.
  else 
  do: 
    message "Нет ни одного измеряемого резервуара." view-as alert-box. 
  end.
  run waitfram-hide in this-procedure.
  run ui-on in this-procedure .
  if VErrorFlag
    then
    return error.
end procedure.


