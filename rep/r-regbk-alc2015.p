

/*------------------------------------------------------------------------
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Журнал учёта объёма розничной продажи алкогольной и спиртосодержащей продукции

Автор: Шаланин Сергей Владимирович
Дата создания: 11/12/15
Author: Shalanin Sergey
Creation date: 11/12/15
ТН-15.0
  ----------------------------------------------------------------------*/
  
define input parameter parParentProc as handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Журнал учёта розничной продажи алкогольной продукции".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
/*{ cmp/r-pril.i new }*/
{ cmp/r-page1.i  } /* Внутри вложен { cmp/obj-list.i {1}}, в котором формируется таблица obj-list. */
{ str/trdcalib.i }
{ gbl/attr-lib.i }
{ ref/gds-attr.i }
{ trg/factord.i  }
/*{ gbl/paramls.i  }*/
{ rep/fmtcli.i   }
{ cmp/r-pril.i new  } 
{ gbl/clntattr.i }

define variable v-qnty as decimal.
define variable v-par-val           as character no-undo.
define variable v-par-type          as character no-undo.
define variable v-fact-order-start  as decimal   no-undo.
define variable v-fact-order-end    as decimal   no-undo.
define variable v-begin-date        as date      no-undo.
define variable v-end-date          as date      no-undo.
define variable v-addres as character.
define variable v-search as character.
define variable v-cntxt-host-name-obj as character no-undo .
define variable v-cntxt-host-code-obj as integer.
define        variable v-report-name            as character no-undo.         /* Наименование отчёта */
define        variable v-period                 as character no-undo.              /* Период за который формируется отчёт */
define        variable v-short-obj-list         as character no-undo.      /* Перечень выбранных объектов "в одну строку" */
define        variable v-choice-gds             as character no-undo. /* Список выбранных товаров. Вывод - в шапке отчёта */
define        variable v-choice-obj             as character no-undo. /* Выбранный пользователем параметр "Выбор объекта" (в окне параметров). Вывод в шапке отчёта */
define        variable v-full-path-RepView      as character no-undo.   /* Полный путь к файлу Просмотровщика (отчётов) */
define        variable v-file-name-rep-htm      as character no-undo.   /* Полный путь к файлу отчёта */
define variable v-file-name     as character no-undo .
define variable g#report-num        as integer   no-undo.
define variable v-user-action       as character no-undo.
define variable v-printed           as logical   no-undo.
define variable v-cnt-line          as integer   no-undo.
define variable v-cnt-line2         as integer   no-undo.
define variable v-alc-type-name     as character no-undo.
define variable v-alc-type-code     as character no-undo.
define variable v-doc-code          as character no-undo.
define variable v-attr-type         as character no-undo.
define variable v-attr-value        as character no-undo.
define variable v-attr-doc-data     as date      no-undo.
define variable v-attr-doc-code     as character no-undo.
define variable v-name-ext-doc-type as character no-undo.
define variable v-fill-path-RepView as character no-undo.
define variable v-temp-id           as integer   no-undo.
define variable v-sub-store-on      as logical   no-undo.
define variable v-obj-code          as integer   no-undo.
define variable v-obj-type          as char      no-undo.
        define variable v-out-qnty-tot as decimal initial 0 no-undo.
       define variable v-out-litres-tot as decimal initial 0 no-undo.

define temp-table tt-rep1
    field obj-code                as integer
    field obj-type  as character 
    field cnt-line                as integer                                               /* 1.  "№ п/п."                                         Поступления. */
    field alc-type-name           like ub.alc-type.alc-type-name                      /* 2.  "Вид и наименование продукции"                   Поступления. */ /* По Rлассификатору алк прод. */
    field alc-type-code           like ub.alc-type.alc-type-code                      /* 3.  "Код вида продукции"                             Поступления. */
    field cli-obj-name            like ub.clients.obj-name                             /* 4.  "Наименование организации" (Поставщика)          Поступления. */
    field inn                     like ub.firm.inn                                              /* 5.  "ИНН" (Поставщика)                               Поступления. */
    field date-trn                as date                                                  /* 6.  "Дата" (Накл. Поставщика)                        Поступления. */ /* Из атрибутов прихода внешнего, если нет, то дата дата факт документа. Дата факт расхода внеш между фирм для межфирм перемещ. */
    field doc-line-code           like ub.doc-line.doc-code                           /* -   Служебное поле(не для вывода на экран) */
    field doc-line-fact-order     like ub.doc-line.fact-order                   /* -   Служебное поле. */
    field doc-code                like ub.doc-line.doc-code                                /* 7.  "Номер" (Накл. Поставщика)                       Поступления. */ /* Из атрибутов прихода внешнего, если нет, то пусто. Номер расхода внеш между фирм для межфирм перемещ. */
    field volume-piece-litres     like ub.goods.ms-base /* ">>,>>9,999" */      /* 8.  "Ёмкость тары(упаковки) (л)" (Накл. Поставщика)  Поступления. */ /* Определение: Объём одной минимальной(не делимой) штуки в литрах (ub.goods.ms-base). Т.е. это скажем, бутылка. */
    field fact-qnty               like doc-line.fact-qnty /* "->>,>>>,>>9,<<<" */         /* 9.  "Количество тары(упаковки)" (Накл. Поставщика)   Поступления. */ /* Определение: Кол-во минимальной тары(не делимой) по накладной. (doc-line.fact-qnty) Т.е. кол-во скажем, бутылок. */
    field inc-total-quontity      like doc-line.fact-qnty                        /* 10. "Итого поступило за отчётный период"             Поступления. */ /* Выводим литры тары: (doc-line.fact-qnty * goods.ms-base (т.е. факт_кол-во * объём_штуки)). Выводим штуки тары: факт_кол-во */
    field exp-categoryes-prod     as character                                  /* 11. "Содержание записи"                              Расход.      */ /* Определение: продажа; списание - с указанием основания документа; перемещение - расход внутренний; недостача - инвентаризация; арестованная продукция изъятая из оборота; конфискованная продукция по решению суда. */
    field exp-alc-type-name       like ub.alc-type.alc-type-name                  /* 12. "Вид и наименование продукции"                Расход.      */ /* Вид и наимен продукции по Классификатору алк прод по каждой строке пт.11 */
    field exp-alc-type-code       like ub.alc-type.alc-type-code                 /* -   Служебное поле(не для вывода на экран) */
    field exp-doc-line-code       like ub.doc-line.doc-code                      /* -   Служебное поле(не для вывода на экран) */
    field exp-td-fact-date        as date                                         /* -   Служебное поле(не для вывода на экран) */
    field exp-fact-order          like ub.doc-line.fact-order                       /* -   Служебное поле. */
    field exp-volume-piece-litres like ub.goods.ms-base /* ">>,>>9,999" */  /* 13. "Ёмкость тары(упаковки) (л)"                     Расход.      */ 
    field exp-fact-qnty           like doc-line.fact-qnty /* "->>,>>>,>>9,<<<" */     /* 14. "Количество тары(упаковки)"                      Расход.      */
    field exp-total-quontity      like doc-line.fact-qnty                        /* 15. "Итого расход за отчётный период"                Расход.      */ /* Подобно п.10 */
    field itog_ii                 as integer
    field itog_volume as integer
    field exp-doc-type  like doc-line.ext-doc-type
    index pi is primary alc-type-code       doc-line-code volume-piece-litres
    index fact_order    doc-line-fact-order
    .


