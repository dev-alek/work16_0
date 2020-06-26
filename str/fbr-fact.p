/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Создание, заполнение внутренней ПН; закрытие НС и ПН по факту

Автор: Хныкин Павел Андреевич
Дата создания: 02/17/09
Author: Pavel Khnykin
Creation date: 02/17/09

Автор1: Гюнтнер Виктор Арнольдович
Дата создания1: 04/12/06

*/

define input  parameter parparentproc        as widget-handle no-undo .
define input  parameter p-fbr-doc-recid      as recid         no-undo .
define input  parameter p-silent             as logical       no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Создание, заполнение внутренней ПН; закрытие НС и ПН по факту".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/library.i  }
{ str/lib-trn.i  }
{ str/libtfarh.i }
{ str/doc-code.i }
{ str/clcprtsl.i }
{ trg/partslib.i }
{ str/fbrlib.i   }
{ rep/fbrrep.i   }
{ gbl/cur-time.i }
{ str/writelog.i def "'fbr.log'" no-create }
{ gbl/waitfram.i }
{ gbl/getsect.i def }

define variable v-in-qnty           like ub.doc-line.doc-qnty      no-undo.    /* количество для резервирования */
define variable v-in-doc-code       like ub.trn-doc.doc-code       no-undo.    /* номер ПН */
define variable v-recipe-code       like ub.fbr-line.recipe-code   no-undo.    /* для контроля одинаковости */
define variable v-price-base        like ub.fbr-line.price-base    no-undo.    /* для контроля одинаковости */
define variable v-price-rubl        like ub.fbr-line.price-rubl    no-undo.    /* для контроля одинаковости */
define variable v-in-fix-cost       like ub.fbr-line.fix-cost      no-undo.    /* для контроля одинаковости */
define variable v-fact-time         as integer                  no-undo.
define variable v-fact-date         as date                     no-undo.
define variable v-shift-date        as date                     no-undo.
define variable v-shift-num         as integer                  no-undo.
define variable v-shift-name        as character                no-undo.
define variable v-par-gen-mrgn-ie      as character                no-undo.
define variable v-par-gen-mrgn-iv      as character                no-undo.
define variable v-par-gen-mrgn-im      as character                no-undo.
define variable v-par-gen-mrgn-ie-parts      as character                no-undo.
define variable v-par-gen-mrgn-iv-parts      as character                no-undo.
define variable v-par-gen-mrgn-im-parts      as character                no-undo.


define variable v-par-type          as character                no-undo.    /* тип параметра конфигурации */
define variable v-sum-fact-qnty     as decimal                  no-undo.
define variable v-sum-rsrv-qnty     as decimal                  no-undo.
define variable v-trn-doc-doc-code  as character    no-undo.
define variable v-yesno             as logical      no-undo.
define variable v-host-code         as integer      no-undo.
define variable varrec-in           as recid        no-undo.
define variable varrec-out          as recid        no-undo.
define variable v-rb-is-base        as logical      no-undo.
define variable v-db-num            as integer      no-undo.
define variable v-reasonm           as logical      no-undo .
define variable v-reasonme as character no-undo .

define buffer buf_in_trn-doc            for ub.trn-doc.
define buffer buf_out_trn-doc           for ub.trn-doc.
define buffer buf_fbr-doc               for ub.fbr-doc.
define buffer buf_fbr-line              for ub.fbr-line.
define buffer buf_goods                 for ub.goods.
define buffer buf_temp_fbrlib_recipe    for temp_fbrlib_recipe.
define buffer buf_temp_fbrrep-goods     for temp_fbrrep-goods.
define buffer buf_shift-obj             for ub.shift-obj.

do
for buf_in_trn-doc
  , buf_out_trn-doc
  , buf_fbr-doc
  , buf_fbr-line
  , buf_goods
  , buf_temp_fbrlib_recipe
  , buf_temp_fbrrep-goods
on error undo, return error return-value
:
    { gbl/working.i }
    { gbl/curdbnum.i
        v-db-num
    }
    { gbl/rbisbase.i
        v-rb-is-base
    }
/* Получим из ТПЛ автопереоценок нужные переменные */

