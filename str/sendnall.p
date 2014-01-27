/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Посылка всей информации на все магазины БД из новостей
написан для того, чтобы  не закрывтаь окно diallog.w при  вызове send-gds.p по каждому объекту

Автор: Бахтадзе Наталья Викторовна
Дата создания: 02/16/04
Author: Bakhtadze Natalya
Creation date: 02/16/04

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-parameter   as character no-undo .

/*
p-parameter включает
define input parameter p-db-num like ub.db.db-num no-undo .
*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Посылка всей информации на все магазины БД из новостей".
{ cmp/vssrevis.i }

{ cmp/trg-def.i }
define variable p-db-num like ub.db.db-num no-undo .

{ str/defc-txn.i "shared" }
{ str/defc-txr.i "shared" }
{ cmp/gds-list.i gds-list def "shared" }
{ cmp/gdsolist.i gdsolist def "shared" }
{ cmp/pbc-list.i pbc-list def  }
{ cmp/bc-list.i bc-list def  }
{ cmp/dc-list.i  dc-list  def "shared" }
{ cmp/stpllist.i stpl-list  def "shared" }
{ str/defc-cli.i "new shared" }
{ str/pdf-list.i pdf-list def "shared" }



define buffer buf_clients for ub.clients.
define buffer buf_shop for ub.shop.
define buffer buf_cash-desk for ub.cash-desk.

assign
p-db-num = integer(entry(1, p-parameter, {&delim-par}))
no-error
.
if error-status:error then return error.

if can-find(first gds-list no-lock)
or can-find(first gdsolist no-lock) then do:
  for each buf_clients no-lock
      where buf_clients.obj-type = {&shop}
        and buf_clients.db-num   = p-db-num,
      first buf_cash-desk no-lock where
           buf_cash-desk.db-num = p-db-num
       AND buf_cash-desk.obj-code = buf_clients.obj-code
       AND buf_cash-desk.cash-on = yes
  on error undo, return error
  :
    for each gdsolist no-lock where
            gdsolist.obj-type = buf_clients.obj-type
        and gdsolist.obj-code = buf_clients.obj-code:
        find first gds-list where
                  gds-list.gds-code = gdsolist.gds-code no-error .
        if avail gds-list then NEXT.
        if not avail gds-list then do:
          find first ub.goods no-lock where
                    ub.goods.gds-code = gdsolist.gds-code no-error .
          create gds-list.
          buffer-copy ub.goods to gds-list.
        end.
        if avail gds-list then
        assign
        /*сигнал для send-gds.p чтобы стер эту запись*/
        gds-list.qnty = -1
        .
    END.
    run set-title in p-log-handle (
          input "Отправка товаров на кассу"
                                   ).
    run str/send-gds.p (
                    input parparentproc
                  ,input p-parent-handle
                  ,input p-log-handle
                  ,input (string(buf_clients.obj-code) + {&delim-par} + "no":U)
                    ) no-error .
    if error-status:error then
    return error substitute( "ошибка при отправке товаров на кассу по магазину &1&2&3&2&4"
                            , buf_clients.obj-code
                            , {&new-line}
                            , error-status:get-message(1)
                            , return-value
                            ).
  end.
end.

if can-find(first bc-list no-lock) then do:
  for each buf_clients no-lock
      where buf_clients.obj-type = {&shop}
        and buf_clients.db-num   = g#db-num,
      first buf_cash-desk no-lock where
           buf_cash-desk.db-num = p-db-num
       AND buf_cash-desk.obj-code = buf_clients.obj-code
       AND buf_cash-desk.cash-on = yes
  on error undo, return error
  :
    run set-title in p-log-handle (
         input 'Удаление бар-кодов с кассы'
                                   ).
    run str/send-bcn.p (
                    input parparentproc
                   ,input p-parent-handle
                  ,input p-log-handle
                  ,input (string(buf_clients.obj-code) + {&delim-par} + "D":U)
                    ) no-error .
    if error-status:error then do:
      return error substitute( "ошибка при удалении бар-кодов с кассы магазина &1&2&3&2&4"
                            , buf_clients.obj-code
                            , {&new-line}
                            , error-status:get-message(1)
                            , return-value

      ).
    end.
    run set-title in p-log-handle (
         input 'Отправка бар-кодов на кассу'
                                   ).
    run str/send-bcn.p (
                    input parparentproc
                  ,input p-parent-handle
                  ,input p-log-handle
                  ,input (string(buf_clients.obj-code) + {&delim-par} + "U":U)
                    ) no-error .
    if error-status:error then do:
      return error substitute( "ошибка при отправке бар-кодов на кассы магазина &1&2&3&2&4"
                            , buf_clients.obj-code
                            , {&new-line}
                            , error-status:get-message(1)
                            , return-value

        ).
    end.
  end.
