/*------------------------------------------------------------------------
$Revision: $
$Author: $
$Date: $
$Workfile$
$Archive$

Отчет Платежи ОСС

Автор: Кривошеин Александр Николаевич
Дата создания: 23/11/14
Author: Krivoshein Alexander
Creation date: 23/11/14

  ----------------------------------------------------------------------*/

def var vss-revision    as character no-undo init "$Revision$":U .
def var vss-author      as character no-undo init "$Author$":U .
def var vss-date        as character no-undo init "$Date$":U .
def var vss-workfile    as character no-undo init "$Workfile$":U .
def var vss-archive     as character no-undo init "$Archive$":U .
def var vss-description as character no-undo init "Печать Платежей ОСС".

{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i  } /* Внутри вложен { cmp/obj-list.i {1}}, в котором формируется таблица obj-list. */
{ str/trdcalib.i }
{ gbl/attr-lib.i }
{ ref/gds-attr.i }
{ trg/factord.i  }
{ gbl/paramls.i  }
{ rep/fmtcli.i   }
{ cmp/r-pril.i new }
{ ref/extclass.i }
/*===================================================================================================================*/

define input parameter parParentProc as handle no-undo.
DEFINE INPUT PARAMETER v-operator AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER v-classified AS INTEGER NO-UNDO.

&glob check-no-error no-error. if error-status:ERROR then return error subst("&1 &2 &3", return-value, ERROR-STATUS:get-message(1), ERROR-STATUS:get-message(2)).
&glob check-error if error-status:ERROR then return error subst("&1 &2 &3", return-value, ERROR-STATUS:get-message(1), ERROR-STATUS:get-message(2)).

define stream Out-Stream.
define stream OutStr-html.

DEFINE BUFFER buf_shift-obj_from FOR ub.shift-obj.
DEFINE BUFFER buf_shift-obj_till FOR ub.shift-obj.
DEFINE BUFFER buf_shift-obj      FOR ub.shift-obj.
DEFINE BUFFER buf_chk-doc        FOR ub.chk-doc.
DEFINE BUFFER buf_goods-attr     FOR ub.goods-attr.
DEFINE BUFFER buf_chk-gds-pay    FOR ub.chk-gds-pay.
DEFINE BUFFER buf_bar-code       FOR ub.bar-code.
DEFINE BUFFER buf_chk-gds-attr   FOR ub.chk-gds-attr.
DEFINE BUFFER buf_ext-classif    FOR ub.ext-classif.

DEFINE TEMP-TABLE tt-ref NO-UNDO
    FIELD obj-name LIKE obj-list.obj-name
    FIELD oss-name LIKE ub.ext-classif.charkey_one
    FIELD chk-num AS INTEGER
    FIELD chk-sum AS DECIMAL
    .

DEFINE VARIABLE v-attr-value AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-attr-type AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-oss-name AS CHARACTER NO-UNDO.

DEFINE VARIABLE g#report-num AS INTEGER NO-UNDO.
DEFINE VARIABLE v-file-name-rep-htm AS CHARACTER NO-UNDO.
DEFINE VARIABLE v-fill-path-RepView AS CHARACTER NO-UNDO.

/* **********************  Internal Procedures  *********************** */