fact-close:
    do transaction
    on error undo fact-close, return error return-value
    :
    find first buf_fbr-doc exclusive-lock
         where recid( buf_fbr-doc ) = p-fbr-doc-recid
    .
  { gbl/gtplmrgn.i
      parparentproc
      buf_fbr-doc.obj-type
      buf_fbr-doc.obj-code
      v-par-gen-mrgn-ie
      v-par-gen-mrgn-iv
      v-par-gen-mrgn-im
    no-error }
    if error-status :error then message
      vss-workfile vss-revision vss-description skip
      error-status :get-message(1) skip
      return-value skip
      ""
      view-as alert-box error
    .
  { gbl/partmrgn.i
      parparentproc
      buf_fbr-doc.obj-type
      buf_fbr-doc.obj-code
      v-par-gen-mrgn-ie-parts
      v-par-gen-mrgn-iv-parts
      v-par-gen-mrgn-im-parts
    no-error }
    if error-status :error then message
      vss-workfile vss-revision vss-description skip
      error-status :get-message(1) skip
      return-value skip
      ""
      view-as alert-box error
    .

    { gbl/hostcode.i buf_fbr-doc.obj-type buf_fbr-doc.obj-code v-host-code }
/* Получим из секции Складские документы   нужные переменные */

        v-reasonm = no.
        v-reasonme = "".
        { gbl/getsect.i run buf_fbr-doc.obj-type buf_fbr-doc.obj-code {&attr-nakl_par} }
        for each thbjattr_thbj-attr :
            if thbjattr_thbj-attr.prop-code = 'reasonm' then v-reasonm =  thbjattr_thbj-attr.property-value-logical .
            if thbjattr_thbj-attr.prop-code = 'reasonme' then v-reasonme =  thbjattr_thbj-attr.property-value-character .
        end.


    /* проверяем совпадение резервов с тем, что требовалось */
    find first buf_fbr-line no-lock
         where buf_fbr-line.doc-code = buf_fbr-doc.doc-code
           and buf_fbr-line.fact-qnty <> buf_fbr-line.rsrv-qnty
           and buf_fbr-line.rsrv-qnty <> ?
    no-error.
    if available buf_fbr-line
    then do:
        message
            "В документе есть строки, по которым не прошло резервирование. Закрытие невозможно."
        view-as alert-box error.
        { gbl/stopwork.i }
        undo, return error "В документе есть строки, по которым не прошло резервирование. Закрытие невозможно.".
    end.
    /* для документа с рецептами проверяем заданность и суммы учетных цен */
    if buf_fbr-doc.is-free = no
    then do:
        run fbrlib-fill-and-check-temp_fbrlib_recipe in this-procedure (
            input buf_fbr-doc.doc-code
        ) no-error.
        if error-status :error
        then do:
            undo, return error substitute( "Документ производства закрыть невозможно. &1. &2", return-value, trim(error-status :get-message(1)) ).
        end.
        /* считаем шапку окончательно */
        run fbrlib-fill-sum-fbr-doc in this-procedure (
            input recid( buf_fbr-doc )
            , input {&fact}
        ) no-error.
        if error-status :error
        then do:
            undo, return error substitute( "Ошибка расчета шапки документа. &1. &2", return-value, trim(error-status :get-message(1)) ).
        end.
    end.
    run fbrrep-fill-qnty-and-prices in this-procedure (
        input buf_fbr-doc.doc-code
    ).
        /* создаем строки ПН */
        create-income-line:
        for each buf_temp_fbrrep-goods
           where buf_temp_fbrrep-goods.is-waste = no
        on error undo, return error
        :
            assign
                v-in-qnty           = buf_temp_fbrrep-goods.income-qnty - buf_temp_fbrrep-goods.write-off-qnty
            .
            if v-in-qnty <= 0
            then do:        /* приходы <= списания: нечего приходовать - все пошло дальше в производство */
                next create-income-line.
            end.
            run str/fbr-trn.p (
                  input {&income}                       /* тип формируемой накладной */
                , input buf_fbr-doc.doc-code            /* документ производства */
                , input buf_temp_fbrrep-goods.gds-code  /* товар */
                , output v-trn-doc-doc-code
            ).
            run fill-doc-line in this-procedure (
                  input v-trn-doc-doc-code                          /* приходная накладная */
                , input buf_fbr-doc.doc-code                        /* документ производства */
                , input buf_temp_fbrrep-goods.gds-code              /* товар */
                , input buf_temp_fbrrep-goods.price-sale            /* продажная цена */
                , input v-in-qnty                                   /* количество для резервирования */
                , input buf_temp_fbrrep-goods.sum-cost-rubl         /* сумма учетных цен без НДС */
                , input buf_temp_fbrrep-goods.sum-cost-base
                , input buf_temp_fbrrep-goods.sum-vat-cost-rubl     /* сумма НДС учетных цен */
                , input buf_temp_fbrrep-goods.sum-vat-cost-base
                , output v-in-qnty                          /* зарезервированное количество */
            ).
            if v-in-qnty = 0
            then do:
                { gbl/stopwork.i }
                undo fact-close, return error substitute( "Не удалось зарезервировать товар &1 &2. &3. &4&5Приходная накладная не может быть сформирована."
                                                          ,buf_temp_fbrrep-goods.artic
                                                          ,buf_temp_fbrrep-goods.gds-name
                                                          , return-value
                                                          , error-status :get-message(1)
                                                          , {&new-line}
                                                          ).
            end.
        end.        /* for each buf_temp_fbrrep-goods */
        find first buf_out_trn-doc exclusive-lock       /* НС - товары */
             where buf_out_trn-doc.doc-code = buf_fbr-doc.doc-code
        .
        /* расчет накладной */
        run gbl/calc-trn.p ( input parparentproc, input recid ( buf_out_trn-doc ) ).
        run doc-code in this-procedure (
              input  "pair"
            , input  buf_fbr-doc.obj-type
            , input  buf_fbr-doc.obj-code
            , input  buf_fbr-doc.doc-code
            , output v-in-doc-code
        ) no-error.
        if error-status:error
        then do:
            undo, return error substitute( "Ошибка при генерации номера документа pair для документа &3. &1. &2"
                                        , return-value
                                        , error-status :get-message( 1 )
                                        , buf_fbr-doc.doc-code
                                        ).
        end.
        find first buf_in_trn-doc exclusive-lock        /* ПН */
             where buf_in_trn-doc.doc-code = v-in-doc-code
        .
        run doc-code in this-procedure (
              input  "trio"
            , input  buf_fbr-doc.obj-type
            , input  buf_fbr-doc.obj-code
            , input  v-in-doc-code
            , output v-in-doc-code
        ) no-error.
        if error-status:error
        then do:
            undo, return error substitute( "Ошибка при генерации номера документа trio для документа &3. &1. &2"
                                        , return-value
                                        , error-status :get-message( 1 )
                                        , v-in-doc-code
                                        ).
        end.
        
        /* расчет накладной */
        run gbl/calc-trn.p ( input parparentproc, input recid (buf_in_trn-doc ) ).
        
        /* Устанавливаем фактич. дату, время, смену */
        run gbl/factdate.p (
              input buf_fbr-doc.obj-type
            , input buf_fbr-doc.obj-code
            , input-output v-fact-date
            , input-output v-fact-time
            , input-output v-shift-date
            , input-output v-shift-num
            , input-output v-shift-name
            , input        (p-silent = no)        /* выводить сообщения? */
        ) no-error.
        if error-status:error
        then do:
            undo, return error substitute( "Ошибка при установке даты в документе производства (&3). &1. &2"
                                        , return-value
                                        , error-status :get-message( 1 )
                                        , buf_fbr-doc.doc-code
                                        ).
        end.

        if buf_fbr-doc.fact-date <> ? then do:
            define variable v-authorize as logical no-undo.
            run gbl/authoriz.p("", output v-authorize).
            
            if not v-authorize then undo, return.
        end.
        
        if buf_fbr-doc.fact-date = ? then do:
            assign
                buf_fbr-doc.fact-date      = v-fact-date
                buf_fbr-doc.shift-date     = v-shift-date
                buf_fbr-doc.shift-num      = v-shift-num
                buf_fbr-doc.shift-name     = v-shift-name
            .
        end.
        
        find first buf_shift-obj no-lock
            where buf_shift-obj.shift-date = buf_fbr-doc.shift-date
            and buf_shift-obj.shift-num = buf_fbr-doc.shift-num
            and buf_shift-obj.obj-type = buf_fbr-doc.obj-type
            and buf_shift-obj.obj-code = buf_fbr-doc.obj-code
            no-error.
        
        if available buf_shift-obj then do:
            if buf_fbr-doc.fact-date > buf_shift-obj.close-date
                OR buf_fbr-doc.fact-date < buf_shift-obj.open-date then do:
                
                undo, return error subst("Фактическая дата &1 не входит в интервал дат смены &2 &3.",
                                         buf_fbr-doc.fact-date,
                                         buf_shift-obj.shift-date,
                                         buf_shift-obj.shift-num
                                        ).
            end.
        end.
        
        assign
            buf_out_trn-doc.fact-date  = buf_fbr-doc.fact-date
            buf_out_trn-doc.fact-time  = v-fact-time
            buf_out_trn-doc.shift-date = buf_fbr-doc.shift-date
            buf_out_trn-doc.shift-num  = buf_fbr-doc.shift-num
            buf_out_trn-doc.shift-name = buf_fbr-doc.shift-name
        .
        
        run str/parts-pc.p (
              input parparentproc
            , input buf_out_trn-doc.doc-code
            , input integer( {&responsible-storage-code} )
            , input integer( {&repayment-code} )
            , input {&fact}
            , input buf_out_trn-doc.fact-date
            , input buf_out_trn-doc.fact-time
            , input buf_out_trn-doc.shift-date
            , input buf_out_trn-doc.shift-num
            , input buf_out_trn-doc.shift-name
        ) no-error .
        if error-status:error
        then do:
            undo, return error substitute( "Не удается преобразовать товар на ответственном хранении в выкупной для накладной &3. &1. &2"
                                        , return-value
                                        , error-status :get-message( 1 )
                                        , buf_out_trn-doc.doc-code
                                          ).
        end.

        run  verify-trn-reason ( input buf_in_trn-doc.reason-code
                               , input buf_in_trn-doc.doc-code
                               , input buf_in_trn-doc.ext-doc-type
                               ) no-error .
        if error-status :error then do:
           undo, return error return-value .
        end.

        run  verify-trn-reason ( input buf_out_trn-doc.reason-code
                                ,input buf_out_trn-doc.doc-code
                                ,input buf_out_trn-doc.ext-doc-type
                                ) no-error .
        if error-status :error then do:
           undo, return error return-value .
        end.

        assign
            buf_in_trn-doc.fact-date   = buf_fbr-doc.fact-date
            buf_in_trn-doc.fact-time   = v-fact-time
            buf_in_trn-doc.shift-date  = buf_fbr-doc.shift-date
            buf_in_trn-doc.shift-num   = buf_fbr-doc.shift-num
            buf_in_trn-doc.shift-name  = buf_fbr-doc.shift-name
            buf_out_trn-doc.status_    = {&fact}
            buf_out_trn-doc.flag_      = yes
            buf_in_trn-doc.status_     = {&fact}
            buf_in_trn-doc.flag_       = yes
            buf_fbr-doc.status_            = {&fact}
        .
        if buf_in_trn-doc.fact-date <> v-fact-date
        then do:
          run str/vtrecalc.p ( input parparentproc , input recid (buf_out_trn-doc)) no-error .
          if error-status:error
          then do:
            undo, return error substitute( "Ошибка при закрытие документа списания производства: &2. &1."
                                          , return-value
                                          , buf_out_trn-doc.doc-code
                                          ).
          end.
        end.
        { str/st-fo.i buf_out_trn-doc.doc-code }
        { str/st-fo.i buf_in_trn-doc.doc-code  }
        find first buf_out_trn-doc        /* НС - услуги */
            where buf_out_trn-doc.doc-code = v-in-doc-code
        no-error.
        if available buf_out_trn-doc
        then do:        /* расчет накладной */
            run  verify-trn-reason ( input buf_out_trn-doc.reason-code
                                    ,input buf_out_trn-doc.doc-code
                                    ,input buf_out_trn-doc.ext-doc-type
                                    ) no-error .
            if error-status :error then do:
              undo, return error return-value .
            end.

            run gbl/calc-trn.p ( input parparentproc, input recid (buf_out_trn-doc ) ).
            assign
                buf_out_trn-doc.fact-date  = buf_fbr-doc.fact-date
                buf_out_trn-doc.fact-time  = v-fact-time
                buf_out_trn-doc.shift-date = buf_fbr-doc.shift-date
                buf_out_trn-doc.shift-num  = buf_fbr-doc.shift-num
                buf_out_trn-doc.shift-name = buf_fbr-doc.shift-name
                buf_out_trn-doc.status_    = {&fact}
                buf_out_trn-doc.flag_      = yes
            .
            { str/st-fo.i buf_out_trn-doc.doc-code }
        end.
        /* генерация переоценки нулевого остатка по ПН */
        run trg/lock-gds.p
          (input buf_in_trn-doc.doc-code /* v-trn-doc-doc-code     */
          ,input no               /* p-check-inv            */
          ,input no               /* p-check-inv-rasr-minus */
          ,input 0                /* p-document-fact-order  */
          ,input 0                /* p-document-fact-order-price  */
          ,input false            /* p-fact-close           */
          ,input false            /* p-is-news              */
          ) no-error .
        if error-status :error
        then do:
            undo, return error substitute( "Ошибка при блокировании товара по накладной &3. &1. &2"
                                        , return-value
                                        , error-status :get-message( 1 )
                                        ,buf_in_trn-doc.doc-code
                                        ).
        end.
        run str/in-pr.p (input parparentproc, input recid( buf_in_trn-doc ), input "cost-price" ) no-error .
        if error-status :error
        then do:
            undo, return error substitute( "Ошибка при создании автоматической переоценки типа cost-price для &3. &1. &2"
                                        , return-value
                                        , error-status :get-message(1)
                                        ,buf_in_trn-doc.doc-code
                                          ).
        end.
        if  v-par-gen-mrgn-im = {&typeprice_before-margin}
        then do:
          run str/in-pr.p ( input parparentproc, input recid(buf_in_trn-doc ), input "before-margin" ) no-error .
          if error-status :error
          then do:
          message
            vss-workfile vss-revision vss-description skip
            error-status :get-message(1) skip
            return-value skip
            ""
            view-as alert-box error
          .
            run waitfram-hide in this-procedure no-error.
            undo, return error substitute( 'Ошибка при создании автоматической переоценки. Документ "&1". '
                                        + 'Тип переоценки: &2 &3 &4.'
                                        , buf_in_trn-doc.doc-code
                                        , "before-margin"
                                        , return-value
                                        , buf_in_trn-doc.ext-doc-type ).
          end.
        end.
        
        if buf_in_trn-doc.fact-date <> v-fact-date
        then do:
          run str/vtrecalc.p ( input parparentproc , input recid (buf_in_trn-doc)) no-error .
          if error-status:error
          then do:
            undo, return error substitute( "Ошибка при закрытие документа прихода производства: &2. &1."
                                          , return-value
                                          , buf_in_trn-doc.doc-code
                                          ).
          end.
        end.
        
        if buf_in_trn-doc.obj-type = {&shop} then do:
          { str/add-scal.i parparentproc buf_in_trn-doc.obj-type buf_in_trn-doc.obj-code buf_in_trn-doc.doc-code buf_in_trn-doc.doc-type this-procedure no-error }
          if error-status:error
          then do:
            { gbl/stopwork.i }
            undo, return error .
          end.
        end.
        define variable v-par-value-l as logical   no-undo init false .

        /* Получим из секции Складские документы   нужные переменные */
        { gbl/getsect.i run buf_fbr-doc.obj-type buf_fbr-doc.obj-code {&attr-nakl_par} }
        for each thbjattr_thbj-attr :
            if thbjattr_thbj-attr.prop-code = 'minusprt' then v-par-value-l =  thbjattr_thbj-attr.property-value-logical .
        end.

        if v-par-value-l = yes
        then do:
            assign
                v-in-doc-code = buf_in_trn-doc.doc-code
            .
            release buf_in_trn-doc.
            run str/deadprts.p (
                  input v-in-doc-code
                , input parparentproc
            ).
        end.
    end.
    { gbl/stopwork.i }

