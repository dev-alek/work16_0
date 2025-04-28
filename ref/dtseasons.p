block-level on error undo, throw.
/*

$Revision: $
$Author: $
$Date: $
$Workfile: $
$Archive: $

Процедура запуска выбора из справочника "Сезоны ДТ"

Автор: Ростовцев Александр
Дата создания: 18/09/23
Author: Rostovtsev Aleksandr
Creation date: 18/09/23

*/

define input  parameter iParentProc as widget-handle no-undo .
define output parameter oId         as recid         no-undo init ? .

{ gbl/tmprecid.i "new shared"}

run ref/codelay.p
  (input  iParentProc
  ,input  {&select}
  ,input  ""
  ,input  "DTSeasons"
  ,input  ?
  ) .
run rid-rest.
find tmprecid no-error.
if available tmprecid then 
do:
  oId = tmprecid.frecid.
end.
else 
do:
  find first tmprecid no-error.
  if available tmprecid then
  do:
    return error "Можно выбрать только одну запись ~"Сезона ДТ~".".
  end.
end.
