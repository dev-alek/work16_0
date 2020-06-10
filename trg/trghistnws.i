&if defined(trghistnwsdef) eq 0
&then
&glob trghistnwsdef
{ cmp/vssrevis.i }

{ cmp/trg-def.i  } 
{ cmp/str-glbl.i } /* &db-name_schema, &hn-delete */
{ gbl/cur-time.i } /* cur-time() */
{gbl/key-rec.i}
&if defined(nobufhist) eq 0
&then
define buffer buf_c-{&main-tbl}  for ub.c-{&main-tbl} .
&endif

define variable v-date      as date      no-undo .
define variable v-time      as integer   no-undo .
define variable v-field-chg as character no-undo .
define variable v-Seq       as int64     no-undo init ?.
define variable vFlagseq    as logical no-undo.
define variable vuniq-key-rec as character no-undo.
define variable v-rowid as rowid no-undo.
define variable v-tbl-name as character no-undo.
&endif
&if defined (histheadtbl) ne 0 and defined (buf_head) eq 0
&then
&glob buf_head
define buffer buf_{&histheadtbl} for ub.{&histheadtbl} .
&endif
&if defined(hist) ne 0
&then
  &if defined(del) eq 0
  &then
      buffer-compare new-{&main-tbl} to old-{&main-tbl} case-sensitive save result in v-field-chg.
      if v-field-chg > "":U then . else return .
      
      run cur-time in this-procedure (output v-date, output v-time).
    publish "getNextseq" ("{&main-tbl}","{&seqnamehist}", "{&db-name_schema}", output v-Seq ).
    if v-Seq = ?
    then 
       v-Seq  = next-value ({&seqnamehist}, {&db-name_schema}).
    else
       vFlagSeq = yes.
  
    /* пишем историю */
    if vFlagSeq
    then do:
       run gen-key-rec in this-procedure ( input "{&main-tbl}"
                                          ,input if new(new-{&main-tbl}) 
                                                 then (buffer new-{&main-tbl}:handle)
                                                 else (buffer old-{&main-tbl}:handle)
                                          ,output vuniq-key-rec).
       vuniq-key-rec = "c-" + vuniq-key-rec + {&delim-key} + string(g#db-num)  + {&delim-key} +  string(v-Seq).
       run gen-row-keyr in this-procedure (
                                        input  vuniq-key-rec /*uniq-key-rec смены*/
                                        ,input ? /*p-key-handle буфер записи которую будем искать. если ищем по key-rec то ? */
                                        ,input  "{&db-name_schema}"
                                        ,input  ? /*p-tt-handle   буфер таблицы - если надо найти во временной таблице. если ищем в БД то ? */
                                        ,input  no-lock
                                        ,output v-rowid
                                        ,output v-tbl-name ) .
      if v-rowid ne ?
      then
         find first buf_c-{&main-tbl} where rowid(buf_c-{&main-tbl})           = v-rowid
         exclusive-lock no-error.
    end.
    
    /* в историю копируется запись до изменений; при создании в историю копирются начальные пустые значения */
   if new(new-{&main-tbl}) 
   then do:
      if not available buf_c-{&main-tbl}
      then
         create buf_c-{&main-tbl}.
      buffer-copy new-{&main-tbl} to buf_c-{&main-tbl}
      assign
      
         buf_c-{&main-tbl}.chip-num           = v-Seq
         buf_c-{&main-tbl}.corr-date          = v-date
         buf_c-{&main-tbl}.corr-time          = v-time
         buf_c-{&main-tbl}.corr-user-db-num   = g#db-num
         buf_c-{&main-tbl}.corr-user-name     = g#userid
         buf_c-{&main-tbl}.action             = {&bef-hn-create}
         buf_c-{&main-tbl}.is-del             = false
      .
   end.
   else do:
      if not available buf_c-{&main-tbl}
      then do:
         create buf_c-{&main-tbl}.
         buffer-copy old-{&main-tbl} to buf_c-{&main-tbl}
         assign
            buf_c-{&main-tbl}.chip-num           = v-Seq
            buf_c-{&main-tbl}.corr-date          = v-date
            buf_c-{&main-tbl}.corr-time          = v-time
            buf_c-{&main-tbl}.corr-user-db-num   = g#db-num
            buf_c-{&main-tbl}.corr-user-name     = g#userid
            buf_c-{&main-tbl}.action             = {&bef-hn-update} when buf_c-{&main-tbl}.action ne {&bef-hn-create}
            buf_c-{&main-tbl}.is-del             = false
         .
      end.
   end.
  &else
  
    run cur-time in this-procedure (output v-date, output v-time).
    publish "getNextseq" ("{&seqnamehist}", "{&db-name_schema}", output v-Seq ).
    if v-Seq = ?
    then
       v-Seq  = next-value ({&seqnamehist}, {&db-name_schema}).
  
    /* пишем историю */
    if vFlagseq
    then do:
       run gen-key-rec in this-procedure ( input "{&main-tbl}"
                                          ,input(buffer {&main-tbl}:handle)
                                                
                                          ,output vuniq-key-rec).
       vuniq-key-rec = "c-" + vuniq-key-rec + {&delim-key} + string(g#db-num) + {&delim-key} +  string(v-Seq).
       run gen-row-keyr in this-procedure (
                                        input  vuniq-key-rec /*uniq-key-rec смены*/
                                        ,input ? /*p-key-handle буфер записи которую будем искать. если ищем по key-rec то ? */
                                        ,input  "{&db-name_schema}"
                                        ,input  ? /*p-tt-handle   буфер таблицы - если надо найти во временной таблице. если ищем в БД то ? */
                                        ,input  no-lock
                                        ,output v-rowid
                                        ,output v-tbl-name ) .
      if v-rowid ne ?
      then
         find first buf_c-{&main-tbl} where rowid(buf_c-{&main-tbl})           = v-rowid
         exclusive-lock no-error.
    end.   
    if not available buf_c-{&main-tbl}
    then
       create buf_c-{&main-tbl}.
    buffer-copy ub.{&main-tbl} to buf_c-{&main-tbl}
    assign
      buf_c-{&main-tbl}.chip-num           = v-Seq
      buf_c-{&main-tbl}.corr-date          = v-date
      buf_c-{&main-tbl}.corr-time          = v-time
      buf_c-{&main-tbl}.corr-user-db-num   = g#db-num
      buf_c-{&main-tbl}.corr-user-name     = g#userid
      buf_c-{&main-tbl}.action             = {&bef-hn-delete}
      buf_c-{&main-tbl}.is-del             = true
    .
  &endif
  &if defined (histheadtbl) ne 0
  &then
      if vFlagSeq
      then
         find first buf_{&histheadtbl}  where buf_{&histheadtbl}.chip-num           eq v-Seq
         exclusive-lock no-error.
      if not available  buf_{&histheadtbl} 
      then do:
         create buf_{&histheadtbl}.
         buffer-copy  buf_c-{&main-tbl} to buf_{&histheadtbl}
         assign
            buf_{&histheadtbl}.subject = "{&main-tbl}"
            buf_{&histheadtbl}.is-news = g#news
            buf_{&histheadtbl}.source-type = (if g#news
                                          then {&hn-source-db}
                                          else (if g#esys
                                                then {&hn-source-esys}
                                                else "":U)
                                          )
            buf_{&histheadtbl}.source-ref = (if g#news
                                         then string(g#news-source-db)
                                         else (if g#esys
                                               then string(g#esys-source-esys)
                                               else "":U)
                                         )
         .
      end.
      else
         if     buf_{&histheadtbl}.subject ne "*"
            and buf_{&histheadtbl}.subject ne "{&main-tbl}"
         then
            buf_{&histheadtbl}.subject = "*".
  &endif
&endif


&if defined(nws) ne 0
&then
  if not ibs.th.gbl.gbl-var:g#news then do :
  &if defined(del) eq 0
  &then
     run str/callnews.p
      (input {&table_{&main-tbl}}
      ,input (buffer {&db-name_schema}.new-{&main-tbl}:handle)
      ) no-error.
  
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Невозможно маршрутизировать {&main-tbl} для отправки в новости" skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo , return error return-value .
    end.
  &else

    run nws/cmd-del.p
      ( input {&table_{&main-tbl}}
       ,input (buffer {&db-name_schema}.{&main-tbl}:handle)
       ,input "":U
      ) no-error .
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Невозможно маршрутизировать удаление {&main-tbl} для отправки в новости" skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo , return error return-value .
    end.
    &endif
    end. /* end_of not-g-news */
&endif

  