/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Бестселлеры

Автор: Чернова Светлана Александровна
Дата создания: 03/06/06
Author: Svetlana Chernova
Creation date: 03/06/06
Created: 6.12.00

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Бестселлеры".
{ cmp/vssrevis.i }

/* parameters definitions ---                                           */
{ cmp/str-glbl.i  }
{ cmp/r-page1.i  }
{ cmp/r-pril.i   }
{ rep/rep-bt.i   }
{ rep/r-sym.i    }
{ rep/r-gl.i     }
{ rep/f-fdec.i   }
{ gbl/waitfram.i }
{ cmp/library.i  }
{ rep/lkp-font.i }

define input parameter x-store-code like ub.clients.obj-code   no-undo.
define input parameter x-store-type like ub.clients.obj-type   no-undo.
define input parameter x-base-type  like ub.currency.curr-abbr no-undo.
define input parameter x-base-code  like ub.currency.curr-code no-undo.
define input parameter xcrit        as int no-undo.
define input parameter xsort        as int no-undo.
define input parameter xbsamount    as int no-undo.
define input parameter xsc_name     as int no-undo.
define input parameter x-upper-code as int no-undo.
define input parameter tog-scale    as log no-undo.

define buffer goods   for ub.goods  .
define buffer gds-obj for ub.gds-obj  .
define buffer clients for ub.clients  .

define variable g#log as logical   no-undo .
define variable xclassify  as char no-undo.
define variable xsorttype  as char no-undo.
define variable xsumsonly  as log  no-undo.
define variable xshowzero  as log  no-undo.
define variable xtog-obj   as log  no-undo.
define variable xshowcost  as log  no-undo.
define variable xshowsale  as log  no-undo.
define variable xtog-lavel as log  no-undo.
define variable xvar-lavel as int  no-undo.
define variable  tprintrubl as log no-undo.
define stream  outstream.

/*общий итог*/

define variable    objname           as   char     no-undo.
define variable    select-good       as   integer  no-undo.
define variable    chosedtype        as   integer  no-undo.
define variable    paytype           as   integer  no-undo.
define variable    retclassify       as   char     no-undo.
define variable    retsorttype       as   char     no-undo.
define variable    show-negativ      as   logical  no-undo.
define variable    sums-only         as   logical  no-undo.
define variable    valtype           as   integer  no-undo.
define variable    line              as   char        no-undo.
define variable    firstline         as   logical     no-undo.


define variable tot_tqnty as decimal  no-undo.
define variable break_group as logical no-undo init true.
define variable break_group1 as logical no-undo init true.

/* local variable definitions ---                                       */

define variable stat     as log no-undo .
define variable inperror as log no-undo .
define variable i        as integer no-undo .
define variable p        as integer no-undo init 0 .
define variable kk        as integer no-undo init 0 .
define variable old-page as integer no-undo .
define variable new-page as integer no-undo .
define variable rid-list as character no-undo .

define variable gds-zap-unit-base     like ub.goods.unit-base     no-undo.
define variable gds-zap-prt-root      like ub.goods.prt-root     no-undo .
define variable gds-zap-gds-name      like ub.goods.gds-name     no-undo .
define variable gds-zap-prod-type     like ub.goods.prod-type    no-undo .
define variable gds-zap-prod-code     like ub.goods.prod-code   no-undo .
define variable gds-zap-artic         like ub.goods.artic        no-undo .
define variable gds-zap-b-code        like ub.bar-code.b-code    no-undo .
define variable gds-type              as char no-undo.
define variable gds-zap-type          like ub.goods.gds-type     no-undo .
define variable gds-zap-grp-name      like ub.goods.grp-name     no-undo .
define variable gds-zap-prod-name     like ub.clients.obj-name   no-undo .
define variable gds-zap-price-base    like ub.stk-tot.sum-base no-undo.
define variable gds-zap-stoim-base    like ub.stk-tot.sum-base no-undo.
define variable gds-zap-qnty          like ub.stk-tot.fact-qnty  no-undo.
define variable gds-zap-nds           like ub.stk-tot.sum-base no-undo.
define variable gds-zap-np            like ub.stk-tot.sum-base no-undo.

define variable f-ostatok-start    as   char  no-undo.
define variable f-ostatok-end      as   char  no-undo.
define variable ostatok-start      as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable ostatok-end        as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b1-ostatok-start   as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b1-ostatok-end     as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b2-ostatok-start   as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b2-ostatok-end     as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable bi-ostatok-start   as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable bi-ostatok-end     as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable f-qnty             as   char  no-undo.
define variable f-sumcost          as   char label "Сумма в учетных ценах" no-undo.
define variable f-sumsale          as   char label "Сумма в ценах док-та" no-undo.
define variable f-kassaqnty          as   char  no-undo.
define variable f-kassasale          as   char  no-undo.
define variable f-kassacost         as   char  no-undo.
define variable f-effect          as   char  no-undo.
define variable f-percent          as  decimal format "->>9.99"  no-undo.


define variable f-prih             as   char  no-undo.
define variable f-rash             as   char  no-undo.
define variable f-kassa            as   char  no-undo.
define variable f-inv              as   char  no-undo.
define variable f-overturn         as   char  no-undo.
define variable prih             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable rash             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable kassa            as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable srash             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable skassa            as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable inv              as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable overturn         as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.

define variable b1-prih             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b1-rash             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b1-kassa            as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b1-inv              as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b1-overturn         as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.

