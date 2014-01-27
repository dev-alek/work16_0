/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Списки таблиц по типам маршрутизации

Автор: Бахтадзе Наталья Викторовна
Дата создания: 01/07/07
Author: Bakhtadze Natalya
Creation date: 01/07/07

*/

&scoped-define vssseq {&sequence}
define variable vss-include-info{&vssseq} as character format "x(65)" no-undo initial "@(#)$Workfile$ $Revision$".

/*
из ГБД в УБД  и только если не СПН  - НЕ ходят транзитом  УБД1-ГБД-УБД2

if g#db-num = 0 and not g#news then do:
  assign list-db-for-send = list-remote-db-wsd .
 end.
*/

define variable v-0-rdb-not-news as character no-undo initial
"sysconf~
,dis-card-type~
,dis-card-type-attr~
,prop-ref~
,prop-ref-call~
,prop-head~
,c-prop-head~
,prop-ruleset~
,prop-map~
,dis-card-mask~
,curr-accnt~
,curr-bank~
,c-curr-bank~
,currency~
,c-currency~
,pay-type~
,c-pay-type~
,shop~
,store~
,tare~
,c-tare~
,units~
,c-units~
,cli-grp~
,c-cli-grp~
,gds-prt~
,c-gds-prt~
,gds-grp~
,c-gds-grp~
,c-gds-grp-hist~
,cash-pay~
,c-cash-pay~
,cash-pay-attr~
,c-cash-pay-attr~
,wealth~
,wth-par~
,wth-gds~
,country~
,c-country~
,tax~
,c-tax~
,tax-rate~
,c-tax-rate~
,tax-rate-gds-grp~
,c-tax-rate-gds-grp~
,gds-grp-attr~
,c-gds-grp-attr~
,gds-grp-obj~
,c-gds-grp-obj~
,tax-units~
,c-tax-units~
,sum-grp~
,c-sum-grp~
,auto-tank~
,auto-tank-meas~
,c-auto-tank~
,parts-attr~
,group-period-validity~
,c-group-period-validity~
,condition-keeping~
,c-condition-keeping~
,delivery-type~
,c-delivery-type~
,delivery-subject~
,c-delivery-subject~
,delivery-type-subject~
,c-delivery-type-subject~
,deliv-type-cond-keep~
,c-deliv-type-cond-keep~
,variant-delivery~
,c-variant-delivery~
,var-deliv-gr-per-val~
,c-var-deliv-gr-per-val~
,trn-reason~
,trn-rsn-attr~
,trn-reason-obj~
,trn-reason-host~
,global-state~
,rule~
,ruleset~
,ruledict~
,c-ruledict~
,ruledict-param~
,rule-profile~
,profile-by-profile~
,rule-process~
,rp-rule-param~
,rule-by-profile~
,rp-by-call~
,rule-by-set~
,rule-call-param~
,prop-script~
,pscript-ruleset~
,rule-by-call~
,dis-cfg-rule~
,drt-prop~
,attr-prop~
,alc-type~
,c-alc-type~
,alc-type-attr~
,c-alc-type-attr~
,alc-type-gds~
,c-alc-type-gds~
,custom-labels~
,stop-list~
,layout-elem~
,wi-mode~
,cd-events~
,cd-events-attr~
,cd-video-link~
,cd-video-link-attr~
":U.


/*---------------------------------------------------------------------------------------------*/


/* отдельный блок т.к. только из ГБД но и во время работы новостей  - ХОДЯТ ТРАНЗИТОМ УБД1-ГБД-УБД2*/
/*
if g#db-num = 0 then do: /* Если БД центральная, то  разослать  во все удаленные базы  */
  assign list-db-for-send = list-remote-db-wsd.
end.
*/

define variable v-0-rdb-and-from-news as character no-undo initial
"code-range~
,dis-card~
,dis-host":U
.

/*---------------------------------------------------------------------------------------------*/

/*
из УБД в ГБД  и только если не СПН

if  g#db-num <> 0 and not g#news then do :
  assign list-db-for-send = "0" .
end.
*/

