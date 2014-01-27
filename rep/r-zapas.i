/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Состояние запаса(закладка № 2)

Автор: Чернова Светлана Александровна
Дата создания: 20/10/00
Author: Svetlana Chernova
Creation date: 20/10/00

*/
define input parameter x-store-code like ub.clients.obj-code no-undo.
define input parameter x-store-type like ub.clients.obj-type no-undo.
define input parameter x-base-type  like ub.currency.curr-abbr no-undo.
define input parameter x-base-code  like ub.currency.curr-code no-undo.
define input parameter xClassify  as character no-undo.
define input parameter xSortType  as character no-undo.
define input parameter xSumsOnly  as logical  no-undo.
define input parameter xShowZero  as logical  no-undo.
define input parameter xlongName  as logical  no-undo.
define input parameter xPartsDet  as logical  no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Состояние запаса".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i }
{ rep/rep-bt.i }
{ cmp/r-pril.i }
{ rep/r-sym.i }
{ rep/r-gl.i }
{ rep/f-fdec.i }
{ gbl/cur-time.i }
{ gbl/paramls.i  }
{ rep/lkp-font.i }

{ trg/factord.i  }
{ trg/partslib.i }
{ str/prl-vat.i  }
{ trg/partsfnc.i }
{ gbl/alc-lib.i  }

{ str/clcprtsl.i "only-one-parts" }

define buffer goods   for ub.goods  .
define buffer gds-obj for ub.gds-obj  .
define buffer clients for ub.clients  .

define variable num#col# as integer no-undo .
define variable var-1 as integer no-undo .
define variable var-2 as integer no-undo .

define variable  zap-date   as date no-undo.
define variable  tPrintRubl as log no-undo.
define variable time-start as decimal no-undo .

define stream  InStream  .
define stream  OutStream  .
define stream  macr_excel .

define variable v-file-name as character no-undo .
define variable v-ind       as integer   no-undo .

/*общий итог*/

define variable Tot-1 as decimal FORMAT "->>>>>>>>>>9.999" no-undo init 0.
define variable Tot-2 as decimal FORMAT "->>>>>>>>>>9.99" no-undo init 0.
define variable Tot-3 as decimal FORMAT "->>>>>>>>>>9.99" no-undo init 0.
define variable Tot-4 as decimal FORMAT "->>>>>>>>>>9.99" no-undo init 0.
define variable Tot-5 as decimal FORMAT "->>>>>>>>>>9.99" no-undo init 0.

/* итог по объекту*/
define variable oTot-1 as decimal FORMAT "->>>>>>>>>>9.999"  no-undo init 0.
define variable oTot-2 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable oTot-3 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable oTot-4 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable oTot-5 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.

/* итог по группе 1 */
define variable Tot-1-1 as decimal FORMAT "->>>>>>>>>>9.999"  no-undo init 0.
define variable Tot-1-2 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable Tot-1-3 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable Tot-1-4 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable Tot-1-5 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.


/* итог по группе 2 */
define variable Tot-2-1 as decimal FORMAT "->>>>>>>>>>9.999"  no-undo init 0.
define variable Tot-2-2 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable Tot-2-3 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable Tot-2-4 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.
define variable Tot-2-5 as decimal FORMAT "->>>>>>>>>>9.99"  no-undo init 0.

define buffer b-clients for clients .
define buffer buf_parts for ub.parts.
define buffer buf_tt-allsum for tt-allsum.

define variable    ObjName           as char no-undo.
define variable    Select-Good       as   integer no-undo.
define variable    ChosedType        as   integer no-undo.
define variable    PayType           as   integer no-undo.
define variable    RetClassify       as   char no-undo.
define variable    RetSortType       as   char no-undo.
define variable    Show-Negativ      as   logical no-undo.
define variable    Sums-Only         as   logical no-undo.
define variable    ValType           as   integer no-undo.
define variable    Line              as  char     no-undo.
define variable    FirstLine         as  logical  no-undo.
define variable    Parts-Det         as  logical  no-undo.
define variable v-goods-alcohol-prod as  logical  no-undo.

define variable v-show-part-code as character no-undo .

  define variable v-cur-dn  as character no-undo .
  define variable v-price as decimal   no-undo .
  define variable v-cur-rt as decimal   no-undo .
  define variable v-cur-ex as decimal   no-undo .
  define variable v-cur-VAT-pc as decimal   no-undo .
  define variable v-cur-SLT-pc as decimal   no-undo .
  define variable v-cons-vat-pc as decimal   no-undo .

  define variable v-is-part-price as logical   no-undo .


define variable tot_tqnty as decimal  no-undo.

define variable break_group as logical no-undo init true.
define variable break_group1 as logical no-undo init true.

/* Local Variable Definitions ---                                       */

define variable stat     as log no-undo .
define variable InpError as log no-undo .
define variable i        as integer no-undo .
define variable rid-list as character no-undo .

define variable gds-zap-unit-base     like ub.goods.unit-base   no-undo  .
define variable gds-zap-prt-root      like ub.goods.prt-root    no-undo  .
define variable gds-zap-gds-name      like ub.goods.gds-name    no-undo  .
define variable gds-zap-gds-long-name as character format "x(120)" no-undo .
define variable gds-zap-part-b-code   like ub.bar-code.b-code   no-undo  .
define variable gds-zap-prod-type     like ub.goods.prod-type   no-undo  .
define variable gds-zap-prod-code     like ub.goods.prod-code   no-undo  .
define variable gds-zap-artic         like ub.goods.artic       no-undo  .
define variable gds-zap-b-code        like ub.bar-code.b-code   no-undo  .
define variable gds-zap-grp-name      like ub.goods.grp-name    no-undo  .
define variable gds-zap-prod-name     like ub.clients.obj-name  no-undo  .
define variable gds-zap-price-base    like ub.stk-tot.sum-base FORMAT "->>>>>>>>>>9.99" no-undo.
define variable gds-zap-price-nds     like ub.stk-tot.sum-base FORMAT "->>>>>>>>>>9.99" no-undo.
define variable gds-zap-stoim-base    like ub.stk-tot.sum-base FORMAT "->>>>>>>>>>9.99" no-undo.
define variable gds-zap-qnty          like ub.stk-tot.sum-base FORMAT "->>>>>>>>>9.999" no-undo.
define variable gds-zap-Nds           like ub.stk-tot.sum-base FORMAT "->>>>>>>>>>9.99" no-undo.
define variable gds-zap-Np            like ub.stk-tot.sum-base FORMAT "->>>>>>>>>>9.99" no-undo.

/* ************** frame для формы **************** */
DEFINE FRAME zapas
        sym1 column-label ":!:" format "x(1)" space(0)
        gds-zap-b-code column-label  "Код       ! " space(0)
        sym2 column-label ":!:" format "x(1)"                space(0)
        gds-zap-artic column-label "Артикул        ! " format "X(16)" space(0)
        sym3 column-label ":!:" format "x(1)"                         space(0)
        gds-zap-gds-name column-label "Название товара! " format "X(40)" space(0)
        sym4 column-label ":!:" format "x(1)"                                     space(0)
        gds-zap-unit-base column-label "Ед.!изм" format "X(3)"                  space(0)
        sym5 column-label ":!:" format "x(1)"                                     space(0)
        gds-zap-qnty column-label "Количество! " format "->>>>>>9.999"          space(0)
        sym6 column-label ":!:" format "x(1)"                                          space(0)
        gds-zap-price-base column-label "Цена!  " format "->>>>>>>>>>>9.99"            space(0)
        sym7 column-label ":!:" format "x(1)"                                          space(0)
        gds-zap-stoim-base column-label "Сумма! " format "->>>>>>>>>>>>9.99"           space(0)
        sym8 column-label ":!:" format "x(1)"                                          space(0)
        gds-zap-Nds column-label "НДС! " format "->>>>>>>>>>>9.99" space(0)
        sym9 column-label ":!:" format "x(1)"                                             space(0)
        gds-zap-Np column-label "НП! " format "->>>>>>>>>9.99" space(0)
        sym10 column-label ":!:" format "x(1)"                                             space(0)
        gds-zap-price-nds column-label "Цена!без НДС" format "->>>>>>>>>>>9.99"            space(0)
        sym11 column-label ":!:" format "x(1)"                             space(0)
        tot_tqnty column-label "Сумма!без НДС" format "->>>>>>>>>>>9.99"          space(0)


    HEADER
        cur-time-print() AT 5 format "X(35)"
        "Цены указаны в" (if tPrintRubl then "{&abbr_rub_allshift}" else x-base-type )
        string( "Страница " + string( PAGE-NUMBER( OutStream ), ">>>>>9") ) AT 115 format "X(17)" skip
        Line format "X(187)" AT 1
    with width {&DOS_CW_2} down stream-io use-text NO-BOX.

