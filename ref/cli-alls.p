/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Открытие запроса в справочнике клиентов

Автор: Чернова Светлана Александровна
Дата создания: 12/08/05
Author: Svetlana Chernova
Creation date: 12/08/05

*/

&if "{&db-name_schema}" = "ub" &then
&glob contains-oper contains
&else
&glob contains-oper  begins
&endif


{ ref/cli-all.i B }

{ gbl/fltopend.i
    &where-cond = " X_clients.obj-type = ~{&shop~} and X_clients.obj-name {&contains-oper} NameOrCode "
    &dyn_where-cond = " substitute('X_clients.obj-type = &1&2&1 and X_clients.obj-name {&contains-oper} &1&3&1 ', {&double-quote}, ~{&shop~}, NameOrCode)"
    &by         = "    " }


end.

end procedure. /* proc-main */