/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Оборот по по чекам

Автор: Белоусов Илья Александрович
Дата создания: 01/31/08
Author: Ilia Belousov
Creation date: 01/31/08

Input:

Output:

*/
define input parameter p-rvs-code as character        no-undo.
define input parameter p-obj-type as character        no-undo.
define input parameter p-obj-code as integer          no-undo.
define output parameter p-ok      as logical          no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Оборот по по чекам".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }

define temp-table tt-rvs-line-attr no-undo
  field gds-code    like ub.goods.gds-code
  field pl-code     like ub.place.pl-code
  field artic       like ub.goods.artic
  field prod-type   like ub.goods.prod-type
  field prod-code   like ub.goods.prod-code
  field attr-value  as decimal
  field rest        as decimal initial 0.0
  field oo          as decimal initial 0.0
  index pi is primary unique gds-code pl-code
.

define buffer buf_tt-rvs-line-attr  for tt-rvs-line-attr .
define buffer buf_place             for ub.place .
define buffer buf_pl-gds            for ub.pl-gds .
define buffer buf_inkas             for ub.inkas .
define buffer buf_doc-pl            for ub.doc-pl .
define buffer buf_trn-doc           for ub.trn-doc .
define buffer buf_goods             for ub.goods .
define buffer buf_doc-line          for ub.doc-line .
define buffer buf_rvs-line-attr     for ub.rvs-line-attr .
define buffer curr_shift-obj        for ub.shift-obj .
define buffer prev_shift-obj        for ub.shift-obj .
define buffer buf_rvs-doc           for ub.rvs-doc .
define buffer buf_rvs-line          for ub.rvs-line .

define variable v-sign            as decimal   no-undo .

