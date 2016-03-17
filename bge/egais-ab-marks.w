&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------


$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Акцизные марки

Автор: Шкляр Елена 
Дата создания: 01/16/07
Author: Elena Shklyar
Creation date: 01/16/07

          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* Parameters Definitions ---                                           */

define input parameter p-num    as character no-undo .
define input parameter p-position as integer no-undo .
define input parameter p-alc-code as character   no-undo.

/*define variable v-proc-name-err    as character    no-undo.*/

define variable l-error as logical no-undo. /* Есть ли ошибки */
define variable v-user-action    as character no-undo.
define variable v-printed        as logical   no-undo.
define variable v-proc-name-err as character no-undo initial 'impmark.err'. /* Имя лога */
/* Local Variable Definitions ---                                       */



define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Акцизные марки".

{ cmp/vssrevis.i }
{ibs/th/bge/egais/ab-egais.i shared}
{bge/egais-mark.i}
{ cmp/showinf.i  }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

define temp-table tt-del-marks like tt-marks .

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "Ввод" 
     SIZE 10 BY 1
     BGCOLOR 8 .
     
DEFINE BUTTON Btn_del 
     LABEL "Удалить" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_imp 
     LABEL "Импорт" 
     SIZE 10 BY 1
     BGCOLOR 8 .
          
define variable v-mark as character format "X(255)" view-as fill-in size 80 by 1 label "Марка" .

define variable v-gds-code as integer    no-undo .
define variable v-gds-name as character   no-undo .
define variable v-alc-code as character   no-undo .
define variable v-error-lang as logical   no-undo .
define stream str-err .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-marks FOR 
      tt-marks SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-marks
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-marks Dialog-Frame _FREEFORM
  QUERY br-marks  DISPLAY
    tt-marks.mark    
    WIDTH 40
    tt-marks.alc-code 
    WIDTH 20
    tt-marks.gds-code 
    WIDTH 10
    tt-marks.gds-name
    WIDTH 30 

    
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 107 BY 20.2 FIT-LAST-COLUMN.
/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.24 COL 2
     Btn_del at row 1.24 col 22
     Btn_imp at row 1.24 col 32
     Btn_Cancel AT ROW 1.24 COL 12
     v-mark at row 2.7 col 2 
     br-marks at row 4 col 2
     SPACE(1) SKIP(0.3)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Ввод Акцизных марок"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
 
 
/*Процедура выбора файла*/
PROCEDURE proc-choose-file :
  /* Выбор файла */
  if search (v-proc-name-err) <> ? then 
  do:
    os-delete value(v-proc-name-err).
  end.
  DEFINE VARIABLE vCh AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE vLg AS LOGICAL     NO-UNDO.
  SYSTEM-DIALOG GET-FILE vCh
    MUST-EXIST
    TITLE "Выбор файла"
    USE-FILENAME UPDATE vLg.
  IF vCh <> "" THEN
  DO:
    output stream str-err to value(v-proc-name-err) .
    INPUT FROM value(vCh). 
    /*DISABLE TRIGGERS FOR LOAD OF Customer.*/
        
    REPEAT: 
      IMPORT v-mark.
      find first tt-marks where tt-marks.mark = v-mark no-error .
      if not available tt-marks then 
      do:
        create tt-marks.
        tt-marks.mark = v-mark .
                  
        run ProcAlcCode  IN THIS-PROCEDURE (input v-mark, output v-alc-code, output l-error, output v-error-lang ) no-error.
        if v-error-lang then do:
            put stream str-err unformatted
            "Не корректно считана акцизная марка, перед считыванием переключите клавиатуру на английскую раскладку."
             skip .
          v-alc-code = "".
        end.  
        else do:
        if l-error then 
        do:
          put stream str-err unformatted
            substitute("Алког. код не преобразовывается в десятичную систему из акцизной марки: &1", v-mark
            ) skip .
                      
          v-alc-code = "".
        end.
        else 
        do:
          run ProcFindGds IN THIS-PROCEDURE (input v-alc-code, output v-gds-code ) no-error.
          if v-gds-code = 0 then 
          do:
            put stream str-err unformatted
              substitute ("Для алког. кода &1 не найден товар (не установлено соответствие)", v-alc-code) skip .
            v-alc-code = "".
            l-error = yes .
          end.
          else 
          do: 
            run proc-gds IN THIS-PROCEDURE (input v-alc-code, input v-gds-code) no-error . 
          end. 
        end.
      end.
      end.
      
      
    END. 
    INPUT CLOSE. 
    output stream str-err close.
           if l-error then do: 
            if search (v-proc-name-err) <> ? then 
            do:
              run gbl/prnfilen.w
                (input  substitute ("Не все марки были загружены")
                ,input  0
                ,input  v-proc-name-err
                ,input  7
                ,output v-user-action
                ,output v-printed
                ).
            end.
            end.
  END.
  else os-delete value(v-proc-name-err). /* Если нет - удаляем лог */
 
