&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Сканирование акцизных марок

Автор: Шкляр Елена
Дата создания: 07/09/07
Author: Elena Shklyar
Creation date: 07/09/07

*/
&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
using ibs.th.bge.egais.*. 
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS Procedure
using ibs.th.str.alcohol.*.
using ibs.th.str.marking.handlers.*.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Сканирование акцизных марок".
&if defined(globobjSrv) eq 0
&then 
&glob globobjSrv yes
def    var      objSrv          as class     ibs.th.gbl.sys.objsrv no-undo.
run gbl/getobjsrvhndl.p (input-output ObjSrv).
&endif

define input  parameter parparentproc         as  handle              no-undo .
define input  parameter p-doc-code            as  character           no-undo .
define input  parameter p-mode                as character            no-undo .
define input  parameter p-message             as character            no-undo .
define output parameter p-mark                as character            no-undo .
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/library.i  }
{ cmp/showinf.i  }
{ str/marks.i    }
{bge/egais-mark.i}
{ str/lib-trn.i  }
{ str/lib-calc.i }
{ str/libbcrcn.i }
{ cmp/croslist.i }
{ gbl/lineattr.i }
{ gbl/getcntxt.i def }
{ gbl/getcntxt.i get }
{ str/temp_upd.i }
{utl/gtin.i}
{ rep/gn-extp.i }
define temp-table tt-mark no-undo
  field alcmark as character.

/* Parameters Definitions ---                                           */



define variable extGdsObj       as class     extgds.
define variable iLang           as integer   no-undo.

define variable v-alc-code      as character no-undo .
define variable v-proc-name-err as character no-undo initial 'impmark.txt'. /* Имя лога */
define variable l-error         as logical   no-undo. /* Есть ли ошибки */
define variable is-impfile      as logical   no-undo. /* Есть ли ошибки */
define variable v-user-action   as character no-undo.
define variable v-printed       as logical   no-undo.
define variable Tree            as class     tree   no-undo .  
define buffer t_doc        for ub.trn-doc .
define buffer bf_trn-doc   for ub.trn-doc .
define buffer buf_gen-attr for ub.gen-attr .
define buffer bf_parts     for ub.parts .

define variable v-scan-str       as character no-undo.

define stream str-err .
define stream in-stream.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b-exit b-imp v-mark 
&Scoped-Define DISPLAYED-OBJECTS v-mark F-text 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b-exit AUTO-GO 
  LABEL "&Выход" 
  SIZE 10 BY 1
  BGCOLOR 8 .

DEFINE BUTTON b-imp 
  LABEL "Импорт" 
  SIZE 10 BY 1.

DEFINE VARIABLE F-text AS CHARACTER FORMAT "X(256)":U 
  VIEW-AS FILL-IN 
  SIZE 70 BY 1.25
  FGCOLOR 12 NO-UNDO.

DEFINE VARIABLE v-mark AS CHARACTER FORMAT "X(256)":U 
  LABEL "Марка" 
  VIEW-AS FILL-IN 
  SIZE 76 BY 1 
  BGCOLOR 15 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
  b-exit AT ROW 1 COL 1
  b-imp AT ROW 1 COL 32.5 WIDGET-ID 2
  v-mark AT ROW 2.71 COL 7.5 COLON-ALIGNED
  F-text AT ROW 4.25 COL 7.5 NO-LABEL WIDGET-ID 224
  SPACE(0.37) SKIP(0.66)
  WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
  SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
  TITLE "Сканирование марок"
  DEFAULT-BUTTON b-exit.


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
   FRAME-NAME                                                           */
ASSIGN 
  FRAME Dialog-Frame:SCROLLABLE = FALSE
  FRAME Dialog-Frame:HIDDEN     = TRUE.

/* SETTINGS FOR FILL-IN F-text IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Сканирование марок */
  DO:
    APPLY "END-ERROR":U TO SELF.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
