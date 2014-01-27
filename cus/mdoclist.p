/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

формирование списка заказов по выбранным товарам

Автор: Чернова Светлана Александровна
Дата создания: 03/03/06
Author: Svetlana Chernova
Creation date: 03/03/06

Дата создания: 06/02/05
*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "формирование списка заказов по выбранным товарам".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/obj-list.i }
{ cmp/doc-list.i doc-list def "shared" }
{ gbl/waitfram.i }
define input  parameter p-recid-list as character no-undo .
define buffer buf_abc-analysis-goods for ub.abc-analysis-goods.
define buffer buf_goods              for ub.goods.
define buffer buf_ord-doc            for ub.ord-doc.
define buffer buf_ord-line           for ub.ord-line.
define variable v-host-code as integer   no-undo .

run waitfram-show ("Ждите...Анализ заказов...").
define variable v-i as integer   no-undo .
define variable v-all as integer   no-undo .
v-all = num-entries(p-recid-list) .
repeat v-i = 1 to v-all :
   find first buf_abc-analysis-goods no-lock where
        recid( buf_abc-analysis-goods ) = int(entry( v-i , p-recid-list ) ) no-error .
        if available  buf_abc-analysis-goods then do:
           find first buf_goods no-lock where
                      buf_goods.gds-code = buf_abc-analysis-goods.gds-code no-error .
             if available buf_goods then do:
                for each obj-list :
                { gbl/hostcode.i
                  obj-list.obj-type
                  obj-list.obj-code
                  v-host-code
                  }
                    for each buf_ord-line no-lock where
                            buf_ord-line.artic     = buf_goods.artic       and
                            buf_ord-line.prod-code = buf_goods.prod-code   and
                            buf_ord-line.prod-type = buf_goods.prod-type   and
                            buf_ord-line.obj-code  = obj-list.obj-code     and
                            buf_ord-line.obj-type  = obj-list.obj-type     and
                            buf_ord-line.status_   <> {&fact}
                            :
                            find first doc-list where doc-list.doc-code = buf_ord-line.doc-code no-error .
                            if not available doc-list then do:
                               find first buf_ord-doc no-lock where buf_ord-doc.doc-code = buf_ord-line.doc-code no-error .
                               if available buf_ord-doc then do:
                                  create doc-list.
                                  BUFFER-COPY buf_ord-doc TO doc-list .
                               end.
                            end.
                    end.
                    for each buf_ord-line no-lock where
                            buf_ord-line.artic     = buf_goods.artic       and
                            buf_ord-line.prod-code = buf_goods.prod-code   and
                            buf_ord-line.prod-type = buf_goods.prod-type   and
                            buf_ord-line.status_   <> {&fact}
                            :
                            find first doc-list where doc-list.doc-code = buf_ord-line.doc-code no-error .
                            if not available doc-list then do:
                               find first buf_ord-doc no-lock where buf_ord-doc.doc-code = buf_ord-line.doc-code  and
                                                                    buf_ord-doc.host-code = v-host-code           and
                                                                    buf_ord-doc.doc-type = {&f-p}  no-error .
                               if available buf_ord-doc then do:
                                  create doc-list.
                                  BUFFER-COPY buf_ord-doc TO doc-list .
                               end.
                            end.
                    end.

                end.
             end.
        end.
end.
run waitfram-hide in this-procedure .
/* message error-status :get-message(1) return-value 123. */