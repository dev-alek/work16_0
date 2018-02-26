/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

создание топливных документов по документу сверки

Автор: Уханов Дмитрий Юрьевич
Дата создания: 11/14/06
Author: Dmitry Ukhanov
Creation date: 11/14/06

*/

define input  parameter parparentproc as handle    no-undo.
define input  parameter p-rvs-rowid   as rowid     no-undo .
define output parameter p-docs-info   as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "создание топливных документов по документу сверки".
{ cmp/vssrevis.i     }
{ cmp/str-glbl.i     }
{ str/lib-trn.i      }
{ cmp/library.i      }
{ str/lib-calc.i     }
{ str/doc-code.i     }
{ cmp/gds-list.i gds-list def }
{ gbl/getcntxt.i def }
{ str/getctxtp.i def }
{ gbl/ptrlprop.i def }
{ ref/gdsoattr.i     }

do
on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
on stop   undo, return error substitute( "&1. stop", vss-workfile )
on endkey undo, return error substitute( "&1. endkey", vss-workfile )
:

  define buffer buf_rvs-doc       for ub.rvs-doc .
  define buffer buf_rvs-line      for ub.rvs-line .
  define buffer buf_rvs-line-attr for ub.rvs-line-attr .

  define buffer buf-add_clients     for ub.clients .
  define buffer buf_sysconf         for ub.sysconf .
  define buffer buf_goods           for ub.goods .
  define buffer buf_gds-prt         for ub.gds-prt .
  define buffer buf_prt-obj         for ub.prt-obj .
  define buffer buf_pl-gds          for ub.pl-gds .

  define buffer buf_trn-doc      for ub.trn-doc .
  define buffer buf_doc-line     for ub.doc-line .
  define buffer buf_inv-line     for ub.inv-line .
  define buffer buf_gds-dtl      for ub.gds-dtl .
  define buffer buf_doc-pl       for ub.doc-pl .
  define buffer buf_doc-line-sum for ub.doc-line-sum .

  define buffer bf_doc-line         for ub.doc-line.
  define buffer bf_inv-line         for ub.inv-line.
  define buffer bf-prev_doc-line for ub.doc-line.
  define buffer bf-wst_trn-doc   for ub.trn-doc.
  define buffer bf-wst_doc-line  for ub.doc-line.
  define buffer bf-wst_inv-line  for ub.inv-line.
  define buffer bf-wst_doc-pl    for ub.doc-pl.
  define buffer buf_sale-doc     for ub.sale-doc .

  define temp-table tt-line-for-doc no-undo
    field gds-code      like ub.rvs-line.gds-code
    field pl-code       like ub.rvs-line.pl-code
    field fact-qnty     like ub.doc-pl.fact-qnty
    field fact-cli-qnty like ub.doc-pl.fact-qnty
    index pi is unique primary gds-code pl-code
  .
  define buffer buf_tt-line-for-doc for tt-line-for-doc .

  define buffer buf-spi_trn-doc     for ub.trn-doc .
  define buffer buf-spi_doc-line    for ub.doc-line .
  define buffer buf-spi_inv-line    for ub.inv-line .
  define buffer buf-spi_gds-dtl     for ub.gds-dtl .
  define buffer buf-spi_parts       for ub.parts .
  define buffer buf-spi_doc-pl      for ub.doc-pl .

  define variable chs-gds-inv                         as   logical                       no-undo.
  define variable vartot-docold                       like ub.trn-doc.tot-doc            no-undo.
  define variable vartot-rublold                      like ub.trn-doc.tot-rubl           no-undo.
  define variable i-total-doc-line_tot-ovold          like ub.trn-doc.tot-ov             no-undo.
  define variable i-total-doc-line_fact-rublold       like ub.trn-doc.fact-rubl          no-undo.
  define variable i-total-doc-line_fact-baseold       like ub.trn-doc.fact-base          no-undo.
  define variable i-total-doc-line_fact-qntyold       like ub.trn-doc.fact-qnty          no-undo.
  define variable i-total-doc-line_doc-qntyold        like ub.trn-doc.doc-qnty           no-undo.
  define variable i-total-doc-line_cli-qntyold        like ub.trn-doc.cli-qnty           no-undo.
  define variable i-total-parts_fact-baseold          as   decimal                       no-undo.
  define variable i-total-parts_fact-rublold          as   decimal                       no-undo.
  define variable i-total-parts_fact-qntyold          as   decimal                       no-undo.
  define variable stfactplvalue                       as   character                     no-undo.
  define variable stfactpltype                        as   character                     no-undo.
  define variable v-reserv-qnty-base                  like ub.doc-line.fact-qnty         no-undo.
  define variable v-reserv-qnty-cli                   like ub.doc-line.cli-qnty          no-undo.
  define variable v-chg-qnty                          like ub.doc-line.fact-qnty         no-undo.
  define variable v-fact-qnty                         like ub.doc-line.fact-qnty         no-undo.
  define variable v-fact-cli-qnty                   like ub.doc-line.cli-qnty          no-undo.
  define variable varupdate                           as   logical                       no-undo initial yes.
  define variable varrevision                         as   logical                       no-undo initial no.
  define variable varpercrev                          as   decimal                       no-undo initial ?.
  define variable varauto-tank                        as   logical                       no-undo initial no.
  define variable varpercauto                         as   decimal                       no-undo initial ?.
  define variable varinv                              as   logical                       no-undo initial no.
  define variable varpercinv                          as   decimal                       no-undo initial ?.
  define variable varinv-set                          as   logical                       no-undo initial no.

  define variable O_PKH                               as   decimal                       no-undo.
  define variable O_FACT                              as   decimal                       no-undo.
  define variable v-metering-error                    as   decimal                       no-undo.
  define variable v-normal-wastage                    as   decimal                       no-undo.
  define variable v-normal-wastage-winter             as   decimal                       no-undo init ?.
  define variable v-normal-wastage-summer             as   decimal                       no-undo init ?.
  define variable v-rsrv-qnty                         like ub.doc-line.fact-qnty         no-undo.

  define variable O_PKH-base                          as   decimal                       no-undo.
  define variable O_FACT-base                         as   decimal                       no-undo.
  define variable O_PKH-cli                           as   decimal                       no-undo.
  define variable O_FACT-cli                          as   decimal                       no-undo.
  define variable K1                                  as   decimal                       no-undo.
  define variable v-metering-error-base               as   decimal                       no-undo.
  define variable v-metering-error-cli                as   decimal                       no-undo.
  define variable v-metering-error-dens               as   decimal                       no-undo.
  define variable v-metering-qnty-base                as   decimal                       no-undo .
  define variable v-metering-qnty-cli                 as   decimal                       no-undo .
  define variable K2                                  as   decimal                       no-undo.
  define variable v-normal-wastage-base               as   decimal                       no-undo.
  define variable v-normal-wastage-cli                as   decimal                       no-undo.
  define variable v-normal-wastage-dens               as   decimal                       no-undo .
  define variable v-wastage-qnty-base                 as   decimal                       no-undo .
  define variable v-wastage-qnty-cli                  as   decimal                       no-undo .
  define variable WST-base                            as   decimal                       no-undo.
  define variable WST-cli                             as   decimal                       no-undo.
  define variable varfact-order-prev-inv              like ub.trn-doc.fact-order         no-undo.

  /* создавать ли TDEDT_Spi_Vnesh */
  define variable v-cre-add-docs      as logical   no-undo .
  define variable v-without-mt-err    as logical   no-undo .

  define variable v-inv-code         as character no-undo .
  define variable v-spi-code         as character                no-undo .
  define variable v-host-code        as integer                  no-undo .
  define variable v-prt-root         as integer                  no-undo .
  define variable v-recid            as recid     no-undo .

  define variable v-log              as logical   no-undo .
  define variable v-type              as character no-undo .

  { gbl/getcntxt.i get }
  find first buf_rvs-doc
    where rowid( buf_rvs-doc ) = p-rvs-rowid
  .

  if v-cntxt-obj-type <> buf_rvs-doc.obj-type
    or v-cntxt-obj-code <> buf_rvs-doc.obj-code
  then do:
    message
      vss-workfile vss-revision vss-description skip
      substitute("Сверка &1 резервуаров на объекте &2 &3", buf_rvs-doc.rvs-code, buf_rvs-doc.obj-type, buf_rvs-doc.obj-code ) skip
      substitute("На текущем объекте нельзя создать инвентаризацию по данной сверке." ) skip
      view-as alert-box error .
    return error .
  end.


  assign
    v-log = no
  .
  message
    "Вы хотите сделать инвентаризацию по сверке?"    skip
    "YES    - по всем товарам из сверки"             skip
    "NO     - не делать инвентаризацию"              skip
    "CANCEL - опционально по товарам и бакам"
    view-as alert-box buttons yes-no-cancel update v-log.
  if v-log = no then do:
    return no-apply.
  end.

  assign
    chs-gds-inv = v-log
    p-docs-info = "":U
  .
  /* создание документа инвентаризации */
  block_cre-inv :
  do transaction
  on error  undo block_cre-inv, retry block_cre-inv
  on stop   undo block_cre-inv, retry block_cre-inv
  on endkey undo block_cre-inv, retry block_cre-inv
  :
    if retry then do:
      assign
        p-docs-info = "":U
      .
      message
        vss-workfile vss-revision vss-description skip
        "Ошибка при создании документа" skip
        error-status :get-message(1) skip
        return-value skip
        view-as alert-box error .
      undo block_cre-inv, leave block_cre-inv .
    end.

    for each tt-line-for-doc
    on error undo block_cre-inv, retry block_cre-inv
    :
      delete tt-line-for-doc .
    end.

    { gbl/ptrlprop.i
      run
      buf_rvs-doc.obj-type
      buf_rvs-doc.obj-code
    }

    if not error-status :error then do:
      assign
        v-without-mt-err = ptrlprop-rvsnmter
      .
    end.

    assign
      v-cre-add-docs = false
    .
    if ptrlprop-invclipt <> ? then do:
      find first buf-add_clients
        where buf-add_clients.obj-type = {&cmp}
          and buf-add_clients.obj-code = ptrlprop-invclipt
        no-error .
      if available buf-add_clients then do:
        assign
          v-cre-add-docs = true
        .
        { gbl/hostcode.i
          v-cntxt-obj-type
          v-cntxt-obj-code
          v-host-code
        }
        find first buf_sysconf no-lock
          where buf_sysconf.host-code = v-host-code
        .
        if buf_sysconf.cons-vat-pc = ? then do:
          message
            vss-workfile vss-revision vss-description skip
            "У Вас не установлен НДС для консигнационного товара по фирме." skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
          undo block_cre-inv, retry block_cre-inv .
        end.
      end.
    end.

    /* Создаем инвентаризацию */
    { str/adinvdoc.i
      v-cntxt-obj-type
      v-cntxt-obj-code
      v-cntxt-userid
      v-recid
    }
    find first buf_trn-doc exclusive-lock
      where recid( buf_trn-doc ) = v-recid
        .
    assign
      v-inv-code           = buf_trn-doc.doc-code
      buf_trn-doc.agnt     = buf_rvs-doc.agnt
      buf_trn-doc.wrkr     = buf_rvs-doc.wrkr
      buf_trn-doc.boss     = buf_rvs-doc.boss
      buf_trn-doc.out-code = buf_rvs-doc.rvs-code
      .

    /* Заполняем инвентаризацию товарами */
    block_rvs-line:
    for each buf_rvs-line no-lock
      where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
      ,first buf_goods no-lock
      where buf_goods.gds-code = buf_rvs-line.gds-code
    on error undo block_cre-inv, retry block_cre-inv
    :
      if chs-gds-inv <> yes then do:
        assign
          v-log = no
        .
        message
          substitute( 'Будем проводить инвентаризацию по товару (&1 &2 &3) "&4"', buf_goods.artic, buf_goods.prod-type, buf_goods.prod-code, buf_goods.gds-name ) skip
          substitute( " на месте хранения &1", buf_rvs-line.pl-code ) skip
          substitute( " системное количество &1", buf_rvs-line.system-qnty ) skip
          substitute( " фактический остаток &1?", buf_rvs-line.state-measure-qnty )
          view-as alert-box buttons yes-no update v-log.
        if v-log <> yes then do:
          next block_rvs-line.
        end.
      end.

      { str/adinvlin.i
        parparentproc
        v-inv-code
        buf_goods.artic
        buf_goods.prod-type
        buf_goods.prod-code
        v-recid
        no-error
      }
      if error-status :error then do:
        undo block_cre-inv, retry block_cre-inv.
      end.

      find first buf_doc-line exclusive-lock
        where recid( buf_doc-line ) = v-recid
      .
      assign
        buf_doc-line.doc-density  = buf_rvs-line.state-density
        buf_doc-line.fact-density = buf_doc-line.doc-density
      .
    end. /* each buf_rvs-line */

    /* инвентаризация накл- - разр+ */
    run close-doc in this-procedure
      ( input v-inv-code
      , input recid( buf_trn-doc )
      ) no-error .
    if error-status :error then do:
      undo block_cre-inv, leave block_cre-inv .
    end.

    { gbl/conf-rd.i
      "'stfactpl'"
      "''"
      "''"
      0
      "''"
      "''"
      "''"
      no
      stfactplvalue
      stfactpltype
      no-error
    }
    if not error-status :error
      and stfactplvalue <> ?
      and stfactplvalue <> "?"
    then do:
      { str/chkqtpl.i
        stfactplvalue
        varupdate
        varrevision
        varpercrev
        varauto-tank
        varpercauto
        varinv
        varpercinv
        varinv-set
        no-error
      }
      if error-status :error then do:
        message
          return-value skip
          error-status :get-message( 1 )
          view-as alert-box.
        undo block_cre-inv, retry block_cre-inv .
      end.
      if varrevision = yes then do:
        assign
          K1 = varpercrev.
      end.
      if varauto-tank = yes then do:
        assign
          K1 = varpercauto.
      end.
      if varinv = yes then do:
        assign
          K1 = varpercinv.
      end.
    end.
    if K1 = ? then do:
      assign
        K1 = 0.0
      .
    end.
    define variable K1-all as decimal no-undo.
    K1-all = K1.
    
    for each buf_doc-line exclusive-lock
      where buf_doc-line.doc-code = v-inv-code
      ,first buf_inv-line exclusive-lock
      where buf_inv-line.doc-code  = buf_doc-line.doc-code
        and buf_inv-line.artic     = buf_doc-line.artic
        and buf_inv-line.prod-type = buf_doc-line.prod-type
        and buf_inv-line.prod-code = buf_doc-line.prod-code
      ,first buf_goods no-lock
      where buf_goods.artic     = buf_doc-line.artic
        and buf_goods.prod-type = buf_doc-line.prod-type
        and buf_goods.prod-code = buf_doc-line.prod-code
    on error undo block_cre-inv, retry block_cre-inv
    :
      
      K1 = K1-all.
      
      find first buf_rvs-line no-lock
        where buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
          and buf_goods.gds-code = buf_rvs-line.gds-code no-error.
      find first buf_rvs-line-attr where buf_rvs-line-attr.obj-code = buf_rvs-line.obj-code
                                          and buf_rvs-line-attr.obj-type = buf_rvs-line.obj-type
                                          and buf_rvs-line-attr.gds-code = buf_rvs-line.gds-code
                                          and buf_rvs-line-attr.pl-code = buf_rvs-line.pl-code
                                          and buf_rvs-line-attr.rvs-code = buf_rvs-line.rvs-code
                                          and buf_rvs-line-attr.attr-code = "delta-mass-qnty" no-lock no-error.
      
      if available (buf_rvs-line-attr)
      then do:
        decimal (buf_rvs-line-attr.attr-value) no-error.
        if not error-status:error
        then do: 
        if not decimal (buf_rvs-line-attr.attr-value) = 0
          then K1 = decimal (buf_rvs-line-attr.attr-value) no-error.
        end.
      end.
      
      run gds-o-normal-wastage-value in this-procedure
                        ( input buf_goods.gds-code
                         , input buf_trn-doc.obj-type
                         , input buf_trn-doc.obj-code
                         , input if buf_trn-doc.fact-date <> ? then buf_trn-doc.fact-date else buf_trn-doc.doc-date
                         , output v-normal-wastage-winter
                         , output v-normal-wastage-summer
                         , output v-normal-wastage
                        ) no-error.

      if error-status:error
      then do:
        message
          "ОШИБКА при определние нормы естественной убыли." skip
          "По строке товара : " buf_goods.artic " " buf_goods.prod-type " " buf_goods.prod-code " " buf_goods.gds-name skip
          "на объекте: " buf_trn-doc.obj-type " " buf_trn-doc.obj-code
          skip
          view-as alert-box error.
        undo block_cre-inv, retry block_cre-inv.
      end.
      
      if v-normal-wastage = ? then do:
        assign
          K2 = 0.0
        .
      end.
      else do:
        assign
          K2 = v-normal-wastage
        .
      end.

      { str/reclcinv.i
        "'old'":U
        recid(buf_doc-line)
        v-inv-code
        vartot-docold
        vartot-rublold
        i-total-doc-line_tot-ovold
        i-total-doc-line_fact-rublold
        i-total-doc-line_fact-baseold
        i-total-doc-line_fact-qntyold
        i-total-doc-line_doc-qntyold
        i-total-doc-line_cli-qntyold
        i-total-parts_fact-baseold
        i-total-parts_fact-rublold
        i-total-parts_fact-qntyold
        no-error
      }
      if error-status :error then do:
        undo block_cre-inv, retry block_cre-inv.
      end.
      assign
        buf_inv-line.wast-cli-qnty  = buf_inv-line.before-cli-qnty
        buf_inv-line.after-cli-qnty = buf_inv-line.before-cli-qnty
      .
      find first buf_gds-prt no-lock
        where buf_gds-prt.upper-code = buf_goods.prt-root
        .
      if not v-cntxp-doc-prt
        or buf_gds-prt.node-name = {&empty-scale}
      then do:
        { gbl/gdsdtlcr.i
          buf_gds-prt.node-code
          buf_doc-line
          buf_gds-dtl
          no-error
        }
        if error-status :error then do:
          undo block_cre-inv, retry block_cre-inv.
        end.
        find first buf_prt-obj no-lock
          where buf_prt-obj.prt-code  = buf_gds-prt.node-code
            and buf_prt-obj.prod-code = buf_goods.prod-code
            and buf_prt-obj.prod-type = buf_goods.prod-type
            and buf_prt-obj.artic     = buf_goods.artic
            and buf_prt-obj.obj-code  = buf_trn-doc.obj-code
            and buf_prt-obj.obj-type  = buf_trn-doc.obj-type
          no-error.
        assign
          buf_gds-dtl.doc-qnty  = 0
          buf_gds-dtl.fact-qnty = ( if available buf_prt-obj then buf_prt-obj.fact-qnty else 0 )
        .
        if buf_doc-line.doc-qnty <> buf_gds-dtl.fact-qnty then do:
          message
            "ОШИБКА" skip
            "Кол-во товара по строке : " buf_goods.artic " " buf_goods.prod-type " " buf_goods.prod-code " " buf_goods.gds-name skip
            "на объекте: " buf_trn-doc.obj-type " " buf_trn-doc.obj-code " , равное " buf_doc-line.doc-qnty skip
            " не совпадает с кол-ом по корневому признаку, равном " buf_gds-dtl.fact-qnty "." skip
            view-as alert-box error.
          undo block_cre-inv, retry block_cre-inv.
        end. /* несоответствие строки и признака */

        block_doc-pl:
        for each buf_doc-pl exclusive-lock
          where buf_doc-pl.out-code = v-inv-code
            and buf_doc-pl.gds-code = buf_goods.gds-code
            and buf_doc-pl.obj-type = buf_trn-doc.obj-type
            and buf_doc-pl.obj-code = buf_trn-doc.obj-code
          ,each buf_rvs-line no-lock
          where buf_rvs-line.gds-code = buf_doc-pl.gds-code
            and buf_rvs-line.rvs-code = buf_rvs-doc.rvs-code
            and buf_rvs-line.obj-type = buf_doc-pl.obj-type
            and buf_rvs-line.obj-code = buf_doc-pl.obj-code
            and buf_rvs-line.pl-code  = buf_doc-pl.pl-code
        on error undo block_cre-inv, retry block_cre-inv
        :
          find first buf_pl-gds no-lock
            where buf_pl-gds.obj-type = buf_rvs-line.obj-type
              and buf_pl-gds.obj-code = buf_rvs-line.obj-code
              and buf_pl-gds.pl-code  = buf_rvs-line.pl-code
              and buf_pl-gds.gds-code = buf_rvs-line.gds-code
            no-error.
          if available buf_pl-gds then do:
            assign
              v-fact-qnty     = buf_pl-gds.fact-qnty
              v-fact-cli-qnty = buf_pl-gds.cli-fact-qnty
            .
          end.
          else do:
            assign
              v-fact-qnty     = 0.0
              v-fact-cli-qnty = 0.0
            .
          end.
          assign
            O_PKH-base            = v-fact-qnty
            O_FACT-base           = buf_rvs-line.state-measure-qnty + buf_rvs-line.state-add-qnty
            O_PKH-cli             = v-fact-cli-qnty
            O_FACT-cli            = buf_rvs-line.state-measure-cli-qnty + buf_rvs-line.state-add-qnty * buf_rvs-line.state-density
            /*Согласно разъяснениям Главного технического управления Государственного комитета РСФСР № 12-3/47-233 от 16.04.1990 г.,*/
            /*установленные ГОСТ 26976-86 пределы погрешности измерений (нормы точности) могут применяться только по отношению к фактическому остатку нефтепродуктов, */
            /*измеренному в резервуарах при инвентаризации, без учета количества нефтепродукта в трубопроводе.*/
            v-metering-error-base = K1 / 100 * buf_rvs-line.state-measure-qnty
            v-metering-error-cli  = K1 / 100 * buf_rvs-line.state-measure-cli-qnty
            v-metering-error-dens = buf_rvs-line.state-density
