/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать формы ТОРГ-13

Автор: Демин Алексей Сергеевич
Дата создания: 09/15/05
Author: Alexey Demin
Creation date: 09/15/05

Input:

Output:

*/
&scop P3-X 130
&scop P3-S1 30 /*начало надписи перехода на следующую страницу*/

&scop P0-S 112
&scop P0-X 19
&scop P0-X1 85 /* максимальная ширина надписи  И Н Н */
&scop P0-E 130

&scop P1-S 55
&scop P1-X 32
&scop P1-X1 44 /* максимальная ширина надписи статуса документа*/
&scop P1-C1-S 73
&scop P1-E 86

&scop P4-C1-X 17
&scop P4-C2-X 17
&scop P4-C3-X 25
&scop P4-X1 100 /* максимальная ширина суммы прописью */

&scop P2-X 130
&scop P2-X0 128 /* длина внутренней линии = {&P2-X} - 2*/
&scop P2-C1-X 60
&scop P2-C2-S 65
&scop P2-C2-X 60
&scop P2-E 130

do
on error undo, return error
:
define input parameter p-mainmenu-handle    as handle           no-undo.
define input parameter rec_id               as recid            no-undo.
define input parameter p-print-gold         as logical          no-undo. /* Если yes, то печатается модификация формы для ювелирных изделмй */
define input parameter p-print-prod         as logical          no-undo. /* Если yes, то идет сортировка по производителям */
define input parameter p-break-name         as logical          no-undo. /* Если yes, то названия товаров переносятся */

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Печать формы ТОРГ-13".
{ cmp/vssrevis.i        }
{ cmp/str-glbl.i        }
{ cmp/library.i         }
{ cmp/r-pril.i          }
{ str/trdcalib.i        }
{ str/in-vatp.i def     }
{ str/out-vatp.i def    }
{ rep/p-fmt.i           }
{ rep/r-cliprp.i def    }
{ cmp/breakstr.i        }
{ rep/fmtcli.i          }
{ gbl/clntattr.i        }
{ rep/torgconf.i        }

def buffer t-doc        for trn-doc.
def buffer OurObject    for clients.
def buffer buf_clients  for clients.
def buffer buf_units    for units.

define stream Out-stream .

def shared var PrintScale   as logical              no-undo.
def shared var costprice    as logical              no-undo.
def shared var sort-name    as logical              no-undo.
def shared var sort-gr      as logical              no-undo.

def temp-table temp_gds-name no-undo
    field gds-name like goods.gds-name
    field string-num as integer
    index sn is primary unique string-num
.
def var v-gds-name          like goods.gds-name     no-undo.
def var v-gds-name-counter  as integer              no-undo.

def var tdoc-prt            as    logical           no-undo.
def var tdoc-code           like trn-doc.doc-code   no-undo.
def var v-doc-date-string   as character            no-undo.

def var rootnode_code       as integer              no-undo.

def var LineCounter         as integer              no-undo.
def var txt-LC              as char                 no-undo.
def var s1                  as char                 no-undo.
def var s2                  as char                 no-undo.

def var Node_Code           like gds-prt.upper-code no-undo.

def var PriceNoNDS          as decimal              no-undo.
def var PricendS            as decimal              no-undo.
def var PricewithNDS        as decimal              no-undo.

def var tqnty               as decimal              no-undo.
def var SumNoNDS            as decimal              no-undo.
def var SumNDS              as decimal              no-undo.
def var SumwithNDS          as decimal              no-undo.

def var sum-tqnty           as decimal              no-undo.
def var sum-SumNoNDS        as decimal              no-undo.
def var sum-SumNDS          as decimal              no-undo.
def var sum-SumwithNDS      as decimal              no-undo.

def var prt-tqnty           as decimal              no-undo.
def var prt-SumNoNDS        as decimal              no-undo.
def var prt-SumNDS          as decimal              no-undo.
def var prt-SumwithNDS      as decimal              no-undo.

def var sum-prt-tqnty       as decimal              no-undo.
def var sum-prt-SumNoNDS    as decimal              no-undo.
def var sum-prt-SumNDS      as decimal              no-undo.
def var sum-prt-SumwithNDS  as decimal              no-undo.

def var Pg-tqnty            as decimal init 0       no-undo.
def var Pg-SumNoNDS         as decimal              no-undo.
def var Pg-SumNDS           as decimal              no-undo.
def var Pg-SumwithNDS       as decimal              no-undo.
def var PrevPage            as integer init 0       no-undo.

def var tot-SumNoNDS        as decimal              no-undo.
def var tot-SumNDS          as decimal              no-undo.
def var tot-SumwithNDS      as decimal              no-undo.

def var PrtName             as char                 no-undo.

def var OKEI                as char                 no-undo.
def var tb-code             as char                 no-undo.
def var qnty-opl            as decimal              no-undo.
def var qnty-pl             as decimal              no-undo.
def var mass-b              as decimal              no-undo.
def var mass-n              as decimal              no-undo.

def var v-line-counter      as integer              no-undo.

def var v-not-gold          as logical              no-undo.

def var v-new-prod          as logical  no-undo.
def var v-prod-type         like doc-line.prod-type no-undo.
def var v-prod-code         like doc-line.prod-code no-undo.
def var v-prod-name         like clients.obj-name   no-undo.

def var sym1    as char init ":" no-undo.
def var sym2    as char init ":" no-undo.
def var sym3    as char init ":" no-undo.
def var sym4    as char init ":" no-undo.
def var sym5    as char init ":" no-undo.
def var sym6    as char init ":" no-undo.
def var sym7    as char init ":" no-undo.
def var sym8    as char init ":" no-undo.
def var sym9    as char init ":" no-undo.
def var sym10   as char init ":" no-undo.

