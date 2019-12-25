&if defined(trghistnwsdef) eq 0
&then
&glob trghistnwsdef
{ cmp/vssrevis.i }

{ cmp/trg-def.i  } 
{ cmp/str-glbl.i } /* &db-name_schema, &hn-delete */
{ gbl/cur-time.i } /* cur-time() */
define buffer buf_c-{&main-tbl}  for ub.c-{&main-tbl} .

define variable v-date      as date      no-undo .
define variable v-time      as integer   no-undo .
define variable v-field-chg as character no-undo .
define variable v-Seq       as int64     no-undo init ?.

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
    /*publish "getNextseq" ("{&seqnamehist}", "{&db-name_schema}", output v-Seq ).
    if v-Seq = ?
    then */
       v-Seq  = next-value ({&seqnamehist}, {&db-name_schema}).
  
    /* пишем историю */
    create buf_c-{&main-tbl}.
    /* в историю копируетс€ запись до изменений; при создании в историю копирютс€ начальные пустые значени€ */
    if new(new-{&main-tbl}) 
    then
       buffer-copy new-{&main-tbl} to buf_c-{&main-tbl}
       assign
      
      buf_c-{&main-tbl}.chip-num           = v-Seq
      buf_c-{&main-tbl}.corr-date          = v-date
      buf_c-{&main-tbl}.corr-time          = v-time
      buf_c-{&main-tbl}.corr-user-db-num   = ibs.th.gbl.gbl-var:g#db-num
      buf_c-{&main-tbl}.corr-user-name     = ibs.th.gbl.gbl-var:g#userid
      buf_c-{&main-tbl}.action             = {&bef-hn-create}
      buf_c-{&main-tbl}.is-del             = false
    .
    else
       buffer-copy old-{&main-tbl} to buf_c-{&main-tbl}
    assign
      
      buf_c-{&main-tbl}.chip-num           = v-Seq
      buf_c-{&main-tbl}.corr-date          = v-date
      buf_c-{&main-tbl}.corr-time          = v-time
      buf_c-{&main-tbl}.corr-user-db-num   = ibs.th.gbl.gbl-var:g#db-num
      buf_c-{&main-tbl}.corr-user-name     = ibs.th.gbl.gbl-var:g#userid
      buf_c-{&main-tbl}.action             = {&bef-hn-update}
      buf_c-{&main-tbl}.is-del             = false
    .
  &else
  
    run cur-time in this-procedure (output v-date, output v-time).
   /* publish "getNextseq" ("{&seqnamehist}", "{&db-name_schema}", output v-Seq ).
    if v-Seq = ?
    then */
       v-Seq  = next-value ({&seqnamehist}, {&db-name_schema}).
  
    /* пишем историю */
    create buf_c-{&main-tbl}.
    buffer-copy ub.{&main-tbl} to buf_c-{&main-tbl}
    assign
      buf_c-{&main-tbl}.chip-num           = v-Seq
      buf_c-{&main-tbl}.corr-date          = v-date
      buf_c-{&main-tbl}.corr-time          = v-time
      buf_c-{&main-tbl}.corr-user-db-num   = ibs.th.gbl.gbl-var:g#db-num
      buf_c-{&main-tbl}.corr-user-name     = ibs.th.gbl.gbl-var:g#userid
      buf_c-{&main-tbl}.action             = {&bef-hn-delete}
      buf_c-{&main-tbl}.is-del             = true
    .
  &endif
  &if defined (histheadtbl) ne 0
  &then 
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
  &endif
&endif

if not ibs.th.gbl.gbl-var:g#news then do :
&if defined(nws) ne 0
&then
  &if defined(del) eq 0
  &then
     run str/callnews.p
      (input {&table_{&main-tbl}}
      ,input (buffer {&db-name_schema}.new-{&main-tbl}:handle)
      ) no-error.
  
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ќевозможно маршрутизировать {&main-tbl} дл€ отправки в новости" skip
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
        "Ќевозможно маршрутизировать удаление {&main-tbl} дл€ отправки в новости" skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo , return error return-value .
    end.
    &endif
&endif
end. /* end_of not-g-news */
  