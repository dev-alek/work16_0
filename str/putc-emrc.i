 /*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура отслыки справочника оснований чеков коррекций

Автор: Шкляр Елена
Дата создания: 02/14/14
Author: Elena Shklyar
Creation date: 02/14/14

*/


&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".
{ cmp/str-glbl.i  }

procedure putc-emrc :
define input parameter iSAXWriter as handle no-undo .
define input parameter p-pos-type as character  no-undo .
define input parameter p-version  as character  no-undo .
define input parameter p-cash-os  as character  no-undo .
define input parameter p-cash-num as integer   no-undo .
define input parameter p-value    as character no-undo .
define buffer code for ub.code.
define variable vi as integer no-undo.
  define variable vDate  as character no-undo.
  for each code where Code.parent = "EMC"  
  on error undo, return error
  : 
      iSAXWriter:start-element("EMRC_Type") .
         iSAXWriter:insert-attribute("ctrl",   if Code.status_ eq {&bef-current-status-int} then "ADD" else "DEL").
         iSAXWriter:insert-attribute("tsm",    "0").
         iSAXWriter:insert-attribute("code",    string(int(Code.code))).

         iSAXWriter:write-data-element("EMRC_TypeName" , Code.CodeName ) .
      iSAXWriter:end-element("EMRC_Type" ).
   end.
  vdate = iso-date(today - 93).
  find last code where Code.parent begins "EMC" + {&delim-par} and code.code < vdate
  no-lock no-error.
  if avail code
  then
     vdate = code.code.
  for each code where Code.parent begins "EMC" + {&delim-par} and code.code >= vdate 
  on error undo, return error
  : 
      define variable vcode as character no-undo.
      define variable vEMRCDate as character no-undo.
    /*  vEMRCDate =  trim(string( ( (date(Code.misc1) - date( "01/01/1970" ) )* 24 * 3600 + 1 ), ">>>>>>>>>9" )). */
      vEMRCDate = Code.code + "00:00:00".
      vcode = entry(2,Code.parent,{&delim-par}).
      vi = vi + 1.
      iSAXWriter:start-element("EMRC_Value") .
         iSAXWriter:insert-attribute("ctrl",   if Code.status_ eq {&bef-current-status-int} then "ADD" else "DEL").
         iSAXWriter:insert-attribute("tsm",    "0").
         iSAXWriter:insert-attribute("code",    string(vi)).

         iSAXWriter:write-data-element("EMRC_ValueType" , trim(string(dec(vcode),">>>>9.9")) ) .
         iSAXWriter:write-data-element("EMRC_ValueData" , vEMRCDate).
         iSAXWriter:write-data-element("EMRC_ValuePrice" , Code.CodeValue).
      iSAXWriter:end-element("EMRC_Value" ).
   end.

end procedure. /* putc-par */

procedure putc-emrcdel :
define input parameter iSAXWriter as handle no-undo .
define input parameter p-pos-type as character  no-undo .
define input parameter p-version  as character  no-undo .
define input parameter p-cash-os  as character  no-undo .
define input parameter p-cash-num as integer   no-undo .
define input parameter p-value    as character no-undo .
   iSAXWriter:start-element("EMRC_Type") .
      iSAXWriter:insert-attribute("ctrl",   "DEL").
      iSAXWriter:insert-attribute("tsm",    "0").
      iSAXWriter:insert-attribute("code",    "*").
   iSAXWriter:end-element("EMRC_Type" ).
   
   iSAXWriter:start-element("EMRC_Value") .
      iSAXWriter:insert-attribute("ctrl",   "DEL").
      iSAXWriter:insert-attribute("tsm",    "0").
      iSAXWriter:insert-attribute("code",    "*").
   iSAXWriter:end-element("EMRC_Value" ).
  end procedure. /* putc-par */

/* $Workfile$ e n d */