ON CHOOSE OF b-exit IN FRAME Dialog-Frame /* Выход */
  DO:
    if p-mode = {&add-def} then 
    do:
      run save_update .
    end.
    else 
    do:
      define variable vcodident as character no-undo.
      vcodident = GetCodeIdent(v-mark:screen-value).
      p-mark = vcodident .
    end.  
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
ON return OF b-exit IN FRAME Dialog-Frame /* Выход */
  DO:
    if p-mode = {&add-def} then 
    do:
      run save_update .
    end.
    else 
    do:
      define variable vcodident as character no-undo.
      vcodident = GetCodeIdent(v-mark:screen-value).
      p-mark = vcodident .
    end.  
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-imp Dialog-Frame
ON choose OF b-imp IN FRAME Dialog-Frame /* Импорт */
  DO:
    is-impfile = true.
    run proc-choose-file no-error.
    is-impfile = false.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark Dialog-Frame
ON ENTRY OF v-mark IN FRAME Dialog-Frame /* Марка */
  DO:
    run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
    run ActivateKeyboardLayout (input iLang, input 0).
    
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark Dialog-Frame
ON LEAVE OF v-mark IN FRAME Dialog-Frame /* Марка */
  DO:
    assign frame {&frame-name} v-mark .
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark Dialog-Frame
ON MOUSE-SELECT-DBLCLICK OF v-mark IN FRAME Dialog-Frame /* Марка */
  DO:
    if p-mode = {&add-def} then 
    do:
      run save_update .
    end.
    else 
    do:
      apply "CHOOSE" to b-exit in frame {&frame-name}.
    end.  
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark Dialog-Frame
ON return OF v-mark IN FRAME Dialog-Frame /* Марка */
  DO:
    if p-mode = {&add-def} then 
    do:
      run save_update .
    end.
    else 
    do:
      apply "CHOOSE" to b-exit in frame {&frame-name}.
    end.  
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME v-mark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-mark Dialog-Frame
ON any-printable OF v-mark IN FRAME Dialog-Frame /*              */
do:
  run proc-any-key.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
ON any-printable OF b-exit IN FRAME Dialog-Frame /*              */
do:
  run proc-any-key.
end.

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
  F-text = p-message .  
  Tree = ObjSrv:Lib:MarkingTree .     
  run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
  run ActivateKeyboardLayout (input iLang, input 0).     
  RUN enable_UI.
  apply "entry" to v-mark in FRAME {&FRAME-NAME}.
  find first t_doc no-lock where t_doc.doc-code = p-doc-code no-error .
  
  find first trn-doc exclusive-lock where trn-doc.doc-code = p-doc-code no-error .  
    if ObjSrv:Env:ParametrsOfSection:GetSectionEDO(v-cntxt-obj-type, v-cntxt-obj-code):IsManual
    then enable v-mark with frame {&frame-name}.
    else disable v-mark with frame {&frame-name}.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActivateKeyboardLayout Dialog-Frame 
PROCEDURE ActivateKeyboardLayout external "user32" :
  define input parameter P1 as long.
  define input parameter P2 as long.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispmessage Dialog-Frame 
PROCEDURE dispmessage :
  define input parameter p-str as character no-undo.
  
  if is-impfile
    then 
  do:
    put stream str-err unformatted
      p-str
      skip.
    l-error = yes .    
  end.
  else 
  do:
    message p-str view-as alert-box information title "Информация".
  end.
  
  
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
  DISPLAY v-mark F-text
    WITH FRAME Dialog-Frame.
  if p-mode = {&add-def} then 
  do:
    enable b-imp  with frame Dialog-Frame .
  end.  
  ENABLE b-exit v-mark 
    WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadKeyboardLayoutA Dialog-Frame 
PROCEDURE LoadKeyboardLayoutA external "user32" :
  define input  parameter P1 as char.
  define input  parameter P2 as long.
  define return parameter pret as long.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-choose-file Dialog-Frame 
