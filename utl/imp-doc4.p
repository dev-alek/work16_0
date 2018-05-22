/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Импорт накладных

Автор: Молотков Сергей
Дата создания: 10/04/18
Author: Molotkov Sergey
Creation date: 10/04/18

Из имеющегося файла с партиями сформировать накладные по указанным поставщикам и договорам.
В параметрах утилиты должны задаваться:
Имя файла импорта и код ВС, относительно которой внесены соответствия кодов контрагентов.
*/
block-level on error undo, throw.
using ibs.th.gbl.gbl-var.

define input parameter parparentproc    as handle no-undo .
define input parameter p-parent-handle  as handle no-undo .
define input parameter p-log-handle     as handle no-undo .
define input parameter p-parameter      as character no-undo .
/*p-parameter включает в себя */
define variable p-in-file     as character no-undo .
define variable p-obj-code    as integer no-undo .
define variable p-obj-type    as character no-undo .
define variable p-is-close    as logical no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Импорт накладных".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i  }
{ ref/extclass.i }
{ str/lib-trn.i  }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ str/getctxtp.i def }
{ str/getctxtp.i get }
{ cmp/gds-list.i gds-list def }
{ str/doc-code.i }
{ str/lib-def.i  }
{ cmp/df-sub.i   }
{ cmp/thth150.i }

// @NOTE логических полей избегать, иначе при импорте пустого значения ';;;' будет ошибка:
//       логическое поле может быть только yes/no
define temp-table tt-imp-parts no-undo
  /* 01 */ field artic         as character
           field f02           as character
  /* 03 */ field part-code     as character
  /* 04 */ field in-code       like ub.parts.in-code
  /* 05 */ field gds-code      as integer
  /* 06 */ field price-rubl    like ub.parts.price-rubl
  /* 07 */ field fact-qnty     like ub.parts.fact-qnty
           field f08           as character
           field f09           as character
           field f10           as character
  /* 11 */ field vat-tax-value as decimal
           field f12           as character
           field f13           as character
  /* 14 */ field name-gtd      as character
           field f15           as character
           field f16           as character
  /* 17 */ field srok-god      as character
           field f18           as character
           field f19           as character
  /* 20 */ field supp-code     as integer
  /* 21 */ field supp-type     as character
  /* 22 */ field cont-prn-code like ub.contract.contract-prn-code
           field imp-row       as character // исходая строка из файла импорта
.

define temp-table temp_parts no-undo like ub.parts
  field new_artic     as character
  field new_prod-type as character
  field new_prod-code as integer
  field new-cli-type  as character
  field new-cli-code  as integer
  index pi is primary
supp-type
supp-code
host-code
contract-code
VAT-type
VAT-PC
prod-type
prod-code
artic
price-cli
part-code
fact-date
.

define temp-table temp-line no-undo
  field num           as integer
  field supp-type     as character
  field supp-code     as integer
  field host-code     as integer
  field contract-code as integer
  field artic         as character
  field prod-type     as character
  field prod-code     as integer
  field part-code     as character
  field vat-type      as character
  field vat-pc        as decimal
  field price-rubl    as decimal
  field fact-qnty     as decimal
  field cli-qnty      as decimal
  field new-cli-type  as character
  field new-cli-code  as integer
  index pi is primary
  supp-type
  supp-code
  host-code
  contract-code
  vat-type
  vat-pc
  artic
  prod-type
  prod-code
  part-code
  price-rubl
  num
.

define temp-table temp-2exists no-undo
  field artic     as character
  field prod-type as character
  field prod-code as integer
  field doc-code  as character
  index pi is unique primary
  doc-code
  artic
  prod-type
  prod-code
.

define temp-table tt-trn-doc   no-undo like ub.trn-doc .
define temp-table tt2-doc-line no-undo like lib-trn_ret-line .
define temp-table tt-doc-line  no-undo like ub.doc-line .
define temp-table tt-gds-dtl   no-undo like ub.gds-dtl .
define temp-table tt-parts     no-undo like ub.parts.
define temp-table tt-doc-line-attr no-undo like ub.doc-line-attr .
define temp-table gds-list1    no-undo like gds-list .

define variable v-f-cli-type as character no-undo .
define variable v-f-cli-code as integer   no-undo .
define variable v-classif-name as character no-undo .
define variable v-cli-classif-name as character no-undo .
define variable new_obj-code   as integer   no-undo .
define variable new_obj-type   as character no-undo .
define variable new_host-code  as integer   no-undo .
define variable new_purch-code as integer no-undo .
define variable v-tti as integer   no-undo .
define variable v-print-rubl as logical   no-undo .
define variable v-ii          as integer   no-undo .
define variable v-count-all   as integer no-undo .
define variable v-count-err   as integer no-undo .
define variable local-trace-on as logical no-undo .

define buffer new_ext-classif for ub.ext-classif  .
define buffer new_trn-doc     for ub.trn-doc  .
define buffer new_line        for temp-line  .
define buffer buf2_temp_parts for temp_parts  .
define buffer old_contract-specif for ub.contract-specif  .
define buffer buf_shop        for ub.shop .

&glob display-message  run write-log-and-file in p-log-handle ( 1, log-file-name, 1, ~{&my-message~} )
/*
&glob display-count-message  run write-counter in p-log-handle (input ~{&my-count-message~})
&glob hide-count-message  run hide-counter in p-log-handle
*/
local-trace-on = false .

/* разбор и проверка входных параметров */
define variable v-input-error as logical no-undo .
define variable v-view-log    as logical no-undo .
define variable v-esm         as character no-undo .
define variable log-file-name as character no-undo .
define variable v-num-params  as integer no-undo initial 4 .
/* 20/IV-2018  внутри diallog.w проверяется имя лог-файла.
               Если имя файла задано со слэшом - оно заменяется на имя текущей процедуры.
               Если имя файла задано без слэша - оно пишется в текущую директорию.
               Выбираем второй вариант, как наименьшее зло.
*/
log-file-name = substitute("impdoc4.log", ibs.th.gbl.gbl-inipar:logDir) .
if num-entries(p-parameter, {&delim-par}) = v-num-params then do:
  assign
     p-in-file  =          entry(1, p-parameter, {&delim-par})
     p-obj-code = integer( entry(2, p-parameter, {&delim-par}) )
     p-obj-type =          entry(3, p-parameter, {&delim-par})
     p-is-close = logical( entry(4, p-parameter, {&delim-par}) )
  no-error .
  v-input-error = error-status:error .
  if v-input-error then v-esm = error-status:get-message(1) .
end.
else do:
  assign
    v-input-error = yes
    v-esm         = substitute("Неверное количество ENTRY в составном параметре - &1, должно быть &2"
                             , num-entries(p-parameter, {&delim-par})
                             , v-num-params)
  .
end.
if v-input-error = yes then do:
  &scop my-message substitute("Ошибка входных параметров:&2&1&2&3", p-parameter, {&new-line}, v-esm)
  {&display-message}.
  v-view-log = yes.
  return.
end.

define variable p-from-version as character no-undo .
p-from-version = {&thth150-from-version} .

v-f-cli-type = {&cmp} .

define stream f-err-lines .
define variable v-err-file-name as character no-undo .
case p-from-version:
  when {&thth150-from-version} then do:
    assign
    v-classif-name = {&extclass_goods_th-th150}
    v-cli-classif-name = {&extclass_clients_th-th150}
    .
  end.
  /*
  when {&thth14-from-version} then do:
    assign
    v-classif-name = {&extclass_goods_th-th14}
    v-cli-classif-name = {&extclass_clients_th-th14}
    .
  end.
  */
end case.
/*
log-file-name = substitute("&1.txt", entry(1, entry(num-entries(this-procedure:file-name, {&slash-char}), this-procedure:file-name, {&slash-char}), ".")).
*/

