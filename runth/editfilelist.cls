 /*------------------------------------------------------------------------
    File        : editfilelist
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sat Oct 10 18:36:34 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class runth.editfilelist inherits Form : 

   define private variable checkBox1 as System.Windows.Forms.CheckBox no-undo.
   define private variable bindfilelist as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable Filename as System.Windows.Forms.TextBox no-undo.
   define private variable FileId as System.Windows.Forms.TextBox no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   define variable mtrg as class runth.runth_trg no-undo.
    
   constructor public editfilelist( ):
   
      super().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   constructor public editfilelist(itrg as runth.runth_trg ):
   
      super().
      InitializeComponent ( ).
      mtrg = itrg.
      bindfilelist:Handle = mtrg:getQuery("fileListOne").
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.
   
   destructor public editfilelist( ):
      if valid-object(bindfilelist) then bindfilelist:Dispose().
      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   

   method private void okButton_Click (sender as System.Object, e as System.EventArgs):
      if mtrg:CheckFileList(FileId:Text)
      then do:
         bindfilelist:Assign().
         this-object:DialogResult = System.Windows.Forms.DialogResult:Ok.
         this-object:Close ( ).
      end.
      else
         message "Уже есть запись с индификатором " FileId:Text
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
      tableDesc1 = new Progress.Data.TableDesc("tt-fileList").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:FileId = new System.Windows.Forms.TextBox().
      this-object:bindfilelist = new Progress.Data.BindingSource(this-object:components).
      this-object:Filename = new System.Windows.Forms.TextBox().
      this-object:checkBox1 = new System.Windows.Forms.CheckBox().
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:label2 = new System.Windows.Forms.Label().
      cast(this-object:bindfilelist, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(563, 80).
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
      this-object:buttonCancel:Location = new System.Drawing.Point(647, 80).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* FileId */
      /*  */
      this-object:FileId:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindfilelist, "FileId", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:FileId:Location = new System.Drawing.Point(126, 12).
      this-object:FileId:Name = "FileId".
      this-object:FileId:Size = new System.Drawing.Size(595, 20).
      this-object:FileId:TabIndex = 2.
      /*  */
      /* bindfilelist */
      /*  */
      this-object:bindfilelist:MaxDataGuess = 0.
      this-object:bindfilelist:NoLOBs = false.
      this-object:bindfilelist:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar0 = new "Progress.Data.TableDesc[]"(0).
      tableDesc1:ChildTables = arrayvar0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("FileName", "", Progress.Data.DataType:CHARACTER).
      arrayvar1[2] = new Progress.Data.ColumnPropDesc("FileId", "", Progress.Data.DataType:CHARACTER).
      arrayvar1[3] = new Progress.Data.ColumnPropDesc("RunFile", "", Progress.Data.DataType:LOGICAL).
      tableDesc1:Columns = arrayvar1.
      this-object:bindfilelist:TableSchema = tableDesc1.
      /*  */
      /* Filename */
      /*  */
      this-object:Filename:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindfilelist, "FileName", true)).
      this-object:Filename:Location = new System.Drawing.Point(126, 39).
      this-object:Filename:Name = "Filename".
      this-object:Filename:Size = new System.Drawing.Size(595, 20).
      this-object:Filename:TabIndex = 3.
      /*  */
      /* checkBox1 */
      /*  */
      this-object:checkBox1:DataBindings:Add(new System.Windows.Forms.Binding("CheckState", this-object:bindfilelist, "RunFile", true, System.Windows.Forms.DataSourceUpdateMode:OnPropertyChanged)).
      this-object:checkBox1:Location = new System.Drawing.Point(126, 66).
      this-object:checkBox1:Name = "checkBox1".
      this-object:checkBox1:Size = new System.Drawing.Size(249, 24).
      this-object:checkBox1:TabIndex = 4.
      this-object:checkBox1:Text = "Выполнить после обработки".
      this-object:checkBox1:UseCompatibleTextRendering = true.
      this-object:checkBox1:UseVisualStyleBackColor = true.
      /*  */
      /* label1 */
      /*  */
      this-object:label1:Location = new System.Drawing.Point(12, 12).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(100, 23).
      this-object:label1:TabIndex = 5.
      this-object:label1:Text = "Индификатор".
      this-object:label1:UseCompatibleTextRendering = true.
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Location = new System.Drawing.Point(12, 35).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(100, 23).
      this-object:label2:TabIndex = 6.
      this-object:label2:Text = "Файл запуск".
      this-object:label2:UseCompatibleTextRendering = true.
      /*  */
      /* editfilelist */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(736, 117).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:label1).
      this-object:Controls:Add(this-object:checkBox1).
      this-object:Controls:Add(this-object:Filename).
      this-object:Controls:Add(this-object:FileId).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "editfilelist".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "Файл запуска".
      cast(this-object:bindfilelist, System.ComponentModel.ISupportInitialize):EndInit().
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
