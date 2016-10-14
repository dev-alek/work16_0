/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура резервирования товара для документов

Автор: Чернова Светлана Александровна
Дата создания: 02/14/07
Author: Svetlana Chernova
Creation date: 02/14/07

create: Перваков Михаил Сергеевич
Дата создания: 10/19/05

*/


&scop f-l Base2Int64
&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
{ gbl/std-func.i {&f-l} }

  define temp-table tt-alc-codes
    field alc-code      as character
    field qnty          as decimal
    index pi as primary unique
      alc-code
  .


procedure rsrv-doc :
  define input  parameter parparentproc          AS WIDGET-HANDLE           NO-UNDO.
  define input  parameter p-db-num               as integer   no-undo .
  define input  parameter p-user-id              as character no-undo .
  define input  parameter p-trn-doc-recid        as recid     no-undo .
  define input  parameter p-doc-line-recid       as recid     no-undo .
  define input  parameter p-reserv-base          as decimal   no-undo .
  define input  parameter p-reserv-rubl          as decimal   no-undo .
  define input  parameter p-partscr-prompt-price as character no-undo .
  define input  parameter p-extended-doc-type    as character no-undo .
  define input  parameter p-reserv-single-part   as logical   no-undo .
  define input  parameter p-in-code              as character no-undo .
  define input  parameter p-part-code            as character no-undo .
  define input  parameter p-reserv-pl-code       as logical   no-undo .
  define input  parameter p-pl-code              as character no-undo .
  define input  parameter p-goods-serial         as logical   no-undo .
  define input  parameter p-goods-twounit        as logical   no-undo .
  define input  parameter p-purch-code-list      as character no-undo .
  define input  parameter p-chg-qnty             as decimal   no-undo .
  define input  parameter p-unreserv-other-sign  as logical   no-undo .
  define output parameter p-real-chg-qnty        as decimal   no-undo .

  define variable vss-description as character no-undo init "rsrv-doc: Процедура резервирования партий".

  define variable v-chg-qnty-sign   as integer         no-undo .
  define variable v-rsrv-code       as character       no-undo .
  define variable v-reason          as character       no-undo .
  define variable v-process-part    as logical         no-undo .
  define variable v-real-chg-qnty   like ub.parts.qnty no-undo .
  define variable v-parts-recid     as recid           no-undo .
  define variable v-check-part-qnty as decimal         no-undo .

  define buffer buf_parts    for ub.parts .
  define buffer buf2_parts   for ub.parts .
  define buffer buf_trn-doc  for ub.trn-doc .
  define buffer buf_doc-line for ub.doc-line .
  define buffer buf1_doc-line-attr for ub.doc-line-attr .
  define buffer buf1_goods    for ub.goods .
  
  
  define variable v-mark as character no-undo .
  define variable v-mark-list as character no-undo .
  define variable v-alc-code as character no-undo .
  define variable mark-ii as integer  no-undo .
  define variable v-alc-qnty as decimal no-undo .

  do
  on error undo, return error return-value
  :
    find first buf_trn-doc no-lock
      where recid(buf_trn-doc) = p-trn-doc-recid
      no-error .
    if not available buf_trn-doc
    then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка задания входных параметров" skip
        "Не найден документ" skip
        "Указатель" p-trn-doc-recid skip
        view-as alert-box error .
      undo, return error return-value .
    end.

    find first buf_doc-line no-lock
      where recid(buf_doc-line) = p-doc-line-recid
      no-error .
    if not available buf_doc-line
    then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка задания входных параметров" skip
        "Не найдена строка документа" skip
        "Указатель" p-doc-line-recid skip
        view-as alert-box error .
      undo, return error return-value .
    end.
    
    empty temp-table tt-alc-codes .
    find first buf1_goods no-lock where buf1_goods.artic      = buf_doc-line.artic
                                   and buf1_goods.prod-type  = buf_doc-line.prod-type
                                   and buf1_goods.prod-code  = buf_doc-line.prod-code .
    find first buf1_doc-line-attr exclusive-lock where buf1_doc-line-attr.doc-code = buf_doc-line.doc-code
                                                  and buf1_doc-line-attr.gds-code = buf1_goods.gds-code
                                                  and buf1_doc-line-attr.attr-code = 'mark-code'
                                                  no-error.
    if available buf1_doc-line-attr and buf1_doc-line-attr.attr-value <> ''
    then do :
      do mark-ii = 1 to num-entries(buf1_doc-line-attr.attr-value) :
        v-mark = entry(mark-ii, buf1_doc-line-attr.attr-value) .
        if not can-do(v-mark-list, v-mark)
        then v-mark-list = v-mark-list + (if v-mark-list = '' then '' else ',') + v-mark .
      end.
      buf1_doc-line-attr.attr-value = v-mark-list .
      do mark-ii = 1 to min(num-entries(buf1_doc-line-attr.attr-value), buf_doc-line.fact-qnty) :
        v-mark = entry(mark-ii, buf1_doc-line-attr.attr-value) .
        run ProcAlcCode (input v-mark, output v-alc-code) no-error.
        if v-alc-code = ? or v-alc-code = ''
        then do :
          message
            vss-workfile vss-revision vss-description skip
            "Ошибка определения алкогольного кода" skip
            "Марка - " v-mark skip
            view-as alert-box error .
          undo, return error return-value .  
        end.
        find first tt-alc-codes exclusive-lock where tt-alc-codes.alc-code = v-alc-code no-error.
        if not available tt-alc-codes
        then do :
            create tt-alc-codes.
            assign tt-alc-codes.alc-code = v-alc-code .
        end.
        tt-alc-codes.qnty = tt-alc-codes.qnty + 1 .
      end.
    end.
    release buf1_goods no-error .
    release buf1_doc-line-attr no-error .
    
    v-alc-qnty = 0 .
    for each tt-alc-codes exclusive-lock :
        v-alc-qnty = v-alc-qnty + tt-alc-codes.qnty .
    end.
    
