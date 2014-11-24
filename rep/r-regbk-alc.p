
/*------------------------------------------------------------------------
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Журнал учёта объёма розничной продажи алкогольной и спиртосодержащей продукции

Автор: Шутилов Арнольд Валерьевич
Дата создания: 15/10/14
Author: Arnold Shutilov
Creation date: 15/10/14
ТН-15.1
  ----------------------------------------------------------------------*/
define input parameter parParentProc as handle no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Кассовая книга".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i  } /* Внутри вложен { cmp/obj-list.i {1}}, в котором формируется таблица obj-list. */
{ str/trdcalib.i }
{ gbl/attr-lib.i }
{ ref/gds-attr.i }
{ trg/factord.i  }
{ gbl/paramls.i  }
{ rep/fmtcli.i   }

{ cmp/r-pril.i new  } /* ТН-3309. 2014г. Арн. Здесь берём {&DF_Name}*/

define variable v-par-val as character no-undo.
define variable v-par-type as character no-undo.
define variable v-fact-order-start as decimal no-undo.
define variable v-fact-order-end as decimal no-undo.
define variable v-begin-date as date no-undo.
define variable v-end-date as date no-undo.

define variable g#report-num as integer no-undo.
define variable v-user-action as character no-undo.
define variable v-printed as logical no-undo.
define variable v-cnt-line as integer no-undo.
define variable v-cnt-line2 as integer no-undo.
define variable v-alc-type-name as character no-undo.
define variable v-alc-type-code as character no-undo.
define variable v-doc-code as character no-undo.
define variable v-attr-type as character no-undo.
define variable v-attr-value as character no-undo.
define variable v-attr-doc-data as date no-undo.
define variable v-attr-doc-code as character no-undo.
define variable v-name-ext-doc-type as character no-undo.

define variable v-file-name-rep-htm as character no-undo.

define stream Out-Stream.
define stream OutStr-html.

define temp-table tt-rep1
    field cnt-line as integer                                               /* 1.  "№ п/п."                                         Поступления. */
    field alc-type-name like ub.alc-type.alc-type-name                      /* 2.  "Вид и наименование продукции"                   Поступления. */ /* По Rлассификатору алк прод. */
    field alc-type-code like ub.alc-type.alc-type-code                      /* 3.  "Код вида продукции"                             Поступления. */
    field cli-obj-name like ub.clients.obj-name                             /* 4.  "Наименование организации" (Поставщика)          Поступления. */
    field inn like ub.firm.inn                                              /* 5.  "ИНН" (Поставщика)                               Поступления. */
    field date-trn as date                                                  /* 6.  "Дата" (Накл. Поставщика)                        Поступления. */ /* Из атрибутов прихода внешнего, если нет, то дата дата факт документа. Дата факт расхода внеш между фирм для межфирм перемещ. */
    field doc-line-code like ub.doc-line.doc-code                           /* -   Служебное поле(не для вывода на экран) */
    field doc-line-fact-order like ub.doc-line.fact-order                   /* -   Служебное поле. */
    field doc-code like ub.doc-line.doc-code                                /* 7.  "Номер" (Накл. Поставщика)                       Поступления. */ /* Из атрибутов прихода внешнего, если нет, то пусто. Номер расхода внеш между фирм для межфирм перемещ. */
    field volume-piece-litres like ub.goods.ms-base /* ">>,>>9,999" */      /* 8.  "Ёмкость тары(упаковки) (л)" (Накл. Поставщика)  Поступления. */ /* Определение: Объём одной минимальной(не делимой) штуки в литрах (ub.goods.ms-base). Т.е. это скажем, бутылка. */
    field fact-qnty like doc-line.fact-qnty /* "->>,>>>,>>9,<<<" */         /* 9.  "Количество тары(упаковки)" (Накл. Поставщика)   Поступления. */ /* Определение: Кол-во минимальной тары(не делимой) по накладной. (doc-line.fact-qnty) Т.е. кол-во скажем, бутылок. */
    field inc-total-quontity like doc-line.fact-qnty                        /* 10. "Итого поступило за отчётный период"             Поступления. */ /* Выводим литры тары: (doc-line.fact-qnty * goods.ms-base (т.е. факт_кол-во * объём_штуки)). Выводим штуки тары: факт_кол-во */
    field exp-categoryes-prod as character                                  /* 11. "Содержание записи"                              Расход.      */ /* Определение: продажа; списание - с указанием основания документа; перемещение - расход внутренний; недостача - инвентаризация; арестованная продукция изъятая из оборота; конфискованная продукция по решению суда. */
    field exp-alc-type-name like ub.alc-type.alc-type-name                  /* 12. "Вид и наименование продукции"                Расход.      */ /* Вид и наимен продукции по Классификатору алк прод по каждой строке пт.11 */
     field exp-alc-type-code like ub.alc-type.alc-type-code                 /* -   Служебное поле(не для вывода на экран) */
     field exp-doc-line-code like ub.doc-line.doc-code                      /* -   Служебное поле(не для вывода на экран) */
     field exp-td-fact-date as date                                         /* -   Служебное поле(не для вывода на экран) */
     field exp-fact-order like ub.doc-line.fact-order                       /* -   Служебное поле. */
    field exp-volume-piece-litres like ub.goods.ms-base /* ">>,>>9,999" */  /* 13. "Ёмкость тары(упаковки) (л)"                     Расход.      */ 
    field exp-fact-qnty like doc-line.fact-qnty /* "->>,>>>,>>9,<<<" */     /* 14. "Количество тары(упаковки)"                      Расход.      */
    field exp-total-quontity like doc-line.fact-qnty                        /* 15. "Итого расход за отчётный период"                Расход.      */ /* Подобно п.10 */

    index pi is primary
        alc-type-code doc-line-code volume-piece-litres
