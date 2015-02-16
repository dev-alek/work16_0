 /*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура отслыки справочника ОСС

Автор: Морозов Александр Сергеевич
Дата создания: 02/14/14
Author: Alexandr Morozov
Creation date: 02/14/14

*/


&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

{ ref/extclass.i }

procedure putc-oss :
define input parameter p-pos-type like ub.cash-desk.pos-type no-undo .
define input parameter p-version like ub.cash-desk.version no-undo .
define input parameter p-cash-os like ub.cash-desk.cash-os no-undo .
define input parameter p-cash-num like ub.cash-desk.cash-num  no-undo .
define input parameter p-is-del as logical no-undo .

define buffer buf_ext-classif for ub.ext-classif.

define variable ii as integer no-undo.

  do
  on error undo, return error
  :

    if p-is-del then do:
      for each buf_ext-classif where buf_ext-classif.classif-subject = {&extclass_oss-ref} no-lock by buf_ext-classif.Key#_One :
        ii = ii + 1.
        run bgelib-tag-open in this-procedure ( input 2, input "OperServ", input substitute("ctrl='&2' code='&1'", string (ii), "ADD":u)).
          run bgelib-tag-put in this-procedure ( input 3, input "OSCode":U, input string (buf_ext-classif.Key#_One), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSName":U, input if ub.cash-desk.pos-type = {&cd-type-IBM-XML} then entry (1, buf_ext-classif.CharKey_Two, {&delim-par}) else buf_ext-classif.CharKey_One, input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSQuantMin":U, input trim(string(entry(2, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSQuantMax":U, input trim(string(entry(3, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSGroup":U, input string (buf_ext-classif.Key#_Two), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSSumMin":U, input trim(string(entry(4, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSSumMax":U, input trim(string(entry(5, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSSumAtent":U, input trim(string(entry(6, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSComType":U, input trim(string(entry(7, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSComPerc":U, input trim(string(entry(8, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSComSum":U, input trim(string(entry(9, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSPreAvt":U, input trim(string(entry(10, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSPreSlip":U, input trim(string(entry(11, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSSlipName":U, input trim(string(entry(12, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
          run bgelib-tag-put in this-procedure ( input 3, input "OSCalcType":U, input trim(string(entry(13, buf_ext-classif.CharKey_Two, {&delim-par}))), input 1 ).
        run bgelib-tag-close in this-procedure ( input 2, input "OperServ").    
  
      end.
      ii = 0 .
    end.
    else do:
      run bgelib-tag-open in this-procedure ( input 2, input "OperServ", input substitute("ctrl='&2' code='&1'", "*", "DEL":u)).
      run bgelib-tag-close in this-procedure ( input 2, input "OperServ").
    end.
  end.

end procedure. /* putc-par */

/* $Workfile$ e n d */