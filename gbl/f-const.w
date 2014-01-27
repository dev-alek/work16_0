&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r11 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME    DIALOG-1
&Scoped-define FRAME-NAME     DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Заведение константных выражений для фильтра

Автор: Хныкин Павел Андреевич
Дата создания: 06/10/95
Author: Pavel Khnykin
Creation date: 06/10/95

*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define input parameter parparentproc as widget-handle no-undo .
define input  parameter spr     as character no-undo .
define input  parameter type    as character no-undo .
define output parameter str     as character no-undo .
define output parameter str_rus as character no-undo .

define variable vss-revision    as character no-undo initial "$Revision$":U .
define variable vss-author      as character no-undo initial "$Author$":U .
define variable vss-date        as character no-undo initial "$Date$":U .
define variable vss-workfile    as character no-undo initial "$Workfile$":U .
define variable vss-archive     as character no-undo initial "$Archive$":U .
define variable vss-description as character no-undo initial "Заведение константных выражений для фильтра".
{ cmp/vssrevis.i "substitute('&1|&2':u,spr,type)"}
{ cmp/trg-def.i  }
{ cmp/showinf.i  }
{ gbl/flt-shar.i }
{ gbl/cur-time.i }
{ ref/grplibfn.i }
{ ref/cgrplbfn.i }
{ nws/db-rec.i   }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

define variable v_type     as char no-undo.
DEFINE VARIABLE kk as integer no-undo .


/* ********************  Preprocessor Definitions  ******************** */

/* Name of first Frame and/or Browse (alphabetically)                   */
&Scoped-define FRAME-NAME  DIALOG-1

/* Custom List Definitions                                              */
&Scoped-define LIST-1
&Scoped-define LIST-2
&Scoped-define LIST-3

/* Definitions for DIALOG-BOX DIALOG-1                                  */
&Scoped-define FIELDS-IN-QUERY-DIALOG-1
&Scoped-define ENABLED-FIELDS-IN-QUERY-DIALOG-1

/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-spr
     IMAGE-UP FILE "btn-left-arrow"
     IMAGE-DOWN FILE "btn-left-arrow"
     IMAGE-INSENSITIVE FILE "btn-left-arrow"
     LABEL "":L
     SIZE 3 BY .88.

DEFINE BUTTON Btn_Cancel AUTO-END-KEY DEFAULT
     LABEL "&Отмена":L
     SIZE 7 BY 1.17
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO DEFAULT
     LABEL "&Сохр.":L
     SIZE 7 BY 1.17
     BGCOLOR 8 .

DEFINE BUTTON {&Btn_Help} DEFAULT
     LABEL "Помо&щь":L
     SIZE 10 BY 1.17
     BGCOLOR 8 .

DEFINE VARIABLE comb AS CHARACTER FORMAT "X(256)":U
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1"
     SIZE 41 BY 1.08 NO-UNDO.

DEFINE VARIABLE in-char AS CHARACTER FORMAT "X(256)":U
     VIEW-AS FILL-IN
     SIZE 25.5 BY 1 NO-UNDO.

DEFINE VARIABLE in-date AS DATE FORMAT "99/99/9999":U INITIAL ?
     VIEW-AS FILL-IN
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE in-dec AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 25.5 BY 1 NO-UNDO.

DEFINE VARIABLE in-int AS INTEGER FORMAT "->>,>>>,>>>,>>9":U INITIAL 0
     VIEW-AS FILL-IN
     SIZE 25.5 BY 1 NO-UNDO.

DEFINE VARIABLE in-log AS CHARACTER
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS
          "Да (Истино)", "TRUE",
"Нет (Ложь)", "FALSE"
     SIZE 14 BY 2.25 NO-UNDO.

DEFINE VARIABLE toggle-date AS LOGICAL INITIAL no
     LABEL "СЕГОДНЯ +/- ДНЕЙ"
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
       Btn_OK     AT ROW 1.25 COL  2.5
       Btn_Cancel AT ROW 1.25 COL 11
     {&Btn_Help}  AT ROW 1.25 COL 25   SPACE(0.03)
     in-log       AT ROW 3    COL  4.5 NO-LABEL
     comb         AT ROW 4.5  COL  2.5 NO-LABEL
     in-char      AT ROW 4.5  COL  2.5 NO-LABEL
     in-date      AT ROW 4.5  COL  2.5 NO-LABEL
     toggle-date  AT ROW 4.5  COL 15
     in-dec       AT ROW 4.5  COL  2.5 NO-LABEL
     in-int       AT ROW 4.5  COL  2.5 NO-LABEL
     b-spr        AT ROW 4.5  COL 30.5 SKIP(0.44)
WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER
     SIDE-LABELS NO-UNDERLINE THREE-D SCROLLABLE
     TITLE "":L
     DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.




/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
ASSIGN
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON b-spr IN FRAME DIALOG-1
   NO-ENABLE                                                            */
ASSIGN
       b-spr:HIDDEN IN FRAME DIALOG-1           = TRUE.

/* SETTINGS FOR COMBO-BOX comb IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN in-char IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN in-date IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN in-dec IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN in-int IN FRAME DIALOG-1
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */
on choose of btn_ok in frame dialog-1 do:
   { gbl/stdbtn.i }
     case spr :
         when 'pay' then do:
            find ub.pay-type where ub.pay-type.obj-code = input frame dialog-1 in-int no-lock no-error.
            if avail ub.pay-type then str_rus = ub.pay-type.obj-name.
         end.
         when 'curr' then do:
            find ub.currency where ub.currency.curr-code = input frame dialog-1 in-int no-lock.
            if available ub.currency then str_rus = ub.currency.curr-abbr.
         end.
         when 'prt' then do:
            find ub.gds-prt where ub.gds-prt.upper-code = input frame dialog-1 in-int no-lock no-error.
            if avail ub.gds-prt then str_rus = ub.gds-prt.node-name.
         end.
         when 'db' then do:
            find ub.db where ub.db.db-num = input frame dialog-1 in-int no-lock no-error.
            if avail ub.db then str_rus = substitute("&1", ub.db.db-num).
         end.

     end case.
end.

&Scoped-define SELF-NAME b-spr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-spr DIALOG-1
ON CHOOSE OF b-spr IN FRAME DIALOG-1
DO:
  { gbl/stdbtn.i }
  define variable grp-rec as recid no-undo.
  define variable ref-rec as recid no-undo.
  define variable grp_name as char no-undo.
  define variable ref-list as char.
  define variable out-an as int no-undo.
  define variable  rid-list as character no-undo .

  case spr :
         when 'pay' then do:
            run ref/paytype.w (input parparentproc, "b-sel", output  rid-list ).
            find ub.pay-type where recid ( ub.pay-type ) = integer( rid-list) no-lock no-error.
            if available ub.pay-type then do:
               in-int = ub.pay-type.obj-code.
               disp in-int with frame {&frame-name}.
               apply "choose" to btn_ok.
               return no-apply.
            end.
         end.
         when 'curr' then do:
            assign
            ref-rec = ?.
            run ref/currency.w (parparentproc, "b-sel", input-output ref-rec ).
            if ref-rec = ? then return no-apply.
            find ub.currency where recid ( ub.currency ) = ref-rec no-lock.
            if available ub.currency then do:
               in-int = ub.currency.curr-code.
               disp in-int with frame {&frame-name}.
               apply "choose" to btn_ok.
               return no-apply.
            end.
         end.
         when 'unit' then do:
            run ref/units.w (input parparentproc
                       , input yes
                       , output ref-rec).
            if ref-rec = ? then return no-apply.
            find ub.units where recid ( ub.units ) = ref-rec no-lock.
            if available ub.units then do:
               in-char = ub.units.unit-name.
               disp in-char with frame {&frame-name}.
               apply "choose" to btn_ok.
               return no-apply.
            end.
         end.
         when 'country' then do:
            run ref/countris.w (
                            input parparentproc
                          , input "b-sel"
                          , input-output rid-list).
            if ref-rec = ? then return no-apply.
            find ub.country where recid ( ub.country ) = integer(rid-list) no-lock.
            if available ub.country then do:
               in-char = ub.country.alpha1.
               disp in-char with frame {&frame-name}.
               apply "choose" to btn_ok.
               return no-apply.
            end.
         end.
         when 'prt' then do:
          run ref/gdsprts.w ( parparentproc, yes, output ref-rec ).
          find  ub.gds-prt where recid ( ub.gds-prt ) = ref-rec no-lock no-error.
          if avail ub.gds-prt then do:
            in-int = ub.gds-prt.upper-code.
            disp in-int with frame {&frame-name}.
            apply "choose" to btn_ok.
            return no-apply.
          end.
         end.
         when 'cligrp' then do:
                  ref-list = "".
                  run ref/cli-grps.w (input parparentproc, "b-sel", input-output ref-list).
                  grp-rec = int(ref-list).
                  if grp-rec <> 0 then do:
                     find ub.cli-grp where recid(ub.cli-grp) = grp-rec.
                     run cli-grplib-get-full-name in this-procedure(input ub.cli-grp.node-code, output grp_name).
                     in-char = grp_name.
                     disp in-char with frame {&frame-name}.
                     apply "choose" to btn_ok.
                     return no-apply.
                  end.
         end.
         when 'gdsgrp' then do:
            ref-list = "".
            run ref/gds-grp.w (parparentproc, "b-sel", '':U, 0, input-output ref-list ).
            grp-rec = int( ref-list ).
            if grp-rec <> 0 then do:
                find ub.gds-grp where recid( ub.gds-grp ) = grp-rec.
                run grplib-get-full-name in this-procedure ( input ub.gds-grp.node-code, output grp_name ).
                in-char = grp_name.
                disp in-char with frame {&frame-name}.
                apply "entry" to btn_ok.
            end. else apply "entry" to b-spr.
         end.
         when 'db' then do:
            run adm/dbs.w (
                           input parparentproc
                          ,input {&lookup}
                          ,output  ref-rec ).
            find ub.db where recid ( ub.db ) = ref-rec no-lock no-error.
            if available ub.db then do:
               in-int = ub.db.db-num.
               disp in-int with frame {&frame-name}.
               apply "choose" to btn_ok.
               return no-apply.
            end.
         end.
  end case.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1


