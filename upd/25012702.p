block-level on error undo, throw.
define input  parameter iParam as character no-undo.
define output parameter oOK as logical no-undo.

define variable vBufSysCtrl as handle no-undo.
define variable vBufPlace as handle no-undo.
define variable vBufPlaceAttr as handle no-undo.

create buffer vBufSysCtrl for table "sys-ctrl".
vBufSysCtrl:find-first ("" , no-lock) no-error.

if (vBufSysCtrl:available
and vBufSysCtrl:buffer-field("db-num"):buffer-value() eq 0)
or not vBufSysCtrl:available
then do :
  oOK = true .
  delete object vBufSysCtrl .
  return .
end .

create buffer vBufPlace for table "place" .
vBufPlace:find-first ("" , no-lock) no-error.

if vBufPlace:available
then do:
  create buffer vBufPlaceAttr for table "place-attr" .
  vBufPlaceAttr:find-first ("where place-attr.attr-code eq 'init-shift-period-rvs'", no-lock) no-error.
  oOK = vBufPlaceAttr:available .
  delete object vBufPlaceAttr .
end .
else
  oOK = true .
  
delete object vBufPlace .