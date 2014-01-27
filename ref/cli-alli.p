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

{ ref/cli-all.i B }

{ gbl/fltopend.i
    &where-cond = " X_clients.obj-type = ~{&shop~} "
    &dyn_where-cond = " substitute('X_clients.obj-type = &1&2&1', ~{&double-quote~}, ~{&shop~}) "
    &by         = "    " }
  end. /*doe*/

end procedure. /* proc-main */