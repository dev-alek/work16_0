&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS s-object
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Экспорт данных в систему Элкос-Талон (лист 2)

Автор: Хныкин Павел Андреевич
Дата создания: 07/04/07
Author: Pavel Khnykin
Creation date: 07/04/07

*/

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Экспорт данных в систему Элкос-Талон (лист 2)".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i   }
{ cmp/r-page1.i }
/*{ cmp/operlist.i  }*/
/*{ cmp/cli-list.i cli-list def "new shared"}*/
{ gbl/getcntxt.i def }

/* no app_help.i */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

define variable State-source as  WIDGET-HANDLE.
define variable v-recid-list    as character no-undo .

&scop exp-elc-name "exp-elc":U

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-cashpay ed-cashpay-list
&Scoped-Define DISPLAYED-OBJECTS rs-cashpay ed-cashpay-list

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE ed-cashpay-list AS CHARACTER
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 53.5 BY 16 TOOLTIP "Список типов кассовых платежей" NO-UNDO.

DEFINE VARIABLE rs-cashpay AS INTEGER
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS
          "Все", 1,
"Справочник", 2
     SIZE 14 BY 2 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-cashpay AT ROW 2 COL 2 NO-LABEL
     ed-cashpay-list AT ROW 2 COL 20.5 NO-LABEL
     "Типы кассовых платежей" VIEW-AS TEXT
          SIZE 30 BY .67 AT ROW 1 COL 2
          FGCOLOR 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE
         BGCOLOR 8 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 17
         WIDTH              = 73.13.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

ASSIGN
       ed-cashpay-list:RETURN-INSERTED IN FRAME F-Main  = TRUE.

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

&Scoped-define SELF-NAME rs-cashpay
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-cashpay s-object
ON VALUE-CHANGED OF rs-cashpay IN FRAME F-Main
DO:
  define buffer buf_cash-pay for cash-pay.

  define variable v-num           as integer   no-undo .
  define variable v-i             as integer   no-undo .
  define variable v-cash-pay-list as character no-undo .

  assign
      rs-cashpay
  .
  case rs-cashpay :
    when 1 then do:
      assign
        v-cash-pay-list = 'Все':U
      .
    end.
    when 2 then do:
      run ref/cashpays.w ( input my-handle
                         , input  "b-sel,b-mark":u
                         , input {&all}
                         , input (if v-cntxt-obj-type = {&cmp} then v-cntxt-obj-code else v-cntxt-host-code-obj)
                         , input (if v-cntxt-obj-type = {&cmp} then '':u else v-cntxt-obj-type)
                         , input (if v-cntxt-obj-type = {&cmp} then 0 else v-cntxt-obj-code)
                         , output v-recid-list
                         ) no-error.
      if error-status:error or v-recid-list = "":u  then do :
        assign
          rs-cashpay = 1
          v-cash-pay-list = 'Все':U
        .
      end.
      assign
        v-num = num-entries( v-recid-list )
      .
      do v-i = 1 to v-num :
        find first buf_cash-pay no-lock
          where recid(buf_cash-pay) = integer(entry( v-i , v-recid-list ))
        no-error .
        if available buf_cash-pay then do :
          assign
            v-cash-pay-list = v-cash-pay-list + buf_cash-pay.obj-name + {&new-line}
          .
        end.
      end.

    end.
  end case.
  assign
    ed-cashpay-list = v-cash-pay-list
  .
  display
    rs-cashpay
    ed-cashpay-list
  with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK s-object


/* ***************************  Main Block  *************************** */
/* If testing in the UIB, initialize the SmartObject. */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
  RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-time-format s-object
PROCEDURE check-time-format :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-time-in-sec s-object
PROCEDURE get-time-in-sec :
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-layout s-object
PROCEDURE local-apply-layout :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
  define buffer buf_usr-flt   for ubflt.usr-flt.
  define buffer buf_cash-pay  for ub.cash-pay.

  define variable v-i             as integer   no-undo .
  define variable v-cashpay       as integer   no-undo .
  define variable v-cash-pay-list as character no-undo .

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-layout':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  { gbl/getcntxt.i get " " my-handle }

  find first buf_usr-flt no-lock
    where buf_usr-flt.user-name   = v-cntxt-userid
      and buf_usr-flt.call-point  = {&exp-elc-name}
  no-error .
  if available buf_usr-flt then do:
    assign
      v-cashpay = integer(entry( 1 , buf_usr-flt.list_ ) )
    no-error .
    if error-status :error then return.
    case v-cashpay :
      when 1 then do:
        assign
          rs-cashpay = v-cashpay
          ed-cashpay-list = "Все":U
        .
      end.
      when 2 then do:
        assign
          rs-cashpay = v-cashpay
        .
        do v-i = 2 to num-entries(buf_usr-flt.list_) :
          find first buf_cash-pay no-lock
            where recid(buf_cash-pay) = integer(entry( v-i, buf_usr-flt.list_ ))
          no-error .
          if available buf_cash-pay then do :
            assign
              v-cash-pay-list = v-cash-pay-list + buf_cash-pay.obj-name + {&new-line}
            .
          end.
        end.
        assign
          ed-cashpay-list = v-cash-pay-list
        .
      end.
    end case.
  end.
  else do:
    assign
        rs-cashpay      = 1
        ed-cashpay-list = "Все":U
    .
  end.
  assign
      ed-cashpay-list :read-only in frame {&frame-name} = true
  .
  DISPLAY
      rs-cashpay
      ed-cashpay-list
  WITH FRAME {&frame-name}.
  ENABLE
      rs-cashpay
      ed-cashpay-list
  WITH FRAME {&frame-name}.
  VIEW FRAME {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE my-report s-object
PROCEDURE my-report :
/*------------------------------------------------------------------------------
  Purpose:     здесь происходит вызов  процедуры отчета с любыми параметрами
------------------------------------------------------------------------------*/
  define buffer buf_usr-flt for ubflt.usr-flt.

  find first buf_usr-flt no-lock
    where buf_usr-flt.user-name   = v-cntxt-userid
      and buf_usr-flt.call-point  = {&exp-elc-name}
  no-error .
  if not available buf_usr-flt then do:
    create buf_usr-flt.
    assign
      buf_usr-flt.user-name   = v-cntxt-userid
      buf_usr-flt.call-point  = {&exp-elc-name}
    .
  end.
  find current buf_usr-flt exclusive-lock no-error .
  if available buf_usr-flt then do:
    assign
      buf_usr-flt.list_ = string( rs-cashpay ) + ',' + v-recid-list
    .
  end.

  run utl/exp-elc.p ( input my-handle
                    , input X-Date-Start
                    , input X-Date-End
                    , input rs-cashpay
                    , input v-recid-list
                    ) .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE my-var s-object
PROCEDURE my-var :
/*------------------------------------------------------------------------------
  Purpose:     здесь происходит вызов  значений переменных
  например  Название отчета, может быть еще пример шапки???
------------------------------------------------------------------------------*/
  assign
    ReportHeader = "Типы кассовых платежей: " +
                   {&new-line} + ed-cashpay-list :screen-value in frame {&frame-name}.
  .
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