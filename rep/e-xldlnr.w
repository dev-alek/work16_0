&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW

using Progress.Lang.*.
using Ibs.Th.Gbl.ReportXml.
using Ibs.Th.Gbl.rep-out. 


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-grp NO-UNDO LIKE gds-grp.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS s-object 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

e-Отчет по картам ЛНР. Печать отчёта в процедуре  my-report.

Автор: Соломко Дмитрий Владимирович
Дата создания: 10/02/2014 
Author: Solomko Dmitry
Creation date: 10/02/2014 

*/

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "e-Отчет по картам ЛНР.Печать отчёта в процедуре  my-report.".

{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ cmp/showinf.i }
{ gbl/cur-time.i }
{ cmp/r-page1.i  }
{ cmp/operlist.i }
{ rep/e-xldbj.i "NEW SHARED" }
{ cmp/r-pril.i new }
{ gbl/prn-lib.i }
{ gbl/waitfram.i }
{ cmp/dc-list.i dc-list def "new shared" }
{ gbl/getcntxt.i def }
{ rep/lhstprex.i dc-list-hist }

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable parparentproc as widget-handle no-undo.
define variable loc-ref-list as character no-undo.
define variable doc-list as character no-undo.
define variable ii as integer no-undo.
define variable Report  as class ReportXml no-undo. /* Переменная под класс */
define variable xml_tmp as character no-undo. /*путь к временному файлу*/
define variable xslt-path as character no-undo. /*путь к шаблону */
define variable rep-out-unit as class rep-out no-undo. /*экземпляр класса формирования документа отчёта */
define variable v-total-qnty as decimal no-undo.
define variable v-total-sum1 as decimal no-undo.
define variable v-total-sum2 as decimal no-undo.
define variable v-discount as decimal no-undo.

define buffer buf_trn-doc for ub.trn-doc.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS   v-rs-klass v-rs-det RECT-3 RECT-4
&Scoped-Define DISPLAYED-OBJECTS   v-rs-klass v-rs-det

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE v-rs-klass AS CHARACTER
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS
     "Объект", "object":U,
     "Дата", "date":U,
     "Номер карты", "card":U
     SIZE 20 BY 3.8 NO-UNDO.

DEFINE VARIABLE v-rs-det AS CHARACTER
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS
     "Товар", "good":U,
     "По типам товаров", "goodtype":U
     SIZE 20 BY 2.5 NO-UNDO.
     
DEFINE RECTANGLE RECT-3
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
SIZE 35 BY 5.43.

DEFINE RECTANGLE RECT-4
EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
SIZE 35 BY 4.


define temp-table tt-line no-undo

/*Дата чека*/
field chk-date as date
/*Время*/
field chk-time as integer
/*Номер карты*/
field d-card as character
/*№ кассы*/
field pay-desk as integer 
/*Объект*/
field obj-name as character
field obj-type as character
field obj-code as integer
/*Товар*/
field gds-name as character
/*Количество*/
field eff-doc-qnty as decimal
/*Сумма без скидки*/
field object-sum as decimal
/*Скидка*/
field discount as decimal
/*Сумма со скидкой*/
field tot-r-b as decimal
field line-type as character
field doc-code as character
field type-line as character
    
index pi as primary doc-code
.                         