.

define temp-table tt-expence /* Временная таблица для обработки Расхода */
    field exp-doc-line-code like ub.doc-line.doc-code   /*+ -   Служебное поле(не для вывода на экран) */
    field exp-cnt-line as integer                       /*- -   Служебное поле(не для вывода на экран) */
    field exp-td-fact-date as date                      /*+ -   Служебное поле(не для вывода на экран) */
    field exp-fact-order like ub.doc-line.fact-order    /*+ -   Служебное поле. */
    field exp-categoryes-prod as character              /* 11. "Содержание записи"                              Расход.      */ /* Определение: продажа; списание - с указанием основания документа; перемещение - расход внутренний; недостача - инвентаризация; арестованная продукция изъятая из оборота; конфискованная продукция по решению суда. */
    field exp-alc-type-code like ub.alc-type.alc-type-code /*+ -   Служебное поле(не для вывода на экран) */
    field exp-alc-type-name like ub.alc-type.alc-type-name /* 12. "Вид и наименование продукции"                Расход.      */ /* Вид и наимен продукции по Классификатору алк прод по каждой строке пт.11 */
    field exp-volume-piece-litres like ub.goods.ms-base /* 13. "Ёмкость тары(упаковки) (л)"                     Расход.      */ 
    field exp-fact-qnty like doc-line.fact-qnty         /* 14. "Количество тары(упаковки)"                      Расход.      */
    field exp-total-quontity like doc-line.fact-qnty    /* 15. "Итого расход за отчётный период"                Расход.      */ /* Подобно п.10 */

    index pi is primary
        exp-alc-type-code exp-doc-line-code exp-volume-piece-litres
.

define buffer buf_tt-rep1 for tt-rep1.
define buffer buf_trn-doc for ub.trn-doc.

/* ***************************  Definitions  ************************** */

/* ********************  Preprocessor Definitions  ******************** */

/* ************************  Function Prototypes ********************** */


function fnc-fmt-dec-tc-litres returns character 
(input p-num as decimal) forward.

function fnc-fmt-dec-tc-qnty returns character 
(input p-num as decimal) forward.

/* ***************************  Main Block  *************************** */



/* **********************  Internal Procedures  *********************** */