/*            v-metering-error-base = K1 / 100 * O_FACT-base*/
/*            v-metering-error-cli  = K1 / 100 * O_FACT-cli*/
            v-metering-qnty-base  = 0.0
            v-metering-qnty-cli   = 0.0
            v-normal-wastage-base = 0.0
            v-normal-wastage-cli  = 0.0
            v-normal-wastage-dens = 1 / buf_goods.cli-base-rate
            v-wastage-qnty-base   = 0.0
            v-wastage-qnty-cli    = 0.0
            v-reserv-qnty-base    = 0.0
            v-reserv-qnty-cli     = 0.0
          .

          if ptrlprop-expptrl = {&calc-petrol-weight} then do:
            /* работаем относительно килограммов */
            assign
              O_FACT           = O_FACT-cli
              O_PKH            = O_PKH-cli
              v-metering-error = v-metering-error-cli
            .
          end.
          else do:
            /* работаем относительно литров */
            assign
              O_FACT           = O_FACT-base
              O_PKH            = O_PKH-base
              v-metering-error = v-metering-error-base
            .
          end.
          if (O_PKH - O_FACT) <= 0  then do:
          /* излишки */
            if (O_FACT - O_PKH) - v-metering-error <= 0 then do:
            /* все укладывается в погрешность */
              assign
                v-rsrv-qnty = 0
                v-metering-qnty-base = v-metering-error-base
                v-metering-qnty-cli  = v-metering-error-cli
              .
              case ptrlprop-algrvspt :
                when 1 then do:
                end.
                when 2 then do:
                  if v-metering-error > (O_FACT - O_PKH) then do:
                    /* уменьшим погрешность измерения, чтобы она была не больше дельты РКН и ФАКТ */
                    if ptrlprop-expptrl = {&calc-petrol-weight} then do:
                      assign
                        v-metering-error-cli  = (O_FACT-cli - O_PKH-cli)
                        v-metering-error-base = v-metering-error-cli / v-metering-error-dens
                      .
                    end.
                    else do:
                      assign
                        v-metering-error-base = (O_FACT-base - O_PKH-base)
                        v-metering-error-cli  = v-metering-error-base * v-metering-error-dens
                      .
                    end.
                  end.
                end.
              end case.
            end.
            else do:
            /* в погрешность не укладывается, пересчитываем по алгоритму */
              assign
                v-rsrv-qnty          = (O_FACT - O_PKH) - (if v-without-mt-err = true then 0 else v-metering-error)
                v-metering-qnty-base = (if v-without-mt-err = true then 0 else v-metering-error-base)
                v-metering-qnty-cli  = (if v-without-mt-err = true then 0 else v-metering-error-cli )
              .
            end.
          end. /* излишки */
          else do:
          /* недостача */
            if K2 <> 0 then do:
            /* расчет естественной убыли */
              assign
                WST-base = 0.0
                WST-cli  = 0.0
              .
              /* ищем предыдущую инвентаризацию */
              find last bf-prev_doc-line no-lock
                where bf-prev_doc-line.obj-type     = buf_doc-line.obj-type
                  and bf-prev_doc-line.obj-code     = buf_doc-line.obj-code
                  and bf-prev_doc-line.prod-type    = buf_doc-line.prod-type
                  and bf-prev_doc-line.prod-code    = buf_doc-line.prod-code
                  and bf-prev_doc-line.artic        = buf_doc-line.artic
                  and bf-prev_doc-line.ext-doc-type = {&TDEDT_Inv}
                  and bf-prev_doc-line.status_      = {&fact}
                use-index dt-fo
                no-error.
              if available bf-prev_doc-line then do:
                assign
                  varfact-order-prev-inv = bf-prev_doc-line.fact-order
                .
              end.
              else do:
                assign
                  varfact-order-prev-inv = 0
                .
              end.
              for each bf-wst_doc-line no-lock
                where ( bf-wst_doc-line.obj-type         = buf_doc-line.obj-type
                        and bf-wst_doc-line.obj-code     = buf_doc-line.obj-code
                        and bf-wst_doc-line.prod-type    = buf_doc-line.prod-type
                        and bf-wst_doc-line.prod-code    = buf_doc-line.prod-code
                        and bf-wst_doc-line.artic        = buf_doc-line.artic
                        and bf-wst_doc-line.ext-doc-type = {&TDEDT_Pri_Vnesh}
                        and bf-wst_doc-line.status_      = {&fact}
                        and bf-wst_doc-line.fact-order   > varfact-order-prev-inv
                        and (not can-find (first buf_sale-doc
                                           where buf_sale-doc.doc-code = bf-wst_doc-line.doc-code
                                             and buf_sale-doc.doc-kind = {&sale-add2-in-tech-refuell}))
                      )
                      or
                      ( bf-wst_doc-line.obj-type         = buf_doc-line.obj-type
                        and bf-wst_doc-line.obj-code     = buf_doc-line.obj-code
                        and bf-wst_doc-line.prod-type    = buf_doc-line.prod-type
                        and bf-wst_doc-line.prod-code    = buf_doc-line.prod-code
                        and bf-wst_doc-line.artic        = buf_doc-line.artic
                        and bf-wst_doc-line.ext-doc-type = {&TDEDT_Ras_Vnesh_VP}
                        and bf-wst_doc-line.status_      = {&fact}
                        and bf-wst_doc-line.fact-order   > varfact-order-prev-inv
                      )
              on error undo block_cre-inv, retry block_cre-inv
              :
                find first bf-wst_doc-pl no-lock
                  where bf-wst_doc-pl.obj-type = bf-wst_doc-line.obj-type
                    and bf-wst_doc-pl.obj-code = bf-wst_doc-line.obj-code
                    and bf-wst_doc-pl.pl-code  = buf_rvs-line.pl-code
                    and bf-wst_doc-pl.out-code = bf-wst_doc-line.doc-code
                    and bf-wst_doc-pl.gds-code = buf_rvs-line.gds-code
                  no-error.
                if available bf-wst_doc-pl then do:
                  assign
                    WST-base = WST-base + (if bf-wst_doc-line.ext-doc-type = {&TDEDT_Pri_Vnesh} then bf-wst_doc-pl.fact-qnty else - bf-wst_doc-pl.fact-qnty)
                    WST-cli  = WST-cli + (if bf-wst_doc-line.ext-doc-type = {&TDEDT_Pri_Vnesh} then bf-wst_doc-pl.cli-fact-qnty else - bf-wst_doc-pl.cli-fact-qnty )
                  .
                end.
              end.

              assign
                v-normal-wastage-base = WST-base * K2 / 1000
                v-normal-wastage-cli  = WST-cli  * K2 / 1000
                v-normal-wastage-dens = WST-cli / WST-base
              .
            end.

            if ptrlprop-expptrl = {&calc-petrol-weight} then do:
              /* работаем относительно килограммов */
              if v-normal-wastage-cli <= 0.0 then do:
                assign
                  v-normal-wastage-base = 0.0
                  v-normal-wastage-cli = 0.0
                .
              end.
              else do:
                if v-normal-wastage-cli > (O_PKH-cli - O_FACT-cli) then do:
                  assign
                    v-normal-wastage-cli  = (O_PKH-cli - O_FACT-cli)
                    v-normal-wastage-base = v-normal-wastage-cli / v-normal-wastage-dens
                  .
                end.
              end.
              assign
                v-normal-wastage = v-normal-wastage-cli
              .
            end.
            else do:
              if v-normal-wastage-base <= 0.0 then do:
                assign
                  v-normal-wastage-base = 0.0
                  v-normal-wastage-cli = 0.0
                .
              end.
              else do:
                if v-normal-wastage-base > (O_PKH-base - O_FACT-base) then do:
                  assign
                    v-normal-wastage-base = (O_PKH-base - O_FACT-base)
                    v-normal-wastage-cli  = v-normal-wastage-base * v-normal-wastage-dens
                  .
                end.
              end.
              assign
                v-normal-wastage = v-normal-wastage-base
              .
            end.

            assign
              v-wastage-qnty-base = v-normal-wastage-base
              v-wastage-qnty-cli  = v-normal-wastage-cli
            .

            case ptrlprop-algrvspt :
              when 1 then do:
                if (O_PKH - O_FACT) - v-metering-error - v-normal-wastage <= 0 then do:
                  /* все укладывается в погрешность + естественная убыль */
                  assign
                    v-rsrv-qnty          = 0.0
                    v-metering-qnty-base = v-metering-error-base
                    v-metering-qnty-cli  = v-metering-error-cli
                  .
                  if v-normal-wastage > 0 then do:
                    if (O_PKH - O_FACT) - v-metering-error > 0 then do:
                      /* в погрешность не укладывается, поэтому учитываем естественную убыль */
                      if v-normal-wastage > (O_PKH - O_FACT) - v-metering-error then do:
                        /* уменьшим естественную убыль, чтобы дельта РКН и ФАКТ была равна погрешности измерения */
                        if ptrlprop-expptrl = {&calc-petrol-weight} then do:
                          assign
                            v-normal-wastage-cli  = (O_PKH-cli - O_FACT-cli) - v-metering-error-cli
                            v-normal-wastage-base = v-normal-wastage-cli / v-normal-wastage-dens
                          .
                        end.
                        else do:
                          assign
                            v-normal-wastage-base = (O_PKH-base - O_FACT-base) - v-metering-error-base
                            v-normal-wastage-cli  = v-normal-wastage-base * v-normal-wastage-dens
                          .
                        end.
                      end.
                    end.
                    else do:
                      /* все укладывается в погрешность */
                      assign
                        v-normal-wastage-cli  = 0.0
                        v-normal-wastage-base = 0.0
                      .
                    end.
                  end.
                end.
                else do:
                  /* в погрешность не укладывается, пересчитываем по алгоритму */
                  assign
                    v-rsrv-qnty          = - ( (O_PKH - O_FACT)
                                                - (if v-cre-add-docs   = true then v-normal-wastage else 0.0)
                                                - (if v-without-mt-err = true then 0.0 else v-metering-error)
                                              )
                    v-metering-qnty-base = (if v-without-mt-err = true then 0 else v-metering-error-base)
                    v-metering-qnty-cli  = (if v-without-mt-err = true then 0 else v-metering-error-cli )
                  .
                end.
              end.
              when 2 then do:
                if v-normal-wastage = (O_PKH - O_FACT) then do:
                  /* естественная убыль покрыла разницу */
                  assign
                    v-rsrv-qnty = - ( (O_PKH - O_FACT)
                                      - (if v-cre-add-docs = true then v-normal-wastage else 0.0)
                                    )
                    v-metering-qnty-base = 0.0
                    v-metering-qnty-cli  = 0.0
                  .
                end.
                else do:
                  if (O_PKH - O_FACT) - v-metering-error - v-normal-wastage <= 0 then do:
                    /* все укладывается в погрешность + естественная убыль */
                    if v-metering-error > (O_PKH - O_FACT) - v-normal-wastage  then do:
                      /* уменьшим погрешность измерения, чтобы она была не больше дельты РКН и ФАКТ с учетом ЕУ */
                      if ptrlprop-expptrl = {&calc-petrol-weight} then do:
                        assign
                          v-metering-error-cli  = (O_PKH-cli - O_FACT-cli) - v-normal-wastage-cli
                          v-metering-error-base = v-metering-error-cli / v-metering-error-dens
                          v-metering-error      = v-metering-error-cli
                        .
                      end.
                      else do:
                        assign
                          v-metering-error-base = (O_PKH-base - O_FACT-base) - v-normal-wastage-base
                          v-metering-error-cli  = v-metering-error-base * v-metering-error-dens
                          v-metering-error      = v-metering-error-base
                        .
                      end.
                    end.
                    assign
                      v-rsrv-qnty = - ( (O_PKH - O_FACT)
                                        - (if v-cre-add-docs = true then v-normal-wastage else 0.0)
                                        - v-metering-error
                                      )
                      v-metering-qnty-base = v-metering-error-base
                      v-metering-qnty-cli  = v-metering-error-cli
                    .
                  end. /* if (O_PKH - O_FACT) - v-metering-error - v-normal-wastage <= 0 then */
                  else do:
                    /* в погрешность не укладывается, пересчитываем по алгоритму */
                    assign
                      v-rsrv-qnty          = - ( (O_PKH - O_FACT)
                                                  - (if v-cre-add-docs   = true then v-normal-wastage else 0.0)
                                                  - (if v-without-mt-err = true then 0.0 else v-metering-error)
                                                )
                      v-metering-qnty-base = (if v-without-mt-err = true then 0 else v-metering-error-base)
                      v-metering-qnty-cli  = (if v-without-mt-err = true then 0 else v-metering-error-cli )
                    .
                  end.
                end.
              end.
            end case.


            if v-cre-add-docs   = true
              and v-normal-wastage-base <> 0.0
              and v-normal-wastage-cli <> 0.0
            then do:
              create tt-line-for-doc.
              assign
                tt-line-for-doc.gds-code      = buf_rvs-line.gds-code
                tt-line-for-doc.pl-code       = buf_rvs-line.pl-code
                tt-line-for-doc.fact-qnty     = v-normal-wastage-base
                tt-line-for-doc.fact-cli-qnty = v-normal-wastage-cli
              .
            end.
          end. /* недостача */

          if ptrlprop-expptrl = {&calc-petrol-weight} then do:
            /* работаем относительно килограммов */
            assign
              v-reserv-qnty-cli = v-rsrv-qnty
            .
            if varinv-set = true then do: /* установлен параметр, выставляем кол-ва по плотности */
              assign
                v-reserv-qnty-base = ( v-fact-cli-qnty + v-reserv-qnty-cli - (if v-cre-add-docs = true then v-normal-wastage-cli else 0.0)
                                      ) / buf_rvs-line.state-density - ( v-fact-qnty - (if v-cre-add-docs = true then v-normal-wastage-base else 0.0) )
              .
            end.
            else do:
              assign
                v-reserv-qnty-base = v-reserv-qnty-cli / buf_rvs-line.state-density
              .
            end.
          end.
          else do:
            assign
              v-reserv-qnty-base = v-rsrv-qnty
            .
            if varinv-set = true then do: /* установлен параметр, выставляем кол-ва по плотности */
              assign
                v-reserv-qnty-cli = ( v-fact-qnty + v-reserv-qnty-base - (if v-cre-add-docs = true then v-normal-wastage-base else 0.0)
                                    ) * buf_rvs-line.state-density - ( v-fact-cli-qnty - (if v-cre-add-docs = true then v-normal-wastage-cli else 0.0) )
              .
            end.
            else do:
              assign
                v-reserv-qnty-cli = v-reserv-qnty-base * buf_rvs-line.state-density
              .
            end.
          end.

          if v-reserv-qnty-base <> 0 then do:
            assign
              v-chg-qnty = v-reserv-qnty-base
            .
            run trg/rsrv-dtl.p
              ( input parparentproc
              , input {&rsrv-dtl_action_reserv} + "," + {&rsrv-dtl_pl-code} + "=" + string(buf_rvs-line.pl-code)
              , buffer buf_gds-dtl
              , input-output v-chg-qnty
              , input-output buf_doc-line.price-base
              , input-output buf_doc-line.price-rubl
              , input -1
              ) no-error.
            if error-status :error then do:
              message
                vss-workfile vss-revision vss-description skip
                "Ошибка резервирования." skip
                error-status:get-message(1)      skip
                error-status:get-message(2)      skip
                return-value
                view-as alert-box error.
              undo block_cre-inv, retry block_cre-inv.
            end.
            if v-chg-qnty <> v-reserv-qnty-base then do:
              message
                vss-workfile vss-revision vss-description skip
                "Не удалось произвести автоматическое резервирование на все кол-во." skip
                substitute( "Для документа инвентаризации по месту хранения &1", buf_rvs-line.pl-code ) skip
                "Инвентаризация не может быть сделана автоматически."
                view-as alert-box.
              undo block_cre-inv, retry block_cre-inv.
            end.
          end.
          if v-reserv-qnty-base <> 0
            or v-reserv-qnty-cli <> 0
          then do:
            assign
              buf_gds-dtl.fact-qnty       = buf_gds-dtl.fact-qnty       + v-reserv-qnty-base
              buf_gds-dtl.doc-qnty        = buf_gds-dtl.doc-qnty        + v-reserv-qnty-base
              buf_doc-line.doc-qnty       = buf_doc-line.doc-qnty       + v-reserv-qnty-base
              buf_doc-line.fact-qnty      = buf_doc-line.fact-qnty      + v-reserv-qnty-base
              buf_doc-line.cli-qnty       = buf_doc-line.cli-qnty       + v-reserv-qnty-cli
              buf_inv-line.wast-cli-qnty  = buf_inv-line.wast-cli-qnty  + v-reserv-qnty-cli

              buf_doc-pl.doc-qnty         = buf_doc-pl.doc-qnty         + v-reserv-qnty-base
              buf_doc-pl.cli-qnty         = buf_doc-pl.cli-qnty         + v-reserv-qnty-cli
              buf_doc-pl.rest-af-qnty     = buf_doc-pl.rest-af-qnty     + v-reserv-qnty-base
              buf_doc-pl.cli-rest-af-qnty = buf_doc-pl.cli-rest-af-qnty + v-reserv-qnty-cli
              buf_doc-pl.fact-qnty        = buf_doc-pl.doc-qnty
              buf_doc-pl.cli-doc-qnty     = buf_doc-pl.cli-qnty
              buf_doc-pl.cli-fact-qnty    = buf_doc-pl.cli-qnty
            .
          end.

          create buf_doc-line-sum .
          assign
            buf_doc-line-sum.doc-code  = v-inv-code
            buf_doc-line-sum.gds-code  = buf_rvs-line.gds-code
            buf_doc-line-sum.sum-type  = substitute( "&1&2&3&2&4", {&sum-wastage-doc}, {&delim-par}, "base":U, buf_rvs-line.pl-code )
            buf_doc-line-sum.fact-qnty = v-wastage-qnty-base