/* подготовка незакрытой переоценки */

    if v-par-gen-mrgn-im = {&typeprice_after-margin}
    then do:
        if not available buf_in_trn-doc
        then do:
            find first buf_in_trn-doc no-lock
                 where buf_in_trn-doc.doc-code = v-in-doc-code
            .
        end.
        run str/in-pr.p (input parparentproc, input recid( buf_in_trn-doc ), input "after-margin" ).
    end.
    if v-par-gen-mrgn-im-parts = {&typeprice_after-margin}
    then do:
        if not available buf_in_trn-doc
        then do:
            find first buf_in_trn-doc no-lock
                 where buf_in_trn-doc.doc-code = v-in-doc-code
            .
        end.
        run str/in-pr.p (input parparentproc, input recid( buf_in_trn-doc ), input "after-margin-parts" ).
    end.
end.


/*==========================================================================
   если не удается зарезервировать все, возвращает 0,
   хотя количество в doc-line оставляет

       p-price-sale     -   продажная цена товара
       p-required-qnty  -   требуемое количество, точность не важна -  PROGRESS берет точность
                            из вызывающей процедуры
       p-reserved-qnty  -   кол-во для резервирования, должно быть точности doc-line.doc-qnty (3),
                            иначе будет накапливаться погрешность при резервировании

==========================================================================*/
procedure fill-doc-line :

