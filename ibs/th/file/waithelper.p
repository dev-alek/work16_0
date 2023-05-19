define input  parameter mhelper as ibs.th.file.asynchelperTh no-undo.
define input  parameter iSched as character no-undo.
define input  parameter ipInterval as int64 no-undo.
define input  parameter itext as character no-undo.
{gbl\waitfram.i}

/*define variable vCountOld as integer init -1 no-undo.*/
     
procedure WaitFramStop:
      define variable vCount as integer no-undo.
  define variable vi as integer no-undo.
      if    mWaitFramStop
         or mhelper:mStop
         or not mhelper:FileExists(mhelper:MyWorkDir + "Stop.txt")
      then do:
         mhelper:mStop = yes.
         mWaitFramStop = yes.
         mhelper:SendStop(iSched).
         mWaitFramInterval = ipInterval.
         define variable vWaitFramStartProc          as datetime-tz no-undo.
         vWaitFramStartProc = now.
         block-waitshow:
         do vi = 1 to 10:
            define variable vtime as int64 no-undo.
            vtime = ( now - vWaitFramStartProc  ) / 1000 .
       
            run waitfram-show (substitute("&1 Отправлена команда прерывания. Ожидаем завершения процесса. Прошло: &2 сек. из 10 сек. &3" ,
                               mWaitFramTextBeg , 
                               string( vtime),
                               mWaitFramTextEnd
                                         )
                              ).
            if mhelper:WaitStopEnd(iSched, 0)
            then
               leave block-waitshow.
         end.
         publish "PutFileLogAsunc"  ("Операция прервана пользователем." ).
         mhelper:EndStopEnd(iSched).
         mhelper:mStop = no.
         mhelper:WAIT-FOR-COMPLETE = true. /* процес завис */
           
      end.
      else do:
         mhelper:WAIT-FOR-COMPLETE = true.
/*         vCount = mhelper:vCountEnd + */ 
         mhelper:WaitForOne(iSched) .
         /*if (not mhelper:WAIT-FOR-COMPLETE 
         and
              /*or (    mhelper:myTimeOut    ne 0
                  and mhelper:myTimeOut    ne ?
                  and vCountOld    = vCount
                  and dec(now - vStart) / 1000 > mhelper:myTimeOut
                  )*/ 
               )
              or mhelper:mstop
          then do:
             mhelper:WaitForStop (iSched).
             
/*             oOK = false.*/
             
          end.   
        /*  else
             vCountOld = vCount.*/ */
          mWaitFramStop = mhelper:WAIT-FOR-COMPLETE.
      end.
      mWaitFramTextend = mhelper:getStatus(iSched).
end.
/*
procedure WaitFor:
/*( input iSched as character, input ipInterval as int64):*/
/*define input  parameter p-message as character no-undo.*/
define input  parameter iInterval as int64 no-undo.
define output parameter oOk as logical no-undo.
/*       define variable vNowTask as character  no-undo.*/
       define variable vCountOld as integer init -1 no-undo.
       define variable vCount as integer no-undo.
/*       define variable vOK as logical no-undo initial true.*/
       
/*      output to value (mhelper:getLog(iSched) ).*/
      define variable vStart  as datetime-tz no-undo.
      vStart = now.
/*      output close.*/
       mhelper:vCountend = 0. 
/*       vNowTask          = iSched.*/
       mhelper:WAIT-FOR-COMPLETE = false.      /* на всякий случай */
       mhelper:mstop = no.
       do while not mhelper:WAIT-FOR-COMPLETE:
          /*if not WaitFor (vNowTask, ipInterval, true) then return false.*/
          
          mhelper:WAIT-FOR-COMPLETE = true.
          vCount = mhelper:vCountEnd + mhelper:WaitForOne(iSched) .
          if (not mhelper:WAIT-FOR-COMPLETE 
           and not mhelper:FileExists(mhelper:MyWorkDir + "Stop.txt")
           or (    mhelper:myTimeOut    ne 0
               and mhelper:myTimeOut    ne ?
               and vCountOld    = vCount
               and dec(now - vStart) / 1000 > mhelper:myTimeOut
              )) 
              
              or mhelper:mstop
          then do:
             mhelper:WaitForStop (iSched).
             oOK = false.
             mhelper:WAIT-FOR-COMPLETE = true. /* процес завис */
          end.   
          else
             vCountOld = vCount.
          if not mhelper:WAIT-FOR-COMPLETE
          then do:
             subscribe   to "WaitFramStop" anywhere.
             run WaitFramRunPause(ipInterval).
             unsubscribe   to "WaitFramStop".
          end.
       end. 
       return.
   end .
   */
mWaitFramView = not mhelper:InAsyncProc.

mWaitProcEvent = no.   
mWaitFramTextBeg = itext.
mWaitFramStartProc = now.
output to value(mhelper:MyWorkDir + "Stop.txt").
output close.
mhelper:vCountend = 0.
subscribe   to "WaitFramStop" anywhere.
run WaitFramWaitFor(ipInterval).
unsubscribe   to "WaitFramStop".
/*mWaitFramTextBeg = "".*/
/*run waitfram-hide.    */
  /*
  define variable vFlag as logical no-undo.
  if not session:batch-mode
     this-object:MyPause:Subscribe(this-object:waitfram-show).*/
/*     mShowFrame = yes.*/
/*  run WaitFor(/*iSched,*/ipInterval,output vflag).*/
  
  /*finally:*/
/*  run gbl\inidebug.p.*/
     mWaitFramTextBeg = "".
     run waitfram-hide.
     
/*     mShowFrame = no.*/
     /*if not session:batch-mode
     then
        this-object:MyPause:Unsubscribe(this-object:waitfram-show).*/
  /*end finally.*/
  return.
  