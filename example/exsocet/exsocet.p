define temp-table tt-socet no-undo
   field hSocet as handle
   field num    as int
index num num.
define variable vi as integer no-undo.
do vi = 1 to 1000:
   create tt-socet.
   tt-socet.num    = vi.
   run bge/socet.p persistent set tt-socet.hSocet.
   run setParam in tt-socet.hSocet ("TypeResponce","GET").
end.

for each tt-socet:
   run SendReqSocet in tt-socet.hSocet
                 ("localhost", 
                  "8080", 
                  "tst/DeferredCommand?123", 
                  "", 
                  "http", 
                  'getResponse').
end.

define variable vWorkSocet as logical no-undo.
find first tt-socet no-error.
do while available tt-socet:
   for each tt-socet:
      run WaitRespTestStop in tt-socet.hSocet.
      run isEndWork in tt-socet.hSocet (output vWorkSocet).
      if vWorkSocet
      then do:
         define variable vResult as longchar no-undo.
         run getResponceLongchar in tt-socet.hSocet (output vResult).
         delete procedure tt-socet.hSocet .
         delete tt-socet.
      end.            
   end.
   find first tt-socet no-error.
end.   
message "end."
view-as alert-box.
