/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс ипорта данных shops (АЗК/АЗС) из 1С

Автор: Молотков Сергей
Дата создания: 03/10/17
Author: Molotkov Sergey
Creation date: 03/10/17

*/

using Progress.Lang.*.
using ibs.th.bge.1crn.subjects.*.

class ibs.th.bge.1crn.import.impshops: 
  
  { cmp/str-glbl.i class }
  
  
  define property Msg as character no-undo
    get. 
    set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  method public logical Excute( objImp as class shops ):
    define variable v-mode      as character no-undo. /* create/update */
    define variable v-rid1      as recid no-undo .
    define variable v-rid2      as recid no-undo .
    define variable v-obj-code  as integer no-undo . /* like ub.shop.obj-code */
    define variable v-db-num    as integer no-undo . /* like ub.db.db-num */
    define variable v-host-code as integer no-undo . /* like ub.shop.host-code */
    define variable v-grp-code  as integer no-undo . /* like ub.clients.grp-code */
    define variable v-addr1     as character no-undo . /* первые 80 символов для address1 */
    define variable v-addr2     as character no-undo . /* оставшиеся символы для address2 */
    define variable v-retfl     as logical no-undo .
    define buffer buf_shop for ub.shop .

    if objImp:del-f > 0 then do:
      Msg = "not supported in TH" .
      return false .
    end .
    if objImp:del-l > 0 then do:
      Msg = "not supported in TH" .
      return false .
    end .
    
    assign
      Msg = ""
      v-obj-code  = integer(objImp:code_)
      v-host-code = integer(objImp:frm-code)
      v-grp-code  = integer(objImp:grp-code)
      v-addr1     = substring(objImp:address, 1, 80)
      v-addr2     = substring(objImp:address, 81)
    .
    assign
      v-mode   = if can-find (first buf_shop where buf_shop.obj-code = v-obj-code) then {&update} else {&add-def} 
      /* АЗС импортируются всегда в ГБД. При создании АЗС создаётся db-num = АЗС.code_ */
      v-db-num = v-obj-code
    .

    if v-mode = {&add-def} then do:
      /* db с номером АЗС.code_ должна была быть создана раньше магазина */
      /* sysconf с номером db. должна была быть создана раньше записи о БД */
      /* создаём в ГБД запись об УБД */
      run adm/db01.p 
      (input-output v-rid1
      ,input v-mode
      ,input v-db-num      /* p-db-num like ub.db.db-num */
      /* ub.db.db-key       "Ключ БД"   пустое значение */
      /* ub.db.db-key-enc   "Кодировка" пустое значение */
      ,input objImp:name_  /* p-db-name like ub.db.db-name */
      /* ub.db.add-clients  "Возможность добавления клиентов" false */
      /* ub.db.remote-stock "Отправка чужих остатков"        false - вводится только в УБД */
      /* ub.db.send-check   "ОТправлять чеки из БД в ГБД"    true (! init value в БД = false !) - вводится только в УБД */
      /* ub.db.add-goods    "Возможность добавлять товары"   false */
      /* ub.db.on-line-rest "Мгновенные остатки"             false - вводится только в УБД */
      ,10 /* ub.db.save-packs (int) "Удалять файлы пакетов СПН из каталога heap через N дней" N=10 согласно скрин-шоту Юрия Румянцева от 02-мар-2017 (! init value в БД = 0 !) - вводится только в УБД */
      /* ub.db.max-p-size   "Максимальное кол-во записей в пакете"   10000 согласно скрин-шоту Юрия Румянцева от 02-мар-2017 (! init value в БД = 0 !) - вводится только в УБД */
      /* ub.db.max-p-queue  "Кол-во неподтвержденных пакетов больше"    10 согласно скрин-шоту Юрия Румянцева от 02-мар-2017 (! init value в БД = 0 !) - вводится только в УБД */
      /* ub.db.max-p-time   "Время ожидания подтверждения больше (мин)"  0 - вводится только в УБД */
      /* ub.db.unload-arch  "Выгружать складские архивы по товарам и по поставщикам" true - вводится только в УБД */
      /* ub.db.unload-aht   "Выгружать складской архив по типам приобретения"        true - вводится только в УБД */
      ) .
      /* in dbi.w Выгружать историю t-unload-history по умолчанию initial true работает в режиме выгрузки УБД when mode = "unld" */
    end .

    run adm/shop01.p
    (input-output v-rid2 /* p-rid as recid, only for output */
    ,input v-mode        /* p-mode as character */
    ,input v-obj-code    /* p-obj-code like ub.shop.obj-code */
    ,input v-db-num      /* p-db-num like ub.clients.db-num */
    ,input v-host-code   /* p-host-code like ub.shop.host-code */
    ,input v-grp-code    /* p-grp-code like ub.clients.grp-code */
    ,input objImp:name_  /* p-obj-name like ub.clients.obj-name */
    ,input ""            /* p-PS like ub.clients.PS */
    ,input objImp:accr   /* p-acct like ub.shop.acct - бухгалтер */
    ,input v-addr1       /* p-addres1 like ub.shop.addres1 */
    ,input v-addr2       /* p-addres2 like ub.shop.addres2 */

    /* параметры отсылки товаров на кассу магазина */    
    ,input false         /* p-all-prt like ub.shop.all-prt передача на кассу ВСЕХ признаков товаров */
    ,input true          /* p-buy-goods like ub.shop.buy-goods yes - приоритетная продажа выкупного товара, no - консигнационного */
    
    ,input false         /* p-cd-bc-alt like ub.shop.cd-bc-alt пересылать на кассу Бар-код доп. ед. изм. */
    ,input true          /* p-cd-bc-base like ub.shop.cd-bc-base пересылать на кассу Бар-код осн. ед. изм. */
    ,input false         /* p-cd-loc-alt like ub.shop.cd-loc-alt пересылать на кассу Лок. код доп. ед. изм. */
    ,input true          /* p-cd-loc-base like ub.shop.cd-loc-base пересылать на кассу Лок. код осн. ед. изм. */
    ,input false         /* p-cd-parts-all like ub.shop.cd-parts-all пересылать на кассу Партии для всех товаров */
    ,input false         /* p-cd-parts-not-blank like ub.shop.cd-parts-not-blank пересылать на кассу Партии для товаров с непустыми номерами */
    ,input false         /* p-cd-parts-ser like ub.shop.cd-parts-ser пересылать на кассу Партии для серийных товаров */
    ,input false         /* p-cd-pb-alt like ub.shop.cd-pb-alt пересылать на кассу Доп. БК доп. ед. изм. */
    ,input true          /* p-cd-pb-base like ub.shop.cd-pb-base пересылать на кассу Доп. БК осн. ед. изм. */
    ,input true          /* p-cd-sc-base like ub.shop.cd-sc-base пересылать на кассу Вес. код */
    
    ,input 1             /* p-chk-pay like ub.shop.chk-pay = pay-type.obj-code Код оплаты продажи по умолчанию */
    ,input yes           /* p-day-only like ub.shop.day-only yes (нач. значение) - в кассовом отчете присутствуют чеки только за один день (или часть дня), no - за произвольный (больший) период */
    ,input objImp:director /* p-director like ub.shop.director */
    ,input yes           /* p-discaloc like ub.shop.discaloc Размазывать скидку на итог */
    ,input no            /* p-doc-prt like ub.shop.doc-prt учёт по шкалам */
    ,input 2             /* p-down-pay like ub.shop.down-pay Код оплаты списания по умолчанию */
    ,input ""            /* p-fax like ub.shop.fax */
    ,input ""            /* p-goods-man like ub.shop.goods-man */
    ,input no            /* p-in-ov like ub.shop.in-ov Переоценка после прихода */
    ,input 2             /* p-in-pay like ub.shop.in-pay Код оплаты прихода по умолчанию */
    ,input no            /* p-in-perm like ub.shop.in-perm Перемещение по цене магазина */
    ,input yes           /* p-inout-price like ub.shop.inout-price Изменение налогов поставщика в ПН */
    ,input 2             /* p-inv-pay like ub.shop.inv-pay Код оплаты инвентаризации по умолчанию */
    
    /* Склад кухни - это сам магазин.
       Т.к. номер магазина совпадает с номером Склада кухни,
       то сначала надо создать обьект магазин, а потом уже присвоить номер Склад кухни. */
    ,input yes           /* p-is-catering like ub.shop.is-catering Объект-РЕСТОРАН */
    ,input no            /* *p-is-kitchen like ub.shop.is-kitchen Объект-кухня */
    ,input no            /* *p-is-kitchen-store like ub.shop.is-kitchen-store Объект-склад для кухни */
    ,input 0             /* *p-kitchen-store-code like ub.shop.kitchen-store-code Код объекта Склад Кухни */
    ,input ""            /* *p-kitchen-store-type like ub.shop.kitchen-store-type Перечислимый тип объекта Склад Кухни */
    
    ,input no            /* p-no-eq like ub.shop.no-eq Если включено - нельзя закрыть приход при нулевых или отсутствующих продажных ценах */
    ,input no            /* p-out-line-discnt like ub.shop.out-line-discnt Можно установить скидку по строке накладной */
    ,input 2             /* p-out-pay like ub.shop.out-pay Код оплаты расхода по умолчанию */
    ,input no            /* p-out-rate like ub.shop.out-rate Можно менять курс расходной накладной */
    ,input objImp:tel    /* p-phone like ub.shop.phone */
    ,input yes           /* p-pr-cash like ub.shop.pr-cash Разрешить переоценку без блокировки касс */
    ,input no            /* p-price-calc like ub.shop.price-calc нельзя закрыть приход на объекте, если приходная цена не равна продажной */
    ,input 2             /* p-ret-pay like ub.shop.ret-pay Код оплаты возврата по умолчанию */
    ,input 3             /* p-ret-sup-pay like ub.shop.ret-sup-pay Код типа оплаты для операции "возврат поставщику" */
    ,input 2             /* p-fbr-pay like ub.shop.fbr-pay Код оплаты производства по умолчанию */
    ,input 0             /* p-rsrv-time like ub.shop.rsrv-time период в днях, подставляемый по умолчанию для резерва при создании нового счета */
    ,input yes           /* p-shift-on like ub.shop.shift-on На объекте включены смены */
    ,input ""            /* p-store-boss like ub.shop.store-boss Зав. складом */
    ,input ""            /* p-store-man like ub.shop.store-man Кладовщик */
    ,input no            /* p-sub-store-on like ub.shop.sub-store-on Определять товародвижение по подсобке */
    ,input 0             /* p-sub-store-code like ub.shop.sub-store-code Код объекта-подсобки */
    ,input ""            /* p-sub-store-type like ub.shop.sub-store-type Тип объекта-подсобки */
    ,input yes           /* p-unit-cli-perm like ub.shop.unit-cli-perm Изменение ед. изм. поставщика */
    ,input yes           /* p-with-serv like ub.shop.with-serv yes - если маг-н реализует услуги */
    ,input ""            /* p-work-hours like ub.shop.work-hours Часы работы в формате "99.99,99.99" */
    ,input ?             /* p-purch-code like ub.shop.purch-code (int) Тип приобретерия */
    ,INPUT no            /* p-envd доп.атрибуты по ЕНВД */ 
    ,INPUT no            /* p-pharm доп.атрибуты по Аптека */
    ,input ""            /* p-KPP доп.атрибуты по КПП */
    ) .

    for first buf_shop exclusive-lock
        where buf_shop.obj-code = v-obj-code:
      assign
        buf_shop.is-kitchen         = yes
        buf_shop.kitchen-store-type = {&shop}
        buf_shop.kitchen-store-code = v-obj-code
      .
    end.
    
    v-retfl = true.
    
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
      return v-retfl .
    end finally .
  end method. /* end_of Excute */

end class.