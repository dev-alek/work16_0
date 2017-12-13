/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных good-grps из 1С

Автор: Елена Шкляр
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.impgood-grps implements ibs.th.bge.1crn.import.iimpsubject: 
  
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
		
    define variable v-rec  as recid     no-undo .
    define variable v-mode as character no-undo .
    define buffer buf_gds-grp for ub.gds-grp .
    DEFINE VARIABLE varnode-code          like ub.gds-grp.node-code no-undo .
    DEFINE VARIABLE varupper-code         like ub.gds-grp.upper-code no-undo .
    define variable v-fill-tax-from-upper as LOGICAL no-undo .
    define variable v-perenos             as logical no-undo .
    
    define variable objGood-Grps          as class   good-grps no-undo.
		
    objGood-Grps = cast (subjectObj, good-grps).

    if objGood-Grps:del-f = 1 then 
    do:
      /*проверять не используется ли данные где-то в другом месте - не сделано*/
		
      find first buf_gds-grp EXCLUSIVE-LOCK
        where buf_gds-grp.node-code = integer(objGood-Grps:code_)
        no-error.
      if error-status :error
        then
      do:
        Msg = "Нет группы БД, соответствующей значению в списке.".
        return false.
      end.

      run ref/gdsgrp03.p ( input yes
        ,input recid(buf_gds-grp)
        ,input "up" /*p-child-grp-behavior*/
        ,input "up" /*p-child-gds-behavior*/
        ) no-error.
      if error-status:error then
      do:
        Msg = return-value.
        return false.
      end.                         		
    end.
    else
    do:
      ASSIGN
        varnode-code  = INTEGER(objGood-Grps:code_)
        varupper-code = INTEGER (objGood-Grps:upper-code)
        .   	
      find first buf_gds-grp EXCLUSIVE-LOCK
        where buf_gds-grp.node-code = integer(objGood-Grps:code_)
        no-error.
      if AVAILABLE buf_gds-grp then
      do:
        assign
          v-rec                 = RECID (buf_gds-grp) 
          v-mode                = {&update}
          v-fill-tax-from-upper = no
          .
        if varupper-code <> buf_gds-grp.upper-code then 
        do:
          assign
            varupper-code = buf_gds-grp.upper-code
            v-perenos     = yes.
          .
        end.   
      end.
      else
      do:
        assign
          v-rec                 = ? 
          v-mode                = {&add-def}
          v-fill-tax-from-upper = yes
          .
      end.
      run ref/gdsgrp01.p (
        input v-mode
        ,input yes /*-silent*/
        ,input yes /*p-get-node-code*/
        ,input v-fill-tax-from-upper /*p-fill-tax-from-upper*/
        ,input-output  varnode-code
        ,input-output  varupper-code
        ,input objGood-Grps:name_
        ,input {&pr-calc-fix}
        ,input ""
        ,input objGood-Grps:rn-code
        ,input {&pr-round-off}
        ,input 0
        ,output v-rec
        ) no-error .
      if error-status:error then
      do:
        Msg = return-value.
        return false.
      end.
    end.
  end method.

end class.