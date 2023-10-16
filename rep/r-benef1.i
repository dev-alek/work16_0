/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать отчета о выручке по чекам

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/11/06
Author: Bakhtadze Natalya
Creation date: 01/11/06

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{ gbl/cur-time.i }

&global-define  no-benefits    "Не было никакой выручки на выбранных объектах ~
в течение заданного Вами периода времени."


assign
date_string = cur-time-print()
Line = fill( "-", 140 ).

for each benefits:
    delete benefits.
end.

for each inkas-num:
    delete inkas-num.
end.

for each day_sum:
    delete day_sum.
end.

for each all-days_sum:
    delete all-days_sum.
end.

if v-curr-r-b = {&r-b-base} then do:
&if "{1}" = "rubl" &then
sale-price-type = "{&abbr_rubley}".
&else
sale-price-type = base-type.
&endif
end.
else sale-price-type = "{&abbr_rubley}".

run no-benq(output found).
if not found then do:
  run waitfram-hide in this-procedure .
  message {&no-benefits} view-as alert-box information .
  return.
end.

run no-benqi(output NotInc).
&if "{2}" = "time" &then
run rep/r-bennq1.p (
                 input parparentproc
                ,input cas-num
                ,input T-time
                ,input v-curr-r-b
                ,output allday-basesum
                ,output allday-Rublsum
                ,output ObjAmount
                ,output ChkAmount
                ) no-error.
&else
run rep/r-beneq1.p (
                 input parparentproc
                ,input cas-num
                ,input no
                ,input v-curr-r-b
                ,output allday-basesum
                ,output allday-Rublsum
                ,output ObjAmount
                ,output ChkAmount
                ) no-error.
&endif
if error-status:error then return error return-value.
run waitfram-hide in this-procedure .
if x-date-start = x-date-end
then choice = TRUE .
else choice = HowBreak .

&if "{1}" = "tot" &then
run prn-lib-open-stream  in this-procedure (
                                             input parParentProc
                                            ,input {&LS_PS_A4}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).
&else
run prn-lib-open-stream  in this-procedure (
                                             input parParentProc
                                            ,input {&CS_PS}
                                            ,input yes /*p-is-stream*/
                                            ,input no /*p-append*/
                                            ).
&endif


FORM HEADER
Line format "X(136)" AT 1 SKIP
"Продолжение - на следующей странице" AT 30 SKIP
with FRAME BottomFrame width {&A4_CW} PAGE-BOTTOM NO-LABELS NO-BOX .
VIEW stream PrnLibStream FRAME BottomFrame .

PUT stream PrnLibStream UNFORMATTED
space(5) string( "ОТЧЕТ  О  ВЫРУЧКЕ " + str1 )
format "X(120)" SKIP(1)
str4 SKIP(0)
space(5)
(IF NotInc
then
"( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
("КАССЫ " + string(cas-num))) + " , включая невошедшие в отчеты о продажах )"
else
"( сформирован по ВСЕМ ЧЕКАМ " + (IF cas-num = 0 then "ВСЕХ КАСС" ELSE
("КАССЫ " + string(cas-num) ) ) + ")"
  )  format "x(80)" skip
space(5) string( "( всего чеков : " + string( ChkAmount ) +
                  ", в среднем " + string(
&if "{1}" = "rubl" &then
                                     (if ChkAmount > 0 then  round( AllDay-RublSum / ChkAmount, 2 ) else 0)
&else
                                     (if ChkAmount > 0 then  round( AllDay-BaseSum / ChkAmount, 2 ) else 0)
&endif
                                          ) +
                  " " + sale-price-type + " / чек )" ) format "x(80)" skip(1)
.
&if "{2}" = "time" &then
IF T-time then do:
  PUT stream PrnLibStream UNFORMATTED
  "Выборочно по времени: ".
  FOR EACH times No-LOCK :
    PUT stream PrnLibStream UNFORMATTED
    times
    {&space-char}
    .
  END.
  PUT stream PrnLibStream UNFORMATTED
  SKIP (1).
