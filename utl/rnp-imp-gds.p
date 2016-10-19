
/*------------------------------------------------------------------------
    File        : rnp-imp-gds.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Aug 30 12:37:42 MSK 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define input parameter parparentproc as widget-handle no-undo .

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author: SSlivenko$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Импорт товаров РН-Питер".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ gbl/waitfram.i }
{ gbl/getcntxt.i def }
{ gbl/thbj-def.i }
{ str/tt-tax.i "new shared" tt-tax full }
define new shared buffer goods for goods.

define buffer first_gds-grp for ub.gds-grp.

define new shared stream gds-file.

define variable custvalue      as character no-undo.
define variable custtype       as character no-undo.
define variable tnvedimp as logical no-undo init no.

define variable f-name as char no-undo.
define variable impc as integer no-undo.
define variable impc-saved as integer no-undo.
define variable not-saved as character no-undo.
define variable text-string as char no-undo.
define variable p-artic     AS integer NO-UNDO init 1.
define variable p-name      AS integer NO-UNDO init 2.
define variable p-engl-name AS integer NO-UNDO.
define variable p-SLT-code  AS integer NO-UNDO.
define variable p-VAT-code  AS integer NO-UNDO.
define variable p-unit-base AS integer NO-UNDO.
define variable p-struct AS integer NO-UNDO.
define variable p-prod AS integer NO-UNDO.
define variable p-tnved as integer no-undo .
define variable p-attrib as integer no-undo .
define variable p-destin as integer no-undo .
define variable p-sert as integer no-undo .
define variable p-user-rule as integer no-undo .
define variable p-alpha1 as integer no-undo .
define variable p-grp-code as integer no-undo .
define variable i-artic as char no-undo.
define variable i-prod-type as character no-undo .
define variable i-prod-code as integer no-undo .
define variable i-gds-name as char no-undo.
define variable i-engl-name as char no-undo.
define variable i-SLT-code as integer no-undo.
define variable i-unit-base as char no-undo.
define variable i-VAT-code as integer no-undo.
define variable i-struct as character no-undo.
define variable i-tnved like ub.goods.tnved no-undo .
define variable i-attrib like ub.goods.attrib no-undo .
define variable i-destin like ub.goods.destin no-undo .
define variable i-sert like ub.goods.sert no-undo .
define variable i-user-rule like ub.goods.user-rule no-undo .
define variable i-alpha1 like ub.goods.alpha1 no-undo .
define variable i-grp-code like ub.goods.grp-code no-undo .
define variable choice as integer no-undo.

define variable NDS like  tax-rate-value.rate-value  no-undo .
define variable NP like  tax-rate-value.rate-value  no-undo .

define variable j-gds-code like goods.gds-code NO-UNDO.

{ gbl/conf-rd.i
 "'is-custm'"
 "''"
 "''"
 0
 "''"
 "''"
 "''"
 no
 custvalue
 custtype
 no-error
 }
 

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
{ gbl/getcntxt.i get }
for each thbjattr_thbj-attr  where
        thbjattr_thbj-attr.obj-type = '':U
    and thbjattr_thbj-attr.obj-code = 0
    and thbjattr_thbj-attr.upper-prop-code = {&attr-gds-ref}
on error undo, return error substitute( "&1. &2&3&4", vss-workfile, return-value, {&new-line}, error-status :get-message (1))
:
  case thbjattr_thbj-attr.prop-code:
    when {&attr-gds-ref_tnvedimp} then do:
      tnvedimp = thbjattr_thbj-attr.property-value-logical.
    end.
  end case.
end.

run ref/strtimp.w (
                       input parparentproc
                      ,input integer({&vat-tax-code})
                      ,input integer({&slt-tax-code})
                      ,input custvalue
                      ,input tnvedimp
                      ,output f-name
                      ,output choice
                      ,output p-artic
                      ,output p-prod
                      ,OUTPUT p-name
                      ,OUTPUT p-engl-name
                      ,OUTPUT p-unit-base
                      ,OUTPUT p-VAT-code
                      ,OUTPUT p-SLT-code
                      ,OUTPUT p-struct
                      ,OUTPUT p-tnved
                      ,OUTPUT p-attrib
                      ,OUTPUT p-destin
                      ,OUTPUT p-sert
                      ,OUTPUT p-user-rule
                      ,OUTPUT p-alpha1
                      ,OUTPUT p-grp-code
                      ) no-error.
if  error-status:error or f-name = "" then return error.
CASE choice:
    WHEN 1 then do:
        input stream gds-file from value (f-name) convert source "1251".
    END.
    WHEN 2 then do:
        input stream gds-file from value (f-name) convert source "KOI8-R".
    END.
END CASE.

impc = 0.
impc-saved = 0.

run waitfram-show in this-procedure ( "ЖДИТЕ...") .

repeat :
    run ref/nxtgdsi.p (   input integer({&vat-tax-code})
                         ,input integer({&slt-tax-code})
                         ,input custvalue
                         ,input p-artic
                         ,input p-prod
                         ,input p-name
                         ,input p-engl-name
                         ,input p-unit-base
                         ,input p-VAT-code
                         ,input p-SLT-code
                         ,input p-struct
                         ,input p-tnved
                         ,input p-attrib
                         ,input p-destin
                         ,input p-sert
                         ,input p-user-rule
                         ,input p-alpha1
                         ,input p-grp-code
                         ,input (impc + 1)
                         ,input-output i-artic
                         ,input-output i-prod-type
                         ,input-output i-prod-code
                         ,input-output i-gds-name
                         ,input-output i-engl-name
                         ,input-output i-unit-base
                         ,input-output i-VAT-code
                         ,input-output i-SLT-code
                         ,input-output i-struct
                         ,input-output i-tnved
                         ,input-output i-attrib
                         ,input-output i-destin
                         ,input-output i-sert
                         ,input-output i-user-rule
                         ,input-output i-alpha1
                         ,input-output i-grp-code
                          ) no-error .
    if return-value = "END" then leave .                      
    if error-status :error
    then do :
        impc = impc + 1 .
        next.
    end.                          
    
    if can-find(goods where goods.artic = i-artic
                        and goods.prod-type = i-prod-type
                        and goods.prod-code = i-prod-code)
    then next.
    
    assign
    impc = impc + 1 .
    
    do transaction:

/**************************************************************************/
        define variable v-host-code     as integer           no-undo.

        { gbl/hostcode.i
        v-cntxt-obj-type
        v-cntxt-obj-code
        v-host-code
        }
        
        find last tax-rate-value where    /*Значение ставки налога    НДС    */
                    tax-rate-value.tax-code = 1 and
                    tax-rate-value.rate-code = i-vat-code no-lock no-error.
        IF available tax-rate-value then do:
            NDS = tax-rate-value.rate-code.
        END.
        
        find first gds-grp no-lock where gds-grp.node-code = i-grp-code no-error .
        find first first_gds-grp .
        
        run ref/dtaxgdss.p (
              input yes
            , input /*par-unit-base*/  i-unit-base
            , input /*par-node-code*/  (if available gds-grp
                          then gds-grp.node-code
                          else first_gds-grp.node-code)
            , input ?
            , input ?
            , input /*par-host-code*/  v-host-code
            , input /*par-obj-type*/   v-cntxt-obj-type
            , input /*par-obj-code*/   v-cntxt-obj-code
        ).

        IF p-VAT-code > 0 THEN DO:
            find first tt-tax
                 where tt-tax.tax-code = integer( {&vat-tax-code} )
            no-error.
            if available tt-tax   then do:
                assign
                    tt-tax.rate-code = NDS .
            end.
        END.


        define variable v-recid         as recid             no-undo.

        run ref/goods01.p (
              input parparentproc
            , input {&add-def} /* {&add-def} или {&update} */
            , input no   /*копирование с другого товара - тогда par-copy-rec - должен быть задан*/
            , input 0    /*нужно ли вводить ДОП БК вместе с товаром*/
            , input no   /*мз карточки товара - yes*/
            , input yes  /*ругаемся вслух или ?*/
            , input no   /* yes - пропускается проверка на повторный артикул */
            , input no   /*идет импорт из файла - из карточки товара*/
            , input yes  /*надо сохранить только одну запись - потом выход в справ*/
            , input v-host-code
            , input v-cntxt-obj-type
            , input v-cntxt-obj-code
            , input yes           /*товар - yes услуга no*/
            , input ?             /*recid записи с которой копируем*/
            , input 0
            , input i-artic       /* артикул*/
            , input i-prod-type /* тип производителя */
            , input i-prod-code /*код производителя */
            , input 1 /* пустая шкала */
            , input i-grp-code
            , input i-gds-name        /* наименование товара */
            , input ""
            , input i-engl-name        /* Название англ. */
            , input i-gds-name        /* Название на ценнике */
            , input replace( replace( i-gds-name, chr( 39 ), "" ), chr( 34 ), "" )
            , input i-alpha1        /* Код страны */
            , input i-unit-base   /* Ед. изм. */
            , input i-unit-base   /* Ед. изм. */
            , input 0.0           /* Макс. кол-во дробн./шт */
            , input 0.0           /*  Мин. кол-во дробн./шту */
            , input 1             /* Коэффициент  */
            , input 1             /* Кол. в упак.  */
            , input 0             /* Объем штуки */
            , input 0             /* Вес штуки */
            , input 0             /* Объем упаковки  */
            , input 0             /* Вес упаковки  */
            , input {&pr-calc-grp}            /*   Способ расчета  */
            , input 0             /* Процент наценки  */
            , input no            /* Отриц. остаток   */
            , input 0
            , input 0
            , input ""            /* ОКДП  */
            , input ""          /* Назначение  */
            , input ""          /*  Характеристики */
            , input ""          /*  Правила эксплутации */
            , input ""          /*  Сертификация */
            , input ""      /* Состав (комплектность)  */
            , input 0             /* Срок хранения  */
            , input 0             /* Код условия хранения  */
            , input ""            /* Сорт  */
            , input 0.0           /* процент алкоголя */
            , input 0             /*  Норма естественной убы */
            , input 0             /*  Норма отходов */
            , input ""            /*  Код ТНВЭД */
            , input ""            /*  Национальность */
            , input ""            /* Таможенная единица изм  */
            , input 0             /*  Коэффициент */
            , input ?             /*  Код глоб.группы меню */
            , input ""            /*  Примечание */
            , input no            /* настройка  */
            , input no            /*  в системе разрешены ювелирные изделия */
            , input no            /* в системе разрешена стеклотара  */
            , input no            /*  в системе разрешено топливо */
            , input "no"          /* в системе разрешена таможня  */
            , input yes           /*настройка*/
            , input no            /*настройка*/
            , input no            /* автоматический артикул */
            , input 0             /*главный код товара берется из артикула*/
            , input-output v-recid
            , output j-gds-code   /*gds-code*/
        ) no-error .


        if error-status :error
        then do:
            message
                     vss-workfile vss-revision vss-description
                skip "Ошибка создания или изменения карточки товара."
                skip return-value
                skip i-artic
                skip trim(error-status :get-message(1))
                     trim(error-status :get-message(2))
                     trim(error-status :get-message(3))
            view-as alert-box error.
/*            IF r-s-stop = 2 THEN RETURN.*/
        end.
        else do :
            impc-saved = impc-saved + 1.
            if impc-saved modulo 10 = 0 then
            run waitfram-show in this-procedure (input substitute("Обработано товаров &1", impc-saved)) .
        end.
        
    end.   /*   do transaction: */
    
end.

input stream gds-file close.

run waitfram-hide in this-procedure .
message ("Импорт из файла " + f-name + " закончен" + {&new-line} + "прочитано " + string(impc) +
         ",  сохранено " + string(impc-saved) )
view-as alert-box  INFORMATION.
 
 