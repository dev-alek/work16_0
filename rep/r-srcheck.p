


/*
$Revision: $
$Author$ Shalanin Sergey
$Date$
$Workfile$
$Archive$

Средний чек


Автор: Шаланин Сергей
Дата создания: 29/05/15
Author: Shalanin Sergey
Creation date: 29/05/15
*/

/* ***************************  Definitions  ************************** */
define variable vss-revision    as character no-undo init "$Revision: ":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Средний чек".
{ cmp/vssrevis.i }

define input parameter parparentproc as widget-handle no-undo .

define input parameter p-tog-raz        as logical no-undo.
define input parameter p-tog-uchet      as logical no-undo.
define input parameter p-tog-prod      as logical no-undo.

{ rep/r-pychk0.i defalgo }
{ cmp/str-glbl.i }
{ cmp/r-page1.i }
{ cmp/r-pril.i new }
{ cmp/trg-def.i }
{ cmp/library.i  }
{ str/lib-trn.i  }
{ rep/r-sale.i   }
{ trg/factord.i  }

define variable g#report-num as integer no-undo .
define stream  macr_excel .
define stream  out-stream .

define variable v-file-name       as character no-undo .
define variable v-file-name-ind   as integer   no-undo .
define variable v-line            as character no-undo .
  { gbl/getcntxt.i def }
  { gbl/getcntxt.i get }
define variable v-cntxt-obj-name      as character no-undo .
  
define temp-table temp-chk no-undo
    field gds-code like goods.gds-code 
    field gds-name like goods.gds-name 
    field unit like goods.unit-base  /*Единица измерения*/
    field qnty as decimal   /*Количество*/
    field sum-base as decimal /*Сумма со скидкой*/
    field sum-unbase as decimal /*Сумма без скидки*/
    field doc-qnty as integer  /*Количество чеков*/
    field pok-qnty as integer     /*Количество покупок*/
    field srchk-kol-tov as decimal  /*Средний чек по количеству товара*/
    field srchk-sum as decimal  /*Средний чек по сумме без скидок / Сумма */
    field srchk-uch as decimal  /*Средний чек по сумме без скидок / Участие*/
    field srchk-base-sum as decimal   /*Средний чек по сумме со скидками / Сумма*/
    field srchk-base-uch as decimal  /*Средний чек по сумме со скидками / Участие*/
    field srchk-kol-tov-pokup as decimal  /*Средний чек по количеству покупок товара / количество покупок*/
    field srchk-kol-tov-uch as decimal   /*Средний чек по количеству покупок товара / участие*/
    field grp-code like ub.goods.grp-code init 0 /* Группа родителя (применительно к Группе товаров) */
    field grp-lvl as integer        /* Уровень группы относительный. */
    field upper-code like gds-grp.upper-code /* Группа родительская(применительно к Группе товаров) */
    field obj-code as integer
    field obj-type as char
    field obj-name as char
  fields note_ as char
  fields sales-man-psn as integer
  
  
    INDEX tt is primary gds-code  obj-code obj-type
   index tt-grp  grp-lvl  obj-type obj-code grp-code sales-man-psn
.

define temp-table help-chk no-undo

    field doc-code as char
    field group-chk as integer
    index pi is primary unique  doc-code group-chk
    .
define buffer prod-temp-chk for temp-chk. 
define buffer obj-temp-chk for temp-chk. 
  
  
  
/*  define temp-table obj-host no-undo         */
/*    field host-code like ub.sysconf.host-code*/
/*index pi is primary unique host-code.        */
  
  
define variable v-full-path-RepView as character no-undo.   /* Полный путь к файлу Просмотровщика (отчётов) */
define variable v-file-name-rep-htm as character no-undo.   /* Полный путь к файлу отчёта */

define variable v-report-name as character no-undo.         /* Наименование отчёта */
define variable v-period as character no-undo.              /* Период за который формируется отчёт */
define variable v-short-obj-list as character no-undo.      /* Перечень выбранных объектов "в одну строку" */
define variable v-choice-gds as character no-undo. /* Список выбранных товаров. Вывод - в шапке отчёта */
define variable v-choice-obj as character no-undo. /* Выбранный пользователем параметр "Выбор объекта" (в окне параметров). Вывод в шапке отчёта */


define variable v-cntxt-host-name-obj as character no-undo .
define variable v-group-chk as integer no-undo.
define variable gds-str as character no-undo init "".
define variable v-vozvrt as logical no-undo.
define variable v-razd as logical no-undo.
define variable v-qnty     as integer no-undo.
define variable v-code       as integer   no-undo .
define variable v-name          as integer   no-undo .
define variable v-unit       as character no-undo .
define variable v-object      as character no-undo .
define variable v-firm as char no-undo.
define variable v-host-code   as integer   no-undo .
define variable v-date-start  AS DATE FORMAT "99/99/9999" no-undo .
define variable v-date-end    AS DATE FORMAT "99/99/9999" no-undo .
define variable v-shift-start AS integer   no-undo .
define variable v-shift-end   AS integer   no-undo .
define variable f-prn-doc-code as character no-undo.
define variable f-payer       as character no-undo .
define variable f-corr-acc    as character no-undo .
define variable f-income      as character no-undo .
define variable f-expense     as character no-undo .
define variable v-income      as decimal   no-undo .
define variable v-expense     as decimal   no-undo .
define variable v-kolvo-chk   as integer   no-undo .
define variable v-kolvo-pokup   as decimal   no-undo .
define variable v-srchk-kol-tov as decimal   no-undo.
define variable v-srchk-sum-noskid as decimal no-undo.
define variable v-srchk-sum-skid as decimal no-undo.
define variable v-srchk-kolvo-pokup as decimal no-undo.
define variable v-sum-noskid       as decimal   no-undo .
define variable v-sum-skid      as decimal   no-undo .
define variable v-ost-begin   as decimal   no-undo .
define variable v-sum-begin   as decimal   no-undo .
define variable sum           as decimal   no-undo .
define variable sum1          as decimal   no-undo .
define variable v-tab110      as character no-undo .
define variable v-klass as char no-undo.
define variable v-tov as char no-undo.
define variable v-date-name       as character no-undo .
define variable v-num-page as character no-undo. 
define variable v-obj-code as integer.
define variable v-obj-type as char.
define variable v-obj-name as char.
define variable v-chk-doc-code as char.
define variable v-discnt as decimal.
define variable  v-sum-base as decimal.
define variable  v-sum-unbase as decimal.
define variable  v-chk-qnty as decimal.
define variable v-gds-code as integer.
define variable v-b-code as integer.
define variable tog-uchet-html as char.
define variable tog-raz-html as char.
define variable v-prod as logical.
define variable v-gds-name as char.
define variable p-grp-code as integer.
define buffer buf-qnty-temp-chk for temp-chk.

define buffer buf_shift-obj                 for ub.shift-obj .
define buffer buf_day-shift-obj             for ub.shift-obj .
define buffer buf_goods for ub.goods.
define stream OutStr-html.



define variable p-object as char.
define variable FixProdAttr as character no-undo.

define variable v-grp-code like ub.gds-grp.node-code no-undo.
define variable v-grp-name like ub.goods.grp-name no-undo.
define variable ii-grp as integer no-undo.
define variable v-found as logical no-undo.


/* ************************  Function Implementations ***************** */
function fnc-DD-MM-YYYY returns character 
(input p-dat-date as date) forward.

function fnc-convert-dot-to-colon returns character 
(input p-data as decimal, input p-accur as character) forward.


/* ***************************  Main Block  *************************** */


  run get-full-path-RepViewer(output v-full-path-RepView).   
  