procedure ConvertStr-ext-doc-type:
/********************************/
    define input parameter p-ext-doc-type as character no-undo.
    define output parameter p-name-ext-doc-type as character no-undo.
    define variable v-num-element as integer no-undo.

        /* Код_вида_расходов. Получение номера элемента в списке кодов */
        v-num-element = lookup(p-ext-doc-type, {&TDEDT_List}).

        /* Получение наименования код_вида_расходов по полученному элементу из списка наименований */
        p-name-ext-doc-type = entry(v-num-element, {&TDEDT_List-full}).
        if p-ext-doc-type <> "" and v-num-element = 0 then
            do:
                message "Ошибка 115." view-as alert-box.
                return.
            end.

end procedure.

procedure prc-create-file:
/* ******************** */
    define input parameter p-rep-num as integer no-undo.
/* Создаём временные файлы. */
    output to value( string( session:temp-directory + "$" + string( g#report-num ) ) + ".txl" ).
    output close.
    output to value( string( session:temp-directory + {&DF_Name} + string( g#report-num ) ) + ".txl" ).
    output close.
/* ******************** */

end procedure.

procedure proc-create-HTML:
/*************************/
    define variable v-volume-piece-litres as character no-undo.
    define variable v-fact-qnty as character no-undo.
    define variable v-inc-total-quontity as character no-undo.
    define variable v-exp-volume-piece-litres as character no-undo.
    define variable v-exp-fact-qnty as character no-undo.
    define variable v-exp-total-quontity as character no-undo.
    
    /* Итоговые данные */
    define input parameter p-inc-qnty-tot as decimal no-undo.
    define input parameter p-inc-litres-tot as decimal no-undo.
    define input parameter p-out-qnty-tot as decimal no-undo.
    define input parameter p-out-litres-tot as decimal no-undo.

    define variable v-inc-litres-tot2 as character no-undo.
    define variable v-out-litres-tot2 as character no-undo.

    define parameter buffer buf_tt for tt-rep1.

    v-inc-litres-tot2 = fnc-fmt-dec-tc-litres(p-inc-litres-tot).
    v-out-litres-tot2 = fnc-fmt-dec-tc-litres(p-out-litres-tot).

    output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8' /*no-convert*/.
        put stream OutStr-html unformatted

        substitute(
            '<!DOCTYPE HTML>
             <html>
             <head>
             <meta charset="utf-8">
             </head>
    
             <style type="text/css">
    
             table &1 border-collapse: collapse; font-size: 9pt; table-layout: fixed; width: 1157px; padding: 14px; &2
    
             td &1 border: 1px black ridge; word-wrap:break-word; &2
             htm
             .rotate &1
              -webkit-transform: rotate(-90deg);
              -moz-transform: rotate(-90deg);
              -ms-transform: rotate(-90deg);
              -o-transform: rotate(-90deg);
              transform: rotate(-90deg);
    
              /* also accepts left, right, top, bottom coordinates; not required, but a good idea for styling */
              -webkit-transform-origin: 50% 50%;
              -moz-transform-origin: 50% 50%;
              -ms-transform-origin: 50% 50%;
              -o-transform-origin: 50% 50%;
              transform-origin: 50% 50%;
            
              /* Should be unset in IE9+ I think. */
              filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
            &2
             </style>
            
            <body>
                <table>
                    <thead>
                        <tr id="set-columns">
                            <td style="width: 35px; border: none;"></td>
                            <td style="width: 100px; border: none;"></td>
                            <td style="width: 40px; border: none;"></td>
                            <td style="width: 170px; border: none;"></td>
                            <td style="width: 82px; border: none;"></td>
                            <td style="width: 65px; border: none;"></td>
                            <td style="width: 60px; border: none;"></td>
                            <td style="width: 60px; border: none;"></td>
                            <td style="width: 60px; border: none;"></td>
                            <td style="width: 60px; border: none;"></td>
                            <td style="width: 75px; border: none;"></td>
                            <td style="width: 170px; border: none;"></td>
                            <td style="width: 60px; border: none;"></td>
                            <td style="width: 60px; border: none;"></td>
                            <td style="width: 60px; border: none;"></td>
                        </tr>
                        <tr>
                            <td style="border: none"></td></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="width: 60px; border: none;" colspan="4">Приложение № 1</td>
                        </tr>
                        <tr>
                            <td style="height: 14px; border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none" colspan="4">к приказу Федеральной службы</td>
                        </tr>
                        <tr>
                            <td style="height: 14px; border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none" colspan="4">по регулированию алкогольного рынка</td>
                        </tr>
                        <tr>
                            <td style="height: 14px; border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none" colspan="4">от 23 мая 2014 г. № 153</td>
                        </tr>
                        <tr>
                            <td style="height: 14px; border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td>
                        </tr>
                        <tr>
                            <td style="height: 14px; border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td>
                        </tr>
                        <tr>
                            <td style="height: 14px; border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td>
                        </tr>
                        <tr>
                            <td style="border: none; font-size: 12pt; text-align: center;" colspan="14"> <b>Журнал учета объема розничной продажи алкогольной и спиртосодержащей продукции</b></td>
                        </tr>
                        <tr>
                            <td style="height: 14px; border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td> <td style="border: none"></td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td rowspan="3" style="text-align: center;">№ п/п</td> <td colspan="9" style="text-align: center;">Поступления</td> <td colspan="5" height="16" style="text-align: center;">Расход</td>
                        </tr>
                        <tr>
                            <td rowspan="2" style="text-align: center;">Вид и наименование продукции</td> <td  rowspan="2" style="text-align: center;"><div class="rotate">Код вида продукции</div></td> <td colspan="2" style="text-align: center;">Поставщик продукции</td> <td  colspan="4" style="text-align: center;">ТТН</td> <td  rowspan="2" style="text-align: center;">Итого поступило за отчетный период (дкл) </td> <td rowspan="2" style="text-align: center;">Содержание записи</td> <td rowspan="2" style="text-align: center;">Вид и наименование продукции</td> <td  rowspan="2" style="text-align: center;">Емкость тары (упаковки) (л)</td> <td  rowspan="2" style="text-align: center;">Количество тары (упаковки)</td> <td  rowspan="2" style="text-align: center;">Итого расход за отчетный период (дкл)</td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">Наименование организации</td> <td style="text-align: center;">ИНН</td> <td  style="text-align: center;">Дата</td> <td  style="text-align: center;">Номер</td>  <td  style="text-align: center;">Емкость тары (упаковки) (л)</td> <td  style="text-align: center;">Количество тары (упаковки)</td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">1</td>
                            <td style="text-align: center;">2</td>
                            <td style="text-align: center;">3</td>
                            <td style="text-align: center;">4</td>
                            <td style="text-align: center;">5</td>
                            <td style="text-align: center;">6</td>
                            <td style="text-align: center;">7</td>
                            <td style="text-align: center;">8</td>
                            <td style="text-align: center;">9</td>
                            <td style="text-align: center;">10</td>
                            <td style="text-align: center;">11</td>
                            <td style="text-align: center;">12</td>
                            <td style="text-align: center;">13</td>
                            <td style="text-align: center;">14</td>
                            <td style="text-align: center;">15</td>
                        </tr>'
            , chr(123), chr(125)
        ).
        .
    output stream OutStr-html close.

    /* Заполнение линий таблицы "*/
    for each buf_tt no-lock by buf_tt.cnt-line:
        assign
            v-volume-piece-litres = if buf_tt.volume-piece-litres = 0 and buf_tt.fact-qnty = 0 then "" else fnc-fmt-dec-tc-litres(buf_tt.volume-piece-litres)
            v-inc-total-quontity = fnc-fmt-dec-tc-litres(buf_tt.inc-total-quontity)
            v-exp-volume-piece-litres = if buf_tt.exp-volume-piece-litres = 0 and buf_tt.exp-fact-qnty = 0 then "" else fnc-fmt-dec-tc-litres(buf_tt.exp-volume-piece-litres)
            v-exp-total-quontity = fnc-fmt-dec-tc-litres(buf_tt.exp-total-quontity)
        .
    output stream OutStr-html to value(v-file-name-rep-htm) append convert target 'UTF-8'.
        put stream OutStr-html unformatted

            substitute(
                    '<tr>
                        <td style="height: 14px; border: all; text-align: center;"> &1 </td>
                        <td style="border: all; padding: 3px;"> &2 </td>
                        <td style="border: all; text-align: center;"> &3 </td>
                        <td style="border: all; padding: 3px;"> &4 </td>
                        <td style="border: all; text-align: center;"> &5 </td>
                        <td style="border: all; text-align: center;"> &6 </td>
                        <td style="border: all; text-align: center;"> &7 </td>
                        <td style="border: all; text-align: right; padding: 3px;"> &8 </td>
                        <td style="border: all; text-align: right; padding: 3px;"> &9 </td>'
                ,
                buf_tt.cnt-line,
                buf_tt.alc-type-name,
                buf_tt.alc-type-code,
                buf_tt.cli-obj-name,
                buf_tt.inn,
                if buf_tt.date-trn = ? then "" else string(buf_tt.date-trn),
                buf_tt.doc-code,
                v-volume-piece-litres, /*fnc-fmt-dec-tc-litres(buf_tt.volume-piece-litres),*/
                if buf_tt.fact-qnty = 0 and buf_tt.volume-piece-litres = 0 then "" else string(buf_tt.fact-qnty) /* Если есть ёмкость, логично ожидать количество и наоборот! :-) */ /*v-fact-qnty*/ /*fnc-fmt-dec-tc-qnty(buf_tt.fact-qnty)*/
            )
            +
            substitute( /* Продолжение столбцов. Так сделано из-за того, что substitute работает только с девятью параметрами &n, а у нас их 15. */
                        '<td style="border-top: none; border-bottom: none; text-align: right; padding: 3px;"> &1 </td>
                        <td style="border: all; padding: 3px;"> &2 </td>
                        <td style="border: all; padding: 3px;"> &3 </td>
                        <td style="border: all; text-align: right; padding: 3px;"> &4 </td>
                        <td style="border: all; text-align: right; padding: 3px;"> &5 </td>
                        <td style="border-top: none; border-bottom: none; text-align: right; padding: 3px;"> &6 </td>
                    </tr>'
                ,
                "", /*v-inc-total-quontity,*/ /*fnc-fmt-dec-tc-litres(buf_tt.inc-total-quontity),*/
                buf_tt.exp-categoryes-prod,
                buf_tt.exp-alc-type-name,
                v-exp-volume-piece-litres, /*fnc-fmt-dec-tc(buf_tt.exp-volume-piece-litres),*/
                if buf_tt.exp-fact-qnty = 0 and buf_tt.exp-volume-piece-litres = 0 then "" else string(buf_tt.exp-fact-qnty), /* Если есть ёмкость, логично ожидать количество и наоборот! :-) */ /*v-exp-fact-qnty,*/ /*fnc-fmt-dec-tc-qnty(buf_tt.exp-fact-qnty),*/
                "" /*v-exp-total-quontity*/ /*fnc-fmt-dec-tc-litres(buf_tt.exp-total-quontity)*/
                ).

    output stream OutStr-html close.
            end.

    /* Строка ИТОГО (суммы) по документу: "*/
    output stream OutStr-html to value(v-file-name-rep-htm) append convert target 'UTF-8' /*no-convert*/.
        put stream OutStr-html unformatted
            substitute (
                        '<tr>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all; text-align: right; padding: 3px;"> &1 </td>
                            <td style="height: 14px; border: all; text-align: right; padding: 3px;"> &2 </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all; text-align: right; padding: 3px;"> &3 </td>
                            <td style="height: 14px; border: all; text-align: right; padding: 3px;"> &4 </td>
                        </tr>'
            ,
            p-inc-qnty-tot,
            v-inc-litres-tot2,
            p-out-qnty-tot,
            v-out-litres-tot2
            )
        .
        /* '" */
    output stream OutStr-html close.

    /* Вставка "декоративных" надписей "ИТОГО" под таблицей. */

    output stream OutStr-html to value(v-file-name-rep-htm) append convert target 'UTF-8' /*no-convert*/.
        put stream OutStr-html unformatted
                        '<tr>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all; text-align: center;">ИТОГО</td> 
                            <td style="height: 14px; border: all; text-align: center;">ИТОГО</td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td>
                            <td style="height: 14px; border: all"> </td> 
                            <td style="height: 14px; border: all; text-align: center;">ИТОГО</td>
                            <td style="height: 14px; border: all; text-align: center;">ИТОГО</td>
                        </tr>
                    </tbody>'
        .
        /* " */
    output stream OutStr-html close.


    /* Заполнение подвала таблицы */
    output stream OutStr-html to value(v-file-name-rep-htm) append convert target 'UTF-8' /*no-convert*/.
        put stream OutStr-html unformatted
                    '<tfoot>
                        <tr>
                            <td style="height: 14px; border: none"> </td> <td style="height: 14px; border: none"> </td> <td style="height: 14px; border: none"> </td> <td style="height: 14px; border: none"> </td> <td style="height: 14px; border: none"> </td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td> <td style="height: 14px; border: none"></td>
                        </tr>
                    </tfoot>
                </table>
            </body>
        </html>'
        .
        /* '" */
    output stream OutStr-html close.

end procedure.


/* ************************  Function Implementations ***************** */

function fnc-fmt-dec-tc-litres returns character 
(input p-number as decimal):

    define variable result as character no-undo.
    define variable v-str1 as character no-undo.

    v-str1 = trim(replace(string(p-number,'>>>>9.99<'), ".", ",")).

    return v-str1.
		
end function.

function fnc-fmt-dec-tc-qnty returns character
(input p-number as decimal):

    define variable result as character no-undo.
    define variable v-str1 as character no-undo.

	v-str1 = trim(replace(string(p-number,'->>>>>>>9.<<<'), ".", ",")).

    return v-str1.

end function.

do: /* S */

    do: /* Нач_Иниц */
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

        /* Получаем номер отчёта из ТН для вставки его в имя файла Excel при сохранении. */
        run get-report-num in parParentProc (
            output g#report-num
        ).

        v-file-name-rep-htm = {&DF_Name} + string(g#report-num) + ".html".
        /* Создаём файл html где будет сформирован отчёт. */
            output to value(string(session:temp-directory + v-file-name-rep-htm)).
            output close.
        /* ******************** */


        
    
    end. /* Нач_Иниц */
do:

    for each tt-rep1 no-lock:
        delete tt-rep1.
    end.

    for each obj-list no-lock: /* А. Тело_Отчёта */
        { gbl/working.i }
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
                no-lock,
                first goods where
                goods.gds-code = gds-obj.gds-code:

                    run gds-attr-value(
                        ub.gds-obj.gds-code,
                        {&attr-alcohol-prod},
                        output v-par-val,
                        output v-par-type
                    ).

                    if v-par-val <> "" then
                        do: /* 1 */
                            v-alc-type-name = "".
                            v-alc-type-code = "".

                            for first ub.alc-type-gds where /* F Подготовка для определения Вид_Алкогольной_Продукции. */
                                ub.alc-type-gds.gds-code = ub.gds-obj.gds-code no-lock:
                                do: /* U */
                                    for first ub.alc-type where /* Определение Вид_Алкогольной_Продукции. */
                                        ub.alc-type.alc-type-inner-code = ub.alc-type-gds.alc-type-inner-code no-lock:
                                        do: /* M */
                                            assign
                                                v-alc-type-name = ub.alc-type.alc-type-name /* Запись Вид_Алкогольной_Продукции во временную переменную. */
                                                v-alc-type-code = ub.alc-type.alc-type-code /* Запись Код_Вида_Продукции во временную переменную. */
                                            .

                                            for each ub.doc-line where 
                                            ub.doc-line.status_ = {&fact} and
                                            ub.doc-line.fact-order >= v-fact-order-start and
                                            ub.doc-line.fact-order <= v-fact-order-end and
                                            ub.doc-line.prod-type = ub.gds-obj.prod-type and
                                            ub.doc-line.prod-code = ub.gds-obj.prod-code and
                                            ub.doc-line.artic = ub.gds-obj.artic no-lock,
                                            first buf_trn-doc where
                                            buf_trn-doc.doc-code = ub.doc-line.doc-code no-lock:

                                                /* Приход */
                                                if lookup(ub.doc-line.ext-doc-type, {&TDEDT_in_list}) > 0 then /* Если работаем с Приходом (список кодов прихода содержится в TDEDT_in_list) */
                                                    do:
                                                        find first tt-rep1 where
                                                            tt-rep1.alc-type-code = v-alc-type-code and
                                                            tt-rep1.doc-line-code = doc-line.doc-code and
                                                            tt-rep1.volume-piece-litres = goods.ms-base
                                                        no-error.

                                                        if not available tt-rep1 then
                                                            do:
                                                                run fmtcli-get-client in this-procedure (
                                                                    input buf_trn-doc.cli-type,
                                                                    input buf_trn-doc.cli-code
                                                                ).

                                                                v-doc-code = doc-line.doc-code.
                                                                /* дата документа из атрибутов */
                                                                { str/tdat-val.i
                                                                    v-doc-code
                                                                    {&trdcattr-dids}
                                                                    v-attr-value
                                                                    v-attr-type
                                                                }
                                                                v-attr-doc-data = date(v-attr-value).
                                                                if v-attr-doc-data = ? then v-attr-doc-data = buf_trn-doc.fact-date.

                                                                /* номер документа из атрибутов ********************/
                                                                { str/tdat-val.i
                                                                    v-doc-code
                                                                    {&trdcattr-nids}
                                                                    v-attr-value
                                                                    v-attr-type
                                                                }
                                                                v-attr-doc-code = v-attr-value.
/*                                                                if trim(v-attr-doc-code) = "" then v-attr-doc-code = "" - по умолчанию */
                                                                if  buf_trn-doc.hold-doc-code-child <> "" and buf_trn-doc.hold-doc-code-child <> "no-hold"
                                                                    or
                                                                    buf_trn-doc.hold-doc-code-parent <> "" and buf_trn-doc.hold-doc-code-parent <> "no-hold"
                                                                    then
                                                                        do:
                                                                            v-attr-doc-code = buf_trn-doc.hold-doc-code-parent.
                                                                        end.
                                                                /******************** номер документа из атрибутов */

                                                                create tt-rep1.

                                                                assign
                                                                    tt-rep1.alc-type-name = v-alc-type-name         /* 02 */
                                                                    tt-rep1.alc-type-code = v-alc-type-code         /* 03 */
                                                                    tt-rep1.cli-obj-name = v-fmtcli-name            /* 04 */
                                                                    tt-rep1.inn = v-fmtcli-inn                      /* 05 */
                                                                    tt-rep1.date-trn = v-attr-doc-data              /* 06 */
                                                                    tt-rep1.doc-line-code = doc-line.doc-code       /* - Служебное поле (не на экран) */
                                                                    tt-rep1.doc-line-fact-order = doc-line.fact-order /* - Служебное поле (не на экран) */
                                                                    tt-rep1.doc-code = v-attr-doc-code              /* 07 */
                                                                    tt-rep1.volume-piece-litres = goods.ms-base * doc-line.cli-base-rate    /* 08 */ /* ЕСЛИ в приходе ед.изм поставщика(doc-line.unit-cli) <> учётной ед.изм(goods.unit-base), ТОГДА объём_штуки_в_литрах(doc-line.unit-cli) * коэфициент_в_приходе(doc-line.cli-base-rate). Теперь изюминка - IF...THEN применять не будем! т.к. как правило, если описанное ранее условие выполняется, то нужно перемножать на коэф. cli-base-rate, если условие НЕ ВЫПОЛНЯЕТСЯ(т.е. коэф-т не нужен), всё-же можно в этом случае продолжать тупо умножать на cli-base-rate потому, что оно будет всегда(при невыполнения условия) иметь значение "ЕДИНИЦА"! и не внесёт некорректных изменений при перемножении, а мы избалвяемся от проверки условия! */
                                                                .

                                                            end.

                                                            tt-rep1.fact-qnty = tt-rep1.fact-qnty + (doc-line.fact-qnty / doc-line.cli-base-rate). /* 09 (Запись новой или добавление к сущ записи tt-rep1) */

                                                    end.

                                                /* Расход */
                                                else
                                                    if lookup(ub.doc-line.ext-doc-type, {&TDEDT_out_list}) > 0 then /* Если работаем с Расходом (список кодов расхода содержится в TDEDT_out_list) */
                                                        do:
                                                            create tt-rep1.
                                                            run ConvertStr-ext-doc-type (input ub.doc-line.ext-doc-type, output v-name-ext-doc-type).
                                                            assign
                                                                tt-rep1.exp-doc-line-code = doc-line.doc-code        /* Служебное поле (не на экран) */
                                                                tt-rep1.exp-alc-type-code = v-alc-type-code          /* Служебное поле (не на экран) */
                                                                tt-rep1.exp-td-fact-date = buf_trn-doc.fact-date     /* Служебное поле (не на экран) */
                                                                tt-rep1.doc-line-fact-order = doc-line.fact-order    /* Служебное поле (не на экран) */
                                                                tt-rep1.exp-categoryes-prod = v-name-ext-doc-type    /* 11 */
                                                                tt-rep1.exp-alc-type-name = v-alc-type-name          /* 12 */
                                                                tt-rep1.exp-volume-piece-litres = goods.ms-base      /* 13 */
                                                                tt-rep1.exp-fact-qnty = tt-rep1.exp-fact-qnty + doc-line.fact-qnty. /* 14 (Запись новой или добавление к сущ записи tt-expence) */
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
    end. /* А. Тело_Отчёта */

    do:  /* B Присвоение в поля таблицы="№ п/п" номеров по порядку, так будет выглядеть порядок в отчёте. */

        /*FF*****************************************************************************/
        define variable v-inc-litres-line as decimal no-undo.
        define variable v-out-litres-line as decimal no-undo.
        define variable v-inc-litres-tot as decimal no-undo.
        define variable v-out-litres-tot as decimal no-undo.
        define variable v-inc-qnty-tot as decimal no-undo.
        define variable v-out-qnty-tot as decimal no-undo.

        v-cnt-line = 0.

        for each tt-rep1 no-lock
        by tt-rep1.doc-line-fact-order
        :
            /* Для ПРИХОДА */
            v-cnt-line = v-cnt-line + 1.
            tt-rep1.cnt-line = v-cnt-line.
            v-inc-litres-line = (decimal(tt-rep1.volume-piece-litres) * decimal(tt-rep1.fact-qnty)) / 10.
            v-inc-litres-tot = v-inc-litres-tot + v-inc-litres-line. /* 10/1 */
            v-inc-qnty-tot = v-inc-qnty-tot + decimal(tt-rep1.fact-qnty). /* 10/2 */

            /* Для РАСХОДА */
            v-out-litres-line = (tt-rep1.exp-volume-piece-litres * tt-rep1.exp-fact-qnty) / 10.
            v-out-litres-tot = v-out-litres-tot + v-out-litres-line. /* 15/1 */
            v-out-qnty-tot = v-out-qnty-tot + tt-rep1.exp-fact-qnty. /* 15/2 */

        end.
        v-cnt-line = 0.

    end. /* B */

    find first tt-rep1 no-lock no-error.
    if error-status:error then
        do:
            message "Для установленных параметров отчета" skip "- данные отсутствуют!" view-as alert-box warning.
        end.

    run proc-create-HTML (input v-inc-qnty-tot, input v-inc-litres-tot, input v-out-qnty-tot, input v-out-litres-tot, buffer tt-rep1).

    message "Отчет сохранен в рабочую директорию " skip "(файл: " + v-file-name-rep-htm + ")." view-as alert-box information.

    os-command silent value("ReportViewer\dist\main\main.exe" + " " + v-file-name-rep-htm).

end.

end. /* S */
