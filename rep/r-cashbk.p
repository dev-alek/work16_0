/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Кассовая книга

Автор: Комаров Иван Сергеевич
Дата создания: 02/02/10
Author: Ivan Komarov
Creation date: 02/02/10

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle          as handle                  no-undo .
define input parameter p-log-handle             as handle                  no-undo .
define input parameter p-cont-handle            as handle                  no-undo .
define input parameter p-call-handle            as handle                  no-undo .
define input parameter p-rebh                   as handle                  no-undo . /*для ошибок*/
define input parameter p-rdbh                   as handle                  no-undo . /*destination*/
define input parameter p-report-id              as character               no-undo .
define input parameter p-log-file-name          as character               no-undo .
define input parameter p-batch                  as integer                 no-undo .
define input parameter p-codex-id               as integer                 no-undo .
define input parameter p-ruleset-id             as integer                 no-undo .
define input parameter p-print-form             as integer                 no-undo .
define input parameter p-plain-txt              as   logical               no-undo .
define input parameter p-xls                    as   logical               no-undo .
define input parameter p-dir-name               as   character             no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Кассовая книга".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/r-page1.i  }
{ cmp/r-pril.i new }
{ rep/r-sym.i    }
{ rep/f-fdec.i   }
{ gbl/cur-time.i }
{ gbl/prn-lib.i  }
{ ref/grplib.i   }
{ cmp/library.i  }
{ str/lib-trn.i  }
{ rep/r-sale.i   }
{ trg/factord.i  }
define variable g#report-num as integer no-undo .
{ gbl/paramls.i  }
{ rep/ostatok.i  }
{ rep/fostatok.i  &arh-name = "arh-fin-doc-schet-nal-obj" }
{ rep/ost-line.i }
{ str/farh-def.i }
{ cmp/trg-def.i  }
{ rep/reprumpr.i print-plain-text,print-printer,print-xls }
{ gbl/std-func.i }


