/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Получение глобальных переменных в статический объект gbl-var

Автор: Морозов Александр Сергеевич
Дата создания: 04/10/18
Author: Mikhail Pervakov
Creation date: 04/10/18

*/

{ cmp/trg-def.i  }


define variable objGblVar as class Ibs.Th.Gbl.gbl-var.


objGblVar = new Ibs.Th.Gbl.gbl-var().

objGblVar:InitObj(g#auto, g#news, g#news-source-db, g#db-num, g#userid, g#passwd, g#esys).
