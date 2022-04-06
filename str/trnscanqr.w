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

Сканирование 2D кода. Автоматическое заполнение накладной.

Автор: Морозов Александр Сергеевич
Дата создания: 08/08/2021
Author: Alexandr Morozov
Creation date: 08/08/2021

*/
&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS Procedure

using ibs.th.str.ptrl.autotrn.*.
using ibs.th.str.*.

define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Сканирование 2D кода. Автоматическое заполнение накладной.". 
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/showinf.i  }

          /* Parameters Definitions ---                                           */

define input  parameter parparentproc         as handle              no-undo .
define input  parameter p-doc-code            as character           no-undo .
define input  parameter p-mode                as character           no-undo .
define input  parameter p-handle              as handle              no-undo .

define variable iLang           as integer   no-undo.

define buffer t_doc        for ub.trn-doc .
define buffer bf_doc-line  for ub.doc-line.
define variable v-timedelay  as integer   no-undo.
define variable v-scan-str as character no-undo.

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
&Scoped-Define ENABLED-OBJECTS b-exit b-cancel b-help b-imp v-sts 
&Scoped-Define DISPLAYED-OBJECTS v-sts 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
define button b-cancel 
     label "&Отмена" 
     size 10 by 1
     bgcolor 8 .

define button b-exit auto-go 
     label "&Ввод" 
     size 10 by 1
     bgcolor 8 .

define variable v-sts as character format "X(256)":U init "ожидание сканирования" 
     label "Статус" 
     view-as fill-in 
     size 76 by 1 no-undo.


/* ************************  Frame Definitions  *********************** */

define frame Dialog-Frame
     b-exit at row 1 col 1
     b-cancel at row 1 col 11.5
     v-sts at row 3 col 7.5 colon-aligned
     space(2.25) skip(0.44)
    with view-as dialog-box keep-tab-order 
         side-labels no-underline three-d  scrollable 
         title "Сканирование 2D кода. Автоматическое заполнение накладной."
         default-button b-exit cancel-button b-cancel.


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
assign 
       frame Dialog-Frame:SCROLLABLE       = false
       frame Dialog-Frame:HIDDEN           = true.

/* SETTINGS FOR FILL-IN f-msg IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-L                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
on window-close of frame Dialog-Frame
do:

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*&Scoped-define SELF-NAME b-exit                              */
/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame*/
/*on choose of b-exit in frame Dialog-Frame /* Ввод */         */
/*do:                                                          */
/*                                                             */
/*end.                                                         */
/*                                                             */
/*/* _UIB-CODE-BLOCK-END */                                    */
/*&ANALYZE-RESUME                                              */

&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-exit Dialog-Frame
on return of b-exit in frame Dialog-Frame /* Ввод */
do:
    run save_update .
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME v-sts
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-sts Dialog-Frame
on entry of v-sts in frame Dialog-Frame
do:
    run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
    run ActivateKeyboardLayout (input iLang, input 0).
    
  end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME UUID_VSD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL UUID_VSD Dialog-Frame
on any-printable of v-sts in frame Dialog-Frame
do:

  run proc-any-key.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL UUID_VSD Dialog-Frame
on any-printable of b-exit in frame Dialog-Frame
do:

  run proc-any-key.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME b-cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b-cancel Dialog-Frame
on any-printable of b-cancel in frame Dialog-Frame
do:

  run proc-any-key.

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-sts Dialog-Frame
on leave of v-sts in frame Dialog-Frame /* Марка */
do:
    assign frame {&frame-name} v-sts .
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-sts Dialog-Frame
on mouse-select-dblclick of v-sts in frame Dialog-Frame /* Марка */
do:
    run save_update .

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL end-error Dialog-Frame
on end-error of frame Dialog-Frame
do:

  return no-apply.

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
do on error undo MAIN-BLOCK, leave MAIN-BLOCK
  :
  run LoadKeyboardLayoutA (input v-scan-str, input 0, output iLang).
  run ActivateKeyboardLayout (input iLang, input 0).     
  run enable_UI.
  apply "entry" to v-sts in frame {&FRAME-NAME}.
  find first t_doc no-lock where t_doc.doc-code = p-doc-code no-error .  
  
  hide b-cancel in frame {&frame-name}.
  
  disable v-sts with frame {&frame-name}.
  
  wait-for go of frame {&FRAME-NAME}.
