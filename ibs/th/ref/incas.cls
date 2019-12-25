 
 /*------------------------------------------------------------------------
    File        : incas
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Tue Nov 05 12:55:21 MSK 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.Form.

block-level on error undo, throw.

class ibs.th.ref.incas inherits Form: 
   
   define private variable Bt_ok as System.Windows.Forms.Button no-undo.
   define private variable button1 as System.Windows.Forms.Button no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
   define private variable fOsn as System.Windows.Forms.TextBox no-undo.
   define private variable fDop as System.Windows.Forms.TextBox no-undo.
   define private variable label3 as System.Windows.Forms.Label no-undo.
   define private variable label2 as System.Windows.Forms.Label no-undo.
   define private variable label1 as System.Windows.Forms.Label no-undo.
   define private variable fSum as System.Windows.Forms.TextBox no-undo.
   define private variable windowContainer1 as ibs.th.ref.Coins_Banknot no-undo.
{ ibs\th\ref\Coins_Bank_tt.i }
   define public variable mSumm as decimal  no-undo.
   define public variable mosnbag as character no-undo.   
   define public variable mdopbag as character no-undo.
   define public variable mMoney as character no-undo.
   
   define public property maxSum    as decimal  no-undo init ?
  private get.
  set(input isum as decimal ):
    maxSum = iSum.
    fSum:text = string(maxSum).
  end. 
   constructor public incas (  ):
      
      
      super().
      InitializeComponent().
      add_Banknot().
      windowContainer1:Update_Banknots (getq_Banknot()).
      add_Coints(). 
      windowContainer1:Update_coints( getq_Coints()).
      windowContainer1:Fsumm:ReadOnly = yes.
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
	method private void Bt_ok_Click( input sender as System.Object, input e as System.EventArgs ):
	   define variable Vmoney as longchar  no-undo.
	   if     windowContainer1:v-total-sum ne 0
	      and windowContainer1:v-total-sum ne dec(fSum:text)
	   then do:
	      message "Веднная сумма не сответствует введеным номиналам"
         view-as alert-box.
         return.
      end.
      if      maxSum ne ?
          and dec(fSum:text) > maxSum
      then do:
         message "Сумма инкасации " dec(fSum:text) " не может быть больше суммы денег в кассе " maxSum
         view-as alert-box.
         return.
      end.
	   if fDop:text ne "" and fDop:text ne ? and trim(fOsn:text)  ne trim(fdop:text)
	   then do:
	       dataset ds-banknots:empty-dataset().
	       Vmoney = "".
	   end.
	   else
	      if windowContainer1:v-total-sum eq 0
	      then
	         Vmoney = "".
	      else
	         dataset ds-banknots:write-json("longchar", Vmoney).
	   this-object:mSumm = dec(fSum:text).
	   this-object:mosnbag = trim(fOsn:text).
	   this-object:mdopbag = trim(if fDop:text eq "" or fDop:text eq ? then fOsn:text else fDop:text).
	   this-object:mMoney  = Vmoney.
		this-object:DialogResult = System.Windows.Forms.DialogResult:Ok.
		
		this-object:Close ( ).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button1_Click( input sender as System.Object, input e as System.EventArgs ):
	   this-object:Close ( ).
	   return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void fDop_TextChanged( input sender as System.Object, input e as System.EventArgs ):
		windowContainer1:visible = fDop:text eq "" or fDop:text eq ? or trim(fDop:text) = trim(fosn:text).
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void fOsn_TextChanged( input sender as System.Object, input e as System.EventArgs ):
		fDop:visible    = fosn:text ne "" and fosn:text ne ?. 
		label3:visible  = fosn:text ne "" and fosn:text ne ?.
		return.

	end method.

   method private void InitializeComponent(  ):
      
      /* NOTE: The following method is automatically generated.
      
      We strongly suggest that the contents of this method only be modified using the
      Visual Designer to avoid any incompatible modifications.
      
      Modifying the contents of this method using a code editor will invalidate any support for this file. */
      this-object:windowContainer1 = new ibs.th.ref.Coins_Banknot().
      this-object:button1 = new System.Windows.Forms.Button().
      this-object:Bt_ok = new System.Windows.Forms.Button().
      this-object:fSum = new System.Windows.Forms.TextBox().
      this-object:label1 = new System.Windows.Forms.Label().
      this-object:fOsn = new System.Windows.Forms.TextBox().
      this-object:fDop = new System.Windows.Forms.TextBox().
      this-object:label2 = new System.Windows.Forms.Label().
      this-object:label3 = new System.Windows.Forms.Label().
      this-object:SuspendLayout().
      /*  */
      /* windowContainer1 */
      /*  */
      this-object:windowContainer1:Location = new System.Drawing.Point(12, 171).
      this-object:windowContainer1:Name = "windowContainer1".
      this-object:windowContainer1:Size = new System.Drawing.Size(677, 285).
      this-object:windowContainer1:TabIndex = 0.
      /*  */
      /* button1 */
      /*  */
      this-object:button1:Location = new System.Drawing.Point(391, 462).
      this-object:button1:Name = "button1".
      this-object:button1:Size = new System.Drawing.Size(75, 23).
      this-object:button1:TabIndex = 1.
      this-object:button1:Text = "Отмена".
      this-object:button1:UseCompatibleTextRendering = true.
      this-object:button1:UseVisualStyleBackColor = true.
      this-object:button1:Click:Subscribe(this-object:button1_Click).
      /*  */
      /* Bt_ok */
      /*  */
      this-object:Bt_ok:Location = new System.Drawing.Point(257, 462).
      this-object:Bt_ok:Name = "Bt_ok".
      this-object:Bt_ok:Size = new System.Drawing.Size(110, 23).
      this-object:Bt_ok:TabIndex = 2.
      this-object:Bt_ok:Text = "Сформировать".
      this-object:Bt_ok:UseCompatibleTextRendering = true.
      this-object:Bt_ok:UseVisualStyleBackColor = true.
      this-object:Bt_ok:Click:Subscribe(this-object:Bt_ok_Click).
      /*  */
      /* fSum */
      /*  */
      this-object:fSum:Location = new System.Drawing.Point(225, 21).
      this-object:fSum:Name = "fSum".
      this-object:fSum:Size = new System.Drawing.Size(304, 20).
      this-object:fSum:TabIndex = 3.
      /*  */
      /* label1 */
      /*  */
      this-object:label1:Location = new System.Drawing.Point(168, 18).
      this-object:label1:Name = "label1".
      this-object:label1:Size = new System.Drawing.Size(51, 23).
      this-object:label1:TabIndex = 4.
      this-object:label1:Text = "Сумма:".
      this-object:label1:UseCompatibleTextRendering = true.
      /*  */
      /* fOsn */
      /*  */
      this-object:fOsn:Location = new System.Drawing.Point(225, 60).
      this-object:fOsn:Name = "fOsn".
      this-object:fOsn:Size = new System.Drawing.Size(304, 20).
      this-object:fOsn:TabIndex = 5.
      this-object:fOsn:TextChanged:Subscribe(this-object:fOsn_TextChanged).
      /*  */
      /* fDop */
      /*  */
      this-object:fDop:Location = new System.Drawing.Point(225, 100).
      this-object:fDop:Name = "fDop".
      this-object:fDop:Size = new System.Drawing.Size(304, 20).
      this-object:fDop:TabIndex = 6.
      this-object:fDop:Visible = false.
      this-object:fDop:TextChanged:Subscribe(this-object:fDop_TextChanged).
      /*  */
      /* label2 */
      /*  */
      this-object:label2:Location = new System.Drawing.Point(7, 60).
      this-object:label2:Name = "label2".
      this-object:label2:Size = new System.Drawing.Size(212, 23).
      this-object:label2:TabIndex = 7.
      this-object:label2:Text = "Номер сумки (основная деятельность):".
      this-object:label2:UseCompatibleTextRendering = true.
      this-object:label2:Click:Subscribe(this-object:label2_Click).
      /*  */
      /* label3 */
      /*  */
      this-object:label3:Location = new System.Drawing.Point(25, 97).
      this-object:label3:Name = "label3".
      this-object:label3:Size = new System.Drawing.Size(194, 23).
      this-object:label3:TabIndex = 8.
      this-object:label3:Text = "Номер сумки (агент. деятельность):".
      this-object:label3:UseCompatibleTextRendering = true.
      /*  */
      /* incas */
      /*  */
      this-object:ClientSize = new System.Drawing.Size(755, 497).
      this-object:Controls:Add(this-object:label3).
      this-object:Controls:Add(this-object:label2).
      this-object:Controls:Add(this-object:fDop).
      this-object:Controls:Add(this-object:fOsn).
      this-object:Controls:Add(this-object:label1).
      this-object:Controls:Add(this-object:fSum).
      this-object:Controls:Add(this-object:Bt_ok).
      this-object:Controls:Add(this-object:button1).
      this-object:Controls:Add(this-object:windowContainer1).
      this-object:Cursor = System.Windows.Forms.Cursors:Default.
      this-object:Name = "incas".
      this-object:Text = "Инкасация".
      this-object:ResumeLayout(false).
      this-object:PerformLayout().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void label2_Click( input sender as System.Object, input e as System.EventArgs ):
		
		return.

	end method.


   destructor public incas ( ):

   end destructor.

end class.