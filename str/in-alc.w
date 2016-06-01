&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
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

Форма для редактирования атрибутов алкогольной продукции в партии прихода

Автор: Хныкин Павел Андреевич
Дата создания: 03/01/06
Author: Pavel Khnykin
Creation date: 03/01/06

------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
define input        parameter parParentProc             as widget-handle no-undo.
define input        parameter p-mode                    as character no-undo.
define input        parameter p-gds-code as integer no-undo.
define input-output parameter p-alc-mark-db-num         as integer   no-undo.
define input-output parameter p-alc-mark-code           as integer   no-undo.
define input-output parameter p-alc-bottling-date       as date      no-undo.
define input-output parameter p-alc-ref-ab-path         as character no-undo.
/*define input-output parameter p-alc-ref-b-path as char no-undo.*/
/*define input-output parameter p-group-alc-prod as char no-undo.*/
/*define input-output parameter p-code-egais as char no-undo.    */
define input-output parameter p-alc-quality-certif-path as character no-undo.
define input-output parameter p-alc-certif-path         as character no-undo.
define input-output parameter p-alc-imp-type            as character no-undo.
define input-output parameter p-alc-imp-code            as integer   no-undo.
define output       parameter save-flag                 as logical   no-undo.

/* Local Variable Definitions ---                                       */
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Форма для редактирования атрибутов алкогольной продукции в партии прихода".
{ cmp/vssrevis.i }

{ cmp/str-glbl.i }
{ cmp/library.i }
{ cmp/showinf.i }
{ gbl/sel-date.i }

define variable v-alc-mark-db-num as integer   no-undo .
define variable v-alc-mark-code   as integer   no-undo .
define variable v-recid-list      as character no-undo .
define variable v-code-egais       as character   no-undo.
define variable v-gds-name         as character no-undo.
define variable v-prod-full-name   as character no-undo.
define variable v-import-full-name as character no-undo.

define buffer buf_ex-mark for ub.ex-mark.
define buffer buf_clients for ub.clients .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS v-alc-mark-name b-exmark v-alc-bottling-date ~
b-bottling-date v-alc-ref-a-path v-alc-ref-b-path code-egais group-alc-prod ~
v-alc-quality-certif-path b-qltycert v-alc-certif-path b-certif ~
v-alc-imp-code b-alc-imp B-save B-cancel B-help b-grp-alc b-code-egais 
&Scoped-Define DISPLAYED-OBJECTS v-alc-mark-name v-alc-bottling-date ~
v-alc-ref-a-path v-alc-ref-b-path code-egais group-alc-prod ~
v-alc-quality-certif-path v-alc-certif-path v-alc-imp-name v-alc-imp-type ~
v-alc-imp-code 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-alc-imp 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 2.88 BY 1 TOOLTIP "Выбор импортера".

DEFINE BUTTON b-bottling-date 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 2.88 BY 1 TOOLTIP "Выбор акцизной или специальной марки".

DEFINE BUTTON B-cancel AUTO-END-KEY 
     LABEL "&Отмена" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-certif 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 2.88 BY 1 TOOLTIP "Выбор файла".

DEFINE BUTTON b-code-egais 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 2.88 BY 1 TOOLTIP "Выбор файла".

DEFINE BUTTON b-exmark 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 2.88 BY 1 TOOLTIP "Выбор акцизной или специальной марки".

DEFINE BUTTON b-grp-alc 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 2.88 BY 1 TOOLTIP "Выбор файла".

DEFINE BUTTON B-help 
     LABEL "Помо&щь" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON b-qltycert 
     IMAGE-UP FILE "btn-down-arrow":U
     IMAGE-DOWN FILE "btn-down-arrow":U
     IMAGE-INSENSITIVE FILE "btn-down-arrow":U
     LABEL "" 
     SIZE 2.88 BY 1 TOOLTIP "Выбор файла".

