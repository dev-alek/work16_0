 
/*------------------------------------------------------------------------
   File        : ActBalance
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : SSlivenko
   Created     : Wed Nov 11 14:29:45 MSK 2015
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.egais.*.

class ibs.th.bge.egais.ActWriteOff inherits EGAISUTM:

{cmp/str-glbl.i class}
{ibs/th/bge/egais/awo-egais.i}
{ ref/extclass.i }

  define stream outstr.
  
  define private buffer buf_clob-bind for ub.clob-bind.
  define private buffer buf_clob-data for ub.clob-data.
  define private buffer buf_gds for ub.goods.
  define private buffer buf_trn-doc for ub.trn-doc.
  define private buffer buf_doc-attr for ub.doc-attr.
  define private buffer buf_doc-line for ub.doc-line.
  define private buffer buf_clients for ub.clients.
  define private buffer buf_ext-classif for ub.ext-classif.
  
  define private variable parameters     as character no-undo.
  define private variable inFileName     as character no-undo.
  define private variable inData         as character no-undo.
  define private variable outData        as character no-undo.
  define private variable cmd            as character no-undo.
  define private variable urlResp        as character no-undo.
  define private variable v-uniq-key-rec as character no-undo.
  define private variable v-Answer       as character no-undo.

  define variable v-FS-RAR  as character no-undo .
  define variable v-ext-sys as integer   no-undo .
  DEFINE VARIABLE good AS LOGICAL NO-UNDO.
  
  define property inNum as character no-undo
    get.
    set. 


  constructor public ActWriteOff (inOjType as char, inObjCode as int, inFSRAR as char, inExtSys as integer):
    
    
    super (inOjType, inObjCode).
/*    assign               */
/*      parameters = inNum.*/
/*    .                    */
    v-FS-RAR = inFSRAR.
    v-ext-sys = inExtSys.
    IsSent.
    
  end constructor.
  
  method public override handle GetHndlTable(inTableType as int, inAbIndenty as char) :

    define variable hRoot as handle  no-undo.
    define variable hDoc  as handle  no-undo.
    define variable ii    as integer no-undo.
    
    assign
      parameters = inNum
      StatusErr = false
      Msg       = ""
      .
    
    
    case inTableType:
      when {&awo-clob} then 
        do:
          empty temp-table tt-act-header.
          for each buf_clob-bind where buf_clob-bind.field-name_ = {&lob-egais-awo}:
            /*v-info = string (tt-wb-header.wb-date) + {&-par} + tt-wb-header.num + {&-par} + tt-wb-info-client.regID + {&-par} + tt-wb-header.indenty + {&-par} + string (tt-wb-header.wbregid) + {&-par} + "нет" + {&-par} + "нет" + {&-par}.*/
            create tt-act-header.
            assign
                tt-act-header.num       = (entry (1, buf_clob-bind.descr, {&delim-par}))
                tt-act-header.date_     = date (entry (2, buf_clob-bind.descr, {&delim-par}))
                tt-act-header.type_     = (entry (3, buf_clob-bind.descr, {&delim-par}))
                tt-act-header.is-sent   = logical (entry (4, buf_clob-bind.descr, {&delim-par}))                
            .
            assign tt-act-header.answer_   = (entry (5, buf_clob-bind.descr, {&delim-par})) no-error .
            end.
          return buffer tt-act-header:handle.
        end.
      when {&awo-answer} then
      do :       
        
        create x-document hDoc.
        create x-noderef  hRoot.
            
        if not IsSent
        then do:
          StatusErr = true.
          Msg = "Акт еще не был отправлен".
          return ?.
        end.
        
        if ConPar = "" or ConPar = ?
        then do:
          StatusErr = true.
          Msg = "Не заданы настройки соединения для EGAIS".
          return ?.
        end.
         
        GetSubjectOfRequestUTM().
        
        if StatusErr 
          then return ?.
    
        
        file-info:file-name = search (inFileName).
        if search (inFileName) = ? or file-info:file-size = 0 
        then do:
          assign
            StatusErr = true
            Msg = "Не удалось получить данные от UTM"
          .
          return ?.
        end.
        
        if not WriteDbStatus ( 4, parameters , ReplyId, true )
        then do: 
          assign
            StatusErr = true
            Msg = "Не удалось записать данные о запросе в БД. Запрос не выполен."
          .
          undo, return ?.
        end.
        
        hDoc:load ("file", inFileName, false).
        hDoc:get-document-element(hRoot) .
        
        GetChildren(hRoot, 1).
            
        DELETE OBJECT hDoc.
        DELETE OBJECT hRoot.
        
        find last buf_clob-bind where buf_clob-bind.field-name_ = {&lob-egais-awo} and buf_clob-bind.uniq-key-rec = inAbIndenty .
        if num-entries (buf_clob-bind.descr, {&delim-par}) = 4 then
            assign buf_clob-bind.descr = buf_clob-bind.descr + {&delim-par} + v-Answer .
        else if num-entries (buf_clob-bind.descr, {&delim-par}) = 5 then   
            assign entry(5, buf_clob-bind.descr, {&delim-par}) = v-Answer .
            
        find first tt-act-header where tt-act-header.num = inAbIndenty .
        assign tt-act-header.answer_ = v-Answer .
        
        return buffer tt-act-header:handle.    
      end.
      
    end case.
    
  end.
  
  method override public logical SendRequestUTM ():
    
    def var ii        as int    no-undo.
    def var xml-cont  as char   no-undo.
    def var respValue as handle no-undo.
    assign
      parameters = inNum
      StatusErr = false
      Msg       = ""
      .
    
    if IsSent 
      then 
    do:
      Msg = "Запрос уже был отправлен".
      StatusErr = true.
      return no.
    end.
    
    do trans:
    
      os-delete "RespActWriteOff.xml".
      assign
        inFileName = "RespActWriteOff.xml"
        .
      
      find first tt-act-header no-error.
      
      if available (tt-act-header)
        then 
      do:
        