def var Line                as char          no-undo.
def var UndLine             as char          no-undo.

def var unit-str            as char          no-undo.
def var val-str             as char          no-undo.
define variable v-host-code as integer       no-undo.

define variable g#report-num    as integer      no-undo.
define variable g#quest-print   as logical      no-undo.
define variable g#log           as logical      no-undo.

run get-report-num in p-mainmenu-handle (
    output g#report-num
).
run get-quest-print in p-mainmenu-handle (
    output g#quest-print
).

find first t-doc no-lock
     where recid( t-doc ) = rec_id
.
{ gbl/hostcode.i
    t-doc.obj-type
    t-doc.obj-code
    v-host-code
}
run torgconf-read in this-procedure (
      input "torg13x"
    , input v-host-code
    , input t-doc.obj-type
    , input t-doc.obj-code
) no-error.
if error-status :error
then do:
    message
    vss-workfile vss-revision vss-description
    skip "Ошибка чтения параметров печати формы."
    skip "Форма будет напечатана с параметрами по умолчанию."
    skip return-value
    skip trim(error-status :get-message(1))
        trim(error-status :get-message(2))
        trim(error-status :get-message(3))
    view-as alert-box error.
end.

{ rep/torg-13x.i def-frame}
{ rep/torg-13x.i def-frame gold}

assign
    val-str = ( if PrintRubl then "{&abbr_rublyah}" else "баз.вал" )
.
assign
    Line = fill("-", 230)
    UndLine = fill("_", 230)
    LineCounter = 1
.
if v-torgconf-outnum = yes
then do:
    assign
        tdoc-code = fill( " ", 10 )
    .
end.
else do:
    assign
        tdoc-code = t-doc.doc-code
    .
end.
if v-torgconf-outdate = yes
then do:
    assign
        v-doc-date-string = fill( " ", 10 )
    .
end.
else do:
    assign
        v-doc-date-string = ( if t-doc.status_ <> {&fact}
                              then string( t-doc.doc-date, "99/99/9999" )
                              else string( t-doc.fact-date, "99/99/9999" )  )
    .
end.
find OurObject where OurObject.obj-type = t-doc.obj-type and
                                          OurObject.obj-code = t-doc.obj-code no-lock no-error.
case OurObject.obj-type :
    when {&shop}
    then do:
        find shop where shop.obj-code = OurObject.obj-code no-lock .
        tdoc-prt = shop.doc-prt.
    end.
    when {&stock}
    then do:
        find store where store.obj-code = OurObject.obj-code no-lock .
        tdoc-prt = store.doc-prt .
    end.
end case.

if not tdoc-prt then
    PrintScale = no .

{ gbl/working.i }

{ cmp/open-out.i stream Out-stream " " {&CS_PS} }

form header
    Line format "X({&P3-X})" at 1 skip
    "Продолжение - на следующей странице" at {&P3-S1} skip
    with frame bottomframe width {&DOS_CW} page-bottom no-labels no-box .
view stream out-stream frame bottomframe .

find clients where clients.obj-type = {&cmp} and
                                   clients.obj-code = t-doc.host-code no-lock .

{ rep/r-cliprp.i }
put stream out-stream
    space(5) Line format  "X({&P0-X})" at {&P0-S} skip
    space(5) "|"            at {&P0-S}
             {&g___code}  format "X(3)"     at center-field( {&P0-S}, {&P0-E}, 3 )
             "|" at {&P0-E}
    skip space(5)
             "Форма по ОКУД" format "X(13)" at right-field ( {&P0-S}, 13 )
             "| "                           at {&P0-S}
             "0330213"                      at center-field( {&P0-S}, {&P0-E}, 7 )
             "|"                            at {&P0-E}
    skip space(5)
             string( "{&abbr_inn_allshift} " + t-inn + " " + caps( clients.obj-name )
                     + " (" + string(clients.obj-code) + ")"
                     + t-addres + t-phone
                    )        format "X({&P0-X1})"
                   "по ОКПО" format "X(7)"  at right-field ( {&P0-S}, 7 )
                   "| "                     at {&P0-S}
                   t-okpo    format "X(10)" at center-field( {&P0-S}, {&P0-E}, 10 )
                   "|"                      at {&P3-X}
    skip space(5)
             "Вид деятельности по ОКДП" format "X(24)"  at right-field ( {&P0-S}, 24 )
             "| "                                       at {&P0-S}
             "|"                                        at {&P0-E}
    skip space(5)
             "Вид операции" format "X(12)"  at right-field ( {&P0-S}, 12 )
             "| "                           at {&P0-S}
              ( if t-doc.doc-type = {&income}
                then " приход"
                else ( if t-doc.doc-type = {&return}
                       then "возврат"
                       else " расход" ) )
                            format "X(7)"   at center-field( {&P0-S}, {&P0-E}, 7 )
             "|"                            at {&P0-E}
    skip space(5)
             Line format  "X({&P0-X})"      at {&P0-S}
    .
