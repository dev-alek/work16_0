/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Адаптер динамических триггеров

Автор: Топорец Александр
Дата создания: 12/29/14
Author: Alexander Toporets
Creation date: 12/29/14

*/

DEFINE VARIABLE vss-revision    AS CHARACTER NO-UNDO INITIAL "$Revision$":U .
DEFINE VARIABLE vss-author      AS CHARACTER NO-UNDO INITIAL "$Author$":U .
DEFINE VARIABLE vss-date        AS CHARACTER NO-UNDO INITIAL "$Date$":U .
DEFINE VARIABLE vss-workfile    AS CHARACTER NO-UNDO INITIAL "$Workfile$":U .
DEFINE VARIABLE vss-archive     AS CHARACTER NO-UNDO INITIAL "$Archive$":U .
DEFINE VARIABLE vss-description AS CHARACTER NO-UNDO INITIAL "Адаптер динамических триггеров".

DEFINE VARIABLE mHandle AS HANDLE NO-UNDO. /* Ссылка на объект */

/* Адаптер триггера */
PROCEDURE DynaTrig:
    DEFINE INPUT PARAMETER iTrigger AS CHARACTER NO-UNDO.
    RUN DynaTrig IN (THIS-PROCEDURE:INSTANTIATING-PROCEDURE) 
        (mHandle, iTrigger) NO-ERROR.
END PROCEDURE.

/* Установить ссылку на объект */
PROCEDURE SetHandle:
    DEFINE INPUT PARAMETER iHandle AS HANDLE NO-UNDO.
    mHandle = iHandle.
END.
