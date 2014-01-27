 /*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Остатки товаров на указанную дату, оприходованных до заданной даты

Автор: Хныкин Павел Андреевич
Дата создания: 04/12/06
Author: Pavel Khnykin
Creation date: 04/12/06

*/
define input parameter parparentproc as widget-handle no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Остатки товаров на указанную дату, оприходованных до заданной даты".
{ cmp/vssrevis.i      }
{ cmp/str-glbl.i      }
{ cmp/library.i       }
{ cmp/r-page1.i new   }
{ gbl/getcntxt.i def  }

define variable g#log as logical no-undo.

{ gbl/getcntxt.i get " " parparentproc }
{ gbl/chk-actg.i
  v-cntxt-db-num
  v-cntxt-userid
  {&action-head-code-main}
  'actn_tax-settlement_print':U
  {&cntxt-firm}
  v-cntxt-host-code-obj
  '':U
  0
  0
  0
  0
  false
  g#Log
}
if not g#Log then return "NO".
run rep/d-report.w (
                            input parparentproc ,
                            input 'rep/e-pstrst.w',
                            input ('Остатки товаров на указанную дату, оприходованных до заданной даты'),
                            0,
                            "",
                            "*",
                            "",
                            "",
                            "{&Excel-yes}",
                            no
               ).