DEFINE BUTTON B-save AUTO-GO 
     LABEL "&Ввод" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE code-egais AS CHARACTER FORMAT "X(256)":U 
     LABEL "Код товара в ЕГАИС" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE group-alc-prod AS CHARACTER FORMAT "X(256)":U 
     LABEL "Группа алкогольной продукции" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.

DEFINE VARIABLE v-alc-bottling-date AS DATE FORMAT "99/99/9999":U 
     LABEL "Дата розлива" 
     VIEW-AS FILL-IN 
     SIZE 11.5 BY 1 TOOLTIP "Дата розлива партии алкогольной продукции" NO-UNDO.

DEFINE VARIABLE v-alc-certif-path AS CHARACTER FORMAT "X(256)":U 
     LABEL "Сертификат соответствия" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 TOOLTIP "Ссылка на файл сертификата соответствия" NO-UNDO.

DEFINE VARIABLE v-alc-imp-code AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 10 BY 1 NO-UNDO.

DEFINE VARIABLE v-alc-imp-name AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.5 BY 1 NO-UNDO.

DEFINE VARIABLE v-alc-imp-type AS CHARACTER FORMAT "X(3)":U 
     LABEL "Импортер" 
     VIEW-AS FILL-IN 
     SIZE 5 BY 1 NO-UNDO.

DEFINE VARIABLE v-alc-mark-name AS CHARACTER FORMAT "X(20)":U 
     LABEL "Код марки" 
     VIEW-AS FILL-IN 
     SIZE 21.5 BY 1 TOOLTIP "Код акцизной или специальной марки" NO-UNDO.

DEFINE VARIABLE v-alc-quality-certif-path AS CHARACTER FORMAT "X(256)":U 
     LABEL "Удостоверение качества" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 TOOLTIP "Ссылка на файл удостоверения качества продукции" NO-UNDO.

DEFINE VARIABLE v-alc-ref-a-path AS CHARACTER FORMAT "X(256)":U 
     LABEL "Справка А" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 TOOLTIP "Ссылка на файл справок A и Б" NO-UNDO.

DEFINE VARIABLE v-alc-ref-b-path AS CHARACTER FORMAT "X(256)":U 
     LABEL "Справка Б" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     v-alc-mark-name AT ROW 2.75 COL 30 COLON-ALIGNED
     b-exmark AT ROW 2.75 COL 54.5
     v-alc-bottling-date AT ROW 4 COL 30 COLON-ALIGNED
     b-bottling-date AT ROW 4 COL 51
     v-alc-ref-a-path AT ROW 5.75 COL 30 COLON-ALIGNED
     v-alc-ref-b-path AT ROW 7 COL 30 COLON-ALIGNED WIDGET-ID 12
     code-egais AT ROW 8.25 COL 30 COLON-ALIGNED WIDGET-ID 20
     group-alc-prod AT ROW 9.5 COL 30 COLON-ALIGNED WIDGET-ID 22
     v-alc-quality-certif-path AT ROW 10.75 COL 30 COLON-ALIGNED
     b-qltycert AT ROW 10.75 COL 82
     v-alc-certif-path AT ROW 12.25 COL 30 COLON-ALIGNED
     b-certif AT ROW 12.25 COL 82
     v-alc-imp-name AT ROW 13.75 COL 42.5 COLON-ALIGNED NO-LABEL WIDGET-ID 10 NO-TAB-STOP 
     v-alc-imp-type AT ROW 13.75 COL 25.5 COLON-ALIGNED WIDGET-ID 2
     v-alc-imp-code AT ROW 13.75 COL 31.5 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     b-alc-imp AT ROW 13.75 COL 82 WIDGET-ID 6
     B-save AT ROW 1 COL 1
     B-cancel AT ROW 1 COL 11
     B-help AT ROW 1 COL 70.5
     b-grp-alc AT ROW 9.5 COL 82 WIDGET-ID 24
     b-code-egais AT ROW 8.25 COL 82 WIDGET-ID 26
     SPACE(2.99) SKIP(6.87)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Атрибуты алкогольной продукции"
         DEFAULT-BUTTON B-save CANCEL-BUTTON B-cancel.



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME Custom                                                    */
ASSIGN
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN v-alc-imp-name IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
ASSIGN
       v-alc-imp-name:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* SETTINGS FOR FILL-IN v-alc-imp-type IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Атрибуты алкогольной продукции */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-alc-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-alc-imp Dialog-Frame
