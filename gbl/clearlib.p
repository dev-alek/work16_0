/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление всех библиотек

Автор: Перваков Михаил Сергеевич
Дата создания: 04/05/06
Author: Mikhail Pervakov
Creation date: 04/05/06

*/

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Удаление всех библиотек":U .

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ gbl/attr-lib.i }
{ str/lib-trn.i  }
{ str/lib-farh.i }
{ str/libtfarh.i }
{ str/libofarh.i }
{ str/libfarhp.i }
{ str/libfarpo.i }
{ str/lib-calc.i }
{ str/libbcrcn.i }
{ str/trdcalib.i }
{ str/lib-rvs.i  }
{ str/lib-rwds.i }
{ nws/lib-nws.i  }
{ str/libthpos.i }
{ str/libchkvl.i }
{ gbl/fr-lib.i   }
{ gbl/sb-lib.i   }
{ gbl/disp-lib.i }
{ gbl/eventlib.i }
{ ref/gds-matl.i }
{ gbl/lib-gate.i }
{ gbl/lib-log.i  }
define new global shared variable g#libobj  as handle no-undo .

do
on error undo, return error return-value
:
  run delete-procedure in this-procedure
    (input g#library
    ) .
  run delete-procedure in this-procedure
    (input g#library2
    ) .
  run delete-procedure in this-procedure
    (input g#lib-trn
    ) .
  run delete-procedure in this-procedure
    (input g#lib-trn2
    ) .
  run delete-procedure in this-procedure
    (input g#lib-trn3
    ) .
  run delete-procedure in this-procedure
    (input g#lib-trn4
    ) .
  run delete-procedure in this-procedure
    (input g#lib-farh
    ) .
  run delete-procedure in this-procedure
    (input g#libtfarh
    ) .
  run delete-procedure in this-procedure
    (input g#libofarh
    ) .
  run delete-procedure in this-procedure
    (input g#libfarhp
    ) .
  run delete-procedure in this-procedure
    (input g#libfarpo
    ) .
  run delete-procedure in this-procedure
    (input g#lib-calc
    ) .
  run delete-procedure in this-procedure
    (input g#libbcrcn
    ) .
  run delete-procedure in this-procedure
    (input g#trdcalib
    ) .
  run delete-procedure in this-procedure
    (input g#lib-rvs
    ) .
  run delete-procedure in this-procedure
    (input g#lib-rwds
    ) .
  run delete-procedure in this-procedure
    (input g#lib-nws
    ) .
  run delete-procedure in this-procedure
    (input g#attr-lib
    ) .
  run delete-procedure in this-procedure
    (input g#libthpos
    ) .
  run delete-procedure in this-procedure
    (input g#libchkvl
    ) .
  run delete-procedure in this-procedure
    (input g#fr-lib
    ) .
  run delete-procedure in this-procedure
    (input g#sb-lib
    ) .
  run delete-procedure in this-procedure
    (input g#disp-lib
    ) .
  run delete-procedure in this-procedure
    (input g#eventlib
    ) .
run delete-procedure in this-procedure
    (input g#lib-Matrix
    ) .
  run delete-procedure in this-procedure
    (input g#lib-gate
    ) .
  run delete-procedure in this-procedure
    (input g#lib-log
    ) .
  run delete-procedure in this-procedure
    (input g#libobj
    ) .
end.


procedure delete-procedure :
  define input  parameter p-proc-handle as handle    no-undo .

  do
  on error undo, return error return-value
  :
    if valid-handle(p-proc-handle) then do:
      apply 'delete':u to p-proc-handle .
      delete procedure p-proc-handle .
    end.
  end.

end procedure. /* delete-procedure */