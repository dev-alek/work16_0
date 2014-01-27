/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Акт приема и недовоза нефтепродуктов

Автор: Сливенко Сергей Андреевич
Дата создания: 10/14/11
Author: Sergey Slivenko
Creation date: 10/14/11

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Акт приема и недовоза нефтепродуктов".
{ cmp/vssrevis.i }

define input parameter p-mainmenu-handle    as handle           no-undo.
define input parameter rec_id               as recid            no-undo.

define stream out-stream.


    { cmp/str-glbl.i }
    { cmp/library.i  }
    { cmp/r-pril.i   }
    { str/lib-trn.i  }
    { str/trdcalib.i }
    { rep/w-rep.i    }
    { rep/fmtcli.i   }
    { rep/torgconf.i }
    { str/getctxtp.i def }
    { gbl/paramls.i  }
define variable g#report-num    as integer      no-undo .
define variable g#quest-print   as logical      no-undo .
define variable g#log           as logical      no-undo .
{ rep/apn-xl.i  }

define variable is-petrolium as logical no-undo.
define variable is-pieces as logical no-undo.
define variable v-attr-value as character no-undo .
define variable v-attr-type  as character no-undo .
define variable v-nakl   as character no-undo .
define variable v-date   as character no-undo .
define variable v-t-start   as character no-undo .
define variable v-t-end   as character no-undo .


define variable v-doc-code         like ub.trn-doc.doc-code   no-undo .
define variable v-gds-code         like ub.goods.gds-code     no-undo .
define variable v-car-num          as   character             no-undo .
define variable v-car-vol          as   character             no-undo .
define variable v-tests            as   character             no-undo .
define variable v-autoent-obj-type as   character             no-undo .
define variable v-autoent-obj-code as   character             no-undo .
define variable v-item-pour        as   character             no-undo .
define variable v-time-pour        as   character             no-undo .
define variable v-tank-vol         as   character             no-undo .
define variable v-tank-temp        as   character             no-undo .
define variable v-tank-water       as   character             no-undo .
define variable v-tank-density     as   character             no-undo .
define variable v-tank-weight      as   character             no-undo .
define variable v-time-income      as   character             no-undo .
define variable v-date-start       like ub.rvs-line.real-date no-undo .
define variable v-time-start       like ub.rvs-line.real-time no-undo .
define variable v-date-end         like ub.rvs-line.real-date no-undo .
define variable v-time-end         like ub.rvs-line.real-time no-undo .
define variable v-mouth            as   character             no-undo .
define variable v-fio              as   character             no-undo .
define variable v-ptbotype         as   character             no-undo .
define variable v-ptbocode         as   character             no-undo .
define variable v-a-b-tarir        as   character             no-undo .

    define buffer buf_trn-doc       for ub.trn-doc.
    define buffer buf_doc-line      for ub.doc-line.
    define buffer buf_doc-line-attr for ub.doc-line-attr.
    define buffer buf_goods         for ub.goods.


do

