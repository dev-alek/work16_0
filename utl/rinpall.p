/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Вызов утилиты импорта

Автор: Чернова Светлана Александровна
Дата создания: 03/25/08
Author: Svetlana Chernova
Creation date: 03/25/08

Автор1: Суслов Алексей Юрьевич
Дата создания: 04/12/06

*/
define input parameter parparentproc as handle no-undo.
run utl/imp-all.p (parparentproc, ?, ?, ?, ?, ?, ?, ?, ?).