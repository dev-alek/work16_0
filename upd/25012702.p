block-level on error undo, throw.

define input  parameter iParam as character no-undo.
define output parameter oOK as logical no-undo.

define variable vBufSysCtrl as handle no-undo.
define variable vBufPlace as handle no-undo.
define variable vBufPlaceAttr as handle no-undo.
define variable vBufPlGds as handle no-undo.
define variable vBufGoodsAttr as handle no-undo.

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
delete object vBufSysCtrl .

create buffer vBufPlace for table "place" .
vBufPlace:find-first ("" , no-lock) no-error.

if vBufPlace:available
then do:
  create buffer vBufPlaceAttr for table "place-attr" .
  vBufPlaceAttr:find-first ("where place-attr.attr-code eq 'init-shift-period-rvs'", no-lock) no-error.
  oOK = vBufPlaceAttr:available .
  delete object vBufPlaceAttr .
  
  if not oOK
  then do :

    /* если газ то OK  */
    create buffer vBufPlGds for table "pl-gds" .
    vBufPlGds:find-first (substitute ("where pl-gds.pl-code eq &1", vBufPlace:buffer-field("pl-code"):buffer-value), no-lock) no-error.
    if vBufPlGds:available
    then do :
      create buffer vBufGoodsAttr for table "goods-attr" .
      vBufGoodsAttr:find-first (substitute ("where goods-attr.attr-code eq 'fuel-type' and goods-attr.gds-code eq &1", vBufPlGds:buffer-field("gds-code"):buffer-value), no-lock) no-error.
      if vBufGoodsAttr:available
      then do :
        if vBufGoodsAttr:buffer-field("attr-value"):buffer-value = "lgas"
        or vBufGoodsAttr:buffer-field("attr-value"):buffer-value = "metan"
        or vBufGoodsAttr:buffer-field("attr-value"):buffer-value = "propan"
        then oOK = true .
      end .
      else
        oOK = true .
        
      delete object vBufGoodsAttr .
    end .
    else
      oOK = true .
    
    delete object vBufPlGds .
  end .
end .
else
  oOK = true .
  
delete object vBufPlace .
