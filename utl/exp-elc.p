/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт данных в систему Элкос-Талон

Автор: Хныкин Павел Андреевич
Дата создания: 07/11/07
Author: Pavel Khnykin
Creation date: 07/11/07

*/
define input  parameter parparentproc   as handle    no-undo .
define input  parameter p-date-start    as date      no-undo .
define input  parameter p-date-end      as date      no-undo .
define input  parameter p-cash-pay-type as integer   no-undo .
define input  parameter p-recid-list    as character no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экспорт данных в систему Элкос-Талон".
{ cmp/vssrevis.i                  }
{ cmp/str-glbl.i                  }
{ cmp/r-pril.i                    }
{ cmp/r-page1.i                   }
{ cmp/library.i                   }
{ gbl/clntattr.i                  }
{ rep/cpapcep.i " "               }
{ rep/real-2df.i " " treal-2 bge  }
{ rep/real3tmp.i bge              }
{ rep/realg3df.i " " treal-3 bge  }
{ rep/real-4df.i " " treal-4 bge  }
{ rep/real-2cr.i treal-2 bge      }
{ rep/realg3cr.i treal-3 bge      }
{ rep/real-4cr.i treal-4 bge      }
{ str/lib-trn.i                   }
{ str/valddnst.i def              }
{ rep/r-paychk.i def    bge       }
{ rep/r-paychk.i defvar bge       }
{ gbl/key-rec.i                   }
{ ref/extclass.i                  }
{ gbl/cur-time.i                  }
{ gbl/waitfram.i                  }

&scop error-log-file "for_elcos.err":U
&scop export-file "for-elcos.txt":U
&scop log-file "for-elcos.log":U

&scop export-field-delim ";":U

&scop dot-char ".":U
&scop semicolon-char ";":U

&scop gds-type-fuel 1
&scop gds-type-goods 2
&scop gds-type-service 3

define temp-table tt-cash-pay no-undo like ub.cash-pay .

define temp-table tt-treal no-undo like treal-2
  field gds-type as integer
index p is primary unique
        gds-type
        gds-code
        pay-desk
        cpay-code
        curr-code
        prefix
        is-pay DESCENDING
.


define temp-table tt-export no-undo
  field cli-code  as integer
  field chk-date  as date
  field cli-name  as character
  field gds-code  like ub.goods.gds-code
  field azk-num   as integer
  field gds-name  as character
  field gds-qnty  as decimal
  field sum       as decimal
  field chk-code like ub.chk-doc.doc-code
index pi
    cli-code
    chk-date
    azk-num
    gds-code
index exp
    cli-name
    chk-date
.

define temp-table tt-clients no-undo
  field obj-type like ub.clients.obj-type
  field obj-code like ub.clients.obj-code
  field obj-name like ub.clients.obj-name
index pi is primary unique
  obj-type
  obj-code
index obj-name
  obj-name
.

/*DEFINE BUFFER b-treal-2         for treal-2.*/
/*DEFINE BUFFER b-treal-3         for treal-3.*/
/*DEFINE BUFFER b-treal-4         for treal-4.*/
/*DEFINE BUFFER b2-treal-2        for treal-2.*/
/*DEFINE BUFFER b2-treal-3        for treal-3.*/
/*DEFINE BUFFER b2-treal-4        for treal-4.*/
/*DEFINE BUFFER b3-treal-2        for treal-2.*/
/*DEFINE BUFFER b3-treal-3        for treal-3.*/
/*DEFINE BUFFER b3-treal-4        for treal-4.*/
/*define buffer buf_temp-cpa-pcep for temp-cpa-pcep.*/
define buffer buf_inkas         for ub.inkas .
define buffer buf_cash-pay      for ub.cash-pay .
define buffer buf_chk-doc       for ub.chk-doc .

{ rep/real-2cr.i b2-treal-2 bge }
{ rep/realg3cr.i b2-treal-3 bge }
{ rep/real-4cr.i b2-treal-4 bge }

