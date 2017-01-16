/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Файл пирога обрезания. Относится к категории 107.

blob-bind  - частично
blob-data - частично
clob-bind  - частично
clob-data - частично

Автор: Бахтадзе Наталья Викторовна
Дата создания: 05/21/09
Author: Bakhtadze Natalya
Creation date: 05/21/09

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$".
define variable vss-description as character no-undo init "Файл пирога обрезания. Относится к категории 107.".
{ cmp/str-glbl.i }
{ gbl/key-rec.i }
{ ref/extclass.i }

define variable v-tbl-row as rowid no-undo .
define variable v-tbl-name as character no-undo .
define variable v-bh as handle no-undo .
define variable lob-res-list as character no-undo .
define variable lob-reslist-date-egais as character no-undo .
define variable lob-reslist-egais-doc as character no-undo .
define variable v-ii as integer no-undo .
define variable v-entry as character no-undo .
define variable v-doc-code as character no-undo .

define buffer old-clob-bind for src.clob-bind.
define buffer new-clob-bind for dst.clob-bind.
define buffer old-clob-data for src.clob-data.
define buffer new-clob-data for dst.clob-data.
define buffer old-blob-bind for src.blob-bind.
define buffer new-blob-bind for dst.blob-bind.
define buffer old-blob-data for src.blob-data.
define buffer new-blob-data for dst.blob-data.
define buffer old-trn-doc   for src.trn-doc.
define buffer new-trn-doc   for dst.trn-doc.

define buffer buf_new-clob-bind for dst.clob-bind.

define buffer old-ext-classif for src.ext-classif.
define buffer new-ext-classif for dst.ext-classif.
define buffer old-doc-attr    for src.doc-attr.
define buffer new-doc-attr    for dst.doc-attr.


do
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)) :
{ utl/00000001.i }
on WRITE of dst.clob-bind             override do: end.
on WRITE of dst.clob-data             override do: end.
on WRITE of dst.blob-bind             override do: end.
on WRITE of dst.blob-data             override do: end.
lob-res-list = {&lob-res-data} + {&comma-char} + {&lob-res-ref} + {&comma-char} + {&lob-res-list} + {&comma-char} + {&lob-res-list-macro}.
lob-reslist-date-egais = {&lob-egais-ab} + {&comma-char} + {&lob-egais-awo} + {&comma-char}
  + {&comma-char} + {&lob-egais-ab_shop} + {&comma-char} + {&lob-egais-awo_shop}.
lob-reslist-egais-doc = {&lob-egais-wb} + {&comma-char} + {&lob-egais-ref-b} + {&comma-char} + {&lob-egais-wb-act} + {&comma-char} + {&lob-egais-ticket} + {&comma-char} + {&lob-egais-wb-ticket}. 

do v-ii = 1 to num-entries(lob-res-list):
  v-entry = entry(v-ii, lob-res-list).
for each old-clob-bind no-lock where
      old-clob-bind.resource-type = v-entry
and old-clob-bind.db-num = 0
and old-clob-bind.int64-id > 0
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    if v-entry = {&lob-res-data} then do:
    run gen-row-keyr  in this-procedure (
                                      input  old-clob-bind.uniq-key-rec
                                    ,input  ? /* p-key-handle */
                                    ,input "dst"
                                    ,input  ? /*p-tt-handle  */
                                    ,input NO-LOCK
                                    ,output v-tbl-row
                                    ,output v-tbl-name ) no-error.
   if error-status:error then next.
   create buffer v-bh for table "dst." + v-tbl-name .
   v-bh:find-by-rowid( v-tbl-row, exclusive-lock ) no-error .
   if not v-bh:available then do:
      delete widget v-bh.
      next.
   end.
   delete widget v-bh.
    end. /*if v-entry = {&lob-res-data} then do:*/
   create new-clob-bind.
   buffer-copy old-clob-bind to new-clob-bind.
   for  EACH old-clob-data NO-LOCK
      where      (old-clob-data.db-num = old-clob-bind.db-num
              and old-clob-data.int64-id = old-clob-bind.int64-id )
              or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                  and
                  old-clob-bind.uniq-key-rec begins "exe/")
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    create new-clob-data.
    buffer-copy old-clob-data to new-clob-data.
   end.
end.
for each old-blob-bind no-lock where
      old-blob-bind.resource-type = v-entry
