/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт чеков

Автор: Гюнтнер Виктор Арнольдович
Дата создания: 04/12/06
Author: Victor Guntner
Creation date: 04/12/06

Input:

Output:

*/
define input parameter  p-log-handle       as handle               no-undo.
define input parameter v-ftp-adress        as character            no-undo.
define input parameter v-place             as integer              no-undo.
define input parameter v-login             as character            no-undo.
define input parameter v-password          as character            no-undo.
define input parameter v-date-from         as date      INIT ?     no-undo.
define input parameter v-date-to           as date      INIT ?     no-undo.
define input parameter v-range             as integer              no-undo.
define input parameter v-host-code         as integer              no-undo.
define input parameter v-obj-list          as character            no-undo.
define input parameter v-pay-type-list     as character            no-undo . /* список recid'ов выбранных записей cash-pay */
define input parameter v-gds-type          as character init 'all' no-undo.  /* тип товара all/fuel/other */
define input parameter v-void-character    as character            no-undo.
define input parameter v-dc-num-full       as character            no-undo.
define input parameter v-per               as integer              no-undo.
define input parameter v-inf-bonus         as logical              no-undo.    
define input parameter p-code_pool         as character            no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экспорт чеков".
{ cmp/vssrevis.i        }
{ cmp/trg-def.i         }
{ gbl/temphost.i        }
{ bge/bge-xml.i         }
{ gbl/getcntxt.i def    }
{ str/lib-trn.i         }
{ gbl/ftp-df.i }
{ cmp/r-pril.i new  } 

&scoped-define version-string "12.2 " + replace( vss-revision + vss-date, "$", " " )

define variable   log-file-name  as char no-undo.


DEFINE TEMP-TABLE tt-cash-pay NO-UNDO
    FIELD pay-code  LIKE cash-pay.cdpay-code
    FIELD curr-code LIKE cash-pay.curr-code
    INDEX pu AS PRIMARY UNIQUE
    pay-code
    curr-code
    .


do
    on error undo, return error
    :
    define variable v-xml-file-name    as character no-undo.
    define variable v-log-file-name    as character no-undo.
    define variable v-locked           as logical   no-undo.

    define variable v-obj-counter      as integer   no-undo.
    define variable v-rrn              as character no-undo.
    DEFINE VARIABLE v-pay-type-counter AS INTEGER   NO-UNDO.
    DEFINE VARIABLE v-need-pay-type    AS LOGICAL   NO-UNDO.

    DEFINE VARIABLE v-db-num-char      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-task-type        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE v-task-num         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE v-action           AS CHARACTER NO-UNDO.

    DEFINE BUFFER buf_cash-pay FOR cash-pay.
    define buffer  buf_chk-pay-attr for chk-pay-attr.





    IF v-pay-type-list <> "" THEN
    DO v-pay-type-counter = 1 TO NUM-ENTRIES( v-pay-type-list ):
        FIND FIRST buf_cash-pay
            WHERE RECID(buf_cash-pay) = INTEGER(ENTRY( v-pay-type-counter, v-pay-type-list ))
            NO-LOCK
            NO-ERROR.
        IF NOT AVAILABLE buf_cash-pay
            OR CAN-FIND(FIRST tt-cash-pay WHERE tt-cash-pay.pay-code  = buf_cash-pay.cdpay-code
            AND tt-cash-pay.curr-code = buf_cash-pay.curr-code
            NO-LOCK )
            THEN NEXT.

        CREATE tt-cash-pay.
        ASSIGN
            tt-cash-pay.pay-code  = buf_cash-pay.cdpay-code
            tt-cash-pay.curr-code = buf_cash-pay.curr-code
            .

        RELEASE tt-cash-pay.
        RELEASE buf_cash-pay.
    END.

    IF CAN-FIND(FIRST tt-cash-pay NO-LOCK) THEN ASSIGN
            v-need-pay-type = TRUE
            .


        { gbl/working.i }

if v-place = 2 then do:
        log-file-name = "check.log"
        .
 &scop display-message    run write-log-and-file in p-log-handle (  ~
         input 1                                                      ~
         , input log-file-name                                          ~
         , input 1                                                      ~
         , input ~{&my-message~})