ON CHOOSE OF b-alc-imp IN FRAME Dialog-Frame
DO:
  run select-importer in this-procedure no-error.
  if error-status:error then do:
     return no-apply.
  end.
  DISPLAY
    v-alc-imp-code
    v-alc-imp-type
    v-alc-imp-name
  with frame {&frame-name}.
  apply "entry" to v-alc-imp-type in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-certif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-certif Dialog-Frame
ON CHOOSE OF b-certif IN FRAME Dialog-Frame
DO:
  define variable v-file-name as character no-undo.
  define variable lOK         as logical no-undo.

  assign frame {&frame-name} v-alc-certif-path.
  v-file-name = v-alc-certif-path.
  SYSTEM-DIALOG GET-FILE
      v-file-name
      FILTERS    "Все файлы (*.*)" "*.*"
      MUST-EXIST
      TITLE      "Выберите файл Сертификата соответствия ..."
      USE-FILENAME
      UPDATE lOK.

  if lOK then do:
    v-alc-certif-path = v-file-name.
    display v-alc-certif-path with frame {&frame-name}.
  end.
  apply "entry" to v-alc-certif-path in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-code-egais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-code-egais Dialog-Frame
ON CHOOSE OF b-code-egais IN FRAME Dialog-Frame
    DO:
        define variable v-rid-list as character no-undo.
        define variable p-OK       as logical   no-undo.
        define variable gds-code   as integer   no-undo.
        
        if p-mode = {&lookup} then 
        do: 
            run bge/egais-goods-mark.w ( 
                input parparentproc, 
                input {&select}, 
                input-output v-code-egais, 
                input-output p-gds-code, 
                output v-gds-name, 
                output v-prod-full-name, 
                output v-import-full-name )  . 
        end.
        else 
        do: 
            run bge/egais-goods-mark.w ( 
                input parparentproc, 
                input {&lookup}, 
                input-output v-code-egais, 
                input-output p-gds-code, 
                output v-gds-name, 
                output v-prod-full-name, 
                output v-import-full-name )  . 
            if v-code-egais <> "" then 
            do: 
                
                code-egais:screen-value = v-code-egais.
            end.
   
        END.
    end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exmark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exmark Dialog-Frame
ON CHOOSE OF b-exmark IN FRAME Dialog-Frame
DO:
  define variable ref-list as character no-undo.
  define variable ref-rec  as recid no-undo.

  do on error undo, return no-apply:
    if v-alc-mark-code <> 0 then do:
      find first buf_ex-mark no-lock
        where buf_ex-mark.db-num    = v-alc-mark-db-num
          and buf_ex-mark.mark-code = v-alc-mark-code
        no-error.
      if available buf_ex-mark then do:
        assign
          ref-list = string(recid(buf_ex-mark))
        .
      end.
    end.

    run ref/exmark.w
      (input parParentProc
      ,input 'b-sel,b-add'
      ,input-output ref-list
      ).
    if ref-list <> "" and ref-list <> ? then do:
      ref-rec = integer(entry(1, ref-list)).
      find buf_ex-mark no-lock where recid(buf_ex-mark) = ref-rec.
      assign
        v-alc-mark-db-num = buf_ex-mark.db-num
        v-alc-mark-code   = buf_ex-mark.mark-code
        v-alc-mark-name   = buf_ex-mark.mark-name
      .
      display v-alc-mark-name
        with frame {&frame-name}.
    end.
    apply "entry" to v-alc-mark-name in frame {&frame-name}.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-grp-alc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-grp-alc Dialog-Frame