/*    А вот здесь начинаются танцы с бубном.                                                                               */
/*    Случай, когда дорезервируем товар с марками, но который изначально заразервировался или частично заразервировался    */
/*    по ФИФО, из-за того, что не была найдена партия/партии с алкокодом/алкокодами из марок.                              */
/*    Боюсь, что до конца всё привести в порядок удасться только когда реализуем помарочный учёт (марки в партиях).        */
    if p-chg-qnty < v-alc-qnty and p-chg-qnty > 0
    then
    for each  buf2_parts no-lock
        where buf2_parts.obj-type  = buf_doc-line.obj-type
          and buf2_parts.obj-code  = buf_doc-line.obj-code
          and buf2_parts.artic     = buf_doc-line.artic
          and buf2_parts.prod-type = buf_doc-line.prod-type
          and buf2_parts.prod-code = buf_doc-line.prod-code
          and buf2_parts.out-code  = buf_doc-line.doc-code
          and buf2_parts.status_   = no
          and buf2_parts.fact-qnty > 0
    use-index FIFO :
        if num-entries(buf2_parts.alc-ref-ab-path) = 4
        and entry(3, buf2_parts.alc-ref-ab-path) <> ""
        then do :
            find first tt-alc-codes exclusive-lock where tt-alc-codes.alc-code = entry(3, buf2_parts.alc-ref-ab-path) no-error.
            if not available tt-alc-codes
            then do :
                find first tt-alc-codes exclusive-lock .
            end.
            tt-alc-codes.qnty = tt-alc-codes.qnty - min(buf2_parts.fact-qnty, tt-alc-codes.qnty) .
            v-alc-qnty = v-alc-qnty - min(buf2_parts.fact-qnty, tt-alc-codes.qnty) .
            if tt-alc-codes.qnty = 0
            then do :
                delete tt-alc-codes . 
                if p-chg-qnty < v-alc-qnty
                then do :
                    find next tt-alc-codes exclusive-lock no-error.
                    if not available tt-alc-codes then find first tt-alc-codes exclusive-lock .
                    tt-alc-codes.qnty = tt-alc-codes.qnty - (v-alc-qnty - p-chg-qnty) .
                    v-alc-qnty = p-chg-qnty .
                    leave .
                end.
            end.
        end.
        else do :
            find first tt-alc-codes exclusive-lock .
            tt-alc-codes.qnty = tt-alc-codes.qnty - min(buf2_parts.fact-qnty, tt-alc-codes.qnty) .
            v-alc-qnty = v-alc-qnty - min(buf2_parts.fact-qnty, tt-alc-codes.qnty) .
            if tt-alc-codes.qnty = 0
            then do :
                delete tt-alc-codes . 
                if p-chg-qnty < v-alc-qnty
                then do :
                    find next tt-alc-codes exclusive-lock no-error.
                    if not available tt-alc-codes then find first tt-alc-codes exclusive-lock .
                    tt-alc-codes.qnty = tt-alc-codes.qnty - (v-alc-qnty - p-chg-qnty) .
                    v-alc-qnty = p-chg-qnty .
                    leave .
                end.
            end.
        end.
    end.

    /* определяем знак изменяемого количества */
    assign
      v-chg-qnty-sign = 0
    .
    if p-chg-qnty > 0
    then do:
      assign
        v-chg-qnty-sign = 1
      .
    end.
    if p-chg-qnty < 0
    then do:
      assign
        v-chg-qnty-sign = - 1
      .
    end.

    if  buf_trn-doc.ext-doc-type <> {&TDEDT_Peresort}
    and buf_trn-doc.ext-doc-type <> {&TDEDT_Corr_Acc_Price}
    and buf_trn-doc.ext-doc-type <> {&TDEDT_Corr_Minus_Parts}
    then do:
      run unrsrv-negative in this-procedure
        (buffer buf_doc-line
        ,input  p-chg-qnty
        ,output v-real-chg-qnty
        ) no-error .
      if error-status :error
      then do:
        message
          vss-workfile vss-revision vss-description skip
          "Ошибка при вызове процедуры unrsrv-negative" skip
          view-as alert-box error .
        undo, return error return-value .
      end.
    end.


    assign
      p-chg-qnty      = p-chg-qnty      - abs(v-real-chg-qnty) * v-chg-qnty-sign
      p-real-chg-qnty = p-real-chg-qnty + abs(v-real-chg-qnty) * v-chg-qnty-sign
    .

    if p-chg-qnty = 0
    then do:
      return . /* --->>>--- */
    end.

    define variable v-fifo as logical   no-undo .
    define variable v-alc-rsrv  as logical   no-undo .

    if p-unreserv-other-sign
    then do:
      if buf_trn-doc.doc-type = {&expense}
      or buf_trn-doc.doc-type = {&write-off}
      then do:
        assign
          v-fifo = true
        .
      end.
      else do:
        assign
          v-fifo = false
        .
      end.

      if v-fifo
      then do:
        find first buf_parts
          where buf_parts.obj-type  = buf_doc-line.obj-type
            and buf_parts.obj-code  = buf_doc-line.obj-code
            and buf_parts.artic     = buf_doc-line.artic
            and buf_parts.prod-type = buf_doc-line.prod-type
            and buf_parts.prod-code = buf_doc-line.prod-code
            and buf_parts.out-code  = buf_doc-line.doc-code
            and buf_parts.in-code   <> buf_parts.out-code
            and buf_parts.qnty * p-chg-qnty < 0
          use-index FIFO
          no-error.
      end.
      else do:
        find last buf_parts
          where buf_parts.obj-type  = buf_doc-line.obj-type
            and buf_parts.obj-code  = buf_doc-line.obj-code
            and buf_parts.artic     = buf_doc-line.artic
            and buf_parts.prod-type = buf_doc-line.prod-type
            and buf_parts.prod-code = buf_doc-line.prod-code
            and buf_parts.out-code  = buf_doc-line.doc-code
            and buf_parts.in-code   <> buf_parts.out-code
            and buf_parts.qnty * p-chg-qnty < 0
          use-index FIFO
          no-error.
      end.

      do while p-chg-qnty <> 0
      and available buf_parts
      :
        assign
          v-check-part-qnty = p-chg-qnty
                            * ( if lookup(buf_trn-doc.doc-type, {&expense_write-off} ) > 0
                                then -1
                                else 1
                              )
        .

        /* определяем необходимость резервирования партии */
        { gbl/part-prc.i
          buf_parts
          buf_trn-doc
          p-reserv-single-part
          p-in-code
          p-part-code
          p-pl-code
          p-goods-twounit
          p-purch-code-list
          v-check-part-qnty
          "true"
          v-reason
          v-process-part
          no-error
        }
        if error-status :error
        then do:
          message
            vss-workfile vss-revision vss-description skip
            "Ошибка при определении возможности резервирования партии" skip
            "Документ" buf_doc-line.doc-code skip
            "Артикул" buf_doc-line.artic buf_doc-line.prod-type buf_doc-line.prod-code skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
          undo, return error return-value .
        end.

        if v-process-part = true
        then do:
          /* Резервирование или снятие резервов */
          run partrsrv in this-procedure
            (input  p-chg-qnty      /* p-chg-qnty      */
                    * ( if lookup(buf_trn-doc.doc-type, {&expense_write-off} ) > 0
                        then -1
                        else 1
                      )
            ,input  p-goods-serial  /* p-goods-serial  */
            ,input  p-goods-twounit /* p-goods-twounit */
            ,input  true            /* p-unreserv-only */
            ,buffer buf_parts       /* buf_orig_parts  */
            ,buffer buf_trn-doc     /* buf_trn-doc     */
            ,output v-real-chg-qnty /* p-real-chg-qnty */
            ,output v-parts-recid   /* p-parts-recid   */
            ) no-error .
          if error-status :error
          then do:
            message
              vss-workfile vss-revision vss-description skip
              "Ошибка при вызове partrsrv" skip
              error-status :get-message(1) skip
              return-value skip
              view-as alert-box error .
            return return-value .
          end.

          assign
            p-chg-qnty      = p-chg-qnty      - abs(v-real-chg-qnty) * v-chg-qnty-sign
            p-real-chg-qnty = p-real-chg-qnty + abs(v-real-chg-qnty) * v-chg-qnty-sign
          .
        end.

        /* ищем следующую доступную партию */
        if v-fifo
        then do:
          find next buf_parts
            where buf_parts.obj-type  = buf_doc-line.obj-type
              and buf_parts.obj-code  = buf_doc-line.obj-code
              and buf_parts.artic     = buf_doc-line.artic
              and buf_parts.prod-type = buf_doc-line.prod-type
              and buf_parts.prod-code = buf_doc-line.prod-code
              and buf_parts.out-code  = buf_doc-line.doc-code
              and buf_parts.in-code   <> buf_parts.out-code
              and buf_parts.qnty * p-chg-qnty < 0
            use-index FIFO
            no-error.
        end.
        else do:
          find prev buf_parts
            where buf_parts.obj-type  = buf_doc-line.obj-type
              and buf_parts.obj-code  = buf_doc-line.obj-code
              and buf_parts.artic     = buf_doc-line.artic
              and buf_parts.prod-type = buf_doc-line.prod-type
              and buf_parts.prod-code = buf_doc-line.prod-code
              and buf_parts.out-code  = buf_doc-line.doc-code
              and buf_parts.in-code   <> buf_parts.out-code
              and buf_parts.qnty * p-chg-qnty < 0
            use-index FIFO
            no-error.
        end.
      end.
    end.

    if  buf_trn-doc.discnt-type = {&cash-desk}
    and p-goods-serial = true
    then do:
      /* Продажа через кассу серийных товаров  */
      /* бар-код должен быть задан обязательно */
      if p-reserv-single-part = false
      then do:
        return . /* --->>>--- */
      end.
    end.

    /* необходимо использовать список партий */
    define variable v-partlist-use    as logical   no-undo .

    /* порядок резервирования партий */
    define variable v-partlist-order  as character no-undo .

    run partlist_use-get in this-procedure
      (output v-partlist-use
      ) .

    if p-chg-qnty < 0
    then do:
      if buf_trn-doc.doc-type = {&inventory}
      then do:
        assign
          v-rsrv-code = {&free-code}
        .
        assign
          v-fifo = true
        .
        if v-partlist-use = true
        then do:
          assign
            v-partlist-order  = 'partlist-increment,parts':u
          .
        end.
        else do:
          assign
            v-partlist-order  = 'parts':u
          .
        end.
      end.
      else do:
        assign
          v-rsrv-code = buf_doc-line.doc-code
        .
        if buf_trn-doc.doc-type = {&expense}
        or buf_trn-doc.doc-type = {&write-off}
        then do:
          assign
            v-fifo = false
          .
          if v-partlist-use = true
          then do:
            assign
              v-partlist-order  = 'parts,partlist-decrement':u
            .
          end.
          else do:
            assign
              v-partlist-order  = 'parts':u
            .
          end.
        end.
        else do:
          assign
            v-fifo = true
          .
          if v-partlist-use = true
          then do:
            assign
              v-partlist-order  = 'parts,partlist-decrement':u
            .
          end.
          else do:
            assign
              v-partlist-order  = 'parts':u
            .
          end.
        end.
      end.
    end.
    else do:
      /* p-chg-qnty > 0 */
      assign
        v-rsrv-code = { trg/partsprm.i "rsrv-code" "buf_trn-doc." "0" }
      .
      if v-rsrv-code = {&free-code}
      then do:
        find first tt-alc-codes no-error.
        if available tt-alc-codes
        then do :
          v-alc-rsrv = true .
        end.
        else do :
           v-alc-rsrv = false .  
        end.  
        assign
          v-fifo = true
        .
        if v-partlist-use = true
        then do:
          assign
            v-partlist-order = 'partlist-increment,parts':u
          .
        end.
        else do:
          assign
            v-partlist-order = 'parts':u
          .
        end.
      end.
      else do:
        assign
          v-fifo = false
        .
        if v-partlist-use = true
        then do:
          assign
            v-partlist-order = 'partlist-increment,parts':u
          .
        end.
        else do:
          assign
            v-partlist-order = 'parts':u
          .
        end.
      end.
    end.

    if  v-partlist-use = false
    and v-partlist-order <> 'parts':u
    then do:
      message
        vss-workfile vss-revision vss-description skip
        "Внутренняя ошибка резервирования" skip
        view-as alert-box error .
    end.

    define variable v-find-first         as logical   no-undo .
    define variable v-rsrv-index         as integer   no-undo .
    define variable v-rsrv-entry         as character no-undo .
    define variable v-iteration-chg-qnty as decimal   no-undo .
    define variable v-part-index         as integer   no-undo .
    define variable v-max-part-index     as integer   no-undo .
    define variable v-partlist-in-code   as character no-undo .
    define variable v-partlist-part-code as character no-undo .
    define variable v-partlist-rsrv-qnty as decimal   no-undo .

    assign
      v-find-first = true
      v-rsrv-index = 1
      v-rsrv-entry = entry(v-rsrv-index, v-partlist-order, {&comma-char})
    .

    rsrv_cycle:
    do while p-chg-qnty <> 0
    :
      assign
        v-iteration-chg-qnty = 0
      .

      /* найти партию в соответствии с условиями */
      case v-rsrv-entry :
        when 'parts':u
        then do:
          assign
            v-iteration-chg-qnty = p-chg-qnty
          .
          if v-find-first = true
          then do:
            assign
              v-find-first = false
            .
            if v-alc-rsrv
            then do :
              find first tt-alc-codes .
              assign
                v-iteration-chg-qnty = tt-alc-codes.qnty
              .
              find first buf_parts
                where buf_parts.obj-type  = buf_doc-line.obj-type
                  and buf_parts.obj-code  = buf_doc-line.obj-code
                  and buf_parts.artic     = buf_doc-line.artic
                  and buf_parts.prod-type = buf_doc-line.prod-type
                  and buf_parts.prod-code = buf_doc-line.prod-code
                  and buf_parts.out-code  = v-rsrv-code
                  and buf_parts.status_   = no
                  and buf_parts.fact-qnty > 0
                  and num-entries(buf_parts.alc-ref-ab-path) = 4
                  and entry(3, buf_parts.alc-ref-ab-path) = tt-alc-codes.alc-code
                use-index FIFO
                no-error.
              if available buf_parts
              then v-fifo = false .
              else v-fifo = true .  
            end.
            
            if v-fifo = true
            then do:
              find first buf_parts
                where buf_parts.obj-type  = buf_doc-line.obj-type
                  and buf_parts.obj-code  = buf_doc-line.obj-code
                  and buf_parts.artic     = buf_doc-line.artic
                  and buf_parts.prod-type = buf_doc-line.prod-type
                  and buf_parts.prod-code = buf_doc-line.prod-code
                  and buf_parts.out-code  = v-rsrv-code
                  and buf_parts.status_   = no
                  and buf_parts.fact-qnty > 0
                use-index FIFO
                no-error.
            end.
            else if not v-alc-rsrv
            then do:
              find last buf_parts
                where buf_parts.obj-type  = buf_doc-line.obj-type
                  and buf_parts.obj-code  = buf_doc-line.obj-code
                  and buf_parts.artic     = buf_doc-line.artic
                  and buf_parts.prod-type = buf_doc-line.prod-type
                  and buf_parts.prod-code = buf_doc-line.prod-code
                  and buf_parts.out-code  = v-rsrv-code
                  and buf_parts.status_   = no
                  and buf_parts.fact-qnty > 0
                use-index FIFO
                no-error.
            end.
          end.
          else do:
            /* ищем следующую доступную партию */
            if v-alc-rsrv
            then do :
              if p-real-chg-qnty = tt-alc-codes.qnty
              then do :
                  find next tt-alc-codes no-error.
                  if available tt-alc-codes
                  then do :
                    assign
                      v-iteration-chg-qnty = tt-alc-codes.qnty
                    .
                    find first buf_parts
                    where buf_parts.obj-type  = buf_doc-line.obj-type
                      and buf_parts.obj-code  = buf_doc-line.obj-code
                      and buf_parts.artic     = buf_doc-line.artic
                      and buf_parts.prod-type = buf_doc-line.prod-type
                      and buf_parts.prod-code = buf_doc-line.prod-code
                      and buf_parts.out-code  = v-rsrv-code
                      and buf_parts.status_   = no
                      and buf_parts.fact-qnty > 0
                      and num-entries(buf_parts.alc-ref-ab-path) = 4
                      and entry(3, buf_parts.alc-ref-ab-path) = tt-alc-codes.alc-code
                    use-index FIFO
                    no-error.
                    if available buf_parts
                    then v-fifo = false .
                    else v-fifo = true .  
                  end. 
                  else do :
                    v-fifo = true .  
                  end.
              end.    
              else do :
