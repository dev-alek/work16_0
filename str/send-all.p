/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отсылка схемы интеграции ККТ

Автор: Шкляр Елена
Дата создания: 02/14/14
Author: Elena Shklyar
Creation date: 02/14/14

Input:

Output:

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-parent-handle  as widget-handle no-undo .
define input parameter p-log-handle  as handle no-undo .
define input parameter p-parameter   as character no-undo .


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Отсылка схемы интеграции ККТ".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }


define variable i-obj-type as character no-undo .
define variable i-obj-code as integer   no-undo .
define variable i-action   as character no-undo init 'U':U.
define variable i-type     as character no-undo .
define variable i-title     as character no-undo .
define variable i-value    as character no-undo .
/*define stream str-log .*/
/*output stream  str-log to value("shema-KKT.log") append.*/

assign
i-obj-type = entry(1, p-parameter, {&delim-par})
i-obj-code = integer(entry(2, p-parameter, {&delim-par}))
i-action     = entry(3, p-parameter, {&delim-par})
i-Type    = entry(4, p-parameter, {&delim-par})
i-Title    = entry(5, p-parameter, {&delim-par})
i-value    = entry(6, p-parameter, {&delim-par})
no-error
.

{ str/cdsnddef.i }
{ bge/bgelib.i }
{ str/cd-xml.i }
{ gbl/cd-attr.i }
{ bge/socet.i}
     
FIND FIRST ub.cash-desk NO-LOCK WHERE
           ub.cash-desk.db-num = g#db-num AND
           ub.cash-desk.pos-type = {&cd-type-IBM-XML} AND
           ub.cash-desk.obj-code = i-obj-code
            No-error.
IF not avail(cash-desk) then do:
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute( "!!!'&1' реализуется только для касс &3 "
                          , i-Title
                          , {&cd-type-ibm-xml}
                        )
                        ).
  return.
end.


{ str/putc-emrc.i }

/*PROCEDURE for-cash-cycle*/
/*пройдем цикл по всем кассам одного типа*/
{ str/cd-cyall.i }

/*PROCEDURE SENDING.*/
{ str/cd-seall.i }

RUN SENDING no-error.

if error-status:error then do:
  run write-log-and-file in p-log-handle (
        input 1
      , input log-file-name
      , input 1
      , input substitute( "!!!Ошибки при отсылке '&3' на кассы &1&2"
                         , i-obj-type, i-obj-code, i-Title
                        )
                                        ).
end.




