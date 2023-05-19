&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ub               PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f-c-p


/* Temp-Table and Buffer definitions                                    */
define buffer buf-code for Code.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f-c-p 
/*

$Revision: $
$Author: $
$Date: $
$Workfile: $
$Archive: $

Код ОКЕИ код ККТ

Автор: Рукавишников Вадим
Дата создания: 21/04/21
Author: Rukavishnikov Vadim
Creation date: 21/04/21

*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

{ref/codepar.i}
define variable vss-revision    as character no-undo init "$Revision: $":U .
define variable vss-author      as character no-undo init "$Author: $":U .
define variable vss-date        as character no-undo init "$Date: $":U .
define variable vss-workfile    as character no-undo init "$Workfile: $":U .
define variable vss-archive     as character no-undo init "$Archive: $":U .
define variable vss-description as character no-undo init "Код ОКЕИ код ККТ".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i  }
{ cmp/library.i }
{ cmp/showinf.i }
{ cmp/r-pril.i new }
{ gbl/cur-time.i }
{ gbl/getcntxt.i def }
{ gbl/prn-lib.i }
{ gbl/waitfram.i }
{ cmp/mrk-strf.i }
{ ref/code-func.i }
{gbl/tmprecid.i }
  
&Scoped-define CODE_PARENT mParent 
&Scoped-define EditWhere and v-db-num = 0
&Scoped-define SearchTable  code  
&Scoped-define SearchWhere  ~{&SearchTable~}.parent = ~{&CODE_PARENT~}
/* Local Variable Definitions ---                                       */
define variable mParent as character no-undo.
if    iparent eq ""
   or iparent eq ?
then
   mparent = icode.
else
   mparent = iparent + {&delim-par} + icode. 
define variable log-res     as log       no-undo.
define variable ri          as recid     no-undo.
define variable v-rid       as recid     no-undo .
define variable v-db-num like ub.db.db-num no-undo .
define variable MaxLevel as integer no-undo.
function endLevel returns logical():

   return MaxLevel ne 0 and num-entries(mparent,{&delim-par})  eq  MaxLevel  .
end.
define variable startlevel as integer no-undo.
startlevel = num-entries(mparent,{&delim-par}) .
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-c-p
&Scoped-define BROWSE-NAME BROWSE-Code

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Code

/* Definitions for BROWSE BROWSE-Code                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Code Code.code Code.CodeName 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Code 
&Scoped-define QUERY-STRING-BROWSE-Code FOR EACH {&SearchTable} ~
      where {&SearchWhere} NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-codebrow OPEN QUERY BROWSE-Code FOR each {&SearchTable} ~
      where {&SearchWhere} NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BROWSE-Code Code
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Code Code


/* Definitions for DIALOG-BOX f-c-p                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-f-c-p ~
    ~{&OPEN-QUERY-codebrow}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-sel b-add b-del b-upd b-help b-chiled b-hist

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button b-add 
     label "&Добавить":L 
     size 10 by 1.

define button b-chiled 
     label "&Открыть" 
     size 10 by 1.

define button b-del 
     label "&Удалить":L 
     size 10 by 1.

define button b-exit
     label "&Выход ":L 
     size 10 by 1.

define button b-help 
     label "Помо&щь":L 
     size 3 by 1.

define button b-sel 
     label "Вы&бор ":L 
     size 10 by 1.

define button b-upd 
     label "&Изменить":L 
     size 10 by 1.

define menu POPUP-MENU-b-servis 
    menu-item mGetCashParam     label "Запросить настройки с касс"
    menu-item mExpCashParam     label "Экспорт в Excel"
    menu-item mImpCashParam     label "Импорт из Excel"
.

define button b-hist 
     label "Ис&тория":L 
     size 10 by 1.
     
define variable mSearch   as character       format "x(60)":U 
   label "Поиск" 
   view-as fill-in 
   size 60 by 1 no-undo.
        
define menu POPUP-MENU-b-hist 
    menu-item mHistOne     label "История этой записи"
    menu-item mHistChiled  label "История потомков"
.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
define query BROWSE-Code for 
      Code scrolling.
&ANALYZE-RESUME

/* Browse definitions                                                   */
define browse BROWSE-Code
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Code f-c-p _STRUCTURED
  query BROWSE-Code no-lock display
      isSelect(buffer code:handle) @ fSelect
      Code.code format "x(8)":U
      Code.CodeName format "x(60)":U width 54.13
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 73 BY 20 ROW-HEIGHT-CHARS .67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

