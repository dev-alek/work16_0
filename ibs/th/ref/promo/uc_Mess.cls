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

CLASS ibs.th.ref.promo.uc_Mess INHERITS UserControl: 
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Просмотр/редактирование одной акции". 
  /* --- end_of для cmp/vssrevis.i --- */
    
    define private variable bindPromoCrit as Progress.Data.BindingSource no-undo.
    define private variable bindPromoMess as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE textBox1 AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.

    {ibs/th/ref/promo/promo_trg_heder.i &NotLocalEvent = yes &NotSetBind = yes}  
    
    method Public VOID SetBind( ):
        bindPromoMess:Handle = m-promo-trg:getQuery("promoMes").
      end.
    
        
    CONSTRUCTOR PUBLIC uc_Mess (  ):
        
        
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
        define variable tableDesc2 as Progress.Data.TableDesc no-undo.
        tableDesc2 = new Progress.Data.TableDesc("tt-PromoCriterion").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        define variable tableDesc1 as Progress.Data.TableDesc no-undo.
        tableDesc1 = new Progress.Data.TableDesc("tt-PromoGift").
        this-object:tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel().
        this-object:tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel().
        this-object:label1 = new System.Windows.Forms.Label().
        this-object:bindPromoCrit = new Progress.Data.BindingSource(this-object:components).
        this-object:textBox1 = new System.Windows.Forms.TextBox().
        this-object:bindPromoMess = new Progress.Data.BindingSource(this-object:components).
        this-object:tableLayoutPanel1:SuspendLayout().
        this-object:tableLayoutPanel2:SuspendLayout().
        cast(this-object:bindPromoCrit, System.ComponentModel.ISupportInitialize):BeginInit().
        cast(this-object:bindPromoMess, System.ComponentModel.ISupportInitialize):BeginInit().
        this-object:SuspendLayout().
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        this-object:tableLayoutPanel1:ColumnCount = 1.
        this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel2, 0, 0).
        this-object:tableLayoutPanel1:Controls:Add(this-object:textBox1, 0, 1).
        this-object:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel1:Location = new System.Drawing.Point(0, 0).
        this-object:tableLayoutPanel1:Name = "tableLayoutPanel1".
        this-object:tableLayoutPanel1:RowCount = 2.
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(35))).
        this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel1:Size = new System.Drawing.Size(556, 297).
        this-object:tableLayoutPanel1:TabIndex = 4.
        /*  */
        /* tableLayoutPanel2 */
        /*  */
        this-object:tableLayoutPanel2:ColumnCount = 4.
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
        this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
        this-object:tableLayoutPanel2:Controls:Add(this-object:label1, 0, 0).
        this-object:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:tableLayoutPanel2:Location = new System.Drawing.Point(3, 3).
        this-object:tableLayoutPanel2:Name = "tableLayoutPanel2".
        this-object:tableLayoutPanel2:RowCount = 1.
        this-object:tableLayoutPanel2:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
        this-object:tableLayoutPanel2:Size = new System.Drawing.Size(550, 29).
        this-object:tableLayoutPanel2:TabIndex = 5.
        /*  */
        /* label1 */
        /*  */
        this-object:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        this-object:label1:Location = new System.Drawing.Point(3, 0).
        this-object:label1:Name = "label1".
        this-object:label1:Size = new System.Drawing.Size(144, 29).
        this-object:label1:TabIndex = 6.
        this-object:label1:Text = "Сообщение".
        this-object:label1:UseCompatibleTextRendering = true.
        /*  */
        /* bindPromoCrit */
        /*  */
        this-object:bindPromoCrit:MaxDataGuess = 0.
        this-object:bindPromoCrit:NoLOBs = false.
        this-object:bindPromoCrit:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar0 = new "Progress.Data.TableDesc[]"(0).
        tableDesc2:ChildTables = arrayvar0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 1 no-undo.
        arrayvar1[1] = new Progress.Data.ColumnPropDesc("mincrit", "минимальное значение критерия", Progress.Data.DataType:DECIMAL).
        tableDesc2:Columns = arrayvar1.
        this-object:bindPromoCrit:TableSchema = tableDesc2.
        /*  */
        /* textBox1 */
        /*  */
        this-object:textBox1:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindPromoMess, "mess", true)).
        this-object:textBox1:Dock = System.Windows.Forms.DockStyle:Fill.
        this-object:textBox1:Location = new System.Drawing.Point(3, 38).
        this-object:textBox1:Multiline = true.
        this-object:textBox1:Name = "textBox1".
        this-object:textBox1:Size = new System.Drawing.Size(550, 256).
        this-object:textBox1:TabIndex = 7.
        /*  */
        /* bindPromoMess */
        /*  */
        this-object:bindPromoMess:MaxDataGuess = 0.
        this-object:bindPromoMess:NoLOBs = false.
        this-object:bindPromoMess:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar2 as "Progress.Data.TableDesc[]" no-undo.
        arrayvar2 = new "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar2.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        define variable arrayvar3 as Progress.Data.ColumnPropDesc extent 1 no-undo.
        arrayvar3[1] = new Progress.Data.ColumnPropDesc("mess", "сообщение", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar3.
        this-object:bindPromoMess:TableSchema = tableDesc1.
        /*  */
        /* uc_Mess */
        /*  */
        this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        this-object:Controls:Add(this-object:tableLayoutPanel1).
        this-object:Name = "uc_Mess".
        this-object:Size = new System.Drawing.Size(556, 297).
        this-object:tableLayoutPanel1:ResumeLayout(false).
        this-object:tableLayoutPanel1:PerformLayout().
        this-object:tableLayoutPanel2:ResumeLayout(false).
        cast(this-object:bindPromoCrit, System.ComponentModel.ISupportInitialize):EndInit().
        cast(this-object:bindPromoMess, System.ComponentModel.ISupportInitialize):EndInit().
        this-object:ResumeLayout(false).
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    END METHOD.

    DESTRUCTOR PUBLIC uc_Mess ( ):
        if valid-object(m-promo-trg) then closeBind().
    END DESTRUCTOR.
    
    method private void closeBind():
       bindPromoMess:Assign().
       bindPromoMess:Dispose().
    end.

END CLASS.