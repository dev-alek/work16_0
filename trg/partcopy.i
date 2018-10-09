/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Копирование партии из одной зоны в другую

Автор: Чернова Светлана Александровна
Дата создания: 02/14/07
Author: Svetlana Chernova
Creation date: 02/14/07

create: Перваков Михаил Сергеевич
Дата создания: 04/26/01

p-free-output-copy  false  копирование партии в документ, в свободную, расходную зону
                           резервирование товара
                    true   копирование партии в свободную, расходную зону
                           закрытие документа до статуса {&fact}
*/
{ str/marks.i }

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

procedure partcopy :

  define input parameter  p-free-output-copy as logical   no-undo .
  define input parameter  p-out-code         like ub.parts.out-code no-undo .
  define parameter buffer buf_orig_parts     for ub.parts .
  define parameter buffer buf_parts          for ub.parts .

  define variable vss-description as character no-undo init "partcopy-01: процедура копирования партии".
  
  define variable v-value-character as character no-undo .
  define variable v-value-date      as date no-undo .
  define variable v-value-decimal   as decimal no-undo .
  define variable v-value-integer   as integer no-undo .
  define variable v-izlcstpr        as logical no-undo .
  define variable v-tth             as handle no-undo .
  define variable v-type            as character no-undo .
  
  define variable part-key-rec      as character no-undo .
  define variable orig-part-key-rec as character no-undo .
  
  define buffer buf_gen-attr for ub.gen-attr .

  /* процедура создания партии в свободной или расходной зоне */
  do
  on error undo, return error return-value
  :
    if p-free-output-copy = true
    then do:
      if  p-out-code <> {&free-code}
      and p-out-code <> {&output-code}
      then do:
        message
          vss-workfile vss-revision vss-description skip
          vss-include-info{&vssseq} skip
          "Ошибка задания входных параметров процедуры partcopy" skip
          "p-free-output-copy" p-free-output-copy skip
          "p-out-code" p-out-code skip
          view-as alert-box error .
        undo, return error .
      end.
    end.


    if buf_orig_parts.out-code <> p-out-code
    then do:
      /* ищем партию и создаем партию, если ее нет */
      find first buf_parts exclusive-lock
        where buf_parts.obj-type  = buf_orig_parts.obj-type
          and buf_parts.obj-code  = buf_orig_parts.obj-code
          and buf_parts.artic     = buf_orig_parts.artic
          and buf_parts.prod-type = buf_orig_parts.prod-type
          and buf_parts.prod-code = buf_orig_parts.prod-code
          and buf_parts.in-code   = buf_orig_parts.in-code
          and buf_parts.out-code  = p-out-code
          and buf_parts.part-code = buf_orig_parts.part-code
        no-error.
      if not available buf_parts
      then do:
        define variable v-rsrv-free as logical   no-undo .

        if p-out-code = {&free-code}
        or p-out-code = {&output-code}
        then do:
          assign
            v-rsrv-free = { trg/partsprm.i "rsrv-free" "p-out-code" }
          .
        end.
        else do:
          /* в случае создания партии документа */
          /* за поле rsrv-free отвечает вызывающая программа */
          assign
            v-rsrv-free = ?
          .
        end.

        create buf_parts .
        buffer-copy buf_orig_parts to buf_parts
        assign
          buf_parts.out-code  = p-out-code
          buf_parts.status_   = no
          buf_parts.rsrv-free = v-rsrv-free
          buf_parts.qnty      = 0
          buf_parts.fact-qnty = 0
          buf_parts.real-qnty = 0
          buf_parts.cli-qnty  = 0
        .
        
        run gen-key-rec IN THIS-PROCEDURE (  input {&table_parts}
                                        ,input (buffer buf_orig_parts:handle)
                                        ,output orig-part-key-rec).
        run gen-key-rec IN THIS-PROCEDURE (  input {&table_parts}
                                        ,input (buffer buf_parts:handle)
                                        ,output part-key-rec).                                
        for each ub.gen-attr no-lock where ub.gen-attr.table-name = {&excise-mark}
                                       and ub.gen-attr.p-key =  orig-part-key-rec :
            create buf_gen-attr .
            buffer-copy ub.gen-attr to buf_gen-attr
            assign
                buf_gen-attr.p-key = part-key-rec
                buf_gen-attr.whole-send-news = 0
            .                                
        end.

        /* сделаем партию доступной для поиска через первичный индекс */
        /* todo - возможно это не нужно, так как блок выделен в отдельную процедуру */
        validate buf_parts .
      end.
    end.
    else do:
      find first buf_parts exclusive-lock
        where recid(buf_parts) = recid(buf_orig_parts)
        .
    end.

    if p-out-code = {&free-code}
    or p-out-code = {&output-code}
    then do:
      if buf_parts.rsrv-free <> { trg/partsprm.i "rsrv-free" "buf_parts.out-code" }
      then do:
        message
          vss-workfile vss-revision vss-description skip
          vss-include-info{&vssseq} skip
          "Ошибка типа резерва партии" skip
          "Объект" buf_parts.obj-type buf_parts.obj-code  skip
          "Артикул" buf_parts.artic buf_parts.prod-type buf_parts.prod-code skip
          "Партия" buf_parts.in-code buf_parts.part-code skip
          "Резерв" buf_parts.out-code skip
          "Статус" buf_parts.status_ skip
          "Тип резерва" buf_parts.rsrv-free skip
          view-as alert-box error .
        undo, return error .
      end.
    end.
  end.

end procedure. /* partcopy */


