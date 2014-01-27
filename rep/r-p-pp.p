/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет Сравнительный анализ цен поставщиков

Автор: Чернова Светлана Александровна
Дата создания: 04/26/05
Author: Svetlana Chernova
Creation date: 04/26/05

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ gbl/cur-time.i }
{ cmp/r-pril.i   }
{ cmp/r-page1.i  }
{ cmp/breakstr.i }
{ rep/r-cliprp.i def }
{ gbl/paramls.i  }
{ rep/f-fdec.i   }
{ rep/repfrm.i def }   /* Показать окно информации о текущем процессе */
{ rep/repfrm.i on 25 } /* Показать окно информации о текущем процессе */
{ ref/grpobj.i  }
{ trg/factord.i }
{ rep/rep-bt.i  }
define input  parameter par-kol  as integer   no-undo .
define input  parameter par-cost as logical   no-undo .
define input  parameter par-crsa as logical   no-undo .
define input  parameter par-all as integer   no-undo .
define input  parameter par-nacenka as logical no-undo .


define variable parhost-code as integer   no-undo .
parhost-code = v-cntxt-host-code-obj.
define variable kol-post as integer   no-undo .

if par-cost = true then do:
    if par-kol > 5 then do:
       par-kol = 5 .
    end.
    if par-kol < 1 then do:
       par-kol = 5 .
       message "Не выбрано количество последних поставок! Будет рассчитано на 5 "  view-as alert-box information .
    end.
end.


    if not can-find (first gds-list) then do:
      message "Не выбран ни один товар !" view-as alert-box error .
      return error.
    end.


define buffer bf_cli-gds  for ub.cli-gds .
define buffer bf_doc-line for ub.doc-line.

define variable v-price-rubl as decimal decimals 2  no-undo .
define variable v-price-cli  as decimal   no-undo .
define variable v-goods as logical   no-undo .

define temp-table tt-temp no-undo
field gds-code   as integer
field obj-type    as char
field obj-code    as int
field cli-code    as int
field cli-type    as char
field fact-date   as date
field price-rubl  as decimal
field price-cli   as decimal
index pi gds-code obj-type obj-code fact-date desc
index pi2 fact-date desc
.

define temp-table tt-goods no-undo
field gds-code   as integer
field obj-type    as char
field obj-code    as int
field five        as int
index pi gds-code obj-type obj-code
.

define buffer buf_tt for tt-temp .
define variable jj as integer   no-undo .
define variable v-fact-order-alone as decimal no-undo .
if par-cost = false  then do:
   par-kol = 0 .
  for each gds-list :
      for each obj-list ,
        first ub.gds-obj no-lock where
              ub.gds-obj.gds-code = gds-list.gds-code and
              ub.gds-obj.obj-code = obj-list.obj-code and
              ub.gds-obj.obj-type = obj-list.obj-type
              :
            jj = jj + 1.
           { rep/repfrm.i disp JJ obj-list.obj-name }
                create tt-temp.
                assign
                  tt-temp.obj-type   = obj-list.obj-type
                  tt-temp.obj-code   = obj-list.obj-code
                  tt-temp.gds-code   = gds-list.gds-code
                  tt-temp.price-rubl   = 1
                .

     end.
  end.
end.
if par-cost = true then do:

run day-begin-fact-order in this-procedure
    ( input (x-date-alone + 1)
    , output v-fact-order-alone
    ).
