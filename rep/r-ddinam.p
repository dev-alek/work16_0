/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Движение денежных средств

Автор: Комаров Иван Сергеевич
Дата создания: 04/29/10
Author: Ivan Komarov
Creation date: 04/29/10

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
define input parameter p-det-obj                as logical                 no-undo .
define input parameter p-plain-txt              as   logical               no-undo .
define input parameter p-xls                    as   logical               no-undo .
define input parameter p-dir-name               as   character             no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Движение денежных средств".
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
{ cmp/trg-def.i }

{ rep/reprumpr.i print-plain-text,print-printer,print-xls }

define SHARED variable is-rosneft as logical no-undo .

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
FIELD sheet-num        as integer
FIELD host-code        as integer
FIELD obj-code         as integer
FIELD obj-type         as character
FIELD obj-name         as character
FIELD ost-begin        as decimal
FIELD income-realiz    as decimal
FIELD income-other     as decimal
FIELD expense-bank     as decimal
FIELD expense-other    as decimal
FIELD ost-end          as decimal
FIELD staff-curr1      as character
FIELD staff-curr2      as character
FIELD staff-curr3      as character
FIELD staff-curr4      as character
FIELD staff-curr5      as character
FIELD staff-next1      as character
FIELD staff-next2      as character
FIELD staff-next3      as character
FIELD staff-next4      as character
FIELD staff-next5      as character

INDEX pi is primary unique sheet-num host-code obj-code obj-type
.

define buffer buf_clients                   for ub.clients .
define buffer buf_obj-list                  for obj-list .
define buffer buf_fin-doc                   for ub.fin-doc .
define buffer buf_arh-fin-doc-schet-nal-obj for ub.arh-fin-doc-schet-nal-obj .
define buffer buf_clients-attr              for ub.clients-attr .
define buffer buf_shift-staff               for ub.shift-staff .
define buffer buf_sysconf                   for ub.sysconf .

define variable v-count        as integer   no-undo .
define variable v-str          as integer   no-undo .
define variable v-firm         as character no-undo .
define variable v-object       as character no-undo .
define variable v-host-code    as integer   no-undo .
define variable v-sum-begin    as decimal   no-undo .
define variable sum1           as decimal   no-undo .

define variable f-ost-begin    as character no-undo .
define variable f-cashf-begin  as character no-undo .
define variable f-income-realiz as character no-undo .
define variable f-income-other  as character no-undo .
define variable f-expense-bank  as character no-undo .
define variable f-expense-other as character no-undo .
define variable f-ost-end      as character no-undo .
define variable f-cashf-end    as character no-undo .

define variable v-ost-begin     as decimal   no-undo .
define variable v-income-realiz as decimal   no-undo .
define variable v-income-other  as decimal   no-undo .
define variable v-expense-bank  as decimal   no-undo .
define variable v-expense-other as decimal   no-undo .
define variable v-ost-end       as decimal   no-undo .
define variable v-sheet        as integer   no-undo .
define variable v-obj-name     as character no-undo .
define variable v-obj-type1    as character no-undo .
define variable v-obj-code1    as integer   no-undo .
define variable v-num-obj      as integer   no-undo .

define variable v-col1-propis  as character no-undo .
define variable v-col3-propis  as character no-undo .
define variable v-col45-propis as character no-undo .
define variable v-col4-propis  as character no-undo .
define variable v-col5-propis  as character no-undo .
define variable v-col6-propis  as character no-undo .
define variable abbr           as character no-undo .

define variable v-ost-begin-all    as decimal no-undo .
define variable v-income-realiz-all as decimal no-undo .
define variable v-income-other-all  as decimal no-undo .
define variable v-expense-bank-all  as decimal no-undo .
define variable v-expense-other-all as decimal no-undo .
define variable v-ost-end-all      as decimal no-undo .

define variable x-store-code    like ub.clients.obj-code   no-undo .
define variable x-store-type    like ub.clients.obj-type   no-undo .

define variable Fact-order-1    like ub.stk-tot.Fact-order no-undo .
define variable Fact-order-2    like ub.stk-tot.Fact-order no-undo .

define variable v-obj-type        as character no-undo .
define variable v-obj-code        as integer no-undo init -1.

define variable Counter1          as integer   no-undo .
define variable v-date-name       as character no-undo .
define variable v-shift-on        as logical   no-undo .
define variable v-sheet-num       as integer   no-undo .

