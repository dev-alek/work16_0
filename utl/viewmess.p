/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Просмотр рассшифровки сообщений

Автор: Чернова Светлана Александровна
Дата создания: 12/08/09
Author: Svetlana Chernova
Creation date: 12/08/09

*/

define input  parameter parParentProc as handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Просмотр рассшифровки сообщений".
{ cmp/vssrevis.i }
  define variable passwd as character no-undo.

  run gbl/d-prompt.w (
      'title=':u + "Просмотр расшифровки сообщения" + '\':u
    + 'text1=':u + "Введите Номер сообщения #:" + '\':u
    + 'format=' + ">>>>>>>>>9" + '\':u
    + 'type=int\':u
    + 'fillin_row=1\':u
    + 'fillin_col=24\':u
    + 'fillin_width=9\':u
    + 'fillin_height=1\':u
    + 'readonly=no\':u
    ,input-output passwd
    ).
  if return-value = 'false':u
  then do:
    return .
  end.

  if search("exe/messages.chm") > ''
  then do:

    define variable v-full-pathname as character no-undo .
    assign
      file-info :file-name = search("exe/messages.chm")
    .
    assign
      v-full-pathname = file-info :full-pathname
    .

    run gbl/open_url.p
      (input substitute('mk:@MSITStore:&1::/&2.html':u
                        ,v-full-pathname
                        ,passwd
                        )
      ).
  end.
  else do:
    message "Поместите messages.chm в директорию c r-codes EXE ."  view-as alert-box information .
  end.
  return .