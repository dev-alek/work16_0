
&glob fbr-rsrv-log-file-name 'fbr-rsrv-errors.txt'

define variable v-fbr-log-file-name as character no-undo init {&fbr-rsrv-log-file-name}.
define stream fbr-rsrv-fs.

procedure init-fbr-rsrv-log:
  os-delete value(v-fbr-log-file-name) no-error.
end.

procedure write-fbr-rsrv-log:
  define input parameter p-mes as character no-undo.
  
  output stream fbr-rsrv-fs to value(v-fbr-log-file-name) append unbuffered.
  put stream fbr-rsrv-fs unformatted p-mes {&new-line}.
  output stream fbr-rsrv-fs close.
end.

procedure show-fbr-rsrv-log:
  
end.