/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    "Классификация" VIEW-AS TEXT
     SIZE 20 BY .83 AT ROW 1.5 COL 3.6
     FGCOLOR 4
     v-rs-klass AT ROW 2.5 COL 3.6 NO-LABEL
     "Детализация" VIEW-AS TEXT
     SIZE 20 BY .83 AT ROW 7.2 COL 3.6
     FGCOLOR 4
     v-rs-det AT ROW 8.2 COL 3.6 NO-LABEL
     RECT-3 AT ROW 1.2 COL 1.1
     RECT-4 AT ROW 6.97 COL 1.1
     
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
   Temp-Tables and Buffers:
      TABLE: tt-grp T "?" NO-UNDO ub gds-grp
   END-TABLES.
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW s-object ASSIGN
         HEIGHT             = 4.05
         WIDTH              = 73.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB s-object 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW s-object
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.


       

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK s-object 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */
  parparentproc = my-handle.
  { gbl/getcntxt.i get }
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI s-object  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-layout s-object 
PROCEDURE local-apply-layout :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-layout':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize s-object 
PROCEDURE local-initialize :
define variable v-list as character no-undo.
    define variable v-tmp as character no-undo.
    
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE my-report s-object
/* Процедура печати отчёта */ 
PROCEDURE my-report :
/*------------------------------------------------------------------------------
  Purpose:     здесь происходит вызов  процедуры отчета с любыми параметрами
------------------------------------------------------------------------------*/
for each tt-line no-lock  
    :
    delete tt-line.
end.

         
for each obj-list :
    /*НАДО УБЕДИТЬСЯ ЧТО ВСЕ РАЗМАЗАНО!!*/
     run rep/rpychk0.p ( input "r-shftc2"
                    ,input obj-list.obj-type
                    ,input obj-list.obj-code
                    ,input ? /*p-date-from*/
                    ,input ? /*p-date-to*/
                    ,input X-date-start /*p-shift-date-from*/
                    ,input X-date-end /*p-shift-date-to*/
                    ,input 1 /*p-shift-num-start*/
                    ,input 99 /*p-shift-num-end*/
                    ,input ? /*p-inkas-code*/
                    ) no-error.
                    
     if error-status:error then do:
         message error-status:get-message(1) view-as alert-box.
     end. 
     
     
        
     if x-TOG-Shift = yes  then
         /* Выбрана галка СМЕНЫ в интерфейсе */        
         for each ub.chk-doc no-lock
            where ub.chk-doc.obj-type = obj-list.obj-type
            AND ub.chk-doc.obj-code = obj-list.obj-code
            AND (ub.chk-doc.shift-date > x-Date-Start or 
                (ub.chk-doc.shift-date = x-Date-Start and ub.chk-doc.shift-num >= x-Shift-Start))
            AND (ub.chk-doc.shift-date < x-Date-End or 
                (ub.chk-doc.shift-date = x-Date-End and ub.chk-doc.shift-num <= x-Shift-End))
            AND  ub.chk-doc.out-code > "" ,
         first ub.chk-discnt  no-lock
            where ub.chk-discnt.doc-code = ub.chk-doc.doc-code
            AND ub.chk-discnt.discnt-type = integer({&discnt-t-cashLoyal})       
                : 
                for each chk-gds no-lock
                    where ub.chk-gds.doc-code = ub.chk-doc.doc-code
                    : 
                    for each ub.chk-gds-pay no-lock
                        where ub.chk-gds-pay.doc-code = ub.chk-doc.doc-code
                        AND ub.chk-gds-pay.b-code = chk-gds.b-code
                        AND ub.chk-gds-pay.line-num = chk-gds.line-num
                        :       
                        run proc-tt. /* Процедура для заполнения временной таблицы tt-line */
                    end.
                end.                
         end.       
     else 
         /* Не выбрана галка СМЕНЫ в интерфейсе */  
         for each ub.chk-doc no-lock
            where ub.chk-doc.obj-type = obj-list.obj-type
            AND ub.chk-doc.obj-code = obj-list.obj-code
            AND ub.chk-doc.chk-date >= x-Date-Start
            AND ub.chk-doc.chk-date <= x-Date-End
            AND  ub.chk-doc.out-code > "" ,
         first ub.chk-discnt  no-lock
            where ub.chk-discnt.doc-code = ub.chk-doc.doc-code
            AND ub.chk-discnt.discnt-type = integer({&discnt-t-cashLoyal})        
                :    
                for each chk-gds no-lock
                    where ub.chk-gds.doc-code = ub.chk-doc.doc-code
                    :     
                    for each ub.chk-gds-pay no-lock
                        where ub.chk-gds-pay.doc-code = ub.chk-doc.doc-code
                        AND ub.chk-gds-pay.b-code = chk-gds.b-code
                        AND ub.chk-gds-pay.line-num = chk-gds.line-num
                        :                            
                        run proc-tt.  /* Процедура для заполнения временной таблицы tt-line */               
                    end.      
                end.
         end.       
