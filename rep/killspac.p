/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Закавычивание пробелов в именах файлов и директорий

Автор: Бахтадзе Наталья Викторовна
Дата создания: 03/24/06
Author: Bakhtadze Natalya
Creation date: 03/24/06

*/

define input-output parameter p-file-name as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Закавычивание пробелов в именах файлов и директорий".
{ cmp/vssrevis.i }


{ cmp/str-glbl.i }

DEFINE VARIABLE ii as integer no-undo .
DEFINE VARIABLE v-entry as character no-undo .

do
on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
:

  assign
    p-file-name = replace( p-file-name, {&back-slash-char} + {&back-slash-char}, {&delim-par} )
  .
  assign
  p-file-name = replace(p-file-name, {&back-slash-char}, {&slash-char})
  .

  do ii = 1 to num-entries(p-file-name, {&slash-char}) :
    if INDEX(entry(ii, p-file-name, {&slash-char}), {&space-char}) > 0 then do:
      assign
      entry(ii, p-file-name, {&slash-char}) = {&double-quote} + entry(ii, p-file-name, {&slash-char}) + {&double-quote}
      .
      assign
      p-file-name = trim(p-file-name, {&double-quote})
      .
    end.
  end.
  assign
    p-file-name = replace(p-file-name, {&delim-par}, {&back-slash-char} + {&back-slash-char} )
  .
end. /*doe*/