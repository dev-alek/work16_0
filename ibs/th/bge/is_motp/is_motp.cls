/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Класс работы с ИС МОТП

Автор: Сливенко Сергей
Дата создания: 05/03/18
Author: Slivenko Sergey
Creation date: 05/03/18


*/

using Progress.Lang.*.
using ibs.th.str.gds.*.
using ibs.th.gbl.*.
using ibs.th.gbl.sys.*.
using ibs.th.gbl.storage.*.
using ibs.th.str.clients.*.
using ibs.th.str.utd.*.
using ibs.th.str.utd.sts.*.
&glob prefixfile IsMotp_
class ibs.th.bge.is_motp.is_motp inherits objth: 
  
  {cmp/str-glbl.i class}
  { ref/extclass.i }
  { str/lib-trn.i class }
  { gbl/thbj-def.i }
  
  
  define temp-table tt-childs no-undo
    field mark    as character case-sensitive
    field parent_ as character
    index pi as primary unique
      mark parent_
  .
  
  define property thumpprint as character no-undo init ?
    get.
    private set.

  define property proxy-addr as character no-undo init ?
    get.
    private set.
      
  define property proxy-login as character no-undo init ?
    get.
    private set.
    
  define property proxy-pswd as character no-undo init ?
    get.
    private set.
  define variable CmdParamProxy    as character no-undo.
  define variable CmdParamProxyLog as character no-undo.
    
  define property proxy-ssl as logical no-undo init ?
    get.
    private set.  
    
  define property esysId as integer no-undo init ?
    get.
    private set.
    
  define property esysDbNum as integer no-undo init ?
    get.
    private set.
    
  define property user-id_ as character no-undo init ?
    get.
    private set.
    
  define property mail-list as character no-undo init ?
    get.
    private set.
    
  define property server_ as character no-undo init "https://int01.gismt.crpt.tech/api/v3/true-api"
    get.
    private set.

  define property applicationId as character no-undo
    get.
    protected set.
  
  define property Status_ as character no-undo
    get.
    protected set.  
    
  define property HttpStatus as integer no-undo
    get.
    protected set.

  define property Msg as character no-undo
    get.
    protected set.

  define property StatusErr as logical no-undo init false
    get.
    protected set.
  
  define property Doc-Id as integer no-undo
    get.
    protected set.
    
  define property DB-num as integer no-undo
    get.
    protected set.
    
  define property docDB-num as integer no-undo
    get.
    protected set.
    
  define property INN as character no-undo
    get.
    protected set.
    
  define property isFirstEnter as logical no-undo init false
    get.
    set.
    
  define property checkINN as logical no-undo init false
    get.
    set.
  
  define property isDebug as logical no-undo init false
    get.
    set.
    
  define property INNchecked as logical no-undo init false
    get.
    protected set.
    
  define property BadAuth as logical no-undo init false
    get.
    protected set.
    
  define property lastLineCisInfo as integer no-undo init 0
    get.
    set.
    
  define property currToken as character no-undo
    get :
      define buffer buf_ext-system-attr for ub.ext-system-attr .
      find first buf_ext-system-attr no-lock where buf_ext-system-attr.db-num   = esysDbNum
                                               and buf_ext-system-attr.esys-id  = esysId
                                               and buf_ext-system-attr.esya-attr-code = "AuthToken"
                                               no-error .
      if not available buf_ext-system-attr
      then do :
        return ? .
      end.
      return buf_ext-system-attr.esya-attr-value .
    end.
    protected set .
    
  define property currTokenDT as datetime-tz no-undo
    get :
      define buffer buf_ext-system-attr for ub.ext-system-attr .
      find first buf_ext-system-attr no-lock where buf_ext-system-attr.db-num   = esysDbNum
                                               and buf_ext-system-attr.esys-id  = esysId
                                               and buf_ext-system-attr.esya-attr-code = "AuthTokenDT"
                                               no-error .
      if not available buf_ext-system-attr
      or (available buf_ext-system-attr and trim(buf_ext-system-attr.esya-attr-value) = "")
      then do :
        return ? .
      end.
      return datetime-tz(buf_ext-system-attr.esya-attr-value) .
    end.
    protected set .
    
  define variable mFileAuth      as character no-undo.
  define variable mFileCades     as character no-undo.
  define variable mFileAuthTest  as character no-undo.
  define variable mFilecisesInfo as character no-undo.
    
  constructor public is_motp (  ):
 
    define buffer buf_ext-system for ub.ext-system .
    define buffer buf_ext-system-attr for ub.ext-system-attr .
    
    find first clients no-lock where clients.obj-type = {&shop} 
                                 and clients.db-num = gbl-var:g#db-num
                                 and clients.stts = 0
                                 no-error .
    if not available clients
    then do :
      assign
        MSG = "Нет активного магазина в БД" + string(gbl-var:g#db-num)
        StatusErr = true
      .
      return error .
    end .         
    
    for each buf_ext-system-attr no-lock where buf_ext-system-attr.esya-attr-code   = {&attr-esys-host-code}
                                           and buf_ext-system-attr.esya-attr-value  = string(clients.host-code)
                                          /* and buf_ext-system-attr.db-num           = buf_db.db-num */
                                           :
      find first buf_ext-system no-lock where buf_ext-system.esys-type = integer({&openxml-type-is_motp})
                                          and buf_ext-system.esys-id   = buf_ext-system-attr.esys-id 
                                          no-error .
      if available buf_ext-system then leave .
    end .                                      
    if not available buf_ext-system
    then do :
      assign
        MSG = "Нет внешней системы с типом ИС МОТП, привязанной к фирме Орг" + string(clients.host-code)
        StatusErr = true
      .
      return error .
    end .
    
    setProps(buf_ext-system.db-num, buf_ext-system.esys-id, gbl-var:g#db-num) .
    
  end constructor .
  
  constructor public is_motp
  (
  input pEsysDbNum as integer,
  input pEsysId as integer
  ) :
    
    setProps(pEsysDbNum, pEsysId, gbl-var:g#db-num) .                         
    
  end constructor .  
  
  constructor public is_motp
  (
  input pEsysDbNum as integer,
  input pEsysId as integer,
  input pDbNum as integer
  ) :
        
    setProps(pEsysDbNum, pEsysId, pDbNum) .                         
    
  end constructor .
  
  method private void setProps
  (
  input pEsysDbNum as integer,
  input pEsysId as integer,
  input pDbNum as integer
  ) :
    
    define buffer buf_ext-system for ub.ext-system .
    define buffer buf_ext-system-attr for ub.ext-system-attr .
    
    DB-num = pDbNum .
    
    find first buf_ext-system no-lock where buf_ext-system.db-num = pEsysDbNum
                                        and buf_ext-system.esys-id = pEsysId
                                        .
    esysId = buf_ext-system.esys-id .  
    esysDbNum = buf_ext-system.db-num .                               
    for each buf_ext-system-attr no-lock where buf_ext-system-attr.db-num = buf_ext-system.db-num
                                           and buf_ext-system-attr.esys-id = buf_ext-system.esys-id
                                           :
      case buf_ext-system-attr.esya-attr-code :
        when {&attr-esys-user-id} then do:
          user-id_ = buf_ext-system-attr.esya-attr-value .
        end.
        when {&attr-esys-server-addr} then do:
          server_ = buf_ext-system-attr.esya-attr-value.
        end.
        when {&attr-esys-proxy-addr} then do:
           get-key-value section "ProxyServ" key buf_ext-system-attr.esya-attr-code value proxy-addr.
           if proxy-addr eq ?
           then
              proxy-addr = buf_ext-system-attr.esya-attr-value .
        end.
        when {&attr-esys-proxy-login} then do:
           get-key-value section "ProxyServ" key buf_ext-system-attr.esya-attr-code value proxy-login.
           if proxy-login eq ?
           then
              proxy-login = buf_ext-system-attr.esya-attr-value .
        end.
        when {&attr-esys-proxy-pswd} then do:
           get-key-value section "ProxyServ" key buf_ext-system-attr.esya-attr-code value proxy-pswd.
           if proxy-pswd eq ?
           then
              proxy-pswd = buf_ext-system-attr.esya-attr-value .
        end.
        when {&attr-esys-proxy-ssl} then do:
           define variable vtext as character no-undo.
           get-key-value section "ProxyServ" key buf_ext-system-attr.esya-attr-code value vtext.
           if vtext eq ?
           then
              proxy-ssl = logical(buf_ext-system-attr.esya-attr-value) .
           else
              proxy-ssl = logical(vtext) .
        end.
        when {&attr-esys-mail-list} then do:
          mail-list = buf_ext-system-attr.esya-attr-value .
        end.
        when {&attr-esys-host-code} then do:
          find first firm no-lock where firm.firm-code = integer(buf_ext-system-attr.esya-attr-value) no-error .
          if available firm
          then do :
            INN = firm.inn .
          end .
        end.
      end case .
    end .
    if trim(proxy-addr) <> "" and proxy-addr <> ?
    then do :
      if proxy-ssl
      then do:
        assign
          CmdParamProxy    = substitute ('-k --proxy-negotiate -x &1 -U : ',proxy-addr)
          CmdParamProxyLog = CmdParamProxy
        .
      end.
      else do:
        assign
          CmdParamProxy     = substitute ('-x &1 -U &2:&3', proxy-addr, proxy-login, proxy-pswd )
          CmdParamProxyLog  = substitute ('-x &1 -U &2:',   proxy-addr, proxy-login             )
        .
      end.
    end.
    else
      assign 
        CmdParamProxy    = ""
        CmdParamProxyLog = ""
      .
      
    mFileAuth      = "{&prefixfile}auth_db" + string(DB-num) + ".log".
    mFileCades     = "{&prefixfile}cadescom_db" + string(DB-num) + ".log".
    mFileAuthTest  = "{&prefixfile}authTest_db" + string(DB-num) + ".log".
    mFilecisesInfo = "{&prefixfile}cisesInfo_db" + string(DB-num) + ".log".              
    
  end method .
  
  
  
  method public character authorize
  (
  input pKey as character,
  input pMode as character
  ):
    
    define buffer buf_ext-system-attr for ub.ext-system-attr .
  
    define variable oStore as component-handle no-undo .
    define variable oCerts as com-handle no-undo .
    define variable oCert as com-handle no-undo .
    define variable oSigner as com-handle no-undo .
    define variable oSignedData as com-handle no-undo .
    define variable signedData1Long as longchar no-undo .
    define variable signedData2Long as longchar no-undo .
  
    define variable ii as integer no-undo .
    define variable ix as integer no-undo .
    define variable v-found as logical no-undo .
    define variable cmd as character no-undo .
    define variable cmdlog as character no-undo .
  
    define variable vData1 as character no-undo .
    define variable vData2 as character no-undo .
    define variable vLine  as character no-undo .
    define variable vStr   as character no-undo .
  
    define variable vAuthDataLong as longchar no-undo .
    define variable vToken as character no-undo .
  
    MSG = "".
    StatusErr = true.
    create "CAdESCOM.Store" oStore no-error .
    if error-status:num-messages > 0
    then do ix = 1 to  error-status:num-messages:
       putcades( error-status:get-message(ix) ) .
    end .
    oStore:Open (2, "My", 0) no-error .
    if error-status:num-messages > 0
    then do ix = 1 to  error-status:num-messages:
       putcades( error-status:get-message(ix) ) .
    end .
  
    create "CAPICOM.Certificates" oCerts no-error . 
    if error-status:num-messages > 0
    then do ix = 1 to  error-status:num-messages:
       putcades( error-status:get-message(ix) ). .
    end .
    oCerts = oStore:Certificates .
    
    release object oStore . 
    .
    create "CAdESCOM.Certificate" oCert  no-error.
    if error-status:num-messages > 0
    then do ix = 1 to  error-status:num-messages:
       putcades( error-status:get-message(ix) ). .
    end .
 
    assign v-found = false .
    do ii = 1 to oCerts:Count :
       oCert = oCerts:item(ii) .
       case pMode :
          when "ThumbPrint"
          then do :
             if oCert:Thumbprint = pKey
             then do :
                v-found = true .
                leave .
             end .
          end .
          when "SerialNumber"
          then do :
             if oCert:SerialNumber = pKey
             then do :
                v-found = true .
                leave .
             end .
          end .  
       end case.
    end.
    release object oCerts .
    if not v-found
    then do :
       case pMode :
          when "ThumbPrint"
          then
             MSG = "В личном хранилище сертификатов не найден сертификат с отпечатком " + pKey .
          when "SerialNumber"
          then 
             MSG = "В личном хранилище сертификатов не найден сертификат с серийным номером " + pKey .
       end case .
       putauth ( MSG ) .
    end.
    else do:
       define variable vFileResult as character no-undo.
       define variable vFileResultErr as character no-undo.
       assign
          vFileResult    = "{&prefixfile}AuthData_db" + string(DB-num) + ".json"
          vFileResultErr = "{&prefixfile}AuthData_db" + string(DB-num) + ".err"
          cmd    = substitute ('&1 &4 --stderr &5 &3/auth/key >&2', search ("exe/curl.exe"), vFileResult, server_, CmdParamProxy, vFileResultErr)
          cmdlog = substitute ('&1 &4 --stderr &5 &3/auth/key >&2', search ("exe/curl.exe"), vFileResult, server_, CmdParamProxylog, vFileResultErr)
       .
       putauth(" command   " + cmdlog ).
       os-command silent value (cmd).
       define variable VFile as character no-undo.
       vfile =  SearchFile(vFileResult).
       if vfile eq ?
       then do:
          MSG = "Нет ответа от ИС МОТП. Не найден " + vFileResult.
          putauth (MSG ).
       end.
       else do:
          file-info:file-name = vfile .
          if file-info:file-size = 0
          then do :
             MSG = "Нет ответа от ИС МОТП. Файл пустой " + vfile.
             putauth ( MSG ).
          end.
          else do:
             copy-lob from file vfile to vAuthDataLong no-convert .
  
             output to value (vfile) append .
             put unformatted " " skip " _ ".
             output close .
  
             input from value (vfile) .
             import unformatted vLine .
             input close .
             do ii = 1 to num-entries(vLine) :
                vStr = entry(ii, vLine) .
                vStr = trim(vStr) .
                vStr = trim(vStr, "[") .
                vStr = trim(vStr, "]") .
                vStr = trim(vStr, chr(123)) .
                vStr = trim(vStr, "}") .
                if num-entries(vStr, ":") <> 2 then next .
                if vStr begins '"data"'
                then do :
                   if ii < 3
                   then vData1 = trim(trim(entry(2, vStr, ":")), '"') .
                   else vData2 = trim(trim(entry(2, vStr, ":")), '"') .
                end.
             end .
             create "CAdESCOM.CPSigner" oSigner no-error .
             if error-status:num-messages > 0
             then do ix = 1 to  error-status:num-messages:
                putcades( error-status:get-message(ix) ) .
             end .
             create "CAdESCOM.CadesSignedData" oSignedData no-error .
             if error-status:num-messages > 0
             then do ix = 1 to  error-status:num-messages:
                putcades( error-status:get-message(ix) ) .
             end .
             oSigner:Certificate = oCert . 
             oSigner:TSAAddress = "http://testca2012.cryptopro.ru/tsp/tsp.srf" .
             oSignedData:ContentEncoding = 0 .
             oSignedData:Content = vData1 .
  
             signedData1Long = oSignedData:SignCades(oSigner, 1, false, 0) no-error .
             if error-status:num-messages > 0
             then do ix = 1 to  error-status:num-messages:
                putcades( error-status:get-message(ix)).
             end .
             if    signedData1Long = ?
                or signedData1Long = ""
             then do :
                MSG = "Ошибка при попытке подписания строки для получения токена авторизации!".
                putauth ( MSG ) .
             end .
             else do:
                signedData1Long = replace(signedData1Long, chr(10), "") .
                signedData1Long = replace(signedData1Long, chr(13), "") .
                define variable vFlagError as logical no-undo.
                if vData2 > ""
                then do :
                   oSignedData:Content = vData2 .
                   signedData2Long = oSignedData:SignCades(oSigner, 1, false, 0) no-error .
                   if error-status:num-messages > 0
                   then do ix = 1 to  error-status:num-messages:
                      putcades( error-status:get-message(ix)) .
                   end .
                   if    signedData2Long = ?
                      or signedData1Long = ""
                   then do :
                      MSG = "Ошибка при попытке подписания строки (2) для получения токена авторизации!".
                      putauth ( MSG ) .
                      vFlagError = yes.
                   end .
                   else do:
                      signedData2Long = replace(signedData2Long, chr(10), "") .
                      signedData2Long = replace(signedData2Long, chr(13), "") .
                   end.
               end.
               if not vFlagError
               then do:
                   if vData1 > ""
                   then
                      vAuthDataLong = replace(vAuthDataLong, vData1, signedData1Long) .
                   if vData2 > ""
                   then
                      vAuthDataLong = replace(vAuthDataLong, vData2, signedData2Long) .
                   copy-lob vAuthDataLong to file ("{&prefixfile}AuthDataSigned_db" + string(DB-num) + ".json") no-convert .
 
                     vFileResult = "{&prefixfile}AuthToken_db" + string(DB-num) + ".json".
                   vFileResulterr = "{&prefixfile}AuthToken_db" + string(DB-num) + ".err".
                   cmd = substitute ('&1 -H "Content-Type: application/json" &5 -d @&4 --stderr &6 &3/auth/simpleSignIn >&2',
                                      search ("exe/curl.exe"),
                                      vFileResult,
                                      server_,
                                      searchfile ("{&prefixfile}AuthDataSigned_db" + string(DB-num) + ".json"),
                                      CmdParamProxy,
                                      vFileResulterr).
                   cmdlog = substitute ('&1 -H "Content-Type: application/json" &5 -d @&4 --stderr &6 &3/auth/simpleSignIn >&2',
                                         search ("exe/curl.exe"),
                                         vFileResult,
                                         server_,
                                         searchfile ("{&prefixfile}AuthDataSigned_db" + string(DB-num) + ".json"),
                                         CmdParamProxyLog,
                                         vFileResulterr).
 
                   putauth (" command   " + cmdlog ) .
                   os-command silent value (cmd).
                   vfile =  SearchFile(vFileResult).
                   if vfile eq ?
                   then do:
                     MSG = "Нет ответа от ИС МОТП. Не найден " + vFileResult.
                     putauth (MSG ).
                   end.
                   else do:
                      file-info:file-name = vfile .
                      if file-info:file-size = 0
                      then do :
                         MSG = "Нет ответа от ИС МОТП. Файл пустой " + vfile.
                         putauth ( MSG ).
                      end.
                      else do:
                         output to value (vfile) append .
                         put unformatted " " skip " _ ".
                             output close .
   
                             input from value (vfile) .
                             import unformatted vLine .
                             input close .
                             do ii = 1 to num-entries(vLine) :
                                vStr = entry(ii, vLine) .
                                vStr = trim(vStr) .
                                vStr = trim(vStr, "[") .
                        vStr = trim(vStr, "]") .
                        vStr = trim(vStr, chr(123)) .
                        vStr = trim(vStr, "}") .
                        if num-entries(vStr, '":"') < 2 then next .
   
                            if vStr begins '"token"'
                        then do :
                          vToken = trim(trim(substring(vStr, 9)), '"') .
                            end.
   
                            if vStr begins '"error_message"'
                        then do :
                          MSG = trim(trim(substring(vStr, 17)), '"').
                          putauth ( MSG ) .
                        end.
                        else do trans:
                          find first buf_ext-system-attr where buf_ext-system-attr.db-num   = esysDbNum
                                                           and buf_ext-system-attr.esys-id  = esysId
                                                           and buf_ext-system-attr.esya-attr-code = "AuthToken"
                          exclusive-lock no-error .
                          if not available buf_ext-system-attr
                          then do :
                            create buf_ext-system-attr.
                            assign
                              buf_ext-system-attr.db-num         = esysDbNum
                              buf_ext-system-attr.esys-id        = esysId
                              buf_ext-system-attr.esya-attr-code = "AuthToken"
                                .
                              end.
                              buf_ext-system-attr.esya-attr-value = vToken .
   
                              find first buf_ext-system-attr where buf_ext-system-attr.db-num   = esysDbNum
                                                               and buf_ext-system-attr.esys-id  = esysId
                                                               and buf_ext-system-attr.esya-attr-code = "AuthTokenDT"
                          exclusive-lock no-error .
                          if not available buf_ext-system-attr
                          then do :
                            create buf_ext-system-attr.
                            assign
                              buf_ext-system-attr.db-num         = esysDbNum
                              buf_ext-system-attr.esys-id        = esysId
                              buf_ext-system-attr.esya-attr-code = "AuthTokenDT"
                            .
                          end.
                          buf_ext-system-attr.esya-attr-value = string(datetime-tz(now)) .
                        end.
                     end.
                   end.
                 end.
               end.
             end.
             release object oSigner .
             release object oSignedData .
          end.
       end.
    end.
    release object oCert .
    
    if MSG <> ""
    then
       return error MSG .
    else do:
       StatusErr = no .
       return vToken .
    end.
      
  end method .
  
  method public character updateToken
  (
  input pToken as character
  ) :
    define variable cmd         as character no-undo .
    define variable cmdlog      as character no-undo .
    define variable vLine       as character no-undo .
    define variable vFileResult as character no-undo.
    define variable vFileResultErr as character no-undo.
    define variable VFile       as character no-undo.
    define variable vStr        as character no-undo.
    define variable vNewToken   as character no-undo.
    define variable vPath       as character no-undo.
    define variable ii          as integer no-undo .
    
    define buffer buf_ext-system-attr for ub.ext-system-attr .
    
    MSG = "".
    StatusErr = true.
    vPath = substring(server_, 1, (length(server_) - 8)) + "auth/login/refresh" .
    
    vFileResult    = "{&prefixfile}updateToken_db" + string(DB-num) + ".test".
    vFileResultErr = "{&prefixfile}updateToken_db" + string(DB-num) + ".err".
    cmd = substitute ('&1 -L -i --stderr &6 -H "Content-Type: application/json;charset=UTF-8" -H "Authorization: Bearer &4" &5 &3 >&2',
                      search ("exe/curl.exe"),
                      vFileResult,
                      vPath,
                      pToken,
                      CmdParamProxy,
                      vFileResultErr).
    cmdlog = substitute ('&1 -L -i --stderr &6 -H "Content-Type: application/json;charset=UTF-8" -H "Authorization: Bearer &4" &5 &3 >&2',
                      search ("exe/curl.exe"),
                      vFileResult,
                      vPath,
                      pToken,
                      CmdParamProxyLOG,
                      vFileResultErr).
    
    putauth (" command   " + cmdlog ) .
    os-command silent value (cmd).
    vfile =  SearchFile(vFileResult).
    if vfile eq ?
    then do:
      MSG = "Нет ответа от ИС МОТП. Не найден " + vFileResult.
      putauth (MSG ).
    end.
    else do:
      file-info:file-name = vfile .
      if file-info:file-size = 0
      then do :
        MSG = "Нет ответа от ИС МОТП. Файл пустой " + vfile.
        putauth ( MSG ).
      end.
      else do:
        output to value (vfile) append .
        put unformatted " " skip " _ ".
        output close .
     
        input from value (vfile) .
        import unformatted vLine .
        input close .
        do ii = 1 to num-entries(vLine) :
          vStr = entry(ii, vLine) .
          vStr = trim(vStr) .
          vStr = trim(vStr, "[") .
          vStr = trim(vStr, "]") .
          vStr = trim(vStr, chr(123)) .
          vStr = trim(vStr, "}") .
          if num-entries(vStr, '":"') < 2 then next .
           
          if vStr begins '"token"'
          then do :
            vNewToken = trim(trim(substring(vStr, 9)), '"') .
          end.
           
          if vStr begins '"error_message"'
          then do :
            MSG = trim(trim(substring(vStr, 17)), '"').
            putauth ( MSG ) .
          end.
          else do trans:
            find first buf_ext-system-attr where buf_ext-system-attr.db-num   = esysDbNum
                                             and buf_ext-system-attr.esys-id  = esysId
                                             and buf_ext-system-attr.esya-attr-code = "AuthToken"
            exclusive-lock no-error .
            if not available buf_ext-system-attr
            then do :
              create buf_ext-system-attr.
              assign
                buf_ext-system-attr.db-num         = esysDbNum
                buf_ext-system-attr.esys-id        = esysId
                buf_ext-system-attr.esya-attr-code = "AuthToken"
              .
            end.
            buf_ext-system-attr.esya-attr-value = vNewToken .
 
            find first buf_ext-system-attr where buf_ext-system-attr.db-num   = esysDbNum
                                             and buf_ext-system-attr.esys-id  = esysId
                                             and buf_ext-system-attr.esya-attr-code = "AuthTokenDT"
            exclusive-lock no-error .
            if not available buf_ext-system-attr
            then do :
              create buf_ext-system-attr.
              assign
                buf_ext-system-attr.db-num         = esysDbNum
                buf_ext-system-attr.esys-id        = esysId
                buf_ext-system-attr.esya-attr-code = "AuthTokenDT"
              .
            end.
            buf_ext-system-attr.esya-attr-value = string(datetime-tz(now)) .
          end.
        end.
      end.
    end.
    
    if MSG <> ""
    then
      return error MSG .
    else do:
      StatusErr = no .
      return vNewToken .
    end.
    
  end method .
  
  method public logical needTokenUpd ()
  :
    define buffer buf_ext-system-attr for ub.ext-system-attr .
    define variable vTokenDTdiff as datetime-tz no-undo .
    
    find first buf_ext-system-attr where buf_ext-system-attr.db-num   = esysDbNum
                                     and buf_ext-system-attr.esys-id  = esysId
                                     and buf_ext-system-attr.esya-attr-code = "AuthTokenDT"
    no-lock no-error .
    if not available buf_ext-system-attr
    then do :
      return false .
    end .
    
    vTokenDTdiff = datetime-tz(buf_ext-system-attr.esya-attr-value) + 21600000 .
    
    if vTokenDTdiff <= datetime-tz(now)
    then do :
      return true .
    end .
    else do :
      return false .
    end .
  
  end method .
  
  method public logical authTest
  (
  input pToken as character
  ) :
    
    define variable cmd         as character no-undo .
    define variable cmdlog      as character no-undo .
    define variable vLine       as character no-undo .
    define variable vHTTPstatus as character no-undo .
    define variable ii          as integer   no-undo .
    define variable tmpfile     as character no-undo .
    define variable tmpcmdfile  as character no-undo .
    define variable vFileResult as character no-undo.
    define variable vFileResultErr as character no-undo.
    
    StatusErr = true.
    tmpfile = "tmpmotp_db" + string(DB-num) + ".json" .
    output to value(tmpfile) .
      put unformatted  '~{"gtin":"00000046210654"}' skip .
    output close .
    
    putauthTest ( "  out-data:" ) .
    if isDebug
    then
      os-append value(tmpfile) value(mFileAuthTest) .
    
    vFileResult    = "{&prefixfile}AuthTest_db" + string(DB-num) + ".test".
    vFileResultErr = "{&prefixfile}AuthTest_db" + string(DB-num) + ".err".
    cmd = substitute ('&1 -i -d @&5 --stderr &7 -H "Content-Type: application/json" -H "Authorization: Bearer &4" &6 &3/cises/my >&2',
                      search ("exe/curl.exe"),
                      vFileResult,
                      server_,
                      pToken,
                      searchfile (tmpfile),
                      CmdParamProxy,
                      vFileResultErr).
    cmdlog = substitute ('&1 -i -d @&5 --stderr &7 -H "Content-Type: application/json" -H "Authorization: Bearer &4" &6 &3/cises/my >&2',
                      search ("exe/curl.exe"),
                      vFileResult,
                      server_,
                      pToken,
                      searchfile (tmpfile),
                      CmdParamProxyLOG,
                      vFileResultErr).
     
    putauthTest ( "command: " ).
    putauthTest ( cmdLOG   ).
    tmpcmdfile = "tmp_cmd_db" + string(DB-num) + ".bat".
    output to value(tmpcmdfile) .
    put unformatted cmd skip .
    output close .
    os-command silent value(tmpcmdfile) .
/*    os-command silent value(cmd). токен большой и не влезает в os-command*/
    define variable vfile as character no-undo.
    vfile =  SearchFile(vFileResult).
    if vfile eq ?
    then do:
       MSG = "Нет ответа от ИС МОТП. Не найден " + vFileResult.
       putauth (MSG ).
    end.
    else do:
       file-info:file-name = vfile .
       if file-info:file-size = 0
       then do :
          MSG = "Нет ответа от ИС МОТП. Файл пустой " + vfile.
          putauth ( MSG ).
       end.
       else do:
          putauthTest (" in-data:" ) .
    
          if isDebug
          then
            os-append value(vFileResult) value(mFileAuthTest) .
    
          output to value (searchfile(vFileResult)) append .
          put unformatted " " skip " _ ".
          output close .
    
          input from value (searchfile(vFileResult)) .
          import unformatted vLine .
          input close .
    
          HttpStatus = ? .
          assign vHTTPstatus = "unknown" .
          if vLine begins 'HTTP/2'
          then do :
            vHTTPstatus = trim(substring(vLine, 8)) .
            HttpStatus = integer(vHTTPstatus) .
          end.
          
          if vLine begins 'HTTP/1.1'
          then do :
            vHTTPstatus = trim(substring(vLine, 10,3)) .
            HttpStatus = integer(vHTTPstatus) .
          end.
          StatusErr = no.
          if HttpStatus = 401
          then do :
            MSG = "Токен авторизации в ИС МОТП - НЕ ДЕЙСТВИТЕЛЕН" .
            return false .
          end .
          else if HttpStatus = 502
          then do :
            MSG = "Невозможно определить валидность токена. Ответ от МОТП - 502 Bad Gateway. Пробуем работать с текущим" .
            return true .
          end .
          else do :
            MSG = "Токен авторизации в ИС МОТП - ДЕЙСТВИТЕЛЕН" .
            return true .
          end .
       end.
    end.
    
/*    if vHTTPstatus begins "20"                               */
/*    then do :                                                */
/*      MSG = "Токен авторизации в ИС МОТП - ДЕЙСТВИТЕЛЕН" .   */
/*      return true .                                          */
/*    end .                                                    */
/*    else do :                                                */
/*      MSG = "Токен авторизации в ИС МОТП - НЕ ДЕЙСТВИТЕЛЕН" .*/
/*      return false .                                         */
/*    end .                                                    */
    
  end method .
  
  method public logical sendEMail
  (
  input pMessage as character
  ) :
    
    define variable email as character no-undo .
    define variable ii as integer no-undo .
    
    do ii = 1 to num-entries(mail-list):
      email = trim(entry(ii, mail-list)).
      
      if email = ? or email = "" then next.
      
      run gbl/sendmail.p(
          email,
          "Ошибка авторизации в ИС МОТП",
          pMessage,
          ""
      ) no-error.
      
      if error-status:error
      then do :
        MSG = MSG + substitute("Ошибка при отправке на почту &1 - &2", email, return-value) + {&new-line} .
        StatusErr = true .
      end .    
    end.
    
  end method .
  
  define variable GrayZoneQnty  as integer no-undo .
  
  
  method public void cisesInfo
  (
  input pToken as character,
  input pDB-num as integer,
  input pDoc-id as integer,
  input pLevel2 as logical,
  output v-ok as logical
  ) :
    if pToken > ""
    then .
    else do :
       v-ok = no.
       MSG = "Запрос не выполнен. Нет токена для авторизации" .
       return.
    end.
    define variable cmd    as character no-undo .
    define variable cmdlog as character no-undo .
    define variable vLine as character no-undo .
    define variable vlongJson as longchar no-undo .
    define variable v-num-marks as integer no-undo .
    define variable vMark as character no-undo .
    
    define variable v-value-character     as character     no-undo .
    define variable v-value-decimal       as decimal       no-undo .
    define variable v-value-integer       as integer       no-undo .
    define variable v-value-logical       as logical       no-undo .
    define variable v-value-type          as character     no-undo .
    define variable v-value-date          as date          no-undo .
    
    define variable vRecKeyLine    as character no-undo .
    define variable vRecKeyUTDLine as character no-undo .
    define variable objKeyRec as class ibs.th.gbl.keyrec no-undo.
    
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_utd-lines for ub.utd-lines .
    define buffer buf_marking for ub.marking .
    define buffer buf_marking-parent for ub.marking .
    define buffer buf_utd-err for ub.utd-err .
    define buffer buf_utd for ub.utd .
    
    
    
    if not checkINN
    and lastLineCisInfo = 0
    then do :
      for each buf_utd-err exclusive-lock where buf_utd-err.db-num = pDB-num
                                            and buf_utd-err.doc-id = pDoc-id
                                            and buf_utd-err.CheckType = "CheckMOTP"
                                            and buf_utd-err.CodeErr = "MotpMarkErr"
                                            :
        delete buf_utd-err .                                      
      end .
    end .
    
    GrayZoneQnty = 100 .
    
    find first buf_utd no-lock where buf_utd.db-num = pDB-num
                                 and buf_utd.doc-id = pDoc-id
                                 .
                                 
    run adm/shattri.p (
      input "get":U
      ,input buf_utd.obj-type
      ,input buf_utd.obj-code
      ,input {&attr-marking}
      ,input "gray_zone_qnty"
      ,output v-value-character
      ,output v-value-date
      ,output v-value-decimal
      ,output v-value-integer
      ,output v-value-logical
      ,output v-value-type
      ,input-output TABLE thbjattr_thbj-attr
      ) no-error .
    if v-value-integer <> ?
    then
      GrayZoneQnty = v-value-integer
    .                             
      
    objKeyRec = new ibs.th.gbl.keyrec().
    v-ok = true .
    v-num-marks = 0 .
    define variable vfilereq as character no-undo.
    vfilereq = "{&prefixfile}cisesInfoReq_db" + string(DB-num) + ".json".
    os-delete value (searchFile(vfilereq)) no-error .
    if searchFile(vfilereq) = ?
    then do : end .
    else do :
      v-ok = false .
      Msg = "Запрос не выполнен! Не могу удалить файл-запрос " + vfilereq .
      return .
    end .
    output to value(vfilereq) .
    put unformatted "[" skip .
    lines_:
    for each buf_utd-lines no-lock where buf_utd-lines.db-num = pDB-num
                                     and buf_utd-lines.doc-id = pDoc-id
                                     and buf_utd-lines.LineNum >= lastLineCisInfo
                                     break by buf_utd-lines.LineNum
                                     :
      objKeyRec:GenKeyRec ( input "utd-lines"
                            ,input buffer buf_utd-lines:handle
                            ,output vRecKeyLine).
      vRecKeyUTDLine = replace(vRecKeyLine,"utd-lines","utd-marking-lines") + {&delim-key}. 
      
      if can-find (first buf_utd-err no-lock where buf_utd-err.doc-id = buf_utd-lines.doc-id
                                               and buf_utd-err.db-num = buf_utd-lines.db-num
                                               and buf_utd-err.reckey = vRecKeyLine)
      then next lines_ .
      else
      if can-find (first buf_utd-err no-lock where buf_utd-err.doc-id = buf_utd-lines.doc-id
                                               and buf_utd-err.db-num = buf_utd-lines.db-num
                                               and buf_utd-err.reckey begins vRecKeyUTDLine)
      then next lines_ . 
            
      
      marks_:
      for each buf_utd-marking-lines no-lock where buf_utd-marking-lines.db-num = buf_utd-lines.db-num
                                               and buf_utd-marking-lines.doc-id = buf_utd-lines.doc-id
                                               and buf_utd-marking-lines.LineNum = buf_utd-lines.LineNum,
      first buf_marking no-lock where buf_marking.mark = buf_utd-marking-lines.mark
                                               break by  buf_utd-marking-lines.doc-id :
        if v-num-marks = 999
        then do :
          lastLineCisInfo = buf_utd-lines.LineNum .
          leave lines_ .
        end .
        if pLevel2 and buf_marking.unit-ext <> "LEVEL2" then next marks_ .
        if not pLevel2 and buf_marking.unit-ext = "LEVEL2" then next marks_ .
        if checkINN and buf_marking.sts = objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB then next marks_ .
        if buf_marking.unit-ext = "UNIT"
        then do :
          find first buf_marking-parent no-lock where buf_marking-parent.mark = buf_marking.mark-parent
                                                  and (buf_marking-parent.sts  = objSrv:Env:Marking:Sts:Mark:CheckContr:KeyIntDB
                                                     or buf_marking-parent.sts = objSrv:Env:Marking:Sts:Mark:DeliveryControl:KeyIntDB)
                                                  no-error .
          if available buf_marking-parent then next marks_ .                                        
        end .
        vMark = GetCodeIdent(buf_utd-marking-lines.mark) .
        vMark = replace(vMark, '\', '\\') .
        vMark = replace(vMark, '/', '\/') .
        vMark = replace(vMark, '"', '\"') .
        put unformatted '"' vMark '"' .
        v-num-marks = v-num-marks + 1 .
        put unformatted ',' skip .
      end .
    end .
    put unformatted '""' skip .
    put unformatted skip "]" skip.
    output close .
    
    delete object objKeyRec.
    
    if v-num-marks <> 999 then lastLineCisInfo = 0 .
    
    putcisesInfo (vfilereq + " (out-data):" ) .
    if isDebug
    then
      os-append value(vfilereq) value(mFilecisesInfo) .
    define variable vCmdToken as character no-undo.
    if pToken > ""
    then
       vCmdToken = substitute (' -H "Authorization: Bearer &1"',pToken).
    define variable vfileresult as character no-undo.
    define variable vfileresulterr as character no-undo.
    vfileresult    = "{&prefixfile}cisesInfoResp_db" + string(DB-num) + ".json".
    vfileresulterr = "{&prefixfile}cisesInfoResp_db" + string(DB-num) + ".err".
    
    os-delete value (searchFile(vfileresult)) no-error .
    if searchFile(vfileresult) = ?
    then do : end .
    else do :
      v-ok = false .
      Msg = "Запрос не выполнен! Не могу удалить файл-ответ " + vfileresult .
      return .
    end .
    
    cmd = substitute ('&1 -H "Content-Type: application/json" &5 &6 -d @&4 --stderr &7 &3/cises/info >&2',
                      search ("exe/curl.exe"),
                      vfileresult,
                      server_,
                      searchfile (vfilereq),
                      vCmdToken,
                      CmdParamProxy,
                      vfileresulterr). 
    cmdlog = substitute ('&1 -H "Content-Type: application/json" &5 &6 -d @&4 --stderr &7 &3/cises/info >&2',
                      search ("exe/curl.exe"),
                      vfileresult,
                      server_,
                      searchfile (vfilereq),
                      vCmdToken,
                      CmdParamProxylog,
                      vfileresulterr).               
     
    
    
    putcisesInfo (" command:" ).
    putcisesInfo ( cmdlog ) .
    
    output to tmp-cmd.bat .
    put unformatted cmd skip .
    output close .
    os-command silent tmp-cmd.bat .
    
/*    os-command silent value(cmd). так нельзя делать такак токен большой и не влизает в команду*/
/*    input from value (search("cisesInfoResp_.json")) .*/
/*    import unformatted vLine .                        */
/*    input close .                                     */

    if searchFile(vfileresult) = ?
    then do :
      v-ok = false .
      MSG = "Запрос не выполнен! Нет ответа от МОТП. Не могу найти файл " + search(vfileresult) .
      return .
    end .
    file-info:file-name = searchFile(vfileresult) .
    if file-info:file-size = 0
    then do :
      v-ok = false .
      MSG = "Запрос не выполнен! Файл-ответ из МОТП " + search(vfileresult) + " пустой (размер 0 байт)." .
      return .
    end .

    copy-lob from file vfileresult to vlongJson .
    vlongJson = replace(vlongJson, "&", "&amp;") .
    vlongJson = replace(vlongJson, "<", "&lt;") .
    vlongJson = replace(vlongJson, ">", "&gt;") .
    vlongJson = replace(vlongJson, ':null', ':""') .
    copy-lob from vlongJson to file vfileresult .
    
    putcisesInfo ( vfileresult + " (in-data):") .
    if isDebug
    then
      os-append value(vfileresult) value(mFilecisesInfo) .
    define variable vfileresultxml as character no-undo.
    vfileresultxml = "{&prefixfile}cisesInfoResp_db" + string(DB-num) + ".xml".
    
    os-delete value (searchFile(vfileresultxml)) no-error .
    if searchFile(vfileresultxml) = ?
    then do : end .
    else do :
      v-ok = false .
      Msg = "Запрос не выполнен! Не могу удалить сконвертированный в xml файл-ответ " + vfileresultxml .
      return .
    end .
    
    cmd = substitute ('&1 -file=&2 >&3',
                       search("exe/json2xml.exe"),
                       searchfile(vfileresult),
                       vfileresultxml
                       ) .
    os-command silent value (cmd). 
    
    file-info:file-name = search(vfileresultxml) .
    if file-info:file-size = 0
    then do :
      v-ok = false .
      MSG = "Запрос не выполнен! Ошибка при конвертации json в XML. Файл " + search(vfileresultxml) + " пустой (размер 0 байт)." .
      return .
    end .
    
    empty temp-table tt-childs .
    
    Doc-Id = pDoc-id .
    docdb-num = pDB-num .
    
/*    for each buf_utd-err exclusive-lock where buf_utd-err.db-num = docdb-num     */
/*                                          and buf_utd-err.doc-id = Doc-Id        */
/*                                          and buf_utd-err.CheckType = "CheckMOTP"*/
/*                                          and buf_utd-err.CodeErr = "MotpMarkErr"*/
/*                                          :                                      */
/*      delete buf_utd-err .                                                       */
/*    end .                                                                        */
    
    ParseResponseInfoCises(searchfile(vfileresultxml)) .   
    
    Doc-Id = ? .
    docdb-num = ? .
    
    if Msg = "empty_file"
    then do :
      v-ok = false .
      MSG = "Запрос не выполнен! Файл " + search(vfileresultxml) + " пустой (размер 0 байт)." .
      return .
    end .
    
    if BadAuth
    then do :
      v-ok = false .
      MSG = "Запрос не выполнен! Авторизация не пройдена. Попробуйте запросить новый токен." .
      return .
    end .
                  
  
  end method .  
  
  define variable v-cis as character no-undo .
  define variable v-cis-child as character no-undo .
  define variable v-unit as character no-undo .
  define variable v-unit-child as character no-undo .
  define variable v-gtin as character no-undo .
  define variable v-num-childs as integer no-undo .
  define variable v-err-childs as logical no-undo .
  define variable v-gray-zone  as logical no-undo .
  
  method private void ParseResponseInfoCises(inFileName as char):
    define variable hDoc  as handle no-undo .
    define variable hRoot as handle no-undo .
                
    create x-document hDoc.
    create x-noderef hRoot.
           
    hDoc:load("file", inFileName, false) no-error.
    if inFileName = ? then 
    do:
      Msg = "empty_file" .   
      return .   
    end.  
    
    INNchecked = false .
    BadAuth = false .
           
    hDoc:get-document-element(hRoot).
            
    GetChildrenInfoCises(hRoot, 1).
        
    delete object hDoc.
    delete object hRoot.
            
    
  end.
    
  method private void GetChildrenInfoCises(hParent as handle, level as integer):
        
    define variable i           as integer no-undo .
    define variable hNoderef    as handle  no-undo .
    define variable hText       as handle  no-undo .
    define variable tt          as integer no-undo .
    define variable good        as logical   no-undo .
    define variable v-item      as character no-undo .
    define variable v-err-code  as integer no-undo .
    define variable v-text      as character no-undo .
    
    tt = hParent:num-children no-error .    
    if tt = ? then 
    do:
      Msg = "Ошибка запроса. См. в файле ответа" .
      return .
    end.

    create x-noderef hNoderef.
    create x-noderef hText .
        
    repeat i = 1 to hParent:num-children:
      good = hParent:get-child(hNoderef,i).
      if not good
      then leave .
      
      if hNoderef:name = "cisinfo" then 
      do:
        assign
          v-num-childs = 0
          v-err-childs = false
          v-gray-zone  = false
          v-err-code   = 0
          v-item       = ""
          v-cis        = ""
          v-gtin       = ""
          v-cis-child  = ""
          v-unit       = ""
          v-unit-child = ""
        .
      end .
      
      if hNoderef:subtype <> "element" then
        next.
            
      hNoderef:get-child(hText, 1) no-error . 
      assign
        v-text = hText:node-value
      no-error .   
      if v-text = ""
      or v-text = ?
      then next .
      
/*      IF hNoderef:NAME = "cisifo" THEN*/
/*      DO:                             */
/*        empty temp-table tt-childs .  */
/*      END.                            */
      
      if hNoderef:name = "child" then 
      do:
        assign
          v-cis-child = hText:node-value
        no-error .
        v-cis-child = repSpecSimbforDm(v-cis-child) .
        v-cis-child = replace(v-cis-child, '\\', '\') .
        v-cis-child = replace(v-cis-child, '\/', '/') .
        v-cis-child = replace(v-cis-child, '\"', '"') .
        create tt-childs .
        assign tt-childs.mark    = v-cis-child .
        assign tt-childs.parent_ = "temp" .
      end .
      
      if hNoderef:name = "gtin" then 
      do:
        v-item = "gtin" .
        v-gtin = hText:node-value no-error .
      end .
            
      if hNoderef:name = "cis" then 
      do:
        v-item = "cis" .
        v-unit = "" .
        v-unit-child = "" .
        MSG = "" .
        assign
          v-cis = hText:node-value
        no-error .
        v-cis = repSpecSimbforDm(v-cis) .
        v-cis = replace(v-cis, '\\', '\') .
        v-cis = replace(v-cis, '\/', '/') .
        v-cis = replace(v-cis, '\"', '"') .
        if trim(v-cis) = "" or v-cis = ? then next .
        for each tt-childs exclusive-lock where tt-childs.parent_ = "temp" :
          assign tt-childs.parent_ = v-cis .
        end.
      end .
      
      if hNoderef:name = "packageType" then 
      do:
        v-item = "packageType" .
        assign v-unit = hText:node-value no-error .
        case v-unit :
          when "LEVEL1" then v-unit-child = "UNIT" .
          when "LEVEL2" then v-unit-child = "LEVEL1" .
          when "LEVEL3" then v-unit-child = "LEVEL2" .
          when "LEVEL4" then v-unit-child = "LEVEL3" .
          when "LEVEL5" then v-unit-child = "LEVEL4" .
        end case .
      end .
      
      if hNoderef:name = "ownerinn"
      and checkINN
      and INN > ""
      then do :
        v-item = "ownerinn" .
        INNchecked = false .
        if INN = hText:node-value
        then do :
          INNchecked = true .
          updateUtdStatus(input docDB-num, input Doc-Id, input ObjSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB) .
          return .
        end .
      end .
      
      if hNoderef:name = "status"
      and trim(v-cis) > ""
      then do:
        for each tt-childs no-lock where tt-childs.parent_ = v-cis :
          assign v-num-childs = v-num-childs + 1 .
        end .
        
        if v-unit = "LEVEL2"
        then do :
          if isFirstEnter
          then do :
            if v-num-childs <> 50 then v-err-childs = true .
          end .
          else do :
            if v-num-childs <> 50 and GrayZoneQnty <> 100
            then do:
              if (50 - v-num-childs) <= GrayZoneQnty
              then v-gray-zone = true .
              else v-err-childs = true .
            end .
          end .
          if v-err-childs
          then do :
            MSG = "В коробе " + string(v-num-childs) + " блоков." .
          end.
        end .
        
        if v-unit = "LEVEL1"
        then do :
          if isFirstEnter
          then do :
            if v-num-childs <> 10 then v-err-childs = true .
          end .
          else do :
            if v-num-childs <> 10 and GrayZoneQnty <> 100
            then do:
              if (10 - v-num-childs) <= GrayZoneQnty
              then v-gray-zone = true .
              else v-err-childs = true .
            end .
          end .
          if v-err-childs
          then do :
            MSG = "В блоке " + string(v-num-childs) + " пачек." .
          end.
        end .
        
        
        if isFirstEnter
        then do :
          if hText:node-value = "DISAGGREGATED"
          and v-unit = "LEVEL1"
          then do :
            UpdateMark(v-cis,
                       if isFirstEnter then objSrv:Env:Marking:Sts:Mark:Ungrouped:KeyIntDB else objSrv:Env:Marking:Sts:Mark:CheckContr:KeyIntDB,
                       "",
                       v-unit,
                       v-gtin,
                       hText:node-value) .
            for each tt-childs no-lock where tt-childs.parent_ = v-cis :
              UpdateMark(tt-childs.mark,
                         if isFirstEnter then objSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB else objSrv:Env:Marking:Sts:Mark:CheckContr:KeyIntDB,
                         v-cis,
                         v-unit-child,
                         v-gtin,
                         hText:node-value) .
            end .
          end .
          else do :
            if v-err-childs
            then do :
              UpdateMark(v-cis,
                         objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB,
                         "",
                         v-unit,
                         v-gtin,
                         hText:node-value) .
            end .
            else do :
              UpdateMark(v-cis,
                         objSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB,
                         "",
                         v-unit,
                         v-gtin,
                         hText:node-value) .
            end .
            for each tt-childs no-lock where tt-childs.parent_ = v-cis :
              UpdateMark(tt-childs.mark,
                         objSrv:Env:Marking:Sts:Mark:Checked_:KeyIntDB,
                         v-cis,
                         v-unit-child,
                         v-gtin,
                         hText:node-value) .
            end .
          end .
        end .
        else do :
          case hText:node-value :
            when "APPLIED" or
            when "INTRODUCED" or
            when "INTRODUCED_RETURNED"
            then do :
              if v-err-childs
              then do :
                UpdateMark(v-cis,
                           objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB,
                           "",
                           v-unit,
                           v-gtin,
                           hText:node-value) .
              end .
              else
              if v-gray-zone
              then do :
                UpdateMark(v-cis,
                           objSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB,
                           "",
                           v-unit,
                           v-gtin,
                           hText:node-value) .
              end .
              else do :
                UpdateMark(v-cis,
                           objSrv:Env:Marking:Sts:Mark:CheckContr:KeyIntDB,
                           "",
                           v-unit,
                           v-gtin,
                           hText:node-value) .
              end .
              for each tt-childs no-lock where tt-childs.parent_ = v-cis :
                UpdateMark(tt-childs.mark,
                           objSrv:Env:Marking:Sts:Mark:CheckContr:KeyIntDB,
                           v-cis,
                           v-unit-child,
                           v-gtin,
                           hText:node-value) .
              end .
            end .
            otherwise do :
              MSG = "Статус марки в МОТП - " + hText:node-value .
              UpdateMark(v-cis, objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB, "", v-unit, v-gtin, hText:node-value) .
              for each tt-childs no-lock where tt-childs.parent_ = v-cis :
                UpdateMark(tt-childs.mark, objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB, v-cis, v-unit-child, v-gtin, hText:node-value) .
              end .
            end .
          end case .
        end .
      end .
      
      if hNoderef:name = "errormessage" then 
      do:
        if trim(v-cis) = ""
        or v-cis = ?
        then next .
        v-item = "errormessage" .
        MSG = hText:node-value .
        if v-err-code = 404
        then do :
          UpdateMark(v-cis, objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB, "", v-unit, v-gtin, "") .
        end .
      end .
      
      if hNoderef:name = "errorCode" then 
      do:
        BadAuth = false .
        if integer(hText:node-value) = 401
        then do :
          BadAuth = true .
          return .
        end .
        if trim(v-cis) = ""
        or v-cis = ?
        then next .
        v-item = "errorCode" .
        v-err-code = integer(hText:node-value) no-error .
      end .
      
      if hNoderef:name = "error_message" then 
      do:
        if hText:node-value = "Для доступа к этому ресурсу требуется полная аутентификация"
        then do :
          BadAuth = true .
          return .
        end .
      end .
      
      if INNchecked then return .
      if BadAuth then return .
      
      GetChildrenInfoCises(hNoderef, (level + 1)) .
      
      if INNchecked then return .
      if BadAuth then return .
      
    end.
        
    delete object hNoderef.
    delete object hText.
  end method .
  
  method private void UpdateMark
  (
  input pMark as character,
  input pSts as integer,
  input pParent as character,
  input pUnit as character,
  input pGtin as character,
  input pMOTPsts as character
  ) :
    
    define buffer buf_utd for ub.utd .
    define buffer buf_marking for ub.marking .
    define buffer buf_marking-attr for ub.marking-attr .
    define buffer buf_marking-parent for ub.marking .
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    define buffer buf_utd-marking-lines-parent for ub.utd-marking-lines .
    
    define buffer buf_prod-bc for ub.prod-bc .
    define buffer buf_bar-code for ub.bar-code .
    define variable v-found-bc as logical no-undo .
    define variable vGtin as character no-undo .
    
    if checkINN then return .
    
    if pMark = ?
    or trim(pMark) = ""
    then return .
    
    find first buf_utd no-lock where buf_utd.db-num = docDB-num
                                 and buf_utd.doc-id = Doc-id
                                 no-error .
    
    find first buf_marking exclusive-lock where buf_marking.mark begins pMark no-error .
    if not available buf_marking
    then do :
      find first buf_marking-parent no-lock where buf_marking-parent.mark begins pParent and pParent <> "" no-error .
      create buf_marking .
      assign
        buf_marking.mark = pMark
        buf_marking.unit-ext = pUnit when pUnit <> ""
      .
      if available buf_utd
      then
      assign
        buf_marking.obj-type = buf_utd.obj-type
        buf_marking.obj-code = buf_utd.obj-code
      .
      case pUnit :
        when "UNIT" then assign buf_marking.box-qnty = 1 .
        when "LEVEL1" then assign buf_marking.box-qnty = 10 .
        when "LEVEL2" then assign buf_marking.box-qnty = 500 .
      end case .
      if available buf_marking-parent
      then do :
        assign
          buf_marking.mark-parent = buf_marking-parent.mark
          buf_marking.gds-code    = buf_marking-parent.gds-code
          buf_marking.gds-ext-id  = buf_marking-parent.gds-ext-id
        .
      end .
    end . 
    assign
      buf_marking.sts = pSts
      buf_marking.unit-ext = pUnit when pUnit <> ""
    .
    assign
      buf_marking.box-qnty = 500 when pUnit = "LEVEL2"
      buf_marking.box-qnty = 10 when pUnit = "LEVEL1"
      buf_marking.box-qnty = 1 when pUnit = "UNIT"
    .
    
    find first buf_marking-parent no-lock where buf_marking-parent.mark = buf_marking.mark-parent and buf_marking.mark-parent <> "" no-error .
    if available buf_marking-parent
    then do :
      assign
        buf_marking.gds-code    = buf_marking-parent.gds-code
      .
    end .
    
    if pMOTPsts > ""
    then do :
      find first buf_marking-attr exclusive-lock where buf_marking-attr.mark = buf_marking.mark
                                                   and buf_marking-attr.attr-code = "MOTPsts"
                                                   no-error .
      if not available buf_marking-attr
      then do :
        create buf_marking-attr .
        assign
          buf_marking-attr.mark = buf_marking.mark
          buf_marking-attr.attr-code = "MOTPsts"
        .
      end .                  
      assign
        buf_marking-attr.attr-value = pMOTPsts
      .
    end .
/*
    if buf_marking.gds-ext-id <> pGtin
    then do :
      assign
        buf_marking.sts = objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB
        buf_marking.comment = "GTIN в марке не совпадает с GTIN'ом, который вернула ИС МОТП."
      .
    end .
*/
    
    if trim(pGtin) > ""
    and buf_marking.gds-code <> ?
    and buf_marking.gds-code <> 0
    then do :
      if buf_marking.unit-ext = "UNIT"
      then do :
        assign
          v-found-bc = false .
        .
        for each buf_bar-code no-lock where buf_bar-code.gds-code = buf_marking.gds-code,
        each buf_prod-bc no-lock where buf_prod-bc.b-code = buf_bar-code.b-code
                                   and buf_prod-bc.b-str  = pGtin
                                   :
          assign
            v-found-bc = true .
          .
          leave .
        end .
        if not v-found-bc
        then do :
          run utl/upd-gtin.p (input docDB-num,
                              input buf_marking.gds-code,
                              input pGtin,
                              input (docDB-num = gbl-var:g#db-num))
                              no-error .
          if error-status:error
          then do :
            
          end .
        end .
      end . /* unit */ 
      if buf_marking.unit-ext = "LEVEL1"
      then do :
        assign
          v-found-bc = false .
        .
        vGtin = getGtinByDM(buf_marking.mark) .
        find first buf_bar-code no-lock where buf_bar-code.gds-code = buf_marking.gds-code
                                          and buf_bar-code.cli-base-rate = 10
                                          no-error .
        if available buf_bar-code
        then do :                                  
          for each buf_prod-bc no-lock where buf_prod-bc.b-code = buf_bar-code.b-code
                                         and buf_prod-bc.b-str  = vGtin :
            assign
              v-found-bc = true .
            .
            leave .
          end .
          if not v-found-bc
          then do :
            run utl/upd-gtin.p (input docDB-num,
                                input buf_bar-code.b-code,
                                input vGtin,
                                input (docDB-num = gbl-var:g#db-num))
                                no-error .
            if error-status:error
            then do :
              
            end .
          end .
        end . /* available buf_bar-code */
      end .     
    end .    
     
    if pSts = objSrv:Env:Marking:Sts:Mark:MarkError:KeyIntDB
    then do :
      assign buf_marking.comment = MSG .
      AddUtdErr(buf_utd.db-num,
                buf_utd.doc-id,
                buffer buf_marking:handle,
                "CheckMOTP",
                "MotpMarkErr",
                (buf_marking.mark + {&delim-par} + MSG)).
       /*для первоначального ввода, если блок в статусе ошибка присваивать ему статус серая зона*/         
       if buf_marking.unit-ext <> "UNIT" and buf_utd.EDocType = objSrv:Env:Utd:EDocType:Introduce:KeyIntDB then 
       do:
          assign
          buf_marking.sts = objSrv:Env:Marking:Sts:Mark:GrayZone:KeyIntDB.
/*          buf_marking.unit-ext = getLevelMotpByCodId(buf_marking.mark) .*/
          buf_marking.box-qnty = getQntyUTDByCodId(buf_marking.mark) .
          buf_marking.unit = getLevelUTDByCodId(buf_marking.mark) .
       end.
    end .
    
    if pParent <> ""
    then do :
      find first buf_utd-marking-lines exclusive-lock where buf_utd-marking-lines.mark begins pMark
                                                        and buf_utd-marking-lines.db-num = docDB-num
                                                        and buf_utd-marking-lines.doc-id = Doc-Id no-error .
      if not available buf_utd-marking-lines
      then do :
        find first buf_utd-marking-lines-parent no-lock where buf_utd-marking-lines-parent.mark begins pParent
                                                      and buf_utd-marking-lines-parent.db-num = docDB-num
                                                      and buf_utd-marking-lines-parent.doc-id = Doc-Id no-error .
        create buf_utd-marking-lines .
        if available buf_utd-marking-lines-parent
        then do :
          buffer-copy buf_utd-marking-lines-parent to buf_utd-marking-lines
          assign
            buf_utd-marking-lines.mark = pMark
            buf_utd-marking-lines.doc-level = buf_utd-marking-lines-parent.doc-level + 1
          .
        end .
        else do :
          assign
            buf_utd-marking-lines.mark = pMark
            buf_utd-marking-lines.db-num = docDB-num
            buf_utd-marking-lines.doc-id = Doc-Id
            buf_utd-marking-lines.doc-level = 1
          .
        end .
      end . 
    end .
    
  end method .
  
  method public logical CheckStatus
  (
  input pDb-num as integer,
  input pDoc-id as integer
  ) :
    
    define buffer buf_utd for ub.utd .
    define buffer buf_marking for ub.marking .
    define buffer buf_utd-marking-lines for ub.utd-marking-lines .
    
/*    define variable v-comment as character no-undo .*/
    define variable v-ok      as logical no-undo .
    define variable v-not-checked as logical no-undo .
    
    assign v-not-checked = false .
    for each buf_utd-marking-lines no-lock where  buf_utd-marking-lines.db-num = pDb-num
                                              and buf_utd-marking-lines.doc-id = pDoc-id,
    first buf_marking no-lock where buf_marking.mark = buf_utd-marking-lines.mark :
      if buf_marking.sts = objSrv:Env:Marking:Sts:Mark:PendingVerification:KeyIntDB
      then do :
        assign v-not-checked = true .
        leave .
      end .                                     
    end .
    
    if v-not-checked then return false .
    
    assign v-ok = true .
    for each buf_utd-marking-lines no-lock where  buf_utd-marking-lines.db-num = pDb-num
                                              and buf_utd-marking-lines.doc-id = pDoc-id,
    first buf_marking no-lock where buf_marking.mark = buf_utd-marking-lines.mark :
      if buf_marking.sts <> objSrv:Env:Marking:Sts:Mark:CheckContr:KeyIntDB
      then do :
        assign v-ok = false .
        leave .
      end .                                     
    end . 
    
    if not v-ok
    then do :                                      
      for first buf_utd exclusive-lock where buf_utd.db-num = pDb-num
                                         and buf_utd.doc-id = pDoc-id :
        assign
          buf_utd.sts = objSrv:Env:Utd:Sts:TH:LackOfMarkingCodesInCirculation:KeyIntDB
        .
      end.
    end .
    else do :
      for first buf_utd exclusive-lock where buf_utd.db-num = pDb-num
                                         and buf_utd.doc-id = pDoc-id :
        assign
          buf_utd.sts = objSrv:Env:Utd:Sts:TH:VerificationPassed:KeyIntDB
        .
      end.
    end .
    
    return true .
    
  end method .
  
  method public void CheckSpec
  (
  input pDb-num as integer,
  input pDoc-id as integer
  ) :
    
    run utl/utd-checkSpec.p (input pDb-num,
                             input pDoc-id) .
    
  end method .
  
  method public void checkUtd
  (
  input pToken  as character,
  input pDb-num as integer,
  input pDoc-id as integer
  ) :
    define buffer buf_utd for ub.utd .
    define buffer buf_utd-attr for ub.utd-attr .
    
    define variable v-ok            as logical no-undo .
    define variable cmd             as character no-undo .
    define variable v-out-file-name as character no-undo .
    define variable v-out-file-name-err as character no-undo .
    define variable v-doc-code      as character no-undo .
    
    Doc-Id = pDoc-id .
    db-num = pDB-num .
    
    assign v-ok = true .
    find first buf_utd no-lock where buf_utd.db-num = pDb-num
                                 and buf_utd.doc-id = pDoc-id
                                 no-error .
    if not available buf_utd
    then do :
      MSG = "Не найден УПД в БД " + string(pDb-num) + " c doc-id " + string(pDoc-id) .
      return error MSG .
    end. 
    
    v-doc-code = buf_utd.DocumentExt .
    for first buf_utd-attr no-lock where buf_utd-attr.db-num    = buf_utd.db-num
                                     and buf_utd-attr.doc-id    = buf_utd.doc-id
                                     and buf_utd-attr.attr-code = "FileName"
                                     and buf_utd-attr.attr-value > ""
                                     :
      v-doc-code = buf_utd-attr.attr-value .                               
    end .
    
    v-out-file-name     = substitute("{&prefixfile}docinfo_&1.json", buf_utd.DocumentNumber) .
    v-out-file-name-err = substitute("{&prefixfile}docinfo_&1.err", buf_utd.DocumentNumber) .
    cmd = substitute ('&1 -H "Authorization: Bearer &5" &6 --stderr &7 &3/documents/&4/info >&2',
                      search ("exe/curl.exe"),
                      v-out-file-name,
                      server_,
                      v-doc-code,
                      pToken,
                      CmdParamProxy,
                      v-out-file-name-err).
    /* 
    output to tmp-cmd.bat .
    put unformatted cmd skip .
    output close .
    os-command silent tmp-cmd.bat .
    */
    os-command silent value(cmd).
    define variable vfile as character no-undo.
    vfile =  SearchFile(v-out-file-name).
    if vfile eq ?
    then do:
       MSG = "Нет ответа от ИС МОТП. Не найден " + v-out-file-name.
       putauth (MSG ).
    end.
    else do:
       file-info:file-name = vfile .
       if file-info:file-size = 0
       then do :
          MSG = "Нет ответа от ИС МОТП. Файл пустой " + vfile.
          putauth ( MSG ).
       end.
       else do:
          cmd = substitute ('&1 -file=&2 >&3',
                             search("exe/json2xml.exe"),
                             vfile,
                             ("{&prefixfile}" + buf_utd.DocumentNumber + ".xml")
                             ) .
          os-command silent value (cmd).
          
          ParseResponseInfoDoc(input ("{&prefixfile}" + buf_utd.DocumentNumber + ".xml")) .
       end.
    end.
  
  end method .
  
  method private void ParseResponseInfoDoc(inFileName as char):
    define variable hDoc  as handle no-undo .
    define variable hRoot as handle no-undo .
                
    create x-document hDoc.
    create x-noderef hRoot.
           
    hDoc:load("file", inFileName, false) no-error.
    if inFileName = ? then 
    do:
      Msg = "Файл не найден" .   
      return .   
    end.  
           
    hDoc:get-document-element(hRoot).
            
    GetChildrenInfoDoc(hRoot, 1).
        
    delete object hDoc.
    delete object hRoot.
            
    
  end.
    
  method private void GetChildrenInfoDoc(hParent as handle, level as integer):
        
    define variable i           as integer no-undo .
    define variable hNoderef    as handle  no-undo .
    define variable hText       as handle  no-undo .
    define variable tt          as integer no-undo .
    define variable good        as logical   no-undo .
    define variable v-item      as character no-undo .
    
    
    tt = hParent:num-children no-error .    
    if tt = ? then 
    do:
      Msg = "Ошибка запроса. См. в файле ответа" .
      return.
    end.
/*    run gbl/inidebug.p.*/
    create x-noderef hNoderef.
    create x-noderef hText .
        
    repeat i = 1 to hParent:num-children:
      good = hParent:get-child(hNoderef,i).
      if not good
      then leave .
      if hNoderef:subtype <> "element" then
        next.
            
      hNoderef:get-child(hText, 1) no-error .    
    
      if hNoderef:name = "status" then 
      do:
        case hText:node-value :
          when "CHECKED_OK"
          then do :
            updateUtdStatus(input DB-num, input Doc-Id, input ObjSrv:Env:Utd:Sts:TH:Confirmed:KeyIntDB) .
          end .
          otherwise do :
            
          end .
        end case .
      end .
      
      if hNoderef:name = "errormessage" then 
      do:
        if trim(v-cis) = "" then next .
        v-item = "errormessage" .
        MSG = hText:node-value .
      end .
      
      GetChildrenInfoDoc(hNoderef, (level + 1)).

    end.
        
    delete object hNoderef.
    delete object hText.
  end method .
  
  method private logical updateUtdStatus
  (
  input pDb-num as integer,
  input pDoc-id as integer,
  input pSts    as integer
  ) :
    define variable p-ok as logical no-undo .
    define buffer buf_utd for ub.utd .
    
    assign p-ok = false .
    for first buf_utd exclusive-lock where buf_utd.db-num   = pDb-num
                                       and buf_utd.doc-id   = pDoc-id
                                       :
      assign
        buf_utd.sts = pSts
        p-ok = true
      .                                   
    end .
    
    return p-ok .
    
  end method .
  define stream cades .
  define stream auth .
  define stream authtest .
  define stream cisesInfo .
  method public void putauth(input itext as character):
    if not isDebug then return .
    output stream auth to value (mFileauth) append .
    put stream auth unformatted now " " itext skip .
    output stream auth close .
  end.
  method public void putcades(input itext as character):
    if not isDebug then return .
    output stream cades to value (mFileCades) append .
    put stream cades unformatted now " " itext skip .
    output stream cades close .
  end.
  method public void putauthtest(input itext as character):
    if not isDebug then return .
    output stream authtest to value (mFileauthtest) append .
    put stream authtest unformatted now " " itext skip .
    output stream authtest close .
  end.
  method public void putcisesInfo(input itext as character):
    if not isDebug then return .
    output stream cisesInfo to value (mFilecisesInfo) append .
    put stream cisesInfo unformatted now " " itext skip .
    output stream cisesInfo close .
  end.
   
  { str/utd-err.i class }
  { utl/gtin.i    class }
  { utl/search.i  class }
end class.