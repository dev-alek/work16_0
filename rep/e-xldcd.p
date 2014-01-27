/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Заполнение полей временной таблицы для отчета по постоянным клиентам

Автор: Бахтадзе Наталья Викторовна
Дата создания: 10/18/05
Author: Bakhtadze Natalya
Creation date: 10/18/05

*/

/*вызвается с тремя параметрами компиляции - WHERE-Phrase для chk-doc.d-card и
where-phrase для dis-card
where-phrase для chk-gds.b-code -> bar--code*/
DEFINE INPUT PARAMETER DcardMode as char no-undo.
/*может быть ALL, ONE, LIST*/
DEFINE INPUT PARAMETER FixDCard as char no-undo.
DEFINE INPUT PARAMETER ProdMode as integer no-undo.
/*может быть {g-all} {&g-prod} {&g-grp}*/
DEFINE INPUT PARAMETER FixProdAttr as char no-undo.
DEFINE INPUT PARAMETER TotalOnly as logical no-undo.
DEFINE INPUT PARAMETER StartPoint as date no-undo.
DEFINE INPUT PARAMETER EndPoint as date no-undo.
DEFINE INPUT PARAMETER T-time as logical no-undo.
define input parameter T-zeros as logical no-undo .
define input parameter t-legacy  as logical no-undo .
define input parameter t-subsid  as logical no-undo .
define input parameter p-prodmode2 as character no-undo .
define input parameter t-imp as logical no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Заполнение полей временной таблицы для отчета по постоянным клиентам".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i  }
{ cmp/library.i }
{ cmp/r-page1.i  " " cmp }
{ cmp/dc-list.i dc-list def "shared " }
{ gbl/waitfram.i }
{ ref/grplibfn.i }

define variable new-doc  as logical no-undo.
define variable Prodtype as character no-undo.
define variable prodCode as integer no-undo.
define variable v-grp-code like ub.gds-grp.node-code no-undo .
define variable v-gds-code like ub.goods.gds-code no-undo .
define variable v-grp-name like ub.goods.grp-name no-undo .
define variable v-card-num-chr as character no-undo .
define variable ii-grp as integer no-undo .
define variable v-found as logical no-undo .
define variable v-count as integer   no-undo .

{ rep/e-xldcd.i "SHARED" }

define temp-table obj-host no-undo
FIELd host-code like ub.sysconf.host-code
index pi is primary unique host-code.

define buffer buf_shop for ub.shop.
define buffer buf_store for ub.store.
define buffer buf_dis-card for ub.dis-card.
define buffer buf_dcards for dcards.
define buffer X_dis-card for ub.dis-card.
define buffer buf_chk-doc for ub.chk-doc.
define buffer buf_CHK-GDS for ub.chk-gds.
define buffer buf_bar-code for ub.bar-code.
define buffer buf_goods for ub.goods.
define buffer buf_payment for ub.payment.
define buffer buf_payment-attr for ub.payment-attr.

if p-prodmode2 = "ONE" then do:
  if prodmode = {&g-prod} then do:
    assign
    ProdType = Substr(FixProdAttr, 1, 3)
    ProdCode = integer(substr(FixProdAttr, 4))
    .
  end.
  if prodmode = {&g-grp} then do:
    assign
    v-grp-code = integer(FixProdAttr)
    .
    run grplib-get-full-name  in this-procedure (
                                                input v-grp-code
                                                ,output v-grp-name).

  end.
  if prodmode = {&g-one} then do:
    assign
    v-gds-code = integer(FixProdAttr)
    .
  end.
end. /*if p-prodmode2 = "ONE" then do:*/

for each obj-host:
  DELETE obj-host.
end.

create obj-host.
assign
obj-host.host-code = 0
. /*для глобальных карт*/


