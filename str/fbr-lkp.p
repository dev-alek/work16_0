/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Просмотр документа производства

Автор: Белоусов Илья Александрович
Дата создания: 09/15/05
Author: Ilia Belousov
Creation date: 09/15/05

*/
define input parameter parparentproc   as handle           no-undo.
define input parameter p-fbr-doc-recid as recid            no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Просмотр документа производства".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/getcntxt.i def }

do
on error undo, return error return-value
:
  { gbl/getcntxt.i get }

    define variable v-new-fbr-doc-recid    as rowid        no-undo.
    define variable v-next-prev            as logical      no-undo.

    define variable v-ok as logical   no-undo .

    define buffer buf_fbr-doc for ub.fbr-doc .

    find buf_fbr-doc no-lock
        where recid(buf_fbr-doc) = p-fbr-doc-recid
        no-error.
    if available buf_fbr-doc
    then do:

      { gbl/chk-actg.i
        v-cntxt-db-num
        v-cntxt-userid
        {&action-head-code-main}
        'actn_manufacturing_lookup':U
        {&cntxt-object}
        buf_fbr-doc.host-code
        buf_fbr-doc.obj-type
        buf_fbr-doc.obj-code
        0
        0
        0
        true
        v-ok
      }
      if v-ok <> true
      then do:
              return .
      end.

        define new shared variable br-handle as handle no-undo .
        define new shared buffer   f-doc     for fbr-doc .
        define new shared query    br-docs   for f-doc scrolling .

        open query br-docs for each f-doc no-lock
        where recid(f-doc) = recid(buf_fbr-doc).
        get first br-docs .

        run str/fbr-doc.w (
              input parparentproc
            , input ?
            , input {&lookup}
            , input p-fbr-doc-recid
            , output v-new-fbr-doc-recid
            , input-output v-next-prev
        ).
    end.
    else do:
        message
        vss-workfile vss-revision vss-description skip
        "Ошибка задания входных параметров" skip
        view-as alert-box error .
        undo, return error return-value .
    end.
end.