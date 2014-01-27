/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Начало формирования скидочных ДНЦ по ГТПЛ

Автор: Чернова Светлана Александровна
Дата создания: 04/24/09
Author: Svetlana Chernova
Creation date: 04/24/09


*/

define input parameter parparentproc    as widget-handle no-undo .
define input parameter p-pdf-recid      as recid no-undo .
define input parameter p-log-handle     as handle no-undo .
define input parameter log-file-name    as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Начало формирования скидочных ДНЦ по ГТПЛ".
{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ cmp/library.i  }
{ gbl/key-rec.i  }


define buffer buf_price-doc-forming for ub.price-doc-forming  .
define buffer buf_price-list-type   for ub.price-list-type  .

find first   buf_price-doc-forming  no-lock where recid(buf_price-doc-forming )  =  p-pdf-recid no-error .
  if error-status :error then return error error-status :get-message(1) .
find first buf_price-list-type no-lock where
           buf_price-list-type.plt-db-num = buf_price-doc-forming.plt-db-num and
           buf_price-list-type.plt-id     = buf_price-doc-forming.plt-id
           no-error .
  if error-status :error then return error error-status :get-message(1) .


run write-log-and-file in p-log-handle (
      input 1
    , input log-file-name
    , input 1
    , input substitute("Запуск машины правил при закрытии на факт ДНЦ &1(БД&2) ГТПЛ &3(БД&4)", buf_price-doc-forming.pdf-id,buf_price-doc-forming.pdf-db, buf_price-doc-forming.plt-id,buf_price-doc-forming.plt-db)).

define variable v-uniq-key-rec as character no-undo .
define buffer buf_thbj-attr for ub.thbj-attr.

    find first buf_thbj-attr no-lock where
              buf_thbj-attr.upper-prop-code = {&attr-rum}
          and buf_thbj-attr.prop-code = {&attr-rum_pdf}
          and buf_thbj-attr.obj-type = ''
          and buf_thbj-attr.obj-code = 0
          and buf_thbj-attr.property-value-logical = yes
          no-error.
    if available buf_thbj-attr then do:
      run gen-key-rec in this-procedure (
                 input  {&table_thbj-attr}
                ,input  ( buffer buf_thbj-attr:handle)
                ,output v-uniq-key-rec ).

      run str/pdfrum.p
        ( input parparentproc
         ,input this-procedure:handle
         ,input p-log-handle
         ,input {&pdf-proc_pdf-main-doc-close}
         ,input 0 /*p-profile-id*/
         ,input 0 /*p-codex-id*/
         ,input 0 /*p-ruleset-id*/
         ,input g#db-num     /*current-db-num*/
         ,input v-uniq-key-rec
         ,input '1{&delim-par}1'    /*p-doc-code*/   /*виртуальный код док-та {&delim-par} имя файла */
         ,input buf_price-doc-forming.plt-id
         ,input buf_price-doc-forming.plt-db-num
         ,input buf_price-doc-forming.pdf-id
         ,input buf_price-doc-forming.pdf-db
         ,input yes /*p-save*/
         ) no-error .
         if error-status :error then return error return-value .
    end.