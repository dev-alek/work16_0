/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Утилита создания недостающей свободной партии по коду товара

Автор: Ростовцев А.М.
Дата создания: 24.03.2025
Author: 
Creation date: 

*/

disable triggers for load of ub.price-doc .
disable triggers for load of ub.price-list .

{ utl/runpro.i }
define input parameter parparentproc    as widget-handle no-undo .
define input parameter iGdsCode as integer no-undo.

define buffer trn-doc            for ub.trn-doc .
define buffer parts              for ub.parts .
define buffer free_parts         for ub.parts .
define buffer out_parts          for ub.parts .
define buffer marking-lines      for ub.marking-lines .
define buffer free_marking-lines for ub.marking-lines .
define buffer goods              for ub.goods .
define buffer gds-obj            for ub.gds-obj .

define variable vObjType    as character no-undo.
define variable vObjCode    as integer   no-undo.
define variable vOutQnty    as decimal   no-undo.
define variable vFile       as character no-undo.
define variable vSeek       as integer   no-undo.
define variable vCountMarks as integer   no-undo.
define stream vProt.

{ cmp/str-glbl.i }
{ gbl/getcntxt.i def }

find first goods no-lock where goods.gds-code = iGdsCode no-error .
if not available goods
then do :
  message substitute("Товар с кодом &1 не найден!",iGdsCode) view-as alert-box .
  return .
end .

{ gbl/getcntxt.i get }
find first gds-obj where
           gds-obj.obj-type  = v-cntxt-obj-type and
           gds-obj.obj-code  = v-cntxt-obj-code and
           gds-obj.prod-type = goods.prod-type  and
           gds-obj.prod-code = goods.prod-code  and
           gds-obj.artic     = goods.artic      no-lock no-error.
if not avail gds-obj then do:
  message substitute("Не найден оcтаток  с кодом &1 не найден!",iGdsCode) view-as alert-box .
  return .
end.

vFile = session:temp-directory + "/fix_bts-1469.log". 
output stream vProt to value(vFile).

tr_ :
do trans :

for each parts no-lock where 
         parts.obj-type  = gds-obj.obj-type
     and parts.obj-code  = gds-obj.obj-code
     and parts.prod-type = gds-obj.prod-type
     and parts.prod-code = gds-obj.prod-code
     and parts.artic     = gds-obj.artic
     and parts.out-code  = parts.in-code
     and parts.doc-type  = {&income}:
  
  vOutQnty = 0.
  for each out_parts no-lock where 
           out_parts.obj-type  = gds-obj.obj-type
       and out_parts.obj-code  = gds-obj.obj-code
       and out_parts.prod-type = gds-obj.prod-type
       and out_parts.prod-code = gds-obj.prod-code
       and out_parts.artic     = gds-obj.artic
       and out_parts.in-code   = parts.in-code
       and out_parts.doc-type  = {&expense}:
    vOutQnty = vOutQnty + out_parts.fact-qnty.        
  end.     
  
  if parts.fact-qnty <> vOutQnty then
  do:
    find first trn-doc no-lock where
               trn-doc.doc-code = parts.in-code no-error.

    find first free_parts no-lock where 
               free_parts.obj-type  = gds-obj.obj-type
           and free_parts.obj-code  = gds-obj.obj-code
           and free_parts.prod-type = gds-obj.prod-type
           and free_parts.prod-code = gds-obj.prod-code
           and free_parts.artic     = gds-obj.artic
           and free_parts.out-code  = "free-zone"
           and free_parts.in-code   = parts.in-code
           and free_parts.doc-type  = {&income} no-error.     
/*run gbl/inidebug.p.*/
    if not avail free_parts or free_parts.fact-qnty <> (parts.fact-qnty - vOutQnty) then do:
      if not avail free_parts then
      do:
        create free_parts.
        buffer-copy parts except out-code to free_parts assign
          free_parts.out-code = "free-zone"
          free_parts.rsrv-free = yes
          free_parts.status_ = no 
          free_parts.qnty      = parts.fact-qnty - vOutQnty
          free_parts.fact-qnty = free_parts.qnty
          free_parts.cli-qnty  = free_parts.qnty   
        .
        put stream vProt unformatted
          substitute("Создана свободная партия для ПН &1 в количестве &2", parts.in-code, free_parts.qnty) skip 
        . 
      end.
      else
      do:
        put stream vProt unformatted
          substitute("Изменена свободная партия для ПН &1. Было - &2. Стало - &3", 
                     parts.in-code, free_parts.qnty, parts.fact-qnty - vOutQnty ) 
          skip
        . 
        assign
          free_parts.qnty      = parts.fact-qnty - vOutQnty
          free_parts.fact-qnty = free_parts.qnty
          free_parts.cli-qnty  = free_parts.qnty   
        .
      end.
      /* создаем привязанные партии из приходной партии к свободной */
      vCountMarks = 0.
      for each marking-lines no-lock where
               marking-lines.gds-code  = goods.gds-code
           and marking-lines.obj-type  = gds-obj.obj-type
           and marking-lines.obj-code  = gds-obj.obj-code
           and marking-lines.in-code   = parts.in-code
           and marking-lines.out-code  = parts.out-code
           and marking-lines.part-code = parts.part-code
           and marking-lines.prt-code  = parts.prt-code:
        find first free_marking-lines no-lock where
                   free_marking-lines.gds-code  = goods.gds-code
               and free_marking-lines.obj-type  = gds-obj.obj-type
               and free_marking-lines.obj-code  = gds-obj.obj-code
               and free_marking-lines.in-code   = free_parts.in-code
               and free_marking-lines.out-code  = free_parts.out-code
               and free_marking-lines.part-code = free_parts.part-code
               and free_marking-lines.prt-code  = free_parts.prt-code
             no-error.
        if not avail free_marking-lines then
        do:
          create free_marking-lines.
          buffer-copy marking-lines except out-code to free_marking-lines assign
            free_marking-lines.out-code   = free_parts.out-code
            free_marking-lines.fact-order = trn-doc.fact-order 
          . 
          vCountMarks = vCountMarks + 1. 
        end.
      end.
      put stream vProt unformatted
        substitute("   для партии добавлено &1 марок", vCountMarks )
        skip 
      . 
    end.
  end.
end.

end .
vSeek = seek(vProt).
output stream vProt close.


message 
  if vSeek = 0 then substitute("Все свободные партии по товару &1 есть!",iGdsCode)
               else substitute("Результат смотрите в протоколе &1.",vFile) 
  view-as alert-box .