PROCEDURE proc-create-HTML:
/*************************/

    define parameter buffer buf_tt for tt-ref.

    output stream OutStr-html to value(v-file-name-rep-htm) convert target 'UTF-8' /*no-convert*/.
        put stream OutStr-html unformatted

        substitute(
            '<!doctype html>
            <html>
              <head>
              <meta charset="UTF-8">
                  <!-- Стили документа -->
              <style>
                   table ~{
                       border-collapse: collapse; 
                   ~}
                   tbody td, th ~{
                       border: 1px solid black;
                       border-collapse: collapse;
                 height: 14px;
                   ~}
          
              </style>
              </head>
                <body>
                  <table orientation="landscape" name="лист1" fit_to_page="true">
                    <thead>
                        <tr class="set_columns">
                            <td style="width: 150px;"></td>
                            <td style="width: 150px;"></td>
                            <td style="width: 200px;"></td>
                            <td style="width: 100px;"></td>
                        </tr>
                        <tr>
                        <td colspan="4">Отчет по переводу средств ОСС за период с &1 по &2</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th style="text-align: center;">Объект</th>
                            <th style="text-align: center;">Оператор</th>
                            <th style="text-align: center;">Количество чеков</th>
                            <th style="text-align: center;">Сумма</th>
                        </tr>'
            ,
            string( x-Date-Start),
            string( x-Date-End)
            
        ).
        .
    output stream OutStr-html close.

    /* Заполнение линий таблицы "*/

    IF v-classified = 1 THEN DO:
        FOR EACH buf_tt NO-LOCK BY buf_tt.oss-name BY buf_tt.obj-name:
            OUTPUT STREAM OutStr-html TO VALUE(v-file-name-rep-htm) APPEND CONVERT TARGET 'UTF-8'.
            PUT STREAM OutStr-html UNFORMATTED
            SUBSTITUTE(
                    '<tr>
                        <td >&1</td>
                        <td >&2</td>
                        <td >&3</td>
                        <td >&4</td>
                     </tr>'
                ,
                buf_tt.obj-name,
                buf_tt.oss-name,
                buf_tt.chk-num,
                buf_tt.chk-sum
            ).
            OUTPUT STREAM OutStr-html CLOSE.
        END.
    END.
    ELSE IF v-classified = 2 THEN DO:
        FOR EACH buf_tt NO-LOCK BY buf_tt.obj-name BY buf_tt.oss-name:
            OUTPUT STREAM OutStr-html TO VALUE(v-file-name-rep-htm) APPEND CONVERT TARGET 'UTF-8'.
            PUT STREAM OutStr-html UNFORMATTED
            SUBSTITUTE(
                    '<tr>
                        <td >&1</td>
                        <td >&2</td>
                        <td >&3</td>
                        <td >&4</td>
                     </tr>'
                ,
                buf_tt.obj-name,
                buf_tt.oss-name,
                buf_tt.chk-num,
                buf_tt.chk-sum
            ).
            OUTPUT STREAM OutStr-html CLOSE.
        END.
    END.

    /* Заполнение подвала таблицы */
    OUTPUT STREAM OutStr-html TO VALUE(v-file-name-rep-htm) APPEND CONVERT TARGET 'UTF-8' /*no-convert*/.
        PUT STREAM OutStr-html UNFORMATTED
                    '</table>
            </body>
        </html>'
        .
        /* '" */
    OUTPUT STREAM OutStr-html CLOSE.

END PROCEDURE.