put stream out-stream
    skip
        Line                format "X({&P1-X})" at {&P1-S}
    skip
        "НАКЛАДНАЯ"                             at right-field ( {&P1-S}, 9 )
        "|"                                     at {&P1-S}
        string( tdoc-code ) format "X(14)"      at center-field( {&P1-S}, {&P1-C1-S}, 14 )
        "|"                                     at {&P1-C1-S}
        v-doc-date-string
                            format "X(10)"      at center-field( {&P1-C1-S}, {&P1-E}, 10 )
        "|"                                     at {&P1-E}
        (if t-doc.status_ <> {&fact}
         then string( "(" + caps(t-doc.status_) + ")" )
         else ""
        )                   format "X({&P1-X1})"
    skip
        Line                format "X({&P1-X})" at {&P1-S}
    skip
        "НА ВНУТРЕННЕЕ ПЕРЕМЕЩЕНИЕ, ПЕРЕДАЧУ ТОВАРОВ, ТАРЫ"
                            format "X(49)"      at center-field( {&P1-S} - 7, {&P1-E}, 49 )
    skip
.

put stream out-stream
        Line format "X({&P3-X})"
    skip
        "| "
        "Отправитель"             format "X(11)"
        "| "                                        at {&P2-C2-S}
        "Получатель"              format "X(10)"
        "|"                                         at {&P2-E}
    skip
        "|"
        Line                        format "X({&P2-X0})"
        "|"
    skip
.
if t-doc.doc-type = {&income} or t-doc.doc-type = {&return}
then do:
    find first clients no-lock
         where clients.obj-type = t-doc.cli-type
           and clients.obj-code = t-doc.cli-code
    .
end.
else do:
    find first clients no-lock
         where clients.obj-type = t-doc.obj-type
           and clients.obj-code = t-doc.obj-code
    .
end.
put stream out-stream
    "| "
    string( clients.obj-name ) format "X({&P2-C1-X})"
.
if t-doc.doc-type = {&income} or t-doc.doc-type = {&return}
then do:
    find first clients no-lock
         where clients.obj-type = t-doc.obj-type
           and clients.obj-code = t-doc.obj-code
    .
end.
else do:
    find first clients no-lock
         where clients.obj-type = t-doc.cli-type
           and clients.obj-code = t-doc.cli-code
    .
end.
put stream out-stream
    "|"                                                 at {&P2-C2-S}
    string( clients.obj-name ) format "X({&P2-C2-X})"
    "|"                                                 at {&P2-E}
    skip
    Line format "X({&P2-X})" skip
.
if t-doc.PS <> ?
and t-doc.PS <> ""
and substring( trim( t-doc.PS ), 1, 1 ) <> "@"
then do:
    put stream out-stream
        "Примечание: " t-doc.PS skip
        Line format "X({&P2-X})" skip
    .
end.
/*---START--------- Определение формы для вывода строк ---------------------*/
if costprice
then do:
    if p-print-gold = yes
    then do:
        form with frame f-doc-cost-gold .
        if sort-gr = yes or p-print-prod = yes
        then do:
            down stream out-stream 1 with frame f-doc-cost-gold .
        end.
    end.
    else do:
        form with frame f-doc-cost.
        if sort-gr = yes or p-print-prod = yes
        then do:
            down stream out-stream 1 with frame f-doc-cost .
        end.
    end.
end.
else do:
    if p-print-gold = yes
    then do:
        form with frame f-doc-doc-gold .
        if sort-gr = yes or p-print-prod = yes
        then do:
            down stream out-stream 1 with frame f-doc-doc-gold .
        end.
    end.
    else do:
        form with frame f-doc-doc.
        if sort-gr = yes or p-print-prod = yes
        then do:
            down stream out-stream 1 with frame f-doc-doc .
        end.
    end.
end.
/*---END----------- Определение формы для вывода строк ---------------------*/



/*----- Начальные значения ------*/

assign
    v-line-counter  = 0
    v-new-prod      = yes
    sum-tqnty       = 0
    sum-SumNoNDS    = 0
    sum-SumNDS      = 0
    sum-SumwithNDS  = 0
.

/*---S---------- Печать строк документа ---------------*/
if sort-name = yes
then do:
    if p-print-prod = yes
    then do:
        if sort-gr = yes
        then do:
            for each doc-line no-lock
               where doc-line.doc-code = t-doc.doc-code
              ,first goods no-lock
               where goods.prod-type    = doc-line.prod-type
                 and goods.prod-code    = doc-line.prod-code
                 and goods.artic        = doc-line.artic
              ,first clients no-lock
               where clients.obj-type   = goods.prod-type
                 and clients.obj-code   = goods.prod-code
            break   by clients.obj-name
                    by goods.grp-name
                    by goods.gds-name
            :
                if first-of (clients.obj-name)
                then do:
                    run print-prod-line in this-procedure.
                end.
                if first-of (goods.grp-name)
                then do:
                    run print-group-line in this-procedure.
                end.
                run print-doc-line in this-procedure.
            end.
        end.        /* sort-gr = yes */
        else do:
            for each doc-line no-lock
               where doc-line.doc-code = t-doc.doc-code
             , first goods no-lock
               where goods.prod-type    = doc-line.prod-type
                 and goods.prod-code    = doc-line.prod-code
                 and goods.artic        = doc-line.artic
              ,first clients no-lock
               where clients.obj-type   = goods.prod-type
                 and clients.obj-code   = goods.prod-code
            break   by clients.obj-name
                    by goods.gds-name
            :
                if first-of (clients.obj-name)
                then do:
                    run print-prod-line in this-procedure.
                end.
                run print-doc-line in this-procedure.
            end.
        end.        /* sort-gr = no */
    end.            /* p-print-prod = yes */
    else do:
        if sort-gr = yes
        then do:
            for each doc-line no-lock
            where doc-line.doc-code = t-doc.doc-code
            , first goods no-lock
            where goods.prod-type    = doc-line.prod-type
                and goods.prod-code    = doc-line.prod-code
                and goods.artic        = doc-line.artic
            break by goods.grp-name
                by goods.gds-name
            :
                if first-of (goods.grp-name)
                then do:
                    run print-group-line in this-procedure.
                end.
                run print-doc-line in this-procedure.
            end.
        end.        /* sort-gr = yes */
        else do:
            for each doc-line no-lock
            where doc-line.doc-code = t-doc.doc-code
            , first goods no-lock
            where goods.prod-type    = doc-line.prod-type
                and goods.prod-code    = doc-line.prod-code
                and goods.artic        = doc-line.artic
            break by goods.gds-name
            :
                run print-doc-line in this-procedure.
            end.
        end.        /* sort-gr = no */
    end.            /* p-print-prod = no */