end.          
                                                  

   
/*формируем xml */
xml_tmp = string(session:temp-directory + "report-tmp2.xml"). /* путь к временному xml файлу */
Report = new ReportXml(xml_tmp). 


Report:worksheet("Лист 1").
Report:worksheet-header("start").   /* Начало шапки отчета */
        if length(str1) > 95 
            then
                do:
                    Report:worksheet-header("Отчёт по картам ЛНР " + substring(str1, 1, 95) + "..." ).
                end.
            else
                do:
                    Report:worksheet-header("Отчёт по картам ЛНР " + str1).
                end.
        if length(str2) > 115 
            then
                do:
                    Report:worksheet-header(substring(str2, 1, 115)+ "..." ).
                end.
            else
                do:
                    Report:worksheet-header(str2).
                end.                
       if length(str4) > 115 
            then
                do:
                    Report:worksheet-header(substring(str4, 1, 115)+ "..." ).
                end.
            else
                do:
                    Report:worksheet-header(str4).
                end.
            
Report:worksheet-header("end").     /*Конец шапки отчета*/ 

Report:table-columns("60,60,120,60,60,60,110,60,60,60").    /* Начало таблицы, задаем размеры колонок */
Report:table-types = "String,String,String,String,String,String,Number,Number,String,Number".   /* Типы данных в таблице */
Report:table-header("Дата чека|Время|Номер карты|№ кассы|Объект|Товар|Количество|Сумма без скидки|Скидка|Сумма со скидкой","40","4").    /* Шапка таблицы */ 



