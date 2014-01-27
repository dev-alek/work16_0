/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Пересчет По группам товара + Ассортиментная матрица

Автор: Чернова Светлана Александровна
Дата создания: 10/10/08
Author: Svetlana Chernova
Creation date: 10/10/08

*/
define input  parameter p-id     as integer   no-undo .
define input  parameter p-db-num as integer   no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Пересчет По группам товара + Ассортиментная матрица".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ gbl/waitfram.i }
{ ref/grplib.i   }

find first  ub.assortment-matrix no-lock where
            ub.assortment-matrix.asmt-id  = p-id and
            ub.assortment-matrix.db-num   = p-db-num and
            ub.assortment-matrix.asmt-type =  {&type-assmatr-shablon}
            no-error .
    if available ub.assortment-matrix then do:
      return .
    end.

run waitfram-show in this-procedure (substitute("Ждите. Идет пересчет ассортимента по группам в АссМатрице &1" , p-id)).

define buffer buf_gds-grp for ub.gds-grp  .
define buffer buf_assortment-matrix-goods for ub.assortment-matrix-goods  .
define buffer buf_goods for ub.goods  .
define buffer buf_gds-grp-obj-attr for ub.gds-grp-obj-attr  .
define buffer buf_gds-obj-prop for ub.gds-obj-prop  .
define temp-table tt_gds-grp-obj-attr no-undo like ub.gds-grp-obj-attr  .


define variable kk as integer   no-undo .
define variable v-full-name as character no-undo .

for each buf_gds-grp no-lock :
      kk = 0 .
      if buf_gds-grp.lvl-num = 0 then do:  /* всего в матрице */
        for each buf_assortment-matrix-goods no-lock where
                 buf_assortment-matrix-goods.asmg-status  = 0 and
                 buf_assortment-matrix-goods.db-num = p-db-num and
                 buf_assortment-matrix-goods.asmt-id = p-id :
                  find first buf_gds-obj-prop no-lock where
                            buf_gds-obj-prop.gds-code = buf_assortment-matrix-goods.gds-code and
                            buf_gds-obj-prop.obj-type = buf_assortment-matrix-goods.obj-type and
                            buf_gds-obj-prop.obj-code = buf_assortment-matrix-goods.obj-code and
                            buf_gds-obj-prop.gdop-igt = {&ass-izd-del} no-error .
                  if not available buf_gds-obj-prop then do:
                      kk = kk + 1 .
                  end.

        end.
      end.
      else do:
          run grplib-get-full-name ( input buf_gds-grp.node-code , output v-full-name).
          run waitfram-show in this-procedure (substitute("Ждите. Идет пересчет ассортимента по группам в АссМатрице &1" , v-full-name)).
          for each buf_assortment-matrix-goods no-lock where
                   buf_assortment-matrix-goods.asmg-status  = 0 and
                   buf_assortment-matrix-goods.db-num = p-db-num and
                   buf_assortment-matrix-goods.asmt-id = p-id ,
             first buf_goods no-lock where
                   buf_goods.gds-code = buf_assortment-matrix-goods.gds-code and
                 ( buf_goods.grp-name begins v-full-name )
                  :
              find first buf_gds-obj-prop no-lock where
                        buf_gds-obj-prop.gds-code = buf_assortment-matrix-goods.gds-code and
                        buf_gds-obj-prop.obj-type = buf_assortment-matrix-goods.obj-type and
                        buf_gds-obj-prop.obj-code = buf_assortment-matrix-goods.obj-code and
                        buf_gds-obj-prop.gdop-igt = {&ass-izd-del} no-error .
              if not available buf_gds-obj-prop then do:
                  kk = kk + 1 .
              end.
          end.
      end.

      /* Запись количества во временную таблицу */
      find first tt_gds-grp-obj-attr exclusive-lock where
                  tt_gds-grp-obj-attr.attr-code = {&ggoattr-QntyAssMat} and
                  tt_gds-grp-obj-attr.obj-type  = string(p-id) and
                  tt_gds-grp-obj-attr.obj-code  = p-db-num and
                  tt_gds-grp-obj-attr.host-code = 0 and
                  tt_gds-grp-obj-attr.node-code = buf_gds-grp.node-code no-error .
      if not available tt_gds-grp-obj-attr then do:
          create tt_gds-grp-obj-attr.
               assign
                  tt_gds-grp-obj-attr.attr-code = {&ggoattr-QntyAssMat}
                  tt_gds-grp-obj-attr.obj-type  = string(p-id)
                  tt_gds-grp-obj-attr.obj-code  = p-db-num
                  tt_gds-grp-obj-attr.host-code = 0
                  tt_gds-grp-obj-attr.node-code = buf_gds-grp.node-code
                  tt_gds-grp-obj-attr.attr-value = string(kk)
          .
      end.
      else do:
          if int(tt_gds-grp-obj-attr.attr-value) <> kk then tt_gds-grp-obj-attr.attr-value = string(kk) .
      end.
end.

run waitfram-show in this-procedure (substitute("Запись ограничений в БД"  )).
for each tt_gds-grp-obj-attr :
   find first buf_gds-grp-obj-attr exclusive-lock where
              buf_gds-grp-obj-attr.node-code = tt_gds-grp-obj-attr.node-code and
              buf_gds-grp-obj-attr.host-code = tt_gds-grp-obj-attr.host-code and
              buf_gds-grp-obj-attr.obj-type  = tt_gds-grp-obj-attr.obj-type  and
              buf_gds-grp-obj-attr.obj-code  = tt_gds-grp-obj-attr.obj-code  and
              buf_gds-grp-obj-attr.attr-code = tt_gds-grp-obj-attr.attr-code  no-error .
        if not available buf_gds-grp-obj-attr then do:
           create buf_gds-grp-obj-attr.
           buffer-copy tt_gds-grp-obj-attr to buf_gds-grp-obj-attr .
        end.
        else do:
           if buf_gds-grp-obj-attr.attr-value <> tt_gds-grp-obj-attr.attr-value then do:
              buf_gds-grp-obj-attr.attr-value  = tt_gds-grp-obj-attr.attr-value .
            end.
        end.
end.
run waitfram-hide in this-procedure .