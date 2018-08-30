 /*------------------------------------------------------------------------
    File        : dSelectConditonItem
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mshavlov
    Created     : Fri Jul 13 12:50:25 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
  
block-level on error undo, throw.
class ibs.th.ref.promo.dSelectConditonItem inherits Form : 

    define private variable bindPromoGoodsCrit as Progress.Data.BindingSource no-undo.
    define private variable button3 as System.Windows.Forms.Button no-undo.
    define private variable button2 as System.Windows.Forms.Button no-undo.
    define private variable button1 as System.Windows.Forms.Button no-undo.
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable buttonOk as System.Windows.Forms.Button no-undo.
    define private variable buttonCancel as System.Windows.Forms.Button no-undo.
    define private variable gdscodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsNameDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable tableLayoutPanel_Basic as System.Windows.Forms.TableLayoutPanel no-undo.
    define private variable tableLayoutPanel2 as System.Windows.Forms.TableLayoutPanel no-undo.
    define private variable tableLayoutPanel1 as System.Windows.Forms.TableLayoutPanel no-undo.
    define private variable label1 as System.Windows.Forms.Label no-undo.
    define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
    
    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.
    
    
    method public void SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
    end.
    
    method public void SetBind( ):
       bindPromoGoodsCrit:handle = m-promo-trg:getQuery("PromoGoodsCrit").
    end.
    
    constructor public dSelectConditonItem( ):
    
        super().
        InitializeComponent ( ).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.        

    end constructor.

    destructor public dSelectConditonItem( ):
        bindPromoGoodsCrit:Dispose().
        if valid-object(components) then do:
            cast(components, System.IDisposable):Dispose().
        end.

    end destructor.    

    method private void okButton_Click (sender as System.Object, e as System.EventArgs):
        this-object:DialogResult = System.Windows.Forms.DialogResult:Ok.
        this-object:Close ( ). 
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
        
        this-object:components = new System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("tt-PromoGoodsCrite").
        this-object:buttonOk = new System.Windows.Forms.Button().
        this-object:buttonCancel = new System.Windows.Forms.Button().
        this-object:tableLayoutPanel_Basic = new System.Windows.Forms.TableLayoutPanel().
        this-object:label1 = new System.Windows.Forms.Label().
        this-object:tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel().
        this-object:button1 = new System.Windows.Forms.Button().
        this-object:button2 = new System.Windows.Forms.Button().
        this-object:button3 = new System.Windows.Forms.Button().
        this-object:tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel().
        this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
        this-object:bindPromoGoodsCrit = new Progress.Data.BindingSource(this-object:components).
        this-object:gdsNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:gdscodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:gdsNameDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn().
        this-object:tableLayoutPanel_Basic:SuspendLayout().
        this-object:tableLayoutPanel1:SuspendLayout().
        this-object:tableLayoutPanel2:SuspendLayout().
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindPromoGoodsCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* buttonOk */
        /*  */
        define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
        nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
        this-object:buttonOk:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        this-object:buttonOk:Location = new System.Drawing.Point(400, 3).
        this-object:buttonOk:Name = "buttonOk".
        this-object:buttonOk:Size = new System.Drawing.Size(75, 23).
        this-object:buttonOk:TabIndex = 0.
        this-object:buttonOk:Text = "OK".
        this-object:buttonOk:UseCompatibleTextRendering = true.
        this-object:buttonOk:Click:Subscribe(this-object:okButton_Click).
        /*  */
        /* buttonCancel */
        /*  */
        define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
        nestedvar1 = System.Windows.Forms.AnchorStyles:Bottom.
        this-object:buttonCancel:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        this-object:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
        this-object:buttonCancel:Location = new System.Drawing.Point(481, 3).
        this-object:buttonCancel:Name = "buttonCancel".
        this-object:buttonCancel:Size = new System.Drawing.Size(74, 23).
        this-object:buttonCancel:TabIndex = 1.
        this-object:buttonCancel:Text = "Cancel".
        this-object:buttonCancel:UseCompatibleTextRendering = true.
        this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
        /*  */
        /* tableLayoutPanel_Basic */
        /*  */
        this-object:tableLayoutPanel_Basic:ColumnCount = 1.
        this-object:tableLayoutPanel_Basic:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel_Basic:Controls:Add(this-object:label1, 0, 0).
        this-object:tableLayoutPanel_Basic:Controls:Add(this-object:tableLayoutPanel1, 0, 1).
        this-object:tableLayoutPanel_Basic:Controls:Add(this-object:tableLayoutPanel2, 0, 3).
        this-object:tableLayoutPanel_Basic:Controls:Add(this-object:dataGridView1, 0, 2).
        this-object:tableLayoutPanel_Basic:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel_Basic:Location = new System.Drawing.Point(0, 0).
        this-object:tableLayoutPanel_Basic:Name = "tableLayoutPanel_Basic".
        this-object:tableLayoutPanel_Basic:RowCount = 4.
        this-object:tableLayoutPanel_Basic:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        this-object:tableLayoutPanel_Basic:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(35))).
        this-object:tableLayoutPanel_Basic:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel_Basic:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(35))).
        this-object:tableLayoutPanel_Basic:Size = new System.Drawing.Size(564, 324).
        this-object:tableLayoutPanel_Basic:TabIndex = 3.
        /*  */
        /* label1 */
        /*  */
        this-object:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label1:Location = new System.Drawing.Point(3, 0).
        this-object:label1:Name = "label1".
        this-object:label1:Size = new System.Drawing.Size(558, 25).
        this-object:label1:TabIndex = 1.
        this-object:label1:Text = "Выбор номенклатуры для условий".
        this-object:label1:UseCompatibleTextRendering = true.
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        this-object:tableLayoutPanel1:ColumnCount = 4.
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Controls:Add(this-object:button1, 0, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:button2, 1, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:button3, 2, 0).
        this-object:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel1:Location = new System.Drawing.Point(3, 28).
        this-object:tableLayoutPanel1:Name = "tableLayoutPanel1".
        this-object:tableLayoutPanel1:RowCount = 1.
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Size = new System.Drawing.Size(558, 29).
        this-object:tableLayoutPanel1:TabIndex = 2.
        /*  */
        /* button1 */
        /*  */
        this-object:button1:Location = new System.Drawing.Point(3, 3).
        this-object:button1:Name = "button1".
        this-object:button1:Size = new System.Drawing.Size(74, 23).
        this-object:button1:TabIndex = 0.
        this-object:button1:Text = "Добавить".
        this-object:button1:UseCompatibleTextRendering = true.
        this-object:button1:UseVisualStyleBackColor = true.
        /*  */
        /* button2 */
        /*  */
        this-object:button2:Location = new System.Drawing.Point(83, 3).
        this-object:button2:Name = "button2".
        this-object:button2:Size = new System.Drawing.Size(74, 23).
        this-object:button2:TabIndex = 1.
        this-object:button2:Text = "Удалить".
        this-object:button2:UseCompatibleTextRendering = true.
        this-object:button2:UseVisualStyleBackColor = true.
        /*  */
        /* button3 */
        /*  */
        this-object:button3:Location = new System.Drawing.Point(163, 3).
        this-object:button3:Name = "button3".
        this-object:button3:Size = new System.Drawing.Size(74, 23).
        this-object:button3:TabIndex = 2.
        this-object:button3:Text = "Заполнить".
        this-object:button3:UseCompatibleTextRendering = true.
        this-object:button3:UseVisualStyleBackColor = true.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        this-object:tableLayoutPanel2:ColumnCount = 2.
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        this-object:tableLayoutPanel2:Controls:Add(this-object:buttonCancel, 1, 0).
        this-object:tableLayoutPanel2:Controls:Add(this-object:buttonOk, 0, 0).
        this-object:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel2:Location = new System.Drawing.Point(3, 292).
        this-object:tableLayoutPanel2:Name = "tableLayoutPanel2".
        this-object:tableLayoutPanel2:RowCount = 1.
        this-object:tableLayoutPanel2:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Size = new System.Drawing.Size(558, 29).
        this-object:tableLayoutPanel2:TabIndex = 0.
        /*  */
        /* dataGridView1 */
        /*  */
        this-object:dataGridView1:AllowUserToAddRows = false.
        this-object:dataGridView1:AllowUserToDeleteRows = false.
        this-object:dataGridView1:AutoGenerateColumns = false.
        this-object:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 2 no-undo.
        arrayvar0[1] = this-object:gdscodeDataGridViewTextBoxColumn.
        arrayvar0[2] = this-object:gdsNameDataGridViewTextBoxColumn1.
        this-object:dataGridView1:Columns:AddRange(arrayvar0).
        this-object:dataGridView1:DataSource = this-object:bindPromoGoodsCrit.
        this-object:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:dataGridView1:Location = new System.Drawing.Point(3, 63).
        this-object:dataGridView1:Name = "dataGridView1".
        this-object:dataGridView1:ReadOnly = true.
        this-object:dataGridView1:Size = new System.Drawing.Size(558, 223).
        this-object:dataGridView1:TabIndex = 3.
        /*  */
        /* bindPromoGoodsCrit */
        /*  */
        this-object:bindPromoGoodsCrit:MaxDataGuess = 0.
        this-object:bindPromoGoodsCrit:NoLOBs = false.
        this-object:bindPromoGoodsCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar1 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 2 no-undo.
        arrayvar2[1] = new Progress.Data.ColumnPropDesc("gdsName", "", Progress.Data.DataType:CHARACTER).
        arrayvar2[2] = new Progress.Data.ColumnPropDesc("gds-code", "gds-code", Progress.Data.DataType:INTEGER).
        tableDesc1:Columns = arrayvar2.
        this-object:bindPromoGoodsCrit:TableSchema = tableDesc1.
        /*  */
        /* gdsNameDataGridViewTextBoxColumn */
        /*  */
        this-object:gdsNameDataGridViewTextBoxColumn:DataPropertyName = "gdsName".
        this-object:gdsNameDataGridViewTextBoxColumn:HeaderText = "Номенклатура".
        this-object:gdsNameDataGridViewTextBoxColumn:Name = "gdsNameDataGridViewTextBoxColumn".
        this-object:gdsNameDataGridViewTextBoxColumn:Width = 515.
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
        /* dSelectConditonItem */
        /*  */
        this-object:AcceptButton = this-object:buttonOk.
        this-object:CancelButton = this-object:buttonCancel.
        this-object:ClientSize = new System.Drawing.Size(564, 324).
        this-object:Controls:Add(this-object:tableLayoutPanel_Basic).
        this-object:MaximizeBox = false.
        this-object:MinimizeBox = false.
        this-object:Name = "dSelectConditonItem".
        this-object:ShowInTaskbar = false.
        this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
        this-object:Text = "Независимые условия".
        this-object:tableLayoutPanel_Basic:ResumeLayout(false).
        this-object:tableLayoutPanel1:ResumeLayout(false).
        this-object:tableLayoutPanel2:ResumeLayout(false).
        cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindPromoGoodsCrit, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end method. 
 
    method public void ShowModalDialog(  ):
        
        wait-for this-object:ShowDialog().

    end method.


 
end class.