define variable v-user-action     as character no-undo .
define variable v-printed         as logical   no-undo .
define variable disabledoptions   as integer   no-undo .
define variable v-orient-page     as character no-undo .
define variable v-file-name       as character no-undo .
define variable v-file-name-ind   as integer   no-undo .
define variable v-line            as character no-undo .
define variable v-underline       as character no-undo .
define variable v-fio-sign        as character no-undo .

define stream  macr_excel .
define stream  out-stream .

   assign
      v-line  = fill( "-" , 200 )
      v-underline  = fill( "_" , 200 )
      v-fio-sign   = "                Ф.И.О.   (подписи)"
   .
  { cmp/open-out.i stream out-stream  " " }

  assign
    v-file-name     = string(session :temp-directory) + {&DF_Name} + string( g#report-num ) + ".txt"
    v-file-name-ind = 1
  .

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
    if length(v-obj-name) > 160 then v-obj-name = substring(v-obj-name, 1, 155) + "..." .

  for each sheetf :
      delete sheetf.
  end.

  define frame ddinam-kedr
          sym1                no-label  format "X(1)"  space(0)
          f-ost-begin         no-label  format "X(30)" space(0)
          sym2                no-label  format "X(1)"  space(0)
          f-cashf-begin       no-label  format "X(20)" space(0)
          sym3                no-label  format "X(1)"  space(0)
          f-income-realiZ     no-label  format "X(23)" space(0)
          sym4                no-label  format "X(1)"  space(0)
          f-expense-bank      no-label  format "X(18)" space(0)
          sym5                no-label  format "X(1)"  space(0)
          f-expense-other     no-label  format "X(18)" space(0)
          sym6                no-label  format "X(1)"  space(0)
          f-ost-end           no-label  format "X(31)" space(0)
          sym7                no-label  format "X(1)"  space(0)
          f-cashf-end         no-label  format "X(20)" space(0)
          sym8                no-label  format "X(1)"  space(0)
  header
          str1 at 5  format "X(160)"
          ReportHeader at 5 format "X(165)"

"+------------------------------+--------------------+-----------------------+-------------------------------------+-------------------------------+--------------------+" skip
"|                              |                    |                       |               Сдано                 |                               |                    |" skip
"|                              |                    |                       +------------------+------------------+                               |                    |" skip
"|       Остаток денежных       |       в т.ч.       |    Выручка за смену   |   Инкассация в   |   Инкассация в   |    Остаток денежных средств   |       в т.ч.       |" skip
"|   средств на начало смены    |   кассовый фонд    |        (Z-отчет)      |       банк       |       офис       |         на конец смены        |    кассовый фонд   |" skip
"+------------------------------+--------------------+-----------------------+------------------+------------------+-------------------------------+--------------------+" skip
"|               1              |          2         |            3          |         4        |         5        |               6               |         7          |" skip
"+------------------------------+--------------------+-----------------------+------------------+------------------+-------------------------------+--------------------+" skip
  with width {&DOS_CW_2} down stream-io no-box no-underline no-labels .
  define frame ddinam
          sym1                no-label  format "X(1)"  space(0)
          f-ost-begin         no-label  format "X(30)" space(0)
          sym2                no-label  format "X(1)"  space(0)
          f-cashf-begin       no-label  format "X(20)" space(0)
          sym3                no-label  format "X(1)"  space(0)
          f-income-realiZ     no-label  format "X(23)" space(0)
          sym4                no-label  format "X(1)"  space(0)
          f-income-other      no-label  format "X(23)" space(0)
          sym5                no-label  format "X(1)"  space(0)
          f-expense-bank      no-label  format "X(18)" space(0)
          sym6                no-label  format "X(1)"  space(0)
          f-expense-other     no-label  format "X(18)" space(0)
          sym7                no-label  format "X(1)"  space(0)
          f-ost-end           no-label  format "X(31)" space(0)
          sym8                no-label  format "X(1)"  space(0)
          f-cashf-end         no-label  format "X(20)" space(0)
          sym9                no-label  format "X(1)"  space(0)
  header
          str1 at 5  format "X(160)"
          ReportHeader at 5 format "X(165)"

"+------------------------------+--------------------+-----------------------------------------------+-------------------------------------+-------------------------------+--------------------+" skip
"|        Остаток денежных      |        в т.ч.      |                    Приход                     |               Расход                |        Остаток денежных       |       в т.ч.       |" skip
"|            средств           |       кассовый     +-----------------------+-----------------------+------------------+------------------+            средств            |      кассовый      |" skip
"|         на начало смены      |         фонд       |       Реализация      |        Прочий         |   Инкассация в   |      Прочий      |         на конец смены        |        фонд        |" skip
"|                              |                    |                       |                       |       банк       |                  |                               |                    |" skip
"+------------------------------+--------------------+-----------------------+-----------------------+------------------+------------------+-------------------------------+--------------------+" skip
"|               1              |          2         |            3          |           4           |         5        |         6        |               7               |         8          |" skip
"+------------------------------+--------------------+-----------------------+-----------------------+------------------+------------------+-------------------------------+--------------------+" skip
  with width {&DOS_CW_2} down stream-io no-box no-underline no-labels .

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

        for each   temp-fin-doc :
            delete temp-fin-doc .
        end .

        assign
          v-ost-begin = 0
        .
        run report-exec in this-procedure .

        assign
            v-date-name = str1
            v-sheet     = 1
        .
          find first temp-fin-doc where temp-fin-doc.sheet-num = 1 no-error.
          if available temp-fin-doc then do :
          assign str1 = temp-fin-doc.obj-name.
          end.
          assign
            str2 = ""
            str3 = ""
            str4 = ""
            ReportHeader = "ДВИЖЕНИЕ ДЕНЕЖНЫХ СРЕДСТВ " + v-date-name
          .

            create sheetf.
            assign
              sheetf.sheet-num = 1
              sheetf.MergeCellsH = "3:4,5:6"
              sheetf.MergeCellsV = "1=1:2/2=1:2/7=1:2/8=1:2"
              sheetf.Excel-Column-Lable = "Остаток денежных средств на начало смены" + {&comma-char} +
              "в т.ч. кассовый фонд"                                                 + {&comma-char} +
              "Приход"                                               + {&comma-char} + {&comma-char} +
              "Расход"                                               + {&comma-char} + {&comma-char} +
              "Остаток денежных средств на конец смены"                              + {&comma-char} +
              " в т.ч. кассовый фонд"                                                + {&new-line} +
              {&comma-char} + {&comma-char} +
              "Реализация"                                                           + {&comma-char} +
              "Прочее"                                                               + {&comma-char} +
              "Инкассация в банк"                                                    + {&comma-char} +
              "Другие"
              sheetf.Sizes  = "27,15,14,14,14,14,26,15"
              Sheetf.ColFOrmat   = "1=@;2=@;3=@;4=@;5=@;6=@;7=@;8=@"
              Make-excel = p-xls
              Make-excel-com = false
              Sheetf.Bas-File      = "exe/ddinam.bas"
              .

              if is-rosneft then do :
                assign
                  sheetf.MergeCellsH = "4:5"
                  sheetf.MergeCellsV = "1=1:2/2=1:2/3=1:2/6=1:2/7=1:2"
                  sheetf.Excel-Column-Lable = "Остаток денежных средств на начало смены" + {&comma-char} +
                  "в т.ч. кассовый фонд"                                                 + {&comma-char} +
                  "Выручка за смену (Z-отчет)"                                           + {&comma-char} +
                  "Сдано"                                                + {&comma-char} + {&comma-char} +
                  "Остаток денежных средств на конец смены"                              + {&comma-char} +
                  " в т.ч. кассовый фонд"                                                + {&new-line} +
                  {&comma-char} + {&comma-char} + {&comma-char} +
                  "Инкассация в банк"                                                    + {&comma-char} +
                  "Инкассация в офис"
                  sheetf.Sizes  = "27,15,18,14,14,26,15,0"
                  Sheetf.ColFOrmat   = "1=@;2=@;3=@;4=@;5=@;6=@;7=@;8=@"
                .
              end.

              run rep/extitle.p ( 1 ).

        do while v-sheet <> (v-sheet-num + 1) :
          for each temp-fin-doc where temp-fin-doc.sheet-num = v-sheet no-lock :
            if v-sheet <> 1 then do :
              {&PutExcel}
            temp-fin-doc.obj-name                                          {&new-line}
            .
            assign
              str1 = temp-fin-doc.obj-name
            .
              {&PutExcel}
              "Новый лист"                                                 {&new-line}
              .
            end.
            if is-rosneft then do :
              display stream Out-stream
              sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8
              string(temp-fin-doc.ost-begin, "->>>>>>>>>.99")    @ f-ost-begin
                string((temp-fin-doc.income-realiZ + temp-fin-doc.income-other),  "->>>>>>>>>.99") @ f-income-realiZ
                string(temp-fin-doc.expense-bank,   "->>>>>>>>>.99") @ f-expense-bank
                string(temp-fin-doc.expense-other,  "->>>>>>>>>.99") @ f-expense-other
              string(temp-fin-doc.ost-end, "->>>>>>>>>.99")      @ f-ost-end
              with frame ddinam-kedr .
              put stream out-stream v-line format "X(168)" skip.
              down stream Out-stream 1 with frame ddinam-kedr .
              {&PutExcel}
                string(temp-fin-doc.ost-begin,     "->>>>>>>>>.99") {&tabulation} {&tabulation}
                string((temp-fin-doc.income-realiZ + temp-fin-doc.income-other), "->>>>>>>>>.99") {&tabulation}
                string(temp-fin-doc.expense-bank,  "->>>>>>>>>.99") {&tabulation}
                string(temp-fin-doc.expense-other, "->>>>>>>>>.99") {&tabulation}
                string(temp-fin-doc.ost-end,       "->>>>>>>>>.99") {&new-line}
                .
            end.
            else do:
            display stream Out-stream
              sym1 sym2 sym3 sym4 sym5 sym6 sym7 sym8 sym9
              string(temp-fin-doc.ost-begin, "->>>>>>>>>.99")    @ f-ost-begin
              string(temp-fin-doc.income-realiZ,  "->>>>>>>>>.99") @ f-income-realiZ
              string(temp-fin-doc.income-other,   "->>>>>>>>>.99") @ f-income-other
              string(temp-fin-doc.expense-bank,   "->>>>>>>>>.99") @ f-expense-bank
              string(temp-fin-doc.expense-other,  "->>>>>>>>>.99") @ f-expense-other
              string(temp-fin-doc.ost-end, "->>>>>>>>>.99")      @ f-ost-end
              with frame ddinam .
              put stream out-stream v-line format "X(192)" skip.
            down stream Out-stream 1 with frame ddinam .
            {&PutExcel}
              string(temp-fin-doc.ost-begin,     "->>>>>>>>>.99") {&tabulation} {&tabulation}
              string(temp-fin-doc.income-realiZ, "->>>>>>>>>.99") {&tabulation}
              string(temp-fin-doc.income-other,  "->>>>>>>>>.99") {&tabulation}
              string(temp-fin-doc.expense-bank,  "->>>>>>>>>.99") {&tabulation}
              string(temp-fin-doc.expense-other, "->>>>>>>>>.99") {&tabulation}
              string(temp-fin-doc.ost-end,       "->>>>>>>>>.99") {&new-line}
              .
            end.
            run rep/wp-rub.p ( input (temp-fin-doc.ost-begin),                              output v-col1-propis,  output abbr ).
            run rep/wp-rub.p ( input (temp-fin-doc.income-realiZ + temp-fin-doc.income-other), output v-col3-propis,  output abbr ).
            run rep/wp-rub.p ( input (temp-fin-doc.expense-bank + temp-fin-doc.expense-other), output v-col45-propis, output abbr ).
            run rep/wp-rub.p ( input (temp-fin-doc.expense-bank),                              output v-col4-propis,  output abbr ).
            run rep/wp-rub.p ( input (temp-fin-doc.expense-other),                             output v-col5-propis,  output abbr ).
            run rep/wp-rub.p ( input (temp-fin-doc.ost-end),                                output v-col6-propis,  output abbr ).

            if (v-num-obj = 1 or p-det-obj)
              and x-tog-shift    /*по сменам */
              and x-date-start = x-date-end  /*и за 1 смену, иначе оставляем как есть */
              and x-shift-start = x-shift-end
              then do:
                for each buf_shift-staff
                    where buf_shift-staff.obj-type   = temp-fin-doc.obj-type
                      and buf_shift-staff.obj-code   = temp-fin-doc.obj-code
                      and buf_shift-staff.shift-date = x-date-start
                      and buf_shift-staff.shift-num  = x-shift-start
                      no-lock.
                      if buf_shift-staff.next-shift <> yes then do :   /*текущая смена */
                          if buf_shift-staff.staff-role then do :
                            assign temp-fin-doc.staff-curr1 = trim(buf_shift-staff.name) .
                          end.
                          else do :
                              if temp-fin-doc.staff-curr2 = "" then do :
                                assign temp-fin-doc.staff-curr2 = trim(buf_shift-staff.name) .
                              end.
                              else do :
                                  if temp-fin-doc.staff-curr3 = "" then do :
                                    assign temp-fin-doc.staff-curr3 = trim(buf_shift-staff.name) .
                                  end.
                                  else do :
                                      if temp-fin-doc.staff-curr4 = "" then do :
                                        assign temp-fin-doc.staff-curr4 = trim(buf_shift-staff.name) .
                                      end.
                                      else do :
                                        assign temp-fin-doc.staff-curr5 = trim(buf_shift-staff.name) .
                                      end.
                                  end.
                              end.
                          end.
                      end. /*if buf_shift-staff.next-shift <> yes then do : */
                      else do :  /*принимающая смена */
                          if buf_shift-staff.staff-role then do :
                            assign temp-fin-doc.staff-next1 = trim(buf_shift-staff.name) .
                          end.
                          else do :
                              if temp-fin-doc.staff-next2 = "" then do :
                                assign temp-fin-doc.staff-next2 = trim(buf_shift-staff.name) .
                              end.
                              else do :
                                  if temp-fin-doc.staff-next3 = "" then do :
                                    assign temp-fin-doc.staff-next3 = trim(buf_shift-staff.name) .
                                  end.
                                  else do :
                                      if temp-fin-doc.staff-next4 = "" then do :
                                        assign temp-fin-doc.staff-next4 = trim(buf_shift-staff.name) .
                                      end.
                                      else do :
                                        assign temp-fin-doc.staff-next5 = trim(buf_shift-staff.name) .
                                      end.
                                  end.
                              end.
                          end.
                      end.
                end.
            end.

            PUT STREAM Out-Stream
            space(0) "Принято по смене"                                         format "X(20)" at 5
            space(0)                 v-col1-propis                                                                                               format "X(100)" at 25
            space(0)  v-underline          format "X(100)" at 25
            space(0)  "(прописью)"                                              format "X(12)" at 65   skip
            .
            if is-rosneft then do:
              PUT STREAM Out-Stream
            space(0) "Выручка за смену"                                         format "X(20)" at 5
            space(0)                 v-col3-propis                                                                                               format "X(100)" at 25
            space(0)  v-underline          format "X(100)" at 25
            space(0)  "(прописью)"                                              format "X(12)" at 65   skip

            space(0) "Сдано: в банк"                                            format "X(20)" at 5
            space(0)                 v-col4-propis                                                                                              format "X(100)" at 25
            space(0)  v-underline          format "X(100)" at 25
            space(0)  "(прописью)"                                              format "X(12)" at 65   skip

            space(0) "Сдано: в офис"                                            format "X(20)" at 5
            space(0)                 v-col5-propis                                                                                              format "X(100)" at 25
            space(0)  v-underline          format "X(100)" at 25
            space(0)  "(прописью)"                                              format "X(12)" at 65   skip

            space(0) "Итого инкассировано"                                      format "X(20)" at 5
            space(0)                 v-col45-propis                                                                                               format "X(100)" at 25
            space(0)  v-underline          format "X(100)" at 25
            space(0)  "(прописью)"                                              format "X(12)" at 65   skip
              .
            end.
            PUT STREAM Out-Stream
            space(0) "Передано по смене: "                                      format "X(20)" at 5    skip
            space(0) "наличных денег"                                           format "X(15)" at 10
            space(0)                 v-col6-propis                                                                                               format "X(100)" at 25
            space(0)  v-underline          format "X(100)" at 25
            space(0)  "(прописью)"                                              format "X(12)" at 65   skip

            space(0) "Отчет составили и смену сдали"                            format "X(30)" at 5
            space(0) "_____" + temp-fin-doc.staff-curr1 + v-underline format "X(34)" at 35
            space(0) "Смену приняли"                                            format "X(15)" at 76
            space(0) "_____" + temp-fin-doc.staff-next1 + v-underline format "X(34)" at 91 skip
            space(0) v-fio-sign             format "X(40)" at 27
            space(0) v-fio-sign             format "X(40)" at 83 skip
            " "                                                                                        skip
            space(0) "_____" + temp-fin-doc.staff-curr2 + v-underline format "X(34)" at 35
            space(0) "_____" + temp-fin-doc.staff-next2 + v-underline format "X(34)" at 91 skip
            space(0) v-fio-sign             format "X(40)" at 27
            space(0) v-fio-sign             format "X(40)" at 83 skip
            " "                                                                                        skip
            space(0) "_____" + temp-fin-doc.staff-curr3 + v-underline format "X(34)" at 35
            space(0) "_____" + temp-fin-doc.staff-next3 + v-underline format "X(34)" at 91 skip
            space(0) v-fio-sign             format "X(40)" at 27
            space(0) v-fio-sign             format "X(40)" at 83 skip
            " "                                                                                        skip
            space(0) "_____" + temp-fin-doc.staff-curr4 + v-underline format "X(34)" at 35
            space(0) "_____" + temp-fin-doc.staff-next4 + v-underline format "X(34)" at 91 skip
            space(0) v-fio-sign             format "X(40)" at 27
            space(0) v-fio-sign             format "X(40)" at 83 skip
            " "                                                                                        skip
            space(0) "_____" + temp-fin-doc.staff-curr5 + v-underline format "X(34)" at 35
            space(0) "_____" + temp-fin-doc.staff-next5 + v-underline format "X(34)" at 91 skip
            space(0) v-fio-sign             format "X(40)" at 27
            space(0) v-fio-sign             format "X(40)" at 83 skip
          .
                 PAGE STREAM Out-Stream.
          .
          if is-rosneft then do:
        {&PutExcel}
                                                {&new-line}
          "Принято по смене"                    {&tabulation} {&tabulation}
          string (v-col1-propis + v-underline, "x(90)") {&new-line}
                                                {&tabulation} {&tabulation} {&tabulation}
          "(прописью)"                          {&new-line}
          ""                                    {&new-line}
          "Выручка за смену"                    {&tabulation} {&tabulation}
          string (v-col3-propis + v-underline, "x(90)") {&new-line}
                                                {&tabulation} {&tabulation} {&tabulation}
          "(прописью)"                          {&new-line}
          ""                                    {&new-line}
          "Сдано: в банк"                       {&tabulation} {&tabulation}
          string (v-col4-propis + v-underline, "x(90)") {&new-line}
                                                {&tabulation} {&tabulation} {&tabulation}
          "(прописью)"                          {&new-line}
          ""                                    {&new-line}
          "Сдано: в офис"                       {&tabulation} {&tabulation}
          string (v-col5-propis + v-underline, "x(90)") {&new-line}
                                                {&tabulation} {&tabulation} {&tabulation}
          "(прописью)"                          {&new-line}
          ""                                    {&new-line}
          "Итого инкассировано"                 {&tabulation} {&tabulation}
          string (v-col45-propis + v-underline, "x(90)") {&new-line}
                                                {&tabulation} {&tabulation} {&tabulation}
          "(прописью)"                          {&new-line}
          ""                                    {&new-line}
              .
          end.
          else do:
            {&PutExcel}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
            ""                                    {&new-line}
                                                  {&new-line}
            "Принято по смене"                    {&tabulation} {&tabulation}
            string (v-col1-propis + v-underline, "x(90)") {&new-line}
                                                  {&tabulation} {&tabulation} {&tabulation}
            "(прописью)"                          {&new-line}
            ""                                    {&new-line}
            .
          end.
          {&PutExcel}
          "Передано по смене: наличных денег"   {&tabulation} {&tabulation}
          string (v-col6-propis + v-underline, "x(90)")  {&new-line}
                                                {&tabulation} {&tabulation} {&tabulation}
          "(прописью)"                          {&new-line}
          ""                                    {&new-line}
          "Отчет составили и смену сдали"       {&tabulation}
          string (temp-fin-doc.staff-curr1 + v-underline, "x(34)") {&tabulation} {&tabulation} {&tabulation}
          "Смену приняли"                       {&tabulation}
          string (temp-fin-doc.staff-next1 + v-underline, "x(34)") {&new-line}   {&tabulation}
          v-fio-sign  {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          v-fio-sign  {&new-line}   {&tabulation}

          string (temp-fin-doc.staff-curr2 + v-underline, "x(34)") {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          string (temp-fin-doc.staff-next2 + v-underline, "x(34)") {&new-line}   {&tabulation}
          v-fio-sign  {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          v-fio-sign  {&new-line}   {&tabulation}

          string (temp-fin-doc.staff-curr3 + v-underline, "x(34)") {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          string (temp-fin-doc.staff-next3 + v-underline, "x(34)") {&new-line}   {&tabulation}
          v-fio-sign  {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          v-fio-sign  {&new-line}   {&tabulation}

          string (temp-fin-doc.staff-curr4 + v-underline, "x(34)") {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          string (temp-fin-doc.staff-next4 + v-underline, "x(34)") {&new-line}   {&tabulation}
          v-fio-sign  {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          v-fio-sign  {&new-line}   {&tabulation}

          string (temp-fin-doc.staff-curr5 + v-underline, "x(34)") {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          string (temp-fin-doc.staff-next5 + v-underline, "x(34)") {&new-line}   {&tabulation}
          v-fio-sign  {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          v-fio-sign  {&new-line}   {&tabulation}

          string ( v-underline, "x(34)")  {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          string ( v-underline, "x(34)")  {&new-line}   {&tabulation}
          v-fio-sign  {&tabulation} {&tabulation} {&tabulation} {&tabulation}
          v-fio-sign  {&new-line}
          .
          if v-sheet <> 1 then do :
            {&PutExcel}
                {&new-line}
            .
          end.

          end.
          v-sheet = v-sheet + 1.
        end.
        {&PageExcel}

  { rep/repfrm.i off }
  { gbl/stopwork.i }

  output stream out-stream close.
  {&CloseExcel}
  assign
  DisabledOptions = 8
  ReportFontNum = 7
  .
  if p-batch > 0 then do:
    /*сразу печатаем на принтер проверка на q-print внутри*/
    run reprumpr_print-printer in this-procedure ( input ReportFontNum /*font*/
                                                  ,input 2 /*flags*/
                                                  ) no-error.
    if error-status:error then do:
      &scop my-message "Печать на принтер завершилась ошибкой..."
      {&display-message}.
    end.
    IF p-xls THEN DO:
      if p-report-id = "70/2066" then do:
        RUN reprumpr_print-xls ( input p-dir-name
                                ,input '' /*нет печати по расписанию в XLT*/
                                ,input substitute("ddinam_&1&2_&3&4&5_&6.xls"
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
      if p-report-id = "70/2066" then do:
        run reprumpr_print-plain-text in this-procedure ( input p-dir-name
                                                          ,input '' /*нет печати по расписанию в TXT*/
                                                          ,input substitute("ddinam_&1&2_&3&4&5_&6.txt"
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
        , input  string(session :temp-directory) + {&DF_Name} + string( g#report-num )
        , input  ReportFontNum
        , output v-user-action
        , output v-printed
        ) .
  end.

 /*--------------------------------------*/
procedure report-exec :
  assign
    v-ost-begin        = 0
    v-ost-begin-all    = 0
    v-income-realiZ-all = 0
    v-income-other-all  = 0
    v-expense-bank-all  = 0
    v-expense-other-all = 0
    v-ost-end-all      = 0
  .

  for each buf_obj-list no-lock :
  { gbl/hostcode.i buf_obj-list.obj-type buf_obj-list.obj-code v-host-code }


    assign
      fact-order-1   = 0
      fact-order-2   = 0
      v-ost-begin    = 0
      v-income-realiZ  = 0
      v-income-other   = 0
      v-expense-bank   = 0
      v-expense-other  = 0
      v-ost-end      = 0
    .
    run fostatok in this-procedure (
         input   v-host-code
        ,input   buf_obj-list.obj-code
        ,input   buf_obj-list.obj-type
        ,input   x-tog-shift
        ,input   x-date-start - 1
        ,input   date('')
        ,input   x-shift-start
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
        ,input   x-date-end
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
        :
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
                assign Counter1 = Counter1 + 1.
                { rep/repfrm.i disp Counter1 }
                if buf_fin-doc.fin-ext-doc-type = {&income-cash} then do :
                      find first buf_sysconf no-lock
                           where buf_sysconf.host-code = v-host-code
                           no-error.
                      if available buf_sysconf
                      and buf_fin-doc.payer-type = buf_sysconf.sale-type
                      and buf_fin-doc.payer-code = buf_sysconf.sale-code
                      then do:   /*контрагент-реализация*/
                        assign
                          v-income-realiZ = v-income-realiZ + buf_fin-doc.sum-doc
                        .
                      end.
                      else do:
                        assign
                          v-income-other = v-income-other + buf_fin-doc.sum-doc
                        .
                       end.
                end.
                else do :
                    find first buf_clients-attr
                    where buf_clients-attr.obj-type  = buf_fin-doc.receiver-type
                      and buf_clients-attr.obj-code  = buf_fin-doc.receiver-code
                      and buf_clients-attr.attr-code = {&attr-is-inkassator}
                      use-index pi no-error.
                      if available buf_clients-attr then do :
                        assign
                          v-expense-bank = v-expense-bank + buf_fin-doc.sum-doc
                        .
                      end.
                      else do :
                        assign
                          v-expense-other = v-expense-other + buf_fin-doc.sum-doc
                        .
                      end.
                end.
             end.
          end.
    end.
    assign
      v-ost-begin = v-ost-begin + v-sum-begin
    .
    if p-det-obj then do :
      if v-shift-on or (v-shift-on = no and x-tog-shift = no) then do :
      assign v-sheet-num = v-sheet-num + 1.
      find first temp-fin-doc
          where temp-fin-doc.sheet-num = v-sheet-num
            and temp-fin-doc.host-code = v-host-code
            and temp-fin-doc.obj-type  = buf_obj-list.obj-type
            and temp-fin-doc.obj-code  = buf_obj-list.obj-code

            use-index pi no-error.
            if not available temp-fin-doc then do :
              create temp-fin-doc.
              assign
                temp-fin-doc.sheet-num = v-sheet-num
                temp-fin-doc.host-code = v-host-code
                temp-fin-doc.obj-type  = buf_obj-list.obj-type
                temp-fin-doc.obj-code  = buf_obj-list.obj-code
                temp-fin-doc.obj-name  = buf_obj-list.obj-name
              .
            end.
            assign
                temp-fin-doc.ost-begin      = v-ost-begin
                temp-fin-doc.income-realiZ  = v-income-realiZ
                temp-fin-doc.income-other   = v-income-other
                temp-fin-doc.expense-bank   = v-expense-bank
                temp-fin-doc.expense-other  = v-expense-other
                temp-fin-doc.ost-end        = v-ost-begin + ( v-income-realiZ + v-income-other ) - ( v-expense-bank + v-expense-other )
            .
      end.
    end.
    assign
      v-ost-begin-all    = v-ost-begin-all    + v-ost-begin
      v-income-realiZ-all = v-income-realiZ-all + v-income-realiZ
      v-income-other-all  = v-income-other-all  + v-income-other
      v-expense-bank-all  = v-expense-bank-all  + v-expense-bank
      v-expense-other-all = v-expense-other-all + v-expense-other
      v-ost-end-all       = v-ost-end-all + v-ost-begin + ( v-income-realiZ + v-income-other ) - ( v-expense-bank + v-expense-other )
      v-obj-type1 = buf_obj-list.obj-type
      v-obj-code1 = buf_obj-list.obj-code
      v-num-obj = v-num-obj + 1
    .

end. /*buf_list-object*/
if not p-det-obj then do :
          create temp-fin-doc.
          assign
            temp-fin-doc.sheet-num      = 1
            temp-fin-doc.host-code      = 0
            temp-fin-doc.obj-type       = v-obj-type1
            temp-fin-doc.obj-code       = v-obj-code1
            temp-fin-doc.obj-name       = (if X-SelectObject = {&obj-firm} then v-firm else v-obj-name)
            temp-fin-doc.ost-begin      = v-ost-begin-all
            temp-fin-doc.income-realiZ = v-income-realiZ-all
            temp-fin-doc.income-other  = v-income-other-all
            temp-fin-doc.expense-bank  = v-expense-bank-all
            temp-fin-doc.expense-other = v-expense-other-all
            temp-fin-doc.ost-end        = v-ost-end-all
            v-sheet-num = 2
        .
end.
end procedure . /*report-exec*/