/*                buf_doc-line-sum.sale-sum-base       = varwast-sum-sale-base-line * wast-goods.normal-wastage * 0.01*/
/*                buf_doc-line-sum.sale-sum-rubl       = varwast-sum-sale-rubl-line * wast-goods.normal-wastage * 0.01*/
/*                buf_doc-line-sum.cost-sum-base       = varwast-sum-base-line      * wast-goods.normal-wastage * 0.01*/
/*                buf_doc-line-sum.cost-sum-rubl       = varwast-sum-rubl-line      * wast-goods.normal-wastage * 0.01*/
          .
          create buf_doc-line-sum .
          assign
            buf_doc-line-sum.doc-code  = v-inv-code
            buf_doc-line-sum.gds-code  = buf_rvs-line.gds-code
            buf_doc-line-sum.sum-type  = substitute( "&1&2&3&2&4", "mterr":U, {&delim-par}, "base":U, buf_rvs-line.pl-code )
            buf_doc-line-sum.fact-qnty = v-metering-qnty-base
          .
          create buf_doc-line-sum .
          assign
            buf_doc-line-sum.doc-code  = v-inv-code
            buf_doc-line-sum.gds-code  = buf_rvs-line.gds-code
            buf_doc-line-sum.sum-type  = substitute( "&1&2&3&2&4", {&sum-wastage-doc}, {&delim-par}, "cli":U, buf_rvs-line.pl-code )
            buf_doc-line-sum.fact-qnty = v-wastage-qnty-cli
          .
          create buf_doc-line-sum .
          assign
            buf_doc-line-sum.doc-code  = v-inv-code
            buf_doc-line-sum.gds-code  = buf_rvs-line.gds-code
            buf_doc-line-sum.sum-type  = substitute( "&1&2&3&2&4", "mterr":U, {&delim-par}, "cli":U, buf_rvs-line.pl-code )
            buf_doc-line-sum.fact-qnty = v-metering-qnty-cli
          .

        end. /* each buf_rvs-line */
        assign
          buf_inv-line.after-cli-qnty  = buf_inv-line.wast-cli-qnty
          buf_doc-line.doc-density     = buf_inv-line.wast-cli-qnty / buf_doc-line.doc-qnty
        .
        if buf_doc-line.doc-density = ? then do:
          assign
            buf_doc-line.doc-density = 1 / buf_goods.cli-base-rate
          .
        end.

        assign
          buf_doc-line.fact-density = buf_doc-line.doc-density
        .
      end. /* пустая шкала или отсутствие шкалы */
      else do:
        message
          "Режим инвентаризации по сверке работает только в товарах без признаков." skip
          "Откатываем создание инвентаризации."
        view-as alert-box error.
          undo block_cre-inv, retry block_cre-inv.
      end.
      { str/reclcinv.i
        "'update'":U
        recid(buf_doc-line)
        v-inv-code
        vartot-docold
        vartot-rublold
        i-total-doc-line_tot-ovold
        i-total-doc-line_fact-rublold
        i-total-doc-line_fact-baseold
        i-total-doc-line_fact-qntyold
        i-total-doc-line_doc-qntyold
        i-total-doc-line_cli-qntyold
        i-total-parts_fact-baseold
        i-total-parts_fact-rublold
        i-total-parts_fact-qntyold
        no-error
      }
      if error-status :error then do:
          undo block_cre-inv, retry block_cre-inv.
      end.
    end. /* each buf_doc-line */

    run gbl/calc-trn.p
      ( input parparentproc
      , recid( buf_trn-doc )
      ) no-error.
    if error-status :error then do:
      undo block_cre-inv, retry block_cre-inv.
    end.

    if v-cre-add-docs = true then do:

      find first tt-line-for-doc no-lock
        where tt-line-for-doc.fact-qnty > 0
        no-error.
      if available tt-line-for-doc then do:
        run doc-code in this-procedure
          ( input  "pair"
          , input  v-cntxt-obj-type
          , input  v-cntxt-obj-code
          , input  v-inv-code
          , output v-spi-code
          ) no-error.
        if error-status:error then do:
          message
            vss-workfile vss-revision vss-description skip
            "Ошибка вычисления номера документа списания." skip
            return-value skip
            trim(error-status :get-message(1))
            trim(error-status :get-message(2))
            trim(error-status :get-message(3))
            view-as alert-box error.
          undo block_cre-inv, retry block_cre-inv.
        end.
        { str/crtrndoc.i
          ?
          ?
          buf_trn-doc.base-rate
          buf_trn-doc.base-scale
          buf-add_clients.obj-code
          buf-add_clients.obj-type
          buf-add_clients.obj-name
          v-cntxt-db-num
          v-cntxt-userid
          {&percent}
          v-spi-code
          buf_trn-doc.doc-date
          {&write-off}
          no
          buf_trn-doc.host-code
          no
          buf_trn-doc.obj-code
          buf_trn-doc.obj-type
          no
          buf_trn-doc.pay-code
          "substitute( '@  Списание к документу инвентаризации &1', v-inv-code )"
          no
          "{&without-slt}"
          {&wayb}
          "{&inc-vat}"
          {&TDEDT_Spi_Vnesh}
          ?
          no-error
        }
        if error-status:error then do:
          message
            vss-workfile vss-revision vss-description skip
            substitute("Ошибка при генерации документа списания по инвентаризации &1", v-inv-code ) skip
            error-status :get-message(1) skip
            return-value skip
            view-as alert-box error .
          undo block_cre-inv, retry block_cre-inv.
        end.
        find buf-spi_trn-doc
          where buf-spi_trn-doc.doc-code = v-spi-code
          .
        assign
          buf-spi_trn-doc.shift-date = buf_trn-doc.shift-date
          buf-spi_trn-doc.shift-num  = buf_trn-doc.shift-num
          buf-spi_trn-doc.out-code   = v-inv-code
          buf-spi_trn-doc.exch-code  = buf_trn-doc.exch-code
          buf-spi_trn-doc.exch-rate  = buf_trn-doc.exch-rate
          buf-spi_trn-doc.exch-scale = buf_trn-doc.exch-scale
          buf-spi_trn-doc.print-rubl = buf_trn-doc.print-rubl
          buf-spi_trn-doc.agnt       = buf_trn-doc.agnt
          buf-spi_trn-doc.wrkr       = buf_trn-doc.wrkr
          buf-spi_trn-doc.boss       = buf_trn-doc.boss
        .

        for each tt-line-for-doc no-lock
          ,first buf_goods no-lock
          where buf_goods.gds-code = tt-line-for-doc.gds-code
           break by tt-line-for-doc.gds-code
        on error undo block_cre-inv, retry block_cre-inv
        :
          find first buf-spi_doc-line no-lock
            where buf-spi_doc-line.doc-code  = v-spi-code
              and buf-spi_doc-line.artic     = buf_goods.artic
              and buf-spi_doc-line.prod-type = buf_goods.prod-type
              and buf-spi_doc-line.prod-code = buf_goods.prod-code
            no-error .
          if not available buf-spi_doc-line then do:
            { str/adinvlin.i
              parparentproc
              v-spi-code
              buf_goods.artic
              buf_goods.prod-type
              buf_goods.prod-code
              v-recid
            }
            { gbl/termnode.i
              buf_goods.prt-root
              v-prt-root
            }
            { str/crgdsdtl.i
              buf_trn-doc.obj-code
              buf_trn-doc.obj-type
              v-spi-code
              buf_goods.artic
              buf_goods.prod-code
              buf_goods.prod-type
              v-prt-root
              yes
            }
          end.
          create buf-spi_doc-pl.
          assign
            buf-spi_doc-pl.obj-type      = buf_trn-doc.obj-type
            buf-spi_doc-pl.obj-code      = buf_trn-doc.obj-code
            buf-spi_doc-pl.pl-code       = tt-line-for-doc.pl-code
            buf-spi_doc-pl.out-code      = v-spi-code
            buf-spi_doc-pl.gds-code      = buf_goods.gds-code
            buf-spi_doc-pl.doc-qnty      = tt-line-for-doc.fact-qnty
            buf-spi_doc-pl.fact-qnty     = tt-line-for-doc.fact-qnty
            buf-spi_doc-pl.cli-qnty      = tt-line-for-doc.fact-cli-qnty
            buf-spi_doc-pl.cli-doc-qnty  = tt-line-for-doc.fact-cli-qnty
            buf-spi_doc-pl.cli-fact-qnty = tt-line-for-doc.fact-cli-qnty
          .

          find first buf-spi_gds-dtl exclusive-lock
            where buf-spi_gds-dtl.doc-code    = v-spi-code
              and buf-spi_gds-dtl.artic       = buf_goods.artic
              and buf-spi_gds-dtl.prod-type   = buf_goods.prod-type
              and buf-spi_gds-dtl.prod-code   = buf_goods.prod-code
              and buf-spi_gds-dtl.prt-code    = v-prt-root
            .
          find first buf_doc-line exclusive-lock
            where buf_doc-line.doc-code  = v-inv-code
              and buf_doc-line.artic     = buf_goods.artic
              and buf_doc-line.prod-type = buf_goods.prod-type
              and buf_doc-line.prod-code = buf_goods.prod-code
            .
          find first buf-spi_doc-line exclusive-lock
            where buf-spi_doc-line.doc-code  = v-spi-code
              and buf-spi_doc-line.artic     = buf_goods.artic
              and buf-spi_doc-line.prod-type = buf_goods.prod-type
              and buf-spi_doc-line.prod-code = buf_goods.prod-code
            .
          find first buf-spi_inv-line exclusive-lock
            where buf-spi_inv-line.doc-code  = v-spi-code
              and buf-spi_inv-line.artic     = buf_goods.artic
              and buf-spi_inv-line.prod-type = buf_goods.prod-type
              and buf-spi_inv-line.prod-code = buf_goods.prod-code
            .
          if first-of( tt-line-for-doc.gds-code ) then do:
            assign
              v-fact-qnty     = 0.0
              v-fact-cli-qnty = 0.0
            .
            for each buf_tt-line-for-doc
              where buf_tt-line-for-doc.gds-code = buf_goods.gds-code
            on error undo block_cre-inv, retry block_cre-inv
            :
              assign
                v-fact-qnty     = v-fact-qnty     + buf_tt-line-for-doc.fact-qnty
                v-fact-cli-qnty = v-fact-cli-qnty + buf_tt-line-for-doc.fact-cli-qnty
              .
            end.
            assign
              buf-spi_doc-line.doc-density   = v-fact-cli-qnty / v-fact-qnty
              buf-spi_doc-line.fact-density  = buf-spi_doc-line.doc-density
              buf-spi_doc-line.cli-base-rate = 1.0 / buf-spi_doc-line.doc-density
              buf-spi_doc-line.cli-qnty      = 0.0
              buf-spi_doc-line.doc-qnty      = 0.0
              buf-spi_doc-line.fact-qnty     = 0.0
              buf-spi_doc-line.price-rubl    = buf_doc-line.price-rubl
              buf-spi_doc-line.price-base    = buf_doc-line.price-base
              buf-spi_doc-line.price-cli     = buf_doc-line.price-cli
              buf-spi_gds-dtl.doc-qnty       = 0.0
              buf-spi_gds-dtl.fact-qnty      = 0.0
