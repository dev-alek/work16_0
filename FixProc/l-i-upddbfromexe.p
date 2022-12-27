/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 8 мая 2022 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 8 мая 2022 г.

*/
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ utl/search.i }

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
 
  
  {utlcomp\crpwd.i}
  
  block-login:
  for each pasSysadm where pasSysadm.Flogin eq "sysadm"
  no-lock:
     v-connect-option = substitute('-U &1 -P &2':u
                                 ,pasSysadm.Flogin
                                 ,pasSysadm.pasw
                                 ).
     define variable mConPar as character no-undo.
     mConPar = substitute(conn-par, v-connect-option, v-connect-option).
    connect value( substitute(conn-par, v-connect-option, v-connect-option) ) no-error. 
    
     if not error-status :error
     then do:
        leave block-login.
     end.
  end.
  if available pasSysadm
  then do:
     current-window:hidden = yes. 
     define variable mAsyncHelper as ibs.th.file.AsyncHelperth no-undo.
     mAsyncHelper = new ibs.th.file.AsyncHelperth().
     mAsyncHelper:mProcPublish = this-procedure.    /* хандел для публикации событий */
     mAsyncHelper:conpar = "".                      /* уберем подключение */
     mAsyncHelper:MyBachMode = session:batch-mode.  /* установка батч режима */
     mAsyncHelper:MyBachMode = yes. 
     mAsyncHelper:DbConnect = no.   
     mAsyncHelper:AsyncProc("ubexeupd","utl/proc-upddbfromexe", substitute ("&2&1&3",{&delim-par},mConPar,session:parameter),1).
     disconnect value ('ub').
     run ibs\th\file\waithelper.p (mAsyncHelper,?, 1,"Обновление БД по структуре болванки.").
    
      define variable mlogfile as character no-undo. 
      define stream  sReadfile.
      define variable mText as character no-undo.
      define variable mError as logical no-undo.  
      mlogfile = mAsyncHelper:getLog(?).
      if SearchFile(mlogfile) ne ?
      then do:
         input stream sReadfile FROM  VALUE(SearchFile(mlogfile)).
         output to "ubCompareExe.txt".
         repeat:
            import stream sReadfile unformatted mText.
            put unformatted mText skip.
            define variable vtext1 as character no-undo.
            define variable vtext3 as character no-undo.
            define variable vErrorText as character no-undo.
            if not mError
            then do:
               assign
                  vtext1 = entry(1,mText," ")
                  vtext3 = entry(3,mText," ")
               no-error.
               if    vtext1 = "error"
                  or vtext3 = "error"
               then do:
                  mError = yes.
                  vErrorText = mText.
               end.
            end.
         end.
         output close.
         input stream sReadfile close  .
         os-delete value(SearchFile(mlogfile)).
         os-command no-wait value (SearchFile("ubCompareExe.txt")).
         if mError
         then
            message "Произошла ошибка при обновление БД":U skip vErrorText
            view-as alert-box. 
      end.
      if session:system-alert-boxes
      then
         message "Результаты выполнения находятся в " mAsyncHelper:SaveArh() skip
                 "Лог выполнения сохранен в " SearchFile("ubCompareExe.txt")
            view-as alert-box.
      else
         message "Лог выполнения сохранен в " SearchFile("ubCompareExe.txt")
         view-as alert-box.
      delete object mAsyncHelper.
     
  /*  run adm\initadm.p(yes,yes). */
    
  end.
  else do:
    message "пароль не удалось подобрать"
    view-as alert-box.
  end.
  quit.   