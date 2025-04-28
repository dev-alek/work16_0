block-level on error undo, throw.

{ utl/runpro.i }

define input parameter gdsCode as integer no-undo .
define input parameter unitsName as character no-undo .
do transaction:
  disable triggers for load of ub.goods .
  disable triggers for load of ub.bar-code .
 
  find first ub.goods exclusive-lock where ub.goods.gds-code = gdsCode no-error .
  if not available (ub.goods) then 
  do:
    message "Нет такого товара"
      view-as alert-box.
    return .
  end.
  find first ub.units no-lock where ub.units.unit-name = unitsName no-error .
  if not available (ub.units) then 
  do:
    message "Нет такой ед.изм."
      view-as alert-box.
    return .      
  end.  
  ub.goods.unit-base = unitsName .
  find first ub.bar-code exclusive-lock where ub.bar-code.b-code = ub.goods.gds-code no-error .
  if available (ub.bar-code) then ub.bar-code.unit-cli = unitsName .
  message "Ед.изм. изменена."
    view-as alert-box.

end.