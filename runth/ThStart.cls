 /*------------------------------------------------------------------------
    File        : ThStart
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Sun Oct 11 18:28:02 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class runth.ThStart inherits Form : 

   define private variable btn_delete_9 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_8 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_7 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_6 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_5 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_4 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_3 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_2 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_10 as System.Windows.Forms.Button no-undo.
   define private variable btn_delete_1 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_9 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_8 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_7 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_6 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_5 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_4 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_3 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_2 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_10 as System.Windows.Forms.Button no-undo.
   define private variable btn_choice_1 as System.Windows.Forms.Button no-undo.
   define private variable btn_setup as System.Windows.Forms.Button no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
   define private variable teg_attr_9 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_8 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_7 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_6 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_5 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_4 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_3 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_2 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_10 as System.Windows.Forms.TextBox no-undo.
   define private variable teg_attr_1 as System.Windows.Forms.TextBox no-undo.
   define private variable splitContainer1 as System.Windows.Forms.SplitContainer no-undo.
   define private variable labVer as System.Windows.Forms.Label no-undo.
   define private variable Val_ComBox_9 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_8 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_7 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_6 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_5 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_4 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_3 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_2 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_10 as System.Windows.Forms.ComboBox no-undo.
   define private variable Val_ComBox_1 as System.Windows.Forms.ComboBox no-undo.
   define private variable VerComBox as System.Windows.Forms.ComboBox no-undo.
   define variable mtrg as class runth.runth_trg no-undo.
   
   constructor public ThStart( ):
   
      super().
      InitializeComponent ( ).
      mtrg = new  runth.runth_trg ().
      InitVal().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   constructor public ThStart(itrg as class runth.runth_trg ):
   
      super().
      InitializeComponent ( ).
      mtrg = itrg.
      InitVal().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

   end constructor.

   destructor public ThStart( ):

      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

   end destructor.   

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_10_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(10).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_1_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(1).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_2_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(2).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_3_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(3).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_4_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(4).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_5_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(5).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_6_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(6).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_7_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(7).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_8_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(8).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_choice_9_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnChoice(9).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_10_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(10).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_1_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(1).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_2_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(2).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_3_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(3).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_4_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(4).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_5_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(5).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_6_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(6).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_7_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(7).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_8_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(8).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_delete_9_Click( input sender as System.Object, input e as System.EventArgs ):
		BtnDelHot(9).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btn_setup_Click( input sender as System.Object, input e as System.EventArgs ):
		mtrg:SetupParam().
		InitVal().
		return.

	end method.

    method private void okButton_Click (sender as System.Object, e as System.EventArgs):
       define variable vi as integer no-undo.
       mtrg:SaveComBox(VerComBox,-1).
       do vi = 1 to 10:
          mtrg:SaveComBox(GetValBox(vi),vi).
       end.
       mtrg:SaveHotParam().
       mtrg:replaseFile(VerComBox:Text). 
      /*this-object:DialogResult = System.Windows.Forms.DialogResult:Ok.
      this-object:Close ( ).*/ 
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
      
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable resources as Progress.Util.ResourceManager no-undo.
      resources = new Progress.Util.ResourceManager("runth.ThStart").
      this-object:buttonOk = new System.Windows.Forms.Button().
      this-object:buttonCancel = new System.Windows.Forms.Button().
      this-object:VerComBox = new System.Windows.Forms.ComboBox().
      this-object:labVer = new System.Windows.Forms.Label().
      this-object:teg_attr_1 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_2 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_3 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_4 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_5 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_6 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_7 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_8 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_9 = new System.Windows.Forms.TextBox().
      this-object:teg_attr_10 = new System.Windows.Forms.TextBox().
      this-object:Val_ComBox_1 = new System.Windows.Forms.ComboBox().
      this-object:Val_ComBox_2 = new System.Windows.Forms.ComboBox().
      this-object:splitContainer1 = new System.Windows.Forms.SplitContainer().
      this-object:btn_delete_10 = new System.Windows.Forms.Button().
      this-object:btn_delete_9 = new System.Windows.Forms.Button().
      this-object:btn_delete_8 = new System.Windows.Forms.Button().
      this-object:btn_delete_7 = new System.Windows.Forms.Button().
      this-object:btn_delete_6 = new System.Windows.Forms.Button().
      this-object:btn_delete_5 = new System.Windows.Forms.Button().
      this-object:btn_delete_4 = new System.Windows.Forms.Button().
      this-object:btn_delete_3 = new System.Windows.Forms.Button().
      this-object:btn_delete_2 = new System.Windows.Forms.Button().
      this-object:btn_delete_1 = new System.Windows.Forms.Button().
      this-object:btn_choice_10 = new System.Windows.Forms.Button().
      this-object:btn_choice_9 = new System.Windows.Forms.Button().
      this-object:btn_choice_8 = new System.Windows.Forms.Button().
      this-object:btn_choice_7 = new System.Windows.Forms.Button().
      this-object:btn_choice_6 = new System.Windows.Forms.Button().
      this-object:btn_choice_5 = new System.Windows.Forms.Button().
      this-object:Val_ComBox_10 = new System.Windows.Forms.ComboBox().
      this-object:btn_choice_4 = new System.Windows.Forms.Button().
      this-object:Val_ComBox_9 = new System.Windows.Forms.ComboBox().
      this-object:btn_choice_3 = new System.Windows.Forms.Button().
      this-object:Val_ComBox_8 = new System.Windows.Forms.ComboBox().
      this-object:btn_choice_2 = new System.Windows.Forms.Button().
      this-object:Val_ComBox_7 = new System.Windows.Forms.ComboBox().
      this-object:btn_choice_1 = new System.Windows.Forms.Button().
      this-object:Val_ComBox_6 = new System.Windows.Forms.ComboBox().
      this-object:Val_ComBox_5 = new System.Windows.Forms.ComboBox().
      this-object:Val_ComBox_4 = new System.Windows.Forms.ComboBox().
      this-object:Val_ComBox_3 = new System.Windows.Forms.ComboBox().
      this-object:btn_setup = new System.Windows.Forms.Button().
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):BeginInit().
      this-object:splitContainer1:Panel1:SuspendLayout().
      this-object:splitContainer1:Panel2:SuspendLayout().
      this-object:splitContainer1:SuspendLayout().
      this-object:SuspendLayout().
      /*  */
      /* buttonOk */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonOk:Location = new System.Drawing.Point(402, 340).
      this-object:buttonOk:Name = "buttonOk".
      this-object:buttonOk:Size = new System.Drawing.Size(75, 23).
      this-object:buttonOk:TabIndex = 0.
      this-object:buttonOk:Text = "Создать".
      this-object:buttonOk:UseCompatibleTextRendering = true.
      this-object:buttonOk:Click:Subscribe(this-object:okButton_Click).
      /*  */
      /* buttonCancel */
      /*  */
      define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar1 = System.Windows.Forms.AnchorStyles:Bottom.
      this-object:buttonCancel:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
      this-object:buttonCancel:Location = new System.Drawing.Point(486, 340).
      this-object:buttonCancel:Name = "buttonCancel".
      this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
      this-object:buttonCancel:TabIndex = 1.
      this-object:buttonCancel:Text = "Выход".
      this-object:buttonCancel:UseCompatibleTextRendering = true.
      this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
      /*  */
      /* VerComBox */
      /*  */
      this-object:VerComBox:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
      this-object:VerComBox:FormattingEnabled = true.
      this-object:VerComBox:Location = new System.Drawing.Point(104, 12).
      this-object:VerComBox:Name = "VerComBox".
      this-object:VerComBox:Size = new System.Drawing.Size(326, 21).
      this-object:VerComBox:TabIndex = 2.
      /*  */
      /* labVer */
      /*  */
      this-object:labVer:Location = new System.Drawing.Point(13, 12).
      this-object:labVer:Name = "labVer".
      this-object:labVer:Size = new System.Drawing.Size(85, 23).
      this-object:labVer:TabIndex = 3.
      this-object:labVer:Text = "Версия".
      this-object:labVer:UseCompatibleTextRendering = true.
      /*  */
      /* teg_attr_1 */
      /*  */
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_1:Location = new System.Drawing.Point(3, 11).
      this-object:teg_attr_1:Name = "teg_attr_1".
      this-object:teg_attr_1:ReadOnly = true.
      this-object:teg_attr_1:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_1:TabIndex = 4.
      /*  */
      /* teg_attr_2 */
      /*  */
      define variable nestedvar3 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar3 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_2:Location = new System.Drawing.Point(3, 37).
      this-object:teg_attr_2:Name = "teg_attr_2".
      this-object:teg_attr_2:ReadOnly = true.
      this-object:teg_attr_2:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_2:TabIndex = 5.
      /*  */
      /* teg_attr_3 */
      /*  */
      define variable nestedvar4 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar4 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_3:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar4, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_3:Location = new System.Drawing.Point(3, 65).
      this-object:teg_attr_3:Name = "teg_attr_3".
      this-object:teg_attr_3:ReadOnly = true.
      this-object:teg_attr_3:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_3:TabIndex = 6.
      /*  */
      /* teg_attr_4 */
      /*  */
      define variable nestedvar5 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar5 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_4:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar5, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_4:Location = new System.Drawing.Point(3, 91).
      this-object:teg_attr_4:Name = "teg_attr_4".
      this-object:teg_attr_4:ReadOnly = true.
      this-object:teg_attr_4:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_4:TabIndex = 7.
      /*  */
      /* teg_attr_5 */
      /*  */
      define variable nestedvar6 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar6 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_5:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar6, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_5:Location = new System.Drawing.Point(3, 119).
      this-object:teg_attr_5:Name = "teg_attr_5".
      this-object:teg_attr_5:ReadOnly = true.
      this-object:teg_attr_5:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_5:TabIndex = 8.
      /*  */
      /* teg_attr_6 */
      /*  */
      define variable nestedvar7 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar7 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_6:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar7, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_6:Location = new System.Drawing.Point(3, 145).
      this-object:teg_attr_6:Name = "teg_attr_6".
      this-object:teg_attr_6:ReadOnly = true.
      this-object:teg_attr_6:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_6:TabIndex = 9.
      /*  */
      /* teg_attr_7 */
      /*  */
      define variable nestedvar8 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar8 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_7:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar8, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_7:Location = new System.Drawing.Point(3, 173).
      this-object:teg_attr_7:Name = "teg_attr_7".
      this-object:teg_attr_7:ReadOnly = true.
      this-object:teg_attr_7:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_7:TabIndex = 10.
      /*  */
      /* teg_attr_8 */
      /*  */
      define variable nestedvar9 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar9 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_8:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar9, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_8:Location = new System.Drawing.Point(3, 200).
      this-object:teg_attr_8:Name = "teg_attr_8".
      this-object:teg_attr_8:ReadOnly = true.
      this-object:teg_attr_8:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_8:TabIndex = 11.
      /*  */
      /* teg_attr_9 */
      /*  */
      define variable nestedvar10 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar10 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_9:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar10, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_9:Location = new System.Drawing.Point(3, 226).
      this-object:teg_attr_9:Name = "teg_attr_9".
      this-object:teg_attr_9:ReadOnly = true.
      this-object:teg_attr_9:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_9:TabIndex = 12.
      /*  */
      /* teg_attr_10 */
      /*  */
      define variable nestedvar11 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar11 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_10:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar11, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:teg_attr_10:Location = new System.Drawing.Point(3, 253).
      this-object:teg_attr_10:Name = "teg_attr_10".
      this-object:teg_attr_10:ReadOnly = true.
      this-object:teg_attr_10:Size = new System.Drawing.Size(123, 20).
      this-object:teg_attr_10:TabIndex = 13.
      /*  */
      /* Val_ComBox_1 */
      /*  */
      define variable nestedvar12 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar12 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar12, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_1:FormattingEnabled = true.
      this-object:Val_ComBox_1:Location = new System.Drawing.Point(3, 10).
      this-object:Val_ComBox_1:Name = "Val_ComBox_1".
      this-object:Val_ComBox_1:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_1:TabIndex = 14.
      /*  */
      /* Val_ComBox_2 */
      /*  */
      define variable nestedvar13 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar13 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar13, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_2:FormattingEnabled = true.
      this-object:Val_ComBox_2:Location = new System.Drawing.Point(3, 37).
      this-object:Val_ComBox_2:Name = "Val_ComBox_2".
      this-object:Val_ComBox_2:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_2:TabIndex = 15.
      /*  */
      /* splitContainer1 */
      /*  */
      this-object:splitContainer1:Location = new System.Drawing.Point(13, 39).
      this-object:splitContainer1:Name = "splitContainer1".
      /*  */
      /* splitContainer1.Panel1 */
      /*  */
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_1).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_10).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_2).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_9).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_3).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_8).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_4).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_5).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_6).
      this-object:splitContainer1:Panel1:Controls:Add(this-object:teg_attr_7).
      /*  */
      /* splitContainer1.Panel2 */
      /*  */
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_10).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_9).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_8).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_7).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_6).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_5).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_4).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_3).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_2).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_delete_1).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_10).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_9).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_8).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_7).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_6).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_5).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_10).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_4).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_9).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_3).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_8).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_2).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_7).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:btn_choice_1).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_6).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_5).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_4).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_3).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_1).
      this-object:splitContainer1:Panel2:Controls:Add(this-object:Val_ComBox_2).
      this-object:splitContainer1:Size = new System.Drawing.Size(548, 283).
      this-object:splitContainer1:SplitterDistance = 129.
      this-object:splitContainer1:TabIndex = 16.
      /*  */
      /* btn_delete_10 */
      /*  */
      define variable nestedvar14 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar14 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_10:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar14, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_10:Image = cast(resources:GetObject("btn_delete_10.Image"), System.Drawing.Image).
      this-object:btn_delete_10:Location = new System.Drawing.Point(388, 252).
      this-object:btn_delete_10:Name = "btn_delete_10".
      this-object:btn_delete_10:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_10:TabIndex = 37.
      this-object:btn_delete_10:UseCompatibleTextRendering = true.
      this-object:btn_delete_10:UseVisualStyleBackColor = true.
      this-object:btn_delete_10:Click:Subscribe(this-object:btn_delete_10_Click).
      /*  */
      /* btn_delete_9 */
      /*  */
      define variable nestedvar15 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar15 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_9:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar15, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_9:Image = cast(resources:GetObject("btn_delete_9.Image"), System.Drawing.Image).
      this-object:btn_delete_9:Location = new System.Drawing.Point(388, 225).
      this-object:btn_delete_9:Name = "btn_delete_9".
      this-object:btn_delete_9:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_9:TabIndex = 36.
      this-object:btn_delete_9:UseCompatibleTextRendering = true.
      this-object:btn_delete_9:UseVisualStyleBackColor = true.
      this-object:btn_delete_9:Click:Subscribe(this-object:btn_delete_9_Click).
      /*  */
      /* btn_delete_8 */
      /*  */
      define variable nestedvar16 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar16 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_8:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar16, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_8:Image = cast(resources:GetObject("btn_delete_8.Image"), System.Drawing.Image).
      this-object:btn_delete_8:Location = new System.Drawing.Point(388, 198).
      this-object:btn_delete_8:Name = "btn_delete_8".
      this-object:btn_delete_8:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_8:TabIndex = 35.
      this-object:btn_delete_8:UseCompatibleTextRendering = true.
      this-object:btn_delete_8:UseVisualStyleBackColor = true.
      this-object:btn_delete_8:Click:Subscribe(this-object:btn_delete_8_Click).
      /*  */
      /* btn_delete_7 */
      /*  */
      define variable nestedvar17 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar17 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_7:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar17, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_7:Image = cast(resources:GetObject("btn_delete_7.Image"), System.Drawing.Image).
      this-object:btn_delete_7:Location = new System.Drawing.Point(388, 171).
      this-object:btn_delete_7:Name = "btn_delete_7".
      this-object:btn_delete_7:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_7:TabIndex = 34.
      this-object:btn_delete_7:UseCompatibleTextRendering = true.
      this-object:btn_delete_7:UseVisualStyleBackColor = true.
      this-object:btn_delete_7:Click:Subscribe(this-object:btn_delete_7_Click).
      /*  */
      /* btn_delete_6 */
      /*  */
      define variable nestedvar18 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar18 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_6:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar18, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_6:Image = cast(resources:GetObject("btn_delete_6.Image"), System.Drawing.Image).
      this-object:btn_delete_6:Location = new System.Drawing.Point(388, 144).
      this-object:btn_delete_6:Name = "btn_delete_6".
      this-object:btn_delete_6:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_6:TabIndex = 33.
      this-object:btn_delete_6:UseCompatibleTextRendering = true.
      this-object:btn_delete_6:UseVisualStyleBackColor = true.
      this-object:btn_delete_6:Click:Subscribe(this-object:btn_delete_6_Click).
      /*  */
      /* btn_delete_5 */
      /*  */
      define variable nestedvar19 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar19 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_5:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar19, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_5:Image = cast(resources:GetObject("btn_delete_5.Image"), System.Drawing.Image).
      this-object:btn_delete_5:Location = new System.Drawing.Point(388, 117).
      this-object:btn_delete_5:Name = "btn_delete_5".
      this-object:btn_delete_5:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_5:TabIndex = 32.
      this-object:btn_delete_5:UseCompatibleTextRendering = true.
      this-object:btn_delete_5:UseVisualStyleBackColor = true.
      this-object:btn_delete_5:Click:Subscribe(this-object:btn_delete_5_Click).
      /*  */
      /* btn_delete_4 */
      /*  */
      define variable nestedvar20 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar20 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_4:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar20, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_4:Image = cast(resources:GetObject("btn_delete_4.Image"), System.Drawing.Image).
      this-object:btn_delete_4:Location = new System.Drawing.Point(388, 90).
      this-object:btn_delete_4:Name = "btn_delete_4".
      this-object:btn_delete_4:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_4:TabIndex = 31.
      this-object:btn_delete_4:UseCompatibleTextRendering = true.
      this-object:btn_delete_4:UseVisualStyleBackColor = true.
      this-object:btn_delete_4:Click:Subscribe(this-object:btn_delete_4_Click).
      /*  */
      /* btn_delete_3 */
      /*  */
      define variable nestedvar21 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar21 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_3:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar21, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_3:Image = cast(resources:GetObject("btn_delete_3.Image"), System.Drawing.Image).
      this-object:btn_delete_3:Location = new System.Drawing.Point(388, 63).
      this-object:btn_delete_3:Name = "btn_delete_3".
      this-object:btn_delete_3:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_3:TabIndex = 30.
      this-object:btn_delete_3:UseCompatibleTextRendering = true.
      this-object:btn_delete_3:UseVisualStyleBackColor = true.
      this-object:btn_delete_3:Click:Subscribe(this-object:btn_delete_3_Click).
      /*  */
      /* btn_delete_2 */
      /*  */
      define variable nestedvar22 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar22 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar22, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_2:Image = cast(resources:GetObject("btn_delete_2.Image"), System.Drawing.Image).
      this-object:btn_delete_2:Location = new System.Drawing.Point(388, 36).
      this-object:btn_delete_2:Name = "btn_delete_2".
      this-object:btn_delete_2:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_2:TabIndex = 29.
      this-object:btn_delete_2:UseCompatibleTextRendering = true.
      this-object:btn_delete_2:UseVisualStyleBackColor = true.
      this-object:btn_delete_2:Click:Subscribe(this-object:btn_delete_2_Click).
      /*  */
      /* btn_delete_1 */
      /*  */
      define variable nestedvar23 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar23 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_delete_1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar23, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_delete_1:Image = cast(resources:GetObject("btn_delete_1.Image"), System.Drawing.Image).
      this-object:btn_delete_1:Location = new System.Drawing.Point(388, 9).
      this-object:btn_delete_1:Name = "btn_delete_1".
      this-object:btn_delete_1:Size = new System.Drawing.Size(23, 23).
      this-object:btn_delete_1:TabIndex = 17.
      this-object:btn_delete_1:UseCompatibleTextRendering = true.
      this-object:btn_delete_1:UseVisualStyleBackColor = true.
      this-object:btn_delete_1:Click:Subscribe(this-object:btn_delete_1_Click).
      /*  */
      /* btn_choice_10 */
      /*  */
      define variable nestedvar24 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar24 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_10:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar24, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_10:Image = cast(resources:GetObject("btn_choice_10.Image"), System.Drawing.Image).
      this-object:btn_choice_10:Location = new System.Drawing.Point(360, 252).
      this-object:btn_choice_10:Name = "btn_choice_10".
      this-object:btn_choice_10:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_10:TabIndex = 28.
      this-object:btn_choice_10:UseCompatibleTextRendering = true.
      this-object:btn_choice_10:UseVisualStyleBackColor = true.
      this-object:btn_choice_10:Click:Subscribe(this-object:btn_choice_10_Click).
      /*  */
      /* btn_choice_9 */
      /*  */
      define variable nestedvar25 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar25 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_9:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar25, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_9:Image = cast(resources:GetObject("btn_choice_9.Image"), System.Drawing.Image).
      this-object:btn_choice_9:Location = new System.Drawing.Point(360, 225).
      this-object:btn_choice_9:Name = "btn_choice_9".
      this-object:btn_choice_9:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_9:TabIndex = 27.
      this-object:btn_choice_9:UseCompatibleTextRendering = true.
      this-object:btn_choice_9:UseVisualStyleBackColor = true.
      this-object:btn_choice_9:Click:Subscribe(this-object:btn_choice_9_Click).
      /*  */
      /* btn_choice_8 */
      /*  */
      define variable nestedvar26 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar26 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_8:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar26, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_8:Image = cast(resources:GetObject("btn_choice_8.Image"), System.Drawing.Image).
      this-object:btn_choice_8:Location = new System.Drawing.Point(360, 198).
      this-object:btn_choice_8:Name = "btn_choice_8".
      this-object:btn_choice_8:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_8:TabIndex = 26.
      this-object:btn_choice_8:UseCompatibleTextRendering = true.
      this-object:btn_choice_8:UseVisualStyleBackColor = true.
      this-object:btn_choice_8:Click:Subscribe(this-object:btn_choice_8_Click).
      /*  */
      /* btn_choice_7 */
      /*  */
      define variable nestedvar27 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar27 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_7:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar27, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_7:Image = cast(resources:GetObject("btn_choice_7.Image"), System.Drawing.Image).
      this-object:btn_choice_7:Location = new System.Drawing.Point(360, 171).
      this-object:btn_choice_7:Name = "btn_choice_7".
      this-object:btn_choice_7:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_7:TabIndex = 25.
      this-object:btn_choice_7:UseCompatibleTextRendering = true.
      this-object:btn_choice_7:UseVisualStyleBackColor = true.
      this-object:btn_choice_7:Click:Subscribe(this-object:btn_choice_7_Click).
      /*  */
      /* btn_choice_6 */
      /*  */
      define variable nestedvar28 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar28 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_6:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar28, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_6:Image = cast(resources:GetObject("btn_choice_6.Image"), System.Drawing.Image).
      this-object:btn_choice_6:Location = new System.Drawing.Point(360, 144).
      this-object:btn_choice_6:Name = "btn_choice_6".
      this-object:btn_choice_6:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_6:TabIndex = 24.
      this-object:btn_choice_6:UseCompatibleTextRendering = true.
      this-object:btn_choice_6:UseVisualStyleBackColor = true.
      this-object:btn_choice_6:Click:Subscribe(this-object:btn_choice_6_Click).
      /*  */
      /* btn_choice_5 */
      /*  */
      define variable nestedvar29 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar29 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_5:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar29, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_5:Image = cast(resources:GetObject("btn_choice_5.Image"), System.Drawing.Image).
      this-object:btn_choice_5:Location = new System.Drawing.Point(360, 117).
      this-object:btn_choice_5:Name = "btn_choice_5".
      this-object:btn_choice_5:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_5:TabIndex = 21.
      this-object:btn_choice_5:UseCompatibleTextRendering = true.
      this-object:btn_choice_5:UseVisualStyleBackColor = true.
      this-object:btn_choice_5:Click:Subscribe(this-object:btn_choice_5_Click).
      /*  */
      /* Val_ComBox_10 */
      /*  */
      define variable nestedvar30 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar30 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_10:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar30, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_10:FormattingEnabled = true.
      this-object:Val_ComBox_10:Location = new System.Drawing.Point(3, 253).
      this-object:Val_ComBox_10:Name = "Val_ComBox_10".
      this-object:Val_ComBox_10:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_10:TabIndex = 23.
      /*  */
      /* btn_choice_4 */
      /*  */
      define variable nestedvar31 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar31 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_4:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar31, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_4:Image = cast(resources:GetObject("btn_choice_4.Image"), System.Drawing.Image).
      this-object:btn_choice_4:Location = new System.Drawing.Point(360, 90).
      this-object:btn_choice_4:Name = "btn_choice_4".
      this-object:btn_choice_4:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_4:TabIndex = 20.
      this-object:btn_choice_4:UseCompatibleTextRendering = true.
      this-object:btn_choice_4:UseVisualStyleBackColor = true.
      this-object:btn_choice_4:Click:Subscribe(this-object:btn_choice_4_Click).
      /*  */
      /* Val_ComBox_9 */
      /*  */
      define variable nestedvar32 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar32 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_9:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar32, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_9:FormattingEnabled = true.
      this-object:Val_ComBox_9:Location = new System.Drawing.Point(3, 226).
      this-object:Val_ComBox_9:Name = "Val_ComBox_9".
      this-object:Val_ComBox_9:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_9:TabIndex = 22.
      /*  */
      /* btn_choice_3 */
      /*  */
      define variable nestedvar33 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar33 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_3:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar33, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_3:Image = cast(resources:GetObject("btn_choice_3.Image"), System.Drawing.Image).
      this-object:btn_choice_3:Location = new System.Drawing.Point(360, 63).
      this-object:btn_choice_3:Name = "btn_choice_3".
      this-object:btn_choice_3:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_3:TabIndex = 19.
      this-object:btn_choice_3:UseCompatibleTextRendering = true.
      this-object:btn_choice_3:UseVisualStyleBackColor = true.
      this-object:btn_choice_3:Click:Subscribe(this-object:btn_choice_3_Click).
      /*  */
      /* Val_ComBox_8 */
      /*  */
      define variable nestedvar34 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar34 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_8:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar34, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_8:FormattingEnabled = true.
      this-object:Val_ComBox_8:Location = new System.Drawing.Point(3, 199).
      this-object:Val_ComBox_8:Name = "Val_ComBox_8".
      this-object:Val_ComBox_8:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_8:TabIndex = 21.
      /*  */
      /* btn_choice_2 */
      /*  */
      define variable nestedvar35 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar35 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_2:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar35, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_2:Image = cast(resources:GetObject("btn_choice_2.Image"), System.Drawing.Image).
      this-object:btn_choice_2:Location = new System.Drawing.Point(360, 36).
      this-object:btn_choice_2:Name = "btn_choice_2".
      this-object:btn_choice_2:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_2:TabIndex = 18.
      this-object:btn_choice_2:UseCompatibleTextRendering = true.
      this-object:btn_choice_2:UseVisualStyleBackColor = true.
      this-object:btn_choice_2:Click:Subscribe(this-object:btn_choice_2_Click).
      /*  */
      /* Val_ComBox_7 */
      /*  */
      define variable nestedvar36 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar36 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_7:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar36, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_7:FormattingEnabled = true.
      this-object:Val_ComBox_7:Location = new System.Drawing.Point(3, 172).
      this-object:Val_ComBox_7:Name = "Val_ComBox_7".
      this-object:Val_ComBox_7:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_7:TabIndex = 20.
      /*  */
      /* btn_choice_1 */
      /*  */
      define variable nestedvar37 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar37 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_choice_1:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar37, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_choice_1:Image = cast(resources:GetObject("btn_choice_1.Image"), System.Drawing.Image).
      this-object:btn_choice_1:Location = new System.Drawing.Point(360, 9).
      this-object:btn_choice_1:Name = "btn_choice_1".
      this-object:btn_choice_1:Size = new System.Drawing.Size(23, 23).
      this-object:btn_choice_1:TabIndex = 17.
      this-object:btn_choice_1:UseCompatibleTextRendering = true.
      this-object:btn_choice_1:UseVisualStyleBackColor = true.
      this-object:btn_choice_1:Click:Subscribe(this-object:btn_choice_1_Click).
      /*  */
      /* Val_ComBox_6 */
      /*  */
      define variable nestedvar38 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar38 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_6:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar38, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_6:FormattingEnabled = true.
      this-object:Val_ComBox_6:Location = new System.Drawing.Point(3, 145).
      this-object:Val_ComBox_6:Name = "Val_ComBox_6".
      this-object:Val_ComBox_6:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_6:TabIndex = 19.
      /*  */
      /* Val_ComBox_5 */
      /*  */
      define variable nestedvar39 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar39 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_5:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar39, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_5:FormattingEnabled = true.
      this-object:Val_ComBox_5:Location = new System.Drawing.Point(3, 118).
      this-object:Val_ComBox_5:Name = "Val_ComBox_5".
      this-object:Val_ComBox_5:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_5:TabIndex = 18.
      /*  */
      /* Val_ComBox_4 */
      /*  */
      define variable nestedvar40 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar40 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_4:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar40, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_4:FormattingEnabled = true.
      this-object:Val_ComBox_4:Location = new System.Drawing.Point(3, 91).
      this-object:Val_ComBox_4:Name = "Val_ComBox_4".
      this-object:Val_ComBox_4:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_4:TabIndex = 17.
      /*  */
      /* Val_ComBox_3 */
      /*  */
      define variable nestedvar41 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar41 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_3:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar41, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:Val_ComBox_3:FormattingEnabled = true.
      this-object:Val_ComBox_3:Location = new System.Drawing.Point(3, 64).
      this-object:Val_ComBox_3:Name = "Val_ComBox_3".
      this-object:Val_ComBox_3:Size = new System.Drawing.Size(351, 21).
      this-object:Val_ComBox_3:TabIndex = 16.
      /*  */
      /* btn_setup */
      /*  */
      define variable nestedvar42 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar42 = System.Windows.Forms.AnchorStyles:Top.
      this-object:btn_setup:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar42, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:btn_setup:Image = cast(resources:GetObject("btn_setup.Image"), System.Drawing.Image).
      this-object:btn_setup:Location = new System.Drawing.Point(521, 1).
      this-object:btn_setup:Name = "btn_setup".
      this-object:btn_setup:Size = new System.Drawing.Size(36, 35).
      this-object:btn_setup:TabIndex = 17.
      this-object:btn_setup:UseCompatibleTextRendering = true.
      this-object:btn_setup:UseVisualStyleBackColor = true.
      this-object:btn_setup:Click:Subscribe(this-object:btn_setup_Click).
      /*  */
      /* ThStart */
      /*  */
      this-object:AcceptButton = this-object:buttonOk.
      this-object:CancelButton = this-object:buttonCancel.
      this-object:ClientSize = new System.Drawing.Size(575, 377).
      this-object:Controls:Add(this-object:btn_setup).
      this-object:Controls:Add(this-object:splitContainer1).
      this-object:Controls:Add(this-object:labVer).
      this-object:Controls:Add(this-object:VerComBox).
      this-object:Controls:Add(this-object:buttonCancel).
      this-object:Controls:Add(this-object:buttonOk).
      this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
      this-object:MaximizeBox = false.
      this-object:MinimizeBox = false.
      this-object:Name = "ThStart".
      this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
      this-object:Text = "Создание bat файлов для запуска th".
      this-object:splitContainer1:Panel1:ResumeLayout(false).
      this-object:splitContainer1:Panel1:PerformLayout().
      this-object:splitContainer1:Panel2:ResumeLayout(false).
      cast(this-object:splitContainer1, System.ComponentModel.ISupportInitialize):EndInit().
      this-object:splitContainer1:ResumeLayout(false).
      this-object:ResumeLayout(false).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method. 
 
   method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

   end method.

   method public System.Windows.Forms.ComboBox GetValBox(iNom as integer):
      define variable VBox as System.Windows.Forms.ComboBox no-undo.
      case inom:
         when  1 then vbox = Val_ComBox_1.
         when  2 then vbox = Val_ComBox_2.
         when  3 then vbox = Val_ComBox_3.
         when  4 then vbox = Val_ComBox_4.
         when  5 then vbox = Val_ComBox_5.
         when  6 then vbox = Val_ComBox_6.
         when  7 then vbox = Val_ComBox_7.
         when  8 then vbox = Val_ComBox_8.
         when  9 then vbox = Val_ComBox_9.
         when 10 then vbox = Val_ComBox_10.
      end.
      return vbox.   
   end method.
 
   method public System.Windows.Forms.TextBox GetLableBox(iNom as integer):
      define variable VBox as System.Windows.Forms.TextBox no-undo.
      case inom:
         when  1 then vbox = teg_attr_1.
         when  2 then vbox = teg_attr_2.
         when  3 then vbox = teg_attr_3.
         when  4 then vbox = teg_attr_4.
         when  5 then vbox = teg_attr_5.
         when  6 then vbox = teg_attr_6.
         when  7 then vbox = teg_attr_7.
         when  8 then vbox = teg_attr_8.
         when  9 then vbox = teg_attr_9.
         when 10 then vbox = teg_attr_10.
      end.
      return vbox.   
   end method.
   
   method public void InitVal():
      define variable VValue as System.Windows.Forms.ComboBox no-undo.
      define variable VLabel as System.Windows.Forms.TextBox no-undo.
      define variable vi as integer no-undo.
      mtrg:SetVerComBox(VerComBox).
      do vi = 1 to 10:
         VValue = GetValBox(vi).
         mtrg:SetComBox(VValue, vi).
         VLabel = GetLableBox(vi).
         VLabel:Text = mtrg:GetLabelComBox(vi). 
      end.
   end method.
   
   method public void BtnChoice(inom as int):
      define variable VValue as System.Windows.Forms.ComboBox no-undo.
      define variable VLabel as System.Windows.Forms.TextBox no-undo.
      define variable vi as integer no-undo.
      mtrg:ChoiceParam(VerComBox:Text, inom).
      VValue = GetValBox(inom).
      mtrg:SetComBox(VValue, inom).
      VLabel = GetLableBox(inom).
      VLabel:Text = mtrg:GetLabelComBox(inom). 
      
   end method.
   
   method public void BtnDelHot(inom as int):
      define variable VValue as System.Windows.Forms.ComboBox no-undo.
      define variable VLabel as System.Windows.Forms.TextBox no-undo.
      define variable vi as integer no-undo.
      mtrg:delHotParam(inom).
      VValue = GetValBox(inom).
      VValue:text = "".
      mtrg:SetComBox(VValue, inom).
      VLabel = GetLableBox(inom).
      VLabel:Text = mtrg:GetLabelComBox(inom). 
      
   end method.
   
end class.
