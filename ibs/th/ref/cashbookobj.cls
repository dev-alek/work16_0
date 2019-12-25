 /*------------------------------------------------------------------------
    File        : cashbookobj
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Thu Dec 06 11:27:09 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class ibs.th.ref.cashbookobj inherits Form : 

   define private variable codevalueDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable codeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable bindingSource1 as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable objcodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable nameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable groupBox1 as System.Windows.Forms.GroupBox no-undo.
   define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
    
   constructor public cashbookobj( ):
   
      super().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   destructor public cashbookobj( ):

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
      tableDesc1 = new Progress.Data.TableDesc("Table").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:groupBox1 = new System.Windows.Forms.GroupBox().
      this-object:bindingSource1 = new Progress.Data.BindingSource(this-object:components).
      this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
      this-object:objcodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:codeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:nameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:codevalueDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(550, 502).
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
      this-object:buttonCancel:Location = new System.Drawing.Point(634, 502).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* groupBox1 */
      /*  */
      this-object:groupBox1:Location = new System.Drawing.Point(72, 28).
      this-object:groupBox1:Name = "groupBox1".
      this-object:groupBox1:Size = new System.Drawing.Size(522, 70).
      this-object:groupBox1:TabIndex = 2.
      this-object:groupBox1:TabStop = false.
      this-object:groupBox1:Text = "фильтр".
      this-object:groupBox1:UseCompatibleTextRendering = true.
      /*  */
      /* bindingSource1 */
      /*  */
      this-object:bindingSource1:MaxDataGuess = 0.
      this-object:bindingSource1:NoLOBs = false.
      this-object:bindingSource1:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar0 = new "Progress.Data.TableDesc[]"(0).
      tableDesc1:ChildTables = arrayvar0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 4 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("code", "Код", Progress.Data.DataType:CHARACTER).
      arrayvar1[2] = new Progress.Data.ColumnPropDesc("Name", "Наименование", Progress.Data.DataType:CHARACTER).
      arrayvar1[3] = new Progress.Data.ColumnPropDesc("codevalue", "Значение", Progress.Data.DataType:CHARACTER).
      arrayvar1[4] = new Progress.Data.ColumnPropDesc("obj-code", "Объект", Progress.Data.DataType:CHARACTER).
      tableDesc1:Columns = arrayvar1.
      this-object:bindingSource1:TableSchema = tableDesc1.
      /*  */
      /* dataGridView1 */
      /*  */
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:AutoGenerateColumns = false.
      this-object:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
      this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar2 as System.Windows.Forms.DataGridViewColumn extent 4 no-undo.
      arrayvar2[1] = this-object:objcodeDataGridViewTextBoxColumn.
      arrayvar2[2] = this-object:codeDataGridViewTextBoxColumn.
      arrayvar2[3] = this-object:nameDataGridViewTextBoxColumn.
      arrayvar2[4] = this-object:codevalueDataGridViewTextBoxColumn.
      this-object:dataGridView1:Columns:AddRange(arrayvar2).
      this-object:dataGridView1:DataSource = this-object:bindingSource1.
      this-object:dataGridView1:Location = new System.Drawing.Point(12, 116).
      this-object:dataGridView1:Name = "dataGridView1".
      this-object:dataGridView1:Size = new System.Drawing.Size(697, 380).
      this-object:dataGridView1:TabIndex = 3.
      /*  */
      /* objcodeDataGridViewTextBoxColumn */
      /*  */
      this-object:objcodeDataGridViewTextBoxColumn:DataPropertyName = "obj-code".
      this-object:objcodeDataGridViewTextBoxColumn:HeaderText = "Объект".
      this-object:objcodeDataGridViewTextBoxColumn:Name = "objcodeDataGridViewTextBoxColumn".
      /*  */
      /* codeDataGridViewTextBoxColumn */
      /*  */
      this-object:codeDataGridViewTextBoxColumn:DataPropertyName = "code".
      this-object:codeDataGridViewTextBoxColumn:HeaderText = "Код".
      this-object:codeDataGridViewTextBoxColumn:Name = "codeDataGridViewTextBoxColumn".
      /*  */
      /* nameDataGridViewTextBoxColumn */
      /*  */
      this-object:nameDataGridViewTextBoxColumn:DataPropertyName = "Name".
      this-object:nameDataGridViewTextBoxColumn:HeaderText = "Наименование".
      this-object:nameDataGridViewTextBoxColumn:Name = "nameDataGridViewTextBoxColumn".
      /*  */
      /* codevalueDataGridViewTextBoxColumn */
      /*  */
      this-object:codevalueDataGridViewTextBoxColumn:DataPropertyName = "codevalue".
      this-object:codevalueDataGridViewTextBoxColumn:HeaderText = "Значение".
      this-object:codevalueDataGridViewTextBoxColumn:Name = "codevalueDataGridViewTextBoxColumn".
      /*  */
      /* cashbookobj */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(723, 539).
      this-object:Controls:Add(this-object:dataGridView1).
      this-object:Controls:Add(this-object:groupBox1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "cashbookobj".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "cashbookobj".
      cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:ResumeLayout(false).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 
   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.


 
end class.
