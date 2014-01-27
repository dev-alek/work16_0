/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

ОТЧЕТ О СОСТОЯНИИ ЗАПАСА И ПРОДАЖАХ

Автор: Демин Алексей Сергеевич
Дата создания: 03/23/06
Author: Alexey Demin
Creation date: 03/23/06

*/
define var vss-revision    as character no-undo init "$Revision$":U .
define var vss-author      as character no-undo init "$Author$":U .
define var vss-date        as character no-undo init "$Date$":U .
define var vss-workfile    as character no-undo init "$Workfile$":U .
define var vss-archive     as character no-undo init "$Archive$":U .
define var vss-description as character no-undo init "ОТЧЕТ О СОСТОЯНИИ ЗАПАСА И ПРОДАЖАХ".
{ cmp/vssrevis.i }

{ rep/r-zap-pr.i base }