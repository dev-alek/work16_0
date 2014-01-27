/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Удаление документов + вывод информации о ходе процесса

Автор: Чернова Светлана Александровна
Дата создания: 10/10/06
Author: Svetlana Chernova
Creation date: 10/10/06

create: Суслов Алексей Юрьевич


*/

/* Parameter Definitions ---                                            */
define  input parameter parparentproc      as   widget-handle                no-undo.
define  input parameter pardoc-code        like ub.trn-doc.doc-code          no-undo.
define  input parameter pardb-num          like ub.db.db-num                 no-undo.
define  input parameter parfilename        as   character                    no-undo.
define  input parameter parcorr-inkas-code like ub.c-trn-doc.corr-inkas-code no-undo.
define  input parameter parcorr-fbr-code   like ub.c-trn-doc.corr-fbr-code   no-undo.
define  input parameter paruserid          as   character                    no-undo.
define  input parameter parphdoc-code      like ub.trn-doc.doc-code          no-undo.
define  input parameter parphchip-num      as   integer                      no-undo.
define output parameter parchip-num        as   integer                      no-undo.

/* VSS Variable Definitions ---                                         */
define variable vss-revision    as character no-undo initial "$Revision$":U.
define variable vss-author      as character no-undo initial "$Author$":U.
define variable vss-date        as character no-undo initial "$Date$":U.
define variable vss-workfile    as character no-undo initial "$Workfile$":U.
define variable vss-archive     as character no-undo initial "$Archive$":U.
define variable vss-description as character no-undo initial "Удаление документов + вывод информации о ходе процесса":U.

/* Global, Shared, Preprocessor Definitions ---                         */
{ cmp/vssrevis.i           }
{ cmp/trg-def.i            }
{ str/lib-trn.i            }
{ gbl/waitfram.i noprocess }

&scop proc-name lib-trn_del-doc
{&run_proc_lib-trn}
  (
     input parparentproc
  ,  input pardoc-code
  ,  input pardb-num
  ,  input parfilename
  ,  input parcorr-inkas-code
  ,  input parcorr-fbr-code
  ,  input paruserid
  ,  input parphdoc-code
  ,  input parphchip-num
  , output parchip-num
  ,  input this-procedure
  ) no-error.
  if error-status :error then do:
    run waitfram-hide in this-procedure no-error.
    return error substitute( "&1 &2", return-value, error-status :get-message( 1 ) ).
  end.
  run waitfram-hide in this-procedure no-error.

/* $Workfile$   E n d */