define variable v-rdb-0-not-news as character no-undo initial
"db-info~
,fbr-doc
,c-fbr-doc~
,fin-ob~
,c-fin-ob~
,fin-ob-before~
,fin-connect~
,fin-statement~
,c-fin-statement~
,fin-statement-attr~
,c-fin-statement-attr~
,edi-status~
,esys-pck-sent~
,esys-pck-rcvd~
,pump~
,c-pmp-hist~
,c-pump~
,pump-attr~
,c-pump-attr~
,place~
,place-attr~
,c-place-attr~
,c-plc-hist~
,c-place~
,wth-place~
,c-wth-place~
,pl-gds~
,c-pl-gds~
,pl-gds-attr~
,c-pl-gds-attr~
,pl-pump~
,c-pl-pump~
,pl-gds-pump~
,c-pl-gds-pump~
,nozzle~
,c-nzl-hist~
,c-nozzle~
,nozzle-attr~
,c-nozzle-attr~
,pump-nozzle~
,c-pump-nozzle~
,pl-pump-nozzle~
,c-pl-pump-nozzle~
,obj-date~
,shift-obj~
,c-shift-obj~
,sum-grp-obj~
,c-sum-grp-obj~
,cshr-month~
,cash-desk~
,c-cash-desk~
,nws-doc-hist~
,fbr-prn~
,c-fbr-prn~
,fbr-prn-grp~
,c-fbr-prn-grp~
,fbr-prn-gds~
,c-fbr-prn-gds~
,fbr-gds-grp~
,fbr-gds-grp-attr~
,c-fbr-gds-grp-hist~
,c-fbr-gds-grp~
,c-fbr-gds-grp-attr~
,arh-fin-doc-an~
,arh-fin-doc-an-nal~
,arh-fin-doc-contr-schet~
,arh-fin-doc-contr-schet-nal~
,arh-fin-doc-contr-schet-tax~
,arh-fin-doc-c-schet-tax-nal~
,arh-fin-doc-schet~
,arh-fin-doc-schet-nal~
,arh-fin-doc-schet-tax~
,arh-fin-doc-schet-tax-nal~
,arh-fin-ob-contr~
,c-chk-doc~
,scales~
,scales-attr~
,scales-grp~
,scales-gds~
,c-scales-attr~
,c-scales~
,c-scales-grp~
,c-scales-gds~
,factur-connect~
,pl-level~
,c-pl-level~
,prod-bc-db~
,cd-clu~
,c-cd-clu~
,cd-doc~
,c-cd-doc~
,cd-dlu~
,c-cd-dlu~
,cd-grp~
,c-cd-grp~
,cd-plu~
,c-cd-plu~
,user-login~
,user-host~
,user-obj~
,user-context-history~
,user-login-attr~
,user-login-action-role~
,user-login-action-item~
,action-post~
,action-post-user-login~
,action-post-host~
,action-post-role~
,menu-user~
,menu-user-call~
,action-post-menu-group~
,user-menu-group~
,c-user-login~
,action-role~
,action-role-item~
,action-role-item-gds~
,action-role-item-gds-grp~
,action-post-obj~
,user-window-attr~
,rpt-option~
,c-wth-ser~
,cd-trans~
,cd-event-log~
,cd-event-log-attr~
,c-assortment-matrix-goods~
,c-gds-obj-prop~
":U.

/*---------------------------------------------------------------------------------------------*/


/* эти таблицы можно заводить где угодно */
/*
if g#db-num = 0 then do: /* Если БД центральная, то разослать во все удаленные базы */
  assign list-db-for-send = list-remote-db-wsd .
end.
if  g#db-num <> 0 and not g#news then do: /* Если БД не центральная и не новости (новости сами пришли из ГБД), послать в ГБД  */
  assign list-db-for-send = "0" .
end.
*/
define variable v-0-rdb_rbd-0-not-news as character no-undo initial
"clients~
,clients-attr~
,db~
,c-db~
,firm~
,person~
,goods~
,goods-attr~
,bar-code~
,bar-code-attr~
,prod-bc~
,sert~
,c-sert~
,tax-rate-gds~
,tax-rate-value~
,sert-join~
,gds-host-attr~
,dis-time-rule~
,c-dis-time-rule~
,season~
,gds-add-charges~
,gds-season~
,ext-system~
,ext-system-attr~
,abc-analysis~
,xyz-analysis~
,abcxyz-analysis~
,rang-abc-def~
,rang-xyz-def~
,doc-abc-def~
,doc-xyz-def~
,c-table-bind~
,criterion-analysis~
,ext-artic~
,c-ext-artic~
,ext-artic-attr~
,c-ext-artic-attr~
,ex-mark~
,c-ex-mark~
,place-io~
,c-place-io~
,point-io~
,c-point-io~
,point-place-rel~
,c-point-place-rel~
,point-point-rel~
,c-point-point-rel~
,schedule~
,schedule-attr~
,ext-classif~
,dis-thbj-rule~
,user-account~
,alc-sale-lic~
,c-alc-sale-lic~
,alc-sale-lic-attr~
,c-alc-sale-lic-attr~
,alc-sale-lic-type~
,c-alc-sale-lic-type~
,alc-supp-lic~
,c-alc-supp-lic~
,alc-supp-lic-attr~
,c-alc-supp-lic-attr~
,alc-supp-lic-type~
,c-alc-supp-lic-type~
,alc-type~
,c-alc-type~
,alc-type-attr~
,c-alc-type-attr~
,alc-type-gds~
,c-alc-type-gds~
,contract~
,c-contract~
,contract-specif~
,c-contract-specif~
,some-lk~
,who-lk~
,egais-gds~
,c-egais-gds~
,egais-clients~
,c-egais-clients~
,layout~
,assortment-matrix~
,assortment-matrix-attr~
,assortment-matrix-goods~
,c-assortment-matrix~
,gds-obj-prop~
,fin-code-cel-nazn~
,fin-code-an-uchet~
,fin-code-cor-acc~
,thbj-attr~
":U.


