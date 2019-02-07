/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление всех persistent процедур

Автор: Перваков Михаил Сергеевич
Дата создания: 09/20/02
Author: Mikhail Pervakov
Creation date: 09/20/02

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Удаление всех persistent процедур".
{ cmp/vssrevis.i }

/* run utl/ttp.p ( input "utl/del-pers.p").
   21/I-2019 - попробуем обойтись без подсчёта удаляемых persistent-procedure
   На очереди - избавиться от utl/ttq.p и от utl/tto.p
*/
   define stream LogStream.
   DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.
   DEFINE VARIABLE iCounter AS INTEGER    NO-UNDO.
   define variable v-procedure-handle as handle    no-undo .

  hProc = session:first-procedure .
  iCounter = 0 .
  if valid-handle(hProc) then do :
    OUTPUT stream LogStream TO "memdump.log" APPEND.
    do while valid-handle(hProc) 
    on error undo, return error :
      iCounter = iCounter + 1.
      v-procedure-handle = hProc .
      hProc = hProc:next-sibling .
      
      put stream LogStream unformatted
            "Procedure No.:~t" iCounter "~t"
            "Procedure:~t" v-procedure-handle:file-name
      skip.
      
      apply 'delete':u to v-procedure-handle .
      delete procedure v-procedure-handle .
    end.
    output stream LogStream close.
  end .
run utl/ttq.p ( input "utl/del-pers.p").
run utl/tto.p ( input "utl/del-pers.p").