/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Возвращает дополнительные языки языковой базы данных

Автор: Суслов Алексей Юрьевич
Дата создания: 04/12/06
Author: Alexey Suslov
Creation date: 04/12/06

*/

do
on error undo, return error return-value
:
  define output parameter parlang as character no-undo .

  for each xl_language no-lock
  on error undo, return error
  :
    assign
      parlang = parlang
              + min(parlang, ",")
              + xl_language.lang_name
    .
  end.

end.