END PROCEDURE.

/*Поиск товара */
PROCEDURE proc-gds :
/*  define input parameter p-mark-alc as character no-undo .*/
  define input parameter v-alc-code as character     no-undo .
  define input parameter v-gds-code as integer   no-undo . 
  define buffer buf_goods for ub.goods .
      if p-alc-code <> "" and p-alc-code <> v-alc-code then do :
          message "Не тот товар! Вы вводите марки для алк. кода " + p-alc-code skip "Алк. код в марке - " v-alc-code view-as alert-box .
      end.
      if (p-alc-code <> "" and p-alc-code = v-alc-code) or p-alc-code = "" then do:
      find first buf_goods where buf_goods.gds-code = v-gds-code no-error .
        if available buf_goods then v-gds-name = buf_goods.gds-name . 
        find first tt-marks where tt-marks.mark = v-mark no-error.
            if not available tt-marks then do:
                create tt-marks .
            end.    
                assign
                  tt-marks.num                = p-num
                  tt-marks.gds-part-position_ = p-position 
                  tt-marks.mark               = v-mark 
                  tt-marks.new_               = true
                  tt-marks.gds-code           = v-gds-code
                  tt-marks.alc-code           = v-alc-code 
                  tt-marks.gds-name           = v-gds-name 
        
                .      
        end.    
      


END PROCEDURE .
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark Dialog-Frame
ON return OF v-mark in FRAME Dialog-Frame /* Ввод марок */
DO:
  define variable v-error as logical no-undo init no.
    assign v-mark = v-mark:screen-value .
    RUN ProcAlcCode IN THIS-PROCEDURE (input v-mark, output v-alc-code, output l-error, output v-error-lang) no-error.
      if v-error-lang then do:
            message "Не корректно считана акцизная марка, перед считыванием переключите клавиатуру на английскую раскладку."
      view-as alert-box.
      assign 
        v-mark = ""
        v-mark:screen-value = ""
        .
      end.
      else do:
      if l-error then do:
        message substitute ("Алког. код не преобразовывается в десятичную систему из акцизной марки: &1", v-mark)
        view-as alert-box.
        v-alc-code = "".
      end.
      else do:
        run ProcFindGds IN THIS-PROCEDURE (input v-alc-code, output v-gds-code ) no-error.
            if v-gds-code = 0 then do:
                    message substitute ("Для алког. кода &1 не найден товар (не установлено соответствие)", v-alc-code)
                    view-as alert-box.
                    v-alc-code = "".
            end.
            else do:
              RUN proc-gds IN THIS-PROCEDURE (input v-alc-code, input v-gds-code) no-error .
            end.  
         end.
         open query br-marks for each tt-marks  where tt-marks.num = p-num and tt-marks.gds-part-position_ = p-position .
        assign v-mark:screen-value = "" .
        assign v-mark .
        apply "entry" to v-mark in FRAME {&FRAME-NAME}.
        end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Ввод марок */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON choose OF Btn_Cancel in FRAME Dialog-Frame /* Ввод марок */
DO:
    for each tt-marks exclusive-lock where tt-marks.new_ :
        delete tt-marks .
    end.
    for each tt-del-marks :
        create tt-marks.
        buffer-copy tt-del-marks to tt-marks .
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Btn_ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_ok Dialog-Frame
ON choose OF Btn_ok in FRAME Dialog-Frame /* Ввод марок */
DO:
    for each tt-marks exclusive-lock :
/*      RUN ProcAlcCode IN THIS-PROCEDURE (input tt-marks.mark, output v-alc-code).*/
      assign tt-marks.new_ = false .
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Btn_del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_del Dialog-Frame
ON choose OF Btn_del in FRAME Dialog-Frame /* удалить */
DO:
    if not available tt-marks then return no-apply .
    create tt-del-marks.
    buffer-copy tt-marks to tt-del-marks .
    delete tt-marks .
    open query br-marks for each tt-marks where tt-marks.num = p-num and tt-marks.gds-part-position_ = p-position.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Btn_imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_imp Dialog-Frame
ON choose OF Btn_imp in FRAME Dialog-Frame /* удалить */
DO:
  run proc-choose-file no-error .
  open query br-marks for each tt-marks  where tt-marks.num = p-num and tt-marks.gds-part-position_ = p-position .
    assign v-mark:screen-value = "" .
    assign v-mark .
    apply "entry" to v-mark in FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  open query br-marks for each tt-marks  where tt-marks.num = p-num and tt-marks.gds-part-position_ = p-position .
  apply "entry" to v-mark in FRAME {&FRAME-NAME}.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE Btn_OK Btn_Cancel Btn_del Btn_imp v-mark br-marks
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

