 
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$

Форма фильтра для формы браузера gpwdbrw

Автор: Сергей Палагин
Дата создания: 21/10/18
Author: Sergey Palagin
Creation date: 21/10/18

*/

using Progress.Lang.*.
using Progress.Windows.Form.

block-level on error undo, throw.

class utl.gpwdbrw_flt inherits Form: 
   
   define private variable btnCancel as System.Windows.Forms.Button no-undo.
   define private variable btnApply as System.Windows.Forms.Button no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
   define private variable gbModofier as System.Windows.Forms.GroupBox no-undo.
   define private variable panel1 as System.Windows.Forms.Panel no-undo.
   define private variable rbOr as System.Windows.Forms.RadioButton no-undo.
   define private variable rbAnd as System.Windows.Forms.RadioButton no-undo.
   define private variable splitContainer1 as System.Windows.Forms.SplitContainer no-undo.
   define private variable ucCashNum as utl.flt_condition_uc no-undo.
   define private variable ucDateGen as utl.flt_condition_uc no-undo.
   define private variable ucDateProl as utl.flt_condition_uc no-undo.
   define private variable ucFio as utl.flt_condition_uc no-undo.
   define private variable ucHostName as utl.flt_condition_uc no-undo.
   define private variable ucObject as utl.flt_condition_uc no-undo.
   define private variable ucTimeGen as utl.flt_condition_uc no-undo.
   define private variable ucUser as utl.flt_condition_uc no-undo.
   define private variable Filter as class utl.gpwdbrw-filter no-undo.

      
   constructor public gpwdbrw_flt (  ):
      
      
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
	method private void btnApply_Click( input sender as System.Object, input e as System.EventArgs ):
		this-object:FormToObject().
		this-object:DialogResult = System.Windows.Forms.DialogResult:ok.
		this-object:Close().
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btnCancel_Click( input sender as System.Object, input e as System.EventArgs ):
		
		this-object:DialogResult = System.Windows.Forms.DialogResult:cancel.
		this-object:Close().
		
		return.

	end method.


	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void gpwdbrw_flt_VisibleChanged( input sender as System.Object, input e as System.EventArgs ):
		return.

	end method.

   method private void InitializeComponent(  ):
      
      /* NOTE: The following method is automatically generated.
      
      We strongly suggest that the contents of this method only be modified using the
      Visual Designer to avoid any incompatible modifications.
      
      Modifying the contents of this method using a code editor will invalidate any support for this file. */
      this-object:panel1 = new System.Windows.Forms.Panel().
      this-object:splitContainer1 = new System.Windows.Forms.SplitContainer().
      this-object:btnCancel = new System.Windows.Forms.Button().
      this-object:btnApply = new System.Windows.Forms.Button().
      this-object:ucDateProl = new utl.flt_condition_uc().
      this-object:ucCashNum = new utl.flt_condition_uc().
      this-object:gbModofier = new System.Windows.Forms.GroupBox().
      this-object:rbOr = new System.Windows.Forms.RadioButton().
      this-object:rbAnd = new System.Windows.Forms.RadioButton().
      this-object:ucObject = new utl.flt_condition_uc().
      this-object:ucFio = new utl.flt_condition_uc().
      this-object:ucTimeGen = new utl.flt_condition_uc().
      this-object:ucDateGen = new utl.flt_condition_uc().
      this-object:ucHostName = new utl.flt_condition_uc().
      this-object:ucUser = new utl.flt_condition_uc().
      this-object:panel1:SuspendLayout().
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer1:Panel1:SuspendLayout().
      this-object:splitContainer1:Panel2:SuspendLayout().
      this-object:splitContainer1:SuspendLayout().
      this-object:gbModofier:SuspendLayout().
      this-object:SuspendLayout().
      /*  */
      /* panel1 */
      /*  */
      this-object:panel1:Controls:Add(this-object:splitContainer1).
      this-object:panel1:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:panel1:Location = new System.Drawing.Point(0, 0).
      this-object:panel1:Name = "panel1".
      this-object:panel1:Size = new System.Drawing.Size(631, 663).
      this-object:panel1:TabIndex = 0.
      /*  */
      /* splitContainer1 */
      /*  */
      this-object:splitContainer1:Dock = System.Windows.Forms.DockStyle:Fill.
      this-object:splitContainer1:Location = new System.Drawing.Point(0, 0).
      this-object:splitContainer1:Name = "splitContainer1".
      this-object:splitContainer1:Orientation = System.Windows.Forms.Orientation:Horizontal.
      /*  */
      /* splitContainer1.Panel1 */
      /*  */
      this-object:splitContainer1:Panel1:Controls:Add(this-object:btnCancel).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:btnApply).
      /*  */
      /* splitContainer1.Panel2 */
      /*  */
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucDateProl).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucCashNum).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:gbModofier).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucObject).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucFio).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucTimeGen).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucDateGen).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucHostName).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:ucUser).
      this-object:splitContainer1:Size = new System.Drawing.Size(631, 663).
      this-object:splitContainer1:SplitterDistance = 78.
      this-object:splitContainer1:TabIndex = 0.
      /*  */
      /* btnCancel */
      /*  */
      this-object:btnCancel:Location = new System.Drawing.Point(143, 12).
      this-object:btnCancel:Name = "btnCancel".
      this-object:btnCancel:Size = new System.Drawing.Size(108, 23).
      this-object:btnCancel:TabIndex = 1.
      this-object:btnCancel:Text = "Отказаться".
      this-object:btnCancel:UseCompatibleTextRendering = true.
      this-object:btnCancel:UseVisualStyleBackColor = true.
      this-object:btnCancel:Click:Subscribe(this-object:btnCancel_Click).
      /*  */
      /* btnApply */
      /*  */
      this-object:btnApply:Location = new System.Drawing.Point(12, 12).
      this-object:btnApply:Name = "btnApply".
      this-object:btnApply:Size = new System.Drawing.Size(108, 23).
      this-object:btnApply:TabIndex = 0.
      this-object:btnApply:Text = "Применить".
      this-object:btnApply:UseCompatibleTextRendering = true.
      this-object:btnApply:UseVisualStyleBackColor = true.
      this-object:btnApply:Click:Subscribe(this-object:btnApply_Click).
      /*  */
      /* ucDateProl */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucDateProl:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucDateProl:Location = new System.Drawing.Point(12, 324).
      this-object:ucDateProl:Name = "ucDateProl".
      this-object:ucDateProl:Size = new System.Drawing.Size(607, 33).
      this-object:ucDateProl:TabIndex = 7.
      /*  */
      /* ucCashNum */
      /*  */
      define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar1 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucCashNum:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucCashNum:Location = new System.Drawing.Point(12, 273).
      this-object:ucCashNum:Name = "ucCashNum".
      this-object:ucCashNum:Size = new System.Drawing.Size(607, 33).
      this-object:ucCashNum:TabIndex = 6.
      /*  */
      /* gbModofier */
      /*  */
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:gbModofier:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:gbModofier:Controls:Add(this-object:rbOr).
      this-object:gbModofier:Controls:Add(this-object:rbAnd).
      this-object:gbModofier:Location = new System.Drawing.Point(6, 407).
      this-object:gbModofier:Name = "gbModofier".
      this-object:gbModofier:Size = new System.Drawing.Size(613, 122).
      this-object:gbModofier:TabIndex = 6.
      this-object:gbModofier:TabStop = false.
      this-object:gbModofier:Text = "Способ объединения фильтров".
      this-object:gbModofier:UseCompatibleTextRendering = true.
      /*  */
      /* rbOr */
      /*  */
      this-object:rbOr:Location = new System.Drawing.Point(30, 81).
      this-object:rbOr:Name = "rbOr".
      this-object:rbOr:Size = new System.Drawing.Size(75, 24).
      this-object:rbOr:TabIndex = 1.
      this-object:rbOr:TabStop = true.
      this-object:rbOr:Text = "ИЛИ".
      this-object:rbOr:UseCompatibleTextRendering = true.
      this-object:rbOr:UseVisualStyleBackColor = true.
      /*  */
      /* rbAnd */
      /*  */
      this-object:rbAnd:Checked = true.
      this-object:rbAnd:Location = new System.Drawing.Point(30, 34).
      this-object:rbAnd:Name = "rbAnd".
      this-object:rbAnd:Size = new System.Drawing.Size(78, 24).
      this-object:rbAnd:TabIndex = 0.
      this-object:rbAnd:TabStop = true.
      this-object:rbAnd:Text = "И".
      this-object:rbAnd:UseCompatibleTextRendering = true.
      this-object:rbAnd:UseVisualStyleBackColor = true.
      /*  */
      /* ucObject */
      /*  */
      define variable nestedvar3 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar3 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucObject:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucObject:Location = new System.Drawing.Point(12, 234).
      this-object:ucObject:Name = "ucObject".
      this-object:ucObject:Size = new System.Drawing.Size(607, 33).
      this-object:ucObject:TabIndex = 5.
      /*  */
      /* ucFio */
      /*  */
      define variable nestedvar4 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar4 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucFio:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar4, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucFio:Location = new System.Drawing.Point(12, 195).
      this-object:ucFio:Name = "ucFio".
      this-object:ucFio:Size = new System.Drawing.Size(607, 33).
      this-object:ucFio:TabIndex = 4.
      /*  */
      /* ucTimeGen */
      /*  */
      define variable nestedvar5 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar5 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucTimeGen:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar5, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucTimeGen:Location = new System.Drawing.Point(12, 156).
      this-object:ucTimeGen:Name = "ucTimeGen".
      this-object:ucTimeGen:Size = new System.Drawing.Size(607, 33).
      this-object:ucTimeGen:TabIndex = 3.
      /*  */
      /* ucDateGen */
      /*  */
      define variable nestedvar6 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar6 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucDateGen:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar6, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucDateGen:Location = new System.Drawing.Point(12, 117).
      this-object:ucDateGen:Name = "ucDateGen".
      this-object:ucDateGen:Size = new System.Drawing.Size(607, 33).
      this-object:ucDateGen:TabIndex = 2.
      /*  */
      /* ucHostName */
      /*  */
      define variable nestedvar7 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar7 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucHostName:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar7, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucHostName:Location = new System.Drawing.Point(12, 78).
      this-object:ucHostName:Name = "ucHostName".
      this-object:ucHostName:Size = new System.Drawing.Size(607, 33).
      this-object:ucHostName:TabIndex = 1.
      /*  */
      /* ucUser */
      /*  */
      define variable nestedvar8 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar8 = System.Windows.Forms.AnchorStyles:Left.
      this-object:ucUser:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar8, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ucUser:Location = new System.Drawing.Point(12, 39).
      this-object:ucUser:Name = "ucUser".
      this-object:ucUser:Size = new System.Drawing.Size(607, 33).
      this-object:ucUser:TabIndex = 0.
      /*  */
      /* gpwdbrw_flt */
      /*  */
      this-object:ClientSize = new System.Drawing.Size(631, 663).
      this-object:Controls:Add(this-object:panel1).
      this-object:Name = "gpwdbrw_flt".
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterScreen.
      this-object:Text = "Фильтры".
      this-object:VisibleChanged:Subscribe(this-object:gpwdbrw_flt_VisibleChanged).
      this-object:panel1:ResumeLayout(false).
      this-object:splitContainer1:Panel1:ResumeLayout(false).
      this-object:splitContainer1:Panel2:ResumeLayout(false).
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer1:ResumeLayout(false).
      this-object:gbModofier:ResumeLayout(false).
      this-object:ResumeLayout(false).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method.

   method public static utl.gpwdbrw_flt GetObject(iFilter as class utl.gpwdbrw-filter):
      
      def var vForm as class utl.gpwdbrw_flt.
      
      assign
         vForm = new utl.gpwdbrw_flt()
         vForm:Filter = iFilter
      .
      
      vForm:SetCondition("User",    vForm:Filter:User).
      vForm:SetCondition("HostName",vForm:Filter:HostName).
      vForm:SetCondition("DateGen", vForm:Filter:DateGen).
      vForm:SetCondition("TimeGen", vForm:Filter:TimeGen).
      vForm:SetCondition("Fio",     vForm:Filter:Fio).
      vForm:SetCondition("Object",  vForm:Filter:ObjectNum).
      vForm:SetCondition("CashNum", vForm:Filter:CashNum).
      vForm:SetCondition("DateProl",vForm:Filter:DateProl).
      vForm:ObjectToForm().
      
      return vForm.
      
   end method.

   method public void SetCondition(iControlName as char, iCond as utl.flt-condition):
      
      case iControlName:
         when "User"     then ucUser:Condition = iCond.
         when "HostName" then ucHostName:Condition = iCond.
         when "DateGen"  then ucDateGen:Condition = iCond.
         when "TimeGen"  then ucTimeGen:Condition = iCond.
         when "Fio"      then ucFio:Condition = iCond.
         when "Object"   then ucObject:Condition = iCond.
         when "CashNum"  then ucCashNum:Condition = iCond.
         when "DateProl"  then ucDateProl:Condition = iCond.
      end case.

   end method.

   method public void FormToObject():

      this-object:ucUser:FormToObject().
      this-object:ucFio:FormToObject(). 
      this-object:ucDateGen:FormToObject().
      this-object:ucTimeGen:FormToObject().
      this-object:ucObject:FormToObject(). 
      this-object:ucHostName:FormToObject().
      this-object:ucCashNum:FormToObject().
      this-object:ucDateProl:FormToObject().
      
      if this-object:rbAnd:Checked then
         this-object:Filter:Modifier = "and".
         
      if this-object:rbOr:Checked then
         this-object:Filter:Modifier = "or".
          
   end method.

   method public void ObjectToForm():
      
      this-object:ucUser:ObjectToForm().
      this-object:ucFio:ObjectToForm(). 
      this-object:ucDateGen:ObjectToForm().
      this-object:ucTimeGen:ObjectToForm().
      this-object:ucObject:ObjectToForm(). 
      this-object:ucHostName:ObjectToForm().
      this-object:ucCashNum:ObjectToForm().
      this-object:ucDateProl:ObjectToForm().
           
      if this-object:Filter:Modifier = "and" then
         this-object:rbAnd:Checked = yes.
         
         
      if this-object:Filter:Modifier = "or" then
         this-object:rbOr:Checked = yes. 
      
          
   end method.
   
   destructor public gpwdbrw_flt ( ):

   end destructor.

end class.