/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Определение доступного места на диске.

Автор: Белоусов Илья Александрович
Дата создания: 04/12/06
Author: Ilia Belousov
Creation date: 04/12/06

Input:
    p-disk-letter   - имя диска (1 символ)
Output:
    p-free-space    - доступное для записи место на диске в мегабайтах

*/

define input parameter p-disk-letter as character    no-undo.
define output parameter p-free-space as decimal      no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Определение доступного места на диске.".
{ cmp/vssrevis.i }

do
on error undo, return error
:

    define variable v-full-space    as decimal        no-undo.

    run gbl/volspace.p (
          input p-disk-letter + ":"
        , input "MB"
        , output p-free-space
        , output v-full-space
    ).
end.