{ gbl/hot-key.i {&Btn_Help} }

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

{ gbl/app_help.i }

{ gbl/ed_date.i in-date }

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR    UNDO MAIN-BLOCK, return error
      ON STOP       UNDO MAIN-BLOCK, return error
      ON END-KEY UNDO MAIN-BLOCK, return error :

  if can-do("cligrp,gdsgrp,pay,curr,unit,prt,country,db",spr) then do:
    assign
      b-spr:sensitive = yes
      b-spr:visible = yes
    .
  end.

  RUN UI_on.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  case type:
    when "character"
    then do:
      if can-do( "trn-stat,trn-type,order-status-all,order-type-all,ext-doc-type,pr-stat,fbr-stat,gds-type,form-type,actions," +
                 "tbl-name,fin-doc-stat,fin-doc-type,fin-ext-doc-type," +
                 "gds-hist-subject,cli-hist-subject,dc-hist-subject,dc-type-hist-subject,tax-hist-subject,gds-grp-hist-subject,cli-grp-hist-subject,scl-hist-subject," +
                 "fbr-gds-grp-hist-subject,plc-hist-subject,pmp-hist-subject,nzl-hist-subject,sht-hist-subject,sert-hist-subject," +
                 "hist-source-type," +
                 "contract-type,usl-opl,db-rec-attr-type,db-rec-attr-cmd,nws-coll_codes," +
                 "cd-types,cd-types-real,cd-types-discnt,rcv-type-all,wth-ext-type", spr )
      then do:
        assign
          str = input frame {&frame-name} comb
          str_rus = input comb
        .
      end.
      else do:
        assign
          str = input frame {&frame-name} in-char
          str_rus = input in-char
        .
      end.
      if can-do( "ext-doc-type,fin-ext-doc-type,gds-hist-subject,cli-hist-subject,dc-hist-subject,dc-type-hist-subject,tax-hist-subject," +
                 "gds-grp-hist-subject,cli-grp-hist-subject,fbr-gds-grp-hist-subject,plc-hist-subject,pmp-hist-subject,sht-hist-subject,nzl-hist-subject,sert-hist-subject,scl-hist-subject," +
                 "hist-source-type,db-rec-attr-cmd,nws-coll_codes," +
                 "cd-types,cd-types-real,cd-types-discnt,rcv-type-all,wth-ext-type", spr)
      then do:
        assign
          kk = comb:lookup(str)
          str = entry( kk, comb:private-data)
        .
      end.

      assign
        str_rus = replace(str_rus, ',', '~~054')
      .
    end.
    when "date"
    then do:
      if input frame {&frame-name} in-date = "":U
      or input frame {&frame-name} in-date = ?
      or input frame {&frame-name} in-date = "?"
      then do:
        assign
          str = {&question-mark}
          str_rus = {&question-mark}
        .
      end.
      else do:
        if toggle-date :checked = true then do:
          define variable v-diff-value as integer   no-undo .
          define variable v-diff-str   as character no-undo .
          define variable v-diff-day   as character no-undo .
          assign
            v-diff-value = input frame {&frame-name} in-date - today
          .
          if v-diff-value = 0
          then do:
            assign
              v-diff-str = ""
              v-diff-day = ""
            .
          end.
          if v-diff-value > 0
          then do:
            assign
              v-diff-str = '+ ':u + string(v-diff-value)
              v-diff-day = v-diff-str + " ДНЕЙ"
            .
          end.
          if v-diff-value < 0
          then do:
            assign
              v-diff-str = '- ':u + string(abs(v-diff-value))
              v-diff-day = v-diff-str + " ДНЕЙ"
            .
          end.
          assign
            str = '(TODAY ':u + v-diff-str + ')':u
            str_rus = "СЕГОДНЯ " + v-diff-day
          .
        end.
        else do:
          define variable v-date as date      no-undo .
          assign
            v-date = input frame {&frame-name} in-date
          .
          if v-date = ?
          then do:
            assign
              str = {&question-mark}
              str_rus = "НЕ_ЗАДАНА"
            .
          end.
          else do:
            assign
              str = 'date(':u + string(month(v-date))
                  + '~~054':u + string(day(v-date))
                  + '~~054':u + string(year(v-date))
                  + ')':u
              str_rus = string(v-date, "99/99/9999")
            .
          end.
        end.
      end.
    end.
    when "decimal"
    then do:
      assign
        str = string(input frame {&frame-name} in-dec)
        str_rus = string(input in-dec)
      .
    end.
    when "integer"
    then do:
      if can-do( "pay,curr,prt,db", spr )
      then do:
        assign
          str = string( input frame {&frame-name} in-int )
        .
      end.
      else do:
        if can-do( "course-type,purch-code,hist-action,receipt-code,wth-receipt-code", spr )
        then do:
          case spr :
            when "course-type"
            then do:
              assign
                str     = string( if comb:screen-value = "ММВБ" then 2 else
                          ( if comb:screen-value = "ЦБ"      then 1 else 0 ), "9" )
                str_rus = comb:screen-value
              .
            end.
            when "purch-code"
            then do:
              assign
                str        = string( entry(lookup(comb:screen-value, {&purchase-codes-full}), {&purchase-codes}))
                str_rus = comb:screen-value
              .
            end.
            when "hist-action"
            then do:
              assign
                str        = string( entry(lookup(comb:screen-value, {&hn-actions-full}), {&hn-actions}))
                str_rus = comb:screen-value
              .
            end.
            when "receipt-code"
            then do:
              assign
                str        = string( entry(lookup(comb:screen-value, {&receipt-codes-full}), {&receipt-codes}))
                str_rus = comb:screen-value
              .
            end.
            when "wth-receipt-code"
            then do:
              assign
                str        = string( entry(lookup(comb:screen-value, {&wth-receipt-codes-full}), {&wth-receipt-codes}))
                str_rus = comb:screen-value
              .
            end.
          end case.
        end.
        else do:
          assign
            str = string(input frame {&frame-name} in-int)
            str_rus = string(input in-int)
          .
        end.
      end.
    end.
    when "logical" then do:
      assign
        str = (input frame {&frame-name} in-log)
        str_rus = (if input in-log = "TRUE" then "ИСТИНА" else "ЛОЖЬ")
      .
    end.
  end case.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
