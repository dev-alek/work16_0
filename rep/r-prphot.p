/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Прайс-лист с фото товаров

Автор: Чернова Светлана Александровна
Дата создания: 05/05/10
Author: Svetlana Chernova
Creation date: 05/05/10

*/
define input parameter p-mainmenu-handle   as handle           no-undo.
define input  parameter p-sort-type   as character no-undo .
define input  parameter p-name        as character no-undo .
define input  parameter p-dostavka    as character no-undo .
define input  parameter p-telefon-1   as character no-undo .
define input  parameter p-telefon-2   as character no-undo .
define input  parameter p-info        as character no-undo .
define input  parameter p-orderinfo  as character no-undo .
define input  parameter p-action     as character no-undo .
define input  parameter p-skidki     as character no-undo .
define input  parameter p-skidki-2   as character no-undo .
define input  parameter p-skidki-3   as character no-undo .
define input  parameter p-skidki-4   as character no-undo .
define input  parameter p-skidki-5   as character no-undo .
define input  parameter p-skidki-6   as character no-undo .
define input  parameter p-skidki-7   as character no-undo .
define input  parameter p-skidki-8   as character no-undo .

define input  parameter p-colsize    as integer   no-undo .
define input  parameter p-hot        as character no-undo .

/*

message
p-mainmenu-handle skip
'p-sort-type '  p-sort-type skip
'p-name      '  p-name      skip
'p-dostavka  '  p-dostavka  skip
'p-telefon-1 '  p-telefon-1 skip
'p-telefon-2 '  p-telefon-2 skip
'p-info      '  p-info      skip
'p-orderinfo ' p-orderinfo  skip
'p-action    ' p-action     skip
'p-skidki    ' p-skidki     skip
'p-colsize   ' p-colsize    skip
'p-hot       ' p-hot        skip
.

*/
define variable vss-revision    as character no-undo init "$Revision$":U .
define variable vss-author      as character no-undo init "$Author$":U .
define variable vss-date        as character no-undo init "$Date$":U .
define variable vss-workfile    as character no-undo init "$Workfile$":U .
define variable vss-archive     as character no-undo init "$Archive$":U .
define variable vss-description as character no-undo init "Прайс-лист с фото товаров".
{ cmp/vssrevis.i }
{ cmp/str-glbl.i }
{ cmp/r-page1.i  }
{ rep/rep-bt.i   }
{ cmp/r-pril.i   }
{ rep/r-sym.i    }
{ rep/r-gl.i     }
{ gbl/cur-time.i }
{ gbl/paramls.i  }
{ rep/lkp-font.i }
{ cmp/ini-lib.i  }
{ str/bc-gnrt.i new bc } /* используется в процедуре create-bar-code */

define temp-table temp-list no-undo
field f-sort   as character
field gds-code as integer
field b-code   as integer
field big-code as character
field artic    as character
field gds-name as character
field price-sale as decimal
field min-part as character
field f-name     as character
index pi
 f-sort

index pi2
 gds-code
.

define stream outstream.

define variable HexStr as character no-undo .
define variable Path-To-Dir-Pictures as character no-undo .
define variable v-dircode1 as character no-undo .
define variable v-dircode2 as character no-undo .
define variable v-b-code as integer   no-undo .
define variable v-ean as character no-undo .
define variable v-proc-name-err as character no-undo initial 'prphot.err'. /* Имя лога */
define variable l-error as logical no-undo. /* Есть ли ошибки */

define variable g#quest-print   as logical      no-undo.
define variable g#log           as logical      no-undo.

run get-report-num in p-mainmenu-handle (
    output g#report-num
).
run get-quest-print in p-mainmenu-handle (
    output g#quest-print
).

