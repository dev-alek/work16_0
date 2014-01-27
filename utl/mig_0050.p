/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Модификация таблиц  раздела Принтера-кухни

Автор: Чернова Светлана Александровна
Дата создания: 12/08/08
Author: Svetlana Chernova
Creation date: 12/08/08

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Модификация тфблиц раздела Принтера-кухни".
{ cmp/vssrevis.i }
{ utl/mig_0001.i }

run write-log-and-file in p-log-handle (
      input 1
    , input log-file-name
    , input 1
    , input substitute("Принтера-кухни") ).

on write  of ub.fbr-prn      override do: end .
on delete of ub.fbr-prn      override do: end .
  do
  on error undo, return error return-value
  :
    for each ub.fbr-prn exclusive-lock WHERE
            ub.fbr-prn.db-num <> p-db-num :
            delete ub.fbr-prn .
    end.
    for each ub.fbr-prn exclusive-lock WHERE
             ub.fbr-prn.db-num = 0 .
    end.
  end.