/*          run gbl/inidebug.p .*/
      
          cmd = substitute ("&1 --connect-timeout 1 -F xml_file=@&2 &3/opt/in/ActWriteOff >&4", search ("exe/curl.exe"), search ("ActWriteOff.xml"), ConPar, inFileName).
          os-command value (cmd).
    
          file-info:file-name = search (inFileName).
          if search (inFileName) <> ? and file-info:file-size > 0 
            then 
          do:
            respValue = ParseRequest (inFileName).
            if respValue = ? 
              then 
            do:
              assign
                StatusErr = true
                Msg       = "Не удалось разобрать данные от UTM"
                .
              undo, return false. 
            end.
            if not StatusErr 
              then 
              ReplyId = respValue:node-value.
            else 
            do:
              assign
                StatusErr = true
                Msg       = respValue:node-value
                .
              undo, return false. 
            end.
          end.
          else 
          do:
            assign
              StatusErr = true
              Msg       = "Не удалось отправить акт о списании в UTM"
              .
            undo, return false.
          end.
           
          if not WriteDbStatus (4, parameters , ReplyId, false)
          then do: 
            assign
              StatusErr = true
              Msg = "Не удалось записать данные о запросе в БД. Запрос не выполен."
            .
            undo, return false.
          end. 
        
      end.
    end.      
  end.

  method override protected logical GetIsSent ():
    def var repId as char no-undo.
    def var glog  as log  no-undo.
    glog = CheckCurrentRequest (4, parameters, repId).
    if glog
      then ReplyId = repId.
    return glog.
  end.

  method protected handle ParseRequest (inFileName as char):
    
    define variable hRoot as handle  no-undo.
    define variable hDoc  as handle  no-undo.
    define variable hRow  as handle  no-undo.
    define variable hText as handle  no-undo.
    define variable ii    as integer no-undo.
    
    create x-document hDoc.
    create x-noderef  hRoot.
    create x-noderef  hRow.
    create x-noderef htext .
    
    hDoc:load ("file", inFileName, false).
    hDoc:encoding = "UTF-8".
    hDoc:get-document-element(hRoot) .
    
    do ii = 1 to hRoot:num-children:
      hRoot:get-child(hRow,ii).
      case hRow:name:
        when "url" then
          do:
            hRow:get-child (hText, 1) no-error.
            return hText.
          end.
        when "error" then
          do:
            hRow:get-child (hText, 1) no-error.
            StatusErr = true.
            return hText.
          end.
        otherwise 
          do:
            return ?.
          end.
      end case.
    end.


  end.


  method private void GetChildren(hParent AS HANDLE, level AS INTEGER):
        
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE hNoderef AS HANDLE NO-UNDO.
        DEFINE VARIABLE hText AS HANDLE NO-UNDO.
        
        CREATE X-NODEREF hNoderef.
        CREATE X-NODEREF hText .
        
        
        REPEAT i = 1 TO hParent:NUM-CHILDREN:
            good = hParent:GET-CHILD(hNoderef,i).
            IF NOT good THEN 
                LEAVE.
            IF hNoderef:SUBTYPE <> "element" THEN
                NEXT.
            
            hNoderef:GET-CHILD(hText, 1) no-error .    
            
            IF hNoderef:NAME = "tc:Comments" THEN v-Answer = hText:node-value .

            GetChildren(hNoderef, (level + 1)).
        END.
        
        DELETE OBJECT hNoderef.
        DELETE OBJECT hText.
  END.

  method public override character GetSubjectOfRequestUTM() :
      
    urlResp = GetURLUTM(ReplyId).
    
    if urlResp = "" or urlResp = ?
    then do:
      StatusErr = true.
      Msg = "Еще не получен ответ от сервера EGAIS по запросу " + ReplyId.
      return ?.
    end.
    
    os-delete "RespActWriteOff.xml".
    assign
      inFileName = "RespActWriteOff.xml"
    .
    
    cmd = substitute ("&1 --connect-timeout &2 -X GET &3 >&4", search ("exe/curl.exe"), TimeOut, urlResp, inFileName).
    os-command value (cmd).
  end.

  method protected override character GetURLUTM (inReplyId as char):
    
    define variable hRoot as handle  no-undo.
    define variable hDoc  as handle  no-undo.
    define variable hRow  as handle  no-undo.
    define variable hText as handle  no-undo.
    define variable ii    as integer no-undo.
    
    create x-document hDoc.
    create x-noderef  hRoot.
    create x-noderef  hRow.
    create x-noderef  hText.
    
    
    assign
      inFileName = "ReceiptListOfQuery.xml"
    .
    if search ("ReceiptListOfQuery.xml") <> ? then os-delete value (inFileName).
    if search (inFileName) <> ? then os-delete value (inFileName).
    

    cmd = substitute ("&1 --connect-timeout &2 -X GET &3/opt/out?refresh=true >&4",search ("exe/curl.exe"), TimeOut, ConPar, inFileName).
    os-command value (cmd).
       
    file-info:file-name = search (inFileName).
    if search (inFileName) = ? or file-info:file-size = 0 
    then do:
      assign
        StatusErr = true
        Msg = "Не удалось получить данные от UTM"
      .
      return ?.
    end.
    
    hDoc:load ("file", inFileName, false).
    hDoc:get-document-element(hRoot) .
    
    do ii = 1 to hRoot:num-children:
      hRoot:get-child(hRow,ii).
      case hRow:name:
        when "url" then
          do:
            if hRow:get-attribute("replyId") = ReplyId 
            then do:
              hRow:get-child (hText, 1) no-error.
              return hText:node-value.
            end.
          end.
      end case.
    end.
    
    return ?.
    
  end.


end class.