/*                  find first tt-alc-codes .*/
                  find first buf_parts
                    where buf_parts.obj-type  = buf_doc-line.obj-type
                      and buf_parts.obj-code  = buf_doc-line.obj-code
                      and buf_parts.artic     = buf_doc-line.artic
                      and buf_parts.prod-type = buf_doc-line.prod-type
                      and buf_parts.prod-code = buf_doc-line.prod-code
                      and buf_parts.out-code  = v-rsrv-code
                      and buf_parts.status_   = no
                      and buf_parts.fact-qnty > 0
                      and num-entries(buf_parts.alc-ref-ab-path) = 4
                      and entry(3, buf_parts.alc-ref-ab-path) = tt-alc-codes.alc-code
                    use-index FIFO
                    no-error.
                  if available buf_parts
                  then v-fifo = false .
                  else v-fifo = true . 
              end. 
            end.
            if v-fifo = true
            then do:
              find next buf_parts
                where buf_parts.obj-type  = buf_doc-line.obj-type
                  and buf_parts.obj-code  = buf_doc-line.obj-code
                  and buf_parts.artic     = buf_doc-line.artic
                  and buf_parts.prod-type = buf_doc-line.prod-type
                  and buf_parts.prod-code = buf_doc-line.prod-code
                  and buf_parts.out-code  = v-rsrv-code
                  and buf_parts.status_   = no
                  and buf_parts.fact-qnty > 0
                use-index FIFO
                no-error.
            end.
            else if not v-alc-rsrv 
            then do:
              find prev buf_parts
                where buf_parts.obj-type  = buf_doc-line.obj-type
                  and buf_parts.obj-code  = buf_doc-line.obj-code
                  and buf_parts.artic     = buf_doc-line.artic
                  and buf_parts.prod-type = buf_doc-line.prod-type
                  and buf_parts.prod-code = buf_doc-line.prod-code
                  and buf_parts.out-code  = v-rsrv-code
                  and buf_parts.status_   = no
                  and buf_parts.fact-qnty > 0
                use-index FIFO
                no-error.
            end.
          end.

          if not available buf_parts
          then do:
            assign
              v-rsrv-index = v-rsrv-index + 1
            .
            if v-rsrv-index <= num-entries(v-partlist-order)
            then do:
              assign
                v-find-first = true
                v-rsrv-entry = entry(v-rsrv-index, v-partlist-order, {&comma-char})
              .
              next rsrv_cycle . /* --->>>--- */
            end.
            else do:
              /* если партия не найдена */
              /* и это последний элемент порядка резервирования */
              /* - прекратить резервирование */
              leave rsrv_cycle . /* --->>>--- */
            end.
          end.

          /* если эта партия входит в список партий */
          /* то необходимо задать количество на резервирование */
          /* равное разнице текущего зарезервированного количества */
          /* и количества заданного в списке партий */
          if v-partlist-use = true
          then do:
            define variable v-parts-rsrv-qnty  as decimal   no-undo .
            define variable v-parts-check-qnty as decimal   no-undo .

            run partlist_check-part-qnty in this-procedure
              (input  buf_parts.in-code
              ,input  buf_parts.part-code
              ,output v-parts-check-qnty
              ) .

            if v-parts-check-qnty > 0
            then do:
              assign
                v-parts-rsrv-qnty = 0
              .
              if buf_parts.out-code = buf_doc-line.doc-code
              then do:
                assign
                  v-parts-rsrv-qnty = buf_parts.qnty
                .
              end.
              else do:
                define buffer buf_rsrv_parts for ub.parts .
                find first buf_rsrv_parts
                  where buf_rsrv_parts.obj-type  = buf_doc-line.obj-type
                    and buf_rsrv_parts.obj-code  = buf_doc-line.obj-code
                    and buf_rsrv_parts.artic     = buf_doc-line.artic
                    and buf_rsrv_parts.prod-type = buf_doc-line.prod-type
                    and buf_rsrv_parts.prod-code = buf_doc-line.prod-code
                    and buf_rsrv_parts.in-code   = buf_parts.in-code
                    and buf_rsrv_parts.out-code  = buf_doc-line.doc-code
                    and buf_rsrv_parts.part-code = buf_parts.part-code
                  no-error .
                if available buf_rsrv_parts
                then do:
                  assign
                    v-parts-rsrv-qnty = buf_rsrv_parts.qnty
                  .
                end.
                if v-parts-rsrv-qnty > v-parts-check-qnty
                then do:
                  assign
                    v-iteration-chg-qnty = min(v-parts-rsrv-qnty - v-parts-check-qnty
                                              ,abs(v-iteration-chg-qnty)
                                              )
                                         * (if v-iteration-chg-qnty > 0
                                            then 1
                                            else -1
                                           )
                  .
                end.
                else do:
                  assign
                    v-iteration-chg-qnty = 0
                  .
                end.
              end.
            end.
          end.
        end.
        when 'partlist-increment':u
        then do:
          if v-find-first = true
          then do:
            assign
              v-find-first = false
            .
            run partlist_get-total-num in this-procedure
              (output v-max-part-index
              ) .
            assign
              v-part-index = 1
            .
          end.
          else do:
            assign
              v-part-index = v-part-index + 1
            .
          end.

          if v-part-index <= v-max-part-index
          then do:
            run partlist_get-part-qnty in this-procedure
              (input  v-part-index
              ,output v-partlist-in-code
              ,output v-partlist-part-code
              ,output v-partlist-rsrv-qnty
              ) no-error .
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                "Ошибка при получении необходимых количеств для резервирования" skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error return-value .
            end.

            find first buf_parts
              where buf_parts.obj-type  = buf_doc-line.obj-type
                and buf_parts.obj-code  = buf_doc-line.obj-code
                and buf_parts.artic     = buf_doc-line.artic
                and buf_parts.prod-type = buf_doc-line.prod-type
                and buf_parts.prod-code = buf_doc-line.prod-code
                and buf_parts.out-code  = v-rsrv-code
                and buf_parts.in-code   = v-partlist-in-code
                and buf_parts.part-code = v-partlist-part-code
                and buf_parts.status_   = no
                and buf_parts.fact-qnty > 0
              no-error .
            if not available buf_parts
            then do:
              next rsrv_cycle . /* --->>>--- */
            end.

            assign
              v-iteration-chg-qnty = min(abs(p-chg-qnty)
                                        ,abs(v-partlist-rsrv-qnty)
                                        )
                                   * (if p-chg-qnty > 0 then 1 else -1)
            .
          end.
          else do:
            assign
              v-rsrv-index = v-rsrv-index + 1
            .
            if v-rsrv-index <= num-entries(v-partlist-order)
            then do:
              assign
                v-find-first = true
                v-rsrv-entry = entry(v-rsrv-index, v-partlist-order, {&comma-char})
              .
              next rsrv_cycle . /* --->>>--- */
            end.
            else do:
              /* если партия не найдена */
              /* и это последний элемент порядка резервирования */
              /* - прекратить резервирование */
              leave rsrv_cycle . /* --->>>--- */
            end.
          end.
        end.
        when 'partlist-decrement':u
        then do:
          if v-find-first = true
          then do:
            assign
              v-find-first = false
            .
            run partlist_get-total-num in this-procedure
              (output v-max-part-index
              ) .
            assign
              v-part-index = v-max-part-index
            .
          end.
          else do:
            assign
              v-part-index = v-part-index - 1
            .
          end.

          if v-part-index >= 1
          then do:
            run partlist_get-part-qnty in this-procedure
              (input  v-part-index
              ,output v-partlist-in-code
              ,output v-partlist-part-code
              ,output v-partlist-rsrv-qnty
              ) no-error .
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                "Ошибка при получении необходимых количеств для резервирования" skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error return-value .
            end.

            find first buf_parts
              where buf_parts.obj-type  = buf_doc-line.obj-type
                and buf_parts.obj-code  = buf_doc-line.obj-code
                and buf_parts.artic     = buf_doc-line.artic
                and buf_parts.prod-type = buf_doc-line.prod-type
                and buf_parts.prod-code = buf_doc-line.prod-code
                and buf_parts.out-code  = v-rsrv-code
                and buf_parts.in-code   = v-partlist-in-code
                and buf_parts.part-code = v-partlist-part-code
                and buf_parts.status_   = no
                and buf_parts.fact-qnty > 0
              no-error .
            if not available buf_parts
            then do:
              next rsrv_cycle . /* --->>>--- */
            end.

            assign
              v-iteration-chg-qnty = min(abs(p-chg-qnty)
                                        ,abs(v-partlist-rsrv-qnty)
                                        )
                                   * (if p-chg-qnty > 0 then 1 else -1)
            .
          end.
          else do:
            assign
              v-rsrv-index = v-rsrv-index + 1
            .
            if v-rsrv-index <= num-entries(v-partlist-order)
            then do:
              assign
                v-find-first = true
                v-rsrv-entry = entry(v-rsrv-index, v-partlist-order, {&comma-char})
              .
              next rsrv_cycle . /* --->>>--- */
            end.
            else do:
              /* если партия не найдена */
              /* и это последний элемент порядка резервирования */
              /* - прекратить резервирование */
              leave rsrv_cycle . /* --->>>--- */
            end.
          end.
        end.
        otherwise do:
          message
            vss-workfile vss-revision vss-description skip
            "Внутренняя ошибка" skip
            "Неизвестное значение переменной" v-rsrv-entry skip
            view-as alert-box error .
        end.
      end.

      assign
        v-check-part-qnty = p-chg-qnty
                          * ( if lookup(buf_trn-doc.doc-type, {&expense_write-off} ) > 0
                              then -1
                              else 1
                            )
      .

      /* определяем необходимость резервирования партии */
      { gbl/part-prc.i
        buf_parts
        buf_trn-doc
        p-reserv-single-part
        p-in-code
        p-part-code
        p-pl-code
        p-goods-twounit
        p-purch-code-list
        v-check-part-qnty
        "true"
        v-reason
        v-process-part
        no-error
      }
      if error-status :error
      then do:
        message
          vss-workfile vss-revision vss-description skip
          "Ошибка при определении возможности резервирования партии" skip
          "Документ" buf_doc-line.doc-code skip
          "Артикул" buf_doc-line.artic buf_doc-line.prod-type buf_doc-line.prod-code skip
          error-status :get-message(1) skip
          return-value skip
          view-as alert-box error .
        undo, return error return-value .
      end.

      if v-process-part = true
      then do:
        /* Резервирование или снятие резервов */
        run partrsrv in this-procedure
          (input  v-iteration-chg-qnty /* p-chg-qnty      */
                    * ( if lookup(buf_trn-doc.doc-type, {&expense_write-off} ) > 0
                        then -1
                        else 1
                      )
          ,input  p-goods-serial  /* p-goods-serial  */
          ,input  p-goods-twounit /* p-goods-twounit */
          ,input  false           /* p-unreserv-only */
          ,buffer buf_parts       /* buf_orig_parts  */
          ,buffer buf_trn-doc     /* buf_trn-doc     */
          ,output v-real-chg-qnty /* p-real-chg-qnty */
          ,output v-parts-recid   /* p-parts-recid   */
          ) no-error .
        if error-status :error
        then do:
          message
            vss-workfile vss-revision vss-description skip
            "Ошибка при вызове partrsrv" skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
          return return-value .
        end.

        assign
          p-chg-qnty      = p-chg-qnty      - abs(v-real-chg-qnty) * v-chg-qnty-sign
          p-real-chg-qnty = p-real-chg-qnty + abs(v-real-chg-qnty) * v-chg-qnty-sign
        .
      end.
    end.

    if p-chg-qnty = 0
    then do:
      return . /* --->>>--- */
    end.

    if v-chg-qnty-sign < 0
    then do:
      /* это было уменьшение резервов */
      if p-chg-qnty <> 0
      then do:
  /*      message*/
  /*        vss-workfile vss-revision vss-description skip*/
  /*        "Документ" buf_doc-line.doc-code skip*/
  /*        "Артикул" buf_doc-line.artic buf_doc-line.prod-type buf_doc-line.prod-code skip*/
  /*        "Нельзя списать" p-chg-qnty skip*/
  /*        view-as alert-box.*/
  /*      undo, return error return-value .*/
      end.
    end.

    /* создание порожденной партии */
    if  p-chg-qnty <> 0
    and p-reserv-single-part = false
    and p-purch-code-list    = '':u
    then do:
      run rsrv-negative in this-procedure
        (input  parparentproc
        ,input  p-db-num
        ,input  p-user-id
        ,buffer buf_doc-line            /* buf_doc-line           */
        ,buffer buf_trn-doc             /* buf_trn-doc            */
        ,input  p-chg-qnty              /* p-chg-qnty             */
        ,input  p-reserv-base           /* p-reserv-base          */
        ,input  p-reserv-rubl           /* p-reserv-rubl          */
        ,input  p-partscr-prompt-price  /* p-partscr-prompt-price */
        ,output v-real-chg-qnty         /* p-real-rsrv-qnty       */
        ) no-error .
      if error-status :error
      then do:
        if error-status :get-message(1) <> '':U
        then do:
          message
            vss-workfile vss-revision vss-description skip
            "Ошибка при вызове процедуры rsrv-negative" skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
        end.
        undo, return error return-value .
      end.
      assign
        p-chg-qnty      = p-chg-qnty      - abs(v-real-chg-qnty) * v-chg-qnty-sign
        p-real-chg-qnty = p-real-chg-qnty + abs(v-real-chg-qnty) * v-chg-qnty-sign
      .
      if  v-real-chg-qnty <> p-chg-qnty
      and return-value <> '':U
      then do:
        return return-value .
      end.
    end.
  end.

  return .