&scop display-message ~
   if p-batch > 0 then do: ~
     run write-log-and-file in p-log-handle ( ~
                input 1                            ~
              , input p-log-file-name                ~
              , input 1                            ~
              , input ~{&my-message}~). ~
   end. ~
   else do: ~
      run write-to-log in p-log-handle ( input ~{&my-message~}). ~
   end




  run get-report-num  in parparentproc (output  g#report-num).
  { gbl/getcntxt.i def }
  { gbl/getcntxt.i get }
  define variable v-cntxt-obj-name      as character no-undo .

define temp-table temp-fin-doc no-undo
  FIELD host-code        as integer
  FIELD prn-doc-code     as character
  FIELD fin-doc-code     as integer
  FIELD fin-doc-type     as character
  FIELD payer            as character
  FIELD receiver         as character
  FIELD cor-acc          as character
  FIELD sum-rubl         as decimal
  FIELD obj-code         as integer
  FIELD obj-type         as character
  FIELD sheet-num        as integer

  INDEX pi is primary unique sheet-num host-code obj-code obj-type fin-doc-code
  .

define buffer buf_clients                   for ub.clients .
define buffer buf_obj-list                  for obj-list .
define buffer buf_fin-doc                   for ub.fin-doc .
define buffer buf_arh-fin-doc-schet-nal-obj for ub.arh-fin-doc-schet-nal-obj .
define buffer buf_shift-obj                 for ub.shift-obj .

define variable v-count       as integer   no-undo .
define variable v-str         as integer   no-undo .
define variable v-firm        as character no-undo .
define variable v-object      as character no-undo .
define variable v-host-code   as integer   no-undo .
define variable v-date-start  AS DATE FORMAT "99/99/9999" no-undo .
define variable v-date-end    AS DATE FORMAT "99/99/9999" no-undo .
define variable v-shift-start AS integer   no-undo .
define variable v-shift-end   AS integer   no-undo .
define variable f-prn-doc-code as character no-undo.
define variable f-payer       as character no-undo .
define variable f-corr-acc    as character no-undo .
define variable f-income      as character no-undo .
define variable f-expense     as character no-undo .
define variable v-income      as decimal   no-undo .
define variable v-expense     as decimal   no-undo .
define variable v-kolvo-pko   as integer   no-undo .
define variable v-kolvo-rko   as integer   no-undo .
define variable v-pko-propis  as character no-undo .
define variable v-rko-propis  as character no-undo .
define variable v-saldo       as decimal   no-undo .
define variable v-sum-i       as decimal   no-undo .
define variable v-sum-e       as decimal   no-undo .
define variable v-ost-begin   as decimal   no-undo .
define variable v-sum-begin   as decimal   no-undo .
define variable sum           as decimal   no-undo .
define variable sum1          as decimal   no-undo .
define variable v-tab110      as character no-undo .

define variable x-store-code    like ub.clients.obj-code   no-undo.
define variable x-store-type    like ub.clients.obj-type   no-undo.

define variable  Fact-order-1   like ub.stk-tot.Fact-order no-undo.
define variable  Fact-order-2   like ub.stk-tot.Fact-order no-undo.
define variable  Fact-order-0   like ub.stk-tot.Fact-order no-undo.

define variable v-ind             as integer   no-undo .
define variable num#col#          as integer   no-undo .
define variable str10             as character no-undo .
define variable Counter1          as integer   no-undo .
define variable v-num-obj         as integer   no-undo .
define variable v-page            as integer   no-undo .
define variable v-strok           as integer   no-undo .
define variable v-strok1          as integer   no-undo .
define variable v-strok2          as integer   no-undo .
define variable v-date-name       as character no-undo .
define variable v-obj-name        as character no-undo .
define variable v-shift-on        as logical   no-undo .

define variable v-sheet-num       as integer   init 1 no-undo .

define variable v-user-action     as character no-undo .
define variable v-printed         as logical   no-undo .
define variable disabledoptions   as integer   no-undo .
define variable v-orient-page     as character no-undo .
define variable v-obj-type        as character no-undo .
define variable v-obj-code        as integer   no-undo init -1.


define stream  macr_excel .
define stream  out-stream .

define variable v-file-name       as character no-undo .
define variable v-file-name-ind   as integer   no-undo .
define variable v-line            as character no-undo .
   assign
      v-line  = fill( "-" , 100 )
      v-tab110 = fill( " " , 110  )
   .

  { cmp/open-out.i stream out-stream  " " }

  if p-xls then do:
  assign
    make-excel      = yes
    v-file-name     = string(session :temp-directory) + {&DF_Name} + string( g#report-num ) + ".txt"
    v-file-name-ind = 1
  .
  end.
  for each sheetf :
      delete sheetf.
  end.
  define frame cashbk
          sym1                column-label ":!:!:" format "X(1)" space(0)
          f-prn-doc-code      column-label "  Номер!документа" format "X(10)" space(0)
          sym2                column-label ":!:!:" format "X(1)" space(0)
          f-payer             column-label "    От кого получено или кому выдано    ! " format "X(45)" space(0)
          sym3                column-label ":!:!:" format "X(1)" space(0)
          f-corr-acc          column-label "Номер коррес-!пондирующего!счета, субсчета" format "X(15)" space(0)
          sym4                column-label ":!:!:" format "X(1)" space(0)
          f-income            column-label "   Приход,! руб.коп.!  " format "X(12)" space(0)
          sym5                column-label ":!:!:" format "X(1)" space(0)
          f-expense           column-label "   Расход,! руб.коп.!  " format "X(12)" space(0)
          sym6                column-label ":!:!:" format "X(1)" space(0)
  header
          str1 at 5  format "X(100)"
          str2 at 50 format "X(75)"
          string( "Касса за ") + v-date-name at 5 format "X(50)"
          string( "Лист____" ) at 90 format "X(8)"
          v-line format "X(100)" at 1
  with width {&DOS_CW} down stream-io.

  { gbl/working.i }

    assign  Counter1 = 0 .
    { rep/repfrm.i def }   /* Показать окно информации о текущем процессе */
    { rep/repfrm.i on 1 } /* Показать окно информации о текущем процессе */

    find first buf_clients
          where buf_clients.obj-type = {&cmp}
          and   buf_clients.obj-code = v-cntxt-host-code-obj
          no-lock
          .
    assign v-firm = buf_clients.obj-name  .

    for each obj-list by obj-list.obj-name :
      if v-obj-code = -1 then do:
        assign
        v-obj-type = obj-list.obj-type
        v-obj-code = obj-list.obj-code.
      end.
      else do:
        assign
        v-obj-type = ''
        v-obj-code = 0
        .
      end.
      assign
        v-shift-on = yes
      .
      if x-tog-shift then do :
        { gbl/objat.i
        obj-list.obj-type
        obj-list.obj-code
        "'shift-on=request'"
        v-shift-on
        no-error
        }
        if error-status :error
        then do:
         &scop my-message substitute("&1 &2 &3&4" +  ~
                                       "Невозможно определить тип сменный/не сменный&4" + ~
                                       "для заданного объекта.&4" + ~
                                       "Объект: &5&6&4&7&4&8"  ~
                                       ,vss-workfile  ~
                                       ,vss-revision  ~
                                       ,vss-description ~
                                       ,~{&new-line~} ~
                                       ,obj-list.obj-type  ~
                                       ,obj-list.obj-code ~
                                       , return-value   ~
                                       ,error-status:get-message(1) )
          {&display-message}.
            undo, return error .
        end.
        if v-shift-on = no
        then do:
          &scop my-message substitute("Неверно задан тип объекта &1&2&3"  + ~
                                      "Объект не сменный." ~
                                      ,obj-list.obj-type ~
                                      ,obj-list.obj-code ~
                                      , ~{&new-line~} )
          {&display-message}.
          undo, return error .
        end.
      end.

      if v-shift-on or x-tog-shift = no then do :
        if v-obj-name <> "" then do :
          assign
            v-obj-name = v-obj-name + ", " + obj-list.obj-name
          .
        end.
        else do :
          assign
            v-obj-name = obj-list.obj-name
          .
        end.
      end.
    end .
    if length(v-obj-name) > 100 then v-obj-name = substring(v-obj-name, 1, 95) + "..." .


    find first obj-list
        where obj-list.obj-type = v-cntxt-obj-type
          and obj-list.obj-code = v-cntxt-obj-code
          no-error .
        if available obj-list then do :
            assign v-cntxt-obj-name = obj-list.obj-name .
        end .
    assign
        v-date-start  = x-date-start
        v-date-end    = x-date-end
    .
    do while v-date-start <> (v-date-end + 1) :
        for each   temp-fin-doc :
            delete temp-fin-doc .
        end .

        create sheetf.
        assign
          sheetf.sheet-num = v-sheet-num
          sheetf.Excel-Column-Lable = "Номер документа,От кого получено или кому выдано,Номер коррес-пондирующего счета\субсчета,Приход руб.коп.,Расход руб.коп."
          sheetf.Sizes  = "10,40,15,11,11"
          Sheetf.ColFOrmat   = "1=@;2=@;3=@;4=0.00;5=0.00"
          Make-excel = p-xls  /*иногда не хотим пеачать в excel!!!*/
          Make-excel-com = false
          Sheetf.Bas-File      = "exe/cash-bk.bas"
      .

        assign
          v-strok  = 0
          v-strok1 = 0
          v-strok2 = 0
          v-ost-begin = 0
        .
        if v-date-start = x-date-end   then v-shift-end   = x-shift-end.
        if v-date-start = x-date-start then v-shift-start = x-shift-start.

        run report-exec in this-procedure (input v-date-start, output v-strok ).
        if X-SelectObject = {&obj-firm} then do :
            assign         str1 = "Организация: " + v-firm .
        end .
        else do :
            assign          str1 = v-obj-name .
        end.

        if p-print-form = 1 then do :
            assign         str2 = "Вкладной лист кассовой книги" .
        end .
        else do :
            assign          str2 = "Отчет кассира" .
        end .
        assign
          v-date-name = string(day(v-date-start)) + " " + MonthNameRusGen(MONTH ( v-date-start )) + " " + string(year(v-date-start))
        .
        if x-tog-shift then do :
            if v-date-start = x-date-start then do :
              assign
                v-date-name = v-date-name + ". Смена с " + string(x-shift-start)
              .
            end.
            else do :
              assign
                v-date-name = v-date-name + ". Смена с 0 "
              .
            end.
            if v-date-start = x-date-end then do :
              assign
                v-date-name = v-date-name + " по " + string(x-shift-end)
              .
            end.
            else do :
              assign
                v-date-name = v-date-name + " по " + string({&max-shift-num})
              .
            end.
        end.
        assign
          ReportHeader = "Касса за " + v-date-name + v-tab110 + "Лист____"
        .
        if v-page > 0 then do :
            down stream Out-stream 70 with frame cashbk .
        end.

        if v-strok > 48 then do :
          assign
            v-strok1 = v-strok - 48
            v-strok2 = 1
          .
        end.
        do while v-strok1 >= 51 :
            assign
              v-strok1 = v-strok1 - 51
              v-strok2 = v-strok2 + 1
            .
        end.
        run my-extitle in this-procedure ( input sheetf.sheet-num).
        assign
          Sheetf.Bas-Params    = string(v-strok + v-strok2 )
        .

        display stream Out-stream
        sym1 sym3 sym4 sym5 sym6
        "                      Остаток на начало дня"  @ f-payer
        string(v-ost-begin, "->>>>>>>>.99")            @ f-income
        "     X"                                       @ f-expense
        with frame cashbk .
        down stream Out-stream 1 with frame cashbk .

        {&PutExcel}
        ""                                   {&tabulation}
        "Остаток на начало дня"              {&tabulation}
        ""                                   {&tabulation}
        v-ost-begin                          {&tabulation}
        "X"                                  {&new-line}
        .
        assign
            v-page      = 1
            v-count     = 0
            v-kolvo-pko = 0
            v-kolvo-rko = 0
            v-income    = 0
            v-expense   = 0
        .
        for each temp-fin-doc where temp-fin-doc.sheet-num = v-sheet-num no-lock by temp-fin-doc.prn-doc-code :
            {&PutExcel}
              temp-fin-doc.prn-doc-code                                                                                    {&tabulation}
              (if temp-fin-doc.fin-doc-type = {&income-cash}  then temp-fin-doc.payer else temp-fin-doc.receiver)          {&tabulation}
              temp-fin-doc.cor-acc                                                                                         {&tabulation}
              (if temp-fin-doc.fin-doc-type = {&income-cash}  then string(temp-fin-doc.sum-rubl, "->>>>>>>>.99") else "-") {&tabulation}
              (if temp-fin-doc.fin-doc-type = {&expense-cash} then string(temp-fin-doc.sum-rubl, "->>>>>>>>.99") else "-") {&new-line}
              .

              display stream Out-stream
              sym1 sym2 sym3 sym4 sym5 sym6
              temp-fin-doc.prn-doc-code                                                                        @ f-prn-doc-code
              temp-fin-doc.payer                            when temp-fin-doc.fin-doc-type  = {&income-cash}   @ f-payer
              temp-fin-doc.receiver                         when temp-fin-doc.fin-doc-type  = {&expense-cash}  @ f-payer
              temp-fin-doc.cor-acc                                                                             @ f-corr-acc
              string(temp-fin-doc.sum-rubl, "->>>>>>>>.99") when temp-fin-doc.fin-doc-type  = {&income-cash}   @ f-income
              "         -"                                  when temp-fin-doc.fin-doc-type  = {&income-cash}   @ f-expense
              "         -"                                  when temp-fin-doc.fin-doc-type  = {&expense-cash}  @ f-income
              string(temp-fin-doc.sum-rubl, "->>>>>>>>.99") when temp-fin-doc.fin-doc-type  = {&expense-cash}  @ f-expense
              with frame cashbk .
              down stream Out-stream 1 with frame cashbk .
              assign
                v-count = v-count + 1
              .

              if temp-fin-doc.fin-doc-type  = {&income-cash} then do :
                assign
                  v-income    = v-income    + temp-fin-doc.sum-rubl
                  v-kolvo-pko = v-kolvo-pko + 1
                .
              end.
              else do :
                assign
                  v-expense   = v-expense   + temp-fin-doc.sum-rubl
                  v-kolvo-rko = v-kolvo-rko + 1
                .
              end.
              if (v-count = 48 and v-page = 1 ) or (v-count = 51 and v-page > 1 ) then do :
              assign
                str1 = ""
                str2 = ""
              .
                  {&PutExcel}
                  ""                                   {&tabulation}
                  "Перенесено на следующий лист"       {&tabulation}
                  ""                                   {&tabulation}
                  string(v-income,  "->>>>>>>>.99")    {&tabulation}
                  string(v-expense, "->>>>>>>>.99")    {&new-line}
                  .
                  if v-page = 1 then do :
                      display stream Out-stream
                      sym1 sym4 sym5 sym6
                      "              Перенесено на следующий лист"   @ f-payer
                      string(v-income,  "->>>>>>>>.99")  @ f-income
                      string(v-expense, "->>>>>>>>.99")  @ f-expense
                      with frame cashbk .
                      down stream Out-stream 4 with frame cashbk .
                  end .
                  else do :
                      display stream Out-stream
                      sym1 sym4 sym5 sym6
                      "              Перенесено на следующий лист"   @ f-payer
                      string(v-income,  "->>>>>>>>.99")  @ f-income
                      string(v-expense, "->>>>>>>>.99")  @ f-expense
                      with frame cashbk .
                      down stream Out-stream 1 with frame cashbk .
                  end .
                  assign
                      v-count = 0
                      v-page  = v-page + 1
                  .
              end.
        end .
        run rep/wp-qnty.p ( input v-kolvo-pko, output v-pko-propis ).
        if v-pko-propis = '' then do :
          v-pko-propis = 'Ноль'.
        end.
        run rep/wp-qnty.p ( input v-kolvo-rko, output v-rko-propis ).
        if v-rko-propis = '' then do :
          v-rko-propis = 'Ноль'.
        end.
        {&PutExcel}
          ""                                   {&tabulation}
          "Итого за день"                      {&tabulation}
          ""                                   {&tabulation}
          v-income                             {&tabulation}
          v-expense                            {&new-line}
          ""                                   {&tabulation}
          "Остаток на конец дня"               {&tabulation}
          ""                                   {&tabulation}
          (v-ost-begin + v-income - v-expense) {&tabulation}
          "X"                                  {&new-line}
          ""                                   {&tabulation}
          "В том числе на заработную плату, выплаты"   {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          ""                                   {&tabulation}
          "социального характера и стипендии"  {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          .
        {&PutExcel}
          "Кассир"                             {&tabulation}
          "______________________"             {&tabulation}
          "______________________"             {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          ""                                   {&tabulation}
          "       подпись"                     {&tabulation}
          "расшифровка подписи"                {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          "Записи в кассовой книге проверил и документы в количестве" {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          string(v-pko-propis) + " приходных и " + string(v-rko-propis) + " расходных получил."  {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          "Бухгалтер"                          {&tabulation}
          "______________________"             {&tabulation}
          "______________________"             {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          ""                                   {&tabulation}
          "       подпись"                     {&tabulation}
          "расшифровка подписи"                {&tabulation}
          ""                                   {&tabulation}
          ""                                   {&new-line}
          .

        put stream out-stream v-line format "X(100)" skip.
        display stream Out-stream
        sym1 sym3 sym4 sym5 sym6
        "                             Итого за день" @ f-payer
        string(v-income,  "->>>>>>>>.99")            @ f-income
        string(v-expense, "->>>>>>>>.99")            @ f-expense
        with frame cashbk .
        down stream Out-stream 1 with frame cashbk .

        put stream out-stream v-line format "X(100)" skip.
        display stream Out-stream
        sym1 sym3 sym4 sym5 sym6
        "                      Остаток на конец дня"  @ f-payer
        string((v-ost-begin + v-income - v-expense),  "->>>>>>>>.99")     @ f-income
        "     X"                                      @ f-expense
        with frame cashbk .
        down stream Out-stream 1 with frame cashbk .


        put stream out-stream v-line format "X(100)" skip.
        display stream Out-stream
        sym1 sym3 sym4 sym5 sym6
        "  В том числе на заработную плату, выплаты"   @ f-payer
        with frame cashbk .
        down stream Out-stream 1 with frame cashbk .
        display stream Out-stream
        sym1 sym3 sym4 sym5 sym6
        "         социального характера и стипендии"   @ f-payer
        "     X"                                       @ f-expense
        with frame cashbk .
        down stream Out-stream 1 with frame cashbk .
        put stream out-stream v-line format "X(100)" skip.


        PUT STREAM Out-Stream
          space(0) "Кассир" format "X(10)"                                                             skip
                            "_____________________    _______________________"  format "X(50)" at 10   skip
                            "     (подпись)           (расшифровка подписи)  "  format "X(50)" at 10   skip
          space(0) "Записи в кассовой книге проверил и документы в количестве " format "X(80)"         skip
          space(0) v-pko-propis + " приходных и "
                + v-rko-propis + " расходных получил."                          format "X(80)"         skip
          " "                                                                                          skip
          space(0) "Бухгалтер" format "X(10)"                                                          skip
                            "_____________________    _______________________"  format "X(50)" at 10   skip
                            "     (подпись)           (расшифровка подписи)  "  format "X(50)" at 10   skip

        .
        assign
          v-date-start = v-date-start + 1
          v-sheet-num = v-sheet-num + 1
          v-kolvo-pko = 0
          v-kolvo-rko = 0
        .

        {&PageExcel}
    end.
  { rep/repfrm.i off }
  { gbl/stopwork.i }

  output stream out-stream close.
  {&CloseExcel}
  DisabledOptions = 0.
  ReportFontNum = 7.
  if p-batch > 0 then do:
    /*сразу печатаем на принтер проверка на q-print внутри*/
    run reprumpr_print-printer in this-procedure ( input ReportFontNum /*font*/
                                                  ,input 0 /*flags*/
                                                  ) no-error.
    if error-status:error then do:
      &scop my-message "Печать на принтер завершилась ошибкой..."
      {&display-message}.
    end.
    IF p-xls THEN DO:
      if p-report-id = "71/2067" then do:
        RUN reprumpr_print-xls ( input p-dir-name
                                ,input '' /*нет печати по расписанию в XLs*/
                                ,input substitute("cashbk_&1&2_&3&4&5_&6.xls"
                                                  , v-obj-type
                                                  , v-obj-code
                                                  , string(year(X-date-end), "9999")
                                                  , string(month(X-date-end), "99")
                                                  , string(day(X-date-end), "99")
                                                  , X-shift-end)
                                ,input DisabledOptions /*p-disable-option*/
                                ,input ReportFontNum /*p-font-number*/
                                  ) .
      end.
      if error-status:error then do:
        &scop my-message return-value
        {&display-message}.
      end.
    END.
    if p-plain-txt then do:
      if p-report-id = "71/2067" then do:
        run reprumpr_print-plain-text in this-procedure ( input p-dir-name
                                                          ,input '' /*нет печати по расписанию в TXT*/
                                                          ,input substitute("cashbk_&1&2_&3&4&5_&6.txt"
                                                                          , v-obj-type
                                                                          , v-obj-code
                                                                          , string(year(X-date-end), "9999")
                                                                          , string(month(X-date-end), "99")
                                                                          , string(day(X-date-end), "99")
                                                                          , X-shift-end)
                                                          ,input DisabledOptions /*p-disable-option*/
                                                          ,input ReportFontNum /*p-font-number*/
                                                          ) no-error.
      end.
      if error-status:error then do:
        &scop my-message return-value
        {&display-message}.
      end.
    end.
  end.
  else do:
      run gbl/prnfilen.w
        ( input  ""
        , input  DisabledOptions
         ,input  string(session :temp-directory) + {&DF_Name} + string( g#report-num )
        , input  ReportFontNum
         ,output v-user-action
         ,output v-printed
      ) .
  end.

 /*--------------------------------------*/
procedure report-exec :
  define input  parameter p-date        as date    no-undo .
  define output parameter p-strok       as integer no-undo .

  assign
    v-ost-begin = 0
    v-num-obj   = 0
  .
  for each buf_obj-list no-lock :
  { gbl/hostcode.i buf_obj-list.obj-type buf_obj-list.obj-code v-host-code }
    assign
      fact-order-1 = 0
      fact-order-2 = 0
      v-sum-begin  = 0
      v-shift-on = yes
    .

    run fostatok in this-procedure (
         input   v-host-code
        ,input   buf_obj-list.obj-code
        ,input   buf_obj-list.obj-type
        ,input   x-tog-shift
        ,input   p-date - 1
        ,input   date('')
        ,input   ( if p-date <> x-date-start then 0 else x-shift-start )
        ,input   X-shift-end
        ,input   yes /*xTog-obj*/
        ,input   0 /*p-curr-code*/
        ,output  v-sum-begin
        ,output  Fact-order-1)
        no-error .
    run fostatok in this-procedure (
         input   v-host-code
        ,input   buf_obj-list.obj-code
        ,input   buf_obj-list.obj-type
        ,input   x-tog-shift
        ,input   p-date
        ,input   x-date-end
        ,input   X-shift-end
        ,input   X-shift-end
        ,input   yes /*xTog-obj*/
        ,input   0 /*p-curr-code*/
        ,output  sum1
        ,output  Fact-order-2)
        no-error .

      for each buf_arh-fin-doc-schet-nal-obj no-lock
        where buf_arh-fin-doc-schet-nal-obj.host-code         = v-host-code
          and buf_arh-fin-doc-schet-nal-obj.obj-type          = buf_obj-list.obj-type
          and buf_arh-fin-doc-schet-nal-obj.obj-code          = buf_obj-list.obj-code
          and buf_arh-fin-doc-schet-nal-obj.cli-type          = {&cmp}
          and buf_arh-fin-doc-schet-nal-obj.cli-code          = v-host-code
          and buf_arh-fin-doc-schet-nal-obj.fin-code-acc      = 0
          and buf_arh-fin-doc-schet-nal-obj.curr-code         = 0
          and buf_arh-fin-doc-schet-nal-obj.fin-ext-doc-type  = "":U
          and buf_arh-fin-doc-schet-nal-obj.calc-curr-code    = 0
          and buf_arh-fin-doc-schet-nal-obj.sum-type          = (if x-tog-shift then {&arh-fin-doc-schet-nal-obj-shift-obj} else {&arh-fin-doc-schet-nal-obj-obj} )
          and buf_arh-fin-doc-schet-nal-obj.fact-order       > fact-order-1
          and buf_arh-fin-doc-schet-nal-obj.fact-order       <= fact-order-2
          and p-date = ( if x-tog-shift then buf_arh-fin-doc-schet-nal-obj.shift-date else buf_arh-fin-doc-schet-nal-obj.fact-date )   /*в 15-0 поля shift-date нет */
           use-index pi :
          find first buf_fin-doc
                  where buf_fin-doc.host-code         = v-host-code
                    and buf_fin-doc.fin-doc-code      = buf_arh-fin-doc-schet-nal-obj.fin-doc-code
                    and buf_fin-doc.obj-type          = buf_obj-list.obj-type
                    and buf_fin-doc.obj-code          = buf_obj-list.obj-code
                    and buf_fin-doc.status_           = {&fact}
                    and (buf_fin-doc.fin-ext-doc-type = {&income-cash}
                    or buf_fin-doc.fin-ext-doc-type   = {&expense-cash} )
                  no-error.
                  if available buf_fin-doc then do :
                    &scop fin-doc-obj-type buf_fin-doc.obj-type
                    &scop fin-doc-obj-code buf_fin-doc.obj-code
                    if buf_fin-doc.trn-doc-code = {&fin-doc-cash-book-name} then do:
                      run create-lines in this-procedure (input-output p-strok).
                  end.
    end.
    end.
    assign
      v-ost-begin = v-ost-begin + v-sum-begin
    .
  end. /*buf_list-object*/
end procedure . /*report-exec*/
/* ============================================================================================== */
procedure my-extitle :
DEFINE INPUT PARAMETER current-sheet as integer no-undo.

define variable C-c as int no-undo.
define variable C-str as char no-undo.
define variable str--1 as char Format "x(60)" no-undo.
define variable C-i as int no-undo.
define variable M        AS INTEGER no-undo.
define variable L        AS INTEGER no-undo.
define variable iColumn  AS INTEGER no-undo.
define variable cColumn  AS CHARACTER no-undo.
define variable cRange   AS CHARACTER no-undo.
define variable cRange2  AS CHARACTER no-undo.
define variable g#report-num as integer no-undo .

define variable AllCol   AS Int no-undo.
DEFINE VARIABLE v-bas-file as character no-undo .

IF Make-Excel THEN DO:
  IF NOT Make-Excel-com THEN DO:
    FIND FIRST sheetf NO-LOCK WHERE
                sheetf.sheet-num = current-sheet No-ERROR.
    if not avail sheetf then do:
      &scop my-message substitute("&1 &2 &3&4Отсутствуют параметры форматирования для листов книги Excel" ~
                                  ,vss-workfile  ~
                                  ,vss-revision  ~
                                  ,vss-description ~
                                  ,~{&new-line~} )
      {&display-message}.
      return.
    end.
    C-str= str1        + {&new-line} + str2
                       + {&new-line} + ReportHeader .
    C-str = replace(c-str, ({&new-line} + {&new-line}), {&new-line}).

    PUT stream FORExcel UNFORMATTED C-str skip.

    sheetf.Excel-Row-Heder =  NUM-ENTRIES(C-str ,{&new-line}) + 1.

    sheetf.Excel-Row-Title =  NUM-ENTRIES(sheetf.Excel-Column-Lable ,{&new-line}).
    Repeat C-c = 1 to sheetf.Excel-Row-Title :
      Repeat C-i = 1 to NUM-ENTRIES(Entry(c-c,sheetf.Excel-Column-Lable,{&new-line}), {&comma-char}) :
        str--1 = Entry( C-i ,Entry(c-c,sheetf.Excel-Column-Lable,{&new-line}), {&comma-char}).
        Put stream ForExcel UNFORMATTED
                    Trim(Str--1)  Format "x(60)"
                  {&tabulation}  .
      End.
      C-i = 0.
      Put stream ForExcel UNFORMATTED skip.
    End.

    /*перепишем в нужное место bas-file*/

    if Sheetf.Bas-FIle <> "":U then do:

      run get-report-num in my-handle (output G#report-num).
      assign
      v-bas-file = string( session:temp-directory) +
                   string( g#report-num)  + ".b8s":U + string(current-sheet)
      .

      define variable v-full-path        as character no-undo .
      define variable v-path             as character no-undo .
      define variable v-file-name        as character no-undo .
      define variable v-file-name-no-ext as character no-undo .
      define variable v-file-name-ext    as character no-undo .

      run gbl/filename.p
        (input  Sheetf.Bas-file
        ,output v-full-path
        ,output v-path
        ,output v-file-name
        ,output v-file-name-no-ext
        ,output v-file-name-ext
        ) no-error  .

      run gbl/fileattr.p
      (input v-bas-file
      ,input "readonly-clear"
      ) no-error .

      OS-delete value(v-bas-file).
      OS-COPY value(v-full-path) value(v-bas-file).
      if os-error <> 0 or search(v-bas-file) = ? then do:
        assign
        Sheetf.Bas-file = "":U
        .
      end.
      else do:
        assign
        Sheetf.Bas-file = v-bas-file
        .
      end.
    end.
  END. /*IF NOT Make-Excel-com*/
End.

end procedure.
/*----------------------*/
procedure create-lines :
define input-output parameter p-strok1 as integer no-undo.

find first temp-fin-doc
where temp-fin-doc.sheet-num    = v-sheet-num
  and temp-fin-doc.host-code    = v-host-code
  and temp-fin-doc.obj-code     = buf_obj-list.obj-code
  and temp-fin-doc.obj-type     = buf_obj-list.obj-type
  and temp-fin-doc.fin-doc-code = buf_fin-doc.fin-doc-code
  use-index pi no-error .
  if not available temp-fin-doc
  then do :
      assign Counter1 = Counter1 + 1.
      { rep/repfrm.i disp Counter1 }

      create temp-fin-doc.
      assign
        p-strok1 = p-strok1 + 1
        temp-fin-doc.obj-code     = buf_obj-list.obj-code
        temp-fin-doc.obj-type     = buf_obj-list.obj-type
        temp-fin-doc.fin-doc-code = buf_fin-doc.fin-doc-code
        temp-fin-doc.sheet-num    = v-sheet-num
        temp-fin-doc.host-code    = v-host-code
      .
  end.
  assign
      temp-fin-doc.prn-doc-code = buf_fin-doc.prn-doc-code
      temp-fin-doc.payer        = buf_fin-doc.payer-name
      temp-fin-doc.receiver     = buf_fin-doc.receiver-name
      temp-fin-doc.cor-acc      = buf_fin-doc.cor-acc-value
      temp-fin-doc.fin-doc-type = buf_fin-doc.fin-doc-type
      temp-fin-doc.sum-rubl     = buf_fin-doc.sum-rubl
  .
end procedure.