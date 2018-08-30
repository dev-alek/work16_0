 
 /*------------------------------------------------------------------------
    File        : uc_Tab_Presents
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mshavlov
    Created     : Fri Jul 27 17:32:04 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Windows.UserControl.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ibs.th.ref.promo.uc_Tab_Presents INHERITS UserControl: 
    
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE panel_SelectConditionItems AS System.Windows.Forms.Panel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton2 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton1 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE textBox1 AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE ucSelect_Present1 AS ibs.th.ref.promo.ucSelect_Present NO-UNDO.

        
    CONSTRUCTOR PUBLIC uc_Tab_Presents (  ):
        
        
        SUPER().
        InitializeComponent().
        THIS-OBJECT:ComponentsCollection:ADD(THIS-OBJECT:components).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.

    END CONSTRUCTOR.

    METHOD PRIVATE VOID InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        THIS-OBJECT:tableLayoutPanel1 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:panel_SelectConditionItems = NEW System.Windows.Forms.Panel().
        THIS-OBJECT:ucSelect_Present1 = NEW ibs.th.ref.promo.ucSelect_Present().
        THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:tableLayoutPanel2 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:radioButton2 = NEW System.Windows.Forms.RadioButton().
        THIS-OBJECT:radioButton1 = NEW System.Windows.Forms.RadioButton().
        THIS-OBJECT:textBox1 = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:tableLayoutPanel1:SuspendLayout().
        THIS-OBJECT:panel_SelectConditionItems:SuspendLayout().
        THIS-OBJECT:tableLayoutPanel2:SuspendLayout().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        THIS-OBJECT:tableLayoutPanel1:ColumnCount = 1.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:panel_SelectConditionItems, 0, 2).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label1, 0, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:tableLayoutPanel2, 0, 1).
        THIS-OBJECT:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:tableLayoutPanel1:Name = "tableLayoutPanel1".
        THIS-OBJECT:tableLayoutPanel1:RowCount = 3.
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:Size = NEW System.Drawing.Size(593, 483).
        THIS-OBJECT:tableLayoutPanel1:TabIndex = 0.
        /*  */
        /* panel_SelectConditionItems */
        /*  */
        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(THIS-OBJECT:ucSelect_Present1).
        THIS-OBJECT:panel_SelectConditionItems:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:panel_SelectConditionItems:Location = NEW System.Drawing.Point(0, 60).
        THIS-OBJECT:panel_SelectConditionItems:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:panel_SelectConditionItems:Name = "panel_SelectConditionItems".
        THIS-OBJECT:panel_SelectConditionItems:Size = NEW System.Drawing.Size(593, 423).
        THIS-OBJECT:panel_SelectConditionItems:TabIndex = 4.
        /*  */
        /* ucSelect_Present1 */
        /*  */
        THIS-OBJECT:ucSelect_Present1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:ucSelect_Present1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:ucSelect_Present1:Name = "ucSelect_Present1".
        THIS-OBJECT:ucSelect_Present1:Size = NEW System.Drawing.Size(593, 423).
        THIS-OBJECT:ucSelect_Present1:TabIndex = 0.
        /*  */
        /* label1 */
        /*  */
        THIS-OBJECT:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label1:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        THIS-OBJECT:label1:Location = NEW System.Drawing.Point(3, 3).
        THIS-OBJECT:label1:Margin = NEW System.Windows.Forms.Padding(3).
        THIS-OBJECT:label1:Name = "label1".
        THIS-OBJECT:label1:Size = NEW System.Drawing.Size(587, 24).
        THIS-OBJECT:label1:TabIndex = 1.
        THIS-OBJECT:label1:Text = "Выбор подарков".
        THIS-OBJECT:label1:UseCompatibleTextRendering = true.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        THIS-OBJECT:tableLayoutPanel2:ColumnCount = 3.
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(140))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(140))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:radioButton2, 1, 0).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:radioButton1, 0, 0).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:textBox1, 2, 0).
        THIS-OBJECT:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel2:Location = NEW System.Drawing.Point(0, 30).
        THIS-OBJECT:tableLayoutPanel2:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:tableLayoutPanel2:Name = "tableLayoutPanel2".
        THIS-OBJECT:tableLayoutPanel2:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel2:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Size = NEW System.Drawing.Size(593, 30).
        THIS-OBJECT:tableLayoutPanel2:TabIndex = 2.
        /*  */
        /* radioButton2 */
        /*  */
        THIS-OBJECT:radioButton2:Appearance = System.Windows.Forms.Appearance:Button.
        THIS-OBJECT:radioButton2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:radioButton2:Location = NEW System.Drawing.Point(143, 3).
        THIS-OBJECT:radioButton2:Name = "radioButton2".
        THIS-OBJECT:radioButton2:Size = NEW System.Drawing.Size(134, 24).
        THIS-OBJECT:radioButton2:TabIndex = 1.
        THIS-OBJECT:radioButton2:Text = "Сложные".
        THIS-OBJECT:radioButton2:UseCompatibleTextRendering = true.
        THIS-OBJECT:radioButton2:UseVisualStyleBackColor = true.
        /*  */
        /* radioButton1 */
        /*  */
        THIS-OBJECT:radioButton1:Appearance = System.Windows.Forms.Appearance:Button.
        THIS-OBJECT:radioButton1:Checked = true.
        THIS-OBJECT:radioButton1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:radioButton1:ForeColor = System.Drawing.Color:Green.
        THIS-OBJECT:radioButton1:Location = NEW System.Drawing.Point(3, 3).
        THIS-OBJECT:radioButton1:Name = "radioButton1".
        THIS-OBJECT:radioButton1:Size = NEW System.Drawing.Size(134, 24).
        THIS-OBJECT:radioButton1:TabIndex = 0.
        THIS-OBJECT:radioButton1:TabStop = true.
        THIS-OBJECT:radioButton1:Text = "Порстые ".
        THIS-OBJECT:radioButton1:UseCompatibleTextRendering = true.
        THIS-OBJECT:radioButton1:UseVisualStyleBackColor = true.
        THIS-OBJECT:radioButton1:CheckedChanged:Subscribe(THIS-OBJECT:radioButton1_CheckedChanged).
        /*  */
        /* textBox1 */
        /*  */
        THIS-OBJECT:textBox1:Location = NEW System.Drawing.Point(283, 3).
        THIS-OBJECT:textBox1:Name = "textBox1".
        THIS-OBJECT:textBox1:Size = NEW System.Drawing.Size(100, 20).
        THIS-OBJECT:textBox1:TabIndex = 2.
        THIS-OBJECT:textBox1:Visible = false.
        /*  */
        /* uc_Tab_Presents */
        /*  */
        THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel1).
        THIS-OBJECT:Name = "uc_Tab_Presents".
        THIS-OBJECT:Size = NEW System.Drawing.Size(593, 483).
        THIS-OBJECT:tableLayoutPanel1:ResumeLayout(false).
        THIS-OBJECT:panel_SelectConditionItems:ResumeLayout(false).
        THIS-OBJECT:tableLayoutPanel2:ResumeLayout(false).
        THIS-OBJECT:tableLayoutPanel2:PerformLayout().
        THIS-OBJECT:ResumeLayout(false).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END METHOD.


	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID radioButton1_CheckedChanged( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		THIS-OBJECT:panel_SelectConditionItems:Controls:Clear().
        if radioButton1:Checked then do:
           radioButton1:ForeColor  = System.Drawing.Color:Green.
           radioButton2:ForeColor  = System.Drawing.Color:Black.
           Show_Panet_SelectConditonItem(1).
        end.
        else do:
           radioButton1:ForeColor  = System.Drawing.Color:Black.
           radioButton2:ForeColor  = System.Drawing.Color:Green.
           Show_Panet_SelectConditonItem(2).
        end.
		RETURN.

	END METHOD.
	
	DEFINE VARIABLE ucMain7_1   AS ibs.th.ref.promo.ucSelect_Items7_1   NO-UNDO.
	
	
	METHOD PRIVATE VOID Show_Panet_SelectConditonItem( INPUT SelectItem AS int):
	    CASE SelectItem:
	    	    WHEN 1 then do:
	                ucSelect_Present1 = NEW ibs.th.ref.promo.ucSelect_Present().
                    ucSelect_Present1:Dock = System.Windows.Forms.DockStyle:Fill.
                    THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucSelect_Present1).
                END.
                
                WHEN 2 then do:
                        ucMain7_1 = NEW ibs.th.ref.promo.ucSelect_Items7_1().
                        
                        ucMain7_1:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain7_1).
                END.
                
         END.
	   RETURN.

    END METHOD.


    DESTRUCTOR PUBLIC uc_Tab_Presents ( ):

    END DESTRUCTOR.

END CLASS.