define frame f-c-p
     b-exit at row 1 col 1
     b-sel at row 1 col 14
     b-add at row 1 col 24
     b-del at row 1 col 34 widget-id 2
     b-upd at row 1 col 44
     b-help at row 1 col 71
     b-chiled at row 1 col 54 widget-id 10
     b-hist at row 1 col 64
     mSearch at row 2.5 col 1.2
     BROWSE-Code at row 4 col 1 widget-id 300
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         title "Устройства":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Temp-Tables and Buffers:
      TABLE: buf-code B "?" ? ub Code
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f-c-p
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-Code b-chiled f-c-p */
assign 
       frame f-c-p:SCROLLABLE       = false.

/* SETTINGS FOR BROWSE BROWSE-Code IN FRAME f-c-p
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Code
/* Query rebuild information for BROWSE BROWSE-Code
     _TblList          = "ub.Code"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Where[1]         = "Code.parent = {&CODE_PARENT}"
     _FldNameList[1]   = ub.Code.code
     _FldNameList[2]   > ub.Code.CodeName
"Code.CodeName" ? ? "character" ? ? ? ? ? ? no ? no no "54.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Code */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */
&Scoped-define SELF-NAME mHistOne
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mHistOne f-c-p
on choose of menu-item mHistOne /* История однойзаписи */
do:
   define variable v-rid-list as character no-undo.
   if avail code then  
   do:
      run ref/ccode.w (
                code.parent, 
                code.code,
                parparentproc,
                0,
                "",
                0,
                "",
                "one",
                ?,
                "",
                "" ,
                v-cntxt-db-num,
                ?,
                input-output v-rid-list ) .
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mHistChiled
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mHistChiled f-c-p
on choose of menu-item mHistChiled /* Отключить запрос Token */
do:
   define variable v-rid-list as character no-undo.
   if avail code then  
   do:
      run ref/ccode.w (
                code.parent, 
                code.code,
                parparentproc,
                0,
                "",
                0,
                "",
                "parentBeg",
                ?,
                "",
                "" ,
                v-cntxt-db-num,
                ?,
                input-output v-rid-list ) .
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mGetCashParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mGetCashParam f-c-p
on choose of menu-item mGetCashParam /* Отключить запрос Token */
do:
   define variable vList as character no-undo init "cashp1i,cashp2i".
   if vList ne ""
   then 
      run str/diallog.w (
            input parparentproc
          , input this-procedure
          , input "str/send-all.p":U
          , input ( v-cntxt-obj-type + {&delim-par} + string(v-cntxt-obj-code) + {&delim-par} + 'U':U + {&delim-par} + vList + {&delim-par} + 'Получение параметров кассы':U)
          , input ? /*p-auto-go*/
          , input "":U
          , input substitute("Получение параметров кассы")
        ) no-error.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mExpCashParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mExpCashParam f-c-p
on choose of menu-item mExpCashParam /* Отключить запрос Token */
do:
   run bge/cashparexp.p no-error.
   if error-status:error
   then
      message return-value skip
              error-status:get-message (1)
      view-as alert-box.
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mImExpCashParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mImpCashParam f-c-p
on choose of menu-item mImpCashParam /* Отключить запрос Token */
do:
   run bge/cashparImp.p no-error.
   if error-status:error
   then
      message return-value skip
              error-status:get-message (1)
      view-as alert-box.
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME f-c-p
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-c-p f-c-p
on go of frame f-c-p /* Группы параметров */
do:
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit f-c-p
on choose of b-exit in frame f-c-p /* Добавить */
do:
   define variable vView as logical no-undo.
   run PrevLevel(output vView).
   if vView
   then do:
      {&OPEN-QUERY-codebrow}
      apply "ENTRY" to BROWSE-Code.
   end.
   else
      apply "GO" to frame {&FRAME-NAME}.
   return.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-add f-c-p
