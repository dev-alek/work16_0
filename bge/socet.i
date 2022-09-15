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
define variable mHSocket       as handle      no-undo.
define variable mWebRespHead   as longchar    no-undo.
define variable mWebResp       as longchar    no-undo.
define variable OerrMsg        as character   no-undo.
define variable mFileLogSocet  as character   no-undo.
define variable mReturnXML     as logical     no-undo.
define variable mSocetBegTime  as datetime-tz no-undo.
define variable mSocetEndTime  as dec         no-undo.
define variable mWriteRespFile as character   no-undo.

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
   mWaitFramTextBeg = iTextWait.
   run SendReqSocet (iHost, iPort, iUrl, iPostData, iReturnXML, 'getResponse').
   if OerrMsg eq ""
   then
      run waitrespsocet (iTimeOut, iSilent, iTextWait).
   mSocetEndTime = (now - mSocetBegTime) / 1000.
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
   mSocetBegTime = now.
   run writeLogSocet in this-procedure (substitute("Подключаемся к адресу &1 по порту &2",iHost,iPort )).
   assign
      mWebResp         = ""
      mWebResphead     = ""
      OerrMsg          = ""
      mReturnXML       = iReturnXML eq "xml"
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
   
   run waitfram-show (substitute("Подключаемся к адресу &1 по порту &2",iHost,iPort )).
   create socket mHSocket.
   mHSocket:connect('-H ' + iHost + ' -S ' + iPort) no-error.
 /*   mHSocket:SET-SOCKET-OPTION('TCP-NODELAY', 'true').
  mHSocket:SET-SOCKET-OPTION('SO-KEEPALIVE', 'true').
  mHSocket:SET-SOCKET-OPTION('SO-REUSEADDR', 'true').
   */
   if mHSocket:connected() = false 
   then do:
      run waitfram-hide .
      oErrMsg = substitute( "Не удалось установить соединение: &1" , error-status:get-message(1)).
      run writeLogSocet in this-procedure (oErrMsg).
      delete object mHSocket.
      return oErrMsg.
   end.
   run waitfram-show ("Отправка данных").
   
   mHSocket:set-read-response-procedure(iProcGetResponse).
   run PostRequest (
    input iUrl,
    input iHost + ":" + iPort,
    input iPostData
    ).
    run waitfram-hide .
   
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
   then do:
      run writeLogSocet in this-procedure (substitute("Потерян объект соединения")).
  
      return "End connected".
   end.
   if mHSocket:connected() = false 
   then do:
      run writeLogSocet in this-procedure (substitute("Соединение было разорвано другой стороной WaitRespSocet")).
  
      oErrMsg = "Not connected".
      return oErrMsg.
   end.
   mWaitFramView = if iSilent ne yes then yes else no.
   mWaitFramTextBeg = iTextWait.
   mWaitFramTimeOut = iTimeOut.
   mWaitFramTextEnd = "".
   mWaitFramStop = no.
   mWaitFramTimeOut = 300.
   run writeLogSocet in this-procedure (substitute ("Таймаут увеличен до &1 при учтановке соодинения",mWaitFramTimeOut)).
   
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
   run waitfram-hide .
   mHSocket:disconnect() no-error.
   delete object mHSocket.
end.