procedure partcopy-update-parts :

  define input  parameter p-doc-code  like ub.doc-line.doc-code  no-undo .
  define input  parameter p-obj-type  like ub.doc-line.obj-type  no-undo .
  define input  parameter p-obj-code  like ub.doc-line.obj-code  no-undo .
  define input  parameter p-artic     like ub.doc-line.artic     no-undo .
  define input  parameter p-prod-type like ub.doc-line.prod-type no-undo .
  define input  parameter p-prod-code like ub.doc-line.prod-code no-undo .

  define variable vss-description as character no-undo init "partcopy-update-parts-01: процедура обработки партий при закрытии документа".

  define buffer buf_trn-doc for ub.trn-doc .
  define buffer archive_parts for ub.parts .
  define buffer buf_parts   for ub.parts .

  define variable v-rsrv-code     as character no-undo .
  define variable v-goods-twounit as logical   no-undo .
  
  define variable v-value-character as character no-undo .
  define variable v-value-date      as date no-undo .
  define variable v-value-decimal   as decimal no-undo .
  define variable v-value-integer   as integer no-undo .
  define variable v-izlcstpr        as logical no-undo .
  define variable v-tth             as handle no-undo .
  define variable v-type            as character no-undo .
  
  define variable v-exch-rate  like ub.curr-accnt.exch-rate no-undo .
  define variable v-exch-scale like ub.curr-accnt.exch-scale no-undo .

  do
  on error undo, return error return-value
  :
    find first buf_trn-doc no-lock
      where buf_trn-doc.doc-code = p-doc-code
      no-error .
    if not available buf_trn-doc
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка задания входных параметров" skip
        "Не найден документ" skip
        "Документ" p-doc-code skip
        "Объект" p-obj-type p-obj-code skip
        "Артикул" p-artic p-prod-type p-prod-code skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.
    
    if buf_trn-doc.ext-doc-type = {&TDEDT_inv}
    then do :
        delete object v-tth no-error.
        run adm/shattri.p (
           input "get":U
          ,input buf_trn-doc.obj-type
          ,input buf_trn-doc.obj-code
          ,input {&attr-inv-obj}
          ,input  "izlcstpr"
          ,output v-value-character
          ,output v-value-date
          ,output v-value-decimal
          ,output v-value-integer
          ,output v-izlcstpr
          ,output v-type
          ,INPUT-OUTPUT table-handle v-tth
          ) no-error .
          delete object v-tth no-error.      
        if error-status:error then do:
          message "Ошибка при получение параметра izlcstpr"
          view-as alert-box.
          return error.
        end. 
    end.
    else do :
        v-izlcstpr = false .
    end.

    /* определяется, что товар учитывается в двух единицах измерения */
    { gbl/gdsat.i
      p-artic
      p-prod-type
      p-prod-code
      "'twounit=request':u"
      v-goods-twounit
      no-error
    }
    if error-status :error
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка при определении атрибута товара" skip
        "Артикул" p-artic p-prod-type p-prod-code skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.

    define query partcopy-select-parts for archive_parts .

    open query partcopy-select-parts preselect each archive_parts
      where archive_parts.obj-type  = p-obj-type
        and archive_parts.obj-code  = p-obj-code
        and archive_parts.artic     = p-artic
        and archive_parts.prod-type = p-prod-type
        and archive_parts.prod-code = p-prod-code
        and archive_parts.out-code  = p-doc-code
      .

    get first partcopy-select-parts .
    if buf_trn-doc.doc-type = {&income}
    then do:

      /* Создание партий в свободной зоне */
      do while available archive_parts
      on error undo, return error return-value
      :
        /* !!! внимание здесь условие сформулировано в обратном порядке */
        if can-do({&expense_write-off}, buf_trn-doc.doc-type)
        or (buf_trn-doc.doc-type = {&inventory}
            and archive_parts.fact-qnty < 0)
        then do:
          assign
            v-rsrv-code = {&output-code}
          .
        end.
        else do:
          assign
            v-rsrv-code = {&free-code}
          .
        end.

        /* дополнительная гарантия того, что каждая партия будет рассмотрена
          только один раз
        */
        assign
          archive_parts.status_   = yes
          archive_parts.rsrv-free = ?
        .

        if archive_parts.in-code = p-doc-code
        then do:
          /* если партии были порождены данным документом,
             то надо записать дату и fact-num
           */
          assign
            archive_parts.fact-num  = buf_trn-doc.fact-num
            archive_parts.fact-date = buf_trn-doc.fact-date
            archive_parts.doc-type  = buf_trn-doc.doc-type
          .
        end.

        if archive_parts.fact-qnty <> 0
        then do:
          run partcopy in this-procedure
            (input  true      /* p-free-output-copy */
            ,input  v-rsrv-code /* p-out-code         */
            ,buffer archive_parts  /* buf_orig_parts     */
            ,buffer buf_parts /* buf_parts          */
            ) no-error .
          if error-status :error
          then do:
            message
              vss-workfile vss-revision vss-description skip
              vss-include-info{&vssseq} skip
              "Ошибка при создании партии" skip
              "Документ" p-doc-code skip
              "Объект" p-obj-type p-obj-code skip
              "Артикул" p-artic p-prod-type p-prod-code skip
              "Партия" archive_parts.in-code archive_parts.part-code skip
              "Резерв" v-rsrv-code skip
              error-status :get-message(1) skip
              return-value skip
              view-as alert-box error .
            undo, return error .
          end.
          assign
            buf_parts.qnty      = buf_parts.qnty     + archive_parts.fact-qnty
            buf_parts.fact-qnty = buf_parts.qnty
          .

          if v-goods-twounit = true
          then do:
            assign
              buf_parts.cli-qnty = buf_parts.cli-qnty + archive_parts.cli-qnty
            .

            case buf_trn-doc.ext-doc-type :
              when {&TDEDT_Pri_Vnesh}
              then do:
                /* клиентское количество может быть любым целым */
                if archive_parts.cli-qnty <> truncate(archive_parts.cli-qnty, 0 )
                then do:
                  message
                    vss-workfile vss-revision vss-description skip
                    vss-include-info{&vssseq} skip
                    "Клиентское количество для товара," skip
                    "который учитывается по двум единицам измерения" skip
                    "должно равняться единице" skip
                    "Документ" p-doc-code skip
                    "Объект" p-obj-type p-obj-code skip
                    "Артикул" p-artic p-prod-type p-prod-code skip
                    "Партия" archive_parts.in-code archive_parts.part-code skip
                    "Количество по документу" archive_parts.qnty skip
                    "Фактическое количество" archive_parts.fact-qnty skip
                    "Клиентское количество" archive_parts.cli-qnty skip
                    view-as alert-box error .
                  undo, return error .
                end.
              end.
              when {&TDEDT_Pri_Perem}
              then do:
                /* клиентское количество может быть любым */
                if archive_parts.cli-qnty <> 1
                then do:
                  message
                    vss-workfile vss-revision vss-description skip
                    vss-include-info{&vssseq} skip
                    "Клиентское количество для товара," skip
                    "который учитывается по двум единицам измерения" skip
                    "должно равняться единице" skip
                    "Документ" p-doc-code skip
                    "Объект" p-obj-type p-obj-code skip
                    "Артикул" p-artic p-prod-type p-prod-code skip
                    "Партия" archive_parts.in-code archive_parts.part-code skip
                    "Количество по документу" archive_parts.qnty skip
                    "Фактическое количество" archive_parts.fact-qnty skip
                    "Клиентское количество" archive_parts.cli-qnty skip
                    view-as alert-box error .
                  undo, return error .
                end.
              end.
              otherwise do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Товар учитывается по двум единицам измерения" skip
                  "Для приходов разрешен только внешний приход или приход перемещение" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type archive_parts.prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Количество по документу" archive_parts.qnty skip
                  "Фактическое количество" archive_parts.fact-qnty skip
                  "Клиентское количество" archive_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
            end.
          end.
          else do:
            if buf_parts.cli-base-rate <> 0
            then do:
              assign
                buf_parts.cli-qnty = buf_parts.fact-qnty / buf_parts.cli-base-rate
              .
            end.
            else do:
              assign
                buf_parts.cli-qnty = 0
              .
            end.
          end.

          if  buf_parts.qnty      = 0
          and buf_parts.fact-qnty = 0
          then do:
            if v-goods-twounit = true
            then do:
              if buf_parts.cli-qnty <> 0
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Ошибка при удалении партии" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" buf_parts.in-code buf_parts.part-code skip
                  "Резерв" buf_parts.out-code skip
                  "qnty" buf_parts.qnty skip
                  "fact-qnty" buf_parts.fact-qnty skip
                  "cli-qnty" buf_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
            end.
            delete buf_parts .
          end.
        end. /* if fact-qnty > 0 */

        get next partcopy-select-parts .
      end.
    end.

    /************* РАСХОД, СПИСАНИЕ, ВОЗВРАТ, ИНВЕНТАРИЗАЦИЯ **************/
    if buf_trn-doc.doc-type = {&expense}
    or buf_trn-doc.doc-type = {&write-off}
    or buf_trn-doc.doc-type = {&return}
    or buf_trn-doc.doc-type = {&inventory}
    then do:

      /* создание партий в свободных и расходных зонах */
      do while available archive_parts
      on error undo, return error return-value
      :
        /* меняем статус партий на архивный */
        assign
          archive_parts.status_   = yes
          archive_parts.rsrv-free = ?
        .

        /*
          Если фактическое количество не совпадает с количеством по документу
          то лишнее (недостающее количество) переводится в соответствующую зону
        */

        if archive_parts.fact-qnty <> archive_parts.qnty
        then do:
          define variable v-is-hold as logical   no-undo .
          { gbl/hold-doc.i
            buf_trn-doc.doc-code
            v-is-hold
            no-error
          }
          if error-status :error
          then do:
            message
              vss-workfile vss-revision vss-description skip
              vss-include-info{&vssseq}
              "Ошибка при определении типа документа hold-doc.i" skip
              "Документ" p-doc-code skip
              "Объект" p-obj-type p-obj-code skip
              "Артикул" p-artic p-prod-type p-prod-code skip
              error-status :get-message(1) skip
              return-value skip
              view-as alert-box error .
            undo, return error .
          end.

          /* эта ситуация невозможна для документов  */
          /* инвентаризации */
          /* документа возвращата */
          /* и для порожденных партий */
          if buf_trn-doc.ext-doc-type = {&TDEDT_Inv}
          /*or buf_trn-doc.ext-doc-type = {&TDEDT_Vozvrat_Perem}*/
          or (buf_trn-doc.ext-doc-type = {&TDEDT_Vozvrat_Vnesh} and v-is-hold = true)
          or buf_trn-doc.ext-doc-type = {&TDEDT_Corr_Acc_Price}
          or buf_trn-doc.ext-doc-type = {&TDEDT_Chg_Purch_Code}
          or buf_trn-doc.ext-doc-type = {&TDEDT_Corr_Minus_Parts}
          or  buf_trn-doc.ext-doc-type = {&TDEDT_Peresort}
          then do:
            message
              vss-workfile vss-revision vss-description skip
              vss-include-info{&vssseq} skip
              "Фактическое количество не может отличаться от количества по документу" skip
              "для документов инвентаризации, внутреннего возврата и автоматического возврата между фирмами" skip
              "Документ" p-doc-code skip
              "Объект" p-obj-type p-obj-code skip
              "Артикул" p-artic p-prod-type p-prod-code skip
              "Партия" archive_parts.in-code archive_parts.part-code skip
              "Количество по документу" archive_parts.qnty skip
              "Фактическое количество" archive_parts.fact-qnty skip
              "Клиентское количество" archive_parts.cli-qnty skip
              view-as alert-box error .
            undo, return error .
          end.

          if archive_parts.in-code <> archive_parts.out-code
          then do:

            if can-do({&expense_write-off},buf_trn-doc.doc-type)
            or (buf_trn-doc.doc-type = {&inventory}
                and archive_parts.fact-qnty < 0)
            then do:
              assign
                v-rsrv-code = {&free-code}
              .
            end.
            else do:
              assign
                v-rsrv-code = {&output-code}
              .
            end.
            run partcopy in this-procedure
              (input  true      /* p-free-output-copy */
              ,input  v-rsrv-code /* p-out-code         */
              ,buffer archive_parts  /* buf_orig_parts     */
              ,buffer buf_parts /* buf_parts          */
              ) no-error .
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при создании партии" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Резерв" v-rsrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            assign
              buf_parts.qnty      = buf_parts.qnty + (archive_parts.qnty - archive_parts.fact-qnty)
              buf_parts.fact-qnty = buf_parts.qnty
            .

            if v-goods-twounit = true
            then do:
              if archive_parts.cli-qnty <> 1
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Клиентское количество для товара," skip
                  "который учитывается по двум единицам измерения" skip
                  "должно равняться единице" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Количество по документу" archive_parts.qnty skip
                  "Фактическое количество" archive_parts.fact-qnty skip
                  "Клиентское количество" archive_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
              if archive_parts.fact-qnty = 0
              then do:
                assign
                  buf_parts.cli-qnty = buf_parts.cli-qnty + archive_parts.cli-qnty
                .
              end.
              else do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Фактическое количество для товара," skip
                  "который учитывается по двум единицам измерения" skip
                  "должно равняться нулю или количеству по документу" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Количество по документу" archive_parts.qnty skip
                  "Фактическое количество" archive_parts.fact-qnty skip
                  "Клиентское количество" archive_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
            end.
            else do:
              if buf_parts.cli-base-rate <> 0
              then do:
                assign
                  buf_parts.cli-qnty = buf_parts.fact-qnty / buf_parts.cli-base-rate
                .
              end.
              else do:
                assign
                  buf_parts.cli-qnty = 0
                .
              end.
            end.
          end.

          if  available buf_parts
          and buf_parts.qnty      = 0
          and buf_parts.fact-qnty = 0
          then do:
            if v-goods-twounit = true
            then do:
              if buf_parts.cli-qnty <> 0
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Ошибка при удалении партии" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" buf_parts.in-code buf_parts.part-code skip
                  "Резерв" buf_parts.out-code skip
                  "qnty" buf_parts.qnty skip
                  "fact-qnty" buf_parts.fact-qnty skip
                  "cli-qnty" buf_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
            end.
            delete buf_parts .
          end.
        end.
        /* создаем партии в расходной (свободной) зоне */
        /* не создаем партии в расходной зоне для некоторых типов документов */
        /* todo - переделать условия на единую функцию partcond.i */
        /* todo - объединить данный код с кодом для приходной накладной */
        /* todo - объединить данный код с кодом для удаления документа */

        if archive_parts.in-code = buf_trn-doc.doc-code
        then do:
          /* если партии были порождены данным документом,
              то надо записать дату и fact-num
          */
          assign
            archive_parts.fact-num  = buf_trn-doc.fact-num
            archive_parts.fact-date = buf_trn-doc.fact-date
            archive_parts.doc-type  = buf_trn-doc.doc-type
          .
        end.

        if archive_parts.fact-qnty <> 0
        then do:
          /* !!! внимание здесь условие сформулировано в обратном порядке */
          if can-do({&expense_write-off}, buf_trn-doc.doc-type)
          or (buf_trn-doc.doc-type = {&inventory}
              and archive_parts.fact-qnty < 0
            )
          then do:
            { gbl/hold-doc.i
              buf_trn-doc.doc-code
              v-is-hold
              no-error
            }
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq}
                "Ошибка при определении типа документа hold-doc.i" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            assign
              v-rsrv-code = {&output-code}
            .
            if buf_trn-doc.ext-doc-type  = {&TDEDT_Ras_Vnesh_VP}
            /* or buf_trn-doc.ext-doc-type  = {&TDEDT_Ras_Perem} */
            /* or (buf_trn-doc.ext-doc-type = {&TDEDT_Ras_Vnesh} and v-is-hold = true) */
            or (buf_trn-doc.ext-doc-type = {&TDEDT_Corr_Acc_Price} )
            or (buf_trn-doc.ext-doc-type = {&TDEDT_Chg_Purch_Code} )
            then do:
              /* для внутреннего расхода parts перетекут в своб. зону другого объекта,
                за исключением тех которые вернутся  с возвратной накладной */
              /* для остальных документов партия в расходной зоне не должна создаваться */
              assign
                v-rsrv-code = ""
              .
            end.
          end.
          else do:
            assign
              v-rsrv-code = {&free-code}
            .
          end.

          if v-rsrv-code <> ""
          then do:
            run partcopy in this-procedure
              (input  true      /* p-free-output-copy */
              ,input  v-rsrv-code /* p-out-code         */
              ,buffer archive_parts  /* buf_orig_parts     */
              ,buffer buf_parts /* buf_parts          */
              ) no-error .
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при создании партии" skip
                "Документ" buf_trn-doc.doc-code skip
                "Объект" archive_parts.obj-type archive_parts.obj-code skip
                "Артикул" archive_parts.artic archive_parts.prod-type archive_parts.prod-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Резерв" v-rsrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            /* здесь используется abs, так как в партиях документа инвентаризации */
            /* возможен знак минус */
            assign
              buf_parts.qnty      = buf_parts.qnty + abs(archive_parts.fact-qnty)
              buf_parts.fact-qnty = buf_parts.qnty
            .

            if v-goods-twounit = true
            then do:
              define variable v-qnty-sign as integer   no-undo .
              assign
                v-qnty-sign = 1
              .
              if  buf_trn-doc.doc-type = {&inventory}
              and archive_parts.fact-qnty < 0
              then do:
                assign
                  v-qnty-sign = - 1
                .
              end.
              if archive_parts.cli-qnty <> v-qnty-sign
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Клиентское количество для товара," skip
                  "который учитывается по двум единицам измерения" skip
                  "должно равняться" v-qnty-sign skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Количество по документу" archive_parts.qnty skip
                  "Фактическое количество" archive_parts.fact-qnty skip
                  "Клиентское количество" archive_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
              if archive_parts.fact-qnty = archive_parts.qnty
              then do:
                /* здесь используется abs, так как в партиях документа инвентаризации */
                /* возможен знак минус */
                assign
                  buf_parts.cli-qnty = buf_parts.cli-qnty + abs(archive_parts.cli-qnty)
                .
              end.
              else do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Фактическое количество для товара," skip
                  "который учитывается по двум единицам измерения" skip
                  "должно равняться нулю или количеству по документу" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Количество по документу" archive_parts.qnty skip
                  "Фактическое количество" archive_parts.fact-qnty skip
                  "Клиентское количество" archive_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
            end.
            else do:
              if buf_parts.cli-base-rate <> 0
              then do:
                assign
                  buf_parts.cli-qnty = buf_parts.fact-qnty / buf_parts.cli-base-rate
                .
              end.
              else do:
                assign
                  buf_parts.cli-qnty = 0
                .
              end.
            end.

            if  buf_parts.qnty      = 0
            and buf_parts.fact-qnty = 0
            then do:
              if v-goods-twounit = true
              then do:
                if buf_parts.cli-qnty <> 0
                then do:
                  message
                    vss-workfile vss-revision vss-description skip
                    vss-include-info{&vssseq} skip
                    "Ошибка при удалении партии" skip
                    "Документ" p-doc-code skip
                    "Объект" p-obj-type p-obj-code skip
                    "Артикул" p-artic p-prod-type p-prod-code skip
                    "Партия" buf_parts.in-code buf_parts.part-code skip
                    "Резерв" buf_parts.out-code skip
                    "qnty" buf_parts.qnty skip
                    "fact-qnty" buf_parts.fact-qnty skip
                    "cli-qnty" buf_parts.cli-qnty skip
                    view-as alert-box error .
                  undo, return error .
                end.
              end.
              delete buf_parts .
            end.
          end.
        end.

        if  ( archive_parts.in-code = buf_trn-doc.doc-code
        and archive_parts.supp-type = { trg/partsprm.i "supp-type" "buf_trn-doc." }
        and archive_parts.supp-code = { trg/partsprm.i "supp-code" "buf_trn-doc." }
        )
        or buf_trn-doc.ext-doc-type = {&tdedt_vozvrat_perem}
        then do:
          /* партии были порождены данным документом
            и это не партии старого возврата
            , создание соответствующей отрицательной партии
            в свободной или расходной зонах
          */
          if can-do({&expense_write-off},buf_trn-doc.doc-type)
          or (buf_trn-doc.doc-type = {&inventory}
              and archive_parts.fact-qnty < 0
            )
          then do:
            assign
              v-rsrv-code = {&free-code}
            .
          end.
          else do:
            assign
              v-rsrv-code = {&output-code}
            .
          end.
          
          if not v-izlcstpr
          then do :
              run partcopy in this-procedure
                (input  true      /* p-free-output-copy */
                ,input  v-rsrv-code /* p-out-code         */
                ,buffer archive_parts  /* buf_orig_parts     */
                ,buffer buf_parts /* buf_parts          */
                ) no-error .
              if error-status :error
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Ошибка при создании партии" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Резерв" v-rsrv-code skip
                  error-status :get-message(1) skip
                  return-value skip
                  view-as alert-box error .
                undo, return error .
              end.
    
              /* количества у порожденной партии должны быть отрицательными
                независимо от количества, хранящегося в архивной партии
              */
              assign
                buf_parts.qnty      = buf_parts.qnty - abs(archive_parts.fact-qnty)
                buf_parts.fact-qnty = buf_parts.qnty
              .
              if v-goods-twounit = true
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Запрещено порождение партий," skip
                  "который учитывается по двум единицам измерения" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Количество по документу" archive_parts.qnty skip
                  "Фактическое количество" archive_parts.fact-qnty skip
                  "Клиентское количество" archive_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
              else do:
                if buf_parts.cli-base-rate <> 0
                then do:
                  assign
                    buf_parts.cli-qnty = buf_parts.fact-qnty / buf_parts.cli-base-rate
                  .
                end.
                else do:
                  assign
                    buf_parts.cli-qnty = 0
                  .
                end.
              end.
          end.
        end.

        get next partcopy-select-parts .
      end. /* do while */
    end.
  end.

