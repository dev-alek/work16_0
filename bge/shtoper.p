/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт XML смены

Автор: Хныкин Павел Андреевич
Дата создания: 10/24/05
Author: Pavel Khnykin
Creation date: 10/24/05

Input:

Output:

*/

define input parameter p-host-code          as character        no-undo.
define input parameter p-obj-type           as character        no-undo.
define input parameter p-obj-code           as integer          no-undo.
define input parameter p-shift-date         as date             no-undo.
define input parameter p-shift-num          as integer          no-undo.
define input parameter p-xml-file-name      as character        no-undo.
define input parameter p-log-file-name      as character        no-undo.
define input parameter p-bge-editor-handle  as handle           no-undo.
define input parameter p-bge-fillin-handle  as handle           no-undo.



define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экспорт XML смены".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ bge/bge-xml.i  }
{ gbl/clntattr.i }
{ str/wth-lib.i  }
{ str/lib-trn.i  }

    define temp-table temp_payDeskZOrder no-undo
        field pay-desk as integer
        field z-number as integer
        field sum      as decimal

        index pi is primary unique
            pay-desk
            z-number
    .
    define temp-table temp_sumWthInkasToBank no-undo
        field wth-code  as integer
        field wth-name  as character
        field fact-sum  as decimal

        index pi is primary unique
            wth-code
    .
    define temp-table temp_sumWthInternal no-undo
        field wth-code  as integer
        field wth-name  as character
        field fact-sum  as decimal

        index pi is primary unique
            wth-code
    .
    define temp-table temp_stkWthInPlace no-undo
        field w-p-code    as integer
        field wth-code    as integer
        field w-p-name    as character
        field wth-name    as character
        field stock-start as decimal
        field stock-end   as decimal

        index pi is primary unique
            w-p-code
            wth-code
    .
    define temp-table temp_techPro no-undo
        field artic      as character
        field prod-type  as character
        field prod-code  as integer
        field gds-code   as integer
        field gds-name   as character
        field envd       as logical
        field fact-qnty  as decimal

        index pi is primary unique
            artic
            prod-type
            prod-code
    .
    define temp-table temp_stkShiftEnd no-undo
        field gds-code   as integer
        field artic      as character
        field prod-type  as character
        field prod-code  as integer
        field gds-name   as character
        field envd       as logical
        field qnty       as decimal
        field cli-qnty   as decimal

        index pi is primary unique
            gds-code
    .
    define temp-table temp_stkPlShiftEnd no-undo
        field gds-code   as integer
        field pl-code   as integer
        field qnty       as decimal
        field cli-qnty   as decimal
        field state-density  as decimal
        field state-add-quantity as decimal

        index pi is primary unique
            gds-code
            pl-code
    .
    define temp-table temp_stkTrkShiftEnd no-undo
        field pump-code as integer
        field nozzle-code as integer
            field pl-code   as integer
        field gds-code as integer
        field state-mh-cnt as decimal

        index pi is primary unique
            pump-code
            nozzle-code
            pl-code
        index igds
            gds-code
    .


    define temp-table temp_stkTNP no-undo
        field artic         as character
        field prod-type     as character
        field prod-code     as integer
        field gds-code      as integer
        field gds-name      as character
        field envd          as logical
        field end-sumSale   as decimal
        field end-sumVat    as decimal
        field start-sumSale as decimal
        field start-sumVat  as decimal

        index pi is primary unique
            artic
            prod-type
            prod-code
    .
    define temp-table temp_sumPriceSale no-undo
        field artic         as character
        field prod-type     as character
        field prod-code     as integer
        field gds-code      as integer
        field gds-name      as character
        field envd          as logical
        field sumSale       as decimal
        field sumVat        as decimal

        index pi is primary unique
            artic
            prod-type
            prod-code
    .