end.        /* sort-name = yes */
else do:
    if p-print-prod = yes
    then do:
        if sort-gr = yes
        then do:
            for each doc-line no-lock
            where doc-line.doc-code = t-doc.doc-code
            , first goods no-lock
            where goods.prod-type    = doc-line.prod-type
                and goods.prod-code    = doc-line.prod-code
                and goods.artic        = doc-line.artic
              ,first clients no-lock
               where clients.obj-type   = goods.prod-type
                 and clients.obj-code   = goods.prod-code
            break   by clients.obj-name
                    by goods.grp-name
                    by doc-line.line-num
            :
                if first-of (clients.obj-name)
                then do:
                    run print-prod-line in this-procedure.
                end.
                if first-of (goods.grp-name)
                then do:
                    run print-group-line in this-procedure.
                end.
                run print-doc-line in this-procedure.
            end.
        end.
        else do:
            for each doc-line no-lock
            where doc-line.doc-code = t-doc.doc-code
            , first goods no-lock
              where goods.prod-type    = doc-line.prod-type
                and goods.prod-code    = doc-line.prod-code
                and goods.artic        = doc-line.artic
            , first clients no-lock
              where clients.obj-type   = goods.prod-type
                and clients.obj-code   = goods.prod-code
            break   by clients.obj-name
                    by doc-line.line-num
            :
                if first-of (clients.obj-name)
                then do:
                    run print-prod-line in this-procedure.
                end.
                run print-doc-line in this-procedure.
            end.
        end.
    end.        /* p-print-prod = yes */
    else do:
        if sort-gr = yes
        then do:
            for each doc-line no-lock
            where doc-line.doc-code = t-doc.doc-code
            , first goods no-lock
            where goods.prod-type    = doc-line.prod-type
                and goods.prod-code    = doc-line.prod-code
                and goods.artic        = doc-line.artic
            break by goods.grp-name
                by doc-line.line-num
            :
                if first-of (goods.grp-name)
                then do:
                    run print-group-line in this-procedure.
                end.
                run print-doc-line in this-procedure.
            end.
        end.        /* sort-gr = yes */
        else do:
            for each doc-line no-lock
            where doc-line.doc-code = t-doc.doc-code
            , first goods no-lock
            where goods.prod-type    = doc-line.prod-type
                and goods.prod-code    = doc-line.prod-code
                and goods.artic        = doc-line.artic
            break by doc-line.line-num
            :
                run print-doc-line in this-procedure.
            end.
        end.        /* sort-gr = yes */
    end.        /* p-print-prod = no */
end.        /* sort-name = no */
/*---E---------- Печать строк документа ---------------*/

/*---START--------- Выводим итог на странице ---------------------*/
if line-counter( Out-stream ) + 9 > page-size( Out-stream )
then do:
    if p-print-gold = yes
    then do:
        if costprice =yes
        then do:
            { rep/torg-13x.i itog cost -gold}.
        end.
        else do:
            { rep/torg-13x.i itog doc -gold}.
        end.
        page stream Out-stream .
    end.        /* p-print-gold = yes */
    else do:
        if costprice =yes
        then do:
            { rep/torg-13x.i itog cost}.
        end.
        else do:
            { rep/torg-13x.i itog doc}.
        end.
        page stream Out-stream .
    end.        /* p-print-gold = no */
end.
/*---END----------- Выводим итог на странице ---------------------*/
/*---START--------- Общий итог ---------------------*/

hide stream Out-stream frame Bottomframe .

if p-print-gold = yes
then do:
    if costprice = yes
    then do:
        { rep/torg-13x.i itog cost -gold}
        display stream Out-stream
            "Всего по накладной"    @ temp_gds-name.gds-name
            t-doc.fact-qnty         @ tqnty
            sum-SumNoNDS            @ SumNoNDS
            sum-SumwithNDS          @ SumwithNDS
            with frame f-doc-cost-gold .
        down stream Out-stream 2 with frame f-doc-cost-gold .
    end.        /* costprice = yes */
    else do:
        { rep/torg-13x.i itog doc -gold}
        display stream Out-stream
            "Всего по накладной"    @ temp_gds-name.gds-name
            t-doc.fact-qnty         @ tqnty
            sum-SumNoNDS            @ SumNoNDS
            sum-SumwithNDS          @ SumwithNDS
            with frame f-doc-doc-gold .
        down stream Out-stream 2 with frame f-doc-doc-gold .
    end.        /* costprice = no */
