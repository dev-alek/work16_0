 /*------------------------------------------------------------------------
    File        : editver
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sat Oct 10 12:20:13 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class runth.editver inherits Form : 

   define private variable btn_edit as System.Windows.Forms.Button no-undo.
   define private variable btn_del as System.Windows.Forms.Button no-undo.
   define private variable btn_add as System.Windows.Forms.Button no-undo.
   define private variable bindVer as Progress.Data.BindingSource no-undo.
   define private variable bindParam as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable valuenewDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable valueOldDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   define private variable dataParam as System.Windows.Forms.DataGridView no-undo.
   define private variable Ver as System.Windows.Forms.TextBox no-undo.
   define variable mTrg as runth.runth_trg no-undo.
   define private variable versionidDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   constructor public editver( ):
   
      super().
      mtrg = new runth.runth_trg().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   constructor public editver(Itrg as runth.runth_trg ):
   
      super().
      mtrg = itrg.
      InitializeComponent ( ).
      bindVer:handle    = mtrg:getQuery("verOne").
      bindParam:Handle  = mTrg:getQuery("ParamsEdit").
      catch e as Progress.Lang.Error:
         undo, throw e.
   end catch.      

   end constructor.


   destructor public editver( ):
      if valid-object(bindParam) then bindParam:Dispose().
      if valid-object(bindVer)   then bindVer:Dispose().
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
		Mtrg:AddParam().
		bindParam:handle:query-open.
		bindParam:RefreshAll().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_del_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:DelParam().
		bindParam:handle:query-open.
		bindParam:RefreshAll().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_edit_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:EditParam().
		bindParam:Refresh().
		return.

	end method.

    method private void okButton_Click (sender as System.Object, e as System.EventArgs):
       if mtrg:CheckVer(Ver:Text)
       then do:
          bindVer:Assign().
          this-object:DialogResult = System.Windows.Forms.DialogResult:Ok.
          this-object:Close ( ).
       end.
       else
          message "Уже есть запись с такой версией"
          view-as alert-box. 
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
      tableDesc1 = new Progress.Data.TableDesc("tt-verOne").
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable tableDesc2 as Progress.Data.TableDesc no-undo.
      tableDesc2 = new Progress.Data.TableDesc("tt-Params").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:Ver = new System.Windows.Forms.TextBox().
      this-object:bindVer = new Progress.Data.BindingSource(this-object:components).
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:btn_add = new System.Windows.Forms.Button().
      this-object:btn_edit = new System.Windows.Forms.Button().
      this-object:btn_del = new System.Windows.Forms.Button().
      this-object:dataParam = new System.Windows.Forms.DataGridView().
      this-object:bindParam = new Progress.Data.BindingSource(this-object:components).
      this-object:versionidDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:valueOldDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:valuenewDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      cast(this-object:bindVer, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:dataParam, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:bindParam, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(368, 353).
      this-object:buttonOk:Name = "buttonOk".
      this-object:buttonOk:Size = new System.Drawing.Size(75, 23).
      this-object:buttonOk:TabIndex = 0.
      this-object:buttonOk:Text = "Сохратить".
      this-object:buttonOk:UseCompatibleTextRendering = true.
      this-object:buttonOk:Click:Subscribe(this-object:okButton_Click).
      /*  */
      /* buttonCancel */
      /*  */
      define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar1 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonCancel:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
      this-object:buttonCancel:Location = new System.Drawing.Point(452, 353).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* Ver */
      /*  */
      this-object:Ver:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindVer, "version", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:Ver:Location = new System.Drawing.Point(78, 12).
      this-object:Ver:Name = "Ver".
      this-object:Ver:Size = new System.Drawing.Size(425, 20).
      this-object:Ver:TabIndex = 2.
      /*  */
      /* bindVer */
      /*  */
      this-object:bindVer:MaxDataGuess = 0.
      this-object:bindVer:NoLOBs = false.
      this-object:bindVer:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar0 = new "Progress.Data.TableDesc[]"(0).
      tableDesc1:ChildTables = arrayvar0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 2 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("version", "", Progress.Data.DataType:CHARACTER).
      arrayvar1[2] = new Progress.Data.ColumnPropDesc("last_ver", "", Progress.Data.DataType:CHARACTER).
      tableDesc1:Columns = arrayvar1.
      this-object:bindVer:TableSchema = tableDesc1.
      /*  */
      /* label1 */
      /*  */
      this-object:label1:Location = new System.Drawing.Point(18, 12).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(54, 23).
      this-object:label1:TabIndex = 3.
      this-object:label1:Text = "Версия".
      this-object:label1:UseCompatibleTextRendering = true.
      /*  */
      /* btn_add */
      /*  */
      this-object:btn_add:Location = new System.Drawing.Point(12, 38).
      this-object:btn_add:Name = "btn_add".
      this-object:btn_add:Size = new System.Drawing.Size(75, 23).
      this-object:btn_add:TabIndex = 4.
      this-object:btn_add:Text = "Добавить".
      this-object:btn_add:UseCompatibleTextRendering = true.
      this-object:btn_add:UseVisualStyleBackColor = true.
      this-object:btn_add:Click:Subscribe(this-object:btn_add_Click).
      /*  */
      /* btn_edit */
      /*  */
      this-object:btn_edit:Location = new System.Drawing.Point(93, 38).
      this-object:btn_edit:Name = "btn_edit".
      this-object:btn_edit:Size = new System.Drawing.Size(75, 23).
      this-object:btn_edit:TabIndex = 5.
      this-object:btn_edit:Text = "Изменить".
      this-object:btn_edit:UseCompatibleTextRendering = true.
      this-object:btn_edit:UseVisualStyleBackColor = true.
      this-object:btn_edit:Click:Subscribe(this-object:btn_edit_Click).
      /*  */
      /* btn_del */
      /*  */
      this-object:btn_del:Location = new System.Drawing.Point(174, 38).
      this-object:btn_del:Name = "btn_del".
      this-object:btn_del:Size = new System.Drawing.Size(75, 23).
      this-object:btn_del:TabIndex = 6.
      this-object:btn_del:Text = "Удалить".
      this-object:btn_del:UseCompatibleTextRendering = true.
      this-object:btn_del:UseVisualStyleBackColor = true.
      this-object:btn_del:Click:Subscribe(this-object:btn_del_Click).
      /*  */
      /* dataParam */
      /*  */
      this-object:dataParam:AllowUserToAddRows = false.
      this-object:dataParam:AllowUserToDeleteRows = false.
      this-object:dataParam:AutoGenerateColumns = false.
      this-object:dataParam:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar2 as System.Windows.Forms.DataGridViewColumn extent 3 no-undo.
      arrayvar2[1] = this-object:versionidDataGridViewTextBoxColumn.
      arrayvar2[2] = this-object:valueOldDataGridViewTextBoxColumn.
      arrayvar2[3] = this-object:valuenewDataGridViewTextBoxColumn.
      this-object:dataParam:Columns:AddRange(arrayvar2).
      this-object:dataParam:DataSource = this-object:bindParam.
      this-object:dataParam:EnableHeadersVisualStyles = false.
      this-object:dataParam:Location = new System.Drawing.Point(3, 67).
      this-object:dataParam:Name = "dataParam".
      this-object:dataParam:ReadOnly = true.
      this-object:dataParam:RowHeadersVisible = false.
      this-object:dataParam:Size = new System.Drawing.Size(535, 280).
      this-object:dataParam:TabIndex = 7.
      /*  */
      /* bindParam */
      /*  */
      this-object:bindParam:MaxDataGuess = 0.
      this-object:bindParam:NoLOBs = false.
      this-object:bindParam:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar3 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar3 = new "Progress.Data.TableDesc[]"(0).
      tableDesc2:ChildTables = arrayvar3.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar4 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar4[1] = new Progress.Data.ColumnPropDesc("version_id", "Номер", Progress.Data.DataType:INTEGER).
      arrayvar4[2] = new Progress.Data.ColumnPropDesc("Value_Old", "Заменить с", Progress.Data.DataType:CHARACTER).
      arrayvar4[3] = new Progress.Data.ColumnPropDesc("Value_new", "Заменить на", Progress.Data.DataType:CHARACTER).
      tableDesc2:Columns = arrayvar4.
      this-object:bindParam:TableSchema = tableDesc2.
      /*  */
      /* versionidDataGridViewTextBoxColumn */
      /*  */
      this-object:versionidDataGridViewTextBoxColumn:DataPropertyName = "version_id".
      this-object:versionidDataGridViewTextBoxColumn:HeaderText = "№".
      this-object:versionidDataGridViewTextBoxColumn:Name = "versionidDataGridViewTextBoxColumn".
      this-object:versionidDataGridViewTextBoxColumn:ReadOnly = true.
      this-object:versionidDataGridViewTextBoxColumn:Width = 30.
      /*  */
      /* valueOldDataGridViewTextBoxColumn */
      /*  */
      this-object:valueOldDataGridViewTextBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
      this-object:valueOldDataGridViewTextBoxColumn:DataPropertyName = "Value_Old".
      this-object:valueOldDataGridViewTextBoxColumn:HeaderText = "Заменить с".
      this-object:valueOldDataGridViewTextBoxColumn:Name = "valueOldDataGridViewTextBoxColumn".
      this-object:valueOldDataGridViewTextBoxColumn:ReadOnly = true.
      /*  */
      /* valuenewDataGridViewTextBoxColumn */
      /*  */
      this-object:valuenewDataGridViewTextBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
      this-object:valuenewDataGridViewTextBoxColumn:DataPropertyName = "Value_new".
      this-object:valuenewDataGridViewTextBoxColumn:HeaderText = "Заменить на".
      this-object:valuenewDataGridViewTextBoxColumn:Name = "valuenewDataGridViewTextBoxColumn".
      this-object:valuenewDataGridViewTextBoxColumn:ReadOnly = true.
      /*  */
      /* editver */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(541, 390).
      this-object:Controls:Add(this-object:dataParam).
      this-object:Controls:Add(this-object:btn_del).
      this-object:Controls:Add(this-object:btn_edit).
      this-object:Controls:Add(this-object:btn_add).
      this-object:Controls:Add(this-object:label1).
      this-object:Controls:Add(this-object:Ver).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "editver".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "Редактирование параметров замены".
      cast(this-object:bindVer, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:dataParam, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:bindParam, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:ResumeLayout(false).
      this-object:PerformLayout().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 
   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.


 
end class.