{ str/writelog.i def v-proc-name-err } /* Запуск лога для ошибок */
{ rep/f-fdec.i }
{ gbl/getcntxt.i get " " p-mainmenu-handle }
  RUN verify-ini-entry("pict_path":U,
                        "REP-SETS":U,
                        "не определен путь к подкаталогу для хранения фото товара" + {&new-line} +
                        "отсутствует параметр pict_path, секция [REP-SETS] ini-файла",
                        no,
                        output Path-To-Dir-Pictures) no-error.
  if error-status:error
  or Path-To-Dir-Pictures = ?
  then do:
    return error .
  end.

  v-dircode1 = search( 'exe/own-logo.jpg' ) .
  v-dircode2 = search( 'exe/own-tel.jpg' ) .
  
  if search(v-proc-name-err) <> ? then do:
    os-delete value(v-proc-name-err).
  end.
  
  l-error = no.
  
  for each obj-list :
    for each gds-list :
       find first ub.gds-obj no-lock where
                  ub.gds-obj.gds-code = gds-list.gds-code and
                  ub.gds-obj.obj-type = obj-list.obj-type and
                  ub.gds-obj.obj-code = obj-list.obj-code no-error .
        if not available ub.gds-obj  then 
          do:
            l-error = yes.
            run writelog in this-procedure (v-proc-name-err, 1, substitute("У товара &1 &2 нет продажной цены",gds-list.artic,gds-list.gds-name)).
            next.
          end.
        if ub.gds-obj.price-sale = 0  then 
          do:
            l-error = yes.
            run writelog in this-procedure (v-proc-name-err, 1, substitute("У товара &1 &2 нулевая цена продажи",gds-list.artic,gds-list.gds-name)).
            next.
          end.
        find first temp-list where
                   temp-list.gds-code = ub.gds-obj.gds-code no-error .
        if not available temp-list then do:

    run gbl/newbase.p
      (input ub.gds-obj.gds-code
      ,input 16
      ,output HexStr
      ).
            create temp-list.

            case p-sort-type :
              when "sort-name" then do:
                temp-list.f-sort          = gds-list.gds-name .
              end.
              when "sort-code" then do:
                temp-list.f-sort          = string(ub.gds-obj.gds-code, "9999999999999999").
              end.
              when "sort-artic" then do:
                temp-list.f-sort          = ub.gds-obj.artic.
              end.
            end case.
            assign
              temp-list.gds-code        = ub.gds-obj.gds-code
              temp-list.artic           = ub.gds-obj.artic
              temp-list.gds-name        = gds-list.gds-name
              temp-list.price-sale      = ub.gds-obj.price-sale
              temp-list.min-part        = if gds-list.qnty-cart = 0 then  ""  else string(gds-list.qnty-cart)
              temp-list.f-name          = substitute("&1gds\&2.jpg" ,Path-To-Dir-Pictures, HexStr )
              .

              { gbl/gdsbcode.i
               ub.gds-obj.gds-code
               ?
               v-b-code
               }
               temp-list.b-code = v-b-code.

                run gen-bc in this-procedure
                  ( input v-b-code
                    ,output v-ean
                  ).
                temp-list.big-code = v-ean.


              /* Проверить есть ли такой файл на диске */

                assign
                  file-info:file-name = temp-list.f-name
                .
                if file-info:file-type <> ? then do:
                  /* message file-info:full-pathname . */
                end.
                else do:
                   temp-list.f-name  = "" .
                end.

          end.
    end.
  end.
  
  if l-error = yes then /* Если есть ошибки - говорим. */
    message "Не все товары попали в прайс-лист." skip
    substitute("Подробности в файле &1",v-proc-name-err) view-as alert-box warning.
  else os-delete value(v-proc-name-err). /* Если нет - удаляем лог */

   make-excel = true .
   os-delete value( string( session:temp-directory ) +
                              {&df_name} + string( g#report-num ) + ".txt":u ) .
   output stream forexcel to value( string( session:temp-directory ) +
                              {&df_name} + string( g#report-num ) + ".txt":u ) .

reportheader =  "".
reportname   =  "".
str1 =  "".
str2 =  "".
str3 =  "".
str4 =  "".
run rep/extitle.p (1) no-error .
if error-status :error then message
  vss-workfile vss-revision vss-description skip
  error-status :get-message(1) skip
  return-value skip
  ""
  view-as alert-box error
.
Sheetf.Bas-Params =
      p-name            + {&delim-par} +
      p-dostavka        + {&delim-par} +
      p-telefon-1       + {&delim-par} +
      p-telefon-2       + {&delim-par} +
      p-info            + {&delim-par} +
      p-orderinfo       + {&delim-par} +
      p-action          + {&delim-par} +
      p-skidki          + {&delim-par} +
      p-skidki-2        + {&delim-par} +
      p-skidki-3        + {&delim-par} +
      p-skidki-4        + {&delim-par} +
      p-skidki-5        + {&delim-par} +
      p-skidki-6        + {&delim-par} +
      p-skidki-7        + {&delim-par} +
      p-skidki-8        + {&delim-par} +
      string(p-colsize) + {&delim-par} +
      p-hot             + {&delim-par} +
      v-dircode1        + {&delim-par} +
      v-dircode2

      .
        for each  temp-list break by temp-list.f-sort :
          {&putexcel}
            temp-list.big-code  {&tabulation}
            temp-list.b-code    {&tabulation}
            temp-list.gds-name  {&tabulation}
            temp-list.price-sal {&tabulation}
            temp-list.min-part  {&tabulation}
            temp-list.f-name    {&tabulation}
            {&new-line}
            .
        end.



if session:set-wait-state("") then.
 {&closeexcel}
 run rep/runexcel.p (string( session:temp-directory) + {&df_name} + string( g#report-num ) + ".txt").

os-delete value( string( session:temp-directory ) +
                           {&df_name} + string( g#report-num ) + ".txt":u ) .