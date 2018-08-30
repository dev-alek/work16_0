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

CLASS ibs.th.ref.promo.ucSelect_Items2_1 INHERITS UserControl: 
    define private variable gdscodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsNameDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Просмотр/редактирование одной акции". 
  /* --- end_of для cmp/vssrevis.i --- */
    
    define private variable bindpromoCrit as Progress.Data.BindingSource no-undo.
    define private variable bindPromoGoodsAPPl as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE button5 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button4 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button3 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button2 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    define private variable spanDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable mincritDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable discontDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE tableLayoutPanel3 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE label2 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView2 AS System.Windows.Forms.DataGridView NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.

    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.
    
    
    method Public VOID SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
    end.
    
    method Public VOID SetBind( ):
          bindPromoGoodsAPPl:handle = m-promo-trg:getQuery("PromoGoodsAppl").
          bindpromoCrit:handle      = m-promo-trg:getQuery("PromoCriterion").
       // bindPromoActionOne:handle = m-promo-trg:getQuery("promoActionOne2").
      /*  message valid-object(bindPromoActionOne:handle)
        view-as alert-box.*/
    end.

        
    CONSTRUCTOR PUBLIC ucSelect_Items2_1 (  ):
        
        
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
        define variable tableDesc4 as Progress.Data.TableDesc no-undo.
        tableDesc4 = new Progress.Data.TableDesc("tt-PromoCriterion").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc3 as Progress.Data.TableDesc no-undo.
        tableDesc3 = new Progress.Data.TableDesc("tt-PromoGoodsAppl").
        this-object:tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel().
        this-object:dataGridView2 = new System.Windows.Forms.DataGridView().
        this-object:mincritDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:discontDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:spanDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:bindpromoCrit = new Progress.Data.BindingSource(this-object:components).
        this-object:tableLayoutPanel3 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button5 = new System.Windows.Forms.Button().
        this-object:button4 = new System.Windows.Forms.Button().
        this-object:tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button3 = new System.Windows.Forms.Button().
        this-object:button2 = new System.Windows.Forms.Button().
        this-object:button1 = new System.Windows.Forms.Button().
        this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
        this-object:bindPromoGoodsAPPl = new Progress.Data.BindingSource(this-object:components).
        this-object:label1 = new System.Windows.Forms.Label().
        this-object:label2 = new System.Windows.Forms.Label().
        this-object:gdsNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:gdscodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:gdsNameDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:tableLayoutPanel1:SuspendLayout().
        cast(this-object:dataGridView2, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindpromoCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:tableLayoutPanel3:SuspendLayout().
        this-object:tableLayoutPanel2:SuspendLayout().
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindPromoGoodsAPPl, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        this-object:tableLayoutPanel1:ColumnCount = 2.
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView2, 1, 2).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel3, 1, 1).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel2, 0, 1).
        this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView1, 0, 2).
        this-object:tableLayoutPanel1:Controls:Add(this-object:label1, 0, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:label2, 1, 0).
        this-object:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel1:Location = new System.Drawing.Point(0, 0).
        this-object:tableLayoutPanel1:Name = "tableLayoutPanel1".
        this-object:tableLayoutPanel1:RowCount = 3.
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Size = new System.Drawing.Size(700, 287).
        this-object:tableLayoutPanel1:TabIndex = 2.
        /*  */
        /* dataGridView2 */
        /*  */
        this-object:dataGridView2:AllowUserToAddRows = false.
        this-object:dataGridView2:AllowUserToDeleteRows = false.
        this-object:dataGridView2:AutoGenerateColumns = false.
        this-object:dataGridView2:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        this-object:dataGridView2:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 3 no-undo.
        arrayvar0[1] = this-object:mincritDataGridViewTextBoxColumn.
        arrayvar0[2] = this-object:discontDataGridViewTextBoxColumn.
        arrayvar0[3] = this-object:spanDataGridViewTextBoxColumn.
        this-object:dataGridView2:Columns:AddRange(arrayvar0).
        this-object:dataGridView2:DataSource = this-object:bindpromoCrit.
        this-object:dataGridView2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView2:Location = new System.Drawing.Point(353, 53).
        this-object:dataGridView2:Name = "dataGridView2".
        this-object:dataGridView2:ReadOnly = true.
        this-object:dataGridView2:Size = new System.Drawing.Size(344, 231).
        this-object:dataGridView2:TabIndex = 3.
        /*  */
        /* mincritDataGridViewTextBoxColumn */
        /*  */
        this-object:mincritDataGridViewTextBoxColumn:DataPropertyName = "mincrit".
        this-object:mincritDataGridViewTextBoxColumn:HeaderText = "Сумма, руб".
        this-object:mincritDataGridViewTextBoxColumn:Name = "mincritDataGridViewTextBoxColumn".
        this-object:mincritDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* discontDataGridViewTextBoxColumn */
        /*  */
        this-object:discontDataGridViewTextBoxColumn:DataPropertyName = "discont".
        this-object:discontDataGridViewTextBoxColumn:HeaderText = "Скидки, Руб".
        this-object:discontDataGridViewTextBoxColumn:Name = "discontDataGridViewTextBoxColumn".
        this-object:discontDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* spanDataGridViewTextBoxColumn */
        /*  */
        this-object:spanDataGridViewTextBoxColumn:DataPropertyName = "span".
        this-object:spanDataGridViewTextBoxColumn:HeaderText = "Диапозон действия".
        this-object:spanDataGridViewTextBoxColumn:Name = "spanDataGridViewTextBoxColumn".
        this-object:spanDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindpromoCrit */
        /*  */
        this-object:bindpromoCrit:MaxDataGuess = 0.
        this-object:bindpromoCrit:NoLOBs = false.
        this-object:bindpromoCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar1 = new "Progress.Data.TableDesc[]"(0).
        tableDesc4:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 3 no-undo.
        arrayvar2[1] = new Progress.Data.ColumnPropDesc("span", "", Progress.Data.DataType:CHARACTER).
        arrayvar2[2] = new Progress.Data.ColumnPropDesc("discont", "знач. скидки", Progress.Data.DataType:DECIMAL).
        arrayvar2[3] = new Progress.Data.ColumnPropDesc("mincrit", "минимальное значение критерия", Progress.Data.DataType:DECIMAL).
        tableDesc4:Columns = arrayvar2.
        this-object:bindpromoCrit:TableSchema = tableDesc4.
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
        this-object:tableLayoutPanel3:Location = new System.Drawing.Point(353, 25).
        this-object:tableLayoutPanel3:Margin = new System.Windows.Forms.Padding(3, 0, 0, 0).
        this-object:tableLayoutPanel3:Name = "tableLayoutPanel3".
        this-object:tableLayoutPanel3:RowCount = 1.
        this-object:tableLayoutPanel3:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel3:Size = new System.Drawing.Size(347, 25).
        this-object:tableLayoutPanel3:TabIndex = 1.
        /*  */
        /* button5 */
        /*  */
        this-object:button5:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:button5:Location = new System.Drawing.Point(86, 0).
        this-object:button5:Margin = new System.Windows.Forms.Padding(0).
        this-object:button5:Name = "button5".
        this-object:button5:Size = new System.Drawing.Size(86, 25).
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
        this-object:button4:Size = new System.Drawing.Size(86, 25).
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
        this-object:tableLayoutPanel2:Size = new System.Drawing.Size(347, 25).
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
        define variable arrayvar3 as System.Windows.Forms.DataGridViewColumn extent 2 no-undo.
        arrayvar3[1] = this-object:gdscodeDataGridViewTextBoxColumn.
        arrayvar3[2] = this-object:gdsNameDataGridViewTextBoxColumn1.
        this-object:dataGridView1:Columns:AddRange(arrayvar3).
        this-object:dataGridView1:DataSource = this-object:bindPromoGoodsAPPl.
        this-object:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView1:Location = new System.Drawing.Point(3, 53).
        this-object:dataGridView1:Name = "dataGridView1".
        this-object:dataGridView1:ReadOnly = true.
        this-object:dataGridView1:Size = new System.Drawing.Size(344, 231).
        this-object:dataGridView1:TabIndex = 2.
        /*  */
        /* bindPromoGoodsAPPl */
        /*  */
        this-object:bindPromoGoodsAPPl:MaxDataGuess = 0.
        this-object:bindPromoGoodsAPPl:NoLOBs = false.
        this-object:bindPromoGoodsAPPl:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar4 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar4 = new "Progress.Data.TableDesc[]"(0).
        tableDesc3:ChildTables = arrayvar4.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar5 as Progress.Data.ColumnPropDesc extent 2 no-undo.
        arrayvar5[1] = new Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        arrayvar5[2] = new Progress.Data.ColumnPropDesc("gds-code", "gds-code", Progress.Data.DataType:INTEGER).
        tableDesc3:Columns = arrayvar5.
        this-object:bindPromoGoodsAPPl:TableSchema = tableDesc3.
        /*  */
        /* label1 */
        /*  */
        this-object:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label1:Location = new System.Drawing.Point(3, 0).
        this-object:label1:Name = "label1".
        this-object:label1:Size = new System.Drawing.Size(344, 25).
        this-object:label1:TabIndex = 4.
        this-object:label1:Text = "Товар".
        this-object:label1:UseCompatibleTextRendering = true.
        /*  */
        /* label2 */
        /*  */
        this-object:label2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:label2:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label2:Location = new System.Drawing.Point(353, 0).
        this-object:label2:Name = "label2".
        this-object:label2:Size = new System.Drawing.Size(344, 25).
        this-object:label2:TabIndex = 5.
        this-object:label2:Text = "Условия".
        this-object:label2:UseCompatibleTextRendering = true.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn */
        /*  */
        this-object:gdsNameDataGridViewTextBoxColumn:DataPropertyName = "gdsName".
        this-object:gdsNameDataGridViewTextBoxColumn:HeaderText = "Номенклатура".
        this-object:gdsNameDataGridViewTextBoxColumn:Name = "gdsNameDataGridViewTextBoxColumn".
        this-object:gdsNameDataGridViewTextBoxColumn:Width = 301.
        /*  */
        /* gdscodeDataGridViewTextBoxColumn */
        /*  */
        this-object:gdscodeDataGridViewTextBoxColumn:DataPropertyName = "gds-code".
        this-object:gdscodeDataGridViewTextBoxColumn:FillWeight = Progress.Util.CastUtil:ToSingle(55.8375626).
        this-object:gdscodeDataGridViewTextBoxColumn:HeaderText = "Код товара".
        this-object:gdscodeDataGridViewTextBoxColumn:Name = "gdscodeDataGridViewTextBoxColumn".
        this-object:gdscodeDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn1 */
        /*  */
        this-object:gdsNameDataGridViewTextBoxColumn1:DataPropertyName = "gdsName".
        this-object:gdsNameDataGridViewTextBoxColumn1:FillWeight = Progress.Util.CastUtil:ToSingle(144.1624451).
        this-object:gdsNameDataGridViewTextBoxColumn1:HeaderText = "Номенклатура".
        this-object:gdsNameDataGridViewTextBoxColumn1:Name = "gdsNameDataGridViewTextBoxColumn1".
        this-object:gdsNameDataGridViewTextBoxColumn1:ReadOnly = true.
        /*  */
        /* ucSelect_Items2_1 */
        /*  */
        this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        this-object:Controls:Add(this-object:tableLayoutPanel1).
        this-object:Name = "ucSelect_Items2_1".
        this-object:Size = new System.Drawing.Size(700, 287).
        this-object:tableLayoutPanel1:ResumeLayout(false).
        cast(this-object:dataGridView2, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindpromoCrit, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:tableLayoutPanel3:ResumeLayout(false).
        this-object:tableLayoutPanel2:ResumeLayout(false).
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindPromoGoodsAPPl, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    END METHOD.

    DESTRUCTOR PUBLIC ucSelect_Items2_1 ( ):
          if valid-object(m-promo-trg) then closeBind().
    END DESTRUCTOR.
    
    method private void closeBind():
        if  dataGridView1:SelectedCells:Count > 0
        then
            dataGridView1:SelectedCells[0]:Selected = true.
        if  dataGridView2:SelectedCells:Count > 0
        then
            dataGridView2:SelectedCells[0]:Selected = true.
        bindPromoGoodsAPPl   :Assign().
        bindpromoCrit        :Assign().
        bindPromoGoodsAPPl   :Dispose().
        bindpromoCrit        :Dispose().
 
    end.
END CLASS.
