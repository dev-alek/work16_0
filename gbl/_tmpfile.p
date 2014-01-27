/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура создания временного файла

Автор: Перваков Михаил Сергеевич
Дата создания: 04/05/06
Author: Mikhail Pervakov
Creation date: 04/05/06

*/

define input  parameter p-user-chars as character no-undo.
define input  parameter p-extension  as character no-undo.
define output parameter p-name       as character no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Процедура создания временного файла".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }

do
on error undo, return error return-value
:
  define variable v-base        as integer   no-undo .
  define variable v-check-name  as character no-undo .

  if  p-extension <> ""
  and substring(p-extension, 1, 1) <> '.':u
  then do:
    assign
      p-extension = '.':u + p-extension
    .
  end.

  /*
  * Loop until we find a name that hasn't been used. In theory, if the
  * temp directory gets filled, this could be an infinite loop. But, the
  * likelihood of that is low.
  */
  assign
    v-check-name = "something"
  .

  do while v-check-name <> ?:
    /* создается число из не более чем пять цифр */
    assign
      v-base = ( time * 1000 + etime ) modulo 100000
    .

    /* Add in the extension and directory into the name. */
    assign
      p-name = session :temp-directory
            + "p" + string(v-base,"99999":U) + p-user-chars
            + p-extension
    .

    assign
      v-check-name = search(p-name)
    .
  end.
end.