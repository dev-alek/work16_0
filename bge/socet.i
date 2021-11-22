/*
$Revision:$
$Author:$
$Date:$
$Workfile:$
$Archive:$

Автор: Рубан Дмитрий Андреевич 
Дата создания: 9 июля 2021 г.
Author:  Ruban Dmitriy Andreevich
Creation date: 9 июля 2021 г.

*/
&scoped-define vssseq {&sequence}
define variable vss-revision{&vssseq}    as character no-undo init "$Revision:$":U .
define variable vss-author{&vssseq}      as character no-undo init "$Author:$":U .
define variable vss-date{&vssseq}        as character no-undo init "$Date:$":U .
define variable vss-workfile{&vssseq}    as character no-undo init "$Workfile:$":U .
define variable vss-archive{&vssseq}     as character no-undo init "$Archive:$":U .
define variable vss-description{&vssseq} as character no-undo init "Работа С сокетом".
{cmp\str-glbl.i}
{ gbl/waitfram.i }
define variable mHSocket      as handle    no-undo.
define variable mWebRespHead  as longchar  no-undo.
define variable mWebResp      as longchar  no-undo.
define variable OerrMsg       as character no-undo.
define variable mFileLogSocet as character no-undo.
define variable mReturnXML    as logical   no-undo.
/*------------------------------------------------------------------------------
  Purpose: Процедура, которая формирует и отправляет POST отправляет запрос 
  Parameters: iHost            - ДНС имя хоста
              iPort            - Порт обращения
              iUrl             - часть адреса, идентифицирующая ссылку
              iPostData        - параметры (после ? в URL)
              iPostData        - параметры (после ? в URL)
              iReturnXML       - Что ожидать в ответе text или xml
              iTimeOut         - время ожидания ответа
              iSilent          - Молчаливый режим по умолчанию no
              iTextWait        - Текст для пользователя во время ожидания 
  Notes:
------------------------------------------------------------------------------*/
procedure ConectSocet:
   define input  parameter iHost      as character no-undo.
   define input  parameter iPort      as character no-undo.
   define input  parameter iUrl       as character no-undo.
   define input  parameter iPostData  as longchar  no-undo.
   define input  parameter iReturnXML as character no-undo.
   define input  parameter iTimeOut   as decimal   no-undo.
   define input  parameter iSilent    as logical   no-undo.
   define input  parameter iTextWait  as character no-undo.
   
   run SendReqSocet (iHost, iPort, iUrl, iPostData, iReturnXML, 'getResponse').
   run waitrespsocet (iTimeOut, iSilent, iTextWait).
end.

/*------------------------------------------------------------------------------
  Purpose: Процедура, которая формирует и отправляет POST отправляет запрос 
  Parameters: iHost            - ДНС имя хоста
              iPort            - Порт обращения
              iUrl             - часть адреса, идентифицирующая ссылку
              iPostData        - параметры (после ? в URL)
              iReturnXML       - Что ожидать в ответе text или xml
              iProcGetResponse - процедура обработки ответа по умолчанию getResponse
  Notes:
------------------------------------------------------------------------------*/
procedure SendReqSocet:
   define input  parameter iHost            as character no-undo.
   define input  parameter iPort            as character no-undo.
   define input  parameter iUrl             as character no-undo.
   define input  parameter iPostData        as longchar  no-undo.
   define input  parameter iReturnXML       as character no-undo.
   define input  parameter iProcGetResponse as character no-undo.
   run writeLogSocet in this-procedure (substitute("Подключаемся к &1:&2",iHost,iPort )).
   assign
      mWebResp    = ""
      OerrMsg     = ""
      mReturnXML  = iReturnXML eq "xml"
      iProcGetResponse = "getResponse"  when iProcGetResponse eq ? or iProcGetResponse eq "" 
   .
   define variable vPostData as longchar                       no-undo.
/*   define variable vHSocket  as handle                         no-undo.*/
/*   if valid-object(mHSocket) then delete object mHSocket. */
   if    iHost eq ""
      or iHost eq ?
   then do:
      oErrMsg = substitute("Не задан host &1 или port &2.", ihost ,iport).
      run writeLogSocet in this-procedure (oErrMsg).
      return oErrMsg.
   end.
   
   create socket mHSocket.
   mHSocket:connect('-H ' + iHost + ' -S ' + iPort) no-error.
    
   if mHSocket:connected() = false 
   then do:
      oErrMsg = substitute( "Неудалось установить соединение: &1" , error-status:get-message(1)).
      run writeLogSocet in this-procedure (oErrMsg).
      delete object mHSocket.
      return oErrMsg.
   end.
   mHSocket:set-read-response-procedure(iProcGetResponse).
   run PostRequest (
    input iUrl,
    input iHost + ":" + iPort,
    input iPostData
    ).
end.

