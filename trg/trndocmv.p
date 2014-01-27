/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Создание документов внутреннего перемещения.

Автор: Чернова Светлана Александровна
Дата создания: 05/08/07
Author: Svetlana Chernova
Creation date: 05/08/07

Автор1: Перваков Михаил Сергеевич
Дата создания: 11/11/99


Создает документ внутреннего прихода по документу внутреннего расхода.
  ПРИ <<<--- РАС

Создает документ внутреннего возврата по документу внутреннего прихода.
  ВОЗВРАТ <<<--- ПРИ

Общее правило для таблиц doc-line, gds-dtl, parts:
  fact-qnty должно быть больше нуля.
  fact-qnty должно быть меньше или равно doc-qnty.

При перемещении с объекта, где признаки выключены
на объект, где признаки включены
  информация на новом объекте записывается в первый терминальный признак

При перемещении с объекте, где признаки включены
на объект, где признаки выключены
  информация на новом объекте записывается в корневой признак.
  Если признаков было несколько, то их продажная цена усредняется.


Пользователь имеет возможность проставить любые количества
для любых признаков gds-dtl.fact-qnty,
а значит gds-dtl.fact-qnty может быть больше gds-dtl.doc-qnty.

*/

define input parameter v-doc-code like ub.trn-doc.doc-code no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Создание документов внутреннего перемещения":U .

{ cmp/vssrevis.i }
{ cmp/trg-def.i  }
{ str/lib-trn.i  }
{ str/doc-code.i }
{ str/trdcalib.i }
{ cmp/library.i  }

define variable same_db as logical   no-undo initial no . /* при внутренних перемещениях в одной и той же УБД */
define variable v-today as date      no-undo.

/* включены или выключены признаки на объекте, куда происходит перемещение */
/* yes - признаки включены */
/* no  - признаки выключены */
define variable cli_doc-prt as logical   no-undo .

/* включены или выключены признаки на объекте, с которого происходит перемещение */
/* yes - признаки включены */
/* no  - признаки выключены */
define variable obj_doc-prt as logical   no-undo .

define variable n_str       as integer   no-undo .

define variable v-base-code         like ub.currency.curr-code no-undo .
define variable v-doc-line-chg-qnty like ub.doc-line.doc-qnty  no-undo .
define variable l-goods-twounit     as logical   no-undo .
define variable var-ok-assort-pol   as logical   no-undo .
define variable var-mess-assort-pol as character no-undo .
define variable v-doc-pl-rowid      as rowid     no-undo .
define variable v-event-code as character no-undo .
define variable is-petrolium               as logical   no-undo .
define variable is-pieces                  as logical   no-undo .

define buffer buf_trn-doc       for ub.trn-doc .
define buffer buf_doc-line      for ub.doc-line .
define buffer buf_gds-dtl       for ub.gds-dtl .
define buffer buf_parts         for ub.parts .
define buffer buf_doc-pl        for ub.doc-pl .
define buffer buf-first_trn-doc for ub.trn-doc .
define buffer buf-first_parts   for ub.parts .
define buffer doc-obj           for ub.clients .
define buffer buf_cliobj        for ub.clients .

