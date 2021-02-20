 /*------------------------------------------------------------------------
    File        : editfilerep
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sat Oct 10 18:37:06 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class runth.editfilerep inherits Form : 

   define private variable checkBox1 as System.Windows.Forms.CheckBox no-undo.
   define private variable bindfilerep as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable textBox3 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox2 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox1 as System.Windows.Forms.TextBox no-undo.
   define private variable nom as System.Windows.Forms.Label no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   define variable mtrg as class runth.runth_trg no-undo.
   
   constructor public editfilerep( ):
   
      super().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   constructor public editfilerep(itrg as class runth.runth_trg ):
   
      super().
      InitializeComponent ( ).
      mtrg = itrg.
      bindfilerep:handle = mtrg:getQuery("fileReplaseone").
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.


   destructor public editfilerep( ):
      if valid-object(bindfilerep) then bindfilerep:Dispose().
      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   

   method private void okButton_Click (sender as System.Object, e as System.EventArgs):
      bindfilerep:Assign().
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
      tableDesc1 = new Progress.Data.TableDesc("tt-fileReplase").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:textBox1 = new System.Windows.Forms.TextBox().
      this-object:bindfilerep = new Progress.Data.BindingSource(this-object:components).
      this-object:nom = new System.Windows.Forms.Label().
      this-object:textBox2 = new System.Windows.Forms.TextBox().
      this-object:textBox3 = new System.Windows.Forms.TextBox().
      this-object:checkBox1 = new System.Windows.Forms.CheckBox().
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:label2 = new System.Windows.Forms.Label().
      cast(this-object:bindfilerep, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(539, 125).
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
      this-object:buttonCancel:Location = new System.Drawing.Point(623, 125).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* textBox1 */
      /*  */
      this-object:textBox1:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindfilerep, "FileId", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:textBox1:Location = new System.Drawing.Point(162, 13).
      this-object:textBox1:Name = "textBox1".
      this-object:textBox1:ReadOnly = true.
      this-object:textBox1:Size = new System.Drawing.Size(535, 20).
      this-object:textBox1:TabIndex = 2.
      /*  */
      /* bindfilerep */
      /*  */
      this-object:bindfilerep:MaxDataGuess = 0.
      this-object:bindfilerep:NoLOBs = false.
      this-object:bindfilerep:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar0 = new "Progress.Data.TableDesc[]"(0).
      tableDesc1:ChildTables = arrayvar0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 4 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("FileName_Old", "", Progress.Data.DataType:CHARACTER).
      arrayvar1[2] = new Progress.Data.ColumnPropDesc("FileName_New", "", Progress.Data.DataType:CHARACTER).
      arrayvar1[3] = new Progress.Data.ColumnPropDesc("FileId", "", Progress.Data.DataType:INTEGER).
      arrayvar1[4] = new Progress.Data.ColumnPropDesc("FileCycle", "", Progress.Data.DataType:LOGICAL).
      tableDesc1:Columns = arrayvar1.
      this-object:bindfilerep:TableSchema = tableDesc1.
      /*  */
      /* nom */
      /*  */
      this-object:nom:Location = new System.Drawing.Point(13, 13).
      this-object:nom:Name = "nom".
      this-object:nom:Size = new System.Drawing.Size(100, 23).
      this-object:nom:TabIndex = 3.
      this-object:nom:Text = "Номер".
      this-object:nom:UseCompatibleTextRendering = true.
      /*  */
      /* textBox2 */
      /*  */
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox2:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindfilerep, "FileName_Old", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:textBox2:Location = new System.Drawing.Point(162, 40).
      this-object:textBox2:Name = "textBox2".
      this-object:textBox2:Size = new System.Drawing.Size(536, 20).
      this-object:textBox2:TabIndex = 4.
      /*  */
      /* textBox3 */
      /*  */
      define variable nestedvar3 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar3 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox3:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox3:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindfilerep, "FileName_New", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:textBox3:Location = new System.Drawing.Point(162, 67).
      this-object:textBox3:Name = "textBox3".
      this-object:textBox3:Size = new System.Drawing.Size(536, 20).
      this-object:textBox3:TabIndex = 5.
      /*  */
      /* checkBox1 */
      /*  */
      define variable nestedvar4 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar4 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:checkBox1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar4, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:checkBox1:DataBindings:Add(new System.Windows.Forms.Binding("CheckState", this-object:bindfilerep, "FileCycle", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:checkBox1:Location = new System.Drawing.Point(162, 93).
      this-object:checkBox1:Name = "checkBox1".
      this-object:checkBox1:Size = new System.Drawing.Size(326, 24).
      this-object:checkBox1:TabIndex = 6.
      this-object:checkBox1:Text = "Подставлять значения из дополнительного списка".
      this-object:checkBox1:UseCompatibleTextRendering = true.
      this-object:checkBox1:UseVisualStyleBackColor = true.
      /*  */
      /* label1 */
      /*  */
      this-object:label1:Location = new System.Drawing.Point(13, 40).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(143, 23).
      this-object:label1:TabIndex = 7.
      this-object:label1:Text = "Файл для замены текста".
      this-object:label1:UseCompatibleTextRendering = true.
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Location = new System.Drawing.Point(13, 67).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(100, 23).
      this-object:label2:TabIndex = 8.
      this-object:label2:Text = "Новый файл".
      this-object:label2:UseCompatibleTextRendering = true.
      /*  */
      /* editfilerep */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(712, 162).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:label1).
      this-object:Controls:Add(this-object:checkBox1).
      this-object:Controls:Add(this-object:textBox3).
      this-object:Controls:Add(this-object:textBox2).
      this-object:Controls:Add(this-object:nom).
      this-object:Controls:Add(this-object:textBox1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "editfilerep".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "Файлы для замены".
      cast(this-object:bindfilerep, System.ComponentModel.ISupportInitialize):EndInit().
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
