&glob param_1 iMark
define input  parameter {&Param_1} as character no-undo.

{ gbl/objsrv.i }

define temp-table c-marking-hist no-undo like c-marking-attr
  field subject as character
  field is-news as logical
  field source-type as character
  field source-ref as character
.

function fLabel returns character forward.

&glob buf_obj-hist c-marking-hist
&Glob VisibleKeyField yes
&glob myChangeAdd ParentPars
{ref/brwhist.i &lable = fLabel() &objtt=yes &objhead = yes}

function getStsName returns character (iSts as int ):
  define variable thMarkSts  as class ibs.th.str.marking.sts.mark no-undo.
  thMarkSts = ObjSrv:Env:Marking:Sts:Mark.

  return thMarkSts:GetLabel(iSts).
end.

function formatLogicalValue returns character (iValue as character ):
  return if iValue = "" then ? else string(logical(iValue),"Да/Нет").
end.

function getAttributeName returns character (iCode as character ):
  return 
    if iCode = "notOnlineCheck" 
      then "Игнорировать результат online-проверки"
      else "Значениеа атрибута".
end.

&glob tt_name temp-changes
procedure ParentPars:
   define input  parameter iOldBuf as handle no-undo.
   define input  parameter iCurBuf as handle no-undo.
end.
function fLabel returns character :
   return "История изменений по марке " + iMark.
end.

function get-subject returns character
  ( p-subject as character ) :
  
  return if p-subject = "marking" then "Марка" else "Атрибут марки".

end function.
 
procedure local-view-cange:
  define output parameter odescription as character no-undo.
  
  define buffer current_c-marking for ub.c-marking  .
  define variable v-mess as character no-undo.

   if X_c-obj-hist.subject eq "marking"
   then
      run getMarking (output odescription).
   else
      run getMarkingAttr (output odescription).
end procedure.

procedure getMarking:
  define output parameter p-description as character no-undo .

  define buffer current_c-marking for ub.c-marking.
  define variable v-mess as character no-undo.
  
  do
  on error undo, return error return-value
  :
    find first current_c-marking no-lock where
               current_c-marking.mark = X_c-obj-hist.mark
           and current_c-marking.chip-num = X_c-obj-hist.chip-num
           and current_c-marking.corr-user-db-num = X_c-obj-hist.corr-user-db-num no-error .
    if not avail current_c-marking then do:
        v-mess = "Неверная ссылка на марку в таблице c-marking".
        return error  v-mess .
    end.
    &scop fields-name-list "sts,last-change"
    define variable v-label-param as character no-undo .
    v-label-param =
          "sts"   + {&delim-par} + "Статус" + {&delim-par} + "getStsName" + {&delim-flf}
        + "last-change" + {&delim-par} + "Изменен" + {&delim-par} + "".
    run proc-full-temp-changes in this-procedure (
                                                 input current_c-marking.action = integer({&hn-create})
                                                ,input current_c-marking.action = integer({&hn-delete})
                                                ,input  buffer current_c-marking:handle
                                                ,input  "marking"
                                                ,input  {&fields-name-list}
                                                ,input  v-label-param).
  end.
end procedure. /* getMarking */

procedure getMarkingAttr:
  define output parameter p-description as character no-undo .

  define buffer current_c-marking for ub.c-marking-attr.
  define variable v-mess as character no-undo.
  
  do
  on error undo, return error return-value
  :
    find first current_c-marking no-lock where
               current_c-marking.mark = X_c-obj-hist.mark
           and current_c-marking.chip-num = X_c-obj-hist.chip-num
           and current_c-marking.corr-user-db-num = X_c-obj-hist.corr-user-db-num no-error .
    if not avail current_c-marking then do:
        v-mess = "Неверная ссылка на марку в таблице c-marking".
        return error  v-mess .
    end.
    &scop fields-name-list "attr-value"
    define variable v-label-param as character no-undo .
    v-label-param =
          "attr-value"   + {&delim-par} + getAttributeName(current_c-marking.attr-code) + {&delim-par} + "formatLogicalValue".
    run proc-full-temp-changes in this-procedure (
                                                 input current_c-marking.action = integer({&hn-create})
                                                ,input current_c-marking.action = integer({&hn-delete})
                                                ,input  buffer current_c-marking:handle
                                                ,input  "marking-attr"
                                                ,input  {&fields-name-list}
                                                ,input  v-label-param).
  end.
end procedure. /* getMarkingAttr */

function local-open-br returns logical ( 
  p-open-query     as logical    ,
  p-find-next       as logical    ,
  p-find-condition as character 
):
  define variable sort-column-phrase as character no-undo .
  define variable l-query-was-opened as logical no-undo .
  
  for each X_c-obj-hist :
    delete X_c-obj-hist.
  end.
  if p-mode eq "one"
  then do:
    &glob addTable marking
    for each c-{&addTable} where c-{&addTable}.mark               eq iMark
    no-lock:
       create X_c-obj-hist.
       buffer-copy c-{&addTable} to X_c-obj-hist
       assign 
          X_c-obj-hist.subject = "{&addTable}"
       .
    end.
    &glob addTable marking-attr
    for each c-{&addTable} where c-{&addTable}.mark               eq iMark
    no-lock:
       create X_c-obj-hist.
       buffer-copy c-{&addTable} to X_c-obj-hist
       assign 
          X_c-obj-hist.subject = "{&addTable}"
       .
    end.
  end.
  {gbl/fltopend.i
    &where-cond = " TRUE "
    &by         = " by X_c-obj-hist.corr-date desc by X_c-obj-hist.corr-time desc  " 
  }
  return true.
end.