end.        /* p-print-gold = yes */
else do:
    if costprice = yes
    then do:
        { rep/torg-13x.i itog cost}
        display stream Out-stream
            "Всего по накладной"    @ temp_gds-name.gds-name
            t-doc.fact-qnty         @ tqnty
            sum-SumNoNDS            @ SumNoNDS
            sum-SumwithNDS          @ SumwithNDS
            with frame f-doc-cost .
        down stream Out-stream 2 with frame f-doc-cost .
    end.        /* costprice = yes */
    else do:
        { rep/torg-13x.i itog doc}
        display stream Out-stream
            "Всего по накладной"    @ temp_gds-name.gds-name
            t-doc.fact-qnty         @ tqnty
            sum-SumNoNDS            @ SumNoNDS
            sum-SumwithNDS          @ SumwithNDS
            with frame f-doc-doc .
        down stream Out-stream 2 with frame f-doc-doc .
    end.        /* costprice = no */
end.        /* p-print-gold = no */
/*---END----------- Общий итог ---------------------*/
/*---START--------- Примечание формы ---------------------*/
if PrintRubl then
    run rep/wp-rub.p ( sum-SumwithNDS, output s1, output s2 ) .
else
    run rep/wp.p ( input p-mainmenu-handle, sum-SumwithNDS, output s1, output s2 ) .

put stream Out-stream
    skip space(10)
        string( "Отпустил " ) format "X(9)"
        UndLine format "X({&P4-C1-X})" string( " " ) format "X(1)"
        UndLine format "X({&P4-C2-X})" string( " " ) format "X(1)"
        UndLine format "X({&P4-C3-X})" string( " товар и тару по количеству и надлежащему качеству" ) format "X(50)"
    skip space(19)
        string( "должность" )           format "X({&P4-C1-X})" string( " " ) format "X(1)"
        string( "подпись" )             format "X({&P4-C2-X})" string( " " ) format "X(1)"
        string( "расшифровка подписи" ) format "X({&P4-C3-X})"
    skip(1) space(10)
        string( "на сумму " ) format "X(9)"
        caps(s1) format "X({&P4-X1})"
    skip(1) space(10)
        string( "Получил " ) format "X(9)"
        UndLine format "X({&P4-C1-X})" string( " " ) format "X(1)"
        UndLine format "X({&P4-C2-X})" string( " " ) format "X(1)"
        UndLine format "X({&P4-C3-X})"
    skip space(19)
        string( "должность" )           format "X({&P4-C1-X})" string( " " ) format "X(1)"
        string( "подпись" )             format "X({&P4-C2-X})" string( " " ) format "X(1)"
        string( "расшифровка подписи" ) format "X({&P4-C3-X})" skip
    .
/*---END----------- Примечание формы ---------------------*/
output stream Out-stream close.
{ rep/q-print.i 4}

end.










/*==========================================================================*/
procedure print-doc-line :
do
on error undo, return error
:
    if p-print-gold = yes
    then do:
        /*---START--------- Определили, золото это или нет и вычислили кол-во мест ---------------------*/
        find first buf_units no-lock
            where buf_units.unit-name = goods.unit-base
        .
        assign
            v-not-gold  = ?
        .
        if lookup({&twounit}, buf_units.type) <> 0
        then do:
            run get-cli-qnty in this-procedure
                             (    input recid( doc-line )
                                , output qnty-pl
                             ).
            assign
                /*qnty-pl     = doc-line.cli-qnty*/
                v-not-gold  = no
            .
        end.
        if lookup({&altunit}, buf_units.type) <> 0
        then do:
            assign
                qnty-pl     = doc-line.doc-qnty
                v-not-gold  = no
            .
        end.
        if  v-not-gold  = ?
        then do:
            assign
                v-not-gold  = yes
            .
        end.
        /*---END----------- Определили, золото это или нет и вычислили кол-во мест ---------------------*/
    end.
    /*---START--------- Очистили и заполнили temp-table с именем товара по строкам ---------------------*/
    assign
        v-gds-name  = goods.gds-name
    .
    for each temp_gds-name exclusive-lock
    :
        delete temp_gds-name.
    end.
    create temp_gds-name.
    assign
        s1 = breakstr( v-gds-name,  28, input-output temp_gds-name.gds-name, input-output s2)
        v-gds-name-counter          = 1
        temp_gds-name.string-num    = 1
    .
    do while s2 <> "" :
        create temp_gds-name.
        assign
            s1                          = breakstr( input s2
                                                  , input 28
                                                  , input-output temp_gds-name.gds-name
                                                  , input-output s2
                                                  )
            v-gds-name-counter          = v-gds-name-counter + 1
            temp_gds-name.string-num    = v-gds-name-counter
        .
    end. /* do while ... */
    find first temp_gds-name no-lock .
