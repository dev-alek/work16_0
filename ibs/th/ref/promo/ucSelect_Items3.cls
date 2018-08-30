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

CLASS ibs.th.ref.promo.ucSelect_Items3 INHERITS UserControl: 
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Просмотр/редактирование одной акции". 
  /* --- end_of для cmp/vssrevis.i --- */
    
    define private variable bindPromoGoodsAppl as Progress.Data.BindingSource no-undo.
    define private variable bindPromoCrit as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE button3 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button2 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    define private variable gdsNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE label2 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label3 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.

    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.
    DEFINE PRIVATE VARIABLE textBox2 AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE textBox1 AS System.Windows.Forms.TextBox NO-UNDO.
    
    
    method Public VOID SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
    end.
    
    method Public VOID SetBind( ):
        bindPromoGoodsAppl:handle = m-promo-trg:getQuery("PromoGoodsAppl").
        bindPromoCrit:handle           = m-promo-trg:getQuery("PromoCriterionOne").
    end.
    

        
    CONSTRUCTOR PUBLIC ucSelect_Items3 (  ):
        
        
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
        tableDesc1 = new Progress.Data.TableDesc("tt-PromoCriterion").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc2 as Progress.Data.TableDesc no-undo.
        tableDesc2 = new Progress.Data.TableDesc("tt-PromoGoodsAppl").
        this-object:tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel().
        this-object:label1 = new System.Windows.Forms.Label().
        this-object:tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button3 = new System.Windows.Forms.Button().
        this-object:button2 = new System.Windows.Forms.Button().
        this-object:button1 = new System.Windows.Forms.Button().
        this-object:label2 = new System.Windows.Forms.Label().
        this-object:textBox1 = new System.Windows.Forms.TextBox().
        this-object:bindPromoCrit = new Progress.Data.BindingSource(this-object:components).
        this-object:textBox2 = new System.Windows.Forms.TextBox().
        this-object:label3 = new System.Windows.Forms.Label().
        this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
        this-object:gdsNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:bindPromoGoodsAppl = new Progress.Data.BindingSource(this-object:components).
        this-object:tableLayoutPanel1:SuspendLayout().
        this-object:tableLayoutPanel2:SuspendLayout().
        cast(this-object:bindPromoCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindPromoGoodsAppl, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        this-object:tableLayoutPanel1:ColumnCount = 1.
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
        this-object:tableLayoutPanel1:Controls:Add(this-object:label1, 0, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel2, 0, 1).
        this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView1, 0, 2).
        this-object:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel1:Location = new System.Drawing.Point(0, 0).
        this-object:tableLayoutPanel1:Name = "tableLayoutPanel1".
        this-object:tableLayoutPanel1:RowCount = 3.
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Size = new System.Drawing.Size(654, 302).
        this-object:tableLayoutPanel1:TabIndex = 3.
        /*  */
        /* label1 */
        /*  */
        this-object:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label1:Location = new System.Drawing.Point(3, 0).
        this-object:label1:Name = "label1".
        this-object:label1:Size = new System.Drawing.Size(648, 25).
        this-object:label1:TabIndex = 5.
        this-object:label1:Text = "Товар".
        this-object:label1:UseCompatibleTextRendering = true.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        this-object:tableLayoutPanel2:ColumnCount = 9.
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(70))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(70))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(70))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(40))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(70))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button3, 2, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button2, 1, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button1, 0, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:label2, 4, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:textBox1, 5, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:textBox2, 7, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:label3, 6, 0).
        this-object:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel2:Location = new System.Drawing.Point(3, 25).
        this-object:tableLayoutPanel2:Margin = new System.Windows.Forms.Padding(3, 0, 0, 0).
        this-object:tableLayoutPanel2:Name = "tableLayoutPanel2".
        this-object:tableLayoutPanel2:RowCount = 1.
        this-object:tableLayoutPanel2:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Size = new System.Drawing.Size(651, 25).
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
        /* label2 */
        /*  */
        this-object:label2:Location = new System.Drawing.Point(353, 3).
        this-object:label2:Margin = new System.Windows.Forms.Padding(3).
        this-object:label2:Name = "label2".
        this-object:label2:Size = new System.Drawing.Size(64, 19).
        this-object:label2:TabIndex = 3.
        this-object:label2:Text = "Бесплатно".
        this-object:label2:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
        this-object:label2:UseCompatibleTextRendering = true.
        /*  */
        /* textBox1 */
        /*  */
        this-object:textBox1:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindPromoCrit, "discont", true)).
        this-object:textBox1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:textBox1:Location = new System.Drawing.Point(423, 3).
        this-object:textBox1:Name = "textBox1".
        this-object:textBox1:Size = new System.Drawing.Size(64, 20).
        this-object:textBox1:TabIndex = 4.
        /*  */
        /* bindPromoCrit */
        /*  */
        this-object:bindPromoCrit:MaxDataGuess = 0.
        this-object:bindPromoCrit:NoLOBs = false.
        this-object:bindPromoCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar0 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 2 no-undo.
        arrayvar1[1] = new Progress.Data.ColumnPropDesc("discont", "знач. скидки", Progress.Data.DataType:DECIMAL).
        arrayvar1[2] = new Progress.Data.ColumnPropDesc("mincrit", "минимальное значение критерия", Progress.Data.DataType:DECIMAL).
        tableDesc1:Columns = arrayvar1.
        this-object:bindPromoCrit:TableSchema = tableDesc1.
        /*  */
        /* textBox2 */
        /*  */
        this-object:textBox2:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindPromoCrit, "mincrit", true)).
        this-object:textBox2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:textBox2:Location = new System.Drawing.Point(533, 3).
        this-object:textBox2:Name = "textBox2".
        this-object:textBox2:Size = new System.Drawing.Size(64, 20).
        this-object:textBox2:TabIndex = 5.
        /*  */
        /* label3 */
        /*  */
        this-object:label3:Location = new System.Drawing.Point(493, 0).
        this-object:label3:Name = "label3".
        this-object:label3:Size = new System.Drawing.Size(34, 23).
        this-object:label3:TabIndex = 6.
        this-object:label3:Text = "из".
        this-object:label3:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
        this-object:label3:UseCompatibleTextRendering = true.
        /*  */
        /* dataGridView1 */
        /*  */
        this-object:dataGridView1:AllowUserToAddRows = false.
        this-object:dataGridView1:AllowUserToDeleteRows = false.
        this-object:dataGridView1:AutoGenerateColumns = false.
        this-object:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as System.Windows.Forms.DataGridViewColumn extent 1 no-undo.
        arrayvar2[1] = this-object:gdsNameDataGridViewTextBoxColumn.
        this-object:dataGridView1:Columns:AddRange(arrayvar2).
        this-object:dataGridView1:DataSource = this-object:bindPromoGoodsAppl.
        this-object:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView1:Location = new System.Drawing.Point(3, 53).
        this-object:dataGridView1:Name = "dataGridView1".
        this-object:dataGridView1:ReadOnly = true.
        this-object:dataGridView1:Size = new System.Drawing.Size(648, 246).
        this-object:dataGridView1:TabIndex = 2.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn */
        /*  */
        this-object:gdsNameDataGridViewTextBoxColumn:DataPropertyName = "gdsName".
        this-object:gdsNameDataGridViewTextBoxColumn:HeaderText = "Номенклатура".
        this-object:gdsNameDataGridViewTextBoxColumn:Name = "gdsNameDataGridViewTextBoxColumn".
        this-object:gdsNameDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindPromoGoodsAppl */
        /*  */
        this-object:bindPromoGoodsAppl:MaxDataGuess = 0.
        this-object:bindPromoGoodsAppl:NoLOBs = false.
        this-object:bindPromoGoodsAppl:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar3 = new "Progress.Data.TableDesc[]"(0).
        tableDesc2:ChildTables = arrayvar3.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as Progress.Data.ColumnPropDesc extent 1 no-undo.
        arrayvar4[1] = new Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        tableDesc2:Columns = arrayvar4.
        this-object:bindPromoGoodsAppl:TableSchema = tableDesc2.
        /*  */
        /* ucSelect_Items3 */
        /*  */
        this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        this-object:Controls:Add(this-object:tableLayoutPanel1).
        this-object:Name = "ucSelect_Items3".
        this-object:Size = new System.Drawing.Size(654, 302).
        this-object:tableLayoutPanel1:ResumeLayout(false).
        this-object:tableLayoutPanel2:ResumeLayout(false).
        this-object:tableLayoutPanel2:PerformLayout().
        cast(this-object:bindPromoCrit, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindPromoGoodsAppl, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    END METHOD.

    DESTRUCTOR PUBLIC ucSelect_Items3 ( ):
        if valid-object(m-promo-trg) then closeBind().
    END DESTRUCTOR.
    
    method private void closeBind():
        if  dataGridView1:SelectedCells:Count > 0
        then
            dataGridView1:SelectedCells[0]:Selected = true.
        bindPromoGoodsAppl   :Assign().
        bindPromoCrit        :Assign().
        bindPromoGoodsAppl   :Dispose().
        bindPromoCrit        :Dispose().
 
    end.
END CLASS.
