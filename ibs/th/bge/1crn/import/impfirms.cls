/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных firms (фирмы, на АЗС выгружается только своя организация) из 1С

Автор: Молотков Сергей
Дата создания: 02/10/17
Author: Molotkov Sergey
Creation date: 02/10/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.impfirms: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.

  /* ===== обязательные параметры для создания фирм, которые отсутствуют в протоколе ====== */
  
  define property Cli-Grp-Code   as integer no-undo /* like ub.clients.grp-code */
    get. 
    set.
  define property Base-Code      as integer no-undo /* like ub.sysconf.base-code */
    get. 
    set.
  define property Cash-Pay-Code  as integer no-undo /* like ub.sysconf.cash-pay */
    get. 
    set.
  define property Credit-Pay     as integer no-undo /* like ub.sysconf.credit-pay */
    get. 
    set.
  define property Ret-Credit-Pay as integer no-undo /* like ub.sysconf.ret-credit-pay */
    get. 
    set.
  define property Sale-Type      as character no-undo /* like ub.sysconf.sale-type */
    get. 
    set.
  define property Sale-Code      as integer no-undo /* like ub.sysconf.sale-code */
    get. 
    set.
  define property Purch-Code     as integer no-undo /* like ub.sysconf.purch-code */
    get. 
    set.
    
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( objImp as class firms ):
    define variable v-mode       as character no-undo. /* create/update */
    define variable v-rid        as recid no-undo.
    define variable v-host-code  as integer no-undo . /* like ub.sysconf.host-code */
    define variable v-retfl      as logical no-undo .
    define buffer buf_sysconf for ub.sysconf .
    
    if objImp:del-f > 0 then do:
      Msg = "not supported in TH".
      v-retfl = false .
      return false. /* уходит в finally, где перевозвращает v-retfl вместо false */
    end.
    if objImp:del-l > 0 then do:
      Msg = "not supported in TH".
      v-retfl = false .
      return false. /* уходит в finally, где перевозвращает v-retfl вместо false */
    end.

    assign
      Msg = ""
      v-rid = ?
      v-host-code = integer(objImp:code_)
      
      /* и ещё поле contract-type
         character;X(8);Тип;Тип;;тип документа: прих., расх., внутр. Присваивается автоматически и никогда не меняется.`Typ`Tip;870;;0;;true;false;;;;;;;;;;1251;RUSSIAN_I;
         - обязательное; заполняется вероятно в триггере */
    .
    assign
      v-mode   = if can-find (first buf_sysconf where buf_sysconf.host-code = v-host-code) then {&update} else {&add-def}
    . 
  
    run adm/sysconf1.p
    (input-output v-rid  /* p-rid as recid, only for output */
    ,input v-mode        /* p-mode as character */
    ,input yes           /* p-silent: yes с выводом в return-value */
    ,input no            /* p-is-deploy: yes режим первоначальной раскрутки */ 
    ,input v-host-code   /* p-host-code like ub.sysconf.host-code */
    ,input Cli-Grp-Code  /* p-grp-code like ub.clients.grp-code */
    ,input objImp:name_  /* p-obj-name like ub.clients.obj-name */
    ,input no            /* p-avrg-price like ub.sysconf.avrg-price (log): yes Средние учётные цены Считать данную фирму посредником для отчетов; средние, последние учетные цены будут считаться по этой фирме; поле может быть истинно лишь в 1 фирме */
    ,input no            /* p-artic-disable like ub.sysconf.artic-disable (log): Автомат. артикул; режим добавления новых товаров - автоматическое заполнение артикула */
    ,input Base-Code     /* p-base-code Код базовой валюты */
    ,input ""            /* p-branch like ub.sysconf.branch Отрасль (вид деятельности) */
    ,input Cash-Pay-Code /* p-cash-pay Код оплаты наличными, когда надо считать налог с продажи */
    ,input ""            /* p-cashier like ub.sysconf.cashier Кассир */
    ,input 0.0           /* p-cons-vat-pc like ub.sysconf.cons-vat-pc Консигнационный НДС >9.9<% */
    ,input Credit-Pay    /* p-credit-pay Код оплаты кредита, платежи с таким кодом допускаются только для авторизованных клиентов и не учитываются в платежах по карте */
    ,input 0             /* p-firm-db-num like ub.sysconf.firm-db-num Номер главной БД для фирмы */
    ,input ""            /* p-head-position like ub.sysconf.head-position Должность рук-ля */
    ,input ""            /* p-KOPF like ub.sysconf.KOPF КОПФ */
    ,input no            /* p-negative-rest like ub.sysconf.negative-rest Отрицательные остатки; начальное значение по фирме, которое используется при добавлении нового товара */
    ,input no            /* p-ord-prt like ub.sysconf.ord-prt Детальный заказ (по признакам) */
    ,input no            /* p-osn-base like ub.sysconf.osn-base Учет ОС в баз. вал. (true) */
    ,input ""            /* p-property like ub.sysconf.property Организационно-правовая форма */
    ,input Purch-Code    /* p-purch-code Тип приобретения */
    ,input Ret-Credit-Pay /* p-ret-credit-pay Оплата задолженности по кредиту */
    ,input Sale-Type     /* p-sale-type */
    ,input Sale-Code     /* p-sale-code */
    ,input ""            /* p-snr-accnt like ub.sysconf.snr-accnt Главный бухгалтер */
    ,input ""            /* p-SOEI like ub.sysconf.SOEI СОЕИ */
    ,input ""            /* p-transport-cli-type like ub.sysconf.transport-cli-type Контрагент */
    ,input 0             /* p-transport-cli-code like ub.sysconf.transport-cli-code Код поставщика */
    ,input 0             /* p-transport-host like ub.sysconf.transport-host Фирма - Грузоперевозчик */
    ,input 0             /* p-transport-contract like ub.sysconf.transport-contract Договор оказания транспортных услуг */
    ,input 0             /* p-transport-uslov like ub.sysconf.transport-uslov Условия предоставления транспортных услуг */
    ,input 0.0           /* p-transport-value like ub.sysconf.transport-value Дополнения к условиям транспортировки (%, км, ...) */
    ,input ""            /* p-main-obj-type like ub.firm.main-obj-type -> clients.obj-type */
    ,input 0             /* p-main-obj-code like ub.firm.main-obj-code -> clients.obj-code */
    ,input no            /* p-als-gds Торговля чужим товаром clntattr({&cmp}, host-code, {&attr-als-gds}) */
    ,input ?             /* p-egrip-date ЕГРИП Дата clntattr({&cmp}, host-code, {&attr-egrip-date}) */
    ,input ""            /* p-egrip-num ЕГРИП Номер clntattr({&cmp}, host-code, {&attr-egrip-num}) */
    ,input yes           /* p-gen-s-f-office like ub.sysconf.gen-s-f-office Генерация счет-фактур только в офисе */
    ) .
    
    v-retfl = true .

    catch exAppErrors as class Progress.Lang.AppError :
      Msg = exAppErrors:ReturnValue .
      if Msg = "" then Msg = exAppErrors:GetMessage(1) .
      v-retfl = false.
      undo, throw exAppErrors .
    end catch .
    catch exProErrors as class Progress.Lang.ProError :
      Msg = exProErrors:GetMessage(1) . 
      v-retfl = false.
      undo, throw exProErrors .
    end catch .
    catch exAnyErrors as class Progress.Lang.Error:
      Msg = "Unexpected error occurred..." .
      v-retfl = false.
      undo, throw exAnyErrors .
    end catch .
    finally :
      return v-retfl.
    end finally .
  end method. /* end_of Excute */

end class.