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
using Progress.Lang.*.
using Progress.Windows.UserControl.

block-level on error undo, throw.

class ibs.th.ref.promo.uc_TabTypePay inherits UserControl: 
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Просмотр/редактирование одной акции". 
  /* --- end_of для cmp/vssrevis.i --- */
    
    define private variable bindPromoPay as Progress.Data.BindingSource no-undo.
    define private variable button2 as System.Windows.Forms.Button no-undo.
    define private variable button1 as System.Windows.Forms.Button no-undo.
    define private variable cdpaycodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable currcodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.

    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.
    define private variable paycodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable objnameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable tableLayoutPanel2 as System.Windows.Forms.TableLayoutPanel no-undo.
    define private variable tableLayoutPanel1 as System.Windows.Forms.TableLayoutPanel no-undo.

    method public void SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
    end.
    
    method public void SetBind( ):
         bindPromoPay:handle      = m-promo-trg:getQuery("PromoPay").
    end.

        
    constructor public uc_TabTypePay (  ):
        
        
        super().
        InitializeComponent().
        this-object:ComponentsCollection:ADD(this-object:components).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.

    end constructor.

    method private void InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("tt-CashPay").
        this-object:tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel().
        this-object:tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button2 = new System.Windows.Forms.Button().
        this-object:button1 = new System.Windows.Forms.Button().
        this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
        this-object:cdpaycodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:objnameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:currcodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:paycodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:bindPromoPay = new Progress.Data.BindingSource(this-object:components).
        this-object:tableLayoutPanel1:SuspendLayout().
        this-object:tableLayoutPanel2:SuspendLayout().
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindPromoPay, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        this-object:tableLayoutPanel1:ColumnCount = 1.
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel2, 0, 1).
        this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView1, 0, 2).
        this-object:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel1:Location = new System.Drawing.Point(0, 0).
        this-object:tableLayoutPanel1:Name = "tableLayoutPanel1".
        this-object:tableLayoutPanel1:RowCount = 3.
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(7))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Size = new System.Drawing.Size(734, 291).
        this-object:tableLayoutPanel1:TabIndex = 5.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        this-object:tableLayoutPanel2:ColumnCount = 4.
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button2, 1, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:button1, 0, 0).
        this-object:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel2:Location = new System.Drawing.Point(3, 7).
        this-object:tableLayoutPanel2:Margin = new System.Windows.Forms.Padding(3, 0, 0, 0).
        this-object:tableLayoutPanel2:Name = "tableLayoutPanel2".
        this-object:tableLayoutPanel2:RowCount = 1.
        this-object:tableLayoutPanel2:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Size = new System.Drawing.Size(731, 25).
        this-object:tableLayoutPanel2:TabIndex = 0.
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
        this-object:dataGridView1:AllowUserToOrderColumns = true.
        this-object:dataGridView1:AutoGenerateColumns = false.
        this-object:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 4 no-undo.
        arrayvar0[1] = this-object:cdpaycodeDataGridViewTextBoxColumn.
        arrayvar0[2] = this-object:objnameDataGridViewTextBoxColumn.
        arrayvar0[3] = this-object:currcodeDataGridViewTextBoxColumn.
        arrayvar0[4] = this-object:paycodeDataGridViewTextBoxColumn.
        this-object:dataGridView1:Columns:AddRange(arrayvar0).
        this-object:dataGridView1:DataSource = this-object:bindPromoPay.
        this-object:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView1:Location = new System.Drawing.Point(3, 35).
        this-object:dataGridView1:Name = "dataGridView1".
        this-object:dataGridView1:ReadOnly = true.
        this-object:dataGridView1:Size = new System.Drawing.Size(728, 253).
        this-object:dataGridView1:TabIndex = 2.
        /*  */
        /* cdpaycodeDataGridViewTextBoxColumn */
        /*  */
        this-object:cdpaycodeDataGridViewTextBoxColumn:DataPropertyName = "cdpay-code".
        this-object:cdpaycodeDataGridViewTextBoxColumn:HeaderText = "Код".
        this-object:cdpaycodeDataGridViewTextBoxColumn:Name = "cdpaycodeDataGridViewTextBoxColumn".
        this-object:cdpaycodeDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* objnameDataGridViewTextBoxColumn */
        /*  */
        this-object:objnameDataGridViewTextBoxColumn:DataPropertyName = "obj-name".
        this-object:objnameDataGridViewTextBoxColumn:HeaderText = "Название".
        this-object:objnameDataGridViewTextBoxColumn:Name = "objnameDataGridViewTextBoxColumn".
        this-object:objnameDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* currcodeDataGridViewTextBoxColumn */
        /*  */
        this-object:currcodeDataGridViewTextBoxColumn:DataPropertyName = "curr-code".
        this-object:currcodeDataGridViewTextBoxColumn:HeaderText = "Код валюты".
        this-object:currcodeDataGridViewTextBoxColumn:Name = "currcodeDataGridViewTextBoxColumn".
        this-object:currcodeDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* paycodeDataGridViewTextBoxColumn */
        /*  */
        this-object:paycodeDataGridViewTextBoxColumn:DataPropertyName = "pay-code".
        this-object:paycodeDataGridViewTextBoxColumn:HeaderText = "Оплата".
        this-object:paycodeDataGridViewTextBoxColumn:Name = "paycodeDataGridViewTextBoxColumn".
        this-object:paycodeDataGridViewTextBoxColumn:ReadOnly = true.
        /*  */
        /* bindPromoPay */
        /*  */
        this-object:bindPromoPay:MaxDataGuess = 0.
        this-object:bindPromoPay:NoLOBs = false.
        this-object:bindPromoPay:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar1 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 4 no-undo.
        arrayvar2[1] = new Progress.Data.ColumnPropDesc("cdpay-code", "Код", Progress.Data.DataType:INTEGER).
        arrayvar2[2] = new Progress.Data.ColumnPropDesc("curr-code", "Код валюты", Progress.Data.DataType:INTEGER).
        arrayvar2[3] = new Progress.Data.ColumnPropDesc("obj-name", "Название", Progress.Data.DataType:CHARACTER).
        arrayvar2[4] = new Progress.Data.ColumnPropDesc("pay-code", "Оплата", Progress.Data.DataType:INTEGER).
        tableDesc1:Columns = arrayvar2.
        this-object:bindPromoPay:TableSchema = tableDesc1.
        /*  */
        /* uc_TabTypePay */
        /*  */
        this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        this-object:Controls:Add(this-object:tableLayoutPanel1).
        this-object:Name = "uc_TabTypePay".
        this-object:Size = new System.Drawing.Size(734, 291).
        this-object:tableLayoutPanel1:ResumeLayout(false).
        this-object:tableLayoutPanel2:ResumeLayout(false).
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindPromoPay, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method.

    destructor public uc_TabTypePay ( ):
           if valid-object(m-promo-trg) then closeBind().
    end destructor.
    
    method private void closeBind():
        if  dataGridView1:SelectedCells:Count > 0
        then
            dataGridView1:SelectedCells[0]:Selected = true.
        bindPromoPay:Assign().
        bindPromoPay:Dispose().
 
    end.

end class.