end.
&endif


if choice then do:
    FORM with frame Benefit-{1} .
end.
else do:
    FORM with FRAME PayCodes-{1}.
end.

FOR EACH obj-list WHERE
          obj-list.obj-type = {&shop} ,
    EACH all-days_sum WHERE
          all-days_sum.obj-type = obj-list.obj-type AND
          all-days_sum.obj-code = obj-list.obj-code
BREAK
BY obj-list.obj-type
BY obj-list.obj-code :
  ACCUMULATE
  all-days_sum.tot-base ( TOTAL )
  all-days_sum.tot-rubl ( TOTAL )
  all-days_sum.tot-r-b  ( TOTAL )
  obj-list.obj-code ( COUNT ) .
  if choice then do:
    FOR EACH benefits WHERE
              benefits.obj-type = obj-list.obj-type AND
              benefits.obj-code = obj-list.obj-code
    BREAK
    BY benefits.obj-type
    BY benefits.obj-code
    BY benefits.date_
    BY benefits.pay-code
    BY benefits.curr-code :
      if first( benefits.obj-code ) then do:
        FIND FIRST clients WHERE
                    clients.obj-type = obj-list.obj-type  AND
                    clients.obj-code = obj-list.obj-code  NO-LOCK .
        DOWN stream PrnLibStream 1 with frame Benefit-{1}.
        PUT stream PrnLibStream space(10) clients.obj-name format "x(60)" skip.
        UNDERLINE stream PrnLibStream
        benefits.pay-name
&if "{1}" = "tot" &then
        benefits.curr-name
        benefits.tot-base
&endif
&if "{1}" = "base" &then
        benefits.tot-r-b
&else
        benefits.tot-rubl
&endif
        benefits.pcnt
        with frame Benefit-{1}.
      end. /*if first-of (benefits.obj-code) */
      if first-of( benefits.date_ ) then do:
        doprubl = 0.
        for each t-benefits No-LOCK where
                t-benefits.obj-type = obj-list.obj-type AND
                t-benefits.obj-code = obj-list.obj-code AND
                t-benefits.date_ = benefits.date_:
            doprubl = doprubl +  t-benefits.tot-rubl.
        END.

        FIND FIRST day_sum WHERE
                  day_sum.obj-type = obj-list.obj-type AND
                  day_sum.obj-code = obj-list.obj-code AND
                  day_sum.date_ = benefits.date_   NO-ERROR.
                  day_sum.tot-rubl  = doprubl.
        DatePrinted = FALSE .
      end. /*if first-of( benefits.date_ ) */
&if "{1}" = "rubl" &then
      benefits.pcnt = round( benefits.tot-r-b / day_sum.tot-r-b * 100 , 2 ) .
&else
      benefits.pcnt = round( benefits.tot-rubl / day_sum.tot-rubl * 100 , 2 ) .
&endif

      if benefits.tot-base <> 0
      or day_sum.chk-cnt-all <> 0
      then do:
        if DatePrinted then do:
          DISPLAY stream PrnLibStream
          sym1
          " " format "X(8)" @ benefits.date_
          sym2
          benefits.pay-name
&if "{1}" = "tot" &then
          sym3
          benefits.curr-name
          sym4
          benefits.tot-sum
          sym5
          benefits.tot-base
&endif
          sym6
/*&if "{1}" = "base" &THEN
          benefits.tot-r-b
&else
          benefits.tot-rubl
&endif*/
          sym7
          benefits.pcnt
          sym8
          with frame Benefit-{1} .
          DOWN stream PrnLibStream 1 with frame Benefit-{1}.
        end.
        else do:
          DISPLAY stream PrnLibStream
          sym1
          benefits.date_
          sym2
          benefits.pay-name
&if "{1}" = "tot" &then
          sym3
          benefits.curr-name
          sym4
          benefits.tot-sum
          sym5
          benefits.tot-base
