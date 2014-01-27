/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Открытие запроса в справочнике клиентов

Автор: Бахтадзе Наталья Викторовна
Дата создания: 02/02/07
Author: Bakhtadze Natalya
Creation date: 02/02/07

*/

{ ref/cli-all.i B }

{ gbl/fltopend.i
    &where-cond = " X_clients.obj-type = ~{&shop~} and X_clients.db-num = g#db-num "
    &dyn_where-cond = " substitute('X_clients.obj-type = &1&2&1 and X_clients.db-num = &3 ', ~{&double-quote~}, ~{&shop~}, g#db-num)"
    &by         = "    " }
  end. /*doe*/

end procedure. /* proc-main */