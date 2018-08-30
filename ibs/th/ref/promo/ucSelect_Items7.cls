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

CLASS ibs.th.ref.promo.ucSelect_Items7 INHERITS UserControl: 
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
    

        
    CONSTRUCTOR PUBLIC ucSelect_Items7 (  ):
        
        
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
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("tt-PromoGoodsCrite").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc2 as Progress.Data.TableDesc no-undo.
        tableDesc2 = new Progress.Data.TableDesc("tt-PromoGift").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc3 as Progress.Data.TableDesc no-undo.
        tableDesc3 = new Progress.Data.TableDesc("tt-PromoCriterion").
        this-object:tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel().
        this-object:dataGridView3 = new System.Windows.Forms.DataGridView().
        this-object:gdsNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:bindpromogoodsCrit = new Progress.Data.BindingSource(this-object:components).
        this-object:dataGridView2 = new System.Windows.Forms.DataGridView().
        this-object:gdsNameDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:qntyDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:bindPromoGift = new Progress.Data.BindingSource(this-object:components).
        this-object:tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button5 = new System.Windows.Forms.Button().
        this-object:button4 = new System.Windows.Forms.Button().
        this-object:tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button3 = new System.Windows.Forms.Button().
        this-object:button2 = new System.Windows.Forms.Button().
        this-object:button1 = new System.Windows.Forms.Button().
        this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
        this-object:mincritDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:spanDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:bindPromoCrit = new Progress.Data.BindingSource(this-object:components).
        this-object:label1 = new System.Windows.Forms.Label().
        this-object:label2 = new System.Windows.Forms.Label().
        this-object:label3 = new System.Windows.Forms.Label().
        this-object:tableLayoutPanel4 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button6 = new System.Windows.Forms.Button().
        this-object:button7 = new System.Windows.Forms.Button().
        this-object:tableLayoutPanel1:SuspendLayout().
        cast(this-object:dataGridView3, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindpromogoodsCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:dataGridView2, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindPromoGift, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:tableLayoutPanel3:SuspendLayout().
        this-object:tableLayoutPanel2:SuspendLayout().
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindPromoCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:tableLayoutPanel4:SuspendLayout().
        this-object:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        this-object:tableLayoutPanel1:ColumnCount = 3.
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33.3333321))).
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33.3333321))).
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33.3333321))).
        this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView3, 0, 2).
        this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView2, 1, 2).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel3, 1, 1).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel2, 0, 1).
        this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView1, 0, 2).
        this-object:tableLayoutPanel1:Controls:Add(this-object:label1, 0, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:label2, 1, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:label3, 2, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel4, 2, 1).
        this-object:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel1:Location = new System.Drawing.Point(0, 0).
        this-object:tableLayoutPanel1:Name = "tableLayoutPanel1".
        this-object:tableLayoutPanel1:RowCount = 3.
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Size = new System.Drawing.Size(871, 309).
        this-object:tableLayoutPanel1:TabIndex = 3.
        /*  */
        /* dataGridView3 */
        /*  */
        this-object:dataGridView3:AllowUserToAddRows = false.
        this-object:dataGridView3:AllowUserToDeleteRows = false.
        this-object:dataGridView3:AutoGenerateColumns = false.
        this-object:dataGridView3:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        this-object:dataGridView3:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 1 no-undo.
        arrayvar0[1] = this-object:gdsNameDataGridViewTextBoxColumn.
        this-object:dataGridView3:Columns:AddRange(arrayvar0).
        this-object:dataGridView3:DataSource = this-object:bindpromogoodsCrit.
        this-object:dataGridView3:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView3:Location = new System.Drawing.Point(3, 53).
        this-object:dataGridView3:Name = "dataGridView3".
        this-object:dataGridView3:ReadOnly = true.
        this-object:dataGridView3:Size = new System.Drawing.Size(284, 253).
        this-object:dataGridView3:TabIndex = 8.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn */
        /*  */
        this-object:gdsNameDataGridViewTextBoxColumn:DataPropertyName = "gdsName".
        this-object:gdsNameDataGridViewTextBoxColumn:HeaderText = "Номенклатура".
        this-object:gdsNameDataGridViewTextBoxColumn:Name = "gdsNameDataGridViewTextBoxColumn".
        this-object:gdsNameDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindpromogoodsCrit */
        /*  */
        this-object:bindpromogoodsCrit:MaxDataGuess = 0.
        this-object:bindpromogoodsCrit:NoLOBs = false.
        this-object:bindpromogoodsCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar1 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 1 no-undo.
        arrayvar2[1] = new Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar2.
        this-object:bindpromogoodsCrit:TableSchema = tableDesc1.
        /*  */
        /* dataGridView2 */
        /*  */
        this-object:dataGridView2:AllowUserToAddRows = false.
        this-object:dataGridView2:AllowUserToDeleteRows = false.
        this-object:dataGridView2:AutoGenerateColumns = false.
        this-object:dataGridView2:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        this-object:dataGridView2:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as System.Windows.Forms.DataGridViewColumn extent 2 no-undo.
        arrayvar3[1] = this-object:gdsNameDataGridViewTextBoxColumn1.
        arrayvar3[2] = this-object:qntyDataGridViewTextBoxColumn.
        this-object:dataGridView2:Columns:AddRange(arrayvar3).
        this-object:dataGridView2:DataSource = this-object:bindPromoGift.
        this-object:dataGridView2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView2:Location = new System.Drawing.Point(583, 53).
        this-object:dataGridView2:Name = "dataGridView2".
        this-object:dataGridView2:ReadOnly = true.
        this-object:dataGridView2:Size = new System.Drawing.Size(285, 253).
        this-object:dataGridView2:TabIndex = 3.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn1 */
        /*  */
        this-object:gdsNameDataGridViewTextBoxColumn1:DataPropertyName = "gdsName".
        this-object:gdsNameDataGridViewTextBoxColumn1:HeaderText = "Номенклатура".
        this-object:gdsNameDataGridViewTextBoxColumn1:Name = "gdsNameDataGridViewTextBoxColumn1".
        this-object:gdsNameDataGridViewTextBoxColumn1:ReadOnly = true.
        /*  */
        /* qntyDataGridViewTextBoxColumn */
        /*  */
        this-object:qntyDataGridViewTextBoxColumn:DataPropertyName = "qnty".
        this-object:qntyDataGridViewTextBoxColumn:HeaderText = "Количество".
        this-object:qntyDataGridViewTextBoxColumn:Name = "qntyDataGridViewTextBoxColumn".
        this-object:qntyDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindPromoGift */
        /*  */
        this-object:bindPromoGift:MaxDataGuess = 0.
        this-object:bindPromoGift:NoLOBs = false.
        this-object:bindPromoGift:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar4 = new "Progress.Data.TableDesc[]"(0).
        tableDesc2:ChildTables = arrayvar4.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar5 as Progress.Data.ColumnPropDesc extent 2 no-undo.
        arrayvar5[1] = new Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        arrayvar5[2] = new Progress.Data.ColumnPropDesc("qnty", "кол-во", Progress.Data.DataType:DECIMAL).
        tableDesc2:Columns = arrayvar5.
        this-object:bindPromoGift:TableSchema = tableDesc2.
        /*  */
        /* tableLayoutPanel3 */
        /*  */
        this-object:tableLayoutPanel3:ColumnCount = 4.
        this-object:tableLayoutPanel3:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel3:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel3:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel3:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel3:Controls:Add(this-object:button5, 0, 0).
        this-object:tableLayoutPanel3:Controls:Add(this-object:button4, 0, 0).
        this-object:tableLayoutPanel3:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel3:Location = new System.Drawing.Point(293, 25).
        this-object:tableLayoutPanel3:Margin = new System.Windows.Forms.Padding(3, 0, 0, 0).
        this-object:tableLayoutPanel3:Name = "tableLayoutPanel3".
        this-object:tableLayoutPanel3:RowCount = 1.
        this-object:tableLayoutPanel3:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel3:Size = new System.Drawing.Size(287, 25).
        this-object:tableLayoutPanel3:TabIndex = 1.
        /*  */
        /* button5 */
        /*  */
        this-object:button5:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button5:Location = new System.Drawing.Point(71, 0).
        this-object:button5:Margin = new System.Windows.Forms.Padding(0).
        this-object:button5:Name = "button5".
        this-object:button5:Size = new System.Drawing.Size(71, 25).
        this-object:button5:TabIndex = 2.
        this-object:button5:Text = "Удалить".
        this-object:button5:UseCompatibleTextRendering = true.
        this-object:button5:UseVisualStyleBackColor = true.
        /*  */
        /* button4 */
        /*  */
        this-object:button4:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button4:Location = new System.Drawing.Point(0, 0).
        this-object:button4:Margin = new System.Windows.Forms.Padding(0).
        this-object:button4:Name = "button4".
        this-object:button4:Size = new System.Drawing.Size(71, 25).
        this-object:button4:TabIndex = 1.
        this-object:button4:Text = "Добавить".
        this-object:button4:UseCompatibleTextRendering = true.
        this-object:button4:UseVisualStyleBackColor = true.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        this-object:tableLayoutPanel2:ColumnCount = 4.
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button3, 2, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button2, 1, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button1, 0, 0).
        this-object:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel2:Location = new System.Drawing.Point(3, 25).
        this-object:tableLayoutPanel2:Margin = new System.Windows.Forms.Padding(3, 0, 0, 0).
        this-object:tableLayoutPanel2:Name = "tableLayoutPanel2".
        this-object:tableLayoutPanel2:RowCount = 1.
        this-object:tableLayoutPanel2:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Size = new System.Drawing.Size(287, 25).
        this-object:tableLayoutPanel2:TabIndex = 0.
        /*  */
        /* button3 */
        /*  */
        this-object:button3:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button3:Location = new System.Drawing.Point(160, 0).
        this-object:button3:Margin = new System.Windows.Forms.Padding(0).
        this-object:button3:Name = "button3".
        this-object:button3:Size = new System.Drawing.Size(120, 25).
        this-object:button3:TabIndex = 2.
        this-object:button3:Text = "Добавить по отбору".
        this-object:button3:UseCompatibleTextRendering = true.
        this-object:button3:UseVisualStyleBackColor = true.
        /*  */
        /* button2 */
        /*  */
        this-object:button2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button2:Location = new System.Drawing.Point(80, 0).
        this-object:button2:Margin = new System.Windows.Forms.Padding(0).
        this-object:button2:Name = "button2".
        this-object:button2:Size = new System.Drawing.Size(80, 25).
        this-object:button2:TabIndex = 1.
        this-object:button2:Text = "Удалить".
        this-object:button2:UseCompatibleTextRendering = true.
        this-object:button2:UseVisualStyleBackColor = true.
        /*  */
        /* button1 */
        /*  */
        this-object:button1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button1:Location = new System.Drawing.Point(0, 0).
        this-object:button1:Margin = new System.Windows.Forms.Padding(0).
        this-object:button1:Name = "button1".
        this-object:button1:Size = new System.Drawing.Size(80, 25).
        this-object:button1:TabIndex = 0.
        this-object:button1:Text = "Добавить".
        this-object:button1:UseCompatibleTextRendering = true.
        this-object:button1:UseVisualStyleBackColor = true.
        /*  */
        /* dataGridView1 */
        /*  */
        this-object:dataGridView1:AllowUserToAddRows = false.
        this-object:dataGridView1:AllowUserToDeleteRows = false.
        this-object:dataGridView1:AutoGenerateColumns = false.
        this-object:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar6 as System.Windows.Forms.DataGridViewColumn extent 2 no-undo.
        arrayvar6[1] = this-object:mincritDataGridViewTextBoxColumn.
        arrayvar6[2] = this-object:spanDataGridViewTextBoxColumn.
        this-object:dataGridView1:Columns:AddRange(arrayvar6).
        this-object:dataGridView1:DataSource = this-object:bindPromoCrit.
        this-object:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView1:Location = new System.Drawing.Point(293, 53).
        this-object:dataGridView1:Name = "dataGridView1".
        this-object:dataGridView1:ReadOnly = true.
        this-object:dataGridView1:Size = new System.Drawing.Size(284, 253).
        this-object:dataGridView1:TabIndex = 2.
        this-object:dataGridView1:CellContentClick:Subscribe(this-object:dataGridView1_CellContentClick).
        /*  */
        /* mincritDataGridViewTextBoxColumn */
        /*  */
        this-object:mincritDataGridViewTextBoxColumn:DataPropertyName = "mincrit".
        this-object:mincritDataGridViewTextBoxColumn:HeaderText = "Количество,ед".
        this-object:mincritDataGridViewTextBoxColumn:Name = "mincritDataGridViewTextBoxColumn".
        this-object:mincritDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* spanDataGridViewTextBoxColumn */
        /*  */
        this-object:spanDataGridViewTextBoxColumn:DataPropertyName = "span".
        this-object:spanDataGridViewTextBoxColumn:HeaderText = "Диапозон,ед".
        this-object:spanDataGridViewTextBoxColumn:Name = "spanDataGridViewTextBoxColumn".
        this-object:spanDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindPromoCrit */
        /*  */
        this-object:bindPromoCrit:MaxDataGuess = 0.
        this-object:bindPromoCrit:NoLOBs = false.
        this-object:bindPromoCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar7 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar7 = new "Progress.Data.TableDesc[]"(0).
        tableDesc3:ChildTables = arrayvar7.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar8 as Progress.Data.ColumnPropDesc extent 2 no-undo.
        arrayvar8[1] = new Progress.Data.ColumnPropDesc("span", "", Progress.Data.DataType:CHARACTER).
        arrayvar8[2] = new Progress.Data.ColumnPropDesc("mincrit", "минимальное значение критерия", Progress.Data.DataType:DECIMAL).
        tableDesc3:Columns = arrayvar8.
        this-object:bindPromoCrit:TableSchema = tableDesc3.
        /*  */
        /* label1 */
        /*  */
        this-object:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label1:Location = new System.Drawing.Point(3, 0).
        this-object:label1:Name = "label1".
        this-object:label1:Size = new System.Drawing.Size(284, 25).
        this-object:label1:TabIndex = 4.
        this-object:label1:Text = "Товар".
        this-object:label1:UseCompatibleTextRendering = true.
        /*  */
        /* label2 */
        /*  */
        this-object:label2:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label2:Location = new System.Drawing.Point(293, 0).
        this-object:label2:Name = "label2".
        this-object:label2:Size = new System.Drawing.Size(284, 25).
        this-object:label2:TabIndex = 5.
        this-object:label2:Text = "Условия".
        this-object:label2:UseCompatibleTextRendering = true.
        /*  */
        /* label3 */
        /*  */
        this-object:label3:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:label3:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label3:Location = new System.Drawing.Point(583, 0).
        this-object:label3:Name = "label3".
        this-object:label3:Size = new System.Drawing.Size(285, 25).
        this-object:label3:TabIndex = 6.
        this-object:label3:Text = "Подарки".
        this-object:label3:UseCompatibleTextRendering = true.
        /*  */
        /* tableLayoutPanel4 */
        /*  */
        this-object:tableLayoutPanel4:ColumnCount = 4.
        this-object:tableLayoutPanel4:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel4:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel4:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel4:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel4:Controls:Add(this-object:button6, 0, 0).
        this-object:tableLayoutPanel4:Controls:Add(this-object:button7, 0, 0).
        this-object:tableLayoutPanel4:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel4:Location = new System.Drawing.Point(583, 25).
        this-object:tableLayoutPanel4:Margin = new System.Windows.Forms.Padding(3, 0, 0, 0).
        this-object:tableLayoutPanel4:Name = "tableLayoutPanel4".
        this-object:tableLayoutPanel4:RowCount = 1.
        this-object:tableLayoutPanel4:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel4:Size = new System.Drawing.Size(288, 25).
        this-object:tableLayoutPanel4:TabIndex = 7.
        /*  */
        /* button6 */
        /*  */
        this-object:button6:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button6:Location = new System.Drawing.Point(72, 0).
        this-object:button6:Margin = new System.Windows.Forms.Padding(0).
        this-object:button6:Name = "button6".
        this-object:button6:Size = new System.Drawing.Size(72, 25).
        this-object:button6:TabIndex = 2.
        this-object:button6:Text = "Удалить".
        this-object:button6:UseCompatibleTextRendering = true.
        this-object:button6:UseVisualStyleBackColor = true.
        /*  */
        /* button7 */
        /*  */
        this-object:button7:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button7:Location = new System.Drawing.Point(0, 0).
        this-object:button7:Margin = new System.Windows.Forms.Padding(0).
        this-object:button7:Name = "button7".
        this-object:button7:Size = new System.Drawing.Size(72, 25).
        this-object:button7:TabIndex = 1.
        this-object:button7:Text = "Добавить".
        this-object:button7:UseCompatibleTextRendering = true.
        this-object:button7:UseVisualStyleBackColor = true.
        /*  */
        /* ucSelect_Items7 */
        /*  */
        this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        this-object:Controls:Add(this-object:tableLayoutPanel1).
        this-object:Name = "ucSelect_Items7".
        this-object:Size = new System.Drawing.Size(871, 309).
        this-object:tableLayoutPanel1:ResumeLayout(false).
        cast(this-object:dataGridView3, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindpromogoodsCrit, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:dataGridView2, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindPromoGift, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:tableLayoutPanel3:ResumeLayout(false).
        this-object:tableLayoutPanel2:ResumeLayout(false).
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindPromoCrit, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:tableLayoutPanel4:ResumeLayout(false).
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    END METHOD.

    DESTRUCTOR PUBLIC ucSelect_Items7 ( ):
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
