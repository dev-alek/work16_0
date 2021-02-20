 /*------------------------------------------------------------------------
    File        : ChoiceParam
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sun Oct 11 22:03:02 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class runth.ChoiceParam inherits Form : 

   define private variable bindParam as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable valuenewDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable valueOldDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
   define variable mTrg as class runth.runth_trg no-undo.
   constructor public ChoiceParam( ):
   
      super().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   constructor public ChoiceParam(itrg as class runth.runth_trg ):
   
      super().
      InitializeComponent ( ).
      mtrg = itrg.
      bindParam:handle = mTrg:getQuery("ParamsEdit").
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.
   destructor public ChoiceParam( ):

      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   

    method private void okButton_Click (sender as System.Object, e as System.EventArgs):
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
      tableDesc1 = new Progress.Data.TableDesc("tt-Params").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
      this-object:bindParam = new Progress.Data.BindingSource(this-object:components).
      this-object:valueOldDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:valuenewDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:bindParam, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(350, 279).
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
      this-object:buttonCancel:Location = new System.Drawing.Point(434, 279).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
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
      define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 2 no-undo.
      arrayvar0[1] = this-object:valueOldDataGridViewTextBoxColumn.
      arrayvar0[2] = this-object:valuenewDataGridViewTextBoxColumn.
      this-object:dataGridView1:Columns:AddRange(arrayvar0).
      this-object:dataGridView1:DataSource = this-object:bindParam.
      this-object:dataGridView1:EnableHeadersVisualStyles = false.
      this-object:dataGridView1:Location = new System.Drawing.Point(13, 13).
      this-object:dataGridView1:Name = "dataGridView1".
      this-object:dataGridView1:RowHeadersVisible = false.
      this-object:dataGridView1:Size = new System.Drawing.Size(498, 260).
      this-object:dataGridView1:TabIndex = 2.
      /*  */
      /* bindParam */
      /*  */
      this-object:bindParam:MaxDataGuess = 0.
      this-object:bindParam:NoLOBs = false.
      this-object:bindParam:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar1 = new "Progress.Data.TableDesc[]"(0).
      tableDesc1:ChildTables = arrayvar1.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar2[1] = new Progress.Data.ColumnPropDesc("version_id", "Номер", Progress.Data.DataType:INTEGER).
      arrayvar2[2] = new Progress.Data.ColumnPropDesc("Value_Old", "Заменить с", Progress.Data.DataType:CHARACTER).
      arrayvar2[3] = new Progress.Data.ColumnPropDesc("Value_new", "Заменить на", Progress.Data.DataType:CHARACTER).
      tableDesc1:Columns = arrayvar2.
      this-object:bindParam:TableSchema = tableDesc1.
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
      /* ChoiceParam */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(523, 316).
      this-object:Controls:Add(this-object:dataGridView1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "ChoiceParam".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "Выбор параметра".
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:bindParam, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:ResumeLayout(false).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 
   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.


 
end class.