&scop my-message substitute("Перенос партий свободной зоны из &1 в 16.0 ...", p-from-version)
{&display-message}.
/*run save-conf-par in this-procedure .*/


  /* поиск соответствия старого obj-code p-from-version версии в 16.0 */
  assign
    new_obj-type = p-obj-type
    new_obj-code = p-obj-code
  . // никакого соответствия не нужно: p-obj-type и p-obj-code заданы для целевой системы; информация об исходной системе не требуется.
  find first buf_shop no-lock where buf_shop.obj-code = new_obj-code no-error .
  if available buf_shop then do:
    new_purch-code = if buf_shop.purch-code > 0 then buf_shop.purch-code else {&bef-repayment-code} .
  end .
  else new_purch-code = {&bef-repayment-code} .

    { gbl/hostcode.i
      new_obj-type
      new_obj-code
      new_host-code
      }
    { gbl/curobjdt.i
      new_obj-type
      new_obj-code
      to-day
    }

run import_file in this-procedure (p-in-file) .

/* ----- перекодировка их supp-code-15_0 в наш supp-code_16_0 ----- */
define temp-table w-osn no-undo
  field supp-code-16_0 as integer
  field supp-code-15_0 as integer
.
define stream fosnid.
define variable v-osn-fname as character no-undo .
v-osn-fname = substitute("&1_supp.txt", p-obj-code) .
input stream fosnid from value (v-osn-fname).
repeat:
  create w-osn.
  import stream fosnid w-osn.