/*define temp-table itog-rep  */
/*field itog-name as character*/
/*field fact-qnty as decimal  */
/*field fact-date as date     */
/*field fact-volume as decimal*/
/*field obj-code as integer   */
/*field obj-type as char      */
/*                            */
/*                            */

define buffer buf_tt for tt-rep1.
define buffer buf_tt-rep1   for tt-rep1.
define buffer buf_trn-doc   for ub.trn-doc.
/*define buffer buf_obj-list  for obj-list.*/
/*define buffer buf2_obj-list for obj-list.*/
define buffer buf_itog      for tt-rep1.
define stream Out-Stream.
define stream OutStr-html.
define stream MyWatch-strm.


/* ************************  Function Prototypes ********************** */

function fnc-DD-MM-YYYY returns character 
(input p-dat-date as date) forward.

function fnc-fmt-dec-tc-litres returns character 
    (input p-num as decimal) forward.

function fnc-fmt-dec-tc-qnty returns character 
    (input p-num as decimal) forward.

/* ***************************  Main Block  *************************** */



/*procedure ConvertStr-ext-doc-type: /* Получение наименования код_вида_расходов по полученному элементу из списка наименований */*/
/*    /********************************/                                                                                          */
/*    define input parameter p-ext-doc-type as character no-undo.                                                                 */
/*    define output parameter p-name-ext-doc-type as character no-undo.                                                           */
/*    define variable v-num-element as integer no-undo.                                                                           */
/*                                                                                                                                */
/*    /* Код_вида_расходов. Получение номера элемента в списке кодов */                                                           */
/*    v-num-element = lookup(p-ext-doc-type, {&TDEDT_List}).                                                                      */
/*                                                                                                                                */
/*    /* Получение наименования код_вида_расходов по полученному элементу из списка наименований */                               */
/*    p-name-ext-doc-type = entry(v-num-element, {&TDEDT_List-full}).                                                             */
/*    if p-ext-doc-type <> "" and v-num-element = 0 then                                                                          */
/*    do:                                                                                                                         */
/*        message "Ошибка 115." view-as alert-box.                                                                                */
/*        return.                                                                                                                 */
/*    end.                                                                                                                        */
/*                                                                                                                                */
/*end procedure.                                                                                                                  */

/*procedure prc-create-file:                                                                             */
/*    /* ******************** */                                                                         */
/*    define input parameter p-rep-num as integer no-undo.                                               */
/*    /* Создаём временные файлы. */                                                                     */
/*    output to value( string( session:temp-directory + "$" + string( g#report-num ) ) + ".txl" ).       */
/*    output close.                                                                                      */
/*    output to value( string( session:temp-directory + {&DF_Name} + string( g#report-num ) ) + ".txl" ).*/
/*    output close.                                                                                      */
/*/* ******************** */                                                                             */
/*                                                                                                       */
/*/*/* Найти файл */                                                           */                        */
/*/*define variable v-full-file-name as character no-undo.                     */                        */
/*/*define variable v-shot-file-name as character no-undo.                     */                        */
/*/*v-shot-file-name = {&DF_Name} + string(g#report-num).                      */                        */
/*/*message "Ищем файл v-shot-file-name = " v-shot-file-name view-as alert-box.*/                        */
/*/*v-full-file-name = search(session:temp-directory + v-shot-file-name).      */                        */
/*/*message "Ищем файл v-full-file-name = " v-full-file-name view-as alert-box.*/                        */
/*                                                                                                       */
/*end procedure.                                                                                         */



/* ************************  Function Implementations ***************** */

function fnc-fmt-dec-tc-litres returns character 
    (input p-number as decimal):

    define variable result as character no-undo.
    define variable v-str1 as character no-undo.

    v-str1 = trim(replace(string(p-number,'>>>>9.999<'), ".", ",")).

    return v-str1.
        
end function.

function fnc-fmt-dec-tc-qnty returns character
    (input p-number as decimal):

    define variable result as character no-undo.
    define variable v-str1 as character no-undo.

    v-str1 = trim(replace(string(p-number,'->>>>>>>9.999<<'), ".", ",")).

    return v-str1.

end function.

do: /* S */

    do:  /* Нач_Иниц */
        /* Начальная инициализация таблицы */
        for each tt-rep1 no-lock:
            delete tt-rep1.
        end.
    
        /* Поиск нач fact-order */
        run day-begin-fact-order in this-procedure ( input X-Date-Start /*v-begin-date*/
            , output v-fact-order-start
            ).
        /* Поиск посл fact-order */
        run factord-end-day in this-procedure ( input X-Date-End /*v-end-date*/
            , output v-fact-order-end
            ).



    end. /* Нач_Иниц */
    do:

        for each tt-rep1 no-lock:
            delete tt-rep1.
        end.

