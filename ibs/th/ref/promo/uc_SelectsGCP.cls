 
 /*------------------------------------------------------------------------
    File        : uc_SelectsGCP
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mshavlov
    Created     : Tue Jul 31 13:16:49 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Windows.UserControl.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ibs.th.ref.promo.uc_SelectsGCP INHERITS UserControl: 
    
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE uc_Present1 AS ibs.th.ref.promo.uc_Presents NO-UNDO.
    DEFINE PRIVATE VARIABLE uc_Goods1 AS ibs.th.ref.promo.uc_Goods NO-UNDO.
    DEFINE PRIVATE VARIABLE uc_Conditions1 AS ibs.th.ref.promo.uc_Conditions NO-UNDO.

        
    CONSTRUCTOR PUBLIC uc_SelectsGCP (  ):
        
        
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
        THIS-OBJECT:uc_Goods1 = NEW ibs.th.ref.promo.uc_Goods().
        THIS-OBJECT:uc_Conditions1 = NEW ibs.th.ref.promo.uc_Conditions().
        THIS-OBJECT:uc_Present1 = NEW ibs.th.ref.promo.uc_Presents().
        THIS-OBJECT:tableLayoutPanel1:SuspendLayout().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        THIS-OBJECT:tableLayoutPanel1:ColumnCount = 3.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle()).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle()).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle()).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:uc_Goods1, 0, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:uc_Conditions1, 1, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:uc_Present1, 2, 0).
        THIS-OBJECT:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:tableLayoutPanel1:Name = "tableLayoutPanel1".
        THIS-OBJECT:tableLayoutPanel1:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:Size = NEW System.Drawing.Size(906, 345).
        THIS-OBJECT:tableLayoutPanel1:TabIndex = 0.
        /*  */
        /* uc_Goods1 */
        /*  */
        THIS-OBJECT:uc_Goods1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:uc_Goods1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:uc_Goods1:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:uc_Goods1:Name = "uc_Goods1".
        THIS-OBJECT:uc_Goods1:Size = NEW System.Drawing.Size(301, 345).
        THIS-OBJECT:uc_Goods1:TabIndex = 0.
        /*  */
        /* uc_Conditions1 */
        /*  */
        THIS-OBJECT:uc_Conditions1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:uc_Conditions1:Location = NEW System.Drawing.Point(301, 0).
        THIS-OBJECT:uc_Conditions1:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:uc_Conditions1:Name = "uc_Conditions1".
        THIS-OBJECT:uc_Conditions1:Size = NEW System.Drawing.Size(301, 345).
        THIS-OBJECT:uc_Conditions1:TabIndex = 1.
        /*  */
        /* uc_Present1 */
        /*  */
        THIS-OBJECT:uc_Present1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:uc_Present1:Location = NEW System.Drawing.Point(602, 0).
        THIS-OBJECT:uc_Present1:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:uc_Present1:Name = "uc_Present1".
        THIS-OBJECT:uc_Present1:Size = NEW System.Drawing.Size(304, 345).
        THIS-OBJECT:uc_Present1:TabIndex = 2.
        /*  */
        /* uc_SelectsGCP */
        /*  */
        THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel1).
        THIS-OBJECT:Name = "uc_SelectsGCP".
        THIS-OBJECT:Size = NEW System.Drawing.Size(906, 345).
        THIS-OBJECT:tableLayoutPanel1:ResumeLayout(false).
        THIS-OBJECT:ResumeLayout(false).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END METHOD.

    DESTRUCTOR PUBLIC uc_SelectsGCP ( ):

    END DESTRUCTOR.
    
    
    METHOD PUBLIC VOID INIT_TableLayoutPanel(INPUT IsGoods as LOGICAL, INPUT IsConditions as LOGICAL, INPUT IsPresents as LOGICAL):
        
        uc_Goods1:Visible = IsGoods.
        uc_Present1:Visible = IsPresents.
        uc_Conditions1:Visible = IsConditions.
        

        IF IsGoods and IsConditions and not IsPresents THEN 
        DO:
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[0]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[1]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[2]:Width = 0.
        END.        
        IF IsConditions and IsPresents and not IsGoods THEN
        DO:
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[1]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[2]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[0]:Width = 0.
        END.
              
        IF IsPresents and IsGoods and not IsConditions THEN
        DO:
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[2]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[0]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[1]:Width = 0.
        END.
         
        
        IF IsGoods and not IsConditions and not IsPresents THEN 
        DO:
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[0]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[1]:Width = 0.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[2]:Width = 0.
        END.        
        IF IsConditions and not IsPresents and not IsGoods THEN
        DO:
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[1]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[2]:Width = 0.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[0]:Width = 0.
        END.
              
        IF IsPresents and not IsGoods and not IsConditions THEN
        DO:
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[2]= NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100)).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[0]:Width = 0.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles[1]:Width = 0.
        END.
              
    END METHOD.


END CLASS.