end procedure. /* partcopy-update-parts */




procedure partcopy-update-parts-delete :

  define input  parameter p-doc-code  like ub.doc-line.doc-code  no-undo .
  define input  parameter p-obj-type  like ub.doc-line.obj-type  no-undo .
  define input  parameter p-obj-code  like ub.doc-line.obj-code  no-undo .
  define input  parameter p-artic     like ub.doc-line.artic     no-undo .
  define input  parameter p-prod-type like ub.doc-line.prod-type no-undo .
  define input  parameter p-prod-code like ub.doc-line.prod-code no-undo .

  define variable vss-description as character no-undo init "partcopy-update-parts-delete-01: процедура обработки партий при удалении документа".

  define buffer buf_trn-doc    for ub.trn-doc .
  define buffer archive_parts  for ub.parts .
  define buffer buf_parts      for ub.parts .
  define buffer buf_parts-attr for ub.parts-attr .

  define variable v-rsrv-code as character no-undo .
  define variable v-unrv-code as character no-undo .
  define variable v-need-rsrv as logical   no-undo .
  define variable v-need-unrv as logical   no-undo .
  define variable v-rsrv-sign as integer   no-undo .
  define variable v-unrv-sign as integer   no-undo .

  define variable v-goods-twounit as logical   no-undo .
  
  define variable v-value-character as character no-undo .
  define variable v-value-date      as date no-undo .
  define variable v-value-decimal   as decimal no-undo .
  define variable v-value-integer   as integer no-undo .
  define variable v-izlcstpr        as logical no-undo .
  define variable v-tth             as handle no-undo .
  define variable v-type            as character no-undo .
  
  define variable part-key-rec as character no-undo .

  do
  on error undo, return error return-value
  :
    find first buf_trn-doc no-lock
      where buf_trn-doc.doc-code = p-doc-code
      no-error .
    if not available buf_trn-doc
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка задания входных параметров" skip
        "Не найден документ" skip
        "Документ" p-doc-code skip
        "Объект" p-obj-type p-obj-code skip
        "Артикул" p-artic p-prod-type p-prod-code skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.
    
    if buf_trn-doc.ext-doc-type = {&TDEDT_inv}
    then do :
        delete object v-tth no-error.
        run adm/shattri.p (
           input "get":U
          ,input buf_trn-doc.obj-type
          ,input buf_trn-doc.obj-code
          ,input {&attr-inv-obj}
          ,input  "izlcstpr"
          ,output v-value-character
          ,output v-value-date
          ,output v-value-decimal
          ,output v-value-integer
          ,output v-izlcstpr
          ,output v-type
          ,INPUT-OUTPUT table-handle v-tth
          ) no-error .
          delete object v-tth no-error.      
        if error-status:error then do:
          message "Ошибка при получение параметра izlcstpr"
          view-as alert-box.
          return error.
        end. 
    end.
    else do :
        v-izlcstpr = false .
    end.

    /* определяется, что товар учитывается в двух единицах измерения */
    { gbl/gdsat.i
      p-artic
      p-prod-type
      p-prod-code
      "'twounit=request':u"
      v-goods-twounit
      no-error
    }
    if error-status :error
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка при определении атрибута товара" skip
        "Артикул" p-artic p-prod-type p-prod-code skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.

    /* Обработка партий удаляемого документа */
    for each archive_parts
      where archive_parts.obj-type  = p-obj-type
        and archive_parts.obj-code  = p-obj-code
        and archive_parts.artic     = p-artic
        and archive_parts.prod-type = p-prod-type
        and archive_parts.prod-code = p-prod-code
        and archive_parts.out-code  = p-doc-code
    on error undo, return error return-value
    :
      if archive_parts.fact-qnty <> 0
      then do:
        define variable v-create-part as logical   no-undo .
        define variable v-old-return  as logical   no-undo .
        assign
          v-create-part = false
          v-old-return  = false
        .
        if archive_parts.in-code = buf_trn-doc.doc-code
        then do:
          assign
            v-create-part = true
          .
          if archive_parts.supp-type <> { trg/partsprm.i "supp-type" "buf_trn-doc." }
          or archive_parts.supp-code <> { trg/partsprm.i "supp-code" "buf_trn-doc." }
          then do:
            assign
              v-old-return = true
            .
          end.
        end.

        define variable v-is-hold as logical   no-undo .
        { gbl/hold-doc.i
          buf_trn-doc.doc-code
          v-is-hold
          no-error
        }
        if error-status :error
        then do:
          message
            vss-workfile vss-revision vss-description skip
            vss-include-info{&vssseq}
            "Ошибка при определении типа документа hold-doc.i" skip
            "Документ" p-doc-code skip
            "Объект" p-obj-type p-obj-code skip
            "Артикул" p-artic p-prod-type p-prod-code skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
          undo, return error .
        end.

        { gbl/partcond.i
          buf_trn-doc.ext-doc-type
          v-is-hold
          archive_parts.fact-qnty
          v-create-part
          v-old-return
          v-rsrv-code
          v-unrv-code
          v-need-rsrv
          v-need-unrv
          v-rsrv-sign
          v-unrv-sign
          no-error
        }
        if error-status :error
        then do:
          message
            vss-workfile vss-revision vss-description skip
            vss-include-info{&vssseq}
            "Ошибка при определении параметров резервирования партии" skip
            "Документ" p-doc-code skip
            "Объект" p-obj-type p-obj-code skip
            "Артикул" p-artic p-prod-type p-prod-code skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
          undo, return error .
        end.
        
        if v-izlcstpr then v-need-unrv = false .

        if v-need-rsrv = true
        then do:
          release buf_parts no-error .
          if archive_parts.out-code <> v-rsrv-code and v-rsrv-sign = -1 and v-izlcstpr
          then do:              
              find first buf_parts exclusive-lock
                where buf_parts.obj-type  = archive_parts.obj-type
                  and buf_parts.obj-code  = archive_parts.obj-code
                  and buf_parts.artic     = archive_parts.artic
                  and buf_parts.prod-type = archive_parts.prod-type
                  and buf_parts.prod-code = archive_parts.prod-code
                  and buf_parts.in-code   = archive_parts.out-code
                  and buf_parts.out-code  = v-rsrv-code
                  and buf_parts.part-code = archive_parts.part-code
                no-error.
          end .      
          if not available  buf_parts
          then do :     
              run partcopy in this-procedure
                (input  true          /* p-free-output-copy */
                ,input  v-rsrv-code   /* p-out-code         */
                ,buffer archive_parts /* buf_orig_parts     */
                ,buffer buf_parts     /* buf_parts          */
                ) no-error .
              if error-status :error
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Ошибка при создании партии" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Необходимо резервировать" v-need-rsrv skip
                  "Резерв" v-rsrv-code skip
                  "Необходимо снятие резервов" v-need-unrv skip
                  "Снятие резервов" v-unrv-code skip
                  error-status :get-message(1) skip
                  return-value skip
                  view-as alert-box error .
                undo, return error .
              end.
          end.    

          if new(buf_parts)
          then do:
            /* если партия была создана на основании архивной партии, */
            /* то необходимо произвести поиск атрибута партии */
            /* и взять оттуда значения полей, */
            /* которые были присвоены при закрытии документа до статуса {&fact} */

            define variable v-gds-code as integer   no-undo .

            { gbl/gds-code.i
              p-artic
              p-prod-type
              p-prod-code
              v-gds-code
              no-error
            }
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при определении кода товара" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            find first buf_parts-attr no-lock
              where buf_parts-attr.in-code   = buf_parts.in-code
                and buf_parts-attr.gds-code  = v-gds-code
                and buf_parts-attr.part-code = buf_parts.part-code
              no-error .
            if not available buf_parts-attr
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Не найден атрибут партии" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Код товара" v-gds-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            define variable v-fact-num as integer   no-undo .
            define variable v-doc-type as character no-undo .

            run factord-to-fact-num in this-procedure
              (input  buf_parts-attr.fact-order
              ,output v-fact-num
              ) no-error .
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при определении порядкового номера партии" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Код товара" v-gds-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            { gbl/trnextdt.i
              buf_parts-attr.ext-doc-type
              v-doc-type
              no-error
            }
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при определении типа документа" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Код товара" v-gds-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            assign
              buf_parts.fact-date = buf_parts-attr.fact-date
              buf_parts.fact-num  = v-fact-num
              buf_parts.doc-type  = v-doc-type
            .
          end.

          assign
            buf_parts.qnty      = buf_parts.qnty  + v-rsrv-sign * archive_parts.fact-qnty
            buf_parts.fact-qnty = buf_parts.qnty
          .

          if v-goods-twounit = true
          then do:
            assign
              buf_parts.cli-qnty = buf_parts.cli-qnty + v-rsrv-sign * archive_parts.cli-qnty
            .
          end.
          else do:
            if buf_parts.cli-base-rate <> 0
            then do:
              assign
                buf_parts.cli-qnty = buf_parts.fact-qnty / buf_parts.cli-base-rate
              .
            end.
            else do:
              assign
                buf_parts.cli-qnty = 0
              .
            end.
          end.

          if  buf_parts.qnty      = 0
          and buf_parts.fact-qnty = 0
          then do:
            if v-goods-twounit = true
            then do:
              if buf_parts.cli-qnty <> 0
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Ошибка при удалении партии" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" buf_parts.in-code buf_parts.part-code skip
                  "Резерв" buf_parts.out-code skip
                  "qnty" buf_parts.qnty skip
                  "fact-qnty" buf_parts.fact-qnty skip
                  "cli-qnty" buf_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
            end.
            run gen-key-rec IN THIS-PROCEDURE (  input {&table_parts}
                                        ,input (buffer buf_parts:handle)
                                        ,output part-key-rec).
            for each ub.gen-attr where ub.gen-attr.table-name = {&excise-mark}
                                     and ub.gen-attr.p-key =  part-key-rec
            on error undo, return error substitute( "&1&2&3", vss-workfile, {&new-line}, return-value )
            :
                delete ub.gen-attr.
            end. 
            delete buf_parts .
          end.
        end.

        if v-need-unrv = true
        then do:
          release buf_parts no-error .
          if archive_parts.out-code <> v-unrv-code and v-unrv-sign = -1 and v-izlcstpr
          then do:              
              find first buf_parts exclusive-lock
                where buf_parts.obj-type  = archive_parts.obj-type
                  and buf_parts.obj-code  = archive_parts.obj-code
                  and buf_parts.artic     = archive_parts.artic
                  and buf_parts.prod-type = archive_parts.prod-type
                  and buf_parts.prod-code = archive_parts.prod-code
                  and buf_parts.in-code   = archive_parts.out-code
                  and buf_parts.out-code  = v-unrv-code
                  and buf_parts.part-code = archive_parts.part-code
                no-error.
          end .      
          if not available  buf_parts
          then do :
              run partcopy in this-procedure
                (input  true          /* p-free-output-copy */
                ,input  v-unrv-code   /* p-out-code         */
                ,buffer archive_parts /* buf_orig_parts     */
                ,buffer buf_parts     /* buf_parts          */
                ) no-error .
              if error-status :error
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Ошибка при создании партии" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" archive_parts.in-code archive_parts.part-code skip
                  "Необходимо резервировать" v-need-rsrv skip
                  "Резерв" v-rsrv-code skip
                  "Необходимо снятие резервов" v-need-unrv skip
                  "Снятие резервов" v-unrv-code skip
                  error-status :get-message(1) skip
                  return-value skip
                  view-as alert-box error .
                undo, return error .
              end.
          end.

          if new(buf_parts)
          then do:
            /* если партия была создана на основании архивной партии, */
            /* то необходимо произвести поиск атрибута партии */
            /* и взять оттуда значения полей, */
            /* которые были присвоены при закрытии документа до статуса {&fact} */

            { gbl/gds-code.i
              p-artic
              p-prod-type
              p-prod-code
              v-gds-code
              no-error
            }
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при определении кода товара" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            find first buf_parts-attr no-lock
              where buf_parts-attr.in-code   = buf_parts.in-code
                and buf_parts-attr.gds-code  = v-gds-code
                and buf_parts-attr.part-code = buf_parts.part-code
              no-error .
            if not available buf_parts-attr
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Не найден атрибут партии" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Код товара" v-gds-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            run factord-to-fact-num in this-procedure
              (input  buf_parts-attr.fact-order
              ,output v-fact-num
              ) no-error .
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при определении порядкового номера партии" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Код товара" v-gds-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            { gbl/trnextdt.i
              buf_parts-attr.ext-doc-type
              v-doc-type
              no-error
            }
            if error-status :error
            then do:
              message
                vss-workfile vss-revision vss-description skip
                vss-include-info{&vssseq} skip
                "Ошибка при определении типа документа" skip
                "Документ" p-doc-code skip
                "Объект" p-obj-type p-obj-code skip
                "Артикул" p-artic p-prod-type p-prod-code skip
                "Код товара" v-gds-code skip
                "Партия" archive_parts.in-code archive_parts.part-code skip
                "Необходимо резервировать" v-need-rsrv skip
                "Резерв" v-rsrv-code skip
                "Необходимо снятие резервов" v-need-unrv skip
                "Снятие резервов" v-unrv-code skip
                error-status :get-message(1) skip
                return-value skip
                view-as alert-box error .
              undo, return error .
            end.

            assign
              buf_parts.fact-date = buf_parts-attr.fact-date
              buf_parts.fact-num  = v-fact-num
              buf_parts.doc-type  = v-doc-type
            .
          end.

          assign
            buf_parts.qnty      = buf_parts.qnty  + v-unrv-sign * archive_parts.fact-qnty
            buf_parts.fact-qnty = buf_parts.qnty
          .

          if v-goods-twounit = true
          then do:
            assign
              buf_parts.cli-qnty = buf_parts.cli-qnty + v-unrv-sign * archive_parts.cli-qnty
            .
          end.
          else do:
            if buf_parts.cli-base-rate <> 0
            then do:
              assign
                buf_parts.cli-qnty = buf_parts.fact-qnty / buf_parts.cli-base-rate
              .
            end.
            else do:
              assign
                buf_parts.cli-qnty = 0
              .
            end.
          end.

          if  buf_parts.qnty      = 0
          and buf_parts.fact-qnty = 0
          then do:
            if v-goods-twounit = true
            then do:
              if buf_parts.cli-qnty <> 0
              then do:
                message
                  vss-workfile vss-revision vss-description skip
                  vss-include-info{&vssseq} skip
                  "Ошибка при удалении партии" skip
                  "Документ" p-doc-code skip
                  "Объект" p-obj-type p-obj-code skip
                  "Артикул" p-artic p-prod-type p-prod-code skip
                  "Партия" buf_parts.in-code buf_parts.part-code skip
                  "Резерв" buf_parts.out-code skip
                  "qnty" buf_parts.qnty skip
                  "fact-qnty" buf_parts.fact-qnty skip
                  "cli-qnty" buf_parts.cli-qnty skip
                  view-as alert-box error .
                undo, return error .
              end.
            end.
            run gen-key-rec IN THIS-PROCEDURE (  input {&table_parts}
                                        ,input (buffer buf_parts:handle)
                                        ,output part-key-rec).
            for each ub.gen-attr where ub.gen-attr.table-name = {&excise-mark}
                                     and ub.gen-attr.p-key =  part-key-rec
            on error undo, return error substitute( "&1&2&3", vss-workfile, {&new-line}, return-value )
            :
                delete ub.gen-attr.
            end.
            delete buf_parts .
          end.
        end.
      end.
    end.
  end.

