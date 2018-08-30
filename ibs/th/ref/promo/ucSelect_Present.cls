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
 
CLASS ibs.th.ref.promo.ucSelect_Present INHERITS UserControl: 
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Просмотр/редактирование одной акции". 
  /* --- end_of для cmp/vssrevis.i --- */
    
    define private variable bindPromoGift as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE button3 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button2 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.
    define private variable qntyDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE tableLayoutPanel3 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.

    method Public VOID SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
    end.
    
    method Public VOID SetBind( ):
         bindPromoGift:handle      = m-promo-trg:getQuery("PromoGiftForAction").
    end.

        
    CONSTRUCTOR PUBLIC ucSelect_Present (  ):
        
        
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
        DEFINE VARIABLE tableDesc1 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc1 = NEW Progress.Data.TableDesc("tt-PromoGift").
        THIS-OBJECT:tableLayoutPanel2 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:tableLayoutPanel3 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:button3 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button2 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:dataGridView1 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:qntyDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:bindPromoGift = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:tableLayoutPanel2:SuspendLayout().
        THIS-OBJECT:tableLayoutPanel3:SuspendLayout().
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:bindPromoGift, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        THIS-OBJECT:tableLayoutPanel2:ColumnCount = 1.
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:tableLayoutPanel3, 0, 0).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:dataGridView1, 0, 1).
        THIS-OBJECT:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel2:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:tableLayoutPanel2:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:tableLayoutPanel2:Name = "tableLayoutPanel2".
        THIS-OBJECT:tableLayoutPanel2:RowCount = 2.
        THIS-OBJECT:tableLayoutPanel2:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel2:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Size = NEW System.Drawing.Size(545, 238).
        THIS-OBJECT:tableLayoutPanel2:TabIndex = 4.
        /*  */
        /* tableLayoutPanel3 */
        /*  */
        THIS-OBJECT:tableLayoutPanel3:ColumnCount = 4.
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
        THIS-OBJECT:tableLayoutPanel3:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel3:Controls:Add(THIS-OBJECT:button3, 2, 0).
        THIS-OBJECT:tableLayoutPanel3:Controls:Add(THIS-OBJECT:button2, 1, 0).
        THIS-OBJECT:tableLayoutPanel3:Controls:Add(THIS-OBJECT:button1, 0, 0).
        THIS-OBJECT:tableLayoutPanel3:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel3:Location = NEW System.Drawing.Point(3, 0).
        THIS-OBJECT:tableLayoutPanel3:Margin = NEW System.Windows.Forms.Padding(3, 0, 0, 0).
        THIS-OBJECT:tableLayoutPanel3:Name = "tableLayoutPanel3".
        THIS-OBJECT:tableLayoutPanel3:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel3:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel3:Size = NEW System.Drawing.Size(542, 25).
        THIS-OBJECT:tableLayoutPanel3:TabIndex = 0.
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
        DEFINE VARIABLE arrayvar0 AS System.Windows.Forms.DataGridViewColumn EXTENT 2 NO-UNDO.
        arrayvar0[1] = THIS-OBJECT:gdsNameDataGridViewTextBoxColumn.
        arrayvar0[2] = THIS-OBJECT:qntyDataGridViewTextBoxColumn.
        THIS-OBJECT:dataGridView1:Columns:AddRange(arrayvar0).
        THIS-OBJECT:dataGridView1:DataSource = THIS-OBJECT:bindPromoGift.
        THIS-OBJECT:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:dataGridView1:Location = NEW System.Drawing.Point(3, 28).
        THIS-OBJECT:dataGridView1:Name = "dataGridView1".
        THIS-OBJECT:dataGridView1:ReadOnly = true.
        THIS-OBJECT:dataGridView1:Size = NEW System.Drawing.Size(539, 207).
        THIS-OBJECT:dataGridView1:TabIndex = 2.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:DataPropertyName = "gdsName".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:HeaderText = "Номенклатура".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:Name = "gdsNameDataGridViewTextBoxColumn".
        THIS-OBJECT:gdsNameDataGridViewTextBoxColumn:ReadOnly = true.
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
        DEFINE VARIABLE arrayvar1 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar1 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar2 AS Progress.Data.ColumnPropDesc EXTENT 2 NO-UNDO.
        arrayvar2[1] = NEW Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        arrayvar2[2] = NEW Progress.Data.ColumnPropDesc("qnty", "кол-во", Progress.Data.DataType:DECIMAL).
        tableDesc1:Columns = arrayvar2.
        THIS-OBJECT:bindPromoGift:TableSchema = tableDesc1.
        /*  */
        /* ucSelect_Present */
        /*  */
        THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel2).
        THIS-OBJECT:Name = "ucSelect_Present".
        THIS-OBJECT:Size = NEW System.Drawing.Size(545, 238).
        THIS-OBJECT:tableLayoutPanel2:ResumeLayout(false).
        THIS-OBJECT:tableLayoutPanel3:ResumeLayout(false).
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:bindPromoGift, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:ResumeLayout(false).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END METHOD.

    DESTRUCTOR PUBLIC ucSelect_Present ( ):
        if valid-object(m-promo-trg) then closeBind().
    END DESTRUCTOR.
    
    method private void closeBind():
        if  dataGridView1:SelectedCells:Count >0
        then
            dataGridView1:SelectedCells[0]:Selected = true.
       // dataGridView2:SelectedCells[0]:Selected = true.
       // dataGridView3:SelectedCells[0]:Selected = true.
        bindPromoGift:assign().
        bindPromoGift:Dispose().    
    end.    
END CLASS.