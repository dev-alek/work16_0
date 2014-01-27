/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вызов поставок

Автор: Чернова Светлана Александровна
Дата создания: 03/02/06
Author: Svetlana Chernova
Creation date: 03/02/06

Дата создания: 08/21/01
*/

  define variable vss-revision    as character no-undo init "$Revision$":U .
  define variable vss-author      as character no-undo init "$Author$":U .
  define variable vss-date        as character no-undo init "$Date$":U .
  define variable vss-workfile    as character no-undo init "$Workfile$":U .
  define variable vss-archive     as character no-undo init "$Archive$":U .
  define variable vss-description as character no-undo init "Вызов поставок".
 { cmp/vssrevis.i }
 { cmp/trg-def.i  }
 { cmp/showinf.i  }
 { gbl/getcntxt.i def }

define input parameter parParentProc  as widget-handle no-undo.
define input parameter p-place as character no-undo .  /* Тип поставка */
define input parameter p-type as character no-undo .       /* Тип поставка */
define input parameter p-status as character no-undo . /* статус поставка */
define variable v-list as character no-undo .
{ gbl/getcntxt.i get }

run cus/all-rcv.w
(    parParentProc
    , v-cntxt-host-code-obj
    , (If p-type   = "all":U then ? else p-type    )  /* type */
    , (if p-status = "all":U then ? else p-status  )  /* status */
    , ?
    , p-place
    , output v-list
    ) .

RETURN.