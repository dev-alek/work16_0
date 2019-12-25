 /*------------------------------------------------------------------------
    File        : cashbook
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Thu Dec 06 09:59:03 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class ibs.th.ref.cashbookfrm inherits Form : 

   define private variable checkBox2 as System.Windows.Forms.CheckBox no-undo.
   define private variable checkBox1 as System.Windows.Forms.CheckBox no-undo.
   define private variable bindingSource1 as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   define private variable label6 as System.Windows.Forms.Label no-undo.
   define private variable textBox5 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox2 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox1 as System.Windows.Forms.TextBox no-undo.
   define private variable label5 as System.Windows.Forms.Label no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define private variable textBox6 as System.Windows.Forms.TextBox no-undo.
    
   constructor public cashbookfrm( ):
   
      super().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   destructor public cashbookfrm( ):

      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void label1_Click( input sender as System.Object, input e as System.EventArgs ):
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void label2_Click( input sender as System.Object, input e as System.EventArgs ):
		
		return.

	end method.

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
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:textBox1 = new System.Windows.Forms.TextBox().
      this-object:textBox2 = new System.Windows.Forms.TextBox().
      this-object:label2 = new System.Windows.Forms.Label().
      this-object:textBox5 = new System.Windows.Forms.TextBox().
      this-object:label5 = new System.Windows.Forms.Label().
      this-object:textBox6 = new System.Windows.Forms.TextBox().
      this-object:label6 = new System.Windows.Forms.Label().
      this-object:bindingSource1 = new Progress.Data.BindingSource(this-object:components).
      this-object:checkBox1 = new System.Windows.Forms.CheckBox().
      this-object:checkBox2 = new System.Windows.Forms.CheckBox().
      cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(293, 280).
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
      this-object:buttonCancel:Location = new System.Drawing.Point(377, 280).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* label1 */
      /*  */
      this-object:label1:Location = new System.Drawing.Point(53, 24).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(141, 23).
      this-object:label1:TabIndex = 2.
      this-object:label1:Text = "Наименование типа кассовой книги".
      this-object:label1:UseCompatibleTextRendering = true.
      this-object:label1:Click:Subscribe(this-object:label1_Click).
      /*  */
      /* textBox1 */
      /*  */
      this-object:textBox1:Location = new System.Drawing.Point(228, 27).
      this-object:textBox1:Name = "textBox1".
      this-object:textBox1:Size = new System.Drawing.Size(100, 20).
      this-object:textBox1:TabIndex = 3.
      /*  */
      /* textBox2 */
      /*  */
      this-object:textBox2:Location = new System.Drawing.Point(228, 64).
      this-object:textBox2:Name = "textBox2".
      this-object:textBox2:Size = new System.Drawing.Size(100, 20).
      this-object:textBox2:TabIndex = 5.
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Location = new System.Drawing.Point(53, 61).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(141, 23).
      this-object:label2:TabIndex = 4.
      this-object:label2:Text = "фирма, которой принадлежит тип кассовой книги".
      this-object:label2:UseCompatibleTextRendering = true.
      this-object:label2:Click:Subscribe(this-object:label2_Click).
      /*  */
      /* textBox5 */
      /*  */
      this-object:textBox5:Location = new System.Drawing.Point(228, 109).
      this-object:textBox5:Name = "textBox5".
      this-object:textBox5:Size = new System.Drawing.Size(100, 20).
      this-object:textBox5:TabIndex = 11.
      /*  */
      /* label5 */
      /*  */
      this-object:label5:Location = new System.Drawing.Point(53, 106).
      this-object:label5:Name = "label5".
      this-object:label5:Size = new System.Drawing.Size(141, 23).
      this-object:label5:TabIndex = 10.
      this-object:label5:Text = "Правило заполнения графы ~"Основание~"".
      this-object:label5:UseCompatibleTextRendering = true.
      /*  */
      /* textBox6 */
      /*  */
      this-object:textBox6:Location = new System.Drawing.Point(228, 157).
      this-object:textBox6:Name = "textBox6".
      this-object:textBox6:Size = new System.Drawing.Size(100, 20).
      this-object:textBox6:TabIndex = 13.
      /*  */
      /* label6 */
      /*  */
      this-object:label6:Location = new System.Drawing.Point(53, 154).
      this-object:label6:Name = "label6".
      this-object:label6:Size = new System.Drawing.Size(141, 23).
      this-object:label6:TabIndex = 12.
      this-object:label6:Text = "Правило заполнения графы ~"Приложение~"".
      this-object:label6:UseCompatibleTextRendering = true.
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
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 3 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("code", "Код", Progress.Data.DataType:CHARACTER).
      arrayvar1[2] = new Progress.Data.ColumnPropDesc("Name", "Наименование", Progress.Data.DataType:CHARACTER).
      arrayvar1[3] = new Progress.Data.ColumnPropDesc("codevalue", "Значение", Progress.Data.DataType:CHARACTER).
      tableDesc1:Columns = arrayvar1.
      this-object:bindingSource1:TableSchema = tableDesc1.
      /*  */
      /* checkBox1 */
      /*  */
      this-object:checkBox1:Location = new System.Drawing.Point(224, 229).
      this-object:checkBox1:Name = "checkBox1".
      this-object:checkBox1:Size = new System.Drawing.Size(147, 24).
      this-object:checkBox1:TabIndex = 17.
      this-object:checkBox1:Text = "Раздельно НП и ТНП".
      this-object:checkBox1:UseCompatibleTextRendering = true.
      this-object:checkBox1:UseVisualStyleBackColor = true.
      /*  */
      /* checkBox2 */
      /*  */
      this-object:checkBox2:Location = new System.Drawing.Point(224, 199).
      this-object:checkBox2:Name = "checkBox2".
      this-object:checkBox2:Size = new System.Drawing.Size(226, 24).
      this-object:checkBox2:TabIndex = 18.
      this-object:checkBox2:Text = "Отдельный ПКО для каждой кассы".
      this-object:checkBox2:UseCompatibleTextRendering = true.
      this-object:checkBox2:UseVisualStyleBackColor = true.
      /*  */
      /* cashbook */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(466, 317).
      this-object:Controls:Add(this-object:checkBox2).
      this-object:Controls:Add(this-object:checkBox1).
      this-object:Controls:Add(this-object:textBox6).
      this-object:Controls:Add(this-object:label6).
      this-object:Controls:Add(this-object:textBox5).
      this-object:Controls:Add(this-object:label5).
      this-object:Controls:Add(this-object:textBox2).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:textBox1).
      this-object:Controls:Add(this-object:label1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "cashbook".
      this-object:ShowInTaskbar = false.
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "Кассовая книга".
      cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):EndInit().
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