define stream error-log .
define stream out-stream .
define stream log-stream .

/*закодировано какие листы печатаем в отчете*/
define variable sheet2      as logical no-undo initial yes .
define variable sheet3      as logical no-undo initial yes .
define variable sheet4      as logical no-undo initial yes .
define variable pclassify   as logical no-undo initial no .
define variable pselectgood as logical no-undo initial no .


define variable no-exch         as logical   no-undo . /*если все в р у б л я х то курс пересчета 1 к базовой валюте */
define variable no-exch-rubl    as logical   no-undo . /*если r-b- base  и base-code <> 0 то курс пересчета <> 1*/
define variable v-curr-r-b      as character no-undo .
define variable v-obj-exp-code  as integer   no-undo .
define variable v-err-exist     as logical   no-undo . /* флаг устанавливается если не был найден код
                                                          клиента для экспорта в систему ЭЛКОС-ТАЛОН */
define variable v-filename      as character no-undo .
define variable v-lines-num-exported as integer   no-undo .

do on error undo, return error return-value :

  assign
    v-filename = search({&export-file})
  .
  if v-filename <> ? then do:
    message
      "Уже есть файл " v-filename skip
    view-as alert-box error.
    undo , return error.
  end.

  run waitfram-show in this-procedure ("Ждите...").
  { gbl/curr-r-b.i v-curr-r-b }

  /*run clear-treal in this-procedure .*/
  run clear-all in this-procedure .
  run fill-tt-cash-pay in this-procedure .
  /*соберем данные*/
  _obj-list:
  for each obj-list no-lock:
    run waitfram-show in this-procedure ("Обработка чеков по объекту  " + obj-list.obj-name ).
    run find-azs-export-code in this-procedure ( input obj-list.obj-type
                                               , input obj-list.obj-code
                                               , output v-obj-exp-code
                                               ) .
    /* Если по объекту не найден код экспорта, то пропускаем такой объект */
    if v-obj-exp-code = ? then next _obj-list.
    for each buf_inkas no-lock
        where buf_inkas.doc-date  >= p-date-start
          and buf_inkas.doc-date  <= p-date-end
          and buf_inkas.obj-type   = obj-list.obj-type
          and buf_inkas.obj-code   = obj-list.obj-code
          and buf_inkas.status_    = {&fact}
    :
      run process-inkas in this-procedure ( input buf_inkas.inkas-code ).
    end. /* for each buf_inkas no-lock */
  end. /*for each obj-list*/
  run waitfram-show in this-procedure ("Запись данных в файл...").
  run export-data in this-procedure .
  run clear-all in this-procedure .
  run waitfram-hide in this-procedure .
  message
    "Экспорт завершен! " skip
    v-lines-num-exported " строк экспортировано" skip
    string( if v-err-exist then "Обнаруженые ошибки выведены в файл " + {&error-log-file} else "")
  view-as alert-box information.

end.


/* ======================================================================== */
procedure process-inkas :

define input  parameter p-inkas-code like ub.inkas.inkas-code no-undo .


define buffer buf_temp-cpa-pcep for temp-cpa-pcep.
define buffer buf_inkas         for ub.inkas.
define buffer buf_dis-card      for ub.dis-card.
define buffer buf_clients       for ub.clients.
define buffer buf_goods         for ub.goods.

