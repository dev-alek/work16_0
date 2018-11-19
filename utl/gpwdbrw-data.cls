/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Прослойка работы с БД для формы браузера gpwdbrw

Автор: Сергей Палагин
Дата создания: 21/10/18
Author: Sergey Palagin
Creation date: 21/10/18

*/

&glob DF_Name "rpt"

class utl.gpwdbrw-data:
   
   define stream sHtml.
   
   define temp-table ttTechProlBrw no-undo
      field id        as int64 column-label "Идентификатор"
      field fDate     as date  column-label "Дата"
      field fTime     as char  column-label "Время" 
      field fHostName as char  column-label "Имя хоста"
      field fUser     as char  column-label "Пользователь" 
      field fDetails  as char  column-label "Детали" 
      index fdate fDate ftime  
      .     

   define temp-table ttTemp no-undo
      field id as int64
      index id id
   .     

   define public property hQuery as handle no-undo 
   get.
   set. 

   constructor public gpwdbrw-data (  ):
      super ().
      create ttTemp.
      
   end constructor.
   
   method public void RefreshTT(iFilter as class utl.gpwdbrw-filter):
      
      def buffer b-tech-prol-pwd for tech-prol-pwd.

      def buffer b-clients   for clients.
      def buffer b-cash-desk for cash-desk.
      
      
      def var vShop     as char   no-undo. 
      def var vCashDesk as char   no-undo.
      def var hQuery-tt as handle no-undo.
      def var vQueryString as char no-undo.
      
     
       
      empty temp-table ttTechProlBrw.

      create query hQuery-tt.    
      hQuery-tt:set-buffers(buffer b-tech-prol-pwd:handle, 
                            buffer b-clients:handle,
                            buffer b-cash-desk:handle,
                            buffer ttTemp:handle).
      vQueryString = iFilter:GetQueryString().
      hQuery-tt:query-prepare(vQueryString).
      hQuery-tt:query-open.
      hQuery-tt:get-first().
      
      do while not hQuery-tt:query-off-end:
          
         create ttTechProlBrw.
         assign
            ttTechProlBrw.id = b-tech-prol-pwd.id
            ttTechProlBrw.fDate = date(b-tech-prol-pwd.f-time)
            ttTechProlBrw.fTime = string(b-tech-prol-pwd.f-time,"99/99/99 HH:MM:SS")
            ttTechProlBrw.fTime = substring(ttTechProlBrw.fTime,10)
            ttTechProlBrw.fHostName = b-tech-prol-pwd.f-hostname
            ttTechProlBrw.fDetails = substitute(
               "маг &1, касса &2, &3, &4 - &5, &6",
               string(b-clients.obj-code),
               string(b-cash-desk.cash-num),
               b-tech-prol-pwd.f-date,
               b-tech-prol-pwd.f-beg-time,
               b-tech-prol-pwd.f-end-time,
               b-tech-prol-pwd.f-fio)
         .
         
         if b-tech-prol-pwd.f-user <> "" then
         do:
            ttTechProlBrw.fUser = substitute("&1: &2",
                                             b-tech-prol-pwd.f-user,
                                             this-object:GetUserLogin(b-tech-prol-pwd.f-user)).  
         end.
         
         hQuery-tt:get-next().
         
      end.
      hQuery-tt:query-close().
      
      finally:
         delete object hQuery-tt. 
      end finally.
      
   end method.
   
   method public char GetUserLogin(iUser as char):
      
      def var vUserLogin as char no-undo.
      def buffer buf_user-account for ub.user-account.
      
      for first buf_user-account where 
                buf_user-account.user-id = iUser
      no-lock:
         assign
            vUserLogin = substitute('&1 &2 &3':U
                                    ,buf_user-account.last-name
                                    ,buf_user-account.first-name
                                    ,buf_user-account.second-name
                                    )
         .
      end.    
      
      return vUserLogin.
   end method.
       
   method public handle GetQuery():
      
      create query hQuery.    
      hQuery:set-buffers(buffer ttTechProlBrw:handle). 
      hQuery:query-prepare("FOR EACH ttTechProlBrw").
      hQuery:query-open.

      return hQuery.

   end method.

   method public void RefreshQuery(iFilter as class utl.gpwdbrw-filter):
      
      RefreshTT(iFilter).
      
      hQuery:query-close().
      
      hQuery:set-buffers(buffer ttTechProlBrw:handle). 
      hQuery:query-prepare("FOR EACH ttTechProlBrw").
      hQuery:query-open.

   end method.

   method public void Dispose():
      empty temp-table ttTechProlBrw.
      if valid-handle(hQuery) then delete object hQuery.

   end method.
   
   method public void Report(iFilter as class utl.gpwdbrw-filter):
      
      def var vFullFileName as char  no-undo.
      def var vReportId     as int64 no-undo.
      def var vRepViewer    as char  no-undo.
      def var vFilters      as log   no-undo.
      
      def buffer ttTechProlBrw for ttTechProlBrw.
      
      main:
      do on error undo, throw:
         
         vRepViewer = search("exe\ReportViewer\reportviewer.exe").
      
         if vRepViewer = ? then
         do:
           message "Не найдена программа просмотра отчёта!" view-as alert-box error.
           leave main.
         end.
         
         run get-report-num in utl.gpwdbrw:parParentProc (output vReportId).
      
         vFullFileName = session:temp-directory + {&DF_Name} + string(vReportId) + ".html".
         
         /*вызов процедуры печати шапки отчета*/      
         output stream sHtml to value(vFullFileName) convert target 'UTF-8'.
         
         put stream sHtml unformatted
            "<!DOCTYPE HTML>" skip
            ' <html>' skip
            '  <head>' skip
            '   <meta charset="utf-8">' skip
            '    <style type="text/css">' skip
                        
            '      table ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
            '      .class1 ' + chr(123) + ' border-collapse: collapse; ' + chr(125) skip
            '      tbody td, th ' + chr(123) + ' border-collapse: collapse; border: 1px solid black; height: 14px;' + chr(125) skip
            '   </style>' skip
            '  </head>' skip
            .
         
         put stream sHtml unformatted
            '<body>' skip
            '<TABLE name="1"  fit_to_page="true" orientation="portrait" CELLSPACING="0" BORDER="0">'skip
            '<thead>' skip
            .
         
         put stream sHtml unformatted
            '<tr>' skip
            '<td style="width: 70px;"></td>' skip
            '<td style="width: 70px;"></td>' skip
            '<td style="width: 250px;"></td>' skip
            '<td style="width: 250px;"></td>' skip
            '<td style="width: 600px;"></td>' skip
            '</tr>' skip
            .
            
         put stream sHtml unformatted
            '<tr>' skip
            '<td colspan="5" style="text-align: center; font-weight: bold; font: 25px arial;">Журнал генерации паролей для проведения технологических проливов </td>' skip
            '</tr>' skip   
            '</thead>' skip .
         
         put stream sHtml unformatted
            '<tr>' skip
            '<td colspan="5" style="text-align: left; font-weight: bold;">Фильтры: </td>' skip
            '</tr>' skip   
            '</thead>' skip .
            
         if iFilter:IsEnabled() then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;">Способ объединения фильтров: ' + iFilter:GetModifierName() + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.
         
         if iFilter:User:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:User:FieldName,":","") + "-" + iFilter:User:Operation + "-" + iFilter:User:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.

         if iFilter:HostName:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:HostName:FieldName,":","") + "-" + iFilter:HostName:Operation + "-" + iFilter:HostName:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.

         if iFilter:DateGen:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:DateGen:FieldName,":","") + "-" + iFilter:DateGen:Operation + "-" + iFilter:DateGen:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.

         if iFilter:TimeGen:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:TimeGen:FieldName,":","") + "-" + iFilter:TimeGen:Operation + "-" + iFilter:TimeGen:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.

         if iFilter:Fio:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:Fio:FieldName,":","") + "-" + iFilter:Fio:Operation + "-" + iFilter:Fio:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.
         
         if iFilter:ObjectNum:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:ObjectNum:FieldName,":","") + "-" + iFilter:ObjectNum:Operation + "-" + iFilter:ObjectNum:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.

         if iFilter:CashNum:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:CashNum:FieldName,":","") + "-" + iFilter:CashNum:Operation + "-" + iFilter:CashNum:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.

         if iFilter:DateProl:Enabled then
         do:
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left;"> ' + replace(iFilter:DateProl:FieldName,":","") + "-" + iFilter:DateProl:Operation + "-" + iFilter:DateProl:Value + '</td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.
         
         if not iFilter:IsEnabled() then
         do:  
            put stream sHtml unformatted
               '<tr>' skip
               '<td colspan="5" style="text-align: left; font-weight: bold;">    все </td>' skip
               '</tr>' skip   
               '</thead>' skip .
         end.
          
         put stream sHtml unformatted
            '<tbody>'                                                            skip
            '<TR>'                                                               skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">Дата</TD>'         skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">Время</TD>'        skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">Имя хоста</TD>'    skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">Пользователь</TD>' skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">Детали</TD>'       skip
            '</TR>'                                                              skip       
           
            .

         put stream sHtml unformatted
            '<tbody>'                                                 skip
            '<TR>'                                                    skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">1</TD>' skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">2</TD>' skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">3</TD>' skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">4</TD>' skip
            '<TD text_wrap="true" style="text-align: center; font-weight: bold; background: DarkSeaGreen;">6</TD>' skip
            '</TR>'                                                   skip       
           
            .
         
         for each ttTechProlBrw:
            put stream sHtml unformatted
               '<TR>' skip
               '<TD text_wrap="true" style="text-align: center;">'  + string(ttTechProlBrw.fDate) + '</TD>' skip
               '<TD text_wrap="true" style="text-align: center;">'  + ttTechProlBrw.fTime + '</TD>' skip
               '<TD text_wrap="true" style="text-align: center;">'  + ttTechProlBrw.fHostName + '</TD>' skip
               '<TD text_wrap="true" style="text-align: center;">'  + ttTechProlBrw.fUser + '</TD>' skip
               '<TD text_wrap="true" style="text-align: left; padding-left: 20px">' + ttTechProlBrw.fDetails + '</TD>' skip
               '</TR>'skip                       
            .  
            
         end.
         output stream sHtml close.
      
         os-command no-wait value(vRepViewer + " " + vFullFileName).
            
      end.
   end method.

end class.