/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Полное название группы

Автор: Белоусов Илья Александрович
Дата создания: 04/12/06
Author: Ilia Belousov
Creation date: 04/12/06

Input:

Output:

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Полное название группы".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ ref/grplibfn.i }

define input  parameter v-node-code as integer      no-undo.
define output parameter v-full-name as character    no-undo.

do
on error undo, return error return-value
:
    run grplib-get-full-name in this-procedure (
          input  v-node-code
        , output v-full-name
    ).
end.