end procedure. /* partcopy-update-parts-delete */


procedure partcopy-rsrv-parts :

  define input  parameter p-doc-code-rowid as rowid no-undo .
  define input  parameter p-parts-rowid    as rowid no-undo .
  define input  parameter p-rsrv-direction as logical   no-undo .
  define input  parameter p-goods-twounit  as logical   no-undo .
  define input  parameter p-is-hold        as logical   no-undo .

  define variable vss-description as character no-undo init "partcopy-rsrv-parts-01: процедура обработки партий при удалении документа".

  define buffer buf_trn-doc for ub.trn-doc .
  define buffer archive_parts for ub.parts .
  define buffer buf_parts   for ub.parts .

  define variable v-rsrv-code as character no-undo .

  do
  on error undo, return error return-value
  :
    find first buf_trn-doc no-lock
      where rowid(buf_trn-doc) = p-doc-code-rowid
      no-error .
    if not available buf_trn-doc
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка задания входных параметров" skip
        "Не найден документ" skip
        "Документ" string(p-doc-code-rowid) skip
        "Партия" string(p-parts-rowid) skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.

    /* Обработка партий документа */
    find first archive_parts
      where rowid(archive_parts) = p-parts-rowid
      no-error .
    if not available archive_parts
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка задания входных параметров" skip
        "Не найдена партия" skip
        "Документ" string(p-doc-code-rowid) skip
        "Партия" string(p-parts-rowid) skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.

    if  archive_parts.out-code <> archive_parts.in-code
    and archive_parts.qnty <> 0
    and (buf_trn-doc.doc-type = {&income} and buf_trn-doc.internal = yes ) = false
    /* не надо резервировать из расходной зоны для межфирменного возврата от покупателя */
    and (buf_trn-doc.doc-type = {&return} and p-is-hold = true  ) = false
    then do:
      assign
        v-rsrv-code = { trg/partsprm.i "rsrv-code" buf_trn-doc. archive_parts.qnty }
      .

      run partcopy in this-procedure
        (input  true          /* p-free-output-copy */
        ,input  v-rsrv-code   /* p-out-code         */
        ,buffer archive_parts /* buf_orig_parts     */
        ,buffer buf_parts     /* buf_parts          */
        ) no-error .
      if error-status :error
      then do:
        message
          vss-workfile vss-revision vss-description skip
          vss-include-info{&vssseq} skip
          "Ошибка при создании партии" skip
          "Документ" buf_trn-doc.doc-code skip
          "Объект" archive_parts.obj-type archive_parts.obj-code skip
          "Артикул" archive_parts.artic archive_parts.prod-type archive_parts.prod-code skip
          "Партия" archive_parts.in-code archive_parts.part-code skip
          "Количество" archive_parts.qnty skip
          "Резерв" v-rsrv-code skip
          error-status :get-message(1) skip
          return-value skip
          view-as alert-box error .
        undo, return error .
      end.
      assign
        buf_parts.qnty      = buf_parts.qnty     - abs(archive_parts.qnty)
                                                  * (if p-rsrv-direction = true
                                                    then 1
                                                    else -1
                                                    )
        buf_parts.fact-qnty = buf_parts.qnty
      .

      if p-goods-twounit = true
      then do:
        assign
          buf_parts.cli-qnty = buf_parts.cli-qnty - abs(archive_parts.cli-qnty)
                                                  * (if p-rsrv-direction = true
                                                    then 1
                                                    else -1
                                                    )
        .
      end.

      if  buf_parts.qnty      = 0
      and buf_parts.fact-qnty = 0
      then do:
        if p-goods-twounit = true
        then do:
          if buf_parts.cli-qnty <> 0
          then do:
            message
              vss-workfile vss-revision vss-description skip
              vss-include-info{&vssseq} skip
              "Ошибка при удалении партии" skip
              "Документ" buf_trn-doc.doc-code skip
              "Объект" buf_parts.obj-type buf_parts.obj-code skip
              "Артикул" buf_parts.artic buf_parts.prod-type buf_parts.prod-code skip
              "Партия" buf_parts.in-code buf_parts.part-code skip
              "Резерв" buf_parts.out-code skip
              "qnty" buf_parts.qnty skip
              "fact-qnty" buf_parts.fact-qnty skip
              "cli-qnty" buf_parts.cli-qnty skip
              view-as alert-box error .
            undo, return error .
          end.
        end.
        delete buf_parts .
      end.
    end.
  end.

