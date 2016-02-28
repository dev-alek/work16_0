/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Выгрузка на кассу XML

Автор: Бахтадзе Наталья Викторовна
Дата создания: 08/18/03
Author: Bakhtadze Natalya
Creation date: 08/18/03

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

define variable i-entry as integer no-undo .
define buffer buf_cash-gds for cash-gds.
define buffer buf_goods-attr for ub.goods-attr.

&if "{1}" <> "7" &then
if action = 'U':U then do:
  run bgelib-tag-open in this-procedure ( input 2, input "Producer", input substitute("ctrl='&1' tms='&2' code='&3'", 'ADD':u, OS2-time, cash-gds.producer-int)).
  run bgelib-tag-put in this-procedure ( input 3, input "ProducerName"  , input trim(cash-gds.producer), input 1 ).
  run bgelib-tag-close in this-procedure ( input 2, input "Producer").
end.
&endif

&if "{&called}" = "in-ov" &then
  if action = "D":U then do:
    run bgelib-tag-open in this-procedure ( input 2, input "Item", input substitute("ctrl='&1' tms='&2' code='&3'", 'LOCK':u, OS2-time, cash-gds.main-prt-b-code)).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemLock"  , input string(1), input 1 ).
  end.
  else do:
    run bgelib-tag-open in this-procedure ( input 2, input "Item", input substitute("ctrl='&1' tms='&2' code='&3'", 'ADD':u, OS2-time, cash-gds.main-prt-b-code)).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemLock"  , input string(1), input 1 ).
  end.
&else

/*если удаляется prod-bc то Item удалять не надо
если удаляется bar-code то  Item удалять надо!!
*/
  &if "{&called}"  =  "s-prodbc" or "{&called}" = "s-prodbcn"  or "{&called}"  =  "send-bc" or "{&called}" = "send-bcn" &then

  run bgelib-tag-open in this-procedure ( input 2, input "Item", input substitute("ctrl='&1' tms='&2' code='&3'"
                                        ,"ADD":U, OS2-time, cash-gds.main-prt-b-code)).
  &else
  run bgelib-tag-open in this-procedure ( input 2, input "Item", input substitute("ctrl='&1' tms='&2' code='&3'",
                                        (if
                                        action = "U"
                                        then "ADD":U
                                        else "DEL":U), OS2-time, cash-gds.main-prt-b-code)).
  &endif
