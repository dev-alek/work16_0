 
 /*------------------------------------------------------------------------
    File        : runth_trg
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Mon Oct 05 07:00:38 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

block-level on error undo, throw.
&glob fileparam "RunTh.xml"
&glob fileSeporator "\"
class runth.runth_trg: 
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   
   {runth\ds-runth.i}
   {runth\ds-procstart.i}
   define temp-table tt-ParamsEdit      no-undo like tt-Params.
   define temp-table tt-ParamsOne       no-undo like tt-ParamsEdit.
   define temp-table tt-VerOne          no-undo like tt-Ver.
   define temp-table tt-fileListOne     no-undo like tt-fileList.
   define temp-table tt-fileReplaseOne  no-undo like tt-fileReplase.
   define public property mVer as character  no-undo
   get.
   set.
   method public void LoadReplaceParam(ifile as character ):
      dataset ds-replace:read-xml ("file", ifile,"empty",?,?).
      
      for each tt-fileList where tt-fileList.desc_ eq "" :
         if tt-fileList.FileId eq "auto"
         then
            tt-fileList.desc_ = "Авто задания".
         else if tt-fileList.FileId eq "cut"
         then
            tt-fileList.desc_ = "Обрезка базы".
            
         else if tt-fileList.FileId eq "Diadoc"
         then
            tt-fileList.desc_ = "Обмен с диадоком (ЭДО)".
            
         else if tt-fileList.FileId eq "merc"
         then
            tt-fileList.desc_ = "Обмен с меркурем (Сертификаты на продукцию)".
            
         else if tt-fileList.FileId eq "motp"
         then
            tt-fileList.desc_ = "МОТП (Честный знак)".
            
         else if tt-fileList.FileId eq "nws"
         then
            tt-fileList.desc_ = "Новости".
            
         else if tt-fileList.FileId eq "oxml"
         then
            tt-fileList.desc_ = "Обмен с ВС (1С)".
            
         else if tt-fileList.FileId eq "skt"
         then
            tt-fileList.desc_ = "Сокет сервер".
            
         else if tt-fileList.FileId eq "th"
         then
            tt-fileList.desc_ = "Trade House".
            
         else if tt-fileList.FileId eq "th-prof"
         then
            tt-fileList.desc_ = "Trade House c профилирование".
            
      end.
   end.
   
   method public void LoadHotParam(ifile as character ):
      dataset ds-HotParam:read-xml ("file", ifile,"empty",?,?).
   end.
   
   method public void SaveReplaceParam(ifile as character ):
      CrPatch(ifile).
      dataset ds-replace:write-xml ("file",  ifile, true, "windows-1251", ?, false, true ,false,true ).
   end.
   
   method public void SaveHotParam( ):
       SaveHotParam(GetPARAM({&fileparam},"FileHotParam")).
   end.
   method public void SaveHotParam(ifile as character ):
      if ifile eq ? then return.
      CrPatch(ifile).
      dataset ds-HotParam:write-xml ("file",  ifile, true, "windows-1251", ?, false, true ,false,true ).
   end.
   
   method public character replaseOneStr(itext as character ):
      define buffer tt-Params  for tt-ParamsEdit .
      for each tt-Params by tt-Params.version_run descending by tt-Params.version_id descending :
         itext = replace (itext,tt-Params.Value_Old,tt-Params.Value_new).
      end.
      return itext.
   end.
   
   method public character replasefileTeg(itext as character, ifileId as character  ):
      define buffer tt-fileList     for tt-fileList.
      if ifileId ne ?
      then do:
         find first tt-fileList where tt-fileList.FileId eq  iFileId.
         if available tt-fileList
         then do:
            itext = replace(itext, "#FileId#"   , tt-fileList.FileId).
            itext = replace(itext, "#FileName#" , tt-fileList.FileName).
         end.
      end.
      return itext.
   end.
   
   method public void replaseFile (iver as character ):
      define buffer tt-fileReplase  for tt-fileReplase.
      define buffer tt-fileList     for tt-fileList.
      define variable vmaxnon as integer no-undo.
         
      for each tt-Params where tt-Params.version_run eq iver:
         create tt-ParamsEdit.
         buffer-copy tt-Params to tt-ParamsEdit.
         vmaxnon = max (vmaxnon,tt-ParamsEdit.version_id).
      end.
      
      for each tt-HotKey where tt-HotKey.HotId > 0:
         find first tt-ParamsEdit where tt-ParamsEdit.Value_Old eq tt-HotKey.HotAttr no-error.
         if not available tt-ParamsEdit
         then do:
            create tt-ParamsEdit.
            assign
               vmaxnon = vmaxnon + 1
               tt-ParamsEdit.version_run = iver
               tt-ParamsEdit.version_id  = vmaxnon
               tt-ParamsEdit.Value_Old   = tt-HotKey.HotAttr
            .
         end.
         tt-ParamsEdit.Value_new = tt-HotKey.HotVal.
      end.
      
      for each tt-fileReplase :
         if tt-fileReplase.FileCycle
         then do:
            for each tt-fileList:
               replaseOneFile (tt-fileReplase.FileId,tt-fileList.FileId).
            end.
         end.
         else
            replaseOneFile (tt-fileReplase.FileId,?).
      end.
      finally:
         for each tt-ParamsEdit:
            delete tt-ParamsEdit.
         end.
      end. 
   end.
   
   method public void CrPatch (iFilePatch as character ):
      define variable vi     as integer   no-undo.
      define variable vpatch as character no-undo.
      iFilePatch = replace(iFilePatch,"\","/").
      do vi = 1 to num-entries(iFilePatch,"/") - 1:
         vpatch = vpatch + entry (vi,iFilePatch,"/") + "/".
         file-information:file-name = vpatch.
         if index( file-information:file-type, "f" ) > 0
         then
            message "Нельзя создать дирикторию уже есть файл " vpatch
            view-as alert-box.
         else if file-information:file-type eq ? 
         then
            os-create-dir VALUE(vpatch).
      end.  
   end.
   
   method public handle getQuery (input iNameQuery as character ) :
        return getQuery(iNameQuery,no).
   end.
  
   define temp-table tt-query
      field NameQuery as character 
      field hQuery    as handle
   index NameQuery NameQuery.
  
   method public handle getQuery (input iNameQuery as character,input iNewQuery as logical ) :
      define variable hQuery   as handle  no-undo .
      define variable vfirst   as logical no-undo .
      define variable vOpen    as logical no-undo init yes.
      define variable vTblName as character no-undo .
      define variable vOpenStr as character no-undo .
      define variable vSchedId as integer no-undo .

      find first tt-Query where tt-Query.NameQuery eq iNameQuery
      no-error.
      if     available tt-Query
         and iNewQuery
      then do:
         delete object tt-Query.hQuery.
         delete tt-Query.
      end.      
      if not available tt-Query
      then 
      do: 
          create query hQuery.
      end.
      else
         hQuery = tt-Query.hQuery.
      case iNameQuery:
         when "fileList"
         then do:
            hQuery:set-buffers(buffer tt-fileList:HANDLE). 
            hQuery:query-prepare("FOR EACH tt-fileList ").
         end.
         when "fileListOne"
         then do:
            hQuery:set-buffers(buffer tt-fileListOne:HANDLE). 
            hQuery:query-prepare("FOR EACH tt-fileListOne ").
            vFirst = yes.
         end.
         when "fileReplase"
         then do:
            hQuery:set-buffers(buffer tt-fileReplase:HANDLE). 
            hQuery:query-prepare("FOR EACH tt-fileReplase ").
         end.
         when "fileReplaseone"
         then do:
            hQuery:set-buffers(buffer tt-fileReplaseone:HANDLE). 
            hQuery:query-prepare("FOR EACH tt-fileReplaseone ").
            vFirst = yes.
         end.  
         when "Params"
         then do:
            hQuery:set-buffers(buffer tt-Params:HANDLE).
            if available  tt-ver
            then
               hQuery:query-prepare("FOR EACH tt-Params where tt-Params.version_run eq " + quoter (tt-ver.version)).
            else
               hQuery:query-prepare('FOR EACH tt-Params WHERE tt-Params.version_run eq  ' + quoter ("QWERTY2")).
         end.
         when "ParamsEdit"
         then do:
            hQuery:set-buffers(buffer tt-ParamsEdit:HANDLE).
            hQuery:query-prepare("FOR EACH tt-ParamsEdit ").
         end.
         when "ParamsOne"
         then do:
            hQuery:set-buffers(buffer tt-ParamsOne:HANDLE).
            hQuery:query-prepare("FOR EACH tt-ParamsOne ").
            vFirst = yes.
         end.
         when "ver"
         then do:
            hQuery:set-buffers(buffer tt-ver:HANDLE). 
            hQuery:query-prepare("FOR EACH tt-ver ").
         end.
         when "verOne"
         then do:
            hQuery:set-buffers(buffer tt-verOne:HANDLE). 
            hQuery:query-prepare("FOR EACH tt-verOne ").
            vFirst = yes.
         end.
         when "procRun"
         then do:
            hQuery:set-buffers(buffer tt-procList:HANDLE). 
            hQuery:query-prepare("FOR EACH tt-procList ").
            vFirst = yes.
         end.                     
      end case.
      
      if vOpen
      then do:
         hQuery:query-open.
         if vFirst 
         then
            hQuery:get-first () no-error .
      end.
           
      if not available tt-Query
      then do: 
         create tt-Query.
         assign
            tt-Query.NameQuery = iNameQuery
            tt-Query.hQuery    = hQuery
         .         
      end.
      return hQuery.
   end.
   
   define stream sRead.
   define stream sWrite.
   
   method public void replaseOneFile (iFileidRep as integer ,ifileIdlist as character ):
      
      define variable vFile as character no-undo.
      define variable vstr  as character no-undo.
      
      find first tt-fileReplase where tt-fileReplase.FileId eq  iFileidRep.
      if available tt-fileReplase
      then do:
         vFile = replaseOneStr (tt-fileReplase.FileName_New).
         vFile = replasefileTeg(vFile,ifileIdlist).
         CrPatch(vFile).
         input  stream sRead  from value(tt-fileReplase.FileName_Old).
         output stream sWrite to   value(vFile).
         impline:
         repeat:
            import stream sRead unformatted vStr.
            vStr = replaseOneStr(vStr).
            vStr = replasefileTeg(vStr,ifileIdlist).
            put stream sWrite unformatted vStr skip.
         end.
         output stream sWrite close.
         input stream sRead close.
         find first tt-fileList where tt-fileList.FileId eq ifileIdlist
                                  and tt-fileList.RunFile
         no-lock no-error.
         if available tt-fileList
         then
            os-command value( vFile).
         
      end.
   end.   
   
   method public void AddVer():
      define variable mform as runth.editver no-undo.
      define buffer tt-ParamsEdit for tt-ParamsEdit.
      release tt-ver.
      create tt-verOne.
      mform = new runth.editver (this-object).
      wait-for  mform:ShowDialog() .
      if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
      then do:
         create tt-ver.
         buffer-copy tt-verOne to tt-ver.
         for each tt-ParamsEdit:
            create tt-Params.
            buffer-copy tt-ParamsEdit except version_run to tt-Params
            assign
               tt-Params.version_run = tt-ver.version
            .
         end.
      end.
      finally:
         for each tt-VerOne:
            delete tt-VerOne.
         end.
         for each tt-ParamsEdit:
            delete tt-ParamsEdit.
         end.
         delete object mform no-error.
      end.
   end.
   
   method public void EditVer():
      define variable mform as runth.editver no-undo.
      define buffer tt-ParamsEdit for tt-ParamsEdit.
      define buffer tt-VerOne     for tt-VerOne.
      if available tt-Ver
      then do:
         create tt-verOne.
         buffer-copy tt-Ver to tt-VerOne.
         for each tt-Params where tt-Params.version_run eq tt-VerOne.version:
            create tt-ParamsEdit.
            buffer-copy tt-Params to tt-ParamsEdit.
         end.
         mform = new runth.editver (this-object).
         wait-for  mform:ShowDialog() .
         if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
         then do:
            for each tt-Params where tt-Params.version_run eq tt-Ver.version:
               delete tt-Params.
               
            end.
            buffer-copy tt-verOne to tt-ver.
            
            for each tt-ParamsEdit:
               create tt-Params.
               buffer-copy tt-ParamsEdit except version_run to tt-Params
               assign
                  tt-Params.version_run = tt-ver.version
               .
            end.
         end.
      end.
      finally:
         for each tt-VerOne:
            delete tt-VerOne.
         end.
         for each tt-ParamsEdit:
            delete tt-ParamsEdit.
         end.
         delete object mform no-error.
      end.
   end.
   
   method public void delVer():
      define variable mform as runth.editver no-undo.
      define buffer tt-ParamsEdit for tt-ParamsEdit.
      define buffer tt-VerOne     for tt-VerOne.
      if available tt-Ver
      then do:
         for each tt-Params where tt-Params.version_run eq tt-Ver.version:
            delete tt-Params.
         end.
         delete tt-ver.
      end.
   end.
   
   method public void AddParam():
      define variable mform as runth.editparam no-undo.
      define buffer tt-ParamsEdit for tt-ParamsEdit.
      find last tt-ParamsEdit no-error.
      create tt-ParamsOne.
      tt-ParamsOne.version_id = if available tt-ParamsEdit then tt-ParamsEdit.version_id + 1 else 1.
      mform = new runth.editparam (this-object).
      wait-for  mform:ShowDialog() .
      if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
      then do:
         create tt-ParamsEdit.
         buffer-copy tt-ParamsOne to tt-ParamsEdit.
      end.
      finally:
         for each tt-ParamsOne:
            delete tt-ParamsOne.
         end.
         delete object mform no-error.
      end.
   end. 
   
   method public void EditParam():
      define variable mform as runth.editparam no-undo.
      if available tt-ParamsEdit
      then do:
         create tt-ParamsOne.
         buffer-copy tt-ParamsEdit to tt-ParamsOne.
         mform = new runth.editparam (this-object).
         wait-for  mform:ShowDialog() .
         if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
         then do:
            buffer-copy tt-ParamsOne to tt-ParamsEdit.
         end.
      end.
      finally:
         for each tt-ParamsOne:
            delete tt-ParamsOne.
         end.
         delete object mform no-error.
      end.
   end.
   
   method public void DelParam():
      if available tt-ParamsEdit
      then
         delete tt-ParamsEdit.
   end.
   
   method public void AddFileRep():
      define variable mform as runth.editfilerep no-undo.
      define buffer tt-fileReplase for tt-fileReplase.
      find last tt-fileReplase no-error.
      create tt-fileReplaseOne.
      tt-fileReplaseOne.FileId = if available tt-fileReplase then tt-fileReplase.FileId + 1 else 1.
      mform = new runth.editfilerep (this-object).
      wait-for  mform:ShowDialog() .
      if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
      then do:
         create tt-fileReplase.
         buffer-copy tt-fileReplaseOne to tt-fileReplase.
      end.
      finally:
         for each tt-fileReplaseOne:
            delete tt-fileReplaseOne.
         end.
         delete object mform no-error.
      end.
   end. 
   
   method public void EditFileReplase():
      define variable mform as runth.editfilerep no-undo.
      if available tt-fileReplase
      then do:
         create tt-fileReplaseOne.
         buffer-copy tt-fileReplase to tt-fileReplaseOne.
         mform = new runth.editfilerep (this-object).
         wait-for  mform:ShowDialog() .
         if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
         then do:
            buffer-copy tt-fileReplaseOne to tt-fileReplase.
         end.
      end.
      finally:
         for each tt-fileReplaseOne:
            delete tt-fileReplaseOne.
         end.
         delete object mform no-error.
      end.
   end.
    
   method public void DelFileReplase():
      if available tt-fileReplase
      then
         delete tt-fileReplase.
   end.
   
   method public logical CheckVer(iver as character ):
      define buffer Buf-tt-ver for tt-ver.
      define variable vOk as logical no-undo.
      if     available     tt-ver
         and tt-ver.version eq iver
      then do: 
         vOk = true.
      end.
      else do:
         find first Buf-tt-ver where Buf-tt-ver.version eq iver no-error.
         if    not available Buf-tt-ver
         then do: 
            vOk = true.
         end.
      end.
      return vOk.
       
   end.
   
   method public logical CheckFileList(ifileId as character ):
      define buffer Buf-tt-fileList for tt-fileList.
      define variable vOk as logical no-undo.
      if     available     tt-fileList
         and tt-fileList.FileId eq ifileId
      then do: 
         vOk = true.
      end.
      else do:
         find first Buf-tt-fileList where Buf-tt-fileList.FileId eq ifileId no-error.
         if    not available Buf-tt-fileList
         then do: 
            vOk = true.
         end.
      end.
      return vOk.
       
   end.
   
   method public void AddFileList():
      define variable mform as runth.editfilelist no-undo.
      define buffer tt-filelist for tt-filelist.
      create tt-fileListOne no-error.
      mform = new runth.editfilelist (this-object).
      wait-for  mform:ShowDialog() .
      if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
      then do:
         create tt-fileList.
         buffer-copy tt-fileListOne to tt-filelist.
      end.
      finally:
         for each tt-fileListOne:
            delete tt-fileListOne.
         end.
         delete object mform no-error.
      end.
   end. 
   
   method public void EditFileList():
      define variable mform as runth.editfilelist no-undo.
      if available tt-fileList
      then do:
         create tt-fileListone.
         buffer-copy tt-fileList to tt-fileListOne.
         mform = new runth.editfilelist (this-object).
         wait-for  mform:ShowDialog() .
         if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
         then do:
            buffer-copy tt-fileListOne to tt-fileList.
         end.
      end.
      finally:
         for each tt-fileListOne:
            delete tt-fileListOne.
         end.
         delete object mform no-error.
      end.
   end.
    
   method public void DelFileList():
      if available tt-fileList
      then
         delete tt-fileList.
   end.
   
   method public void SetComBox(iComBox as System.Windows.Forms.ComboBox, inom as integer):
      iComBox:Items:Clear().
      find first tt-HotKey where tt-HotKey.HotId eq inom no-error.
      if available tt-HotKey
      then do: 
         for each tt-HotValList where tt-HotValList.HotKeyId eq tt-HotKey.HotId:
            iComBox:Items:Add(tt-HotValList.HotValList).
         end.
         iComBox:text = tt-HotKey.HotVal.
      end.
   end.
   
   method public void SetVerComBox(iComBox as System.Windows.Forms.ComboBox):
      define buffer tt-ver    for tt-ver.
      define buffer tt-HotKey for tt-HotKey.
      
      find first tt-HotKey where tt-HotKey.HotId eq -1 no-error.
      
      iComBox:Items:Clear().
      for each tt-ver :
         iComBox:Items:Add(tt-ver.version).
         if available tt-HotKey
            and tt-HotKey.HotVal  eq tt-ver.version
         then
            iComBox:text =  tt-HotKey.HotVal.
      end.
      
   end.
   
   method public void SaveComBox(iComBox as System.Windows.Forms.ComboBox, inom as integer  ):
      define variable vtext as character no-undo.
      vText = iComBox:text.
      find first tt-HotKey where tt-HotKey.HotId eq inom no-error.
      if inom < 0
         and not available tt-HotKey
      then do:
         create tt-HotKey.
         tt-HotKey.HotId = inom.
      end.
      if available tt-HotKey
      then do: 
         find first tt-HotValList where tt-HotValList.HotkeyId      eq tt-HotKey.HotId 
                                    and tt-HotValList.HotValList eq vText
         no-error.
         if     not available tt-HotValList
            and inom > 0
         then do:
            iComBox:Items:Add(vText).
            create tt-HotValList.
            assign
               tt-HotValList.HotkeyId       = tt-HotKey.HotId
               tt-HotValList.HotValList  = vText
            .
         end.
         tt-HotKey.HotVal = vText .
      end.
      if inom > 0
      then
         SetComBox(iComBox,inom).
   end.
   
   method public character GetLabelComBox(inom as integer):
      find first tt-HotKey where tt-HotKey.HotId eq inom no-error.
      return if available tt-HotKey then tt-HotKey.HotAttr else "".
   end.
   
   method public void ChoiceParam(iVer as character, inom as integer  ):
      define variable mform as runth.ChoiceParam no-undo.
      define buffer tt-Params for tt-Params.
      
      for each tt-Params where tt-Params.version_run eq iVer:
         create tt-ParamsEdit.
         buffer-copy tt-Params to tt-ParamsEdit.
      end.
      mform = new runth.ChoiceParam (this-object).
      wait-for  mform:ShowDialog() .
      if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
      then do:
         if available tt-ParamsEdit
         then do:
            delHotParam( inom).
            create tt-HotKey.
            assign
               tt-HotKey.HotId   = inom
               tt-HotKey.HotAttr = tt-ParamsEdit.Value_Old
               tt-Hotkey.HotVal  = ""
            .
            for each tt-Params where tt-Params.Value_Old eq tt-ParamsEdit.Value_Old:
               find first tt-HotValList where tt-HotValList.HotkeyId      = inom
                                          and tt-HotValList.HotValList = tt-Params.Value_new
               no-error.
               if not available tt-HotValList
               then do:
                  create tt-HotValList.
                  assign
                     tt-HotValList.HotkeyId      = inom
                     tt-HotValList.HotValList = tt-Params.Value_new
                  .
               end.
            end.
         end.
      end.
      finally:
         for each tt-ParamsEdit:
            delete tt-ParamsEdit.
         end.
         delete object mform no-error.
      end finally.
   end method.
   
   method public void delHotParam(inom as integer ):
      for each tt-HotKey where tt-HotKey.HotId eq inom:
         delete tt-HotKey.
      end.
      for each tt-HotValList where tt-HotValList.HotkeyId eq inom:
         delete tt-HotValList.
      end.
   end method.
   
   method public void SetupParam():
      define variable mform as runth.runth no-undo.
      
      mform = new runth.runth (this-object).
      wait-for  mform:ShowDialog() .
      if mform:DialogResult = System.Windows.Forms.DialogResult:Ok
      then do:
         
      end.
   
      finally:
         delete object mform no-error.
      end.
   end.
    
   method public logical repaintProc(iFileName as character ):
      define buffer tt-procList for tt-procList.
      find first tt-procList where tt-procList.FileName eq iFileName no-lock no-error.
      if available tt-procList
         and tt-procList.Repaintrow
      then do:
         tt-procList.Repaintrow =false.
         return true.
      end.
      return false.
   end.
   
   method public logical isRun(iFileName as character ):
      define buffer tt-procList for tt-procList.
      find first tt-procList where tt-procList.FileName eq iFileName no-lock no-error.
      return if available tt-procList then tt-procList.RunFile else false.
   end.
   
   method public character  glueDir(iFileName as character,
                                    iDir1      as character,
                                    iDir2      as character,
                                    iDir3      as character):
      if     iDir1 ne ""
         and iDir1 ne ?
      then do:
         iFileName = glueDir(iFileName,iDir1).
         if     iDir2 ne ""
            and iDir2 ne ?
         then do:
            iFileName = glueDir(iFileName,iDir2).
            if     iDir3 ne ""
               and iDir3 ne ?
            then do:
               iFileName = glueDir(iFileName,iDir3).
            end.
         end.
      end.
      return iFileName.
   end.
   
   method public character  glueDir(iFileName as character,
                                 iDir      as character):
      if     iDir ne ""
         and iDir ne ?
      then
         return iFileName + {&fileSeporator} + iDir.  
   end.
   
   method public logical updComboBox(iFileName as character,
                                     iDir1     as character,
                                     iDir2     as character,  
                                     comboBox as System.Windows.Forms.ComboBox):
      if    iDir1 eq ""
         or iDir1 eq ?
         or iDir2 eq ""
         or iDir2 eq ?
      then do:
         comboBox:Items:Clear().
         comboBox:Items:Add("").
      end.
      else do:
         iFileName = glueDir(iFileName,iDir1,iDir2,?).
         updComboBox(iFileName,comboBox).
      end.
   end.
   
   method public logical updComboBox(iFileName as character,
                                     iDir      as character, 
                                     comboBox as System.Windows.Forms.ComboBox):
      if    iDir eq ""
         or iDir eq ?
      then do:
         comboBox:Items:Clear().
         comboBox:Items:Add("").
      end.
      else do:
         iFileName = glueDir(iFileName,iDir).
         updComboBox(iFileName,comboBox).
      end.
   end.
   
   define stream flstream.
   method public void updComboBox(iFileName as character, 
                                     comboBox as System.Windows.Forms.ComboBox):
      define variable v-filename     as character no-undo.
      define variable v-fullfilename as character no-undo.
      define variable v-filetype     as character no-undo.
      comboBox:Items:Clear().
      comboBox:Items:Add("").
      file-information:file-name = iFileName.
      if iFileName eq ?  then return.
      if index( file-information:file-type, "d") eq 0 then return.
      input stream flstream from os-dir ( iFileName ) .
      repeat
         on error undo, return error
      :
         import stream flstream v-filename v-fullfilename v-filetype.
         if         v-filetype begins "d"
            and not v-filename begins "."
         then
            comboBox:Items:Add(v-filename).
      end.
      input stream flstream close.
      updProcList(iFileName).
   end.
   define variable WorkDir as character no-undo.
   method public void updProcList(iFileName as character):
      define variable v-filename     as character no-undo.
      define variable v-fullfilename as character no-undo.
      define variable v-filetype     as character no-undo.
      file-information:file-name = iFileName.
      if index( file-information:file-type, "d") eq 0 then return.
      input stream flstream from os-dir ( iFileName ) .
      WorkDir = iFileName.
      empty temp-table tt-procList.
      repeat
         on error undo, return error
      :
         import stream flstream v-filename v-fullfilename v-filetype.
         if v-filetype begins "f"
         then do:
            create tt-procList.
            tt-procList.FileName = v-filename.
            tt-procList.RunFile  = lookup(entry(num-entries (v-filename,"."),v-filename,"."),"exe,bat,cmd") > 0.
            if tt-procList.RunFile
            then do:
               find first tt-fileList where tt-fileList.FileId eq entry(1,tt-procList.FileName,".") no-lock no-error.
               if available tt-fileList
               then
                  tt-procList.Desc_ = tt-fileList.desc_.
            end.
         end.
      end.
      input stream flstream close.
      getQuery("procRun").
   end.
   
   method public void runProc():
      if available tt-procList
      then
         os-command value("start " + WorkDir + {&fileSeporator} + tt-procList.FileName + " & exit").
   end.
   
   method public void saveProc(  idir as character ,
                                 idir1 as character ,
                                 idir2 as character ,
                                 idir3 as character ):
      find first tt-hotDir no-error.
      if not available tt-hotDir
      then
         create tt-hotDir.
      if    tt-hotDir.HotDir  ne idir
         or tt-hotDir.HotDir1 ne idir1
         or tt-hotDir.HotDir2 ne idir2
         or tt-hotDir.HotDir3 ne idir3
      then do:
         assign
            tt-hotDir.HotDir  = idir
            tt-hotDir.HotDir1 = idir1
            tt-hotDir.HotDir2 = idir2
            tt-hotDir.HotDir3 = idir3
         .
         SaveHotParam().
      end.
   end.
   
   method public void loadProc( output idir as character ,
                                output idir1 as character ,
                                output idir2 as character ,
                                output idir3 as character ):
      find first tt-hotDir no-error.
      if available tt-hotDir
      then assign
         idir  = tt-hotDir.HotDir
         idir1 = tt-hotDir.HotDir1
         idir2 = tt-hotDir.HotDir2
         idir3 = tt-hotDir.HotDir3
      .
   end.
   
   constructor public runth_trg (  ):
      super ().
      define variable vfile as character no-undo.
      vfile = GetPARAM({&fileparam},"FileVer").
      if vfile ne ? and vfile ne "" and SearchFile(vfile) ne ?
      then
         LoadReplaceParam(vfile).
      vfile = GetPARAM({&fileparam},"FileHotParam").
      if vfile ne ? and vfile ne "" and SearchFile(vfile) ne ?
      then
         LoadHotParam(vfile).
   end constructor.

   destructor public runth_trg ( ):

   end destructor.

/* эти файл должен быть в конце иначе дизайнер не понимает препроцессоры и открывает пустую форму */
   {runth\param.i class }
end class.