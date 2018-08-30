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

CLASS ibs.th.ref.promo.ucSelect_Items7_1 INHERITS UserControl: 
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Просмотр/редактирование одной акции". 
  /* --- end_of для cmp/vssrevis.i --- */
    
    define private variable bindPromoGift as Progress.Data.BindingSource no-undo.
    define private variable bindPromoCrit as Progress.Data.BindingSource no-undo.
    define private variable bindpromogoodsCrit as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE button7 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button6 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button5 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button4 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button3 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button2 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    define private variable gdsNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable spanDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable qntyDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable mincritDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsNameDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE tableLayoutPanel4 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel3 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE label3 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label2 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView3 AS System.Windows.Forms.DataGridView NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView2 AS System.Windows.Forms.DataGridView NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.

    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.
    
    
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_CellContentClick( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):
		bindPromoGift:dispose().
                bindPromoGift:handle      = m-promo-trg:getQuery("PromoGiftForCrit",yes).
		bindPromoGift:RefreshAll().
		return.

	end method.

    method Public VOID SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
    end.
    
    method Public VOID SetBind( ):
         bindpromogoodsCrit:handle = m-promo-trg:getQuery("PromoGoodsCrit").
         bindpromoCrit:handle      = m-promo-trg:getQuery("PromoCriterion").
         bindPromoGift:handle      = m-promo-trg:getQuery("PromoGiftForCrit").

       // bindPromoActionOne:handle = m-promo-trg:getQuery("promoActionOne2").
      /*  message valid-object(bindPromoActionOne:handle)
        view-as alert-box.*/
    end.
    

        
    CONSTRUCTOR PUBLIC ucSelect_Items7_1 (  ):
        
        
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
        THIS-OBJECT:components = NEW System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc4 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc4 = NEW Progress.Data.TableDesc("tt-PromoGoodsCrite").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc5 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc5 = NEW Progress.Data.TableDesc("tt-PromoGift").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc6 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc6 = NEW Progress.Data.TableDesc("tt-PromoCriterion").
        THIS-OBJECT:tableLayoutPanel1 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:dataGridView3 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:bindpromogoodsCrit = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:dataGridView2 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn1 = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:qntyDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:bindPromoGift = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:tableLayoutPanel3 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:button5 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button4 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:tableLayoutPanel2 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:button3 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button2 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:dataGridView1 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:mincritDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:spanDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:bindPromoCrit = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:label2 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:label3 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:tableLayoutPanel4 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:button6 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button7 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:tableLayoutPanel1:SuspendLayout().
        CAST(THIS-OBJECT:dataGridView3, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:bindpromogoodsCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:dataGridView2, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:bindPromoGift, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:tableLayoutPanel3:SuspendLayout().
        THIS-OBJECT:tableLayoutPanel2:SuspendLayout().
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:bindPromoCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:tableLayoutPanel4:SuspendLayout().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        THIS-OBJECT:tableLayoutPanel1:ColumnCount = 3.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33.3333321))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33.3333321))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33.3333321))).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:dataGridView3, 0, 2).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:dataGridView2, 1, 2).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:tableLayoutPanel3, 1, 1).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:tableLayoutPanel2, 0, 1).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:dataGridView1, 0, 2).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label1, 0, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label2, 1, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label3, 2, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:tableLayoutPanel4, 2, 1).
        THIS-OBJECT:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:tableLayoutPanel1:Name = "tableLayoutPanel1".
        THIS-OBJECT:tableLayoutPanel1:RowCount = 3.
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:Size = NEW System.Drawing.Size(871, 309).
        THIS-OBJECT:tableLayoutPanel1:TabIndex = 3.
        /*  */
        /* dataGridView3 */
        /*  */
        THIS-OBJECT:dataGridView3:AllowUserToAddRows = false.
        THIS-OBJECT:dataGridView3:AllowUserToDeleteRows = false.
        THIS-OBJECT:dataGridView3:AutoGenerateColumns = false.
        THIS-OBJECT:dataGridView3:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        THIS-OBJECT:dataGridView3:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar0 AS System.Windows.Forms.DataGridViewColumn EXTENT 1 NO-UNDO.
        arrayvar0[1] = THIS-OBJECT:gdsNameDataGridViewTextBoxColumn.
        THIS-OBJECT:dataGridView3:Columns:AddRange(arrayvar0).
        THIS-OBJECT:dataGridView3:DataSource = THIS-OBJECT:bindpromogoodsCrit.
        THIS-OBJECT:dataGridView3:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:dataGridView3:Location = NEW System.Drawing.Point(3, 53).
        THIS-OBJECT:dataGridView3:Name = "dataGridView3".
        THIS-OBJECT:dataGridView3:ReadOnly = true.
        THIS-OBJECT:dataGridView3:Size = NEW System.Drawing.Size(284, 253).
        THIS-OBJECT:dataGridView3:TabIndex = 8.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:DataPropertyName = "gdsName".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:HeaderText = "Номенклатура".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:Name = "gdsNameDataGridViewTextBoxColumn".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindpromogoodsCrit */
        /*  */
        THIS-OBJECT:bindpromogoodsCrit:MaxDataGuess = 0.
        THIS-OBJECT:bindpromogoodsCrit:NoLOBs = false.
        THIS-OBJECT:bindpromogoodsCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar1 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar1 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc4:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar2 AS Progress.Data.ColumnPropDesc EXTENT 1 NO-UNDO.
        arrayvar2[1] = NEW Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        tableDesc4:Columns = arrayvar2.
        THIS-OBJECT:bindpromogoodsCrit:TableSchema = tableDesc4.
        /*  */
        /* dataGridView2 */
        /*  */
        THIS-OBJECT:dataGridView2:AllowUserToAddRows = false.
        THIS-OBJECT:dataGridView2:AllowUserToDeleteRows = false.
        THIS-OBJECT:dataGridView2:AutoGenerateColumns = false.
        THIS-OBJECT:dataGridView2:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        THIS-OBJECT:dataGridView2:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar3 AS System.Windows.Forms.DataGridViewColumn EXTENT 2 NO-UNDO.
        arrayvar3[1] = THIS-OBJECT:gdsNameDataGridViewTextBoxColumn1.
        arrayvar3[2] = THIS-OBJECT:qntyDataGridViewTextBoxColumn.
        THIS-OBJECT:dataGridView2:Columns:AddRange(arrayvar3).
        THIS-OBJECT:dataGridView2:DataSource = THIS-OBJECT:bindPromoGift.
        THIS-OBJECT:dataGridView2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:dataGridView2:Location = NEW System.Drawing.Point(583, 53).
        THIS-OBJECT:dataGridView2:Name = "dataGridView2".
        THIS-OBJECT:dataGridView2:ReadOnly = true.
        THIS-OBJECT:dataGridView2:Size = NEW System.Drawing.Size(285, 253).
        THIS-OBJECT:dataGridView2:TabIndex = 3.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn1 */
        /*  */
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn1:DataPropertyName = "gdsName".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn1:HeaderText = "Номенклатура".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn1:Name = "gdsNameDataGridViewTextBoxColumn1".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn1:ReadOnly = true.
        /*  */
        /* qntyDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:qntyDataGridViewTextBoxColumn:DataPropertyName = "qnty".
        THIS-OBJECT:qntyDataGridViewTextBoxColumn:HeaderText = "Количество".
        THIS-OBJECT:qntyDataGridViewTextBoxColumn:Name = "qntyDataGridViewTextBoxColumn".
        THIS-OBJECT:qntyDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindPromoGift */
        /*  */
        THIS-OBJECT:bindPromoGift:MaxDataGuess = 0.
        THIS-OBJECT:bindPromoGift:NoLOBs = false.
        THIS-OBJECT:bindPromoGift:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar4 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar4 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc5:ChildTables = arrayvar4.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar5 AS Progress.Data.ColumnPropDesc EXTENT 2 NO-UNDO.
        arrayvar5[1] = NEW Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        arrayvar5[2] = NEW Progress.Data.ColumnPropDesc("qnty", "кол-во", Progress.Data.DataType:DECIMAL).
        tableDesc5:Columns = arrayvar5.
        THIS-OBJECT:bindPromoGift:TableSchema = tableDesc5.
        /*  */
        /* tableLayoutPanel3 */
        /*  */
        THIS-OBJECT:tableLayoutPanel3:ColumnCount = 4.
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel3:Controls:Add(THIS-OBJECT:button5, 0, 0).
        THIS-OBJECT:tableLayoutPanel3:Controls:Add(THIS-OBJECT:button4, 0, 0).
        THIS-OBJECT:tableLayoutPanel3:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel3:Location = NEW System.Drawing.Point(293, 25).
        THIS-OBJECT:tableLayoutPanel3:Margin = NEW System.Windows.Forms.Padding(3, 0, 0, 0).
        THIS-OBJECT:tableLayoutPanel3:Name = "tableLayoutPanel3".
        THIS-OBJECT:tableLayoutPanel3:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel3:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel3:Size = NEW System.Drawing.Size(287, 25).
        THIS-OBJECT:tableLayoutPanel3:TabIndex = 1.
        /*  */
        /* button5 */
        /*  */
        THIS-OBJECT:button5:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:button5:Location = NEW System.Drawing.Point(71, 0).
        THIS-OBJECT:button5:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:button5:Name = "button5".
        THIS-OBJECT:button5:Size = NEW System.Drawing.Size(71, 25).
        THIS-OBJECT:button5:TabIndex = 2.
        THIS-OBJECT:button5:Text = "Удалить".
        THIS-OBJECT:button5:UseCompatibleTextRendering = true.
        THIS-OBJECT:button5:UseVisualStyleBackColor = true.
        /*  */
        /* button4 */
        /*  */
        THIS-OBJECT:button4:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:button4:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:button4:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:button4:Name = "button4".
        THIS-OBJECT:button4:Size = NEW System.Drawing.Size(71, 25).
        THIS-OBJECT:button4:TabIndex = 1.
        THIS-OBJECT:button4:Text = "Добавить".
        THIS-OBJECT:button4:UseCompatibleTextRendering = true.
        THIS-OBJECT:button4:UseVisualStyleBackColor = true.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        THIS-OBJECT:tableLayoutPanel2:ColumnCount = 4.
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:button3, 2, 0).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:button2, 1, 0).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:button1, 0, 0).
        THIS-OBJECT:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel2:Location = NEW System.Drawing.Point(3, 25).
        THIS-OBJECT:tableLayoutPanel2:Margin = NEW System.Windows.Forms.Padding(3, 0, 0, 0).
        THIS-OBJECT:tableLayoutPanel2:Name = "tableLayoutPanel2".
        THIS-OBJECT:tableLayoutPanel2:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel2:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Size = NEW System.Drawing.Size(287, 25).
        THIS-OBJECT:tableLayoutPanel2:TabIndex = 0.
        /*  */
        /* button3 */
        /*  */
        THIS-OBJECT:button3:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:button3:Location = NEW System.Drawing.Point(160, 0).
        THIS-OBJECT:button3:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:button3:Name = "button3".
        THIS-OBJECT:button3:Size = NEW System.Drawing.Size(120, 25).
        THIS-OBJECT:button3:TabIndex = 2.
        THIS-OBJECT:button3:Text = "Добавить по отбору".
        THIS-OBJECT:button3:UseCompatibleTextRendering = true.
        THIS-OBJECT:button3:UseVisualStyleBackColor = true.
        /*  */
        /* button2 */
        /*  */
        THIS-OBJECT:button2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:button2:Location = NEW System.Drawing.Point(80, 0).
        THIS-OBJECT:button2:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:button2:Name = "button2".
        THIS-OBJECT:button2:Size = NEW System.Drawing.Size(80, 25).
        THIS-OBJECT:button2:TabIndex = 1.
        THIS-OBJECT:button2:Text = "Удалить".
        THIS-OBJECT:button2:UseCompatibleTextRendering = true.
        THIS-OBJECT:button2:UseVisualStyleBackColor = true.
        /*  */
        /* button1 */
        /*  */
        THIS-OBJECT:button1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:button1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:button1:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:button1:Name = "button1".
        THIS-OBJECT:button1:Size = NEW System.Drawing.Size(80, 25).
        THIS-OBJECT:button1:TabIndex = 0.
        THIS-OBJECT:button1:Text = "Добавить".
        THIS-OBJECT:button1:UseCompatibleTextRendering = true.
        THIS-OBJECT:button1:UseVisualStyleBackColor = true.
        /*  */
        /* dataGridView1 */
        /*  */
        THIS-OBJECT:dataGridView1:AllowUserToAddRows = false.
        THIS-OBJECT:dataGridView1:AllowUserToDeleteRows = false.
        THIS-OBJECT:dataGridView1:AutoGenerateColumns = false.
        THIS-OBJECT:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        THIS-OBJECT:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar6 AS System.Windows.Forms.DataGridViewColumn EXTENT 2 NO-UNDO.
        arrayvar6[1] = THIS-OBJECT:mincritDataGridViewTextBoxColumn.
        arrayvar6[2] = THIS-OBJECT:spanDataGridViewTextBoxColumn.
        THIS-OBJECT:dataGridView1:Columns:AddRange(arrayvar6).
        THIS-OBJECT:dataGridView1:DataSource = THIS-OBJECT:bindPromoCrit.
        THIS-OBJECT:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:dataGridView1:Location = NEW System.Drawing.Point(293, 53).
        THIS-OBJECT:dataGridView1:Name = "dataGridView1".
        THIS-OBJECT:dataGridView1:ReadOnly = true.
        THIS-OBJECT:dataGridView1:Size = NEW System.Drawing.Size(284, 253).
        THIS-OBJECT:dataGridView1:TabIndex = 2.
        THIS-OBJECT:dataGridView1:CellContentClick:Subscribe(THIS-OBJECT:dataGridView1_CellContentClick).
        /*  */
        /* mincritDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:mincritDataGridViewTextBoxColumn:DataPropertyName = "mincrit".
        THIS-OBJECT:mincritDataGridViewTextBoxColumn:HeaderText = "Сумма,руб".
        THIS-OBJECT:mincritDataGridViewTextBoxColumn:Name = "mincritDataGridViewTextBoxColumn".
        THIS-OBJECT:mincritDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* spanDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:spanDataGridViewTextBoxColumn:DataPropertyName = "span".
        THIS-OBJECT:spanDataGridViewTextBoxColumn:HeaderText = "Диапозон действия,руб".
        THIS-OBJECT:spanDataGridViewTextBoxColumn:Name = "spanDataGridViewTextBoxColumn".
        THIS-OBJECT:spanDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindPromoCrit */
        /*  */
        THIS-OBJECT:bindPromoCrit:MaxDataGuess = 0.
        THIS-OBJECT:bindPromoCrit:NoLOBs = false.
        THIS-OBJECT:bindPromoCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar7 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar7 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc6:ChildTables = arrayvar7.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar8 AS Progress.Data.ColumnPropDesc EXTENT 2 NO-UNDO.
        arrayvar8[1] = NEW Progress.Data.ColumnPropDesc("span", "", Progress.Data.DataType:CHARACTER).
        arrayvar8[2] = NEW Progress.Data.ColumnPropDesc("mincrit", "минимальное значение критерия", Progress.Data.DataType:DECIMAL).
        tableDesc6:Columns = arrayvar8.
        THIS-OBJECT:bindPromoCrit:TableSchema = tableDesc6.
        /*  */
        /* label1 */
        /*  */
        THIS-OBJECT:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label1:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        THIS-OBJECT:label1:Location = NEW System.Drawing.Point(3, 0).
        THIS-OBJECT:label1:Name = "label1".
        THIS-OBJECT:label1:Size = NEW System.Drawing.Size(284, 25).
        THIS-OBJECT:label1:TabIndex = 4.
        THIS-OBJECT:label1:Text = "Товар".
        THIS-OBJECT:label1:UseCompatibleTextRendering = true.
        /*  */
        /* label2 */
        /*  */
        THIS-OBJECT:label2:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        THIS-OBJECT:label2:Location = NEW System.Drawing.Point(293, 0).
        THIS-OBJECT:label2:Name = "label2".
        THIS-OBJECT:label2:Size = NEW System.Drawing.Size(284, 25).
        THIS-OBJECT:label2:TabIndex = 5.
        THIS-OBJECT:label2:Text = "Условия".
        THIS-OBJECT:label2:UseCompatibleTextRendering = true.
        /*  */
        /* label3 */
        /*  */
        THIS-OBJECT:label3:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label3:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        THIS-OBJECT:label3:Location = NEW System.Drawing.Point(583, 0).
        THIS-OBJECT:label3:Name = "label3".
        THIS-OBJECT:label3:Size = NEW System.Drawing.Size(285, 25).
        THIS-OBJECT:label3:TabIndex = 6.
        THIS-OBJECT:label3:Text = "Подарки".
        THIS-OBJECT:label3:UseCompatibleTextRendering = true.
        /*  */
        /* tableLayoutPanel4 */
        /*  */
        THIS-OBJECT:tableLayoutPanel4:ColumnCount = 4.
        THIS-OBJECT:tableLayoutPanel4:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel4:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel4:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel4:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel4:Controls:Add(THIS-OBJECT:button6, 0, 0).
        THIS-OBJECT:tableLayoutPanel4:Controls:Add(THIS-OBJECT:button7, 0, 0).
        THIS-OBJECT:tableLayoutPanel4:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel4:Location = NEW System.Drawing.Point(583, 25).
        THIS-OBJECT:tableLayoutPanel4:Margin = NEW System.Windows.Forms.Padding(3, 0, 0, 0).
        THIS-OBJECT:tableLayoutPanel4:Name = "tableLayoutPanel4".
        THIS-OBJECT:tableLayoutPanel4:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel4:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel4:Size = NEW System.Drawing.Size(288, 25).
        THIS-OBJECT:tableLayoutPanel4:TabIndex = 7.
        /*  */
        /* button6 */
        /*  */
        THIS-OBJECT:button6:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:button6:Location = NEW System.Drawing.Point(72, 0).
        THIS-OBJECT:button6:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:button6:Name = "button6".
        THIS-OBJECT:button6:Size = NEW System.Drawing.Size(72, 25).
        THIS-OBJECT:button6:TabIndex = 2.
        THIS-OBJECT:button6:Text = "Удалить".
        THIS-OBJECT:button6:UseCompatibleTextRendering = true.
        THIS-OBJECT:button6:UseVisualStyleBackColor = true.
        /*  */
        /* button7 */
        /*  */
        THIS-OBJECT:button7:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:button7:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:button7:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:button7:Name = "button7".
        THIS-OBJECT:button7:Size = NEW System.Drawing.Size(72, 25).
        THIS-OBJECT:button7:TabIndex = 1.
        THIS-OBJECT:button7:Text = "Добавить".
        THIS-OBJECT:button7:UseCompatibleTextRendering = true.
        THIS-OBJECT:button7:UseVisualStyleBackColor = true.
        /*  */
        /* ucSelect_Items7_1 */
        /*  */
        THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel1).
        THIS-OBJECT:Name = "ucSelect_Items7_1".
        THIS-OBJECT:Size = NEW System.Drawing.Size(871, 309).
        THIS-OBJECT:tableLayoutPanel1:ResumeLayout(false).
        CAST(THIS-OBJECT:dataGridView3, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:bindpromogoodsCrit, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:dataGridView2, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:bindPromoGift, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:tableLayoutPanel3:ResumeLayout(false).
        THIS-OBJECT:tableLayoutPanel2:ResumeLayout(false).
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:bindPromoCrit, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:tableLayoutPanel4:ResumeLayout(false).
        THIS-OBJECT:ResumeLayout(false).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END METHOD.

    DESTRUCTOR PUBLIC ucSelect_Items7_1 ( ):
        if valid-object(m-promo-trg) then closeBind().
    END DESTRUCTOR.
    
    method private void closeBind():
        if  dataGridView1:SelectedCells:Count > 0
        then
            dataGridView1:SelectedCells[0]:Selected = true.
        if  dataGridView2:SelectedCells:Count > 0
        then
            dataGridView2:SelectedCells[0]:Selected = true.
        if  dataGridView3:SelectedCells:Count > 0
        then
            dataGridView3:SelectedCells[0]:Selected = true.
        bindpromogoodsCrit   :Assign().
        bindpromoCrit        :Assign().
        bindPromoGift        :Assign().
        bindpromogoodsCrit   :Dispose().
        bindpromoCrit        :Dispose().
        bindPromoGift        :Dispose().
 
    end.

END CLASS.