end.
if can-find(first pbc-list no-lock) then do:
    for each buf_clients no-lock
      where buf_clients.obj-type = {&shop}
        and buf_clients.db-num   = p-db-num,
      first buf_cash-desk no-lock where
           buf_cash-desk.db-num = p-db-num
       AND buf_cash-desk.obj-code = buf_clients.obj-code
       AND buf_cash-desk.cash-on = yes
  on error undo, return error
  :
    run set-title in p-log-handle (
          input 'Удаление ДопБК с кассы'
                                    ).
    run str/s-prdbcn.p (
                    input parparentproc
                  ,input p-parent-handle
                  ,input p-log-handle
                  ,input (string(buf_clients.obj-code) + {&delim-par} + "D":U)
                    ) no-error .
    if error-status:error then do:
      return error substitute( "ошибка при удалении ДопБК с кассы магазина &1&2&3&2&4"
                            , buf_clients.obj-code
                            , {&new-line}
                            , error-status:get-message(1)
                            , return-value
         ).
    end.
    run str/s-prdbcn.p (
                    input parparentproc
                  ,input p-parent-handle
                  ,input p-log-handle
                  ,input (string(buf_clients.obj-code) + {&delim-par} + "U":U)
                    ) no-error .
    if error-status:error then do:
      return error substitute( "ошибка при отправке ДопБК на кассы магазина &1&2&3&2&4"
                            , buf_clients.obj-code
                            , {&new-line}
                            , error-status:get-message(1)
                            , return-value
         ).
    end.
  end.
end.
if can-find(first cash-txn no-lock)
  or can-find(first cash-txr no-lock)
then do:
    run set-title in p-log-handle (
          input 'Отправка налогов на кассу'
                                    ).
  for each buf_clients no-lock
      where buf_clients.obj-type = {&shop}
        and buf_clients.db-num   = p-db-num,
      first buf_cash-desk no-lock where
           buf_cash-desk.db-num = p-db-num
       AND buf_cash-desk.obj-code = buf_clients.obj-code
       AND buf_cash-desk.cash-on = yes
  on error undo, return error
  :
    run str/sendtaxn.p (
                    input parparentproc
                  ,input p-parent-handle
                  ,input p-log-handle
                  ,input (string(buf_clients.obj-code) + {&delim-par} + "U":U)
                  ) no-error.
    if error-status:error then do:
      return error substitute( "ошибка при отправке налогов на кассы магазина &1&2&3&2&4"
                            , buf_clients.obj-code
                            , {&new-line}
                            , error-status:get-message(1)
                            , return-value

         ).
    end.
  end.
end.
if can-find(first dc-list no-lock) then do:
    run set-title in p-log-handle (
          input 'Отправка информации по клиентским картам на кассу'
                                    ).
    for each buf_clients no-lock
      where buf_clients.obj-type = {&shop}
        and buf_clients.db-num = p-db-num
  ,each buf_shop no-lock
      where buf_shop.obj-code = buf_clients.obj-code
    break by buf_shop.host-code
  on error undo, return error
  :
    if first-of(buf_shop.host-code) then do:
      run str/send-cli.p (
                    input parparentproc
                   ,input p-parent-handle
                   ,input p-log-handle
                   ,input (string(buf_clients.obj-code) + {&delim-par} + "U":U +
                           {&delim-par} + "no":U + {&delim-par} + "no":U )
                     ) no-error .
      if error-status:error then do:
        return error substitute( "ошибка при отправке информации по клиентским картам на кассы магазина &1&2&3&2&4"
                            , buf_clients.obj-code
                            , {&new-line}
                            , error-status:get-message(1)
                            , return-value
           ).
      end.
    end.
  end.
end.
if can-find(first stpl-list no-lock where stpl-list.classif-type = {&table_dis-card}) then do:
  for each stpl-list no-lock where
          stpl-list.classif-type = {&table_dis-card}:
    run str/snd-stpl.p (
                      input parparentproc
                      ,input p-parent-handle
                      ,input p-log-handle
                      ,input stpl-list.stop-list-code
                      ) no-error .
    if error-status:error then do:
      return error substitute( "ошибка при отправке информации по стоплистам на кассы &1&2&1&3"
                          , {&new-line}
                          , error-status:get-message(1)
                          , return-value
          ).
    end.
  end.
end.
if can-find (first  pdf-list ) then do:
  run str/sendpdfr.p (
                       input parparentproc
                      ,input this-procedure:handle
                      ,input p-log-handle
                      ,input "N"
                      ) no-error.
end.

procedure sendnall_get-pdf : /*callback*/
define input-output parameter p-ii as integer no-undo .
define output parameter p-plt-id as integer no-undo .
define output parameter p-plt-db-num as integer no-undo .
define output parameter p-pdf-id as integer no-undo .
define output parameter p-pdf-db-num as integer no-undo .
define output parameter p-del as logical no-undo .

find first pdf-list where
          pdf-list.order-num > p-ii no-error.
if available pdf-list then do:
   assign
   p-plt-id = pdf-list.plt-id
   p-plt-db-num = pdf-list.plt-db-num
   p-pdf-id = pdf-list.pdf-id
   p-pdf-db-num = pdf-list.pdf-db
   p-ii = pdf-list.order-num
   p-del = pdf-list.to-del
   .
end.
end procedure. /* get-pdf */