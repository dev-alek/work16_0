&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS B-table-Win
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Smart browser общения со связкой ТРК-пистолет

Автор: Уханов Дмитрий Юрьевич
Дата создания: 07/23/07
Author: Dmitry Ukhanov
Creation date: 07/23/07

Автор1: Суслов Алексей Юрьевич
Дата создания1: 03/27/06

*/


define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Smart browser общения со связкой ТРК-пистолет".
{ cmp/vssrevis.i  }
{ cmp/trg-def.i   }
{ cmp/showinf.i }
{ str/ptrlv.i def }
{ str/pumpnzdv.i  }
{ str/chkcsptr.i  }
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define variable is-ef-chr as character no-undo .
define variable var-type as character no-undo .
define variable is-ef as logical no-undo .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br_table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ub.pump-nozzle

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br_table                                      */
&Scoped-define FIELDS-IN-QUERY-br_table ub.pump-nozzle.pump-code ub.pump-nozzle.nozzle-code
&Scoped-define ENABLED-FIELDS-IN-QUERY-br_table
&Scoped-define SELF-NAME br_table
&Scoped-define QUERY-STRING-br_table FOR EACH ub.pump-nozzle WHERE ub.pump-nozzle.obj-type = varobj-type and                                                    ub.pump-nozzle.obj-code = varobj-code NO-LOCK     ~{&SORTBY-PHRASE} INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br_table OPEN QUERY {&SELF-NAME} FOR EACH ub.pump-nozzle WHERE ub.pump-nozzle.obj-type = varobj-type and                                                    ub.pump-nozzle.obj-code = varobj-code NO-LOCK     ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br_table ub.pump-nozzle
&Scoped-define FIRST-TABLE-IN-QUERY-br_table ub.pump-nozzle


/* Definitions for FRAME F-Main                                         */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br_table varis-meas varef-nid varps b-add ~
b-del b-hist b-help lef-nid
&Scoped-Define DISPLAYED-OBJECTS varis-meas varef-nid varps lef-nid

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" B-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).

/* Tell the ADM to use the OPEN-QUERY-CASES. */
&Scoped-define OPEN-QUERY-CASES RUN dispatch ('open-query-cases':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Advanced Query Options" B-table-Win _INLINE
/* Actions: ? adm/support/advqedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
&BROWSE-NAME
</KEY-OBJECT>
<SORTBY-OPTIONS>
</SORTBY-OPTIONS>
<SORTBY-RUN-CODE>
************************
* Set attributes related to SORTBY-OPTIONS */
RUN set-attribute-list (
    'SortBy-Options = ""':U).
/************************
</SORTBY-RUN-CODE>
<FILTER-ATTRIBUTES>
</FILTER-ATTRIBUTES> */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON b-add
     LABEL "&Добавить"
     SIZE 10 BY 1.

DEFINE BUTTON b-del
     LABEL "&Удалить"
     SIZE 10 BY 1.

DEFINE BUTTON b-help
     LABEL "&Помощь"
     SIZE 10 BY 1.

DEFINE BUTTON b-hist
     LABEL "&История"
     SIZE 10 BY 1.

DEFINE VARIABLE lef-nid AS CHARACTER FORMAT "X(20)":U INITIAL "Идентиф. EasyFuel"
      VIEW-AS TEXT
     SIZE 18 BY .67 NO-UNDO.

DEFINE VARIABLE varef-nid AS CHARACTER FORMAT "X(8)":U
     VIEW-AS FILL-IN
     SIZE 9 BY 1 NO-UNDO.

DEFINE VARIABLE varps AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 46.3 BY 1.87 NO-UNDO.

DEFINE VARIABLE varis-meas AS LOGICAL INITIAL no
     LABEL "Измеряется"
     VIEW-AS TOGGLE-BOX
     SIZE 17.3 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br_table FOR
      ub.pump-nozzle SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br_table B-table-Win _FREEFORM
  QUERY br_table NO-LOCK DISPLAY
      ub.pump-nozzle.pump-code
      ub.pump-nozzle.nozzle-code
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 27.9 BY 7.3.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     br_table AT ROW 1 COL 1
     varis-meas AT ROW 4.37 COL 29.6
     varef-nid AT ROW 7.13 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     varps AT ROW 8.43 COL 1 NO-LABEL AUTO-RETURN
     b-add AT ROW 10.53 COL 1.4
     b-del AT ROW 10.53 COL 11.8
     b-hist AT ROW 10.53 COL 22.1
     b-help AT ROW 10.53 COL 32.5
     lef-nid AT ROW 6.13 COL 27 COLON-ALIGNED NO-LABEL WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE
         BGCOLOR 8 FGCOLOR 0 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
   Allow: Basic,Browse
   Frames: 1
   Add Fields to: External-Tables
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB)
  CREATE WINDOW B-table-Win ASSIGN
         HEIGHT             = 10.87
         WIDTH              = 46.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB B-table-Win