define variable kk          as integer no-undo. /*текущая позиция в полученном списке товаров*/
define variable jj          as integer no-undo. /*текущая позиция в полученном списке товаров*/
define variable jjp         as integer no-undo. /*текущая позиция в полученном списке товаров*/
define variable jjo         as integer no-undo. /*текущая позиция в полученном списке товаров*/
define variable pay-sum     as decimal no-undo. /*сумма неразбросанного*/
define variable dop-sump    as decimal no-undo. /*сумма неразбросанной текущей оплаты*/
define variable dop-sumg    as decimal no-undo. /*сумма неразбросанного текцщего товара*/
define variable dop-sumk    as decimal no-undo. /*квант товар-оплата*/
define variable exch        as decimal no-undo. /*курс платежа*/
define variable exch-rubl   as decimal no-undo. /*курс платежа*/
define variable v-density   as decimal no-undo.
define variable v-line-num  as integer no-undo .
define variable v-pay-desk  like ub.chk-doc.pay-desk  no-undo .
define variable v-pay-card  like ub.chk-pay.pay-card  no-undo .
define variable v-base-code like ub.sysconf.base-code no-undo .
define variable p-by-pay-desk         as logical no-undo initial no .
define variable p-by-pay-card-prefix  as logical no-undo initial no .

define variable v-cli-export-code     as integer   no-undo .

do
on error undo, return error return-value
:
  find first buf_inkas no-lock where
             buf_inkas.inkas-code = p-inkas-code.

  { gbl/basecode.i buf_inkas.host-code v-base-code }
  if v-curr-r-b = {&r-b-base} or
  v-base-code = 0 then NO-exch = yes.
  else No-exch = no.
  if v-curr-r-b = {&r-b-rubl} or
  v-base-code = 0 then NO-exch-rubl = yes.
  else No-exch-rubl = no.
  assign
    v-pay-desk = 0
  .


  _chk-doc:
  for each ub.chk-doc no-lock where
          ub.chk-doc.obj-type = buf_inkas.obj-type and
          ub.chk-doc.obj-code = buf_inkas.obj-code and
          ub.chk-doc.out-code = p-inkas-code       and
          ub.chk-doc.d-card   <> ""
  :
    if lookup(string(ub.chk-doc.chk-type), {&no-sale-receipt-codes}) > 0 then next _chk-doc.
/*    run clear-treal in this-procedure .*/
    for each temp-chk-gds:
      delete temp-chk-gds.
    end.

    find first buf_dis-card no-lock
      where buf_dis-card.d-card = ub.chk-doc.d-card
    no-error .
    if available buf_dis-card then do:
      find first buf_clients no-lock
        where buf_clients.obj-type = buf_dis-card.cli-type
          and buf_clients.obj-code = buf_dis-card.cli-code
      no-error .
      if available buf_clients then do:
        run find-cli-export-code in this-procedure ( input buf_clients.obj-type
                                                   , input buf_clients.obj-code
                                                   , output v-cli-export-code
                                                   ) .
        if v-cli-export-code = ? then next _chk-doc.
      end.
      else do:
        next _chk-doc.
      end.
    end.
    else do:
      next _chk-doc.
    end.

    for each ub.chk-pay no-lock where
            ub.chk-pay.doc-code = ub.chk-doc.doc-code
      break
      by chk-pay.doc-code
      by chk-pay.line-num
    :
      { rep/r-paychk.i bge }
    end.
    /* собираем по оплатам */

