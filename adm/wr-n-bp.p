/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

запись следующего по расписанию задани

Автор: Уханов Дмитрий Юрьевич
Дата создания: 03/22/03
Author: Dmitry Ukhanov
Creation date: 03/22/03

*/
define input parameter parparentproc   as handle    no-undo .
define input parameter p-session-begin as logical   no-undo .
define input parameter p-task-type     as character no-undo .
define input parameter p-db-num        as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "запись следующего по расписанию задания".
{ cmp/vssrevis.i }
{ adm/auto-def.i }
{ adm/schedule.i }
{ gbl/db-attr.i  }
{ adm/push-m.i "with-attr-code" }

do
on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
on stop   undo, return error substitute( "&1. stop", vss-workfile )
on endkey undo, return error substitute( "&1. endkey", vss-workfile )
:
  define buffer buf_BatchProcess for ub.BatchProcess .
  define buffer buf_db           for ub.db .
  define buffer buf_sys-ctrl     for ub.sys-ctrl .

  define variable v-str                 as character no-undo .
  define variable v-db-wait             as character no-undo .
  define variable num-entries-v-db-wait as integer   no-undo .
  define variable v-db-list             as character no-undo .
  define variable num-entries-v-db-list as integer   no-undo .
  define variable v-db-num              as character no-undo .
  define variable ind                   as integer   no-undo .
  define variable v-date                as date      no-undo .
  define variable v-time                as integer   no-undo .
  define variable v-user-id             as character no-undo .
  define variable v-recid               as recid     no-undo .
  define variable db-attr-code          as character no-undo .
  define variable db-attr-value         as character no-undo .
  define variable db-attr-type          as character no-undo .
  define variable db-attr-exist         as logical   no-undo .

  if transaction = true then do:
    message
      vss-workfile vss-revision vss-description skip
      substitute( "Вызов данной процедуры не возможен при наличии транзакции" )
      view-as alert-box error
    .
    return error substitute( "&1. Вызов данной процедуры не возможен при наличии активной транзакции.", vss-workfile ).
  end.

  assign
    v-str        = get-str-type( p-task-type )
    db-attr-code = get-attr-code( p-task-type )
  .
  if v-str = ? then do:
    return error string( vss-workfile + {&space-char} + "НЕТ ОБРАБОТКИ АТРИБУТА" + {&space-char} + p-task-type ) .
  end.

  run trans-task( input p-task-type ) no-error.
  if error-status:error then do:
    run write-to-log( vss-workfile + {&space-char}
                      + "Ошибка при выполнении процедуры преобразования расписания." + {&new-line}
                      + error-status:get-message(error-status:num-messages) + {&new-line}
                      + return-value
                    ) .
    return error.
  end.

  assign
    v-db-wait = "":U
  .
  if p-db-num <> "*":U then do:
    assign
      v-db-list = p-db-num
    .
  end.
  else do:
    assign
      v-db-list = "":U
    .
  end.

  find first buf_sys-ctrl no-lock.

  if p-task-type = {&btpr-type-autonws}
     and buf_sys-ctrl.db-num <> 0
  then do:
    run db-attr-value ( input 0
                       ,input db-attr-code
                       ,output db-attr-value
                       ,output db-attr-type
                      ) no-error.
    if error-status :error then do:
      run write-to-log( vss-workfile + {&space-char}
                        + "Ошибка при чтении атрибута наличия расписания для БД" + {&space-char} + v-db-num
                      ) .
    end.
    if v-db-list = "":U then do:
      if db-attr-value = "no":U then do:
        assign
          v-db-list = "0":U
        .
      end.
      else do:
        assign
          v-db-wait = "0":U
        .
      end.
    end.
  end.
  else do:
    _db:
    for each buf_db no-lock
    on error  undo, return error substitute( "&1 (for each db). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
    on stop   undo, return error substitute( "&1 (for each db). stop", vss-workfile )
    on endkey undo, return error substitute( "&1 (for each db). endkey", vss-workfile )
    :
      if p-task-type = {&btpr-type-autonws}
         and ( buf_db.db-num = 0
               or buf_db.db-key = "":U
               or buf_db.db-key = ?
             )
      then do:
        next.
      end.
      if (p-task-type = {&btpr-type-autosale}
      or p-task-type = {&btpr-type-autogetcd}
      or p-task-type = {&btpr-type-autocbnk}
      or p-task-type = {&btpr-type-autooxml}
      or p-task-type = {&btpr-type-autosuz}
      or p-task-type = {&btpr-type-autofree}
      /*гюнтнер согласен и извещен*/
      )
         and buf_db.db-num <> buf_sys-ctrl.db-num
      then do:
        next _db.
      end.
      run db-attr-value ( input buf_db.db-num
                         ,input db-attr-code
                         ,output db-attr-value
                         ,output db-attr-type
                        ) no-error.
      if error-status :error then do:
        run write-to-log( vss-workfile + {&space-char}
                          + "Ошибка при чтении атрибута наличия расписания для БД" + {&space-char} + v-db-num
                        ) .
      end.
      if lookup( string( buf_db.db-num ), v-db-list, {&comma-char} ) = 0 then do:
        if p-db-num = "*":U
          or db-attr-value = "no":U
        then do:
          if v-db-list = "":U then do:
            assign
              v-db-list = string( buf_db.db-num )
            .
          end.
          else do:
            assign
              v-db-list = v-db-list + {&comma-char} + string( buf_db.db-num )
            .
          end.
        end.
        else do:
          if v-db-wait = "":U then do:
            assign
              v-db-wait = string( buf_db.db-num )
            .
          end.
          else do:
            assign
              v-db-wait = v-db-wait + {&comma-char} + string( buf_db.db-num )
            .
          end.
        end.
      end.
    end.
  end.

  assign
    num-entries-v-db-list = num-entries( v-db-list )
  .
  do ind = 1 to num-entries-v-db-list
  on error  undo, return error substitute( "&1 (v-db-list). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo, return error substitute( "&1 (v-db-list). stop", vss-workfile )
  on endkey undo, return error substitute( "&1 (v-db-list). endkey", vss-workfile )
  :
    assign
      v-db-num = entry( ind, v-db-list )
      v-recid  = ?
    .

    if v-db-num = "*":U
      or v-db-num = "":U
    then do:
      next.
    end.

    run cur-time ( output v-date
                  ,output v-time
                 ).

    find first curr-task no-lock
      where curr-task.task-type = p-task-type
        and curr-task.db-num    = v-db-num
        and curr-task.task-date = v-date
        and curr-task.task-time > v-time
      no-error
    .
    if not available curr-task then do:
      find first curr-task no-lock
        where curr-task.task-type = p-task-type
          and curr-task.db-num    = v-db-num
          and curr-task.task-date > v-date
        no-error
      .
    end.

    do transaction
    on error  undo, return error substitute( "&1 (do transaction). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
    on stop   undo, return error substitute( "&1 (do transaction). stop", vss-workfile )
    on endkey undo, return error substitute( "&1 (do transaction). endkey", vss-workfile )
    :
      find first buf_BatchProcess exclusive-lock
        where buf_BatchProcess.BP_Status   = {&btpr-normal}
          and buf_BatchProcess.BP_Type     = p-task-type
          and buf_BatchProcess.CharKey_One = v-db-num
          and buf_BatchProcess.CharKey_Two = "auto":U
        no-error
      .

      run db-attr-exist ( input v-db-num
                        ,input  db-attr-code
                        ,output db-attr-exist
                        ) no-error.
      if error-status :error then do:
        run write-to-log( vss-workfile + {&space-char}
                          + "Ошибка при определении наличия атрибута расписания для БД" + {&space-char} + v-db-num
                        ) .
      end.
      run db-attr-value ( input  v-db-num
                        ,input  db-attr-code
                        ,output db-attr-value
                        ,output db-attr-type
                        ) no-error.
      if error-status :error then do:
        run write-to-log( vss-workfile + {&space-char}
                          + "Ошибка при чтении атрибута наличия расписания для БД" + {&space-char} + v-db-num
                        ) .
      end.

      if not available curr-task then do:
        if db-attr-value = "yes":U
          or db-attr-exist = false
          or p-session-begin = true
        then do:
          run write-to-log( substitute( "Для БД &1 не составлено расписание!", v-db-num ) ).
          run db-attr-write ( input v-db-num
                            ,input db-attr-code
                            ,input no
                            ) no-error.
          if error-status :error then do:
            run write-to-log( substitute( "&1. Ошибка при записи атрибута отсутствия расписания для БД &2"
                                        ,vss-workfile
                                        ,v-db-num
                                        )
                            ) .
          end.
        end.
        if available buf_BatchProcess
          and ( buf_BatchProcess.BP_ExecSysDate < v-date
                or ( buf_BatchProcess.BP_ExecSysDate = v-date
                    and buf_BatchProcess.BP_ExecSysTimeInt < v-time
                  )
              )
        then do:
          delete buf_BatchProcess.
        end.
        next.
      end.

      run get-userid in parparentproc
        ( output v-user-id
        ).

      if not available buf_BatchProcess then do:
        create buf_BatchProcess.
        assign
          buf_BatchProcess.BatchProcess# = next-value (s-btpr, {&db-name_schema})
          buf_BatchProcess.BP_Type       = p-task-type
          buf_BatchProcess.BP_Status     = {&btpr-normal}
          buf_BatchProcess.CharKey_One   = v-db-num
          buf_BatchProcess.CharKey_Two   = "auto":U
        .
      end.
      assign
        buf_BatchProcess.CharKey_Three     = substitute( "&1&2&3&2&4", buf_sys-ctrl.db-num, {&delim-key}, curr-task.task-type, curr-task.task-num )
        buf_BatchProcess.User_ID           = v-user-id
        buf_BatchProcess.Key#_One          = 0
        buf_BatchProcess.BP_SysDate        = v-date
        buf_BatchProcess.BP_SysTimeInt     = v-time
        buf_BatchProcess.BP_SysTime        = string(v-time, 'HH:MM:SS':U)
        buf_BatchProcess.BP_ExecSysDate    = curr-task.task-date
        buf_BatchProcess.BP_ExecSysTimeInt = curr-task.task-time
        buf_BatchProcess.BP_ExecSysTime    = string(curr-task.task-time, 'HH:MM:SS':U)
      .

      run write-to-log( "Следующий сеанс" + {&space-char} + v-str
                        + {&space-char} + v-db-num
                        + {&space-char} + "после" + {&space-char} + buf_BatchProcess.BP_ExecSysTime
                        + {&space-char} + string( buf_BatchProcess.BP_ExecSysDate , "99.99.9999" )
                      ) .
      run db-attr-write ( input v-db-num
                        ,input db-attr-code
                        ,input "yes":U
                        ) no-error.
      if error-status :error then do:
        run write-to-log( vss-workfile + {&space-char}
                          + "Ошибка при записи атрибута наличия расписание для БД" + {&space-char} + v-db-num
                        ) .
      end.
    end.
  end.

  if p-session-begin = true then do:
    assign
      num-entries-v-db-wait = num-entries( v-db-wait )
    .
    do ind = 1 to num-entries-v-db-wait
    on error  undo, return error substitute( "&1 (v-db-wait). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
    on stop   undo, return error substitute( "&1 (v-db-wait). stop", vss-workfile )
    on endkey undo, return error substitute( "&1 (v-db-wait). endkey", vss-workfile )
    :
      find first buf_BatchProcess no-lock
        where buf_BatchProcess.BP_Status   = {&btpr-normal}
          and buf_BatchProcess.BP_Type     = p-task-type
          and buf_BatchProcess.CharKey_One = entry( ind, v-db-wait )
          and buf_BatchProcess.CharKey_Two = "auto":U
        no-error
      .
      if available buf_BatchProcess then do:
        run write-to-log( "Очередной сеанс" + {&space-char} + v-str
                          + {&space-char} + entry( ind, v-db-wait )
                          + {&space-char} + "после" + {&space-char} + buf_BatchProcess.BP_ExecSysTime
                          + {&space-char} + string( buf_BatchProcess.BP_ExecSysDate , "99.99.9999" )
                        ) .
      end.
    end.
  end.

  for each buf_db no-lock
  on error  undo, return error substitute( "&1 (for each db 2). &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo, return error substitute( "&1 (for each db 2). stop", vss-workfile )
  on endkey undo, return error substitute( "&1 (for each db 2). endkey", vss-workfile )
  :
    find first buf_BatchProcess exclusive-lock
      where buf_BatchProcess.BP_Status   = {&btpr-normal}
        and buf_BatchProcess.BP_Type     = p-task-type
        and buf_BatchProcess.CharKey_One = string( buf_db.db-num )
        and buf_BatchProcess.CharKey_Two = "auto":U
      no-error
    .
    if available buf_BatchProcess
      and lookup( string(buf_db.db-num), v-db-list ) = 0
      and lookup( string(buf_db.db-num), v-db-wait ) = 0
    then do:
      delete buf_BatchProcess.
    end.
  end.

end.

return.

/* $Workfile$ end */