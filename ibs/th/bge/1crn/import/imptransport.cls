/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных imptransport из 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.


block-level on error undo, throw.

class ibs.th.bge.1crn.import.imptransport implements ibs.th.bge.1crn.import.iimpsubject: 
  
  { cmp/str-glbl.i class }
  { cmp/str-glbl.i }
   
   
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):

    define variable v-transport  as class   transport                no-undo.
    define variable v-section    as class   transport_section        no-undo.
    define variable v-ct-lvl     as class   transport_section_ct-lvl no-undo.
    define variable v_sections   as class   subjects                 no-undo.
    define variable v_CalibTable as class   subjects                 no-undo.
    
    define variable ii           as integer no-undo .
    define variable jj           as integer no-undo .
    define variable is-create    as logical no-undo .
    
    define buffer buf_auto-tank      for ub.auto-tank .
    define buffer bf_auto-tank       for ub.auto-tank .
    define buffer buf_auto-tank-attr for ub.auto-tank-attr .
    define buffer buf_auto-tank-meas for ub.auto-tank-meas .
    define buffer buf_clients        for ub.clients .
    
    v-transport = cast (subjectObj, transport).
    v_sections = v-transport:sections .
    v_CalibTable = v-transport:calibration-table .
    
    if v-transport:del-f = 1 then 
    do:
      /*проверять не используется ли данные где-то в другом месте - не сделано*/
      Msg = "Нет физического удаления автотранспорта".
    end.  
    else 
    do:
      find first buf_auto-tank EXCLUSIVE-LOCK where buf_auto-tank.auto-num = v-transport:reg-num no-error .
      if not AVAILABLE (buf_auto-tank) then 
      do:
        create buf_auto-tank .
        buf_auto-tank.auto-num = v-transport:reg-num .
      end.
      assign
        buf_auto-tank.status_ = if v-transport:del-l = 1 then {&deleted-status} else {&current-status} 
        buf_auto-tank.name    = v-transport:name_
        .
      
      find first buf_clients no-lock where buf_clients.obj-code = integer(v-transport:tr-owner) no-error .
      if not AVAILABLE (buf_clients) then 
      do:
        Msg = "В справочнике нет автопредприятия с кодом:" + v-transport:tr-owner. 
        return error .
      end.
      
      else 
      do:
        find first buf_auto-tank-attr EXCLUSIVE-LOCK where buf_auto-tank-attr.auto-num = buf_auto-tank.auto-num and buf_auto-tank-attr.attr-code = "auto-firm" no-error .
        if not AVAILABLE (buf_auto-tank-attr) then 
        do:
          create buf_auto-tank-attr.
          assign
            buf_auto-tank-attr.attr-code = "auto-firm"
            buf_auto-tank-attr.auto-num  = buf_auto-tank.auto-num 
            .
        end.
        buf_auto-tank-attr.attr-value = v-transport:tr-owner
          .
        for each bf_auto-tank where bf_auto-tank.auto-num BEGINS (v-transport:reg-num + chr(35)):
          
          delete bf_auto-tank .
          
        end.  
        for each buf_auto-tank-meas where buf_auto-tank-meas.auto-num begins (v-transport:reg-num):
          
          delete buf_auto-tank-meas .
          
        end.   
        if VALID-OBJECT (v_sections) then 
        do:
          do ii = 1 to v_sections:Get(ii):
            v-section = cast(v_sections:SubjectObjCurr, transport_section) .
            
            find first bf_auto-tank EXCLUSIVE-LOCK where bf_auto-tank.auto-num = (v-transport:reg-num + chr(35) + string(v-section:sec-num)) no-error .
            if not AVAILABLE (bf_auto-tank) then 
            do:
              create bf_auto-tank.
              bf_auto-tank.auto-num = (v-transport:reg-num + chr(35) + STRING (v-section:sec-num)) .
            end.  
            ASSIGN 
              bf_auto-tank.brutto-qnty = v-section:capacity
              bf_auto-tank.name        = STRING (v-section:min-of-lvl) + {&delim-par} + STRING (v-section:max-of-lvl) + {&delim-par} + STRING (v-section:throat-diameter)
              .
          end.  
        end.
        if VALID-OBJECT (v_CalibTable) then 
        do:
          do jj = 1 to v_CalibTable:Get(jj):
            v-ct-lvl = cast(v_CalibTable:SubjectObjCurr, transport_section_ct-lvl) .
            find first buf_auto-tank-meas EXCLUSIVE-LOCK where buf_auto-tank-meas.auto-num = (v-transport:reg-num + chr(35) + string(v-ct-lvl:sec-num)) and
              buf_auto-tank-meas.meas-label = STRING (v-ct-lvl:lvl_) no-error .
            IF NOT AVAILABLE (buf_auto-tank-meas) THEN 
            DO:
              create buf_auto-tank-meas .
              assign
                buf_auto-tank-meas.auto-num   = (v-transport:reg-num + chr(35) + string(v-ct-lvl:sec-num)) 
                buf_auto-tank-meas.meas-label = STRING (v-ct-lvl:lvl_)
                .
            end.
            assign
              buf_auto-tank-meas.meas-qnty = v-ct-lvl:amount
              .
          end.  
        end.
      end.  
    end.

  end method.
end class.