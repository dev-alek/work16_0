/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Триггер на запись goods-attr

Автор: Бахтадзе Наталья Викторовна
Дата создания: 04/12/04
Author: Bakhtadze Natalya
Creation date: 04/12/04

*/

TRIGGER PROCEDURE FOR WRITE OF ub.goods-attr OLD old-goods-attr .
 
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Триггер на запись атрибутов товара".
{ cmp/vssrevis.i "substitute('&1|&2', ub.goods-attr.gds-code, ub.goods-attr.attr-code) " }

{ cmp/trg-def.i }
{ ref/gds-attr.i }
{ gbl/cur-time.i }
{ nws/lib-nws.i }

define variable p-news as logical no-undo.
define variable v-date as date no-undo .
define variable v-time as integer no-undo .
define variable v-manual-editing as integer no-undo .
define buffer buf_goods for ub.goods.
define buffer buf_c-goods-attr for ub.c-goods-attr.
define buffer buf_c-goods-attr-any for ub.c-goods-attr-any.
define buffer buf_c-gds-hist for ub.c-gds-hist.
define buffer locked_goods-attr for ub.goods-attr.

main-block:
do
on error  undo main-block, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
on stop   undo main-block, return error substitute( "&1. stop", vss-workfile )
on endkey undo main-block, return error substitute( "&1. endkey", vss-workfile )
:
  if not ub.goods-attr.attr-code = {&attr-gds-attr-lock} then do:

    run gds-attr-manual-edit in this-procedure (
                                                    input ub.goods-attr.attr-code
                                                    ,output v-manual-editing
                                                    ) no-error .
    if not error-status:error
    and v-manual-editing > 0 then do:
       Find first locked_goods-attr exclusive-lock  where
                  locked_goods-attr.gds-code = ub.goods-attr.gds-code
              and locked_goods-attr.attr-code = {&attr-gds-attr-lock}
        no-error no-wait.
        if locked locked_goods-attr then
           undo main-block, return error substitute("&1&2Атрибут товара &3 &4 занят"
                                              , {&attr-gds-attr-lock}
                                              , {&delim-par}
                                              , ub.goods-attr.attr-code
                                              , ub.goods-attr.gds-code
                                                 ).

    end.
    if lookup( ub.goods-attr.attr-code,  {&struct-attr-list}) > 0
    then do:
      find first buf_goods no-lock where buf_goods.gds-code = ub.goods-attr.gds-code no-error.
      if available buf_goods then do:
             { ref/scgdsupd.i buf_goods " " " " ?  ub.goods-attr.attr-code }
      end.
      
    end.
    if g#news then do:
      define variable v-send as integer no-undo .
      v-send = integer({&hn-is-on}).
      { gbl/get-hn.i
      g#db-num
      {&table_goods-attr}
      0
      '':U
      0
      '':U
      '':U
      '':U
      0
      0
      0
      {&nws-to-hist}
      v-send
      no-error
      }
    end.
    if not g#news
    or v-send >= 0 then do:
      run cur-time in this-procedure(output v-date, output v-time).
      create buf_c-goods-attr.
      buffer-copy old-goods-attr to buf_c-goods-attr
      assign
      buf_c-goods-attr.gds-code           = ub.goods-attr.gds-code
      buf_c-goods-attr.chip-num           = next-value (s-gds-chip, {&db-name_schema})
      buf_c-goods-attr.attr-code          = ub.goods-attr.attr-code
      buf_c-goods-attr.corr-time          = v-time
      buf_c-goods-attr.corr-user-db-num   = g#db-num
      buf_c-goods-attr.corr-user-name     = (if g#news
                                      then {&nts-user}
                                      else (if g#esys
                                            then {&esys-user}
                                            else g#userid)
                                      )
      buf_c-goods-attr.corr-date          = v-date 
      .
      create buf_c-gds-hist.
      buffer-copy buf_c-goods-attr to buf_c-gds-hist
      assign
      buf_c-gds-hist.action = (if new ub.goods-attr then integer({&hn-create}) else integer({&hn-update}))
      buf_c-gds-hist.subject = {&table_goods-attr}
      buf_c-gds-hist.is-news = g#news
      buf_c-gds-hist.source-type = (if g#news
                                  then {&hn-source-db}
                                  else (if g#esys
                                        then {&hn-source-esys}
                                        else "":U)
                                  )
      buf_c-gds-hist.source-ref = (if g#news
                                  then string(g#news-source-db)
                                  else (if g#esys
                                        then string(g#esys-source-esys)
                                        else "":U)
                                  )
      .
      if    ub.goods-attr.attr-code eq "operservid"
         or ub.goods-attr.attr-code eq "cashbookid"
      then do:
         if     ub.goods-attr.attr-value ne ""
            and ub.goods-attr.attr-value ne ?
         then do:
            create buf_c-goods-attr-any.
            buffer-copy goods-attr to buf_c-goods-attr-any
            assign
               buf_c-goods-attr-any.gds-code           = ub.goods-attr.gds-code
               buf_c-goods-attr-any.Bush               = if ub.goods-attr.attr-code eq "operservid"
                                                         then
                                                            "operserv"
                                                         else
                                                            "cashbook"
               buf_c-goods-attr-any.chip-num           = if ub.goods-attr.attr-code eq "operservid"
                                                         then
                                                            next-value (s-c-operserv-chip-num, {&db-name_schema})
                                                         else
                                                            next-value (s-c-cashbook-chip-num, {&db-name_schema})   
               buf_c-goods-attr-any.attr-code          = ub.goods-attr.attr-code
               buf_c-goods-attr-any.corr-time          = v-time
               buf_c-goods-attr-any.corr-user-db-num   = g#db-num
               buf_c-goods-attr-any.corr-user-name     = (if g#news
                                                          then {&nts-user}
                                                          else (if g#esys
                                                          then {&esys-user}
                                                          else g#userid)
                                                         )
               buf_c-goods-attr-any.corr-date          = v-date
               buf_c-goods-attr-any.action             = {&bef-hn-create}
            .
            if ub.goods-attr.attr-code eq "cashbookid"
            then do:
               create c-cashbook-head.
               buffer-copy  buf_c-goods-attr-any to c-cashbook-head
               assign
                  c-cashbook-head.subject = "c-goods-attr-any"
                  c-cashbook-head.cashbookid     = int64(buf_c-goods-attr-any.attr-value)
                  c-cashbook-head.is-news = g#news
                  c-cashbook-head.source-type = (if g#news
                                                 then {&hn-source-db}
                                                 else (if g#esys
                                                 then {&hn-source-esys}
                                                 else "":U)
                                                ) 
                  c-cashbook-head.source-ref = (if g#news
                                                then string(g#news-source-db)
                                                else (if g#esys
                                                then string(g#esys-source-esys)
                                                else "":U)
                                               )

               .
            end.
         end.
      end.
      if    ub.old-goods-attr.attr-code eq "operservid"
         or ub.old-goods-attr.attr-code eq "cashbookid"
      then do:
         if     ub.old-goods-attr.attr-value ne ""
            and ub.old-goods-attr.attr-value ne ?
         then do:
            create buf_c-goods-attr-any.
            buffer-copy old-goods-attr to buf_c-goods-attr-any
            assign
               buf_c-goods-attr-any.gds-code           = ub.old-goods-attr.gds-code
               buf_c-goods-attr-any.Bush               = if ub.old-goods-attr.attr-code eq "operservid"
                                                         then
                                                            "operserv"
                                                         else
                                                            "cashbook"
               buf_c-goods-attr-any.chip-num           = if ub.old-goods-attr.attr-code eq "operservid"
                                                         then
                                                            next-value (s-c-operserv-chip-num, {&db-name_schema})
                                                         else
                                                            next-value (s-c-cashbook-chip-num, {&db-name_schema})   
               buf_c-goods-attr-any.attr-code          = ub.old-goods-attr.attr-code
               buf_c-goods-attr-any.corr-time          = v-time
               buf_c-goods-attr-any.corr-user-db-num   = g#db-num
               buf_c-goods-attr-any.corr-user-name     = (if g#news
                                                          then {&nts-user}
                                                          else (if g#esys
                                                  then {&esys-user}
                                                  else g#userid)
                                            )
               buf_c-goods-attr-any.corr-date          = v-date
               buf_c-goods-attr-any.action             = {&bef-hn-delete}
            .
            if ub.goods-attr.attr-code eq "cashbookid"
            then do:
               create c-cashbook-head.
               buffer-copy  buf_c-goods-attr-any to c-cashbook-head
               assign
                  c-cashbook-head.subject = "c-goods-attr-any"
                  c-cashbook-head.cashbookid      = int64(buf_c-goods-attr-any.attr-value)
                  c-cashbook-head.is-news = g#news
                  c-cashbook-head.source-type = (if g#news
                                                 then {&hn-source-db}
                                                 else (if g#esys
                                                 then {&hn-source-esys}
                                                 else "":U)
                                                ) 
                  c-cashbook-head.source-ref = (if g#news
                                                then string(g#news-source-db)
                                                else (if g#esys
                                                then string(g#esys-source-esys)
                                                else "":U)
                                               )

               .
            end.
         end.
      end.
    if ub.goods-attr.attr-code = {&attr-mark-type} and ub.goods-attr.attr-value <> "not-type" and 
       ub.goods-attr.attr-value <> "" then 
         do:
{ str/promoMark.i }
         end.    
    end.
    run gds-attr-news in this-procedure(input ub.goods-attr.attr-code,
                                        output p-news) no-error.
    if p-news then do:
      run str/callnews.p
        ( input {&table_goods-attr}
        ,input (buffer ub.goods-attr:handle )
        ) .
    end.

    if g#oxml = yes
    then do:
      run str/calloxml.p (
            input {&nwsdochs_action_update}
          , input {&table_goods-attr}
          , input ( buffer ub.goods-attr:handle )
      ) no-error.
      if error-status :error
      then do:
          undo, return error substitute( "&2&1Ошибка при отправке записи в систему OpenXML&1&3&1&4"
                              , {&new-line}
                              , vss-workfile
                              , return-value
                              , error-status :get-message ( 1 ) ).
      end.
    end.
  end.
end.