define variable b2-prih             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b2-rash             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b2-kassa            as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b2-inv              as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable b2-overturn         as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.

define variable bi-prih             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable bi-rash             as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable bi-kassa            as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable bi-inv              as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.
define variable bi-overturn         as   decimal extent 6 format "->>>>>>>>>9.99<" no-undo.


define variable  fact-order-1   like ub.stk-tot.fact-order no-undo.
define variable  quantity1      like ub.stk-tot.fact-qnty  no-undo.
define variable  coast_r1       like ub.stk-tot.sum-rubl   no-undo.
define variable  coast_v1       like ub.stk-tot.sum-rubl   no-undo.
define variable  vat_r1         like ub.stk-tot.sum-rubl   no-undo.
define variable  vat_v1         like ub.stk-tot.sum-rubl   no-undo.

define variable  fact-order-2   like ub.stk-tot.fact-order no-undo.
define variable  quantity2      like ub.stk-tot.fact-qnty  no-undo.
define variable  coast2         like ub.stk-tot.sum-rubl   no-undo.
define variable  coast_r2       like ub.stk-tot.sum-rubl   no-undo.
define variable  coast_v2       like ub.stk-tot.sum-rubl   no-undo.
define variable  vat_r2         like ub.stk-tot.sum-rubl   no-undo.
define variable  vat_v2         like ub.stk-tot.sum-rubl   no-undo.


define variable  quantity    like ub.stk-tot.fact-qnty  no-undo.
define variable  coast       like ub.stk-tot.sum-rubl   no-undo.
define variable  coast_r     like ub.stk-tot.sum-rubl   no-undo.
define variable  coast_v     like ub.stk-tot.sum-rubl   no-undo.
define variable  vat_r       like ub.stk-tot.sum-rubl   no-undo.
define variable  vat_v       like ub.stk-tot.sum-rubl   no-undo.
define variable  slt_r       like ub.stk-tot.sum-rubl   no-undo.
define variable  slt_v       like ub.stk-tot.sum-rubl   no-undo.


define variable  coast3       like ub.stk-tot.sum-rubl   no-undo.
define variable  coast4       like ub.stk-tot.sum-rubl   no-undo.
define variable  temp-str as char no-undo.

define variable str as char format "x(60)" no-undo.
define variable i#i as int no-undo.
define variable gi as int no-undo.
define variable xlavel as int  no-undo.
define variable list-field as char no-undo.
define variable str10 as char no-undo.

define temp-table tmp#bs no-undo
    field qnty      like ub.ot-line.fact-qnty
    field sumcost   like ub.ot-line.sum-rubl
    field sumsale   like ub.ot-line.sum-rubl
    field kassaqnty like ub.ot-line.sum-rubl
    field kassasale like ub.ot-line.sum-rubl
    field kassacost like ub.ot-line.sum-rubl
    field effect    like ub.ot-line.sum-rubl
    field b-code    like ub.bar-code.b-code
    field artic     like ub.goods.artic
    field prod-type like ub.goods.prod-type
    field prod-code like ub.goods.prod-code
    field prt-root  like ub.goods.prt-root
    field gds-name  like ub.goods.gds-name
    field unit-base like ub.goods.unit-base
    index byqnty       qnty      ascending
    index bysumcost    sumcost   ascending
    index bysumsale    sumsale   ascending
    index byeffect     effect    ascending
    index bykassaqnty  kassaqnty ascending
    index bykassasale  kassasale ascending
    .

define variable  v#qnty         like ub.ot-line.fact-qnty       no-undo.
define variable  v#sumcost      like ub.ot-line.sum-rubl        no-undo.
define variable  v#sumsale      like ub.ot-line.sum-rubl        no-undo.
define variable  v#kassaqnty    like ub.ot-line.sum-rubl        no-undo.
define variable  v#kassasale    like ub.ot-line.sum-rubl        no-undo.
define variable  v#kassacost    like ub.ot-line.sum-rubl        no-undo.
define variable  v#effect       like ub.ot-line.sum-rubl        no-undo.
define variable  v#b-code       like ub.bar-code.b-code      no-undo.
define variable  v#artic        like ub.goods.artic          no-undo.
define variable  v#prod-code    like ub.goods.prod-code      no-undo.
define variable  v#prod-type    like ub.goods.prod-type      no-undo.
define variable  v#prt-root     like ub.goods.prt-root       no-undo.
define variable  v#gds-name     like ub.goods.gds-name       no-undo.
define variable  v#unit-base    like ub.goods.unit-base      no-undo.
define variable  percent#1      like ub.ot-line.sum-rubl   format "->>9.99"            no-undo.
define variable  percent#all    like ub.ot-line.sum-rubl   format "->>>>>>>>>>>>9.99"  no-undo.
define variable  prtroot        like ub.gds-prt.node-code no-undo.

define variable cc as logical no-undo .

