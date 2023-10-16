/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получение истории по резервуару и атрибутам

Автор: Шкляр Елена
Дата создания: 05/23/06
Author: Andrew Bulgakoff
Creation date: 05/23/06

*/


procedure c-place_get-attr :
  define input parameter attr-code as character no-undo .
  define input parameter obj-code as integer no-undo .
  define input parameter obj-type as character no-undo .
  define input parameter pl-code as integer no-undo .
  define input parameter endDate as date no-undo .
  define input parameter endTime as integer no-undo .
  define output parameter attr-value as character no-undo .
  
  define buffer bf_c-place-attr     for ub.c-place-attr .
  define variable is-place-attr as logical no-undo .
  
    find last bf_c-place-attr no-lock where bf_c-place-attr.pl-code = pl-code and
      bf_c-place-attr.obj-code = obj-code and
      bf_c-place-attr.obj-type = obj-type and
      bf_c-place-attr.attr-code = attr-code and
      ((bf_c-place-attr.corr-date = endDate and 
      bf_c-place-attr.corr-time < endTime) or 
      bf_c-place-attr.corr-date < endDate) no-error .
    if available (bf_c-place-attr) then attr-value = bf_c-place-attr.attr-value .
    else attr-value = "true" .

end procedure. 

FUNCTION get_meas returns logical (
  input obj-code as integer, 
  input obj-type as character,
  input pl-code as integer,
  input endDate as date,
  input endTime as integer ):
  
  define buffer bf_c-place     for ub.c-place .
  define buffer bf_place       for ub.place .
  
  find last bf_c-place no-lock where bf_c-place.pl-code = pl-code and
    bf_c-place.obj-code = obj-code and
    bf_c-place.obj-type = obj-type and
    ((bf_c-place.corr-date = endDate and 
    bf_c-place.corr-time < endTime) or 
    bf_c-place.corr-date < endDate) no-error .
  if available (bf_c-place) then return not bf_c-place.is-meas .
  else 
  do:
    find first bf_place no-lock where bf_place.pl-code = pl-code and
      bf_place.obj-code = obj-code and
      bf_place.obj-type = obj-type no-error .
    return bf_place.is-meas .
  end.
 
end function. 