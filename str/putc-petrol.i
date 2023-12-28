 /*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура отсылки данных по соответствию товаров/кошельков

Автор: Шкляр Елена
Дата создания: 02/14/14
Author: Elena Shklyar
Creation date: 02/14/14

*/


&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
{ cmp/str-glbl.i  }
{ ref/extclass.i }

procedure putc-petrol :
   define input parameter p-pos-type like ub.cash-desk.pos-type no-undo .
   define input parameter p-version like ub.cash-desk.version no-undo .
   define input parameter p-cash-os like ub.cash-desk.cash-os no-undo .
   define input parameter p-cash-num like ub.cash-desk.cash-num  no-undo .
   define input parameter recid-list as character no-undo .
   define input parameter p-is-del as character no-undo .

   define variable v-system as character no-undo .
   define variable ii       as integer   no-undo .
   define variable jj       as integer   no-undo .
   define buffer buf_ext-classif for ub.ext-classif .
   define buffer buf_c-ext-classif for ub.c-ext-classif .
   define buffer buf_ext-system  for ub.ext-system .
   do
      on error undo, return error
      :
       
      run adm/shattri.p (
         input "get":U
         ,input  {&shop}
         ,input  i-obj-code
         ,input  {&attr-cd-inf-send}
         ,input  {&attr-cd-inf-send_code-system} /*p-param-code*/
         ,output v-value-character
         ,output v-value-date
         ,output v-value-decimal
         ,output v-value-integer
         ,output v-value-logical
         ,output v-param-type
         ,INPUT-OUTPUT table-handle v-tth
         ) no-error .
      IF not error-status:error then
         assign
            v-system = v-value-character
            .

		recid-list = trim(recid-list,",")	.
      do ii = 1 to num-entries (v-system,","):
         if p-is-del = "U"  then 
         do:
            if recid-list <> "" then 
            do:
			jj = 0 .
               do jj = 1 to num-entries (recid-list):
                  for each buf_ext-classif no-lock where recid(buf_ext-classif) = integer(entry(jj, recid-list)):
                     if buf_ext-classif.Key#_Two = integer(entry (ii,v-system,",")) then 
                     do:
                        find first buf_ext-system no-lock where buf_ext-system.db-num = buf_ext-classif.db-num and
                           buf_ext-system.esys-id = buf_ext-classif.Key#_Two no-error .
                        run bgelib-tag-open in this-procedure ( input 2, input "FuelCodeInfo"
                          , input substitute("ctrl='&2' code='&1'", string (if buf_ext-classif.Key#_Three <> 0 then buf_ext-classif.Key#_Three else buf_ext-classif.Key#_One), "ADD":u)).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtCode", input string(buf_ext-classif.CharKey_One), input 1 ).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtId", input string(buf_ext-classif.Key#_Two), input 1 ).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtName", input string(if available (buf_ext-system) then buf_ext-system.esys-name else ""), input 1 ).
                        run bgelib-tag-close in this-procedure ( input 2, input "FuelCodeInfo").    
                     end.
                  end.
               end.   
            end.   
            else 
            do:
               for each buf_ext-classif where buf_ext-classif.classif-subject = {&table_goods} and buf_ext-classif.classif-name = {&extclass_goods_esys} and buf_ext-classif.Key#_Two = integer(entry (ii,v-system,",")) no-lock by buf_ext-classif.CharKey_One:
                  find first buf_ext-system no-lock where buf_ext-system.db-num = buf_ext-classif.db-num and
                     buf_ext-system.esys-id = buf_ext-classif.Key#_Two no-error .
                  run bgelib-tag-open in this-procedure ( input 2, input "FuelCodeInfo"
                    , input substitute("ctrl='&2' code='&1'", string (if buf_ext-classif.Key#_Three <> 0 then buf_ext-classif.Key#_Three else buf_ext-classif.Key#_One), "ADD":u)).
                  run bgelib-tag-put in this-procedure ( input 3, input "FCIExtCode", input string(buf_ext-classif.CharKey_One), input 1 ).
                  run bgelib-tag-put in this-procedure ( input 3, input "FCIExtId", input string(buf_ext-classif.Key#_Two), input 1 ).
                  run bgelib-tag-put in this-procedure ( input 3, input "FCIExtName", input string(if available (buf_ext-system) then buf_ext-system.esys-name else ""), input 1 ).
                  run bgelib-tag-close in this-procedure ( input 2, input "FuelCodeInfo").    
               end.
            end.
         end.
         else 
         do:
            if recid-list <> "" then 
            do:
			jj = 0 .
               DO jj = 1 to num-entries (recid-list):
			   find first buf_c-ext-classif no-lock where recid(buf_c-ext-classif) = integer(entry(jj, recid-list)) no-error .
			   if available buf_c-ext-classif then do:
                  for each buf_c-ext-classif no-lock where recid(buf_c-ext-classif) = integer(entry(jj, recid-list)): 
                     if buf_c-ext-classif.Key#_Two = integer(entry (ii,v-system,",")) then 
                     do:
                        find first buf_ext-system no-lock where buf_ext-system.db-num = buf_c-ext-classif.db-num and
                           buf_ext-system.esys-id = buf_c-ext-classif.Key#_Two no-error .
                        run bgelib-tag-open in this-procedure ( input 2, input "FuelCodeInfo"
                          , input substitute("ctrl='&2' code='&1'", string (if buf_ext-classif.Key#_Three <> 0 then buf_ext-classif.Key#_Three else buf_ext-classif.Key#_One), "DEL":u)).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtCode", input string(buf_c-ext-classif.CharKey_One), input 1 ).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtId", input string(buf_c-ext-classif.Key#_Two), input 1 ).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtName", input string(if available (buf_ext-system) then buf_ext-system.esys-name else ""), input 1 ).                  
                        run bgelib-tag-close in this-procedure ( input 2, input "FuelCodeInfo").
                     end.       
                  end.
				  end.
				  else do:
                  for each buf_ext-classif no-lock where recid(buf_ext-classif) = integer(entry(jj, recid-list)): 
                     if buf_ext-classif.Key#_Two = integer(entry (ii,v-system,",")) then 
                     do:
                        find first buf_ext-system no-lock where buf_ext-system.db-num = buf_ext-classif.db-num and
                           buf_ext-system.esys-id = buf_ext-classif.Key#_Two no-error .
                        run bgelib-tag-open in this-procedure ( input 2, input "FuelCodeInfo"
                          , input substitute("ctrl='&2' code='&1'", string (if buf_ext-classif.Key#_Three <> 0 then buf_ext-classif.Key#_Three else buf_ext-classif.Key#_One), "DEL":u)).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtCode", input string(buf_ext-classif.CharKey_One), input 1 ).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtId", input string(buf_ext-classif.Key#_Two), input 1 ).
                        run bgelib-tag-put in this-procedure ( input 3, input "FCIExtName", input string(if available (buf_ext-system) then buf_ext-system.esys-name else ""), input 1 ).                  
                        run bgelib-tag-close in this-procedure ( input 2, input "FuelCodeInfo").
                     end.       
                  end.				  
				  end.
               end.  
            end.
            else 
            do:    
               run bgelib-tag-open in this-procedure ( input 2, input "FuelCodeInfo", input substitute("ctrl='&2' code='&1'", "*", "DEL":u)).
               run bgelib-tag-close in this-procedure ( input 2, input "FuelCodeInfo").
            end.
         end.
      end.
   end.
end procedure. /* putc-par */

/* $Workfile$ e n d */
