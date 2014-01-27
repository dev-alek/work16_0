/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Cоздание библиотеки из r-кодов

Автор: Перваков Михаил Сергеевич
Дата создания: 03/13/06
Author: Mikhail Pervakov
Creation date: 03/13/06

Параметры:
p-rc-dic-name  директория с r-кодами
p-pl-file-name директория для создания библиотеки

*/

define input parameter p-rc-dic-name  as character no-undo .
define input parameter p-pl-file-name as character no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
define variable v-startup-filename as character no-undo .
define variable v-command-filename as character no-undo .

do
on error undo, return error return-value
:
  define stream slog .

  run gbl/_tmpfile.p
    (input  "f":u
    ,input  ".pf":u
    ,output v-startup-filename
    ) .
  run gbl/_tmpfile.p
    (input  'f':u
    ,input  '.bat':u
    ,output v-command-filename
    ).

  /* создается файл конфигурации */
  output stream slog to value(v-startup-filename) no-echo .
  put stream slog unformatted
    '-cpcase '     session :cpcase     skip
    '-cpcoll '     session :cpcoll     skip
    '-cpinternal ' session :cpinternal skip
    '-cpstream '   session :cpstream   skip
    .
  output stream slog close.

  define variable v-dlc-dir-name as character no-undo .

  get-key-value section "startup" key "dlc" value v-dlc-dir-name .

  /* создается командный файл */
  output stream slog to value( v-command-filename ) no-echo.
  put stream slog unformatted
    '@ echo off':u skip
    'set dlc=':u v-dlc-dir-name skip
    substring(p-rc-dic-name, 1, 2) skip
    'cd ':u + p-rc-dic-name skip
    .
  put stream slog unformatted
    v-dlc-dir-name + '\bin\prolib ':u + p-pl-file-name + ' -cre -add *.* -pf ' + v-startup-filename skip
    .
  output stream slog close.

  /* удаление предыдущей библиотеки */
  if search(p-pl-file-name) <> ? then do:
    os-rename value(p-pl-file-name) value(p-pl-file-name + '.old').
    os-delete value(p-pl-file-name) .
  end.

  /* процедура создания библиотеки */
  os-command silent value(v-command-filename) .

  /* удаление файлов конфигурации и командного файла */
  os-delete value(v-command-filename) .
  os-delete value(v-startup-filename) .

end.