ON CHOOSE OF b-grp-alc IN FRAME Dialog-Frame
DO:
  define variable v-rid-list as character no-undo.
  define variable p-OK         as logical no-undo.

run ref/alc-type.w (input parparentproc
                    , input "b-sel"
                    , input-output v-rid-list
                    ,  output p-ok
                               ).   

  if p-OK then do:
      find first alc-type where v-rid-list = string( recid( alc-type ) ) no-lock no-error.
      group-alc-prod = alc-type.alc-type-code. 
    display group-alc-prod with frame {&frame-name}.
  end.
  apply "entry" to group-alc-prod in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-qltycert
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-qltycert Dialog-Frame
ON CHOOSE OF b-qltycert IN FRAME Dialog-Frame
DO:
  define variable v-file-name as character no-undo.
  define variable lOK         as logical no-undo.

  assign frame {&frame-name} v-alc-quality-certif-path.
  v-file-name = v-alc-quality-certif-path.
  SYSTEM-DIALOG GET-FILE
      v-file-name
      FILTERS    "Все файлы (*.*)" "*.*"
      MUST-EXIST
      TITLE      "Выберите файл Удостоверения качества ..."
      USE-FILENAME
      UPDATE lOK.

  if lOK then do:
    v-alc-quality-certif-path = v-file-name.
    display v-alc-quality-certif-path with frame {&frame-name}.
  end.
  apply "entry" to v-alc-quality-certif-path in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





&Scoped-define SELF-NAME B-save
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B-save Dialog-Frame
ON CHOOSE OF B-save IN FRAME Dialog-Frame /* Ввод */
DO:
  { gbl/stdbtn.i }

  if p-mode = {&lookup} then return no-apply.

  do on error undo, return no-apply:
    run proc-save in this-procedure.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-alc-certif-path
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-alc-certif-path Dialog-Frame
ON LEAVE OF v-alc-certif-path IN FRAME Dialog-Frame /* Сертификат соответствия */
DO:
  /* При нажатии на кнопку выбора файла не проверяем содержимое поля */
  if last-event:widget-enter <> b-certif:handle then do:
    assign frame {&frame-name} v-alc-certif-path.
    if (v-alc-certif-path <> "") and (search (v-alc-certif-path) = ?) then do:
      message "Указанный файл сертификата соответствия не найден"
        view-as alert-box error.
      apply "entry" to self.
      return no-apply.
    end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-alc-imp-code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-alc-imp-code Dialog-Frame
ON LEAVE OF v-alc-imp-code IN FRAME Dialog-Frame
DO:
   assign
      v-alc-imp-type
      v-alc-imp-code
   .
   IF v-alc-imp-type <> ""
   OR v-alc-imp-code <> 0
   THEN DO:
      FIND buf_clients WHERE buf_clients.obj-type = v-alc-imp-type
                        and buf_clients.obj-code = v-alc-imp-code
                        no-lock
                        no-error
                        .
      if available buf_clients then do:
         assign
               v-alc-imp-name = buf_clients.obj-name
         .
         DISPLAY
            v-alc-imp-type
            v-alc-imp-code
            v-alc-imp-name
         with frame {&frame-name}.
      end.
      else do:
         message SUBSTITUTE ( "Указанный импортер (&1 &2) не найден"
                            , v-alc-imp-type
                            , v-alc-imp-code
                            )
            skip "Выбрать из списка?"
         view-as alert-box question
         buttons ok-cancel
         update v-ok as logical
         .
         if v-ok then do:
            run select-importer in this-procedure no-error.
            if error-status:error then do:
               return no-apply.
            end.
         end.
      end.
      DISPLAY
         v-alc-imp-code
         v-alc-imp-type
         v-alc-imp-name
      with frame {&frame-name}.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-alc-mark-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-alc-mark-name Dialog-Frame
