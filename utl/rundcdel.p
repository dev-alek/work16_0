/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Çàïóñê óòèëèòû ÎÊÎÍ×ÀÒÅËÜÍÎÃÎ ÓÄÀËÅÍÈß ÄÊ

Àâòîğ: Áàõòàäçå Íàòàëüÿ Âèêòîğîâíà
Äàòà ñîçäàíèÿ: 05/12/06
Author: Bakhtadze Natalya
Creation date: 05/12/06

*/

define input parameter parparentproc as widget-handle.
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Çàïóñê óòèëèòû ÎÊÎÍ×ÀÒÅËÜÍÎÃÎ ÓÄÀËÅÍÈß ÄÊ".
{ cmp/vssrevis.i }

run str/diallog.w (
                  input parparentproc
                , input this-procedure
                , input 'utl/dc-del.p':U
                , input '':U
                , input no /*p-auto-go*/
                , input 'Ïğåğâàòü'
                , input 'ÎÊÎÍ×ÀÒÅËÜÍÎÅ ÓÄÀËÅÍÈÅ ÍÅÈÑÏÎËÜÇÎÂÀÍÍÛÕ È ÎØÈÁÎ×ÍÎ ÂÂÅÄÅÍÍÛÕ ÄÈÑÊÎÍÒÍÛÕ ÊÀĞÒ') no-error .