DEFINE FRAME zapas-parts
        sym1 column-label ":!:" format "x(1)" space(0)
        gds-zap-b-code column-label  "Код       ! " space(0)
        sym2 column-label ":!:" format "x(1)"                space(0)
        gds-zap-artic column-label "Артикул        ! " format "X(16)" space(0)
        sym3 column-label ":!:" format "x(1)"                         space(0)
        gds-zap-gds-name column-label "Название товара! " format "X(40)" space(0)
        sym4 column-label ":!:" format "x(1)"                         space(0)
        gds-zap-part-b-code column-label "Бар-код!партии":C9 space(0)
        sym5 column-label ":!:" format "x(1)"                                     space(0)
        gds-zap-unit-base column-label "Ед.!изм" format "X(3)"                  space(0)
        sym6 column-label ":!:" format "x(1)"                                     space(0)
        gds-zap-qnty column-label "Количество! " format "->>>>>>9.999"          space(0)
        sym7 column-label ":!:" format "x(1)"                                          space(0)
        gds-zap-price-base column-label "Цена!  " format "->>>>>>>>>>>9.99"            space(0)
        sym8 column-label ":!:" format "x(1)"                                          space(0)
        gds-zap-stoim-base column-label "Сумма! " format "->>>>>>>>>>>>9.99"           space(0)
        sym9 column-label ":!:" format "x(1)"                                          space(0)
        gds-zap-Nds column-label "НДС! " format "->>>>>>>>>>>9.99" space(0)
        sym10 column-label ":!:" format "x(1)"                                             space(0)
        gds-zap-Np column-label "НП! " format "->>>>>>>>>9.99" space(0)
        sym11 column-label ":!:" format "x(1)"                                             space(0)
        gds-zap-price-nds column-label "Цена!без НДС" format "->>>>>>>>>>>9.99"            space(0)
        sym12 column-label ":!:" format "x(1)"                             space(0)
        tot_tqnty column-label "Сумма!без НДС" format "->>>>>>>>>>>9.99"          space(0)


    HEADER
        cur-time-print() AT 5 format "X(35)"
        "Цены указаны в" (if tPrintRubl then "{&abbr_rub_allshift}" else x-base-type )
        string( "Страница " + string( PAGE-NUMBER( OutStream ), ">>>>>9") ) AT 115 format "X(17)" skip
        Line format "X(197)" AT 1
    with width {&DOS_CW_2} down stream-io use-text NO-BOX.

{ rep/repfrm.i def}
{ rep/repfrm.i on 50 }
/*===================================================================================================================*/
define variable C-c    as integer no-undo .
define variable C-str  as character no-undo .
define variable str--1 as character Format "x(60)" no-undo.
define variable str--2 as integer no-undo .
define variable C-i    as integer no-undo .
define variable p-var  as integer no-undo .


assign
  i=0
  zap-date      = x-Date-Alone
  Select-Good   = x-SelectGood
  PayType       = x-SET_PAY_TYPE
  RetClassify   = xClassify
  RetSortType   = xSortType
  Sums-Only     = xSumsOnly
  Show-Negativ  = xShowZero
  Parts-Det     = xPartsDet
  ValType       = IF (PayType = 1) Then 0  else x-SET_val_TYPE.
  time-start    = time.

define variable v-fact-order-end as decimal   no-undo .
  run day-begin-fact-order in this-procedure ( input ( zap-date + 1 ),   output v-fact-order-end ). /*Поиск посл fact-order*/

  RUN REPORT-EXECUTE.
/*------------------------------------------------------------------------------------------------*/
procedure foreach :
 do
 on error undo, return error return-value
 :

 { rep/repfrm.i disp i  reportname ObjName}
 FIND LAST  ub.stk-line where
                        ub.stk-line.artic      = gds-zap-artic
                  AND   ub.stk-line.fact-date <= zap-date
                  AND   ub.stk-line.obj-code   = x-store-code
                  AND   ub.stk-line.obj-type   = x-store-type
                  AND   ub.stk-line.prod-code  = gds-zap-prod-code
                  AND   ub.stk-line.prod-type  = gds-zap-prod-type
                  AND   ub.stk-line.sum-type   = (IF PayType = 2  then  {&arh-cost} /* учетная */
                                                               else  {&arh-crsa} )
                 AND    ub.stk-line.cat-id       = {&root-cat-id}
                       USE-INDEX category no-lock no-error.
        IF AVAILABLE ub.stk-line Then DO:
            IF  tPrintRubl  THEN
                  ASSIGN gds-zap-qnty       = ub.stk-line.fact-qnty
                        gds-zap-stoim-base  = ub.stk-line.sum-rubl
                        gds-zap-Nds         = ub.stk-line.VAT-rubl
                        gds-zap-Np          = ub.stk-line.SLT-rubl .
              ELSE
                  ASSIGN gds-zap-qnty       =  ub.stk-line.fact-qnty
                        gds-zap-stoim-base  =  ub.stk-line.sum-base
                        gds-zap-Nds         =  ub.stk-line.VAT-base
                        gds-zap-Np          =  ub.stk-line.SLT-base .
             End.
          Else ASSIGN gds-zap-qnty       = 0
                      gds-zap-price-base = 0
                      gds-zap-price-nds = 0
                      gds-zap-stoim-base = 0
                      gds-zap-Nds   = 0
                      gds-zap-Np    = 0.
        Assign
          gds-zap-price-base = if (gds-zap-qnty <> 0) Then round((gds-zap-stoim-base / gds-zap-qnty),2) Else 0
          tot_tqnty          = gds-zap-stoim-base - gds-zap-Nds
          gds-zap-price-nds = if (gds-zap-qnty <> 0) Then round( (tot_tqnty / gds-zap-qnty) , 2) Else 0
          .


 end. /* do */
end procedure. /* foreach */