end procedure. /* partcopy-rsrv-parts */




procedure partcopy-update-doc-line-tot-fact :

  define input  parameter p-doc-code  like ub.doc-line.doc-code  no-undo .
  define input  parameter p-artic     like ub.doc-line.artic     no-undo .
  define input  parameter p-prod-type like ub.doc-line.prod-type no-undo .
  define input  parameter p-prod-code like ub.doc-line.prod-code no-undo .

  define variable vss-description as character no-undo init "partcopy-update-doc-line-tot-fact-01: процедура обновления средней учетной цены в строке документа".

  &scop partrqst-prefix v-total-parts-
  {&partrqst-var}

  define buffer buf_doc-line for ub.doc-line .

  do
  on error undo, return error return-value
  :
    find first buf_doc-line exclusive-lock
      where buf_doc-line.doc-code  = p-doc-code
        and buf_doc-line.artic     = p-artic
        and buf_doc-line.prod-type = p-prod-type
        and buf_doc-line.prod-code = p-prod-code
      no-error .
    if error-status :error
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка задания входных параметров" skip
        "Не найдена строка документа" skip
        "Документ" p-doc-code skip
        "Артикул" p-artic p-prod-type p-prod-code skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.

    run partrqst in this-procedure
      (input buf_doc-line.doc-code         /* p-doc-code               */
      ,input buf_doc-line.obj-type         /* p-obj-type               */
      ,input buf_doc-line.obj-code         /* p-obj-code               */
      ,input buf_doc-line.artic            /* p-artic                  */
      ,input buf_doc-line.prod-type        /* p-prod-type              */
      ,input buf_doc-line.prod-code        /* p-prod-code              */
      &scop partrqst-prefix v-total-parts-
      {&partrqst-param}
      ) no-error .
    if error-status :error
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка при сборе информации по партиям" skip
        "Документ" p-doc-code skip
        "Артикул" p-artic p-prod-type p-prod-code skip
        view-as alert-box error .
      undo, return error .
    end.

    if v-total-parts-fact-qnty <> 0
    then do:
      assign
        buf_doc-line.price-base      = v-total-parts-price-base
                                     / v-total-parts-fact-qnty
        buf_doc-line.price-rubl      = v-total-parts-price-rubl
                                     / v-total-parts-fact-qnty
        buf_doc-line.transport-base  = v-total-parts-transport-base
                                     / v-total-parts-fact-qnty
        buf_doc-line.transport-rubl  = v-total-parts-transport-rubl
                                     / v-total-parts-fact-qnty
        buf_doc-line.other-base      = v-total-parts-other-base
                                     / v-total-parts-fact-qnty
        buf_doc-line.other-rubl      = v-total-parts-other-rubl
                                     / v-total-parts-fact-qnty
      .
    end.
    else do:
      /* фактическое количество ноль - мы не можем */
      /* рассчитать среднюю учетную цену */
      /* и не меняем ее */
    end.
  end.

