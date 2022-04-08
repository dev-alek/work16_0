define input  parameter mhelper as ibs.th.file.asynchelperTh no-undo.
define input  parameter iSched as character no-undo.
define input  parameter ipInterval as int64 no-undo.
define input  parameter itext as character no-undo.

define variable v-waitfram-action01         as character no-undo .
define variable v-waitfram-action02         as character no-undo .
define variable v-waitfram-action03         as character no-undo .
define variable v-waitfram-prev-left-margin as integer   no-undo init 0 .
define variable mText                       as character no-undo.

define button B-stop auto-end-key
     label "Стоп"
     size 10 by 1 tooltip "Остоновить процесс".
define button B-viewProcInfo
     label "Информация"
     size 15 by 1 tooltip "Информация о процесс".

define variable MstarstProc as datetime-tz no-undo.

define frame waitfram
  v-waitfram-action01 format "x(72)" no-label skip
  v-waitfram-action02 format "x(72)" no-label skip
  v-waitfram-action03 format "x(72)" no-label skip
  B-viewProcInfo 
  B-stop at row 4 col 30
  with view-as dialog-box side-labels three-d cancel-button b-stop
  .
on choose of B-stop in frame waitfram /* Добавить в АМ */
do:
  mhelper:mStop = yes.
  
end.

/*on choose of B-viewProcInfo in frame waitfram /* Добавить в АМ */
do:
  run ref/runprocview.p (MyWorkDir,MyWorkDir).
end.
*/
function waitfram-hide returns character  () :

  do
  on error undo, return error return-value
  :
    pause 0 before-hide .
    hide frame waitfram .

/*&if "{1}" = "" &then
    process events .
&endif*/
  end.
end.

procedure waitfram-show :  
/*(input p-message as character,input iInterval as int64  ):*/
define input  parameter p-message as character no-undo.
define input  parameter iInterval as int64 no-undo.
  

  define variable v-left-margin as integer   no-undo .

  do
  on error undo, return error return-value
  :
    if length(p-message) <= 70 then do:
      assign
        v-left-margin = integer((70 - length(p-message)) / 2)
      .
      assign
        v-left-margin = max(0, v-left-margin - (v-left-margin mod 5))
      .
      if abs(v-left-margin - v-waitfram-prev-left-margin) > 5 then do:
        assign
          v-waitfram-prev-left-margin = v-left-margin
        .
      end.

      assign
        v-waitfram-action01 = " "
        v-waitfram-action02 = " "
                                 + fill(" ", v-waitfram-prev-left-margin)
                                 + p-message
        v-waitfram-action03 = " "
      .
    end.
    else do:
      if length(p-message) <= 140 then do:
        assign
          v-waitfram-action01 = " "
          v-waitfram-action02 = " " + substring(p-message,   1, 70)
          v-waitfram-action03 = " " + substring(p-message,  71, 70)
        .
      end.
      else do:
        assign
          v-waitfram-action01 = " " + substring(p-message,   1, 70)
          v-waitfram-action02 = " " + substring(p-message,  71, 70)
          v-waitfram-action03 = " " + substring(p-message, 141, 70)
        .
      end.
    end.
    B-viewProcInfo:visible in frame waitfram = no. /*session:debug-alert.*/
    B-viewProcInfo:sensitive in frame waitfram = no. /*session:debug-alert.*/
    display
      v-waitfram-action01 skip
      v-waitfram-action02 skip
      v-waitfram-action03 skip
      with frame waitfram .
      
      
    B-stop:sensitive   in frame waitfram = yes.   
/*&if "{1}" = "" &then */
   /* process events .*/
/*&endif
*/
     wait-for go of frame waitfram pause iInterval.
/*pause iInterval.*/
  end.

end . /* waitfram-show */
procedure waitfram-show-this: 
/*returns logical (input iInterval as int64  ):*/
define input  parameter iInterval as int64 no-undo.

   define variable vtime as int64 no-undo.
   vtime = ( now - MstarstProc ) / 1000 .
   run waitfram-show (substitute("&1 Прошло: &2 сек &3" ,mText , string( vtime),mhelper:getStatus(iSched)), iInterval).
   
end.
   


procedure AsyncRunpause:
/*returns logical (input iInterval as int64):*/
     define variable vStart  as datetime-tz no-undo.
     define variable vend    as datetime-tz no-undo.
     define variable vint as int64 no-undo.
  define input  parameter iInterval as int64 no-undo.
  
     vStart = now.
     vend   = vStart.
     publish "MyPause" (iInterval).
     vend   =  now.
     vint = vend - vStart.
     vint = iInterval - vint / 1000.
     if not mhelper:mStop
        and vint > 0
     then
        run waitfram-show-this (iInterval). 
     vend   =  now.
     vint = vend - vStart.
     vint = iInterval - vint / 1000.
     if not mhelper:mStop
        and vint > 0
     then
        pause vint no-message. 
   end.
procedure WaitFor:
/*( input iSched as character, input ipInterval as int64):*/
/*define input  parameter p-message as character no-undo.*/
define input  parameter iInterval as int64 no-undo.
define output parameter oOk as logical no-undo.
       define variable vNowTask as character  no-undo.
       define variable vCountOld as integer init -1 no-undo.
       define variable vCount as integer no-undo.
/*       define variable vOK as logical no-undo initial true.*/
       
      output to value (mhelper:getErrLog(iSched) ).
      define variable vStart  as datetime-tz no-undo.
      vStart = now.
      output close.
       mhelper:vCountend = 0. 
       vNowTask          = iSched.
       mhelper:WAIT-FOR-COMPLETE = false.      /* на всякий случай */
       mhelper:mstop = no.
      output to value(mhelper:MyWorkDir + "Stop.txt").
      output close.
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
          then
             run AsyncRunpause(ipInterval).
       end. 
       return.
   end .
   define variable vFlag as logical no-undo.
mText = itext.
MstarstProc = now.
  /*if not session:batch-mode
     this-object:MyPause:Subscribe(this-object:waitfram-show).*/
/*     mShowFrame = yes.*/
  run WaitFor(/*iSched,*/ipInterval,output vflag).
  
  /*finally:*/
     mtext = "".
     waitfram-hide().
/*     mShowFrame = no.*/
     /*if not session:batch-mode
     then
        this-object:MyPause:Unsubscribe(this-object:waitfram-show).*/
  /*end finally.*/
  return.
  