/*---------------------------------------------------------------------------------------------*/


/* отдельный блок т.к. рассылать надо не во все УБД , а только в те в которые идут чужие остатки*/
/*if g#db-num = 0 then do:
  assign list-db-for-send = list-remote-stock .
end.
*/

define variable v-0-remote-stock as character no-undo initial
"prt-obj~
,db-status":U.

/*---------------------------------------------------------------------------------------------*/

/*
/*из ГБД везде исключая БД источник*/
/*из УБД в ГБД*/
if g#db-num = 0 then do: /* Если БД центральная, то разослать во все удаленные базы кроме исх*/
  assign list-db-for-send = list-remote-db .
end.
if  g#db-num <> 0 and not g#news then do: /* Если БД не центральная и не новости (новости сами пришли из ГБД), послать в ГБД  */
  assign list-db-for-send = "0" .
end.
*/

define variable v-0-rdb-no-src_rdb-0-no-news as character no-undo initial
"fin-bank~
,c-fin-bank~
,fin-schet~
,c-fin-schet~
,dis-obj~
,add-doc~
,buyer-group~
,buyer-in-buyer-group~
,sum-group~
,qnty-group~
,turnover-group~
,grp-obj-price~
,c-grp-obj-price~
,turnover-buyer-main~
,price-list-type~
,upgrade~
,wth-ser~
,recipe~
,recipe-gds~
,c-recipe~
,c-recipe-gds~
,c-recipe-hist
":U.


/*---------------------для маршрутизации истории ГЛОБАЛЬНЫХ ТАБЛИЦЫ или глобального контекста */

define variable v-route-c-glob-context as character no-undo initial
"c-goods~
,c-goods-attr~
,c-prod-bc~
,c-bar-code~
,c-bar-code-attr~
,c-gds-host-attr~
,c-clients~
,c-clients-attr~
,c-firm~
,c-person~
,c-shop~
,c-store~
,c-gds-season~
,c-gds-add-charges~
,c-wth-hist~
,c-season~
,c-wealth~
,c-wth-par~
,c-wth-gds~
,c-trn-reason~
,c-trn-rsn-attr~
,c-trn-reason-obj~
,c-trn-reason-host~
,c-ext-classif~
,c-dis-thbj-rule~
,c-cli-hist~
,c-dis-cfg-rule~
,c-drt-prop~
,c-user-account~
,c-usr-hist~
,c-hist-nws-option~
":U.

/*c-cli-hist входит в глобальную ветвь потому что интересно на всех бд знать историю магазинов - а на маг и скл подавно!*/


/*-----------маршрутизация истории имеющих глобальный и объектный контекст */

define variable v-route-c-quest-context as character no-undo initial
"c-dis-card-property":U.


/*-----------маршрутизация шапок кустов истории имеющих глобальный и объектный контекст и поле is-news и поле shapka*/

define variable v-route-c-shapka-context as character no-undo initial
"c-gds-hist~
,c-tax-hist~
,c-dc-hist":U.

/*-----------маршрутизация истории сущностей, которые могут быть изменены только в ГБД*/

define variable v-route-c-only-0 as character no-undo initial
"c-dis-card~
,c-dis-host~
,c-sysconf~
,c-trn-reason-host~
,c-curr-accnt":U.

/*------------------------ответ через новости-----------------------------*/

define variable v-reply-through-news as character no-undo initial
"ext-file-par":U.

/*------------------------объектные таблицы------------------------------*/
define variable v-obj-tables as character no-undo  initial
"gds-obj~
,dis-obj~
,gds-obj-attr~
,gds-obj-prop-attr~
,fbr-gds-obj~
,varianty-delivery-gds-obj~
,curr-shop~
,price-doc~
,fbr-pln~
,rvs-doc~
,rvs-line~
,icnt-doc~
,inkas":U.

