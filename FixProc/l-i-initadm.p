define variable conn-par            as character no-undo .
/* параметры для подключения к БД */
 get-key-value section "REP-SETS"
                    key "ConPar"
                  value conn-par.
  if conn-par = ?
  or trim( conn-par ) = ""
  then do:
    return error "Не указаны параметры подключения к БД (секция REP-SETS ключ ConPar в .ini файле)." .
  end.

  define variable v-connect-option as character no-undo .
  define temp-table PasSysAdm
    field fLogin as character  
    field num as int64 init ?
    field pasw as character
    
 index num flogin num pasw
 .
 
  
  {utl\crpwd.i}
  
  block-login:
  for each pasSysadm where pasSysadm.Flogin eq "sysadm"
  no-lock:
     v-connect-option = substitute('-U &1 -P &2':u
                                 ,pasSysadm.Flogin
                                 ,pasSysadm.pasw
                                 ).
     define variable ttt as character no-undo.
     ttt = substitute(conn-par, v-connect-option, v-connect-option).
    connect value( substitute(conn-par, v-connect-option, v-connect-option) ) no-error. 
    
     if not error-status :error
     then do:
        leave block-login.
     end.
  end.
  if available pasSysadm
  then do:
     /* find first sys-ctrl no-lock.
     create alias dictdb    for database value( ldbname( "ub":U ) ) . */
     message "ok"
     view-as alert-box.
    run adm\initadm.p(yes,yes).
    delete alias dictdb.
  end.
  else do:
    message "пароль не удалось подобрать"
    view-as alert-box.
  end.
     