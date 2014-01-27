/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Установить порядковый номер рецепта товара.

Автор: Белоусов Илья Александрович
Дата создания: 04/12/06
Author: Ilia Belousov
Creation date: 04/12/06

Input:

Output:

*/

define input parameter p-recipe-code    as character    no-undo.
define input parameter p-recipe-order   as integer      no-undo.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Установить порядковый номер рецепта товара.".
{ cmp/vssrevis.i }

on write of recipe override do: end.

do
on error undo, return error
:

    define buffer buf_recipe        for recipe.

    find first buf_recipe exclusive-lock
         where buf_recipe.recipe-code = p-recipe-code
    .
    assign
        buf_recipe.recipe-order = p-recipe-order
    .
end.