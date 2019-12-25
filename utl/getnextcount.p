define input  parameter iFileName as character no-undo.
define input  parameter ikey      as character no-undo.
define input  parameter icode     as character no-undo.
define output parameter oCount    as int64 no-undo.
 
 define variable mCounterStor as class ibs.th.ref.counter.counterstorage.
 mCounterStor = new ibs.th.ref.counter.counterstorage().
 oCount = mCounterStor:GetAsuncNextcount(iFileName, ikey, icode ).
 delete object mCounterStor.
 