end procedure.



procedure rsrv-negative :
  define input parameter  parparentproc         AS WIDGET-HANDLE NO-UNDO.
  define input  parameter p-db-num               as integer   no-undo .
  define input  parameter p-user-id              as character no-undo .
  define parameter buffer buf_doc-line           for ub.doc-line .
  define parameter buffer buf_trn-doc            for ub.trn-doc  .
  define input parameter  p-chg-qnty             as decimal   no-undo .
  define input parameter  p-reserv-base          as decimal   no-undo .
  define input parameter  p-reserv-rubl          as decimal   no-undo .
  define input parameter  p-partscr-prompt-price as character no-undo .
  define output parameter p-real-rsrv-qnty       as decimal   no-undo .

  define buffer buf_parts for ub.parts .

  define variable v-vat-type  as character no-undo .
  define variable v-vat-pc    as decimal   no-undo .
  define variable v-slt-type  as character no-undo .
  define variable v-slt-pc    as decimal   no-undo .
  define variable v-is-hold-doc as logical no-undo .

  do
  on error undo, return error return-value
  :
    run partscr_get-default-values in this-procedure
      (buffer buf_doc-line /* buf_doc-line */
      ,output v-vat-type   /* p-vat-type   */
      ,output v-vat-pc     /* p-vat-pc     */
      ,output v-slt-type   /* p-slt-type   */
      ,output v-slt-pc     /* p-slt-pc     */
      ) .

    run partscr in this-procedure
      (input  parparentproc
      ,input  p-db-num
      ,input  p-user-id
      ,input  { trg/partsprm.i "supp-type" "buf_trn-doc." } /* p-supp-type        */
      ,input  { trg/partsprm.i "supp-code" "buf_trn-doc." } /* p-supp-code        */
      ,input  '':U                   /* p-part-code        */
      ,input  '':U                   /* p-cst-code         */
      ,input  '':U                   /* p-ps               */
      ,input  '':U                   /* p-dop               */
      ,input  p-reserv-base          /* v-part-reserv-base */
      ,input  p-reserv-rubl          /* v-part-reserv-rubl */
      ,input  v-vat-type             /* p-vat-type         */
      ,input  v-vat-pc               /* p-vat-pc           */
      ,input  v-slt-type             /* p-slt-type         */
      ,input  v-slt-pc               /* p-slt-pc           */
      ,input  p-chg-qnty             /* chg-qnty           */
      ,input  p-partscr-prompt-price /* p-prompt-price     */
      ,input  0                      /* p-cli-qnty         */
      ,input  ?                      /* p-last-date        */
      ,input  ?                      /* p-hold-date        */
      ,input  0                      /* складское место    */
      ,buffer buf_doc-line           /* buf_doc-line       */
      ,buffer buf_parts              /* buf_parts          */
      ) no-error .
    if error-status :error
    then do:
      if error-status :get-message(1) <> '':U
      then do:
        message
          vss-workfile vss-revision vss-description skip
          "Ошибка при создании партии" skip
          "Документ" buf_doc-line.doc-code skip
          "Артикул" buf_doc-line.artic buf_doc-line.prod-type buf_doc-line.prod-code skip
          error-status :get-message(1) skip
          return-value skip
          view-as alert-box error .
      end.
      undo, return error return-value .
    end.

    if not available buf_parts
    and return-value <> '':U
    then do:
      return return-value .
    end.

    { gbl/hold-doc.i buf_trn-doc.doc-code v-is-hold-doc }
    if v-is-hold-doc
    and buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh}
    then do:
      assign
        buf_parts.contract-code = 0
      .
    end.

    assign
      p-real-rsrv-qnty = p-chg-qnty
    .
  end.

