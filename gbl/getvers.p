/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получить имя текущей версии

Автор: Суслов Алексей Юрьевич
Дата создания: 03/24/06
Author: Alexey Suslov
Creation date: 03/24/06

*/

define output parameter p-version-name as character no-undo .

do
on error undo, return error return-value
:
  assign
    p-version-name = "16.0":u
  .
end.