define input parameter p-trn-doc-doc-code   as character no-undo .
define input parameter p-fbr-doc-doc-code   as character no-undo .
define input parameter p-gds-code           as integer   no-undo .
define input parameter p-price-sale         as decimal   no-undo .
define input parameter p-required-qnty      as decimal   no-undo .
define input parameter p-sum-rubl           as decimal   no-undo .
define input parameter p-sum-base           as decimal   no-undo .
define input parameter p-sum-vat-rubl       as decimal   no-undo .
define input parameter p-sum-vat-base       as decimal   no-undo .
define output parameter p-reserved-qnty     as decimal   no-undo .

    define variable v-doc-line-recid            as recid     no-undo .
    define variable v-out-price-base            as decimal   no-undo .
    define variable v-out-price-rubl            as decimal   no-undo .
    define variable v-allsum-sum-dsc-base-acc   as decimal   no-undo .
    define variable v-allsum-sum-dsc-rubl-acc   as decimal   no-undo .
    define variable v-allsum-vat-base-acc       as decimal   no-undo .
    define variable v-allsum-vat-rubl-acc       as decimal   no-undo .
    define variable v-vat-pc                    as decimal   no-undo .
    define variable v-host-code                 as integer   no-undo.
    define variable v-cons-vat-pc               as decimal   no-undo.

    define buffer buf_fbr-doc       for ub.fbr-doc.
    define buffer buf_goods         for ub.goods.
    define buffer buf_gds-prt       for ub.gds-prt.
    define buffer buf_trn-doc       for ub.trn-doc.
    define buffer buf_doc-line      for ub.doc-line.
    define buffer buf_gds-dtl       for ub.gds-dtl.