on choose of b-add in frame f-c-p /* Добавить */
do:
   
   
   define buffer b1-code for code.
   define buffer btt-code for code.
   define variable vRec as recid no-undo.
   define variable v-ok as logical no-undo.

   run ref/cashparamgu.w (
                            input parparentproc
                          , input {&add-def}
                          , input {&CODE_PARENT}
                          , input-output ri).
   if ri <> ? then  do:

            {&OPEN-QUERY-codebrow}
            reposition BROWSE-Code to recid ri.
            apply "ENTRY" to BROWSE-Code.

   end.
   
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-chiled
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-chiled f-c-p
on choose of b-chiled in frame f-c-p /* Параметры */
do:
  run nextlevel.
   
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-del f-c-p
on choose of b-del in frame f-c-p /* Удалить */
do:
   define buffer b1-code for code.
   if not avail code then return.
   define variable v-ok as logical no-undo.

   message "Удалить запись группу параметров " code.code " (" code.codename ")?"
      view-as alert-box question
      buttons yes-no
      title "Удаление"
      update v-ok .
   if not v-ok then return no-apply.
   do on error undo, return
   on stop undo, return:
      find first b1-code of code exclusive-lock no-wait no-error.
      if locked b1-code then do:
         message
            vss-workfile vss-revision vss-description skip
            "Группа занята"
         view-as alert-box error .
         undo, return.
      end.
      if not available b1-code then do:
         message
            vss-workfile vss-revision vss-description skip
            "Не найдена запись группы"
         view-as alert-box error .
         undo, return.
      end.
      delete b1-code.
      {&OPEN-QUERY-codebrow}
      apply "ENTRY" to BROWSE-Code.
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-sel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-sel f-c-p
on choose of b-sel in frame f-c-p /* Выбор  */
do:
   if imode eq {&select}
   then do:
      if not avail code then return.
      setSelect(buffer code:handle).
      {&BROWSE-NAME}:refresh ().
   end.
   else do:
      
   end.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-upd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-upd f-c-p
on choose of b-upd in frame f-c-p /* Изменить */
do:
   define variable vRec as recid no-undo.
   
   if not avail code then return.
   define variable v-ok as logical no-undo.

   vRec = recid(code).
   run ref/cashparamgu.w (
                            input parparentproc
                          , input {&update}
                          , input-output vRec).

         {&OPEN-QUERY-codebrow}
         reposition BROWSE-Code to recid vRec.
         apply "ENTRY" to BROWSE-Code.
      end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Code f-c-p
on mouse-select-dblclick of BROWSE-Code in frame f-c-p
or return of {&SELF-NAME} in frame {&FRAME-NAME}
do:
  apply "choose" to b-chiled in frame {&frame-name}.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mSearch f-c-p
on ENTER of mSearch in frame {&frame-name}
do:
   &Scoped-define SearchTable buf-code-search
   define buffer {&SearchTable} for ub.code.
   assign
     msearch
   .
   define variable vRec as recid no-undo init ?.
   block-code:
   for each {&SearchTable} where ({&SearchWhere} and {&SearchTable}.code     begins msearch) 
                              or ({&SearchWhere} and {&SearchTable}.CodeName begins msearch)
   no-lock:
      vRec = recid({&SearchTable}).
      leave block-code.
   end.
   &Scoped-define SearchTable  {&INTERNAL-TABLES} 
   if vRec eq ?
   then do:
      message "Запись не найдена"
      view-as alert-box.
   end.
   else do:
      {&OPEN-QUERY-BROWSE-Code}
      reposition BROWSE-Code to recid vRec no-error .
      apply "ENTRY" to BROWSE-Code.
   end. 
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define BROWSE-NAME BROWSE-Code
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f-c-p 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
if valid-handle(active-window) and frame {&FRAME-NAME}:PARENT eq ?
  then frame {&FRAME-NAME}:PARENT = active-window.

