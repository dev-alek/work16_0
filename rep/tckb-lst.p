/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Печать ценников (этикеток) по списку bb-list

Автор: Бахтадзе Наталья Викторовна
Дата создания: 09/12/05
Author: Bakhtadze Natalya
Creation date: 09/12/05

*/

define input parameter parparentproc as widget-handle no-undo .
define input parameter p-obj-type like ub.clients.obj-type no-undo .
define input parameter p-obj-code like ub.clients.obj-code no-undo .
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Печать ценников (этикеток) по списку bb-list".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i }

define variable action    as character no-undo initial "ALL":U.
define variable prn-prt   as logical   no-undo .
define variable v-user-id as character no-undo .
run get-userid in parparentproc
  ( output v-user-id
  ).

define new shared stream outstream.

{ rep/new-prn.i new }

{ str/get-pr.i def }
{ rep/tick-beg.i "'bb-list'" }
{ cmp/bb-list.i bb-list def shared }

define variable how-pcnt-kat as character no-undo .
define variable dflt-cd as character no-undo .
{ str/howpcntk.i p-obj-type p-obj-code how-pcnt-kat dflt-cd no-error }
tickons = yes.


/*теперь подменим action - нам это надо чтобы печатать из списка количество нгапрямую а не пересчитывая через кратность*/
action = "all-bb".

CASE List-sort:
  when "artic":U then do:
    run bb-list-artic in this-procedure .
  end.
  when "b-code":U then do:
    run bb-list-b-code in this-procedure .
  end.
  when "order-num":U then do:
    run bb-list-order-num in this-procedure .
  end.
END CASE.


procedure bb-list-artic :

  do
  on error undo, return error
  :

    { rep/tckb-lst.i bb-list artic }

  end.

end procedure. /* bb-list-artic */


procedure bb-list-b-code :

  do
  on error undo, return error
  :

    { rep/tckb-lst.i bb-list b-code }

  end.

end procedure. /* bb-list-b-code */

procedure bb-list-order-num :

  do
  on error undo, return error
  :

   { rep/tckb-lst.i bb-list order-num }

  end.

end procedure. /* bb-list-order-num */