do
for buf_fbr-doc
  , buf_goods
  , buf_gds-prt
  , buf_trn-doc
  , buf_doc-line
  , buf_gds-dtl
on error undo, return error
:
    find first buf_fbr-doc no-lock
         where buf_fbr-doc.doc-code = p-fbr-doc-doc-code
    .
    find first buf_goods no-lock
         where buf_goods.gds-code = p-gds-code
    .
    find first buf_gds-prt no-lock
         where buf_gds-prt.upper-code = buf_goods.prt-root
    .
    find first buf_trn-doc exclusive-lock
         where buf_trn-doc.doc-code = p-trn-doc-doc-code
    .
    { gbl/hostcode.i buf_fbr-doc.obj-type buf_fbr-doc.obj-code v-host-code }
    { gbl/hostcvat.i v-host-code v-cons-vat-pc }
    { gbl/pftxvalg.i
        buf_goods.gds-code
        {&vat-tax-code}
        ?
        v-host-code
        buf_fbr-doc.obj-type
        buf_fbr-doc.obj-code
        v-vat-pc
    }
    /* создаем, если нет, строчки НС и ПН */
    find first buf_doc-line exclusive-lock
         where buf_doc-line.doc-code  = buf_trn-doc.doc-code
           and buf_doc-line.artic     = buf_goods.artic
           and buf_doc-line.prod-type = buf_goods.prod-type
           and buf_doc-line.prod-code = buf_goods.prod-code
    no-error.
    if not available buf_doc-line
    then do:
        create buf_doc-line.
        assign
            buf_doc-line.artic         = buf_goods.artic
            buf_doc-line.prod-type     = buf_goods.prod-type
            buf_doc-line.prod-code     = buf_goods.prod-code
            buf_doc-line.obj-type      = buf_trn-doc.obj-type
            buf_doc-line.obj-code      = buf_trn-doc.obj-code
            buf_doc-line.doc-code      = buf_trn-doc.doc-code
            buf_doc-line.prt-ok        = yes
            buf_doc-line.prt-root      = buf_goods.prt-root
            buf_doc-line.status_       = buf_trn-doc.status_
            buf_doc-line.doc-qnty      = 0
            buf_doc-line.cli-base-rate = 1
            buf_doc-line.VAT-pc        = p-sum-vat-base * 100.00 /  p-sum-base /* для порожденных партий - НДС для уч.цен. */
            buf_doc-line.cons-vat-pc   = v-cons-vat-pc
            buf_doc-line.price-cli     = ( p-sum-rubl + p-sum-vat-rubl ) / p-required-qnty
            buf_doc-line.price-base    = ( p-sum-base + p-sum-vat-base ) / p-required-qnty
            buf_doc-line.price-rubl    = ( p-sum-rubl + p-sum-vat-rubl ) / p-required-qnty
            buf_doc-line.doc-qnty      = p-required-qnty
            buf_doc-line.fact-qnty     = buf_doc-line.doc-qnty
            buf_doc-line.new-price-sale = p-price-sale.
        .
    end.
    else do:
        assign
            buf_doc-line.doc-qnty      = buf_doc-line.doc-qnty + p-required-qnty
        .
    end.
    assign
        v-doc-line-recid = recid( buf_doc-line )
    .
    /* резервируем товар */
    run rsrv-good in this-procedure (
          input p-gds-code            /* товар */
        , input p-trn-doc-doc-code    /* приходная накладная */
        , input v-doc-line-recid      /* строка приходной накладной */
        , input p-price-sale          /* продажная цена */
        , input p-required-qnty       /* количество для резервирования */
        , input p-sum-base            /* сумма учетных цен без НДС */
        , input p-sum-rubl
        , input p-sum-vat-base        /* сумма НДС учетных цен */
        , input p-sum-vat-rubl
        , output p-reserved-qnty      /* зарезервированное количество */
    ) no-error.
    if error-status :error
    then do:
        undo, return error substitute("&1 &2 &3Ошибка резервирования товара  с кодом &4.&5&6&5&7"
                                     ,vss-workfile
                                     ,vss-revision
                                     ,vss-description
                                     , {&new-line}
                                     , error-status:get-message(1)
                                     , return-value ).
    end.
    if p-reserved-qnty <> round( p-required-qnty, 3 ) - buf_doc-line.doc-qnty
    then do:
        assign
            p-required-qnty = 0
        .
    end.
    assign
        buf_doc-line.VAT-pc        = v-vat-pc       /* НДС для продажных цен */
    .
    run str/fbrcost.p (
          input recid( buf_doc-line )
        , input 1
        , input p-reserved-qnty
        , output v-allsum-sum-dsc-base-acc
        , output v-allsum-sum-dsc-rubl-acc
        , output v-allsum-vat-base-acc
        , output v-allsum-vat-rubl-acc
        , output v-vat-pc
    ) .
    find first buf_gds-dtl exclusive-lock
         where buf_gds-dtl.doc-code  = buf_trn-doc.doc-code
           and buf_gds-dtl.artic     = buf_goods.artic
           and buf_gds-dtl.prod-type = buf_goods.prod-type
           and buf_gds-dtl.prod-code = buf_goods.prod-code
           and buf_gds-dtl.prt-code  = buf_gds-prt.node-code
     .
    assign
        buf_gds-dtl.doc-qnty    = buf_gds-dtl.doc-qnty  + p-reserved-qnty
        buf_trn-doc.status_     = {&manufactured}
        buf_gds-dtl.fact-qnty   = buf_gds-dtl.doc-qnty
    .