define buffer bb_trn-doc for ub.trn-doc .
  for each obj-list :
      for  each gds-list ,
          each bf_doc-line no-lock where
                bf_doc-line.artic     = gds-list.artic       and
                bf_doc-line.prod-type = gds-list.prod-type and
                bf_doc-line.prod-code = gds-list.prod-code and
                bf_doc-line.obj-type  = obj-list.obj-type and
                bf_doc-line.obj-code  = obj-list.obj-code and
                bf_doc-line.ext-doc-type  = {&TDEDT_Pri_Vnesh}  and
                bf_doc-line.status_       = {&fact} and
                bf_doc-line.fact-order < v-fact-order-alone
              by bf_doc-line.fact-order descending
                :

        find first tt-goods where
                  tt-goods.gds-code = gds-list.gds-code and
                  tt-goods.obj-code = obj-list.obj-code and
                  tt-goods.obj-type = obj-list.obj-type  no-error .
          if available tt-goods and  tt-goods.five > par-kol  then next.

          v-price-rubl = 0.
          v-goods = false .
          v-price-cli = 0 .
          v-price-rubl = bf_doc-line.price-rubl .


            find first tt-goods where
                      tt-goods.gds-code = gds-list.gds-code and
                      tt-goods.obj-code = obj-list.obj-code and
                      tt-goods.obj-type = obj-list.obj-type  no-error .
            if available tt-goods then do:
                tt-goods.five = tt-goods.five  + 1 .
            end.
            else do:
              jj = jj + 1.
            { rep/repfrm.i disp JJ obj-list.obj-name }
              create tt-goods.
              assign
                tt-goods.gds-code = gds-list.gds-code
                tt-goods.obj-code = obj-list.obj-code
                tt-goods.obj-type = obj-list.obj-type
                tt-goods.five = 1
              .
            end.

            if tt-goods.five <= par-kol  then do:
              find first ub.trn-doc no-lock where ub.trn-doc.doc-code = bf_doc-line.doc-code .
                  create tt-temp.
                  assign
                    tt-temp.obj-type   = bf_doc-line.obj-type
                    tt-temp.obj-code   = bf_doc-line.obj-code
                    tt-temp.gds-code   = gds-list.gds-code
                    tt-temp.price-rubl = v-price-rubl
                    tt-temp.price-cli  = v-price-cli
                    tt-temp.fact-date  = ub.trn-doc.fact-date
                    tt-temp.cli-code   = ub.trn-doc.cli-code
                    tt-temp.cli-type   = ub.trn-doc.cli-type
                  .
              end.
          end.
    /*end. /*for each ub.trn-doc*/*/
  end.
end.

kol-post = par-kol .

define stream  OutStream  .
define stream  macr_excel .

define variable v-file-name as character no-undo .
define variable v-ind       as integer   no-undo .
define variable num#col#    as integer no-undo .
define variable C-c    as integer no-undo .
define variable C-str  as character no-undo .
define variable str--1 as character Format "x(60)" no-undo.
define variable str--2 as integer no-undo .
define variable C-i    as integer no-undo .
define variable p-var  as integer no-undo .
define variable var-1  as integer no-undo .
define variable var-2  as integer no-undo .
def buffer This_Object for  ub.clients .

define variable num-ln as integer   no-undo .

define variable i as int no-undo.
define variable j as int no-undo.
define variable Counter1 as integer init 0  no-undo .

define variable LineBuf       as char    no-undo.
define variable Line       as char    no-undo.
define variable UndLine    as char    no-undo.

define variable     Lines_Counter as   int  init 0  no-undo.
define variable     Tmp_Counter   as   int  init 0  no-undo.

define variable vv0 as character no-undo .
define variable vv1 as character no-undo .
define variable vv2 as character no-undo .
define variable vv3 as character no-undo .
define variable vv4 as character no-undo .
define variable vv5 as character no-undo .
define variable vv6 as character no-undo .
define variable vv7 as character no-undo .


{ rep/r-sym.i }


define variable t-1 as character no-undo .
define variable t-2 as character no-undo .
define variable t-3 as character no-undo .
define variable t-4 as character no-undo .
define variable t-5 as character no-undo .

DEFINE FRAME plan-menu
    HEADER
    string( "Лист " + string( PAGE-NUMBER(OutStream) , ">>>>9") ) AT 80 format "X(13)" SKIP
    UndLine format "X(80)" AT 1
    with width {&DOS_CW} down stream-io use-text NO-UNDERLINE  NO-BOX no-labels.

  if session:set-wait-state("compiler") then.
    { cmp/open-out.i STREAM OutStream " " {&CS_PS} }
  define variable v-prn0 as character no-undo .

  assign
    Line    = fill("-", 230)
    UndLine = fill("_", 230)
    LineBuf = fill("_", 240)
  .