PROCEDURE proc-choose-file :
  /*Процедура выбора файла*/
  /* Выбор файла */

  if search (v-proc-name-err) <> ? then 
  do:
    os-delete value(v-proc-name-err).
  end.
  DEFINE VARIABLE vCh AS CHARACTER NO-UNDO.
  DEFINE VARIABLE vLg AS LOGICAL   NO-UNDO.
  def    var      ii  as int.
  SYSTEM-DIALOG GET-FILE vCh
    MUST-EXIST
    TITLE "Выбор файла"
    USE-FILENAME UPDATE vLg.
  IF vCh <> "" THEN
  DO:
    output stream str-err to value(v-proc-name-err)  APPEND .
    
    input stream in-stream from value(search (vCh)).

    /*DISABLE TRIGGERS FOR LOAD OF Customer.*/
    rpt_:
    REPEAT WITH FRAME {&FRAME-NAME}: 
      import stream in-stream v-mark.
      v-mark:screen-value = v-mark.
      run save_update .
    END. 
    INPUT CLOSE. 
    output stream str-err close.
    
    message substitute ("Не все марки были загружены") view-as alert-box.
    
    if l-error then 
    do: 
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
    else 
    do:
      message substitute("Импорт акцизных марок завершен успешно.")
        view-as alert-box.
    end.  
  END.
  
  else os-delete value(v-proc-name-err). /* Если нет - удаляем лог */

   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/*                                                                     */
/*&Scoped-define SELF-NAME b-cancel                                    */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame      */
/*ON any-printable OF b-cancel IN FRAME Dialog-Frame /*              */*/
/*do:                                                                  */
/*                                                                     */
/*  run proc-any-key.                                                  */
/*                                                                     */
/*end.                                                                 */
/*                                                                     */
/*/* _UIB-CODE-BLOCK-END */                                            */
/*&ANALYZE-RESUME                                                      */

