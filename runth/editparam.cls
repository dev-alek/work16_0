 /*------------------------------------------------------------------------
    File        : editparam
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sat Oct 10 13:16:36 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class runth.editparam inherits Form : 

   define private variable bindParam as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable textBox3 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox2 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox1 as System.Windows.Forms.TextBox no-undo.
   define private variable nom as System.Windows.Forms.Label no-undo.
   define private variable label3 as System.Windows.Forms.Label no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define variable mtrg as runth.runth_trg no-undo.
   
   constructor public editparam( ):
   
      super().
      mtrg = new runth.runth_trg().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   constructor public editparam( itrg as runth.runth_trg):
   
      super().
      mtrg = itrg.
      InitializeComponent ( ).
      bindParam:handle = mtrg:getQuery("ParamsOne").
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.
   destructor public editparam( ):
      if valid-object(bindParam) then bindParam:Dispose().
      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   


    method private void okButton_Click (sender as System.Object, e as System.EventArgs):
      bindParam:Assign().
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
      tableDesc2 = new Progress.Data.TableDesc("tt-Params").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:textBox1 = new System.Windows.Forms.TextBox().
      this-object:textBox2 = new System.Windows.Forms.TextBox().
      this-object:textBox3 = new System.Windows.Forms.TextBox().
      this-object:nom = new System.Windows.Forms.Label().
      this-object:label2 = new System.Windows.Forms.Label().
      this-object:label3 = new System.Windows.Forms.Label().
      this-object:bindParam = new Progress.Data.BindingSource(this-object:components).
      cast(this-object:bindParam, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(447, 110).
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
      this-object:buttonCancel:Location = new System.Drawing.Point(531, 110).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* textBox1 */
      /*  */
      this-object:textBox1:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindParam, "version_id", true)).
      this-object:textBox1:Location = new System.Drawing.Point(90, 9).
      this-object:textBox1:Name = "textBox1".
      this-object:textBox1:ReadOnly = true.
      this-object:textBox1:Size = new System.Drawing.Size(182, 20).
      this-object:textBox1:TabIndex = 2.
      /*  */
      /* textBox2 */
      /*  */
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox2:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindParam, "Value_Old", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:textBox2:Location = new System.Drawing.Point(90, 41).
      this-object:textBox2:Name = "textBox2".
      this-object:textBox2:Size = new System.Drawing.Size(516, 20).
      this-object:textBox2:TabIndex = 3.
      /*  */
      /* textBox3 */
      /*  */
      define variable nestedvar3 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar3 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox3:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox3:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindParam, "Value_new", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:textBox3:Location = new System.Drawing.Point(90, 73).
      this-object:textBox3:Name = "textBox3".
      this-object:textBox3:Size = new System.Drawing.Size(516, 20).
      this-object:textBox3:TabIndex = 4.
      /*  */
      /* nom */
      /*  */
      this-object:nom:Location = new System.Drawing.Point(12, 9).
      this-object:nom:Name = "nom".
      this-object:nom:Size = new System.Drawing.Size(72, 23).
      this-object:nom:TabIndex = 5.
      this-object:nom:Text = "№".
      this-object:nom:UseCompatibleTextRendering = true.
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Location = new System.Drawing.Point(12, 44).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(72, 23).
      this-object:label2:TabIndex = 6.
      this-object:label2:Text = "Заменить с".
      this-object:label2:UseCompatibleTextRendering = true.
      /*  */
      /* label3 */
      /*  */
      this-object:label3:Location = new System.Drawing.Point(12, 76).
      this-object:label3:Name = "label3".
      this-object:label3:Size = new System.Drawing.Size(72, 25).
      this-object:label3:TabIndex = 7.
      this-object:label3:Text = "Заменить на".
      this-object:label3:UseCompatibleTextRendering = true.
      /*  */
      /* bindParam */
      /*  */
      this-object:bindParam:MaxDataGuess = 0.
      this-object:bindParam:NoLOBs = false.
      this-object:bindParam:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar0 = new "Progress.Data.TableDesc[]"(0).
      tableDesc2:ChildTables = arrayvar0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("version_id", "", Progress.Data.DataType:INTEGER).
      arrayvar1[2] = new Progress.Data.ColumnPropDesc("Value_Old", "", Progress.Data.DataType:CHARACTER).
      arrayvar1[3] = new Progress.Data.ColumnPropDesc("Value_new", "", Progress.Data.DataType:CHARACTER).
      tableDesc2:Columns = arrayvar1.
      this-object:bindParam:TableSchema = tableDesc2.
      /*  */
      /* editparam */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(620, 147).
      this-object:Controls:Add(this-object:label3).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:nom).
      this-object:Controls:Add(this-object:textBox3).
      this-object:Controls:Add(this-object:textBox2).
      this-object:Controls:Add(this-object:textBox1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "editparam".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "editparam".
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