and old-blob-bind.db-num = 0
and old-blob-bind.int64-id > 0
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    if v-entry = {&lob-res-data} then do:
    run gen-row-keyr  in this-procedure (
                                      input  old-blob-bind.uniq-key-rec
                                    ,input  ? /* p-key-handle */
                                    ,input "dst"
                                    ,input  ? /*p-tt-handle  */
                                    ,input NO-LOCK
                                    ,output v-tbl-row
                                    ,output v-tbl-name ) no-error.
   if error-status:error then next.
   create buffer v-bh for table "dst." + v-tbl-name .
   v-bh:find-by-rowid( v-tbl-row, exclusive-lock ) no-error .
   if not v-bh:available then do:
      delete widget v-bh.
      next.
   end.
   delete widget v-bh.
    end. /*if v-v-entry = {&lob-res-data} then do:*/
   create new-blob-bind.
   buffer-copy old-blob-bind to new-blob-bind.
   for  EACH old-blob-data NO-LOCK
      where      (old-blob-data.db-num = old-blob-bind.db-num
              and old-blob-data.int64-id = old-blob-bind.int64-id )
              or (old-blob-data.file-name = old-blob-bind.uniq-key-rec
                  and
                  old-blob-bind.uniq-key-rec begins "exe/")
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    create new-blob-data.
    buffer-copy old-blob-data to new-blob-data.
   end.
end.
end. /*do v-ii to */


do v-ii = 1 to num-entries(lob-reslist-date-egais):
  v-entry = entry(v-ii, lob-res-list).
  for each old-clob-bind no-lock where
      lookup (old-clob-bind.resource-type, lob-reslist-date-egais) > 0 and old-clob-bind.sys-date >= vardate-actual-docs
  and old-clob-bind.db-num = 0
  and old-clob-bind.int64-id > 0
  on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    create new-clob-bind.
    buffer-copy old-clob-bind to new-clob-bind.
    for  EACH old-clob-data NO-LOCK
        where      (old-clob-data.db-num = old-clob-bind.db-num
                and old-clob-data.int64-id = old-clob-bind.int64-id )
                or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                    and
                    old-clob-bind.uniq-key-rec begins "exe/")
      on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
      create new-clob-data.
      buffer-copy old-clob-data to new-clob-data.
    end.
  end.

end. /*do v-ii to */


for each old-clob-bind no-lock where
    old-clob-bind.resource-type = {&lob-egais-wb}
and old-clob-bind.int64-id > 0
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
  v-doc-code = entry (6, old-clob-bind.descr, {&delim-par}) no-error.
  if v-doc-code <> ? and v-doc-code <> ""
  then do:
    if not can-find (first new-trn-doc where new-trn-doc.doc-code = v-doc-code)
      then next.
  end.
  else next.
  
  create new-clob-bind.
  buffer-copy old-clob-bind to new-clob-bind.
  for  EACH old-clob-data NO-LOCK
      where      (old-clob-data.db-num = old-clob-bind.db-num
              and old-clob-data.int64-id = old-clob-bind.int64-id )
              or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                  and
                  old-clob-bind.uniq-key-rec begins "exe/")
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    create new-clob-data.
    buffer-copy old-clob-data to new-clob-data.
  end.
end.

for each old-clob-bind no-lock where
    old-clob-bind.resource-type = {&lob-egais-ref-b}
and old-clob-bind.int64-id > 0
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
  
  if not can-find (first new-clob-bind where new-clob-bind.uniq-key-rec = old-clob-bind.uniq-key-rec )
    then next.
  create new-clob-bind.
  buffer-copy old-clob-bind to new-clob-bind.
  for  EACH old-clob-data NO-LOCK
      where      (old-clob-data.db-num = old-clob-bind.db-num
              and old-clob-data.int64-id = old-clob-bind.int64-id )
              or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                  and
                  old-clob-bind.uniq-key-rec begins "exe/")
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    create new-clob-data.
    buffer-copy old-clob-data to new-clob-data.
  end.
end.

for each old-clob-bind no-lock where
    (old-clob-bind.resource-type = {&lob-egais-tts} or old-clob-bind.resource-type = {&lob-egais-tfs}) 
and old-clob-bind.int64-id > 0
on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
  
  create new-clob-bind.
  buffer-copy old-clob-bind to new-clob-bind.
  for  EACH old-clob-data NO-LOCK
      where      (old-clob-data.db-num = old-clob-bind.db-num
              and old-clob-data.int64-id = old-clob-bind.int64-id )
              or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                  and
                  old-clob-bind.uniq-key-rec begins "exe/")
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    create new-clob-data.
    buffer-copy old-clob-data to new-clob-data.
  end.
end.