procedure display-line :
 do
 on error undo, return error return-value
 :
     i = i + 1.
     IF  NOT (NOT Show-Negativ  AND (round(gds-zap-qnty,3) = 0 and round(gds-zap-stoim-base,2) = 0 and round(gds-zap-Nds,2) = 0 )) then DO:
        IF NOT Sums-Only then DO:
          if fr = true then do:
                          if fr0 = true then do:

                              PUT stream  OutStream  tmp#stroka0 format "X(100)" skip .
                              num#str# = num#str# + 1.
                              num#col# = 1.
                              run macr_excel_char_with_format ( String(tmp#stroka0)  , num#str# , num#col#  ) .
                              run macr_cell_format
                              ( 10    ,      /* p-size     */
                                true  ,      /* p-bold     */
                                true  ,      /* p-italic   */
                                33    ,      /* p-color-bg */
                                num#str# ,      /* p-row      */
                                num#col# ,      /* p-col      */
                                num#str# ,   /* p-row-2    */
                                5 ) . /* p-col-2    */

                              fr0 = false .
                           end.
                        PUT stream  OutStream   space(6) tmp#stroka format "X(100)" skip .
                        num#str# = num#str# + 1.
                        num#col# = 2.
                        run macr_excel_char_with_format ( String(tmp#stroka)  , num#str# , num#col#  ) .
                        run macr_cell_format
                          ( 10    ,      /* p-size     */
                            true  ,      /* p-bold     */
                            true  ,      /* p-italic   */
                            36    ,      /* p-color-bg */
                            num#str# ,      /* p-row      */
                            num#col# ,      /* p-col      */
                            num#str# ,   /* p-row-2    */
                            5 ) . /* p-col-2    */

                        fr = false .
          end.
            if not Parts-Det then do :
             DISPLAY stream  OutStream {&all-sym11}
                              gds-zap-b-code
                              gds-zap-artic
                              gds-zap-gds-name
                              gds-zap-unit-base
                              gds-zap-qnty
                              gds-zap-price-base
                              gds-zap-price-nds
                              gds-zap-stoim-base
                              gds-zap-Nds
                              gds-zap-Np
                              tot_tqnty
                              with FRAME  zapas    .
            DOWN stream  OutStream 1 with FRAME zapas    .
            run new-tmp-page .
              num#str# = num#str# + 1.
              num#col# = 1.
                run macr_excel_dec  ( gds-zap-b-code     , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_char ( gds-zap-artic      , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_char ( (if xlongName then gds-zap-gds-long-name else gds-zap-gds-name)   , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_char ( gds-zap-unit-base  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_dec  ( gds-zap-qnty       , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_dec  ( gds-zap-price-base , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_dec  ( gds-zap-stoim-base , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_dec  ( round(gds-zap-Nds,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_dec  ( gds-zap-Np         , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_dec  ( round(gds-zap-price-nds,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                run macr_excel_dec  ( round(tot_tqnty,2)          , num#str# , num#col#   ) .
            end.
            else do :
              DISPLAY stream  OutStream {&all-sym12}
                                gds-zap-b-code
                                gds-zap-artic
                                gds-zap-gds-name
                                ""  @ gds-zap-part-b-code
                                gds-zap-unit-base
                                gds-zap-qnty
                                gds-zap-price-base
                                gds-zap-price-nds
                                gds-zap-stoim-base
                                gds-zap-Nds
                                gds-zap-Np
                                tot_tqnty
                                with FRAME  zapas-parts    .
              DOWN stream  OutStream 1 with FRAME zapas-parts    .
              run new-tmp-page .
                num#str# = num#str# + 1.
                num#col# = 1.
                  run macr_excel_dec  ( gds-zap-b-code     , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_char ( gds-zap-artic      , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_char ( (if xlongName then gds-zap-gds-long-name else gds-zap-gds-name)   , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_char ( ""                 , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_char ( gds-zap-unit-base  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_dec  ( gds-zap-qnty       , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_dec  ( gds-zap-price-base , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_dec  ( gds-zap-stoim-base , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_dec  ( round(gds-zap-Nds,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_dec  ( gds-zap-Np         , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_dec  ( round(gds-zap-price-nds,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                  run macr_excel_dec  ( round(tot_tqnty,2)          , num#str# , num#col#   ) .
              for each temp-parts no-lock :
                  { gbl/gdscdat.i
                    gds-zap-b-code
                    "'alcohol-prod=request':u"
                    v-goods-alcohol-prod
                    no-error
                  }
                  if (v-goods-alcohol-prod = false) and (temp-parts.part-code = '':u)
                  then do:
                    v-show-part-code = '------':u .
                  end.
                  else do:
                    run partsfnc_get-parts-show-code in this-procedure
                      (input  temp-parts.part-code
                      ,input  temp-parts.mark-db-num
                      ,input  temp-parts.mark-code
                      ,input  temp-parts.alc-bottling-date
                      ,input  v-goods-alcohol-prod
                      ,output v-show-part-code
                      ) .
                  end.
                  find first buf_parts where  buf_parts.obj-type   = temp-parts.obj-type   and
                                              buf_parts.obj-code   = temp-parts.obj-code   and
                                              buf_parts.artic      = temp-parts.artic      and
                                              buf_parts.prod-type  = temp-parts.prod-type  and
                                              buf_parts.prod-code  = temp-parts.prod-code  and
                                              buf_parts.in-code    = temp-parts.in-code    /*and
                                              buf_parts.out-code   = temp-parts.out-code   and
                                              buf_parts.part-code  = temp-parts.part-code*/  no-lock no-error.
                  { gbl/partbcod.i
                    buf_parts
                    gds-zap-part-b-code
                    no-error
                  }
                  /*if error-status :error or gds-zap-part-b-code = 0  or gds-zap-part-b-code = ? then do:
                      v-is-part-price = false .
                  end.
                  else do:
                    v-is-part-price = true  .
                  end.
                  if v-is-part-price = true  then do:*/
                      /*{ gbl/bcodeprc.i
                          buf_parts.obj-type
                          buf_parts.obj-code
                          gds-zap-part-b-code
                          0
                          v-fact-order-end
                          v-cur-dn
                          v-price
                          v-cur-rt
                          v-cur-ex
                          no-error
                          }
                      if error-status :error then do:
                        v-price = ? .
                      end.*/
                      { gbl/bcprcex.i
                        buf_parts.obj-type
                        buf_parts.obj-code
                        gds-zap-part-b-code
                        0
                        v-fact-order-end
                        v-cur-dn
                        v-price
                        v-cur-rt
                        v-cur-ex
                        v-cur-VAT-pc
                        v-cur-SLT-pc
                        no-error
                      }
                  /*end.*/
                      { gbl/consvtpc.i
                        buf_parts.host-code
                        v-cons-vat-pc
                      }
                      if v-cons-vat-pc = ? then v-cons-vat-pc = 0.
                  buffer-copy temp-parts to tt-clcparts.
                  run clcprtsl_calc-parts in this-procedure
                    (input recid(tt-clcparts)
                    ,input false /* paris-doc         */
                    ,input true /*(if v-is-part-price = true  then true else false)*/ /* paris-cur         */
                    ,input ?     /* parroad-tax       */
                    ,input ?     /* parexcise         */
                    ,input ?     /* parvat-pc         */
                    ,input ?     /* parcons-vat-pc    */
                    ,input ?     /* parslt-pc         */
                    ,input ?     /* parbase-rate      */
                    ,input ?     /* parbase-scale     */
                    ,input ?     /* parr-b            */
                    ,input v-price /*(if v-is-part-price = true  then v-price else ? )*/     /* parcur-base       */
                    ,input v-cur-rt     /* parcur-road-tax   */
                    ,input v-cur-ex     /* parcur-excise     */
                    ,input v-cur-VAT-pc     /* parcur-vat-pc     */
                    ,input v-cons-vat-pc     /* parcurcons-vat-pc */
                    ,input v-cur-SLT-pc     /* parcurslt-pc      */
                    ) no-error .
                  find first buf_tt-allsum
                       where buf_tt-allsum.sum-type = {&sum-general}
                       no-error .

                  IF PayType = 2 then do :
                    if tPrintRubl then do :
                      DISPLAY stream  OutStream {&all-sym12}
                                        ""
                                        ""
                                        v-show-part-code  @ gds-zap-gds-name
                                        gds-zap-part-b-code
                                        gds-zap-unit-base
                                        buf_tt-allsum.fact-qnty         @  gds-zap-qnty
                                        if buf_tt-allsum.fact-qnty <> 0 then buf_tt-allsum.sum-dsc-rubl-acc / buf_tt-allsum.fact-qnty else 0       @  gds-zap-price-base
                                        if buf_tt-allsum.fact-qnty <> 0 then (buf_tt-allsum.sum-dsc-rubl-acc - buf_tt-allsum.vat-rubl-acc) / buf_tt-allsum.fact-qnty else 0      @  gds-zap-price-nds
                                        buf_tt-allsum.sum-dsc-rubl-acc                @  gds-zap-stoim-base
                                        buf_tt-allsum.vat-rubl-acc             @  gds-zap-Nds
                                        buf_tt-allsum.slt-rubl-acc             @  gds-zap-Np
                                        buf_tt-allsum.sum-dsc-rubl-acc - buf_tt-allsum.vat-rubl-acc @  tot_tqnty
                                        with FRAME  zapas-parts    .
                      DOWN stream  OutStream 1 with FRAME zapas-parts    .
                      run new-tmp-page .
                        num#str# = num#str# + 1.
                        num#col# = 1.
                          run macr_excel_char ( ""                 , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( ""                 , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( v-show-part-code   , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( gds-zap-part-b-code, num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( gds-zap-unit-base  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( buf_tt-allsum.fact-qnty  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.sum-dsc-rubl-acc / buf_tt-allsum.fact-qnty,2) , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( buf_tt-allsum.sum-dsc-rubl-acc , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.vat-rubl-acc,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.slt-rubl-acc,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(((buf_tt-allsum.sum-dsc-rubl-acc - buf_tt-allsum.vat-rubl-acc) / buf_tt-allsum.fact-qnty),2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round((buf_tt-allsum.sum-dsc-rubl-acc - buf_tt-allsum.vat-rubl-acc),2) , num#str# , num#col#   ) .
                    end.  /*   if tPrintRubl   */
                    else do :
                      DISPLAY stream  OutStream {&all-sym12}
                                        ""
                                        ""
                                        v-show-part-code  @ gds-zap-gds-name
                                        gds-zap-part-b-code
                                        gds-zap-unit-base
                                        buf_tt-allsum.fact-qnty         @  gds-zap-qnty
                                        if buf_tt-allsum.fact-qnty <> 0 then buf_tt-allsum.sum-dsc-base-acc / buf_tt-allsum.fact-qnty else 0       @  gds-zap-price-base
                                        if buf_tt-allsum.fact-qnty <> 0 then (buf_tt-allsum.sum-dsc-base-acc - buf_tt-allsum.vat-base-acc) / buf_tt-allsum.fact-qnty else 0      @  gds-zap-price-nds
                                        buf_tt-allsum.sum-dsc-base-acc                @  gds-zap-stoim-base
                                        buf_tt-allsum.vat-base-acc             @  gds-zap-Nds
                                        buf_tt-allsum.slt-base-acc             @  gds-zap-Np
                                        buf_tt-allsum.sum-dsc-base-acc - buf_tt-allsum.vat-base-acc @  tot_tqnty
                                        with FRAME  zapas-parts    .
                      DOWN stream  OutStream 1 with FRAME zapas-parts    .
                      run new-tmp-page .
                        num#str# = num#str# + 1.
                        num#col# = 1.
                          run macr_excel_char ( ""                 , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( ""                 , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( v-show-part-code   , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( gds-zap-part-b-code, num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( gds-zap-unit-base  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( buf_tt-allsum.fact-qnty  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.sum-dsc-base-acc / buf_tt-allsum.fact-qnty,2) , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( buf_tt-allsum.sum-dsc-base-acc , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.vat-base-acc,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.slt-base-acc,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(((buf_tt-allsum.sum-dsc-base-acc - buf_tt-allsum.vat-base-acc) / buf_tt-allsum.fact-qnty),2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round((buf_tt-allsum.sum-dsc-base-acc - buf_tt-allsum.vat-base-acc),2) , num#str# , num#col#   ) .
                    end.
                  end.     /*  if PayType = 2    */
                  else do :
                      DISPLAY stream  OutStream {&all-sym12}
                                        ""
                                        ""
                                        v-show-part-code  @ gds-zap-gds-name
                                        gds-zap-part-b-code
                                        gds-zap-unit-base
                                        buf_tt-allsum.fact-qnty         @  gds-zap-qnty
                                        v-price /*if buf_tt-allsum.fact-qnty <> 0 then buf_tt-allsum.sum-dsc-rubl-cur / buf_tt-allsum.fact-qnty else 0 */      @  gds-zap-price-base
                                        if buf_tt-allsum.fact-qnty <> 0 then (buf_tt-allsum.sum-dsc-rubl-cur - buf_tt-allsum.vat-rubl-cur) / buf_tt-allsum.fact-qnty else 0      @  gds-zap-price-nds
                                        buf_tt-allsum.sum-dsc-rubl-cur                @  gds-zap-stoim-base
                                        buf_tt-allsum.vat-rubl-cur             @  gds-zap-Nds
                                        buf_tt-allsum.slt-rubl-cur             @  gds-zap-Np
                                        buf_tt-allsum.sum-dsc-rubl-cur - buf_tt-allsum.vat-rubl-cur @  tot_tqnty
                                        with FRAME  zapas-parts    .
                      DOWN stream  OutStream 1 with FRAME zapas-parts    .
                      run new-tmp-page .
                        num#str# = num#str# + 1.
                        num#col# = 1.
                          run macr_excel_char ( ""                 , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( ""                 , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( v-show-part-code   , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( gds-zap-part-b-code, num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_char ( gds-zap-unit-base  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( buf_tt-allsum.fact-qnty  , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round((buf_tt-allsum.sum-dsc-rubl-cur / buf_tt-allsum.fact-qnty),2) , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( buf_tt-allsum.sum-dsc-rubl-cur , num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.vat-rubl-cur,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(buf_tt-allsum.slt-rubl-cur,2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round(((buf_tt-allsum.sum-dsc-rubl-cur - buf_tt-allsum.vat-rubl-cur) / buf_tt-allsum.fact-qnty),2), num#str# , num#col#   ) . assign    num#col# = num#col# + 1 .
                          run macr_excel_dec  ( round((buf_tt-allsum.sum-dsc-rubl-cur - buf_tt-allsum.vat-rubl-cur),2) , num#str# , num#col#   ) .
                  end.
              end.  /* for each temp-parts */
            end.
       End.
            Assign
                   TOT-1  = tot-1 + gds-zap-qnty
                   TOT-2  = tot-2 + gds-zap-stoim-base
                   TOT-3  = tot-3 + tot_tqnty
                   TOT-4  = tot-4 + gds-zap-Nds
                   TOT-5  = tot-5 + gds-zap-Np
                   oTOT-1 = otot-1 + gds-zap-qnty
                   oTOT-2 = otot-2 + gds-zap-stoim-base
                   oTOT-3 = otot-3 + tot_tqnty
                   oTOT-4 = otot-4 + gds-zap-Nds
                   oTOT-5 = otot-5 + gds-zap-Np
                   TOT-1-1 = tot-1-1 + gds-zap-qnty
                   TOT-1-2 = tot-1-2 + gds-zap-stoim-base
                   TOT-1-3 = tot-1-3 + tot_tqnty
                   TOT-1-4 = tot-1-4 + gds-zap-Nds
                   TOT-1-5 = tot-1-5 + gds-zap-Np
                   TOT-2-1 = tot-2-1 + gds-zap-qnty
                   TOT-2-2 = tot-2-2 + gds-zap-stoim-base
                   TOT-2-3 = tot-2-3 + tot_tqnty
                   TOT-2-4 = tot-2-4 + gds-zap-Nds
                   TOT-2-5 = tot-2-5 + gds-zap-Np.
      END.


 end. /* do */
end procedure. /* display-line */

procedure print-header :
 do
 on error undo, return error return-value
 :

   PUT stream OutStream  string( v-cntxt-host-name-obj )
       AT 50 format "X(85)" skip (2)
          "С О С Т О Я Н И Е    З А П А С А    на  "
                AT 35  format "X(41)"   zap-date format "99.99.9999" skip (2)
            "ФАКТИЧЕСКОЕ наличие  " + Trim(str3)  AT 35 format "X(75)" skip (1) .


     PUT stream OutStream str2 AT 35 format "x(200)"  skip .
     Repeat i = 1 to NUM-ENTRIES(str4,chr(10)) :
       PUT stream OutStream  Entry(i,str4,chr(10))  AT 1 format "X(170)" skip .
     End.

     Repeat i = 1 to NUM-ENTRIES(ReportHeader,chr(10)) :
       PUT stream OutStream  Entry(i,ReportHeader,chr(10))  AT 1 format "X(170)" skip .
     End.
     i=0.
      FirstLine = TRUE .
    if not Parts-Det then do :
      FORM with FRAME zapas .
      DOWN stream  OutStream 1 with FRAME zapas.
    end.
    else do :
      FORM with FRAME zapas-parts .
      DOWN stream  OutStream 1 with FRAME zapas-parts.
    end.

   Assign
      Tot-1=0
      Tot-2=0
      Tot-3=0
      Tot-4=0
      Tot-5=0
      Tot-1-1=0
      Tot-1-2=0
      Tot-1-3=0
      Tot-1-4=0
      Tot-1-5=0
      Tot-2-1=0
      Tot-2-2=0
      Tot-2-3=0
      Tot-2-4=0
      Tot-2-5=0
      break_group = true
      break_group1 = true.


 end. /* do */
end procedure. /* print-header */

procedure Print-Footer :
 do
 on error undo, return error return-value
 :
 define variable var-1 as integer no-undo .
 define variable var-2 as integer no-undo .
    if not Parts-Det then do :
      DISPLAY stream  OutStream
                      sym1
                    " ИТОГО" @ gds-zap-b-code
                      sym4
                      sym5
                      Tot-1  @ gds-zap-qnty
                      sym6
                      Tot-2  @ gds-zap-stoim-base
                      sym7
                      sym8
                      Tot-4  @ gds-zap-nds
                      sym9
                      Tot-5  @ gds-zap-nP
                      sym10
                      Tot-3  @ tot_tqnty
                      sym11
                      with FRAME zapas.

      DOWN stream  OutStream 1 with FRAME zapas.
    end.
    else do :
      DISPLAY stream  OutStream
                      sym1
                    " ИТОГО" @ gds-zap-b-code
                      sym6
                      Tot-1  @ gds-zap-qnty
                      sym7
                      Tot-2  @ gds-zap-stoim-base
                      sym8
                      sym9
                      Tot-4  @ gds-zap-nds
                      sym10
                      Tot-5  @ gds-zap-nP
                      sym11
                      Tot-3  @ tot_tqnty
                      sym12
                      with FRAME zapas-parts.

      DOWN stream  OutStream 1 with FRAME zapas-parts.
    end.

      assign
       num#str# = num#str# + 1
       num#col# =  1
       var-1 = num#str#
       var-2 = num#col#
       .

       run macr_excel_char_with_format ( "ИТОГО", num#str# , num#col# ). assign   num#col# = (if Parts-Det then (num#col# + 5) else (num#col# + 4)).
       run macr_excel_dec ( Tot-1 , num#str# , num#col# ) . assign   num#col# = num#col# + 2.
       run macr_excel_dec ( Tot-2 , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
       run macr_excel_dec ( round(Tot-4,2) , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
       run macr_excel_dec ( Tot-5 , num#str# , num#col# ) . assign   num#col# = num#col# + 2.
       run macr_excel_dec ( round(Tot-3,2) , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
/* ********* */
       run macr_cell_format
          ( 10    ,      /* p-size     */
            true  ,      /* p-bold     */
            false ,      /* p-italic   */
            ?     ,      /* p-color-bg */
            var-1 ,      /* p-row      */
            var-2 ,      /* p-col      */
            num#str# ,   /* p-row-2    */
            num#col# ) . /* p-col-2    */

      assign
       num#str# = num#str# + 1
       num#col# =  1
       .
      run macr_excel_char_with_format ( "Время формирования отчета " + string( time - time-start ) , num#str# , num#col# ) .

      run u-line.
      put stream  outstream unformatted
        "Итого " tot-1 " единиц , "  " на сумму "    trim( string(tot-2,"->>>>>>>>>>>>9.99"))
        "(" + (if tprintrubl then "{&abbr_rub_allshift}" else x-base-type ) + ")"
        skip
        string("Время формирования отчета ")
        string( time - time-start)
      .


 end. /* do */
end procedure. /* Print-Footer */


procedure Print-Footer-o :
 do
 on error undo, return error return-value
 :

define variable var-1 as integer no-undo .
define variable var-2 as integer no-undo .
      run u-line.
    if not Parts-Det then do :
      DISPLAY stream  OutStream
                      sym1
                    " ИТОГО по" @ gds-zap-b-code
                      sym4
                      objname @ gds-zap-gds-name
                      sym5
                      oTot-1  @ gds-zap-qnty
                      sym6
                      oTot-2  @ gds-zap-stoim-base
                      sym7
                      sym8
                      oTot-4  @ gds-zap-nds
                      sym9
                      oTot-5  @ gds-zap-nP
                      sym10
                      oTot-3  @ tot_tqnty
                      sym11
                      with FRAME zapas.

      DOWN stream  OutStream 1 with FRAME zapas.
    end.
    else do :
      DISPLAY stream  OutStream
                      sym1
                    " ИТОГО по" @ gds-zap-b-code
                      sym4
                      objname @ gds-zap-gds-name
                      sym6
                      oTot-1  @ gds-zap-qnty
                      sym7
                      oTot-2  @ gds-zap-stoim-base
                      sym8
                      sym9
                      oTot-4  @ gds-zap-nds
                      sym10
                      oTot-5  @ gds-zap-nP
                      sym11
                      oTot-3  @ tot_tqnty
                      sym12
                      with FRAME zapas-parts.

      DOWN stream  OutStream 1 with FRAME zapas-parts.
    end.

      assign
       num#str# = num#str# + 1
       num#col# =  1
       var-1 = num#str#
       var-2 = num#col#
       .
       run macr_excel_char_with_format ( "ИТОГО по объекту" + objname  , num#str# , num#col#  ) .
                                                                   assign  num#col# = (if Parts-Det then (num#col# + 5) else (num#col# + 4)).
       run macr_excel_dec ( oTot-1, num#str# , num#col# ) .         assign  num#col# = num#col# + 2.
       run macr_excel_dec ( oTot-2, num#str# , num#col# ) .         assign  num#col# = num#col# + 1.
       run macr_excel_dec ( round(oTot-4,2), num#str# , num#col# ) .         assign  num#col# = num#col# + 1.
       run macr_excel_dec ( oTot-5, num#str# , num#col# ) .         assign  num#col# = num#col# + 2.
       run macr_excel_dec ( round(oTot-3,2), num#str# , num#col# ) .
      run macr_cell_format
          ( 10    ,     /* p-size    */
            true  ,     /*p-bold     */
            false ,     /*p-italic   */
            ?     ,     /*p-color-bg */
            var-1 ,  /*p-row    */
            var-2 ,  /*p-col    */
            num#str# ,         /*p-row-2  */
            num#col#          ) . /*p-col-2 */


   Assign
      oTot-1=0
      oTot-2=0
      oTot-3=0
      oTot-4=0
      oTot-5=0.
   run u-line.
 end. /* do */
end procedure. /* Print-Footer-o */


procedure U-LINE :
 do
 on error undo, return error return-value
 :
  if not Parts-Det then do :
UNDERLINE stream OutStream
        sym1
        gds-zap-b-code
        sym2
        gds-zap-artic
        sym3
        gds-zap-gds-name
        sym4
        gds-zap-unit-base
        sym5
        gds-zap-qnty
        sym6
        gds-zap-price-base
        sym7
        gds-zap-stoim-base
        sym8
        gds-zap-Nds
        sym9
        gds-zap-NP
        sym10
        gds-zap-price-nds
        tot_tqnty
        sym11
        with FRAME zapas .
        DOWN stream  OutStream 1 with FRAME zapas.
  end.
  else do :
    UNDERLINE stream OutStream
        sym1
        gds-zap-b-code
        sym2
        gds-zap-artic
        sym3
        gds-zap-gds-name
        sym4
        gds-zap-part-b-code
        sym5
        gds-zap-unit-base
        sym6
        gds-zap-qnty
        sym7
        gds-zap-price-base
        sym8
        gds-zap-stoim-base
        sym9
        gds-zap-Nds
        sym10
        gds-zap-NP
        sym11
        gds-zap-price-nds
        tot_tqnty
        sym12
        with FRAME zapas-parts .
        DOWN stream  OutStream 1 with FRAME zapas-parts.
  end.

 end. /* do */
end procedure. /* U-LINE */


procedure P-LINE :
 do
 on error undo, return error return-value
 :
  if not Parts-Det then do :
UNDERLINE stream OutStream
        sym3
        gds-zap-gds-name
        sym4
        gds-zap-unit-base
        sym5
        gds-zap-qnty
        sym6
        gds-zap-price-base
        sym7
        gds-zap-stoim-base
        sym8
        gds-zap-Nds
        sym9
        gds-zap-NP
        sym10
        gds-zap-price-nds
        tot_tqnty
        sym11
        with FRAME zapas .
        DOWN stream  OutStream 1 with FRAME zapas.
  end.
  else do :
    UNDERLINE stream OutStream
        sym3
        gds-zap-gds-name
        sym4
        gds-zap-part-b-code
        sym5
        gds-zap-unit-base
        sym6
        gds-zap-qnty
        sym7
        gds-zap-price-base
        sym8
        gds-zap-stoim-base
        sym9
        gds-zap-Nds
        sym10
        gds-zap-NP
        sym11
        gds-zap-price-nds
        tot_tqnty
        sym12
        with FRAME zapas-parts .
        DOWN stream  OutStream 1 with FRAME zapas-parts.
  end.
 end. /* do */
end procedure. /* P-LINE */

procedure Run1 :
 do
 on error undo, return error return-value
 :
  &if '{1}' = '1' &Then
  case RetSortType  :
  when "sort-code":U  then DO:
       CAse Select-Good :
        when {&g-all}   then DO: { rep/run1.i "1" "1" 1 goods goods.gds-code } End.
        when {&g-grp}   then DO: { rep/run2.i "1" "1" 1 goods goods.gds-code} End.
        when {&g-prod}  then DO: { rep/run3.i "1" "1" 1 goods goods.gds-code} End.
        otherwise do:
          { rep/run1.i "1" "1" 1 gds-list gds-list.gds-code}
        end.
        End case.
    End.
   when "sort-artic" then DO:
       CAse Select-Good :
        when {&g-all}   then DO: { rep/run1.i "1" "1" 1 goods goods.artic} End.
        when {&g-grp}   then DO: { rep/run2.i "1" "1" 1 goods goods.artic} End.
        when {&g-prod}  then DO: { rep/run3.i "1" "1" 1 goods goods.artic} End.
        otherwise do:
          { rep/run1.i "1" "1" 1 gds-list gds-list.artic}
        end.
        End case.
    End.
   when "sort-name"  then DO:
       CAse Select-Good :
        when {&g-all}   then DO: { rep/run1.i "1" "1" 1 goods goods.gds-name} End.
        when {&g-grp}   then DO: { rep/run2.i "1" "1" 1 goods goods.gds-name} End.
        when {&g-prod}  then DO: { rep/run3.i "1" "1" 1 goods goods.gds-name} End.
        otherwise do:
          { rep/run1.i "1" "1" 1 gds-list gds-list.gds-name}
        end.
        End case.
    End.
   End case.
    &endif
 end. /* do */
end procedure. /* Run1 */


procedure Run2 :
 do
 on error undo, return error return-value
 :
&if '{1}' = '2' &Then
  case RetSortType :
  when "sort-code":U  then DO:
       CAse Select-Good :
          when {&g-all}   then DO:  { rep/run1.i "1" goods.grp-name 3 goods goods.gds-code }  End.
          when {&g-grp}   then DO:  { rep/run2.i "1" goods.grp-name 3 goods goods.gds-code }  End.
          when {&g-prod}  then DO:  { rep/run3.i "1" goods.grp-name 3 goods goods.gds-code }  End.
          otherwise do:
            { rep/run1.i "1" gds-list.grp-name 3 gds-list gds-list.gds-code }
          end.
       end case.
       End.
 when "sort-artic" then do:
       CAse Select-Good :
          when {&g-all}   then DO:  { rep/run1.i "1" goods.grp-name 3 goods goods.artic }  End.
          when {&g-grp}   then DO:  { rep/run2.i "1" goods.grp-name 3 goods goods.artic }  End.
          when {&g-prod}  then DO:  { rep/run3.i "1" goods.grp-name 3 goods goods.artic }  End.
          otherwise do:
            { rep/run1.i "1" gds-list.grp-name 3 gds-list gds-list.artic }
          end.
       end case.
       End.
 when "sort-name" then do:
       CAse Select-Good :
          when {&g-all}   then DO:  { rep/run1.i "1" goods.grp-name 3 goods goods.gds-name }  End.
          when {&g-grp}   then DO:  { rep/run2.i "1" goods.grp-name 3 goods goods.gds-name }  End.
          when {&g-prod}  then DO:  { rep/run3.i "1" goods.grp-name 3 goods goods.gds-name }  End.
          otherwise do:
            { rep/run1.i "1" gds-list.grp-name 3 gds-list gds-list.gds-name }
          end.
       end case.
       End.
 end case.
 &endif

 end. /* do */
end procedure. /* Run2 */



PROCEDURE Run3 :
 do
 on error undo, return error return-value
 :

&if '{1}' = '3' &Then
  case RetSortType :
  when "sort-code":U  then DO:
      CASE Select-Good :
        when {&g-all}   then DO: { rep/run1.i "1" b-clients.obj-name 2 goods goods.gds-code } End.
        when {&g-grp}   then DO: { rep/run2.i "1" b-clients.obj-name 2 goods goods.gds-code } End.
        when {&g-prod}  then DO: { rep/run3.i "1" b-clients.obj-name 2 goods goods.gds-code } End.
        otherwise do:
          { rep/run1.i "1" b-clients.obj-name 2 gds-list gds-list.gds-code }
        end.
        End case.
       End.
    when "sort-artic" then do:
      CASE Select-Good :
        when {&g-all}   then DO: { rep/run1.i "1" b-clients.obj-name 2 goods "goods.prod-type by  goods.prod-code by goods.artic" } End.
        when {&g-grp}   then DO: { rep/run2.i "1" b-clients.obj-name 2 goods "goods.prod-type by  goods.prod-code by goods.artic" } End.
        when {&g-prod}  then DO: { rep/run3.i "1" b-clients.obj-name 2 goods "goods.prod-type by  goods.prod-code by goods.artic" } End.
        otherwise do:
          { rep/run1.i "1" b-clients.obj-name 2 gds-list "gds-list.prod-type by gds-list.prod-code by gds-list.artic" }
        end.
        End case.
       End.
    when "sort-name" then do:
      CASE Select-Good :
        when {&g-all}   then DO: { rep/run1.i "1" b-clients.obj-name 2 goods goods.gds-name } End.
        when {&g-grp}   then DO: { rep/run2.i "1" b-clients.obj-name 2 goods goods.gds-name } End.
        when {&g-prod}  then DO: { rep/run3.i "1" b-clients.obj-name 2 goods goods.gds-name } End.
         otherwise do:
           { rep/run1.i "1" b-clients.obj-name 2 gds-list gds-list.gds-name }
         end.
        End case.
       End.
   end case.
&endif
 end. /* do */
END PROCEDURE.

&if '{1}' = '4' &Then
PROCEDURE Run4 :
 do
 on error undo, return error return-value
 :

  case RetSortType :
  when "sort-code":U  then DO:
    run run4-sort-code.
   End.
   when "sort-artic"   then do:
     run run4-sort-artic.
    End.
  when "sort-name":U  then DO:
  run run4-sort-name.
   End.
   End case.
 end. /* do */
END PROCEDURE.

procedure  run4-sort-code :
 do
 on error undo, return error return-value
 :
      CASE Select-Good :
         when {&g-all}   then DO: { rep/run1.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" goods.grp-name 4 goods goods.gds-code} End.
         when {&g-grp}   then DO: { rep/run2.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" goods.grp-name 4 goods goods.gds-code} End.
         when {&g-prod}  then DO: { rep/run3.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" goods.grp-name 4 goods goods.gds-code} End.
         otherwise do:
           { rep/run1.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" gds-list.grp-name 4 gds-list gds-list.gds-code}
         end.
      End case.
 end. /* do */
END PROCEDURE.

procedure  run4-sort-artic :
 do
 on error undo, return error return-value
 :
      CASE Select-Good :
         when {&g-all}   then do: { rep/run1.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))"  goods.grp-name 4 goods goods.artic} end.
         when {&g-grp}   then do: { rep/run2.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))"  goods.grp-name 4 goods goods.artic} end.
         when {&g-prod}  then do: { rep/run3.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))"  goods.grp-name 4 goods goods.artic} end.
         otherwise do:
           { rep/run1.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" gds-list.grp-name 4 gds-list gds-list.artic}
         end.
      End case.
 end. /* do */
END PROCEDURE.

procedure  run4-sort-name :
 do
 on error undo, return error return-value
 :

      CASE Select-Good :
         when {&g-all}   then DO: { rep/run1.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" goods.grp-name 4 goods goods.gds-name} End.
         when {&g-grp}   then DO: { rep/run2.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" goods.grp-name 4 goods goods.gds-name} End.
         when {&g-prod}  then DO: { rep/run3.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" goods.grp-name 4 goods goods.gds-name} End.
         otherwise do:
           { rep/run1.i "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" gds-list.grp-name 4 gds-list gds-list.gds-name}
         end.
      End case.
 end. /* do */
END PROCEDURE.
&endif



&if '{1}' = '5' &Then
PROCEDURE Run5 :
 do
 on error undo, return error return-value
 :
  case RetSortType :
  when "sort-code":U  then DO:
    run run5-sort-code.
   End.
   when "sort-artic"   then do:
     run run5-sort-artic.
    End.
  when "sort-name":U  then DO:
  run run5-sort-name.
   End.
   End case.
end. /* do */
END PROCEDURE.

procedure  run5-sort-code :
 do
 on error undo, return error return-value
 :

      case Select-Good:
         when {&g-all}   then DO: { rep/run1.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.gds-code } End.
         when {&g-grp}   then DO: { rep/run2.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.gds-code } End.
         when {&g-prod}  then DO: { rep/run3.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.gds-code } End.
         otherwise do:
           { rep/run1.i gds-list.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 gds-list gds-list.gds-code }
         end.
      End case.
 end. /* do */
END PROCEDURE.

procedure  run5-sort-artic :
 do
 on error undo, return error return-value
 :

      case Select-Good:
         when {&g-all}   then DO: { rep/run1.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.artic } End.
         when {&g-grp}   then DO: { rep/run2.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.artic } End.
         when {&g-prod}  then DO: { rep/run3.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.artic } End.
         otherwise do:
           { rep/run1.i gds-list.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 gds-list gds-list.artic }
         end.
      End case.
 end. /* do */
END PROCEDURE.

procedure  run5-sort-name :
 do
 on error undo, return error return-value
 :

      case Select-Good:
         when {&g-all}   then DO: { rep/run1.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.gds-name } End.
         when {&g-grp}   then DO: { rep/run2.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.gds-name } End.
         when {&g-prod}  then DO: { rep/run3.i goods.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 goods goods.gds-name } End.
         otherwise do:
           { rep/run1.i gds-list.grp-name "(substring(clients.obj-name,1,10) + string(gds-obj.prod-code))" 5 gds-list gds-list.gds-name }
         end.
      End case.
 end. /* do */
END PROCEDURE.
&endif


procedure proc-prt-1 :
 do
 on error undo, return error return-value
 :
run new-tmp-page .
    if not Parts-Det then do :
      DISPLAY stream  OutStream sym11 sym1 sym5 sym6 sym7 sym8 sym9 sym10
              substring(tmp#stroka,1,16)  @  gds-zap-artic
              substring(tmp#stroka,17,60)  @  gds-zap-gds-name
              Tot-1-1     @  gds-zap-qnty
              Tot-1-2     @  gds-zap-stoim-base
              Tot-1-4     @  gds-zap-Nds
              Tot-1-5     @  gds-zap-Np
              Tot-1-3     @  tot_tqnty
              with FRAME  zapas    .
      DOWN stream  OutStream 1 with FRAME zapas    .
    end.
    else do :
      DISPLAY stream  OutStream sym12 sym1 sym6 sym7 sym8 sym9 sym10 sym11
              substring(tmp#stroka,1,16)  @  gds-zap-artic
              substring(tmp#stroka,17,60)  @  gds-zap-gds-name
              Tot-1-1     @  gds-zap-qnty
              Tot-1-2     @  gds-zap-stoim-base
              Tot-1-4     @  gds-zap-Nds
              Tot-1-5     @  gds-zap-Np
              Tot-1-3     @  tot_tqnty
              with FRAME  zapas-parts    .
      DOWN stream  OutStream 1 with FRAME zapas-parts    .
    end.
      assign
        num#str# = num#str# + 1
        num#col# =  1
        var-1 = num#str#
        var-2 = num#col#
      .

      run macr_excel_char ( tmp#stroka, num#str# , num#col# ). assign   num#col# = (if Parts-Det then (num#col# + 5) else (num#col# + 4)).
      run macr_excel_dec ( Tot-1-1 , num#str# , num#col# ) . assign   num#col# = num#col# + 2.
      run macr_excel_dec ( Tot-1-2 , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
      run macr_excel_dec ( Tot-1-4 , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
      run macr_excel_dec ( Tot-1-5 , num#str# , num#col# ) . assign   num#col# = num#col# + 2.
      run macr_excel_dec ( Tot-1-3 , num#str# , num#col# ) . assign   num#col# = num#col# + 1.

      run macr_cell_format
          ( 10    ,      /* p-size     */
            true  ,      /* p-bold     */
            true  ,      /* p-italic   */
            ?     ,      /* p-color-bg */
            var-1 ,      /* p-row      */
            var-2 ,      /* p-col      */
            num#str# ,   /* p-row-2    */
            num#col# ) . /* p-col-2    */

    if not sums-only then run u-line.
    assign break_group = true
      Tot-1-1=0
      Tot-1-2=0
      Tot-1-3=0
      Tot-1-4=0
      Tot-1-5=0 .


 end. /* do */
end procedure. /* proc-prt-1 */



procedure proc-prt-2 :
 do
 on error undo, return error return-value
 :
run new-tmp-page .
if not Parts-Det then do :
DISPLAY stream  OutStream sym11 sym1 sym5 sym6 sym7 sym8 sym9 sym10
          substring(tmp#stroka,1,10)   @  gds-zap-b-code
          substring(tmp#stroka,11,18)  @  gds-zap-artic
          substring(tmp#stroka,29,60)  @  gds-zap-gds-name
          Tot-2-1     @  gds-zap-qnty
          Tot-2-2     @  gds-zap-stoim-base
          Tot-2-4     @  gds-zap-Nds
          Tot-2-5     @  gds-zap-Np
          Tot-2-3     @  tot_tqnty
          with FRAME  zapas    .
DOWN stream  OutStream 1 with FRAME zapas    .
end.
else do :
  DISPLAY stream  OutStream sym12 sym1 sym6 sym7 sym8 sym9 sym10 sym11
            substring(tmp#stroka,1,10)   @  gds-zap-b-code
            substring(tmp#stroka,11,18)  @  gds-zap-artic
            substring(tmp#stroka,29,60)  @  gds-zap-gds-name
            Tot-2-1     @  gds-zap-qnty
            Tot-2-2     @  gds-zap-stoim-base
            Tot-2-4     @  gds-zap-Nds
            Tot-2-5     @  gds-zap-Np
            Tot-2-3     @  tot_tqnty
            with FRAME  zapas-parts    .
  DOWN stream  OutStream 1 with FRAME zapas-parts    .
end.

  assign
  num#str# = num#str# + 1
  num#col# =  1
  var-1 = num#str#
  var-2 = num#col#
  .

  run macr_excel_char ( tmp#stroka, num#str# , num#col# ). assign   num#col# = (if Parts-Det then (num#col# + 5) else (num#col# + 4)).
  run macr_excel_dec ( Tot-2-1 , num#str# , num#col# ) . assign   num#col# = num#col# + 2.
  run macr_excel_dec ( Tot-2-2 , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
  run macr_excel_dec ( Tot-2-4 , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
  run macr_excel_dec ( Tot-2-5 , num#str# , num#col# ) . assign   num#col# = num#col# + 2.
  run macr_excel_dec ( Tot-2-3 , num#str# , num#col# ) . assign   num#col# = num#col# + 1.
  run macr_cell_format
      ( 10    ,      /* p-size     */
        true  ,      /* p-bold     */
        true  ,      /* p-italic   */
        ?     ,      /* p-color-bg */
        var-1 ,      /* p-row      */
        var-2 ,      /* p-col      */
        num#str# ,   /* p-row-2    */
        num#col# ) . /* p-col-2    */


 end. /* do */
end procedure. /* proc-prt-2 */


procedure proc-prt-3 :
 do
 on error undo, return error return-value
 :
  PUT stream  OutStream  tmp#stroka0 format "X(100)" SKIP.
  assign
  num#str# = num#str# + 1
  num#col# =  1
  var-1 = num#str#
  var-2 = num#col#
  .
  run macr_excel_char ( tmp#stroka0, num#str# , num#col# ). assign   num#col# = (if Parts-Det then (num#col# + 5) else (num#col# + 4)).
  run macr_cell_format
  ( 10    ,      /* p-size     */
    true  ,      /* p-bold     */
    true  ,      /* p-italic   */
    40    ,      /* p-color-bg */
    var-1 ,      /* p-row      */
    var-2 ,      /* p-col      */
    num#str# ,   /* p-row-2    */
    num#col# ) . /* p-col-2    */

 end. /* do */
end procedure. /* proc-prt-3 */


procedure new-tmp-page :
 do
 on error undo, return error return-value
 :

    if   num#str#  >= 63000 then do:

        Output stream Macr_Excel  close .
        /*Запишем в файл параметров */
        run paramls-write in this-procedure
          (input "file"
          ,input string(v-ind)
          ,input v-file-name
          ) .
        /* создаем временный файл */
        run gbl/_tmpfile.p ( "wb", ".txt", output v-file-name) .
        output stream  Macr_Excel to value(v-file-name) .
        v-ind = v-ind + 1 .
        num#str# = 0 .
        run proc-print-header-my. /* снова шапку */
    end.

 end. /* do */
end procedure. /* new-tmp-page */


procedure proc-print-header-my :
 do
 on error undo, return error return-value
 :
/* Шапка */
   find first sheetf .
     sheetf.excel-row-heder =  num-entries( c-str ,{&new-line}) + 1.
     sheetf.excel-row-title =  num-entries( sheetf.excel-column-lable , {&new-line} ).
     var-1 =  num#str# .
     repeat c-c = 1 to sheetf.excel-row-title :
     num#str# = num#str# + 1 .

     p-var = num-entries( entry (c-c, sheetf.excel-column-lable, {&new-line}) , {&comma-char} ) .

     do c-i = 1 to p-var :
        str--1 = entry( c-i, entry (c-c,sheetf.excel-column-lable, {&new-line}) , {&comma-char}) .
        str--2 = integer(entry( c-i, sheetf.sizes )) .
        num#col# = c-i .
        run macr_excel_char ( str--1  , num#str# , num#col#  ) .
        run macr_cell_size ( str--2 , ? , num#str# , num#col# , ?, ? ) .
     end.

    c-i = 0.
    end.

    run macr_cell_format (
        10       , /*p-size-font */
        true     , /*p-bold      */
        false    , /*p-italic    */
        35       , /*p-color-bg  */
        var-1 + 1, /*p-row       */
        1        , /*p-col       */
        num#str# , /*p-row-2     */
        num#col# ) /*p-col-2     */
        .
  put  stream macr_excel unformatted
       substitute('select("r&1c&2:r&3c&4 ")' , var-1 + 1 , 1 , num#str# ,  num#col# ) + {&new-line}  +
        'BORDER( 2 , 2 , 2 , 2 , 2 , ,0,0,0,0,0) '  + {&new-line} +
       'ALIGNMENT(3 , , 4 , 4 ,)'  + {&new-line}
       .


 end. /* do */
end procedure. /* proc-print-header-my */

PROCEDURE report-execute :
 do
 on error undo, return error return-value
 :

    { rep/r-val.i }
    /* создаем временный файл */
    run gbl/_tmpfile.p ( "wb", ".txt", output v-file-name) .
    output stream macr_excel to value(v-file-name)   .
    v-ind = 1    .
    num#str# = 0 .

  { cmp/open-out.i stream OutStream  " " ReportPageHeight }
  if not Parts-Det then
  FORM with FRAME zapas .
  else
    FORM with FRAME zapas-parts .
  Line = fill("-", 200).
  if not Parts-Det then do :
  { rep/r-formh.i X(187) {&DOS_cw_2}}
  end.
  else do :
    { rep/r-formh.i X(197) {&DOS_cw_2} "-parts"}
  end.
  /* от куда печатается. */
  FIND First clients where
             x-store-type = clients.obj-type AND
             x-store-code = clients.obj-code no-lock no-error.
    If available clients then  ObjName = clients.obj-name.
                         else  ObjName="объект не определен".

  run print-header .

      num#str# = num#str# + 1 .
      num#col# =  1 .

      run macr_excel_char_with_format ( ReportNAme , num#str# , num#col#  ).
      run macr_cell_format
          ( 12    ,     /* p-size */
            true  ,     /*p-bold   */
            false ,     /*p-italic */
            ?     ,     /*p-color  */
            num#str# ,  /*p-row    */
            num#col# ,  /*p-col    */
            ? ,         /*p-row-2  */
            ?         ) . /*p-col-2 */



define variable l-ii  as integer no-undo .
define variable l-jj  as integer no-undo .
define variable l-len as integer no-undo .
define variable l-m   as integer no-undo .

&scop var-print-n    do l-ii = 1 to num-entries( ~{&var-str-n} , "~{&new-line}"  )    :  ~
      l-len = length (entry( l-ii , ~{&var-str-n}  , "~{&new-line}")) .                 ~
      l-m = integer( l-len / 220 ) + 1 .                                                ~
      do l-jj = 1 to  l-m  :                                                            ~
          num#str# = num#str# + 1 .                                                     ~
          run macr_excel_char_with_format (                                             ~
              substring(entry( l-ii , ~{&var-str-n}  , "~{&new-line}") , (( 220 * l-jj ) - 219 )  , 220 )  , num#str# , num#col# ) .~
      end.                                                                                                       ~
  end.

&scop var-str-n  str1
{&var-print-n }
&scop var-str-n  str2
{&var-print-n }
&scop var-str-n  str3
{&var-print-n }
&scop var-str-n  str4
{&var-print-n }
&scop var-str-n  reportheader
{&var-print-n }


  num#str# = num#str# + 1.
  num#col# = 1.
  run macr_excel_char_with_format ( string(
      cur-time-print()  +
      " Цены указаны в " +
      (if tPrintRubl then "{&abbr_rub_allshift}" else x-base-type )  )
      , num#str#
      , num#col#
        ) .
/*Печать шапки */
   run proc-print-header-my.
   /* проход по списку товаров 1 2 3-№ поиска */
   For each obj-list no-lock :
      x-store-type  =  obj-list.obj-type .
      x-store-code  =  obj-list.obj-code .
      FIND First clients where x-store-type = clients.obj-type AND
                               x-store-code = clients.obj-code no-lock no-error.
        If available clients then  ObjName = clients.obj-name.
                             else  ObjName = "объект не определен".

      PUT stream OutStream  string(  "ПО ОБЬЕКТУ : (" + x-store-type  + string(x-store-code)  +  ") " + ObjName) at 2 format "x(100)" skip .
      assign
       num#str# = num#str# + 1
       num#col# =  1
       .
       run macr_excel_char_with_format ( objname  , num#str# , num#col#  ) .


       case retclassify :
          when "no-classify":u  then do:
            run run1.
            end.
          when "grp-goods":u then do:
            run run2.
            end.
          when "prod":u then do:
            run run3.
            end.
          when "prod/grp-goods":u then do:
           &if '{1}' = '4' &then run run4. &endif
            end.
          when "grp-goods/prod":u then do:
           &if '{1}' = '5' &then run run5.  &endif
            end.
      end case.
      run print-footer-o.
  end.

  if not Parts-Det then
  HIDE stream OutStream FRAME BottomFrame .
  else
    HIDE stream OutStream FRAME BottomFrame-parts .
  run print-footer.

  if not Parts-Det then
  HIDE STREAM   OutStream   FRAME ZAPAS .
  else
    HIDE STREAM   OutStream   FRAME ZAPAS-parts .
  Output stream OutStream   close .
  Output stream InStream   close .
  Output stream Macr_Excel  close .
  { rep/repfrm.i off}
    run paramls-write in this-procedure
      (input "file"
      ,input string(v-ind)
      ,input v-file-name
      ) .

    run paramls-write in this-procedure
        (input "charcol"
        ,input ""
        ,input "2,3,4"
        ) .

  run end-proc .
  define variable v-user-action as character no-undo .
  define variable v-printed as logical   no-undo .
  define variable DisabledOptions as integer   no-undo .
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
    ,input  DisabledOptions
    ,input  string(session :temp-directory) + {&DF_Name} + string( g#report-num )
    ,input ReportFontNum
    ,output v-user-action
    ,output v-printed
    ) .
 end. /* do */
END PROCEDURE.

{ rep/r-libmcr.i macr_excel         }