/* Печать отчёта в случае, если классификация - ОБЪЕКТ и детализация - ТОВАР */
if  v-rs-klass:SCREEN-VALUE in frame {&FRAME-NAME} = "object":U  
    and v-rs-det:SCREEN-VALUE in frame {&FRAME-NAME} = "good":U then do:
    for each tt-line no-lock break by tt-line.obj-type by tt-line.obj-code by tt-line.chk-date by tt-line.chk-time by tt-line.doc-code by tt-line.type-line  :
        if first-of (tt-line.obj-code) then Report:table-group( "Объект " + tt-line.obj-name ).
        Report:table-row(  (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
            + "|" +    (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
            + "|" +    (if tt-line.d-card = ? then "" else tt-line.d-card)
            + "|" +    (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
            + "|" +    (if tt-line.obj-name = ? then "" else tt-line.obj-name)    
            + "|" +    (if tt-line.gds-name = ? then "" else tt-line.gds-name)    
            + "|" +    (if tt-line.eff-doc-qnty  = ? then "" else string(tt-line.eff-doc-qnty))     
            + "|" +    (if tt-line.object-sum  = ? then "" else string(tt-line.object-sum))  
            + "|" +    (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")  
            + "|" +    (if tt-line.tot-r-b  = ? then "" else string(tt-line.tot-r-b))
        ).
        accumulate tt-line.eff-doc-qnty  (total by tt-line.obj-code).
        accumulate tt-line.object-sum  (total by tt-line.obj-code).
        accumulate tt-line.tot-r-b  (total by tt-line.obj-code).
        accumulate tt-line.eff-doc-qnty  (total).
        accumulate tt-line.object-sum  (total).
        accumulate tt-line.tot-r-b  (total). 
        if last-of (tt-line.obj-code) then Report:table-subtotal( ""
                                           + "|" +        ""
                                           + "|" +        "Итого по объекту"
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.obj-code tt-line.eff-doc-qnty) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.obj-code tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))) 
                                           + "|" +        (if (accum total by tt-line.obj-code tt-line.object-sum) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.obj-code tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99")))
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.obj-code tt-line.tot-r-b) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.obj-code tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99")))).
                                        
    end.
end.

/* Печать отчёта в случае, если классификация - ДАТА и детализация - ТОВАР */
if  v-rs-klass:SCREEN-VALUE in frame {&FRAME-NAME} = "date":U 
    and v-rs-det:SCREEN-VALUE in frame {&FRAME-NAME} = "good":U then do: 
     for each tt-line no-lock break by tt-line.chk-date by tt-line.chk-time by tt-line.doc-code by tt-line.type-line:
         if first-of (tt-line.chk-date) then Report:table-group( "Дата " + (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) ).
         Report:table-row(  (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
             + "|" +    (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
             + "|" +    (if tt-line.d-card = ? then "" else tt-line.d-card)
             + "|" +    (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
             + "|" +    (if tt-line.obj-name = ? then "" else tt-line.obj-name)    
             + "|" +    (if tt-line.gds-name = ? then "" else tt-line.gds-name)    
             + "|" +    (if tt-line.eff-doc-qnty  = ? then "" else string(tt-line.eff-doc-qnty))     
             + "|" +    (if tt-line.object-sum  = ? then "" else string(tt-line.object-sum))  
             + "|" +    (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")  
             + "|" +    (if tt-line.tot-r-b  = ? then "" else string(tt-line.tot-r-b))
         ).
         accumulate tt-line.eff-doc-qnty  (total by tt-line.chk-date).
         accumulate tt-line.object-sum  (total by tt-line.chk-date).
         accumulate tt-line.tot-r-b  (total by tt-line.chk-date).
         accumulate tt-line.eff-doc-qnty  (total).
         accumulate tt-line.object-sum  (total).
         accumulate tt-line.tot-r-b  (total).
        if last-of (tt-line.chk-date) then Report:table-subtotal( ""
                                           + "|" +        ""
                                           + "|" +        "Итого по дате"
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.chk-date tt-line.eff-doc-qnty) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.chk-date tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99")))
                                           + "|" +        (if (accum total by tt-line.chk-date tt-line.object-sum) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.chk-date tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))) 
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.chk-date tt-line.tot-r-b) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.chk-date tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99")))). 
    end.
end.

/* Печать отчёта в случае, если классификация - НОМЕР КАРТЫ и детализация - ТОВАР*/
if  v-rs-klass:SCREEN-VALUE in frame {&FRAME-NAME} = "card":U 
    and v-rs-det:SCREEN-VALUE in frame {&FRAME-NAME} = "good":U then do: 
    for each tt-line no-lock break by tt-line.d-card by tt-line.chk-date by tt-line.chk-time by tt-line.doc-code by tt-line.type-line:
         if first-of (tt-line.d-card) then Report:table-group( "Номер карты " + (if tt-line.d-card = ? then "" else tt-line.d-card) ).
         Report:table-row(  (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
             + "|" +    (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
             + "|" +    (if tt-line.d-card = ? then "" else tt-line.d-card)
             + "|" +    (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
             + "|" +    (if tt-line.obj-name = ? then "" else tt-line.obj-name)    
             + "|" +    (if tt-line.gds-name = ? then "" else tt-line.gds-name)     
             + "|" +    (if tt-line.eff-doc-qnty  = ? then "" else string(tt-line.eff-doc-qnty))     
             + "|" +    (if tt-line.object-sum  = ? then "" else string(tt-line.object-sum))  
             + "|" +    (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")  
             + "|" +    (if tt-line.tot-r-b  = ? then "" else string(tt-line.tot-r-b))
         ).
         accumulate tt-line.eff-doc-qnty  (total by tt-line.d-card).
         accumulate tt-line.object-sum  (total by tt-line.d-card).
         accumulate tt-line.tot-r-b  (total by tt-line.d-card).
         accumulate tt-line.eff-doc-qnty  (total).
         accumulate tt-line.object-sum  (total).
         accumulate tt-line.tot-r-b  (total).
        if last-of (tt-line.d-card) then Report:table-subtotal( ""
                                           + "|" +        ""
                                           + "|" +        "Итого по номеру карты"
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.d-card tt-line.eff-doc-qnty) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.d-card tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99")))
                                           + "|" +        (if (accum total by tt-line.d-card tt-line.object-sum) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.d-card tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))) 
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.d-card tt-line.tot-r-b) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.d-card tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99")))).     
    end.
end.


/* Печать отчёта в случае, если классификация - ОБЪЕКТ и детализация - ПО ТИПАМ ТОВАРА */
if  v-rs-klass:SCREEN-VALUE in frame {&FRAME-NAME} = "object":U 
    and v-rs-det:SCREEN-VALUE in frame {&FRAME-NAME} = "goodtype":U then do: 
    for each tt-line no-lock break by tt-line.obj-type by tt-line.obj-code by tt-line.chk-date by tt-line.chk-time by tt-line.doc-code by tt-line.type-line :
        if first-of (tt-line.obj-code) then Report:table-group( "Объект " + tt-line.obj-name ).
        if (tt-line.type-line = "1топливо") then
        Report:table-row(  (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
            + "|" +    (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
            + "|" +    (if tt-line.d-card = ? then "" else tt-line.d-card)
            + "|" +    (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
            + "|" +    (if tt-line.obj-name = ? then "" else tt-line.obj-name)    
            + "|" +    (if tt-line.gds-name = ? then "" else tt-line.gds-name)    
            + "|" +    (if tt-line.eff-doc-qnty  = ? then "" else string(tt-line.eff-doc-qnty))     
            + "|" +    (if tt-line.object-sum  = ? then "" else string(tt-line.object-sum))  
            + "|" +    (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")  
            + "|" +    (if tt-line.tot-r-b  = ? then "" else string(tt-line.tot-r-b))
        ).
        accumulate tt-line.eff-doc-qnty  (total by tt-line.type-line).
        accumulate tt-line.object-sum  (total  by tt-line.type-line).
        accumulate tt-line.tot-r-b  (total  by tt-line.type-line).
        accumulate tt-line.eff-doc-qnty  (total by tt-line.obj-code).
        accumulate tt-line.object-sum  (total by tt-line.obj-code).
        accumulate tt-line.tot-r-b  (total by tt-line.obj-code).
        accumulate tt-line.eff-doc-qnty  (total).
        accumulate tt-line.object-sum  (total).
        accumulate tt-line.tot-r-b  (total).
        if last-of (tt-line.type-line) and (tt-line.type-line = "2услуги") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row( (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)
                                           + "|" +        "Услуги"
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))).
        end.                                   
        if last-of (tt-line.type-line) and (tt-line.type-line = "3соп.тов.") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.  
                                           Report:table-row((if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)  
                                           + "|" +        "Соп.товары"
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))).
        end.                                   
        if last-of (tt-line.type-line) and (tt-line.type-line = "4неуказ.") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row((if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)  
                                           + "|" +        "Не указ."
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))). 
        end.                                                                       
        if last-of (tt-line.obj-code) then Report:table-subtotal( ""
                                           + "|" +        ""
                                           + "|" +        "Итого по объекту"
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.obj-code tt-line.eff-doc-qnty) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.obj-code tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))) 
                                           + "|" +        (if (accum total by tt-line.obj-code tt-line.object-sum) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.obj-code tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99")))
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.obj-code tt-line.tot-r-b) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.obj-code tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99")))).
                                        
    end.