/*                                                                    assign*/
/*                                                                        s1 = ""*/
/*                                                                    .*/
/*                                                                    for each temp_gds-name no-lock*/
/*                                                                    :*/
/*                                                                        assign*/
/*                                                                            s1 = s1 + {&new-line} + string(temp_gds-name.string-num) + ". " + temp_gds-name.gds-name*/
/*                                                                        .*/
/*                                                                    end.*/
/*                                                                    message*/
/*                                                                        s1*/
/*                                                                    view-as alert-box.*/

    /*---END----------- Очистили и заполнили temp-table с именем товара по строкам ---------------------*/

    find first gds-prt no-lock
            where gds-prt.upper-code = goods.prt-root
    .
    assign
        rootnode_code = gds-prt.node-code.
    .
    if costprice
    then do:
        { str/in-vatp.i calc doc-line. t-doc. g}
        assign PricendS = ( if PrintRubl then vat-rubl-loc else vat-base-loc ).
        if PricendS = ? then assign PricendS = 0.
        assign
            PricewithNDS = ( if PrintRubl then price-rubl-with-tax-loc else price-base-with-tax-loc )
            PriceNoNDS = PricewithNDS - PricendS
        .
    end.
    else do:
        { str/out-vatp.i calc doc-line. t-doc.}
        assign PricendS = ( if PrintRubl then vat-rubl-sale else vat-base-sale ).
        if PricendS = ? then assign PricendS = 0.
        assign
            PricewithNDS = ( if PrintRubl then price-rubl-with-tax-sale else price-base-with-tax-sale )
            PriceNoNDS = PricewithNDS - PricendS
        .
    end.
    if not can-do( {&empty-scale}, gds-prt.node-name )
    then do:                                  /* Не пустая шкала */
            if PrintScale = yes
            then do:
                if p-print-gold = yes
                then do:
                    if costprice = yes
                    then do:
                        display stream Out-stream
                            temp_gds-name.gds-name
                            goods.artic
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                            with frame f-doc-cost-gold .
                        down stream Out-stream 1 with frame f-doc-cost-gold .
                        { rep/torg-13x.i no-sum cost -gold}
                    end.        /* costprice = yes */
                    else do:
                        display stream Out-stream
                            temp_gds-name.gds-name
                            goods.artic
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                            with frame f-doc-doc-gold .
                        down stream Out-stream 1 with frame f-doc-doc-gold .
                        { rep/torg-13x.i no-sum doc -gold}
                    end.
                end.            /* p-print-gold = yes */
                else do:
                    if costprice = yes
                    then do:
                        display stream Out-stream
                            temp_gds-name.gds-name
                            goods.artic
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                            with frame f-doc-cost .
                        down stream Out-stream 1 with frame f-doc-cost .
                        { rep/torg-13x.i no-sum cost}
                    end.
                    else do:    /* costprice = no */
                        display stream Out-stream
                            temp_gds-name.gds-name
                            goods.artic
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                            with frame f-doc-doc .
                        down stream Out-stream 1 with frame f-doc-doc .
                        { rep/torg-13x.i no-sum doc}
                    end.
                end.
                assign
                    LineCounter = LineCounter + 1
                .
                if p-break-name = yes
                then do:
                    run display-gds-name in this-procedure .
                end.
            end.  /* PrintScale = yes */
            assign
                sum-prt-tqnty       = 0
                sum-prt-SumNoNDS    = 0
                sum-prt-SumNDS      = 0
                sum-prt-SumwithNDS  = 0
            .
            for each gds-dtl no-lock
               where gds-dtl.prod-type = doc-line.prod-type
                 and gds-dtl.prod-code = doc-line.prod-code
                 and gds-dtl.artic = doc-line.artic
                 and gds-dtl.doc-code = doc-line.doc-code
            :
                find first gds-prt no-lock
                     where gds-prt.node-code = gds-dtl.prt-code
                .

                assign
                    prt-tqnty =  gds-dtl.fact-qnty
                    prt-SumNoNDS = PriceNoNDS * prt-tqnty
                    prt-SumNDS = PricendS * prt-tqnty
                    prt-SumwithNDS = PricewithNDS * prt-tqnty
                .
                assign
                    sum-prt-tqnty       = sum-prt-tqnty      +  prt-tqnty
                    sum-prt-SumNoNDS    = sum-prt-SumNoNDS   +  prt-SumNoNDS
                    sum-prt-SumNDS      = sum-prt-SumNDS     +  prt-SumNDS
                    sum-prt-SumwithNDS  = sum-prt-SumwithNDS +  prt-SumwithNDS
                .
                if PrintScale = yes
                then do:
                    find first bar-code no-lock
                            where bar-code.gds-code  = goods.gds-code
                            and bar-code.unit-cli  = goods.unit-base
                            and bar-code.node-code = gds-dtl.prt-code
                            and bar-code.part-code = ""
                            and bar-code.in-code   = ""
                    .
                    assign
                        PrtName = goods.gds-name + "//" + gds-prt.f-name
                    .
                    if p-print-gold = yes
                    then do:
                        if costprice = yes
                        then do:
                            display stream Out-stream
                                    PrtName @     temp_gds-name.gds-name
                                    string( bar-code.b-code ) @ tb-code
                                    goods.unit-base
                                    prt-tqnty @ tqnty
                                    PricewithNDS
                                    prt-SumNoNDS @ SumNoNDS
                                    prt-SumwithNDS @ SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                                    with frame f-doc-cost-gold .
                            down stream Out-stream 1 with frame f-doc-cost-gold .
                            { rep/torg-13x.i prt- cost -gold}
                        end.        /* costprice = yes */
                        else do:
                            display stream Out-stream
                                    PrtName @     temp_gds-name.gds-name
                                    string( bar-code.b-code ) @ tb-code
                                    goods.unit-base
                                    prt-tqnty @ tqnty
                                    PriceNoNDS
                                    PricewithNDS
                                    prt-SumNoNDS @ SumNoNDS
                                    prt-SumwithNDS @ SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                                    with frame f-doc-doc-gold .
                            down stream Out-stream 1 with frame f-doc-doc-gold .
                            { rep/torg-13x.i prt- doc -gold}
                        end.
                    end.        /* p-print-gold = yes */
                    else do:
                        if costprice = yes
                        then do:
                            display stream Out-stream
                                    PrtName @     temp_gds-name.gds-name
                                    string( bar-code.b-code ) @ tb-code
                                    goods.unit-base
                                    prt-tqnty @ tqnty
                                    PricewithNDS
                                    prt-SumNoNDS @ SumNoNDS
                                    prt-SumwithNDS @ SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                                    with frame f-doc-cost .
                            down stream Out-stream 1 with frame f-doc-cost .
                            { rep/torg-13x.i prt- cost}
                        end.        /* costprice = yes */
                        else do:
                            display stream Out-stream
                                    PrtName @     temp_gds-name.gds-name
                                    string( bar-code.b-code ) @ tb-code
                                    goods.unit-base
                                    prt-tqnty @ tqnty
                                    PricewithNDS
                                    prt-SumNoNDS @ SumNoNDS
                                    prt-SumwithNDS @ SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                                    with frame f-doc-doc .
                            down stream Out-stream 1 with frame f-doc-doc .
                            { rep/torg-13x.i prt- doc}
                        end.
                    end. /* p-print-gold = no */
                end.       /* PrintScale = yes */
            end.        /*for each gds-dtl ...*/

            assign
                tqnty       = sum-prt-tqnty
                SumNoNDS    = sum-prt-SumNoNDS
                SumNDS      = sum-prt-SumNDS
                SumwithNDS  = sum-prt-SumwithNDS
            .

            if not PrintScale
            then do:
                    find bar-code where bar-code.gds-code  = goods.gds-code
                                    and bar-code.unit-cli  = goods.unit-base
                                    and bar-code.node-code = rootnode_code
                                    and bar-code.part-code = ""
                                    and bar-code.in-code   = ""
                    no-lock .
                    if p-print-gold = yes
                    then do:
                        if costprice = yes
                        then do:
                            display stream Out-stream
                                    goods.artic
                                    temp_gds-name.gds-name
                                    goods.sort
                                    string( bar-code.b-code ) @ tb-code
                                    goods.unit-base
                                    tqnty
                                    PricewithNDS
                                    SumNoNDS
                                    SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                                    with frame f-doc-cost-gold .
                            down stream Out-stream 1 with frame f-doc-cost-gold .
                            { rep/torg-13x.i " " cost -gold}
                        end.           /* costprice = yes */
                        else do:
                            display stream Out-stream
                                    temp_gds-name.gds-name
                                    goods.artic
                                    string( bar-code.b-code ) @ tb-code
                                    goods.sort
                                    goods.unit-base
                                    tqnty
                                    PricewithNDS
                                    SumNoNDS
                                    SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                                    with frame f-doc-doc-gold .
                            down stream Out-stream 1 with frame f-doc-doc-gold .
                            { rep/torg-13x.i " " doc -gold}
                        end.        /* costprice = no */
                    end.        /* p-print-gold = yes */
                    else do:
                        if costprice = yes
                        then do:
                            display stream Out-stream
                                    temp_gds-name.gds-name
                                    goods.artic
                                    string( bar-code.b-code ) @ tb-code
                                    goods.unit-base
                                    tqnty
                                    PricewithNDS
                                    SumNoNDS
                                    SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                                    with frame f-doc-cost .
                            down stream Out-stream 1 with frame f-doc-cost .
                            { rep/torg-13x.i " " cost}
                        end.           /* costprice = yes */
                        else do:
                            display stream Out-stream
                                    temp_gds-name.gds-name
                                    goods.artic
                                    string( bar-code.b-code ) @ tb-code
                                    goods.unit-base
                                    tqnty
                                    PricewithNDS
                                    SumNoNDS
                                    SumwithNDS
                                    sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                                    with frame f-doc-doc .
                            down stream Out-stream 1 with frame f-doc-doc .
                            { rep/torg-13x.i " " doc}
                        end.        /* costprice = no */
                    end.        /* p-print-gold = no */
                    LineCounter = LineCounter + 1 .
                    if p-break-name = yes
                    then do:
                        run display-gds-name in this-procedure .
                    end.
                end.
    end.
    else do:    /* пустая шкала */
            find first bar-code no-lock
                 where bar-code.gds-code = goods.gds-code
                   and bar-code.unit-cli = goods.unit-base
                   and bar-code.node-code = rootnode_code
                   and bar-code.part-code = ""
                   and bar-code.in-code = ""
            .
            find first gds-dtl no-lock
                 where gds-dtl.doc-code = doc-line.doc-code
                   and gds-dtl.prod-type = doc-line.prod-type
                   and gds-dtl.prod-code = doc-line.prod-code
                   and gds-dtl.artic = doc-line.artic
                   and gds-dtl.prt-code = rootnode_code
            .
            assign
                tqnty = gds-dtl.fact-qnty
                unit-str = goods.unit-base
                SumNoNDS = PriceNoNDS * tqnty
                SumNDS = PricendS * tqnty
                SumwithNDS = PricewithNDS * tqnty
            .
            if p-print-gold = yes
            then do:
                if costprice = yes
                then do:
                    display stream Out-stream
                        goods.artic
                        temp_gds-name.gds-name
                        goods.sort
                        string( bar-code.b-code ) @ tb-code
                        unit-str @ goods.unit-base
                        tqnty
                        PricewithNDS
                        SumNoNDS
                        SumwithNDS
                        sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                        with frame f-doc-cost-gold .
                    down stream Out-stream 1 with frame f-doc-cost-gold .
                    { rep/torg-13x.i " " cost -gold}
                end.       /* costprice = yes */
                else do:
                    display stream Out-stream
                        goods.artic
                        temp_gds-name.gds-name
                        goods.sort
                        string( bar-code.b-code ) @ tb-code
                        unit-str @ goods.unit-base
                        tqnty
                        PricewithNDS
                        SumNoNDS
                        SumwithNDS
                        sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                        with frame f-doc-doc-gold .
                    down stream Out-stream 1 with frame f-doc-doc-gold .
                    { rep/torg-13x.i " " doc -gold}
                end.       /* costprice = no */
            end.        /* p-print-gold = yes */
            else do:
                if costprice = yes
                then do:
                    display stream Out-stream
                        goods.artic
                        temp_gds-name.gds-name
                        string( bar-code.b-code ) @ tb-code
                        unit-str @ goods.unit-base
                        tqnty
                        PricewithNDS
                        SumNoNDS
                        SumwithNDS
                        sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                        with frame f-doc-cost .
                    down stream Out-stream 1 with frame f-doc-cost .
                    { rep/torg-13x.i " " cost}
                end.       /* costprice = yes */
                else do:
                    display stream Out-stream
                        goods.artic
                        temp_gds-name.gds-name
                        string( bar-code.b-code ) @ tb-code
                        unit-str @ goods.unit-base
                        tqnty
                        PricewithNDS
                        SumNoNDS
                        SumwithNDS
                        sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                        with frame f-doc-doc .
                    down stream Out-stream 1 with frame f-doc-doc .
                    { rep/torg-13x.i " " doc}
                end.       /* costprice = no */
            end.        /* p-print-gold = no */
            LineCounter = LineCounter + 1.
            if p-break-name = yes
            then do:
                run display-gds-name in this-procedure .
            end.
    end.

    assign
        sum-tqnty       =   sum-tqnty       + tqnty
        sum-SumNoNDS    =   sum-SumNoNDS    + SumNoNDS
        sum-SumNDS      =   sum-SumNDS      + SumNDS
        sum-SumwithNDS  =   sum-SumwithNDS  + SumwithNDS
    .