run get-report-num in parParentProc(output g#report-num).

 run define-full-path-Report(input g#report-num, output v-file-name-rep-htm).

run create-file(v-file-name-rep-htm). 

v-report-name = "Отчет по среднему чеку".


run create-fill-tt-chk.


 run proc-create-HTML(       input v-file-name-rep-htm
                            ,input v-report-name
                            ,input str1
                            ,input v-choice-gds
                            ,input v-choice-obj
                            ,input tog-uchet-html
                            ,input tog-raz-html
                        ).
  run search-full-path-Report(input v-file-name-rep-htm).
run Report-Viewer(input v-full-path-RepView, input v-file-name-rep-htm).




procedure chk-calc:
    
    
  
    define input parameter p-obj-code as integer. 
    define input parameter p-obj-type as char.

 
    v-chk-doc-code= chk-doc.doc-code.
    v-prod = no. 
    
/*      message chk-gds-pay.doc-code view-as alert-box.*/
            
            
            
   _chk: for each  chk-gds-pay no-lock  where chk-gds-pay.doc-code = v-chk-doc-code 
    and  chk-gds-pay.algo-num = {&current-algo-1} ,
        first ub.bar-code where bar-code.b-code =  chk-gds-pay.b-code no-lock
        break by chk-gds-pay.b-code :
         
        v-sum-unbase = chk-gds-pay.price-base.
        v-sum-base = chk-gds-pay.tot-r-b.
        v-gds-code = bar-code.gds-code.

        find first buf_goods where buf_goods.gds-code = v-gds-code.
        p-grp-code = buf_goods.grp-code.
         
case x-SelectGood: 
        
         when {&g-choice} or
         when {&g-spis}     or
         when {&g-one}   then 
                do:
                    find  first gds-list no-lock
                        where gds-list.artic     = buf_goods.artic
                        and gds-list.prod-type = buf_goods.prod-type
                        and gds-list.prod-code = buf_goods.prod-code
                        no-error .
                        if not available gds-list then next.
                    
                end.
     
        when {&g-all}  then 
                do: /* все товары */
                end.
                
        when {&g-grp} then 
                do :
       
             assign
                        v-grp-name = ""
                        v-found = no
                    .
                   
                    _ii-grp: do ii-grp = 1 to num-entries(buf_goods.grp-name, {&delim-grp}) - 1     /* 1 */ /* где {&delim-grp} = CHR(47) = "/". Фактически это уровни вложенности данной группы товаров */
                    :
                        assign
                            v-grp-name = v-grp-name + entry(ii-grp, buf_goods.grp-name, {&delim-grp}) + {&delim-grp} /* Вытаскиваем из полной цепочки - имя каждой группы для каждого уровня. Цепочка от корня до тек группы. */
                        .
                        if can-find(first tmp#grp no-lock where
                                          tmp#grp.grp-name = v-grp-name) then
                        do:
                            assign v-found = yes.
                            leave _ii-grp.
                        end.
                    end. /* 1 */                                                                    /* 1 */

                    if not v-found then next _chk.
end.
            otherwise 
            do:     /*список товаров*/
                find  first gds-list no-lock
                    where buf_goods.artic     = gds-list.artic
                    and buf_goods.prod-type = gds-list.prod-type
                    and buf_goods.prod-code = gds-list.prod-code no-error .
                    if not available  gds-list then next.
                
            end.
end case.
                                                                                       
                    

        if p-tog-prod = no then 
        do:
            find first  temp-chk where 
                temp-chk.obj-code = p-obj-code and 
                temp-chk.obj-type = p-obj-type and            
                temp-chk.gds-code = v-gds-code  
                use-index tt no-error 
                .        
                      
 
            if not available temp-chk then
            do:
                create temp-chk.
                assign
                    temp-chk.obj-code = p-obj-code  
                    temp-chk.obj-type = p-obj-type                  
                    temp-chk.gds-code = v-gds-code .
                
                for first buf_goods where buf_goods.gds-code = v-gds-code no-lock :         
                    temp-chk.unit = buf_goods.unit-base.
                    temp-chk.gds-name =  buf_goods.gds-name.
                    temp-chk.grp-code = buf_goods.grp-code.
                    v-group-chk = buf_goods.grp-code.
                    v-gds-name = buf_goods.gds-name.
                end.
            end.
        end.
     
        if p-tog-prod = yes then 
        do: 
            find first temp-chk where 
                temp-chk.obj-code = p-obj-code and 
                temp-chk.obj-type = p-obj-type and            
                temp-chk.gds-code = v-gds-code  and
                temp-chk.grp-code = chk-doc.sales-man and
                    temp-chk.sales-man-psn = chk-doc.salesman-psn-code
                use-index tt no-error 
                .

            if not available temp-chk then 
            do:
                create temp-chk.
    
                assign    

                    temp-chk.obj-code = p-obj-code 
                    temp-chk.obj-type = p-obj-type            
                    temp-chk.gds-code = v-gds-code  
                    temp-chk.grp-code =  chk-doc.sales-man 
                    temp-chk.sales-man-psn = chk-doc.salesman-psn-code
                    .
    
                for first buf_goods where buf_goods.gds-code = v-gds-code no-lock :
                    temp-chk.gds-name = buf_goods.gds-name.
                    temp-chk.unit = buf_goods.unit-base.

                end.
            end.
        end.

        assign
      
            temp-chk.qnty       = temp-chk.qnty + chk-gds-pay.eff-doc-qnty
            temp-chk.sum-unbase = temp-chk.sum-unbase + v-sum-unbase * chk-gds-pay.eff-doc-qnty          
            temp-chk.sum-base   = temp-chk.sum-base + v-sum-base.
        temp-chk.pok-qnty   = temp-chk.pok-qnty  + (if ub.chk-doc.chk-type = integer({&rcpt-return}) then 0 else 1).
      
        obj-temp-chk.qnty       = obj-temp-chk.qnty + chk-gds-pay.eff-doc-qnty.
        obj-temp-chk.sum-unbase = obj-temp-chk.sum-unbase + v-sum-unbase  * chk-gds-pay.eff-doc-qnty.

        obj-temp-chk.pok-qnty   = obj-temp-chk.pok-qnty  + (if ub.chk-doc.chk-type = integer({&rcpt-return}) then 0 else 1).
        obj-temp-chk.sum-base   = obj-temp-chk.sum-base + v-sum-base .
     
      

         
                                                           
        if first-of(chk-gds-pay.b-code) then  
        do : 
            if not can-find(first help-chk where  help-chk.doc-code = chk-gds-pay.doc-code and 
                help-chk.group-chk = v-group-chk) then 
            do:
                create help-chk.             
                help-chk.doc-code = chk-gds-pay.doc-code.
                help-chk.group-chk = v-group-chk.
         
            end.  
            temp-chk.doc-qnty = temp-chk.doc-qnty  + (if ub.chk-doc.chk-type = integer({&rcpt-return}) then 0 else 1).
        end.
 
temp-chk.srchk-kol-tov = temp-chk.qnty / temp-chk.doc-qnty.
temp-chk.srchk-sum = temp-chk.sum-unbase / temp-chk.doc-qnty.
temp-chk.srchk-base-sum = temp-chk.sum-base / temp-chk.doc-qnty.
temp-chk.srchk-kol-tov-pokup = temp-chk.pok-qnty          / temp-chk.doc-qnty.


if p-tog-prod = yes then 
do:
    find first buf-qnty-temp-chk exclusive-lock where 
        buf-qnty-temp-chk.gds-code = 0 and 
        buf-qnty-temp-chk.obj-code = p-obj-code and 
        buf-qnty-temp-chk.obj-type = p-obj-type and                 
        buf-qnty-temp-chk.grp-code = chk-doc.sales-man and 
         buf-qnty-temp-chk.sales-man-psn = chk-doc.salesman-psn-code
        use-index tt no-error 
        .
            
    
    if not available buf-qnty-temp-chk then 
    do:
        create buf-qnty-temp-chk.
    
        assign
            buf-qnty-temp-chk.gds-code  = 0 
            buf-qnty-temp-chk.obj-code  = p-obj-code 
            buf-qnty-temp-chk.obj-type  = p-obj-type                     
            buf-qnty-temp-chk.grp-code  = chk-doc.sales-man 
            buf-qnty-temp-chk.grp-lvl   = 1
            buf-qnty-temp-chk.sales-man-psn = chk-doc.salesman-psn-code
            . 
    end.
                                     
        if v-prod = no then  buf-qnty-temp-chk.doc-qnty = buf-qnty-temp-chk.doc-qnty  + (if ub.chk-doc.chk-type = integer({&rcpt-return}) then 0 else 1).

    v-prod = yes. 
            
end.
else do:
    

  if v-prod = no then  obj-temp-chk.doc-qnty = obj-temp-chk.doc-qnty  + (if ub.chk-doc.chk-type = integer({&rcpt-return}) then 0 else 1).
    v-prod = yes. 
    
    end.

        temp-chk.srchk-kol-tov = temp-chk.qnty / temp-chk.doc-qnty.
        temp-chk.srchk-sum = temp-chk.sum-unbase / temp-chk.doc-qnty.
        temp-chk.srchk-base-sum = temp-chk.sum-base / temp-chk.doc-qnty.
        temp-chk.srchk-kol-tov-pokup = temp-chk.pok-qnty          / temp-chk.doc-qnty.
    

    
    end.  /* chk-gds-pay */



end procedure.


procedure create-fill-tt-chk:
    /* *********************** */
 if p-tog-raz = no then 
        do:

            create obj-temp-chk.
            obj-temp-chk.obj-code = 0.
            obj-temp-chk.obj-type = ''.
            obj-temp-chk.upper-code = -1.
            obj-temp-chk.gds-name = 'Итого по всем объектам'.
            obj-temp-chk.grp-code = 0. 
        end.

    for each obj-list
        :
        { gbl/hostname.i obj-list.obj-type obj-list.obj-code v-cntxt-host-code-obj v-cntxt-host-name-obj }
        if p-tog-raz = yes then 
        do:

            create obj-temp-chk.
            obj-temp-chk.obj-code = obj-list.obj-code.
            obj-temp-chk.obj-type = obj-list.obj-type.
            obj-temp-chk.gds-name = obj-list.obj-name.
             obj-temp-chk.upper-code = -1.
            obj-temp-chk.grp-code = 0. 
        end.

             run rep/rpychk0.p (input "r-shftc2"
                        ,input obj-list.obj-type
                        ,input obj-list.obj-code
                        ,input ?                    /*p-date-from*/
                        ,input ?                    /*p-date-to*/
                        ,input X-date-start         /*p-shift-date-from*/
                        ,input X-date-end           /*p-shift-date-to*/
                        ,input 0                 /*p-shift-num-start*/
                        ,input 99                /*p-shift-num-end*/
                        ,input ?                    /*p-inkas-code*/
                        ) no-error.

         if error-status:error then
         do:
             message error-status:get-message(1) view-as alert-box.
         end.

        if x-TOG-Shift = yes then
        do:  /* if x-TOG-Shift = yes */
        
        
    
    _c-d: for each ub.chk-doc where
                ub.chk-doc.obj-type = obj-list.obj-type and
                ub.chk-doc.obj-code = obj-list.obj-code and
                (ub.chk-doc.shift-date > X-date-Start or (ub.chk-doc.shift-date = X-date-Start and ub.chk-doc.shift-num >= x-Shift-Start)) and
                (ub.chk-doc.shift-date < X-date-End or (ub.chk-doc.shift-date = X-date-End and ub.chk-doc.shift-num <= x-Shift-End)) and
                ub.chk-doc.out-code <> ? and                 /* учтённые чеки */
                (ub.chk-doc.chk-type = integer({&rcpt-sale}) or ( p-tog-uchet = no and ub.chk-doc.chk-type = integer({&rcpt-return}))) /* учитываем все типы продаж и возвратов */
               
                :
                if  p-tog-raz = no then  run chk-calc ( input 0, input '').
                if p-tog-raz  = yes then run chk-calc  ( input obj-list.obj-code, input obj-list.obj-type).
            end. /* for each chk-doc */
        end. /* if x-TOG-Shift = yes */
        else
        do:  /* else if x-TOG-Shift = no */
          
      
            _c-d: for each ub.chk-doc where
                ub.chk-doc.obj-type = obj-list.obj-type and
                ub.chk-doc.obj-code = obj-list.obj-code and
                ub.chk-doc.chk-date >= X-date-Start and
                ub.chk-doc.chk-date <= X-date-End and
                ub.chk-doc.out-code <> ? and                    /* учтённые чеки */
                (ub.chk-doc.chk-type = integer({&rcpt-sale}) or ( p-tog-uchet = no and ub.chk-doc.chk-type = integer({&rcpt-return})))
           
                :
                if  p-tog-raz = no then  run chk-calc ( input 0, input '').
                if p-tog-raz  = yes then run chk-calc  ( input obj-list.obj-code, input obj-list.obj-type).
            end.
        end. /* else if x-TOG-Shift = no */
        if   p-tog-prod = no and p-tog-raz  = yes then run transform-tt-level ( input obj-list.obj-code, input obj-list.obj-type) . /* Преобразование созданной выше chk-calc в таблицу с уровнями и итогами по каждому уровню. */
        if  p-tog-prod = yes and p-tog-raz  = yes then  run prod-level ( input obj-list.obj-code, input obj-list.obj-type).
           
    end. /* for each obj-list */ 

    if p-tog-prod = no and p-tog-raz = no  then run transform-tt-level( input 0, input '').
    if p-tog-prod = yes and p-tog-raz = no  then run prod-level ( input 0, input '').




 str1 = (if X-TOG-Shift then "С " + fnc-DD-MM-YYYY(date(string(X-Date-Start,"99/99/9999"))) + ", смена № "  + string(X-Shift-Start) +
                                " по " + fnc-DD-MM-YYYY(date(string(X-Date-End,"99/99/9999"))) + ", смена № " + string(X-Shift-End)
                           else
                                "За период с " + fnc-DD-MM-YYYY(date(string(X-Date-Start,"99/99/9999"))) + " по " + fnc-DD-MM-YYYY(date(string(X-Date-End,"99/99/9999")))
    ).
    
  if X-selectGood =  {&g-choice} or
         X-selectGood = {&g-spis}     or
      X-selectGood = {&g-one} then
    do:
        v-choice-gds = "По списку товаров: ".

        for each gds-list no-lock:
            gds-str = gds-str + gds-list.gds-name + ", ".
        end.
        gds-str = right-trim( gds-str, " " ).
        gds-str = right-trim( gds-str, "," ).
        if length(gds-str) > 115 then
        do:
            v-choice-gds = (substring(gds-str, 1, 115) + "..." ).
        end.
        else
        do:
            v-choice-gds = gds-str.
        end.
/*        gds-str = "".*/
    end.
    

       
    if error-status :error then next.
   
    if length(str2) > 115 then
    do:
        
        v-choice-gds = substring(str2, 1, 115) + "...".
    end.
    else
    do:
        v-choice-gds = str2.
    end.

    str4 = replace(str4, chr(10), " "). /* Очищаем текст от служ. символов "Новая линия", пока просмотровщик RepView - не умеет передавать его в Excel */
    str4 = replace(str4, chr(13), " "). /* Очищаем текст от служ. символов "Перевод каретки". */
    str4 = replace(str4, chr(9), " "). /* Очищаем текст от служ. символов "Табуляция" */
    str4 = trim(str4, " "). /* Экран от незначащих пробелов по краям названия. */
    if length(str4) > 115 then
    do:
        v-choice-obj = substring(str4, 1, 115) + "...".
    end.
    else
    do:
        v-choice-obj = str4.
    end.

if p-tog-uchet = yes then do:
    tog-uchet-html = "Нет".
    end.
    else do:
        tog-uchet-html = "Да".
        end.
if p-tog-raz = yes then do:
    tog-raz-html = "Да".
    end.
    else do:
        tog-raz-html = "Нет".
        end.


end procedure. /* create-fill-tt-chk */
    
procedure proc-create-HTML:   
    define input parameter p-file-name-rep-htm as character no-undo.
    define input parameter p-report-name as character no-undo.
    define  input parameter  p-period-date as char no-undo. 
    define input parameter v-choice-gds as char no-undo.
    define input parameter v-choice-obj as char no-undo.
    define input parameter tog-uchet-html as char no-undo.
    define input parameter tog-raz-html as char no-undo.
 
    define buffer buf-html-temp-chk for temp-chk.

        do:  /* Системная шапка HTML */
        output stream OutStr-html to value(p-file-name-rep-htm) append convert target 'UTF-8'.
            put stream OutStr-html unformatted
                "<!DOCTYPE HTML>" skip
                ' <html>' skip
                '  <head>' skip
                '   <meta charset="utf-8">' skip
                '    <style type="text/css">' skip
                '      table ' + chr(123) + ' border-collapse: collapse; font-size: 9pt; table-layout: fixed; width: 1157px; padding: 14px; ' + chr(125) skip
                '      td ' + chr(123) ' border: 1px black ridge; word-wrap:break-word; ' + chr(125) skip
                '      htm' skip
                '      .rotate ' + chr(123) skip
                '        -webkit-transform: rotate(-90deg);' skip
                '        -moz-transform: rotate(-90deg);' skip
                '        -ms-transform: rotate(-90deg);' skip
                '        -o-transform: rotate(-90deg);' skip
                '        transform: rotate(-90deg);' skip

                
                '        -webkit-transform-origin: 50% 50%;' skip
                '        -moz-transform-origin: 50% 50%;' skip
                '        -ms-transform-origin: 50% 50%;' skip
                '        -o-transform-origin: 50% 50%;' skip
                '        transform-origin: 50% 50%;' skip


                '        filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);' skip
                '          ' + chr(125) skip
                '            th' + ' ' + chr(123) skip
                '            border: 1px black solid;' skip
                '            word-wrap: break-word;' skip
                '          ' + chr(125) skip
                '   </style>' skip
                '  </head>' skip
            .
    end. 
    
 do:  /* Параметры "глобальной" таблицы отчёта */
     put stream OutStr-html unformatted
         ' <body>' skip
         '   <table name="Лист1" fit_to_page="true" orientation="landscape" outline_below="false">' skip
         '     <thead>' skip
         '       <tr class="set_columns">' skip                          
         '         <td style="width: 60px; border: none;"></td>' skip    /*Код*/
         '         <td style="width: 200px; border: none;"></td>' skip      /*Наименование товара*/
         '         <td style="width: 78px; border: none;"></td>' skip    /* Единица измерения*/
         '         <td style="width: 78px; border: none;"></td>' skip   /*Количество*/
         '         <td style="width: 68px; border: none;"></td>' skip  /*Сумма без скидок*/
         '         <td style="width: 68px; border: none;"></td>' skip  /*Сумма со скидкой*/
         '         <td style="width: 78px; border: none;"></td>' skip  /*Количество чеков*/
         '         <td style="width: 78px; border: none;"></td>' skip  /*Количество покупок*/
         '         <td style="width: 78px; border: none;"></td>' skip   /*Средний чек по количеству товаров*/
         '         <td style="width: 68px; border: none;"></td>' skip    /*сумма*/
         '         <td style="width: 68px; border: none;"></td>' skip /*участие*/
              /*Средний чек по сумме без скидок*/
         '         <td style="width: 68px; border: none;"></td>' skip    /*сумма*/
         '         <td style="width: 68px; border: none;"></td>' skip  /*участие*/
             /*Средний чек по количеству покупок товара */
         '         <td style="width: 78px; border: none;"></td>' skip    /*количество покупок*/
         '         <td style="width: 68px; border: none;"></td>' skip /*участие*/
            
            
         '       </tr>' skip
         .
            
            end.
            /* Заполнение "глобальной" таблицы - блок шапки отчёта (часть отчёта, видимая как "не таблица") */
    do: /* b3 */
            put stream OutStr-html unformatted
            '       <tr>' skip
            '         <td colspan="15" style="border: none; height: 14px; font-size: 14pt; font-weight: bold">Отчет по среднему чеку </td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '       </tr>' skip
            
            '       <tr>' skip
            '         <td colspan="15" style="border: none; height: 14px">По фирме:  ' +    v-cntxt-host-name-obj    + '</td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '       </tr>' skip
            
            '       <tr>' skip
            '         <td colspan="15" style="border: none; height: 14px">' + v-choice-obj + '</td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip             
            '       </tr>' skip
            
            '       <tr>' skip
            '         <td colspan="15" style="border: none; height: 14px">' + p-period-date + '</td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '       </tr>' skip
                     
            '       <tr>' skip
            '         <td colspan="15" style="border: none; height: 14px">' + v-choice-gds + '</td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '       </tr>' skip
                       
            '       <tr>' skip
            '         <td colspan="15" style="border: none; height: 14px">Возвраты:  ' +  tog-uchet-html  + '</td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '       </tr>' skip
            
         
            '       <tr>' skip
            '         <td colspan="15" style="border: none; height: 14px">Раздельно по объектам:    '   + tog-raz-html '  </td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip
            '         <td style="border: none"></td>' skip                    
            '       </tr>' skip
                
                
                '     </thead>' skip
            . /* Точка для закрытия Put */
    end. /* b3 */
            
             do:  /* Шапка таблицы отчёта (видимой, как таблица) */
            put stream OutStr-html unformatted
            '     <tbody>' skip
             '       <tr style="height: 60px;">' skip
            '         <th  rowspan="2" style="background-color:#ffffcc; text-align: center;">Код</th>' skip
            '         <th  rowspan="2"   style="background-color:#ffffcc; text-align: center;">Наименование товара</th>' skip
            '         <th rowspan="2" style="background-color:#ffffcc; text-align: center;">Единица измерения</th>' skip
            '         <th rowspan="2" style="background-color:#ffffcc; text-align: center;">Количество</th>' skip
            '         <th rowspan="2" style="background-color:#ffffcc; text-align: center;">Сумма без скидок</th>' skip
            '         <th rowspan="2" style="background-color:#ffffcc; text-align: center;">Сумма со скидкой</th>' skip
            '         <th rowspan="2" style="background-color:#ffffcc; text-align: center;">Количество чеков</th>' skip
            '         <th rowspan="2" style="background-color:#ffffcc; text-align: center;">Количество покупок</th>' skip
            '         <th rowspan="2"  style="background-color:#ffffcc; text-align: center;">Средний чек по количеству товаров</th>' skip
            '         <th  colspan="2" style="background-color:#ffffcc; text-align: center;">Средний чек по сумме без скидок</th>' skip
            '         <th  colspan="2" style="background-color:#ffffcc; text-align: center;">Средний чек по сумме со скидками</th>' skip                
            '         <th  colspan="2" style="background-color:#ffffcc; text-align: center;">Средний чек по кол-ву покупок товара </th>' skip
                   
            '</tr>'   skip    
               '       <tr style="height: 45px;">' skip
            '        <th style="background-color:#ffffcc; text-align: center;">Сумма</th>' skip 
            '         <th style="background-color:#ffffcc; text-align: center;">Участие (%)</th>' skip
            '         <th style="background-color:#ffffcc; text-align: center;">Сумма</th>' skip
            '         <th style="background-color:#ffffcc; text-align: center;">Участие (%)</th>' skip             
            '         <th style="background-color:#ffffcc; text-align: center;">Количество покупок</th>' skip
            '         <th style="background-color:#ffffcc; text-align: center;">Участие (%)</th>' skip
            '</tr>'skip


                     
                     '       <tr>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">1</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">2</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">3</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">4</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">5</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">6</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">7</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">8</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">9</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">10</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">11</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">12</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">13</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">14</th>' skip
                     '         <th num="" style="background-color:#ffffcc; text-align: center">15</th>' skip
                                              
                     '       </tr>' skip.
            
            
            
            
             output stream OutStr-html close.
    end. 
    
    
                                                                                                            
    do:    
        output stream OutStr-html to value(p-file-name-rep-htm) append convert target 'UTF-8'.
        /* 
        if p-tog-raz = no then 
        do:  
            run tt-print-line (input '', input 0, input 1 , input 2). /* Доформирование групп */
        end.
if p-tog-raz = yes then do:
    */
  
            
        find first buf-html-temp-chk no-lock no-error.
        if not error-status:error and available buf-html-temp-chk then
        do:
            
            for each buf-html-temp-chk where
                buf-html-temp-chk.grp-code = 0 and buf-html-temp-chk.upper-code = -1 and buf-html-temp-chk.gds-code = 0 no-lock
                by buf-html-temp-chk.obj-type by buf-html-temp-chk.obj-code
                :
                put stream OutStr-html unformatted
                    '       <tr level="1">' skip
                    '         <td colspan="3" style="display: yes; text-align: left; font-weight: bold">' +  buf-html-temp-chk.gds-name + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'  + if buf-html-temp-chk.qnty <> ?  then fnc-convert-dot-to-colon( buf-html-temp-chk.qnty, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.sum-unbase <> ? then fnc-convert-dot-to-colon( buf-html-temp-chk.sum-unbase, "->>>>>>>9.99")   + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.sum-base <> ? then fnc-convert-dot-to-colon( buf-html-temp-chk.sum-base, "->>>>>>>9.99")  + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.doc-qnty <> ? then fnc-convert-dot-to-colon( buf-html-temp-chk.doc-qnty, "->>>>>>>9") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.pok-qnty <> ? then fnc-convert-dot-to-colon( buf-html-temp-chk.pok-qnty, "->>>>>>>9") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.srchk-kol-tov <> ?  then fnc-convert-dot-to-colon( buf-html-temp-chk.srchk-kol-tov, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                                  
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.srchk-sum <> ?  then fnc-convert-dot-to-colon( buf-html-temp-chk.srchk-sum, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.srchk-uch <> ? then  fnc-convert-dot-to-colon( buf-html-temp-chk.srchk-uch , "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
   
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if buf-html-temp-chk.srchk-base-sum <> ?  then fnc-convert-dot-to-colon( buf-html-temp-chk.srchk-base-sum, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if  buf-html-temp-chk.srchk-base-uch <> ?  then fnc-convert-dot-to-colon(  buf-html-temp-chk.srchk-base-uch, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
          
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if  buf-html-temp-chk.srchk-kol-tov-pokup <> ?  then fnc-convert-dot-to-colon(  buf-html-temp-chk.srchk-kol-tov-pokup, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align:  right; font-weight: bold">'   + if  buf-html-temp-chk.srchk-kol-tov-uch   <> ?  then fnc-convert-dot-to-colon( buf-html-temp-chk.srchk-kol-tov-uch, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '       </tr>' skip
                    .
                if p-tog-prod = yes then run tt-print-line (input buf-html-temp-chk.obj-type, input buf-html-temp-chk.obj-code, input -2 , input 2). /* Доформирование групп */
                if p-tog-prod = no then run tt-print-line (input buf-html-temp-chk.obj-type, input buf-html-temp-chk.obj-code, input 1 , input 2). /* Доформирование групп */
                
            end. 
 
        end.
   
        else /* Если отчёт пустой - выводим строку-пустышку */
        do:

            put stream OutStr-html unformatted
                '       <tr>' skip
                '         <td style="display: yes; text-align: center; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align: center; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip            
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '         <td style="display: yes; text-align:  right; font-weight: bold">'    '</td>' skip
                '       </tr>' skip
                . 
        end.
    end. /* b5 */
  /*  end.  */
          /* Заполнение подвала отчёта */
        do: 
                put stream OutStr-html unformatted
                '     </tbody>' skip
                '   </table>' skip
                '  </body>' skip
                ' </html>' skip
                . /* Точка для закрытия Put */
        output stream OutStr-html close.
    end. 
    
       end procedure.
      
      
      
      
  procedure define-full-path-Report:  /* Получение полного пути к отчёту html (input №Отчёта, output Полный_путь_имя_файла_отчHTML) */
/* Получение полного пути к отчёту html */
    define input parameter p-rep-num as integer no-undo.
    define output parameter p-file-name-rep-htm as character no-undo.

    p-file-name-rep-htm = session:temp-directory + {&DF_Name} + string(p-rep-num) + ".html".

end procedure.


procedure create-file:              /* СоздЛюбогоФайлаНаДиске(input полный_путь_с_именем) */
/* Создание пустого файла (во входном параметре: полный путь и имя файла) */
    define input parameter p-file-name as character no-undo.
    output to value(string(p-file-name)).
    output close.

end procedure.


procedure Report-Viewer:            /* Запуск на выполнение RV (input Полный_путь_имя_файла_RV, input Полный_путь_имя_файла_отчHTML) */
/* Запуск программы "Просмотровщик Отчётов" - ReportViewer. */
    define input parameter p-full-path-RepView as character no-undo.
    define input parameter p-file-name-rep-htm as character no-undo.

    os-command no-wait value(p-full-path-RepView + " " + search(p-file-name-rep-htm)).

end procedure.

procedure get-full-path-RepViewer:  /* Получение полного пути к исполняемому файлу RV.exe (output Полный_путь_имя_файла_RV.exe) */
/* Получение полного пути к exe-файлу просмотровщика отчётов */
    define output parameter p-fill-path-RepView as character no-undo.

    if search("exe\ReportViewer\reportviewer.exe") <> ? then
    do:
        p-fill-path-RepView = search("exe\ReportViewer\reportviewer.exe").
    end.
    else
    do:
        message "Не найдена программа просмотра отчёта!" view-as alert-box error.
    end.
end procedure.



procedure search-full-path-Report:  /* Только проверка, есть файл отчёта HTML или нет(тогда вывод сбщ-ош) */
/* Поиск файла */
    define input parameter p-file-name as character no-undo.

    if search(p-file-name) = ? then
        do:
            message "Не найден файл отчёта: " p-file-name view-as alert-box error.
        end.
    else
        do:
            p-file-name = search(p-file-name).
        end.

end procedure.


procedure transform-tt-level  :
    /* Трансформация плоской таблицы в таблицу с уровнями */
    /* и итогами для каждого уровня. */
    /******************************************************/
    define input parameter v-obj-code as integer.
    define input parameter v-obj-type as char.

    
    define variable v-pok-qnty     as integer   no-undo.
    define variable v-eff-doc-qnty as decimal   no-undo.
    define variable v-object-sum   as decimal   no-undo.
    define variable v-tot-r-b      as decimal   no-undo.
    define variable v-discount     as decimal   no-undo.
    define variable v-ii           as integer   no-undo.
    define variable v-gds-name     as character no-undo.
    define variable v-cur-lvl      as integer   no-undo.
    define variable v-upper-code   as integer   initial ? no-undo.
    define variable v-obj-chk as integer no-undo.
    define variable v-kk-pok-qnty  as integer   no-undo.
    define buffer buftt_temp-chk   for temp-chk.
    define buffer buf1_temp-chk    for temp-chk.
    define buffer buf2_help-chk    for help-chk.
    define buffer buf_obj_temp-chk for help-chk.
                 define buffer buftt2_temp-chk for temp-chk.
    
      do while v-upper-code <> 0:

          v-upper-code = 0.
            v-gds-name = ''.
          for each temp-chk where temp-chk.grp-lvl =  v-cur-lvl
              and temp-chk.obj-type = v-obj-type
              and  temp-chk.obj-code = v-obj-code
              and temp-chk.upper-code <> -1
              use-index tt-grp
              break by temp-chk.grp-code
              :

              v-ii = v-ii + 1.

              if first-of (temp-chk.grp-code)  then
              do:
                  assign
                      v-eff-doc-qnty = 0  /* Количество */
                      v-object-sum   = 0    /* Сумма без скидки */
                      v-tot-r-b      = 0       /* Сумма со скидкой */
                      v-discount     = 0      /* Скидка */
                      v-pok-qnty     = 0      /* Количество покупок*/
                      .
                  find first ub.gds-grp where
                      ub.gds-grp.node-code = temp-chk.grp-code no-lock no-error.
                  if available ub.gds-grp then
                  do:
                      assign
                          v-upper-code = ub.gds-grp.upper-code
                          v-gds-name   = ub.gds-grp.node-name
                          .
           
                  end.
              end.

   
              temp-chk.srchk-kol-tov-uch = temp-chk.pok-qnty * 100 / obj-temp-chk.pok-qnty.
              temp-chk.srchk-base-uch = temp-chk.sum-base * 100 /  obj-temp-chk.sum-base  .
              temp-chk.srchk-uch  = temp-chk.sum-unbase * 100 /  obj-temp-chk.sum-unbase.  
   
              temp-chk.upper-code = if  temp-chk.grp-lvl = 0 then temp-chk.grp-code else v-upper-code.
  

            if  temp-chk.grp-lvl <> 0 then
            do:
                assign
                    temp-chk.gds-name = v-gds-name
/*                    temp-chk.gds-code = string(temp-chk.grp-code) /* Вывод в подитоговой строке для ГРУПП ТОВАРОВ кода этих самых групп (1-е поле таблицы Excel) */*/
                .
            end.
  
            assign
                v-eff-doc-qnty = v-eff-doc-qnty + temp-chk.qnty  /* Количество */
                v-object-sum   = v-object-sum + temp-chk.sum-unbase        /* Сумма без скидки */
                v-tot-r-b      = v-tot-r-b + temp-chk.sum-base                 /* Сумма со скидкой */
                v-pok-qnty     = v-pok-qnty + temp-chk.pok-qnty               /* Количество покупок*/
                .
  

              if last-of (temp-chk.grp-code) and v-upper-code <> 0  then  
              do :
                
                  find first  buftt_temp-chk   where
                      buftt_temp-chk.grp-code = (if temp-chk.grp-lvl = 0 then temp-chk.grp-code else v-upper-code)
                      and buftt_temp-chk.obj-code = v-obj-code 
                      and buftt_temp-chk.obj-type = v-obj-type 
                      and    buftt_temp-chk.grp-lvl    = temp-chk.grp-lvl + 1 no-error.
                      
              
                  if  not available buftt_temp-chk then 
                  do:
                      create buftt_temp-chk .

                      assign
                          buftt_temp-chk.grp-code = (if temp-chk.grp-lvl = 0 then temp-chk.grp-code
                          else v-upper-code)                             /* Группа товара (как-бы заголовок для группы) */
                      
                          buftt_temp-chk.grp-lvl  = temp-chk.grp-lvl + 1       /* Уровень группы (относительный, как порядок следования групп: 1, 2, ...) */
                          /* Наименование uруппы товаров */
                          buftt_temp-chk.obj-type = v-obj-type
                          buftt_temp-chk.obj-code = v-obj-code
                          .
                  end.
                  assign 
                      buftt_temp-chk.qnty       =   buftt_temp-chk.qnty + v-eff-doc-qnty           /* Количество */
                      buftt_temp-chk.sum-unbase = buftt_temp-chk.sum-unbase + v-object-sum               /* Сумма без скидки */
                      buftt_temp-chk.sum-base   =   buftt_temp-chk.sum-base + v-tot-r-b                     /* Сумма со скидкой */
                      buftt_temp-chk.pok-qnty   =  buftt_temp-chk.pok-qnty + v-pok-qnty                      /* количество покупок*/
                      buftt_temp-chk.gds-name   = v-gds-name  .
                          
                  for each help-chk where help-chk.group-chk = temp-chk.grp-code :
                         
                      buftt_temp-chk.doc-qnty      = buftt_temp-chk.doc-qnty + 1.
                         
                      if not can-find(first buf2_help-chk where  buf2_help-chk.doc-code = help-chk.doc-code and 
                          buf2_help-chk.group-chk = v-upper-code) then 
                      do:
                          create buf2_help-chk.             
                          buf2_help-chk.doc-code = help-chk.doc-code.
                          buf2_help-chk.group-chk = v-upper-code.
                      end.     
                   
                  end.
      
                buftt_temp-chk.srchk-kol-tov = buftt_temp-chk.qnty / buftt_temp-chk.doc-qnty.
                buftt_temp-chk.srchk-sum     = buftt_temp-chk.sum-unbase / buftt_temp-chk.doc-qnty.
                buftt_temp-chk.srchk-base-sum = buftt_temp-chk.sum-base / buftt_temp-chk.doc-qnty.
                buftt_temp-chk.srchk-kol-tov-pokup = buftt_temp-chk.pok-qnty  / buftt_temp-chk.doc-qnty.
            end.

        end. /* temp-chk */
        
        
        
        v-cur-lvl = v-cur-lvl + 1.

    end. /* do while */
 
    for each buftt2_temp-chk where buftt2_temp-chk.grp-code <> 0  and 
        buftt2_temp-chk.gds-code = 0 : 
        for each buftt_temp-chk where buftt_temp-chk.grp-code = buftt2_temp-chk.grp-code and buftt2_temp-chk.grp-lvl <> buftt_temp-chk.grp-lvl and    buftt_temp-chk.gds-code = 0  : 
                        
                       
            assign
                buftt2_temp-chk.qnty       = buftt_temp-chk.qnty  +   buftt2_temp-chk.qnty     /* Количество */
                buftt2_temp-chk.sum-unbase = buftt_temp-chk.sum-unbase +   buftt2_temp-chk.sum-unbase              /* Сумма без скидки */
                buftt2_temp-chk.sum-base   = buftt_temp-chk.sum-base + buftt2_temp-chk.sum-base                   /* Сумма со скидкой */
                buftt2_temp-chk.pok-qnty   = buftt_temp-chk.pok-qnty  + buftt2_temp-chk.pok-qnty       .                /* количество покупок*/
            /*                      buftt_temp-chk.gds-name   = v-gds-name  .*/
                        
            delete buftt_temp-chk.   
        end.
                      
         
    end.
   
   
   
    obj-temp-chk.srchk-uch = 100 .
    obj-temp-chk.srchk-base-uch = 100.
    obj-temp-chk.srchk-kol-tov-uch = 100.
    obj-temp-chk.srchk-kol-tov       = obj-temp-chk.qnty / obj-temp-chk.doc-qnty.
    obj-temp-chk.srchk-sum           = obj-temp-chk.sum-unbase / obj-temp-chk.doc-qnty.
    obj-temp-chk.srchk-base-sum      = obj-temp-chk.sum-base / obj-temp-chk.doc-qnty.
    obj-temp-chk.srchk-kol-tov-pokup = obj-temp-chk.pok-qnty  / obj-temp-chk.doc-qnty.

end procedure.


procedure tt-print-line:
/* Вывод линий таблицы с группировкой: 1) по имени группы товаров; 2) по уровню внутри группы */
    define input parameter v-obj-type as character no-undo.
    define input parameter v-obj-code as integer no-undo.
    define input parameter v-upper-code like ub.gds-grp.upper-code no-undo.
    define input parameter v-print-lvl as integer no-undo.
define variable v-display as character no-undo.  
    define buffer buf-grp_temp-chk for temp-chk.


 

/*              run  gbl/inidebug.p.*/

    for each buf-grp_temp-chk where
        buf-grp_temp-chk.upper-code = v-upper-code and
        buf-grp_temp-chk.obj-type = v-obj-type and
        buf-grp_temp-chk.obj-code = v-obj-code
        no-lock: 
          if v-print-lvl < 3 then /* Выводим в HTML определённые уровни(p-print-lvl) - счёт с единицы и далее (1-й и 2-й ... на подобие в Excel) */
        do:  /* Выводим инфо в Веб-браузер (делаем видимой) */
            v-display = "yes".
        end. /* Выводим инфо в Веб-браузер (делаем видимой) */
        else
        do:  /* НЕ выводим инфо в Веб-браузер (инфа есть, но делаем её НЕвидимой) */
            v-display = "none".
        end.
        do:
            if buf-grp_temp-chk.grp-lvl <> 0 then /* Условие когда выбраны ГРУППЫ ТОВАРОВ (Цель - печать жирным шрифтом) */
            do:
                put stream OutStr-html unformatted
                    '       <tr level="' + string(v-print-lvl) + '">' skip
/*                   '         <td style="display: yes; text-align: right; font-weight: bold">' +  string(buf-grp_temp-chk.gds-code) + '</td>' skip*/
                    '         <td colspan = "3" style="display: yes; text-align: left; font-weight: bold ; padding-left:  ' 
                    + string((v-print-lvl - 1) * 10) + 'px">'
                    + string(fill(" ", ((v-print-lvl - 2) * 4)))
                    + buf-grp_temp-chk.gds-name       + '</td>' skip
/*                  '         <td  style="display: yes; text-align: right; font-weight: bold">'  + buf-grp_temp-chk.unit +      '</td>'  skip*/
                    '         <td style="display: yes; text-align: right; font-weight: bold">'  + if buf-grp_temp-chk.qnty <> ?  then fnc-convert-dot-to-colon(buf-grp_temp-chk.qnty, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align: right; font-weight: bold" >'  + if buf-grp_temp-chk.sum-unbase <> ? then fnc-convert-dot-to-colon(buf-grp_temp-chk.sum-unbase, "->>>>>>>9.99")   + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align: right; font-weight: bold" >'   + if buf-grp_temp-chk.sum-base <> ? then fnc-convert-dot-to-colon(buf-grp_temp-chk.sum-base, "->>>>>>>9.99")  + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align: right; font-weight: bold" >'    + if buf-grp_temp-chk.doc-qnty <> ? then fnc-convert-dot-to-colon( buf-grp_temp-chk.doc-qnty, "->>>>>>>9") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align: right; font-weight: bold" >' + if buf-grp_temp-chk.pok-qnty <> ? then fnc-convert-dot-to-colon( buf-grp_temp-chk.pok-qnty, "->>>>>>>9") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align: right; font-weight: bold" >' + if buf-grp_temp-chk.srchk-kol-tov <> ?  then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-kol-tov, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                                  
                    '         <td style="display: yes; text-align: right; font-weight: bold" >' + if buf-grp_temp-chk.srchk-sum <> ?  then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-sum, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align: right; font-weight: bold" >'    +  if buf-grp_temp-chk.srchk-uch  <> ?  then fnc-convert-dot-to-colon(buf-grp_temp-chk.srchk-uch, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
   
                    '         <td style="display: yes; text-align: right; font-weight: bold" >'     + if buf-grp_temp-chk.srchk-base-sum <> ?  then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-base-sum, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td style="display: yes; text-align: right; font-weight: bold" >'        + if  buf-grp_temp-chk.srchk-base-uch <>?   then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-base-uch , "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
          
                    '         <td style="display: yes; text-align: right; font-weight: bold" >'    + if  buf-grp_temp-chk.srchk-kol-tov-pokup <> ?  then fnc-convert-dot-to-colon(  buf-grp_temp-chk.srchk-kol-tov-pokup, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '          <td style="display: yes; text-align:  right; font-weight: bold"  >'     +  if   buf-grp_temp-chk.srchk-kol-tov-uch   <> ?  then fnc-convert-dot-to-colon(buf-grp_temp-chk.srchk-kol-tov-uch, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip 
                    '       </tr>' skip
                    . /* Точка для закрытия Put */
            
            end.
            else /* иначе - если более детальные уровни (v-print-lvl с 3-го и более), то формируем строки с такими уровнями в HTML, но на экран не выводим! */
            do:
                put stream OutStr-html unformatted
                    '       <tr level="' + string(v-print-lvl) + '">' skip
                    '         <td style="display: yes ;text-align: right">' +  fnc-convert-dot-to-colon(buf-grp_temp-chk.gds-code, "->>>>>>>999999") + '</td>' skip
                    '         <td num="0.00" style="display: yes;text-align: left;   padding-left: ' + string((v-print-lvl - 1) * 10) + 'px">'
                    + string(fill(" ", ((v-print-lvl - 2) * 4))) + buf-grp_temp-chk.gds-name
                    + '</td>' skip
                    '         <td  num="0.00" style="display: yes ;text-align: right">'  + buf-grp_temp-chk.unit +      '</td>'  skip
                    '         <td num="0.00" style="display: yes ;text-align: right" >' + if buf-grp_temp-chk.qnty <> ?  then fnc-convert-dot-to-colon( buf-grp_temp-chk.qnty, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td num="0.00" style="display: yes ;text-align: right">'  + if buf-grp_temp-chk.sum-unbase <> ? then fnc-convert-dot-to-colon( buf-grp_temp-chk.sum-unbase, "->>>>>>>9.99")   + '</td>' else "?" + '</td>' skip
                    '         <td num="0.00" style="display: yes ;text-align: right">'   + if buf-grp_temp-chk.sum-base <> ? then fnc-convert-dot-to-colon( buf-grp_temp-chk.sum-base, "->>>>>>>9.99")  + '</td>' else "?" + '</td>' skip
                    '         <td  style="display: yes ;text-align: right" >'    + if buf-grp_temp-chk.doc-qnty <> ? then fnc-convert-dot-to-colon( buf-grp_temp-chk.doc-qnty, "->>>>>>>9") + '</td>' else "?" + '</td>' skip
                    '         <td  style="display: yes ;text-align: right" >' + if buf-grp_temp-chk.pok-qnty <> ? then fnc-convert-dot-to-colon( buf-grp_temp-chk.pok-qnty, "->>>>>>>9") + '</td>' else "?" + '</td>' skip
                    '         <td num="0.00" style="display: yes ;text-align: right" >' + if buf-grp_temp-chk.srchk-kol-tov <> ?  then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-kol-tov, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                                  
                    '         <td num="0.00" style="display: yes ;text-align: right" >' + if buf-grp_temp-chk.srchk-sum <> ?  then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-sum, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td num="0.00" style="display: yes ;text-align: right" >'  +  if buf-grp_temp-chk.srchk-uch  <> ?     then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-uch,  "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
   
                    '         <td num="0.00" style="display: yes ;text-align: right">'     + if buf-grp_temp-chk.srchk-base-sum <> ?  then fnc-convert-dot-to-colon(buf-grp_temp-chk.srchk-base-sum, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td num="0.00" style="display: yes ;text-align: right" >'      +  if buf-grp_temp-chk.srchk-base-uch  <> ?  then fnc-convert-dot-to-colon( buf-grp_temp-chk.srchk-base-uch, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
          
                    '         <td num="0.00" style="display: yes ;text-align: right" >'     + if  buf-grp_temp-chk.srchk-kol-tov-pokup <> ?  then fnc-convert-dot-to-colon(buf-grp_temp-chk.srchk-kol-tov-pokup, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '         <td num="0.00" style="display: yes ;text-align: right" >'  +  if buf-grp_temp-chk.srchk-kol-tov-uch  <> ?  then fnc-convert-dot-to-colon(buf-grp_temp-chk.srchk-kol-tov-uch, "->>>>>>>9.99") + '</td>' else "?" + '</td>' skip
                    '       </tr>' skip
                    . /* Точка для закрытия Put */
            end.
/*            output stream outstr-html close.*/
        end.
        if buf-grp_temp-chk.grp-lvl <> 0 then run tt-print-line (input v-obj-type, input v-obj-code, input buf-grp_temp-chk.grp-code, input v-print-lvl + 1 ).
            
    end.

end procedure.

/*    procedure prod-level-grp:                            */
/*            define input parameter v-obj-code as integer.*/
/*    define input parameter v-obj-type as char.           */
/*                                                         */
/*                                                         */
/*        end.                                             */

procedure prod-level: 
    define input parameter v-obj-code as integer.
    define input parameter v-obj-type as char.

    define variable v-eff-doc-qnty as decimal   no-undo.
    define variable v-object-sum   as decimal   no-undo.
    define variable v-tot-r-b      as decimal   no-undo.
    define variable v-ii           as integer   no-undo.
    define variable v-gds-name     as character no-undo.
    define variable v-cur-lvl      as integer   no-undo.
    define variable v-grp-code     as integer   initial ? no-undo.
    define variable v-pok-qnty     as integer   no-undo.
    define variable v-srchk-uch    as decimal   no-undo.
    define variable v-name         as char      no-undo.
    define variable v-psn-code     as integer   no-undo.
     define variable v-upper-code   as integer   initial ? no-undo.
    
        
        for each temp-chk where 
            temp-chk.obj-type = v-obj-type
            and  temp-chk.obj-code = v-obj-code
            and temp-chk.gds-code > 0
            break by temp-chk.grp-code
            :

            v-ii = v-ii + 1.
            v-gds-name = ''.
            if first-of (temp-chk.grp-code)  then
            do:
                assign
                    v-eff-doc-qnty = 0  /* Количество */
                    v-object-sum   = 0    /* Сумма без скидки */
                    v-tot-r-b      = 0       /* Сумма со скидкой */
                    v-pok-qnty     = 0      /* Количество покупок*/
                    .
 
                find first ub.gds-grp where
                    ub.gds-grp.node-code = temp-chk.grp-code no-lock no-error.
                if available ub.gds-grp then
                do:
                    assign
                        v-upper-code = ub.gds-grp.upper-code
                        v-gds-name   = ub.gds-grp.node-name
                        .
           
                end.
            end.

            temp-chk.srchk-kol-tov-uch = temp-chk.pok-qnty * 100 / obj-temp-chk.pok-qnty.
            temp-chk.srchk-base-uch =   temp-chk.sum-base * 100 / obj-temp-chk.sum-base.
            temp-chk.srchk-uch  = temp-chk.sum-unbase * 100 / obj-temp-chk.sum-unbase.
      
                                    temp-chk.upper-code =  temp-chk.grp-code.
      
/*            temp-chk.upper-code =  temp-chk.grp-code.*/

      
            assign
                v-eff-doc-qnty = v-eff-doc-qnty + temp-chk.qnty  /* Количество */
                v-object-sum   = v-object-sum + temp-chk.sum-unbase        /* Сумма без скидки */
                v-tot-r-b      = v-tot-r-b + temp-chk.sum-base                 /* Сумма со скидкой */
                v-pok-qnty     = v-pok-qnty + temp-chk.pok-qnty               /* Количество покупок*/
                v-srchk-uch    = v-srchk-uch + temp-chk.srchk-uch
                .

            if last-of (temp-chk.grp-code)   then
            do:

                find first prod-temp-chk exclusive-lock where
                    prod-temp-chk.gds-code = 0 and
                    prod-temp-chk.obj-type = temp-chk.obj-type and
                    prod-temp-chk.obj-code = temp-chk.obj-code  and
                    prod-temp-chk.grp-code = temp-chk.grp-code and
                    prod-temp-chk.grp-lvl = 1       
                 
                    use-index tt no-error
                    .

                if  not available prod-temp-chk then
                do:
                    create prod-temp-chk .
                    assign
                                prod-temp-chk.grp-lvl = 1
                        prod-temp-chk.grp-code   = temp-chk.grp-code
                        prod-temp-chk.obj-type   = temp-chk.obj-type
                        prod-temp-chk.obj-code   = temp-chk.obj-code 
                        prod-temp-chk.gds-code   = 0.
                        
                end.
                 prod-temp-chk.upper-code = -2.
/*                prod-temp-chk.gds-name = "Продавец не указан" + string(temp-chk.sales-man) + string(temp-chk.grp-code).*/
                 prod-temp-chk.gds-name = "Продавец не указан".
                v-name = ''.
      
                if prod-temp-chk.grp-code <> 0 then  for first ub.person where
                    ub.person.psn-code = temp-chk.sales-man-psn no-lock : 
                    
               
                    run rep/get-psn.p(input person.psn-code, output v-name ).
                    prod-temp-chk.gds-name = v-name + '  ' + ub.person.name1 + ' ':U + ub.person.name2.
        
                end.
      
        
                assign
       
                    prod-temp-chk.qnty          = v-eff-doc-qnty           /* Количество */         
                    prod-temp-chk.sum-unbase    = v-object-sum               /* Сумма без скидки */
                    prod-temp-chk.sum-base      = v-tot-r-b                     /* Сумма со скидкой */
                    prod-temp-chk.pok-qnty      = v-pok-qnty                      /* количество покупок*/
                 
                    prod-temp-chk.srchk-kol-tov = prod-temp-chk.qnty / prod-temp-chk.doc-qnty.
                prod-temp-chk.srchk-sum           = prod-temp-chk.sum-unbase / prod-temp-chk.doc-qnty.
                prod-temp-chk.srchk-base-sum      = prod-temp-chk.sum-base / prod-temp-chk.doc-qnty.
                prod-temp-chk.srchk-kol-tov-pokup = prod-temp-chk.pok-qnty  / prod-temp-chk.doc-qnty.
    
      
    
                prod-temp-chk.srchk-base-uch =  prod-temp-chk.sum-base * 100 / obj-temp-chk.sum-base.
                prod-temp-chk.srchk-kol-tov-uch = prod-temp-chk.pok-qnty * 100 / obj-temp-chk.pok-qnty.
                prod-temp-chk.srchk-uch  = prod-temp-chk.sum-unbase * 100 / obj-temp-chk.sum-unbase.
    
        
                obj-temp-chk.doc-qnty = obj-temp-chk.doc-qnty +    prod-temp-chk.doc-qnty.      
         
            end.
            
        end. /* temp-chk */
 
       
    
    obj-temp-chk.srchk-uch = 100. 
    obj-temp-chk.srchk-base-uch = 100.
    obj-temp-chk.srchk-kol-tov-uch = 100.
    obj-temp-chk.srchk-kol-tov       = obj-temp-chk.qnty / obj-temp-chk.doc-qnty.
    obj-temp-chk.srchk-sum           = obj-temp-chk.sum-unbase / obj-temp-chk.doc-qnty.
    obj-temp-chk.srchk-base-sum      = obj-temp-chk.sum-base / obj-temp-chk.doc-qnty.
    obj-temp-chk.srchk-kol-tov-pokup = obj-temp-chk.pok-qnty  / obj-temp-chk.doc-qnty.
          
  
end procedure.




function fnc-DD-MM-YYYY returns character 
(input p-dat-date as date):
/* Преобразование даты в формат: "01.01.2014" */

    define variable result as character no-undo.
    define variable p-str-date as character no-undo.

    p-str-date = replace(string(p-dat-date,'99.99.9999'), "/", ".").

        return p-str-date.

end function.





function fnc-convert-dot-to-colon returns character
(input p-data as decimal, input p-accur as character):
/* Конвертация десятичной точки в запятую с передачей параметра форматирования числа (accuracy - точность) */

    define variable result as character no-undo.
    define variable v-str-result as character no-undo.
/*message "dbg-p-data = " p-data skip "p-accur = " p-accur view-as alert-box.*/
    p-data = round(p-data, 2). /* Чтобы не выйти случайно за рамки формата числа при выводе (несоотвесвие формата результата и формата отображения - приводит к ош) */
    v-str-result = trim(replace(string(p-data, p-accur), ".", ",")).

    return v-str-result.

end function.