PROCEDURE disable_UI :
/* --------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
   -------------------------------------------------------------------- */
  /* Hide all frames. */
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
PROCEDURE enable_UI :
/* --------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other
               Settings" section of the widget Property Sheets.
   -------------------------------------------------------------------- */
  DISPLAY in-log comb in-date toggle-date in-dec in-char in-int
      WITH FRAME DIALOG-1.
  ENABLE in-log comb in-date toggle-date in-dec in-char in-int Btn_OK Btn_Cancel {&Btn_Help}
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UI_on DIALOG-1
PROCEDURE UI_on :
/* -----------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------*/
DEFINE VARIABLE v-time as integer no-undo .
define variable dca as integer no-undo .
define variable v-label as character no-undo .
define variable v-tooltip as character no-undo .
define variable ii as integer no-undo .
                case type:
          when "character" then do:
            if can-do( "trn-stat,trn-type,order-status-all,order-type-all,ext-doc-type,pr-stat,fbr-stat,gds-type,form-type,actions," +
                        "tbl-name,fin-doc-stat,fin-doc-type,fin-ext-doc-type," +
                        "gds-hist-subject,cli-hist-subject,dc-hist-subject,dc-type-hist-subject,tax-hist-subject," +
                        "gds-grp-hist-subject,cli-grp-hist-subject,fbr-gds-grp-hist-subject,plc-hist-subject,pmp-hist-subject,nzl-hist-subject,scl-hist-subject," +
                        "sht-hist-subject,sert-hist-subject,hist-source-type,contract-type,usl-opl,db-rec-attr-cmd,db-rec-attr-type,nws-coll_codes," +
                        "cd-types,cd-types-real,cd-types-discnt,rcv-type-all,wth-ext-type", spr ) then do:
               frame {&frame-name}:title = "Выберите значение".

               case spr :
                 when "trn-stat"  then comb:list-items = {&trn-stat}.
                 when "order-status-all"  then comb:list-items = {&ord-status}.
                 when "rcv-type-all"  then
                  assign
                    comb:list-items   = {&rcv-type-spis_full}
                    comb:private-data = {&rcv-type-spis}
                    comb:inner-lines  = num-entries({&rcv-type-spis})
                    .

                 when "order-type-all"  then comb:list-items = {&order-type-all}.
                 when "trn-type"        then comb:list-items = {&trn-type}.
                 when "ext-doc-type"    then do:
                  assign
                  comb:list-items = {&TDEDT_List-full}
                  comb:private-data = {&TDEDT_List}
                  comb:inner-lines = num-entries({&TDEDT_List})
                  .
                 end.
                 when "db-rec-attr-type" then do:
                  assign
                  comb:list-items = "commit,execution,recover"
                  .
                 end.
                 when "db-rec-attr-cmd" then do:
                  assign
                  comb:private-data = {&db-rec-attr-list}
                  comb:inner-lines = num-entries({&db-rec-attr-list})
                  comb:list-items = "":U
                  .
                  do ii = 1 to comb:inner-lines:
                    assign
                    comb:list-items = (if ii = 1 then "":U else comb:list-items) +
                                     (if ii = 1 then "":U else {&comma-char}) +
                                      progs-title-function(entry(ii, comb:private-data))
                    .
                  end.
                 end.
                 when "nws-coll_codes" then do:
                  assign
                  comb:private-data = {&nws-coll_codes}
                  comb:inner-lines = num-entries({&nws-coll_codes})
                  comb:list-items = "":U
                  .