ON LEAVE OF v-alc-mark-name IN FRAME Dialog-Frame /* Код марки */
DO:
  define variable old-alc-mark-name as character no-undo.

  old-alc-mark-name = v-alc-mark-name.
  assign frame {&frame-name} v-alc-mark-name.
  if v-alc-mark-name = "" then do:
    assign
      v-alc-mark-db-num = 0
      v-alc-mark-code   = 0
    .
  end.
  else
  if v-alc-mark-name <> old-alc-mark-name then do:
    find first buf_ex-mark no-lock
      where buf_ex-mark.mark-name = v-alc-mark-name
        and buf_ex-mark.stts      = integer({&current-status-int})
      no-error.
    if available buf_ex-mark then do:
      assign
        v-alc-mark-db-num = buf_ex-mark.db-num
        v-alc-mark-code   = buf_ex-mark.mark-code
      .
    end.
    else do:
      assign
        v-alc-mark-db-num = 0
        v-alc-mark-code   = 0
      .
      /* При нажатии на кнопку справочника не проверяем содержимое поля */
      if last-event:widget-enter <> b-exmark:handle then do:
        message "Акцизная или специальная марка с указанным кодом не найдена"
          view-as alert-box error.
        apply "entry" to self.
        return no-apply.
      end.
    end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-alc-quality-certif-path
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-alc-quality-certif-path Dialog-Frame
ON LEAVE OF v-alc-quality-certif-path IN FRAME Dialog-Frame /* Удостоверение качества */
DO:
  /* При нажатии на кнопку выбора файла не проверяем содержимое поля */
  if last-event:widget-enter <> b-qltycert:handle then do:
    assign frame {&frame-name} v-alc-quality-certif-path.
    if (v-alc-quality-certif-path <> "") and (search (v-alc-quality-certif-path) = ?) then do:
      message "Указанный файл удостоверения качества не найден"
        view-as alert-box error. 
      apply "entry" to self.
      return no-apply.
    end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME code-egais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL code-egais Dialog-Frame
ON LEAVE OF code-egais IN FRAME Dialog-Frame /* Код товара в ЕГАИС */
DO:
assign code-egais.


end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME group-alc-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL group-alc-prod Dialog-Frame
ON LEAVE OF group-alc-prod IN FRAME Dialog-Frame /* Код группы торваров */
DO:
    assign group-alc-prod.
/*    if group-alc-prod <> "" then                                                            */
/*    do:                                                                                     */
/*                                                                                            */
/*        find first alc-type  where alc-type.alc-type-code = group-alc-prod no-lock no-error.*/
/*        if not available alc-type then                                                      */
/*        do:                                                                                 */
/*            message "Данного кода группы алкогольной продукции нет"                         */
/*                view-as alert-box error.                                                    */
/*            apply "entry" to self.                                                          */
/*            return no-apply.                                                                */
/*        end.                                                                                */
/*    end.                                                                                    */


