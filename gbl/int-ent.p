/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Определяет порядок, в котором перечислены процедуры в internal-entries

Автор: Перваков Михаил Сергеевич
Дата создания: 08/18/00
Author: Mikhail Pervakov
Creation date: 08/18/00

*/

define output parameter l-order-normal as logical no-undo .

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Определяет порядок, в котором перечислены процедуры в internal-entries".
/* { cmp/vssrevis.i }
   нельзя включать никакие дополнительные файлы
   так как в них могут быть определены процедуры и программа не будет работать
*/

def var v-first-proc as character no-undo .

assign
  v-first-proc = entry(1, this-procedure :internal-entries)
.

if v-first-proc = "test1":u then do:
  assign
    l-order-normal = true
  .
  return . /* --->>>--- */
end.
if v-first-proc = "test3":u then do:
  assign
    l-order-normal = false
  .
  return . /* --->>>--- */
end.

message
  vss-workfile vss-revision vss-description skip
  "v-first-proc" v-first-proc skip
  "internal-entries" this-procedure :internal-entries skip
  view-as alert-box error .
undo, return error . /* --->>>--- */


procedure test1 :

end procedure. /* test1 */

procedure test2 :

end procedure. /* test2 */

procedure test3 :

end procedure. /* test2 */