/*------------------------------------------------------------------------------
  Purpose: Процедура, проверки ответа 
  Parameters: 
  Notes:
------------------------------------------------------------------------------*/
procedure WaitRespTestStop:
   if mWaitFramStopTimeOut
   then
      return.
   if     (mWebResp ne ""
       and mWebResp ne ?)
   then do:
      mWaitFramStop = yes.
      return.
   end.
   else if mHSocket:connected() = false 
   then do:
      mWaitFramStop = yes.
      run writeLogSocet in this-procedure (substitute("Соединение было разорвано другой стороной WaitRespTestStop")).
   

      oErrMsg = "Not connected".
      return oErrMsg.
   end.
   wait-for read-response of mHSocket pause 0.001.
   
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
   then do:
  /* vCRequest =substitute( 
      'POST &2 HTTP/1.0&1'                                   + 
      'Accept-Encoding: gzip,deflate&1'                      +
      'Content-Type: text/xml;charset=UTF-8&1'               +
      'Content-Length:&3&1'                                  +
      'Host: &4&1'                                           +
    /*  'Connection: Keep-Alive&1'                             + */
      'User-Agent: Apache-HttpClient/4.1.1 (java 1.5)&1'    +
      'Allow: GET,HEAD&1&1&5' 
      ,
      {&carriage-return} + {&new-line}, 
      iPostUrl, 
      length(iPostData),
      iPostHost,
      iPostData).*/
      vCRequest =substitute( 
      'POST /&2 HTTP/1.1&1'                                   +
      'Host: &4&1'                                           +
      'User-Agent: Apache-HttpClient/4.1.1 (java 1.5)&1'    +
       
      'Accept: */*&1' +
      'Content-Type: text/xml&1'               +
      'Content-Length:&3&1'                                  +
      '&1&5' 
      ,
      {&carriage-return} + {&new-line}, 
      iPostUrl, 
      length(iPostData),
      iPostHost,
      iPostData).
   end.
   else
      vCRequest = iPostData.
   run writeLogSocet in this-procedure (substitute("Отправляем запрос &1&2.",{&carriage-return} + {&new-line},vCRequest )).
   
   SET-SIZE(vMRequest)            = 0.
   SET-SIZE(vMRequest)            = length(vCRequest) + 1.
   SET-BYTE-ORDER(vMRequest)      = big-endian.
   PUT-STRING(vMRequest,1)        = vCRequest .
   if mHSocket:connected() = false then 
   do:
      run writeLogSocet in this-procedure (substitute("Соединение было разорвано другой стороной getResponse")).
   
      oErrMsg = "Not connected".
      return oErrMsg.
   end.
   mHSocket:write(vMRequest, 1, length(vCRequest)).
   run writeLogSocet in this-procedure (substitute("Запрос отправлен." )).
   
end procedure.

function hex-to-int returns integer (
  input p-hex-code  as character  ).

  define variable v-int-code as integer   no-undo .
  define variable v-ind      as integer   no-undo .
  define variable v-digit    as integer   no-undo .
  define variable v-letter   as character no-undo .

  do v-ind = 1 to length(p-hex-code)
  :
    assign
      v-letter = caps(substring(p-hex-code, v-ind, 1))
    .
    assign
      v-digit = index('123456789ABCDEF':u, v-letter)
    .
    assign
      v-int-code = v-int-code * 16 + v-digit
    .
  end.

  return v-int-code .