/*        /* ТН-3371 18.02.2015 Арн. Если включена галочка "Текущий объект" в параметрах Закладка-1, то отчёт будет касаться связки Маг + Скл БЕЗ ВНУТРЕННИХ операций по прих/расх/возвр... между ними!!! */                                                                              */
/*        if x-SelectObject = {&obj-currency} then                                                                                                                                                                                                                                        */
/*        do:                                                                                                                                                                                                                                                                             */
/*            find first buf_obj-list no-error.                                                                                                                                                                                                                                           */
/*            if available buf_obj-list then                                                                                                                                                                                                                                              */
/*            do:                                                                                                                                                                                                                                                                         */
/*                /* Для этого во первых - найдём есть ли связка НашТекОбъект + Склад? */                                                                                                                                                                                                 */
/*                find first ub.shop where                                                                                                                                                                                                                                                */
/*                    ub.shop.obj-code = buf_obj-list.obj-code and                                                                                                                                                                                                                        */
/*                    ub.shop.sub-store-on = yes and           /* Включена/выключена подвязка Склада для тек объекта. */                                                                                                                                                                  */
/*                    ub.shop.sub-store-type <> '':U and       /* Здесь должен храниться тип объекта подвязанного как склад */                                                                                                                                                            */
/*                    ub.shop.sub-store-code <> 0              /* Здесь должен храниться код объекта подвязанного как склад, 0 - объект не задан! */                                                                                                                                      */
/*                    no-error.                                                                                                                                                                                                                                                           */
/*                if available ub.shop then /* Если связка Маг+Скл есть (только для режима "Текущий объект" Закладка-1), то кроме Тек Объекта- добавляем в листинг формируемых для отчёта объектов (а это задаётся в obj-list) - Объект Склад и обрабатываем два объекта: Маг и Скл !!! */*/
/*                do:                                                                                                                                                                                                                                                                     */
/*                                                                                                                                                                                                                                                                                        */
/*                    /* Для добавления данных в obj-list - обязательно заполняется его поле id. Значит найдём последнее знач id и инкрементируем его. Но попутно, по образцу в сущ коде, заполним obj-list полнее (номер бд, имя объекта) */                                             */
/*                    find first ub.clients where                                                                                                                                                                                                                                         */
/*                        ub.clients.obj-type = ub.shop.sub-store-type and                                                                                                                                                                                                                */
/*                        ub.clients.obj-code = ub.shop.sub-store-code                                                                                                                                                                                                                    */
/*                        no-lock no-error.                                                                                                                                                                                                                                               */
/*                    if available ub.clients then                                                                                                                                                                                                                                        */
/*                    do:                                                                                                                                                                                                                                                                 */
/*                        find last buf_obj-list use-index pi no-error.                                                                                                                                                                                                                   */
/*                        if available buf_obj-list then                                                                                                                                                                                                                                  */
/*                        do:                                                                                                                                                                                                                                                             */
/*                            v-temp-id = buf_obj-list.obj-id + 1.                                                                                                                                                                                                                        */
/*                        end.                                                                                                                                                                                                                                                            */
/*                        else                                                                                                                                                                                                                                                            */
/*                        do:                                                                                                                                                                                                                                                             */
/*                            v-temp-id = 1.                                                                                                                                                                                                                                              */
/*                        end.                                                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                                                        */
/*                        create buf_obj-list.                                                                                                                                                                                                                                            */
/*                                                                                                                                                                                                                                                                                        */
/*                        assign                                                                                                                                                                                                                                                          */
/*                            v-sub-store-on        = yes                        /* Флаг уточнённой проверки на предмет того, что есть связка Маг+Скл и она НЕ ПУСТАЯ! Ниже обратимся к объекту Склад для "изъятия" внутренних движений товаров между Маг и Склад */                      */
/*                            buf_obj-list.obj-type = ub.clients.obj-type                                                                                                                                                                                                                 */
/*                            buf_obj-list.obj-code = ub.clients.obj-code                                                                                                                                                                                                                 */
/*                            buf_obj-list.obj-id   = v-temp-id                                                                                                                                                                                                                           */
/*                            buf_obj-list.db-num   = ub.clients.db-num                                                                                                                                                                                                                   */
/*                            buf_obj-list.obj-name = ub.clients.obj-name                                                                                                                                                                                                                 */
/*                                                                                                                                                                                                                                                                                        */
/*                            .                                                                                                                                                                                                                                                           */
/*                    end.                                                                                                                                                                                                                                                                */
/*                end.                                                                                                                                                                                                                                                                    */
/*            end.                                                                                                                                                                                                                                                                        */
/*        end.                                                                                                                                                                                                                                                                            */


        for each obj-list no-lock: /* А. Тело_Отчёта */
        
         
 
