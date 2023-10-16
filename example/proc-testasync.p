{ utl/proc-async.i proc_def}
define variable mPid as int64 no-undo.
run utl/getpid.p(output mPid).
run PutStatAsunc("Тестовый процес PID " +  string(mPid) + " старт").
mAsyncHelper:NextLog(yes).
pause 200.
run PutStatAsunc("Тестовый процес PID " +  string(mPid) + " стоп").
{ utl/proc-async.i proc_end}