&scop treal-calc for each treal-~{~&treal-tbl-num~}~,~
        first tt-cash-pay~
          where treal-~{&treal-tbl-num~}~.cpay-code = tt-cash-pay.cdpay-code~
            and treal-~{&treal-tbl-num~}~.curr-code  = tt-cash-pay.curr-code~
    break by treal-~{&treal-tbl-num~}~.gds-code~
    :~
      if first-of( treal-~{&treal-tbl-num~}~.gds-code ) then do:~
        find first tt-export~
          where tt-export.cli-code = v-cli-export-code~
            and tt-export.chk-date = ub.chk-doc.chk-date~
            and tt-export.azk-num  = v-obj-exp-code~
            and tt-export.gds-code = treal-~{&treal-tbl-num~}~.gds-code~
        no-error .~
        if not available tt-export then do:~
          find first buf_goods no-lock where buf_goods.gds-code = treal-~{&treal-tbl-num~}~.gds-code no-error .~
          create tt-export.~
          assign~
            tt-export.cli-code = v-cli-export-code~
            tt-export.chk-date = ub.chk-doc.chk-date~
            tt-export.azk-num  = v-obj-exp-code~
            tt-export.gds-code = treal-~{&treal-tbl-num~}~.gds-code~
            tt-export.cli-name = buf_clients.obj-name~
            tt-export.gds-name = if available buf_goods then buf_goods.gds-name else ""~
            tt-export.chk-code = ub.chk-doc.doc-code~
          .~
        end.~
      end. /* if first-of( treal-~{&treal-tbl-num~}.gds-code ) */~
      assign~
        tt-export.gds-qnty  = tt-export.gds-qnty  + treal-~{&treal-tbl-num~}~.qnty1~
        tt-export.sum       = tt-export.sum       + treal-~{&treal-tbl-num~}~.netto-rubl~
      .~
    end. /* for each treal-~{&treal-tbl-num~} */
    find first treal-2 no-error .
    if available treal-2 then do :
    end.
    find first treal-3 no-error .
    if available treal-3 then do :
    end.
    find first treal-4 no-error .
    if available treal-4 then do :
    end.

    &scop treal-tbl-num 2
    {&treal-calc}
    &scop treal-tbl-num 3
    {&treal-calc}
    &scop treal-tbl-num 4
    {&treal-calc}
  end. /* _chk-doc: */
end.

end procedure. /* process-inkas */


/* ======================================================================== */
procedure fill-tt-cash-pay :

define buffer buf_tt-cash-pay for tt-cash-pay.
define buffer buf_cash-pay    for ub.cash-pay.

define variable v-num as integer   no-undo .
define variable v-i   as integer   no-undo .

do
on error undo, return error return-value
:

  case p-cash-pay-type :
    when 1 then do:
      for each buf_cash-pay no-lock :
          create buf_tt-cash-pay.
          buffer-copy buf_cash-pay to buf_tt-cash-pay.
      end.
    end.
    when 2 then do:
      assign
        v-num = num-entries(p-recid-list)
      .
      do v-i = 1 to v-num :
        find first buf_cash-pay no-lock
          where recid(buf_cash-pay) = integer( entry( v-i , p-recid-list ) )
        no-error.
        if available buf_cash-pay then do:
          create buf_tt-cash-pay.
          buffer-copy buf_cash-pay to buf_tt-cash-pay.
        end.

      end.
    end. /* when 2 */
    otherwise do:
      message
        "Недопустимое значение параметра з-cash-pay-type = " p-cash-pay-type
      view-as alert-box error.
      undo, return error.
    end.
  end case.


end.

end procedure. /* fill-tt-cash-pay */


/* ======================================================================== */
procedure clear-treal :

do
on error undo, return error return-value
:
  for each treal-2:
    delete treal-2.
  end.

  for each treal-3:
    delete treal-3.
  end.
  for each treal-4:
    delete treal-4.
  end.

end.

end procedure. /* clear-treal */


/* ======================================================================== */
procedure clear-all :

do
on error undo, return error return-value
:

  empty temp-table tt-cash-pay.
  empty temp-table tt-export.
  empty temp-table tt-clients.
  run clear-treal in this-procedure .
end.

end procedure. /* clear-all */


/* ======================================================================== */
procedure find-cli-export-code :

define input  parameter p-obj-type      like ub.clients.obj-type no-undo .
define input  parameter p-obj-code      like ub.clients.obj-code no-undo .
define output parameter p-cli-exp-code  as integer              no-undo .

define buffer buf_ext-classif for ub.ext-classif.
define buffer buf_clients     for ub.clients.

define variable v-rowid     as rowid                  no-undo.
define variable v-tbl-name  as character              no-undo.
define variable v-obj-type  like ub.clients.obj-type  no-undo .
define variable v-obj-code  like ub.clients.obj-code  no-undo .