DO: /* S */

    DO: /* Нач_Иниц */
        /* Начальная инициализация таблицы */

        FOR EACH tt-ref EXCLUSIVE-LOCK:
            DELETE tt-ref.
        END.
    
        RUN get-report-num IN parParentProc (
            OUTPUT g#report-num
        ).

        v-file-name-rep-htm = SESSION:TEMP-DIRECTORY + {&DF_Name} + STRING(g#report-num) + ".html".

        OUTPUT TO VALUE(v-file-name-rep-htm).
        OUTPUT CLOSE.

        IF SEARCH("exe\ReportViewer\reportviewer.exe") <> ? THEN
            DO:
                v-fill-path-RepView = SEARCH("exe\ReportViewer\reportviewer.exe").
            END.
        ELSE
            DO:
                MESSAGE "Не найдена программа просмотра отчёта!" VIEW-AS ALERT-BOX ERROR.
            END.


    END. /* Нач_Иниц */
    DO: /* Тело отчёта */

        FOR EACH obj-list NO-LOCK:

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

		    FOR EACH buf_goods-attr WHERE buf_goods-attr.attr-value = 'oss-pay' 
                                      AND buf_goods-attr.attr-code = {&attr-office-type} No-LOCK,
		        EACH buf_bar-code WHERE buf_bar-code.gds-code = buf_goods-attr.gds-code NO-LOCK:
            
            	    FOR EACH buf_chk-gds-pay WHERE buf_chk-gds-pay.obj-type = obj-list.obj-type
                        		               AND buf_chk-gds-pay.obj-code = obj-list.obj-code
                                               AND ((x-TOG-Shift = YES 
                                                   AND buf_chk-gds-pay.shift-num >= x-Shift-Start
                                                   AND buf_chk-gds-pay.shift-num >= x-Shift-End
                                                   AND buf_chk-gds-pay.shift-date >= x-Date-Start
                                                   AND buf_chk-gds-pay.shift-date <= x-Date-End) 
                                                   OR (x-TOG-Shift = NO 
                                                   AND buf_chk-gds-pay.chk-date >= x-Date-Start
                                                   AND buf_chk-gds-pay.chk-date <= x-Date-End))
                                               AND buf_chk-gds-pay.b-code = buf_bar-code.b-code NO-LOCK:
                        
                        /*определяем оператора*/
                        FIND FIRST buf_chk-gds-attr WHERE buf_chk-gds-attr.doc-code = buf_chk-gds-pay.doc-code
                                                      AND buf_chk-gds-attr.line-num = buf_chk-gds-pay.line-num
                                                      AND buf_chk-gds-attr.attr-code = 'oss-code' NO-LOCK NO-ERROR.

                        IF AVAILABLE buf_chk-gds-attr THEN DO:
                            v-oss-name = string(int(buf_chk-gds-attr.attr-value)) no-error.
                            FIND FIRST ext-classif WHERE ext-classif.classif-subject = {&extclass_oss-ref}
                                                     AND ext-classif.Key#_One = int(v-oss-name) NO-LOCK NO-ERROR.
                            IF AVAILABLE ext-classif THEN DO:
                                v-oss-name = ENTRY(1, ext-classif.charkey_two,{&delim-par}).
                            END.
                            ELSE DO:
                                v-oss-name = 'Нет информации'.
                            END.
                        END.
                        ELSE DO:
                            ASSIGN
                                v-oss-name = 'Не определено'.
                        END.
                        /*учитываем только выбранных операторов*/
                        IF v-operator = '0' OR (LOOKUP(STRING(v-oss-name), v-operator) > 0) THEN DO:
                            IF v-classified = 2 THEN DO: /*итоговая строка по объектам*/
                                FIND FIRST tt-ref WHERE tt-ref.obj-name = obj-list.obj-name 
                                                    AND tt-ref.oss-name = '-' EXCLUSIVE-LOCK NO-ERROR.
				                IF NOT AVAILABLE tt-ref THEN DO:
					                CREATE tt-ref.
					                ASSIGN 
						                tt-ref.obj-name = obj-list.obj-name
                                        tt-ref.oss-name = '-'
                                        tt-ref.chk-num  = 0
                                        tt-ref.chk-sum  = 0
                                        .
				                END.
                                ASSIGN
                                    tt-ref.chk-num = tt-ref.chk-num + 1
                                    tt-ref.chk-sum = tt-ref.chk-sum + buf_chk-gds-pay.tot-r-b.
                            END.
                            ELSE IF v-classified = 1 THEN DO: /*итоговая строка по операторам*/
                                FIND FIRST tt-ref WHERE tt-ref.obj-name = '-'
                                                    AND tt-ref.oss-name = v-oss-name EXCLUSIVE-LOCK NO-ERROR.
				                IF NOT AVAILABLE tt-ref THEN DO:
					                CREATE tt-ref.
					                ASSIGN 
						                tt-ref.obj-name = '-'
                                        tt-ref.oss-name = v-oss-name
                                        tt-ref.chk-num  = 0
                                        tt-ref.chk-sum  = 0
                                        .
				                END.
                                ASSIGN
                                    tt-ref.chk-num = tt-ref.chk-num + 1
                                    tt-ref.chk-sum = tt-ref.chk-sum + buf_chk-gds-pay.tot-r-b.
                            END.
                            /*считаем по оператору и объекту*/
		    		        FIND FIRST tt-ref WHERE tt-ref.obj-name = obj-list.obj-name
                                                AND tt-ref.oss-name = v-oss-name EXCLUSIVE-LOCK NO-ERROR.
				            IF NOT AVAILABLE tt-ref THEN DO:
    					        CREATE tt-ref.
	    				        ASSIGN 
		    				        tt-ref.obj-name = obj-list.obj-name
                                    tt-ref.oss-name = v-oss-name
                                    tt-ref.chk-num  = 0
                                    tt-ref.chk-sum  = 0
                                    .
    				        END.
                            ASSIGN
                                tt-ref.chk-num = tt-ref.chk-num + 1
                                tt-ref.chk-sum = tt-ref.chk-sum + buf_chk-gds-pay.tot-r-b.
                        END. /*IF AVAILABLE buf_chk-gds-attr */ 
                    END. /*FOR EACH buf_chk-doc*/
                END. /*FOR EACH buf_goods-attr*/
           /* END. /*FOR EACH buf_shift-obj NO-LOCK*/*/
        END. /*FOR EACH obj-list NO-LOCK:*/
    END. /* Тело отчёта */

    FIND FIRST tt-ref NO-LOCK NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE "Для установленных параметров отчета" SKIP "- данные отсутствуют!" VIEW-AS ALERT-BOX WARNING.
    END.
    ELSE DO:
        RUN proc-create-HTML (BUFFER tt-ref).

        IF SEARCH(v-file-name-rep-htm) = ? THEN DO:
            MESSAGE "Не найден файл отчёта: " v-file-name-rep-htm VIEW-AS ALERT-BOX ERROR.
        END.
        ELSE DO:
            v-file-name-rep-htm = SEARCH(v-file-name-rep-htm).
        END.

        OS-COMMAND NO-WAIT VALUE(v-fill-path-RepView + " " + SEARCH(v-file-name-rep-htm)).

    END.

END.