&endif
          sym6
&if "{1}" = "base" &then
          benefits.tot-r-b
&else
          benefits.tot-rubl
&endif
          sym7
          benefits.pcnt
          sym8
          with frame Benefit-{1} .
          DOWN stream PrnLibStream 1 with frame Benefit-{1}.
          DatePrinted = TRUE .
        end.
      end.
      if last-of( benefits.date_ ) then  do:
        ACCUMULATE
        day_sum.tot-base ( TOTAL )
        day_sum.tot-rubl ( TOTAL )
        day_sum.tot-r-b  ( TOTAL )

        .
        if day_sum.chk-cnt-all <> 0 then do:
          UNDERLINE stream PrnLibStream
          benefits.pay-name
&if "{1}" = "tot" &then
          benefits.curr-name
          benefits.tot-base
&endif
&if "{1}" = "base" &then
          benefits.tot-r-b
&else
          benefits.tot-rubl
&endif
          benefits.pcnt
          with frame Benefit-{1}.
          DISPLAY stream PrnLibStream
&if "{1}" = "tot" &then
          sym1
          ("чеков: " + string(day_sum.chk-cnt-all, ">>>>>") + ",") @ benefits.pay-name
          (string( ROUND(day_sum.tot-base / day_sum.chk-cnt-all , 2) ,  "->>>,>>9.99" ) +
                      "/ чек" ) @ benefits.curr-name
          day_sum.tot-base  @ benefits.tot-base
          doprubl @ benefits.tot-rubl
          "100.00%" @ benefits.pcnt
          sym8
&endif
&if "{1}" = "base" &then
          sym1
          ("чеков: " + string(day_sum.chk-cnt-all, ">>>>>") +
            ", в среднем " +
          string( ROUND(day_sum.tot-r-b  / day_sum.chk-cnt-all , 2) ,
                      "->>>,>>9.99" ) +  "/ чек" ) @ benefits.pay-name
          day_sum.tot-r-b  @ benefits.tot-r-b
          "100.00%" @ benefits.pcnt
          sym8
&endif
&if "{1}" = "rubl" &then
          sym1
          ("чеков: " + string(day_sum.chk-cnt-all, ">>>>>") +
            ", в среднем " +
          string( ROUND(day_sum.tot-rubl / day_sum.chk-cnt-all , 2) ,
                        "->>>,>>9.99" ) +  "/ чек" ) @ benefits.pay-name
          day_sum.tot-rubl @ benefits.tot-rubl
          "100.00%" @ benefits.pcnt
          sym8
&endif
          with frame Benefit-{1} .
          UNDERLINE stream PrnLibStream
          benefits.pay-name
&if "{1}" = "tot" &then
          benefits.curr-name
          benefits.tot-base
&endif
&if "{1}" = "base" &then
          benefits.tot-r-b
&else
          benefits.tot-rubl
&endif
          benefits.pcnt
          with frame Benefit-{1}.
        end.
      end.
      if last( benefits.date_ ) AND ( x-date-start <> x-date-end ) then do:
        UNDERLINE stream PrnLibStream
        benefits.pay-name
&if "{1}" = "tot" &then
        benefits.curr-name
        benefits.tot-base
&endif
&if "{1}" = "base" &then
        benefits.tot-r-b
&else
        benefits.tot-rubl
&endif
        with frame Benefit-{1} .
        DISPLAY stream PrnLibStream
        ("ИТОГО  чеков: " + string(day_sum.chk-cnt-all)
        )  @ benefits.pay-name
&if "{1}" = "tot" &then
        all-days_sum.tot-base  @ benefits.tot-base
&endif

&if "{1}" = "base" &then
        all-days_sum.tot-r-b  @ benefits.tot-r-b
&else
        all-days_sum.tot-rubl  @ benefits.tot-rubl
&endif
        with frame Benefit-{1} .
        DOWN stream PrnLibStream 1 with frame Benefit-{1}.
        if NOT last( obj-list.obj-code ) then
        UNDERLINE stream PrnLibStream
        benefits.pay-name