do
on error undo, return error
:
    output stream stmXMLOut to value( p-xml-file-name + "xm1" ) convert target "1251" append.
    run export-shift in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "основных данных смены"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-shift-staff in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "списка операторов"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-pay-desk-z-order in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "сумм z-отчётов"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-sum-wth in this-procedure (
          input p-host-code
        , input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "инкассированных и взятых для внутренних нужд средств"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-stk-wth-in-place in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "остатков в кассах"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-techPro in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "технологической прокачки"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-stkShiftEnd in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "остатков топлива"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-stkTNP in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "товарных остатков ТНП"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    run export-price-sum in this-procedure (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
    ) no-error.
    if error-status :error
    then do:
        run wp-XMLWriteLog in this-procedure (
              input p-log-file-name
            , input 1
            , input substitute( "&1. Ошибка выгрузки &2. &3. &4. &5."
                                    , vss-description
                                    , "сумм переоценок за смену"
                                    , return-value
                                    , trim(error-status :get-message(1))
                                    , trim(error-status :get-message(2))
                            )
        ).
    end.
    output stream stmxmlout close.
end.


/*==========================================================================*/
procedure export-shift :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define buffer buf_shift-obj     for ub.shift-obj.
    define buffer buf_clients       for ub.clients.
do
for buf_shift-obj
  , buf_clients
on error undo, return error
:
    find first buf_shift-obj no-lock
         where buf_shift-obj.obj-type   = p-obj-type
           and buf_shift-obj.obj-code   = p-obj-code
           and buf_shift-obj.shift-date = p-shift-date
           and buf_shift-obj.shift-num  = p-shift-num
    .
    find first buf_clients no-lock
         where buf_clients.obj-type = p-obj-type
           and buf_clients.obj-code = p-obj-code
    .
    run wp-xmltagopen( input 2, input "shift", input "" ).
    run wp-xmltagput( input 3, "objType"    , input string( buf_shift-obj.obj-type                  ), input 0 ).
    run wp-xmltagput( input 3, "objCode"    , input string( buf_shift-obj.obj-code                  ), input 0 ).
    run wp-xmltagput( input 3, "objName"    , input string( buf_clients.obj-name                    ), input 0 ).
    run wp-xmltagput( input 3, "shiftDate"  , input string( buf_shift-obj.shift-date, "99.99.9999"  ), input 0 ).
    run wp-xmltagput( input 3, "shiftNum"   , input string( buf_shift-obj.shift-num                 ), input 0 ).
    run wp-xmltagput( input 3, "shiftName"  , input string( buf_shift-obj.shift-name                ), input 0 ).
    run wp-xmltagclose( input 2, input "shift" ).
end.
end procedure. /* export-shift */


/*==========================================================================*/
procedure export-shift-staff :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define buffer buf_shift-staff       for ub.shift-staff.
do
for buf_shift-staff
on error undo, return error
:
    for each buf_shift-staff no-lock
       where buf_shift-staff.obj-type   = p-obj-type
         and buf_shift-staff.obj-code   = p-obj-code
         and buf_shift-staff.shift-date = p-shift-date
         and buf_shift-staff.shift-num  = p-shift-num
         and buf_shift-staff.next-shift = no
         and buf_shift-staff.psn-num   >= 0
    by buf_shift-staff.staff-role descending
    on error undo, return error
    :
        run wp-xmltagopen( input 2, input "shiftStaff", input "" ).
        run wp-xmltagput( input 3, "objType"    , input string( buf_shift-staff.obj-type                  ), input 0 ).
        run wp-xmltagput( input 3, "objCode"    , input string( buf_shift-staff.obj-code                  ), input 0 ).
        run wp-xmltagput( input 3, "shiftDate"  , input string( buf_shift-staff.shift-date, "99.99.9999"  ), input 0 ).
        run wp-xmltagput( input 3, "shiftNum"   , input string( buf_shift-staff.shift-num                 ), input 0 ).
        run wp-xmltagput( input 3, "stfPsnCode" , input string( buf_shift-staff.psn-code                  ), input 0 ).
        run wp-xmltagput( input 3, "stfName"    , input string( buf_shift-staff.name                      ), input 0 ).
        run wp-xmltagput( input 3, "stfCashier" , input string( ( buf_shift-staff.cashier <> 0 )          ), input 2 ).
        run wp-xmltagclose( input 2, input "shiftStaff" ).
    end.        /* for each buf_shift-staff */
end.
end procedure. /* export-shift-staff */


/*==========================================================================*/
procedure export-pay-desk-z-order :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define buffer buf_chk-doc       for ub.chk-doc.
do
for buf_chk-doc
on error undo, return error
:
    empty temp-table temp_payDeskZOrder.
    for each buf_chk-doc no-lock
       where buf_chk-doc.obj-type   = p-obj-type
         and buf_chk-doc.obj-code   = p-obj-code
         and buf_chk-doc.shift-date = p-shift-date
         and buf_chk-doc.shift-num  = p-shift-num
    :
        if lookup(string(buf_chk-doc.chk-type), {&no-sale-receipt-codes}) > 0 then next.
        /*только за вычето таких чеков имеет смысл сичтать*/
        find first temp_payDeskZOrder
             where temp_payDeskZOrder.pay-desk = buf_chk-doc.pay-desk
               and temp_payDeskZOrder.z-number = buf_chk-doc.z-number
        no-error.
        if not available temp_payDeskZOrder
        then do:
            create temp_payDeskZOrder.
            assign
                temp_payDeskZOrder.pay-desk = buf_chk-doc.pay-desk
                temp_payDeskZOrder.z-number = buf_chk-doc.z-number
            .
        end.
        assign
            temp_payDeskZOrder.sum = temp_payDeskZOrder.sum + buf_chk-doc.netto
        .
    end.
    for each temp_payDeskZOrder
    :
        if temp_payDeskZOrder.sum <> 0
        then do:
            run wp-xmltagopen( input 2, input "shiftPayDeskZOrder", input "" ).
            run wp-xmltagput( input 3, "objType"    , input string( p-obj-type                  ), input 0 ).
            run wp-xmltagput( input 3, "objCode"    , input string( p-obj-code                  ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"  , input string( p-shift-date, "99.99.9999"  ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"   , input string( p-shift-num                 ), input 0 ).
            run wp-xmltagput( input 3, "pdzPayDesk" , input string( temp_payDeskZOrder.pay-desk ), input 0 ).
            run wp-xmltagput( input 3, "pdzZOrder"  , input string( temp_payDeskZOrder.z-number ), input 0 ).
            run wp-xmltagput( input 3, "pdzSum"     , input string( temp_payDeskZOrder.sum      ), input 0 ).
            run wp-xmltagclose( input 3, input "shiftPayDeskZOrder").
        end.
    end.
end.
end procedure. /* export-pay-desk-z-order */


/*==========================================================================*/
procedure export-sum-wth :
define input parameter p-host-code  as integer          no-undo.
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define variable v-is-inkassator     as character    no-undo.
    define variable v-attr-type         as character    no-undo.
    define variable v-sale-type         as character    no-undo.
    define variable v-sale-code         as integer      no-undo.

    define buffer buf_clients               for ub.clients.
    define buffer buf_wth-doc               for ub.wth-doc.
    define buffer buf_wth-line              for ub.wth-line.
    define buffer buf_wealth                for ub.wealth.
    define buffer buf_sysconf               for ub.sysconf.
    define buffer buf_temp_sumWthInkasToBank   for temp_sumWthInkasToBank.
    define buffer buf_temp_sumWthInternal      for temp_sumWthInternal.
do
for buf_clients
  , buf_wth-doc
  , buf_wth-line
  , buf_wealth
  , buf_temp_sumWthInkasToBank
  , buf_temp_sumWthInternal
on error undo, return error
:
    empty temp-table buf_temp_sumWthInkasToBank.
    empty temp-table buf_temp_sumWthInternal.
    find first buf_sysconf no-lock
         where buf_sysconf.host-code = p-host-code
    no-error.
    if available buf_sysconf
    then do:
        assign
            v-sale-type = buf_sysconf.sale-type
            v-sale-code = buf_sysconf.sale-code
        .
    end.
    else do:
        assign
            v-sale-type = "":U
            v-sale-code = 0
        .
    end.
    see-all-clients:
    for each buf_clients no-lock
    on error undo, return error
    :
        if buf_clients.obj-type  = v-sale-type
        and buf_clients.obj-code = v-sale-code
        then do:
            undo see-all-clients, next see-all-clients.
        end.
        run clntattr-value in this-procedure (
              input buf_clients.obj-type
            , input buf_clients.obj-code
            , input {&attr-is-inkassator}
            , output v-is-inkassator
            , output v-attr-type
        ).
        if v-is-inkassator = "yes":U
        then do:
            if buf_clients.obj-type = {&cmp}
            then do:
                for each buf_wth-doc no-lock
                   where buf_wth-doc.obj-type   = p-obj-type
                     and buf_wth-doc.obj-code   = p-obj-code
                     and buf_wth-doc.shift-date = p-shift-date
                     and buf_wth-doc.shift-num  = p-shift-num
                     and buf_wth-doc.status_    = {&fact}
                     and buf_wth-doc.doc-type   = {&expense}
                use-index sht-clos
                on error undo, return error
                :
                    if  buf_wth-doc.cli-type   = buf_clients.obj-type
                    and buf_wth-doc.cli-code   = buf_clients.obj-code
                    then do:
                        for each buf_wth-line no-lock
                           where buf_wth-line.doc-code = buf_wth-doc.doc-code
                        on error undo, return error
                        :
                            if buf_wth-line.status_ = {&fact}
                            then do:
                                find first buf_temp_sumWthInkasToBank
                                     where buf_temp_sumWthInkasToBank.wth-code = buf_wth-line.wth-code
                                no-error.
                                if not available buf_temp_sumWthInkasToBank
                                then do:
                                    create buf_temp_sumWthInkasToBank.
                                    assign
                                        buf_temp_sumWthInkasToBank.wth-code = buf_wth-line.wth-code
                                    .
                                    find first buf_wealth no-lock
                                         where buf_wealth.wth-code = buf_wth-line.wth-code
                                    no-error.
                                    if available buf_wealth
                                    then do:
                                        assign
                                            buf_temp_sumWthInkasToBank.wth-name = buf_wealth.wth-name
                                        .
                                    end.
                                end.
                                assign
                                    buf_temp_sumWthInkasToBank.fact-sum = buf_temp_sumWthInkasToBank.fact-sum + buf_wth-line.fact-sum
                                .
                            end.
                        end.        /* for each buf_wth-line */
                    end.
                end.        /* for each buf_wth-doc */
            end.        /* buf_clients.obj-type = {&cmp} */
        end.        /* if v-is-inkassator = "yes":U */
        else do:
            if buf_clients.host-code <> p-host-code
            and ( buf_clients.obj-type <> p-obj-type
               or buf_clients.obj-code <> p-obj-code )
            then do:
                for each buf_wth-doc no-lock
                   where buf_wth-doc.obj-type   = p-obj-type
                     and buf_wth-doc.obj-code   = p-obj-code
                     and buf_wth-doc.shift-date = p-shift-date
                     and buf_wth-doc.shift-num  = p-shift-num
                     and buf_wth-doc.status_    = {&fact}
                     and buf_wth-doc.doc-type   = {&expense}
                use-index sht-clos
                on error undo, return error
                :
                    if  buf_wth-doc.cli-type   = buf_clients.obj-type
                    and buf_wth-doc.cli-code   = buf_clients.obj-code
                    then do:
                        for each buf_wth-line no-lock
                           where buf_wth-line.doc-code = buf_wth-doc.doc-code
                        on error undo, return error
                        :
                            if buf_wth-line.status_ = {&fact}
                            then do:
                                find first buf_temp_sumWthInternal
                                     where buf_temp_sumWthInternal.wth-code = buf_wth-line.wth-code
                                no-error.
                                if not available buf_temp_sumWthInternal
                                then do:
                                    create buf_temp_sumWthInternal.
                                    assign
                                        buf_temp_sumWthInternal.wth-code = buf_wth-line.wth-code
                                    .
                                    find first buf_wealth no-lock
                                         where buf_wealth.wth-code = buf_wth-line.wth-code
                                    no-error.
                                    if available buf_wealth
                                    then do:
                                        assign
                                            buf_temp_sumWthInternal.wth-name = buf_wealth.wth-name
                                        .
                                    end.
                                end.
                                assign
                                    buf_temp_sumWthInternal.fact-sum = buf_temp_sumWthInternal.fact-sum + buf_wth-line.fact-sum
                                .
                            end.
                        end.        /* for each buf_wth-line */
                    end.
                end.        /* for each buf_wth-doc */
            end.
        end.        /* if NOT ( v-is-inkassator = "yes":U ) */
    end.        /* for each buf_clients */
    for each buf_temp_sumWthInkasToBank
    :
        if buf_temp_sumWthInkasToBank.fact-sum <> 0
        then do:
            run wp-xmltagopen( input 2, input "sumWthInkasToBank", input "" ).
            run wp-xmltagput( input 3, "objType"    , input string( p-obj-type                          ), input 0 ).
            run wp-xmltagput( input 3, "objCode"    , input string( p-obj-code                          ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"  , input string( p-shift-date, "99.99.9999"          ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"   , input string( p-shift-num                         ), input 0 ).
            run wp-xmltagput( input 3, "itbWthCode" , input string( buf_temp_sumWthInkasToBank.wth-code  ), input 0 ).
            run wp-xmltagput( input 3, "itbWthName" , input string( buf_temp_sumWthInkasToBank.wth-name  ), input 0 ).
            run wp-xmltagput( input 3, "itbWthSum"  , input string( buf_temp_sumWthInkasToBank.fact-sum  ), input 0 ).
            run wp-xmltagclose( input 3, input "sumWthInkasToBank").
        end.
    end.
    for each buf_temp_sumWthInternal
    :
        if buf_temp_sumWthInternal.fact-sum <> 0
        then do:
            run wp-xmltagopen( input 2, input "sumWthInternal", input "" ).
            run wp-xmltagput( input 3, "objType"    , input string( p-obj-type                          ), input 0 ).
            run wp-xmltagput( input 3, "objCode"    , input string( p-obj-code                          ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"  , input string( p-shift-date, "99.99.9999"          ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"   , input string( p-shift-num                         ), input 0 ).
            run wp-xmltagput( input 3, "inWthCode"  , input string( buf_temp_sumWthInternal.wth-code       ), input 0 ).
            run wp-xmltagput( input 3, "inWthName"  , input string( buf_temp_sumWthInternal.wth-name       ), input 0 ).
            run wp-xmltagput( input 3, "inWthSum"   , input string( buf_temp_sumWthInternal.fact-sum      ), input 0 ).
            run wp-xmltagclose( input 3, input "sumWthInternal").
        end.
    end.
end.
end procedure. /* export-sumWthInkasToBank */


/*==========================================================================*/
procedure export-stk-wth-in-place :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define variable v-stock-start     as decimal      no-undo.
    define variable v-stock-end       as decimal      no-undo.
    define variable v-income          as decimal      no-undo.
    define variable v-income-cassa    as decimal      no-undo.
    define variable v-income-other    as decimal      no-undo.
    define variable v-incass          as decimal      no-undo.
    define variable v-incass-bank     as decimal      no-undo.
    define variable v-incass-other    as decimal      no-undo.
    define variable v-incass-cassa    as decimal      no-undo.

    define buffer buf_wth-place             for ub.wth-place.
    define buffer buf_wth-pobj              for ub.wth-pobj.
    define buffer buf_wealth                for ub.wealth.
    define buffer buf_temp_stkWthInPlace    for temp_stkWthInPlace.
do
for buf_wth-place
  , buf_wth-pobj
  , buf_wealth
  , buf_temp_stkWthInPlace
on error undo, return error
:
    empty temp-table buf_temp_stkWthInPlace.
    for each buf_wth-place no-lock
       where buf_wth-place.obj-type     = p-obj-type
         and buf_wth-place.obj-code     = p-obj-code
         and buf_wth-place.cash-desk    <> ?
    :
        for each buf_wth-pobj no-lock
           where buf_wth-pobj.obj-type  = p-obj-type
             and buf_wth-pobj.obj-code  = p-obj-code
             and buf_wth-pobj.w-p-code  = buf_wth-place.w-p-code
        on error undo, return error
        :
            run wth-lib_full-inf-shift-place in this-procedure (
                  input p-obj-type
                , input p-obj-code
                , input buf_wth-pobj.wth-code
                , input buf_wth-pobj.w-p-code
                , input p-shift-date
                , input p-shift-num
                , output v-stock-start
                , output v-stock-end
                , output v-income
                , output v-income-cassa
                , output v-income-other
                , output v-incass
                , output v-incass-bank
                , output v-incass-other
                , output v-incass-cassa
            ).
            find first buf_temp_stkWthInPlace
                 where buf_temp_stkWthInPlace.w-p-code = buf_wth-pobj.w-p-code
                   and buf_temp_stkWthInPlace.wth-code = buf_wth-pobj.wth-code
            no-error.
            if not available buf_temp_stkWthInPlace
            then do:
                create buf_temp_stkWthInPlace.
                assign
                    buf_temp_stkWthInPlace.w-p-code     = buf_wth-pobj.w-p-code
                    buf_temp_stkWthInPlace.wth-code     = buf_wth-pobj.wth-code
                    buf_temp_stkWthInPlace.w-p-name     = buf_wth-place.w-p-name
                    buf_temp_stkWthInPlace.stock-start  = v-stock-start
                    buf_temp_stkWthInPlace.stock-end    = v-stock-end
                .
                find first buf_wealth no-lock
                     where buf_wealth.wth-code = buf_wth-pobj.wth-code
                no-error.
                if available buf_wealth
                then do:
                    assign
                        buf_temp_stkWthInPlace.wth-name = buf_wealth.wth-name
                    .
                end.
            end.
        end.        /* for each buf_wth-pobj */
    end.
    for each buf_temp_stkWthInPlace
    :
        if buf_temp_stkWthInPlace.stock-start <> 0
        or buf_temp_stkWthInPlace.stock-end <> 0
        then do:
            run wp-xmltagopen( input 2, input "stkWthInPlace", input "" ).
            run wp-xmltagput( input 3, "objType"        , input string( p-obj-type                            ), input 0 ).
            run wp-xmltagput( input 3, "objCode"        , input string( p-obj-code                            ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"      , input string( p-shift-date, "99.99.9999"            ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"       , input string( p-shift-num                           ), input 0 ).
            run wp-xmltagput( input 3, "swpWPCode"      , input string( buf_temp_stkWthInPlace.w-p-code       ), input 0 ).
            run wp-xmltagput( input 3, "swpWthCode"     , input string( buf_temp_stkWthInPlace.wth-code       ), input 0 ).
            run wp-xmltagput( input 3, "swpWPName"      , input string( buf_temp_stkWthInPlace.w-p-name       ), input 0 ).
            run wp-xmltagput( input 3, "swpWthName"     , input string( buf_temp_stkWthInPlace.wth-name       ), input 0 ).
            run wp-xmltagput( input 3, "swpStockStart"  , input string( buf_temp_stkWthInPlace.stock-start    ), input 0 ).
            run wp-xmltagput( input 3, "swpStockEnd"    , input string( buf_temp_stkWthInPlace.stock-end      ), input 0 ).
            run wp-xmltagclose( input 3, input "stkWthInPlace").
        end.
    end.
end.
end procedure. /* export-stk-wth-in-place */


/*==========================================================================*/
procedure export-techPro :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define variable v-shftrep2      as character    no-undo.
    define variable v-attr-value    as character    no-undo.
    define variable v-attr-type     as character    no-undo.

    define buffer buf_clients       for ub.clients.
    define buffer buf_trn-doc       for ub.trn-doc.
    define buffer buf_doc-line      for ub.doc-line.
    define buffer buf_goods         for ub.goods.
    define buffer buf_temp_techPro  for temp_techPro.
do
for buf_clients
  , buf_trn-doc
  , buf_doc-line
  , buf_goods
  , buf_temp_techPro
on error undo, return error
:
    empty temp-table buf_temp_techPro.

    for each buf_clients no-lock
    on error undo, return error
    :
        run clntattr-value in this-procedure ( input buf_clients.obj-type
                                             , input buf_clients.obj-code
                                             , input {&attr-shftrep2}
                                             , output v-shftrep2
                                             , output v-attr-type
                                             ).
        if v-shftrep2 = "yes":U
        then do:
            sum-all-trn-doc-tech-pro:
            for each buf_trn-doc no-lock
               where buf_trn-doc.obj-type   = p-obj-type
                 and buf_trn-doc.obj-code   = p-obj-code
                 and buf_trn-doc.shift-date = p-shift-date
                 and buf_trn-doc.shift-num  = p-shift-num
                 and buf_trn-doc.status_    = {&fact}
            on error undo, return error
            :
                if  buf_trn-doc.cli-type = buf_clients.obj-type   and
                    buf_trn-doc.cli-code = buf_clients.obj-code   and
                    buf_trn-doc.ext-doc-type = {&TDEDT_Spi_Vnesh}
                then do:
                    if not can-find(first ub.sale-doc where ub.sale-doc.doc-code = buf_trn-doc.doc-code and ub.sale-doc.doc-kind = {&sale-add-tech-refuell})
                    then do:
                      /* это не техпролив */
                      undo sum-all-trn-doc-tech-pro, next sum-all-trn-doc-tech-pro.
                    end.
                    for each buf_doc-line no-lock
                       where buf_doc-line.doc-code = buf_trn-doc.doc-code
                    on error undo, return error
                    :
                        find first buf_temp_techPro
                             where buf_temp_techPro.artic       = buf_doc-line.artic
                               and buf_temp_techPro.prod-type   = buf_doc-line.prod-type
                               and buf_temp_techPro.prod-code   = buf_doc-line.prod-code
                        no-error.
                        if not available buf_temp_techPro
                        then do:
                            create buf_temp_techPro.
                            assign
                                buf_temp_techPro.artic       = buf_doc-line.artic
                                buf_temp_techPro.prod-type   = buf_doc-line.prod-type
                                buf_temp_techPro.prod-code   = buf_doc-line.prod-code
                            .
                            find first buf_goods no-lock
                                 where buf_goods.artic     = buf_temp_techPro.artic
                                   and buf_goods.prod-type = buf_temp_techPro.prod-type
                                   and buf_goods.prod-code = buf_temp_techPro.prod-code
                            no-error.
                            if available buf_goods
                            then do:
                                assign
                                    buf_temp_techPro.gds-code = buf_goods.gds-code
                                    buf_temp_techPro.gds-name = buf_goods.gds-name
                                .
                                run get-goods-envd in this-procedure (
                                      input p-obj-type
                                    , input p-obj-code
                                    , input buf_goods.gds-code
                                    , output buf_temp_techPro.envd
                                ).
                            end.
                        end.
                        assign
                            buf_temp_techPro.fact-qnty = buf_temp_techPro.fact-qnty + buf_doc-line.fact-qnty
                        .
                    end.        /* for each buf_doc-line */
                end.
            end.        /* for each buf_trn-doc */
        end.        /* if v-shftrep2 = "yes":U */
    end.        /* for each buf_clients */
    for each buf_temp_techPro
    :
        if buf_temp_techPro.fact-qnty <> 0
        then do:
            run wp-xmltagopen( input 2, input "techPro", input "" ).
            run wp-xmltagput( input 3, "objType"    , input string( p-obj-type                   ), input 0 ).
            run wp-xmltagput( input 3, "objCode"    , input string( p-obj-code                   ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"  , input string( p-shift-date, "99.99.9999"   ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"   , input string( p-shift-num                  ), input 0 ).
            run wp-xmltagput( input 3, "tprArtic"   , input string( buf_temp_techPro.artic       ), input 0 ).
            run wp-xmltagput( input 3, "tprProdType", input string( buf_temp_techPro.prod-type   ), input 0 ).
            run wp-xmltagput( input 3, "tprProdCode", input string( buf_temp_techPro.prod-code   ), input 0 ).
            run wp-xmltagput( input 3, "tprGdsCode" , input string( buf_temp_techPro.gds-code    ), input 0 ).
            run wp-xmltagput( input 3, "tprGdsName" , input string( buf_temp_techPro.gds-name    ), input 0 ).
            run wp-xmltagput( input 3, "tprGdsENVD" , input string( buf_temp_techPro.envd        ), input 3 ).
            run wp-xmltagput( input 3, "tprFactQnty", input string( buf_temp_techPro.fact-qnty   ), input 0 ).
            run wp-xmltagclose( input 3, input "techPro").
        end.
    end.
end.
end procedure. /* export-techPro */



/*==========================================================================*/
procedure export-stkShiftEnd :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define buffer buf_rvs-doc           for ub.rvs-doc.
    define buffer buf_rvs-line          for ub.rvs-line.
    define buffer buf_rvs-line-pump     for ub.rvs-line-pump.
    define buffer buf_goods             for ub.goods.
    define buffer buf_temp_stkShiftEnd  for temp_stkShiftEnd.
    define buffer buf_temp_stkPlShiftEnd  for temp_stkPlShiftEnd.
    define buffer buf_temp_stkTRKShiftEnd  for temp_stkTRKShiftEnd.
do
for buf_rvs-doc
  , buf_rvs-line
  , buf_goods
  , buf_temp_stkShiftEnd
  , buf_temp_stkPlShiftEnd
  , buf_temp_stkTRKShiftEnd
on error undo, return error
:
    empty temp-table buf_temp_stkShiftEnd.
    empty temp-table buf_temp_stkPlShiftEnd.
    empty temp-table buf_temp_stkTRKShiftEnd.

    find first buf_rvs-doc no-lock
         where buf_rvs-doc.obj-type     = p-obj-type
           and buf_rvs-doc.obj-code     = p-obj-code
           and buf_rvs-doc.shift-date   = p-shift-date
           and buf_rvs-doc.shift-num    = p-shift-num
           and buf_rvs-doc.status_      = {&fact}
           and buf_rvs-doc.rvs-type     = {&rvs-shift}
    use-index shift
    no-error.
    if available buf_rvs-doc
    then do:
        for each buf_rvs-line no-lock
           where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
             and buf_rvs-line.obj-type = p-obj-type
             and buf_rvs-line.obj-code = p-obj-code
        on error undo, return error
        :
            find first buf_temp_stkShiftEnd
                 where buf_temp_stkShiftEnd.gds-code = buf_rvs-line.gds-code
            no-error.
            if not available buf_temp_stkShiftEnd
            then do:
                create buf_temp_stkShiftEnd.
                assign
                    buf_temp_stkShiftEnd.gds-code = buf_rvs-line.gds-code
                .
                find first buf_goods no-lock
                     where buf_goods.gds-code = buf_rvs-line.gds-code
                no-error.
                if available buf_goods
                then do:
                    assign
                        buf_temp_stkShiftEnd.artic     = buf_goods.artic
                        buf_temp_stkShiftEnd.prod-type = buf_goods.prod-type
                        buf_temp_stkShiftEnd.prod-code = buf_goods.prod-code
                        buf_temp_stkShiftEnd.gds-name  = buf_goods.gds-name
                        buf_temp_stkShiftEnd.qnty      = 0.0
                        buf_temp_stkShiftEnd.cli-qnty  = 0.0
                    .
                    run get-goods-envd in this-procedure (
                          input p-obj-type
                        , input p-obj-code
                        , input buf_goods.gds-code
                        , output buf_temp_stkShiftEnd.envd
                    ).
                end.
            end.
            assign
                buf_temp_stkShiftEnd.qnty = buf_temp_stkShiftEnd.qnty + buf_rvs-line.state-measure-qnty
                buf_temp_stkShiftEnd.cli-qnty = buf_temp_stkShiftEnd.cli-qnty + buf_rvs-line.state-measure-cli-qnty
            .
            find first buf_temp_stkPlShiftEnd
                 where buf_temp_stkPlShiftEnd.gds-code = buf_rvs-line.gds-code
                   and buf_temp_stkPlShiftEnd.pl-code = buf_rvs-line.pl-code
            no-error.
            if not available buf_temp_stkPlShiftEnd
            then do:
                create buf_temp_stkPlShiftEnd.
                assign
                buf_temp_stkPlShiftEnd.gds-code = buf_rvs-line.gds-code
                buf_temp_stkPlShiftEnd.pl-code = buf_rvs-line.pl-code
                .
                find first buf_goods no-lock
                     where buf_goods.gds-code = buf_rvs-line.gds-code
                no-error.
                if available buf_goods
                then do:
                  assign
                  buf_temp_stkPlShiftEnd.qnty      = buf_rvs-line.state-measure-qnty
                  buf_temp_stkPlShiftEnd.cli-qnty  = buf_rvs-line.state-measure-cli-qnty
                  buf_temp_stkPlShiftEnd.state-density  = buf_rvs-line.state-density
                  .
                end. /*if available buf_goods*/
            end. /*if not available buf_temp_stkPlShiftEnd*/
        end.        /* for each buf_rvs-line */
        for each buf_rvs-line-pump no-lock where
              buf_rvs-line-pump.rvs-code = buf_rvs-doc.rvs-code
          and buf_rvs-line-pump.obj-type = p-obj-type
          and buf_rvs-line-pump.obj-code = p-obj-code
          break
        by buf_rvs-line-pump.pump-code
        by buf_rvs-line-pump.nozzle-code
        on error undo, return error:
          if first-of(buf_rvs-line-pump.nozzle-code) then do:
            find first buf_temp_stkTrkShiftEnd where
                   buf_temp_stkTrkShiftEnd.pump-code = buf_rvs-line-pump.pump-code
                and buf_temp_stkTrkShiftEnd.nozzle-code = buf_rvs-line-pump.nozzle-code 
                and buf_temp_stkTrkShiftEnd.pl-code = buf_rvs-line-pump.pl-code
                no-error.
            if not available buf_temp_stkTrkShiftEnd then do:
              create buf_temp_stkTrkShiftEnd.
              assign
              buf_temp_stkTrkShiftEnd.pump-code = buf_rvs-line-pump.pump-code
              buf_temp_stkTrkShiftEnd.nozzle-code = buf_rvs-line-pump.nozzle-code
              buf_temp_stkTrkShiftEnd.gds-code = buf_rvs-line-pump.gds-code
               buf_temp_stkTrkShiftEnd.pl-code = buf_rvs-line-pump.pl-code
              buf_temp_stkTrkShiftEnd.state-mh-cnt = buf_rvs-line-pump.state-mh-cnt
              .
    end.
          end. /*if first-of(buf_rvs-line-pump.nozzle-code) then do:*/
        end. /*        for each buf_rvs-line-pump no-lock where*/
    end. /*if available buf_rvs-doc*/
    for each buf_temp_stkShiftEnd
    :
            run wp-xmltagopen( input 2, input "stkShiftEnd", input "" ).
            run wp-xmltagput( input 3, "objType"    , input string( p-obj-type                      ), input 0 ).
            run wp-xmltagput( input 3, "objCode"    , input string( p-obj-code                      ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"  , input string( p-shift-date, "99.99.9999"      ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"   , input string( p-shift-num                     ), input 0 ).
            run wp-xmltagput( input 3, "sseArtic"   , input string( buf_temp_stkShiftEnd.artic      ), input 0 ).
            run wp-xmltagput( input 3, "sseProdType", input string( buf_temp_stkShiftEnd.prod-type  ), input 0 ).
            run wp-xmltagput( input 3, "sseProdCode", input string( buf_temp_stkShiftEnd.prod-code  ), input 0 ).
            run wp-xmltagput( input 3, "sseGdsCode" , input string( buf_temp_stkShiftEnd.gds-code   ), input 0 ).
            run wp-xmltagput( input 3, "sseGdsName" , input string( buf_temp_stkShiftEnd.gds-name   ), input 0 ).
            run wp-xmltagput( input 3, "sseGdsENVD" , input string( buf_temp_stkShiftEnd.envd       ), input 3 ).
            run wp-xmltagput( input 3, "sseFactQnty", input string( buf_temp_stkShiftEnd.qnty       ), input 0 ).
      run wp-xmltagput( input 3, "sseCliFactQnty", input string( buf_temp_stkShiftEnd.cli-qnty       ), input 0 ).
      for each buf_temp_stkPlShiftEnd where
              buf_temp_stkPlShiftEnd.gds-code = buf_temp_stkShiftEnd.gds-code
      :
          if buf_temp_stkPlShiftEnd.qnty <> 0
          then do:
              run wp-xmltagopen( input 3, input "stkPlShiftEnd", input "" ).
              run wp-xmltagput( input 4, "ssePlCode", input string( buf_temp_stkPlShiftEnd.pl-code       ), input 0 ).
              run wp-xmltagput( input 4, "ssePlFactQnty", input string( buf_temp_stkPlShiftEnd.qnty       ), input 0 ).
              run wp-xmltagput( input 4, "ssePlCliFactQnty", input string( buf_temp_stkPlShiftEnd.cli-qnty       ), input 0 ).
              run wp-xmltagput( input 4, "ssePlDensity", input string( buf_temp_stkPlShiftEnd.state-density), input 0 ).
              run wp-xmltagput( input 4, "ssePlAddQuantity", input string( buf_temp_stkPlShiftEnd.state-add-quantity), input 0 ).
              run wp-xmltagclose( input 3, input "stkPlShiftEnd").
        end.
    end.
      for each buf_temp_stkTrkShiftEnd where
              buf_temp_stkTrkShiftEnd.gds-code = buf_temp_stkShiftEnd.gds-code
      :
        run wp-xmltagopen( input 3, input "stkTRKShiftEnd", input "" ).
        run wp-xmltagput( input 4, "ssePlCode", input string( buf_temp_stkTRKShiftEnd.pl-code       ), input 0 ).
        run wp-xmltagput( input 4, "sseTRKPump", input string( buf_temp_stkTRKShiftEnd.pump-code   ), input 0 ).
        run wp-xmltagput( input 4, "sseTRKNozzle", input string( buf_temp_stkTRKShiftEnd.nozzle-code   ), input 0 ).
        run wp-xmltagput( input 4, "sseTRKCnt", input string( buf_temp_stkTRKShiftEnd.state-mh-cnt   ), input 0 ).
        run wp-xmltagclose( input 3, input "stkTRKShiftEnd").
      end.
      run wp-xmltagclose( input 2, input "stkShiftEnd").
    end. /*for each buf_temp_stkShiftEnd*/
end.
end procedure. /* export-stkShiftEnd */


/*==========================================================================*/
procedure export-stkTNP :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

/*    define variable v-archive-ok            as logical      no-undo.*/
/*    define variable v-comment               as character    no-undo.*/
/*    define variable v-can-print             as logical      no-undo.*/
/*    define variable v-current-shift-date    as date         no-undo.*/
/*    define variable v-previous-shift-date   as date         no-undo.*/

/*    define buffer buf_shift-obj     for shift-obj.*/
/*buf_shift-obj*/

    define variable v-fact-order-from   as decimal      no-undo.
    define variable v-fact-order-to     as decimal      no-undo.
    define variable v-docs-exists       as logical      no-undo.
    define variable v-is-petrol         as logical      no-undo.
    define variable v-is-pieces         as logical      no-undo.

    define buffer buf_stk-line      for ub.stk-line.
    define buffer buf_ot-line       for ub.ot-line.
    define buffer buf_gds-obj       for ub.gds-obj.
    define buffer buf_goods         for ub.goods.
    define buffer buf_temp_stkTNP   for temp_stkTNP.
do
for buf_stk-line
  , buf_ot-line
  , buf_gds-obj
  , buf_goods
  , buf_temp_stkTNP
on error undo, return error
:
    empty temp-table buf_temp_stkTNP.
    run rep/getfosht.p (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
        , output v-fact-order-from
        , output v-fact-order-to
        , output v-docs-exists
    ).
    goods-on-object:
    for each buf_gds-obj no-lock
       where buf_gds-obj.obj-type = p-obj-type
         and buf_gds-obj.obj-code = p-obj-code
    on error undo, return error
    :
        if buf_gds-obj.first-doc > p-shift-date
        then do:
            undo goods-on-object, next goods-on-object.
        end.
        { str/is-petrl.i
            buf_gds-obj.artic
            buf_gds-obj.prod-type
            buf_gds-obj.prod-code
            v-is-petrol
            v-is-pieces
        }
        if v-is-petrol  = yes
        and v-is-pieces = no
        then do:        /* Только ТНП, не топливо */
            undo goods-on-object, next goods-on-object.
        end.
        find last buf_stk-line no-lock
            where buf_stk-line.obj-type   = p-obj-type
              and buf_stk-line.obj-code   = p-obj-code
              and buf_stk-line.artic      = buf_gds-obj.artic
              and buf_stk-line.prod-type  = buf_gds-obj.prod-type
              and buf_stk-line.prod-code  = buf_gds-obj.prod-code
              and buf_stk-line.fact-order <= v-fact-order-to
              and buf_stk-line.sum-type   = {&arh-crsa}
        no-error.
        if available buf_stk-line
        then do:
            find first buf_temp_stkTNP
                 where buf_temp_stkTNP.artic     = buf_gds-obj.artic
                   and buf_temp_stkTNP.prod-type = buf_gds-obj.prod-type
                   and buf_temp_stkTNP.prod-code = buf_gds-obj.prod-code
            no-error.
            if not available buf_temp_stkTNP
            then do:
                create buf_temp_stkTNP.
                assign
                    buf_temp_stkTNP.artic     = buf_gds-obj.artic
                    buf_temp_stkTNP.prod-type = buf_gds-obj.prod-type
                    buf_temp_stkTNP.prod-code = buf_gds-obj.prod-code
                .
            end.
            find first buf_goods no-lock
                 where buf_goods.artic     = buf_temp_stkTNP.artic
                   and buf_goods.prod-type = buf_temp_stkTNP.prod-type
                   and buf_goods.prod-code = buf_temp_stkTNP.prod-code
            no-error.
            if available buf_goods
            then do:
                assign
                    buf_temp_stkTNP.gds-code = buf_goods.gds-code
                    buf_temp_stkTNP.gds-name = buf_goods.gds-name
                .
                run get-goods-envd in this-procedure (
                      input p-obj-type
                    , input p-obj-code
                    , input buf_goods.gds-code
                    , output buf_temp_stkTNP.envd
                ).
            end.
            assign
                buf_temp_stkTNP.end-sumSale = buf_stk-line.sum-rubl
                buf_temp_stkTNP.end-sumVat  = buf_stk-line.VAT-rubl
            .
        end.
    end.        /* for each buf_gds-obj */
    for each buf_temp_stkTNP
    :
        assign
            buf_temp_stkTNP.start-sumSale   = buf_temp_stkTNP.end-sumSale
            buf_temp_stkTNP.start-sumVat    = buf_temp_stkTNP.end-sumVat
        .
        for each buf_ot-line no-lock
           where buf_ot-line.obj-type  = p-obj-type
             and buf_ot-line.obj-code  = p-obj-code
             and buf_ot-line.artic     = buf_temp_stkTNP.artic
             and buf_ot-line.prod-type = buf_temp_stkTNP.prod-type
             and buf_ot-line.prod-code = buf_temp_stkTNP.prod-code
             and buf_ot-line.fact-order >= v-fact-order-from
             and buf_ot-line.fact-order <= v-fact-order-to
        on error undo, return error
        :
            if buf_ot-line.sum-type  = {&arh-crsa}
            or buf_ot-line.sum-type  = {&arh-crsa-service}
            then do:
                assign
                    buf_temp_stkTNP.start-sumSale   = buf_temp_stkTNP.start-sumSale - buf_ot-line.sum-rubl
                    buf_temp_stkTNP.start-sumVat    = buf_temp_stkTNP.start-sumVat  - buf_ot-line.VAT-rubl
                .
            end.
        end.        /* for each buf_ot-line */
    end.
    for each buf_temp_stkTNP
    :
        if buf_temp_stkTNP.start-sumSale    <> 0
        or buf_temp_stkTNP.start-sumVat     <> 0
        or buf_temp_stkTNP.end-sumSale      <> 0
        or buf_temp_stkTNP.end-sumVat       <> 0
        then do:
            run wp-xmltagopen( input 2, input "stkTNP", input "" ).
            run wp-xmltagput( input 3, "objType"        , input string( p-obj-type                      ), input 0 ).
            run wp-xmltagput( input 3, "objCode"        , input string( p-obj-code                      ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"      , input string( p-shift-date, "99.99.9999"      ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"       , input string( p-shift-num                     ), input 0 ).
            run wp-xmltagput( input 3, "stnArtic"       , input string( buf_temp_stkTNP.artic           ), input 0 ).
            run wp-xmltagput( input 3, "stnProdType"    , input string( buf_temp_stkTNP.prod-type       ), input 0 ).
            run wp-xmltagput( input 3, "stnProdCode"    , input string( buf_temp_stkTNP.prod-code       ), input 0 ).
            run wp-xmltagput( input 3, "stnGdsCode"     , input string( buf_temp_stkTNP.gds-code        ), input 0 ).
            run wp-xmltagput( input 3, "stnGdsName"     , input string( buf_temp_stkTNP.gds-name        ), input 0 ).
            run wp-xmltagput( input 3, "stnGdsENVD"     , input string( buf_temp_stkTNP.envd            ), input 3 ).
            run wp-xmltagput( input 3, "stnStartSumSale", input string( buf_temp_stkTNP.start-sumSale   ), input 0 ).
            run wp-xmltagput( input 3, "stnStartSumVat" , input string( buf_temp_stkTNP.start-sumVat    ), input 0 ).
            run wp-xmltagput( input 3, "stnEndSumSale"  , input string( buf_temp_stkTNP.end-sumSale     ), input 0 ).
            run wp-xmltagput( input 3, "stnEndSumVat"   , input string( buf_temp_stkTNP.end-sumVat      ), input 0 ).
            run wp-xmltagclose( input 3, input "stkTNP").
        end.
    end.
end.
end procedure. /* export-stkTNP */


/*==========================================================================*/
procedure export-price-sum :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-shift-date as date             no-undo.
define input parameter p-shift-num  as integer          no-undo.

    define variable v-fact-order-from   as decimal      no-undo.
    define variable v-fact-order-to     as decimal      no-undo.
    define variable v-docs-exists       as logical      no-undo.
    define variable v-is-petrol         as logical      no-undo.
    define variable v-is-pieces         as logical      no-undo.

    define buffer buf_ot-line           for ub.ot-line.
    define buffer buf_gds-obj           for ub.gds-obj.
    define buffer buf_goods             for ub.goods.
    define buffer buf_temp_sumPriceSale for temp_sumPriceSale.
do
for buf_ot-line
  , buf_gds-obj
  , buf_goods
  , buf_temp_sumPriceSale
on error undo, return error
:
    empty temp-table buf_temp_sumPriceSale.
    run rep/getfosht.p (
          input p-obj-type
        , input p-obj-code
        , input p-shift-date
        , input p-shift-num
        , output v-fact-order-from
        , output v-fact-order-to
        , output v-docs-exists
    ).
    goods-on-object:
    for each buf_gds-obj no-lock
       where buf_gds-obj.obj-type = p-obj-type
         and buf_gds-obj.obj-code = p-obj-code
    on error undo, return error
    :
        { str/is-petrl.i
            buf_gds-obj.artic
            buf_gds-obj.prod-type
            buf_gds-obj.prod-code
            v-is-petrol
            v-is-pieces
        }
        if v-is-petrol  = yes
        and v-is-pieces = no
        then do:        /* Только ТНП, не топливо */
            undo goods-on-object, next goods-on-object.
        end.
        if buf_gds-obj.first-doc > p-shift-date
        then do:
            undo goods-on-object, next goods-on-object.
        end.
        for each buf_ot-line no-lock
           where buf_ot-line.obj-type  = p-obj-type
             and buf_ot-line.obj-code  = p-obj-code
             and buf_ot-line.artic     = buf_gds-obj.artic
             and buf_ot-line.prod-type = buf_gds-obj.prod-type
             and buf_ot-line.prod-code = buf_gds-obj.prod-code
             and buf_ot-line.fact-order >= v-fact-order-from
             and buf_ot-line.fact-order <= v-fact-order-to
        on error undo, return error
        :
            if buf_ot-line.ext-doc-type  = {&TDEDT_Overturn}
            then do:
                find first buf_temp_sumPriceSale
                     where buf_temp_sumPriceSale.artic     = buf_ot-line.artic
                       and buf_temp_sumPriceSale.prod-type = buf_ot-line.prod-type
                       and buf_temp_sumPriceSale.prod-code = buf_ot-line.prod-code
                no-error.
                if not available buf_temp_sumPriceSale
                then do:
                    create buf_temp_sumPriceSale.
                    assign
                        buf_temp_sumPriceSale.artic     = buf_ot-line.artic
                        buf_temp_sumPriceSale.prod-type = buf_ot-line.prod-type
                        buf_temp_sumPriceSale.prod-code = buf_ot-line.prod-code
                    .
                    find first buf_goods no-lock
                         where buf_goods.artic     = buf_ot-line.artic
                           and buf_goods.prod-type = buf_ot-line.prod-type
                           and buf_goods.prod-code = buf_ot-line.prod-code
                    no-error.
                    if available buf_goods
                    then do:
                        assign
                            buf_temp_sumPriceSale.gds-code = buf_goods.gds-code
                            buf_temp_sumPriceSale.gds-name = buf_goods.gds-name
                        .
                        run get-goods-envd in this-procedure (
                              input p-obj-type
                            , input p-obj-code
                            , input buf_goods.gds-code
                            , output buf_temp_sumPriceSale.envd
                        ).
                    end.
                end.
                assign
                    buf_temp_sumPriceSale.sumSale   = buf_temp_sumPriceSale.sumSale + buf_ot-line.sum-rubl
                    buf_temp_sumPriceSale.sumVat    = buf_temp_sumPriceSale.sumSale + buf_ot-line.VAT-rubl
                .
            end.
        end.        /* for each buf_ot-line */
    end.        /* for each buf_gds-obj no-lock */
    for each buf_temp_sumPriceSale
    :
        if buf_temp_sumPriceSale.sumSale    <> 0
        or buf_temp_sumPriceSale.sumVat     <> 0
        then do:
            run wp-xmltagopen( input 2, input "sumPriceSale", input "" ).
            run wp-xmltagput( input 3, "objType"        , input string( p-obj-type                      ), input 0 ).
            run wp-xmltagput( input 3, "objCode"        , input string( p-obj-code                      ), input 0 ).
            run wp-xmltagput( input 3, "shiftDate"      , input string( p-shift-date, "99.99.9999"      ), input 0 ).
            run wp-xmltagput( input 3, "shiftNum"       , input string( p-shift-num                     ), input 0 ).
            run wp-xmltagput( input 3, "spsArtic"       , input string( buf_temp_sumPriceSale.artic     ), input 0 ).
            run wp-xmltagput( input 3, "spsProdType"    , input string( buf_temp_sumPriceSale.prod-type ), input 0 ).
            run wp-xmltagput( input 3, "spsProdCode"    , input string( buf_temp_sumPriceSale.prod-code ), input 0 ).
            run wp-xmltagput( input 3, "spsGdsCode"     , input string( buf_temp_sumPriceSale.gds-code  ), input 0 ).
            run wp-xmltagput( input 3, "spsGdsName"     , input string( buf_temp_sumPriceSale.gds-name  ), input 0 ).
            run wp-xmltagput( input 3, "spsGdsENVD"     , input string( buf_temp_sumPriceSale.envd      ), input 3 ).
            run wp-xmltagput( input 3, "spsSumSale"     , input string( buf_temp_sumPriceSale.sumSale   ), input 0 ).
            run wp-xmltagput( input 3, "spsSumVat"      , input string( buf_temp_sumPriceSale.sumVat    ), input 0 ).
            run wp-xmltagclose( input 3, input "sumPriceSale").
        end.
    end.
end.
end procedure. /* export-price-sum */


/*==========================================================================*/
procedure get-goods-envd :
define input parameter p-obj-type   as character        no-undo.
define input parameter p-obj-code   as integer          no-undo.
define input parameter p-gds-code   as integer          no-undo.
define output parameter p-is-envd   as logical          no-undo.

    define variable v-host-code    as integer      no-undo.

    define buffer buf_clients-attr      for ub.clients-attr.
    define buffer buf_gds-host-attr     for ub.gds-host-attr.
do
for buf_clients-attr
  , buf_gds-host-attr
on error undo, return error
:
    assign
        p-is-envd = no
    .
    find first buf_clients-attr no-lock
         where buf_clients-attr.obj-type  = p-obj-type
           and buf_clients-attr.obj-code  = p-obj-code
           and buf_clients-attr.attr-code = {&attr-taxation}
    no-error.
    if available buf_clients-attr
    then do:
        { gbl/hostcode.i
            p-obj-type
            p-obj-code
            v-host-code
        }
        if caps( buf_clients-attr.attr-value ) = "ЕНВД":U
        then do:
            find first buf_gds-host-attr no-lock
                 where buf_gds-host-attr.host-code = v-host-code
                   and buf_gds-host-attr.gds-code  = p-gds-code
                   and buf_gds-host-attr.attr-code = "no-envd":U
            no-error.
            if not available buf_gds-host-attr
            then do:
                assign
                    p-is-envd = yes
                .
            end.
            else do:
                assign
                    p-is-envd = ( buf_gds-host-attr.attr-value = "no":U )
                .
            end.
        end.
    end.
end.
end procedure. /* get-goods-envd */