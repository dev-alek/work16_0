 
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
using Ibs.Th.Gbl.ProgressBar.

class ibs.th.bge.egais.admutm inherits EGAISUTM:

  {cmp/str-glbl.i class}
  {ibs/th/bge/egais/wb-egais.i}
  
  define stream outstr.
  
  define private buffer buf_ext-sys for ub.ext-system.
  define private variable parameters  as character no-undo.
  define private variable inFileName  as character no-undo.
  define private variable inData      as character no-undo.
  define private variable outData     as character no-undo.
  define private variable cmd         as character no-undo.
  define private variable urlResp     as character no-undo.
  define private variable prsXMLDocWB as class ParserXMLDocWB no-undo.
  define private variable prgObj      as class ProgressBar    no-undo .
  define private variable FSRAR       as character no-undo.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  define property glog as logical no-undo
    get.
    set.

		
  constructor public admutm (inOjType as char, inObjCode as int, inFSRAR as char):

    super (inOjType, inObjCode).
    FSRAR = inFSRAR.
    prsXMLDocWB = new ParserXMLDocWB ().
    
  end constructor.

  destructor public admutm ():

    if valid-object (prsXMLDocWB)
      then delete object prsXMLDocWB.
    if valid-object (prgObj)
      then delete object prgObj.
    
  end destructor.

  method public override handle GetHndlTable ():
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    
    GetURLUTM().
    return buffer tt-alldoc:handle.
    
  end.

  method public void SaveRecords ():
    
    def var hDoc as handle no-undo.
    def var path as char no-undo.
    def var fullFileName as char no-undo.
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    find last tt-alldoc no-error.
    
    if not available (tt-alldoc)
      then return.
    
    prgObj = new ProgressBar (1, tt-alldoc.nnOrder).
    prgObj:can-cancel = true.
    prgObj:show-bar().
    
    for each tt-alldoc where true or tt-alldoc.url_ matches "*WayBillTicket*":
    
      prgObj:increment( substring (tt-alldoc.url_, if length (tt-alldoc.url_) <= 50 then 1 else length (tt-alldoc.url_) - 50)). 
      if prgObj:is-canceled 
        then return.
    
      SaveRecord(tt-alldoc.url_, output fullFileName).
      
      if StatusErr then return.
      
    end.
    
    if valid-object (prgObj)
      then do:
        prgObj:hide-bar().
        delete object prgObj.
      end.
    
    
    glog = true.
    
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
    define variable jj    as integer no-undo.
    
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
    jj = 0.
    do ii = 1 to hRoot:num-children:
      hRoot:get-child(hRow,ii).
      case hRow:name:
        when "url" then
          do:
            jj = jj + 1.
            hRow:get-child (hText, 1) no-error.
            create tt-alldoc.
            tt-alldoc.url_ = hText:node-value.
            tt-alldoc.nnOrder = jj.
          end.
      end case.
    end.
    
    return ?. 

  end.
  
  method public void DelBeforDate (input InDate as date): 
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    for each tt-alldoc where InDate > 01/01/01 :
      
    end.
    
  end.

  method public void LookRec (input inUrl as char): 
    
    def var fullFileName as char no-undo. 
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    SaveRecord(inUrl, output fullFileName).
    if StatusErr then return.
    os-command silent value(fullFileName).
    
  end.

  method public void SaveRecord (input inUrl as char):

    assign
      StatusErr = false
      Msg = ""
    .
    
    def var fullFileName as char no-undo.
    SaveRecord (input inUrl, output fullFileName).
    if StatusErr then return.
  
  end.

  method public void SaveRecord (input inUrl as char, output outFullFileName as char):
    
    def var path as char no-undo.
    def var hDoc as handle no-undo.
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    path = "egais_" + FSRAR + "\".
    
    file-info:file-name = right-trim (path, "\").
    if file-info:file-type = ?
    then do:
      os-create-dir value(right-trim (path, "\")).
      if os-error <> 0 then do:
        message substitute("Невозможно создать директорию &1",path) view-as alert-box error.
        leave.
      end.
    end.

    assign
      inFileName = entry (7, inUrl, "/") + "_" + entry (6, inUrl, "/").
      .
    
    os-delete value (path + "inFileName").
    os-delete value (search (path + inFileName)).
    
    outFullFileName = path + inFileName + ".xml".
    
    cmd = substitute ("&1 --connect-timeout &2 -X GET &3 >&4", search ("exe/curl.exe"), TimeOut, inUrl, outFullFileName).
    os-command silent value (cmd).

    file-info:file-name = search (outFullFileName).
    
    if file-info:file-size = ? or  file-info:file-size = 0 
      then do: 
        StatusErr = true.
        Msg = 'Не удалось получить данные от УТМ.'.
        return.
      end.

    file-info:file-name = search (outFullFileName).
    
    create x-document hDoc.
    hDoc:encoding = 'utf-8'.
    hDoc:load ("file", file-info:file-name, false) no-error.
    
    prsXMLDocWB:ParseRec (hDoc, input-output table tt-alldoc, inUrl).

    glog = true. 
    
  end.

  method public void DelRecord (input inUrl as char): 
    
    assign
      StatusErr = false
      Msg = ""
    .
    
    cmd = substitute ("&1  -X DELETE &2", search ("exe/curl.exe"), inUrl).
    message inUrl view-as alert-box.
/*    os-command silent value (cmd).*/
    
  end.


end class.
