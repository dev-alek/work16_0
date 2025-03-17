/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: 
Дата: создания: 
Author:  
Created: 
Modified: 

Description: Утилита для смены коэффициента ЕИ собственного БК  
*/

define input parameter parparentproc    as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle     as handle no-undo .
define input parameter p-parameter      as character no-undo .

define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
define variable v-curr-r-b as character no-undo .
define variable v-base-code like ub.sysconf.base-code no-undo .
&glob main-tbl  bar-code

{ trg/trghistnws.i }
{ nws/bintrnpr.i }

define variable p-db-num      as integer   no-undo .
define variable p-from-db-num as integer   no-undo .
define variable p-file-num    as integer   no-undo .
define variable res           as character no-undo.
define variable NewCoef as decimal no-undo .
define variable Barcode as character no-undo .
define buffer buf_ext-file-par for ext-file-par.

assign
   p-db-num             = integer(entry(1, p-parameter, {&delim-par}))
   p-from-db-num        = integer(entry(2, p-parameter, {&delim-par}))
   p-file-num           = integer(entry(3, p-parameter, {&delim-par}))
no-error. 
if error-status:error then do:
  return error substitute("Ошибка передачи входных параметров в процедуру &1&2&3&2"
                       , (this-procedure:filename)
                       , {&new-line}
                       , error-status:get-message(1)).
end.

for each buf_ext-file-par where
         buf_ext-file-par.db-num = p-db-num
     and buf_ext-file-par.from-db-num = p-from-db-num
     and buf_ext-file-par.file-num = p-file-num
    no-lock:
      if buf_ext-file-par.param-type = {&type-char} then do: 
       if buf_ext-file-par.param-num = 1 then  Barcode = buf_ext-file-par.param-value.
       if buf_ext-file-par.param-num = 2 then  NewCoef = dec(buf_ext-file-par.param-value). 
  end. 
end.

if NewCoef = 0 or Barcode = ""  then do:
  return error substitute("Ошибка передачи параметров в процедуру &1&2&3&2"
                        , (this-procedure:filename)
                        , {&new-line}
                        , "Значения должно быть не 0.").
end.

define variable mImp2CdH as handle no-undo.
run str/imp2cdgeth.p(output mImp2CdH).

do transaction:
	find first ub.prod-bc where ub.prod-bc.b-str = Barcode no-error .
	if available (ub.prod-bc) then 
        do:
	   find first ub.bar-code exclusive-lock where ub.bar-code.b-code = ub.prod-bc.b-code no-error .
	      if available (ub.bar-code) then 
	      do:  
                           find first ub.goods no-lock where ub.bar-code.gds-code = ub.goods.gds-code 
                           and ub.bar-code.unit-cli <> goods.unit-base no-error.

                                if available ub.goods then 
                                do:  
                                    ub.bar-code.cli-base-rate = DECIMAL(NewCoef) .
                                    /* отправка товара на кассы */
                                    run fill-g-list in mImp2CdH  ( input ub.goods.gds-code, input ?, input ?).
                                    res = substitute("БД: &1; Время запуска: &2 &3; Изменен коэф. для баркода: &4. Товар отправлен на касссы ", 
                                    p-db-num, string(today, "99/99/9999"), string(time, "HH:MM:SS"), Barcode ).
                                end.

                                else do:
	                             res = substitute( "БД: &1; Время запуска: &2 &3; Нельзя изменять коэф. для баркода: &4. ",                                      
                                     p-db-num, string(today, "99/99/9999"), string(time, "HH:MM:SS"), Barcode ).                               	                   	                                           	         
                                end.
              end.

	      else do:
	           res = substitute("БД: &1; Время запуска: &2 &3; Не найден баркод: &4.", p-db-num, string(today, "99/99/9999"), string(time, "HH:MM:SS"), 
                   Barcode ).
              end.
        END.
END. 

run ext-file-par-write-and-send (
      input  p-db-num
      ,input  p-from-db-num
      ,input  p-file-num
      ,input -1 /*p-param-num      */
      ,input {&type-char} /*p-value-type */
      ,input "Результат" /* p-value-name */
      ,input res /*p-value-char */
      ,input ? /*p-value-date */
      ,input 0 /* p-value-integer */
      ,input 0 /* p-value-decimal */
      ,input no /*p-value-logical */
      ,input yes /*p-send*/
      ,input string(g#news-source-db)
   ) no-error .

return res.