&if "{1}" = "tot" &then
        benefits.curr-name
        benefits.tot-base
&endif
&if "{1}" = "base" &then
        benefits.tot-r-b
&else
        benefits.tot-rubl
&endif
        with frame Benefit-{1}.
      end.
    END.
  end.
  else do: /*сводный за период */
    FOR EACH benefits WHERE
             benefits.obj-type = obj-list.obj-type AND
             benefits.obj-code = obj-list.obj-code
    BREAK
    BY benefits.obj-type
    BY benefits.obj-code
    BY benefits.pay-code
    BY benefits.curr-code :
      if first( benefits.curr-code ) then do:
        FIND FIRST clients WHERE
                   clients.obj-type = obj-list.obj-type  AND
                   clients.obj-code = obj-list.obj-code  NO-LOCK .
        DOWN stream PrnLibStream 1 with FRAME PayCodes-{1}.
        PUT stream PrnLibStream space(10) clients.obj-name format "x(60)" skip .
        UNDERLINE stream PrnLibStream
        benefits.pay-name
&if "{1}" = "tot" &then
        benefits.curr-name
        benefits.tot-base
&endif
&if "{1}" = "base" &then
        benefits.tot-r-b
&else
        benefits.tot-rubl
&endif
        benefits.pcnt
        with frame PayCodes-{1}.
      end.
      ACCUMULATE
      benefits.tot-sum ( TOTAL )
      benefits.tot-base ( TOTAL )
      benefits.tot-rubl ( TOTAL )
      benefits.tot-r-b ( TOTAL )
      benefits.tot-sum ( SUB-TOTAL BY benefits.curr-code )
      benefits.tot-base ( SUB-TOTAL BY benefits.curr-code )
      benefits.tot-rubl ( SUB-TOTAL BY benefits.curr-code )
      benefits.tot-r-b ( SUB-TOTAL BY benefits.curr-code )
      benefits.tot-sum ( SUB-TOTAL BY benefits.pay-code )
      benefits.tot-base ( SUB-TOTAL BY benefits.pay-code )
      benefits.tot-rubl ( SUB-TOTAL BY benefits.pay-code )
      benefits.tot-r-b ( SUB-TOTAL BY benefits.pay-code )
      .
&if "{1}" = "tot" &then
      if last-of( benefits.curr-code ) AND
        ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-base ) <> 0 then do:
        DISPLAY stream PrnLibStream
        sym1 benefits.pay-name
        sym3 benefits.curr-name
        sym4
        ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-sum ) @ benefits.tot-sum
        sym5
        ( ACCUM  SUB-TOTAL BY benefits.curr-code benefits.tot-base ) @ benefits.tot-base
        sym6
        ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-rubl )   @ benefits.tot-rubl
        sym7
        ( round( ( ACCUM SUB-TOTAL BY benefits.curr-code benefits.tot-base ) /
                  all-days_sum.tot-base * 100, 2 ) ) @ benefits.pcnt
        sym8
        with frame PayCodes-{1} .
        DOWN stream PrnLibStream 1 with frame PayCodes-{1}.
      end.
&else
      if last-of( benefits.CURR-code ) AND
        ( ACCUM SUB-TOTAL BY benefits.CURR-code benefits.tot-r-b ) <> 0 then do:
  &if "{1}" = "base" &then
        DISPLAY stream PrnLibStream
        sym1
        benefits.pay-name
        sym6 ( ACCUM SUB-TOTAL BY benefits.CURR-code benefits.tot-r-b ) @ benefits.tot-r-b
        sym7 ( round( ( ACCUM SUB-TOTAL BY benefits.CURR-code benefits.tot-r-b ) /
                                all-days_sum.tot-r-b * 100, 2 ) ) @ benefits.pcnt
        sym8
        with frame PayCodes-{1}.
  &endif
  &if "{1}" = "rubl" &then
        DISPLAY stream PrnLibStream
        sym1
        benefits.pay-name
        sym6 ( ACCUM SUB-TOTAL BY benefits.CURR-code benefits.tot-rubl) @ benefits.tot-rubl
        sym7 ( round( ( ACCUM SUB-TOTAL BY benefits.CURR-code benefits.tot-rubl ) /
                                all-days_sum.tot-rubl * 100, 2 ) ) @ benefits.pcnt
        sym8
        with frame PayCodes-{1}.
  &endif
        DOWN stream PrnLibStream 1 with frame PayCodes-{1}.
      end. /*if last-of( benefits.pay-code ) AND*/
