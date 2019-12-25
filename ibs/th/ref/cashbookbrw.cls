 /*------------------------------------------------------------------------
    File        : cashbookbrw
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Thu Dec 06 11:17:18 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class ibs.th.ref.cashbookbrw inherits Form : 

   define private variable bindingSource1 as Progress.Data.BindingSource no-undo.
   define private variable button2 as System.Windows.Forms.Button no-undo.
   define private variable button1 as System.Windows.Forms.Button no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
   define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
   define private variable nameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable idDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable firmDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
   define private variable extcodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    
   constructor public cashbookbrw( ):
   
      super().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   destructor public cashbookbrw( ):

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
      define variable tableDesc2 as Progress.Data.TableDesc no-undo.
      tableDesc2 = new Progress.Data.TableDesc("Table").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
      this-object:bindingSource1 = new Progress.Data.BindingSource(this-object:components).
      this-object:nameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:firmDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:idDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:extcodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
      this-object:button1 = new System.Windows.Forms.Button().
      this-object:button2 = new System.Windows.Forms.Button().
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
      cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      this-object:buttonOk:Location = new System.Drawing.Point(12, 12).
      this-object:buttonOk:Name = "buttonOk".
      this-object:buttonOk:Size = new System.Drawing.Size(75, 40).
      this-object:buttonOk:TabIndex = 0.
      this-object:buttonOk:Text = "Выход".
      this-object:buttonOk:UseCompatibleTextRendering = true.
      this-object:buttonOk:Click:Subscribe(this-object:okButton_Click).
      /*  */
      /* dataGridView1 */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:dataGridView1:AutoGenerateColumns = false.
      this-object:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
      this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 4 no-undo.
      arrayvar0[1] = this-object:nameDataGridViewTextBoxColumn.
      arrayvar0[2] = this-object:firmDataGridViewTextBoxColumn.
      arrayvar0[3] = this-object:idDataGridViewTextBoxColumn.
      arrayvar0[4] = this-object:extcodeDataGridViewTextBoxColumn.
      this-object:dataGridView1:Columns:AddRange(arrayvar0).
      this-object:dataGridView1:DataSource = this-object:bindingSource1.
      this-object:dataGridView1:Location = new System.Drawing.Point(12, 81).
      this-object:dataGridView1:Name = "dataGridView1".
      this-object:dataGridView1:Size = new System.Drawing.Size(445, 276).
      this-object:dataGridView1:TabIndex = 2.
      /*  */
      /* bindingSource1 */
      /*  */
      this-object:bindingSource1:MaxDataGuess = 0.
      this-object:bindingSource1:NoLOBs = false.
      this-object:bindingSource1:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar1 = new "Progress.Data.TableDesc[]"(0).
      tableDesc2:ChildTables = arrayvar1.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 4 no-undo.
      arrayvar2[1] = new Progress.Data.ColumnPropDesc("Name", "Наименование", Progress.Data.DataType:CHARACTER).
      arrayvar2[2] = new Progress.Data.ColumnPropDesc("firm", "Фирма", Progress.Data.DataType:CHARACTER).
      arrayvar2[3] = new Progress.Data.ColumnPropDesc("id", "id", Progress.Data.DataType:INT64).
      arrayvar2[4] = new Progress.Data.ColumnPropDesc("ext-code", "ext-code", Progress.Data.DataType:CHARACTER).
      tableDesc2:Columns = arrayvar2.
      this-object:bindingSource1:TableSchema = tableDesc2.
      /*  */
      /* nameDataGridViewTextBoxColumn */
      /*  */
      this-object:nameDataGridViewTextBoxColumn:DataPropertyName = "Name".
      this-object:nameDataGridViewTextBoxColumn:HeaderText = "Наименование".
      this-object:nameDataGridViewTextBoxColumn:Name = "nameDataGridViewTextBoxColumn".
      /*  */
      /* firmDataGridViewTextBoxColumn */
      /*  */
      this-object:firmDataGridViewTextBoxColumn:DataPropertyName = "firm".
      this-object:firmDataGridViewTextBoxColumn:HeaderText = "Фирма".
      this-object:firmDataGridViewTextBoxColumn:Name = "firmDataGridViewTextBoxColumn".
      /*  */
      /* idDataGridViewTextBoxColumn */
      /*  */
      this-object:idDataGridViewTextBoxColumn:DataPropertyName = "id".
      this-object:idDataGridViewTextBoxColumn:HeaderText = "id".
      this-object:idDataGridViewTextBoxColumn:Name = "idDataGridViewTextBoxColumn".
      /*  */
      /* extcodeDataGridViewTextBoxColumn */
      /*  */
      this-object:extcodeDataGridViewTextBoxColumn:DataPropertyName = "ext-code".
      this-object:extcodeDataGridViewTextBoxColumn:HeaderText = "ext-code".
      this-object:extcodeDataGridViewTextBoxColumn:Name = "extcodeDataGridViewTextBoxColumn".
      /*  */
      /* button1 */
      /*  */
      this-object:button1:Location = new System.Drawing.Point(93, 12).
      this-object:button1:Name = "button1".
      this-object:button1:Size = new System.Drawing.Size(75, 40).
      this-object:button1:TabIndex = 3.
      this-object:button1:Text = "Товары".
      this-object:button1:UseCompatibleTextRendering = true.
      this-object:button1:UseVisualStyleBackColor = true.
      /*  */
      /* button2 */
      /*  */
      this-object:button2:Location = new System.Drawing.Point(174, 12).
      this-object:button2:Name = "button2".
      this-object:button2:Size = new System.Drawing.Size(133, 40).
      this-object:button2:TabIndex = 4.
      this-object:button2:Text = "Настройки для объектов".
      this-object:button2:UseCompatibleTextRendering = true.
      this-object:button2:UseVisualStyleBackColor = true.
      /*  */
      /* cashbookbrw */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:ClientSize = new System.Drawing.Size(469, 369).
      this-object:Controls:Add(this-object:button2).
      this-object:Controls:Add(this-object:button1).
      this-object:Controls:Add(this-object:dataGridView1).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "cashbookbrw".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "cashbookbrw".
      cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
      cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:ResumeLayout(false).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 
   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.


 
end class.
