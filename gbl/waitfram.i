/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Диалог для вывода информации о текущем процессе

Автор: Перваков Михаил Сергеевич
Дата создания: 05/19/03
Author: Mikhail Pervakov
Creation date: 05/19/03

Если первый параметр отличен от пробела, то не будет вызыватьс
оператор process events

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

&if "{1}" <> "" and "{1}" <> "noprocess" &then
  &message Wrong usage of waitfram.i
  &message Unknown parameter ~{1~} '{1}'
&endif

&if defined (waitfram_procedure) eq 0
&then
&glob waitfram_procedure yes
define variable v-waitfram-action01         as character   no-undo .
define variable v-waitfram-action02         as character   no-undo .
define variable v-waitfram-action03         as character   no-undo .
define variable v-waitfram-prev-left-margin as integer     no-undo init 0 .
define variable mWaitFramTextBeg            as character   no-undo.
define variable mWaitFramTextEnd            as character   no-undo.
define variable mWaitFramView               as logical     no-undo.
define variable mWaitFramInterval           as integer     no-undo init 1 .
define variable mWaitFramStop               as logical     no-undo.
define variable mWaitFramStopUser           as logical     no-undo.
define variable mWaitFramStopTimeOut        as logical     no-undo.
define variable mWaitFramStartProc          as datetime-tz no-undo.
define variable mWaitFramTimeOut            as decimal     no-undo init ?.

define button B-WaitFramStop auto-end-key
     label "Стоп"
     size 10 by 1 tooltip "Остоновить процесс".
define button B-viewProcInfo
     label "Информация"
     size 15 by 1 tooltip "Информация о процесс".

define frame waitfram
  v-waitfram-action01 format "x(72)" no-label skip
  v-waitfram-action02 format "x(72)" no-label skip
  v-waitfram-action03 format "x(72)" no-label skip
  B-viewProcInfo 
  B-WaitFramStop at row 4 col 30
  with view-as dialog-box side-labels three-d cancel-button B-WaitFramStop
  .
on choose of B-WaitFramStop in frame waitfram /* Добавить в АМ */
do:
  mWaitFramStop = yes.
  mWaitFramStopUser = yes.
end.

/*on choose of B-viewProcInfo in frame waitfram /* Добавить в АМ */
do:
  run ref/runprocview.p (MyWorkDir,MyWorkDir).
end.
*/

procedure waitfram-hide :

  do
  on error undo, return error return-value
  :
    pause 0 before-hide .
    hide frame waitfram .

&if "{1}" = "" &then
  if not mWaitFramView
  then
    process events .
&endif
  end.

end procedure. /* waitfram-hide */


procedure waitfram-show :

  define input  parameter p-message as character no-undo .

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
    B-viewProcInfo:visible   in frame waitfram = no. /*session:debug-alert.*/
    B-viewProcInfo:sensitive in frame waitfram = no. /*session:debug-alert.*/
    B-WaitFramStop:visible   in frame waitfram = mWaitFramView .
    B-WaitFramStop:sensitive in frame waitfram = mWaitFramView .
    display
      v-waitfram-action01 skip
      v-waitfram-action02 skip
      v-waitfram-action03 skip
      with frame waitfram .
&if "{1}" = "" &then
    if mWaitFramView 
    then
       wait-for go of frame waitfram pause mWaitFramInterval.
    else
       process events .
&endif
  end.

end procedure. /* waitfram-show */

   procedure waitfram-show-this: 
      define input  parameter iInterval as int64 no-undo.

      define variable vtime as int64 no-undo.
      vtime = ( now - mWaitFramStartProc  ) / 1000 .
      mWaitFramInterval = iInterval.
      run waitfram-show (substitute("&1 Прошло: &2 сек &3&4" ,
                                    mWaitFramTextBeg , 
                                    string( vtime),
                                    if mWaitFramTimeOut ne 0 and mWaitFramTimeOut ne ? then " из " + string(mWaitFramTimeOut) + " сек. " else "",
                                    mWaitFramTextEnd
                                   )
                        ).
   end.

   procedure WaitFramRunPause:
      define input  parameter iInterval as dec no-undo.
      
      define variable vStart  as datetime-tz no-undo.
      define variable vend    as datetime-tz no-undo.
      define variable vint as int64 no-undo.
  
      vStart = now.
      vend   = vStart.
      publish "WaitFramPause" (iInterval).
      vend   =  now.
      vint = vend - vStart.
      vint = iInterval - vint / 1000.
/*      publish "WaitFramStop".*/
      if     not mWaitFramStop
         and vint > 0
      then
         run waitfram-show-this (iInterval). 
      vend   =  now.
      vint = vend - vStart.
      vint = iInterval - vint / 1000.
/*      publish "WaitFramStop".*/
      if     not mWaitFramStop
         and vint > 0
      then
         pause vint no-message.
      publish "WaitFramStop".
   end.
   
   procedure WaitFramWaitFor:
      define input  parameter iInterval as dec no-undo.
      assign
         mWaitFramStartProc   = now
         mWaitFramStopUser    = no
         mWaitFramStopTimeOut = no
      .
      block-wait:
      do while not mWaitFramStop:
         run WaitFramRunPause (iInterval).
         define variable vtime as int64 no-undo.
         vtime = ( now - mWaitFramStartProc ) / 1000 .
         if     mWaitFramTimeOut ne ?
            and mWaitFramTimeOut ne 0 
            and mWaitFramTimeOut lt vtime
         then do:
            mWaitFramStopTimeOut = yes.
            leave block-wait.
         end.
      end.
   end.

procedure waitfram-join :

  define input  parameter p-line-1  as character no-undo .
  define input  parameter p-line-2  as character no-undo .
  define input  parameter p-line-3  as character no-undo .
  define output parameter p-message as character no-undo .

  do
  on error undo, return error return-value
  :
    assign
      p-message = substring(p-line-1 + fill(' ', 70), 1, 70)
                + substring(p-line-2 + fill(' ', 70), 1, 70)
                + substring(p-line-3 + fill(' ', 70), 1, 70)
    .
  end.

end procedure. /* waitfram-join */


function waitfram-join-function returns character
  (input p-line-1 as character
  ,input p-line-2 as character
  ,input p-line-3 as character
  ).

  define variable v-message as character no-undo .

  run waitfram-join in this-procedure
    (input  p-line-1
    ,input  p-line-2
    ,input  p-line-3
    ,output v-message
    ) .

  return v-message .

end function .
&endif
/* $Workfile$ e n d */