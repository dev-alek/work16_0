/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Виды внешних классификаторов

Автор: Бахтадзе Наталья Викторовна
Дата создания: 08/01/07
Author: Bakhtadze Natalya
Creation date: 08/01/07

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

&if defined(extclass_i) = 0 &then

&glob extclass_i


/*ext-classif.classif-subject*/
&glob extclass_clients ~{&table_clients~}
&glob extclass_goods ~{&table_goods~}
&glob extclass_subject-list (~{&table_clients~} + ~{&comma-char~} + ~{&table_goods~} + ~{&comma-char~} + ~{&table_gds-grp~})

/*ext-classif.classif-name*/
&glob bef-extclass_clients_inn inn
&glob extclass_clients_inn '{&bef-extclass_clients_inn}':U
&glob bef-extclass_clients_elcos exp-elcos-talon-code
&glob extclass_clients_elcos '{&bef-extclass_clients_elcos}':U
&glob bef-extclass_clients_parus exp-parus-code
&glob extclass_clients_parus '{&bef-extclass_clients_parus}':U
&glob bef-extclass_clients_parus-2 exp-parus-2-code
&glob extclass_clients_parus-2 '{&bef-extclass_clients_parus-2}':U
&glob bef-extclass_clients_GLN  GLN
&glob extclass_clients_GLN '{&bef-extclass_clients_GLN}':U
&glob bef-extclass_clients_exite-edi  exite-edi
&glob extclass_clients_exite-edi '{&bef-extclass_clients_exite-edi}':U

&glob bef-extclass_goods_fib goods_fib
&glob extclass_goods_fib '{&bef-extclass_goods_fib}':U


&glob bef-extclass_clients_th-th150  th-th150_clients
&glob extclass_clients_th-th150 '{&bef-extclass_clients_th-th150}':U
&glob bef-extclass_clients_th-th14  th-th14_clients
&glob extclass_clients_th-th14 '{&bef-extclass_clients_th-th14}':U


&glob bef-extclass_goods_elcos   exp-elcos-talon-gds-code
&glob extclass_goods_elcos   '{&bef-extclass_goods_elcos}':U
&glob bef-extclass_goods_accor   exp-accor-gds-code
&glob extclass_goods_accor   '{&bef-extclass_goods_accor}':U
&glob bef-extclass_clients_esys   clients-esys
&glob extclass_clients_esys   '{&bef-extclass_clients_esys}':U
&glob bef-extclass_goods_easyfuel   exp-easyfuel-talon-gds-code
&glob extclass_goods_easyfuel   '{&bef-extclass_goods_easyfuel}':U
&glob bef-extclass_clients_edoc-nn   clients-edoc-nn
&glob extclass_clients_edoc-nn   '{&bef-extclass_clients_edoc-nn}':U
&glob bef-extclass_goods_th-th150  th-th150_goods
&glob extclass_goods_th-th150 '{&bef-extclass_goods_th-th150}':U
&glob bef-extclass_goods_th-th14  th-th14_goods
&glob extclass_goods_th-th14 '{&bef-extclass_goods_th-th14}':U


&glob bef-extclass_oss-ref oss-ref
&glob extclass_oss-ref '{&bef-extclass_oss-ref}':U


&glob bef-extclass_goods_msf   msf-code
&glob extclass_goods_msf   '{&bef-extclass_goods_msf}':U


&glob bef-extclass_gds-grp_rpm rpm_gds-grp
&glob extclass_gds-grp_rpm '{&bef-extclass_gds-grp_rpm}':U

&glob bef-extclass_code_firm_in_ext_client code_firm_ext
&glob extclass_code_firm_in_ext_client '{&bef-extclass_code_firm_in_ext_client}':U

&glob bef-extclass_code_org_code_client code_org_client
&glob extclass_code_org_code_client '{&bef-extclass_code_org_code_client}':U

&glob extclass_name-list '~
~{&bef-extclass_clients_inn}~
,~{&bef-extclass_clients_elcos}~
,~{&bef-extclass_clients_parus}~
,~{&bef-extclass_clients_parus-2}~
,~{&bef-extclass_clients_GLN}~
,~{&bef-extclass_clients_th-th150}~
,~{&bef-extclass_clients_th-th14}~
,~{&bef-extclass_clients_exite-edi}~
,~{&bef-extclass_goods_elcos}~
,~{&bef-extclass_goods_th-th150}~
,~{&bef-extclass_goods_th-th14}~
,~{&bef-extclass_goods_accor}~
,~{&bef-extclass_goods_msf}~
,~{&bef-extclass_clients_esys}~
,~{&bef-extclass_goods_easyfuel}~
,~{&bef-extclass_clients_edoc-nn}~
,~{&bef-extclass_gds-grp_rpm}~
,~{&bef-extclass_goods_fib}~
,~{&bef-extclass_code_firm_in_ext_client}~
,~{&bef-extclass_code_org_code_client}~
,~{&bef-extclass_oss-ref}~
':U

&glob extclass_no-news '~
~{&bef-extclass_clients_th-th150}~
,~{&bef-extclass_clients_th-th14}~
,~{&bef-extclass_goods_th-th150}~
,~{&bef-extclass_goods_th-th14}~
,~{&bef-extclass_gds-grp_rpm}~
,~{&bef-extclass_goods_fib}~
':U

&glob extclass_no-hist '~
~{&bef-extclass_clients_th-th150}~
,~{&bef-extclass_clients_th-th14}~
,~{&bef-extclass_goods_th-th150}~
,~{&bef-extclass_goods_th-th14}~
,~{&bef-extclass_goods_fib}~
':U

/* extclass_extended-data-list */           /*Здесь можно размещать ТОЛЬКО ТЕ ТАБЛИЦЫ, которые НЕ СВЯЗАНЫ с физическими таблицами ТН (!), т.е. таблицы виртуальные, хранящие свои поля в таблице ext-classif, но которые нужно гонять по новостям и формировать историю.    Пояснение: процедура-триггер типа extclasw.p для записи в таблицу ub.ext-classif, до недавнего времени ВСЕГДА генерировала уникальный ключ (процедурой: gen-key-fv) с использованием физич. таблиц ТН. Данный список теперь используется для проверки и обхода процедуры gen-key-fv (в файле триггера extclasw.p)). */
&glob extclass_extended-data-list '~
~{&bef-extclass_oss-ref}~
':U

&endif

/* $Workfile$ e n d */