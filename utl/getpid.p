define output parameter OPID as int64 no-undo.
run GetCurrentProcessId
      (output OPID
      ) .


procedure GetCurrentProcessId external "kernel32.dll"
:
  define return parameter RetVal          as LONG.
end procedure.