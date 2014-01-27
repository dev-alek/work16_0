/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает компоненты имени существующего файла

Автор: Перваков Михаил Сергеевич
Дата создания: 12/18/01
Author: Mikhail Pervakov
Creation date: 12/18/01

Ищет файл в propath
Если не находит, возвращает ошибку

*/

define input  parameter p-search-file-name as character no-undo .
define output parameter p-full-path        as character no-undo .
define output parameter p-path             as character no-undo .
define output parameter p-file-name        as character no-undo .
define output parameter p-file-name-no-ext as character no-undo .
define output parameter p-file-name-ext    as character no-undo .


def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Возвращает компоненты имени файла".
{ cmp/vssrevis.i "substitute('&1',p-search-file-name)" }
{ cmp/str-glbl.i }

do
on error undo, return error return-value
:
  def var v-full-pathname as character no-undo .

  define variable v-path-split as integer   no-undo .

  assign
    v-full-pathname = search(p-search-file-name)
  .

  if v-full-pathname = ""
  or v-full-pathname = ?
  then do:
    return error substitute("Файл &1 не найден", p-search-file-name) .
  end.

  assign
    file-info :file-name = v-full-pathname
  .
  assign
    v-full-pathname = file-info :full-pathname
  .
  assign
    p-full-path = v-full-pathname
  .
  if index(file-info :file-type, 'F':U) = 0
  then do:
    undo, return error "В качестве параметра указан не файл" + {&space-char} + v-full-pathname .
  end.

  assign
    v-path-split = r-index(p-full-path, '\':u)
  .
  if v-path-split = 0 then do:
    undo, return error "Невозможно определить имя файла" + {&space-char} + v-full-pathname .
  end.
  assign
    p-path      = substring(p-full-path, 1, v-path-split - 1)
    p-file-name = substring(p-full-path, v-path-split + 1)
  .

  /* определяем расширения файла */
  define variable v-ext-split as integer   no-undo .
  assign
    v-ext-split = r-index(p-file-name, '.':u)
  .
  if v-ext-split > 0 then do:
    assign
      p-file-name-no-ext = substring(p-file-name, 1, v-ext-split - 1)
      p-file-name-ext    = substring(p-file-name, v-ext-split + 1)
    .
  end.
  else do:
    assign
      p-file-name-no-ext = p-file-name
      p-file-name-ext    = ""
    .
  end.

  /* нормализуем имя файла для файла с пустым расширением */
  if p-file-name-ext = "" then do:
    assign
      p-file-name = p-file-name-no-ext
    .
  end.

  /* нормализуем полный путь к файлу */
  assign
    p-full-path = p-path + '\':u + p-file-name
  .
end.