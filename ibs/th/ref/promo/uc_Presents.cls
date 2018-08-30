 
 /*------------------------------------------------------------------------
    File        : uc_Presents
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mshavlov
    Created     : Tue Jul 31 13:27:18 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Windows.UserControl.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ibs.th.ref.promo.uc_Presents INHERITS UserControl: 
    
    DEFINE PRIVATE VARIABLE button2 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.

        
    CONSTRUCTOR PUBLIC uc_Presents (  ):
        
        
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
        THIS-OBJECT:dataGridView1 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:tableLayoutPanel2 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:button2 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:tableLayoutPanel1:SuspendLayout().
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:tableLayoutPanel2:SuspendLayout().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        THIS-OBJECT:tableLayoutPanel1:ColumnCount = 1.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:dataGridView1, 0, 2).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:tableLayoutPanel2, 0, 1).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label1, 0, 0).
        THIS-OBJECT:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:tableLayoutPanel1:Name = "tableLayoutPanel1".
        THIS-OBJECT:tableLayoutPanel1:RowCount = 3.
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel1:Size = NEW System.Drawing.Size(500, 400).
        THIS-OBJECT:tableLayoutPanel1:TabIndex = 5.
        /*  */
        /* dataGridView1 */
        /*  */
        THIS-OBJECT:dataGridView1:AllowUserToAddRows = false.
        THIS-OBJECT:dataGridView1:AllowUserToDeleteRows = false.
        THIS-OBJECT:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
        THIS-OBJECT:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        THIS-OBJECT:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:dataGridView1:Location = NEW System.Drawing.Point(3, 53).
        THIS-OBJECT:dataGridView1:Name = "dataGridView1".
        THIS-OBJECT:dataGridView1:ReadOnly = true.
        THIS-OBJECT:dataGridView1:Size = NEW System.Drawing.Size(494, 344).
        THIS-OBJECT:dataGridView1:TabIndex = 8.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        THIS-OBJECT:tableLayoutPanel2:ColumnCount = 4.
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
        THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:button2, 1, 0).
        THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:button1, 0, 0).
        THIS-OBJECT:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:tableLayoutPanel2:Location = NEW System.Drawing.Point(3, 25).
        THIS-OBJECT:tableLayoutPanel2:Margin = NEW System.Windows.Forms.Padding(3, 0, 0, 0).
        THIS-OBJECT:tableLayoutPanel2:Name = "tableLayoutPanel2".
        THIS-OBJECT:tableLayoutPanel2:RowCount = 1.
        THIS-OBJECT:tableLayoutPanel2:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        THIS-OBJECT:tableLayoutPanel2:Size = NEW System.Drawing.Size(497, 25).
        THIS-OBJECT:tableLayoutPanel2:TabIndex = 0.
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
        /* label1 */
        /*  */
        THIS-OBJECT:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label1:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        THIS-OBJECT:label1:Location = NEW System.Drawing.Point(3, 0).
        THIS-OBJECT:label1:Name = "label1".
        THIS-OBJECT:label1:Size = NEW System.Drawing.Size(494, 25).
        THIS-OBJECT:label1:TabIndex = 4.
        THIS-OBJECT:label1:Text = "Подарки".
        THIS-OBJECT:label1:UseCompatibleTextRendering = true.
        /*  */
        /* uc_Presents */
        /*  */
        THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel1).
        THIS-OBJECT:Margin = NEW System.Windows.Forms.Padding(0).
        THIS-OBJECT:Name = "uc_Presents".
        THIS-OBJECT:Size = NEW System.Drawing.Size(500, 400).
        THIS-OBJECT:tableLayoutPanel1:ResumeLayout(false).
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:tableLayoutPanel2:ResumeLayout(false).
        THIS-OBJECT:ResumeLayout(false).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END METHOD.

    DESTRUCTOR PUBLIC uc_Presents ( ):

    END DESTRUCTOR.

END CLASS.