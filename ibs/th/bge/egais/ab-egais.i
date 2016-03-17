
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

&glob ab-header 1
&glob ab-answer   2
&glob ab-clob   3



define temp-table tt-act-header
    field num           as character        label "№ акта"      format "X(30)"
    field date_         as date             label "Дата акта"
    field is-sent       as logical
    field answer_       as character        label "Ответ"       format "X(1500)"
    index pi as primary unique
        num
.

define temp-table tt-gds-act
    field num           as character                label "№ акта"
    field position_     as integer                  label "№ пп"                    format ">>>9"
    field gds-code      like ub.goods.gds-code      label "Код товара   "
    field part-code     like ub.parts.part-code     label "Партия"
    field doc-code      as character                label "№ накладной TH"
    field doc-date      like ub.trn-doc.fact-date   label "Дата TH"
    field alc-code      as character                label "Алкогольный код"         format "X(21)"
    field gds-name      like ub.goods.gds-name      label "Наименование товара"     format "X(35)"
    field qnty          as integer                  label "Количество"
    field inform-A      as character                label "Справка А"               format "X(20)"
    field A-qnty        as integer                  label "Кол-во в справке"        
    field A-bottleDate  as date                     label "Дата розлива"
    field A-ttnNumber   as character                label "№ ТТН справки А"         format "X(15)"
    field A-ttnDate     as date                     label "Дата"
    field A-fixNumber   as character                label "№ фиксации в ЕГАИС"      format "X(15)"
    field A-fixDate     as date                     label "Дата фикс."
    field inform-B      as character                label "Справка Б"               format "X(20)"
    field marks-qnty    as integer                  label "Кол-во марок"
    field egais-name    as character
    index pi as primary unique
        position_
    index code
        gds-code doc-code
.

define {1} {2} temp-table tt-marks
    field num           as character            label "№ акта"
    field gds-part-position_   as integer
    field mark          as character            label "Марка"       format "X(100)"
    field new_          as logical
    field gds-code      like ub.goods.gds-code              LABEL "Код товара"                 
    field gds-name      as character            LABEL "Наименование"   FORMAT "X(30)" 
    field alc-code      as character            LABEL "Алк. код"       FORMAT "X(20)"     
    field importer      as character            LABEL "Импортер"       FORMAT "X(30)" 
    field producer      as character            LABEL "Производитель"
    index pi as primary unique
        mark
.