:
    { gbl/working.i }

    { str/getctxtp.i get p-mainmenu-handle }

    run get-report-num in p-mainmenu-handle (
        output g#report-num
    ).

    run get-quest-print in p-mainmenu-handle (
        output g#quest-print
    ).


    find first buf_trn-doc no-lock
         where recid( buf_trn-doc ) = rec_id.

    { str/tdat-val.i buf_trn-doc.doc-code {&trdcattr-nids} v-attr-value v-attr-type }
    if v-attr-value > "" then do :
      assign v-nakl = v-attr-value .
    end .
    else do :
      assign v-nakl = buf_trn-doc.doc-code .
    end.

    for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code break by buf_doc-line.doc-code :
    { str/is-petrl.i
      buf_doc-line.artic
      buf_doc-line.prod-type
      buf_doc-line.prod-code
      is-petrolium
      is-pieces
      no-error
      }
      if error-status :error
      then do:
        return error return-value .
      end.
    if is-petrolium then do
    :


        { cmp/open-out.i stream out-stream " " {&LS_PS_A4} }
        run apn-xl-init in this-procedure .
        put stream out-stream unformatted
            {&new-line}
          + "Печатная форма предназначена только для вывода в Microsoft Excel."
          + {&new-line}
        .
        output stream out-stream close.

        find first buf_goods where buf_goods.artic     = buf_doc-line.artic
                               and buf_goods.prod-code = buf_doc-line.prod-code
                               and buf_goods.prod-type = buf_doc-line.prod-type no-lock no-error.
        assign
            v-doc-code = buf_doc-line.doc-code
            v-gds-code = buf_goods.gds-code
        .

        find first clients where clients.obj-code = buf_trn-doc.boss and
                                 clients.obj-type = {&prs} no-lock no-error.
        find first person where person.psn-code = buf_trn-doc.boss no-lock no-error.

        run loc-get-set-attr in this-procedure
          ( input "get-attr":U
          ) no-error .

        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-object}
            , input buf_trn-doc.obj-code
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-dr_name}
            , input v-fio
        ).
        if available clients then
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-mngr_name}
            , input string(clients.obj-name + ' ' + person.name1 + ' ' + person.name2)
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-gds-name}
            , input buf_goods.gds-name
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-doc-code}
            , input v-nakl
        ).
        { str/tdat-val.i buf_trn-doc.doc-code {&trdcattr-dids} v-attr-value v-attr-type }
        if v-attr-value > "" then v-date = v-attr-value.
        else do :
              if integer(substring(string(date(buf_trn-doc.doc-date), "99/99/9999") , 1, 2)) > 12
                then v-date = string(date(buf_trn-doc.doc-date), "99/99/9999").
                else v-date = substring(string(date(buf_trn-doc.doc-date), "99/99/9999") , 4, 3)
                            + substring(string(date(buf_trn-doc.doc-date), "99/99/9999") , 1, 3)
                            + substring(string(date(buf_trn-doc.doc-date), "99/99/9999") , 7, 4).
        end.
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-doc-date}
            , input v-date
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-cli-name}
            , input buf_trn-doc.cli-name
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-car-num}
            , input v-car-num
        ).
        if v-date-start <> ? then
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-date-start}
            , input v-date-start
        ).

        define variable v-hours   as integer no-undo.
        define variable v-minutes as integer no-undo.
        if v-time-start <> ? or v-time-start <> 0 then do :
           v-minutes = (v-time-start MODULO 3600) / 60.
           v-hours   = TRUNCATE (v-time-start / 3600, 0).
           v-t-start = string(v-hours) + ":" + string(v-minutes).
           run apn-xl-write-cell-data in this-procedure (
                input {&apn-xl-time-start}
              , input v-t-start
           ).
        end.
        if v-time-end <> ? or v-time-end <> 0 then do :
           v-minutes = (v-time-end MODULO 3600) / 60.
           v-hours   = TRUNCATE (v-time-end / 3600, 0).
           v-t-end   = string(v-hours) + ":" + string(v-minutes).
           run apn-xl-write-cell-data in this-procedure (
                input {&apn-xl-time-end}
              , input v-t-end
           ).
        end.
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-doc-qnty}
            , input buf_doc-line.doc-qnty
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-tank-vol}
            , input v-tank-vol
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-doc-density}
            , input buf_doc-line.doc-density
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-tank-density}
            , input v-tank-density
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-temperature}
            , input buf_doc-line.temperature
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-tank-temp}
            , input v-tank-temp
        ).
        run apn-xl-write-cell-data in this-procedure (
              input {&apn-xl-cli-qnty}
            , input buf_doc-line.cli-qnty
        ).

        run apn-xl-close in this-procedure .

    end.    /*      if is-petrolium        */
    end.    /*        for each buf_doc-line     */
       { rep/q-print.i 4 }
       { gbl/stopwork.i }

end.



PROCEDURE loc-get-set-attr :

  define input  parameter p-mode-attr as character no-undo .

  &scop loc-find-attr ~
  find first buf_doc-line-attr ~
    where buf_doc-line-attr.doc-code  = v-doc-code ~
      and buf_doc-line-attr.gds-code  = v-gds-code ~
      and buf_doc-line-attr.attr-code = "~{&attr-name~}" ~
    no-error.

  &scop loc-get-attr ~
    if available buf_doc-line-attr then do: ~
      assign ~
        v-~{&attr-name~} = buf_doc-line-attr.attr-value ~
      . ~
    end.
  &scop loc-get-attr-int ~
    if available buf_doc-line-attr then do: ~
      assign ~
        v-~{&attr-name~} = integer( buf_doc-line-attr.attr-value ) ~
      . ~
    end.
  &scop loc-get-attr-date ~
    if available buf_doc-line-attr then do: ~
      assign ~
        v-~{&attr-name~} = date( buf_doc-line-attr.attr-value ) ~
      . ~
    end.
  &scop loc-create-attr ~
    if not available buf_doc-line-attr then do: ~
      create buf_doc-line-attr . ~
      assign ~
        buf_doc-line-attr.doc-code  = v-doc-code ~
        buf_doc-line-attr.gds-code  = v-gds-code ~
        buf_doc-line-attr.attr-code = "~{&attr-name~}":U ~
      . ~
    end.

  &scop loc-set-attr ~
    assign ~
      buf_doc-line-attr.attr-value = substitute( "&1", v-~{&attr-name~} ) ~
    .
  &scop loc-set-attr-date ~
    assign ~
      buf_doc-line-attr.attr-value = string( v-~{&attr-name~}, "99/99/9999" )~
    .

  do
  on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo, return error substitute( "&1. stop", vss-workfile )
  on endkey undo, return error substitute( "&1. endkey", vss-workfile )
  :
    define buffer buf_doc-line-attr for ub.doc-line-attr .

    &scop attr-name car-num
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.


    &scop attr-name car-vol
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tests
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name autoent-obj-type
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name autoent-obj-code
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name item-pour
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name time-pour
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name time-income
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name date-start
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-date}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr-date}
    end.

    &scop attr-name time-start
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-int}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name date-end
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-date}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr-date}
    end.

    &scop attr-name time-end
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr-int}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-vol
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-temp
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-water
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-density
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name tank-weight
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name mouth
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name fio
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name ptbotype
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name ptbocode
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    &scop attr-name a-b-tarir
    {&loc-find-attr}
    if p-mode-attr = "get-attr":U then do:
      {&loc-get-attr}
    end.
    else do:
      {&loc-create-attr}
      {&loc-set-attr}
    end.

    return .

  end.
END PROCEDURE.