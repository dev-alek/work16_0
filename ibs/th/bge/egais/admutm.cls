 
/*------------------------------------------------------------------------
   File        : rests
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : sslivenko
   Created     : 
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using ibs.th.bge.egais.*.

class ibs.th.bge.egais.admutm inherits EGAISUTM:

{cmp/str-glbl.i class}

  define temp-table tt-analiz no-undo
    field url_         as character format "X(50)"
    field wb-type      as character label "Тип" format "X(4)"
    field wb-date      as date      label "Дата"
    field wbregid      as character label "WBREGID" format "X(18)"
    field Identity     as character format "X(50)"
    field uniq-key-rec as character format "X(50)"
    field isMany       as logical format "yes/no"
    field nnOrder      as integer
    index pi
    nnOrder
    .
  
  define stream outstr.
  
  define private buffer buf_ext-sys for ub.ext-system.
  define private variable parameters as character no-undo.
  define private variable inFileName as character no-undo.
  define private variable inData     as character no-undo.
  define private variable outData    as character no-undo.
  define private variable cmd        as character no-undo.
  define private variable urlResp    as character no-undo.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  constructor public admutm (inOjType as char, inObjCode as int, inFSRAR as char):

    super (inOjType, inObjCode).
    
  end constructor.

  method public override handle GetHndlTable ():
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    
    GetURLUTM().
    return buffer tt-analiz:handle.
    
  end.

  method public logical SaveRecords ():
    
    
    def var path as char no-undo.
    def var fullFileName as char no-undo.
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    find first tt-analiz.
    
    if not available (tt-analiz)
      then return true.
    
    assign
    path = "egais_" + entry (1, (entry (3, tt-analiz.url_, "/")), ":") + "\" no-error.
    
    file-info:file-name = right-trim (path, "\").
    if file-info:file-type = ?
    then do:
      os-create-dir value(right-trim (path, "\")).
      if os-error <> 0 then do:
          message substitute("Невозможно создать директорию &1",path) view-as alert-box error.
          leave.
      end.
    end.
    
    for each tt-analiz:
    
      assign
        inFileName = entry (6, tt-analiz.url_, "/") + "_" + entry (7, tt-analiz.url_, "/") + ".xml".
        .
      
      os-delete value (path + "inFileName").
      os-delete value (search (path + inFileName)).
      
      fullFileName = path + inFileName.

      cmd = substitute ("&1 --connect-timeout &2 -X GET &3 >&4", search ("exe/curl.exe"), TimeOut, tt-analiz.url_, fullFileName).
      os-command silent value (cmd).
  
      file-info:file-name = search (inFileName).
      
    end.
    
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

  method private character GetURLUTM ():
    
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
            hRow:get-child (hText, 1) no-error.
            create tt-analiz.
            tt-analiz.url_ = hText:node-value.
            tt-analiz.nnOrder = ii.
          end.
      end case.
    end.
    
    return ?. 

  end.


end class.