&scop nws-coll_code entry(ii, comb:private-data)
                  do ii = 1 to comb:inner-lines:
                    assign
                    comb:list-items = (if ii = 1 then "":U else comb:list-items) +
                                     (if ii = 1 then "":U else {&comma-char}) +
                                     {&nws-coll_name}
                    .
                  end.
                 end.


                 when "fin-doc-stat"  then comb:list-items = {&fin-status-all}.
                 when "fin-doc-type"  then comb:list-items = {&fin-doc-types}.
                 when "fin-ext-doc-type" then do:
                  assign
                  comb:list-items = {&fin-ext-doc-types-full}
                  comb:private-data = {&fin-ext-doc-types}
                  comb:inner-lines = num-entries({&fin-ext-doc-types-full})
                  .
                 end.

                 when "pr-stat"   then comb:list-items = {&pr-stat}.
                 when "fbr-stat"  then comb:list-items = {&fbr-stat}.
                 when "gds-type"  then comb:list-items = {&gds-type}.
                 when "actions"  then comb:list-items = {&h-actions}.
                 when "tbl-name"  then comb:list-items = {&h-tbl-names}.
                 WHEN "form-type" THEN DO:
                   ASSIGN comb :LIST-ITEMS  = "{&form-type}"
                          comb :INNER-LINES = NUM-ENTRIES( "{&form-type}" ).
                 END.
                 when "gds-hist-subject"  then do:

                 assign
                 comb:list-items = {&gds-hist-subject-full}
                 comb:private-data = {&gds-hist-subject}
                 .
                 end.
                 when "cli-hist-subject"  then
                 assign
                 comb:list-items = {&cli-hist-subject-full}
                 comb:private-data = {&cli-hist-subject}
                 .
                 when "dc-hist-subject"  then
                 assign
                 comb:list-items = {&dc-hist-subject-full}
                 comb:private-data = {&dc-hist-subject}
                 .
                 when "dc-type-hist-subject"  then
                 assign
                 comb:list-items = {&dc-hist-subject-full}
                 comb:private-data = {&dc-hist-subject}
                 .

                 when "tax-hist-subject"  then do:
                 assign
                 comb:list-items = {&tax-hist-subject-full}
                 comb:private-data = {&tax-hist-subject}
                 .
                 end.
                 when "gds-grp-hist-subject"  then
                 assign
                 comb:list-items = {&gds-grp-hist-subject-full}
                 comb:private-data = {&gds-grp-hist-subject}
                 .
                 when "cli-grp-hist-subject"  then
                 assign
                 comb:list-items = {&cli-grp-hist-subject-full}
                 comb:private-data = {&cli-grp-hist-subject}
                 .
                 when "fbr-gds-grp-hist-subject"  then
                 assign
                 comb:list-items = {&fbr-gds-grp-hist-subject-full}
                 comb:private-data = {&fbr-gds-grp-hist-subject}
                 .
                 when "plc-hist-subject"  then
                 assign
                 comb:list-items = {&plc-hist-subject-full}
                 comb:private-data = {&plc-hist-subject}
                 .
                 when "pmp-hist-subject"  then
                 assign
                 comb:list-items = {&pmp-hist-subject-full}
                 comb:private-data = {&pmp-hist-subject}
                 .
                 when "nzl-hist-subject"  then
                 assign
                 comb:list-items = {&nzl-hist-subject-full}
                 comb:private-data = {&nzl-hist-subject}
                 .
                 when "sht-hist-subject"  then
                 assign
                 comb:list-items = {&sht-hist-subject-full}
                 comb:private-data = {&sht-hist-subject}
                 .
                 when "sert-hist-subject"  then
                 assign
                 comb:list-items = {&sert-hist-subject-full}
                 comb:private-data = {&sert-hist-subject}
                 .
                 when "hist-source-type"  then do:
                 assign
                 comb:list-items = {&hn-sources-full}
                 comb:private-data = {&hn-sources}
                 .
                 end.
                 when "scl-hist-subject"  then do:
                 assign
                 comb:list-items = {&scl-hist-subject-full}
                 comb:private-data = {&scl-hist-subject}
                 .
                 end.

                 when "contract-type"  then assign comb:list-items = {&contract-type-list} .
                 when "usl-opl"  then assign comb:list-items = {&contr-usl-opl-list} .
                 when "cd-types" then do:
                  assign
                  comb:list-items = {&cd-type-codes-full}
                  comb:private-data = {&cd-type-codes}
                  comb:inner-lines = num-entries({&cd-type-codes})
                  .
                 end.
                 when "cd-types-real" then do:
                  assign
                  comb:list-items = {&cd-type-codes-real-full}
                  comb:private-data = {&cd-type-codes-real}
                  comb:inner-lines = num-entries({&cd-type-codes-real})
                  .
                 end.
                 when "cd-types-discnt" then do:
                  assign
                  comb:list-items = {&cd-type-codes-discnt-full}
                  comb:private-data = {&cd-type-codes-discnt}
                  comb:inner-lines = num-entries({&cd-type-codes-discnt})
                  .
                 end.
                  when "wth-ext-type" then do:
                    assign
                      comb:list-items   = {&WDEDT_List-full}
                      comb:private-data = {&WDEDT_List}
                      comb:inner-lines  = num-entries({&WDEDT_List})
                    .
                  end.
               end case.
               comb = entry(1,comb:list-items).
               disp comb with frame {&frame-name}.
               enable comb  Btn_OK Btn_Cancel {&Btn_Help} with frame {&frame-name}.
               in-char:visible = no.
               in-date:visible = no.
               toggle-date:visible = no.
               in-dec:visible = no.
               in-int:visible = no.
               in-log:visible = no.
            end.
            else do:
               frame {&frame-name}:title = "Введите символьное значение".
               disp in-char with frame {&frame-name}.
               enable in-char  Btn_OK Btn_Cancel {&Btn_Help} with frame {&frame-name}.
               comb:visible = no.
               in-date:visible = no.
               toggle-date:visible = no.
               in-dec:visible = no.
               in-int:visible = no.
               in-log:visible = no.
            end.
          end.
          when "date" then do:
               frame {&frame-name}:title = "Введите дату".
               run cur-time in this-procedure (output in-date, output v-time).
               disp in-date toggle-date with frame {&frame-name}.
               enable in-date toggle-date Btn_OK Btn_Cancel {&Btn_Help} with frame {&frame-name}.
               comb:visible = no.
               in-char:visible = no.
               in-dec:visible = no.
               in-int:visible = no.
               in-log:visible = no.
          end.
          when "decimal" then do:
               frame {&frame-name}:title = "Введите десятичное значение".
               disp in-dec with frame {&frame-name}.
               enable in-dec  Btn_OK Btn_Cancel {&Btn_Help} with frame {&frame-name}.
               comb:visible = no.
               in-date:visible = no.
               toggle-date:visible = no.
               in-char:visible = no.
               in-int:visible = no.
               in-log:visible = no.
          end.
          when "integer" then do:
            if can-do( "course-type,purch-code,hist-action,receipt-code,wth-receipt-code", spr ) then do:
               assign frame {&frame-name}:title = "Выберите значение".
               case spr :
                        when "course-type" then assign comb:list-items    = "ЦБ,ММВБ"   comb:inner-lines = 2.
                        when "purch-code" then assign comb:list-items = {&purchase-codes-full}
                                                      comb:inner-lines = num-entries({&purchase-codes-full})
                                                      .
                        when "hist-action" then
                        assign
                        comb:list-items = {&hn-actions-full}
                        comb:inner-lines = num-entries({&hn-actions-full})
                        .
                        when "receipt-code" then assign comb:list-items = {&receipt-codes-full}
                                                      comb:inner-lines = num-entries({&receipt-codes-full})
                                                      .
                        when "wth-receipt-code" then assign comb:list-items = {&wth-receipt-codes-full}
                                                      comb:inner-lines = num-entries({&wth-receipt-codes-full})
                                                      .


               end case.
               assign comb = entry( 1, comb:list-items ).
               disp comb with frame {&frame-name}.
               enable comb  Btn_OK Btn_Cancel {&Btn_Help} with frame {&frame-name}.
               assign
                in-char:visible = no
                in-date:visible = no
                toggle-date:visible = no
                in-dec:visible  = no
                in-int:visible    = no
                in-log:visible   = no.
            end.
            else do:
               frame {&frame-name}:title = "Введите целое значение".
               disp in-int with frame {&frame-name}.
               enable in-int  Btn_OK Btn_Cancel {&Btn_Help} with frame {&frame-name}.
               comb:visible = no.
               in-date:visible = no.
               toggle-date:visible = no.
               in-dec:visible = no.
               in-char:visible = no.
               in-log:visible = no.
            end.
          end.
          when "logical" then do:
               frame {&frame-name}:title = "Выберите логическое значение".
               disp in-log with frame {&frame-name}.
               enable in-log  Btn_OK Btn_Cancel {&Btn_Help} with frame {&frame-name}.
               comb:visible = no.
               in-date:visible = no.
               toggle-date:visible = no.
               in-dec:visible = no.
               in-int:visible = no.
               in-char:visible = no.
          end.
  end case.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE FRAME-NAME
&UNDEFINE WINDOW-NAME