end.
    case v-range:
        when 1
        then 
            do:
                run init-temphost.
            end.
        when 2      /* Экспорт по текущей фирме */
        then 
            do:
                run init-temphost.
                for each temp-obj
                    where temp-obj.host-code <> v-host-code /*v-cntxt-host-code-obj*/
                    :
                    delete temp-obj.
                end.
            end.
        when 3      /* Экспорт по списку объектов */
        then 
            do:
                for each temp-obj
                    :
                    delete temp-obj.
                end.
                do v-obj-counter = 1 to num-entries ( v-obj-list ) / 2
                    :
                    create temp-obj.
                    assign
                        temp-obj.obj-type = entry( v-obj-counter * 2 - 1, v-obj-list )
                        temp-obj.obj-code = integer( entry( v-obj-counter * 2, v-obj-list ) )
            no-error .
                    if error-status :error
                        then 
                    do:
                        run wp-XMLWriteLog in this-procedure (
                            input v-log-file-name
                            , input 1
                            , input substitute( "*** Ошибка чтения списка объектов. &1. &2. &3. &4."
                            , return-value
                            , trim(error-status :get-message(1))
                            , trim(error-status :get-message(2))
                            , trim(error-status :get-message(3))
                            )
                            ).
                        undo, return error .
                    end.
                    { gbl/hostcode.i
                temp-obj.obj-type
                temp-obj.obj-code
                temp-obj.host-code
            no-error }
                    if error-status :error
                        then 
                    do:
                        run wp-XMLWriteLog in this-procedure (
                            input v-log-file-name
                            , input 1
                            , input substitute( "*** Не найдена фирма для объекта &1 &2. &3. &4. &5. &6."
                            , temp-obj.obj-type
                            , temp-obj.obj-code
                            , return-value
                            , trim(error-status :get-message(1))
                            , trim(error-status :get-message(2))
                            , trim(error-status :get-message(3))
                            )
                            ).
                        undo, return error .
                    end.
                end.
            end.
    end case.
    assign
        v-bge-xml-bgeflold = "new":U
        .
    run xml-bge-filename in this-procedure (
        input "d":U
        , input "":U
        , input no
        , output v-xml-file-name
        , output v-log-file-name
        , output v-locked
        ) no-error.
       if v-place = 1 then do:  
           
           
           
  run bge/genfname.p (
                    input v-ftp-adress
                    , input "D"
                    , input ""
                    , input "."
                    , input ""
                    , output v-xml-file-name
                ).
end.