FOR EACH obj-list :
  /*найдем по каким фирмам мы елозим это зависит от переключателя X_selectobject*/

  if obj-list.obj-type = {&shop} then do:
    find first buf_shop no-lock where
              buf_shop.obj-code = obj-list.obj-code.
    find first obj-host no-lock where
                obj-host.host-code = buf_shop.host-code no-error .
    if not available obj-host then do:
      create
      obj-host.
      assign
      obj-host.host-code = buf_shop.host-code
      .
    end.
  end.
  else do:
    find first buf_store no-lock where
              buf_store.obj-code = obj-list.obj-code.
    find first obj-host no-lock where
                obj-host.host-code = buf_store.host-code no-error .
    if not available obj-host then do:
      create
      obj-host.
      assign
      obj-host.host-code = buf_store.host-code
      .
    end.
  end.
  if can-find( FIRST ub.chk-doc WHERE
                      ub.chk-doc.obj-type = obj-list.obj-type AND
                      ub.chk-doc.obj-code = obj-list.obj-code AND
                      ub.chk-doc.chk-date >= StartPoint AND
                      ub.chk-doc.chk-date <= EndPoint AND
                      ub.chk-doc.d-card <> "" AND
                      ub.chk-doc.out-code <> ? ) then DO:
    _chk-doc:
    FOR EACH buf_chk-doc NO-LOCK WHERE
            buf_chk-doc.obj-type = obj-list.obj-type
        AND buf_chk-doc.obj-code = obj-list.obj-code
        AND buf_chk-doc.chk-date >= StartPoint
        AND buf_chk-doc.chk-date <= EndPoint
        AND buf_chk-doc.out-code <> ?
        and buf_chk-doc.d-card > '':U:
      if LOOKUP(string(buf_chk-doc.chk-type), {&no-d-card-receipt-codes}) > 0 then next _CHk-doc.
        if (dcardmode = "ONE" or dcardmode = "LIST")
        and (t-legacy or t-subsid) then do:
            /**/
        end.
        else do:
          if dcardmode = "ONE" then do:
            if not  buf_chk-doc.d-card = FixDCard then next _chk-doc.
          end.

          if dcardmode = "list" then do:
            find first dc-list WHERE
                        dc-list.d-card = buf_chk-doc.d-card no-error.
            if not available dc-list then next _chk-doc.
          end.
        end.
        PROCESS EVENTS .
        v-count = v-count + 1.
        if ( v-count  modulo 10 ) = 0
        AND  v-count >= 10 then do:
          run waitfram-show in this-procedure  ( input substitute("&1&2 обработано чеков &3"
                                                                ,obj-list.obj-type
                                                                ,obj-list.obj-code
                                                                ,v-count)
                                              ).

        end.
        new-doc = yes.
        IF T-time and NOT can-find(FIRST times where
                                            times.time1  <= buf_chk-doc.chk-time AND
                                            times.time2 >= buf_chk-doc.chk-time) then do:
          NEXT _chk-doc.

        end.
        IF TotalOnly
        AND PRODMODE = {&g-all} then do:
          FIND FIRST dcards WHERE dcards.d-card = buf_chk-doc.d-card NO-ERROR .
          if NOT available dcards then  do:
            CREATE dcards .
            assign
            dcards.date_  = buf_chk-doc.chk-date
            dcards.d-card = buf_chk-doc.d-card
            dcards.artic = ""
            dcards.b-code =  0
            dcards.prod-type = ""
            dcards.prod-code = 0
            dcards.qnty = 0
            dcards.node-code = 0
            .
            if t-legacy or t-subsid then do:
              find first buf_dis-card no-lock where
                          buf_dis-card.d-card = buf_chk-doc.d-card no-error .
              if available buf_dis-card then do:
                assign
                v-card-num-chr = (if t-legacy and t-subsid
                                  then buf_dis-card.first-main-card
                                  else (if t-legacy and not t-subsid
                                        then  buf_dis-card.first-card
                                        else  buf_dis-card.main-card
                                        )
                                  ).
                assign
                dcards.cli-type-code   = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
                dcards.card-num        = buf_dis-card.card-num
                dcards.d-card          = buf_dis-card.d-card
                dcards.card-num-chr    = v-card-num-chr
                dcards.main-card       = buf_dis-card.main-card
                dcards.first-card      = buf_dis-card.first-card
                dcards.first-main-card = buf_dis-card.first-main-card
                .
              end.
            end. /*if t-legacy or t-subsid then do:*/
            else do:
              if buf_chk-doc.cli-type = ?
              or buf_chk-doc.cli-code = ?
              or buf_chk-doc.cli-type = '':U
              or buf_chk-doc.cli-code = 0 then do:
                find first buf_dis-card no-lock where
                          buf_dis-card.d-card = buf_chk-doc.d-card no-error .
                if available buf_dis-card then do:
                  assign
                  dcards.cli-type-code = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
                  .
                end.
              end.
              else do:
                assign
                dcards.cli-type-code = buf_chk-doc.cli-type + string(buf_chk-doc.cli-code)
                .
              end.
            end. /*bot legacy*/
          end. /*IF NOT AVAIL dcards*/
          assign
          dcards.qnty = 0
          dcards.sale-price = 0
          dcards.discount = dcards.discount + buf_chk-doc.discnt
          dcards.sum = dcards.sum + buf_chk-doc.tot-doc
          dcards.counter = (if new-doc then dcards.counter + 1 else dcards.counter ) .
          new-doc = no.
        end. /*IF TOTALONLY*/
        else do:
          _chk:
          FOR EACH buf_chk-gds WHERE buf_chk-gds.doc-code = buf_chk-doc.doc-code,
              FIRST buf_bar-code No-LOCK WHERE
                    buf_bar-code.b-code = buf_chk-gds.b-code,
              FIRST buf_goods No-LOCK WHERE
                      buf_goods.gds-code = buf_bar-code.gds-code:
            if p-prodmode2 = "ONE" then do:
              case prodmode:
                when {&g-prod} then do:
                  if not ( buf_goods.prod-type = ProdType
                        AND buf_goods.prod-code = ProdCode) then next _chk.
                end.
                when {&g-all} then do:
                end.
                when {&g-grp} then do:
                  if not buf_goods.grp-name begins v-grp-name then next _chk.
                end.
                when {&g-one} then do:
                  if not buf_goods.gds-code = v-gds-code then next _chk.
                end.
              end case.
            end.

            /*списание по расходу не попадает - списание по возврату попадает*/
            if buf_chk-gds.write-off-code <> ?
            and buf_chk-gds.write-off-code > 0 then NEXT _CHk.
            if p-prodmode2 = "LIST" then do:
              if prodmode = {&g-prod} then do:
                IF NOT can-find(first g#cli No-LOCK where
                                      g#cli.obj-type = buf_goods.prod-type AND
                                      g#cli.obj-code = buf_goods.prod-code) then NEXT _chk.
              end.
              if prodmode = {&g-grp} then do:
                assign
                v-grp-name = ""
                v-found = no
                .
                _ii-grp:
                do ii-grp = 1 to num-entries(buf_goods.grp-name, {&delim-grp}) - 1:
                  assign
                  v-grp-name = v-grp-name + entry(ii-grp, buf_goods.grp-name, {&delim-grp}) + {&delim-grp}.
                  /*message "ii-grp" ii-grp v-grp-name view-as alert-box .*/
                  IF can-find(first tmp#grp No-LOCK where
                                    tmp#grp.grp-name = v-grp-name) then do:
                    assign
                    v-found = yes
                    .
                    leave _ii-grp.
                  end.
                end.
                if not v-found then do:
                  next _chk.
                end.
              end. /*if prodmode = {&g-grp} then do:*/
              if prodmode = {&g-choice} then do:
                IF NOT can-find(first gds-list No-LOCK where
                                    gds-list.gds-code = buf_goods.gds-code) then NEXT _chk.
                end.
              end. /*if p-prodmode2 = "LIST" then do:*/
              FIND FIRST dcards WHERE
                        dcards.date_ = buf_chk-doc.chk-date
                    AND dcards.d-card = buf_chk-doc.d-card
                    AND dcards.b-code = buf_bar-code.b-code
                    AND dcards.sale-price = buf_chk-gds.price-base  NO-ERROR .
              if NOT available dcards then do:
                CREATE dcards .
                assign
                dcards.date_  = buf_chk-doc.chk-date
                dcards.d-card = buf_chk-doc.d-card
                dcards.artic = buf_goods.artic
                dcards.b-code = buf_bar-code.b-code
                dcards.prod-type = buf_goods.prod-type
                dcards.prod-code = buf_goods.prod-code
                dcards.qnty = 0
                dcards.node-code = buf_bar-code.node-code
                .
                if t-legacy or t-subsid then do:
                  find first buf_dis-card no-lock where
                              buf_dis-card.d-card = buf_chk-doc.d-card no-error .
                  assign
                  v-card-num-chr = (if t-legacy and t-subsid
                                    then buf_dis-card.first-main-card
                                    else (if t-legacy and not t-subsid
                                          then  buf_dis-card.first-card
                                          else  buf_dis-card.main-card
                                          )
                                    ).
                  assign
                  dcards.d-card          = buf_dis-card.d-card
                  dcards.card-num-chr    = v-card-num-chr
                  dcards.first-card      = buf_dis-card.first-card
                  dcards.main-card       = buf_dis-card.main-card
                  dcards.first-main-card = buf_dis-card.first-main-card
                  dcards.cli-type-code   = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
                  dcards.card-num        = buf_dis-card.card-num
                  .
                end.
                else do:
                  if buf_chk-doc.cli-type = ?
                  or buf_chk-doc.cli-code = ?
                  or buf_chk-doc.cli-type = '':U
                  or buf_chk-doc.cli-code = 0 then do:
                    find first buf_dis-card no-lock where
                              buf_dis-card.d-card = buf_chk-doc.d-card no-error .
                    if available buf_dis-card then do:
                      assign
                      dcards.cli-type-code = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
                      .
                    end.
                  end.
                  else do:
                    assign
                    dcards.cli-type-code = buf_chk-doc.cli-type + string(buf_chk-doc.cli-code)
                    .
                  end.
                end. /*not legacy*/
              end.
              assign
              dcards.qnty = dcards.qnty + buf_chk-gds.doc-qnty
              dcards.sale-price = buf_chk-gds.price-base
              dcards.discount = dcards.discount + ( buf_chk-gds.doc-qnty *
                      ( buf_chk-gds.discnt + ( dcards.sale-price - buf_chk-gds.price-base ) ) )
              dcards.sum = dcards.sum + ( buf_chk-gds.doc-qnty * dcards.sale-price )
              dcards.counter = (if new-doc then dcards.counter + 1 else dcards.counter ) .
              new-doc = no.
          end.
        END.
      END.    /* FOR EACH buf_chk-doc WHERE ... */
/*
   При необходимости учета по покупкам постоянных оптовиков -
   добавить кусок, аналогичный тому, что есть в   x l s e a s o n . w
   отчет по производителю и классификатору
*/
   END. /*IF can-find(first chk-doc)*/
END. /* FOR EACH obj-list : */

if T-zeros then do:
  CASE dcardmode :
    when "LIST":U then do:
      FOR EACH dc-list no-LOCK:
        if not can-find(first dcards no-lock where
                              dcards.d-card = dc-list.d-card) then do:
          CREATE dcards .
          assign
          dcards.date_  = 01/01/1990
          dcards.d-card = dc-list.d-card
          dcards.artic = "":U
          dcards.b-code = 0
          dcards.prod-type = "":U
          dcards.prod-code = 0
          dcards.qnty = 0
          dcards.node-code = 0
          dcards.cli-type-code = dc-list.cli-type + string(dc-list.cli-code)
          dcards.card-num  = dc-list.card-num
          .
          if t-legacy or t-subsid then do:
            assign
            v-card-num-chr = (if t-legacy and t-subsid
                              then dc-list.first-main-card
                              else (if t-legacy and not t-subsid
                                    then  dc-list.first-card
                                    else  dc-list.main-card
                                    )
                              ).
            assign
            dcards.d-card        = dc-list.d-card
            dcards.card-num-chr  = v-card-num-chr
            dcards.first-card    = dc-list.first-card
            dcards.main-card     = dc-list.main-card
            dcards.first-main-card = dc-list.first-main-card
            dcards.cli-type-code = dc-list.cli-type + string(dc-list.cli-code)
            .
          end.
        end.
      END.
    end.
    when "ALL":U then do:
      for each X_dis-card no-lock,
          first obj-host no-lock where
                obj-host.host-code = X_dis-card.emitent-host-code:
        if not can-find(first dcards no-lock where
                              dcards.d-card = X_dis-card.d-card) then do:
          CREATE dcards .
          assign
          dcards.date_  = 01/01/1990
          dcards.d-card = X_dis-card.d-card
          dcards.artic = "":U
          dcards.b-code = 0
          dcards.prod-type = "":U
          dcards.prod-code = 0
          dcards.qnty = 0
          dcards.node-code = 0
          dcards.cli-type-code = X_dis-card.cli-type + string(X_dis-card.cli-code)
          dcards.card-num  = X_dis-card.card-num
          .
          if t-legacy then do:
            assign
            v-card-num-chr = (if t-legacy and t-subsid
                              then X_dis-card.first-main-card
                              else (if t-legacy and not t-subsid
                                    then  X_dis-card.first-card
                                    else  X_dis-card.main-card
                                    )
                              ).
            assign
            dcards.d-card          = X_dis-card.d-card
            dcards.card-num-chr    = v-card-num-chr
            dcards.first-card      = X_dis-card.first-card
            dcards.main-card       = X_dis-card.main-card
            dcards.first-main-card = X_dis-card.first-main-card
            dcards.cli-type-code = X_dis-card.cli-type + string(X_dis-card.cli-code)
            .
          end.
        end.
        else do:
        end. /*not legacy*/
      end.
    end.
    when "ONE":U then do:
      if not can-find (first dcards no-lock where
                              dcards.d-card = FIXdcard) then do:
          CREATE dcards .
          assign
          dcards.date_  = 01/01/1990
          dcards.d-card = X_dis-card.d-card
          dcards.artic = "":U
          dcards.b-code = 0
          dcards.prod-type = "":U
          dcards.prod-code = 0
          dcards.qnty = 0
          dcards.node-code = 0
          dcards.cli-type-code = X_dis-card.cli-type + string(X_dis-card.cli-code)
          dcards.card-num  = X_dis-card.card-num
          .
        if t-legacy then do:
          assign
          v-card-num-chr = (if t-legacy and t-subsid
                            then X_dis-card.first-main-card
                            else (if t-legacy and not t-subsid
                                  then  X_dis-card.first-card
                                  else  X_dis-card.main-card
                                  )).
          assign
          dcards.d-card          = X_dis-card.d-card
          dcards.card-num-chr    = v-card-num-chr
          dcards.main-card       = X_dis-card.main-card
          dcards.first-main-card = X_dis-card.first-main-card
          dcards.first-card      = X_dis-card.first-card
          dcards.cli-type-code   = X_dis-card.cli-type + string(X_dis-card.cli-code)
          .
        end.
      end.
    end.
  END CASE.
end.

if t-imp then
FOR EACH obj-host
  WHERE obj-host.host-code > 0
:
  _chk-payment:
  FOR EACH buf_payment no-lock
    where buf_payment.host-code = obj-host.host-code
      AND buf_payment.fact-date >= StartPoint
      AND buf_payment.fact-date <= EndPoint
      AND buf_payment.d-card > ""
      and buf_payment.status_ = {&fact}
      AND buf_payment.source-type = {&pmnt-cash-desk} + {&comma-char} + {&hn-source-import}
  :
    if (dcardmode = "ONE" or dcardmode = "LIST")
    and (t-legacy or t-subsid) then do:
        /**/
    end.
    else do:
      if dcardmode = "ONE" then do:
        if not buf_payment.d-card = FixDCard then next _chk-payment.
      end.

      if dcardmode = "list" then do:
        find first dc-list WHERE
                    dc-list.d-card = buf_payment.d-card no-error.
        if not available dc-list then next _chk-payment.
      end.
    end.
    for each buf_payment-attr no-lock
      where buf_payment-attr.pmnt-code = buf_payment.pmnt-code
        and buf_payment-attr.attr-code = "obj"
    :
      if num-entries( buf_payment-attr.attr-value ) < 2 then
        leave.
      if not can-find( first obj-list no-lock
        where obj-list.obj-type = entry( 1, buf_payment-attr.attr-value )
          and obj-list.obj-code = int( entry( 2, buf_payment-attr.attr-value ) )
                     )
      then next _chk-payment.
    end.

    PROCESS EVENTS .
    v-count = v-count + 1.
    if ( v-count  modulo 10 ) = 0
    AND  v-count >= 10 then do:
      run waitfram-show in this-procedure  ( input substitute("&1 обработано чеков &2"
                                                            ,obj-host.host-code
                                                            ,v-count)
                                          ).

    end.
    new-doc = yes.
    find first buf_dis-card no-lock where
      buf_dis-card.d-card = buf_payment.d-card no-error .
    if t-legacy or t-subsid then do:
      if available buf_dis-card then do:
        assign
        v-card-num-chr = (if t-legacy and t-subsid
                          then buf_dis-card.first-main-card
                          else (if t-legacy and not t-subsid
                                then  buf_dis-card.first-card
                                else  buf_dis-card.main-card
                                )
                          ).
      end.
    end.
    IF TotalOnly
    then do:
      FIND FIRST dcards WHERE dcards.d-card = buf_payment.d-card NO-ERROR .
      if NOT available dcards then  do:
        CREATE dcards .
        assign
          dcards.date_  = buf_payment.fact-date
          dcards.d-card = buf_payment.d-card
          dcards.artic = "Импорт из ВС"
/*          dcards.artic = ""*/
          dcards.b-code =  0
          dcards.prod-type = ""
          dcards.prod-code = 0
          dcards.qnty = 0
          dcards.node-code = 0
        .
        if t-legacy or t-subsid then do:
          if available buf_dis-card then do:
            assign
              dcards.cli-type-code   = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
              dcards.card-num        = buf_dis-card.card-num
              dcards.d-card          = buf_dis-card.d-card
              dcards.card-num-chr    = v-card-num-chr
              dcards.main-card       = buf_dis-card.main-card
              dcards.first-card      = buf_dis-card.first-card
              dcards.first-main-card = buf_dis-card.first-main-card
            .
          end.
        end. /*if t-legacy or t-subsid then do:*/
        else do:
          if available buf_dis-card then do:
            assign
              dcards.cli-type-code = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
            .
          end.
          else do:
            assign
              dcards.cli-type-code = buf_payment.cli-type + string(buf_payment.cli-code)
            .
          end.
        end. /*bot legacy*/
      end. /*IF NOT AVAIL dcards*/
      assign
        dcards.qnty = 0
        dcards.sale-price = 0
        dcards.sum = dcards.sum + buf_payment.tot-cli
        dcards.counter = (if new-doc then dcards.counter + 1 else dcards.counter )
      .
      new-doc = no.
    end. /*IF TOTALONLY*/
    else do:
      FIND FIRST dcards
        WHERE dcards.date_ = buf_payment.fact-date
          AND dcards.d-card = buf_payment.d-card
          AND dcards.b-code = 0
          AND dcards.sale-price = 0
        NO-ERROR .
      if NOT available dcards then do:
        CREATE dcards .
        assign
          dcards.date_  = buf_payment.fact-date
          dcards.d-card = buf_payment.d-card
          dcards.artic = "Импорт из ВС"
          dcards.b-code = 0
          dcards.qnty = 0
        .
        if t-legacy or t-subsid then do:
          assign
            dcards.d-card          = buf_dis-card.d-card
            dcards.card-num-chr    = v-card-num-chr
            dcards.first-card      = buf_dis-card.first-card
            dcards.main-card       = buf_dis-card.main-card
            dcards.first-main-card = buf_dis-card.first-main-card
            dcards.cli-type-code   = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
            dcards.card-num        = buf_dis-card.card-num
          .
        end.
        else do:
          if available buf_dis-card then do:
            assign
              dcards.cli-type-code = buf_dis-card.cli-type + string(buf_dis-card.cli-code)
            .
          end.
          else do:
            assign
              dcards.cli-type-code = buf_payment.cli-type + string(buf_payment.cli-code)
            .
          end.
        end. /*not legacy*/
      end.
      assign
        dcards.qnty = 0
        dcards.sale-price = 0
        dcards.sum = dcards.sum + buf_payment.tot-cli
        dcards.counter = (if new-doc then dcards.counter + 1 else dcards.counter )
      .
      new-doc = no.
    end.
  END.    /* FOR EACH buf_payment WHERE ... */
END.
/*for each dcards
break by dcards.d-card
:
  if first-of( dcards.d-card ) then
  for EACH obj-list:
    for each ub.dis-obj no-lock
      where ub.dis-obj.obj-type = obj-list.obj-type
        and ub.dis-obj.obj-code = obj-list.obj-code
        and ub.dis-obj.d-card   = dcards.d-card
        and ub.dis-obj.dt-code = 0
    :
      dcards.counter = dcards.counter + ub.dis-obj.num-chk.
    end.
  end.
end.      */

run waitfram-hide in this-procedure .