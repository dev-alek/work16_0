/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Считать значение атрибута документа МЦ

Автор: Белоусов Илья Александрович
Дата создания: 04/30/08
Author: Ilia Belousov
Creation date: 04/30/08

Input:

Output:

*/
define input  parameter p-doc-code like ub.wth-doc-attr.doc-code   no-undo .
define input  parameter p-code     like ub.wth-doc-attr.attr-code  no-undo .
define output parameter p-value    like ub.wth-doc-attr.attr-value no-undo .
define output parameter p-type     as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Считать значение атрибута документа МЦ".
{ cmp/vssrevis.i "substitute('&1|&2|&3',p-doc-code,p-code)" }
{ cmp/str-glbl.i    }
{ str/wthcalib.i    }

do
on error undo, return error return-value
:
    { str/wthatval.i
        p-doc-code
        p-code
        p-value
        p-type
        no-error
    }
    if error-status :error
    then do:
        if error-status :get-message(1) <> ""
        then do:
        message
            vss-workfile vss-revision vss-description skip
            "Ошибка при вызове процедуры" 'wthat-v.p':u skip
            "Документ" p-doc-code skip
            "Атрибут" p-code skip
            "Значение" p-value skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
        end.
        undo, return error return-value .
    end.
end.