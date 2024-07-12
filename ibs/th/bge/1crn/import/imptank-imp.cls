/*

$Revision: 1d6ea42ddaad, 1178, rls $
$Author: EShklyar $
$Date: Thu Dec 14 02:20:27 2017 +0300 $
$Workfile: imptank-imp.cls $
$Archive: ibs/th/bge/1crn/import/imptank-imp.cls $

Класс ипорта данных imptank-imp из 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
using ibs.th.str.placelib from propath .


block-level on error undo, throw.

class ibs.th.bge.1crn.import.imptank-imp implements ibs.th.bge.1crn.import.iimpsubject: 

  define variable placelib as class placelib no-undo .
  
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

    define variable v-tank         as class tank-imp         no-undo.
    define variable v-cal-tbl-line as class tank-imp_cal-tbl no-undo.
    define variable v-belt-tbl-line as class tank-imp_belt-tbl no-undo.
    
    define variable v_cal-tbl      as class subjects         no-undo.
    define variable v_belt-tbl      as class subjects         no-undo.
    
    define buffer buf_place      for ub.place .
    define buffer bf_place       for ub.place .
    define buffer buf_place-attr for ub.place-attr .
    define buffer buf_pl-level   for ub.pl-level .
    define buffer bf_pl-level    for ub.pl-level .
    define buffer buf_clients    for ub.clients .
    define buffer buf_pl-level-attr for ub.pl-level-attr .
    define buffer buf_pl-level-mm   for ub.pl-level-mm .
    
    define variable v-mode  as character no-undo .
    define variable v-rec   as recid     no-undo .
    define variable ii      as integer   no-undo .
    define variable v-code  as character no-undo .
    define variable v-value as character no-undo .
    define variable v-ok    as logical   no-undo .

    v-tank = cast (subjectObj, tank-imp).
    v_cal-tbl = v-tank:cal-tbl .
    v_belt-tbl = v-tank:belt-tbl .
    
    find first buf_clients no-lock  where buf_clients.obj-type = {&shop} 
      and buf_clients.obj-code = integer(v-tank:gs-code) no-error .
    if not AVAILABLE (buf_clients) then 
    do:
      Msg = "Нет объекта с кодом:" + v-tank:gs-code . 
      return error .
    end.      

    find first buf_place no-lock where buf_place.pl-code = integer(v-tank:tank-code) and buf_place.obj-code = buf_clients.obj-code and buf_place.obj-type = buf_clients.obj-type no-error .
    if AVAILABLE (buf_place) then 
    do:
      for each bf_pl-level where bf_pl-level.obj-code = buf_place.obj-code
        and bf_pl-level.obj-type = buf_place.obj-type
        and bf_pl-level.pl-code = buf_place.pl-code:

        for each buf_pl-level-attr exclusive-lock where 
                 buf_pl-level-attr.obj-type  = buf_place.obj-type
             and buf_pl-level-attr.obj-code  = buf_place.obj-code
             and buf_pl-level-attr.pl-code   = buf_place.pl-code
             and buf_pl-level-attr.pl-level  = bf_pl-level.pl-level:
          delete buf_pl-level-attr.                                              
        end.
        delete bf_pl-level .
      end.
      for each buf_pl-level-mm where buf_pl-level-mm.obj-code = buf_place.obj-code
        and buf_pl-level-mm.obj-type = buf_place.obj-type
        and buf_pl-level-mm.pl-code = buf_place.pl-code:

        delete buf_pl-level-mm .
      end.
              
      if VALID-OBJECT (v_cal-tbl) then 
      do:
        do ii = 1 to v_cal-tbl:Get(ii):
          v-cal-tbl-line = cast(v_cal-tbl:SubjectObjCurr, tank-imp_cal-tbl) .
          find first buf_pl-level EXCLUSIVE-LOCK where buf_pl-level.obj-code = buf_place.obj-code
            and buf_pl-level.obj-type = buf_place.obj-type
            and buf_pl-level.pl-code = buf_place.pl-code
            and buf_pl-level.pl-level = v-cal-tbl-line:lvl_ no-error .
          if not AVAILABLE (buf_pl-level) then 
          do:
            create buf_pl-level.
            assign
              buf_pl-level.obj-type = buf_place.obj-type
              buf_pl-level.obj-code = buf_place.obj-code
              buf_pl-level.pl-code  = buf_place.pl-code
              buf_pl-level.pl-level = v-cal-tbl-line:lvl_
              buf_pl-level.pl-qnty  = v-cal-tbl-line:amnt
              .
          end.
          if v-cal-tbl-line:comp-err <> ? then
          do:
            find first buf_pl-level-attr exclusive-lock where buf_pl-level-attr.obj-type  = buf_place.obj-type
                                              and buf_pl-level-attr.obj-code  = buf_place.obj-code
                                              and buf_pl-level-attr.pl-code   = buf_place.pl-code
                                              and buf_pl-level-attr.pl-level  = buf_pl-level.pl-level
                                              and buf_pl-level-attr.attr-code = "tarir-delta"
                                              no-error .
            if not available buf_pl-level-attr
            then do :
              create buf_pl-level-attr .
              assign
                buf_pl-level-attr.obj-type  = buf_place.obj-type
                buf_pl-level-attr.obj-code  = buf_place.obj-code
                buf_pl-level-attr.pl-code   = buf_place.pl-code 
                buf_pl-level-attr.pl-level  = buf_pl-level.pl-level
                buf_pl-level-attr.attr-code = "tarir-delta"        
              .
            end.                                                                      
            buf_pl-level-attr.attr-value = string(v-cal-tbl-line:comp-err).
          end.
        end.  
      end.

      if VALID-OBJECT (v_belt-tbl) then 
      do:
        do ii = 1 to v_belt-tbl:Get(ii):
          v-belt-tbl-line = cast(v_belt-tbl:SubjectObjCurr, tank-imp_belt-tbl) .
          find first buf_pl-level-mm EXCLUSIVE-LOCK where buf_pl-level-mm.obj-code = buf_place.obj-code
            and buf_pl-level-mm.obj-type = buf_place.obj-type
            and buf_pl-level-mm.pl-code = buf_place.pl-code
            and buf_pl-level-mm.zone = v-belt-tbl-line:num-belt
            and buf_pl-level-mm.level = v-belt-tbl-line:tbl-lvl no-error .
          if not AVAILABLE (buf_pl-level-mm) then 
          do:
            create buf_pl-level-mm.
            assign
              buf_pl-level-mm.obj-type  = buf_place.obj-type
              buf_pl-level-mm.obj-code  = buf_place.obj-code
              buf_pl-level-mm.pl-code   = buf_place.pl-code
              buf_pl-level-mm.zone      = v-belt-tbl-line:num-belt
              buf_pl-level-mm.min-level = v-belt-tbl-line:low-lvl
              buf_pl-level-mm.max-level = v-belt-tbl-line:up-lvl
              buf_pl-level-mm.level     = v-belt-tbl-line:tbl-lvl
              buf_pl-level-mm.capacity  = v-belt-tbl-line:belt-capacity * 1000
            .
          end.
        end.  
      end.
    end.
    else do:
      Msg = "Нет складского места с кодом:" + v-tank:tank-code . 
      return error .
    end.  
  end method.
end class.