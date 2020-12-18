/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс импорта данных impFuelCodeInfo из 1С

Автор: Шкляр Елена
Дата создания: 26/09/17
Author: Shklyar Elena
Creation date: 26/09/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.
USING ibs.th.gbl.*.

class ibs.th.bge.1crn.import.impfuelcodeinfo implements ibs.th.bge.1crn.import.iimpsubject: 
  
   { cmp/str-glbl.i class }
   { cmp/str-glbl.i }
   { ref/extclass.i }
   { str/defc-ext-classif.i }
   define buffer buf_ext-classif for ub.ext-classif .   
   define buffer buf_ext-system  for ub.ext-system .
   define buffer buf_goods       for ub.goods .
  
   define variable v-code         as character no-undo .
   define variable v-uniq-key-rec as character no-undo .
   
   define property Msg as character no-undo
      get. 
      set.

   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/

   method public logical Excute( subjectObj as class ibs.th.bge.1crn.subjects.isubject ):
	
      define variable ri              as recid no-undo .
      define variable objfuelcodeinfo as class fuelcodeinfo no-undo.
        
      objFuelCodeInfo = cast (subjectObj, fuelcodeinfo).

      /*    if objfuelcodeinfo:ExtCode = "" or objfuelcodeinfo:ExtCode = ? then                   */
      /*    do:                                                                                   */
      /*      Msg = "Код продукта внешней системы не задан".                                      */
      /*      return error.                                                                       */
      /*    end.                                                                                  */
      /*    if objfuelcodeinfo:ExtId = ? then                                                     */
      /*    do:                                                                                   */
      /*      Msg = "Идентификатор внешней системы для " + objfuelcodeinfo:ExtCode +  "не задан" .*/
      /*      return error Msg.                                                                   */
      /*    end.                                                                                  */
      /*    if objfuelcodeinfo:IntCode = "" or objfuelcodeinfo:IntCode = ? then                   */
      /*    do:                                                                                   */
      /*      Msg = "Код нефтепродукта для " + objfuelcodeinfo:IntCode + "не задан" .             */
      /*      return error Msg.                                                                   */
      /*    end.                                                                                  */
      find first buf_goods no-lock where buf_goods.gds-code = integer(objfuelcodeinfo:IntCode) no-error .
      if available (buf_goods) then 
      do:
         gen-key-rec (input {&table_goods},input (buffer buf_goods:handle),output v-uniq-key-rec) no-error.
         if error-status:error then 
         do:
            msg = return-value .
            return false .
         end.         
      end.  
      else 
      do:
         Msg = "Товар с кодом " + string(objfuelcodeinfo:IntCode) + " не найден" .
         return false.
      end.    
      if objfuelcodeinfo:ExtId = 0 then 
      do: /*Внешняя система не указана, если не указана привязка идет ко всем внешним системам*/
         for each buf_ext-system no-lock:
            if objfuelcodeinfo:del-f = 0 then 
            do: /*добавление*/
               proc_create(buf_ext-system.esys-id, objfuelcodeinfo:IntCode, objfuelcodeinfo:ExtCode) no-error.
               if error-status:error then 
               do:
                  msg = return-value .
                  return false .
               end.
            end.
            else 
            do: /*удаление*/
               proc_delete(buf_ext-system.esys-id, objfuelcodeinfo:IntCode, objfuelcodeinfo:ExtCode) no-error.
               if error-status:error then 
               do:
                  msg = return-value .
                  return false .
               end.

            end.               
         end.   
      end.      
      else 
      do:
         find first buf_ext-system no-lock where buf_ext-system.esys-id = objfuelcodeinfo:ExtId no-error .
         if not available (buf_ext-system) then 
         do:
            Msg = "Внешняя система " + string(objfuelcodeinfo:ExtId) + " не найдена" .
            return false.
         end.
         if objfuelcodeinfo:del-f = 0 then 
         do: /*добавление*/
            proc_create(buf_ext-system.esys-id, objfuelcodeinfo:IntCode, objfuelcodeinfo:ExtCode) no-error.
            if error-status:error then 
            do:
               msg = return-value .
               return false .
            end.
         end.
         else 
         do: /*удаление*/
            proc_delete(buf_ext-system.esys-id, objfuelcodeinfo:IntCode, objfuelcodeinfo:ExtCode) no-error.
            if error-status:error then 
            do:
               msg = return-value .
               return false .
            end.

         end.               
      end.   
                              
   end method.
   /*   { str/ext-classif-list.i}*/
   method private void proc_create (input p-esys-id   as integer, input p-IntCode as character, input p-ExtCode as character) :
      define variable rid-list as recid no-undo .
      find first buf_ext-classif exclusive-lock where buf_ext-classif.classif-subject = {&table_goods} and 
         buf_ext-classif.classif-name = {&extclass_goods_esys} and
         buf_ext-classif.Key#_Two = p-esys-id and
         buf_ext-classif.db-num	  = buf_ext-system.db-num and
         buf_ext-classif.Key#_One = integer(p-IntCode) no-error .
      if not available (buf_ext-classif) then 
      do:
         create buf_ext-classif .
         assign
            buf_ext-classif.uniq-key-rec    = v-uniq-key-rec
            buf_ext-classif.classif-subject = {&table_goods}
            buf_ext-classif.classif-name    = {&extclass_goods_esys}
            buf_ext-classif.Key#_Two        = p-esys-id
            buf_ext-classif.Key#_One        = integer(p-IntCode)             
            buf_ext-classif.db-num          = buf_ext-system.db-num
            .
      end.                                             
      assign
         buf_ext-classif.CharKey_One = p-ExtCode
         .
         rid-list = recid(buf_ext-classif) .
      rid-classif-create(rid-list).   
      release buf_ext-classif no-error.
      if error-status:error then 
      do:
         Msg = return-value .
         return error .
      end.     
   end method .
  
   method private void proc_delete (input p-esys-id   as integer, input p-IntCode as character, input p-ExtCode as character) :
      define variable rid-list as recid no-undo .
      find first buf_ext-classif exclusive-lock where buf_ext-classif.classif-subject = {&table_goods} and 
         buf_ext-classif.classif-name = {&extclass_goods_esys} and
         buf_ext-classif.Key#_Two = p-esys-id and
         buf_ext-classif.db-num   = buf_ext-system.db-num and
         buf_ext-classif.Key#_One = integer(p-IntCode) no-error .
      if available (buf_ext-classif) then 
      do:
         find first c-ext-classif where c-ext-classif.db-num = buf_ext-classif.db-num and
            c-ext-classif.Key#_One = buf_ext-classif.Key#_One and
            c-ext-classif.Key#_Two = buf_ext-classif.Key#_Two and
            c-ext-classif.CharKey_One = buf_ext-classif.CharKey_One and
            c-ext-classif.classif-subject = {&table_goods} and 
            c-ext-classif.classif-name = {&extclass_goods_esys}
            no-lock no-error.
         delete buf_ext-classif .                 
         rid-list = recid(c-ext-classif) .       
         rid-classif-delete (rid-list).

      end.                                             
      release buf_ext-classif no-error.
      if error-status:error then 
      do:
         Msg = return-value .
         return error .
      end.     
   end method .

   method private void rid-classif-create (input rid-list as recid):
      define buffer bf_ext-classif for ub.ext-classif .
      find first bf_ext-classif no-lock where recid(bf_ext-classif) = rid-list no-error .
      if available (bf_ext-classif) then do:
      create ext-classif-list .
      assign
         ext-classif-list.db-num      = bf_ext-classif.db-num
         ext-classif-list.Key#One     = bf_ext-classif.Key#_One
         ext-classif-list.Key#Two     = bf_ext-classif.Key#_Two
         ext-classif-list.CharKey_One = bf_ext-classif.CharKey_One
         .
      end.
      run gbl/rid-classif.p (input table ext-classif-list, input table c-ext-classif-list) no-error.      
   end.
   
   method private void rid-classif-delete (input rid-list as recid):
      define buffer bf_c-ext-classif for ub.c-ext-classif .
      find first bf_c-ext-classif no-lock where recid(bf_c-ext-classif) = rid-list no-error .
      if available (bf_c-ext-classif) then do:
      create c-ext-classif-list .
      assign
         c-ext-classif-list.db-num      = c-ext-classif.db-num
         c-ext-classif-list.Key#One     = c-ext-classif.Key#_One
         c-ext-classif-list.Key#Two     = c-ext-classif.Key#_Two
         c-ext-classif-list.CharKey_One = c-ext-classif.CharKey_One
         c-ext-classif-list.chip-num    = c-ext-classif.chip-num
         .
      end.   
      run gbl/rid-classif.p (input table ext-classif-list, input table c-ext-classif-list) no-error.      
   end.
   
   method private void gen-key-rec (input p-tbl-name as character, input p-bh_tbl-name as handle, output p-key-rec as character):

      define variable fh               as handle    no-undo .
      define variable v-ok             as logical   no-undo .

      define variable v-inform         as character no-undo .
      define variable v-ind            as integer   no-undo .
      define variable v-idx-field-qnty as integer   no-undo .

      if p-tbl-name = ?
         or p-tbl-name = "":U
         then 
      do:
         return error substitute( "(gen-key-rec). Ошибка задания входных параметров. Не задано имя таблицы.").
      end.

      if not p-bh_tbl-name:available then 
      do:
         return error substitute( "(gen-key-rec). Ошибка задания входных параметров. Переданый буфер таблицы &1 не доступен", p-tbl-name ).
      end.

      assign
         p-key-rec = p-tbl-name
         v-inform  = p-bh_tbl-name:index-information(1)
         v-ind     = 2
         .
      do while v-inform <> ? and entry( 3, v-inform, ",":U ) <> "1":U
         on error undo, return error
         :
         assign
            v-inform = p-bh_tbl-name:index-information( v-ind )
            v-ind    = v-ind + 1
            .
      end.

      if v-inform = ?
         or LC( entry( 1, v-inform, ",":U ) ) = "default":U
         or entry( 3, v-inform, ",":U ) <> "1":U
         then 
      do:
         return error substitute( "Таблица &2 не имеет первичного ключа в БД", p-tbl-name ).
      end.
      else 
      do:
         assign
            v-idx-field-qnty = num-entries( v-inform ) - 4
            .
         if v-idx-field-qnty < 2 then 
         do:
            return error substitute( "Определенный первичный индекс (&2) не содержит списка полей для таблицы &3", v-inform, p-tbl-name ).
         end.
         do v-ind = 1 to v-idx-field-qnty by 2
            on error undo, return error
            :
            assign
               fh = p-bh_tbl-name:buffer-field( entry( 4 + v-ind, v-inform, ",":U ) ).
            p-key-rec = p-key-rec + {&delim-key} + substitute("&1", replace(fh:buffer-value(),{&delim-key},{&delim-key-rep}))
               .
         end.
      end.

      if p-key-rec = ? then 
      do:
         assign
            p-key-rec = "":U
            .
         return error substitute( "Поле(поля) первичного ключа таблицы &2 имеет(ют) неопределенное значение", p-tbl-name ).
      end.
      return.
   end method. /* gen-key-rec */
end class.