&endif
      if last( benefits.curr-code ) then do:
        UNDERLINE stream PrnLibStream
        benefits.pay-name
&if "{1}" = "tot" &then
        benefits.curr-name
        benefits.tot-base
&endif
&if "{1}" = "base" &then
        benefits.tot-r-b
&else
        benefits.tot-rubl
&endif
        benefits.pcnt
        with frame PayCodes-{1}.
&if "{1}" = "tot" &then
        DISPLAY stream PrnLibStream
        (" ИТОГО чеков: " + string(day_sum.chk-cnt-all) )  @ benefits.pay-name
        ( ACCUM TOTAL benefits.tot-base ) @ benefits.tot-base
        ( ACCUM TOTAL benefits.tot-rubl ) @ benefits.tot-rubl
        "100.00%" @ benefits.pcnt     with frame PayCodes-{1} .
&endif
&if "{1}" = "base" &then
        DISPLAY stream PrnLibStream
        (" ИТОГО чеков: " + string(day_sum.chk-cnt-all) )  @ benefits.pay-name
        ( ACCUM TOTAL benefits.tot-r-b ) @ benefits.tot-r-b
        "100.00%" @ benefits.pcnt
        with frame PayCodes-{1} .
&endif
&if "{1}" = "rubl" &then
        DISPLAY stream PrnLibStream
        (" ИТОГО чеков: " + string(all-days_sum.chk-cnt) )  @ benefits.pay-name
        ( ACCUM TOTAL benefits.tot-rubl ) @ benefits.tot-rubl
        "100.00%" @ benefits.pcnt
        with frame PayCodes-{1} .
&endif
        DOWN stream PrnLibStream 1 with FRAME PayCodes-{1}.
      end. /*last( benefits.curr-code )*/
    END.
  end.
  if last( obj-list.obj-code ) AND ( ACCUM COUNT obj-list.obj-code ) > 1 then  do:
    if choice then do:
&if "{1}" = "tot" &then
      DISPLAY stream PrnLibStream
      "ИТОГО по всем" @ benefits.pay-name
      ACCUM TOTAL all-days_sum.tot-base @ benefits.tot-base
      ACCUM TOTAL all-days_sum.tot-rubl @ benefits.tot-rubl
      with FRAME Benefit-{1} .
&endif
&if "{1}" = "base" &then
      DISPLAY stream PrnLibStream
      "ИТОГО по всем" @ benefits.pay-name
      ( ACCUM TOTAL all-days_sum.tot-r-b ) @ benefits.tot-r-b
      with FRAME Benefit-{1}.
&endif
&if "{1}" = "rubl" &then
      DISPLAY stream PrnLibStream
      "ИТОГО по всем" @ benefits.pay-name
      ( ACCUM TOTAL all-days_sum.tot-rubl ) @ benefits.tot-rubl
      with FRAME Benefit-{1}.
&endif
    end.
    else do:
&if "{1}" = "tot" &then
      DISPLAY stream PrnLibStream
      "ИТОГО по всем" @ benefits.pay-name
      ACCUM TOTAL all-days_sum.tot-base @ benefits.tot-base
      ACCUM TOTAL all-days_sum.tot-rubl @ benefits.tot-rubl
      with FRAME PayCodes-{1} .