/*------------------------иcтория объектных таблиц------------------------------*/
define variable v-c-obj-tables as character no-undo  initial
"c-gds-obj-attr~
,c-gds-obj-ref~
,c-fbr-gds-obj~
,c-varianty-delivery-gds-obj~
,c-dis-obj":U.

/*------------------------иcтория объектных таблиц УПРОЩЕННАЯ ??????------------------------------*/

define variable v-c-obj-tables-todo as character no-undo  initial
"c-fbr-gds-obj~
,c-varianty-delivery-gds-obj~
,c-dis-obj~
,c-inkas~
,c-trn-doc~
,c-price-doc~
,c-fbr-pln~
,c-rvs-doc~
,c-rvs-line~
,c-wth-doc":U.

/*-----------маршрутизация истории имеющих глобальный и объектный контекст но глобальный вводится только в ГБД*/
define variable v-c-quest-context-global-only-0 as character no-undo initial
"c-bar-code-obj-attr~
,c-dis-rule~
,c-s-coeff~
,c-dis-dct-rule~
,c-dis-dc-rule~
,c-dis-cp-rule~
,c-dis-gds-rule~
,c-dis-grp-rule~
,c-dis-some-rule~
,c-thbj-attr":U.

define variable v-quest-context as character no-undo initial
"s-coeff":U.

define variable v-quest-context-todo as character no-undo initial
"":U.

/*-----------маршрутизация таблиц имеющих глобальный и объектный контекст но глобальный вводится только в ГБД*/
define variable v-quest-context-global-only-0 as character no-undo initial
"bar-code-obj-attr~
,dis-card-property~
,dis-rule~
,dis-dc-rule~
,dis-cp-rule~
,dis-dct-rule~
,dis-gds-rule~
,dis-grp-rule
,dis-some-rule~
,dis-gds-rule-attr~
":U.


/*-----------маршрутизация таблиц имеющих глобальный и объектный контекст но глобальный вводится только в ГБД и не посслается*/
/*---------------объектный посылается только в БД объекта---------------------*/
/*главная БД фирмы в будущем может быть у УБД но тогде все объекты этой фирмы должны принадлежать ЭТОЙ УБД*/
define variable v-quest-context-glob-nosend as character no-undo initial
"~
fin-doc~
,c-fin-doc~
":U.

/*-----------маршрутизация таблиц из главной БД фирмыи в ГБД*/
define variable v-main-firm-db-0-not-news as character no-undo initial
"~
arh-fin-doc-contr-schet-obj~
,arh-fin-doc-contr-s-nal-obj~
,arh-fin-doc-contr-s-tax-obj~
,arh-fin-doc-c-s-tax-nal-obj~
,arh-fin-doc-schet-obj~
,arh-fin-doc-schet-nal-obj~
":U.

/*-----------маршрутизация ГБД-УБД только не из СПН и из УБД в ГБД всегда*/

define variable v-0-rdb-not-news_rbd-0 as character no-undo initial
"db-attr~
,hist-nws-option~
,c-dis-card-type~
,c-dis-card-type-attr~
,c-dis-dct-rule~
,c-dis-card-mask~
,c-prop-ref~
,c-rp-by-call~
,c-rule-by-call~
,c-rule-call-param~
,c-layout~
,c-layout-elem~
":U.

/*-----------маршрутизация  из УБД в ГБД всегда*/

define variable v-rbd-0 as character no-undo initial
"esys-route~
,esys-all-attr~
":U.


/*-----------двусторонняя маршрутизация записей имеющих db-num*/
define variable v-db-num-tables as character no-undo initial
"config":U.

/*-----------двусторонняя  маршрутизация записей итории имеющих db-num*/
define variable v-c-db-num-tables as character no-undo initial
"c-config":U.

/*-------------маршрутизация записей привязанных не объекту а к магазину*/
define variable v-shop-tables as character no-undo  initial
"cash-desk-attr":U.

/*-------------маршрутизация записей истории привязанных не объекту а к магазину*/
define variable v-c-shop-tables as character no-undo initial
"c-cash-desk-attr":U.

/*-------------маршрутизация сложных таблицы*/
define variable v-custom-list as character no-undo initial
"blob-bind~
,blob-data~
,c-ord-doc~
,c-staff~
,c-schet-fact-doc~
,clob-bind~
,clob-data~
,doc-attr~
,gds-grp-obj-attr~
,ord-cons~
,ord-doc~
,ord-doc-rcv~
,price-all~
,price-doc-forming~
,schet-fact-doc~
,staff~
,trn-doc~
,wth-doc~
,wth-doc-attr~
,c-dis-grp-rule~
":U.

