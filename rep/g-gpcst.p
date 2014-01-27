 /*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Журнал продаж с ГТД и счетами-фактурами (компания СИМПЛ)

Author: Alexey Suslov
Creation date: 02/19/09
Автор: Суслов Алексей Юрьевич
Дата создания: 02/19/09

*/
define input  parameter parParentProc  as widget-handle no-undo.

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Реализация с печатью накладной поставщика и ГТД (компания СИМПЛ)".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/r-page1.i new}

run rep/d-report.w ( input parParentProc,
                     input 'rep/r-gpcst.p',
                     input ('Реализация с печатью накладной поставщика и ГТД'),
                     2,
                     "{&g-all}",
                     "*",
                     "",
                     "",
                     "shop,{&news-arj},{&Excel-yes}",
                     yes).