end function . /* hex-to-int */
/*------------------------------------------------------------------------------
  Purpose: Процедура, которая вызывается когда приходит ответ от сервера
  Parameters:
  Notes:
------------------------------------------------------------------------------*/
procedure getResponse:

   define variable vFlagTag     as logical          no-undo init no.
   define variable vResponse    as memptr           no-undo.
   define variable vCnt         as int64            no-undo.
   define variable vMessage     as longchar         no-undo.
   define variable v-cont-length as int64 no-undo.
   define variable vi           as integer no-undo.
   define variable v-hd-line    as character no-undo.
   if mHSocket:connected() = false then 
   do:
      run writeLogSocet in this-procedure (substitute("Соединение было разорвано другой стороной getResponse")).
   
      oErrMsg = "Not connected".
      return oErrMsg.
   end.
   
   mWaitFramTimeOut = 1000.
   run writeLogSocet in this-procedure (substitute ("Таймаут увеличен до &1 при получении ответа",mWaitFramTimeOut)).
   
   run writeLogSocet in this-procedure (substitute("Получаем ответ")).
   mWaitFramTextEnd = "Получаем ответ".
   mWaitProcEvent = no. /* Отключим proces event иначе бедет беда с получением данных*/
   run WaitFramRunPause (?).
   define variable vByte as int64 no-undo.
   define variable vNextMese as int64 no-undo init 100000.
   mWaitFramStop = no.
   mWaitFramStopTimeOut = no.
   block-wait:
   do while mHSocket:get-bytes-available() > 0:
      define variable vNumByte as integer no-undo.
      vNumByte = if mReturnXML and not vFlagTag then 1 else  mHSocket:get-bytes-available().
      if vNumByte > 30000 then vNumByte = 30000.
      SET-SIZE(vResponse) = vNumByte + 1.
      SET-BYTE-ORDER(vResponse) = big-endian.
      
      mHSocket:read(vResponse,1,vNumByte).
      vByte = vByte + vNumByte.
      if  mReturnXML
      then do:
         /*Отсечение HTTP HEADER*/
         if get-string(vResponse,1) =  "<" or vFlagTag 
         then 
            assign 
               vFlagTag = true
               mWebResp = mWebResp + GET-STRING(vResponse,1)
            .
         else
            mWebResphead = mWebResphead + GET-STRING(vResponse,1).
      end.
      else do:
         mWebResp = mWebResp + GET-STRING(vResponse,1).
      end.
      if not mHSocket:get-bytes-available() > 0
      then do:
         run WaitFramRunPause (?).
         pause 1 no-message.      /* ответ приходит медленее чем мы читаем ответ */
      end.
      else if vByte > vNextMese
      then do:
         vNextMese = vNextMese + 100000.
         mWaitFramTextEnd = substitute ("Получаем ответ прочитано &1 байт ",vByte) .
         run WaitFramRunPause (?). 
      end.
      SET-SIZE(vResponse) = 0.
      
      if mWaitFramStopTimeOut
      then do:
         mWebResp = "".
         mHSocket:disconnect ().
         leave block-wait.
      end.
   end.
   mWaitFramStop = yes.
   run writeLogSocet         in this-procedure ("Получен ответ").
   run writeLogSocetOnlyText in this-procedure (mWebResphead).
   run writeLogSocetOnlyText in this-procedure (mWebResp).
   run writeLogSocetOnlyText in this-procedure (substitute("&1&2",{&carriage-return} , {&new-line} )).
   
   if     vFlagTag
      and R-INDEX(mWebResp,trim(">")) > 0
   then
      mWebResp = substring(mWebResp,1,r-index(mWebResp,trim(">"))).
   mSocetEndTime = (now - mSocetBegTime) / 1000.
   if     mWriteRespFile ne ""
      and mWriteRespFile ne ?
   then
        run gbl/fileapnd.p
             ( mWriteRespFile
             , mWebResp
             ,input 10 /* время ожинания освобождения файла */
             ) no-error .
                          
      
end procedure.

procedure writeLogSocet:
   define input  parameter itext as longchar no-undo.
   if     mFileLogSocet ne ?
      and mFileLogSocet ne ""
   then do:
      run gbl/fileapnd.p
          ( mFileLogSocet
          , substitute("&1 &2 ", string(today), string(time, "HH:MM:SS"))
          ,input 10 /* время ожинания освобождения файла */
          ) no-error .
      run writeLogSocetOnlyText(itext).
      run gbl/fileapnd.p
          ( mFileLogSocet
          , substitute(" &1&2", {&carriage-return} , {&new-line})
          ,input 10 /* время ожинания освобождения файла */
          ) no-error .
      
   end.
end.
procedure writeLogSocetOnlyText:
   define input  parameter itext as longchar no-undo.
   if     mFileLogSocet ne ?
      and mFileLogSocet ne ""
   then do:
      run gbl/fileapnd.p
          ( mFileLogSocet
          , itext 
          ,input 10 /* время ожинания освобождения файла */
          ) no-error .
   end.
end.