define variable v-is-base as logical no-undo .
{ gbl/rbisbase.i    v-is-base  }

if v-is-base = true then do:
end.
else do:
end.

/*-----------------------------------------------------------------------------------------------------------------------*/
v-ind = 0    .

FORM with frame plan-menu .



 /* создаем временный файл */
    Output stream Macr_Excel  close .
    num#str# = 0 .
    run gbl/_tmpfile.p ( "wb", ".txt", output v-file-name) .
    output stream macr_excel to value(v-file-name)   .
    v-ind = v-ind + 1.


  find ub.clients      where ub.clients.obj-type     = {&cmp}            and ub.clients.obj-code      = v-cntxt-host-code-obj no-lock .
  run PrintTitul in this-procedure .

  define variable  v-name as character no-undo .

  define variable  v-old  as integer   no-undo .
  define variable v-artic as character no-undo .
  define variable v-obj as character no-undo .

  /* по строкам -------------------------------------------------------------------------------------------- */
  for each gds-list :
    assign
    v-old = 0
    v-name  = gds-list.gds-name
    v-artic = gds-list.artic
    .
    for each obj-list ,
        first ub.gds-obj no-lock where
              ub.gds-obj.gds-code = gds-list.gds-code and
              ub.gds-obj.obj-code = obj-list.obj-code and
              ub.gds-obj.obj-type = obj-list.obj-type
              :
                assign
                  /*v-obj   = obj-list.obj-type + " " + string(obj-list.obj-code) */
                  v-obj     = obj-list.obj-name
                .
           if not ( ub.gds-obj.price-sale = 0 and par-crsa = true and par-cost = false ) then do:
              run print-line in this-procedure  ( v-obj , v-artic , v-name ).
              if return-value <> "no-old":u then
              assign
              v-old = gds-list.gds-code .
           end.
    end.
  end.
  run print-all-itog in this-procedure .
  /* ... Подвал. --- */
  run on-same-page in this-procedure (input 3) .
  run PrintPodval in this-procedure .
  run paramls-write in this-procedure
    (input "file"
    ,input string(v-ind)
    ,input v-file-name
    ) .
     page stream OutStream .

HIDE STREAM OutStream FRAME plan-menu.
HIDE stream OutStream FRAME BottomFrame .
HIDE stream OutStream FRAME BottomFrame2 .
output stream OutStream CLOSE .
Output stream Macr_Excel  close .