end.


/* Печать отчёта в случае, если классификация - ДАТА и детализация - ПО ТИПАМ ТОВАРА */
if  v-rs-klass:SCREEN-VALUE in frame {&FRAME-NAME} = "date":U 
    and v-rs-det:SCREEN-VALUE in frame {&FRAME-NAME} = "goodtype":U then do: 
     for each tt-line no-lock break by tt-line.chk-date by tt-line.chk-time by tt-line.doc-code by tt-line.type-line:
         if first-of (tt-line.chk-date) then Report:table-group( "Дата " + (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) ).
         if (tt-line.type-line = "1топливо") then
         Report:table-row(  (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
             + "|" +    (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
             + "|" +    (if tt-line.d-card = ? then "" else tt-line.d-card)
             + "|" +    (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
             + "|" +    (if tt-line.obj-name = ? then "" else tt-line.obj-name)    
             + "|" +    (if tt-line.gds-name = ? then "" else tt-line.gds-name)    
             + "|" +    (if tt-line.eff-doc-qnty  = ? then "" else string(tt-line.eff-doc-qnty))     
             + "|" +    (if tt-line.object-sum  = ? then "" else string(tt-line.object-sum))  
             + "|" +    (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")  
             + "|" +    (if tt-line.tot-r-b  = ? then "" else string(tt-line.tot-r-b))
         ).
        accumulate tt-line.eff-doc-qnty  (total  by tt-line.type-line).
        accumulate tt-line.object-sum  (total  by tt-line.type-line).
        accumulate tt-line.tot-r-b  (total by  tt-line.type-line).
        accumulate tt-line.eff-doc-qnty  (total by tt-line.chk-date).
        accumulate tt-line.object-sum  (total by tt-line.chk-date).
        accumulate tt-line.tot-r-b  (total by tt-line.chk-date).
        accumulate tt-line.eff-doc-qnty  (total).
        accumulate tt-line.object-sum  (total).
        accumulate tt-line.tot-r-b  (total).
        if last-of (tt-line.type-line) and (tt-line.type-line = "2услуги") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row( (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)
                                           + "|" +        "Услуги"
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))).
        end.                                   
        if last-of (tt-line.type-line) and (tt-line.type-line = "3соп.тов.") then do: 
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row((if tt-line.chk-date = ? then "" else string(tt-line.chk-date))
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)  
                                           + "|" +        "Соп.товары"
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))). 
        end.                                    
        if last-of (tt-line.type-line) and (tt-line.type-line = "4неуказ.") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row((if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)  
                                           + "|" +        "Не указ."
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))).
        end.                                                                      
        if last-of (tt-line.chk-date) then Report:table-subtotal( ""
                                           + "|" +        ""
                                           + "|" +        "Итого по дате"
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.chk-date tt-line.eff-doc-qnty) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.chk-date tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99")))
                                           + "|" +        (if (accum total by tt-line.chk-date tt-line.object-sum) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.chk-date tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))) 
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.chk-date tt-line.tot-r-b) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.chk-date tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99")))).     
    end.