&endif
&if "{1}" <> "7" &then
if action = "U":U then do:
  run bgelib-tag-put in this-procedure ( input 3, input "ItemName"       , input trim(chk_name, {&space-char}), input 1 ).
  run bgelib-tag-put in this-procedure ( input 3, input "ItemAltName"    , input trim(second-name, {&double-quote}), input 1 ).
  run bgelib-tag-put in this-procedure ( input 3, input "ItemMainPrice"  , input string( cash-gds.price-sale ), input 1 ).
  run bgelib-tag-put in this-procedure ( input 3, input "ItemMasterCode"  , input string( cash-gds.gds-code), input 1 ).
  run bgelib-tag-put in this-procedure ( input 3, input "ItemDisc"  , input string( std-disc-dec), input 1 ).
  run bgelib-tag-put in this-procedure ( input 3, input "ItemDiscReason"  , input string( std-disc-reason), input 1 ).
  if pos-type <> {&cd-type-infokiosk} then do:
    run bgelib-tag-put in this-procedure ( input 3, input "ItemOKEI"          , input string( cash-gds.okei), input 1 ).
  end.
  run bgelib-tag-put in this-procedure ( input 3, input "ItemMeasure"      , input string( cash-gds.unit-cli), input 1 ).


  define buffer bb_goods for ub.goods.
  define variable vVal as character no-undo .
  define variable vType as character no-undo .
  if pos-type = {&cd-type-infokiosk} then do:
    find first bb_goods no-lock where bb_goods.gds-code = cash-gds.gds-code.
 	find FIRST buf_goods-attr where buf_goods-attr.gds-code = cash-gds.gds-code and buf_goods-attr.attr-code = "image-list".
 	vVal = entry(1,buf_goods-attr.attr-value).    
    run bgelib-tag-put in this-procedure ( input 3, input "ItemNameLong"  , input string( bb_goods.gds-name ), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemDetails"    , input string( bb_goods.Ps ), input 1 ).

    run bgelib-tag-put in this-procedure ( input 3, input "ItemPhoto"    , input string( entry(1,vVal)), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemGroupBO"  , input string( bb_goods.grp-code ), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemSizeColorCode" , input string( cash-gds.node-code), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemAttributes" , input string( bb_goods.attrib), input 1 ).

    run bgelib-tag-put in this-procedure ( input 3, input "ItemDestination" , input string( bb_goods.destin), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemSert" , input string( bb_goods.sert), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemDeadLine" , input string( bb_goods.deadline), input 1 ).

    run bgelib-tag-put in this-procedure ( input 3, input "ItemUserRules" , input string( bb_goods.user-rule), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemStructure" , input string( bb_goods.struct), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemSort" , input string( bb_goods.sort), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemUnitWeight" , input string( bb_goods.wt-cart), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemUnitVolume" , input string( bb_goods.ms-cart), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemCountry" , input string( cash-gds.alpha1), input 1 ).
  end.
  else do: /*не инфокиоск*/


    run bgelib-tag-put in this-procedure ( input 3, input "ItemGroup"      , input string( cash-gds.grp-code ), input 1 ).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemShop"      , input string( i-obj-code ), input 1 ).

    /*статус*/
    run bgelib-tag-open in this-procedure ( input 3, input "ItemStatus", input "" ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISWeight" ,
                                          input string(if LOOKUP( {&weight}, cash-gds.unit-cli-type  ) > 0
                                                       or LOOKUP( {&divisional}, cash-gds.unit-cli-type  ) > 0
                                                       then 1 else 0), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISFuel" ,
                                          input string(if (LOOKUP({&petrolium}, cash-gds.unit-cli-type) > 0
                                                        and LOOKUP({&divisional}, cash-gds.unit-cli-type) > 0)
                                                        or cash-gds.pp > 0
                                                        then 1
                                                        else 0), input 1 ).
    /*run bgelib-tag-put in this-procedure ( input 4, input "ISAuthorize" ,
                                          input string(cash-gds.pp), input 1 ).*/
    run bgelib-tag-put in this-procedure ( input 4, input "ISAuthorize" ,
                                          input string(cash-gds.need-auth), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISFreePrice" ,
                                            input string(if cash-gds.fp then 1 else 0), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISNullPrice" ,
                                            string(cash-gds.zp), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISNoTotalDisc" ,
                                          input string(if cash-gds.wd > 0 then wd-option else 0), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISService" ,
                                          input string(cash-gds.office), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISComplex" ,
                                          input string(0), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISActivate" ,
                                          input (if cash-gds.office-type = {&attr-office-type_card-act} then string(1) else string(0)), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISNoDiscount" ,
                                            input string(if cash-gds.wgd > 0 then wgd-option else 0), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISGaz" ,
                                            input string(if cash-gds.is-gas then 1 else 0), input 1 ).
    run bgelib-tag-put in this-procedure ( input 4, input "ISFuelAsUnit" ,
                                            input string(if cash-gds.ptrl-as-good then 1 else 0), input 1 ).
    run bgelib-tag-close in this-procedure ( input 3, input "ItemStatus").

  end. /*не инфокиоск*/

  /*ночная скидка*/
  if cash-gds.temp-discnt-rule <> 0 then do:
    find first cash-dis-rule no-lock where
              cash-dis-rule.rule-num = cash-gds.temp-discnt-rule no-error .
    if available cash-dis-rule then do:
      for each buf_cash-dis-rule no-lock where
              (cash-dis-rule.is-term = yes
              and buf_cash-dis-rule.rule-num = cash-gds.temp-discnt-rule)
            or
            buf_cash-dis-rule.upper-rule-num = cash-gds.temp-discnt-rule,
        first cash-dis-time-rule no-lock where
                  cash-dis-time-rule.time-rule-num = buf_cash-dis-rule.time-rule-num:
        if buf_cash-dis-rule.is-term
        and buf_cash-dis-rule.root then do:
          /*ничего не находим все уже получили ранее в  p u t c - g d s .i */
        end.
        else do:
          case buf_cash-dis-rule.value-type:
            when integer({&discnt-v-pcnt}) then do:
        assign
        temp-disc-dec = - buf_cash-dis-rule.discnt-value
              .
            end.
            when integer({&discnt-v-pdf-pcnt}) then do:
              find first cash-gds-discnt where
                        cash-gds-discnt.b-code = cash-gds.b-code
                    and  cash-gds-discnt.rule-num = buf_cash-dis-rule.rule-num
                    and cash-gds-discnt.obj-type = {&shop}
                    and cash-gds-discnt.obj-code = i-obj-code
                    no-error.
              if available cash-gds-discnt then do:
                assign
                temp-disc-dec = - (cash-gds.price-sale - cash-gds-discnt.discnt-value) /  cash-gds.price-sale * 100
                .
              end.
              else do:
                assign
                temp-disc-dec = 0.
              end.
            end.
            otherwise do:
              temp-disc-dec = 0.
            end.
          end case.
        end.
        assign
        temp-disc-reason = 0
        temp-disc-weekday = 0
        no-error
        .
        assign
        temp-disc-start = cash-dis-time-rule.date-from
        temp-disc-end   = cash-dis-time-rule.date-to
        temp-disc-time-start = (if cash-dis-time-rule.time-from >= 0 then cash-dis-time-rule.time-from else 0)
        temp-disc-time-end = (if cash-dis-time-rule.time-to >= 0 then cash-dis-time-rule.time-to else 0)
        temp-disc-weekday = (if cash-dis-time-rule.week-day-1 then 1 else 0) +
                            (if cash-dis-time-rule.week-day-2 then 2 else 0) +
                            (if cash-dis-time-rule.week-day-3 then 3 else 0) +
                            (if cash-dis-time-rule.week-day-4 then 4 else 0) +
                            (if cash-dis-time-rule.week-day-5 then 5 else 0) +
                            (if cash-dis-time-rule.week-day-6 then 6 else 0) +
                            (if cash-dis-time-rule.week-day-7 then 7 else 0)
        .
        if temp-disc-end <> 12/31/1989 and temp-disc-end < today then
        assign
        temp-disc-dec = 0
        temp-disc-reason = 0
        temp-disc-weekday = 0
        temp-disc-time-start = 0
        temp-disc-time-end = 0
        temp-disc-start = 12/31/1989
        temp-disc-end = {&end-of-age}
        .
        run bgelib-tag-open in this-procedure ( input 3, input "ItemTimeDisc", input "" ).
        run bgelib-tag-put in this-procedure ( input 4, input "ITDEvery"     , input string(temp-disc-weekday), input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "ITDValue" , input string(temp-disc-dec), input 1 ).
        if temp-disc-start <> ? then
        run bgelib-tag-put in this-procedure ( input 4, input "ITDBeg" , input Xml-CD-DateTimetoString(temp-disc-start, temp-disc-time-start), input 1 ).
        if temp-disc-end <> ? then
        run bgelib-tag-put in this-procedure ( input 4, input "ITDEnd" , input Xml-CD-DateTimetoString(temp-disc-end, temp-disc-time-end), input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "ITDReason" , input string(temp-disc-reason), input 1 ).
        run bgelib-tag-close in this-procedure ( input 3, input "ItemTimeDisc").
      end. /*for each buf_cash-dis-rule no-lock where*/
    end. /*avail cash-dis-rule*/
  end. /*if cash-gds.temp-discnt-rule <> 0 then do:*/
  else do:
      run bgelib-tag-open in this-procedure ( input 3, input "ItemTimeDisc", input "" ).
      run bgelib-tag-close in this-procedure ( input 3, input "ItemTimeDisc").
  end.

  &endif

  /*скидки на колво*/
  if cash-gds.qnty-discnt-rule <> 0 then do:
    for each cash-dis-rule no-lock where
            cash-dis-rule.upper-rule-num = cash-gds.qnty-discnt-rule
      :
      run bgelib-tag-open in this-procedure ( input 3, input "ItemQtyDisc", input "" ).
      run bgelib-tag-put in this-procedure ( input 4, input "IQty", input string(cash-dis-rule.doc-qnty / cash-gds.cli-base-rate), input 1 ).
      run bgelib-tag-put in this-procedure ( input 4, input "IQPercent" , input string(- cash-dis-rule.discnt-value),  input 1 ).
      if v-version-dec >= 1.09 then do:
          run bgelib-tag-put in this-procedure ( input 4, input "IQType"
                                              , input string(if cash-dis-rule.value-type = integer({&discnt-v-abs})
                                                              then 1
                                                              else 0)
                                                , input 1 ).
          run bgelib-tag-put in this-procedure ( input 4, input "IQPayRestriction"
                                               , input string(if cash-dis-rule.templ-rl-root = 73
                                                              or cash-dis-rule.templ-rl-root = 74
                                                              then cash-dis-rule.key#_one
                                                              else 0
                                                              ),  input 1 ).
      end.
      run bgelib-tag-close in this-procedure ( input 3, input "ItemQtyDisc").
    end.
  end.
  else do:
    run bgelib-tag-open in this-procedure ( input 3, input "ItemQtyDisc", input "" ).
    run bgelib-tag-close in this-procedure ( input 3, input "ItemQtyDisc").
  end.


  /*кат скидок*/

  if cash-gds.kat-discnt-rule <> 0  then do:
    for each cash-dis-rule no-lock where
            cash-dis-rule.upper-rule-num = cash-gds.kat-discnt-rule   :
      run bgelib-tag-open in this-procedure ( input 3, input "ItemDisCat", input "" ).
      run bgelib-tag-put in this-procedure ( input 4, input "IDCCat" ,  input string(cash-dis-rule.dis-kat), input 1 ).
      if cash-dis-rule.templ-rl-root = 34 then do:
        /*используется поправочный коэффициент и предел скидки*/
        run bgelib-tag-put in this-procedure ( input 4, input "IDCMode" , input string(5), input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "IDCLimit", input string(- cash-dis-rule.discnt-value),  input 1 ).
        run bgelib-tag-put in this-procedure ( input 4, input "IDCFactor", input string(cash-dis-rule.tot-sum),  input 1 ).
      end.
      else do:
        /*используется abd или % скидки*/
        case cash-dis-rule.value-type:
          when integer({&discnt-v-abs}) then do:
            run bgelib-tag-put in this-procedure ( input 4, input "IDCMode" , input string(2), input 1 ).
            run bgelib-tag-put in this-procedure ( input 4, input "IDCValue", input string(- cash-dis-rule.discnt-value * cash-gds.cli-base-rate),  input 1 ).
          end.
          when integer({&discnt-v-pcnt}) then do:
            run bgelib-tag-put in this-procedure ( input 4, input "IDCMode" , input string(1), input 1 ).
            run bgelib-tag-put in this-procedure ( input 4, input "IDCPercent", input string(- cash-dis-rule.discnt-value),  input 1 ).
          end.
          when integer({&discnt-v-FP}) then do:
            run bgelib-tag-put in this-procedure ( input 4, input "IDCMode" , input string(3), input 1 ).
            run bgelib-tag-put in this-procedure ( input 4, input "IDCPrice", input string(cash-dis-rule.discnt-value),  input 1 ).
          end.
          when integer({&discnt-v-pdf-FP}) then do:
            find first cash-gds-discnt where
                      cash-gds-discnt.b-code = cash-gds.b-code
                  and  cash-gds-discnt.rule-num = cash-dis-rule.rule-num
                and cash-gds-discnt.obj-type = {&shop}
                and cash-gds-discnt.obj-code = i-obj-code
                  no-error.
            if available cash-gds-discnt then do:
              assign
              v-kat-discnt = cash-gds-discnt.discnt-value
              .
            end.
            else do:
              v-kat-discnt = cash-gds.price-sale.
            end.
            run bgelib-tag-put in this-procedure ( input 4, input "IDCMode" , input string(3), input 1 ).
            run bgelib-tag-put in this-procedure ( input 4, input "IDCPrice", input string(v-kat-discnt),  input 1 ).
          end.
        end case.
      end.
      run bgelib-tag-close in this-procedure ( input 3, input "ItemDisCat").
    end. /*for each cash-dis-rule no-lock where*/
  end.
  else do:
    run bgelib-tag-open in this-procedure ( input 3, input "ItemDisCat", input "" ).
    run bgelib-tag-close in this-procedure ( input 3, input "ItemDisCat").
  end.



if pos-type <> {&cd-type-infokiosk} then do:
    &if "{1}" <> "7" &then
      if tax-cass
      AND action = "U" then do:
        do i-entry = 1 to num-entries(cash-gds.tax-string, {&space-char}):
          if entry(i-entry, cash-gds.tax-string, {&space-char}) <> "":U then do:
            run bgelib-tag-open in this-procedure ( input 3, input "ItemTax", input "" ).
            run bgelib-tag-put in this-procedure ( input 4, input "ITCode"  , input entry(i-entry, cash-gds.tax-string, {&space-char}), input 1 ).
            run bgelib-tag-close in this-procedure ( input 3, input "ItemTax").
          end.
        end.
      end.
    end.
    &endif
end.

run bgelib-tag-close in this-procedure ( input 2, input "Item").


&if "{&called}" = "in-ov" &then
  if action = "U":U then do:
    run bgelib-tag-open in this-procedure ( input 2, input "Item", input substitute("ctrl='&1' tms='&2' code='&3'", 'FREE':u, OS2-time, cash-gds.main-prt-b-code)).
    run bgelib-tag-put in this-procedure ( input 3, input "ItemLock"  , input string(0), input 1 ).
    run bgelib-tag-close in this-procedure ( input 2, input "Item").
  end.
  if action = "D":U then return.
&endif

&if "{1}" <> "7" &then

&scop output-phrase  ~
    run bgelib-tag-open in this-procedure ( input 2, input "ItemBarCode", input substitute("ctrl='&1' tms='&2' code='&3'" ~
                                          , (if action = "U" ~
                                             then "ADD":U    ~
                                             else "DEL":U)   ~
                                          , OS2-time         ~
                                          , ~{&output-code~})).                                              ~
    run bgelib-tag-put in this-procedure ( input 3, input "IBCCode"                                          ~
                                          , input cash-gds.main-prt-b-code                                            ~
                                          , input 1 ).                                                       ~
    if action = 'U':U then do:                                                                               ~
      run bgelib-tag-put in this-procedure ( input 3, input "IBCProducer"                                      ~
                                          , input string(cash-gds.producer-int), input 1 ).                   ~
      run bgelib-tag-put in this-procedure ( input 3, input "IBCIngredient"                                    ~
                                          , input trim(string( cash-gds.ingredient, "X(40)")), input 1 ).     ~
      if cash-gds.gtd <> "":U then                                                                             ~
      run bgelib-tag-put in this-procedure ( input 3, input "IBCGTD"                                           ~
                                          , input trim(string( cash-gds.gtd, "X(40)")), input 1 ).            ~
      find first ub.country no-lock where ub.country.alpha1 = cash-gds.alpha1 no-error.                              ~
      if available ub.country then                                                                                ~
      run bgelib-tag-put in this-procedure ( input 3, input "IBCCountry"                                       ~
                                          , input ub.country.short-name, input 1 ).                              ~
      run bgelib-tag-put in this-procedure ( input 3, input "IBCPrice"                                         ~
                                          , input string( cash-gds.price-sale ), input 1 ).                   ~
    end.                                                                                                      ~
    run bgelib-tag-close in this-procedure ( input 2, input "ItemBarCode")


&scop output-code                                 (if buf_cash-gds.b-str <> "":U ~
                                                  then ( if  buf_cash-gds.unit-cli = buf_cash-gds.unit-base  ~
                                                         AND  (LOOKUP( ~{&weight~}, buf_cash-gds.unit-type ) > 0  ~
                                                         or buf_cash-gds.bc-on-type = ~{&loc-pg-code~}) ~
                                                         then (if buf_cash-gds.b-str begins "*" then left-trim(buf_cash-gds.b-str, "*") ~
                                                                                                else left-trim(buf_cash-gds.b-str, "0") ~
                                                              ) ~
                                                         else (if buf_cash-gds.b-str begins "*" then left-trim(buf_cash-gds.b-str, "*") ~
                                                                                                else buf_cash-gds.b-str ~
                                                              ) ~
                                                       ) ~
                                                  else string(buf_cash-gds.b-code))
for each buf_cash-gds no-lock where
&if "{&called}" <> "send-bc" and "{&called}" <> "send-bcn" and "{&called}" <> "s-prodbc" and "{&called}" <> "s-prodbcn" &then
          buf_cash-gds.main-prt-b-code = cash-gds.main-prt-b-code
      AND buf_cash-gds.obj-type = {&shop}
      AND buf_cash-gds.obj-code = abs(i-obj-code)
          :
&else
          buf_cash-gds.b-code = cash-gds.b-code
      AND buf_cash-gds.obj-type = {&shop}
      AND buf_cash-gds.obj-code = abs(i-obj-code)
          :
&endif
   if LOOKUP( {&weight}, cash-gds.unit-cli-type ) > 0 and buf_cash-gds.b-str = "" and ub.shop.cd-sc-base  then NEXT.
   if (ub.shop.cd-loc-base = no and buf_cash-gds.is-main-code = yes) then next.
  {&output-phrase}.

&if "{&called}" <> "send-bc" and "{&called}" <> "send-bcn" and "{&called}" <> "s-prodbc" and "{&called}" <> "s-prodbcn" &then
if buf_cash-gds.b-str = ""
and buf_cash-gds.ean-rz <> buf_cash-gds.ean-lz
AND buf_cash-gds.ean-lz <> "":U
then do:
&scop output-code   trim(buf_cash-gds.ean-lz, ~{&space-char~} )
   {&output-phrase}.
end.
&endif
end.

&if "{&called}" <> "send-bc" and "{&called}" <> "send-bcn" and "{&called}" <> "s-prodbc" and "{&called}" <> "s-prodbcn" &then
&else
if cash-gds.b-str = ""
and IBM-good-code-2 <> IBM-good-code
AND IBM-good-code <> "":U
then do:
&scop output-code   trim(IBM-good-code, ~{&space-char~} )
   {&output-phrase}.
end.
&endif
&endif

/* $Workfile$ e n d */