end.
run disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActivateKeyboardLayout Dialog-Frame 
procedure ActivateKeyboardLayout external 'user32' :
  define input parameter P1 as long.
  define input parameter P2 as long.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/*&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fillTrnDoc Dialog-Frame*/
/*procedure fillTrnDoc :                                             */
/*  define variable v-error      as logical   no-undo init no.       */
/*  define variable l-error      as logical   no-undo init no.       */
/*  define variable v-error-lang as logical   no-undo init no.       */
/*  define variable ii           as integer   no-undo .              */
/*                                                                   */
/*  define variable vcodident as character no-undo.                  */
/*                                                                   */
/*    //run go-line in p-inv-handle (?).                             */
/*    f-msg:screen-value in frame {&FRAME-NAME} = v-sts .            */
/*    f-msg:fgcolor in frame {&FRAME-NAME} = 2.                      */
/*                                                                   */
/*end.                                                               */
/*                                                                   */
/*/* _UIB-CODE-BLOCK-END */                                          */
/*&ANALYZE-RESUME                                                    */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispmessage Dialog-Frame 
procedure dispmessage :
define input parameter p-str as character no-undo.
  
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
  display v-sts b-exit 
      with frame Dialog-Frame.
  enable b-exit 
      with frame Dialog-Frame.
  view frame Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadKeyboardLayoutA Dialog-Frame 
procedure LoadKeyboardLayoutA external 'user32':
  define input  parameter P1 as char.
  define input  parameter P2 as long.
  define return parameter pret as long.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save_update Dialog-Frame 
procedure save_update :
  
  def var v-xmlfile as char no-undo.
  def var v-ok as logical no-undo.
  def var xmlhndlerObj as class xmlhndler no-undo.
  def var v-tmp-int as int no-undo.
  def var v-gdsrec-list as char no-undo.
  def var infoSecsObj as class InfoSectionsTotal no-undo.
  run parse2DCodeToXML (input v-scan-str, output v-xmlfile) no-error.
  if error-status:error
  then do:
    undo, return.
  end.
  infoSecsObj = new ibs.th.str.InfoSectionsTotal().
    
  xmlhndlerObj = new xmlhndler().
  
  xmlhndlerObj:FillDataset(input search (v-xmlfile)) no-error.
  if error-status:error
    then message xmlhndlerObj:ErrMsg view-as alert-box.

  v-ok = xmlhndlerObj:GetFirst("doc") no-error.
  if not v-ok
    then message xmlhndlerObj:ErrMsg view-as alert-box.  

  v-tmp-int =  (xmlhndlerObj:vbf:buffer-field("contr-cd"):buffer-value) no-error.
  if error-status:error
    then message error-status:get-message (1) view-as alert-box.
    else do:
      run set-cli-cust in p-handle (input "орг", input v-tmp-int) no-error.
      if error-status:error
        then message "Ошибка установки поставщика." return-value view-as alert-box.      
    end.
  
  v-ok = xmlhndlerObj:GetFirst("scs") no-error.
  if not v-ok
    then message xmlhndlerObj:ErrMsg view-as alert-box.    
  rep_:
  repeat:
    v-tmp-int = xmlhndlerObj:vbf:buffer-field("gd-cd"):buffer-value no-error.
    if error-status:error
    then do:
      message error-status:get-message (1) view-as alert-box.
      if not xmlhndlerObj:GetNext()
        then leave rep_.
      next rep_.
    end.
    else do:
      find first ub.goods where ub.goods.gds-code = v-tmp-int no-lock no-error.
      if not available (ub.goods)
      then do:
        message "Не найден товар с кодом - " v-tmp-int view-as alert-box title "Ошибка".
        if not xmlhndlerObj:GetNext()
          then leave rep_.
        next rep_.
      end.
      if lookup (v-gdsrec-list, string (recid (ub.goods))) = 0
      then do:
        v-gdsrec-list = string (v-gdsrec-list) + "," + string (recid (ub.goods)).
        infoSecsObj:Initialization(t_doc.doc-code, ub.goods.gds-code).
        infoSecsObj:GetInfoSectionProp().
      end.
      else infoSecsObj:NewSection().
      infoSecsObj:InfoSectionCurr:SectionName = xmlhndlerObj:vbf:buffer-field("sc-num"):buffer-value no-error.
      infoSecsObj:InfoSectionCurr:DocQnty = xmlhndlerObj:vbf:buffer-field("vol"):buffer-value no-error.
      infoSecsObj:InfoSectionCurr:CliQnty = xmlhndlerObj:vbf:buffer-field("mass"):buffer-value no-error.
      infoSecsObj:InfoSectionCurr:DocDensity = infoSecsObj:InfoSectionCurr:CliQnty / infoSecsObj:InfoSectionCurr:DocQnty.
      infoSecsObj:InfoSectionCurr:TTNTemp = xmlhndlerObj:vbf:buffer-field("temp"):buffer-value no-error.
      infoSecsObj:InfoSectionCurr:Shape = "Без горловины".
      infoSecsObj:SaveDBNoCheck().
      if not xmlhndlerObj:GetNext()
        then leave rep_.
    end.
  end.
  v-gdsrec-list = left-trim (v-gdsrec-list, ",").
  run cycle-add-cust in p-handle (input v-gdsrec-list) no-error.
  if error-status:error
    then message "Ошибка добавление товара." return-value view-as alert-box.
  v-sts:screen-value in frame {&frame-name}  = "считано".
  apply "choose" to b-exit in frame {&frame-name}.
  

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parse2DCodeToXML Dialog-Frame 
procedure parse2DCodeToXML :
  
  define input parameter p-2dcode as char no-undo.
  define output parameter p-xmlfile as char no-undo.
  
  def var v-json-str as character no-undo.
  def var v-ix as integer no-undo.
  def var v-crc as char no-undo.
  def var cmd as char no-undo.
  def var v-ok as logical no-undo.
  
  v-json-str = p-2dcode.
  v-scan-str = "".
  v-ix = index (v-json-str, ',"CRC":"').
  v-json-str = substring (v-json-str, 8, v-ix - 8).