end.

/* Печать отчёта в случае, если классификация - НОМЕР КАРТЫ и детализация - ПО ТИПАМ ТОВАРА */
if  v-rs-klass:SCREEN-VALUE in frame {&FRAME-NAME} = "card":U 
    and v-rs-det:SCREEN-VALUE in frame {&FRAME-NAME} = "goodtype":U then do: 
    for each tt-line no-lock break by tt-line.d-card by tt-line.chk-date by tt-line.chk-time by tt-line.doc-code by tt-line.type-line:
         if first-of (tt-line.d-card) then Report:table-group( "Номер карты " + (if tt-line.d-card = ? then "" else tt-line.d-card) ).
         if (tt-line.type-line = "1топливо") then
         Report:table-row(  (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
             + "|" +    (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
             + "|" +    (if tt-line.d-card = ? then "" else tt-line.d-card)
             + "|" +    (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
             + "|" +    (if tt-line.obj-name = ? then "" else tt-line.obj-name)    
             + "|" +    (if tt-line.gds-name = ? then "" else tt-line.gds-name)     
             + "|" +    (if tt-line.eff-doc-qnty  = ? then "" else string(tt-line.eff-doc-qnty))     
             + "|" +    (if tt-line.object-sum  = ? then "" else string(tt-line.object-sum))  
             + "|" +    (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")  
             + "|" +    (if tt-line.tot-r-b  = ? then "" else string(tt-line.tot-r-b))
         ).
        accumulate tt-line.eff-doc-qnty  (total by tt-line.type-line).
        accumulate tt-line.object-sum  (total by tt-line.type-line).
        accumulate tt-line.tot-r-b  (total by tt-line.type-line).
        accumulate tt-line.eff-doc-qnty  (total by tt-line.d-card).
        accumulate tt-line.object-sum  (total by tt-line.d-card).
        accumulate tt-line.tot-r-b  (total by tt-line.d-card).
        accumulate tt-line.eff-doc-qnty  (total).
        accumulate tt-line.object-sum  (total).
        accumulate tt-line.tot-r-b  (total).
        if last-of (tt-line.type-line) and (tt-line.type-line = "2услуги") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row( (if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))  
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)
                                           + "|" +        "Услуги"
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))).
        end.                                   
        if last-of (tt-line.type-line) and (tt-line.type-line = "3соп.тов.") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row((if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)  
                                           + "|" +        "Соп.товары"
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))).
        end.                                     
        if last-of (tt-line.type-line) and (tt-line.type-line = "4неуказ.") then do:
                                           tt-line.discount = ((accum total by tt-line.type-line  tt-line.object-sum) - (accum total by tt-line.type-line tt-line.tot-r-b)) * 100 / (accum total by tt-line.type-line  tt-line.object-sum) no-error.
                                           Report:table-row((if tt-line.chk-date = ? then "" else string(tt-line.chk-date)) 
                                           + "|" +        (if tt-line.chk-time = ? then "" else string(tt-line.chk-time,"hh:mm"))    
                                           + "|" +        (if tt-line.d-card = ? then "" else tt-line.d-card)
                                           + "|" +        (if tt-line.pay-desk = ? then "" else string(tt-line.pay-desk))
                                           + "|" +        (if tt-line.obj-name = ? then "" else tt-line.obj-name)  
                                           + "|" +        "Не указ."
                                           + "|" +        left-trim(string(accum total by  tt-line.type-line  tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        left-trim(string(accum total by tt-line.type-line  tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))
                                           + "|" +        (if tt-line.discount  = ? then "" else string(tt-line.discount,"->>>,>>9.99") + "%")
                                           + "|" +        left-trim(string(accum total by tt-line.type-line tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99"))).  
        end.                                                                    
        if last-of (tt-line.d-card) then Report:table-subtotal( ""
                                           + "|" +        ""
                                           + "|" +        "Итого по номеру карты"
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.d-card tt-line.eff-doc-qnty) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.d-card tt-line.eff-doc-qnty, "->>>,>>>,>>>,>>>,>>9.99")))
                                           + "|" +        (if (accum total by tt-line.d-card tt-line.object-sum) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.d-card tt-line.object-sum, "->>>,>>>,>>>,>>>,>>9.99"))) 
                                           + "|" +        ""
                                           + "|" +        (if (accum total by tt-line.d-card tt-line.tot-r-b) = ? then "" 
                                                          else left-trim(string(accum total by tt-line.d-card tt-line.tot-r-b, "->>>,>>>,>>>,>>>,>>9.99")))).     
    end.
