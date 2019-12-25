/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет для сверки ВБРР-Виза

Автор: Кабоев Валерий Асланович
Дата создания: 19/09/12
Author: Kaboev Valeriy
Creation date: 19/09/12

*/

DEFINE INPUT PARAMETER parparentproc AS WIDGET-HANDLE NO-UNDO .
DEFINE VARIABLE vss-revision    AS CHARACTER NO-UNDO INIT "$Revision$":U .
DEFINE VARIABLE vss-author      AS CHARACTER NO-UNDO INIT "$Author$":U .
DEFINE VARIABLE vss-date        AS CHARACTER NO-UNDO INIT "$Date$":U .
DEFINE VARIABLE vss-workfile    AS CHARACTER NO-UNDO INIT "$Workfile$":U .
DEFINE VARIABLE vss-archive     AS CHARACTER NO-UNDO INIT "$Archive$":U .
DEFINE VARIABLE vss-description AS CHARACTER NO-UNDO INIT "Отчет для сверки ВБРР-Виза".

{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ gbl/getcntxt.i def }
{ cmp/trg-def.i  }
{ cmp/r-page0.i new }
/*{ cmp/library.i }
{ cmp/r-page0.i new } */ /* определения для стандартной формы отчетов -часть независящая от БД*/

RUN rep/d-report.w (
  INPUT parparentproc
  ,INPUT 'rep/e-vbbr-viza.w'
  ,INPUT ('Отчет для сверки ВБРР-Виза')
  ,INPUT 4
  ,INPUT ""
  ,INPUT "*"
  ,INPUT ""
  ,INPUT ""
  ,INPUT ""
  ,INPUT NO).