end.
end procedure. /* print-doc-line */





/*==============================================================*/
/*---S-------- Печать линии группы в документе -----------------*/
procedure print-group-line :
do
on error undo, return error
:
  put stream out-stream
      skip
      ":" space(5)
      "Группа  " space(2)
      goods.grp-name format "X(100)"
  .
/*  down stream out-stream 1 with frame f-doc .*/
end.
end procedure. /* print-group-line */
/*---E-------- Печать линии группы в документе -----------------*/

/*==============================================================*/
/*---S------ Печать линии производителя в документе ------------*/
procedure print-prod-line :
do
on error undo, return error
:
  put stream out-stream
      skip
      ":" space(5)
      "Производитель  " space(2)
      string(clients.obj-code) + {&space-char} + clients.obj-name format "X(100)"
  .
/*  down stream out-stream 1 with frame f-doc .*/
end.
end procedure. /* print-group-line */
/*---E------ Печать линии производителя в документе ------------*/

/*==========================================================================*/
procedure display-gds-name :
do
on error undo, return error
:
    for each temp_gds-name
    break by temp_gds-name.string-num
    :
        if not first(temp_gds-name.string-num)
        then do:
            if p-print-gold = yes
            then do:
                if costprice = yes
                then do:
                    display stream out-stream
                            temp_gds-name.gds-name
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                            with frame f-doc-cost-gold .
                    down stream out-stream 1 with frame f-doc-cost-gold .
                    { rep/torg-13x.i no-sum cost -gold}
                end.
                else do:
                    display stream out-stream
                            temp_gds-name.gds-name
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9 sym10
                            with frame f-doc-doc-gold .
                    down stream out-stream 1 with frame f-doc-doc-gold .
                    { rep/torg-13x.i no-sum doc -gold}
                end.
            end.        /* p-print-gold = yes */
            else do:
                if costprice = yes
                then do:
                    display stream out-stream
                            temp_gds-name.gds-name
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                            with frame f-doc-cost .
                    down stream out-stream 1 with frame f-doc-cost .
                    { rep/torg-13x.i no-sum cost}
                end.
                else do:
                    display stream out-stream
                            temp_gds-name.gds-name
                            sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
                            with frame f-doc-doc .
                    down stream out-stream 1 with frame f-doc-doc .
                    { rep/torg-13x.i no-sum doc}
                end.
            end.        /* p-print-gold = no */
            assign
                LineCounter = LineCounter + 1
            .
        end.        /* not first(temp_gds-name.string-num) */
    end.        /* for each temp_gds-name */