end.
end procedure. /* fill-doc-line */

/*==========================================================================*/
procedure rsrv-good :


/*

p-price-sale    продажная цена товара
p-required-qnty требуемое количество,
                точность не важна - PROGRESS берет точность из вызывающей процедуры
p-rsrv-qnty     кол-во для резервирования,
                должно быть точности doc-line (3), иначе будет накапливатьс
                погрешность при резервировании

*/
define input parameter p-goods-gds-code     as integer     no-undo .
define input parameter p-trn-doc-doc-code   as character no-undo .
define input parameter p-doc-line-recid     as recid     no-undo .
define input parameter p-price-sale         as decimal   no-undo .
define input parameter p-required-qnty      as decimal   no-undo .
define input parameter p-sum-cost-base      as decimal   no-undo .
define input parameter p-sum-cost-rubl      as decimal   no-undo .
define input parameter p-sum-cost-vat-base  as decimal   no-undo .
define input parameter p-sum-cost-vat-rubl  as decimal   no-undo .
define output parameter p-rsrv-qnty         as decimal   no-undo .


    define variable v-cost-base  as decimal   no-undo .
    define variable v-cost-rubl  as decimal   no-undo .


    define buffer buf_goods         for ub.goods.
    define buffer buf_gds-prt       for ub.gds-prt.
    define buffer buf_gds-dtl       for ub.gds-dtl.
    define buffer buf_trn-doc       for ub.trn-doc.
    define buffer buf_doc-line      for ub.doc-line.

