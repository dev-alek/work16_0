define input  parameter iSummMax as decimal no-undo.
define output parameter OSumm as decimal no-undo.
define output parameter oOsnBag as character no-undo.
define output parameter oDopBag as character no-undo.
define output parameter oMoney  as character no-undo.
define output parameter oOk     as logical no-undo.


define variable mincas as class ibs.th.ref.incas no-undo.
do trans:    
mincas = new ibs.th.ref.incas().

wait-for  mincas:ShowDialog() .
end.
if mincas:DialogResult = System.Windows.Forms.DialogResult:Ok
   then 
do:
   OSumm = mincas:mSumm.
   oOsnBag = mincas:mosnbag.
   oDopBag = mincas:mosnbag.
   oMoney  = mincas:mMoney.
   oOk = yes.
end.
finally:
   delete object mincas.
end finally.