do
on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
:
   /* собираем резервуарные товары */
  for each buf_place no-lock
    where buf_place.obj-type = p-obj-type
      and buf_place.obj-code = p-obj-code
    ,first buf_pl-gds no-lock
    where buf_pl-gds.obj-type = p-obj-type
      and buf_pl-gds.obj-code = p-obj-code
      and buf_pl-gds.pl-code  = buf_place.pl-code
  on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :

    find first buf_tt-rvs-line-attr
      where buf_tt-rvs-line-attr.gds-code = buf_pl-gds.gds-code
        and buf_tt-rvs-line-attr.pl-code  = buf_pl-gds.pl-code
      no-error .
    if not available buf_tt-rvs-line-attr then do:
      find first buf_goods no-lock
        where buf_goods.gds-code = buf_pl-gds.gds-code
        no-error.
      if available buf_goods then do:
        create buf_tt-rvs-line-attr.
        assign
          buf_tt-rvs-line-attr.gds-code    = buf_pl-gds.gds-code
          buf_tt-rvs-line-attr.pl-code     = buf_pl-gds.pl-code
          buf_tt-rvs-line-attr.artic       = buf_goods.artic
          buf_tt-rvs-line-attr.prod-type   = buf_goods.prod-type
          buf_tt-rvs-line-attr.prod-code   = buf_goods.prod-code
        .
      end.
    end.
  end.

  /* находим текущую смену */
  find first curr_shift-obj no-lock
    where curr_shift-obj.obj-type = p-obj-type
      and curr_shift-obj.obj-code = p-obj-code
      and curr_shift-obj.status_  = {&sht-current}
    no-error .
  if not available curr_shift-obj then do:
    undo, return error substitute( "&1. Не найдена текущая смена.", vss-workfile ).
  end.

  /* находим предыдущую смену */
  find last prev_shift-obj no-lock
    where prev_shift-obj.obj-type = p-obj-type
      and prev_shift-obj.obj-code = p-obj-code
      and ( ( prev_shift-obj.shift-date = curr_shift-obj.shift-date
              and prev_shift-obj.shift-num < curr_shift-obj.shift-num
            )
            or prev_shift-obj.shift-date < curr_shift-obj.shift-date
          )
    use-index pi
    no-error .
  if available prev_shift-obj then do:
    /* остатки в резервуарах на начало смены */
    find first buf_rvs-doc no-lock
      where buf_rvs-doc.obj-type   = p-obj-type
        and buf_rvs-doc.obj-code   = p-obj-code
        and buf_rvs-doc.shift-date = prev_shift-obj.shift-date
        and buf_rvs-doc.shift-num  = prev_shift-obj.shift-num
        and buf_rvs-doc.status_    = {&fact}
        and buf_rvs-doc.rvs-type   = {&rvs-shift}
      no-error .
    if available buf_rvs-doc then do:
      for each buf_rvs-line no-lock
        where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
        ,first buf_tt-rvs-line-attr
        where buf_tt-rvs-line-attr.gds-code = buf_rvs-line.gds-code
          and buf_tt-rvs-line-attr.pl-code  = buf_rvs-line.pl-code
      on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
      :
        assign
          buf_tt-rvs-line-attr.rest = buf_tt-rvs-line-attr.rest + buf_rvs-line.state-measure-qnty
        .
      end.
    end.
  end.


  /* все незакрытые продажи текущей смены */
  for each buf_inkas no-lock
    where buf_inkas.obj-type   = p-obj-type
      and buf_inkas.obj-code   = p-obj-code
      and buf_inkas.status_    = {&g___new}
      and buf_inkas.shift-date = curr_shift-obj.shift-date
      and buf_inkas.shift-num  = curr_shift-obj.shift-num
  on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    for each buf_trn-doc no-lock
      where buf_trn-doc.doc-code = buf_inkas.inkas-code
        and buf_trn-doc.ext-doc-type = {&tdedt_ras_vnesh_kass}
      ,each buf_tt-rvs-line-attr no-lock
      ,each buf_doc-pl no-lock
      where buf_doc-pl.out-code = buf_trn-doc.doc-code
        and buf_doc-pl.gds-code = buf_tt-rvs-line-attr.gds-code
        and buf_doc-pl.pl-code  = buf_tt-rvs-line-attr.pl-code
    on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
    :
      assign
        buf_tt-rvs-line-attr.rest = buf_tt-rvs-line-attr.rest - buf_doc-pl.fact-qnty
        buf_tt-rvs-line-attr.oo   = buf_tt-rvs-line-attr.oo   - buf_doc-pl.fact-qnty
      .
    end.

    for each buf_trn-doc no-lock
      where buf_trn-doc.out-code = buf_inkas.inkas-code
        and buf_trn-doc.ext-doc-type = {&tdedt_vozvrat_vnesh_kass}
      ,each buf_tt-rvs-line-attr no-lock
      ,each buf_doc-pl no-lock
      where buf_doc-pl.out-code = buf_trn-doc.doc-code
        and buf_doc-pl.gds-code = buf_tt-rvs-line-attr.gds-code
        and buf_doc-pl.pl-code  = buf_tt-rvs-line-attr.pl-code
    on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
    :
      assign
        buf_tt-rvs-line-attr.rest = buf_tt-rvs-line-attr.rest + buf_doc-pl.fact-qnty
        buf_tt-rvs-line-attr.oo   = buf_tt-rvs-line-attr.oo   + buf_doc-pl.fact-qnty
      .
    end.

  end. /* each buf_inkas */

  /* все закрытые документы текущей смены */
  for each buf_trn-doc no-lock
    where buf_trn-doc.obj-type   = p-obj-type
      and buf_trn-doc.obj-code   = p-obj-code
      and buf_trn-doc.status_    = {&fact}
      and buf_trn-doc.shift-date = curr_shift-obj.shift-date
      and buf_trn-doc.shift-num  = curr_shift-obj.shift-num
  on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    for each buf_tt-rvs-line-attr no-lock
      ,each buf_doc-pl no-lock
      where buf_doc-pl.out-code = buf_trn-doc.doc-code
        and buf_doc-pl.gds-code = buf_tt-rvs-line-attr.gds-code
        and buf_doc-pl.pl-code  = buf_tt-rvs-line-attr.pl-code
    on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
    :
      if lookup( buf_trn-doc.ext-doc-type, {&TDEDT_out_list} ) > 0 then do:
        assign
          v-sign = -1.0
        .
      end.
      else do:
        /* оставляем все как есть */
        assign
          v-sign = 1.0
        .
        if lookup( buf_trn-doc.ext-doc-type, {&TDEDT_in_list} ) = 0 then do:
          undo, return error substitute( '&1. Тип "&2" не внесен в списки документов уменьшающих(увеличивающих) остатки!', vss-workfile, buf_trn-doc.ext-doc-type).
        end.
      end.

      assign
        buf_tt-rvs-line-attr.rest = buf_tt-rvs-line-attr.rest + buf_doc-pl.fact-qnty * v-sign
        buf_tt-rvs-line-attr.oo   = buf_tt-rvs-line-attr.oo   + buf_doc-pl.fact-qnty * v-sign
      .
    end.
  end. /*for each trn-doc*/

  /* Формируем атрибуты строк */
  do transaction
  on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    for each buf_tt-rvs-line-attr
    on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
    :
      find first buf_rvs-line-attr exclusive-lock
        where buf_rvs-line-attr.rvs-code  = p-rvs-code
          and buf_rvs-line-attr.gds-code  = buf_tt-rvs-line-attr.gds-code
          and buf_rvs-line-attr.attr-code = substitute("rvs-&1", buf_tt-rvs-line-attr.pl-code)
        no-error .
      if not available buf_rvs-line-attr then do:
        create buf_rvs-line-attr .
        assign
          buf_rvs-line-attr.rvs-code = p-rvs-code
          buf_rvs-line-attr.gds-code = buf_tt-rvs-line-attr.gds-code
          buf_rvs-line-attr.attr-code = substitute("rvs-&1", buf_tt-rvs-line-attr.pl-code)
        .
      end.
      assign
        buf_rvs-line-attr.attr-value = substitute ( "&1&2&3", buf_tt-rvs-line-attr.rest, {&delim-par}, buf_tt-rvs-line-attr.oo )
      .
    end.
  end.     /* do transaction */

  /* уборка мусора */
  empty temp-table  buf_tt-rvs-line-attr.
  assign
    p-ok = true
  .
  return .
end.