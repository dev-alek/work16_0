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


define variable v-waitfram-action01         as character no-undo .
define variable v-waitfram-action02         as character no-undo .
define variable v-waitfram-action03         as character no-undo .
define variable v-waitfram-prev-left-margin as integer   no-undo init 0 .

define frame waitfram
  v-waitfram-action01 format "x(72)" no-label skip
  v-waitfram-action02 format "x(72)" no-label skip
  v-waitfram-action03 format "x(72)" no-label skip
  with view-as dialog-box side-labels three-d
  .

procedure waitfram-hide :

  do
  on error undo, return error return-value
  :
    pause 0 before-hide .
    hide frame waitfram .

&if "{1}" = "" &then
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

    display
      v-waitfram-action01 skip
      v-waitfram-action02 skip
      v-waitfram-action03 skip
      with frame waitfram .
&if "{1}" = "" &then
    process events .
&endif
  end.

end procedure. /* waitfram-show */


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

/* $Workfile$ e n d */