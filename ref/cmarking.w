&glob param_1 iMark
define input  parameter {&Param_1} as character no-undo.

{ gbl/objsrv.i }
function fLabel returns character forward.

&glob buf_obj-hist c-marking
&Glob VisibleKeyField no
&glob myChangeAdd ParentPars
{ref/brwhist.i &lable = fLabel()}

function getStsName returns character (iSts as int ):
  define variable thMarkSts  as class ibs.th.str.marking.sts.mark no-undo.
  thMarkSts = ObjSrv:Env:Marking:Sts:Mark.

  return thMarkSts:GetLabel(iSts).
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
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
&scop hn-obj-hist-code p-subject
  return p-subject.   /* Function return value. */

end function.
 
procedure local-view-cange:
   define output parameter odescription as character no-undo.
   define buffer current_c-marking for ub.c-marking  .
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

end procedure.
  
function local-open-br returns logical 
(  p-open-query     as logical    ,
  p-find-next       as logical    ,
  p-find-condition as character ):
     define variable sort-column-phrase as character no-undo .
     define variable l-query-was-opened as logical no-undo .
   if p-mode eq "one"
   then do:
      if p-chip-num eq ?
      then do:
         { gbl/fltopend.i
           &where-cond = " X_c-obj-hist.mark = iMark
                       and X_c-obj-hist.corr-user-db-num = v-corr-user-db-num "


           &dyn_where-cond = " substitute('X_c-obj-hist.mark = &1&2&1
                                       and X_c-obj-hist.corr-user-db-num = &3',~{&double-quote~},iMark, v-corr-user-db-num) "
          &by         = " by X_c-obj-hist.chip-num  " }
      end.
      else do:
         { gbl/fltopend.i
          &where-cond = " X_c-obj-hist.mark = iMark  
                      and X_c-obj-hist.corr-user-db-num   eq v-corr-user-db-num
                      and X_c-obj-hist.chip-num           eq p-chip-num "
          &dyn_where-cond = " substitute('X_c-obj-hist.mark = &1&2&1  
                      and X_c-obj-hist.corr-user-db-num   eq &3
                      and X_c-obj-hist.chip-num           eq &4',~{&double-quote~}, iMark, v-corr-user-db-num, p-chip-num) "
          &by         = " by X_c-obj-hist.chip-num  " }
      end.
   end.
  return true.
end.


