/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Справочник "Кассовых параметров"

Автор: Рубан Дмитрий Андреевич
Дата создания: 01.05.2023

*/
{ cmp/str-glbl.i }
{ ref/codepar.i }
{ cmp/trg-def.i }
define variable vss-revision    as character no-undo init "$Revision:$":U .
define variable vss-author      as character no-undo init "$Author:$":U .
define variable vss-date        as character no-undo init "$Date:$":U .
define variable vss-workfile    as character no-undo init "$Workfile:$":U .
define variable vss-archive     as character no-undo init "$Archive:$":U .
define variable vss-description as character no-undo init "".
{ cmp/vssrevis.i }
define variable mCodeTrg as class ibs.th.ref.code.code_trg no-undo.
    
mCodeTrg = new ibs.th.ref.code.code_trg(if    g#db-num eq 0 
                                           or imode    ne {&update} 
                                        then imode 
                                        else {&lookup}).

mCodeTrg:formLable(1, 1, "Код").
mCodeTrg:formLable(1, 2, "Наименование").
mCodeTrg:formLable(1, 3, ?).
/*mCodeTrg:Mode = .*/
mCodeTrg:parparentproc = Parparentproc.
mCodeTrg:chek-erpRN = yes.
/*mCodeTrg:MaxLevel = mCodeTrg:startlevel.*/

mCodeTrg:parent = left-trim(iparent + {&delim-par} + icode,{&delim-par}).
mCodeTrg:startlevel = num-entries(mCodeTrg:parent,{&delim-par}).
/*find first code where code.parent eq iparent*/
/*                  and code.code   eq icode  */
/*                  no-lock no-error.         */
/*if available code                           */
/*then mCodeTrg:title = code.codename.        */
mCodeTrg:title = "Устройства".
mCodeTrg:brwcode().

finally:
   delete object mCodeTrg.
end finally. 