/* экспорт в 1С чеков открытия и закрытия смены */
{cmp\str-glbl.i}
{ cmp/library.i  }
{ gbl/objsrv.i }
{ str/trdcalib.i }

procedure proc-exp-1s: 

define input parameter  doc-code as character  NO-UNDO. 
define input parameter  chk-id   as  character NO-UNDO.
/*define input  parameter p-oldbh as handle no-undo .*/


FIND FIRST ub.chk-doc WHERE ub.chk-doc.doc-code = doc-code 
                        and ub.chk-doc.chk-id   = chk-id 
                        and (ub.chk-doc.chk-type eq 40 or ub.chk-doc.chk-type eq 13)
                        NO-ERROR.

IF AVAILABLE ub.chk-doc THEN 

     DO:
     FIND FIRST ub.chk-doc-attr WHERE ub.chk-doc-attr.doc-code = ub.chk-doc.doc-code 
                                and ub.chk-doc-attr.attr-code  = "CHFlag1S" 
                                and ub.chk-doc-attr.attr-value = "no" 
                                NO-ERROR. 

     IF AVAILABLE ub.chk-doc-attr THEN DO:

      { gbl/rum-runa.i
      parparentproc
      this-procedure:handle
      p-log-handle
      {&edoc-proc_event_shift}
      " buffer chk-doc:handle "
      " buffer chk-doc:handle "
      ''
      ''
no-error
    } 
if error-status:error then 
do :
    message "Ошибка маршрутизации записи в машину правил" skip return-value skip error-status:get-message(1) view-as alert-box.
end.
else do:                  
/* ub.chk-doc-attr.attr-value = "yes"     . */
delete chk-doc-attr.
end.


     END.

END.

end procedure. 



