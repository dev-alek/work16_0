/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
  
"Просмотр/редактирование одной акции"

Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: 
Creation date: 11/07/18

*/
USING Progress.Lang.*.
USING Progress.Windows.UserControl.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ibs.th.ref.promo.uc_TabPromoAction INHERITS UserControl: 
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Просмотр/редактирование одной акции". 
  /* --- end_of для cmp/vssrevis.i --- */
    
    define private variable bindPromoActionOne as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE comboBox3 AS System.Windows.Forms.ComboBox NO-UNDO.
    DEFINE PRIVATE VARIABLE comboBox1 AS System.Windows.Forms.ComboBox NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox1 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel7 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel6 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel20 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel10 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton2 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton1 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE panel_SelectConditionItems AS System.Windows.Forms.Panel NO-UNDO.
    DEFINE PRIVATE VARIABLE label6 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label5 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label2 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.

//DEFINE PUBLIC VARIABLE tabPage6 AS System.Windows.Forms.TabPage NO-UNDO.
//define PUBLIC variable tabControl1 as System.Windows.Forms.TabControl no-undo.
    define private variable m-promo-type as class ibs.th.ref.promo.promoType no-undo.
    {ibs/th/ref/promo/promoType.def ttMethodCalc}
    {ibs/th/ref/promo/promoType.def ttTypeCond}  
    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.
    
    

    method Public VOID SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
        
    end.
    
    method Public VOID SetBind( ):
        bindPromoActionOne:handle = m-promo-trg:getQuery("promoActionOne2").
    end.
        
    CONSTRUCTOR PUBLIC uc_TabPromoAction (  ):
        SUPER().
        InitializeComponent().
        m-promo-type = new ibs.th.ref.promo.promoType().
        
        Init_comboBox1(TRUE).
        Init_comboBox3(TRUE,1).
        THIS-OBJECT:ComponentsCollection:ADD(THIS-OBJECT:components).
        
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.

    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC uc_TabPromoAction ( ):
        if valid-object(m-promo-trg) then closeBind().
    END DESTRUCTOR.
    
    method private void closeBind():
       bindPromoActionOne:Assign().
       bindPromoActionOne:Dispose().
    end.

    METHOD PUBLIC VOID Enabled_Controls(INPUT sender AS LOGICAL):
        panel_SelectConditionItems:Enabled = sender.
        tableLayoutPanel6:Enabled = sender.
        label6:Enabled = sender.
        comboBox3:Enabled = sender.
    END METHOD. 
    
    
   /* METHOD PUBLIC VOID Set_TabControl( INPUT sender AS System.Windows.Forms.TabControl):
        tabControl1 = sender.
        tabPage6 = tabControl1:TabPages[5]. 
    END METHOD.*/
            
            

    METHOD PRIVATE VOID Init_comboBox1(INPUT sender AS LOGICAL):
        comboBox1:Items:Clear().
        m-promo-type:CangeTypeDiscont(if sender then 1 else 0).
        m-promo-type:typeTable("methodCalc", output table ttMethodCalc).
        for each ttMethodCalc:
            comboBox1:Items:Add(ttMethodCalc.item).
        end.    
        IF sender THEN 
        DO:
            label5:Visible = TRUE.
            label6:Visible = TRUE.
            checkBox1:Visible = TRUE.
            comboBox3:Visible = TRUE. 
        END.
        ELSE
        DO:
            
            label6:Visible = FALSE.
            comboBox3:Visible = FALSE. 
        END.
	END METHOD. 
	
	METHOD PRIVATE VOID Init_comboBox_nUMBER(INPUT sender AS INTEGER):
	       IF radioButton1:Checked THEN
	       DO:
	           label5:Visible = TRUE.
               label6:Visible = TRUE.
               checkBox1:Visible = TRUE.
               comboBox3:Visible = TRUE.
           END.   
         IF comboBox3:Items:Count > 0 THEN 
         DO:
             comboBox3:SelectedIndex = 0.
         END.
        IF sender = 3  THEN 
        DO:
            label5:Visible = FALSE.
            label6:Visible = FALSE.
            checkBox1:Visible = FALSE.
            comboBox3:Visible = FALSE.          
        END.
        IF sender = 4  THEN 
        DO:
            label5:Visible = FALSE.
            label6:Visible = FALSE.
            checkBox1:Visible = FALSE.
            comboBox3:Visible = FALSE.    
        END.    
    END METHOD. 
	
	METHOD PRIVATE VOID Init_comboBox3(INPUT itypeDiscont AS LOGICAL,input iMethodCalc as integer ):
        comboBox3:Items:Clear().
        label5:Text = "Независимые условия:".
        m-promo-type:CangeTypeDiscontAndMethodCalc(if itypeDiscont then 1 else 0,iMethodCalc).
        m-promo-type:typeTable("typecond", output table tttypecond).
        for each tttypecond:
            comboBox3:Items:Add(tttypecond.item).
        end.    
        
    END METHOD.

    METHOD PRIVATE VOID InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        THIS-OBJECT:components = NEW System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc1 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc1 = NEW Progress.Data.TableDesc("tt-promoaction-one").
        THIS-OBJECT:tableLayoutPanel1 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:tableLayoutPanel20 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:tableLayoutPanel7 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:checkBox1 = NEW System.Windows.Forms.CheckBox().
        THIS-OBJECT:label5 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:label6 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:comboBox3 = NEW System.Windows.Forms.ComboBox().
        THIS-OBJECT:bindPromoActionOne = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:tableLayoutPanel6 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:label2 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:tableLayoutPanel10 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:radioButton1 = NEW System.Windows.Forms.RadioButton().
        THIS-OBJECT:radioButton2 = NEW System.Windows.Forms.RadioButton().
        THIS-OBJECT:comboBox1 = NEW System.Windows.Forms.ComboBox().
        THIS-OBJECT:panel_SelectConditionItems = NEW System.Windows.Forms.Panel().
        THIS-OBJECT:tableLayoutPanel1:SuspendLayout().
        THIS-OBJECT:tableLayoutPanel20:SuspendLayout().
        THIS-OBJECT:tableLayoutPanel7:SuspendLayout().
        CAST(THIS-OBJECT:bindPromoActionOne, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:tableLayoutPanel6:SuspendLayout().
        THIS-OBJECT:tableLayoutPanel10:SuspendLayout().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        THIS-OBJECT:tableLayoutPanel1:ColumnCount = 1.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:tableLayoutPanel20, 0, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:panel_SelectConditionItems, 0, 2).
        THIS-OBJECT:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:tableLayoutPanel1:Name = "tableLayoutPanel1".
        THIS-OBJECT:tableLayoutPanel1:RowCount = 3.
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(65))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(7))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:Size = NEW System.Drawing.Size(901, 263).
        THIS-OBJECT:tableLayoutPanel1:TabIndex = 1.
        /*  */
        /* tableLayoutPanel20 */
        /*  */
        THIS-OBJECT:tableLayoutPanel20:ColumnCount = 2.
        THIS-OBJECT:tableLayoutPanel20:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel20:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel20:Controls:Add(THIS-OBJECT:tableLayoutPanel7, 1, 0).
        THIS-OBJECT:tableLayoutPanel20:Controls:Add(THIS-OBJECT:tableLayoutPanel6, 0, 0).
        THIS-OBJECT:tableLayoutPanel20:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel20:Location = NEW System.Drawing.Point(3, 3).
        THIS-OBJECT:tableLayoutPanel20:Name = "tableLayoutPanel20".
        THIS-OBJECT:tableLayoutPanel20:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel20:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel20:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel20:Size = NEW System.Drawing.Size(895, 59).
        THIS-OBJECT:tableLayoutPanel20:TabIndex = 2.
        /*  */
        /* tableLayoutPanel7 */
        /*  */
        THIS-OBJECT:tableLayoutPanel7:ColumnCount = 2.
        THIS-OBJECT:tableLayoutPanel7:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
        THIS-OBJECT:tableLayoutPanel7:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel7:Controls:Add(THIS-OBJECT:checkBox1, 1, 0).
        THIS-OBJECT:tableLayoutPanel7:Controls:Add(THIS-OBJECT:label5, 0, 0).
        THIS-OBJECT:tableLayoutPanel7:Controls:Add(THIS-OBJECT:label6, 0, 1).
        THIS-OBJECT:tableLayoutPanel7:Controls:Add(THIS-OBJECT:comboBox3, 1, 1).
        THIS-OBJECT:tableLayoutPanel7:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel7:Location = NEW System.Drawing.Point(447, 0).
        THIS-OBJECT:tableLayoutPanel7:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:tableLayoutPanel7:Name = "tableLayoutPanel7".
        THIS-OBJECT:tableLayoutPanel7:RowCount = 2.
        THIS-OBJECT:tableLayoutPanel7:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel7:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel7:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
        THIS-OBJECT:tableLayoutPanel7:Size = NEW System.Drawing.Size(448, 59).
        THIS-OBJECT:tableLayoutPanel7:TabIndex = 1.
        /*  */
        /* checkBox1 */
        /*  */
        THIS-OBJECT:checkBox1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:checkBox1:Location = NEW System.Drawing.Point(153, 3).
        THIS-OBJECT:checkBox1:Name = "checkBox1".
        THIS-OBJECT:checkBox1:Size = NEW System.Drawing.Size(292, 24).
        THIS-OBJECT:checkBox1:TabIndex = 8.
        THIS-OBJECT:checkBox1:Text = "Выбрать номенклатуру...".
        THIS-OBJECT:checkBox1:UseCompatibleTextRendering = true.
        THIS-OBJECT:checkBox1:UseVisualStyleBackColor = true.
        THIS-OBJECT:checkBox1:Click:Subscribe(THIS-OBJECT:checkBox1_Click).
        /*  */
        /* label5 */
        /*  */
        THIS-OBJECT:label5:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label5:Location = NEW System.Drawing.Point(3, 3).
        THIS-OBJECT:label5:Margin = NEW System.Windows.Forms.Padding(3).
        THIS-OBJECT:label5:Name = "label5".
        THIS-OBJECT:label5:Size = NEW System.Drawing.Size(144, 24).
        THIS-OBJECT:label5:TabIndex = 4.
        THIS-OBJECT:label5:Text = "Независимые условия:".
        THIS-OBJECT:label5:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label5:UseCompatibleTextRendering = true.
        /*  */
        /* label6 */
        /*  */
        THIS-OBJECT:label6:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label6:Location = NEW System.Drawing.Point(3, 33).
        THIS-OBJECT:label6:Margin = NEW System.Windows.Forms.Padding(3).
        THIS-OBJECT:label6:Name = "label6".
        THIS-OBJECT:label6:Size = NEW System.Drawing.Size(144, 24).
        THIS-OBJECT:label6:TabIndex = 5.
        THIS-OBJECT:label6:Text = "Вид условия:".
        THIS-OBJECT:label6:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label6:UseCompatibleTextRendering = true.
        /*  */
        /* comboBox3 */
        /*  */
        THIS-OBJECT:comboBox3:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bindPromoActionOne, "typecondlbl", true)).
        THIS-OBJECT:comboBox3:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:comboBox3:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
        THIS-OBJECT:comboBox3:FormattingEnabled = true.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar0 AS System.Object EXTENT 3 NO-UNDO.
        arrayvar0[1] = "Количество по строке".
        arrayvar0[2] = "Сумма по строке".
        arrayvar0[3] = "Итог чека".
        THIS-OBJECT:comboBox3:Items:AddRange(arrayvar0).
        THIS-OBJECT:comboBox3:Location = NEW System.Drawing.Point(153, 33).
        THIS-OBJECT:comboBox3:Name = "comboBox3".
        THIS-OBJECT:comboBox3:Size = NEW System.Drawing.Size(292, 21).
        THIS-OBJECT:comboBox3:TabIndex = 7.
        THIS-OBJECT:comboBox3:SelectedIndexChanged:Subscribe(THIS-OBJECT:comboBox3_SelectedIndexChanged).
        /*  */
        /* bindPromoActionOne */
        /*  */
        THIS-OBJECT:bindPromoActionOne:MaxDataGuess = 0.
        THIS-OBJECT:bindPromoActionOne:NoLOBs = false.
        THIS-OBJECT:bindPromoActionOne:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar1 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar1 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar2 AS Progress.Data.ColumnPropDesc EXTENT 3 NO-UNDO.
        arrayvar2[1] = NEW Progress.Data.ColumnPropDesc("TypeDiscontlog", "", Progress.Data.DataType:LOGICAL).
        arrayvar2[2] = NEW Progress.Data.ColumnPropDesc("methodCalclbl", "", Progress.Data.DataType:CHARACTER).
        arrayvar2[3] = NEW Progress.Data.ColumnPropDesc("typecondlbl", "", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar2.
        THIS-OBJECT:bindPromoActionOne:TableSchema = tableDesc1.
        /*  */
        /* tableLayoutPanel6 */
        /*  */
        THIS-OBJECT:tableLayoutPanel6:ColumnCount = 2.
        THIS-OBJECT:tableLayoutPanel6:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
        THIS-OBJECT:tableLayoutPanel6:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel6:Controls:Add(THIS-OBJECT:label1, 0, 0).
        THIS-OBJECT:tableLayoutPanel6:Controls:Add(THIS-OBJECT:label2, 0, 1).
        THIS-OBJECT:tableLayoutPanel6:Controls:Add(THIS-OBJECT:tableLayoutPanel10, 1, 0).
        THIS-OBJECT:tableLayoutPanel6:Controls:Add(THIS-OBJECT:comboBox1, 1, 1).
        THIS-OBJECT:tableLayoutPanel6:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel6:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:tableLayoutPanel6:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:tableLayoutPanel6:Name = "tableLayoutPanel6".
        THIS-OBJECT:tableLayoutPanel6:RowCount = 2.
        THIS-OBJECT:tableLayoutPanel6:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel6:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel6:Size = NEW System.Drawing.Size(447, 59).
        THIS-OBJECT:tableLayoutPanel6:TabIndex = 0.
        /*  */
        /* label1 */
        /*  */
        THIS-OBJECT:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label1:Location = NEW System.Drawing.Point(3, 3).
        THIS-OBJECT:label1:Margin = NEW System.Windows.Forms.Padding(3).
        THIS-OBJECT:label1:Name = "label1".
        THIS-OBJECT:label1:Size = NEW System.Drawing.Size(144, 24).
        THIS-OBJECT:label1:TabIndex = 0.
        THIS-OBJECT:label1:Text = "Вид скидки".
        THIS-OBJECT:label1:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label1:UseCompatibleTextRendering = true.
        /*  */
        /* label2 */
        /*  */
        THIS-OBJECT:label2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label2:Location = NEW System.Drawing.Point(3, 33).
        THIS-OBJECT:label2:Margin = NEW System.Windows.Forms.Padding(3).
        THIS-OBJECT:label2:Name = "label2".
        THIS-OBJECT:label2:Size = NEW System.Drawing.Size(144, 24).
        THIS-OBJECT:label2:TabIndex = 1.
        THIS-OBJECT:label2:Text = "Способ расчета".
        THIS-OBJECT:label2:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label2:UseCompatibleTextRendering = true.
        /*  */
        /* tableLayoutPanel10 */
        /*  */
        THIS-OBJECT:tableLayoutPanel10:ColumnCount = 2.
        THIS-OBJECT:tableLayoutPanel10:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel10:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel10:Controls:Add(THIS-OBJECT:radioButton1, 0, 0).
        THIS-OBJECT:tableLayoutPanel10:Controls:Add(THIS-OBJECT:radioButton2, 1, 0).
        THIS-OBJECT:tableLayoutPanel10:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel10:Location = NEW System.Drawing.Point(153, 3).
        THIS-OBJECT:tableLayoutPanel10:Name = "tableLayoutPanel10".
        THIS-OBJECT:tableLayoutPanel10:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel10:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel10:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        THIS-OBJECT:tableLayoutPanel10:Size = NEW System.Drawing.Size(291, 24).
        THIS-OBJECT:tableLayoutPanel10:TabIndex = 4.
        /*  */
        /* radioButton1 */
        /*  */
        THIS-OBJECT:radioButton1:Appearance = System.Windows.Forms.Appearance:Button.
        THIS-OBJECT:radioButton1:Checked = true.
        THIS-OBJECT:radioButton1:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindPromoActionOne, "TypeDiscontlog", true)).
        THIS-OBJECT:radioButton1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:radioButton1:ForeColor = System.Drawing.Color:Green.
        THIS-OBJECT:radioButton1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:radioButton1:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:radioButton1:Name = "radioButton1".
        THIS-OBJECT:radioButton1:Size = NEW System.Drawing.Size(145, 24).
        THIS-OBJECT:radioButton1:TabIndex = 0.
        THIS-OBJECT:radioButton1:TabStop = true.
        THIS-OBJECT:radioButton1:Text = "Временная скидка".
        THIS-OBJECT:radioButton1:UseCompatibleTextRendering = true.
        THIS-OBJECT:radioButton1:UseVisualStyleBackColor = true.
        THIS-OBJECT:radioButton1:CheckedChanged:Subscribe(THIS-OBJECT:radioButton1_CheckedChanged).
        /*  */
        /* radioButton2 */
        /*  */
        THIS-OBJECT:radioButton2:Appearance = System.Windows.Forms.Appearance:Button.
        THIS-OBJECT:radioButton2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:radioButton2:Location = NEW System.Drawing.Point(145, 0).
        THIS-OBJECT:radioButton2:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:radioButton2:Name = "radioButton2".
        THIS-OBJECT:radioButton2:Size = NEW System.Drawing.Size(146, 24).
        THIS-OBJECT:radioButton2:TabIndex = 1.
        THIS-OBJECT:radioButton2:Text = "Промо-набор".
        THIS-OBJECT:radioButton2:UseCompatibleTextRendering = true.
        THIS-OBJECT:radioButton2:UseVisualStyleBackColor = true.
        /*  */
        /* comboBox1 */
        /*  */
        THIS-OBJECT:comboBox1:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bindPromoActionOne, "methodCalclbl", true)).
        THIS-OBJECT:comboBox1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:comboBox1:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
        THIS-OBJECT:comboBox1:FormattingEnabled = true.
        THIS-OBJECT:comboBox1:Location = NEW System.Drawing.Point(153, 33).
        THIS-OBJECT:comboBox1:Name = "comboBox1".
        THIS-OBJECT:comboBox1:Size = NEW System.Drawing.Size(291, 21).
        THIS-OBJECT:comboBox1:TabIndex = 5.
        THIS-OBJECT:comboBox1:SelectedIndexChanged:Subscribe(THIS-OBJECT:comboBox1_SelectedIndexChanged).
        /*  */
        /* panel_SelectConditionItems */
        /*  */
        THIS-OBJECT:panel_SelectConditionItems:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:panel_SelectConditionItems:Location = NEW System.Drawing.Point(0, 72).
        THIS-OBJECT:panel_SelectConditionItems:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:panel_SelectConditionItems:Name = "panel_SelectConditionItems".
        THIS-OBJECT:panel_SelectConditionItems:Size = NEW System.Drawing.Size(901, 191).
        THIS-OBJECT:panel_SelectConditionItems:TabIndex = 3.
        /*  */
        /* uc_TabPromoAction */
        /*  */
        THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel1).
        THIS-OBJECT:Name = "uc_TabPromoAction".
        THIS-OBJECT:Size = NEW System.Drawing.Size(901, 263).
        THIS-OBJECT:tableLayoutPanel1:ResumeLayout(false).
        THIS-OBJECT:tableLayoutPanel20:ResumeLayout(false).
        THIS-OBJECT:tableLayoutPanel7:ResumeLayout(false).
        CAST(THIS-OBJECT:bindPromoActionOne, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:tableLayoutPanel6:ResumeLayout(false).
        THIS-OBJECT:tableLayoutPanel10:ResumeLayout(false).
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
	    Init_comboBox_nUMBER(0).
		if radioButton1:Checked then do:
           radioButton1:ForeColor  = System.Drawing.Color:Green.
           radioButton2:ForeColor  = System.Drawing.Color:Black.
        end.
        else do:
           radioButton1:ForeColor  = System.Drawing.Color:Black.
           radioButton2:ForeColor  = System.Drawing.Color:Green.
        end.
         Init_comboBox1(radioButton1:Checked).
         find first ttMethodCalc where ttMethodCalc.item eq comboBox1:SelectedItem:ToString() no-lock no-error.
         if available ttMethodCalc 
         then
             Init_comboBox3(radioButton1:Checked,ttMethodCalc.code).
         
        RETURN.

	END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    METHOD PRIVATE VOID comboBox3_SelectedIndexChanged( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
        IF radioButton1:Checked THEN 
        DO:
            find first ttMethodCalc where ttMethodCalc.item eq comboBox1:SelectedItem:ToString() no-lock no-error.
            if available ttMethodCalc then do:
                 Show_Panet_SelectConditonItem(ttMethodCalc.code ).
                
            end.
        END.
        RETURN.
        
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    METHOD PRIVATE VOID comboBox1_SelectedIndexChanged( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
        
        /*IF tabControl1:TabPages:Count = 5 THEN
        DO:
           .
            //tabControl1:TabPages:Add(tabPage6).
        END.*/
        find first ttMethodCalc where ttMethodCalc.item eq comboBox1:SelectedItem:ToString() no-lock no-error.
        if available ttMethodCalc 
        then do:
            Init_comboBox3(radioButton1:Checked,ttMethodCalc.code).
            Init_comboBox_nUMBER(0).
            if ttMethodCalc.code eq 7
            then
                m-promo-trg:ViewPage6(no).
            else    
               m-promo-trg:ViewPage6(yes). 
            case ttMethodCalc.code: 
                when 1 then do: // "Скидка процентом" 
                    Init_comboBox_nUMBER(1).
                    Show_Panet_SelectConditonItem(1).
                end .
                when 2 then do: // Абсолютная (скидка суммой от цены)
                    Show_Panet_SelectConditonItem(2).
                end .
                when 3 then do: // Скидка количеством
                    Init_comboBox_nUMBER(3).
                    Show_Panet_SelectConditonItem(3).
                end .
                when 4 then do: //Скидка процентом за количество
                    Init_comboBox_nUMBER(4).
                    Show_Panet_SelectConditonItem(4).
                end .
                when 5 then do: // Фиксированная цена
                    Init_comboBox_nUMBER(5).
                    Show_Panet_SelectConditonItem(5).
                end .
                when 6 then do: // Выдача сообщения
                    Show_Panet_SelectConditonItem(6).
                end .
                when 7 then do: // "Подарок"
                    Show_Panet_SelectConditonItem(7).
                  //  tabControl1:TabPages:Remove(tabPage6).
                end .
            end case.
        end.            

        
        RETURN.

    END METHOD.
    
    DEFINE VARIABLE ucMain1     AS ibs.th.ref.promo.ucSelect_Items1     NO-UNDO.
    DEFINE VARIABLE ucMain1_1   AS ibs.th.ref.promo.ucSelect_Items1_1   NO-UNDO.
    DEFINE VARIABLE ucMain1_Set AS ibs.th.ref.promo.ucSelect_Items1_Set NO-UNDO.
    DEFINE VARIABLE ucMain2     AS ibs.th.ref.promo.ucSelect_Items2     NO-UNDO.
    DEFINE VARIABLE ucMain2_1   AS ibs.th.ref.promo.ucSelect_Items2_1   NO-UNDO.
    DEFINE VARIABLE ucMain1_2   AS ibs.th.ref.promo.ucSelect_Items1_2   NO-UNDO. 
    DEFINE VARIABLE ucMain3     AS ibs.th.ref.promo.ucSelect_Items3     NO-UNDO.
    DEFINE VARIABLE ucMain4     AS ibs.th.ref.promo.ucSelect_Items4     NO-UNDO.
    DEFINE VARIABLE ucMain5     AS ibs.th.ref.promo.ucSelect_Items5     NO-UNDO.
    DEFINE VARIABLE ucMain5_Set AS ibs.th.ref.promo.ucSelect_Items5_Set NO-UNDO.
    DEFINE VARIABLE ucMain6     AS ibs.th.ref.promo.ucSelect_Items6     NO-UNDO.
    DEFINE VARIABLE ucMain6_1   AS ibs.th.ref.promo.ucSelect_Items6_1   NO-UNDO.
    DEFINE VARIABLE ucMain7     AS ibs.th.ref.promo.ucSelect_Items7     NO-UNDO.
    DEFINE VARIABLE ucMain7_1   AS ibs.th.ref.promo.ucSelect_Items7_1   NO-UNDO.
    DEFINE VARIABLE ucMain7_2   AS ibs.th.ref.promo.ucSelect_Items7_2   NO-UNDO.
     
    METHOD PRIVATE VOID Show_Panet_SelectConditonItem( INPUT SelectItem AS int):
        
        THIS-OBJECT:panel_SelectConditionItems:Controls:Clear().
        if valid-object(ucMain1)        then delete object ucMain1.
        if valid-object(ucMain1_1)      then delete object ucMain1_1.
        if valid-object(ucMain1_Set)    then delete object ucMain1_Set.
        if valid-object(ucMain2_1)      then delete object ucMain2_1.
        if valid-object(ucMain1_2)      then delete object ucMain1_2.
        if valid-object(ucMain2)        then delete object ucMain2.
        if valid-object(ucMain3)        then delete object ucMain3.
        if valid-object(ucMain4)        then delete object ucMain4.
        if valid-object(ucMain5)        then delete object ucMain5.
        if valid-object(ucMain5_Set)    then delete object ucMain5_Set.
        if valid-object(ucMain6)        then delete object ucMain6.
        if valid-object(ucMain6_1)      then delete object ucMain6_1.
        if valid-object(ucMain7)        then delete object ucMain7.
        if valid-object(ucMain7_1)      then delete object ucMain7_1.
        if valid-object(ucMain7_2)      then delete object ucMain7_2.
        assign
            label5:Visible    = FALSE
            checkBox1:Visible = label5:Visible
        .
            
        case SelectItem:
            when 1 then do:
                IF radioButton1:Checked THEN
                DO:
                    find first tttypeCond where tttypeCond.item eq comboBox3:SelectedItem:ToString() no-lock no-error.
                    if available tttypeCond 
                    then do: 
                        if tttypeCond.code = 1 // "Количество по строке"  
                        then do:
                            ucMain1 = NEW ibs.th.ref.promo.ucSelect_Items1().
                            ucMain1:SetPromoTrg(m-promo-trg).
                            ucMain1:Dock = System.Windows.Forms.DockStyle:Fill.
                            THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain1).
                            assign
                                label5:Visible    = true
                                checkBox1:Visible = label5:Visible
                            .
                        end.
                        else IF tttypeCond.code = 2 // "Сумма по строке" 
                        then do:
                            ucMain1_1 = NEW ibs.th.ref.promo.ucSelect_Items1_1().
                            ucMain1_1:SetPromoTrg(m-promo-trg).
                            ucMain1_1:Dock = System.Windows.Forms.DockStyle:Fill.
                            THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain1_1).
                            assign
                                label5:Visible    = true
                                checkBox1:Visible = label5:Visible
                            .
                        end.
                        IF tttypeCond.code = 3 // "Итог чека" 
                        then do:
                            ucMain1_2 = NEW ibs.th.ref.promo.ucSelect_Items1_2().
                            ucMain1_2:SetPromoTrg(m-promo-trg).
                            ucMain1_2:Dock = System.Windows.Forms.DockStyle:Fill.
                            THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain1_2).
                        END.
                    end.
                END.
                ELSE
                DO:
                    
                    ucMain1_Set = NEW ibs.th.ref.promo.ucSelect_Items1_Set().
                    ucMain1_Set:SetPromoTrg(m-promo-trg).
                    ucMain1_Set:Dock = System.Windows.Forms.DockStyle:Fill.
                    THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain1_Set).
                END.
                
            end .
            when 2 then do:
                
                find first tttypeCond where tttypeCond.item eq comboBox3:SelectedItem:ToString() no-lock no-error.
                if available tttypeCond 
                then do:
                    assign
                        label5:Visible    = true
                        checkBox1:Visible = label5:Visible
                    .
                    IF tttypeCond.code = 1 // "Количество по строке" 
                    then DO:
                        ucMain2 = NEW ibs.th.ref.promo.ucSelect_Items2().
                        ucMain2:SetPromoTrg(m-promo-trg).
                        ucMain2:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain2).                    
                    END.
                    IF tttypeCond.code = 2 // "Сумма по строке"  
                    then do :
                        ucMain2_1 = NEW ibs.th.ref.promo.ucSelect_Items2_1().
                        ucMain2_1:SetPromoTrg(m-promo-trg).
                        ucMain2_1:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain2_1).
                    end.
                 end.
            end .
            when 3 then do:
                ucMain3 = NEW ibs.th.ref.promo.ucSelect_Items3().
                ucMain3:SetPromoTrg(m-promo-trg).
                ucMain3:Dock = System.Windows.Forms.DockStyle:Fill.
                THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain3).
            end .
            when 4 then do:
                ucMain4 = NEW ibs.th.ref.promo.ucSelect_Items4().
                ucMain4:SetPromoTrg(m-promo-trg).
                ucMain4:Dock = System.Windows.Forms.DockStyle:Fill.
                THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain4).
            end .
            when 5 then do:
                IF radioButton1:Checked THEN
                DO:
                    ucMain5 = NEW ibs.th.ref.promo.ucSelect_Items5().
                    ucMain5:SetPromoTrg(m-promo-trg).
                    ucMain5:Dock = System.Windows.Forms.DockStyle:Fill.
                    THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain5).                    
                END.
                ELSE
                DO:
                    ucMain5_Set = NEW ibs.th.ref.promo.ucSelect_Items5_Set().
                    ucMain5_Set:SetPromoTrg(m-promo-trg).
                    ucMain5_Set:Dock = System.Windows.Forms.DockStyle:Fill.
                    THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain5_Set).  
                END.
            end .
            when 6 then do:
                find first tttypeCond where tttypeCond.item eq comboBox3:SelectedItem:ToString() no-lock no-error.
                if available tttypeCond 
                then do:
                    if tttypeCond.code = 1 // "Количество по строке"  
                    then do:
                        ucMain6 = NEW ibs.th.ref.promo.ucSelect_Items6().
                        ucMain6:SetPromoTrg(m-promo-trg).
                        ucMain6:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain6).
                        assign
                            label5:Visible    = true
                            checkBox1:Visible = label5:Visible
                        .
                    end.
                    else if    tttypeCond.code = 2 // "Сумма по строке"
                            or tttypeCond.code = 3 // "Итог чека"                       
                    then do :
                        ucMain6_1 = NEW ibs.th.ref.promo.ucSelect_Items6_1().
                        ucMain6_1:SetPromoTrg(m-promo-trg).
                        ucMain6_1:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain6_1).
                        if    tttypeCond.code = 2 then
                        assign
                            label5:Visible    = true
                            checkBox1:Visible = label5:Visible
                        .
                    end.
                          
                end.        
            end .
            when 7 then do:
                find first tttypeCond where tttypeCond.item eq comboBox3:SelectedItem:ToString() no-lock no-error.
                if available tttypeCond 
                then do:
                    if tttypeCond.code = 1 // "Количество по строке"  
                    then do:
                        ucMain7 = NEW ibs.th.ref.promo.ucSelect_Items7().
                        ucMain7:SetPromoTrg(m-promo-trg).
                        ucMain7:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain7).
                    end.
                    else if tttypeCond.code = 2 // "Сумма по строке"   
                    then do:
                        ucMain7_1 = NEW ibs.th.ref.promo.ucSelect_Items7_1().
                        ucMain7_1:SetPromoTrg(m-promo-trg).
                        ucMain7_1:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain7_1).
                    end.
                    else if tttypeCond.code = 3 // "Итог чека"  
                    then do:
                        ucMain7_2 = NEW ibs.th.ref.promo.ucSelect_Items7_2().
                        ucMain7_2:SetPromoTrg(m-promo-trg).
                        ucMain7_2:Dock = System.Windows.Forms.DockStyle:Fill.
                        THIS-OBJECT:panel_SelectConditionItems:Controls:Add(ucMain7_2).
                    end.
                end.    
            end .
            
         end case. 
         
         RETURN.

    END METHOD.
            
       
    
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    METHOD PRIVATE VOID checkBox1_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
        
        DEFINE VARIABLE dialog AS ibs.th.ref.promo.dSelectConditonItem.
        dialog = NEW ibs.th.ref.promo.dSelectConditonItem(). 
        dialog:SetPromoTrg(m-promo-trg).
        WAIT-FOR dialog:ShowDialog().
        
        RETURN.

    END METHOD.

END CLASS.