end procedure. /* partcopy-update-doc-line-tot-fact */


procedure partcopy-change-purch-code :
  define input parameter  p-in-code          like ub.parts.in-code no-undo .
  define input parameter  p-dest-purch-code  like ub.parts.purch-code no-undo .
  define parameter buffer buf_orig_parts     for ub.parts .
  define parameter buffer buf1_parts         for ub.parts .
  define parameter buffer buf2_parts         for ub.parts .

  define variable vss-description as character no-undo init "partcopy-change-purch-code01: процедура копирования партии при смене purch-code".
  define variable var-out-code  like ub.parts.out-code no-undo .
  define variable var-part-code like ub.parts.part-code no-undo .
  define buffer buf_goods        for ub.goods .
  define buffer buf_parts-root   for ub.parts-root.
  define buffer buf_trn-doc      for ub.trn-doc.
  define buffer buf-orig_trn-doc for ub.trn-doc.
  define buffer buf_units        for ub.units .
  /* процедура создания партии в свободной или расходной зоне */
  do
  on error undo, return error return-value
  :
    if buf_orig_parts.out-code = p-in-code
    then do:
      message
        vss-workfile vss-revision vss-description skip
        vss-include-info{&vssseq} skip
        "Ошибка задания входных параметров процедуры partcopy" skip
        "buf_orig_parts.out-code" buf_orig_parts.out-code skip
        "p-in-code" p-in-code skip
        view-as alert-box error .
      undo, return error .
    end.

    find first buf_trn-doc no-lock
      where buf_trn-doc.doc-code = p-in-code
      .
    find first buf-orig_trn-doc where buf-orig_trn-doc.doc-code = buf_orig_parts.out-code.

    find first buf_goods no-lock
      where buf_goods.artic = buf_orig_parts.artic
        and buf_goods.prod-type = buf_orig_parts.prod-type
        and buf_goods.prod-code = buf_orig_parts.prod-code
      .

    find first buf_units where buf_units.unit-name = buf_goods.unit-base no-lock.

    /* ищем первую партию и создаем партию, если ее нет */
    find first buf1_parts exclusive-lock
      where buf1_parts.obj-type  = buf_orig_parts.obj-type
        and buf1_parts.obj-code  = buf_orig_parts.obj-code
        and buf1_parts.artic     = buf_orig_parts.artic
        and buf1_parts.prod-type = buf_orig_parts.prod-type
        and buf1_parts.prod-code = buf_orig_parts.prod-code
        and buf1_parts.in-code   = buf_orig_parts.in-code
        and buf1_parts.out-code  = p-in-code
        and buf1_parts.part-code = buf_orig_parts.part-code
      no-error.
    if not available buf1_parts
    then do:
      create buf1_parts .
      buffer-copy buf_orig_parts to buf1_parts
      assign
        buf1_parts.in-code    = buf_orig_parts.in-code
        buf1_parts.out-code   = p-in-code
        buf1_parts.status_    = no
        buf1_parts.qnty       = (if buf-orig_trn-doc.ext-doc-type = {&TDEDT_Corr_Minus_Parts} then buf_orig_parts.fact-qnty else - buf_orig_parts.fact-qnty )
        buf1_parts.fact-qnty  = (if buf-orig_trn-doc.ext-doc-type = {&TDEDT_Corr_Minus_Parts} then buf_orig_parts.fact-qnty else - buf_orig_parts.fact-qnty )
        buf1_parts.cli-qnty   = (if buf-orig_trn-doc.ext-doc-type = {&TDEDT_Corr_Minus_Parts} then buf_orig_parts.cli-qnty  else - buf_orig_parts.cli-qnty  )
        buf1_parts.purch-code = buf_orig_parts.purch-code
        buf1_parts.rsrv-free  = ?
        buf1_parts.status_    = yes
      .
      /* сделаем партию доступной для поиска через первичный индекс */
      /* todo - возможно это не нужно, так как блок выделен в отдельную процедуру */
      validate buf1_parts .
    end.

    /* Код партии менять нельз для серийного товара  */
    if  lookup({&serial}, buf_units.type) > 0
    then do:
       var-part-code = buf_orig_parts.part-code.
    end.
    else do:
        run holdprts-get-part-code in this-procedure
          (input  p-in-code
          ,output var-part-code
          ) no-error .
        if error-status :error
        then dO:
          undo, return error return-value.
        end.
    end.
    /* ищем вторую партию и создаем партию, если ее нет */
    find first buf2_parts exclusive-lock
      where buf2_parts.obj-type  = buf_orig_parts.obj-type
        and buf2_parts.obj-code  = buf_orig_parts.obj-code
        and buf2_parts.artic     = buf_orig_parts.artic
        and buf2_parts.prod-type = buf_orig_parts.prod-type
        and buf2_parts.prod-code = buf_orig_parts.prod-code
        and buf2_parts.in-code   = p-in-code
        and buf2_parts.out-code  = p-in-code
        and buf2_parts.part-code = var-part-code
      no-error.
    if not available buf2_parts
    then do:
      create buf2_parts .
      buffer-copy buf_orig_parts to buf2_parts
      assign
        buf2_parts.in-code   = p-in-code
        buf2_parts.out-code  = p-in-code
        buf2_parts.qnty      = (if buf-orig_trn-doc.ext-doc-type = {&TDEDT_Corr_Minus_Parts} then - buf_orig_parts.fact-qnty else buf_orig_parts.fact-qnty )
        buf2_parts.fact-qnty = (if buf-orig_trn-doc.ext-doc-type = {&TDEDT_Corr_Minus_Parts} then - buf_orig_parts.fact-qnty else buf_orig_parts.fact-qnty )
        buf2_parts.cli-qnty  = (if buf-orig_trn-doc.ext-doc-type = {&TDEDT_Corr_Minus_Parts} then - buf_orig_parts.cli-qnty  else buf_orig_parts.cli-qnty  )
        buf2_parts.purch-code = p-dest-purch-code
        buf2_parts.part-code  = var-part-code
        buf2_parts.rsrv-free  = ?
        buf2_parts.status_    = yes
      .
      /* сделаем партию доступной для поиска через первичный индекс */
      /* todo - возможно это не нужно, так как блок выделен в отдельную процедуру */
      validate buf2_parts .
    end.

    assign
      buf_orig_parts.in-code    = p-in-code
      buf_orig_parts.part-code  = buf2_parts.part-code
      buf_orig_parts.purch-code = buf2_parts.purch-code
      /*
      buf2_parts.rsrv-free     = buf_orig_parts.rsrv-free
      buf_orig_parts.rsrv-free = ?
      buf2_parts.status_       = buf_orig_parts.status_
      buf_orig_parts.status_   = yes
      */
    .

    find first buf_parts-root
      where buf_parts-root.doc-code       = p-in-code
        and buf_parts-root.in-code        = p-in-code
        and buf_parts-root.gds-code       = buf_goods.gds-code
        and buf_parts-root.part-code      = buf2_parts.part-code
        and buf_parts-root.orig-in-code   = buf1_parts.in-code
        and buf_parts-root.orig-gds-code  = buf_goods.gds-code
        and buf_parts-root.orig-part-code = buf1_parts.part-code
      no-error .
    if not available buf_parts-root
    then do:
      create buf_parts-root.
      assign
      buf_parts-root.doc-code       = p-in-code
      buf_parts-root.in-code        = p-in-code
      buf_parts-root.gds-code       = buf_goods.gds-code
      buf_parts-root.part-code      = buf2_parts.part-code
      buf_parts-root.orig-in-code   = buf1_parts.in-code
      buf_parts-root.orig-gds-code  = buf_goods.gds-code
      buf_parts-root.orig-part-code = buf1_parts.part-code
      .
    end.
  end.
end procedure. /* partcopy */

/* $Workfile$ e n d */