if v-place = 2 then
do:
      run bge/genfname.p (
                    input session:temp-directory 
                    , input "D"
                    , input ""
                    , input "."
                    , input ""
                    , output v-xml-file-name
                ).
    assign
        log-file-name = "check.log"
        .
 end.

    run wp-XMLWriteLog in this-procedure (
        input v-log-file-name
        , input 1
        , input "&DLine"
        ).
    run wp-XMLWriteLog in this-procedure (
        input v-log-file-name
        , input 1
        , input substitute( "Начало выгрузки чеков в файл &1"
        , replace( v-xml-file-name, "/", "\" ) + "xm1"
        )
        ).
        
    if v-per = 0 then 
    do: 
            
        run wp-XMLWriteLog in this-procedure (
            input v-log-file-name
            , input 1
            , input substitute( "................с параметрами: Дата с: &1, дата по: &2"
            , v-date-from
            , v-date-to
            )
            ).
    end.
    else 
    do: 
            
        run wp-XMLWriteLog in this-procedure (
            
            input v-log-file-name
            , input 1
            , input substitute( "................с параметрами: Дата с: &1, дата по: &2"
            , (today - v-per)
            , today
            )
            ).
            
    end.
        
    run wp-XMLWriteLog in this-procedure (
        input v-log-file-name
        , input 1
        , input substitute( "................с параметрами: ... список объектов: &1", v-obj-list )
        ).
    if v-locked = yes
        then 
    do:
        run wp-XMLWriteLog in this-procedure (
            input v-log-file-name
            , input 1
            , input "*** Ошибка выгрузки: Файл выгрузки заблокирован другим процессом."
            ).
        undo, return error .
    end.
    run bge-xml-write-header-check in this-procedure (
        input v-xml-file-name
        , input "check"
        , input {&version-string}
        , input g#db-num
        , input v-date-from
        , input 0
        , input v-date-to
        , input 0
        , input v-obj-list
        , input p-code_pool
        , input v-dc-num-full
        , input v-inf-bonus
        , input "":U
        , input no
        , input no
        , input no
        , input no
        , input no
        , input no
        , input no
        , input no
        ) no-error.
    if error-status :error
        then 
    do:
        run wp-XMLWriteLog in this-procedure (
            input v-log-file-name
            , input 1
            , input substitute( "*** Ошибка записи шапки файла. Процедура: &1 (v.&2 &3). &4. &5"
            , vss-workfile
            , vss-revision
            , vss-description
            , return-value
            , trim( error-status :get-message( 1 ) )
            )
            ).
        undo, return error.
    end.
    

    for each temp-obj 
    no-lock
        on error undo, return error
   
        :
            
            
                   run rep/rpychk0.p (input "r-shftc2"
            ,input temp-obj.obj-type
            ,input temp-obj.obj-code
            ,input ?                    /*p-date-from*/
            ,input ?                    /*p-date-to*/
            ,input v-date-from         /*p-shift-date-from*/
            ,input v-date-to           /*p-shift-date-to*/
            ,input 1                    /*p-shift-num-start*/
            ,input 99                   /*p-shift-num-end*/
            ,input ?                    /*p-inkas-code*/
            ) no-error.

        if error-status:error then
        do:
            message error-status:get-message(1) view-as alert-box.
        end.
            
        if v-per = 0 then 
        do: 
                
            run export-checks-by-object in this-procedure (
                input temp-obj.obj-type
                , input temp-obj.obj-code
                , input v-xml-file-name
                , input v-log-file-name
                , input v-date-from
                , input v-date-to
                , input v-pay-type-list
                , INPUT v-need-pay-type
                ) no-error.
            if error-status :error
                then 
            do:
                run wp-XMLWriteLog in this-procedure (
                    input v-log-file-name
                    , input 1
                    , input substitute( "*** Ошибка выгрузки чеков по объекту &1 &2. &3. &4. &5."
                    , temp-obj.obj-type
                    , temp-obj.obj-code
                    , return-value
                    , trim(error-status :get-message(1))
                    , trim(error-status :get-message(2))
                    , trim(error-status :get-message(3))
                    )
                    ).
            end.
        end.      
        else 
        do: 
            run export-checks-by-object in this-procedure (
                input temp-obj.obj-type
                , input temp-obj.obj-code
                , input v-xml-file-name
                , input v-log-file-name
                , input (today - v-per)
                , input today
                , input v-pay-type-list
                , INPUT v-need-pay-type
                ) no-error.
            if error-status :error
                then 
            do:
                run wp-XMLWriteLog in this-procedure (
                    input v-log-file-name
                    , input 1
                    , input substitute( "*** Ошибка выгрузки чеков по объекту &1 &2. &3. &4. &5."
                    , temp-obj.obj-type
                    , temp-obj.obj-code
                    , return-value
                    , trim(error-status :get-message(1))
                    , trim(error-status :get-message(2))
                    , trim(error-status :get-message(3))
                    )
                    ).
               
               
            end.
        end.
        /*НАДО УБЕДИТЬСЯ ЧТО ВСЕ РАЗМАЗАНО!!*/
 
    end.        /* for each temp-obj */
    
    run xml-bge-write-footer in this-procedure (
        input v-xml-file-name
        ).
    run wp-XMLWriteLog in this-procedure (
        input v-log-file-name
        , input 1
        , input substitute( "Данные выгружены в файл &1"
        , replace( v-xml-file-name, "/", "\" ) + "xml"
        )
        ).
    run wp-XMLWriteLog in this-procedure (
        input v-log-file-name
        , input 1
        , input "&DLine"
        ).
                 if  v-place  = 2 then
do:
   
        run ftp-send in this-procedure (input (v-xml-file-name)) no-error.
        if error-status:error
            then 
        do:
                  &scop my-message substitute("Ошибка отправки по FTP: &1", return-value)
            {&display-message}.
        end.
        else
        do:
            v-xml-file-name = replace( v-xml-file-name, "/", "\" ) + "xml".
            os-delete value( v-xml-file-name ).
        end.
   
end.
        
    { gbl/stopwork.i }
end.

/*==========================================================================*/
procedure export-checks-by-object :
    do
        on error undo, return error
        :
        define input parameter p-obj-type       as character    no-undo.
        define input parameter p-obj-code       as integer      no-undo.
        define input parameter p-xml-file-name  as character    no-undo.
        define input parameter p-log-file-name  as character    no-undo.
        define input parameter p-date-from      as date         no-undo.
        define input parameter p-date-to        as date         no-undo.
        define input parameter p-pay-type-list  as character    no-undo.
        define input parameter p-need-pay-type  as logical      no-undo.


        define variable v-gds-code        as integer   no-undo.
        define variable v-artic           as character no-undo.
        define variable v-prod-type       as character no-undo.
        define variable v-prod-code       as integer   no-undo.
        define variable v-gds-name        as character no-undo.
        define variable v-pay-name        as character no-undo.
        define variable v-curr-abbr       as character no-undo.
        define variable conf-attr         as character no-undo.
        define variable conf-par          as character no-undo.
        define variable par-type          as character no-undo.
        define variable dflt-cd           as character no-undo.
        DEFINE VARIABLE v-finded-pay-type AS LOGICAL   NO-UNDO.
        define variable i                 as integer   init 1 no-undo .
        define variable v-host-code       as integer   no-undo.
        define variable v-d-card          as character no-undo.
        define variable v-par-type        as character no-undo.
        define variable v-trim-zero       as character no-undo.
        define variable v-num             as integer   no-undo.
        define variable v-is-petrol       as logical   no-undo.
        define variable v-is-pieces       as logical   no-undo.
        define variable v-is-found        as logical   no-undo.
        define variable v-dcard-num       as char      no-undo.
        define variable v-cpline          as integer   no-undo.
        define variable v-pay-code        as integer   no-undo.
        define variable v-eff-doc-qnty    as decimal   no-undo.
        define variable v-pay-card        as character no-undo.
        define variable v-price-base      as decimal   no-undo.
        define variable v-tot-r-b         as decimal   no-undo.
        define variable v-discnt          as decimal   no-undo.
        define variable v-qnty-bonus      as decimal   no-undo.
        define buffer buf_chk-doc     for chk-doc.
        define buffer buf_chk-gds     for chk-gds.
        define buffer buf_bar-code    for bar-code.
        define buffer buf_goods       for goods.
        define buffer buf_chk-pay     for chk-pay.
        define buffer buf_cash-pay    for cash-pay.
        define buffer buf_currency    for currency.
        define buffer buf_chk-gds-pay for chk-gds-pay.
    
    
        { gbl/hostcode.i
        p-obj-type
        p-obj-code
        v-host-code
    }
        run gbl/conf-rd.p (
            input "bgedcard":U
            , input v-host-code
            , input p-obj-type
            , input p-obj-code
            , input "":U
            , input "":U
            , input "":U
            , input no
            , output v-trim-zero
            , output v-par-type
            ) no-error.
        if error-status :error
            then 
        do:
            assign
                v-trim-zero = "no":U
                .
        end.
    /*сначала определим маркетерный ли этой объект*/
    /*считаем dflt-cd*/
        { gbl/dflt-cd.i p-obj-type p-obj-code dflt-cd }

        output stream stmxmlout to value( p-xml-file-name + "xm1" ) convert target "1251" append.
        
        
/*            v-num =  num-entries (v-dc-num-full).*/
/*              if v-dc-num-full = "" then i = -1. */
/*                                                 */
           
/*        do while i <> v-num  :*/
        v-dc-num-full = right-trim(v-dc-num-full, ",").

        for each buf_chk-doc no-lock
            where buf_chk-doc.obj-type = p-obj-type
            and buf_chk-doc.obj-code = p-obj-code
            and buf_chk-doc.chk-date >= p-date-from
            and buf_chk-doc.chk-date <= p-date-to  
            
            on error undo, return error
            :
            if lookup(string(buf_chk-doc.chk-type), {&no-sale-receipt-codes}) > 0 then next.
            
            if v-dc-num-full <> "" then
            do:
                if lookup( buf_chk-doc.d-card, v-dc-num-full ) = 0 then next.
            end.
            
            IF p-need-pay-type THEN
            _search-pay-type:
            DO:
                ASSIGN
                    v-finded-pay-type = FALSE
                    .
                FOR EACH buf_chk-pay NO-LOCK
                    WHERE buf_chk-pay.doc-code = buf_chk-doc.doc-code
                    :
                    IF CAN-FIND(FIRST tt-cash-pay WHERE tt-cash-pay.pay-code  = buf_chk-pay.pay-code
                        AND tt-cash-pay.curr-code = buf_chk-pay.curr-code
                        NO-LOCK )
                        THEN 
                    DO:
                        ASSIGN
                            v-finded-pay-type = TRUE
                            .
                        LEAVE _search-pay-type.
                    END.
                END.
            END.
            IF      p-need-pay-type
                AND NOT v-finded-pay-type THEN NEXT.

            /* проверим тип товара */
            if not v-gds-type = "all" then 
            do:
                assign 
                    v-is-found = false .
                /*переберем переберем товары по чеку*/
                for each buf_chk-gds no-lock
                    where buf_chk-gds.doc-code = buf_chk-doc.doc-code :
                    /*найдем код товара по баркоду*/
                    find first buf_bar-code no-lock
                        where buf_bar-code.b-code = buf_chk-gds.b-code
                        no-error.
                    if available buf_bar-code then 
                    do:
                        /*найдем товар по коду*/
                        find first buf_goods no-lock
                            where buf_goods.gds-code = buf_bar-code.gds-code
                            no-error.
                        if available buf_goods then 
                        do:
                        /*это топливо?*/
                        { str/is-petrl.i buf_goods.artic buf_goods.prod-type buf_goods.prod-code v-is-petrol v-is-pieces no-error }
                            if not error-status :error then 
                            do:
                                assign 
                                    v-is-found = true .
                            end.
                        end.
                    end.
                end. /*for each buf_chk-gds*/
                /*если все данные получили без ошибок*/
                if v-is-found then 
                do:
                    /*если фильтр по топливу, а товар не топливо, то чек пропускаем*/
                    if v-gds-type = "fuel" and not v-is-petrol then next.
                    /*если фильтр по НЕ топливу, а товар топливо, то чек пропускаем*/
                    if v-gds-type = "other" and v-is-petrol then next.
                end.
            end. /*if not v-gds-type = "all"*/

            assign
                v-d-card = buf_chk-doc.d-card
                .
            if v-trim-zero = "yes":U
                then 
            do:
                assign
                    v-d-card = left-trim( v-d-card, "0":U )
                    .
            end.
            
                      run wp-xmltagopen  in this-procedure ( input 1, input "check" , input "" ).
        
                        run wp-xmltagopen  in this-procedure ( input 2, input "checkHead" , input "" ).
                        run wp-xmltagput   in this-procedure ( input 3, input "ID"        , input string( buf_chk-doc.doc-code    ), input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "objType"   , input string( buf_chk-doc.obj-type    ), input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "objCode"   , input string( buf_chk-doc.obj-code    ), input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "date"      , input string( buf_chk-doc.chk-date, "99/99/9999" ), input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "time"      , input string( buf_chk-doc.chk-time, "HH:MM:SS" ), input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "checkNum"  , input string( buf_chk-doc.chk-num     ), input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "deskNum"   , input string( buf_chk-doc.pay-desk    ), input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "SrcCardNum"        , input buf_chk-doc.src-d-card , input 0 ).
                        run wp-xmltagput   in this-procedure ( input 3, input "cardNum"   , input string( v-d-card                ), input 0 ).  
                        run wp-xmltagput   in this-procedure ( input 3, input "checktype"   , input string( buf_chk-doc.chk-type            ), input 0 ).            
                        run wp-xmltagput   in this-procedure ( input 3, input "chekShiftDate"   , input string( buf_chk-doc.shift-date            ), input 0 ).            
                        run wp-xmltagput   in this-procedure ( input 3, input "chekShiftNum"   , input string( buf_chk-doc.shift-num            ), input 0 ).   
                        run wp-xmltagput   in this-procedure ( input 3, input "checkTotDoc"   , input string( buf_chk-doc.netto            ), input 0 ).                                    
                        run wp-xmltagclose in this-procedure ( input 2, input "checkHead").
        
                        for each buf_chk-gds no-lock
                            where buf_chk-gds.doc-code = buf_chk-doc.doc-code 
                      
                            on error undo, return error
                            :
                        
                            find first buf_bar-code no-lock
                                where buf_bar-code.b-code = buf_chk-gds.b-code
                                no-error.
                            if available buf_bar-code
                                then 
                            do:
                                find first buf_goods no-lock
                                    where buf_goods.gds-code = buf_bar-code.gds-code
                                    .
                                if available buf_goods
                                    then 
                                do:
                                    assign
                                        v-gds-code  = buf_goods.gds-code
                                        v-artic     = buf_goods.artic
                                        v-prod-type = buf_goods.prod-type
                                        v-prod-code = buf_goods.prod-code
                                        v-gds-name  = buf_goods.gds-name
                                        .
                                end.
                                else 
                                do:
                                    run wp-XMLWriteLog in this-procedure (
                                        input p-log-file-name
                                        , input 1
                                        , input substitute( "*** Не найден товар для баркода по чеку &1. Объект &2 &3. Баркод &4. Код товара &5."
                                        , buf_chk-gds.doc-code
                                        , temp-obj.obj-type
                                        , temp-obj.obj-code
                                        , buf_chk-gds.b-code
                                        , buf_bar-code.gds-code
                                        )
                                        ).
                                end.
                            end.
                            else 
                            do:
                                run wp-XMLWriteLog in this-procedure (
                                    input p-log-file-name
                                    , input 1
                                    , input substitute( "*** Не найден баркод для чека &1. Объект &2 &3. Баркод &4."
                                    , buf_chk-gds.doc-code
                                    , temp-obj.obj-type
                                    , temp-obj.obj-code
                                    , buf_chk-gds.b-code
                                    )
                                    ).
                            end.
                   
                
                        
                              
                    run wp-xmltagopen in this-procedure ( input 2, input "checkBody", input "" ).
                    run wp-xmltagput in this-procedure ( input 3, input "ID"        , input string( buf_chk-gds.doc-code    ), input 0 ).
                    run wp-xmltagput in this-procedure ( input 3, input "bcode"     , input string( buf_chk-gds.b-code      ), input 0 ).
                    run wp-xmltagput in this-procedure ( input 3, input "gdsCode"   , input string( v-gds-code              ), input 0 ).
                            run wp-xmltagput in this-procedure ( input 3, input "artic"     , input string( v-artic                 ), input 0 ).
                            run wp-xmltagput in this-procedure ( input 3, input "prodType"  , input string( v-prod-type             ), input 0 ).
                            run wp-xmltagput in this-procedure ( input 3, input "prodCode"  , input string( v-prod-code             ), input 0 ).
                            run wp-xmltagput in this-procedure ( input 3, input "gdsName"   , input string( v-gds-name              ), input 0 ).
                            run wp-xmltagput in this-procedure ( input 3, input "price"     , input string( buf_chk-gds.price-base  ), input 0 ).
                            run wp-xmltagput in this-procedure ( input 3, input "qnty"      , input string( buf_chk-gds.doc-qnty    ), input 0 ).
                            run wp-xmltagput in this-procedure ( input 3, input "discnt"    , input string( buf_chk-gds.discnt      ), input 0 ).
                            
                            
                            for each buf_chk-gds-pay no-lock
                                where buf_chk-gds-pay.doc-code = buf_chk-gds.doc-code and
                                buf_chk-gds-pay.line-num = buf_chk-gds.line-num:
                 
                                assign
                                    v-cpline       = buf_chk-gds-pay.cpline-num
                                    v-pay-code     = buf_chk-gds-pay.pay-code
                                    v-eff-doc-qnty = buf_chk-gds-pay.eff-doc-qnty
                                    v-pay-card     = buf_chk-gds-pay.pay-card
                                    v-price-base   = buf_chk-gds-pay.price-base 
                                    v-tot-r-b      = buf_chk-gds-pay.tot-r-b
                                    v-discnt       = buf_chk-gds-pay.discnt 
                                    .
                 
                                run wp-xmltagopen in this-procedure ( input 3, input "checkBodyPay", input "" ).
                                run wp-xmltagput in this-procedure ( input 4, input "cpLine"       , input string( v-cpline             ), input 0 ).
                                run wp-xmltagput in this-procedure ( input 4, input "payCode"      , input string( v-pay-code           ), input 0 ).
                                run wp-xmltagput in this-procedure ( input 4, input "totrb"        , input string( v-tot-r-b            ), input 0 ).
                                run wp-xmltagput in this-procedure ( input 4, input "pricebase"    , input string( v-price-base         ), input 0 ).
                                run wp-xmltagput in this-procedure ( input 4, input "numpaycard"   , input string( v-pay-card           ), input 0 ).
                                run wp-xmltagput in this-procedure ( input 4, input "discnt"       , input string( v-discnt             ), input 0 ).
                                run wp-xmltagput in this-procedure ( input 4, input "effdocqnty"   , input string( v-eff-doc-qnty       ), input 0 ).
                                run wp-xmltagclose in this-procedure ( input 3, input "checkBodyPay" ).
                            end.
                            run wp-xmltagclose in this-procedure ( input 2, input "checkBody" ).
                        end.        /* for each buf_chk-gds */
                        
                        
                        
        for each buf_chk-pay no-lock
            where buf_chk-pay.doc-code = buf_chk-doc.doc-code
            on error undo, return error
            :
            find first buf_cash-pay no-lock
                where buf_cash-pay.cdpay-code  = buf_chk-pay.pay-code
                AND buf_cash-pay.curr-code   = buf_chk-pay.curr-code
                no-error.
                   
            if available buf_cash-pay
                then 
            do:
                assign
                    v-pay-name = buf_cash-pay.obj-name
                    .
                find first buf_currency no-lock
                    where buf_currency.curr-code = buf_chk-pay.curr-code
                    .
                if available buf_currency
                    then 
                do:
                    assign
                        v-curr-abbr = buf_currency.curr-abbr
                        .
                end.
                              
                else 
                do:
                    run wp-XMLWriteLog in this-procedure (
                        input p-log-file-name
                        , input 1
                        , input substitute( "*** Не найдена валюта для платежа по чеку &1. Объект &2 &3. Платеж &4. Код валюты &5."
                        , buf_chk-pay.doc-code
                        , temp-obj.obj-type
                        , temp-obj.obj-code
                        , buf_chk-pay.pay-code
                        , buf_chk-pay.curr-code
                        )
                        ).
                end.
            end.
            else 
            do:
                run wp-XMLWriteLog in this-procedure (
                    input p-log-file-name
                    , input 1
                    , input substitute( "*** Не найден платеж для чека &1. Объект &2 &3. Платеж &4. Код валюты &5"
                    , buf_chk-pay.doc-code
                    , temp-obj.obj-type
                    , temp-obj.obj-code
                    , buf_chk-pay.pay-code
                    , buf_chk-pay.curr-code
                    )
                    ).
            end.


          
            find first buf_chk-pay-attr where  buf_chk-pay-attr.doc-code = buf_chk-pay.doc-code  and buf_chk-pay-attr.attr-code = "cpdoc"  and buf_chk-pay.line-num =  buf_chk-pay-attr.line-num  no-lock no-error.
            if available buf_chk-pay-attr then 
            do:
                v-rrn = buf_chk-pay-attr.attr-value.
            end.
            else 
            do:
                v-rrn = "".
                 
            end.



            run wp-xmltagopen in this-procedure ( input 2, input "checkPays", input "" ).
            run wp-xmltagput in this-procedure ( input 3, input "ID"        , input string( buf_chk-pay.doc-code    ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "payCode"   , input string( buf_chk-pay.pay-code    ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "currCode"  , input string( buf_chk-pay.curr-code   ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "payName"   , input string( v-pay-name              ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "currAbbr"  , input string( v-curr-abbr             ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "totSum"    , input string( buf_chk-pay.tot-sum     ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "totBase"   , input string( buf_chk-pay.tot-base    ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "totRubl"   , input string( buf_chk-pay.tot-rubl    ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "payCard"   , input string( buf_chk-pay.pay-card    ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "cashRate"  , input string( buf_chk-pay.cash-rate   ), input 0 ).
            run wp-xmltagput in this-procedure ( input 3, input "OperationCode"  , input string( v-rrn   ), input 0 ).
                            
            run wp-xmltagclose in this-procedure ( input 2, input "checkPays" ).
                            
        end.
        
            if v-inf-bonus then 
            do: 
            
                for  each  chk-discnt where chk-discnt.doc-code = buf_chk-doc.doc-code and chk-discnt.record-type = 4 and chk-discnt.discnt-value-abs <> 0
            on error undo, return error
                    :

                    
                    run wp-xmltagopen in this-procedure ( input 2, input "checkBonus", input "" ).
                    run wp-xmltagput   in this-procedure ( input 3, input "ID"        , input string( buf_chk-doc.doc-code    ), input 0 ).
                    run wp-xmltagput   in this-procedure ( input 3, input "SrcCardNum"        , input chk-discnt.src-d-card , input 0 ).
                    run wp-xmltagput in this-procedure ( input 3, input "LineNum"        , input string( chk-discnt.line-num    ), input 0 ).
                    run wp-xmltagput in this-procedure ( input 3, input "BonusAmount"        , input string(chk-discnt.discnt-value-abs), input 0 ).
                    run wp-xmltagput in this-procedure ( input 3, input "BonusCardNum"        , input buf_chk-doc.d-card , input 0 ).
                    run wp-xmltagput in this-procedure ( input 3, input "BonusMode"        , input string( chk-discnt.line-type) , input 0 ).
                    run wp-xmltagclose in this-procedure ( input 2, input "checkBonus" ).            
                                    
                end.
            end.
   
    run wp-xmltagclose in this-procedure ( input 1, input "check").
               
        /*                end.*/
                    
        end.
                
        output stream stmxmlout close.
    end.
    
    
end procedure. /* export-checks-by-object */


    

procedure ftp-send :
    define input parameter p-xml-file-name    as character no-undo.
    
    define variable v-parameter               as character no-undo.
    define variable p-directory               as char      no-undo.
    do
        on error undo, return error
        :
        p-xml-file-name =     replace(p-xml-file-name, "/", "\" ) + "xml".
        /* v-log-file-name =  replace(v-log-file-name, "/", "\" ) .*/
        /*Перед передачей параметра чистим ip-адрес от лишних символов*/
        p-directory = trim(trim(replace(v-ftp-adress,'ftp:',""),{&slash-char}),{&back-slash-char}).
        /*Передача параметров*/
        v-parameter = p-directory + {&delim-par} +
            v-login + {&delim-par} +
            v-password + {&delim-par} +
            string({&INTERNET_FLAG_PASSIVE}) + {&delim-par} + ''
            +
            p-xml-file-name  + {&delim-par} +
            /*p-ftp-target-dir + {&slash-char} +*/ p-xml-file-name + {&delim-par} +
            string(no) + {&delim-par} +  log-file-name .
        run gbl/ftp-put.p   ( input this-procedure:handle
            ,input this-procedure:handle
            , input p-log-handle
            , input v-parameter
            ) no-error.


    end. /* do on error */
end procedure. /* ftp-send */
        

procedure bge-xml-write-header-check:
do
on error undo, return error
:
define input parameter p-xml-file-name  as character        no-undo.
define input parameter p-doc-name       as character        no-undo.
define input parameter p-version        as character        no-undo.
define input parameter p-db-num         as integer          no-undo.
define input parameter p-date-from      as date             no-undo.
define input parameter p-shift-num-from as integer          no-undo.
define input parameter p-date-to        as date             no-undo.
define input parameter p-shift-num-to   as integer          no-undo.
define input parameter p-obj-list       as character        no-undo.
define input parameter v-code_pool      as char             no-undo.
define input parameter p-dc-list        as char             no-undo.
define input parameter p-bonus          as logical          no-undo.
define input parameter p-doc-type-list  as character        no-undo.
define input parameter p-pay-code       as logical          no-undo.
define input parameter p-cst            as logical          no-undo.
define input parameter p-parts          as logical          no-undo.
define input parameter p-chk-pay-code   as logical          no-undo.
define input parameter p-pay-desk       as logical          no-undo.
define input parameter p-pay-desk-cards as logical          no-undo.
define input parameter p-deleted        as logical          no-undo.
define input parameter p-opened-docs    as logical          no-undo.

define variable v-out-string            as character        no-undo.

p-dc-list = right-trim (p-dc-list, ",").

if v-bge-xml-bgeflold = "old-all" then do :
  output stream stmXMLOut to value( p-xml-file-name + "xm1" ) convert target "1251" append.
end.
else do :
  output stream stmXMLOut to value( p-xml-file-name + "xm1" ) convert target "1251" .
end.
assign
    v-out-string = substitute( "&1&2&3"
                        , "<?xml version='1.0' encoding='windows-1251'?>":U
                        , {&new-line}
                        , "<IBS_Trade_House>":U )
.
/*  {&new-line} + "<?xml-stylesheet type='text/xsl' href='{&OutFileName}.xsl'?>" */

put stream stmXMLOut unformatted
    v-out-string
.
run wp-XMLTagOpen(1, "header","").
if v-bge-xml-bgeflold = "oracle":u
then do:
  run wp-XMLTagOpen in this-procedure  ( 2, "delivery", "").
  run wp-XMLTagput in this-procedure ( 3, "message","", 1).
  run wp-XMLTagput in this-procedure ( 3, "from","IBS Trade House", 1).
  run wp-XMLTagput in this-procedure ( 3, "to","Oracle Retail", 1).
  run wp-XMLTagClose in this-procedure ( 2, "delivery"    ).
end.
run wp-XMLTagOpen( 2, "manifest", "").
run wp-XMLTagOpen( 3, "document", "").
run wp-XMLTagput( 4, "name", p-doc-name, 0).
run wp-XMLTagput( 4, "description", "", 0).
run wp-XMLTagput( 4, "version", p-version, 0).
run wp-XMLTagclose( 3, "document" ).
run wp-XMLTagclose( 2, "manifest" ).
run wp-XMLTagclose( 1, "header" ).
run wp-XMLTagOpen(1, "options","").
run wp-XMLTagput( 2, "exportDate",      string( today,              "99/99/9999" ), 0).
run wp-XMLTagput( 2, "exportDateXml",   bge-xml-date( today )                     , 0).
run wp-XMLTagput( 2, "exportTime",      string( time,               "HH:MM:SS"   ), 0).
run wp-XMLTagput( 2, "baseNum",         string( p-db-num                         ), 0).
run wp-XMLTagput( 2, "dateFrom",        string( p-date-from,        "99/99/9999" ), 0).
run wp-XMLTagput( 2, "dateFromXml",     bge-xml-date( p-date-from )               , 0).
run wp-XMLTagput( 2, "shiftNumFrom",    string( p-shift-num-from                 ), 2).
run wp-XMLTagput( 2, "dateTo",          string( p-date-to,          "99/99/9999" ), 0).
run wp-XMLTagput( 2, "dateToXml",       bge-xml-date( p-date-to )                 , 0).
run wp-XMLTagput( 2, "shiftNumTo",      string( p-shift-num-to                   ), 2).
run wp-XMLTagput( 2, "objList",                 p-obj-list                        , 0).
run wp-XMLTagput( 2, "DataSetName",                 v-code_pool                       , 0).
run wp-XMLTagput( 2, "DCList",                 p-dc-list                        , 0).
run wp-XMLTagput( 2, "chkBonus",              string(p-bonus)                        , 0).
run wp-XMLTagput( 2, "docTypeList",             p-doc-type-list                   , 0).
run wp-XMLTagput( 2, "payCode",         string( p-pay-code                       ), 0).
run wp-XMLTagput( 2, "cst",             string( p-cst                            ), 0).
run wp-XMLTagput( 2, "parts",           string( p-parts                          ), 0).
run wp-XMLTagput( 2, "chkPayCode",      string( p-chk-pay-code                   ), 0).
run wp-XMLTagput( 2, "chkPayDesk",      string( p-pay-desk                       ), 0).
run wp-XMLTagput( 2, "chkPayDeskCards", string( p-pay-desk-cards                 ), 0).
run wp-XMLTagput( 2, "deletedDocs",     string( p-deleted                        ), 0).
run wp-XMLTagput( 2, "openedDocs",      string( p-opened-docs                    ), 0).
run wp-XMLTagClose(1, "options").
run wp-XMLTagOpen( 1, "body", "" ).

output stream stmXMLOut close.
end.
end procedure.