/*                buf-spi_gds-dtl.price-rubl     = buf_doc-line.price-rubl*/
/*                buf-spi_gds-dtl.price-base     = buf_doc-line.price-base*/
            .
          end.

          if tt-line-for-doc.fact-qnty <> 0 then do:
            assign
              v-chg-qnty = tt-line-for-doc.fact-qnty
            .
            run trg/rsrv-dtl.p
              ( input parparentproc
              , input {&rsrv-dtl_action_reserv} + "," + {&rsrv-dtl_pl-code} + "=" + string(tt-line-for-doc.pl-code)
              , buffer buf-spi_gds-dtl
              , input-output v-chg-qnty
              , input-output buf-spi_doc-line.price-base
              , input-output buf-spi_doc-line.price-rubl
              , input -1
              ) no-error.
            if error-status :error then do:
              message
                vss-workfile vss-revision vss-description skip
                "Ошибка резервирования." skip
                error-status:get-message(1)      skip
                error-status:get-message(2)      skip
                return-value
                view-as alert-box error.
              undo block_cre-inv, retry block_cre-inv.
            end.
            if v-chg-qnty <> tt-line-for-doc.fact-qnty then do:
              message
                vss-workfile vss-revision vss-description skip
                "Не удалось произвести автоматическое резервирование на все кол-во." skip
                substitute( "Для списания естественной убыли по месту хранения &1", tt-line-for-doc.pl-code ) skip
                "Инвентаризация не может быть сделана автоматически."
                view-as alert-box.
              undo block_cre-inv, retry block_cre-inv.
            end.
            assign
              buf-spi_gds-dtl.fact-qnty      = buf-spi_gds-dtl.fact-qnty      + tt-line-for-doc.fact-qnty
              buf-spi_gds-dtl.doc-qnty       = buf-spi_gds-dtl.doc-qnty       + tt-line-for-doc.fact-qnty
              buf-spi_doc-line.doc-qnty      = buf-spi_doc-line.doc-qnty      + tt-line-for-doc.fact-qnty
              buf-spi_doc-line.fact-qnty     = buf-spi_doc-line.fact-qnty     + tt-line-for-doc.fact-qnty
              buf-spi_doc-line.cli-qnty      = buf-spi_doc-line.cli-qnty      + tt-line-for-doc.fact-cli-qnty
              buf-spi_inv-line.wast-cli-qnty = buf-spi_inv-line.wast-cli-qnty + tt-line-for-doc.fact-cli-qnty
            .
          end.
        end.

        run gbl/calc-trn.p
          ( input parparentproc
          , recid( buf-spi_trn-doc )
          ) no-error.
        if error-status :error then do:
          undo block_cre-inv, retry block_cre-inv.
        end.

        for each buf-spi_doc-line exclusive-lock
          where buf-spi_doc-line.doc-code = v-spi-code
          ,each buf-spi_inv-line exclusive-lock
            where buf-spi_inv-line.doc-code  = buf-spi_doc-line.doc-code
              and buf-spi_inv-line.artic     = buf-spi_doc-line.artic
              and buf-spi_inv-line.prod-type = buf-spi_doc-line.prod-type
              and buf-spi_inv-line.prod-code = buf-spi_doc-line.prod-code
        on error undo block_cre-inv, retry block_cre-inv
        :
          { str/corinvln.i
            buf-spi_doc-line.doc-code
            buf-spi_doc-line.artic
            buf-spi_doc-line.prod-type
            buf-spi_doc-line.prod-code
            ?
            ?
            ?
            ?
            buf-spi_inv-line.wast-cli-qnty
            buf-spi_doc-line.fact-density
            v-recid
            no-error
          }
          if error-status :error
          then do:
            message
              "Ошибка создания топливной строки накладной." skip( 0 )
              return-value skip( 0 )
              error-status :get-message( 1 )
              view-as alert-box error .
            undo block_cre-inv, retry block_cre-inv.
          end.
        end.

        run close-doc in this-procedure
          ( input v-spi-code
          , recid( buf-spi_trn-doc )
          ) no-error.
        if error-status :error then do:
          undo block_cre-inv, retry block_cre-inv.
        end.
      end.
    end.
    /* Выводим в новый нередактируемый статус */
    assign
      buf_trn-doc.status_ = {&rvs-froze}
      buf_trn-doc.flag_   = yes
      p-docs-info         = substitute( "Документ инвентаризации &1", v-inv-code )
    .
    if available buf-spi_trn-doc then do:
      assign
        buf-spi_trn-doc.status_ = {&rvs-froze}
        buf-spi_trn-doc.flag_   = yes
        p-docs-info = p-docs-info + {&new-line} + substitute( "Документ списания &1", v-spi-code )
      .
    end.
  end. /* block_cre-inv transaction */
  for each tt-line-for-doc
  on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( 1 ) )
  :
    delete tt-line-for-doc .
  end.