end procedure.


procedure unrsrv-negative :

  define parameter buffer buf_doc-line for ub.doc-line .
  define input  parameter p-chg-qnty      as decimal no-undo .
  define output parameter p-real-chg-qnty as decimal no-undo .

  define variable v-part-chg-qnty as decimal no-undo .

  define buffer buf_parts for ub.parts .

  do
  on error undo, return error return-value
  :
    /* снимаем резерв по всем порожденным партиям */
    for each buf_parts
      where buf_parts.in-code   = buf_doc-line.doc-code
        and buf_parts.out-code  = buf_doc-line.doc-code
        and buf_parts.obj-code  = buf_doc-line.obj-code
        and buf_parts.obj-type  = buf_doc-line.obj-type
        and buf_parts.artic     = buf_doc-line.artic
        and buf_parts.prod-type = buf_doc-line.prod-type
        and buf_parts.prod-code = buf_doc-line.prod-code
    on error undo, return error return-value
    :

      assign
        v-part-chg-qnty = 0
      .
      if buf_parts.fact-qnty > 0
      and p-chg-qnty < 0
      then do:
        assign
          v-part-chg-qnty = - min(abs(buf_parts.qnty), abs(p-chg-qnty))
        .
      end.

      if buf_parts.fact-qnty < 0
      and p-chg-qnty > 0
      then do:
        assign
          v-part-chg-qnty = min(abs(buf_parts.qnty), abs(p-chg-qnty))
        .
      end.
      if v-part-chg-qnty = 0
      then do:
        next .
      end.

      if p-chg-qnty = 0
      then do:
        return .
      end.

      assign
        p-chg-qnty          = p-chg-qnty          - v-part-chg-qnty
        p-real-chg-qnty     = p-real-chg-qnty     + v-part-chg-qnty
        buf_parts.qnty      = buf_parts.qnty      + v-part-chg-qnty
        buf_parts.fact-qnty = buf_parts.fact-qnty + v-part-chg-qnty
      .
    end.
  end.

end procedure.

/*Процедура извличения алкокода из акцизной марки и перевод в 10 систему*/
PROCEDURE ProcAlcCode :
  define input  parameter p-mark-alc as character  no-undo .
  define output parameter p-alc-code as character  no-undo initial ''.
  define variable v-kol              as integer    no-undo .
  define variable alc-code as character no-undo .
  define variable v-result as character no-undo .
  define variable ii as integer no-undo .  

  alc-code = SUBSTRing (p-mark-alc, 8, 12) .
  p-alc-code = string (Base2Int64 (alc-code, 36) ) no-error.
  if (Base2Int64 (alc-code, 36) ) < 0 then 
  do:
    p-alc-code = ?.
  end.
  else 
  do:
    if length(p-alc-code) < 20 then 
    do:
      p-alc-code = fill('0', 19 - length(p-alc-code)) + p-alc-code.
    end.  
  end.
  
    
END PROCEDURE.

/* $Workfile$   E n d */