do
on error undo, return error return-value
:
  for each buf_ext-classif no-lock
    where buf_ext-classif.classif-subject = {&table_clients}
      and buf_ext-classif.classif-name    = {&extclass_clients_elcos}
      and buf_ext-classif.db-num          = - 1
  :
    run gen-row-keyr in this-procedure ( input buf_ext-classif.uniq-key-rec
                                       , input ?
                                       , input "ub"
                                       , input ? /*p-bh-handle*/
                                       , input no-lock
                                       , output v-rowid
                                       , output v-tbl-name
                                       ) no-error.
    if error-status :error then do:
      message
        error-status :get-message(1)
      view-as alert-box error.
    end.
    find first buf_clients no-lock where rowid(buf_clients) = v-rowid no-error .
    if available buf_clients then do:
      if buf_clients.obj-type = p-obj-type and buf_clients.obj-code = p-obj-code
      then do:
        assign
          p-cli-exp-code = buf_ext-classif.Key#_One
        .
        return.
      end.
    end.
  end.
  find first tt-clients
    where tt-clients.obj-type = p-obj-type
      and tt-clients.obj-code = p-obj-code
  no-error .
  if not available tt-clients then do:
    find first buf_clients no-lock
      where buf_clients.obj-type = p-obj-type
        and buf_clients.obj-code = p-obj-code
    no-error .
    if available buf_clients then do:
      create tt-clients.
      assign
        tt-clients.obj-type = p-obj-type
        tt-clients.obj-code = p-obj-code
        tt-clients.obj-name = buf_clients.obj-name
      .
    end.
    else do :
      message
        substitute("Не найден контрагент obj-type = '&1', obj-code = '&2'" , p-obj-type, p-obj-code )
      view-as alert-box error.
    end.
  end.
end.

end procedure. /* find-cli-export-code */
/* ======================================================================== */
procedure find-azs-export-code :

define input  parameter p-obj-type      like ub.clients.obj-type no-undo .
define input  parameter p-obj-code      like ub.clients.obj-code no-undo .
define output parameter p-cli-exp-code  as integer              no-undo .

do
on error undo, return error return-value
:
        assign
          p-cli-exp-code = p-obj-code
        .

end.

end procedure. /* find-cli-export-code */


procedure export-data :

do
on error undo, return error return-value
:
  output stream out-stream to value({&export-file}) .
  /*output stream log-stream to value({&log-file}) .*/
  for each tt-export
    by tt-export.cli-name
    by tt-export.chk-date
  :
    /*export stream log-stream tt-export.*/
    put stream out-stream unformatted
      tt-export.cli-code                                                  {&export-field-delim}
      string( tt-export.chk-date , "99.99.9999" )                         {&export-field-delim}
      replace( tt-export.cli-name , {&semicolon-char} , {&comma-char} )   {&export-field-delim}
      tt-export.azk-num                                                   {&export-field-delim}
      replace( tt-export.gds-name , {&semicolon-char} , {&comma-char} )   {&export-field-delim}
      replace( string(tt-export.gds-qnty) , {&dot-char} , {&comma-char} ) {&export-field-delim}
      replace( string(tt-export.sum)      , {&dot-char} , {&comma-char} )
      skip
    .
    assign
      v-lines-num-exported = v-lines-num-exported + 1
    .
  end.
  output stream out-stream close.
  /*output stream log-stream close.*/

  output stream error-log to value ({&error-log-file}) append.
  for each tt-clients
  :
    if v-err-exist = no then do:
      put stream error-log unformatted skip fill( '=' , 60 ) skip
                                        string( today , "99/99/9999") + ' ' + string( time , "hh:mm:ss") skip
                                        fill( '=' , 60 ) skip
      .
      assign
        v-err-exist = yes
      .
    end.
    put stream error-log unformatted "Не найден атрибут клиента ":U tt-clients.obj-type
                                     " " tt-clients.obj-code
                                     " " tt-clients.obj-name
                                     " для экспорта в систему ЭЛКОС-Талон" skip.
  end.
  output stream error-log close.
end.

end procedure. /* export-data */