/* ************** frame  для формы ************************************************************************************ */
define frame zapas
        sym1 column-label ":!:!:" format "x(1)" space(0)
        gds-zap-b-code column-label  "Код! ! ":c10  space(0)
        sym2 column-label ":!:!:" format "x(1)"       space(0)
        gds-zap-artic column-label "Артикул! ! ":c16 format "x(16)" space(0)
        sym3 column-label ":!:!:" format "x(1)"                         space(0)
        gds-zap-gds-name column-label "Название товара! ! ":c38 format "x(38)" space(0)
        sym4 column-label ":!:!:" format "x(1)"                                     space(0)
        gds-zap-unit-base column-label "Ед.!изм! " format "x(3)"                  space(0)
        sym5 column-label ":!:!:" format "x(1)"                                     space(0)
        f-qnty   column-label "Количество! ! ":c15 format "x(15)"           space(0)
        sym6 column-label ":!:!:" format "x(1)" space(0)
        f-kassaqnty   column-label "в т.ч. Касса! ! ":c15  format "x(15)"   space(0)
        sym7 column-label ":!:!:" format "x(1)" space(0)
        f-sumcost     column-label "Сумма в!учетных!ценах":c15  format "x(15)"           space(0)
        sym8 column-label ":!:!:" format "x(1)" space(0)
        f-kassacost    column-label "в т.ч. Касса!в учетных!ценах":c15  format "x(15)"   space(0)
        sym13 column-label ":!:!:" format "x(1)" space(0)
        f-sumsale    column-label "Сумма в!ценах!док-та":c15 format "x(15)"           space(0)
        sym9 column-label ":!:!:" format "x(1)" space(0)
        f-kassasale    column-label "в т.ч. Касса!в ценах!док-та":c15  format "x(15)"   space(0)
        sym10 column-label ":!:!:" format "x(1)" space(0)
        f-effect              column-label "Эффективность! ! ":c15  format "x(15)"   space(0)
        sym11 column-label ":!:!:" format "x(1)" space(0)
        f-percent           column-label "%! ! ":c7  format "->>9.99"   space(0)
        sym12 column-label ":!:!:" format "x(1)" space(0)
    header
        string( "Дата печати : " + string(today,"99.99.9999") +  " , " + string(time, "hh:mm") ) at 5 format "x(35)"
        "Цены указаны в" (if tprintrubl then "{&abbr_rub_allshift}" else x-base-type )
        string( "Страница " + string( page-number( outstream ), ">>>>9") ) at 147 format "x(53)" skip
        line format "x(192)" at 1
   with width {&dos_cw_2} down stream-io use-text no-box.
/*===================================================================================================================*/
        find first ub.gds-prt where ub.gds-prt.node-name = {&empty-scale} no-lock no-error.
        if available  ub.gds-prt then   prtroot =    ub.gds-prt.node-code.
                              else   prtroot = 0.

     assign
        i=0
        xlavel = xvar-lavel
        select-good   = x-selectgood
        paytype       = x-set_pay_type
        retclassify   = xclassify
        retsorttype   = xsorttype
        sums-only     = xsumsonly
        show-negativ  = xshowzero
        firstline     = false.
        line          = fill("-", {&dos_cw_2}).
        valtype       = if (paytype = 1) then 0  else x-set_val_type.
        for each tmp#bs share-lock:
            delete tmp#bs .
        end.
        { gbl/chk-actg.i
          v-cntxt-db-num
          v-cntxt-userid
          {&action-head-code-main}
          'actn_reports_lookup-cost':U
          {&cntxt-object}
          v-cntxt-host-code-obj
          v-cntxt-obj-type
          v-cntxt-obj-code
          0
          0
          0
          false
          g#log
        }
        cc = g#log.


define variable v-r-b-curr-code as integer no-undo .
define variable v-r-b-scale as integer no-undo .
define variable v-r-b-rate  as decimal no-undo .
define variable v-r-b-abbr as character no-undo .
define variable v-cur-base as decimal no-undo .


{ gbl/r-b-curr.i
  v-cntxt-host-code-obj
  v-r-b-curr-code
}

{ gbl/exchrate.i
  v-r-b-curr-code
  today
  v-r-b-rate
  v-r-b-scale
  v-r-b-abbr
}


        run report-execute .
/*-----------------------------------------------------------------------------------------------------------------------------*/
procedure report-execute :
/*------------------------------------------------------------------------------
  purpose: Сбор и выполнение отчета
  parameters:  <none>
  notes:
------------------------------------------------------------------------------*/
  if (valtype=0 and x-base-code=0)  or valtype=1
                                then   assign tprintrubl = yes .
                                else   assign tprintrubl = no .

  run waitfram-show ( {&mywaitmess} ) .
 { cmp/open-out.i stream outstream  " "  ReportPageHeight }
  /*----------------------------------------------------------------*/
   if xtog-obj /* раздельно по объектам */ then do:
            for each obj-list no-lock:
                x-store-type = obj-list.obj-type.
                x-store-code = obj-list.obj-code.
                run report-exec1 .
            end.
                                               end.
  else
    run report-exec1.

  hide   stream outstream frame zapas .
  output stream outstream close.
  {&closeexcel}

  run waitfram-hide .
  define variable v-user-action as character no-undo .
  define variable v-printed as logical   no-undo .
  define variable disabledoptions as integer   no-undo .

define variable v-orient-page as character no-undo .
run How-name in this-procedure (
    input ReportPageHeight,
    input ReportPageWidth,
    output v-orient-page )
    .