end.
input stream fosnid close.
find w-osn where w-osn.supp-code-16_0 = 0 and w-osn.supp-code-15_0 = 0 no-error.
if available w-osn then delete w-osn.
/* ----- end_of перекодировка их supp-code-15_0 в наш supp-code_16_0 ----- */


    empty temp-table temp-line no-error .
    EMPTY TEMP-TABLE temp_parts no-error .
    empty temp-table tt-parts .


  define variable v-str as character no-undo .
  v-str = entry(1, p-in-file, ".") .
  v-err-file-name = substitute("&2.err"
    , ibs.th.gbl.gbl-inipar:logDir
    , substring(  v-str,  r-index(v-str, "\") + 1  )
  ) .
  output stream f-err-lines to value(v-err-file-name) .  


run create_temp_parts in this-procedure (p-obj-code, p-obj-type).
  output stream f-err-lines close .
  
/* импорт шапки */
run import-hed in this-procedure no-error .
    if error-status :error then do:
      &scop my-message substitute("ошибка при импорте ПН  &1 &2" , error-status :get-message(1) , return-value )
      {&display-message}.
      return error  .
    end.
/*run re-save-conf-par in this-procedure .*/

  &scop my-message substitute("Всего прочитано &1 записей. Из них отвергнуто &2", v-count-all, v-count-err )
  {&display-message}.

{&hide-count-message}.


define stream f-inp .
procedure import_file private:
define input parameter p-file-name as character no-undo .
define variable v-imp-row as character no-undo .
define buffer buf_tt-parts for tt-imp-parts .

  empty temp-table tt-imp-parts .
  v-count-all = 0 .
  input stream f-inp from value(p-file-name) no-echo .
  repeat on endkey undo, leave:
    /* строки импортируемого файла, содержащие ошибке, сохранить в отдельном файле того же формата;
       поэтому каждую прочитанную строку необходимо разбирать поэнтриво и хранить в текстовом виде
       вместе с записью, которая по ней создалась во временной таблице */
    // import stream f-inp DELIMITER ';' tt-imp-parts2 .
    v-imp-row = "" .
    import stream f-inp unformatted v-imp-row .
    if v-imp-row > "" then do:
      create buf_tt-parts .
      assign
        buf_tt-parts.artic         = substring(  entry( 1, v-imp-row, ';'),  7  ) // отрезаем начальное "PART: &1;"
        buf_tt-parts.part-code     =      trim(  entry( 3, v-imp-row, ';')  )
        buf_tt-parts.in-code       =      trim(  entry( 4, v-imp-row, ';')  )
        buf_tt-parts.gds-code      =   integer(  entry( 5, v-imp-row, ';')  )
        buf_tt-parts.price-rubl    =   decimal(  entry( 6, v-imp-row, ';')  )
        buf_tt-parts.fact-qnty     =   decimal(  entry( 7, v-imp-row, ';')  )
        buf_tt-parts.vat-tax-value =   decimal(  entry(11, v-imp-row, ';')  )
        buf_tt-parts.name-gtd      =             entry(14, v-imp-row, ';')
        buf_tt-parts.srok-god      =             entry(17, v-imp-row, ';')
        buf_tt-parts.supp-code     =   integer(  entry(20, v-imp-row, ';')  )
        buf_tt-parts.supp-type     =             entry(21, v-imp-row, ';')
        buf_tt-parts.cont-prn-code =             entry(22, v-imp-row, ';')
        buf_tt-parts.imp-row       =                       v-imp-row
        v-count-all = v-count-all + 1
      .
    end .
  end.
  input stream f-inp close.

if local-trace-on then do:
define variable dsXmlFileName as character no-undo .
dsXmlFileName = substitute("&1.xml", entry(1, p-file-name, ".")).
temp-table tt-imp-parts:WRITE-XML ( "FILE", dsXmlFileName, true, "UTF-8").
end .
end procedure . /* import_file */


define stream f-tgds .
procedure create_temp_parts private :
define input parameter p-obj-code as integer no-undo .
define input parameter p-obj-type as character no-undo .
define variable v-last-date as date no-undo .
define variable v-prod-type as character no-undo .
define variable v-prod-code as integer no-undo .
define variable v-host-code as integer no-undo .
define variable v-contract-code as integer no-undo .
define variable new_cli-type  as character no-undo .
define variable new_cli-code  as integer   no-undo .
define variable v-is-supp-err as logical no-undo .
define variable v-is-cont-err as logical no-undo .
define variable v-is-good-err as logical no-undo .
define variable v-my-message  as character no-undo .
define buffer buf_tt-parts for tt-imp-parts .
define buffer buf_goods    for ub.goods .
define buffer buf_contract for ub.contract .
define buffer new_clients  for ub.clients .

  { gbl/hostcode.i p-obj-type p-obj-code v-host-code }
  
  &scop my-message v-my-message
  

v-count-err = 0 .

  for each buf_tt-parts
  break by buf_tt-parts.supp-code
        by buf_tt-parts.cont-prn-code
        by buf_tt-parts.artic
  :
    if first-of (buf_tt-parts.supp-code) then do:
      /* Если у партии не указан код поставщика - такую строку считать ошибочной и не обрабатывать.
         Код фиктивного контрагента не использовать. */
      if buf_tt-parts.supp-type = ""
      or buf_tt-parts.supp-type = {&stock}
      or buf_tt-parts.supp-type = {&shop} then assign
        v-my-message  = substitute ("Фиктивный контрагент &1 &2", buf_tt-parts.supp-type, buf_tt-parts.supp-code )
        v-is-supp-err = true
      .
      else do :
        /* поиск соответствия старого cli-code p-from-version версии в 16.0 */
        find first w-osn where w-osn.supp-code-15_0 = buf_tt-parts.supp-code no-error .
        if available w-osn then do:
          assign
            new_cli-type = buf_tt-parts.supp-type
            new_cli-code = w-osn.supp-code-16_0
          .
          v-is-supp-err = not can-find (first new_clients
                                        where new_clients.obj-type = new_cli-type
                                          and new_clients.obj-code = new_cli-code) .
          if v-is-supp-err then v-my-message = substitute("ошибка (новый клиент &1 &2)", new_cli-type , new_cli-code) .
        end .
        else assign
          v-my-message  = substitute ("Отсутствует код поставщика &1 в файле соответствия &2", buf_tt-parts.supp-code, v-osn-fname )
          v-is-supp-err = true
        .
      end .
      
      if v-is-supp-err then do :
        /* Ошибку выводить в лог-файл, а строку ошибки выводить в отдельный файл, пригодный для повторного импорта, как есть.
           Работу по остальным строкам продолжать. */
        {&display-message}.
      end .
    end . /* end_of first_of_tt-parts.supp-code */
    if v-is-supp-err then do :
      /* @NOTE надо отсечь все строки с этим поставщиком, а не только первую */
      put stream f-err-lines unformatted buf_tt-parts.imp-row skip .
      v-count-err = v-count-err + 1 .
      next .
    end .
      
    if first-of (buf_tt-parts.cont-prn-code) then do:
      find first buf_contract no-lock
           where buf_contract.contract-prn-code = buf_tt-parts.cont-prn-code no-error .
      if available buf_contract then assign
        v-contract-code = buf_contract.contract-code
        v-is-cont-err   = false
      .
      else assign
        v-contract-code = 0
        v-is-cont-err   = true
      .
    end .

    if first-of (buf_tt-parts.artic) then do:
      /* в идеале в формате импорта может быть задан производитель (элемент сразу за артикулом).
         Если он задан, то искать парой. Если нет - то первый попавшийся */                       
      find first buf_goods no-lock
           where buf_goods.artic = buf_tt-parts.artic no-error .
      if available buf_goods then assign
        v-prod-type = buf_goods.prod-type
        v-prod-code = buf_goods.prod-code
        v-is-good-err = false
      .
      else assign
        v-prod-type = ""
        v-prod-code = 0
        v-is-good-err = true
        v-my-message  = substitute ("Отсутствует товар с артикулом &1 в справочнике товаров БД", buf_tt-parts.artic )
      .
      /* 28/IV-2018 Ошибку выводить в лог-файл, как и в случае отвергнутого поставщика. */
      if v-is-good-err then do :
        {&display-message}.
      end .
    end .
    /* 26/IV-2018  Партии с ненайденным товаром надо отвергать */
    if v-is-good-err then do :
      put stream f-err-lines unformatted buf_tt-parts.imp-row skip .
      v-count-err = v-count-err + 1 .
      next .
    end .
    /* 26/IV-2018  Товары с ненайденным договором надо отображатьв логе */
    if v-is-cont-err then do :
      v-my-message  = substitute ("Отсутствует договор № &1 в целевой БД. Товар &2 будет загружен без указания договора.",
                                  buf_tt-parts.cont-prn-code, buf_tt-parts.artic ) .
      {&display-message}.
    end .

    if buf_tt-parts.srok-god = "" then v-last-date = 01/01/2001 .
                                  else v-last-date = date(buf_tt-parts.srok-god) no-error .
    do :
    create temp_parts.
    assign
      temp_parts.artic      = buf_tt-parts.artic
      temp_parts.prod-type  = v-prod-type
      temp_parts.prod-code  = v-prod-code
      temp_parts.new_artic     = buf_tt-parts.artic
      temp_parts.new_prod-type = v-prod-type
      temp_parts.new_prod-code = v-prod-code

      temp_parts.obj-type   = p-obj-type
      temp_parts.obj-code   = p-obj-code
      temp_parts.host-code  = v-host-code 

      temp_parts.supp-code  = buf_tt-parts.supp-code
      temp_parts.supp-type  = buf_tt-parts.supp-type
      temp_parts.contract-code = v-contract-code
//  field cont-prn-code like ub.contract.contract-prn-code

      temp_parts.in-code    = buf_tt-parts.in-code // temp_parts.in-code используется для распределения партий по накладным; далее после записи документа в БД перезатирается номером созданного документа внутри стандартных процедур
//      temp_parts.out-code создаётся пустым и потом заполняется номером документа, в который внесён товар по данной партии 
      temp_parts.part-code  = buf_tt-parts.part-code // Код, определяющий конкретную партию внутри одного прихода

//  field gds-code      as integer
      temp_parts.price-rubl = buf_tt-parts.price-rubl // вместо price-cli используется price-rubl
      temp_parts.fact-qnty  = buf_tt-parts.fact-qnty
      temp_parts.VAT-type   = {&inc-VAT}
      temp_parts.VAT-pc     = buf_tt-parts.vat-tax-value
      temp_parts.cst-code   = buf_tt-parts.name-gtd
      temp_parts.last-date  = v-last-date
      
      temp_parts.new-cli-type = new_cli-type
      temp_parts.new-cli-code = new_cli-code
    .
    end .
  /*
остались незаполненными:
whole-send-news;integer;->,>>>,>>9;Отправилась в новости целой записью;;0;Признак отправки в новости из текущей бд;50;;0;;false;false;;;;;;;;;;;;
price-base;decimal;->>,>>9.99;Цена (вал);Цена (вал);0;$учетная цена в базовой валюте из внешних приходов`Price(cur)`Pret (val.);260;10;0;;false;false;;;;;;;;;;;;
qnty;decimal;->>,>>>,>>9.999;По док-ту;По док-ту;0;Количество товара по док-ту в учетных единицах измерения`On doc`Pe act   ;280;3;0;;true;false;;;;;;;;;;;;
fact-date;date;99/99/99;;;;Дата внешней приходной накладной`External income way-bill date;310;;0;;false;false;;;;;;;;;;;;
fact-num;integer;->,>>>,>>9;;;0;порядковый номер закрытия по факту in-code`sequence number of closing by fact in-code;320;;0;;false;false;;;;;;;;;;;;
PS;character;X(50);Описание;Описание;;описание партии (изделия с серийным номером)`Descript`Legenda ;360;;0;;false;false;;;;;;;;;;1251;RUSSIAN_I;
pay-code;integer;99999;&Оплата;Оплата;;`&Paym.`&Plata ;370;;0;;false;false;;;;;;;;;;;;
status_;logical;yes/no;;;no;yes для закрытых по факту накладых`yes for notes closed by fact;380;;0;;false;false;;;;;;;;;;;;
rsrv-free;logical;yes/no;;;no;yes - резерв и свободная зона, no - резерв и расходная зона , ? - все остальное`yes - stock and free area, no - stock and expense area , ? - the rest;420;;0;;false;false;;;;;;;;;;;;
doc-type;character;X(8);Тип;Тип;;тип документа, на который зарезервирована или закрыта партия. Используется для пометки партий в browse. Не тип документа, породившего партию.`Typ`Tip;430;;0;;true;false;;;;;;;;;;1251;RUSSIAN_I;
cli-qnty;decimal;->>,>>>,>>9.999;По ТТН;По ТТН;0;Фактическое количество товара в единицах измерения поставщика`On GTW`Pe NTT;440;3;0;;false;false;;;;;;;;;;;;
pl-code;integer;999999999;Бар-код;;0;`Bar-cod`Bar-cod;450;;0;;true;false;;;;;;;;;;;;
exch-code;integer;>>9;Валюта;Валюта;;код валюты поставщика`CRC.`Valuta;470;;0;;false;false;;;;;;;;;;;;
cli-base-rate;decimal;>>,>>9.<<<<;Коэффициент;Коэффициент;0;`Coefficient`Coeficient ;490;10;0;;true;false;;;;;;;;;;;;
SLT-pc;decimal;>9.9<%;Налог с продаж;Налог с продаж;0;`Sales tax`Impoz pe vinz ;500;10;0;;false;false;;;;;;;;;;;;
is-supp;logical;yes/no;;;no;yes - создана внешней ПН, no - другим документом`yes - created by external DN, no- by other docum;520;;0;;false;false;;;;;;;;;;;;
real-qnty;decimal;->>,>>>,>>9.999;Реальное количество;Реальное количество;;Реальное количество товара в учетных единицах измерения, зарезервированное из положительных партий расходной или свободной зоны (в отличие от вновь созданных партий по данному документу)`Real quantity`Cant-tea reala     ;530;3;0;;false;false;;;;;;;;;;;;
SLT-type;character;X(8);НП;НП;;способ расчета НП`ST`Impoz pe vinz ;540;;0;;false;false;;;;;;;;;;1251;RUSSIAN_I;
road-tax-base;decimal;->,>>>,>>9.99;Дорожный налог(вал);;;$`Road tax (shaft)`Tarif de drum(val) ;570;10;0;;false;false;;;;;;;;;;;;
road-tax-rubl;decimal;->,>>>,>>9.99;Дорожный налог(руб);;;$`Road tax (nc)`Tarif de drum(nc)  ;580;10;0;;false;false;;;;;;;;;;;;
transport-base;decimal;->,>>>,>>9.99;Транспортные расходы(вал);;;$`Transport expenditures (shaft)`Transport cheltueli(val) ;590;10;0;;false;false;;;;;;;;;;;;
transport-rubl;decimal;->,>>>,>>9.99;Транспортные расходы(руб);;;$`Transport expenditures (nc)`Transport cheltueli( nc) ;600;10;0;;false;false;;;;;;;;;;;;
other-base;decimal;->,>>>,>>9.99;Прочие расходы(вал);;;$`Other expenditures (shaft)`Diverse chelt (val);610;10;0;;false;false;;;;;;;;;;;;
other-rubl;decimal;->,>>>,>>9.99;Прочие расходы(руб);;;$`Other expenditures (nc)`Diverse chelt  (nc);620;10;0;;false;false;;;;;;;;;;;;
purch-code;integer;9;Тип приобретения;;;Тип приобретерия;630;;0;;false;false;;;;;;;;;;;;
mark-db-num;integer;>>>>9;БД акцизной марки;БД акцизной марки;0;Номер БД, где была создана запись акцизной или специальной марки;650;;0;;false;false;;;;;;;;;;;;
mark-code;integer;999999999;Код акцизной марки;Код акцизной марки;0;Внутренний код акцизной или специальной марки;660;;0;;false;false;;;;;;;;;;;;
alc-bottling-date;date;99/99/9999;Дата разлива;Дата разлива;;Дата разлива алкогольной продукции;670;;0;;false;false;;;;;;;;;;;;
alc-ref-ab-path;character;X(255);Справки А,Б;Справки А,Б;;Путь к файлу справок А,Б для алкогольной продукции;680;;0;;false;false;;;;;;;;;;1251;RUSSIAN_I;
alc-quality-certif-path;character;X(255);Удостоверение качества;Удостоверение качества;;Путь к файлу удостоверения качества для алкогольной продукции;690;;0;;false;false;;;;;;;;;;1251;RUSSIAN_I;
alc-certif-path;character;X(255);Сертификат соответствия;Сертификат соответствия;;Путь к файлу сертификата соответствия для алкогольной продукции;700;;0;;false;false;;;;;;;;;;1251;RUSSIAN_I;
alc-imp-code;integer;99999;Код импортера;;0;Код импортера;710;;0;;true;false;;;;;;;;;;;;
alc-imp-type;character;X(3);Тип импортера;Тип;;Тип импортера;720;;0;;true;false;;;;;;;;;;1251;RUSSIAN_I;
hold-date;date;99/99/99;;;;Дата создания МФ или МО родительского документа;730;;0;;false;false;;;;;;;;;;;;
dop;character;x(8);;;;;740;;0;;false;false;;;;;;;;;;1251;RUSSIAN_I;
price-prod;decimal;>>,>>9.99;Цена производителя;Цена производителя;0;$Цена производителя`Price(prod)`Pret ();750;10;0;;false;false;;;;;;;;;;;;
prt-code;integer;>>>>>>9;Признак;Признак;0;Код узла дерева признаков.`Nomenclature number`N nomenclator   ;751;;0;;true;false;;;;;;;;;;;;
defect;logical;yes/no;;;no;;761;;0;;false;false;;;;;;;;;;;;
price-prod-vat;decimal;->>,>>9.99;Цена производителя;Цена производителя;0;Цена производителя с НДС;771;2;0;;false;false;;;;;;;;;;;;
  */

    do : /* 28/IV-2018 перенести создание партий tt-parts из import-hed() сюда */
    end .

  end . /* end_of for_each_tt-parts */
// output stream f-tgds close .
  
if local-trace-on then do:
 define variable dsXmlFileName as character no-undo .
 dsXmlFileName = substitute("&1/&2.xml", ibs.th.gbl.gbl-inipar:logDir, "temp_parts").
 temp-table temp_parts:WRITE-XML ( "FILE", dsXmlFileName, true, "UTF-8").
end .
&undefine my-message
end procedure . /* create_temp_parts */


procedure import-hed :
define variable v-qnty-fact as decimal   no-undo .
define variable v-qnty-cli  as decimal   no-undo .
define variable v-num       as integer   no-undo .

define variable dsXmlFileName as character no-undo .
define variable dsLineCount   as integer no-undo .

// Message "Обработка файла" p-in-file view-as alert-box .
do on error undo, return error substitute("ошибка &1 &2", error-status:get-message(1) , return-value) :
  assign
  v-qnty-fact = 0
  v-qnty-cli  = 0
  dsLineCount = 0
  .
  &scop my-message substitute("Подготовка партий..."  )
  {&display-message}.

  for each temp_parts break
   by temp_parts.supp-type
   by temp_parts.supp-code
   by temp_parts.host-code
   by temp_parts.contract-code
   by temp_parts.VAT-type 
   by temp_parts.VAT-PC
   by temp_parts.prod-type
   by temp_parts.prod-code
   by temp_parts.artic
   by temp_parts.price-rubl
/* 21/V-2018 - с разной ценой ложится в разные накладные;
               с разными номерами партий ложится в одну накладную.
   by temp_parts.part-code*/
  :
    dsLineCount = dsLineCount + 1 .  
    do : /* 16/IV-2018 перенос создания партий из create-nakl() */
    create tt-parts.
    assign
      tt-parts.prod-type      = temp_parts.new_prod-type
      tt-parts.prod-code      = temp_parts.new_prod-code
      tt-parts.artic          = temp_parts.new_artic
      
      tt-parts.obj-type       = new_obj-type
      tt-parts.obj-code       = new_obj-code
      tt-parts.host-code      = new_host-code
      tt-parts.supp-type      = temp_parts.new-cli-type
      tt-parts.supp-code      = temp_parts.new-cli-code

      tt-parts.price-base     = temp_parts.price-rubl
      tt-parts.price-rubl     = temp_parts.price-rubl
      tt-parts.price-cli      = temp_parts.price-rubl
      tt-parts.cli-base-rate  = 1

      tt-parts.qnty           = temp_parts.fact-qnty
      tt-parts.fact-qnty      = temp_parts.fact-qnty
      tt-parts.cli-qnty       = temp_parts.fact-qnty
    
      tt-parts.VAT-pc         = temp_parts.vat-pc
      tt-parts.VAT-type       = temp_parts.vat-type
      tt-parts.SLT-pc         = 0
      tt-parts.SLT-type       = {&without-slt}
      tt-parts.road-tax-base  = 0
      tt-parts.road-tax-rubl  = 0
      tt-parts.transport-base = 0
      tt-parts.transport-rubl = 0
      tt-parts.other-base     = 0
      tt-parts.other-rubl     = 0
    
      tt-parts.PS             = ""
    
      tt-parts.fact-date      = ? // источник заполнения new_trn-doc.fact-date отсутствует 
      tt-parts.fact-num       = 0
      // tt-parts.pay-code заполняется непосредственно в tt-trn-doc
      tt-parts.rsrv-free      = ?
      tt-parts.pl-code        = 0
      tt-parts.exch-code      = 0
      tt-parts.is-supp        = yes
      tt-parts.last-date      = ?
      tt-parts.purch-code     = ? // источник заполнения new_trn-doc.purch-code отсутствует
      tt-parts.contract-code  = temp_parts.contract-code
    
      /* внутри create-nakl() выполнится привязка партий к сознанной по ним накладной */
      tt-parts.doc-type       = {&income}
      tt-parts.part-code      = temp_parts.part-code
      tt-parts.in-code        = temp_parts.in-code // в исходной версии - new_trn-doc.doc-code
      tt-parts.out-code       = "" // new_trn-doc.doc-code
      tt-parts.cst-code       = ""
      tt-parts.status_        = no
    .
    end .
    
    v-qnty-fact = v-qnty-fact + temp_parts.fact-qnty  .
    v-qnty-cli  = v-qnty-cli  + temp_parts.cli-qnty  . // - не заполняется

    if last-of ( temp_parts.price-rubl ) then do:
      /* 28/IV-2018 - добавить вместе с объединением партий с разной ценой в одну накладную
      if temp_parts.price-rubl <= 0  or temp_parts.price-rubl = ? then do:
        &scop my-message substitute("Цена &2   = &1 Пропускаю " , temp_parts.price-rubl  , temp_parts.artic )
        {&display-message}.
        next.
      end.
      if v-qnty-fact <= 0 then do:
        &scop my-message substitute("Количество &2   = &1 Пропускаю " , v-qnty-fact  , temp_parts.artic )
        {&display-message}.
        next.
      end.
      */
      create temp-line .
      assign
      temp-line.supp-type     = temp_parts.supp-type
      temp-line.supp-code     = temp_parts.supp-code
      temp-line.host-code     = temp_parts.host-code
      temp-line.contract-code = temp_parts.contract-code
      temp-line.vat-type      = temp_parts.vat-type
      temp-line.vat-pc        = temp_parts.vat-pc
      temp-line.prod-type     = temp_parts.prod-type
      temp-line.prod-code     = temp_parts.prod-code
      temp-line.artic         = temp_parts.artic
      temp-line.price-rubl    = temp_parts.price-rubl
// 21/V-2018 temp-line.part-code     = temp_parts.part-code
//  field num           as integer
      temp-line.fact-qnty     = v-qnty-fact
      temp-line.cli-qnty      = v-qnty-cli
      temp-line.new-cli-type  = temp_parts.new-cli-type
      temp-line.new-cli-code  = temp_parts.new-cli-code
      v-qnty-fact = 0
      v-qnty-cli  = 0
      .
    end.
if local-trace-on then do:
 dsXmlFileName = substitute("&1/&2-&3.xml", ibs.th.gbl.gbl-inipar:logDir, "tt_parts", string(dsLineCount, "9999999")).
 temp-table tt-parts:WRITE-XML ( "FILE", dsXmlFileName, true, "UTF-8").
end.
  end. /* for each temp_parts break*/

  /* связка полей temp-line.prod-type + prod-code + artic меняется на temp-line.num;
     поля temp_parts.price-rubl и temp_parts.part-code из признаков разделения по накладным исключены */
  for each temp-line  break
  by temp-line.supp-type
  by temp-line.supp-code
  by temp-line.host-code
  by temp-line.contract-code
  by temp-line.vat-type
  by temp-line.vat-pc
  by temp-line.prod-type
  by temp-line.prod-code
  by temp-line.artic
  :
    if first-of (temp-line.artic) then do:
      v-num = 0 .
    end.
    v-num = v-num + 1 .
    temp-line.num = v-num .
  end.
if local-trace-on then do:
 dsXmlFileName = substitute("&1/&2.xml", ibs.th.gbl.gbl-inipar:logDir, "temp_line").
 temp-table temp-line:WRITE-XML ( "FILE", dsXmlFileName, true, "UTF-8").
end.


  for each temp-line break
  by temp-line.supp-type
  by temp-line.supp-code
  by temp-line.host-code
  by temp-line.contract-code
  by temp-line.vat-type
  by temp-line.vat-pc
  by temp-line.num
  :
    if first-of (temp-line.num) then do:
      empty temp-table tt-trn-doc .
      empty temp-table tt2-doc-line .
      empty temp-table tt-doc-line .
      empty temp-table tt-gds-dtl .
/*      empty temp-table tt-parts .*/
      for each lib-trn_ret-doc :
        delete lib-trn_ret-doc.
      end.
      for each lib-trn_ret-line :
        delete lib-trn_ret-line      .
      end.
      for each lib-trn_ret-line-attr :
        delete lib-trn_ret-line.
      end.
      for each lib-trn_ret-dtl :
        delete lib-trn_ret-dtl.
      end.
      for each lib-trn_ret-parts :
        delete lib-trn_ret-parts .
      end.
      run create-nakl in this-procedure  ( temp-line.num, temp-line.new-cli-type, temp-line.new-cli-code ) .
    end.
  end.

end. /*doe*/
end procedure. /* import-contr */

/* 19/IV-2018 - перекодировку через внешние классификаторы не используем:
                внешние классификаторы задаются в ГБД, а перекодировка уникальна для УБД
procedure uni-k :
define input  parameter p-uniq-key-rec as character no-undo .
define input  parameter p-table as character no-undo .
define output parameter p-obj-type as character no-undo .
define output parameter p-obj-code as integer   no-undo .
define output parameter p-gds-code as integer   no-undo .
do
on error undo, return error substitute("ошибка &1 &2" , error-status :get-message(1) , return-value )
:
  case p-table :
    when {&table_clients} then do:
      if entry(1, p-uniq-key-rec, {&delim-key}) = {&table_clients} then do:
        assign
        p-obj-type = entry(2, p-uniq-key-rec, {&delim-key})
        p-obj-code = integer(entry(3, p-uniq-key-rec, {&delim-key}))
        p-gds-code = ?
        .
      end.
    end.
    when {&table_goods} then do:
      if entry(1, p-uniq-key-rec, {&delim-key}) = {&table_goods} then do:
        assign
        p-obj-type = ?
        p-obj-code = ?
        p-gds-code = integer(entry(2, p-uniq-key-rec, {&delim-key}))
        .
      end.
    end.
  end case.
end. /*doe*/
end procedure. /* uni-k */
*/

procedure create-nakl :
/* temp_parts и temp-line спозиционированны в вызывающей процедуре */
define input parameter p-num        as integer no-undo .
define input parameter new_cli-type as character no-undo .
define input parameter new_cli-code as integer no-undo . 
define variable n-d as character no-undo .
define variable v-ext-doc-type as character no-undo .
define buffer buf_goods for ub.goods .

do on error undo, return error return-value :
  run doc-code in this-procedure
    (input  "main":u,
     input  new_obj-type,
     input  new_obj-code,
     input  ?,
     output n-d ) no-error.
  if error-status:error then do:
    &scop my-message substitute("Ошибка при генерации номера документа &1 &2: &3 | &4" ,new_obj-type, new_obj-code, error-status:get-message(1), return-value )
    {&display-message}.
    undo, throw new Progress.Lang.AppError({&my-message}) .
  end.
  &scop my-message substitute("Создание ПН № &1 объект &2&3 контраг &4&5 &6" , n-d  , new_obj-type , new_obj-code ,  new_cli-type ,  new_cli-code , temp-line.contract-code )
  {&display-message}.

  assign
    v-ext-doc-type = {&TDEDT_Pri_Vnesh}
  .
    
  find first temp_parts where
             temp_parts.artic         = temp-line.artic     and
             temp_parts.prod-type     = temp-line.prod-type and
             temp_parts.prod-code     = temp-line.prod-code and
             temp_parts.supp-code     = temp-line.supp-code and
             temp_parts.supp-type     = temp-line.supp-type and
             temp_parts.host-code     = temp-line.host-code and
             temp_parts.vat-type      = temp-line.vat-type  and
             temp_parts.vat-pc        = temp-line.vat-pc    and
             temp_parts.contract-code = temp-line.contract-code  and
/*             temp_parts.part-code     = temp-line.part-code  and*/
             temp_parts.price-rubl    = temp-line.price-rubl no-error .
  if not available temp_parts then do:
    message "Parts not found" skip
 "artic:" temp-line.artic skip
 "prod-type:" temp-line.prod-type skip
 "prod-code:" temp-line.prod-code skip
 "supp-code:" temp-line.supp-code skip
 "supp-type:" temp-line.supp-type skip
 "host-code:" temp-line.host-code skip
 "vat-type:" temp-line.vat-type skip
 "vat-pc:" temp-line.vat-pc skip
 "contract-code:" temp-line.contract-code skip
 "part-code:" temp-line.part-code skip
 "price-rubl:" temp-line.price-rubl skip
    view-as alert-box.
    return. 
  end .

  
  do : /* create_tt-trn-doc */
  create  tt-trn-doc.
  buffer-copy temp_parts to tt-trn-doc
  assign
    tt-trn-doc.status_       = "temp"
    tt-trn-doc.doc-code      = n-d
    tt-trn-doc.doc-date      = to-day
    tt-trn-doc.cli-type      = new_cli-type
    tt-trn-doc.cli-code      = new_cli-code
    tt-trn-doc.obj-type      = new_obj-type
    tt-trn-doc.obj-code      = new_obj-code
    tt-trn-doc.host-code     = new_host-code
    tt-trn-doc.contract-code = temp-line.contract-code
    tt-trn-doc.doc-type      = {&income}
    tt-trn-doc.internal      = false
    tt-trn-doc.cr-db-num     = v-cntxt-db-num
    tt-trn-doc.office        = false
    tt-trn-doc.fact-num      = 0
    tt-trn-doc.PS            = "Перенос остатков"
    tt-trn-doc.creid         = v-cntxt-userid
    tt-trn-doc.flag_         = false
    tt-trn-doc.ext-doc-type  = v-ext-doc-type
    tt-trn-doc.discnt-type   = ""
    tt-trn-doc.ret-supp      = false
    tt-trn-doc.pay-code      = v-cntxp-in-pay
    tt-trn-doc.purch-code    = new_purch-code
    tt-trn-doc.SLT-type      = {&without-slt} // ранее это значение присвоилось во все tt-parts.SLT-type, но не в temp_parts
  .
  if tt-trn-doc.exch-code = ? then tt-trn-doc.exch-code = 0 .
  
  { gbl/baserate.i
    new_host-code
    temp_parts.fact-date
    tt-trn-doc.base-rate
    tt-trn-doc.base-scale
    no-error  }
  if tt-trn-doc.base-rate  = ? or tt-trn-doc.base-rate  = 0 then tt-trn-doc.base-rate  = 1 .
  if tt-trn-doc.base-scale = ? or tt-trn-doc.base-scale = 0 then tt-trn-doc.base-scale = 1 .

  if tt-trn-doc.exch-rate  = ? or tt-trn-doc.exch-rate  = 0 then tt-trn-doc.exch-rate  = 1 .
  if tt-trn-doc.exch-scale = ? or tt-trn-doc.exch-scale = 0 then tt-trn-doc.exch-scale = 1 .
  
  { str/crtrndoc.i
      tt-trn-doc.acc-date
      tt-trn-doc.bge-date
      tt-trn-doc.base-rate
      tt-trn-doc.base-scale
      tt-trn-doc.cli-code
      tt-trn-doc.cli-type
      tt-trn-doc.cli-name
      tt-trn-doc.cr-db-num
      tt-trn-doc.creid
      tt-trn-doc.discnt-type
      tt-trn-doc.doc-code
      tt-trn-doc.doc-date
      tt-trn-doc.doc-type
      tt-trn-doc.flag_
      tt-trn-doc.host-code
      tt-trn-doc.internal
      tt-trn-doc.obj-code
      tt-trn-doc.obj-type
      tt-trn-doc.office
      tt-trn-doc.pay-code
      tt-trn-doc.ps
      tt-trn-doc.ret-supp
      tt-trn-doc.slt-type
      tt-trn-doc.status_
      tt-trn-doc.vat-type
      tt-trn-doc.ext-doc-type
      tt-trn-doc.purch-code
      no-error }
  if error-status :error then do:
    &scop my-message substitute("Ошибка при генерации  документа1 &1 &2" , return-value , error-status :get-message(1) )
    {&display-message}.
    return error return-value .
  end.
  end . /* end_of create_tt-trn-doc */
  
  find first new_trn-doc where new_trn-doc.doc-code = n-d  exclusive-lock no-error .
  if error-status :error then do:
    &scop my-message substitute("Ошибка при генерации  документа2 &1 &2" , return-value , error-status :get-message(1) )
    {&display-message}.
    return error return-value .
  end.

  assign
   new_trn-doc.contract-code = temp-line.contract-code /* уже было присвоено при создании tt-trn-doc */
   new_trn-doc.exch-rate  = tt-trn-doc.exch-rate
   new_trn-doc.exch-scale = tt-trn-doc.exch-scale
   new_trn-doc.exch-date  = to-day
   new_trn-doc.exch-code  = tt-trn-doc.exch-code
   new_trn-doc.status_    = {&wayb}
   new_trn-doc.hold-doc-code-child   = "no-hold"
   new_trn-doc.hold-doc-code-parent  = "no-hold"
   new_trn-doc.print-rubl = v-print-rubl
  .
  
 define variable dsXmlFileName1 as character no-undo .
 define variable dsXmlFileName2 as character no-undo .
 define variable dsXmlFileName3 as character no-undo .
// dsXmlFileName1 = substitute("&1/&2.xml", ibs.th.gbl.gbl-inipar:logDir, "tt-doc-line0").
// dsXmlFileName2 = substitute("&1/&2.xml", ibs.th.gbl.gbl-inipar:logDir, "tt2-doc-line0").
  for each    new_line where
              new_line.supp-type      = temp_parts.supp-type     and
              new_line.supp-code      = temp_parts.supp-code     and
              new_line.host-code      = temp_parts.host-code     and
              new_line.vat-type       = temp_parts.vat-type      and
              new_line.vat-pc         = temp_parts.vat-pc        and
              new_line.contract-code  = temp_parts.contract-code and
              new_line.num            = p-num :
    if new_line.price-rubl <= 0  or new_line.price-rubl = ? then do:
      &scop my-message substitute("Цена &2   = &1 Пропускаю " , new_line.price-rubl  , new_line.artic )
      {&display-message}.
      next.
    end.
    if new_line.fact-qnty <= 0 then do:
      &scop my-message substitute("Количество &2   = &1 Пропускаю " , new_line.fact-qnty  , new_line.artic )
      {&display-message}.
      next.
    end.

  for each buf2_temp_parts no-lock where
        buf2_temp_parts.host-code      = temp_parts.host-code and
        buf2_temp_parts.price-rubl <> ? and
        buf2_temp_parts.price-rubl <> 0 and
        buf2_temp_parts.vat-type       = temp_parts.vat-type and
        buf2_temp_parts.contract-code  = temp_parts.contract-code and
        buf2_temp_parts.supp-type      = temp_parts.supp-type and
        buf2_temp_parts.supp-code      = temp_parts.supp-code and
        buf2_temp_parts.vat-pc         = temp_parts.vat-pc    and
        buf2_temp_parts.artic          = new_line.artic       and
        buf2_temp_parts.prod-type      = new_line.prod-type   and
        buf2_temp_parts.prod-code      = new_line.prod-code   and
/*        buf2_temp_parts.part-code      = new_line.part-code   and*/
        buf2_temp_parts.price-rubl     = new_line.price-rubl
  :
    /*
    if can-find (first temp-2exists where
        temp-2exists.artic     = buf2_temp_parts.artic
    and temp-2exists.prod-type = buf2_temp_parts.prod-type
    and temp-2exists.prod-code = buf2_temp_parts.prod-code
    and temp-2exists.doc-code = n-d) then next .
    */

    find first tt-doc-line exclusive-lock where
              tt-doc-line.doc-code       = n-d and
              tt-doc-line.artic          = buf2_temp_parts.new_artic   and
              tt-doc-line.prod-type      = buf2_temp_parts.new_prod-type and
              tt-doc-line.prod-code      = buf2_temp_parts.new_prod-code no-error .
    if not available tt-doc-line then do:
      find first buf_goods no-lock
           where buf_goods.artic     = buf2_temp_parts.new_artic
             and buf_goods.prod-type = buf2_temp_parts.new_prod-type
             and buf_goods.prod-code = buf2_temp_parts.new_prod-code no-error .
      if not available buf_goods then next .
      create  tt-doc-line.
      assign
      tt-doc-line.doc-code       = n-d
      tt-doc-line.obj-type       = new_obj-type
      tt-doc-line.obj-code       = new_obj-code
      tt-doc-line.line-num       = next-value (s-line-num, {&db-name_schema})
      tt-doc-line.artic          = buf2_temp_parts.new_artic
      tt-doc-line.prod-type      = buf2_temp_parts.new_prod-type
      tt-doc-line.prod-code      = buf2_temp_parts.new_prod-code
      tt-doc-line.prt-root       = buf_goods.prt-root
      tt-doc-line.unit-cli       = buf_goods.unit-base
      tt-doc-line.slt-pc         = buf2_temp_parts.slt-pc
      tt-doc-line.vat-pc         = buf2_temp_parts.vat-pc
      tt-doc-line.ext-doc-type   = v-ext-doc-type
      tt-doc-line.price-base     = buf2_temp_parts.price-rubl
      tt-doc-line.price-cli      = buf2_temp_parts.price-rubl
      tt-doc-line.price-rubl     = buf2_temp_parts.price-rubl
      tt-doc-line.cli-base-rate  = 1
      tt-doc-line.doc-density    = 1 / tt-doc-line.cli-base-rate
      tt-doc-line.fact-density   = 1 / tt-doc-line.cli-base-rate
      tt-doc-line.status_        = "temp"
      tt-doc-line.cli-qnty       = 0
      tt-doc-line.doc-qnty       = 0
      tt-doc-line.fact-qnty      = 0
      .
      create temp-2exists.
      assign
      temp-2exists.artic = buf2_temp_parts.artic
      temp-2exists.prod-type = buf2_temp_parts.prod-type
      temp-2exists.prod-code = buf2_temp_parts.prod-code
      temp-2exists.doc-code = n-d
      .
      release temp-2exists.
    end.
    assign
      tt-doc-line.cli-qnty  = tt-doc-line.cli-qnty  + buf2_temp_parts.fact-qnty
      tt-doc-line.doc-qnty  = tt-doc-line.doc-qnty  + buf2_temp_parts.fact-qnty
      tt-doc-line.fact-qnty = tt-doc-line.fact-qnty + buf2_temp_parts.fact-qnty
    .

    find first tt2-doc-line exclusive-lock where
              tt2-doc-line.doc-code       = n-d and
              tt2-doc-line.artic          = tt-doc-line.artic   and
              tt2-doc-line.prod-code      = tt-doc-line.prod-code and
              tt2-doc-line.prod-type      = tt-doc-line.prod-type  no-error .
    if not available tt2-doc-line then do:
      create  tt2-doc-line .
    end.
    BUFFER-COPY tt-doc-line to tt2-doc-line no-error.
    if error-status:error then do:
      message "buf-copy1 err" skip
      "doc-code:" n-d
      "artic:" tt-doc-line.artic
      view-as alert-box . 
    end .

    find first tt-gds-dtl exclusive-lock where
              tt-gds-dtl.doc-code   = n-d and
              tt-gds-dtl.prt-code   = tt-doc-line.prt-root and
              tt-gds-dtl.artic      = tt-doc-line.artic   and
              tt-gds-dtl.prod-code  = tt-doc-line.prod-code and
              tt-gds-dtl.prod-type  = tt-doc-line.prod-type  no-error .
    if not available tt-gds-dtl then do:
      create  tt-gds-dtl .
    end.
    buffer-copy  tt-doc-line  to  tt-gds-dtl
    assign
    tt-gds-dtl.prt-code  =  tt-doc-line.prt-root
    no-error .
    if error-status:error then do:
      message "buf-copy2 err" skip
      "doc-code:" n-d
      "artic:" tt-doc-line.artic
      view-as alert-box . 
    end .
    
// temp-table tt-doc-line:WRITE-XML ( "FILE", dsXmlFileName1, true, "UTF-8").
// temp-table tt2-doc-line:WRITE-XML ( "FILE", dsXmlFileName2, true, "UTF-8").
  end .
  end . /*for each    new_line where*/
if local-trace-on then do:
 dsXmlFileName1 = substitute("&1/&2-&3.xml", ibs.th.gbl.gbl-inipar:logDir, "tt-doc-line", n-d).
 temp-table tt-doc-line:WRITE-XML ( "FILE", dsXmlFileName1, true, "UTF-8").
 dsXmlFileName2 = substitute("&1/&2-&3.xml", ibs.th.gbl.gbl-inipar:logDir, "tt2-doc-line", n-d).
 temp-table tt2-doc-line:WRITE-XML ( "FILE", dsXmlFileName2, true, "UTF-8").
end .
  
  /* 16/IV-2018 создание партий перенесено до линий документов;
                здесь созданные партии привязываются к линиям */
  for each tt2-doc-line :
    // pi линий:  doc-code artic prod-type prod-code
    // pi партий: obj-type obj-code artic prod-type prod-code in-code out-code part-code prt-code
    for each tt-parts
       where tt-parts.obj-type  = tt2-doc-line.obj-type
         and tt-parts.obj-code  = tt2-doc-line.obj-code
         and tt-parts.artic     = tt2-doc-line.artic
         and tt-parts.prod-type = tt2-doc-line.prod-type
         and tt-parts.prod-code = tt2-doc-line.prod-code
         and tt-parts.supp-type     = new_trn-doc.cli-type
         and tt-parts.supp-code     = new_trn-doc.cli-code
         and tt-parts.contract-code = new_trn-doc.contract-code
         and tt-parts.vat-type      = new_trn-doc.vat-type
         and tt-parts.vat-pc        = tt2-doc-line.vat-pc
         and tt-parts.price-rubl    = tt2-doc-line.price-rubl
    :
/*
@NOTE  Цикл tt-parts, при наличии в tt-parts одной удовлетворяющей записи, выполняет два шага для каждой tt2-doc-line.
       Оба шага становятся на одну и ту же запись в tt-parts.
       Вероятнее всего здесь обновляется индексное поле tt-parts.out-code, что сбивает с толку for-each.
message "parts -> doc-line" skip string(rowid(tt-parts)) string(rowid(tt2-doc-line)) view-as alert-box.
*/      
      tt-parts.out-code = tt2-doc-line.doc-code no-error .
    end . // end_of for_each tt-parts
  end. /*  for each tt2-doc-line :*/
if local-trace-on then do:
 dsXmlFileName3 = substitute("&1/&2-&3.xml", ibs.th.gbl.gbl-inipar:logDir, "tt_parts-2", n-d).
 temp-table tt-parts:WRITE-XML ( "FILE", dsXmlFileName3, true, "UTF-8").
end .

  /* 26/IV-2018 внутри copy-in.i партии создаются по линиям документа tt2-doc-line;
                входная таблица tt-parts для создания партий не используется */
  { str/copy-in.i
    parParentProc
    recid(new_trn-doc)
    tt-trn-doc
    tt2-doc-line
    tt-doc-line-attr
    tt-gds-dtl
    tt-parts
    yes
    yes
    no
    yes
    this-procedure
    no-error }
  if error-status:error then do :
      &scop my-message substitute("Не удалось добавить товар в приходную накладную  (copy-in.i)! &1 &2" , return-value , error-status :get-message(1) )
      {&display-message}.
      return error return-value .
  end.
  v-ii = v-ii + 1.
  run gbl/calc-trn.p ( input parparentproc, input recid(new_trn-doc)) no-error.
  find first new_trn-doc where new_trn-doc.doc-code = n-d  exclusive-lock no-error .
  assign
  new_trn-doc.tot-cli = new_trn-doc.tot-calc
  .
  
  if p-is-close then do :
    run clos-trn2 in this-procedure (new_trn-doc.doc-code) no-error .
    find first new_trn-doc where new_trn-doc.doc-code = n-d  no-lock no-error .
    if new_trn-doc.status_ <> {&fact} then do:
    &scop my-message substitute("Не удалось закрыть на факт ПН &1 &2 &3" ,n-d , return-value , error-status :get-message(1) )
    {&display-message}.
    end.
  end .

end. /*doe*/
end procedure. /* create-nakl */


/* 19/IV-2018 не используется
procedure find-doc :
define input  parameter p-obj-type as character no-undo .
define input  parameter p-obj-code as integer   no-undo .
define output parameter p-err as logical   no-undo .
define variable v-err2 as logical   no-undo .
do
on error undo, return error return-value
:
define buffer buf_trn-doc for ub.trn-doc  .
define buffer buf_parts   for ub.parts  .
define buffer buf_goods   for ub.goods  .

define variable v-err as integer   no-undo .
p-err = false .
  for each buf_trn-doc no-lock where
           buf_trn-doc.obj-type = p-obj-type and
           buf_trn-doc.obj-code = p-obj-code and
           buf_trn-doc.status_ <> {&fact}
  :
    &scop my-message substitute("Не закрыт документ &1  &2 " , buf_trn-doc.doc-code , buf_trn-doc.doc-type )
    {&display-message}.
    p-err = true  .
  end.
  for each buf_parts no-lock where
          buf_parts.obj-type = p-obj-type and
          buf_parts.obj-code = p-obj-code and
          buf_parts.out-code = {&free-code} and
          buf_parts.fact-qnty > 0  and
          buf_parts.contract-code > 0
   :
      if not can-find( first old_contract-specif no-lock where
                        old_contract-specif.contract-num = buf_parts.contract-code and
                        old_contract-specif.host-code    = buf_parts.host-code ) then next.

      find first buf_goods no-lock where
                buf_goods.artic     = buf_parts.artic and
                buf_goods.prod-type = buf_parts.prod-type and
                buf_goods.prod-code = buf_parts.prod-code
                  no-error .
      find first  old_contract-specif no-lock where
                  old_contract-specif.contract-num = buf_parts.contract-code and
                  old_contract-specif.host-code    = buf_parts.host-code and
                  old_contract-specif.gds-code     = buf_goods.gds-code  no-error .
      if not available old_contract-specif then do:
        &scop my-message substitute("Будет мешать закрытию ПН : Товара &1 &2 &3 &4 нет в текущей спецификации Договора Внутр.№ &5" , buf_goods.prod-type, buf_goods.prod-code ,buf_goods.artic,buf_goods.gds-name , buf_parts.contract-code )
        {&display-message}.
      end.
      else do:
       { str/ckcntspc.i
        buf_parts.host-code
        buf_parts.contract-code
        buf_goods.gds-code
        true
        buf_parts.VAT-type
        buf_parts.VAT-pc
        no-error
       }
       if error-status :error then do:
        &scop my-message substitute("Товара &1 &2 &3 &4 нет в текущей спецификации Договора Внутр.№ &5" , buf_goods.prod-type, buf_goods.prod-code ,buf_goods.artic,buf_goods.gds-name , old_contract-specif.contract-num )
        {&display-message}.
       end.
     end.
   end. /*  for each buf_parts no-lock where*/

   for each buf_parts no-lock where
            buf_parts.obj-type = p-obj-type and
            buf_parts.obj-code = p-obj-code and
            buf_parts.out-code = {&free-code} and
            buf_parts.fact-qnty < 0
   :
      find first buf_goods no-lock where
                buf_goods.artic     = buf_parts.artic and
                buf_goods.prod-type = buf_parts.prod-type and
                buf_goods.prod-code = buf_parts.prod-code and
                buf_goods.stts = 0 no-error .
    if available buf_goods then do:
      /*
      put stream str unformatted
      substitute("&5&1&5 &2 &5&3&5 &4" , buf_goods.prod-type, buf_goods.prod-code ,buf_goods.artic, 0 , {&double-quote} )
      skip.
      */
      p-err = true  .
      v-err2 = true  .
    end.
  end. /*for each buf_parts no-lock where*/

  if v-err2 = true  then do:
    &scop my-message substitute("Есть отрицательные партии в свободной зоне ! Сделайте инвентаризацию по товарам из списка negparts.gds" )
    {&display-message}.
  end.

end. /*doe*/
end procedure. /* find-doc */
*/

procedure clos-trn2 :
define input parameter p-trn-code as character no-undo .
do
on error undo, return error return-value
:
define buffer buf_s-trn-doc for ub.trn-doc.
define variable varmode            as   character           no-undo.
define variable varstatus          like ub.trn-doc.status_  no-undo.
define variable varflag            like ub.trn-doc.flag     no-undo.
define variable varcopystatus      like ub.trn-doc.status_  no-undo.
define variable varcopyflag        like ub.trn-doc.flag     no-undo.
define variable varcheck-return as logical no-undo .
define variable varchg-inv as logical no-undo .
define variable v-cntxt-cash-pay as integer   no-undo .
define variable v-cntxt-in-ov as logical   no-undo .
define variable v-cntxt-base-code as integer   no-undo .
define variable v-cntxt-rsrv-time  as integer   no-undo .
define variable v-cntxt-load-time  as integer   no-undo .
define variable v-cntxt-holidays  as character no-undo .
define variable v-db-num as integer   no-undo .
  { gbl/objdbnum.i
     v-cntxt-obj-type
     v-cntxt-obj-code
     v-db-num
     }

  // ошибка при чтении PropGet in gbl-var:g#db-num
  if v-db-num <> gbl-var:g#db-num then return .

  &scop my-message substitute(" Закрытие документа &1 на ФАКТ" , p-trn-code )
  {&display-message}.

  run str/trn-stat.p (
    input  parparentproc  ,
    input  this-procedure ,
    input  {&close-fact} ,
    input  p-trn-code,
    input  false /* проверка старого возврата */ ,
    input  v-cntxt-db-num,
    input  false /* проверка переоценки */,
    input  v-cntxt-rsrv-time,
    input  v-cntxt-load-time,
    input  v-cntxt-holidays,
    input  false ,
    output varchg-inv ,
    output table gds-list1 )
    no-error.
    if error-status:error then do :
        &scop my-message substitute(" Ошибка при закрытии документа &3 &1 &2" , error-status :get-message(1)  , return-value , p-trn-code )
        {&display-message}.
    end.
end. /*doe*/
end procedure. /* clos-trn2 */
