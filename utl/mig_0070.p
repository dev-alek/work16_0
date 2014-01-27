/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Модификация таблиц  раздела Удаление таблиц новостей, обновлений

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
define variable vss-description as character no-undo init "Модификация тфблиц раздела Удаление таблиц новостей, обновлений".
{ cmp/vssrevis.i }
{ utl/mig_0001.i }

run write-log-and-file in p-log-handle (
      input 1
    , input log-file-name
    , input 1
    , input substitute("Удаление таблиц новостей, обновлений") ).

on delete of ub.h-route      override do: end .
on delete of ub.route        override do: end .
on delete of ub.nws-doc-hist override do: end .
on delete of ub.pck-keys     override do: end .
on delete of ub.pck-rcvd     override do: end .
on delete of ub.pck-sent     override do: end .
on delete of ub.upgrade      override do: end .
on write  of ub.upgrade       override do: end .
on write  of ub.config        override do: end .
on delete of ub.config        override do: end .

on delete of ub.ext-file        override do: end .
on delete of ub.ext-file-line   override do: end .
on delete of ub.schedule        override do: end .
on delete of ub.schedule-attr   override do: end .

  do
  on error undo, return error return-value
  :


    for each ub.ext-file exclusive-lock :
        delete ub.ext-file .
    end.
    for each ub.ext-file-line exclusive-lock :
        delete ub.ext-file-line .
    end.

    for each ub.h-route exclusive-lock :
        delete ub.h-route .
    end.
    for each ub.h-route-dump exclusive-lock :
        delete ub.h-route-dump .
    end.

    for each ub.route exclusive-lock :
        delete ub.route .
    end.
    for each ub.route-dump exclusive-lock :
        delete ub.route-dump .
    end.
    for each ub.route-dump-link exclusive-lock :
        delete ub.route-dump-link .
    end.

    for each ub.nws-doc-hist exclusive-lock :
        delete ub.nws-doc-hist .
    end.
    for each ub.pck-keys exclusive-lock :
        delete ub.pck-keys .
    end.
    for each ub.pck-rcvd exclusive-lock :
        delete ub.pck-rcvd .
    end.

    for each ub.pck-sent exclusive-lock :
        delete ub.pck-sent .
    end.
    for each ub.upgrade exclusive-lock  where ub.upgrade.db-num <> p-db-num:
        delete ub.upgrade .
    end.
    for each ub.upgrade exclusive-lock  where ub.upgrade.db-num = p-db-num:
        ub.upgrade.db-num = 0 .
    end.

    for each ub.schedule   exclusive-lock :
        delete ub.schedule .
    end.
    for each ub.schedule-attr   exclusive-lock :
        delete ub.schedule-attr .
    end.

    for each ub.config   exclusive-lock  where
             ub.config.conf-type = "к" or
             ub.config.conf-type = "п"
    :
        delete ub.config .
    end.
    for each ub.config   exclusive-lock
    :
        ub.config.db-num = 0 .
    end.


  end.