do
for buf_goods
  , buf_gds-prt
  , buf_gds-dtl
  , buf_trn-doc
  , buf_doc-line
on error undo, return error
:
    find first buf_goods no-lock
         where buf_goods.gds-code = p-goods-gds-code
    .
    find first buf_gds-prt no-lock
         where buf_gds-prt.upper-code = buf_goods.prt-root
    .
    find first buf_trn-doc no-lock
         where buf_trn-doc.doc-code = p-trn-doc-doc-code
    .
    find first buf_doc-line no-lock
         where recid( buf_doc-line ) = p-doc-line-recid  .


    { str/crgdsdtl.i
        buf_trn-doc.obj-code
        buf_trn-doc.obj-type
        buf_trn-doc.doc-code
        buf_goods.artic
        buf_goods.prod-code
        buf_goods.prod-type
        buf_gds-prt.node-code
        yes
    no-error }
    if error-status:error = yes and
       p-silent = no
    then do:
        message
            "Ошибка при создании признака."
            skip return-value
        view-as alert-box error.
    end.
    find first buf_gds-dtl
         where buf_gds-dtl.doc-code  = buf_trn-doc.doc-code
           and buf_gds-dtl.artic     = buf_goods.artic
           and buf_gds-dtl.prod-type = buf_goods.prod-type
           and buf_gds-dtl.prod-code = buf_goods.prod-code
           and buf_gds-dtl.prt-code  = buf_gds-prt.node-code
     .
    /* подставляем цены продажи из fbr и фиксируем их */
    if v-rb-is-base = yes
    then do:
        assign
            buf_gds-dtl.price-rubl = buf_gds-dtl.price-base * buf_trn-doc.base-rate / buf_trn-doc.base-scale
            buf_gds-dtl.price-base = p-price-sale
        .
    end.        /* if v-rb-is-base = yes */
    else do:
        assign
            buf_gds-dtl.price-base = buf_gds-dtl.price-rubl / buf_trn-doc.base-rate * buf_trn-doc.base-scale
            buf_gds-dtl.price-rubl = p-price-sale
        .
    end.        /* NOT ( if v-rb-is-base = yes ) */
    assign
        buf_gds-dtl.ov      = yes
        buf_trn-doc.status_ = {&wayb}
        buf_trn-doc.flag_   = no
    .

    /* округляем до третьего знака */
    /* именно с такой точностью учитывается товар в складских документах */
    assign
      p-rsrv-qnty = round( p-required-qnty, 3 )
    .

    if p-required-qnty = 0
    then do:
        message
          vss-workfile vss-revision vss-description
          skip "Невозможно зарезервировать количество 0."
          skip "Товар: " buf_goods.artic buf_goods.gds-name
          skip return-value
          skip trim(error-status :get-message(1))
               trim(error-status :get-message(2))
               trim(error-status :get-message(3))
        view-as alert-box error.
        undo, return error .
    end.

    assign
        v-cost-base = ( p-sum-cost-base + p-sum-cost-vat-base ) / p-rsrv-qnty
        v-cost-rubl = ( p-sum-cost-rubl + p-sum-cost-vat-rubl ) / p-rsrv-qnty
    .
    if v-cost-base <= 0
    or v-cost-rubl <= 0
    or ( v-rb-is-base = yes
        and p-sum-cost-base <= 0 )
    or ( v-rb-is-base <> yes
        and p-sum-cost-rubl <= 0 )
    then do:
        undo, return error substitute("Неправильные цены резервирования:&1Учетная цена, &2:  &3&1" +
                                      "Учетная цена, баз.вал.:&4&1" +
                                      "Сумма в учетных ценах: &5"  +
                                      "Товар: &6 &7"
                                      , {&new-line}
                                      , "{&abbr_rubli}"
                                      , v-cost-rubl
                                      , v-cost-base
                                      ,( if v-rb-is-base = yes then p-sum-cost-base else p-sum-cost-rubl )
                                      ,buf_goods.artic
                                      ,buf_goods.gds-name).
    end.
    run trg/rsrv-dtl.p (
          input parparentproc
        , input {&rsrv-dtl_action_reserv}
        , buffer buf_gds-dtl
        , input-output p-rsrv-qnty
        , input-output v-cost-base
        , input-output v-cost-rubl
        , input -1
        , input ""
    ) no-error.
    if error-status :error
    then do:
        if error-status :get-message(1) <> ""
        then do:
            undo, return error substitute("&1 &2 &3&4Ошибка при резервировании товара.&4&5&4&6"
                                         ,vss-workfile
                                         ,vss-revision
                                         ,vss-description
                                         ,{&new-line}
                                         ,error-status:get-message(1)
                                         ,return-value ).
        end.
    end.
end.
end procedure. /* rsrv-good */

procedure verify-trn-reason :
define input  parameter p-reason-code as integer   no-undo .
define input  parameter p-doc-code as character no-undo .
define input  parameter p-ext-doc-type as character no-undo .
  do
  on error undo, return error return-value
  :

  if v-reasonm and  lookup( p-ext-doc-type ,v-reasonme) = 0 and
  lookup( p-ext-doc-type , {&TDEDT_List-not-ver-reason}) = 0
  then do:
     if p-reason-code = 0 or p-reason-code = ? then do:
        return error substitute("Документ производства нельзя закрыть.  Не задана ПРИЧИНА СОЗДАНИЯ ДОКУМЕНТА &1."
                               , p-doc-code) .
     end.
  end.

  end.

end procedure. /* verify-trn-reason */