{ rep/repfrm.i off } /* Показать окно информации о текущем процессе */

    run paramls-write in this-procedure
        (input "charcol"
        ,input ""
        ,input "2,3,4"
        ) .


  define variable v-user-action as character no-undo .
  define variable v-printed as logical   no-undo .
  define variable DisabledOptions as integer   no-undo .

  run end-proc in this-procedure .
  if par-kol < 4  and  par-crsa = false and par-nacenka = false
     then
       DisabledOptions = 0 .
     else
       DisabledOptions = 1 .



        run gbl/prnfilen.w
          (input  ""
          ,input  DisabledOptions
          ,input  string(session :temp-directory) + {&DF_Name} + string( g#report-num )
          ,input 7
          ,output v-user-action
          ,output v-printed
          ) .
/* *************************************************************************************************** */
procedure print-line :
do on error undo, return error return-value :
  define input  parameter p-obj   as character no-undo .
  define input  parameter p-artic as character no-undo .
  define input  parameter p-name as character no-undo .
  define variable v-price as decimal   no-undo .
  define variable v-delta as decimal   no-undo .
  define variable kol-d as integer   no-undo .
    v-delta = 0 .
    kol-d = 0.
    v-price = 0 .
    for each buf_tt where buf_tt.gds-code = gds-list.gds-code and
                          buf_tt.obj-type = obj-list.obj-type and
                          buf_tt.obj-code = obj-list.obj-code
                          :
        v-price = v-price + buf_tt.price-rubl .
        v-delta = buf_tt.price-rubl .
        kol-d = kol-d + 1.
     end.
     if v-price = 0 then return "no-old".
     if par-all = 2 then do:
        if v-delta = ( v-price / kol-d ) /* and kol-d > 1 */  then return "no-old".
     end.

   if v-old = gds-list.gds-code then
      assign
        p-artic = ""
        p-name  = ""
      .

  assign
     Lines_Counter = Lines_Counter + 1
    .

  if line-counter( OutStream ) + 2 > page-size( OutStream ) then do:
     run p-line in this-procedure.
     page stream OutStream.
     PUT STREAM OutStream UNFORMATTED
         string( "Лист " + string( PAGE-NUMBER(OutStream) , ">>>>9") ) AT 100 format "X(13)" SKIP .
     run print-1 in this-procedure.
     end.

  if line-counter( OutStream ) < Tmp_Counter then
    assign
    .

  assign
    Tmp_Counter  = line-counter( OutStream )
    num-ln = num-ln + 1
  .

  if line-counter( OutStream ) + j > page-size( OutStream ) then  PAGE STREAM OutStream.

define variable v-margins-range     as integer  no-undo.
define variable v-margins-exists    as logical  no-undo.
define variable v-increase-range     as integer  no-undo.
define variable v-increase-exists    as logical  no-undo.
define variable v-min-marg          as decimal  no-undo.
define variable v-max-marg          as decimal  no-undo.
define variable v-increase-pc          as decimal  no-undo.
define variable v-round-method as character  no-undo.
define variable v-base              as decimal no-undo .
define variable v-rmethod-range     as integer  no-undo.
define variable v-rmethod-exists    as logical  no-undo.

define variable p-pc as character no-undo .
     p-pc ="" .

  if par-nacenka = true then do:
    run grp-obj-margin-value in this-procedure
    (        input gds-list.grp-code
            , input obj-list.obj-type
            , input obj-list.obj-code
            , output v-min-marg
            , output v-max-marg
            , output v-increase-pc
            , output v-round-method
            , output v-base
            , output v-margins-range
            , output v-margins-exists
            , output v-increase-range
            , output v-increase-exists
            , output v-rmethod-range
            , output v-rmethod-exists

    ) no-error .
    if v-increase-exists then do:
        assign
        p-pc = string( v-increase-pc )
       .
    end.
  end.

PUT STREAM OutStream UNFORMATTED
    sym1                format "X(1)" space(0)
    p-obj               format "X(15)" space(0)
    sym2                format "X(1)" space(0)
    p-artic             format "X(16)" space(0)
    sym3                format "X(1)" space(0)
    p-name              format "X(30)" space(0)
.
    num#col# = 1.
    num#str# = num#str# + 1.
    run macr_excel_char in this-procedure(p-obj   , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
    run macr_excel_char in this-procedure(p-artic , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
    run macr_excel_char in this-procedure(p-name  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
    define variable v-count as integer no-undo .
    if par-cost = true then do:
        _buf-tt:
        for each buf_tt where buf_tt.gds-code = gds-list.gds-code and
                              buf_tt.obj-type = obj-list.obj-type and
                              buf_tt.obj-code = obj-list.obj-code break by buf_tt.fact-date desc :
                PUT STREAM OutStream UNFORMATTED
                    sym1                         format "X(1)" space(0)
                    string(buf_tt.price-rubl,">>>>>>>9.99")    format "X(11)" space(0)
                    "(" + string(buf_tt.fact-date ,"99/99/99") + ")"

                    .
                run macr_excel_dec in this-procedure(buf_tt.price-rubl  , num#str# , num#col#   ) .
                 assign    num#col# = num#col# + 1 .
                 run macr_excel_char in this-procedure(" (" + string(buf_tt.fact-date ,"99/99/99") + ")"  , num#str# , num#col#   ) .

                assign    num#col# = num#col# + 1 .

          assign
          v-count = v-count + 1.
          if v-count >= par-kol then LEAVE _buf-tt.
        end.
    end.
  /* ПРОДАЖНЫЕ цены */
  num#col# = 4 + ( 2 * par-kol ).
  if par-crsa = true then do:
      PUT STREAM OutStream UNFORMATTED
          sym2                        format "X(1)"  at (( par-kol * 22 ) + 65 )  space(0)
          string(ub.gds-obj.price-sale,">>>>>>>9.99")  format "X(11)" space(0)
      .
    run macr_excel_dec in this-procedure(ub.gds-obj.price-sale , num#str# , num#col#   ) . num#col# = num#col# + 1     .
  end.
  if par-nacenka = true then do:
      PUT STREAM OutStream UNFORMATTED
        sym3                        format "X(1)"  at (( par-kol * 22 ) + 65 + (if par-crsa then 12 else 0 ))    space(0)
        p-pc                        format "X(4)" space(0)
        sym4                        format "X(1)"  space(0)
        skip
    .
     run macr_excel_char in this-procedure( p-pc , num#str# , num#col#   ) .   num#col# = num#col# + 1 .
   end.
  else do:
      PUT STREAM OutStream UNFORMATTED
          sym3                format "X(1)" at (( par-kol * 22 ) + 65 + (if par-crsa then 12 else 0 ))    space(0)
          skip
      .
  end.
end.
end procedure. /* print-line */



procedure print-all-itog :
  /* Итоговые суммы */
end procedure. /* print-all-itog */


procedure PrintTitul :
  do  on error undo, return error return-value  :
  define variable cc as integer no-undo .
  define variable tt as integer no-undo .
  define variable pp as integer no-undo .

/* ---------------- Создание заголовка :--------------------------------------------------------------------------- */
PUT STREAM OutStream UNFORMATTED
space(1)
   ReportNAme skip
   "по фирме "  ub.clients.obj-name skip
   "Дата составления " + cur-time-date()  skip
      .

  define variable i as integer no-undo .
  Repeat i = 1 to NUM-ENTRIES(ReportHeader,chr(10)) :
    PUT STREAM OutStream UNFORMATTED  Entry(i,ReportHeader,chr(10))  AT 1 format "X(90)" SKIP.
  End.

    num#str# = 1.
    num#col# = 1.
    run macr_excel_char in this-procedure( Reportname , num#str# , num#col#   ) .
    num#str# = num#str# + 1.
    run macr_excel_char in this-procedure( "по фирме " + CAPS( ub.clients.obj-name)   , num#str# , num#col#   ) .
    num#str# = num#str# + 1.
    run macr_excel_char in this-procedure( ReportHeader , num#str# , num#col#   ) .
    num#str# = num#str# + 1.
    run macr_excel_char in this-procedure("Дата составления " + cur-time-date()   , num#str# , num#col#   ) .

/* шапка */
    num#str# = num#str# + 1.
    run macr_excel_char in this-procedure("Объект"  , num#str# , num#col#   ) .    run macr_cell_size ( 10 , ? , num#str# , num#col# , ?, ? ) .
    num#col# = 2.
    run macr_excel_char in this-procedure("Артикул"  , num#str# , num#col#   ) .  run macr_cell_size ( 16 , ? , num#str# , num#col# , ?, ? ) .
    num#col# = 3.
    run macr_excel_char in this-procedure("Наименование"  , num#str# , num#col#   ) . run macr_cell_size ( 30 , ? , num#str# , num#col# , ?, ? ) .
    repeat i = 1 to kol-post :
      num#col# = num#col# + 1.
      run macr_excel_char in this-procedure( "Прих.цена" + string(i) , num#str# , num#col#   ) .
      run macr_cell_size in this-procedure( 10 , ? , num#str# , num#col# , ?, ? ) .
      num#col# = num#col# + 1.
      run macr_excel_char in this-procedure( "Дата" , num#str# , num#col#   ) .
      run macr_cell_size in this-procedure ( 10 , ? , num#str# , num#col# , ?, ? ) .

    end.
  if par-crsa  = true then do:
      num#col# = num#col# + 1.
      run macr_excel_char in this-procedure( "Продажная цена"  , num#str# , num#col#   ) .
      run macr_cell_size in this-procedure ( 10 , ? , num#str# , num#col# , ?, ? ) .
  end.
  if par-nacenka = true then do:
    num#col# = num#col# + 1.
    run macr_excel_char in this-procedure( "Наценка (справочно)"  , num#str# , num#col#   ) .
    run macr_cell_size in this-procedure ( 10 , ? , num#str# , num#col# , ?, ? ) .
  end.

  run print-1 in this-procedure .


    run macr_cell_format in this-procedure
    ( 10    ,    /* p-size     */
      true  ,    /* p-bold     */
      false  ,   /* p-italic   */
      ?    ,     /* p-color-bg */
      1 , /* p-row      */
      1 ,        /* p-col      */
      num#str# , /* p-row-2    */
      num#col# ) .      /* p-col-2    */

     put  stream macr_excel unformatted
       substitute('select("r&1c&2:r&3c&4 ")' , num#str# , 1 , num#str# ,  num#col# ) + {&new-line}  +
       'BORDER( 2 , 2 , 2 , 2 , 2 , ,0,0,0,0,0) '  + {&new-line} +
       'ALIGNMENT(3 , , 4 , 4 ,)'  + {&new-line}
       .
    put  stream macr_excel unformatted
       substitute('select("r&1c&2:r&3c&4 ")' , num#str# , 1 , num#str# ,  3 ) + {&new-line}  +
       'BORDER( 2, , , , , , , , , , ) '  + {&new-line} .

    /* ... конец создания заголовка. --- */
  end.
end procedure. /* PrintTitul */


procedure PrintPodval :
  do on error undo, return error return-value  :
  define variable pp as integer no-undo .
  define variable rr as integer no-undo .
    run p-line in this-procedure.

    /* ... конец создания Подвал. --- */
  end.
end procedure. /* PrintPodval */



PROCEDURE on-same-page :
  define input parameter p-line-number as integer  no-undo .
  if p-line-number > page-size( OutStream ) then return .
  if line-counter( OutStream ) + p-line-number > page-size( OutStream ) then do:

    run p-line in this-procedure.
    page stream OutStream .
    end.
end procedure. /* on-same-page */

procedure print-1 :

  do
  on error undo, return error return-value
  :
    run p-line in this-procedure.
    PUT STREAM OutStream UNFORMATTED  ":Объект"  AT 1 format "X(16)" .
    PUT STREAM OutStream UNFORMATTED  ":Артикул"  format "X(17)" .
    PUT STREAM OutStream UNFORMATTED  ":Наименование"  format "X(31)" .

    repeat i = 1 to kol-post :
      PUT STREAM OutStream UNFORMATTED  ":Прих.цена " + string(i) + "  Дата" format "X(22)" .
    end.

    if par-crsa  = true then do:
      PUT STREAM OutStream UNFORMATTED ":Продaж цена" format "X(12)" .
    end.
    if par-nacenka = true then do:
      PUT STREAM OutStream UNFORMATTED ":% нац:" format "X(6)" .
    end.

    PUT STREAM OutStream UNFORMATTED  skip .
    run p-line in this-procedure.
  end.

end procedure. /* print-1 */

procedure p-line :

  do
  on error undo, return error return-value
  :
    PUT STREAM OutStream UNFORMATTED  fill("-",16)  AT 1 format "X(16)" .
    PUT STREAM OutStream UNFORMATTED  fill("-",31)  format "X(31)" .
    repeat i = 1 to kol-post :
      PUT STREAM OutStream UNFORMATTED fill("-",22) format "X(22)" .
    end.
    if par-crsa  = true then do:
       PUT STREAM OutStream UNFORMATTED fill("-",13) format "X(12)" .
    end.
    if par-nacenka  = true then do:
       PUT STREAM OutStream UNFORMATTED fill("-",6) format "X(6)" .
    end.
    PUT STREAM OutStream UNFORMATTED fill("-",17) format "X(17)" .
    PUT STREAM OutStream UNFORMATTED  skip .

  end.

end procedure. /* p-line */

{ rep/r-libmcr.i macr_excel         }