&if "{1}" = "check" &then

procedure call-nws_get-variable-names :
define output parameter p-variable-names as character no-undo .

  do
  on error undo, return error
  :
     assign
     p-variable-names = 'v-0-rdb-not-news
,v-0-rdb-and-from-news~
,v-rdb-0-not-news~
,v-0-rdb_rbd-0-not-news~
,v-0-remote-stock~
,v-0-rdb-no-src_rdb-0-no-news~
,v-route-c-glob-context~
,v-route-c-quest-context~
,v-route-c-shapka-context~
,v-route-c-only-0~
,v-reply-through-news~
,v-obj-tables~
,v-c-obj-tables~
,v-c-obj-tables-todo~
,v-c-quest-context-global-only-0~
,v-quest-context~
,v-quest-context-todo~
,v-quest-context-global-only-0~
,v-0-rdb-not-news_rbd-0~
,v-rbd-0~
,v-db-num-tables~
,v-c-db-num-tables~
,v-shop-tables~
,v-c-shop-tables~
,v-custom-list~
':U.
  end.

end procedure. /* call-nws_get-vaiable-names */

procedure call-nws_get-variable-value :
define input parameter p-variable-name as character no-undo .
define output parameter p-variable-value as character no-undo .

  do
  on error undo, return error
  :
    case p-variable-name:
      when 'v-0-rdb-not-news':U then do:
         assign
         p-variable-value = v-0-rdb-not-news
         .
      end.
      when 'v-0-rdb-and-from-news':U then do:
         assign
         p-variable-value = v-0-rdb-and-from-news
         .
      end.
      when 'v-rdb-0-not-news':U then do:
         assign
         p-variable-value = v-rdb-0-not-news
         .
      end.
      when 'v-0-rdb_rbd-0-not-news':U then do:
         assign
         p-variable-value = v-0-rdb_rbd-0-not-news
         .
      end.
      when 'v-0-remote-stock':U then do:
         assign
         p-variable-value = v-0-remote-stock
         .
      end.
      when 'v-0-rdb-no-src_rdb-0-no-news':U then do:
         assign
         p-variable-value = v-0-rdb-no-src_rdb-0-no-news
         .
      end.
      when 'v-route-c-glob-context':U then do:
         assign
         p-variable-value = v-route-c-glob-context
         .
      end.
      when 'v-route-c-quest-context':U then do:
         assign
         p-variable-value = v-route-c-quest-context
         .
      end.
      when 'v-route-c-shapka-context':U then do:
         assign
         p-variable-value = v-route-c-shapka-context
         .
      end.
      when 'v-route-c-only-0':U then do:
         assign
         p-variable-value = v-route-c-only-0
         .
      end.
      when 'v-reply-through-news':U then do:
         assign
         p-variable-value = v-reply-through-news
         .
      end.
      when 'v-obj-tables':U then do:
         assign
         p-variable-value = v-obj-tables
         .
      end.
      when 'v-c-obj-tables':U then do:
         assign
         p-variable-value = v-c-obj-tables
         .
       end.
      when 'v-c-obj-tables-todo':U then do:
         assign
         p-variable-value = v-c-obj-tables-todo
         .
      end.
      when 'v-c-quest-context-global-only-0':U then do:
         assign
         p-variable-value = v-c-quest-context-global-only-0
         .
      end.
      when 'v-quest-context':U then do:
         assign
         p-variable-value = v-quest-context
         .

      end.
      when 'v-quest-context-todo':U then do:
         assign
         p-variable-value = v-quest-context-todo
         .
      end.
      when 'v-quest-context-global-only-0':u then do:
         assign
         p-variable-value = v-quest-context-global-only-0
         .
      end.
      when 'v-0-rdb-not-news_rbd-0':U then do:
         assign
         p-variable-value = v-0-rdb-not-news_rbd-0
         .
      end.
      when 'v-rbd-0':U then do:
         assign
         p-variable-value = v-rbd-0
         .
      end.
      when 'v-db-num-tables':U then do:
         assign
         p-variable-value = v-db-num-tables
         .
      end.
      when 'v-c-db-num-tables':U then do:
         assign
         p-variable-value = v-c-db-num-tables
         .
      end.
      when 'v-shop-tables':u then do:
         assign
         p-variable-value = v-shop-tables
         .
      end.
      when 'v-c-shop-tables':U then do:
         assign
         p-variable-value = v-c-shop-tables
         .
      end.
      when 'v-custom-list':U then do:
         assign
         p-variable-value = v-custom-list
         .
      end.
    end case.
  end.

end procedure. /* call-nws_get-variable-value */
&endif

/* $Workfile$ e n d */