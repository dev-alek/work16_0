 /*------------------------------------------------------------------------
    File        : frmcode
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Wed Jul 31 02:15:08 MSK 2019
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class ibs.th.ref.code.frmcode inherits Form  final: 

   define private variable bindcode as Progress.Data.BindingSource no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable textBox7 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox6 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox5 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox4 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox3 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox2 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox1 as System.Windows.Forms.TextBox no-undo.
   define private variable label7 as System.Windows.Forms.Label no-undo.
   define private variable label6 as System.Windows.Forms.Label no-undo.
   define private variable label5 as System.Windows.Forms.Label no-undo.
   define private variable label4 as System.Windows.Forms.Label no-undo.
   define private variable label3 as System.Windows.Forms.Label no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   
   define variable McodeTrg as class ibs.th.ref.code.code_trg NO-UNDO.
   
   constructor public frmcode( ):
   
      super().
      InitializeComponent ( ).
      
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.
   
   constructor public frmcode(iQuery as handle,itrg as class ibs.th.ref.code.code_trg ):
   
      super().
      InitializeComponent ( ).
      bindcode:handle = iQuery.
      McodeTrg = itrg.
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   destructor public frmcode( ):

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
		label4:visible   = not label4:visible.
      label5:visible   = label4:visible.
      label6:visible   = label4:visible.
      label7:visible   = label4:visible.
      textBox4:visible = label4:visible.
      textBox5:visible = label4:visible.
      textBox6:visible = label4:visible.
      textBox7:visible = label4:visible.
		return.

	end method.

    method private void okButton_Click (sender as System.Object, e as System.EventArgs):
      
      
      bindcode:Assign().
      if valid-object(McodeTrg)
      then
         McodeTrg:checkcode().
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
      tableDesc1 = new Progress.Data.TableDesc("Code").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:textBox1 = new System.Windows.Forms.TextBox().
      this-object:bindcode = new Progress.Data.BindingSource(this-object:components).
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:label2 = new System.Windows.Forms.Label().
      this-object:textBox2 = new System.Windows.Forms.TextBox().
      this-object:label3 = new System.Windows.Forms.Label().
      this-object:textBox3 = new System.Windows.Forms.TextBox().
      this-object:label4 = new System.Windows.Forms.Label().
      this-object:textBox4 = new System.Windows.Forms.TextBox().
      this-object:label5 = new System.Windows.Forms.Label().
      this-object:textBox5 = new System.Windows.Forms.TextBox().
      this-object:label6 = new System.Windows.Forms.Label().
      this-object:textBox6 = new System.Windows.Forms.TextBox().
      this-object:label7 = new System.Windows.Forms.Label().
      this-object:textBox7 = new System.Windows.Forms.TextBox().
      cast(this-object:bindcode, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Top.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(348, 95).
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
      nestedvar1 = System.Windows.Forms.AnchorStyles:Top.
      this-object:buttonCancel:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
      this-object:buttonCancel:Location = new System.Drawing.Point(434, 95).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Cancel".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* textBox1 */
      /*  */
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox1:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindcode, "code", true)).
      this-object:textBox1:Location = new System.Drawing.Point(134, 9).
      this-object:textBox1:Name = "textBox1".
      this-object:textBox1:Size = new System.Drawing.Size(375, 20).
      this-object:textBox1:TabIndex = 2.
      /*  */
      /* bindcode */
      /*  */
      this-object:bindcode:MaxDataGuess = 0.
      this-object:bindcode:NoLOBs = false.
      this-object:bindcode:Position = 0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
      arrayvar0 = new "Progress.Data.TableDesc[]"(0).
      tableDesc1:ChildTables = arrayvar0.
      @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
      define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 7 no-undo.
      arrayvar1[1] = new Progress.Data.ColumnPropDesc("code", "Код", Progress.Data.DataType:CHARACTER).
      arrayvar1[2] = new Progress.Data.ColumnPropDesc("CodeName", "Наименование", Progress.Data.DataType:CHARACTER).
      arrayvar1[3] = new Progress.Data.ColumnPropDesc("CodeValue", "Значение", Progress.Data.DataType:CHARACTER).
      arrayvar1[4] = new Progress.Data.ColumnPropDesc("parent", "?", Progress.Data.DataType:CHARACTER).
      arrayvar1[5] = new Progress.Data.ColumnPropDesc("procdel", "Процедура удаления", Progress.Data.DataType:CHARACTER).
      arrayvar1[6] = new Progress.Data.ColumnPropDesc("procedit", "процедура редактирования", Progress.Data.DataType:CHARACTER).
      arrayvar1[7] = new Progress.Data.ColumnPropDesc("procview", "Процедура просмотра", Progress.Data.DataType:CHARACTER).
      tableDesc1:Columns = arrayvar1.
      this-object:bindcode:TableSchema = tableDesc1.
      /*  */
      /* label1 */
      /*  */
      this-object:label1:Location = new System.Drawing.Point(24, 9).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(100, 23).
      this-object:label1:TabIndex = 3.
      this-object:label1:Text = "Код".
      this-object:label1:UseCompatibleTextRendering = true.
      this-object:label1:Click:Subscribe(this-object:label1_Click).
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Location = new System.Drawing.Point(24, 35).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(100, 23).
      this-object:label2:TabIndex = 5.
      this-object:label2:Text = "Наименование".
      this-object:label2:UseCompatibleTextRendering = true.
      /*  */
      /* textBox2 */
      /*  */
      define variable nestedvar3 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar3 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox2:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindcode, "CodeName", true)).
      this-object:textBox2:Location = new System.Drawing.Point(134, 35).
      this-object:textBox2:Name = "textBox2".
      this-object:textBox2:Size = new System.Drawing.Size(375, 20).
      this-object:textBox2:TabIndex = 4.
      /*  */
      /* label3 */
      /*  */
      this-object:label3:Location = new System.Drawing.Point(24, 61).
      this-object:label3:Name = "label3".
      this-object:label3:Size = new System.Drawing.Size(100, 23).
      this-object:label3:TabIndex = 7.
      this-object:label3:Text = "Значение".
      this-object:label3:UseCompatibleTextRendering = true.
      /*  */
      /* textBox3 */
      /*  */
      define variable nestedvar4 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar4 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox3:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar4, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox3:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindcode, "CodeValue", true)).
      this-object:textBox3:Location = new System.Drawing.Point(134, 61).
      this-object:textBox3:Name = "textBox3".
      this-object:textBox3:Size = new System.Drawing.Size(375, 20).
      this-object:textBox3:TabIndex = 6.
      /*  */
      /* label4 */
      /*  */
      this-object:label4:Location = new System.Drawing.Point(24, 182).
      this-object:label4:Name = "label4".
      this-object:label4:Size = new System.Drawing.Size(100, 23).
      this-object:label4:TabIndex = 9.
      this-object:label4:Text = "Родитель".
      this-object:label4:UseCompatibleTextRendering = true.
      this-object:label4:Visible = false.
      /*  */
      /* textBox4 */
      /*  */
      define variable nestedvar5 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar5 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox4:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar5, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox4:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindcode, "parent", true)).
      this-object:textBox4:Location = new System.Drawing.Point(185, 182).
      this-object:textBox4:Name = "textBox4".
      this-object:textBox4:ReadOnly = true.
      this-object:textBox4:Size = new System.Drawing.Size(324, 20).
      this-object:textBox4:TabIndex = 8.
      this-object:textBox4:Visible = false.
      /*  */
      /* label5 */
      /*  */
      this-object:label5:Location = new System.Drawing.Point(24, 208).
      this-object:label5:Name = "label5".
      this-object:label5:Size = new System.Drawing.Size(123, 23).
      this-object:label5:TabIndex = 11.
      this-object:label5:Text = "Процедура просмотра".
      this-object:label5:UseCompatibleTextRendering = true.
      this-object:label5:Visible = false.
      /*  */
      /* textBox5 */
      /*  */
      define variable nestedvar6 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar6 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox5:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar6, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox5:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindcode, "procview", true)).
      this-object:textBox5:Location = new System.Drawing.Point(185, 208).
      this-object:textBox5:Name = "textBox5".
      this-object:textBox5:Size = new System.Drawing.Size(324, 20).
      this-object:textBox5:TabIndex = 10.
      this-object:textBox5:Visible = false.
      /*  */
      /* label6 */
      /*  */
      this-object:label6:Location = new System.Drawing.Point(24, 234).
      this-object:label6:Name = "label6".
      this-object:label6:Size = new System.Drawing.Size(155, 23).
      this-object:label6:TabIndex = 13.
      this-object:label6:Text = "Процедура редактирования".
      this-object:label6:UseCompatibleTextRendering = true.
      this-object:label6:Visible = false.
      /*  */
      /* textBox6 */
      /*  */
      define variable nestedvar7 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar7 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox6:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar7, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox6:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindcode, "procedit", true)).
      this-object:textBox6:Location = new System.Drawing.Point(185, 234).
      this-object:textBox6:Name = "textBox6".
      this-object:textBox6:Size = new System.Drawing.Size(324, 20).
      this-object:textBox6:TabIndex = 12.
      this-object:textBox6:Visible = false.
      /*  */
      /* label7 */
      /*  */
      this-object:label7:Location = new System.Drawing.Point(24, 260).
      this-object:label7:Name = "label7".
      this-object:label7:Size = new System.Drawing.Size(143, 23).
      this-object:label7:TabIndex = 15.
      this-object:label7:Text = "Проедура удаления".
      this-object:label7:UseCompatibleTextRendering = true.
      this-object:label7:Visible = false.
      /*  */
      /* textBox7 */
      /*  */
      define variable nestedvar8 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar8 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:textBox7:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar8, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:textBox7:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindcode, "procdel", true)).
      this-object:textBox7:Location = new System.Drawing.Point(185, 260).
      this-object:textBox7:Name = "textBox7".
      this-object:textBox7:Size = new System.Drawing.Size(324, 20).
      this-object:textBox7:TabIndex = 14.
      this-object:textBox7:Visible = false.
      /*  */
      /* frmcode */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(528, 143).
      this-object:Controls:Add(this-object:label7).
      this-object:Controls:Add(this-object:textBox7).
      this-object:Controls:Add(this-object:label6).
      this-object:Controls:Add(this-object:textBox6).
      this-object:Controls:Add(this-object:label5).
      this-object:Controls:Add(this-object:textBox5).
      this-object:Controls:Add(this-object:label4).
      this-object:Controls:Add(this-object:textBox4).
      this-object:Controls:Add(this-object:label3).
      this-object:Controls:Add(this-object:textBox3).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:textBox2).
      this-object:Controls:Add(this-object:label1).
      this-object:Controls:Add(this-object:textBox1).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "frmcode".
      this-object:Text = "Справочник".
      cast(this-object:bindcode, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:ResumeLayout(false).
      this-object:PerformLayout().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 
   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.
   define variable VFirst as logical no-undo init yes.
   method public void setlable( inum as integer ,itext as character  ):
      if vfirst 
      then do:
         assign
            vfirst  = no
            label1  :visible = no
            textBox1:visible = no
            label2  :visible = no
            textBox2:visible = no
            label3  :visible = no
            textBox3:visible = no
         .
      end.
      if inum eq 1 
      then do:
         if itext eq ?
         then assign
            label1  :visible = no
            textBox1:visible = no
         .
         else  assign
            label1  :visible = yes
            textBox1:visible = yes
            label1  :text    = itext
         .
      end.
      else if inum eq 2 
      then do:
         if itext eq ?
         then assign
            label2  :visible = no
            textBox2:visible = no
         .
         else  assign
            label2  :visible = yes
            textBox2:visible = yes
            label2  :text    = itext
         .
      end.
      else if inum eq 3 
      then do:
         if itext eq ?
         then assign
            label3  :visible = no
            textBox3:visible = no
         .
         else  assign
            label3  :visible = yes
            textBox3:visible = yes
            label3  :text    = itext
         .
      end.
   end method.
end class.
