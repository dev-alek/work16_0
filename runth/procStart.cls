 /*------------------------------------------------------------------------
    File        : procStart
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sat May 06 10:04:27 MSK 2023
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
using Progress.Windows.Forms.*.  
block-level on error undo, throw.
class runth.procStart inherits Form : 

   define private variable bindProc as Progress.Data.BindingSource no-undo.
   define private variable button1 as System.Windows.Forms.Button no-undo.
   define private variable Column1 as System.Windows.Forms.DataGridViewImageColumn no-undo.
   define private variable comboBox3 as System.Windows.Forms.ComboBox no-undo.
   define private variable comboBox2 as System.Windows.Forms.ComboBox no-undo.
   define private variable comboBox1 as System.Windows.Forms.ComboBox no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable Desc_ as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable folderBrowserDialog as System.Windows.Forms.FolderBrowserDialog no-undo.
   define private variable imageList as System.Windows.Forms.ImageList no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   define private variable label3 as System.Windows.Forms.Label no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define private variable runFileDataGridViewCheckBoxColumn as System.Windows.Forms.DataGridViewCheckBoxColumn no-undo.
   define private variable fileNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
    
   
   define variable mTrg as class runth.runth_trg no-undo.
   define private variable WorkDir as System.Windows.Forms.TextBox no-undo.
   
   method private void loadProc ():
      define variable vdir  as character no-undo.
      define variable vdir1 as character no-undo.
      define variable vdir2 as character no-undo.
      define variable vdir3 as character no-undo.
      mtrg:loadProc(output vdir,
                    output vdir1,
                    output vdir2,
                    output vdir3
               ).
      if vdir ne ""
      then
         assign
            WorkDir:text   = vdir
            comboBox1:text = vdir1
            comboBox2:text = vdir2
            comboBox3:text = vdir3
         .
      mTrg:updComboBox(WorkDir:Text, comboBox1).
      mTrg:updComboBox(WorkDir:Text, comboBox1:Text,comboBox2).
      mTrg:updComboBox(WorkDir:Text, comboBox1:Text,comboBox2:Text,comboBox3).
      if vdir ne ""
      then
         assign
            WorkDir:text   = vdir
            comboBox1:text = vdir1
            comboBox2:text = vdir2
            comboBox3:text = vdir3
         .
   end.
   
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void procStart_FormClosing( input sender as System.Object, input e as System.Windows.Forms.FormClosingEventArgs ):
		saveProc ().
		return.

	end method.

   method private void saveProc ():
      mtrg:saveProc(WorkDir:text,
                    comboBox1:text,
                    comboBox2:text,
                    comboBox3:text
               ).
      
   end.
   
   constructor public procStart( ):
   
      super().
      InitializeComponent ( ).
      mtrg = new runth.runth_trg().
      bindProc:handle = mTrg:getQuery("procRun").
      loadProc().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   constructor public procStart(itrg as class runth.runth_trg ):
   
      super().
      InitializeComponent ( ).
      mtrg = itrg.
      bindProc:handle = mTrg:getQuery("procRun").
      loadProc().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.
   destructor public procStart( ):

      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   




	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button1_Click( input sender as System.Object, input e as System.EventArgs ):
		define variable result as System.Windows.Forms.DialogResult no-undo.
		wait-for folderBrowserDialog:ShowDialog() set result.
      if( result = System.Windows.Forms.DialogResult:OK )
      then do:
         WorkDir:Text = folderBrowserDialog:SelectedPath.
      end.
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_MouseDoubleClick( input sender as System.Object, input e as System.Windows.Forms.MouseEventArgs ):
		mTrg:runProc().
      
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_RowPostPaint( input sender as System.Object, input e as System.Windows.Forms.DataGridViewRowPostPaintEventArgs ):
      define variable vfilename as character no-undo.
      vfilename = dataGridView1:Rows[e:RowIndex]:Cells[2]:Value:ToString().
      if mTrg:repaintProc(vfilename) then
		   dataGridView1:Rows[e:RowIndex]:Cells[0]:Value = imageList:Images[if mTrg:isRun(vfilename) then 0 else 1].
		return.

	end method.



	method private void okButton_Click (sender as System.Object, e as System.EventArgs):
      define variable v-listth-brw as class runth.ThStart no-undo .
      v-listth-brw = new runth.ThStart ( mTrg ).
      wait-for  v-listth-brw:ShowDialog() .
      delete object v-listth-brw.
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
      define variable tableDesc2 as Progress.Data.TableDesc no-undo.
      tableDesc2 = new Progress.Data.TableDesc("tt-procList").
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable resources as Progress.Util.ResourceManager no-undo.
      resources = new Progress.Util.ResourceManager("runth.procStart").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
      this-object:Column1 = new System.Windows.Forms.DataGridViewImageColumn().
      this-object:runFileDataGridViewCheckBoxColumn = new System.Windows.Forms.DataGridViewCheckBoxColumn().
      this-object:fileNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:Desc_ = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:bindProc = new Progress.Data.BindingSource(this-object:components).
      this-object:imageList = new System.Windows.Forms.ImageList(this-object:components).
      this-object:WorkDir = new System.Windows.Forms.TextBox().
      this-object:button1 = new System.Windows.Forms.Button().
      this-object:comboBox1 = new System.Windows.Forms.ComboBox().
      this-object:comboBox2 = new System.Windows.Forms.ComboBox().
      this-object:comboBox3 = new System.Windows.Forms.ComboBox().
      this-object:folderBrowserDialog = new System.Windows.Forms.FolderBrowserDialog().
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:label2 = new System.Windows.Forms.Label().
      this-object:label3 = new System.Windows.Forms.Label().
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:bindProc, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(491, 384).
      this-object:buttonOk:Name = "buttonOk".
      this-object:buttonOk:Size = new System.Drawing.Size(75, 23).
      this-object:buttonOk:TabIndex = 0.
      this-object:buttonOk:Text = "Создать".
      this-object:buttonOk:UseCompatibleTextRendering = true.
      this-object:buttonOk:Click:Subscribe(this-object:okButton_Click).
      /*  */
      /* buttonCancel */
      /*  */
      define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar1 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonCancel:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
      this-object:buttonCancel:Location = new System.Drawing.Point(575, 384).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Выход".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* dataGridView1 */
      /*  */
      this-object:dataGridView1:AllowUserToAddRows = false.
      this-object:dataGridView1:AllowUserToDeleteRows = false.
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:AutoGenerateColumns = false.
      this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 4 no-undo.
      arrayvar0[1] = this-object:Column1.
      arrayvar0[2] = this-object:runFileDataGridViewCheckBoxColumn.
      arrayvar0[3] = this-object:fileNameDataGridViewTextBoxColumn.
      arrayvar0[4] = this-object:Desc_.
      this-object:dataGridView1:Columns:AddRange(arrayvar0).
      this-object:dataGridView1:DataSource = this-object:bindProc.
      this-object:dataGridView1:Location = new System.Drawing.Point(12, 71).
      this-object:dataGridView1:Name = "dataGridView1".
      this-object:dataGridView1:ReadOnly = true.
      this-object:dataGridView1:Size = new System.Drawing.Size(638, 307).
      this-object:dataGridView1:TabIndex = 2.
      this-object:dataGridView1:RowPostPaint:Subscribe(this-object:dataGridView1_RowPostPaint).
      this-object:dataGridView1:MouseDoubleClick:Subscribe(this-object:dataGridView1_MouseDoubleClick).
      /*  */
      /* Column1 */
      /*  */
      this-object:Column1:HeaderText = "".
      this-object:Column1:Name = "Column1".
      this-object:Column1:ReadOnly = true.
      this-object:Column1:Width = 20.
      /*  */
      /* runFileDataGridViewCheckBoxColumn */
      /*  */
      this-object:runFileDataGridViewCheckBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:ColumnHeader.
      this-object:runFileDataGridViewCheckBoxColumn:DataPropertyName = "RunFile".
      this-object:runFileDataGridViewCheckBoxColumn:FalseValue = "".
      this-object:runFileDataGridViewCheckBoxColumn:HeaderText = "Выполнить".
      this-object:runFileDataGridViewCheckBoxColumn:Name = "runFileDataGridViewCheckBoxColumn".
      this-object:runFileDataGridViewCheckBoxColumn:ReadOnly = true.
      this-object:runFileDataGridViewCheckBoxColumn:Visible = false.
      /*  */
      /* fileNameDataGridViewTextBoxColumn */
      /*  */
      this-object:fileNameDataGridViewTextBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:DisplayedCellsExceptHeader.
      this-object:fileNameDataGridViewTextBoxColumn:DataPropertyName = "FileName".
      this-object:fileNameDataGridViewTextBoxColumn:HeaderText = "Файл".
      this-object:fileNameDataGridViewTextBoxColumn:Name = "fileNameDataGridViewTextBoxColumn".
      this-object:fileNameDataGridViewTextBoxColumn:ReadOnly = true.
      this-object:fileNameDataGridViewTextBoxColumn:Width = 21.
      /*  */
      /* Desc_ */
      /*  */
      this-object:Desc_:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
      this-object:Desc_:DataPropertyName = "Desc_".
      this-object:Desc_:HeaderText = "Описание".
      this-object:Desc_:Name = "Desc_".
      this-object:Desc_:ReadOnly = true.
      /*  */
      /* bindProc */
      /*  */
      this-object:bindProc:MaxDataGuess = 0.
      this-object:bindProc:NoLOBs = false.
      this-object:bindProc:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar1 = new "Progress.Data.TableDesc[]"(0).
      tableDesc2:ChildTables = arrayvar1.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar2[1] = new Progress.Data.ColumnPropDesc("FileName", "Файл", Progress.Data.DataType:CHARACTER).
      arrayvar2[2] = new Progress.Data.ColumnPropDesc("RunFile", "Выполнить", Progress.Data.DataType:LOGICAL).
      arrayvar2[3] = new Progress.Data.ColumnPropDesc("Desc_", "Описание", Progress.Data.DataType:CHARACTER).
      tableDesc2:Columns = arrayvar2.
      this-object:bindProc:TableSchema = tableDesc2.
      /*  */
      /* imageList */
      /*  */
      this-object:imageList:ImageStream = cast(resources:GetObject("imageList.ImageStream"), System.Windows.Forms.ImageListStreamer).
      this-object:imageList:TransparentColor = System.Drawing.Color:Transparent.
      this-object:imageList:Images:SetKeyName(0, "run.bmp").
      this-object:imageList:Images:SetKeyName(1, "runi.bmp").
      /*  */
      /* WorkDir */
      /*  */
      this-object:WorkDir:Location = new System.Drawing.Point(33, 14).
      this-object:WorkDir:Name = "WorkDir".
      this-object:WorkDir:Size = new System.Drawing.Size(533, 20).
      this-object:WorkDir:TabIndex = 3.
      this-object:WorkDir:Text = "C:\WRK\th_bat".
      this-object:WorkDir:TextChanged:Subscribe(this-object:WorkDir_TextChanged).
      /*  */
      /* button1 */
      /*  */
      this-object:button1:Location = new System.Drawing.Point(582, 11).
      this-object:button1:Name = "button1".
      this-object:button1:Size = new System.Drawing.Size(75, 23).
      this-object:button1:TabIndex = 4.
      this-object:button1:Text = "Выбрать".
      this-object:button1:UseCompatibleTextRendering = true.
      this-object:button1:UseVisualStyleBackColor = true.
      this-object:button1:Click:Subscribe(this-object:button1_Click).
      /*  */
      /* comboBox1 */
      /*  */
      this-object:comboBox1:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
      this-object:comboBox1:FormattingEnabled = true.
      this-object:comboBox1:Location = new System.Drawing.Point(33, 44).
      this-object:comboBox1:Name = "comboBox1".
      this-object:comboBox1:Size = new System.Drawing.Size(190, 21).
      this-object:comboBox1:TabIndex = 5.
      this-object:comboBox1:SelectedIndexChanged:Subscribe(this-object:comboBox1_SelectedIndexChanged).
      /*  */
      /* comboBox2 */
      /*  */
      this-object:comboBox2:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
      this-object:comboBox2:FormattingEnabled = true.
      this-object:comboBox2:Location = new System.Drawing.Point(249, 44).
      this-object:comboBox2:Name = "comboBox2".
      this-object:comboBox2:Size = new System.Drawing.Size(191, 21).
      this-object:comboBox2:TabIndex = 6.
      this-object:comboBox2:SelectedIndexChanged:Subscribe(this-object:comboBox2_SelectedIndexChanged).
      /*  */
      /* comboBox3 */
      /*  */
      this-object:comboBox3:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
      this-object:comboBox3:FormattingEnabled = true.
      this-object:comboBox3:Location = new System.Drawing.Point(466, 44).
      this-object:comboBox3:Name = "comboBox3".
      this-object:comboBox3:Size = new System.Drawing.Size(191, 21).
      this-object:comboBox3:TabIndex = 7.
      this-object:comboBox3:SelectedIndexChanged:Subscribe(this-object:comboBox3_SelectedIndexChanged).
      /*  */
      /* folderBrowserDialog */
      /*  */
      this-object:folderBrowserDialog:SelectedPath = "C:\WRK\th_bat".
      /*  */
      /* label1 */
      /*  */
      this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(14.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:label1:Location = new System.Drawing.Point(13, 42).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(14, 23).
      this-object:label1:TabIndex = 8.
      this-object:label1:Text = "\".
      this-object:label1:UseCompatibleTextRendering = true.
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(14.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:label2:Location = new System.Drawing.Point(229, 42).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(14, 23).
      this-object:label2:TabIndex = 9.
      this-object:label2:Text = "\".
      this-object:label2:UseCompatibleTextRendering = true.
      /*  */
      /* label3 */
      /*  */
      this-object:label3:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(14.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:label3:Location = new System.Drawing.Point(446, 42).
      this-object:label3:Name = "label3".
      this-object:label3:Size = new System.Drawing.Size(14, 23).
      this-object:label3:TabIndex = 10.
      this-object:label3:Text = "\".
      this-object:label3:UseCompatibleTextRendering = true.
      /*  */
      /* procStart */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(664, 421).
      this-object:Controls:Add(this-object:label3).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:label1).
      this-object:Controls:Add(this-object:comboBox3).
      this-object:Controls:Add(this-object:comboBox2).
      this-object:Controls:Add(this-object:comboBox1).
      this-object:Controls:Add(this-object:button1).
      this-object:Controls:Add(this-object:WorkDir).
      this-object:Controls:Add(this-object:dataGridView1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "procStart".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "Запуск Trade House".
      this-object:FormClosing:Subscribe(this-object:procStart_FormClosing).
      this-object:Paint:Subscribe(this-object:procStart_Paint).
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:bindProc, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:ResumeLayout(false).
      this-object:PerformLayout().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void procStart_Paint( input sender as System.Object, input e as System.Windows.Forms.PaintEventArgs ):
/*		dataGridView1:Rows[e:RowIndex]:Cells[2]:Value = imageList:Images[0].*/
		return.

	end method.

   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void WorkDir_TextChanged( input sender as System.Object, input e as System.EventArgs ):
		comboBox1:text = "".
		comboBox2:text = "".
		comboBox3:text = "".
		mTrg:updComboBox(WorkDir:Text, comboBox1).
		bindProc:RefreshAll().
		
		return.

	end method.

   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   @VisualDesigner.
   method private void comboBox1_SelectedIndexChanged( input sender as System.Object, input e as System.EventArgs ):
      comboBox2:text = "".
      comboBox3:text = "".
      mTrg:updComboBox(WorkDir:Text, comboBox1:Text,comboBox2).
      bindProc:RefreshAll().
      
      return.

   end method.
 
   /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   @VisualDesigner.
   method private void comboBox2_SelectedIndexChanged( input sender as System.Object, input e as System.EventArgs ):
      comboBox3:text = "".
      mTrg:updComboBox(WorkDir:Text, comboBox1:Text,comboBox2:Text,comboBox3).
      bindProc:RefreshAll().
      
      return.

   end method.
   
      /*------------------------------------------------------------------------------
    Purpose:
    Notes:
   ------------------------------------------------------------------------------*/
   @VisualDesigner.
   method private void comboBox3_SelectedIndexChanged( input sender as System.Object, input e as System.EventArgs ):
      define variable vdir as character no-undo.
      vdir = mTrg:glueDir(WorkDir:Text, comboBox1:Text,comboBox2:Text,comboBox3:text).
      mTrg:updProcList(vdir).
      bindProc:RefreshAll().
      
      return.

   end method.
end class.