/*            { gbl/working.i }*/
            run gbl/conf-rd.p ( /* Запрашиваем - есть ли в текущей БД в указанном объекте(маг,скл...) параметр "алкоголь"?  */
                "alcohol":U,
                "":U,
                obj-list.obj-type,
                obj-list.obj-code,
                "":U,
                "":U,
                "":U,
                yes,
                output v-par-val,
                output v-par-type
                ) no-error.
            if v-par-val <> "yes" then /* Если в текущей БД в указанном объекте параметр "алкоголь" = no тогда смотрим следующий объект(маг,склад...) */
            do:
                next.
            end. 
            else
            do: /* Если в указанном объекте(маг,склад...) найден установленный в yes параметр "алкоголь", то... */
                for each ub.gds-obj where                               /* Смотрим все связки Товар-Объект (Т-О) по известному объекту(obj-type;obj-code) находим КодТовара */
                    ub.gds-obj.obj-type = obj-list.obj-type and
                    ub.gds-obj.obj-code = obj-list.obj-code
                    no-lock
                    ,
                    first goods where
                    goods.gds-code = gds-obj.gds-code
                    :

                    run gds-attr-value(
                        ub.gds-obj.gds-code,
                        {&attr-alcohol-prod},
                        output v-par-val,
                        output v-par-type
                        ).

                    if v-par-val <> "" and
                        v-par-val <> "no" then
                    do: /* 1 */
                        v-alc-type-name = "".
                        v-alc-type-code = "".
                        for first ub.alc-type-gds where /* F Подготовка для определения Вид_Алкогольной_Продукции. */
                            ub.alc-type-gds.gds-code = ub.gds-obj.gds-code no-lock
                            :
                            do: /* U */
                                for first ub.alc-type where /* Определение Вид_Алкогольной_Продукции. */
                                    ub.alc-type.alc-type-inner-code = ub.alc-type-gds.alc-type-inner-code no-lock
                                    :
                                    do: /* M */
                                        assign
                                            v-alc-type-name = ub.alc-type.alc-type-name /* Запись Вид_Алкогольной_Продукции во временную переменную. */
                                            v-alc-type-code = ub.alc-type.alc-type-code /* Запись Код_Вида_Продукции во временную переменную. */
                                            .
                                        for each ub.doc-line where 
                                            ub.doc-line.obj-type = obj-list.obj-type and
                                            ub.doc-line.obj-code = obj-list.obj-code and
                                            ub.doc-line.status_ = {&fact} and
                                            ub.doc-line.fact-order >= v-fact-order-start and
                                            ub.doc-line.fact-order <= v-fact-order-end and
                                            ub.doc-line.prod-type = ub.gds-obj.prod-type and
                                            ub.doc-line.prod-code = ub.gds-obj.prod-code and
                                            ub.doc-line.artic = ub.gds-obj.artic and
                                            ( doc-line.ext-doc-type  = {&TDEDT_Ras_Vnesh_Kass}     or
                                            doc-line.ext-doc-type  = {&TDEDT_Ras_Vnesh}          or
                                            doc-line.ext-doc-type  = {&TDEDT_Vozvrat_Vnesh_Kass} or
                                            doc-line.ext-doc-type  = {&TDEDT_Vozvrat_Vnesh} )
                                            no-lock
                                            ,
                                            first buf_trn-doc where
                                            buf_trn-doc.doc-code = ub.doc-line.doc-code no-lock
                                            :
                                            /*                                                                                                                                                                                             */
                                            /*                                            if (lookup(ub.doc-line.ext-doc-type, {&TDEDT_out_list}) > 0) or (ub.doc-line.ext-doc-type = {&TDEDT_Vozvrat_Vnesh_Kass-full}) then /* Если работаем с Расходом (список кодов расхода содержится в TDEDT_out_list) */*/
                                            /*                                            do:                                                                                                                                                                                                                 */
                                            /*                                                  if doc-line.ext-doc-type = {&TDEDT_Ras_Vnesh} or doc-line.ext-doc-type = {&TDEDT_Vozvrat_Vnesh} then do:*/
                                                       

                                            /*                                                if v-sub-store-on = yes then /* Если работаем с гарантированно существующим объектом Склад... */                                                                                                                     */
                                            /*                                                do:                                                                                                                                                                                                                  */
                                            /*                                                    /* ТН-3371 17.02.2015 Арн. По концепции (и по ТЗ) - не включать в отчёт типы док: "приход/расход/возврат ВНУТРЕННИЕ", т.е. имеющие место ТОЛЬКО МЕЖДУ связанными МАГ и СКЛ (остальные внутр док - учитываются) */*/
                                            /*                                                    if (can-find(first obj-list no-lock where                                                                                                                                                                        */
                                            /*                                                        obj-list.obj-type = buf_trn-doc.cli-type and                                                                                                                                                                 */
                                            /*                                                        obj-list.obj-code = buf_trn-doc.cli-code))                                                                                                                                                                   */
                                            /*                                                        and                                                                                                                                                                                                          */
                                            /*                                                        (ub.doc-line.ext-doc-type = {&TDEDT_Pri_Perem} or       /* Приход внутренний - обрабатываем в разделе "Приход" (см. выше) */                                                                                 */
                                            /*                                                        ub.doc-line.ext-doc-type = {&TDEDT_Ras_Perem}  or       /* Расход внутренний */                                                                                                                              */
                                            /*                                                        ub.doc-line.ext-doc-type = {&TDEDT_Vozvrat_Perem})     /* Возврат внутренний - обрабатываем в разделе "Приход" (см. выше) */                                                                                 */
                                            /*                                                        then                                                                                                                                                                                                         */
                                            /*                                                        next.                                                                                                                                                                                                        */
                                            /*                                                end.                                                                                                                                                                                                                 */
       
                                            create tt-rep1.
                                            /*                                  v-cnt-line = v-cnt-line + 1.*/
                                            /*                                                run ConvertStr-ext-doc-type (input ub.doc-line.ext-doc-type, output v-name-ext-doc-type).*/
                                            assign
                                                tt-rep1.obj-code                = obj-list.obj-code
                                                tt-rep1.obj-type                = obj-list.obj-type
                                               
                                                tt-rep1.exp-doc-line-code       = doc-line.doc-code           /* Служебное поле (не на экран) */
                                                tt-rep1.exp-alc-type-code       = v-alc-type-code             /* Служебное поле (не на экран) */
                                                tt-rep1.exp-td-fact-date        = buf_trn-doc.fact-date        /* Служебное поле (не на экран) */
                                                tt-rep1.doc-line-fact-order     = doc-line.fact-order       /* Служебное поле (не на экран) */
                                                /*                                                    tt-rep1.exp-categoryes-prod     = v-name-ext-doc-type       /* 11 */*/
                                                tt-rep1.exp-alc-type-name       = v-alc-type-name             /* 12 */
                                                tt-rep1.exp-volume-piece-litres = goods.ms-base   
                                                .
                                            if (doc-line.ext-doc-type  = {&TDEDT_Ras_Vnesh_Kass}     or   
                                                doc-line.ext-doc-type  = {&TDEDT_Ras_Vnesh})   then 
                                            do: 
                                                tt-rep1.exp-fact-qnty = tt-rep1.exp-fact-qnty + 
                                                    (if doc-line.fact-qnty = ? then 0 else doc-line.fact-qnty)
                                                    .
                                            /*                                                                                                          */
                                            end.
                                     
                                            if  (doc-line.ext-doc-type  = {&TDEDT_Vozvrat_Vnesh_Kass} or
                                                doc-line.ext-doc-type  = {&TDEDT_Vozvrat_Vnesh} ) then 
                                            do: 
                                                tt-rep1.exp-fact-qnty           = tt-rep1.exp-fact-qnty - 
                                                    (if doc-line.fact-qnty = ? then 0 else doc-line.fact-qnty)
                                                    
                               
                                                    .
                                            end.
                                                                                 end.
                                        end. /* M */
                                    end.
                                end. /* U */
                            end. /* F */
                        end. /* 1 */
                    end.
                end.


         for each tt-rep1  where tt-rep1.obj-type = obj-list.obj-type and tt-rep1.obj-code = obj-list.obj-code break by  tt-rep1.exp-td-fact-date   by  tt-rep1.exp-volume-piece-litres by tt-rep1.exp-alc-type-code  : 
    
                
                if first-of(tt-rep1.exp-volume-piece-litres) and first-of(tt-rep1.exp-alc-type-code ) then 
                do: 

                    v-qnty = 0.
                end.

                v-qnty = v-qnty + tt-rep1.exp-fact-qnty.

                if  last-of(tt-rep1.exp-alc-type-code )   then 
                do:
                    
                    find first buf_tt where 
                    buf_tt.obj-code = obj-list.obj-code and 
                    buf_tt.obj-type = obj-list.obj-type and 
                    buf_tt.exp-td-fact-date =   tt-rep1.exp-td-fact-date and
                        buf_tt.exp-volume-piece-litres = tt-rep1.exp-volume-piece-litres and 
                        buf_tt.itog_volume = 1 and 
                        buf_tt.exp-alc-type-code =  tt-rep1.exp-alc-type-code no-lock no-error .
                    if not available buf_tt then 
                    do:
                        create buf_tt.
                         buf_tt.obj-code = obj-list.obj-code. 
                    buf_tt.obj-type = obj-list.obj-type .
                         buf_tt.itog_volume = 1 .
                        buf_tt.exp-td-fact-date =   tt-rep1.exp-td-fact-date .
                        buf_tt.exp-alc-type-code =  tt-rep1.exp-alc-type-code .
                        buf_tt.exp-volume-piece-litres = tt-rep1.exp-volume-piece-litres.   
                 
                    end.     
                      buf_tt.cnt-line = tt-rep1.cnt-line.
                    buf_tt.exp-alc-type-name = tt-rep1.exp-alc-type-name.
               buf_tt.exp-fact-qnty = v-qnty.
                end.  
            end.

            end. /* А. Тело_Отчёта */

