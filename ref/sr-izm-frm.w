&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input  parameter iMode as character  no-undo.
define input  parameter inode-code as integer no-undo.

 
/* Local Variable Definitions ---                                       */
{cmp\str-glbl.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES sr-izmerenia

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame sr-izmerenia.node-code ~
sr-izmerenia.sr-model sr-izmerenia.sr-type-izm sr-izmerenia.sr-level ~
sr-izmerenia.sr-type-level-measuring sr-izmerenia.sr-temp-line ~
sr-izmerenia.sr-abs-err-neft-water sr-izmerenia.sr-relative-err-neft-water ~
sr-izmerenia.sr-abs-err-water sr-izmerenia.sr-relative-err-water ~
sr-izmerenia.sr-temperature sr-izmerenia.sr-abs-err-temp-vol ~
sr-izmerenia.sr-abs-err-temp-dens sr-izmerenia.sr-density ~
sr-izmerenia.sr-type-id sr-izmerenia.sr-abs-err-dens ~
sr-izmerenia.sr-relative-err-dens sr-izmerenia.sr-abs-err-dens-lgas-liquid ~
sr-izmerenia.sr-abs-err-dens-lgas-vapor sr-izmerenia.sr-Weight ~
sr-izmerenia.sr-otnos sr-izmerenia.sr-not-used 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame sr-izmerenia.sr-model ~
sr-izmerenia.sr-type-izm sr-izmerenia.sr-level ~
sr-izmerenia.sr-abs-err-neft-water sr-izmerenia.sr-relative-err-neft-water ~
sr-izmerenia.sr-abs-err-water sr-izmerenia.sr-relative-err-water ~
sr-izmerenia.sr-temperature sr-izmerenia.sr-abs-err-temp-vol ~
sr-izmerenia.sr-abs-err-temp-dens sr-izmerenia.sr-density ~
sr-izmerenia.sr-type-id sr-izmerenia.sr-abs-err-dens ~
sr-izmerenia.sr-relative-err-dens sr-izmerenia.sr-abs-err-dens-lgas-liquid ~
sr-izmerenia.sr-abs-err-dens-lgas-vapor sr-izmerenia.sr-Weight ~
sr-izmerenia.sr-otnos sr-izmerenia.sr-not-used 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame sr-izmerenia
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame sr-izmerenia
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH sr-izmerenia SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH sr-izmerenia SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame sr-izmerenia
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame sr-izmerenia


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS sr-izmerenia.sr-model ~
sr-izmerenia.sr-type-izm sr-izmerenia.sr-level ~
sr-izmerenia.sr-abs-err-neft-water sr-izmerenia.sr-relative-err-neft-water ~
sr-izmerenia.sr-abs-err-water sr-izmerenia.sr-relative-err-water ~
sr-izmerenia.sr-temperature sr-izmerenia.sr-abs-err-temp-vol ~
sr-izmerenia.sr-abs-err-temp-dens sr-izmerenia.sr-density ~
sr-izmerenia.sr-type-id sr-izmerenia.sr-abs-err-dens ~
sr-izmerenia.sr-relative-err-dens sr-izmerenia.sr-abs-err-dens-lgas-liquid ~
sr-izmerenia.sr-abs-err-dens-lgas-vapor sr-izmerenia.sr-Weight ~
sr-izmerenia.sr-otnos sr-izmerenia.sr-not-used 
&Scoped-define ENABLED-TABLES sr-izmerenia
&Scoped-define FIRST-ENABLED-TABLE sr-izmerenia
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 RECT-4 Btn_OK ~
Btn_Cancel 
&Scoped-Define DISPLAYED-FIELDS sr-izmerenia.node-code ~
sr-izmerenia.sr-model sr-izmerenia.sr-type-izm sr-izmerenia.sr-level ~
sr-izmerenia.sr-type-level-measuring sr-izmerenia.sr-temp-line ~
sr-izmerenia.sr-abs-err-neft-water sr-izmerenia.sr-relative-err-neft-water ~
sr-izmerenia.sr-abs-err-water sr-izmerenia.sr-relative-err-water ~
sr-izmerenia.sr-temperature sr-izmerenia.sr-abs-err-temp-vol ~
sr-izmerenia.sr-abs-err-temp-dens sr-izmerenia.sr-density ~
sr-izmerenia.sr-type-id sr-izmerenia.sr-abs-err-dens ~
sr-izmerenia.sr-relative-err-dens sr-izmerenia.sr-abs-err-dens-lgas-liquid ~
sr-izmerenia.sr-abs-err-dens-lgas-vapor sr-izmerenia.sr-Weight ~
sr-izmerenia.sr-otnos sr-izmerenia.sr-not-used 
&Scoped-define DISPLAYED-TABLES sr-izmerenia
&Scoped-define FIRST-DISPLAYED-TABLE sr-izmerenia


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button Btn_Cancel auto-end-key 
     label "Выход" 
     size 15 by 1.13.

define button Btn_OK auto-go 
     label "Ввод" 
     size 15 by 1.13.

define rectangle RECT-1
     edge-pixels 2 graphic-edge  no-fill   
     size 99 by 9.08.

define rectangle RECT-2
     edge-pixels 2 graphic-edge  no-fill   
     size 99 by 5.

define rectangle RECT-3
     edge-pixels 2 graphic-edge  no-fill   
     size 99 by 7.67.

define rectangle RECT-4
     edge-pixels 2 graphic-edge  no-fill   
     size 99 by 2.88.
DEFINE VARIABLE temp-line-text AS CHARACTER FORMAT "x(4)" INITIAL "1/°С" 
     LABEL "nnn" 
      VIEW-AS TEXT .

DEFINE VARIABLE abs-err-neft-water-text AS CHARACTER FORMAT "x(2)" INITIAL "мм" 
     LABEL "nnn" 
      VIEW-AS TEXT .
DEFINE VARIABLE relative-err-neft-water-text AS CHARACTER FORMAT "x(1)" INITIAL "%" 
     LABEL "nnn" 
      VIEW-AS TEXT .
DEFINE VARIABLE abs-err-water-text AS CHARACTER FORMAT "x(2)" INITIAL "мм" 
     LABEL "nnn" 
      VIEW-AS TEXT .
DEFINE VARIABLE relative-err-water-text AS CHARACTER FORMAT "x(1)" INITIAL "%" 
     LABEL "nnn" 
      VIEW-AS TEXT .

DEFINE VARIABLE abs-err-temp-vol-text AS CHARACTER FORMAT "x(2)" INITIAL "°С" 
     LABEL "nnn" 
      VIEW-AS TEXT .
DEFINE VARIABLE abs-err-temp-dens-text AS CHARACTER FORMAT "x(2)" INITIAL "°С" 
     LABEL "nnn" 
      VIEW-AS TEXT .

DEFINE VARIABLE abs-err-dens-text AS CHARACTER FORMAT "x(5)" INITIAL "кг/м3" 
     LABEL "nnn" 
      VIEW-AS TEXT .
DEFINE VARIABLE relative-err-dens-text AS CHARACTER FORMAT "x(1)" INITIAL "%" 
     LABEL "nnn" 
      VIEW-AS TEXT .
DEFINE VARIABLE abs-err-dens-lgas-liquid-text AS CHARACTER FORMAT "x(5)" INITIAL "кг/м3" 
     LABEL "nnn" 
      VIEW-AS TEXT .
DEFINE VARIABLE abs-err-dens-lgas-vapor-text AS CHARACTER FORMAT "x(5)" INITIAL "кг/м3" 
     LABEL "nnn" 
      VIEW-AS TEXT .

DEFINE VARIABLE otnos-text AS CHARACTER FORMAT "x(1)" INITIAL "%" 
     LABEL "nnn" 
      VIEW-AS TEXT .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
define query Dialog-Frame for 
      sr-izmerenia scrolling.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

define frame Dialog-Frame
     Btn_OK at row 1.75 col 6.13 widget-id 64
     Btn_Cancel at row 1.75 col 22.5 widget-id 62
     sr-izmerenia.sr-not-used at row 1.9 col 40 widget-id 116
          view-as toggle-box
          size 40 by .79
     sr-izmerenia.node-code at row 2 col 85.5 colon-aligned widget-id 66
          view-as fill-in 
          size 14 by 1
     sr-izmerenia.sr-model at row 3.21 col 29.5 colon-aligned widget-id 94
          view-as fill-in 
          size 70 by 1
     sr-izmerenia.sr-type-izm at row 4.63 col 29.5 colon-aligned widget-id 110
          view-as combo-box inner-lines 5
          list-item-pairs "Измерительная система",2,
                     "Автоматизированное СИ",0,
                     "Неавтоматизированное СИ",1
          drop-down-list
          size 70 by 1
     sr-izmerenia.sr-level at row 6.96 col 5.5 widget-id 92
          view-as toggle-box
          size 13.38 by .79
     sr-izmerenia.sr-type-level-measuring at row 7.92 col 39.5 colon-aligned widget-id 112
          view-as combo-box inner-lines 5
          list-item-pairs "Рулетка 2-го класса точности (Расчет по ГОСТ 7502)",1,
                     "Плотномер-уровнемер ПЛОТ-3Б-1РУ (Расчет по формуле)",2,
                     "Статичная величина",0
          drop-down-list
          size 48 by 1
     sr-izmerenia.sr-temp-line at row 9.13 col 61.5 colon-aligned widget-id 104
          view-as fill-in 
          size 26 by 1
          temp-line-text no-labels at row 9.3 col 95
     sr-izmerenia.sr-abs-err-neft-water at row 10.33 col 61.5 colon-aligned widget-id 82
          view-as fill-in 
          size 26 by 1
          abs-err-neft-water-text no-labels at row 10.5 col 95
     sr-izmerenia.sr-relative-err-neft-water at row 11.46 col 61.5 colon-aligned widget-id 100
          view-as fill-in 
          size 26 by 1
          relative-err-neft-water-text no-labels at row 11.6 col 95
     sr-izmerenia.sr-abs-err-water at row 12.71 col 61.5 colon-aligned widget-id 88
          view-as fill-in 
          size 26 by 1
          abs-err-water-text no-labels at row 12.85 col 95
     sr-izmerenia.sr-relative-err-water at row 13.92 col 61.5 colon-aligned widget-id 102
          view-as fill-in 
          size 26 by 1
          relative-err-water-text no-labels at row 14.07 col 95
     sr-izmerenia.sr-temperature at row 16.04 col 5.5 widget-id 106
          view-as toggle-box
          size 20 by .79
     sr-izmerenia.sr-abs-err-temp-vol at row 17.21 col 61.5 colon-aligned widget-id 86
          view-as fill-in 
          size 26 by 1
          abs-err-temp-vol-text no-labels at row 17.35 col 95 
     sr-izmerenia.sr-abs-err-temp-dens at row 18.42 col 61.5 colon-aligned widget-id 84
          view-as fill-in 
          size 26 by 1
          abs-err-temp-dens-text no-labels at row 18.57 col 95
     sr-izmerenia.sr-density at row 21.04 col 4.5 widget-id 90
          view-as toggle-box
          size 17 by .79
     sr-izmerenia.sr-type-id at row 21.96 col 40.5 colon-aligned widget-id 108
          view-as combo-box inner-lines 5
          list-item-pairs "Ареометр откалиброванный при 15°С",1,
                     "Ареометр откалиброванный при 20°С",2,
                     "Поточный плотномер",3,
                     "Погружной плотномер",4,
                     "Канал измерения плотности (с поточным плотномером)",5,
                     "Канал измерения плотности (без поточного плотномера)",6
          drop-down-list
          size 56 by 1
     sr-izmerenia.sr-abs-err-dens at row 23.42 col 60.5 colon-aligned widget-id 76
          view-as fill-in 
          size 26 by 1
          abs-err-dens-text  no-labels at row 23.6 col 95 
     sr-izmerenia.sr-relative-err-dens at row 24.63 col 60.5 colon-aligned widget-id 98
          view-as fill-in 
          size 26 by 1
          relative-err-dens-text no-labels at row 24.8 col 95
     sr-izmerenia.sr-abs-err-dens-lgas-liquid at row 25.75 col 60.5 colon-aligned widget-id 78
          view-as fill-in 
          size 26 by 1
          abs-err-dens-lgas-liquid-text no-labels at row 25.9 col 95
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable  widget-id 100.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
define frame Dialog-Frame
     sr-izmerenia.sr-abs-err-dens-lgas-vapor at row 26.96 col 60.5 colon-aligned widget-id 80
          view-as fill-in 
          size 26 by 1
          abs-err-dens-lgas-vapor-text no-labels at row 27.1 col 95
     sr-izmerenia.sr-Weight at row 28.92 col 4.5 widget-id 114
          view-as toggle-box
          size 13.38 by .79
     sr-izmerenia.sr-otnos at row 30.04 col 61.5 colon-aligned widget-id 96
          view-as fill-in 
          size 25 by 1
          otnos-text no-labels at row 30.2 col 95
     RECT-1 at row 6.25 col 2.5 widget-id 68
     RECT-2 at row 15.54 col 2.5 widget-id 70
     RECT-3 at row 20.75 col 2.5 widget-id 72
     RECT-4 at row 28.63 col 2.5 widget-id 74
     space(1.24) skip(0.48)
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         title "Средства измерения" widget-id 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
assign 
       frame Dialog-Frame:SCROLLABLE       = false
       frame Dialog-Frame:HIDDEN           = true.

/* SETTINGS FOR FILL-IN sr-izmerenia.node-code IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
assign 
       sr-izmerenia.node-code:READ-ONLY in frame Dialog-Frame        = true.

/* SETTINGS FOR FILL-IN sr-izmerenia.sr-temp-line IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX sr-izmerenia.sr-type-level-measuring IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "ub.sr-izmerenia"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
on window-close of frame Dialog-Frame /* Средства измерения */
do:
  apply "END-ERROR":U to self.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
on choose of Btn_OK in frame Dialog-Frame /* Ввод */
do:
  def var vMess as char no-undo.
  
  run check-sr-type-id no-error.
  if error-status:error 
  then return no-apply .
  
  run check-neft-water no-error.
  if error-status:error 
  then return no-apply .
  
  run check-err-water no-error.
  if error-status:error 
  then return no-apply .
  
  run Check-err-dens no-error.
  if error-status:error 
  then return no-apply .
  
  run check-sr-otnos no-error.
  if error-status:error 
  then return no-apply .
  
  /* Отключен контроль обязательности и нулевого значения 14.05.2021
  run Check-sr-temp-line no-error.
  if error-status:error then
     return no-apply.
  */
     
  run Check-sr-abs-err-temp-vol no-error.
  if error-status:error then
     return no-apply.

  run Check-sr-abs-err-temp-dens no-error.
  if error-status:error then
     return no-apply.
     
  assign
     sr-izmerenia.sr-not-used
     sr-izmerenia.sr-model
     sr-izmerenia.sr-type-izm 
  
     sr-izmerenia.sr-level
     sr-izmerenia.sr-type-level-measuring
     sr-izmerenia.sr-temp-line
     sr-izmerenia.sr-abs-err-neft-water
     sr-izmerenia.sr-relative-err-neft-water
     sr-izmerenia.sr-abs-err-water
     sr-izmerenia.sr-relative-err-water
     
     sr-izmerenia.sr-temperature
     sr-izmerenia.sr-abs-err-temp-vol
     sr-izmerenia.sr-abs-err-temp-dens
     
     sr-izmerenia.sr-density
     sr-izmerenia.sr-abs-err-dens
     sr-izmerenia.sr-relative-err-dens
     sr-izmerenia.sr-abs-err-dens-lgas-liquid
     sr-izmerenia.sr-abs-err-dens-lgas-vapor
     
     
     sr-izmerenia.sr-Weight
     sr-izmerenia.sr-otnos
  .

  if not(    sr-izmerenia.sr-level
          or sr-izmerenia.sr-density
          or sr-izmerenia.sr-temperature
          or sr-izmerenia.sr-Weight)
  then do:
     message "Не выбран ни уровень, ни температура, ни плотность, ни масса"
        view-as alert-box.
     return no-apply.
  end. 
  vMess = "". 
  if       sr-izmerenia.sr-level
     and   sr-izmerenia.sr-temp-line               = ?
     and   sr-izmerenia.sr-abs-err-neft-water      = ?
     and   sr-izmerenia.sr-relative-err-neft-water = ?
     and   sr-izmerenia.sr-abs-err-water           = ?
     and   sr-izmerenia.sr-relative-err-water      = ?

  then 
     vMess = "Не указаны характеристики средства измерения уровня" .
             
              
  if     sr-izmerenia.sr-temperature
     and sr-izmerenia.sr-abs-err-temp-vol  = ?
     and sr-izmerenia.sr-abs-err-temp-dens = ?
  then 
     vMess = vMess  
           + (if vMess eq "" then "" else {&new-line} )
           + "Не указаны характеристики средства измерения температуры.".
     
   if    sr-izmerenia.sr-density
     and sr-izmerenia.sr-abs-err-dens             = ?
     and sr-izmerenia.sr-relative-err-dens        = ?
     and sr-izmerenia.sr-abs-err-dens-lgas-liquid = ?
     and sr-izmerenia.sr-abs-err-dens-lgas-vapor  = ?
   then
      vMess = vMess  
            + (if vMess eq "" then "" else {&new-line})
            + "Не указаны характеристики средства измерения плотности.".
     
  if vMess ne ""
  then do:
     define variable vOk as logical no-undo.
      message vMess skip 
        "Вы уверены, что хотите закончить настройку средства измерения?"
      view-as alert-box question buttons OK-Cancel update vOk.
     
     if not vOk
     then
        return no-apply.
  end.
  
  /* проверки значений */
  define variable v-msg2  as character no-undo . /* "...воды выходит за границы допустимого диапазона..." */
  define variable v-delta as decimal decimals 2 no-undo . /* границы допустимого диапазона абсолютной погрешности измерений */

  if sr-izmerenia.sr-model > "" then .
  else do: /* Название не может быть пустым */
    message "Пожалуйста заполните наименование модели средства измерения"
    view-as alert-box.
    apply "entry" to sr-izmerenia.sr-model in frame {&frame-name} .
    return no-apply .
  end .

  assign
    v-msg2 = "выходит за границы допустимого диапазона"
    v-delta = 3 
  .
  if sr-izmerenia.sr-abs-err-neft-water > v-delta or sr-izmerenia.sr-abs-err-neft-water < (-1) * v-delta then do :
    message substitute("&1 &2&3(+/-)&4 мм",
                 sr-izmerenia.sr-abs-err-neft-water:label in frame {&frame-name}, v-msg2, {&new-line}, string(v-delta, "9") )
    view-as alert-box.
    apply "entry" to sr-izmerenia.sr-abs-err-neft-water in frame {&frame-name} .
    return no-apply .
  end.
  if sr-izmerenia.sr-abs-err-water > v-delta or sr-izmerenia.sr-abs-err-water < (-1) * v-delta then do :
    message substitute("&1 &2&3(+/-)&4 мм",
                 sr-izmerenia.sr-abs-err-water:label in frame {&frame-name}, v-msg2, {&new-line}, string(v-delta, "9") )
    view-as alert-box.
    apply "entry" to sr-izmerenia.sr-abs-err-water in frame {&frame-name} .
    return no-apply .
  end.
  
  case sr-izmerenia.sr-type-izm:
     when 1 then v-delta = 3.
     when 2 then v-delta = 0.5.
     when 3 then v-delta = 1.5.
  end case.
  if sr-izmerenia.sr-abs-err-dens > v-delta or sr-izmerenia.sr-abs-err-dens < (-1) * v-delta then do :
    message substitute("&1 &2&3(+/-)&4 кг/м3",
                 sr-izmerenia.sr-abs-err-dens:label in frame {&frame-name}, v-msg2, {&new-line}, string(v-delta, "9.9") )
    view-as alert-box.
    apply "entry" to sr-izmerenia.sr-abs-err-dens in frame {&frame-name} .
    return no-apply .
  end.
  
  if sr-izmerenia.sr-abs-err-temp-vol > v-delta or sr-izmerenia.sr-abs-err-temp-vol < (-1) * v-delta then do :
    message substitute("&1 &2&3(+/-)&4 °С",
                 sr-izmerenia.sr-abs-err-temp-vol:label in frame {&frame-name}, v-msg2, {&new-line}, string(v-delta, "9.9") )
    view-as alert-box.
    apply "entry" to sr-izmerenia.sr-abs-err-temp-vol in frame {&frame-name} .
    return no-apply .
  end.
  if sr-izmerenia.sr-abs-err-temp-dens > v-delta or sr-izmerenia.sr-abs-err-temp-dens < (-1) * v-delta then do :
    message substitute("&1 &2&3(+/-)&4 °С",
                 sr-izmerenia.sr-abs-err-temp-dens:label in frame {&frame-name}, v-msg2, {&new-line}, string(v-delta, "9.9") )
    view-as alert-box.
    apply "entry" to sr-izmerenia.sr-abs-err-temp-dens in frame {&frame-name} .
    return no-apply .
  end.
  v-delta = 0.65 .
  if sr-izmerenia.sr-otnos > v-delta or sr-izmerenia.sr-otnos < (-1) * v-delta then do :
    message substitute("&1 &2&3(+/-)&4 %",
                 sr-izmerenia.sr-otnos:label in frame {&frame-name}, v-msg2, {&new-line}, string(v-delta, "9.99") )
    view-as alert-box.
    apply "entry" to sr-izmerenia.sr-otnos in frame {&frame-name} .
    return no-apply .
  end.
  
  if not sr-izmerenia.sr-density
  then 
     assign
        sr-izmerenia.sr-type-id                  = ?
        sr-izmerenia.sr-abs-err-dens             = ?
        sr-izmerenia.sr-relative-err-dens        = ?
        sr-izmerenia.sr-abs-err-dens-lgas-liquid = ?
        sr-izmerenia.sr-abs-err-dens-lgas-vapor  = ?
        sr-izmerenia.sr-relative-err-water       = ?
     .
  if not sr-izmerenia.sr-level
  then 
     assign
        sr-izmerenia.sr-type-level-measuring    = 0
        sr-izmerenia.sr-temp-line               = ?
        sr-izmerenia.sr-abs-err-neft-water      = ?
        sr-izmerenia.sr-relative-err-neft-water = ?
        sr-izmerenia.sr-abs-err-water           = ?
        sr-izmerenia.sr-relative-err-water      = ?
     .
   if not sr-izmerenia.sr-Weight
  then 
     assign
        sr-izmerenia.sr-otnos                  = ?
             .
   if not sr-izmerenia.sr-temperature
  then 
     
     assign
        sr-izmerenia.sr-abs-err-temp-vol  = ?
        sr-izmerenia.sr-abs-err-temp-dens = ?
     .
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sr-izmerenia.sr-type-izm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sr-izmerenia.sr-type-izm Dialog-Frame
on value-changed of sr-izmerenia.sr-type-izm in frame Dialog-Frame /* аси */
do:
   assign 
       sr-izmerenia.sr-type-izm.
       
   if sr-izmerenia.sr-type-izm ne 2
   then do:
      sr-izmerenia.sr-Weight = no.
      sr-izmerenia.sr-Weight:checked = no.
      sr-izmerenia.sr-Weight:visible = no.
      RECT-4:visible = no.
   end.
   else do:
      sr-izmerenia.sr-Weight:visible = yes.
      RECT-4:visible = yes.
   end.
   apply "VALUE-CHANGED" to sr-izmerenia.sr-Weight.
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME sr-izmerenia.sr-density
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sr-izmerenia.sr-density Dialog-Frame
on value-changed of sr-izmerenia.sr-density in frame Dialog-Frame /* Плотность */
do:
  assign
     sr-izmerenia.sr-density
  .
  
  
  assign
        sr-izmerenia.sr-type-id                  :visible = sr-izmerenia.sr-density
        sr-izmerenia.sr-abs-err-dens             :visible = sr-izmerenia.sr-density
        sr-izmerenia.sr-relative-err-dens        :visible = sr-izmerenia.sr-density
        sr-izmerenia.sr-abs-err-dens-lgas-liquid :visible = sr-izmerenia.sr-density
        sr-izmerenia.sr-abs-err-dens-lgas-vapor  :visible = sr-izmerenia.sr-density
        abs-err-dens-text             :visible = sr-izmerenia.sr-density
        relative-err-dens-text        :visible = sr-izmerenia.sr-density
        abs-err-dens-lgas-liquid-text :visible = sr-izmerenia.sr-density
        abs-err-dens-lgas-vapor-text  :visible = sr-izmerenia.sr-density
     .
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sr-izmerenia.sr-level
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sr-izmerenia.sr-level Dialog-Frame
on value-changed of sr-izmerenia.sr-level in frame Dialog-Frame /* Уровень */
do:
  assign
     sr-izmerenia.sr-level
  .
  
  assign
        sr-izmerenia.sr-type-level-measuring   :visible = sr-izmerenia.sr-level
        sr-izmerenia.sr-temp-line              :visible = sr-izmerenia.sr-level
        sr-izmerenia.sr-abs-err-neft-water     :visible = sr-izmerenia.sr-level
        sr-izmerenia.sr-relative-err-neft-water:visible = sr-izmerenia.sr-level
        sr-izmerenia.sr-abs-err-water          :visible = sr-izmerenia.sr-level
        sr-izmerenia.sr-relative-err-water     :visible = sr-izmerenia.sr-level
        temp-line-text              :visible = sr-izmerenia.sr-level
        abs-err-neft-water-text     :visible = sr-izmerenia.sr-level
        relative-err-neft-water-text:visible = sr-izmerenia.sr-level
        abs-err-water-text          :visible = sr-izmerenia.sr-level
        relative-err-water-text     :visible = sr-izmerenia.sr-level
     .
       
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sr-izmerenia.sr-otnos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sr-izmerenia.sr-otnos Dialog-Frame
on leave of sr-izmerenia.sr-otnos in frame Dialog-Frame /* Предел допускаемой относительной погрешности */
do:
  
  run check-sr-otnos no-error.
  if error-status:error 
  then return no-apply .
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sr-izmerenia.sr-temperature
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sr-izmerenia.sr-temperature Dialog-Frame
on value-changed of sr-izmerenia.sr-temperature in frame Dialog-Frame /* Температура */
do:
  assign
     sr-izmerenia.sr-temperature
  .
  

     
  assign
        sr-izmerenia.sr-abs-err-temp-vol  :visible = sr-izmerenia.sr-temperature
        sr-izmerenia.sr-abs-err-temp-dens :visible = sr-izmerenia.sr-temperature
        abs-err-temp-vol-text  :visible = sr-izmerenia.sr-temperature
        abs-err-temp-dens-text :visible = sr-izmerenia.sr-temperature
     .
       
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sr-izmerenia.sr-type-id
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sr-izmerenia.sr-type-id Dialog-Frame
on value-changed of sr-izmerenia.sr-type-id in frame Dialog-Frame /* Тип средства измерения плотности */
do:
   run check-sr-type-id no-error.
   if error-status:error 
   then return no-apply .
  
  
  
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME sr-izmerenia.sr-Weight
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL sr-izmerenia.sr-Weight Dialog-Frame
on value-changed of sr-izmerenia.sr-Weight in frame Dialog-Frame /* Масса */
do:
  assign
     sr-izmerenia.sr-Weight
  .
  
  assign
        sr-izmerenia.sr-otnos                  :visible = sr-izmerenia.sr-Weight
        otnos-text                  :visible = sr-izmerenia.sr-Weight
          .
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
then frame {&FRAME-NAME}:PARENT = active-window.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
   on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:
   find first sr-izmerenia where sr-izmerenia.node-code eq inode-code no-error.
   if not avail sr-izmerenia 
   then do:
      create sr-izmerenia.
      assign
         sr-izmerenia.sr-type-level-measuring = 0.
   end.
  run enable_UI.
  apply "VALUE-CHANGED" to sr-izmerenia.sr-type-izm.
  apply "VALUE-CHANGED" to sr-izmerenia.sr-level.
  apply "VALUE-CHANGED" to sr-izmerenia.sr-temperature.
  apply "VALUE-CHANGED" to sr-izmerenia.sr-density.
  apply "VALUE-CHANGED" to sr-izmerenia.sr-Weight.
  wait-for go of frame {&FRAME-NAME}.
end.
run disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-neft-Water Dialog-Frame 
procedure Check-neft-Water :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   do with frame Dialog-Frame:
      assign
         sr-izmerenia.sr-level
         /* sr-izmerenia.sr-level-product */ /* 09.03.2021 Отключено */
         sr-izmerenia.sr-type-id
         sr-izmerenia.sr-abs-err-neft-water
         sr-izmerenia.sr-relative-err-neft-water
         .
     
      if sr-izmerenia.sr-level then do:
         /* 09.03.2021 Отключено
         if sr-izmerenia.sr-level-product = "СУГ" and 
            (sr-izmerenia.sr-abs-err-neft-water = ? or sr-izmerenia.sr-abs-err-neft-water = 0.0) then
         do:
            message quoter("Абсолютная погрешность измерений уровня") "должно быть заполнено для СУГ"
            view-as alert-box. 
            return error.
         end.
         */
         if sr-izmerenia.sr-abs-err-neft-water = ? and sr-izmerenia.sr-relative-err-neft-water = ? then do:
            message 
               "Для сохранения должно быть заполнено хотя бы одно из полей:" skip
                " " quoter("Абсолютная погрешность измерений уровня") skip
                " " quoter("Относительная погрешность измерений уровня")
            view-as alert-box. 
            return error.
         end.
         if sr-izmerenia.sr-abs-err-neft-water = 0.0 and sr-izmerenia.sr-relative-err-neft-water = 0.0 then do:
            message 
               "Для сохранения хотя бы одно из полей должно быть ненулевым:" skip
                " " quoter("Абсолютная погрешность измерений уровня") skip
                " " quoter("Относительная погрешность измерений уровня")
            view-as alert-box. 
            return error.
         end.
         if sr-izmerenia.sr-abs-err-neft-water <> 0.0 and sr-izmerenia.sr-abs-err-neft-water <> ? and 
            sr-izmerenia.sr-relative-err-neft-water = 0.0 then do:
            message 
                "Поле" quoter("Относительная погрешность измерений уровня")
                "не должно быть нулевым"
            view-as alert-box.
            apply "entry" to sr-izmerenia.sr-relative-err-neft-water in frame {&frame-name} .
            return error.
         end.
         if sr-izmerenia.sr-relative-err-neft-water <> 0.0 and sr-izmerenia.sr-relative-err-neft-water <> ? and 
            sr-izmerenia.sr-abs-err-neft-water = 0.0 then do:
            message 
                "Поле" quoter("Абсолютная погрешность измерений уровня")
                "не должно быть нулевым"
            view-as alert-box.
            apply "entry" to sr-izmerenia.sr-abs-err-neft-water in frame {&frame-name} .
            return error.
         end.
      end.
   end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-err-Water Dialog-Frame 
procedure Check-err-Water :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   do with frame Dialog-Frame:
      assign
         sr-izmerenia.sr-level
         /* sr-izmerenia.sr-level-product */ /* 09.03.2021 Отключено */
         sr-izmerenia.sr-abs-err-water
         sr-izmerenia.sr-relative-err-water
         .
     
      if sr-izmerenia.sr-level /*and sr-izmerenia.sr-level-product <> "СУГ" */ /* 09.03.2021 Отключено */ then do: 
         if sr-izmerenia.sr-abs-err-water = ? and sr-izmerenia.sr-relative-err-water = ? then do:
            message 
               "Для сохранения должно быть заполнено хотя бы одно из полей:" skip
                " " quoter("Абсолютная погрешность измерений уровня подтоварной воды") skip
                " " quoter("Относительная погрешность измерений уровня подтоварной воды")
            view-as alert-box. 
            return error.
         end.
         if (sr-izmerenia.sr-abs-err-water      = 0.0 or sr-izmerenia.sr-abs-err-water      = ?) and
            (sr-izmerenia.sr-relative-err-water = 0.0 or sr-izmerenia.sr-relative-err-water = ?) then do:
            message 
               "Для сохранения хотя бы одно из полей должно быть ненулевым:" skip
                " " quoter("Абсолютная погрешность измерений уровня подтоварной воды") skip
                " " quoter("Относительная погрешность измерений уровня подтоварной воды")
            view-as alert-box. 
            return error.
         end.
         if sr-izmerenia.sr-abs-err-water = 0.0 then do:
            message 
                "Поле" skip
                " " quoter("Абсолютная погрешность измерений уровня подтоварной воды")
                "не должно быть нулевым"
            view-as alert-box.
            apply "entry" to sr-izmerenia.sr-abs-err-water in frame {&frame-name} .
            return error.
         end.
         if sr-izmerenia.sr-relative-err-water = 0.0 then do:
            message 
                "Поле" skip
                " " quoter("Относительная погрешность измерений уровня подтоварной воды")
                "не должно быть нулевым"
            view-as alert-box.
            apply "entry" to sr-izmerenia.sr-relative-err-water in frame {&frame-name} .
            return error.
         end.
      end.
   end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-err-dens Dialog-Frame 
procedure Check-err-dens :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   do with frame Dialog-Frame:
      assign
         sr-izmerenia.sr-density
         /* sr-izmerenia.sr-density-product */ /* 09.03.2021 Отключено */
         sr-izmerenia.sr-abs-err-dens
         sr-izmerenia.sr-relative-err-dens
         sr-izmerenia.sr-abs-err-dens-lgas-liquid
         sr-izmerenia.sr-abs-err-dens-lgas-vapor
         .
     
      if sr-izmerenia.sr-density then do:
         /* if sr-izmerenia.sr-density-product <> "СУГ" then do: */ /* 09.03.2021 Отключено */
            if sr-izmerenia.sr-abs-err-dens = ? and sr-izmerenia.sr-relative-err-dens = ? then do:
               message 
                  "Для сохранения должно быть заполнено хотя бы одно из полей:" skip
                   " " quoter("Абсолютная погрешность измерений плотности нефтепродукта") skip
                   " " quoter("Относительная погрешность измерений плотности нефтепродукта")
               view-as alert-box. 
               return error.
            end.
            if (sr-izmerenia.sr-abs-err-dens      = 0.0 or sr-izmerenia.sr-abs-err-dens      = ?) and
               (sr-izmerenia.sr-relative-err-dens = 0.0 or sr-izmerenia.sr-relative-err-dens = ?) then do:
               message 
                  "Для сохранения хотя бы одно из полей должно быть ненулевым:" skip
                   " " quoter("Абсолютная погрешность измерений плотности нефтепродукта") skip
                   " " quoter("Относительная погрешность измерений плотности нефтепродукта")
               view-as alert-box. 
               return error.
            end.
            if sr-izmerenia.sr-abs-err-dens <> 0.0 and sr-izmerenia.sr-abs-err-dens <> ? and 
               sr-izmerenia.sr-relative-err-dens = 0.0 then do:
               message 
                   "Поле" skip
                   " " quoter("Относительная погрешность измерений плотности нефтепродукта")
                   "не должно быть нулевым"
               view-as alert-box.
               apply "entry" to sr-izmerenia.sr-relative-err-dens in frame {&frame-name} .
               return error.
            end.
            if sr-izmerenia.sr-relative-err-dens <> 0.0 and sr-izmerenia.sr-relative-err-dens <> ? and 
               sr-izmerenia.sr-abs-err-dens = 0.0 then do:
               message 
                   "Поле" skip
                   " " quoter("Абсолютная погрешность измерений плотности нефтепродукта")
                   "не должно быть нулевым"
               view-as alert-box.
               apply "entry" to sr-izmerenia.sr-abs-err-dens in frame {&frame-name} .
               return error.
            end.
         /* end. */
         /* else do: */ /* sr-izmerenia.sr-density-product = "СУГ" */ /* 09.03.2021 Отключено */
            if sr-izmerenia.sr-abs-err-dens-lgas-liquid = 0.0 then do:
               message 
                  "Поле"
                  quoter(sr-izmerenia.sr-abs-err-dens-lgas-liquid:label in frame {&frame-name})
                  "должно быть ненулевым"
               view-as alert-box.
               apply "entry" to sr-izmerenia.sr-abs-err-dens-lgas-liquid in frame {&frame-name} .
               return error.
            end.
            if sr-izmerenia.sr-abs-err-dens-lgas-vapor = 0.0 then do:
               message 
                  "Поле"
                  quoter(sr-izmerenia.sr-abs-err-dens-lgas-vapor:label in frame {&frame-name})
                  "должно быть ненулевым"
               view-as alert-box.
               apply "entry" to sr-izmerenia.sr-abs-err-dens-lgas-vapor in frame {&frame-name} .
               return error.
            end.
         /* end. */ 
      end.
   end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-sr-otnos Dialog-Frame 
procedure Check-sr-otnos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   do with frame Dialog-Frame:
      assign 
          sr-izmerenia.sr-Weight
          sr-izmerenia.sr-otnos
       .
       if sr-izmerenia.sr-Weight then do:
          if sr-izmerenia.sr-otnos = ? then do:
              message
                 "Поле"
                 quoter(sr-izmerenia.sr-otnos:label in frame {&frame-name})
                 "обязательно для заполнения"
              view-as alert-box.
              apply "entry" to sr-izmerenia.sr-otnos in frame {&frame-name} .
              return error.
          end.
          if sr-izmerenia.sr-otnos = 0.0 then do:
              message
                 "Поле"
                 quoter(sr-izmerenia.sr-otnos:label in frame {&frame-name})
                 "должно быть заполнено ненулевым значением"
              view-as alert-box.
              apply "entry" to sr-izmerenia.sr-otnos in frame {&frame-name} .
              return error.
          end.
       end.
   end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-sr-type-id Dialog-Frame 
procedure Check-sr-type-id :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 do with frame Dialog-Frame:
assign 
     sr-izmerenia.sr-density
     sr-izmerenia.sr-type-id
  .
  if     sr-izmerenia.sr-density         
     and (   sr-izmerenia.sr-type-id eq ?
          or sr-izmerenia.sr-type-id eq 0)
  then do:
     message sr-izmerenia.sr-type-id:label in frame {&frame-name} " обязателен для заполнения"
     view-as alert-box.
     apply "entry" to sr-izmerenia.sr-type-id in frame {&frame-name} .
     return error.
  end.  end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-sr-temp-line Dialog-Frame 
procedure Check-sr-temp-line :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   do with frame Dialog-Frame:
      assign 
         sr-izmerenia.sr-temp-line
         sr-izmerenia.sr-level
         .
      if sr-izmerenia.sr-level then do:
         if sr-izmerenia.sr-temp-line = ? then do:
            message
               "Поле"
               quoter(sr-izmerenia.sr-temp-line:label in frame {&frame-name})
               "обязательно для заполнения"
            view-as alert-box.
            apply "entry" to sr-izmerenia.sr-temp-line in frame {&frame-name} .
            return error.
         end.
         if sr-izmerenia.sr-temp-line = 0.0 then do:
            message
               "Поле"
               quoter(sr-izmerenia.sr-temp-line:label in frame {&frame-name})
               "не может быть нулевым"
            view-as alert-box.
            apply "entry" to sr-izmerenia.sr-temp-line in frame {&frame-name} .
            return error.
         end.
      end.
   end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-sr-abs-err-temp-vol Dialog-Frame 
procedure Check-sr-abs-err-temp-vol :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   do with frame Dialog-Frame:
      assign 
         sr-izmerenia.sr-abs-err-temp-vol
         sr-izmerenia.sr-temperature
         .
      if sr-izmerenia.sr-temperature and sr-izmerenia.sr-abs-err-temp-vol = 0.0
      then do:
         message 
            "Поле"
            quoter(sr-izmerenia.sr-abs-err-temp-vol:label in frame {&frame-name})
            "должно быть заполнено ненулевым значением"
         view-as alert-box.
         apply "entry" to sr-izmerenia.sr-abs-err-temp-vol in frame {&frame-name} .
         return error.
      end.
   end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Check-sr-abs-err-temp-dens Dialog-Frame 
procedure Check-sr-abs-err-temp-dens:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   do with frame Dialog-Frame:
      assign 
         sr-izmerenia.sr-abs-err-temp-dens
         sr-izmerenia.sr-temperature
         .
      if sr-izmerenia.sr-temperature and sr-izmerenia.sr-abs-err-temp-dens = 0.0
      then do:
         message 
            "Поле"
            quoter(sr-izmerenia.sr-abs-err-temp-dens:label in frame {&frame-name})
            "должно быть заполнено ненулевым значением"
         view-as alert-box.
         apply "entry" to sr-izmerenia.sr-abs-err-temp-dens in frame {&frame-name} .
         return error.
      end.
   end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
procedure disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  hide frame Dialog-Frame.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
procedure enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/

  {&OPEN-QUERY-Dialog-Frame}
  /*get first Dialog-Frame.*/
  if available sr-izmerenia then 
    display sr-izmerenia.node-code sr-izmerenia.sr-model sr-izmerenia.sr-type-izm 
          sr-izmerenia.sr-level sr-izmerenia.sr-type-level-measuring 
          sr-izmerenia.sr-temp-line sr-izmerenia.sr-abs-err-neft-water 
          sr-izmerenia.sr-relative-err-neft-water sr-izmerenia.sr-abs-err-water 
          sr-izmerenia.sr-relative-err-water sr-izmerenia.sr-temperature 
          sr-izmerenia.sr-abs-err-temp-vol sr-izmerenia.sr-abs-err-temp-dens 
          sr-izmerenia.sr-density sr-izmerenia.sr-type-id 
          sr-izmerenia.sr-abs-err-dens sr-izmerenia.sr-relative-err-dens 
          sr-izmerenia.sr-abs-err-dens-lgas-liquid 
          sr-izmerenia.sr-abs-err-dens-lgas-vapor sr-izmerenia.sr-Weight 
          sr-izmerenia.sr-otnos sr-izmerenia.sr-not-used 
          temp-line-text abs-err-neft-water-text relative-err-neft-water-text
          abs-err-water-text relative-err-water-text abs-err-temp-vol-text
          abs-err-temp-dens-text abs-err-dens-text relative-err-dens-text
          abs-err-dens-lgas-liquid-text abs-err-dens-lgas-vapor-text
          otnos-text
      with frame Dialog-Frame.
  enable RECT-1 RECT-2 RECT-3 RECT-4  Btn_Cancel with frame Dialog-Frame.
  if iMode ne {&lookup}
  then
  enable Btn_OK
         sr-izmerenia.sr-model 
         sr-izmerenia.sr-type-izm sr-izmerenia.sr-level 
         sr-izmerenia.sr-abs-err-neft-water 
         sr-izmerenia.sr-relative-err-neft-water sr-izmerenia.sr-abs-err-water 
         sr-izmerenia.sr-relative-err-water sr-izmerenia.sr-temperature 
         sr-izmerenia.sr-abs-err-temp-vol sr-izmerenia.sr-abs-err-temp-dens 
         sr-izmerenia.sr-density sr-izmerenia.sr-type-id 
         sr-izmerenia.sr-abs-err-dens sr-izmerenia.sr-relative-err-dens 
         sr-izmerenia.sr-abs-err-dens-lgas-liquid 
         sr-izmerenia.sr-abs-err-dens-lgas-vapor sr-izmerenia.sr-Weight 
         sr-izmerenia.sr-otnos sr-izmerenia.sr-type-level-measuring   
        sr-izmerenia.sr-temp-line sr-izmerenia.sr-not-used
      with frame Dialog-Frame.
  view frame Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

