block-level on error undo, throw.

{ cmp/str-glbl.i }
{ ref/gds-attr.i }
{ str/placelib.i }

define input  parameter iParam as character no-undo.
define output parameter oOK as logical no-undo.
define buffer buf_pl-gds for ub.pl-gds .

define variable vBufSysCtrl as handle no-undo.
define variable vBufPlace as handle no-undo.
define variable vBufPlaceAttr as handle no-undo.
define variable v-value as character no-undo .
define variable par-type as character no-undo .

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

    /* если газ то OK  */
    find first buf_pl-gds no-lock where buf_pl-gds.pl-code = vBufPlace:buffer-field("pl-code"):buffer-value no-error .
    &scop proc-name gds-attr-value
    {&run_proc_attr-lib}
      (input  buf_pl-gds.gds-code
      ,input  {&attr-fuel-type}
      ,output v-value
      ,output par-type) no-error.
    if v-value = "lgas"
    or v-value = "metan"
    or v-value = "propan"
    then oOK = true .

end .
else
  oOK = true .





  
delete object vBufPlace .