/*procedure tt-itog:                             */
/*define input parameter p-obj-code as integer.  */
/*define input parameter p-obj-type as character.*/
/*define variable v-fact-qnty as decimal.        */
/*                                               */
             
            
           
            
/* BUFFER-COPY buf_tt to tt-rep1.*/
 

/*end.*/

        do:  /* B Присвоение в поля таблицы="№ п/п" номеров по порядку, так будет выглядеть порядок в отчёте. */

            /*FF*****************************************************************************/
            define variable v-inc-litres-line as decimal   initial 0 no-undo. 
            define variable v-out-litres-line as decimal   initial 0 no-undo.
            define variable v-inc-litres-tot  as decimal   initial 0 no-undo.
      define variable v-fact-qnty as decimal.
            define variable v-inc-qnty-tot    as decimal   initial 0 no-undo.
   define variable v-name as character .
   define variable v-liters as decimal.
   define variable itog_ii as integer .
            define variable v-dec             as character no-undo.
            v-cnt-line = 0.

            for each tt-rep1 no-lock
                /*        by tt-rep1.alc-type-code*/
                /*        by tt-rep1.date-trn*/
                by tt-rep1.doc-line-fact-order
                /*        by tt-rep1.exp-alc-type-code*/
                by tt-rep1.exp-td-fact-date
                :
             

                /* Для РАСХОДА */
                v-cnt-line = v-cnt-line + 1.
                tt-rep1.cnt-line = v-cnt-line.
                v-out-litres-line =
                    if ((tt-rep1.exp-volume-piece-litres * tt-rep1.exp-fact-qnty) / 10) = ? then 0
                else ((tt-rep1.exp-volume-piece-litres * tt-rep1.exp-fact-qnty) / 10).
                v-out-litres-tot =
                    (if v-out-litres-tot = ? then 0 else v-out-litres-tot) +
                    (if v-out-litres-line = ? then 0 else v-out-litres-line). /* 15/1 */
                v-out-qnty-tot =
                    (if v-out-qnty-tot = ? then 0 else v-out-qnty-tot) +
                    (if tt-rep1.exp-fact-qnty = ? then 0 else tt-rep1.exp-fact-qnty). /* 15/2 */
            end.
            v-cnt-line = 0.
        end. /* B */

        find first tt-rep1 no-lock no-error.
        if error-status:error then
        do:
            message "Для установленных параметров отчета" skip 
                "- данные отсутствуют!" view-as alert-box warning.
        end.
        
        
        
    
        
        
    end. /* CMD-1 */
end.

/*создание итогов по каждому дню*/





run get-full-path-RepViewer(output v-full-path-RepView).   
  