for each buf_new-clob-bind where buf_new-clob-bind.resource-type = {&lob-egais-wb} no-lock. /*перенос квитанций по приходным документам*/

  { utl/00000002.i ext-classif   " where old-ext-classif.classif-name = {&extclass_egais-transId} and old-ext-classif.CharKey_One = buf_new-clob-bind.uniq-key-rec" }

  for each old-clob-bind where (old-clob-bind.resource-type = {&lob-egais-ticket} and old-clob-bind.uniq-key-rec begins buf_new-clob-bind.uniq-key-rec) 
                              or (not old-clob-bind.uniq-key-rec begins buf_new-clob-bind.uniq-key-rec and old-clob-bind.resource-type = {&lob-egais-ticket} and lookup (old-clob-bind.field-name_, buf_new-clob-bind.field-name_) > 0)
                              or can-find (first new-ext-classif where new-ext-classif.classif-name = {&extclass_egais-transId}
                                and new-ext-classif.db-num = 0
                                and new-ext-classif.CharKey_One = buf_new-clob-bind.uniq-key-rec
                                and new-ext-classif.CharKey_Two = old-clob-bind.field-name_)
  on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    
    create new-clob-bind.
    buffer-copy old-clob-bind to new-clob-bind.
    for  EACH old-clob-data NO-LOCK
        where      (old-clob-data.db-num = old-clob-bind.db-num
                and old-clob-data.int64-id = old-clob-bind.int64-id )
                or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                    and
                    old-clob-bind.uniq-key-rec begins "exe/")
      on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
      create new-clob-data.
      buffer-copy old-clob-data to new-clob-data.
    end.


  end.
  
  for each old-clob-bind where old-clob-bind.resource-type = {&lob-egais-wb-ticket} and old-clob-bind.uniq-key-rec begins buf_new-clob-bind.uniq-key-rec
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    

    create new-clob-bind.
    buffer-copy old-clob-bind to new-clob-bind.
    for  EACH old-clob-data NO-LOCK
        where      (old-clob-data.db-num = old-clob-bind.db-num
                and old-clob-data.int64-id = old-clob-bind.int64-id )
                or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                    and
                    old-clob-bind.uniq-key-rec begins "exe/")
      on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
      create new-clob-data.
      buffer-copy old-clob-data to new-clob-data.
    end.

  end.
  
end.




for each old-ext-classif where old-ext-classif.classif-name = {&extclass_egais-transId} and can-find (first new-trn-doc where new-trn-doc.doc-code = old-ext-classif.CharKey_One): /*перенос квитанций по расходным документам*/

  create new-ext-classif.
  buffer-copy old-ext-classif to new-ext-classif.

  for each old-clob-bind where 
    old-ext-classif.CharKey_Two = old-clob-bind.field-name_
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    

    create new-clob-bind.
    buffer-copy old-clob-bind to new-clob-bind no-error.
    if error-status:error then do:
      delete new-clob-bind.
      next.
    end.
    for  EACH old-clob-data NO-LOCK
        where      (old-clob-data.db-num = old-clob-bind.db-num
                and old-clob-data.int64-id = old-clob-bind.int64-id )
                or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                    and
                    old-clob-bind.uniq-key-rec begins "exe/")
      on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
      create new-clob-data.
      buffer-copy old-clob-data to new-clob-data.
    end.
  
  end.

end.          


for each old-clob-bind where 
      old-clob-bind.resource-type = {&lob-egais-wb-act} 
  and can-find (first new-doc-attr where new-doc-attr.attr-code = {&trdcattr-negais} and old-clob-bind.uniq-key-rec matches ("*" + new-doc-attr.attr-value + "*"))
  on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):

  create new-clob-bind.
  buffer-copy old-clob-bind to new-clob-bind no-error.
  if error-status:error then do:
    delete new-clob-bind.
    next.
  end.
  for  EACH old-clob-data NO-LOCK
      where      (old-clob-data.db-num = old-clob-bind.db-num
              and old-clob-data.int64-id = old-clob-bind.int64-id )
              or (old-clob-data.file-name = old-clob-bind.uniq-key-rec
                  and
                  old-clob-bind.uniq-key-rec begins "exe/")
    on error undo, return error SUBSTITUTE("&1 &2 &3", return-value, error-status:get-message(1), error-status:get-message(2)):
    create new-clob-data.
    buffer-copy old-clob-data to new-clob-data.
  end.
  
end.          


output stream str-gen close.
return "Произведен экспорт таблиц: clob-data clob-bind blob-bind blob-data.".

end.