if v-orient-page = "A4-lans":U then DisabledOptions = 8 .
                               else DisabledOptions = 0 .

  run gbl/prnfilen.w
    (input  ""
    ,input  disabledoptions
    ,input  string(session :temp-directory) + {&df_name} + string( g#report-num )
    ,input ReportFontNum
    ,output v-user-action
    ,output v-printed
    ) .
end procedure.
/*----------------------------------------------------------------------------------*/
procedure foreach :
/*------------------------------------------------------------------------------
  purpose: Поиск по итогам по строкам документов
  parameters:  <none>
  notes:
------------------------------------------------------------------------------*/
 gi = gi + 1.
 { rep/r-mess.i gi 50 }
  run clear-item .
/* обороты ------------------------------------------------------------------------------------------------------*/
/* цена   по 1 товару  */
   run ob-line (
      input   x-store-code   ,
      input   x-store-type   ,
      input   gds-zap-artic       ,
      input   gds-zap-prod-code   ,
      input   gds-zap-prod-type   ,
      input   fact-order-1,
      input   fact-order-2,
      input   {&arh-cost}    ,
      input   {&root-cat-id},
      input   ""      ,
      input   xtog-obj ).

end procedure.
/*-----------------------------------------------------------------------------------------------------------------------------*/
procedure display-line :
 end procedure.
/*-----------------------------------------------------------------------------------------------------------------------------*/
procedure print-header :
if not firstline then  run display-title .
    firstline = true .
    if xtog-obj and   x-selectobject <> "currency":u   then  do:
          {&put-u1}  "ПО ОБЪЕКТУ : " + caps(objname)  at 30 format "x(170)" skip.
          end.

     form {&wfz} .  {&frame-d} .
   end procedure.
/*-----------------------------------------------------------------------------------------------------------------------------*/
procedure print-footer :
       run u-line.
       end procedure.
/*-----------------------------------------------------------------------------------------------------------------------------*/
procedure u-line :
underline stream outstream  {&all-sym}
        gds-zap-b-code
        gds-zap-artic
        gds-zap-gds-name
        gds-zap-unit-base
        f-qnty
        f-sumcost
        f-kassaqnty
        f-sumsale
        f-kassacost
        f-kassasale
        f-effect
        f-percent
        {&wfz} .
        {&frame-d}.
        end procedure.
procedure calcitog :
/*------------------------------------------------------------------------------
  purpose:  Найти  на начало и конец  fact-order
  номерА  fact-ordera -ДОЛЖЕНЫ ЛЕЖАТЬ В ИНТЕРВАЛЕ ВРЕМЕНИ
  ------------------------------------------------------------------------------*/
/*остаток на НАЧАЛО ЭТО ОСТАТОК НА КОНЕЦ предыдущего дня*/
    run ostatok (
        input x-store-code  ,
        input x-store-type  ,x-tog-shift,
        input x-date-start - 1 ,
        input date('')      ,  x-shift-start,x-shift-end,
        input {&arh-cost}   ,
        input {&root-cat-id},
        input xtog-obj ,

        output  quantity1  ,
        output  coast_r1   ,
        output  coast_v1   ,
        output  vat_r1     ,
        output  vat_v1     ,
        output  fact-order-1 ).
/*----------------------------------------------------------------------------------------------------------------*/
/*номер последнего fact-ordera и остатки на конец интервала  */
/* номерА  fact-ordera -ДОЛЖЕНЫ ЛЕЖАТЬ В ИНТЕРВАЛЕ ВРЕМЕНИ*/
    run ostatok (
        input x-store-code  ,
        input x-store-type  ,x-tog-shift,
        input x-date-start  ,
        input x-date-end    ,  x-shift-start,x-shift-end,
        input {&arh-cost}   ,
        input {&root-cat-id},
        input xtog-obj ,

        output  quantity1  ,
        output  coast_r1   ,
        output  coast_v1   ,
        output  vat_r1     ,
        output  vat_v1     ,
        output  fact-order-2 ).
/*эти не нужны*/
          quantity1  = 0.
          coast_r1   = 0.
          coast_v1   = 0.
          vat_r1     = 0.
          vat_v1     = 0.

end procedure.
/*------------------------------------------------------------------------------*/
procedure display-bi  :
end procedure.
procedure display-b1  :
end procedure.
procedure display-b2  :
end procedure.
procedure clear-b1  :
 end procedure.
procedure clear-b2  :
end procedure.
procedure clear-bi  :
end procedure.

procedure display-title :
   {&put-u1}  string(v-cntxt-host-name-obj +  " , " + x-store-type  +  " " + objname) at 50 format "x(85)" skip(2)
          reportname  at 35 format "x(170)" skip
          trim(str1)  at 35 format "x(75)" skip.

     repeat i = 1 to num-entries(str2,chr(10)) :
      {&put-u1}  entry(i,str2,chr(10))  at 1 format "x(170)" skip.
     end.
    i=0.

     repeat i = 1 to num-entries(str3,chr(10)) :
      {&put-u1}  entry(i,str3,chr(10))  at 1 format "x(170)" skip.
     end.
    i=0.

     repeat i = 1 to num-entries(str4,chr(10)) :
      {&put-u1}  entry(i,str4,chr(10))  at 1 format "x(170)" skip.
     end.
    i=0.


     repeat i = 1 to num-entries(reportheader,chr(10)) :
      {&put-u1}  entry(i,reportheader,chr(10))  at 1 format "x(170)" skip.
     end.
    i=0.
   run rep/extitle.p (1) . /*печать заголовка и шапки в exel*/


end procedure.

procedure ob-line  :
define input  parameter x-store-code   like ub.clients.obj-code     no-undo.
define input  parameter x-store-type   like ub.clients.obj-type     no-undo.
define input  parameter x-artic        like ub.ot-line.artic        no-undo.
define input  parameter x-prod-code    like ub.ot-line.prod-code    no-undo.
define input  parameter x-prod-type    like ub.ot-line.prod-type    no-undo.
define input  parameter x-fact-order-1   like ub.ot-line.fact-order   no-undo.
define input  parameter x-fact-order-2   like ub.ot-line.fact-order   no-undo.
define input  parameter x-sum-type       like ub.ot-line.sum-type     no-undo.
define input  parameter x-cat-id         like ub.ot-line.cat-id       no-undo.
define input  parameter x-ext-doc-type   like ub.ot-line.ext-doc-type no-undo.
define input  parameter xtog-obj           as log no-undo.
define variable  tt#          as   int                 no-undo.

  for each obj-list no-lock:
   if  xtog-obj then
       if   not(    x-store-type     = obj-list.obj-type
            and    x-store-code      = obj-list.obj-code ) then next.

     for each ub.ot-line where
                        ub.ot-line.artic         = x-artic
                  and   ub.ot-line.fact-order   <= x-fact-order-2
                  and   ub.ot-line.fact-order   >= x-fact-order-1
                  and   ub.ot-line.obj-code     = obj-list.obj-code
                  and   ub.ot-line.obj-type     = obj-list.obj-type
                  and   ub.ot-line.prod-code    = x-prod-code
                  and   ub.ot-line.prod-type    = x-prod-type
                  and   (ub.ot-line.sum-type    = {&arh-cost} or ub.ot-line.sum-type = {&arh-sale} or
                         ub.ot-line.sum-type    = {&arh-cost-service} or ub.ot-line.sum-type = {&arh-sale-service}  )
                  no-lock :

 if ub.ot-line.sum-type = {&arh-cost} or
    ub.ot-line.sum-type = {&arh-cost-service} then tt# = 0.
                                           else tt# = 3 .

        case ub.ot-line.ext-doc-type:
        /*разбивка по типам документов */
        /*
             when       {&tdedt_ras_perem}      then
                    if x-selectobject = "currency":u then
                    assign rash[1 + tt#]   = rash[1 + tt#]   +  ub.ot-line.fact-qnty
                           rash[2 + tt#]   = rash[2 + tt#]   +  ub.ot-line.sum-rubl.
          */
        /* расход */
             when       {&tdedt_ras_vnesh}      or
             when       {&tdedt_vozvrat_vnesh}  or
             when       {&tdedt_ras_prvo}       or
             when       {&tdedt_spi_prvo}
                 then
                 assign rash[1 + tt#]   = rash[1 + tt#]   +  ub.ot-line.fact-qnty
                  rash[2 + tt#]   = rash[2 + tt#]   + ( if tprintrubl then ub.ot-line.sum-rubl else ub.ot-line.sum-base ).

       /* касса */
             when       {&tdedt_ras_vnesh_kass}  or
             when       {&tdedt_vozvrat_vnesh_kass} then
                 do:
           assign kassa[1 + tt#]   = kassa[1 + tt#]   +  ub.ot-line.fact-qnty
                  kassa[2 + tt#]   = kassa[2 + tt#]   +  ( if tprintrubl then ub.ot-line.sum-rubl else ub.ot-line.sum-base ).
                 end.

          end case.
   end.
  end.

end procedure.

 { rep/ostatok.i }
/*----------------------------------------------------------------*/
procedure report-exec1  :
   find first ub.clients where x-store-type = ub.clients.obj-type and
                            x-store-code = ub.clients.obj-code no-lock no-error.

           if available ub.clients then  objname = ub.clients.obj-name.
                                         else  objname="объект не определен".
  run waitfram-show (objname) .

  form with frame zapas .
  { rep/r-formh.i x(176) {&dos_cw_2}}
  run calcitog .
  run print-header .
      i = 0.
      case select-good :
        when {&g-all}      then do: { rep/bs-run1.i "1" "1" 1 goods goods.gds-code} end.
        when {&g-grp}      then do: { rep/bs-run2.i "1" "1" 1 goods goods.gds-code} end.
        when {&g-prod}     then do: { rep/bs-run3.i "1" "1" 1 goods goods.gds-code} end.
        when {&g-choice}   then do: { rep/bs-run1.i "1" "1" 1 gds-list gds-list.gds-code} end.
        when {&g-one}      then do: { rep/bs-run1.i "1" "1" 1 gds-list gds-list.gds-code} end.
        when {&g-spis}     then do: { rep/bs-run1.i "1" "1" 1 gds-list gds-list.gds-code} end.
        when {&g-grp-prod} then do: { rep/bs-run1.i "1" "1" 1 gds-list gds-list.gds-code} end.
       end case.

  run printtemptable .
  hide stream outstream frame bottomframe .
  run print-footer .
  end procedure.

procedure clear-item :
define variable kk as int no-undo.
 repeat kk = 1 to 6:
 assign
    rash                [kk]    = 0
    kassa               [kk]    = 0.
       end.

 end procedure.
/*-----------------------------------------------------------------------------------------*/
procedure item-goods :
 define input parameter  par-3 as char no-undo.
 define input parameter  par-4 as char no-undo.

     if par-4 = "goods":u  then do:
                                assign
                                    gds-zap-unit-base  = goods.unit-base
                                    gds-zap-prt-root   = goods.prt-root
                                    gds-zap-prod-type  = goods.prod-type
                                    gds-zap-prod-code  = goods.prod-code
                                    gds-zap-artic      = goods.artic
                                    gds-zap-grp-name   = goods.grp-name
                                    gds-zap-b-code     = goods.gds-code  .
                                if g#gds-engl then
                                    assign gds-zap-gds-name = goods.engl-name.
                                else
                                    assign gds-zap-gds-name = goods.gds-name.

                            end.
     if par-4 = "gds-list":u  then do:
                                assign
                                    gds-zap-unit-base  = gds-list.unit-base
                                    gds-zap-prt-root   = gds-list.prt-root
                                    gds-zap-prod-type  = gds-list.prod-type
                                    gds-zap-prod-code  = gds-list.prod-code
                                    gds-zap-artic      = gds-list.artic
                                    gds-zap-grp-name   = gds-list.grp-name
                                    gds-zap-b-code     = gds-list.gds-code  .
                                if g#gds-engl then
                                    assign gds-zap-gds-name = gds-list.engl-name.
                                else
                                    assign gds-zap-gds-name = gds-list.gds-name.

                            end.
    run foreach .
    run maketemptable .

end procedure.

procedure di :
define input parameter p1 as char no-undo.
define input parameter p2 as int no-undo.
define input parameter p3 as char no-undo.
define input parameter p4 as char no-undo.
define input parameter p5 as char no-undo.
define input parameter p6 as char no-undo.
define input parameter p7 as char no-undo.

end procedure.

procedure maketemptable :
   assign
    v#qnty    =   ( -1 ) * (rash[1] + kassa[1])
    v#sumcost =   ( -1 ) * (rash[2] + kassa[2])
    v#sumsale =   ( -1 ) * (rash[5] + kassa[5])
    v#kassaqnty = ( -1 ) * (kassa[1])
    v#kassasale = ( -1 ) * (kassa[5] )
    v#kassacost = ( -1 ) * (kassa[2] )
    /* v#effect    = ( -1 ) * (rash[5] + kassa[5]) - ( -1 ) * (rash[2] + kassa[2]) */
    v#effect    = ( -1 ) * ( kassa[5]) - ( -1 ) * ( kassa[2])
    v#b-code    =  gds-zap-b-code
    v#artic     =  gds-zap-artic
    v#prod-type =  gds-zap-prod-type
    v#prod-code =  gds-zap-prod-code
    v#prt-root  =  gds-zap-prt-root
    v#gds-name  =  gds-zap-gds-name
    v#unit-base =  gds-zap-unit-base
  .

 if gi <= xbsamount then do:

   create tmp#bs.
   run eqq .
   end.

 else do:
     case xcrit:
        when 1 then do:
           find first tmp#bs  use-index byqnty.
           if available tmp#bs and v#qnty > tmp#bs.qnty then run eqq .
           end.
        when 2 then do:
           find first tmp#bs  use-index bysumcost.
           if available tmp#bs and v#sumcost > tmp#bs.sumcost then run eqq .
           end.
        when 3 then do:
           find first tmp#bs  use-index bysumsale.
           if available tmp#bs and v#sumsale > tmp#bs.sumsale then run eqq .
           end.
        when 4 then do:
           find first tmp#bs  use-index byeffect.
           if available tmp#bs and v#effect > tmp#bs.effect then run eqq .
           end.
        when 5 then do:
           find first tmp#bs  use-index bykassaqnty.
           if available tmp#bs and v#kassaqnty > tmp#bs.kassaqnty then run eqq .
           end.
        when 6 then do:
           find first tmp#bs  use-index bykassasale.
           if available tmp#bs and v#kassasale > tmp#bs.kassasale then run eqq .
           end.
    end case.
 end.
end procedure.

procedure eqq :
   assign
    tmp#bs.qnty      = v#qnty
    tmp#bs.sumcost   = v#sumcost
    tmp#bs.sumsale   = v#sumsale
    tmp#bs.kassaqnty = v#kassaqnty
    tmp#bs.kassasale = v#kassasale
    tmp#bs.kassacost = v#kassacost
    tmp#bs.effect    = v#effect
    tmp#bs.b-code    = v#b-code
    tmp#bs.artic     = v#artic
    tmp#bs.prod-code = v#prod-code
    tmp#bs.prod-type = v#prod-type
    tmp#bs.prt-root  = v#prt-root
    tmp#bs.gds-name  = v#gds-name
    tmp#bs.unit-base = v#unit-base.

end procedure.

procedure printtemptable :
     case xsort:
        when 1 then do:
             percent#all = 0.
             for each tmp#bs no-lock:
             percent#all = percent#all + tmp#bs.qnty.
             end.

            for each tmp#bs no-lock by tmp#bs.qnty  descending  :
                if percent#all <> 0 then
                percent#1 = tmp#bs.qnty * 100 / percent#all .
                else percent#1 = 0.
               run display-str .
            end.
           end.

        when 2 then do:
             percent#all = 0.
             for each tmp#bs no-lock:
             percent#all = percent#all + tmp#bs.sumcost.
             end.

            for each tmp#bs no-lock by tmp#bs.sumcost descending :
            if percent#all <> 0 then
                percent#1 = tmp#bs.sumcost * 100 / percent#all .
                else percent#1 = 0.
            run display-str .
            end.
           end.

        when 3 then do:
             percent#all = 0.
             for each tmp#bs no-lock:
             percent#all = percent#all + tmp#bs.sumsale .
             end.

            for each tmp#bs no-lock by tmp#bs.sumsale descending :
            if percent#all <> 0 then
                percent#1 = tmp#bs.sumsale  * 100 / percent#all .
                else percent#1 = 0.
            run display-str .
            end.
           end.

        when 4 then do:
             percent#all = 0.
             for each tmp#bs no-lock:
             percent#all = percent#all + tmp#bs.effect   .
             end.

            for each tmp#bs no-lock by tmp#bs.effect descending :
            if percent#all <> 0 then
                percent#1 =  tmp#bs.effect * 100 /  percent#all .
                else percent#1 = 0.
            run display-str .
            end.
           end.
        when 5 then do:
             percent#all = 0.
             for each tmp#bs no-lock:
             percent#all = percent#all + tmp#bs.kassaqnty.
             end.

            for each tmp#bs no-lock by tmp#bs.kassaqnty  descending  :
                if percent#all <> 0 then
                percent#1 = tmp#bs.kassaqnty * 100 / percent#all .
                else percent#1 = 0.
               run display-str .
            end.
           end.
        when 6 then do:
             percent#all = 0.
             for each tmp#bs no-lock:
             percent#all = percent#all + tmp#bs.kassasale .
             end.

            for each tmp#bs no-lock by tmp#bs.kassasale descending :
            if percent#all <> 0 then
                percent#1 = tmp#bs.kassasale  * 100 / percent#all .
                else percent#1 = 0.
            run display-str .
            end.
           end.
    end case.

end procedure.

procedure display-str  :
  display stream  outstream {&all-sym}
    tmp#bs.b-code    @ gds-zap-b-code
    tmp#bs.artic     @ gds-zap-artic
    tmp#bs.gds-name  @ gds-zap-gds-name
    tmp#bs.unit-base @ gds-zap-unit-base
    tmp#bs.qnty      @ f-qnty
    tmp#bs.sumcost  when (cc = true )     @ f-sumcost
    tmp#bs.sumsale                        @ f-sumsale
    tmp#bs.kassaqnty                      @ f-kassaqnty
    tmp#bs.kassasale                      @ f-kassasale
    tmp#bs.kassacost  when ( cc = true )  @ f-kassacost
    tmp#bs.effect     when ( cc = true )  @ f-effect
    percent#1         when (cc = true )   @ f-percent
    {&wfz} . {&frame-d}.

    {&putexcel}
        tmp#bs.b-code     {&tabulation}
        tmp#bs.artic      {&tabulation}
        tmp#bs.gds-name   {&tabulation}
        tmp#bs.unit-base  {&tabulation}
        excel-qnty(tmp#bs.qnty)  {&tabulation}
        excel-qnty(tmp#bs.kassaqnty) {&tabulation}
        if (cc = true ) then  excel-sum( tmp#bs.sumcost   ) else " "  {&tabulation}
        if (cc = true ) then  excel-sum( tmp#bs.kassacost ) else " "  {&tabulation}
        excel-sum(tmp#bs.sumsale)  {&tabulation}
        excel-sum(tmp#bs.kassasale)  {&tabulation}
        if (cc = true ) then  excel-sum( tmp#bs.effect ) else " " {&tabulation}
        if (cc = true ) then  excel-sum(percent#1 ) else " " skip.

    if  tog-scale and tmp#bs.prt-root <> prtroot and tmp#bs.prt-root <> 0 then
         if xsc_name = 0 then do:
                             if tmp#bs.qnty = 0 then
                             run print_scala ( 0 ) .
                             else
                             run print_scala ( tmp#bs.sumcost / tmp#bs.qnty ).
                         end.
                         else do:
                             if tmp#bs.prt-root = x-upper-code then do:
                                if tmp#bs.qnty = 0 then
                                run print_scala ( 0 ).
                                else
                                run print_scala ( tmp#bs.sumcost / tmp#bs.qnty ).
                             end.
                          end.

end procedure.

procedure print_scala  :
define input parameter p-price-cost as decimal no-undo .
define variable  tt#          as   int                 no-undo.
/* xsc_name   */
run clear-item .

for each obj-list ,
    each ub.gds-dtl where  ub.gds-dtl.obj-code     = obj-list.obj-code
                  and   ub.gds-dtl.obj-type     = obj-list.obj-type
                  and   ub.gds-dtl.artic        = tmp#bs.artic
                  and   ub.gds-dtl.prod-code    = tmp#bs.prod-code
                  and   ub.gds-dtl.prod-type    = tmp#bs.prod-type
                  no-lock
                  break by ub.gds-dtl.prt-code :

      if var-report-r-b = "rubl" then do:
        if tprintrubl then v-cur-base = ub.gds-dtl.cur-base .
                      else v-cur-base = ub.gds-dtl.cur-base * ( v-r-b-scale / v-r-b-rate ).
      end.
      else do:
        if not tprintrubl then v-cur-base = ub.gds-dtl.cur-base .
                          else v-cur-base = ub.gds-dtl.cur-base /  v-r-b-scale * v-r-b-rate .
      end.

      for each ub.ot-line no-lock where
                              ub.ot-line.obj-code     = obj-list.obj-code
                        and   ub.ot-line.obj-type     = obj-list.obj-type
                        and   ub.ot-line.artic        = tmp#bs.artic
                        and   ub.ot-line.prod-code    = tmp#bs.prod-code
                        and   ub.ot-line.prod-type    = tmp#bs.prod-type
                        and   ub.ot-line.fact-order   <= fact-order-2
                        and   ub.ot-line.fact-order   >= fact-order-1
                        and   ub.ot-line.sum-type      = {&arh-cost}
                        and   (/* ub.ot-line.ext-doc-type = {&tdedt_ras_perem}      or */
                              ub.ot-line.ext-doc-type = {&tdedt_ras_vnesh}       or
                              ub.ot-line.ext-doc-type = {&tdedt_vozvrat_vnesh}   or
                              ub.ot-line.ext-doc-type = {&tdedt_ras_prvo}        or
                              ub.ot-line.ext-doc-type = {&tdedt_spi_prvo}        or
                              ub.ot-line.ext-doc-type = {&tdedt_ras_vnesh_kass}  or
                              ub.ot-line.ext-doc-type = {&tdedt_vozvrat_vnesh_kass})
                              :
                 /* ub.gds-dtl.cur-base */

                  if ub.ot-line.sum-type = {&arh-cost} then tt# = 0.
                                                    else tt# = 3 .
                  case ub.ot-line.ext-doc-type:
                  /*разбивка по типам документов */
                      when       {&tdedt_ras_perem}      then
                              if x-selectobject = "currency":u then do:
                              assign srash[1 + tt#]   = srash[1 + tt#]   +  ub.gds-dtl.fact-qnty
                                     srash[2 + tt#]   = srash[2 + tt#]   +  (ub.gds-dtl.fact-qnty * p-price-cost )
                                     srash[5 + tt#]   = srash[5 + tt#]   +  (ub.gds-dtl.fact-qnty * v-cur-base).
                                    end.
                  /* расход */
                      when       {&tdedt_ras_vnesh}      or
                      when       {&tdedt_vozvrat_vnesh}      or
                      when       {&tdedt_ras_prvo}       or
                      when       {&tdedt_spi_prvo}
                          then
                          assign srash[1 + tt#]   = srash[1 + tt#]   +  ub.gds-dtl.fact-qnty
                                 srash[2 + tt#]   = srash[2 + tt#]   +   (ub.gds-dtl.fact-qnty * p-price-cost )
                                 srash[5 + tt#]   = srash[5 + tt#]   +  (ub.gds-dtl.fact-qnty * v-cur-base).

                /* касса */
                      when       {&tdedt_ras_vnesh_kass}  or
                      when       {&tdedt_vozvrat_vnesh_kass} then
                          do:
                    assign skassa[1 + tt#]   = skassa[1 + tt#]   +  ub.gds-dtl.fact-qnty
                           skassa[2 + tt#]   = skassa[2 + tt#]   +  (ub.gds-dtl.fact-qnty * p-price-cost )
                           skassa[5 + tt#]   = skassa[5 + tt#]   +  (ub.gds-dtl.fact-qnty * v-cur-base).

                          end.
                    end case.
      end. /* ub.ot-line */


  if last-of(ub.gds-dtl.prt-code) then do:
      find first ub.gds-prt  where ub.gds-prt.node-code = ub.gds-dtl.prt-code no-lock no-error .
      find first ub.bar-code where ub.bar-code.gds-code = tmp#bs.b-code and
                                              ub.bar-code.unit-cli = tmp#bs.unit-base and
                                              ub.bar-code.node-code = ub.gds-prt.node-code and
                                              ub.bar-code.part-code = "" and
                                              ub.bar-code.in-code = ""
                                              no-lock no-error .
     if  ub.bar-code.b-code   <> tmp#bs.b-code then do:
      display stream  outstream {&all-sym}
        ub.bar-code.b-code                                                 @ gds-zap-b-code
        ""                                                              @ gds-zap-artic
        ub.gds-prt.f-name                                                  @ gds-zap-gds-name
        tmp#bs.unit-base                                                @ gds-zap-unit-base
         (srash[1] + skassa[1]) format "->>>>>>>>>9.999"                @ f-qnty
         (skassa[1])                                                    @ f-kassaqnty
         (srash[2] + skassa[2])                   when ( cc = true )    @ f-sumcost
         (srash[5] + skassa[5])                                         @ f-sumsale
         (skassa[2])                              when ( cc = true )    @ f-kassacost
         (skassa[5])                                                    @ f-kassasale
         ((srash[5] + skassa[5]) - (srash[2] + skassa[2])) when ( cc = true )    @ f-effect
        ""                                                                       @ f-percent
       {&wfz} . {&frame-d}.

        {&putexcel}
            ub.bar-code.b-code                                              {&tabulation}
            ""                                                           {&tabulation}
            ub.gds-prt.f-name                                               {&tabulation}
            tmp#bs.unit-base                                             {&tabulation}
            excel-qnty (srash[1] + skassa[1])                           {&tabulation}
            excel-qnty (skassa[1] )                                     {&tabulation}
            if (cc = true ) then  excel-sum((srash[2] + skassa[2]) ) else " " {&tabulation}
            if (cc = true ) then  excel-sum((skassa[2]) ) else " "            {&tabulation}
            excel-sum(srash[5] + skassa[5])                                   {&tabulation}
            excel-sum( (skassa[5]) )                                          {&tabulation}
            if (cc = true ) then  excel-sum( ((srash[5] + skassa[5]) - (srash[2] + skassa[2])) ) else " "
            {&tabulation}
            skip.

        assign   srash[1]  = 0  srash[2]  = 0  srash[5]  = 0
                 skassa[1] = 0  skassa[2] = 0  skassa[5] = 0.
     end.
  end. /* if */
end. /* for each */

end procedure.