run get-report-num in parParentProc(output g#report-num).
/*if  x-SelectObject = {&o-choice} then do:*/
for each obj-list : 
   
    run define-full-path-Report(input g#report-num, input obj-list.obj-code , output v-file-name-rep-htm).
    run create-file(v-file-name-rep-htm).       
        
          for each tt-rep1 no-lock where tt-rep1.obj-code = obj-list.obj-code and tt-rep1.obj-type = obj-list.obj-type and tt-rep1.itog_volume = 1
            break by  tt-rep1.exp-td-fact-date by tt-rep1.exp-alc-type-code  by tt-rep1.exp-volume-piece-litres : 
                
                
    if first-of (tt-rep1.exp-td-fact-date) then do: 
                    itog_ii = 0 .    
                    end.
                    
        

            if first-of (tt-rep1.exp-alc-type-code)  then
            do:
                v-fact-qnty = 0.
                v-liters = 0.
                v-name = "".
            
            end.
            v-name = tt-rep1.exp-alc-type-name.
            v-liters =  tt-rep1.exp-volume-piece-litres.
         
                  v-fact-qnty = v-fact-qnty + tt-rep1.exp-fact-qnty.
           
                                                   
     
            if last-of (tt-rep1.exp-alc-type-code)  then 
            do:
                            itog_ii = itog_ii + 1 .
                
                find first buf_itog  where buf_itog.exp-td-fact-date = tt-rep1.exp-td-fact-date and 
                    buf_itog.exp-alc-type-code =  tt-rep1.exp-alc-type-code  and 
                    buf_itog.obj-code =  obj-list.obj-code and 
                    buf_itog.obj-type = obj-list.obj-type and 
                    buf_itog.exp-volume-piece-litres = 0 
                    and 
                    buf_itog.cnt-line  = 0 no-lock no-error .
                if not  available buf_itog then 
                do: 
             
                    create buf_itog.
                    assign 
                       buf_itog.exp-volume-piece-litres = 0
                        buf_itog.exp-td-fact-date  = tt-rep1.exp-td-fact-date
                        buf_itog.exp-alc-type-code = tt-rep1.exp-alc-type-code 
                        buf_itog.obj-code          = obj-list.obj-code  
                        buf_itog.obj-type          = obj-list.obj-type
                        buf_itog.cnt-line          = 0 .
         
                end.
                buf_itog.itog_ii = itog_ii .
                buf_itog.exp-alc-type-name     = v-name.
                buf_itog.exp-volume-piece-litres =  v-liters.
         buf_itog.exp-fact-qnty  =  v-fact-qnty .
                
            end.
           
                    
        end.
      
     
                run fmtcli-get-client in this-procedure (
                input obj-list.obj-type,
                input obj-list.obj-code
                ).
              v-addres = v-fmtcli-addres.
        
    run proc-create-HTML (input v-addres, input v-inc-qnty-tot, input v-inc-litres-tot, input v-out-qnty-tot , input v-out-litres-tot, input obj-list.obj-name, input obj-list.obj-code, input obj-list.obj-type).
    run search-full-path-Report (input v-file-name-rep-htm).
    v-search = v-search + " "  + search(v-file-name-rep-htm).
end.
run Report-Viewer (input v-full-path-RepView, input v-search).



procedure my-watch-table: /* Процедура для моей ОТЛАДКИ! Арн. */
    /* Запись наблюдаемых таблиц в файл */
&scope tt-table tt-rep1
    /*&scope tt-table gds-list*/
    /*&scope tt-table X_dis-card*/
    /*    define input parameter p-str1 as character no-undo.*/
    /*    define input parameter p-table-name as character no-undo.*/

    define variable v-full-file-name   as character no-undo.
    define variable v-message          as character no-undo.
    define variable v-table-handle     as handle    no-undo.
    define variable v-cnt-field        as integer   no-undo.
    define variable v-list-field-name  as character no-undo.
    define variable v-list-field-label as character no-undo.
    define variable v-list-field-type  as character no-undo.
    define variable v-ii               as integer   no-undo.

    define buffer {&tt-table} for {&tt-table}.
    /*    define buffer buf5_dcards for {&tt-table}.*/
    /*    define variable tt-handle as handle no-undo.*/

    /* Получаем:
       спискок полей таблицы - name;
       спискок полей таблицы - label;
       спискок типов полей таблицы - type. */
    v-table-handle = buffer {&tt-table}:handle.
    v-cnt-field = v-table-handle:num-fields.
    do v-ii = 1 to v-cnt-field:
        v-list-field-name =
            (if v-list-field-name <> "" then
            v-list-field-name + "$" + v-table-handle:buffer-field(v-ii):name
            else
            v-table-handle:buffer-field(v-ii):name).
        v-list-field-label =
            (if v-list-field-label <> "" then
            v-list-field-label + "$" + v-table-handle:buffer-field(v-ii):label
            else
            v-table-handle:buffer-field(v-ii):label).
        v-list-field-type =
            (if v-list-field-type <> "" then
            v-list-field-type + "$" + v-table-handle:buffer-field(v-ii):data-type
            else
            v-table-handle:buffer-field(v-ii):data-type).
    end.

    /*    tt-handle:name = p-table-name.*/
    /*    tt-handle = handle(p-table-name).*/
    /*    tt-handle = handle(p-table-name).*/
    /*    tt-handle = buffer dc-list:handle.*/
    /*    tt-handle = buf_tt.a:get-buffer-handle(p-table-name).*/
    /*    tt-handle = tt-handle:get-buffer-handle(p-table-name):handle.*/
    /*    tt-handle = tt-handle:get-buffer-handle(p-table-name).*/
    /*    tt-table = dc-list:get-buffer-handle(p-table-name).*/
    /*    tt-handle = buffer tt-table:handle.*/
    /*{ Zadachi+Test_Arn/my-include-001.i point-A p-table-name }*/

    /* Задаём жёстко имя файла и полный путь */
    /*    v-full-file-name = "C:\work15_0\my-watch-table.txt".*/
    v-full-file-name = "C:\work15_0\my-watch2-{&tt-table}.txt".

    if search(v-full-file-name) = ? then
    do:
        message "Не найден файл отчёта: " v-full-file-name view-as alert-box error.
    end.

    /* Сохранение потока в созданный файл my-watch-table.txt */
    output stream MyWatch-strm to value(v-full-file-name) /*append*/ /*no-convert*/ convert target "utf-8".
    put stream MyWatch-strm unformatted
        today format "99.99.9999" " " string(time, "HH:MM") " " "Исследуемая таблица: " "{&tt-table}" "." skip /* Для вывода текста, отдельных слов - только пробел, не ставить "+" */
        v-list-field-label skip
        v-list-field-name skip
        v-list-field-type skip
        .
    if not can-find(first {&tt-table}) then
    do:
        v-message = "Исследуемая таблица {&tt-table} пуста!".
        put stream MyWatch-strm unformatted
            v-message
            .
        message "My-watch-table: " v-message view-as alert-box information.
    end.

    for each /*buf5_dcards*/ {&tt-table} no-lock:
        export stream MyWatch-strm delimiter "$" /*buf5_dcards*/ {&tt-table}. /* Вставляем сюда вручную свою таблицу!!! */
    end.
    output stream MyWatch-strm close.
end procedure.


procedure proc-create-HTML:
    /*************************/
    define variable v-volume-piece-litres     as character no-undo.
    define variable v-fact-qnty               as character no-undo.
    define variable v-inc-total-quontity      as character no-undo.
    define variable v-exp-volume-piece-litres as character no-undo.
    define variable v-exp-fact-qnty           as character no-undo.
    define variable v-exp-total-quontity      as character no-undo.
    /* Итоговые данные */
    define input parameter p-addres as character.
    define input parameter p-inc-qnty-tot as decimal no-undo.
    define input parameter p-inc-litres-tot as decimal no-undo.
    define input parameter p-out-qnty-tot as decimal no-undo.
    define input parameter p-out-litres-tot as decimal no-undo.
/*    define variable*/
define input parameter p-obj-name as character.
define input parameter p-obj-code as integer no-undo.
define input parameter p-obj-type as char no-undo.  
define variable v-kpp as char.
define var v-inn as char.
define variable var-type as char.
    define variable v-inc-litres-tot2 as character no-undo.
    define variable v-out-litres-tot2 as character no-undo.
   define buffer buf_tt-itog-lvl for tt-rep1.
    define      buffer buf_tt   for tt-rep1.
    define           buffer buf_tt-itog for tt-rep1.
    v-inc-litres-tot2 = fnc-fmt-dec-tc-litres(p-inc-litres-tot).
    v-out-litres-tot2 = fnc-fmt-dec-tc-litres(p-out-litres-tot).
/*   run fmtcli-get-client in this-procedure (*/
/*                input p-obj-type,           */
/*                input p-obj-code            */
/*                ).                          */
                
                        { gbl/hostname.i p-obj-type p-obj-code v-cntxt-host-code-obj v-cntxt-host-name-obj }
                
                run fmtcli-get-client in this-procedure (
                input {&cmp},
                input v-cntxt-host-code-obj
                ).
                
                  RUN clntattr-value IN THIS-PROCEDURE
    (INPUT p-obj-type,
     INPUT p-obj-code,
     input {&attr-kpp},
     OUTPUT v-kpp,
     OUTPUT var-type).
/*                                                 */
/*             RUN clntattr-value IN THIS-PROCEDURE*/
/*    (INPUT p-obj-type,                           */
/*     INPUT p-obj-code,                           */
/*     input {&attr-inn},                          */
/*     OUTPUT v-inn,                               */
/*     OUTPUT var-type).                           */
     
     
    do:
        output stream OutStr-html to value(v-file-name-rep-htm) append convert target 'UTF-8'.
        put stream OutStr-html unformatted
            "<!DOCTYPE HTML>" skip
            ' <html>' skip
            '  <head>' skip
            '   <meta charset="utf-8">' skip
            '    <style type="text/css">' skip
              
            '      table ' + chr(123) + ' border-collapse: collapse; font-size:9pt; font-family:Calibri; table-layout: fixed; width: 540px; hight:  padding: 8px;  ' + chr(125) skip
            '      td ' + chr(123) ' border: 1px black solid; word-wrap:break-word; ' + chr(125) skip
            '      htm' skip
            '      .rotate ' + chr(123) skip
            '        -webkit-transform: rotate(-90deg);' skip
            '        -moz-transform: rotate(-90deg);' skip
            '        -ms-transform: rotate(-90deg);' skip
            '        -o-transform: rotate(-90deg);' skip
            '        transform: rotate(-90deg);' skip


            '        -webkit-transform-origin: 50% 50%;' skip
            '        -moz-transform-origin: 50% 50%;' skip
            '        -ms-transform-origin: 50% 50%;' skip
            '        -o-transform-origin: 50% 50%;' skip
            '        transform-origin: 50% 50%;' skip


            '        filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);' skip
            '          ' + chr(125) skip
            '            th' + ' ' + chr(123) skip
            '            border: 1px black solid;' skip
            '            word-wrap: break-word;' skip
            '          ' + chr(125) skip
            '   </style>' skip
            '  </head>' skip
            . 
    end. 

            
    put stream OutStr-html unformatted
        ' <body>' skip
        '   <table name="Лист1" fit_to_page="true" orientation="Portrait" outline_below="false">' skip
        
        '     <thead>' skip
        '       <tr class="set_columns">' skip                 
        '         <td style="width: 80px; border: none;"></td>' skip  
        '         <td style="width: 80px; border: none;"></td>' skip   
        '         <td style="width: 80px; border: none;"></td>' skip     
        '         <td style="width: 200px; border: none;"></td>' skip    
        '         <td style="width: 100px; border: none;"></td>' skip 
        '         <td style="width: 100px; border: none;"></td>' skip  
        '         <td style="width: 100px; border: none;"></td>' skip  
        '       </tr>' skip
        .
        
    do:  
     
        put stream OutStr-html unformatted
      
      
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td colspan="4" style="border: none;  text-align: right;  font-size: 12pt;">Приложение №1</td>' skip

            '</tr>' skip
      
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td colspan="4" style="border: none; text-align: right;  font-size: 12pt;">к приказу Федеральной службы</td>' skip

            '</tr>' skip
            
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td colspan="4" style="border: none;text-align: right;  font-size: 12pt;">по регулированию алкогольного рынка</td>' skip

            '</tr>' skip
            
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td colspan="4" style="border: none;   text-align: right;  font-size: 12pt;">от 19.06.2015 № 153</td>' skip

            '</tr>' skip
            
           
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '</tr>' skip

            
            
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '</tr>' skip
            
            
            
            '       <tr>' skip
            '         <td colspan="7" style="border: none;   text-align: center;  font-size: 12pt;  font-weight: bold;">Журнал учета объема розничной продажи</td>' skip
            
            '</tr>' skip
            
            
            '       <tr>' skip
            '         <td colspan="7" style="border: none;  text-align: center;  font-size: 12pt;  font-weight: bold;">алкогольной и спиртосодержащей продукции</td>' skip
            
            '</tr>' skip
            
            
            
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '</tr>' skip
             
             
             
            '       <tr style="height: 60px;">' skip
            '         <td text_wrap="true" colspan="3" style="border: none;  text-align: left;  font-size: 12pt;">Наименование организации, Ф.И.О. индивидуального предпринимателя</td>' skip
            '         <td colspan="4" style="border: none; border-bottom: 1px solid black; height: 14px;  text-align: center; font-weight: bold; font-size: 12pt;">' + p-obj-name   + '</td>' skip
            
            '</tr>' skip
                
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '</tr>' skip
             
             
            '       <tr style="height: 60px;">' skip
            '         <td text_wrap="true" colspan="3" style="border: none; text-align: left;  font-size: 12pt;">ИНН/КПП организации, ИНН индивидуального предпринимателя</td>' skip
            '         <td colspan="4" style="border: none; border-bottom: 1px solid black; height: 14px;  text-align: center;  font-weight: bold; font-size: 12pt;">' + v-fmtcli-inn + "/"+  v-kpp + '</td>' skip
            
            '</tr>' skip
            
            
            '       <tr>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '</tr>' skip
             
             
            '       <tr style="height: 60px;">' skip
            '         <td text_wrap="true" colspan="3" style="border: none;  text-align: left;  font-size: 12pt;">Адрес места осуществления деятельности организацией, индивидуальным предпринимателем</td>' skip
            '         <td colspan="4" style="border: none; border-bottom: 1px solid black; height: 14px;  text-align: center; font-weight: bold; font-size: 12pt;">' + p-addres + '</td>' skip
            
            '</tr>' skip
             
             
            '        <tr style="height: 30px;">' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '         <td style="border: none;"></td>' skip
            '</tr>' skip
            '</thead>' skip
            .
          
    end.

    do:
        put stream OutStr-html unformatted
            '     <tbody>' skip
            '       <tr style="height: 60px;">' skip
            '         <th   style="background-color:#ffffcc;  text-align: center;">№ п/п</th>' skip
            '         <th     style="background-color:#ffffcc; text-align: center;">Дата розничной продажи</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center;">Штриховой код</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center;">Наименование продукции</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center;">Код вида продукции</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center;">Емкость (л)</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center;">Количество (штук)</th>' skip

            '</tr>' skip
            '       <tr>' skip
            '         <th   style="background-color:#ffffcc; text-align: center">1</th>' skip
            '         <th     style="background-color:#ffffcc; text-align: center">2</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center">3</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center">4</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center">5</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center">6</th>' skip
            '         <th  style="background-color:#ffffcc; text-align: center">7</th>' skip

            '</tr>' skip
            .
        output stream OutStr-html close.
    end.

    do:
        output stream OutStr-html to value(v-file-name-rep-htm) append convert target 'UTF-8'.

        for each buf_tt no-lock where buf_tt.obj-code = p-obj-code and buf_tt.obj-type = p-obj-type  and   buf_tt.itog_volume = 1 break by buf_tt.exp-td-fact-date  by buf_tt.volume-piece-litres :
            
            v-exp-volume-piece-litres = if buf_tt.exp-volume-piece-litres = 0 and buf_tt.exp-fact-qnty = 0 then "" else fnc-fmt-dec-tc-litres(buf_tt.exp-volume-piece-litres).
            put stream OutStr-html unformatted
                '       <tr style = "height:60px;">' skip
                '         <td style="display: yes; text-align: right;">'  +  string(buf_tt.cnt-line) + '</td>' skip
                '         <td style="display: yes; text-align:  right;">' + if buf_tt.exp-td-fact-date = ? then "" else fnc-DD-MM-YYYY(date(string(buf_tt.exp-td-fact-date,"99.99.9999"))) +  '</td>' skip
                '         <td style="display: yes; text-align:  left;">'  '</td>' skip
                '         <td text_wrap="true" style="display: yes; text-align:  left;">'  +    buf_tt.exp-alc-type-name  + '</td>'  skip
                '         <td style="display: yes; text-align:  right;">'  +      buf_tt.exp-alc-type-code  + '</td>'  skip
                '         <td style="display: yes; text-align:  right;">'  +       v-exp-volume-piece-litres + '</td>'  skip
                '         <td style="display: yes; text-align:  right;">'  +       if buf_tt.exp-fact-qnty = 0 and buf_tt.exp-volume-piece-litres = 0 then ""  else string(fnc-fmt-dec-tc-qnty(buf_tt.exp-fact-qnty))     + '</td>'  skip
                '</tr>' skip
                .
                
            if last-of (buf_tt.exp-td-fact-date) then 
            do: 
                
                find last buf_tt-itog-lvl where buf_tt-itog-lvl.obj-code = p-obj-code  and buf_tt-itog-lvl.obj-type = p-obj-type  and buf_tt-itog-lvl.cnt-line = 0 and  buf_tt-itog-lvl.exp-td-fact-date = buf_tt.exp-td-fact-date no-lock no-error.
                  put stream OutStr-html unformatted
    
                        '       <tr style = "height:60px;">' skip
                    
                        
                        '         <td rowspan = "' +   string(buf_tt-itog-lvl.itog_ii) +  '"   colspan = "3" style="display: yes; vertical-align:  middle; font-weight: bold; text-align:  right;"> ИТОГО</td>' skip
                        .
               
               
                for each buf_tt-itog where buf_tt-itog.obj-code = p-obj-code  and buf_tt-itog.obj-type = p-obj-type  and buf_tt-itog.cnt-line = 0 and  buf_tt-itog.exp-td-fact-date = buf_tt.exp-td-fact-date : 
        
    
    
                   put stream OutStr-html unformatted
                        
                        
                        '         <td text_wrap="true" style="display: yes; font-weight: bold; text-align: left;">'  +    buf_tt-itog.exp-alc-type-name  + '</td>'  skip
                        '         <td style="display: yes; font-weight: bold; text-align:  right;">'  +      buf_tt-itog.exp-alc-type-code  + '</td>'  skip
                        '         <td style="display: yes; font-weight: bold; text-align:  right;"></td>'  skip
                        '         <td style="display: yes; font-weight: bold; text-align:  right;">'  +       if buf_tt-itog.exp-fact-qnty = 0 and buf_tt-itog.exp-volume-piece-litres = 0 then ""  else string(fnc-fmt-dec-tc-qnty(buf_tt-itog.exp-fact-qnty))     + '</td>'  skip
                        '</tr>' skip
                        .
                end.
            end.
    
        end.
    
    
    end.
    do: 
        put stream OutStr-html unformatted  
            '</tbody>'
            '   </table>' skip
            '  </body>' skip
            ' </html>' skip
            . /* Точка для закрытия Put */
        output stream OutStr-html close.
    end.
    
end procedure.


   
    
    function fnc-DD-MM-YYYY returns character 
(input p-dat-date as date):
/* Преобразование даты в формат: "01.01.2014" */

    define variable result as character no-undo.
    define variable p-str-date as character no-undo.

    p-str-date = replace(string(p-dat-date,'99.99.9999'), "/", ".").

        return p-str-date.

end function.
    
    
procedure get-full-path-RepViewer:  /* Получение полного пути к исполняемому файлу RV.exe (output Полный_путь_имя_файла_RV.exe) */
    /* Получение полного пути к exe-файлу просмотровщика отчётов */
    define output parameter p-fill-path-RepView as character no-undo.

    if search("exe\ReportViewer\reportviewer.exe") <> ? then
    do:
        p-fill-path-RepView = search("exe\ReportViewer\reportviewer.exe").
    end.
    else
    do:
        message "Не найдена программа просмотра отчёта!" view-as alert-box error.
    end.
end procedure.


procedure search-full-path-Report:  /* Только проверка, есть файл отчёта HTML или нет(тогда вывод сбщ-ош) */
    /* Поиск файла */  
    define input parameter p-file-name as character no-undo.

    if search(p-file-name) = ? then
    do:
        message "Не найден файл отчёта: " p-file-name view-as alert-box error.
    end.
    else
    do:
        p-file-name = search(p-file-name).
    end.

end procedure.


procedure create-file:              /* СоздЛюбогоФайлаНаДиске(input полный_путь_с_именем) */
    /* Создание пустого файла (во входном параметре: полный путь и имя файла) */
    define input parameter p-file-name as character no-undo.
    output to value(string(p-file-name)).
    output close.

end procedure.


procedure define-full-path-Report:  /* Получение полного пути к отчёту html (input №Отчёта, output Полный_путь_имя_файла_отчHTML) */
    /* Получение полного пути к отчёту html */
    define input parameter p-rep-num as integer no-undo.
     define input parameter name-obj as integer.
    define output parameter p-file-name-rep-htm as character no-undo.

    p-file-name-rep-htm = session:temp-directory +   "Объект" + string(name-obj) + ".html".

end procedure.


procedure Report-Viewer:            /* Запуск на выполнение RV (input Полный_путь_имя_файла_RV, input Полный_путь_имя_файла_отчHTML) */
/* Запуск программы "Просмотровщик Отчётов" - ReportViewer. */
    define input parameter p-full-path-RepView as character no-undo.
    define input parameter p-search as character no-undo.

    os-command no-wait value(p-full-path-RepView +  p-search).

end procedure.