/* ************************* Included-Libraries *********************** */

{src/adm/method/browser.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW B-table-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
/* BROWSE-TAB br_table 1 F-Main */
ASSIGN
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN varps IN FRAME F-Main
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br_table
/* Query rebuild information for BROWSE br_table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ub.pump-nozzle WHERE ub.pump-nozzle.obj-type = varobj-type and
                                                   ub.pump-nozzle.obj-code = varobj-code NO-LOCK
    ~{&SORTBY-PHRASE} INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Query            is NOT OPENED
*/  /* BROWSE br_table */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add B-table-Win
ON CHOOSE OF b-add IN FRAME F-Main /* Добавить */
DO:
  { str/ptrlv.i "cadd" "pumpnz" "{&browse-name}" }
  if available ub.pump-nozzle then do:
     assign
     varis-meas = ub.pump-nozzle.is-meas
     varef-nid = ub.pump-nozzle.ef-nid
     .
     display
     varis-meas
     varef-nid when is-ef
     with frame {&frame-name}.
 end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del B-table-Win
ON CHOOSE OF b-del IN FRAME F-Main /* Удалить */
DO:
if available ub.pump-nozzle then do:
   assign varmes-log = no.
   message "Вы хотите удалить запись <<ТРК-пистолет>> с номером ТРК " ub.pump-nozzle.pump-code
           " и номером пистолета " ub.pump-nozzle.nozzle-code " ?" skip
           "ПРИ ЭТОМ БУДУТ УДАЛЕНА СВЯЗЬ ТРК-пистолет С РЕЗЕРВУАРОМ!!!" skip
           "Вы уверены?"
           view-as alert-box question buttons yes-no update varmes-log.
  if varmes-log = yes then do:
     run pumpnzdv (input ub.pump-nozzle.obj-type,
                   input ub.pump-nozzle.obj-code,
                   input ub.pump-nozzle.pump-code,
                   input ub.pump-nozzle.nozzle-code) no-error.
     if error-status:error then do:
        { str/errmes.i "Ошибка при удалении записи ТРК-резервуар."}
        return no-apply.
     end.
     RUN dispatch IN THIS-PROCEDURE ('open-query':U).
  end.
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-hist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-hist B-table-Win
ON CHOOSE OF b-hist IN FRAME F-Main /* История */
DO:
  define variable v-rec-list as character no-undo.

  if available ub.pump-nozzle then do:
      run ref/cpmphist.w (
                       INPUT parParentProc
                     , input ub.pump-nozzle.obj-type
                     , input ub.pump-nozzle.obj-code
                     , input "":U /*bttns  */
                     , input "subject":U /*p-mode*/
                     , input ub.pump-nozzle.obj-type
                     , input ub.pump-nozzle.obj-code
                     , input ub.pump-nozzle.pump-code
                     , input 0 /*p-pl-code*/
                     , input 0 /*p-gds-code*/
                     , input ub.pump-nozzle.nozzle-code
                     , input {&table_pump-nozzle} /*p-subject*/
                     , input-output v-rec-list
                     ) no-error .

  end.
  apply "ENTRY":U to browse {&BROWSE-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br_table
&Scoped-define SELF-NAME br_table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-ENTRY OF br_table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON ROW-LEAVE OF br_table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   {src/adm/template/brsleave.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br_table B-table-Win
ON VALUE-CHANGED OF br_table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
  if available ub.pump-nozzle then do:
     assign varPS = ub.pump-nozzle.pS
            varis-meas = ub.pump-nozzle.is-meas
            varef-nid = ub.pump-nozzle.ef-nid
            .
     display
     varPS
     varis-meas
     varef-nid when is-ef
     with frame {&frame-name}.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME varef-nid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL varef-nid B-table-Win
ON LEAVE OF varef-nid IN FRAME F-Main
DO:
  define buffer bf_pumpnz for ub.pump-nozzle.
  IF is-ef  THEN DO:

  if available ub.pump-nozzle then do:
     if ub.pump-nozzle.ef-nid <> input frame {&frame-name} varef-nid then do:
        assign varmes-log = yes.
        message "Вы хотите изменить атрибут?"
        view-as alert-box question buttons yes-no update varmes-log.
        if varmes-log then do:
           find first bf_pumpnz where recid(bf_pumpnz) = recid(ub.pump-nozzle) exclusive.
           assign frame {&frame-name} varef-nid.
           assign bf_pumpnz.ef-nid = varef-nid.
        end.
        else do:
            assign varef-nid = ub.pump-nozzle.ef-nid.
            DISPLAY varef-nid with frame {&frame-name}.
        end.
     end.
  end.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME varis-meas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL varis-meas B-table-Win
ON VALUE-CHANGED OF varis-meas IN FRAME F-Main /* Измеряется */
DO:
  define buffer bf_pumpnz for ub.pump-nozzle.
  if available ub.pump-nozzle then do:
     if ub.pump-nozzle.is-meas <> input frame {&frame-name} varis-meas then do:
        assign varmes-log = yes.
        message "Вы хотите изменить атрибут?"
        view-as alert-box question buttons yes-no update varmes-log.
        if varmes-log then do:
           find first bf_pumpnz where recid(bf_pumpnz) = recid(ub.pump-nozzle) exclusive.
           assign frame {&frame-name} varis-meas.
           assign bf_pumpnz.is-meas = varis-meas.
        end.
        else do:
            assign varis-meas = ub.pump-nozzle.is-meas.
            display varis-meas with frame {&frame-name}.
        end.
     end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME varps
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL varps B-table-Win
ON LEAVE OF varps IN FRAME F-Main
DO:
  { str/ptrlv.i "lps" "pump-nozzle" "ТРК-пистолет" "{&frame-name}"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK B-table-Win


/* ***************************  Main Block  *************************** */

{ gbl/personly.i }

{ gbl/app_help.i &disable_diasize=true }

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
RUN dispatch IN THIS-PROCEDURE ('initialize':U).
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-open-query-cases B-table-Win  adm/support/_adm-opn.p
PROCEDURE adm-open-query-cases :
/*------------------------------------------------------------------------------
  Purpose:     Opens different cases of the query based on attributes
               such as the 'Key-Name', or 'SortBy-Case'
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

  {&OPEN-QUERY-{&BROWSE-NAME}}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available B-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-open-doc B-table-Win
PROCEDURE check-open-doc :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  define input parameter parobj-type like ub.clients.obj-type no-undo.
  define input parameter parobj-code like ub.clients.obj-code no-undo.
  define buffer bf_rvs-doc  for ub.rvs-doc.
  define buffer bf_icnt-doc for ub.icnt-doc.
  { str/ptrlv.i "rvs-doc-"                       }
  { str/ptrlv.i "icnt-doc-"                      }

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI B-table-Win  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize B-table-Win
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  { str/ptrlv.i "rc" "{&frame-name}"}
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /*проверим конф параметр is-ef*/
  { gbl/conf-rd.i
  "'is-ef'"
  "''"
  "''"
  0
  "''"
  "''"
  "''"
  no
  is-ef-chr
  var-type
  no-error
  }
  if NOT error-status:error
  and logical(is-ef-chr) = yes then do:
    is-ef = YES.
  end.
  IF NOT is-ef THEN DO:
    HIDE
    varef-nid IN frame {&FRAME-NAME}.
  END.

  if available ub.pump-nozzle then do:
     assign
       varis-meas = ub.pump-nozzle.is-meas
       varps      = ub.pump-nozzle.ps
       varef-nid   = ub.pump-nozzle.ef-nid
     .
     display
       varis-meas
       varps
       varef-nid   when is-ef
       with frame {&frame-name}
     .
  end.
  if lookup('b-add', varbuttons) = 0 then do:
    assign
      varis-meas:sensitive in frame {&frame-name} = no
      varef-nid:sensitive in frame {&frame-name} = no
    .
  end.
  if not is-ef then do:
    hide
    varef-nid
    lef-nid
    in frame {&frame-name} .
  end.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key B-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records B-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "ub.pump-nozzle"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed B-table-Win
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/bstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME