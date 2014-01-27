/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедура обеспечения уникальности имен одноуровневых узлов классификатора товаров

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
define variable vss-description as character no-undo init "Процедура обеспечения уникальности имен одноуровневых узлов классификатора товаров".
{ cmp/vssrevis.i }

{ utl/grp-nmun.i gds-grp }