/*  run checkcrc (input v-json-str, input v-crc, output v-ok).                     */
/*  if not v-ok                                                                    */
/*  then do:                                                                       */
/*    v-sts:screen-value in frame {&frame-name} = "ошибка контрольной суммы CRC32".*/
/*    return error.                                                                */
/*  end.                                                                           */
  
  output to "qr2d.json" convert target 'UTF-8'.
  put unformatted v-json-str.
  output close.
  
  cmd = substitute ('&1 -file=&2 >&3',
                     search("exe/json2xml.exe"),
                     search("qr2d.json"),
                     "qr2d.xml"
                     ) .
  os-command silent value (cmd). 
  
  file-info:file-name = search("qr2d.xml") .
  if file-info:file-size = 0
  then do :
    v-ok = false .
    v-sts = "oшибка при конвертации json в XML. Файл " + search("qr2d.xml") + " пустой (размер 0 байт)." .
    return error.
  end .

  run  validatexml (input search("qr2d.xml"), input v-crc, output v-ok).
  if not v-ok
  then do:
    v-sts:screen-value in frame {&frame-name} = "данные не прошли валидацию".
    return error.
  end.
  p-xmlfile = search("qr2d.xml"). 

end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatexml Dialog-Frame 
procedure validatexml :

  define input parameter p-xml-file as char no-undo.
  define input parameter p-xsd-file as char no-undo.
  define output parameter p-ok as log no-undo.
  
  p-ok = true.
  
  /*validate xml xsd*/

end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE crc32 Dialog-Frame
procedure crc32 external "crc32.dll" CDECL :
    define input    parameter p-crc    as long.
    define input    parameter p-array  as memptr.
    define input    parameter p-len    as long.
    define return   parameter p-crc32  as unsigned-long.
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validate2dcode Dialog-Frame 
procedure checkcrc:
  
  define input parameter p-json-str as char no-undo.
  define input parameter p-crc32 as char no-undo.
  define output parameter p-ok as logical no-undo.
  define var v-crc32 as int64 no-undo.
  
  define variable v-message as memptr no-undo.
  define variable v-mem as memptr no-undo.
  define variable v-len as int no-undo.
  set-size(v-message) = v-len .
  set-pointer-value(v-message) = get-pointer-value(v-mem).
  run crc32 ( input 0 , input v-message , input v-len , output v-crc32).
  set-size(v-message) = 0 .
  
  p-ok = true.
  
end.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE proc-any-key Dialog-Frame 
procedure proc-any-key :
  if v-scan-str = ""
    then v-timedelay = etime.
    else
      if etime - v-timedelay > 700
        then v-scan-str = "".
  v-scan-str = v-scan-str + last-event:label.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME