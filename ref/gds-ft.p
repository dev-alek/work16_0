/*
$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Âûáîğ òèïà òîïëèâà, àòğèáóò òîâàğà

Àâòîğ: Ãğèä÷èíà Ïîëèíà Äìèòğèåâíà
Äàòà ñîçäàíèÿ: 14/08/04
Author: Gridchina Polina
Creation date: 14/08/04
*/

define input parameter p-mode as character no-undo .
DEFINE INPUT PARAMETER p-gds-code AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p-spr-param AS character NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p-attr-value AS character NO-UNDO.
DEFINE OUTPUT PARAMETER p-setted AS LOGICAL NO-UNDO.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Âûáîğ òèïà òîïëèâà, àòğèáóò òîâàğà".

{ cmp/vssrevis.i }
{ gbl/waitfram.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i }
{ rep/frmlib.i }

def var v-choose as char no-undo.

  run gbl/d-list.w (
              INPUT "b-sel":U
              ,INPUT "Âûáåğèòå òèï òîïëèâà"
              ,INPUT "petrol,diesel-sum,diesel-wint,metan,propan,lgas"
              ,INPUT "Áåíçèí,ÄÒ ëåòíåå,ÄÒ çèìíåå,Ìåòàí,Ïğîïàí,ÑÓÃ"
              ,INPUT {&comma-char}
              ,INPUT  p-attr-value
              ,output v-choose).

p-attr-value = v-choose.
if p-attr-value > '' then p-setted = yes.