/*&Scoped-define SELF-NAME B_mark                                    */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL B_mark Dialog-Frame      */
/*ON any-printable OF B_mark IN FRAME Dialog-Frame /*              */*/
/*do:                                                                */
/*                                                                   */
/*  run proc-any-key.                                                */
/*                                                                   */
/*end.                                                               */
/*                                                                   */
/*/* _UIB-CODE-BLOCK-END */                                          */
/*&ANALYZE-RESUME                                                    */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_update Dialog-Frame 
PROCEDURE save_update :
  define variable v-error      as logical   no-undo init no.
  define variable l-error      as logical   no-undo init no.
  define variable v-error-lang as logical   no-undo init no.
          
  define variable ii           as integer   no-undo .
  define variable v-parts      as character no-undo .
  define variable gds-rec      as recid     no-undo .
  define variable v-gds-code   as integer   no-undo .
  define variable v-host-code  like sysconf.host-code no-undo.
  define variable v-tax-date   as date      no-undo.
  define variable v-vat-pc     like ub.doc-line.vat-pc no-undo.
  define variable v-slt-pc     like ub.doc-line.slt-pc no-undo.
  define variable ungroup      as logical   no-undo . 
  define variable chg-qnty     as integer   no-undo .
  define buffer buf_doc-line for ub.doc-line .
  define buffer buf_parts    for ub.parts .
  define buffer out_parts    for ub.parts .
  define buffer buf_goods    for ub.goods .
  define buffer buf_gds-prt  for ub.gds-prt .
  define buffer cpl_gds-dtl  for ub.gds-dtl .
  define variable v-GTIN as character no-undo .
  define buffer buf_marking-lines for ub.marking-lines.
   
   if v-mark:screen-value in frame {&frame-name} = ""
    then do:
      v-mark:screen-value in frame {&frame-name} = v-scan-str.
      v-scan-str = "". 
    end.
        
  assign 
    v-mark = v-mark:screen-value in frame {&frame-name} .
    
  if v-mark <> "" then 
  do:
    define variable vcodident as character no-undo.
    vcodident = GetCodeIdent(v-mark).
    find first marking where marking.mark begins vcodident
      no-lock no-error  .
    if     available marking then 
    do:


      p-mark = vcodident .
      apply "CHOOSE" to b-exit in frame {&frame-name}.

    end.  
    else 
    do:
      
      RUN ProcAlcCode IN THIS-PROCEDURE (input v-mark, output v-alc-code, output l-error, output v-error-lang) no-error.
 

      if v-error-lang then 
      do:
        run dispmessage ("Не корректно считана акцизная марка, перед считыванием переключите клавиатуру на английскую раскладку.").
        assign 
          v-mark              = ""
          v-mark:screen-value = ""
          .
      end.
      else 
      do:
        if l-error then 
        do:
          run dispmessage (substitute ("Алког. код не преобразовывается в десятичную систему из акцизной марки: &1", v-mark)).
          v-alc-code = "".
        end.
        else 
        do:
          /*Ищем товар по алкокоду*/
          if     not v-alc-code = "" 
            then 
          do:
            extGdsObj = new ExtGds (true).
            extGdsObj:OpenQueryExtGds(0, v-alc-code).
          end.
          if valid-object (extGdsObj) 
            and extGdsObj:NumBundles = 0 then 
          do: 
            run dispmessage (substitute ("Для алког. кода &1 не найден товар (не установлено соответствие)", v-alc-code)).
          end.
          else 
          do:        
            /*Проверяем есть ли марка в базе*/
            find first buf_gen-attr no-lock where buf_gen-attr.attr-code = v-mark and buf_gen-attr.table-name = {&excise-mark} no-error .
            if not available (buf_gen-attr) 
              then 
            do:
              run dispmessage ("Марка: " + v-mark + " не зарегистрирована в системе.").
            end.  
            else 
            do:
              def var v-reserv as logical no-undo init false.
              find first buf_gen-attr no-lock where
                buf_gen-attr.table-name = {&excise-mark} 
                and buf_gen-attr.attr-code = v-mark
                and not entry(8,buf_gen-attr.p-key,{&delim-key}) = {&free-code} 
                and entry(8,buf_gen-attr.p-key,{&delim-key}) <> entry(7,buf_gen-attr.p-key,{&delim-key}) no-error . 
              if available (buf_gen-attr) then 
              do:
                run dispmessage ( string ("Марка: " + v-mark + {&new-line} +
                  "уже зарезервирована в системе" + {&new-line} +
                  "документ: " + entry (8,buf_gen-attr.p-key,{&delim-key}))).
                v-reserv = true.
              end.     /*if can-find (buf_gen-attr no-lock where buf_gen-attr.attr-code = v-mark and buf_gen-attr.table-name = {&excise-mark} */         
   
              /*Проверяем, есть ли марка в свободной зоне*/
              find first buf_gen-attr no-lock where buf_gen-attr.table-name = {&excise-mark}
                and buf_gen-attr.attr-code = v-mark
                and num-entries (buf_gen-attr.p-key, {&delim-key}) >= 8  
                and buf_gen-attr.p-key begins "parts"
                and entry(8,buf_gen-attr.p-key,{&delim-key}) = {&free-code} no-error .
              if not available (buf_gen-attr) or v-reserv then 
              do:
                if not v-reserv
                  then
                  run dispmessage ( string ("Марка: " + v-mark + {&new-line} +
                    "отсутсвует в свободной зоне."
                    )).
              end. /*if not available (buf_gen-attr) then */
              else 
              do: 
                if v-alc-code = ""
                  then 
                do:
                  find first buf_parts no-lock where
                    buf_parts.obj-type = entry(2,buf_gen-attr.p-key,{&delim-key})
                    and buf_parts.obj-code = integer (entry(3,buf_gen-attr.p-key,{&delim-key}))
                    and buf_parts.artic = entry(4,buf_gen-attr.p-key,{&delim-key})
                    and buf_parts.prod-type = entry(5,buf_gen-attr.p-key,{&delim-key})
                    and buf_parts.prod-code = integer (entry(6,buf_gen-attr.p-key,{&delim-key}))
                    and buf_parts.in-code = entry(7,buf_gen-attr.p-key,{&delim-key})
                    and buf_parts.out-code = entry(8,buf_gen-attr.p-key,{&delim-key})
                    and buf_parts.part-code = entry(9,buf_gen-attr.p-key,{&delim-key})
                    .
                       
                  if available (buf_parts) and num-entries (buf_parts.alc-ref-ab-path ) = 4
                    then 
                  do:
                    assign
                      v-alc-code = entry (3, buf_parts.alc-ref-ab-path)
                      .
                  end. 
                       
                  find first buf_goods no-lock where
                    buf_goods.artic = buf_parts.artic
                    and buf_goods.prod-type = buf_parts.prod-type
                    and buf_goods.prod-code = buf_parts.prod-code.
                  if available (buf_goods)
                    then 
                  do:
                    v-gds-code = buf_goods.gds-code.
                  end.
                end.
                else 
                do:
                  /*резервируем в партию*/

                  v-gds-code = extGdsObj:GetExtGdsValue(1):GdsCode.
                end.
                find first bf_trn-doc no-lock where bf_trn-doc.doc-code = entry (7, buf_gen-attr.p-key, {&delim-key}) no-error.
                if not available (bf_trn-doc) and not (t_doc.obj-type = bf_trn-doc.obj-type and t_doc.obj-code = bf_trn-doc.obj-code)
                  then 
                do:
                  run dispmessage (substitute ("Марка: " + v-mark + " не зарегистрирована в системе по поставщику &1.", (t_doc.obj-type + string (t_doc.obj-code)))).
                  return.
                end.
              end.
              find first buf_goods no-lock where buf_goods.gds-code = v-gds-code no-error .
              if not available (buf_goods) then 
              do:
                run dispmessage ("Нет товара с кодом: " + string(v-gds-code)).
              end.
              else 
              do:  
                gds-rec = recid(buf_goods) .
                        
                find first buf_doc-line exclusive-lock where buf_doc-line.doc-code = p-doc-code
                  and buf_doc-line.artic = buf_goods.artic and buf_doc-line.prod-code = buf_goods.prod-code
                  and buf_doc-line.prod-type = buf_goods.prod-type no-error .
                if not available (buf_doc-line) then 
                do:
                  run str/out-add.p (parparentproc,
                    recid(t_doc),
                    ?,
                    ?,
                    recid(buf_goods),
                    {&add-def},
                    'scan-marks' + {&delim-key} + v-mark) no-error.
          
                /*          /*Добавляем товар в накладную*/                                                                                                                                                               */

                end.
                else 
                do:
                  
                  /*Увеличеваем кол-во товара в накладной*/
                  find first cpl_gds-dtl exclusive-lock where cpl_gds-dtl.doc-code = buf_doc-line.doc-code
                    and cpl_gds-dtl.artic = buf_doc-line.artic and buf_doc-line.prod-code = cpl_gds-dtl.prod-code
                    and buf_doc-line.prod-type = cpl_gds-dtl.prod-type no-error.
                         
                  run str/out-add.p
                    ( input parparentproc
                    ,input recid(t_doc)
                    ,input recid(buf_doc-line)
                    ,input recid(cpl_gds-dtl)
                    ,input recid (buf_goods)
                    ,input {&update}
                    ,input 'scan-marks' + {&delim-key} + v-mark)
                    no-error.
                  
                end. 
              end.
            end. /*if available (buf_goods) then do*/

                    
          end.  
        end.
        apply "entry" to v-mark in FRAME {&FRAME-NAME}.
        assign 
          v-mark              = ""
          v-mark:screen-value = ""            
          .            
      end.
    end.
  end.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-any-key Dialog-Frame 
PROCEDURE proc-any-key :
  v-scan-str = v-scan-str + last-event:label.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME