/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Прочистка бачпроцесса

Автор: Чернова Светлана Александровна
Дата создания: 11/22/07
Author: Svetlana Chernova
Creation date: 11/22/07

*/

define input  parameter p-doc-code as character no-undo .

FOR EACH BatchProcess exclusive-LOCK WHERE BP_Status <> 'd'
         and CharKey_One = p-doc-code
:
     assign     BP_Status = 'd' .
END.