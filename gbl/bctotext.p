/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает текст для штрих-кода

Автор: Перваков Михаил Сергеевич
Дата создания: 10/26/04
Author: Mikhail Pervakov
Creation date: 10/26/04

*/

define input  parameter p-bar-code-type as character no-undo .
define input  parameter p-bar-code      as character no-undo .
define output parameter p-text          as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Возвращает текст для штрих-кода".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/bar-code.i }

define variable v-bit-string as character no-undo .

do
on error undo, return error return-value
:
  case p-bar-code-type
  :
    when {&barcode-ean8}
    then do:
      run bar-code_ean8 in this-procedure
        (input  p-bar-code
        ,output v-bit-string
        ) .
    end.
    when {&barcode-ean13}
    then do:
      run bar-code_ean13 in this-procedure
        (input  p-bar-code
        ,output v-bit-string
        ) .
    end.
    when {&barcode-3of9}
    then do:
      run bar-code_3of9 in this-procedure
        (input  p-bar-code
        ,output v-bit-string
        ) .
    end.
    when {&barcode-ean128}
    then do:
      run bar-code_ean128 in this-procedure
        (input  p-bar-code
        ,output v-bit-string
        ) .
    end.

  end case .

  run bar-code_bit-string-to-text in this-procedure
    (input  v-bit-string
    ,output p-text
    ) .

end.