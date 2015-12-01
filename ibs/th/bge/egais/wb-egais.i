
/*------------------------------------------------------------------------
    File        : wb-egais.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Fri Nov 27 17:55:35 MSK 2015
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

&glob wb-header 1
&glob wb-line   2
&glob wb-clob   3

  define temp-table tt-wb-header no-undo
    field wb-type      as character label "Тип"
    field indenty      as character label "ID EGAIS"
    field num          as character label "№ EGAIS"
    field wb-date      as date label "Дата"
    field shippingdate as date label "Дата поставки"
    field regID-Ship   as character format "X(21)" label "Контрагент EGAIS"
    field regID-Cons   as character format "X(21)" label "Получатель EGAIS"
    field client       as character label "Контр. TH"
    field clientCons   as character label "Получ. TH" 
    field unit-type    as character label "Тип единицы измерения"
    field cli-type     as character label "Тип клиента TH"
    field cli-code     as integer label "Код клиента TH"
    field obj-type     as character label "Тип клиента TH"
    field obj-code     as integer label "Код клиента TH"
    field ps           as character label "Примечание"
    index pi
    indenty 
    .

  define temp-table tt-wb-gds-EG no-undo
    field gds-code      like ub.goods.gds-code label "Код товара в TH"
    field gds-name      like ub.goods.gds-name label "Полное наименование"
    field alc-code      as character label "Алкогольный код"
    field ms-base       like ub.goods.ms-base label "Объем" format ">>9.9<<"
    field alc-type-code like ub.alc-type.alc-type-code label "Код АП"
    field proof         like ub.goods.proof label "Крепость" format ">9.9"
    field Identity      as integer label "ID EGAIS"
    field doc-qnty      like ub.doc-line.doc-qnty label "Кол-во"
    field price         like ub.doc-line.price-rubl label "Цена"
    index pi as primary
    gds-code
    index name_
    gds-name
    index alc
    alc-code    
    .