{ gbl/app_help.i }

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
on window-close of frame {&FRAME-NAME}
  apply "END-ERROR":U to self.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
do on error   undo MAIN-BLOCK, leave MAIN-BLOCK
  on end-key undo MAIN-BLOCK, leave MAIN-BLOCK:
  if imode eq {&select}
  then
     run rid-rest no-error.
  { gbl/getcntxt.i get }
  { gbl/curdbnum.i v-db-num }

  run enable_UI in this-procedure .

  wait-for go of frame {&FRAME-NAME} focus {&browse-name}.
  if imode eq {&select}
  then
     run rid-keep no-error.
end.
run disable_UI in this-procedure .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f-c-p  _DEFAULT-DISABLE
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
  hide frame f-c-p.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f-c-p 
procedure enable_UI :
/* --------------------------------------------------------------------
        Purpose:     ENABLE the User Interface
        Parameters:  <none>
        Notes:       Here we display/view/enable the widgets in the
                     user-interface.  In addition, OPEN all queries
                     associated with each FRAME and BROWSE.
                     These statements here are based on the "Other
                     Settings" section of the widget Property Sheets.
         -------------------------------------------------------------------- */
  enable
    mSearch
    BROWSE-Code
    b-exit
    b-chiled
    b-add
    when imode eq {&update} {&EditWhere}  
    
    b-del
    when imode eq {&update} {&EditWhere}
    b-upd
    when imode eq {&update} {&EditWhere}
    b-hist   
    b-help
    with frame {&frame-name}.
  if imode ne {&select}
  then do:
     b-sel:label = "Меню".
      enable b-sel
         
      with frame {&frame-name}
      .
      menu-item mGetCashParam:sensitive in menu POPUP-MENU-b-servis = yes {&EditWhere}.
      menu-item mImpCashParam:sensitive in menu POPUP-MENU-b-servis = yes {&EditWhere}.

      b-sel:POPUP-MENU in frame {&frame-name} = menu POPUP-MENU-b-servis:HANDLE.
      assign 
         b-sel:MENU-MOUSE = 1.
  end.
  else enable b-sel
         when imode eq {&select}
       with frame {&frame-name}
      .
  fselect                :visible in browse {&BROWSE-NAME} = imode eq {&select}.
  b-hist:POPUP-MENU in frame {&frame-name} = menu POPUP-MENU-b-hist:HANDLE.
  b-hist:MENU-MOUSE = 1.  
 

  {&OPEN-BROWSERS-IN-QUERY-f-c-p}

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NextLevel  
procedure NextLevel:
   if available  code 
   then do:
      if imode eq {&select}
      then
         run rid-keep no-error.
      run ref/codelay.p (  input parparentproc
                                 , input imode
                                 , input Code.parent
                                 , input code.code
                                 , input ?).
      if imode eq {&select}
      then
         run rid-rest no-error.
      
      
   end.
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrevLevel  
procedure PrevLevel:
   define output parameter oView as logical no-undo.
   if mparent ne ""
   then do:
      assign
         entry(num-entries(mparent,{&delim-par}),mparent,{&delim-par}) = ""
         mparent = right-trim(mparent,{&delim-par})
      .
         
      if num-entries(mparent,{&delim-par}) < startlevel
      then do:
         if imode eq {&select}
         then do:
            for each tmprecid:
               delete tmprecid.
            end.  
            run gbl/rid-keep.p (input table tmprecid) no-error.
         end.
         oView = no.
         return.
      end.
      else do:   
            {&OPEN-QUERY-codebrow}
            oView = yes.
            return.
         end.
      end.
      
   end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