/*------------------------------------------------------------------------------
  Purpose: Ожидание ответа от сокета 
  Parameters: iTimeOut         - время ожидания ответа
              iSilent          - Молчаливый режим по умолчанию no
  Notes:
------------------------------------------------------------------------------*/
procedure WaitRespSocet:
   define input  parameter iTimeOut   as decimal   no-undo.
   define input  parameter iSilent    as logical   no-undo.
   define input  parameter iTextWait  as character no-undo.
   
   if    not valid-handle (mHSocket )
   then 
      return "End connected".
   if mHSocket:connected() = false 
   then do:
      oErrMsg = "Not connected".
      return oErrMsg.
   end.
   mWaitFramView = if iSilent ne yes then yes else no.
   mWaitFramTextBeg = iTextWait.
   mWaitFramTimeOut = iTimeOut.
   run writeLogSocet in this-procedure (substitute("Ожидаем ответ TimeOut &1 сек.",iTimeOut )).
   
   subscribe   to "WaitFramStop" anywhere run-procedure "WaitRespTestStop".
   run WaitFramWaitFor(1).
   unsubscribe "WaitFramStop".
   if mWaitFramStopUser
   then do:
      OerrMsg = substitute("Операция прервана пользователем." ).
      run writeLogSocet in this-procedure (OerrMsg).
   end.
   else if mWaitFramStopTimeOut
   then do:
      OerrMsg = substitute("Привышено время ожидания &1 сек. Ответ не получен.",iTimeOut ).
      run writeLogSocet in this-procedure (OerrMsg).
   end.
   
   mHSocket:disconnect() no-error.
   delete object mHSocket.
end.

/*------------------------------------------------------------------------------
  Purpose: Процедура, проверки ответа 
  Parameters: 
  Notes:
------------------------------------------------------------------------------*/
procedure WaitRespTestStop:
   if mHSocket:connected() = false 
   then do:
      mWaitFramStop = yes.
      oErrMsg = "Not connected".
      return oErrMsg.
   end.
   wait-for read-response of mHSocket pause 0.001.
   if     (mWebResp ne ""
       and mWebResp ne ?)
   then
      mWaitFramStop = yes.
end.
/*------------------------------------------------------------------------------
  Purpose: Процедура, которая формирует и отправляет POST отправляет запрос 
  Parameters: iPostHost - ДНС имя хоста
              iPostUrl  - часть адреса, идентифицирующая ссылку
              iPostData - параметры (после ? в URL)
  Notes:
------------------------------------------------------------------------------*/
procedure PostRequest:
   define input parameter iPostUrl  as char. 
   define input parameter iPostHost as char.
   define input parameter iPostData as longchar.

   define variable vCRequest      as character.
   define variable vMRequest       as memptr.
   if iPostUrl ne ?
   then
   vCRequest = 
      'POST ' + iPostUrl + ' HTTP/1.1' + chr(13)  + chr(10) + 
      'Accept-Encoding: gzip,deflate' + chr(13)  + chr(10) +
      'Content-Type: text/xml;charset=UTF-8' + chr(13)  + chr(10) + 
      'Content-Length:' + string(length(iPostData)) + chr(13)  + chr(10)  +
      'Host: ' + iPostHost + chr(13)  + chr(10)  +
      'Connection: Keep-Alive' + chr(13)  + chr(10) +
      'User-Agent: Apache-HttpClient/4.1.1 (java 1.5)' + chr(13)  + chr(10) + chr(13)  + chr(10)  +
      iPostData.
   else
      vCRequest = iPostData.
   run writeLogSocet in this-procedure (substitute("Отправляем запрос &1.",vCRequest )).
   
   SET-SIZE(vMRequest)            = 0.
   SET-SIZE(vMRequest)            = length(vCRequest) + 1.
   SET-BYTE-ORDER(vMRequest)      = big-endian.
   PUT-STRING(vMRequest,1)        = vCRequest .
   mHSocket:write(vMRequest, 1, length(vCRequest)).
   run writeLogSocet in this-procedure (substitute("Запрос отправлен." )).
   
end procedure.

/*------------------------------------------------------------------------------
  Purpose: Процедура, которая вызывается когда приходит ответ от сервера
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
procedure getResponse:

   define variable vFlagTag     as logical          no-undo init no.
   define variable vResponse    as memptr           no-undo.
   define variable mHParser     as handle           no-undo.
   define variable vCnt         as int64          no-undo.
   
   if mHSocket:connected() = false then 
   do:
      oErrMsg = "Not connected".
      return oErrMsg.
   end.
   run writeLogSocet in this-procedure (substitute("Получаем ответ")).
   
   do while mHSocket:get-bytes-available() > 0:
      SET-SIZE(vResponse) = mHSocket:get-bytes-available() + 1.
      SET-BYTE-ORDER(vResponse) = big-endian.
      mHSocket:read(vResponse,1,1,mHSocket:get-bytes-available()).
      if mReturnXML
      then do:
         if vFlagTag then mWebResp = mWebResp + GET-STRING(vResponse,1).
         /*Отсечение HTTP HEADER*/
         else if get-string(vResponse,1) =  "<" 
         then 
            assign 
               vFlagTag = true
               mWebResphead = mWebResp
               mWebResp = "<"
            .
          
      end.
      else do:
         mWebResp = mWebResp + GET-STRING(vResponse,1).
         if not mHSocket:get-bytes-available() > 0
         then
            pause 1 no-message.      /* ответ приходит медленее чем мы читаем ответ */
      end.   
   end.
   run writeLogSocet in this-procedure (substitute("Получен ответ &1&2",mWebResphead,mWebResp )).
   if     vFlagTag
      and R-INDEX(mWebResp,trim(">")) > 0
   then
      mWebResp = substring(mWebResp,1,r-index(mWebResp,trim(">"))).
   
end procedure.

procedure writeLogSocet:
   define input  parameter itext as longchar no-undo.
   if     mFileLogSocet ne ?
      and mFileLogSocet ne ""
   then
      run gbl/fileapnd.p
          ( mFileLogSocet
          , substitute("&1 &2 &3 &4&5", string(today), string(time, "HH:MM:SS"),itext ,{&carriage-return} , {&new-line})
          ,input 10 /* время ожинания освобождения файла */
          ) no-error .
end.