do
for buf_trn-doc, buf_doc-line, buf_gds-dtl, buf_parts, buf_doc-pl, doc-obj, buf_cliobj
transaction
on error undo, return error return-value
:

  find first ub.trn-doc
    where ub.trn-doc.doc-code = v-doc-code
    no-error .
  if not available ub.trn-doc then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка задания входных параметров" skip
      "Не найден документ" skip
      "Документ " v-doc-code
      view-as alert-box .
    undo, return error .
  end.

  define variable v-host-code like ub.trn-doc.host-code no-undo .

  /* определяем код фирмы для объекта */
  { gbl/hostcode.i
    ub.trn-doc.obj-type
    ub.trn-doc.obj-code
    v-host-code
    no-error
  }
  if error-status :error then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка при определении кода фирмы для объекта с которого происходит перемещение" skip
      "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
      "Объект" ub.trn-doc.obj-type ub.trn-doc.obj-code skip
      view-as alert-box error .
    undo, return error .
  end.

  /* определяем код базовой валюты для фирмы */
  { gbl/basecode.i
    v-host-code
    v-base-code
    no-error
  }
  if error-status :error then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка при определении кода базовой валюты для фирмы" skip
      "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
      "Объект" ub.trn-doc.obj-type ub.trn-doc.obj-code skip
      view-as alert-box error .
    undo, return error .
  end.

  /* определяем код фирмы для объекта на который происходит перемещение */
  define variable v-cli-host-code like ub.trn-doc.host-code no-undo .
  { gbl/hostcode.i
    ub.trn-doc.cli-type
    ub.trn-doc.cli-code
    v-cli-host-code
    no-error
  }
  if error-status :error then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка при определении кода фирмы для объекта на который происходит перемещение" skip
      "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
      "Объект" ub.trn-doc.cli-type ub.trn-doc.cli-code skip
      view-as alert-box error .
    undo, return error .
  end.

  if v-cli-host-code <> v-host-code then do:
    message
      vss-workfile vss-revision vss-description skip
      "Документ " v-doc-code skip
      "Фирма объекта откуда происходит перемещение" skip
      "не совпадает с фирмой, куда происходит перемещение" skip
      "v-host-code"     v-host-code     skip
      "v-cli-host-code" v-cli-host-code skip
      "Закрытие документа невозможно" skip
      view-as alert-box error .
    undo, return error .
  end.

  find ub.clients no-lock
    where ub.clients.obj-type = ub.trn-doc.cli-type
      and ub.clients.obj-code = ub.trn-doc.cli-code
    no-error .
  if not available ub.clients then do:
    message
      vss-workfile vss-revision vss-description skip
      "Неизвестный клиент" skip
      "Документ " v-doc-code skip
      "Объект" ub.trn-doc.obj-type ub.trn-doc.obj-code skip
      "Клиент" ub.trn-doc.cli-code ub.trn-doc.cli-type skip
      view-as alert-box .
    undo, return error .
  end.

  if  ub.trn-doc.cli-type <> {&stock}
  and ub.trn-doc.cli-type <> {&shop}
  then do:
    message
      vss-workfile vss-revision vss-description skip
      "Клиент документа внутреннего перемещения не является объектом"
      "Документ " v-doc-code skip
      "Объект" ub.trn-doc.obj-type ub.trn-doc.obj-code skip
      "Клиент" ub.trn-doc.cli-code ub.trn-doc.cli-type skip
      view-as alert-box error .
    undo, return error .
  end.

  find doc-obj no-lock
    where doc-obj.obj-type = ub.trn-doc.obj-type
      and doc-obj.obj-code = ub.trn-doc.obj-code
    no-error .
  if not available doc-obj then do:
    message
      vss-workfile vss-revision vss-description skip
      "Неизвестный объект" skip
      "Документ " v-doc-code skip
      "Объект" ub.trn-doc.obj-type ub.trn-doc.obj-code skip
      "Клиент" ub.trn-doc.cli-code ub.trn-doc.cli-type skip
      view-as alert-box .
    undo, return error .
  end.

  if  ub.trn-doc.obj-type <> {&stock}
  and ub.trn-doc.obj-type <> {&shop}
  then do:
    message
      vss-workfile vss-revision vss-description skip
      "Объект документа внутреннего перемещения не является объектом"
      "Документ " v-doc-code skip
      "Объект" ub.trn-doc.obj-type ub.trn-doc.obj-code skip
      "Клиент" ub.trn-doc.cli-code ub.trn-doc.cli-type skip
      view-as alert-box error .
    undo, return error .
  end.

  if doc-obj.db-num = clients.db-num
  and clients.db-num > 0 then do:
    assign
      same_db = yes
    .
  end.

  if  ub.trn-doc.status_  = {&fact}
  and lookup(ub.trn-doc.doc-type, {&expense_income}) > 0
  and ub.trn-doc.internal = yes
  and ub.trn-doc.discnt-type <> {&manufactured} then do:
    /* правильный документ */
  end.
  else do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка задания входных параметров" skip
      "В качестве параметра можно передавать только документы" skip
      "внутреннего прихода, внутреннего расход" skip
      "закрытые до статуса" {&fact} skip
      "Документ" ub.trn-doc.doc-code skip
      "Тип документа" ub.trn-doc.doc-type skip
      "Внутренний" ub.trn-doc.internal skip
      "discnt-type" ub.trn-doc.discnt-type skip
      "Статус" ub.trn-doc.status_ skip
      view-as alert-box error .
    undo, return error .
  end.



  if (g#db-num = 0 and same_db = no )
  or (g#db-num > 0 and same_db = yes)
  then do:
    /* необходимо создавать документ прихода/возврата */
  end.
  else do:
    /* не надо порождать документ */
    return.  /* --->>>--- */
  end.

  /* определяем, учитываются ли признаки на объекте */
  /* ОТКУДА происходит перемещение */
  { gbl/objat.i
    ub.trn-doc.obj-type
    ub.trn-doc.obj-code
    "'doc-prt=request':u"
    obj_doc-prt
    no-error
  }
  if error-status:error then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка при определении атрибута объекта" skip
      "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
      "Объект" ub.trn-doc.obj-type ub.trn-doc.obj-code skip
      'doc-prt=request':u skip
      error-status:get-message(1) skip
      return-value skip
      view-as alert-box error .
    undo, return error .
  end.

  /* определяем, учитываются ли признаки на объекте */
  /* КУДА происходит перемещение */
  { gbl/objat.i
    ub.trn-doc.cli-type
    ub.trn-doc.cli-code
    "'doc-prt=request':u"
    cli_doc-prt
    no-error
  }
  if error-status :error then do:
    message
      vss-workfile vss-revision vss-description skip
      "Ошибка при определении атрибута объекта" skip
      "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
      "Объект" ub.trn-doc.cli-type ub.trn-doc.cli-code skip
      "doc-prt=request" skip
      error-status :get-message(1) skip
      return-value skip
      view-as alert-box error .
    undo, return error .
  end.
  if ub.trn-doc.doc-type = {&expense}  then do:
    define variable vardoc-code as character no-undo .

    run doc-code in this-procedure
      (input  "pair",
      input  ub.trn-doc.obj-type,
      input  ub.trn-doc.obj-code,
      input  ub.trn-doc.doc-code,
      output vardoc-code  ) no-error.
    if error-status:error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка при генерации номера документа" skip
        return-value skip
        trim(error-status :get-message(1))
        trim(error-status :get-message(2))
        trim(error-status :get-message(3))
        trim(error-status :get-message(4))
        trim(error-status :get-message(5)) skip
        view-as alert-box error.
      undo, return error .
    end.
  end.
  else do:
    run doc-code in this-procedure
      (input  "trio",
      input  ub.trn-doc.obj-type,
      input  ub.trn-doc.obj-code,
      input  ub.trn-doc.doc-code,
      output vardoc-code) no-error.
    if error-status:error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка при генерации номера документа." skip
        return-value skip
        trim(error-status :get-message(1))
        trim(error-status :get-message(2))
        trim(error-status :get-message(3))
        trim(error-status :get-message(4))
        trim(error-status :get-message(5)) skip
        view-as alert-box error.
      undo, return error .
    end.
  end.
find first buf_cliobj no-lock
  where buf_cliobj.obj-type = ub.trn-doc.obj-type
    and buf_cliobj.obj-code = ub.trn-doc.obj-code
  .
{ gbl/curobjdt.i ub.trn-doc.obj-type ub.trn-doc.obj-code v-today }
{ str/crtrndoc.i
  ?
  ?
  ub.trn-doc.base-rate
  ub.trn-doc.base-scale
  ub.trn-doc.obj-code
  ub.trn-doc.obj-type
  buf_cliobj.obj-name
  ub.clients.db-num
  ub.trn-doc.creid
  ub.trn-doc.discnt-type
  vardoc-code
  v-today
  "(if ub.trn-doc.doc-type = {&expense} then {&income} else {&return})"
  false
  ub.trn-doc.host-code
  ub.trn-doc.internal
  ub.trn-doc.cli-code
  ub.trn-doc.cli-type
  ub.trn-doc.office
  ub.trn-doc.pay-code
  "''"
  no
  ?
  {&wayb}
  ?
  "(if ub.trn-doc.doc-type = {&expense} then {&TDEDT_Pri_Perem} else {&TDEDT_Vozvrat_Perem})"
  ?
  no-error
  }
  if error-status :error then do:
      message
      vss-workfile vss-revision vss-description skip
      "Ошибка при создании документа внутреннего перемещения" skip
      "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
      "Объект" ub.trn-doc.cli-type ub.trn-doc.cli-code skip
      error-status :get-message(1) skip
      return-value skip
      view-as alert-box error .
    undo, return error.
  end.
  find buf_trn-doc where buf_trn-doc.doc-code = vardoc-code.
  assign
    buf_trn-doc.exch-date     = ub.trn-doc.doc-date       /* курсы на дату РН */
    buf_trn-doc.exch-rate     = ub.trn-doc.base-rate      /* ! */
    buf_trn-doc.out-code      = ub.trn-doc.doc-code       /* ! */
    buf_trn-doc.ship-num      = ub.trn-doc.ship-num
    buf_trn-doc.ship-date     = ub.trn-doc.ship-date
    buf_trn-doc.ord-num       = ub.trn-doc.ord-num
    buf_trn-doc.exch-scale    = ub.trn-doc.base-scale     /* ! */
    buf_trn-doc.exch-code     = v-base-code               /* валюта клиента - базовая */
    buf_trn-doc.fact-num      = 0
    buf_trn-doc.fact-date     = ?
    buf_trn-doc.print-rubl    = ub.trn-doc.print-rubl
    buf_trn-doc.wrkr          = ?                         /* ! */
    buf_trn-doc.agnt          = ub.trn-doc.agnt           /* ! */
    buf_trn-doc.boss          = ub.trn-doc.boss           /* ! */
    buf_trn-doc.reason-code   = ub.trn-doc.reason-code
  .

  assign
    n_str = 0
  .

  /* копируем некоторые атрибуты документа */
  define variable v-attr-exist as logical   no-undo .
  define variable v-attr-value as character no-undo .
  define variable v-attr-type  as character no-undo .

  { str/tdat-xst.i
      ub.trn-doc.doc-code
      {&trdcattr-purchlimit}
      v-attr-exist
  }
  if v-attr-exist = true
  then do:
    { str/tdat-val.i
        ub.trn-doc.doc-code
        {&trdcattr-purchlimit}
        v-attr-value
        v-attr-type
    }
    { str/tdat-wrt.i
        buf_trn-doc.doc-code
        {&trdcattr-purchlimit}
        v-attr-value
    }
  end.

  { str/tdat-xst.i
      ub.trn-doc.doc-code
      {&trdcattr-purchcodelist}
      v-attr-exist
  }
  if v-attr-exist = true
  then do:
    { str/tdat-val.i
        ub.trn-doc.doc-code
        {&trdcattr-purchcodelist}
        v-attr-value
        v-attr-type
    }
    { str/tdat-wrt.i
        buf_trn-doc.doc-code
        {&trdcattr-purchcodelist}
        v-attr-value
    }
  end.
  for each ub.doc-line
    where ub.doc-line.doc-code = ub.trn-doc.doc-code use-index line-num
  on error undo, return error substitute("&1 (ub.doc-line). &3&2&4", vss-workfile, {&new-line}, error-status :get-message(1), return-value  )
  :
    find first ub.goods no-lock
      where ub.goods.artic     = ub.doc-line.artic
        and ub.goods.prod-type = ub.doc-line.prod-type
        and ub.goods.prod-code = ub.doc-line.prod-code
      .

    { gbl/gdsat.i
      ub.goods.artic
      ub.goods.prod-type
      ub.goods.prod-code
      "'twounit=request':u"
      l-goods-twounit
      no-error
    }
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка при определении атрибута товара" skip
        "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
        "Артикул" ub.goods.artic ub.goods.prod-type ub.goods.prod-code skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.

    { str/is-petrl.i
      ub.goods.artic
      ub.goods.prod-type
      ub.goods.prod-code
      is-petrolium
      is-pieces
      no-error
    }
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка при определении атрибута товара (petrolium)" skip
        "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
        "Артикул" ub.goods.artic ub.goods.prod-type ub.goods.prod-code skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo, return error .
    end.

    assign
      v-doc-line-chg-qnty = 0
    .

    if ub.doc-line.fact-qnty < 0 then do:
      message
        vss-workfile vss-revision vss-description skip
        "В документе внутреннего перемещения" skip
        "фактическое количество в линии не может быть отрицательным" skip
        "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
        "Артикул" ub.goods.artic ub.goods.prod-type ub.goods.prod-code skip
        "Фактическое количество" ub.doc-line.fact-qnty skip
        view-as alert-box error .
      undo, return error .
    end.

    if ub.doc-line.fact-qnty > ub.doc-line.doc-qnty then do:
      message
        vss-workfile vss-revision vss-description skip
        "В документе внутреннего перемещения" skip
        "фактическое количество в линии" skip
        "не может превышать количество по документу" skip
        "Документ внутреннего перемещения" ub.trn-doc.doc-code skip
        "Артикул" ub.goods.artic ub.goods.prod-type ub.goods.prod-code skip
        view-as alert-box error .
      undo, return error .
    end.

    if ub.trn-doc.doc-type = {&expense}
    and ub.doc-line.fact-qnty  <> 0
    then do:
      assign
        v-doc-line-chg-qnty = ub.doc-line.fact-qnty
      .
    end.

    if  ub.trn-doc.doc-type = {&income}
    and ub.doc-line.fact-qnty < ub.doc-line.doc-qnty then do:
      assign
        v-doc-line-chg-qnty = ub.doc-line.doc-qnty - ub.doc-line.fact-qnty
      .
    end.

    if v-doc-line-chg-qnty = 0 then do:
      next. /* --->>>--- */
    end.

    assign
      n_str = n_str + 1
    .
    create buf_doc-line.
    assign
      buf_doc-line.doc-code       = buf_trn-doc.doc-code
      buf_doc-line.obj-type       = buf_trn-doc.obj-type
      buf_doc-line.obj-code       = buf_trn-doc.obj-code
      buf_doc-line.artic          = ub.doc-line.artic
      buf_doc-line.prod-type      = ub.doc-line.prod-type
      buf_doc-line.prod-code      = ub.doc-line.prod-code

      buf_doc-line.fact-qnty      = v-doc-line-chg-qnty
      buf_doc-line.price-rubl     = ub.doc-line.price-rubl
      buf_doc-line.price-base     = ub.doc-line.price-base
      buf_doc-line.price-cli      = ub.doc-line.price-base
      buf_doc-line.SLT-pc         = ub.doc-line.SLT-pc
      buf_doc-line.VAT-pc         = ub.doc-line.VAT-pc
      buf_doc-line.cons-vat-pc    = ub.doc-line.cons-vat-pc
      buf_doc-line.road-tax       = ub.doc-line.road-tax
      buf_doc-line.excise         = ub.doc-line.excise
      buf_doc-line.transport-base = ub.doc-line.transport-base
      buf_doc-line.transport-rubl = ub.doc-line.transport-rubl
      buf_doc-line.other-base     = ub.doc-line.other-base
      buf_doc-line.other-rubl     = ub.doc-line.other-rubl
      buf_doc-line.unit-cli       = ( if ub.doc-line.fact-density > 0.00 and ub.doc-line.fact-density < 1.00
                                      then ub.goods.unit-cli
                                      else ub.goods.unit-base ) /* ! */
      buf_doc-line.doc-qnty       = v-doc-line-chg-qnty    /* ожидается расх. факт */
      buf_doc-line.prt-root       = ub.doc-line.prt-root
      buf_doc-line.prt-OK         = yes                    /* а то как же */
      buf_doc-line.fact-order     = 0                      /* еще не факт */
      buf_doc-line.cli-qnty       = v-doc-line-chg-qnty * ( if ub.doc-line.fact-density > 0.00 and ub.doc-line.fact-density < 1.00
                                                            then ub.doc-line.fact-density
                                                            else 1 ) /* ! */
      buf_doc-line.doc-density    = ub.doc-line.fact-density

      /* уже НЕ ВСЕГДА одинаковые едизмы */
      buf_doc-line.cli-base-rate  = ub.doc-line.cli-base-rate

      /* количество мест и вес брутто копируется из исходной накладной */
      buf_doc-line.num-place      = ub.doc-line.num-place * v-doc-line-chg-qnty / ub.doc-line.fact-qnty
      buf_doc-line.wt-brutto      = ub.doc-line.wt-brutto * v-doc-line-chg-qnty / ub.doc-line.fact-qnty
    .
    if buf_doc-line.cli-base-rate = ? then do: assign buf_doc-line.cli-base-rate = 1.00. end.
    if buf_doc-line.doc-density   = ? then do: assign buf_doc-line.doc-density   = 1.00. end.

    assign
      buf_doc-line.fact-density  = buf_doc-line.doc-density
    .

    define variable v-part-chg-qnty as decimal no-undo .

    define variable v-total-parts-cli-qnty as decimal   no-undo .

    assign
      v-total-parts-cli-qnty = 0
    .

    /* создаем партии */
    for each ub.parts
      where ub.parts.obj-type  = ub.doc-line.obj-type
        and ub.parts.obj-code  = ub.doc-line.obj-code
        and ub.parts.artic     = ub.doc-line.artic
        and ub.parts.prod-type = ub.doc-line.prod-type
        and ub.parts.prod-code = ub.doc-line.prod-code
        and ub.parts.out-code  = ub.doc-line.doc-code
    on error undo, return error
    :
      assign
        v-part-chg-qnty = 0
      .

      if ub.parts.fact-qnty < 0 then do:
        message
          vss-workfile vss-revision vss-description skip
          "В документе внутреннего перемещения" skip
          "фактическое количество в партии не может быть отрицательным" skip
          view-as alert-box error .
        undo, return error .
      end.

      if ub.parts.fact-qnty > ub.parts.qnty then do:
        message
          vss-workfile vss-revision vss-description skip
          "В документе внутреннего перемещения" skip
          "фактическое количество в партии" skip
          "не может превышать количество в партии по документу" skip
          view-as alert-box error .
        undo, return error .
      end.

      if l-goods-twounit = true then do:
        if ub.parts.fact-qnty <> ub.parts.qnty
        and ub.parts.fact-qnty <> 0
        then do:
          message
            vss-workfile vss-revision vss-description skip
            "В документе внутреннего перемещения фактическое количество в партии" skip
            "должно или равняться количеству по документу" skip
            "или быть равным нулю" skip
            view-as alert-box error .
          undo, return error .
        end.

        if ub.parts.cli-qnty <> 1
        then do:
          message
            vss-workfile vss-revision vss-description skip
            "В документе внутреннего перемещения количество в ед.изм. поставщика" skip
            "должно должно равняться единице" skip
            view-as alert-box error .
          undo, return error .
        end.
      end.


      if ub.trn-doc.doc-type = {&expense}
      and ub.parts.fact-qnty  <> 0
      then do:
        assign
          v-part-chg-qnty = ub.parts.fact-qnty
        .
      end.

      if  ub.trn-doc.doc-type = {&income}
      and ub.parts.fact-qnty < ub.parts.qnty then do:
        assign
          v-part-chg-qnty = ub.parts.qnty - ub.parts.fact-qnty
        .
      end.

      if v-part-chg-qnty = 0 then do:
        next. /* --->>>--- */
      end.


      create buf_parts .
      buffer-copy ub.parts to buf_parts
      assign
        buf_parts.out-code  = buf_trn-doc.doc-code
        buf_parts.obj-type  = buf_trn-doc.obj-type
        buf_parts.obj-code  = buf_trn-doc.obj-code
        buf_parts.status_   = no
        buf_parts.rsrv-free = ?
        buf_parts.pl-code   = 0

        buf_parts.qnty      = v-part-chg-qnty
        buf_parts.fact-qnty = buf_parts.qnty
        buf_parts.cli-qnty  = 0
      .

      if l-goods-twounit = true
        or ( is-petrolium = true
             and is-pieces = false
           )
      then do:
        assign
          buf_parts.cli-qnty = ub.parts.cli-qnty
        .
        assign
          v-total-parts-cli-qnty = buf_parts.cli-qnty
        .
      end.

      if buf_trn-doc.ext-doc-type = {&TDEDT_Vozvrat_Perem}
        and is-petrolium = true
        and is-pieces = false
      then do:
        if num-entries( buf_parts.part-code, {&part-split} ) > 1 then do:
          run trg/partjoin.p
            ( input buf_parts.obj-type
             ,input buf_parts.obj-code
             ,input buf_parts.artic
             ,input buf_parts.prod-type
             ,input buf_parts.prod-code
             ,input buf_parts.in-code
             ,input buf_parts.out-code
             ,input buf_parts.part-code
            ) no-error.
          if error-status :error then do:
            undo, return error substitute( "&1 (partjoin). Не удалось объединить партию с номером &2!&3&4&3&5", vss-workfile, buf_parts.part-code, {&new-line}, return-value, error-status :get-message ( error-status :num-messages ) ).
          end.
        end.
      end.
    end. /* for each parts ...  */

    if buf_trn-doc.ext-doc-type = {&TDEDT_Vozvrat_Perem}
      and is-petrolium = true
      and is-pieces = false
    then do:
      undo, return error substitute( "&1. Запрещено создание возврата топливного товара.", vss-workfile ).
/*      пока запрещено, это коментарим*/
/*      find first buf-first_trn-doc no-lock*/
/*        where buf-first_trn-doc.doc-code = ub.trn-doc.out-code*/
/*        .*/
/*      for each buf-first_parts no-lock*/
/*        where buf-first_parts.obj-type  = buf-first_trn-doc.obj-type*/
/*          and buf-first_parts.obj-code  = buf-first_trn-doc.obj-code*/
/*          and buf-first_parts.artic     = ub.goods.artic*/
/*          and buf-first_parts.prod-type = ub.goods.prod-type*/
/*          and buf-first_parts.prod-code = ub.goods.prod-code*/
/*          and buf-first_parts.out-code  = buf-first_trn-doc.doc-code*/
/*      on error undo, return error return-value*/
/*      :*/
/*        find first buf_parts*/
/*          where buf_parts.obj-type  = buf_doc-line.obj-type*/
/*            and buf_parts.obj-code  = buf_doc-line.obj-code*/
/*            and buf_parts.artic     = buf_doc-line.artic*/
/*            and buf_parts.prod-type = buf_doc-line.prod-type*/
/*            and buf_parts.prod-code = buf_doc-line.prod-code*/
/*            and buf_parts.in-code   = buf-first_parts.in-code*/
/*            and buf_parts.out-code  = buf_doc-line.doc-code*/
/*            and buf_parts.part-code = buf-first_parts.part-code*/
/*          no-error .*/
/*        if available buf_parts then do:*/
/*          assign*/
/*            buf_parts.pl-code = buf-first_parts.pl-code*/
/*          .*/
/*          { str/crdocpl.i*/
/*            buf_trn-doc.doc-code*/
/*            ub.goods.gds-code*/
/*            buf_parts.pl-code*/
/*            buf_trn-doc.obj-type*/
/*            buf_trn-doc.obj-code*/
/*            v-doc-pl-rowid*/
/*            no-error*/
/*          }*/
/*          if error-status:error then do:*/
/*            undo, return error substitute("&1. В документе &3 для товара &4 не удалось создать строку для места хранения &5&2&6&7"*/
/*                                          , vss-workfile*/
/*                                          , {&new-line}*/
/*                                          , buf_trn-doc.doc-code*/
/*                                          , ub.goods.gds-code*/
/*                                          , buf_parts.pl-code*/
/*                                          , return-value*/
/*                                          , error-status :get-message( error-status :num-messages )*/
/*                                          ).*/
/*          end.*/
/*          find first buf_doc-pl*/
/*            where rowid(buf_doc-pl) = v-doc-pl-rowid*/
/*            .*/
/*          assign*/
/*            buf_doc-pl.cli-qnty      = buf_doc-pl.cli-qnty      + buf_parts.qnty / buf_doc-line.cli-base-rate*/
/*            buf_doc-pl.doc-qnty      = buf_doc-pl.doc-qnty      + buf_parts.qnty*/
/*            buf_doc-pl.cli-doc-qnty  = buf_doc-pl.cli-doc-qnty  + buf_parts.qnty * buf_doc-line.doc-density*/
/*            buf_doc-pl.fact-qnty     = buf_doc-pl.fact-qnty     + buf_parts.fact-qnty*/
/*            buf_doc-pl.cli-fact-qnty = buf_doc-pl.cli-fact-qnty + buf_parts.fact-qnty * buf_doc-line.fact-density*/
/*          .*/
/*        end.*/
/*      end.*/
    end.

    if l-goods-twounit = true then do:
      assign
        buf_doc-line.cli-qnty = v-total-parts-cli-qnty
      .
      if buf_doc-line.cli-qnty <> 0 then do:
        assign
          buf_doc-line.cli-base-rate = buf_doc-line.doc-qnty / buf_doc-line.cli-qnty
        .
      end.
    end.

    /* вычисляем среднюю учетную цену */
    define variable v-total-parts-qnty as decimal no-undo .
    define variable v-total-price-base as decimal no-undo .
    define variable v-total-price-rubl as decimal no-undo .

    assign
      v-total-parts-qnty = 0
      v-total-price-base = 0
      v-total-price-rubl = 0
    .

    for each ub.parts
      where ub.parts.obj-type  = buf_doc-line.obj-type
        and ub.parts.obj-code  = buf_doc-line.obj-code
        and ub.parts.artic     = buf_doc-line.artic
        and ub.parts.prod-type = buf_doc-line.prod-type
        and ub.parts.prod-code = buf_doc-line.prod-code
        and ub.parts.out-code  = buf_doc-line.doc-code
    on error undo, return error
    :
      assign
        v-total-parts-qnty = v-total-parts-qnty + parts.fact-qnty
        v-total-price-base = v-total-price-base + parts.fact-qnty * parts.price-base
        v-total-price-rubl = v-total-price-rubl + parts.fact-qnty * parts.price-rubl
      .
    end.

    if v-doc-line-chg-qnty <> v-total-parts-qnty then do:
      message
        vss-workfile vss-revision vss-description skip
        "Количество в партиях не совпадает с количеством в строке документа." skip
        "Количество по документу = " v-doc-line-chg-qnty skip
        "Количество по партиям = " v-total-parts-qnty skip
        view-as alert-box .
      undo, return error.
    end.

    if v-total-parts-qnty <> 0 then do:
      assign
        buf_doc-line.price-rubl = v-total-price-rubl / v-total-parts-qnty
        buf_doc-line.price-base = v-total-price-base / v-total-parts-qnty
        buf_doc-line.price-cli  = v-total-price-base / v-total-parts-qnty
      .
    end.

    define variable v-prt-create-n-c like ub.gds-prt.node-code no-undo .

    if cli_doc-prt <> obj_doc-prt then do:
      /* атрибуты "признаки включены/выключены" отличаются для объектов
        необходимо преобразование gds-dtl
      */
      /* если на объекте, куда мы перемещаем товар - выключены признаки
            то gds-dtl необходимо привязать к корню
        если на объекте, куда мы перемещаем товар - включены признаки
            то gds-dtl необходимо привязать к первому терминальному признаку
      */

      /* ищем корневой признак для товара */
      { gbl/rootnode.i
        ub.goods.artic
        ub.goods.prod-type
        ub.goods.prod-code
        v-prt-create-n-c
      }
      if cli_doc-prt = true then do:
        /* признаки включены - ищем первый терминальный признак */
        { gbl/termnode.i
          v-prt-create-n-c
          v-prt-create-n-c
        }
      end.
    end.

    define variable v-gds-dtl-chg-qnty   as decimal no-undo .
    define variable v-total-gds-dtl-qnty as decimal no-undo .
    define variable v-create-n-c like ub.gds-prt.node-code no-undo .

    assign
      v-total-gds-dtl-qnty = 0
    .

    for each ub.gds-dtl no-lock
      where ub.gds-dtl.doc-code  = ub.doc-line.doc-code
        and ub.gds-dtl.prod-type = ub.doc-line.prod-type
        and ub.gds-dtl.prod-code = ub.doc-line.prod-code
        and ub.gds-dtl.artic     = ub.doc-line.artic
    on error undo, return error
    :
      assign
        v-gds-dtl-chg-qnty = 0
      .

      if ub.gds-dtl.fact-qnty < 0 then do:
        message
          vss-workfile vss-revision vss-description skip
          "В документе внутреннего перемещения в строке признака" skip
          "не может быть задано отрицательное количество" skip
          view-as alert-box error .
        undo, return error .
      end.

      if ub.trn-doc.doc-type = {&expense}
      and ub.gds-dtl.fact-qnty  <> 0
      then do:
        assign
          v-gds-dtl-chg-qnty = ub.gds-dtl.fact-qnty
        .
      end.

      if ub.trn-doc.doc-type = {&income} then do:
        if  cli_doc-prt = no
        and obj_doc-prt = yes then do:
          /* перемещение происходило с объекта, где признаки выключены
            на объект, где признаки включены
            fact-qnty может быть больше, чем doc-qnty
          */
          if ub.gds-dtl.fact-qnty <> ub.gds-dtl.doc-qnty then do:
            assign
              v-gds-dtl-chg-qnty = ub.gds-dtl.doc-qnty - ub.gds-dtl.fact-qnty
            .
          end.
        end.
        else do:
          if ub.gds-dtl.fact-qnty > ub.gds-dtl.doc-qnty then do:
            message
              vss-workfile vss-revision vss-description skip
              "В приходном документе в строке признака" skip
              "фактическое количество не может быть больше, чем количество по документу" skip
              view-as alert-box error .
            undo, return error .
          end.
          if ub.gds-dtl.fact-qnty < ub.gds-dtl.doc-qnty then do:
            assign
              v-gds-dtl-chg-qnty = ub.gds-dtl.doc-qnty - ub.gds-dtl.fact-qnty
            .
          end.
        end.
      end.

      if v-gds-dtl-chg-qnty = 0 then do:
        next. /* --->>>--- */
      end.

      if cli_doc-prt = obj_doc-prt then do:
        assign
          v-create-n-c = ub.gds-dtl.prt-code
        .
      end.
      else do:
        assign
          v-create-n-c = v-prt-create-n-c
        .
      end.

      find first buf_gds-dtl
        where buf_gds-dtl.doc-code    = buf_trn-doc.doc-code
          and buf_gds-dtl.artic       = ub.doc-line.artic
          and buf_gds-dtl.prod-type   = ub.doc-line.prod-type
          and buf_gds-dtl.prod-code   = ub.doc-line.prod-code
          and buf_gds-dtl.prt-code    = v-create-n-c
        no-error .
      if not available buf_gds-dtl then do:
        create buf_gds-dtl.
        assign
          buf_gds-dtl.doc-code    = buf_trn-doc.doc-code
          buf_gds-dtl.artic       = ub.doc-line.artic
          buf_gds-dtl.prod-type   = ub.doc-line.prod-type
          buf_gds-dtl.prod-code   = ub.doc-line.prod-code
          buf_gds-dtl.prt-code    = v-create-n-c
          buf_gds-dtl.obj-type    = buf_trn-doc.obj-type
          buf_gds-dtl.obj-code    = buf_trn-doc.obj-code
        .

        if cli_doc-prt = obj_doc-prt then do:
          assign
            buf_gds-dtl.discnt-base = ub.gds-dtl.discnt-base
            buf_gds-dtl.discnt-rubl = ub.gds-dtl.discnt-rubl
            buf_gds-dtl.discnt-pc   = ub.gds-dtl.discnt-pc
            buf_gds-dtl.discnt-type = ub.gds-dtl.discnt-type
          .
        end.
        else do:
          /* ??? что это означает
            мы игнорируем скидку, если производим перемещение на объект,
            с противоположным атрибутом "признаки включены/выключены"
            */
          assign
            buf_gds-dtl.discnt-base = 0
            buf_gds-dtl.discnt-rubl = 0
            buf_gds-dtl.discnt-pc   = 0
            buf_gds-dtl.discnt-type = ?
          .
        end.
      end.
      assign
        buf_gds-dtl.price-base     = ( buf_gds-dtl.price-base * buf_gds-dtl.fact-qnty
                                  + ub.gds-dtl.price-base * v-gds-dtl-chg-qnty )
                                  / (buf_gds-dtl.fact-qnty + v-gds-dtl-chg-qnty)
        buf_gds-dtl.price-rubl     = ( buf_gds-dtl.price-rubl * buf_gds-dtl.fact-qnty
                                  + ub.gds-dtl.price-rubl * v-gds-dtl-chg-qnty )
                                  / (buf_gds-dtl.fact-qnty + v-gds-dtl-chg-qnty)
        buf_gds-dtl.new-price-sale = ub.gds-dtl.new-price-sale
        buf_gds-dtl.ov             = yes
        buf_gds-dtl.fact-qnty      = buf_gds-dtl.fact-qnty + v-gds-dtl-chg-qnty
        buf_gds-dtl.doc-qnty       = buf_gds-dtl.doc-qnty  + v-gds-dtl-chg-qnty
        v-total-gds-dtl-qnty       = v-total-gds-dtl-qnty + v-gds-dtl-chg-qnty
      .
    end.


    if v-total-gds-dtl-qnty <> v-doc-line-chg-qnty then do:
      message
        vss-workfile vss-revision vss-description skip
        "Количество в признаках не совпадает с количеством в строке документа." skip
        "Количество по документу = " v-doc-line-chg-qnty skip
        "Количество по признакам = " v-total-gds-dtl-qnty skip
        view-as alert-box .
      undo, return error.
    end.
  end.

  if not can-find(first ub.doc-line
    where ub.doc-line.doc-code = buf_trn-doc.doc-code)
  then do:
    /* не было создано ни одной линии */
    /* удаляем документ */
    delete buf_trn-doc.
    return .
  end.

  assign
    buf_trn-doc.PS          = '@  Строк в документе : ' + string(n_str) + (if substring(ub.trn-doc.ps, 1, 1) = '@' then '' else {&new-line} + ub.trn-doc.ps)
    buf_trn-doc.fact-base   = ?
    buf_trn-doc.fact-rubl   = ?
  .

  /* рассчитываем шапку накладной */
  run gbl/calc-trn.p (input ? , INPUT RECID(buf_trn-doc)).
  /* создадим если надо поставку ранье чем уйдет в новости */

  run cus/oo-mkrcv.p (
        buffer ub.trn-doc ,
        buffer buf_trn-doc )
        no-error .
   if error-status :error then
   message vss-workfile vss-revision vss-description skip
          "Ошибка oo-mkrcv.p  " skip
           skip
           error-status :get-message(1) skip
           error-status :get-message(2) skip
           return-value skip
           view-as alert-box error
   .

  /* закрываем накладную       */
  /* она должна уйти в новости */
  assign
    buf_trn-doc.flag_ = yes
  .
  /* Ассортиментная политика */
  /* Проверка ассортиментной политики */
  for each buf_doc-line where buf_doc-line.doc-code = buf_trn-doc.doc-code on error undo, return error return-value :
    find first ub.goods where
              ub.goods.artic     = buf_doc-line.artic     and
              ub.goods.prod-type = buf_doc-line.prod-type and
              ub.goods.prod-code = buf_doc-line.prod-code no-lock.
    var-ok-assort-pol = true .
    if buf_trn-doc.ext-doc-type = {&TDEDT_Pri_Perem} then do:
       v-event-code = substitute("&1" , buf_trn-doc.ext-doc-type ) .
        { gbl/goassizt.i
          v-event-code
          ub.goods.gds-code
          buf_trn-doc.obj-type
          buf_trn-doc.obj-code
          false
          var-ok-assort-pol
          var-mess-assort-pol
        }
    end.
    if var-ok-assort-pol = false then do:
        buf_trn-doc.PS = buf_trn-doc.PS + {&new-line} + var-mess-assort-pol .
    end.
  end.
  /* рассчитываем шапку накладной */
  run gbl/calc-trn.p (input ? /*parparentproc*/ , input recid(buf_trn-doc)) no-error.
  if error-status :error then do:
    undo, return error return-value.
  end.

/*  if  g#news*/
/*  and doc-obj.db-num <> 0 or clients.db-num <> 0 then do:*/
/*    /* маршрутизируем документ для отправки в УБД */*/
/*    /* здесь обрабатывается случай  */*/
/*  теперь все должно уходить стандартно, так же как и с обычными документами!!! */
/*    run str/callnews.p*/
/*      ( input "trn-doc"*/
/*       ,input (buffer buf_trn-doc:handle)*/
/*      ) no-error .*/
/*    if error-status :error*/
/*    then do:*/
/*      message*/
/*        vss-workfile vss-revision vss-description skip*/
/*        "Ошибка при отправке документа в новости" skip*/
/*        "Документ внутреннего перемещения" buf_trn-doc.doc-code skip*/
/*        "Объект" buf_trn-doc.obj-type buf_trn-doc.obj-code skip*/
/*        view-as alert-box error .*/
/*      undo, return error return-value .*/
/*    end.*/
/*  end.*/
end.