end.
end procedure. /* display-gds-name */




/*==========================================================================*/
procedure get-cli-qnty :
do
on error undo, return error
:
def input parameter p-doc-line-recid    as recid                no-undo.
def output parameter p-cli-qnty         like doc-line.cli-qnty  no-undo.

    def buffer buf_gold_parts       for parts.
    def buffer buf_gold_doc-line    for doc-line.

    find first buf_gold_doc-line no-lock
         where recid(buf_gold_doc-line) = p-doc-line-recid
    .
    assign
        p-cli-qnty = 0
    .
    for each buf_gold_parts no-lock
       where buf_gold_parts.obj-type     = buf_gold_doc-line.obj-type
         and buf_gold_parts.obj-code     = buf_gold_doc-line.obj-code
         and buf_gold_parts.artic        = buf_gold_doc-line.artic
         and buf_gold_parts.prod-type    = buf_gold_doc-line.prod-type
         and buf_gold_parts.prod-code    = buf_gold_doc-line.prod-code
         and buf_gold_parts.out-code     = buf_gold_doc-line.doc-code
    :
        if buf_gold_parts.fact-qnty <> 0
        then do:
            assign
                p-cli-qnty = p-cli-qnty + buf_gold_parts.cli-qnty
            .
        end.
    end.
end.
end procedure. /* get-cli-qnty ( input buf_doc-line ) */