end.



v-total-qnty = accum total tt-line.eff-doc-qnty.
v-total-sum1 = accum total tt-line.object-sum.
v-total-sum2 = accum total tt-line.tot-r-b.

Report:table-total( "Итого"
     + "|" +        ""
     + "|" +        ""
     + "|" +        ""
     + "|" +        ""
     + "|" +        ""
     + "|" +        (if (v-total-qnty) = ? then "" 
                     else left-trim(string(v-total-qnty, "->>>,>>>,>>>,>>>,>>9.99"))) 
     + "|" +        (if (v-total-sum1) = ? then "" 
                     else left-trim(string(v-total-sum1, "->>>,>>>,>>>,>>>,>>9.99"))) 
     + "|" +        ""
     + "|" +        (if (v-total-sum2) = ? then "" 
                     else left-trim(string(v-total-sum2, "->>>,>>>,>>>,>>>,>>9.99")))  ).
       
     
     
     
report:worksheet("end").
delete object Report. 

  

xslt-path = search("exe\template.xsl").
rep-out-unit = new rep-out ().
rep-out-unit:office(xml_tmp, xslt-path). 

END PROCEDURE.
/* Конец процедуры печати отчёта */

/* Процедура для заполнения временной таблицы tt-line */ 
PROCEDURE proc-tt :
for first ub.bar-code no-lock where ub.bar-code.b-code = chk-gds-pay.b-code  
    :
    if (x-SelectGood = {&g-all}) or (can-find(first gds-list no-lock where gds-list.gds-code = ub.bar-code.gds-code))
         then do:
         create tt-line.
         /*Дата чека*/
         tt-line.chk-date = ub.chk-doc.chk-date.
         /*Время*/
         tt-line.chk-time = ub.chk-doc.chk-time.
         /*Номер карты*/
         tt-line.d-card = ub.chk-discnt.d-card.
         if tt-line.d-card = ? or tt-line.d-card = "" then do:
             for first chk-pay no-lock 
                  where chk-pay.doc-code = chk-doc.doc-code
                  and chk-pay.line-num = chk-gds-pay.cpline-num
                      :
                      tt-line.d-card = chk-pay.pay-card.
             end.
         end.     
         /*№ кассы*/
         tt-line.pay-desk = ub.chk-doc.pay-desk.
         /*Объект*/
         tt-line.obj-name = obj-list.obj-name .
         tt-line.obj-code = obj-list.obj-code.
         tt-line.obj-type = obj-list.obj-type.
         /*Товар*/
         for first ub.goods no-lock 
             where ub.goods.gds-code = ub.bar-code.gds-code 
             :
             tt-line.gds-name = ub.goods.gds-name.
          end.          
         /*Количество*/
         tt-line.eff-doc-qnty = ub.chk-gds-pay.eff-doc-qnty.
         /*Сумма без скидки*/
         tt-line.object-sum = chk-gds.src-sum * (chk-gds-pay.eff-doc-qnty /  chk-gds.doc-qnty) no-error.
         /*Сумма со скидкой*/
         tt-line.tot-r-b = ub.chk-gds-pay.tot-r-b.                          
         /*Скидка*/
         tt-line.discount = (tt-line.object-sum - tt-line.tot-r-b) * 100 / tt-line.object-sum no-error.
         tt-line.line-type = entry(1,chk-gds-pay.line-type,{&delim-par}).
         tt-line.doc-code = chk-doc.doc-code.
         case tt-line.line-type:
             when {&petrolium} then do: tt-line.type-line = "1топливо". end.
             when {&gds-office} then do: tt-line.type-line = "2услуги". end.
             when {&gds-goods} then do: tt-line.type-line = "3соп.тов.". end.
             otherwise do: tt-line.type-line = "4неуказ.". end.
         end case. 
    end.       
end.        
                               
END PROCEDURE.    
/* Конец процедуры для заполнения временной таблицы tt-line */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE my-var s-object 
PROCEDURE my-var :
/*------------------------------------------------------------------------------
  Purpose:     здесь происходит вызов  значений переменных
  например  Название отчета, может быть еще пример шапки???

------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed s-object 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Receive and process 'state-changed' methods
               (issued by 'new-state' event).
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.


  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      /* link-changed */
  END CASE.
  END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