end. /* создание документа инвентаризации */

procedure close-doc :
  define input  parameter p-doc-code  like ub.trn-doc.doc-code no-undo .
  define input  parameter p-doc-recid as   recid               no-undo .

  do
  on error  undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message ( error-status :num-messages ) )
  on stop   undo, return error substitute( "&1. stop", vss-workfile )
  on endkey undo, return error substitute( "&1. endkey", vss-workfile )
  :
    define variable varchg-inv as logical no-undo.

    run str/trn-stat.p
      ( input parparentproc
        ,input this-procedure
        ,input {&close-doc}
        ,input p-doc-code
        ,input ?
        ,input v-cntxt-db-num
        ,input ?
        ,input ?
        ,input ?
        ,input ?
        ,input yes
        ,output varchg-inv
        ,output table gds-list
      ) no-error.
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        substitute( "Ошибка при переводе документа &1 из статуса накл- в накл+.", p-doc-code ) skip
        return-value skip
        trim(error-status :get-message(1))
        trim(error-status :get-message(2))
        trim(error-status :get-message(3))
        trim(error-status :get-message(4))
        trim(error-status :get-message(5)) skip
        view-as alert-box error.
      undo, return error return-value .
    end.
    /* инвентаризация накл+ - разр+ */
    run str/trn-stat.p
      ( input parparentproc
        ,input this-procedure
        ,input {&close-doc}
        ,input p-doc-code
        ,input ?
        ,input v-cntxt-db-num
        ,input ?
        ,input ?
        ,input ?
        ,input ?
        ,input yes
        ,output varchg-inv
        ,output table gds-list
      ) no-error.
    if error-status :error then do:
      message
        vss-workfile vss-revision vss-description skip
        substitute( "Ошибка при переводе документа &1 из статуса накл+ в разр+.", p-doc-code ) skip
        return-value skip
        trim(error-status :get-message(1))
        trim(error-status :get-message(2))
        trim(error-status :get-message(3))
        trim(error-status :get-message(4))
        trim(error-status :get-message(5)) skip
        view-as alert-box error.
      undo, return error return-value .
    end.
    run gbl/calc-trn.p
      ( input parparentproc
       ,input p-doc-recid
      ) no-error.
  end.

end procedure. /* close-doc */

/* $Workfile$ e n d */