end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*&Scoped-define SELF-NAME v-alc-ref-ab-path                                    */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-alc-ref-ab-path Dialog-Frame      */
/*ON LEAVE OF v-alc-ref-ab-path IN FRAME Dialog-Frame /* Справки А,Б */         */
/*DO:                                                                           */
/*  /* При нажатии на кнопку выбора файла не проверяем содержимое поля */       */
/*  /*if last-event:widget-enter <> b-refAB:handle then do:                     */
/*    assign frame {&frame-name} v-alc-ref-ab-path.                             */
/*    if (v-alc-ref-ab-path <> "") and (search (v-alc-ref-ab-path) = ?) then do:*/
/*      message "Указанный файл справки А,Б не найден"                          */
/*        view-as alert-box error.                                              */
/*      apply "entry" to self.                                                  */
/*      return no-apply.                                                        */
/*    end.                                                                      */
/*  end.*/                                                                      */
/*END.                                                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
{ gbl/app_help.i }
{ gbl/ed_date.i
  v-alc-bottling-date
  " "
  " "
  "'Дата разлива &1'"
}

on choose of b-bottling-date in frame {&frame-name}
do:
  run sel-date in this-procedure
    (input v-alc-bottling-date :handle
    ,input "Дата разлива &1"
    ) .
end.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
enable  b-code-egais  WITH FRAME Dialog-Frame.
  run MyEnable.

  run MyEnable.
/*  hide b-refAB in frame {&FRAME-NAME}.*/
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
  DISPLAY v-alc-mark-name v-alc-bottling-date v-alc-ref-a-path v-alc-ref-b-path 
          code-egais group-alc-prod v-alc-quality-certif-path v-alc-certif-path 
          v-alc-imp-name v-alc-imp-type v-alc-imp-code 
      WITH FRAME Dialog-Frame.
  ENABLE v-alc-mark-name b-exmark v-alc-bottling-date b-bottling-date 
         v-alc-ref-a-path v-alc-ref-b-path code-egais group-alc-prod 
         v-alc-quality-certif-path b-qltycert v-alc-certif-path b-certif 
         v-alc-imp-code b-alc-imp B-save B-cancel B-help b-grp-alc b-code-egais 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MyEnable Dialog-Frame
PROCEDURE MyEnable :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define buffer buf_clients  for ub.clients.

    assign
        v-alc-mark-db-num         = p-alc-mark-db-num
        v-alc-mark-code           = p-alc-mark-code
        v-alc-bottling-date       = p-alc-bottling-date
        v-alc-ref-a-path          = entry(1,p-alc-ref-ab-path,",")     
        v-alc-ref-b-path          = entry(2,p-alc-ref-ab-path,",")      when num-entries (p-alc-ref-ab-path) > 1
        code-egais                = entry(3,p-alc-ref-ab-path,",") when num-entries (p-alc-ref-ab-path) > 2
        group-alc-prod            = entry(4,p-alc-ref-ab-path,",") when num-entries (p-alc-ref-ab-path) > 3
        v-alc-quality-certif-path = p-alc-quality-certif-path
        v-alc-certif-path         = p-alc-certif-path
        v-alc-imp-type            = p-alc-imp-type
        v-alc-imp-code            = p-alc-imp-code
  no-error.
  
  find first buf_clients no-lock
    where buf_clients.obj-type = v-alc-imp-type
      and buf_clients.obj-code = v-alc-imp-code
  no-error .
  if available buf_clients
  then do:
    assign
      v-alc-imp-name = buf_clients.obj-name
    .
  end.

  find first buf_ex-mark no-lock
    where buf_ex-mark.db-num    = p-alc-mark-db-num
      and buf_ex-mark.mark-code = p-alc-mark-code
    no-error.
  if available buf_ex-mark then
    v-alc-mark-name = buf_ex-mark.mark-name.
  else
    v-alc-mark-name = "".

  display
    v-alc-mark-name
    v-alc-bottling-date
    v-alc-ref-a-path
    v-alc-ref-b-path
    code-egais
    group-alc-prod
    v-alc-quality-certif-path
    v-alc-certif-path
    v-alc-imp-type
    v-alc-imp-code
    v-alc-imp-name
   with frame {&frame-name}.

  view frame {&frame-name}.

  if p-mode = {&lookup} then do:
    assign
      b-cancel:label  = "&Выход"
      b-cancel:column = 1
    .
    hide b-save in frame {&frame-name}.
    enable B-cancel B-Help with frame {&frame-name}.
  end.
  else do:
    enable all with frame {&frame-name}.
    apply "entry" to v-alc-mark-name in frame {&frame-name}.
  end.

  return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-save Dialog-Frame
