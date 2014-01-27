/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Данные о реализации НП на АЗС за период (ТамбовНП)

Автор: Демин Алексей Сергеевич
Дата создания: 12/02/08
Author: Alexey Demin
Creation date: 12/02/08

*/

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Данные о реализации НП на АЗС за период (ТамбовНП)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i new }

do
on error undo, return error
:

assign
  my-handle = parparentproc
.
run rep/d-report.w
    ( input parparentproc
    , input "rep/r-rnpazs.p"
    , input "Данные о реализации НП на АЗС за период (ТамбовНП)":U
    , input 4
    , input "":U
    , input "*"
    , input ""
    , input ""
    , input "all":U
    , input yes ).

end.