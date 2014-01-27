/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Процедуры открытия закрытия EXCEL

Автор: Чернова Светлана Александровна
Дата создания: 03/21/06
Author: Svetlana Chernova
Creation date: 03/21/06

*/

PROCEDURE OpenForExcel :
os-delete value( string( session:temp-directory ) +
                              {&DF_Name} + string( g#report-num ) + ".txt":U ) .
os-delete value( string( session:temp-directory ) +
                              {&DF_Name} + string( g#report-num ) + ".frm":U ) .
os-delete value( string( session:temp-directory ) +
                              {&DF_Name} + string( g#report-num ) + ".txl":U ) .


  if Make-Excel then do:

    output stream ForExcel to value( string( session:temp-directory +
                                     {&DF_Name} + string( g#report-num ) + ".txt":U ) ) .
    assign
    v-excel-file = string( session:temp-directory + {&DF_Name} + string( g#report-num ) )
    number-list = 1
    .
    if make-excel-com then do:
      { cmp/relescom.i ch#WorkSheet }
      { cmp/relescom.i ch#Workbook }
      { cmp/relescom.i ch#ExcelApplication }

      create "Excel.Application" ch#excelApplication connect no-error.
      if error-status:error then do :
        create "Excel.Application" ch#excelApplication .
      end.
      assign
      num#str#  = 0
      ch#excelApplication:Interactive = false
      ch#excelApplication:ScreenUpdating = false
      ch#excelApplication:Visible = false
      ch#Workbook  = ch#excelApplication:Workbooks:add ()
      ch#WorkSheet = ch#excelApplication:Sheets:Item (1)
      ch#WorkSheet:Range ("A1"):Font:Bold = TRUE
      ch#WorkSheet:Range ("A1"):Font:Size = 14
      ch#WorkSheet:Range ("A1"):HorizontalAlignment = {&xlLeft}
      ch#WorkSheet:Range ("A1"):VerticalAlignment   = {&xlTop} no-error  .
      if error-status:error then DO:
        Make-Excel-com = false .
        Make-Excel = false .
        output Stream  ForExcel close.
        os-delete value( string( session:temp-directory ) +
                        {&DF_Name} + string( g#report-num ) + ".txt":U ) .
        os-delete value( string( session:temp-directory ) +
                        {&DF_Name} + string( g#report-num ) + ".frm":U ) .

        return.
      end.
    end.
  end.
end procedure.


PROCEDURE CloseForExcel :
define variable ii as integer no-undo .
define buffer buf_sheetf for sheetf.

IF Make-Excel THEN  DO:
  output Stream  ForExcel close.
  os-delete value( string( session:temp-directory ) +
                             {&DF_Name} + string( g#report-num ) + ".txt":U ) .
  os-delete value( string( session:temp-directory ) +
                             {&DF_Name} + string( g#report-num ) + ".frm":U ) .
  find last buf_sheetf no-error .
  if available buf_sheetf then do:
    if buf_sheetf.sheet-num > 1 then do:
      do ii = 2 to buf_sheetf.sheet-num:
        os-delete value( string( session:temp-directory ) +
                                  {&DF_Name} + string( g#report-num ) + ".":U  + string(ii)) .
      end.
    end.
  end.
  { cmp/relescom.i ch#WorkSheet }
  { cmp/relescom.i ch#Workbook }
  { cmp/relescom.i ch#ExcelApplication }

End.
END PROCEDURE.
/* $Workfile$ e n d */