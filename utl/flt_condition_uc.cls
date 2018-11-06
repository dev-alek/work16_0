/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Юзер контрол условия 

Автор: Сергей Палагин
Дата создания: 21/10/18
Author: Sergey Palagin
Creation date: 21/10/18

*/

using Progress.Lang.*.
using Progress.Windows.UserControl.

block-level on error undo, throw.

class utl.flt_condition_uc inherits UserControl: 
   
   define private variable cbOp as System.Windows.Forms.ComboBox no-undo.
   define private variable cbEnabled as System.Windows.Forms.CheckBox no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
   define private variable tbName as System.Windows.Forms.TextBox no-undo.
   define private variable splitContainer3 as System.Windows.Forms.SplitContainer no-undo.
   define private variable splitContainer2 as System.Windows.Forms.SplitContainer no-undo.
   define private variable splitContainer1 as System.Windows.Forms.SplitContainer no-undo.
   define private variable panel1 as System.Windows.Forms.Panel no-undo.
   define private variable mtbValue as System.Windows.Forms.MaskedTextBox no-undo.

   define private var condition_ as class utl.flt-condition no-undo. 
      
   define public property Condition as class utl.flt-condition no-undo 
   get:
      return this-object:condition_.
   end get.
   set(iCond as class utl.flt-condition):
      this-object:condition_ = iCond.
   end set. 
   
   
   constructor public flt_condition_uc (  ):
      
      
      super().
      InitializeComponent().
      this-object:ComponentsCollection:ADD(this-object:components).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.

   end constructor.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void cbEnabled_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
	   
		if cast(sender,System.Windows.Forms.CheckBox):checked then
		do:
         assign
            cbOp:enabled = yes
            mtbValue:enabled = yes
         . 
		end.
		else
		do:
		   assign
            cbOp:enabled = no
            mtbValue:enabled = no
		   .
		end.
		return.

	end method.

   method private void InitializeComponent(  ):
      
      /* NOTE: The following method is automatically generated.
      
      We strongly suggest that the contents of this method only be modified using the
      Visual Designer to avoid any incompatible modifications.
      
      Modifying the contents of this method using a code editor will invalidate any support for this file. */
      this-object:panel1 = new System.Windows.Forms.Panel().
      this-object:splitContainer1 = new System.Windows.Forms.SplitContainer().
      this-object:splitContainer3 = new System.Windows.Forms.SplitContainer().
      this-object:cbEnabled = new System.Windows.Forms.CheckBox().
      this-object:tbName = new System.Windows.Forms.TextBox().
      this-object:splitContainer2 = new System.Windows.Forms.SplitContainer().
      this-object:cbOp = new System.Windows.Forms.ComboBox().
      this-object:mtbValue = new System.Windows.Forms.MaskedTextBox().
      this-object:panel1:SuspendLayout().
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer1:Panel1:SuspendLayout().
      this-object:splitContainer1:Panel2:SuspendLayout().
      this-object:splitContainer1:SuspendLayout().
      cast(this-object:splitContainer3, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer3:Panel1:SuspendLayout().
      this-object:splitContainer3:Panel2:SuspendLayout().
      this-object:splitContainer3:SuspendLayout().
      cast(this-object:splitContainer2, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer2:Panel1:SuspendLayout().
      this-object:splitContainer2:Panel2:SuspendLayout().
      this-object:splitContainer2:SuspendLayout().
      this-object:SuspendLayout().
      /*  */
      /* panel1 */
      /*  */
      this-object:panel1:Controls:Add(this-object:splitContainer1).
      this-object:panel1:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:panel1:Location = new System.Drawing.Point(0, 0).
      this-object:panel1:Name = "panel1".
      this-object:panel1:Size = new System.Drawing.Size(647, 33).
      this-object:panel1:TabIndex = 0.
      /*  */
      /* splitContainer1 */
      /*  */
      this-object:splitContainer1:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:splitContainer1:Location = new System.Drawing.Point(0, 0).
      this-object:splitContainer1:Name = "splitContainer1".
      /*  */
      /* splitContainer1.Panel1 */
      /*  */
      this-object:splitContainer1:Panel1:Controls:Add(this-object:splitContainer3).
      /*  */
      /* splitContainer1.Panel2 */
      /*  */
      this-object:splitContainer1:Panel2:Controls:Add(this-object:splitContainer2).
      this-object:splitContainer1:Size = new System.Drawing.Size(647, 33).
      this-object:splitContainer1:SplitterDistance = 260.
      this-object:splitContainer1:TabIndex = 0.
      /*  */
      /* splitContainer3 */
      /*  */
      this-object:splitContainer3:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:splitContainer3:Location = new System.Drawing.Point(0, 0).
      this-object:splitContainer3:Name = "splitContainer3".
      /*  */
      /* splitContainer3.Panel1 */
      /*  */
      this-object:splitContainer3:Panel1:Controls:Add(this-object:cbEnabled).
      /*  */
      /* splitContainer3.Panel2 */
      /*  */
      this-object:splitContainer3:Panel2:Controls:Add(this-object:tbName).
      this-object:splitContainer3:Size = new System.Drawing.Size(260, 33).
      this-object:splitContainer3:SplitterDistance = 29.
      this-object:splitContainer3:TabIndex = 0.
      /*  */
      /* cbEnabled */
      /*  */
      this-object:cbEnabled:Dock = System.Windows.Forms.DockStyle:Top.
      this-object:cbEnabled:Location = new System.Drawing.Point(0, 0).
      this-object:cbEnabled:Name = "cbEnabled".
      this-object:cbEnabled:Size = new System.Drawing.Size(29, 24).
      this-object:cbEnabled:TabIndex = 0.
      this-object:cbEnabled:UseCompatibleTextRendering = true.
      this-object:cbEnabled:UseVisualStyleBackColor = true.
      this-object:cbEnabled:CheckedChanged:Subscribe(this-object:cbEnabled_CheckedChanged).
      /*  */
      /* tbName */
      /*  */
      this-object:tbName:Dock = System.Windows.Forms.DockStyle:Top.
      this-object:tbName:Enabled = false.
      this-object:tbName:Location = new System.Drawing.Point(0, 0).
      this-object:tbName:Name = "tbName".
      this-object:tbName:Size = new System.Drawing.Size(227, 26).
      this-object:tbName:TabIndex = 0.
      /*  */
      /* splitContainer2 */
      /*  */
      this-object:splitContainer2:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:splitContainer2:Location = new System.Drawing.Point(0, 0).
      this-object:splitContainer2:Name = "splitContainer2".
      /*  */
      /* splitContainer2.Panel1 */
      /*  */
      this-object:splitContainer2:Panel1:Controls:Add(this-object:cbOp).
      /*  */
      /* splitContainer2.Panel2 */
      /*  */
      this-object:splitContainer2:Panel2:Controls:Add(this-object:mtbValue).
      this-object:splitContainer2:Size = new System.Drawing.Size(383, 33).
      this-object:splitContainer2:SplitterDistance = 168.
      this-object:splitContainer2:TabIndex = 0.
      /*  */
      /* cbOp */
      /*  */
      this-object:cbOp:Dock = System.Windows.Forms.DockStyle:Top.
      this-object:cbOp:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
      this-object:cbOp:FormattingEnabled = true.
      this-object:cbOp:Location = new System.Drawing.Point(0, 0).
      this-object:cbOp:Name = "cbOp".
      this-object:cbOp:Size = new System.Drawing.Size(168, 21).
      this-object:cbOp:TabIndex = 0.
      /*  */
      /* mtbValue */
      /*  */
      this-object:mtbValue:Dock = System.Windows.Forms.DockStyle:Top.
      this-object:mtbValue:Location = new System.Drawing.Point(0, 0).
      this-object:mtbValue:Name = "mtbValue".
      this-object:mtbValue:Size = new System.Drawing.Size(211, 26).
      this-object:mtbValue:TabIndex = 0.
      /*  */
      /* flt_condition_uc */
      /*  */
      this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
      this-object:Controls:Add(this-object:panel1).
      this-object:Name = "flt_condition_uc".
      this-object:Size = new System.Drawing.Size(647, 33).
      this-object:panel1:ResumeLayout(false).
      this-object:splitContainer1:Panel1:ResumeLayout(false).
      this-object:splitContainer1:Panel2:ResumeLayout(false).
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer1:ResumeLayout(false).
      this-object:splitContainer3:Panel1:ResumeLayout(false).
      this-object:splitContainer3:Panel2:ResumeLayout(false).
      this-object:splitContainer3:Panel2:PerformLayout().
      cast(this-object:splitContainer3, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer3:ResumeLayout(false).
      this-object:splitContainer2:Panel1:ResumeLayout(false).
      this-object:splitContainer2:Panel2:ResumeLayout(false).
      this-object:splitContainer2:Panel2:PerformLayout().
      cast(this-object:splitContainer2, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer2:ResumeLayout(false).
      this-object:ResumeLayout(false).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method.

   method public void ObjectToForm():
      
      def var vI as int64 no-undo.
      
      if valid-object(this-object:Condition) then
      do:
      
         assign
            this-object:cbEnabled:Checked = this-object:Condition:Enabled
            this-object:tbName:Text = this-object:Condition:FieldName
            this-object:mtbValue:Text = this-object:Condition:Value
         .
         if this-object:cbEnabled:Checked then
         do:
            assign
               cbOp:enabled = yes
               mtbValue:enabled = yes
            . 
         end.
         else
         do:
            assign
               cbOp:enabled = no
               mtbValue:enabled = no
            .
            
         end.
         
         do vI = 1 to num-entries(this-object:Condition:SupportOp):
            this-object:cbOp:Items:Add(entry(vI,this-object:Condition:SupportOp)).
         end.
         
         this-object:cbOp:Text = this-object:Condition:Operation.
         
      end.
      
      return.

   end method.

   method public void FormToObject():
      
      def var vI as int64 no-undo.
      
      if valid-object(this-object:Condition) then
      do:
      
         assign
            this-object:Condition:enabled = this-object:cbEnabled:Checked
            this-object:Condition:value = this-object:mtbValue:Text
            this-object:Condition:Operation = this-object:cbOp:Text  
         .
      end.
      
      return.

   end method.

   destructor public flt_condition_uc ( ):

   end destructor.

end class.