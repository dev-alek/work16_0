/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Все таблицы с Host-code obj-type obj-code

Автор: Чернова Светлана Александровна
Дата создания: 12/12/08
Author: Svetlana Chernova
Creation date: 12/12/08

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Все таблицы с Host-code obj-type obj-code".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
DEFINE STREAM outstrim.
OUTPUT STREAM outstrim TO VALUE("c:\ttable.txt") .
define buffer buf-_Field for ub._Field  .

for each _File no-lock :
   find first _Field no-lock of _File
        where
        _Field._Field-Name = 'obj-type'
        no-error.

    if available _Field then do:
       put stream outstrim "Table "  _File._File-Name skip .

    for each _index of _file no-lock  :
       for each  _index-field of _index  :
           find first buf-_field of _index-field no-error .
           if buf-_Field._Field-Name = 'obj-type' then do:
              put stream outstrim "Index " _index._index-name skip .
              leave.
           end.
           else do:
              leave.
           end.
       end.
    end.

   end.
   end.

OUTPUT STREAM outstrim CLOSE.