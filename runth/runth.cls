 /*------------------------------------------------------------------------
    File        : runth
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Mon Sep 28 07:36:52 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class runth.runth inherits Form : 

   define private variable BindVer as Progress.Data.BindingSource no-undo.
   define private variable BindParam as Progress.Data.BindingSource no-undo.
   define private variable BindFileRep as Progress.Data.BindingSource no-undo.
   define private variable BindFileList as Progress.Data.BindingSource no-undo.
   define private variable btn_add as System.Windows.Forms.Button no-undo.
   define private variable btn_del_file_list as System.Windows.Forms.Button no-undo.
   define private variable btn_Add_file_list as System.Windows.Forms.Button no-undo.
   define private variable btn_edit as System.Windows.Forms.Button no-undo.
   define private variable btn_del as System.Windows.Forms.Button no-undo.
   define private variable btn_edit_file_list as System.Windows.Forms.Button no-undo.
   define private variable btn_file_del as System.Windows.Forms.Button no-undo.
   define private variable btn_file_edit as System.Windows.Forms.Button no-undo.
   define private variable btn_file_add as System.Windows.Forms.Button no-undo.
   define private variable btn_openfile as System.Windows.Forms.Button no-undo.
   define private variable btn_openfilehot as System.Windows.Forms.Button no-undo.
   define private variable btn_save as System.Windows.Forms.Button no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable FileHotParam as System.Windows.Forms.TextBox no-undo.
   define private variable fileNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable fileIdDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable FileVer as System.Windows.Forms.TextBox no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   define private variable label3 as System.Windows.Forms.Label no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define private variable openFileDialog as System.Windows.Forms.OpenFileDialog no-undo.
   define private variable runFileDataGridViewCheckBoxColumn as System.Windows.Forms.DataGridViewCheckBoxColumn no-undo.
   define private variable valuenewDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable valueOldDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable versionDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable versionDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable splitContainer3 as System.Windows.Forms.SplitContainer no-undo.
   define private variable splitContainer2 as System.Windows.Forms.SplitContainer no-undo.
   define private variable splitContainer1 as System.Windows.Forms.SplitContainer no-undo.
   define private variable fileNameOldDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable fileNameNewDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable fileIdDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable fileCycleDataGridViewCheckBoxColumn as System.Windows.Forms.DataGridViewCheckBoxColumn no-undo.
   define private variable dataVer as System.Windows.Forms.DataGridView no-undo.
   define private variable dataParamRep as System.Windows.Forms.DataGridView no-undo.
   define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
   define private variable dataFileList as System.Windows.Forms.DataGridView no-undo.
   define variable mTrg as runth.runth_trg no-undo.
   define variable mFileName as character no-undo.
   define private variable versionidDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  &glob fileparam "RunTh.xml" 
   constructor public runth( ):
   
      super().
      InitializeComponent ( ).
      mtrg = new runth.runth_trg().
      FileVer:text = GetPARAM({&fileparam},"FileVer").
      FileHotParam:text = GetPARAM({&fileparam},"FileHotParam").
      BindVer:handle = mTrg:getQuery("Ver").
      BindFileList:handle = mTrg:getQuery("filelist").
      BindFileRep:handle  = mTrg:getQuery("fileReplase").
      BindParam:handle    = mtrg:getQuery("Params").
       
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.
    
   constructor public runth(itrg as runth.runth_trg):
   
      super().
      InitializeComponent ( ).
      mtrg = itrg.
      FileVer:text = GetPARAM({&fileparam},"FileVer").
      FileHotParam:text = GetPARAM({&fileparam},"FileHotParam").
      BindVer:handle = mTrg:getQuery("Ver").
      BindFileList:handle = mTrg:getQuery("filelist").
      BindFileRep:handle  = mTrg:getQuery("fileReplase").
      BindParam:handle    = mtrg:getQuery("Params").
       
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   destructor public runth( ):
/*      delete object mtrg.*/
      
      if valid-object(BindFileList) then BindFileList:Dispose().
      if valid-object(BindFileRep)  then BindFileRep:Dispose().
      if valid-object(BindParam)    then BindParam:Dispose().
      if valid-object(BindVer)      then BindVer:Dispose(). 
      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_add_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:AddVer().
		BindVer:handle:query-open.
		BindVer:RefreshAll().
		BindParam:handle    = mtrg:getQuery("Params").
		BindParam:RefreshAll().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_Add_file_list_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:AddFileList().
		BindFileList:handle:query-open.
		BindFileList:RefreshAll().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_del_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:delVer().
      BindVer:handle:query-open.
      BindVer:RefreshAll().
      BindParam:handle    = mtrg:getQuery("Params").
      BindParam:RefreshAll().
      
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_del_file_list_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:DelFileList().
      BindFileList:handle:query-open.
      BindFileList:RefreshAll().
      return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_edit_Click( input sender as System.Object, input e as System.EventArgs ):
	   mtrg:EditVer().
      BindVer:Refresh().
      BindParam:handle    = mtrg:getQuery("Params").
      BindParam:RefreshAll().
      	
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_edit_file_list_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:EditFileList().
      BindFileList:Refresh().
      
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_file_add_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:AddFileRep().
		BindFileRep:handle:query-open.
		BindFileRep:RefreshAll().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_file_del_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:DelFileReplase().
		BindFileRep:handle:query-open.
		BindFileRep:RefreshAll().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_file_edit_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:EditFileReplase().
		
		BindFileRep:Refresh().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_openfilehot_Click( input sender as System.Object, input e as System.EventArgs ):
	   define variable vFile as character no-undo.
		if search(FileHotParam:text) eq ?
      then do:
         this-object:openFileDialog:FileName = FileHotParam:text.
         wait-for this-object:openFileDialog:ShowDialog(). 
         if   this-object:openFileDialog:FileName ne ""
         then do:
            this-object:FileHotParam:Text = this-object:openFileDialog:FileName.
            mtrg:LoadHotParam(FileHotParam:Text).
         end.
      end.
      else do:
         vFile = search(FileHotParam:text).
         if vFile ne?
         then do:
            FileHotParam:text = vFile.
            mtrg:LoadHotParam(vFile).
         end.
         else
            message "Не найден файл " FileHotParam:text
            view-as alert-box.
      end.
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_save_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:SaveReplaceParam(FileVer:text).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
   method private void button1_Click( input sender as System.Object, input e as System.EventArgs ):
      define variable Vres as System.Windows.Forms.DialogResult no-undo.
		if search(FileVer:text) eq ?
		then do:
		   this-object:openFileDialog:FileName = FileVer:text.
         wait-for this-object:openFileDialog:ShowDialog() set Vres.
          
         if   Vres = System.Windows.Forms.DialogResult:Ok
         then do:
            mFileName = this-object:openFileDialog:FileName.
            this-object:Filever:Text = mFileName.
            mtrg:LoadReplaceParam(mFileName).
         end.
      end.
      else do:
         mFileName = search(Filever:text).
         if mFileName eq ?
         then do:
            FileVer:text = mFileName.
            mtrg:LoadReplaceParam(mFileName).
         end.
         else
            message "Не найден файл " Filever:text
            view-as alert-box.
      end.
      BindVer:handle:query-open.
      BindVer:RefreshAll().
      BindFileList:handle:query-open.
      BindFileList:RefreshAll().
      BindFileRep:handle:query-open.
      BindFileRep:RefreshAll().
      BindParam:handle = mtrg:getQuery("Params").
      BindParam:RefreshAll().
     
		return.

	end method.



	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataVer_CellClick( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):
		BindParam:handle    = mtrg:getQuery("Params").
      BindParam:RefreshAll().
		return.

	end method.


    method private void okButton_Click (sender as System.Object, e as System.EventArgs):
      output to {&fileparam}.
      SavePARAM("FileVer",FileVer:Text) .
      SavePARAM("FileHotParam",FileHotParam:Text).
      output close.
      this-object:DialogResult = System.Windows.Forms.DialogResult:Ok.
      this-object:Close ( ). 
   end method.

   method private void cancelButton_Click (sender as System.Object, e as System.EventArgs):
      this-object:DialogResult = System.Windows.Forms.DialogResult:Cancel.
      this-object:Close ( ).
   end method.
    
   method private void InitializeComponent ( ):

      /* NOTE: The following method is automatically generated.
         
         We strongly suggest that the contents of this method only be modified using the 
         Visual Designer to avoid any incompatible modifications.
         
         Modifying the contents of this method using a code editor will invalidate any support for this file. */
      
      this-object:components = new System.ComponentModel.Container().
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable tableDesc1 as Progress.Data.TableDesc no-undo.
      tableDesc1 = new Progress.Data.TableDesc("tt-ver").
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable tableDesc2 as Progress.Data.TableDesc no-undo.
      tableDesc2 = new Progress.Data.TableDesc("tt-Params").
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable tableDesc3 as Progress.Data.TableDesc no-undo.
      tableDesc3 = new Progress.Data.TableDesc("tt-fileList").
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable tableDesc4 as Progress.Data.TableDesc no-undo.
      tableDesc4 = new Progress.Data.TableDesc("tt-fileReplase").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:BindVer = new Progress.Data.BindingSource(this-object:components).
      this-object:BindParam = new Progress.Data.BindingSource(this-object:components).
      this-object:BindFileList = new Progress.Data.BindingSource(this-object:components).
      this-object:BindFileRep = new Progress.Data.BindingSource(this-object:components).
      this-object:dataVer = new System.Windows.Forms.DataGridView().
      this-object:versionDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:dataParamRep = new System.Windows.Forms.DataGridView().
      this-object:versionidDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:valueOldDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:valuenewDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:dataFileList = new System.Windows.Forms.DataGridView().
      this-object:fileIdDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:fileNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:runFileDataGridViewCheckBoxColumn = new System.Windows.Forms.DataGridViewCheckBoxColumn().
      this-object:splitContainer1 = new System.Windows.Forms.SplitContainer().
      this-object:btn_del = new System.Windows.Forms.Button().
      this-object:btn_edit = new System.Windows.Forms.Button().
      this-object:btn_add = new System.Windows.Forms.Button().
      this-object:splitContainer2 = new System.Windows.Forms.SplitContainer().
      this-object:splitContainer3 = new System.Windows.Forms.SplitContainer().
      this-object:btn_file_del = new System.Windows.Forms.Button().
      this-object:btn_file_edit = new System.Windows.Forms.Button().
      this-object:btn_file_add = new System.Windows.Forms.Button().
      this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
      this-object:fileIdDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:fileNameOldDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:fileNameNewDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:fileCycleDataGridViewCheckBoxColumn = new System.Windows.Forms.DataGridViewCheckBoxColumn().
      this-object:btn_del_file_list = new System.Windows.Forms.Button().
      this-object:btn_edit_file_list = new System.Windows.Forms.Button().
      this-object:btn_Add_file_list = new System.Windows.Forms.Button().
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:FileVer = new System.Windows.Forms.TextBox().
      this-object:openFileDialog = new System.Windows.Forms.OpenFileDialog().
      this-object:btn_openfile = new System.Windows.Forms.Button().
      this-object:btn_save = new System.Windows.Forms.Button().
      this-object:label2 = new System.Windows.Forms.Label().
      this-object:FileHotParam = new System.Windows.Forms.TextBox().
      this-object:label3 = new System.Windows.Forms.Label().
      this-object:btn_openfilehot = new System.Windows.Forms.Button().
      cast(this-object:BindVer, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:BindParam, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:BindFileList, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:BindFileRep, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:dataVer, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:dataParamRep, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:dataFileList, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer1:Panel1:SuspendLayout().
      this-object:splitContainer1:Panel2:SuspendLayout().
      this-object:splitContainer1:SuspendLayout().
      cast(this-object:splitContainer2, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer2:Panel1:SuspendLayout().
      this-object:splitContainer2:Panel2:SuspendLayout().
      this-object:splitContainer2:SuspendLayout().
      cast(this-object:splitContainer3, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer3:Panel1:SuspendLayout().
      this-object:splitContainer3:Panel2:SuspendLayout().
      this-object:splitContainer3:SuspendLayout().
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(698, 482).
      this-object:buttonOk:Name = "buttonOk".
      this-object:buttonOk:Size = new System.Drawing.Size(75, 23).
      this-object:buttonOk:TabIndex = 0.
      this-object:buttonOk:Text = "OK".
      this-object:buttonOk:UseCompatibleTextRendering = true.
      this-object:buttonOk:Click:Subscribe(this-object:okButton_Click).
      /*  */
      /* buttonCancel */
      /*  */
      define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar1 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonCancel:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
      this-object:buttonCancel:Location = new System.Drawing.Point(513, 483).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Visible = false.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* BindVer */
      /*  */
      this-object:BindVer:AutoUpdate = true.
      this-object:BindVer:MaxDataGuess = 0.
      this-object:BindVer:NoLOBs = false.
      this-object:BindVer:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar0 = new "Progress.Data.TableDesc[]"(0).
      tableDesc1:ChildTables = arrayvar0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 1 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("version", "Версия", Progress.Data.DataType:CHARACTER).
      tableDesc1:Columns = arrayvar1.
      this-object:BindVer:TableSchema = tableDesc1.
      /*  */
      /* BindParam */
      /*  */
      this-object:BindParam:AutoUpdate = true.
      this-object:BindParam:MaxDataGuess = 0.
      this-object:BindParam:NoLOBs = false.
      this-object:BindParam:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar2 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar2 = new "Progress.Data.TableDesc[]"(0).
      tableDesc2:ChildTables = arrayvar2.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar3 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar3[1] = new Progress.Data.ColumnPropDesc("version_id", "№", Progress.Data.DataType:INTEGER).
      arrayvar3[2] = new Progress.Data.ColumnPropDesc("Value_Old", "Заменить с", Progress.Data.DataType:CHARACTER).
      arrayvar3[3] = new Progress.Data.ColumnPropDesc("Value_new", "Заменить на", Progress.Data.DataType:CHARACTER).
      tableDesc2:Columns = arrayvar3.
      this-object:BindParam:TableSchema = tableDesc2.
      /*  */
      /* BindFileList */
      /*  */
      this-object:BindFileList:AutoUpdate = true.
      this-object:BindFileList:MaxDataGuess = 0.
      this-object:BindFileList:NoLOBs = false.
      this-object:BindFileList:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar4 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar4 = new "Progress.Data.TableDesc[]"(0).
      tableDesc3:ChildTables = arrayvar4.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar5 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar5[1] = new Progress.Data.ColumnPropDesc("FileName", " Файл запуска", Progress.Data.DataType:CHARACTER).
      arrayvar5[2] = new Progress.Data.ColumnPropDesc("FileId", "Индиф.", Progress.Data.DataType:CHARACTER).
      arrayvar5[3] = new Progress.Data.ColumnPropDesc("RunFile", "Выполнить", Progress.Data.DataType:LOGICAL).
      tableDesc3:Columns = arrayvar5.
      this-object:BindFileList:TableSchema = tableDesc3.
      /*  */
      /* BindFileRep */
      /*  */
      this-object:BindFileRep:AutoUpdate = true.
      this-object:BindFileRep:MaxDataGuess = 0.
      this-object:BindFileRep:NoLOBs = false.
      this-object:BindFileRep:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar6 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar6 = new "Progress.Data.TableDesc[]"(0).
      tableDesc4:ChildTables = arrayvar6.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar7 as Progress.Data.ColumnPropDesc extent 4 no-undo.
      arrayvar7[1] = new Progress.Data.ColumnPropDesc("FileName_Old", "Файл для замены текста", Progress.Data.DataType:CHARACTER).
      arrayvar7[2] = new Progress.Data.ColumnPropDesc("FileName_New", "Новый файл", Progress.Data.DataType:CHARACTER).
      arrayvar7[3] = new Progress.Data.ColumnPropDesc("FileId", "№", Progress.Data.DataType:INTEGER).
      arrayvar7[4] = new Progress.Data.ColumnPropDesc("FileCycle", "Подставить зачения из доп. списка", Progress.Data.DataType:LOGICAL).
      tableDesc4:Columns = arrayvar7.
      this-object:BindFileRep:TableSchema = tableDesc4.
      /*  */
      /* dataVer */
      /*  */
      this-object:dataVer:AllowUserToAddRows = false.
      this-object:dataVer:AllowUserToDeleteRows = false.
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:dataVer:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:dataVer:AutoGenerateColumns = false.
      this-object:dataVer:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
      this-object:dataVer:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar8 as System.Windows.Forms.DataGridViewColumn extent 1 no-undo.
      arrayvar8[1] = this-object:versionDataGridViewTextBoxColumn.
      this-object:dataVer:Columns:AddRange(arrayvar8).
      this-object:dataVer:DataSource = this-object:BindVer.
      this-object:dataVer:EnableHeadersVisualStyles = false.
      this-object:dataVer:Location = new System.Drawing.Point(0, 65).
      this-object:dataVer:Name = "dataVer".
      this-object:dataVer:RowHeadersVisible = false.
      this-object:dataVer:Size = new System.Drawing.Size(97, 336).
      this-object:dataVer:TabIndex = 2.
      this-object:dataVer:CellClick:Subscribe(this-object:dataVer_CellClick).
      /*  */
      /* versionDataGridViewTextBoxColumn */
      /*  */
      this-object:versionDataGridViewTextBoxColumn:DataPropertyName = "version".
      this-object:versionDataGridViewTextBoxColumn:HeaderText = "Версия".
      this-object:versionDataGridViewTextBoxColumn:Name = "versionDataGridViewTextBoxColumn".
      /*  */
      /* dataParamRep */
      /*  */
      this-object:dataParamRep:AllowUserToAddRows = false.
      this-object:dataParamRep:AllowUserToDeleteRows = false.
      this-object:dataParamRep:AutoGenerateColumns = false.
      this-object:dataParamRep:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar9 as System.Windows.Forms.DataGridViewColumn extent 3 no-undo.
      arrayvar9[1] = this-object:versionidDataGridViewTextBoxColumn.
      arrayvar9[2] = this-object:valueOldDataGridViewTextBoxColumn.
      arrayvar9[3] = this-object:valuenewDataGridViewTextBoxColumn.
      this-object:dataParamRep:Columns:AddRange(arrayvar9).
      this-object:dataParamRep:DataSource = this-object:BindParam.
      this-object:dataParamRep:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:dataParamRep:EnableHeadersVisualStyles = false.
      this-object:dataParamRep:Location = new System.Drawing.Point(0, 0).
      this-object:dataParamRep:Name = "dataParamRep".
      this-object:dataParamRep:RowHeadersVisible = false.
      this-object:dataParamRep:Size = new System.Drawing.Size(662, 178).
      this-object:dataParamRep:TabIndex = 3.
      /*  */
      /* versionidDataGridViewTextBoxColumn */
      /*  */
      this-object:versionidDataGridViewTextBoxColumn:DataPropertyName = "version_id".
      this-object:versionidDataGridViewTextBoxColumn:HeaderText = "№".
      this-object:versionidDataGridViewTextBoxColumn:Name = "versionidDataGridViewTextBoxColumn".
      this-object:versionidDataGridViewTextBoxColumn:Width = 30.
      /*  */
      /* valueOldDataGridViewTextBoxColumn */
      /*  */
      this-object:valueOldDataGridViewTextBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
      this-object:valueOldDataGridViewTextBoxColumn:DataPropertyName = "Value_Old".
      this-object:valueOldDataGridViewTextBoxColumn:HeaderText = "Заменить с".
      this-object:valueOldDataGridViewTextBoxColumn:Name = "valueOldDataGridViewTextBoxColumn".
      /*  */
      /* valuenewDataGridViewTextBoxColumn */
      /*  */
      this-object:valuenewDataGridViewTextBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
      this-object:valuenewDataGridViewTextBoxColumn:DataPropertyName = "Value_new".
      this-object:valuenewDataGridViewTextBoxColumn:HeaderText = "Заменить на".
      this-object:valuenewDataGridViewTextBoxColumn:Name = "valuenewDataGridViewTextBoxColumn".
      /*  */
      /* dataFileList */
      /*  */
      this-object:dataFileList:AllowUserToAddRows = false.
      this-object:dataFileList:AllowUserToDeleteRows = false.
      define variable nestedvar3 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar3 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:dataFileList:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:dataFileList:AutoGenerateColumns = false.
      this-object:dataFileList:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
      this-object:dataFileList:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar10 as System.Windows.Forms.DataGridViewColumn extent 3 no-undo.
      arrayvar10[1] = this-object:fileIdDataGridViewTextBoxColumn.
      arrayvar10[2] = this-object:fileNameDataGridViewTextBoxColumn.
      arrayvar10[3] = this-object:runFileDataGridViewCheckBoxColumn.
      this-object:dataFileList:Columns:AddRange(arrayvar10).
      this-object:dataFileList:DataSource = this-object:BindFileList.
      this-object:dataFileList:EnableHeadersVisualStyles = false.
      this-object:dataFileList:Location = new System.Drawing.Point(0, 26).
      this-object:dataFileList:Name = "dataFileList".
      this-object:dataFileList:RowHeadersVisible = false.
      this-object:dataFileList:Size = new System.Drawing.Size(250, 169).
      this-object:dataFileList:TabIndex = 4.
      /*  */
      /* fileIdDataGridViewTextBoxColumn */
      /*  */
      this-object:fileIdDataGridViewTextBoxColumn:DataPropertyName = "FileId".
      this-object:fileIdDataGridViewTextBoxColumn:HeaderText = "Индиф.".
      this-object:fileIdDataGridViewTextBoxColumn:Name = "fileIdDataGridViewTextBoxColumn".
      /*  */
      /* fileNameDataGridViewTextBoxColumn */
      /*  */
      this-object:fileNameDataGridViewTextBoxColumn:DataPropertyName = "FileName".
      this-object:fileNameDataGridViewTextBoxColumn:HeaderText = " Файл запуска".
      this-object:fileNameDataGridViewTextBoxColumn:Name = "fileNameDataGridViewTextBoxColumn".
      /*  */
      /* runFileDataGridViewCheckBoxColumn */
      /*  */
      this-object:runFileDataGridViewCheckBoxColumn:DataPropertyName = "RunFile".
      this-object:runFileDataGridViewCheckBoxColumn:HeaderText = "Выполнить".
      this-object:runFileDataGridViewCheckBoxColumn:Name = "runFileDataGridViewCheckBoxColumn".
      /*  */
      /* splitContainer1 */
      /*  */
      define variable nestedvar4 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar4 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:splitContainer1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar4, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:splitContainer1:BorderStyle = System.Windows.Forms.BorderStyle:Fixed3D.
      this-object:splitContainer1:FixedPanel = System.Windows.Forms.FixedPanel:Panel1.
      this-object:splitContainer1:Location = new System.Drawing.Point(4, 71).
      this-object:splitContainer1:Name = "splitContainer1".
      /*  */
      /* splitContainer1.Panel1 */
      /*  */
      this-object:splitContainer1:Panel1:Controls:Add(this-object:btn_del).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:btn_edit).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:btn_add).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:dataVer).
      /*  */
      /* splitContainer1.Panel2 */
      /*  */
      this-object:splitContainer1:Panel2:Controls:Add(this-object:splitContainer2).
      this-object:splitContainer1:Size = new System.Drawing.Size(771, 405).
      this-object:splitContainer1:SplitterDistance = 101.
      this-object:splitContainer1:TabIndex = 5.
      /*  */
      /* btn_del */
      /*  */
      this-object:btn_del:Location = new System.Drawing.Point(0, 40).
      this-object:btn_del:Name = "btn_del".
      this-object:btn_del:Size = new System.Drawing.Size(73, 19).
      this-object:btn_del:TabIndex = 5.
      this-object:btn_del:Text = "Удалить".
      this-object:btn_del:UseCompatibleTextRendering = true.
      this-object:btn_del:UseVisualStyleBackColor = true.
      this-object:btn_del:Click:Subscribe(this-object:btn_del_Click).
      /*  */
      /* btn_edit */
      /*  */
      this-object:btn_edit:Location = new System.Drawing.Point(0, 20).
      this-object:btn_edit:Name = "btn_edit".
      this-object:btn_edit:Size = new System.Drawing.Size(73, 19).
      this-object:btn_edit:TabIndex = 4.
      this-object:btn_edit:Text = "Изменить".
      this-object:btn_edit:UseCompatibleTextRendering = true.
      this-object:btn_edit:UseVisualStyleBackColor = true.
      this-object:btn_edit:Click:Subscribe(this-object:btn_edit_Click).
      /*  */
      /* btn_add */
      /*  */
      this-object:btn_add:Location = new System.Drawing.Point(0, 0).
      this-object:btn_add:Name = "btn_add".
      this-object:btn_add:Size = new System.Drawing.Size(73, 19).
      this-object:btn_add:TabIndex = 3.
      this-object:btn_add:Text = "Добавить".
      this-object:btn_add:UseCompatibleTextRendering = true.
      this-object:btn_add:UseVisualStyleBackColor = true.
      this-object:btn_add:Click:Subscribe(this-object:btn_add_Click).
      /*  */
      /* splitContainer2 */
      /*  */
      this-object:splitContainer2:BorderStyle = System.Windows.Forms.BorderStyle:Fixed3D.
      this-object:splitContainer2:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:splitContainer2:FixedPanel = System.Windows.Forms.FixedPanel:Panel2.
      this-object:splitContainer2:Location = new System.Drawing.Point(0, 0).
      this-object:splitContainer2:Name = "splitContainer2".
      this-object:splitContainer2:Orientation = System.Windows.Forms.Orientation:Horizontal.
      /*  */
      /* splitContainer2.Panel1 */
      /*  */
      this-object:splitContainer2:Panel1:Controls:Add(this-object:dataParamRep).
      /*  */
      /* splitContainer2.Panel2 */
      /*  */
      this-object:splitContainer2:Panel2:Controls:Add(this-object:splitContainer3).
      this-object:splitContainer2:Size = new System.Drawing.Size(666, 405).
      this-object:splitContainer2:SplitterDistance = 182.
      this-object:splitContainer2:TabIndex = 0.
      /*  */
      /* splitContainer3 */
      /*  */
      this-object:splitContainer3:BorderStyle = System.Windows.Forms.BorderStyle:Fixed3D.
      this-object:splitContainer3:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:splitContainer3:Location = new System.Drawing.Point(0, 0).
      this-object:splitContainer3:Name = "splitContainer3".
      /*  */
      /* splitContainer3.Panel1 */
      /*  */
      this-object:splitContainer3:Panel1:Controls:Add(this-object:btn_file_del).
      this-object:splitContainer3:Panel1:Controls:Add(this-object:btn_file_edit).
      this-object:splitContainer3:Panel1:Controls:Add(this-object:btn_file_add).
      this-object:splitContainer3:Panel1:Controls:Add(this-object:dataGridView1).
      /*  */
      /* splitContainer3.Panel2 */
      /*  */
      this-object:splitContainer3:Panel2:Controls:Add(this-object:btn_del_file_list).
      this-object:splitContainer3:Panel2:Controls:Add(this-object:btn_edit_file_list).
      this-object:splitContainer3:Panel2:Controls:Add(this-object:btn_Add_file_list).
      this-object:splitContainer3:Panel2:Controls:Add(this-object:label1).
      this-object:splitContainer3:Panel2:Controls:Add(this-object:dataFileList).
      this-object:splitContainer3:Size = new System.Drawing.Size(666, 219).
      this-object:splitContainer3:SplitterDistance = 408.
      this-object:splitContainer3:TabIndex = 0.
      /*  */
      /* btn_file_del */
      /*  */
      this-object:btn_file_del:Location = new System.Drawing.Point(163, 1).
      this-object:btn_file_del:Name = "btn_file_del".
      this-object:btn_file_del:Size = new System.Drawing.Size(75, 23).
      this-object:btn_file_del:TabIndex = 3.
      this-object:btn_file_del:Text = "Удалить".
      this-object:btn_file_del:UseCompatibleTextRendering = true.
      this-object:btn_file_del:UseVisualStyleBackColor = true.
      this-object:btn_file_del:Click:Subscribe(this-object:btn_file_del_Click).
      /*  */
      /* btn_file_edit */
      /*  */
      this-object:btn_file_edit:Location = new System.Drawing.Point(82, 1).
      this-object:btn_file_edit:Name = "btn_file_edit".
      this-object:btn_file_edit:Size = new System.Drawing.Size(75, 23).
      this-object:btn_file_edit:TabIndex = 2.
      this-object:btn_file_edit:Text = "Изменить".
      this-object:btn_file_edit:UseCompatibleTextRendering = true.
      this-object:btn_file_edit:UseVisualStyleBackColor = true.
      this-object:btn_file_edit:Click:Subscribe(this-object:btn_file_edit_Click).
      /*  */
      /* btn_file_add */
      /*  */
      this-object:btn_file_add:Location = new System.Drawing.Point(1, 1).
      this-object:btn_file_add:Name = "btn_file_add".
      this-object:btn_file_add:Size = new System.Drawing.Size(75, 23).
      this-object:btn_file_add:TabIndex = 1.
      this-object:btn_file_add:Text = "Добавить".
      this-object:btn_file_add:UseCompatibleTextRendering = true.
      this-object:btn_file_add:UseVisualStyleBackColor = true.
      this-object:btn_file_add:Click:Subscribe(this-object:btn_file_add_Click).
      /*  */
      /* dataGridView1 */
      /*  */
      this-object:dataGridView1:AllowUserToAddRows = false.
      this-object:dataGridView1:AllowUserToDeleteRows = false.
      define variable nestedvar5 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar5 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar5, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:AutoGenerateColumns = false.
      this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar11 as System.Windows.Forms.DataGridViewColumn extent 4 no-undo.
      arrayvar11[1] = this-object:fileIdDataGridViewTextBoxColumn1.
      arrayvar11[2] = this-object:fileNameOldDataGridViewTextBoxColumn.
      arrayvar11[3] = this-object:fileNameNewDataGridViewTextBoxColumn.
      arrayvar11[4] = this-object:fileCycleDataGridViewCheckBoxColumn.
      this-object:dataGridView1:Columns:AddRange(arrayvar11).
      this-object:dataGridView1:DataSource = this-object:BindFileRep.
      this-object:dataGridView1:Location = new System.Drawing.Point(0, 26).
      this-object:dataGridView1:Name = "dataGridView1".
      this-object:dataGridView1:ReadOnly = true.
      this-object:dataGridView1:RowHeadersVisible = false.
      this-object:dataGridView1:Size = new System.Drawing.Size(404, 189).
      this-object:dataGridView1:TabIndex = 0.
      /*  */
      /* fileIdDataGridViewTextBoxColumn1 */
      /*  */
      this-object:fileIdDataGridViewTextBoxColumn1:DataPropertyName = "FileId".
      this-object:fileIdDataGridViewTextBoxColumn1:HeaderText = "№".
      this-object:fileIdDataGridViewTextBoxColumn1:Name = "fileIdDataGridViewTextBoxColumn1".
      this-object:fileIdDataGridViewTextBoxColumn1:ReadOnly = true.
      this-object:fileIdDataGridViewTextBoxColumn1:Width = 30.
      /*  */
      /* fileNameOldDataGridViewTextBoxColumn */
      /*  */
      this-object:fileNameOldDataGridViewTextBoxColumn:DataPropertyName = "FileName_Old".
      this-object:fileNameOldDataGridViewTextBoxColumn:HeaderText = "Файл для замены текста".
      this-object:fileNameOldDataGridViewTextBoxColumn:Name = "fileNameOldDataGridViewTextBoxColumn".
      this-object:fileNameOldDataGridViewTextBoxColumn:ReadOnly = true.
      /*  */
      /* fileNameNewDataGridViewTextBoxColumn */
      /*  */
      this-object:fileNameNewDataGridViewTextBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
      this-object:fileNameNewDataGridViewTextBoxColumn:DataPropertyName = "FileName_New".
      this-object:fileNameNewDataGridViewTextBoxColumn:HeaderText = "Новый файл".
      this-object:fileNameNewDataGridViewTextBoxColumn:Name = "fileNameNewDataGridViewTextBoxColumn".
      this-object:fileNameNewDataGridViewTextBoxColumn:ReadOnly = true.
      /*  */
      /* fileCycleDataGridViewCheckBoxColumn */
      /*  */
      this-object:fileCycleDataGridViewCheckBoxColumn:DataPropertyName = "FileCycle".
      this-object:fileCycleDataGridViewCheckBoxColumn:HeaderText = "Подставить зачения из доп. списка".
      this-object:fileCycleDataGridViewCheckBoxColumn:Name = "fileCycleDataGridViewCheckBoxColumn".
      this-object:fileCycleDataGridViewCheckBoxColumn:ReadOnly = true.
      /*  */
      /* btn_del_file_list */
      /*  */
      this-object:btn_del_file_list:Location = new System.Drawing.Point(168, 1).
      this-object:btn_del_file_list:Name = "btn_del_file_list".
      this-object:btn_del_file_list:Size = new System.Drawing.Size(75, 23).
      this-object:btn_del_file_list:TabIndex = 4.
      this-object:btn_del_file_list:Text = "Удалить".
      this-object:btn_del_file_list:UseCompatibleTextRendering = true.
      this-object:btn_del_file_list:UseVisualStyleBackColor = true.
      this-object:btn_del_file_list:Click:Subscribe(this-object:btn_del_file_list_Click).
      /*  */
      /* btn_edit_file_list */
      /*  */
      this-object:btn_edit_file_list:Location = new System.Drawing.Point(86, 1).
      this-object:btn_edit_file_list:Name = "btn_edit_file_list".
      this-object:btn_edit_file_list:Size = new System.Drawing.Size(75, 23).
      this-object:btn_edit_file_list:TabIndex = 4.
      this-object:btn_edit_file_list:Text = "Изменить".
      this-object:btn_edit_file_list:UseCompatibleTextRendering = true.
      this-object:btn_edit_file_list:UseVisualStyleBackColor = true.
      this-object:btn_edit_file_list:Click:Subscribe(this-object:btn_edit_file_list_Click).
      /*  */
      /* btn_Add_file_list */
      /*  */
      this-object:btn_Add_file_list:Location = new System.Drawing.Point(3, 1).
      this-object:btn_Add_file_list:Name = "btn_Add_file_list".
      this-object:btn_Add_file_list:Size = new System.Drawing.Size(75, 23).
      this-object:btn_Add_file_list:TabIndex = 4.
      this-object:btn_Add_file_list:Text = "Добавить".
      this-object:btn_Add_file_list:UseCompatibleTextRendering = true.
      this-object:btn_Add_file_list:UseVisualStyleBackColor = true.
      this-object:btn_Add_file_list:Click:Subscribe(this-object:btn_Add_file_list_Click).
      /*  */
      /* label1 */
      /*  */
      define variable nestedvar6 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar6 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Bottom, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:label1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar6, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:label1:Location = new System.Drawing.Point(3, 198).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(236, 17).
      this-object:label1:TabIndex = 5.
      this-object:label1:Text = "Тег #FileId# #FileName#".
      this-object:label1:UseCompatibleTextRendering = true.
      /*  */
      /* FileVer */
      /*  */
      this-object:FileVer:Location = new System.Drawing.Point(179, 8).
      this-object:FileVer:Name = "FileVer".
      this-object:FileVer:Size = new System.Drawing.Size(425, 20).
      this-object:FileVer:TabIndex = 6.
      /*  */
      /* openFileDialog */
      /*  */
      this-object:openFileDialog:FileName = "openFileDialog".
      /*  */
      /* btn_openfile */
      /*  */
      this-object:btn_openfile:Location = new System.Drawing.Point(610, 8).
      this-object:btn_openfile:Name = "btn_openfile".
      this-object:btn_openfile:Size = new System.Drawing.Size(75, 23).
      this-object:btn_openfile:TabIndex = 7.
      this-object:btn_openfile:Text = "Открыть".
      this-object:btn_openfile:UseCompatibleTextRendering = true.
      this-object:btn_openfile:UseVisualStyleBackColor = true.
      this-object:btn_openfile:Click:Subscribe(this-object:button1_Click).
      /*  */
      /* btn_save */
      /*  */
      this-object:btn_save:Location = new System.Drawing.Point(691, 8).
      this-object:btn_save:Name = "btn_save".
      this-object:btn_save:Size = new System.Drawing.Size(75, 23).
      this-object:btn_save:TabIndex = 8.
      this-object:btn_save:Text = "Сохранить".
      this-object:btn_save:UseCompatibleTextRendering = true.
      this-object:btn_save:UseVisualStyleBackColor = true.
      this-object:btn_save:Click:Subscribe(this-object:btn_save_Click).
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Location = new System.Drawing.Point(22, 11).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(103, 23).
      this-object:label2:TabIndex = 9.
      this-object:label2:Text = "Файл параметров".
      this-object:label2:UseCompatibleTextRendering = true.
      /*  */
      /* FileHotParam */
      /*  */
      this-object:FileHotParam:Location = new System.Drawing.Point(179, 35).
      this-object:FileHotParam:Name = "FileHotParam".
      this-object:FileHotParam:Size = new System.Drawing.Size(425, 20).
      this-object:FileHotParam:TabIndex = 10.
      /*  */
      /* label3 */
      /*  */
      this-object:label3:Location = new System.Drawing.Point(22, 35).
      this-object:label3:Name = "label3".
      this-object:label3:Size = new System.Drawing.Size(151, 23).
      this-object:label3:TabIndex = 11.
      this-object:label3:Text = "Файл горячих параметров".
      this-object:label3:UseCompatibleTextRendering = true.
      /*  */
      /* btn_openfilehot */
      /*  */
      this-object:btn_openfilehot:Location = new System.Drawing.Point(611, 38).
      this-object:btn_openfilehot:Name = "btn_openfilehot".
      this-object:btn_openfilehot:Size = new System.Drawing.Size(75, 23).
      this-object:btn_openfilehot:TabIndex = 12.
      this-object:btn_openfilehot:Text = "Открыть".
      this-object:btn_openfilehot:UseCompatibleTextRendering = true.
      this-object:btn_openfilehot:UseVisualStyleBackColor = true.
      this-object:btn_openfilehot:Click:Subscribe(this-object:btn_openfilehot_Click).
      /*  */
      /* runth */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
      this-object:AutoScaleMode = System.Windows.Forms.AutoScaleMode:Font.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(777, 518).
      this-object:Controls:Add(this-object:btn_openfilehot).
      this-object:Controls:Add(this-object:label3).
      this-object:Controls:Add(this-object:FileHotParam).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:btn_save).
      this-object:Controls:Add(this-object:btn_openfile).
      this-object:Controls:Add(this-object:FileVer).
      this-object:Controls:Add(this-object:splitContainer1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:SizableToolWindow.
      this-object:Name = "runth".
      this-object:Text = "Настройка".
      cast(this-object:BindVer, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:BindParam, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:BindFileList, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:BindFileRep, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:dataVer, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:dataParamRep, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:dataFileList, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer1:Panel1:ResumeLayout(false).
      this-object:splitContainer1:Panel2:ResumeLayout(false).
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer1:ResumeLayout(false).
      this-object:splitContainer2:Panel1:ResumeLayout(false).
      this-object:splitContainer2:Panel2:ResumeLayout(false).
      cast(this-object:splitContainer2, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer2:ResumeLayout(false).
      this-object:splitContainer3:Panel1:ResumeLayout(false).
      this-object:splitContainer3:Panel2:ResumeLayout(false).
      cast(this-object:splitContainer3, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer3:ResumeLayout(false).
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:ResumeLayout(false).
      this-object:PerformLayout().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 
   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.

   /* эти файл должен быть в конце иначе дизайнер не понимает препроцессоры и открывает пустую форму */
   {runth\param.i class }
end class.