&endif
&if "{1}" = "base" &then
      DISPLAY stream PrnLibStream
      "ИТОГО по всем" @ benefits.pay-name
      ( ACCUM TOTAL all-days_sum.tot-r-b ) @ benefits.tot-r-b
      with FRAME PayCodes-{1} .
&endif
&if "{1}" = "rubl" &then
      DISPLAY stream PrnLibStream
      "ИТОГО по всем" @ benefits.pay-name
      ( ACCUM TOTAL all-days_sum.tot-rubl ) @ benefits.tot-rubl
      with FRAME PayCodes-{1}.
&endif
    end.
  end.
END.    /* FOR EACH obj-list ... */
if choice AND ( ObjAmount > 1 ) then do:
  FORM with frame ZUM-PayCodes-{1}.
  FOR EACH benefits
  BREAK
  BY benefits.pay-code :
    ACCUMULATE
    benefits.tot-sum ( SUB-TOTAL BY benefits.pay-code )
    benefits.tot-base ( SUB-TOTAL BY benefits.pay-code )
    benefits.tot-rubl ( SUB-TOTAL BY benefits.pay-code )
    benefits.tot-r-b  ( SUB-TOTAL BY benefits.pay-code )
    .
    if last-of( benefits.pay-code ) AND
        ( ACCUM SUB-TOTAL BY benefits.pay-code benefits.tot-base ) <> 0 then do:
&if "{1}" = "tot" &then
      DISPLAY stream PrnLibStream
      ( "/итого по " + benefits.pay-name ) @ benefits.pay-name
      ( ACCUM SUB-TOTAL BY benefits.pay-code benefits.tot-base ) @ benefits.tot-base
      ( ACCUM SUB-TOTAL BY benefits.pay-code benefits.tot-rubl ) @ benefits.tot-rubl
      with frame ZUM-PayCodes-{1} .
&endif
&if "{1}" = "base" &then
      DISPLAY stream PrnLibStream
      ( "/итого по " + benefits.pay-name ) @ benefits.pay-name
      ( ACCUM SUB-TOTAL BY benefits.pay-code benefits.tot-r-b ) @ benefits.tot-r-b
      with frame ZUM-PayCodes-{1}.
&endif
&if "{1}" = "rubl" &then
      DISPLAY stream PrnLibStream
      ( "/итого по " + benefits.pay-name ) @ benefits.pay-name
      ( ACCUM SUB-TOTAL BY benefits.pay-code benefits.tot-rubl ) @ benefits.tot-rubl
      with frame ZUM-PayCodes-{1} .
&endif
      DOWN stream PrnLibStream 1 with frame ZUM-PayCodes-{1} .
    end.
  END.
end.

HIDE stream PrnLibStream FRAME BottomFrame .

&if "{1}" = "tot" &then
PUT stream PrnLibStream Line format "X(136)" SKIP(1) .
&else
PUT stream PrnLibStream Line format "X(82)" SKIP(1) .
&endif
if ( ACCUM COUNT obj-list.obj-code ) < 2 then do:
  if ( line-counter( PrnLibStream ) + 9 ) > page-size( PrnLibStream ) then page stream PrnLibStream.
  PUT stream PrnLibStream
  space(10) "Директор _______________" format "X(30)"
  "Старший продавец ______________" format "X(30)" SKIP(2)
  space(10) "Бухгалтер ______________" format "X(30)"
  "Кассир ________________________" format "X(30)" SKIP .
end.
output stream PrnLibStream CLOSE.
/*
assign
g#rep-tblname = ""
g#rep-tblrid = -101
g#rep-updflds = string( "Отчет о выручке|" + str1) .
*/
&if "{1}" = "tot" &then
run prn-lib-prn-file in this-procedure (
                                          input parParentProc
                                          ,input 8
                                          ).
&else
run prn-lib-prn-file in this-procedure (
                                          input parParentProc
                                          ,input 0
                                          ).
&endif


/* $Workfile$ e n d */