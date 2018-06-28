/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Отчет ВСД

Автор: Рубан Дмитрий Андреевич
Дата создания: 31/05/2018
Author: Ruban Dmitriy
Creation date: 31/05/18

Ruban

*/
DEFINE VARIABLE vss-revision AS CHARACTER NO-UNDO INIT "$Revision$":U .
DEFINE VARIABLE vss-author      AS CHARACTER NO-UNDO INIT "$Author$":U .
DEFINE VARIABLE vss-date        AS CHARACTER NO-UNDO INIT "$Date$":U .
DEFINE VARIABLE vss-workfile    AS CHARACTER NO-UNDO INIT "$Workfile$":U .
DEFINE VARIABLE vss-archive     AS CHARACTER NO-UNDO INIT "$Archive$":U .
DEFINE VARIABLE vss-description AS CHARACTER NO-UNDO INIT "Отчет ВСД".  

{rep/r-statusvsd.p &only_print = YES     }  
