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
  define buffer buf_c-place     for ub.c-place .
  define buffer bf_place       for ub.place .
  define variable ii as integer no-undo init 0.
  define variable is-meas as logical no-undo .
  define variable is-true as logical no-undo .

  find last bf_c-place no-lock where bf_c-place.pl-code = pl-code and
    bf_c-place.obj-code = obj-code and
    bf_c-place.obj-type = obj-type and
    ((bf_c-place.corr-date = endDate and 
    bf_c-place.corr-time < endTime) or 
    bf_c-place.corr-date < endDate) no-error .
  if available (bf_c-place) then 
  do:
    find last buf_c-place no-lock where buf_c-place.pl-code = bf_c-place.pl-code and
      buf_c-place.obj-code = bf_c-place.obj-code and
      buf_c-place.obj-type = bf_c-place.obj-type and
      ((buf_c-place.corr-date = bf_c-place.corr-date and 
      buf_c-place.corr-time < bf_c-place.corr-time) or 
      buf_c-place.corr-date < bf_c-place.corr-date) no-error .   
    if available (buf_c-place) then 
    do:
      if buf_c-place.is-meas <> bf_c-place.is-meas then return not bf_c-place.is-meas .
      else return bf_c-place.is-meas .
    end. 
    else 
    do:
      find first bf_place no-lock where bf_place.pl-code = pl-code and
        bf_place.obj-code = obj-code and
        bf_place.obj-type = obj-type no-error .
      return bf_place.is-meas .
    end.
  end. 
  else 
  do:
    find first bf_place no-lock where bf_place.pl-code = pl-code and
      bf_place.obj-code = obj-code and
      bf_place.obj-type = obj-type no-error .
    return bf_place.is-meas .
  end.
 
end function. 