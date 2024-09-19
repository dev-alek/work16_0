define new global shared variable mBatchMode as logical no-undo init ?.
define variable mWaitFramHandle as handle no-undo.      
mWaitFramHandle = frame {1}:handle.
 
define variable mFameOldVis as logical no-undo.
define variable mVisCUrentVin as logical no-undo.

if mBatchMode = ? then do:
  mVisCUrentVin = current-window:visible.
  mFameOldVis = mWaitFramHandle:visible.
  mWaitFramHandle:visible  = yes.
  mBatchMode = not mWaitFramHandle:visible.
  mWaitFramHandle:visible = mFameOldVis.
  current-window:visible = mVisCUrentVin.
end.