PROCEDURE proc-save :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

  if p-mode = {&lookup} then do:
    return error.
  end.

  assign frame {&frame-name}
    v-alc-mark-name
    v-alc-bottling-date
    v-alc-ref-a-path
    v-alc-ref-b-path
    v-alc-quality-certif-path
    v-alc-certif-path
    code-egais
    group-alc-prod
    v-alc-imp-type
    v-alc-imp-code
  .

  /* Предварительные проверки */
  if v-alc-mark-name <> "" then do:
    /* Переменные v-alc-mark-db-num и v-alc-mark-code уже заполнены
       при вызове справочника или в триггере на on leave поля */
    find first buf_ex-mark no-lock
      where buf_ex-mark.db-num    = v-alc-mark-db-num
        and buf_ex-mark.mark-code = v-alc-mark-code
      no-error.
    if not available buf_ex-mark then do:
      message "Акцизная или специальная марка с указанным кодом не найдена"
        view-as alert-box error.
      apply "entry" to v-alc-mark-name in frame {&frame-name}.
      return error.
    end.
  end.

  IF v-alc-imp-type <> ""
  OR v-alc-imp-code <> 0
  THEN DO:
      FIND buf_clients WHERE buf_clients.obj-type = v-alc-imp-type
                         and buf_clients.obj-code = v-alc-imp-code
                       no-lock
                       no-error
                       .
      if NOT available buf_clients then do:
         message SUBSTITUTE ( "Указанный импортер (&1 &2) не найден"
                            , v-alc-imp-type
                            , v-alc-imp-code
                            )
            view-as alert-box error.
         apply "entry" to v-alc-imp-type in frame {&frame-name}.
         return error.
      End.
  END.

  /*if (v-alc-ref-ab-path <> "") and (search (v-alc-ref-ab-path) = ?) then do:
    message "Указанный файл справки А,Б не найден"
      view-as alert-box error.
    apply "entry" to v-alc-ref-ab-path in frame {&frame-name}.
    return error.
  end.*/

  if (v-alc-quality-certif-path <> "") and (search (v-alc-quality-certif-path) = ?) then do:
    message "Указанный файл удостоверения качества не найден"
      view-as alert-box error.
    apply "entry" to v-alc-quality-certif-path in frame {&frame-name}.
    return error.
  end.

  if (v-alc-certif-path <> "") and (search (v-alc-certif-path) = ?) then do:
    message "Указанный файл сертификата соответствия не найден"
      view-as alert-box error.
    apply "entry" to v-alc-certif-path in frame {&frame-name}.
    return error.
  end.

  assign
        p-alc-mark-db-num         = v-alc-mark-db-num
        p-alc-mark-code           = v-alc-mark-code
        p-alc-bottling-date       = v-alc-bottling-date
        p-alc-ref-ab-path          = v-alc-ref-a-path + "," + v-alc-ref-b-path + "," +   code-egais + "," +  group-alc-prod      
                  
/*        p-alc-ref-b-path          = v-alc-ref-b-path*/
        p-alc-quality-certif-path = v-alc-quality-certif-path
        p-alc-certif-path         = v-alc-certif-path
        p-alc-imp-type            = v-alc-imp-type
        p-alc-imp-code            = v-alc-imp-code
        save-flag                 = yes
        .
  return.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE select-importer Dialog-Frame
PROCEDURE select-importer :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
do
on error undo, return error
:
  run ref/cli-all.w ( input parParentProc
                    , input "b-add,b-sel"
                    , input ?
                    , input ?
                    , input ?
                    , input ?
                    , input ?
                    , input ?
                    , output v-recid-list
                    ) .
  if v-recid-list = "" then do:
     apply "entry" to b-alc-imp in frame {&frame-name}.
     return no-apply.
  end.

  FIND FIRST buf_clients
       WHERE recid (buf_clients) = integer( v-recid-list )
       NO-LOCK .
  assign
    v-alc-imp-code = buf_clients.obj-code
    v-alc-imp-type = buf_clients.obj-type
    v-alc-imp-name = buf_clients.obj-name
  .
  release buf_clients .
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME





