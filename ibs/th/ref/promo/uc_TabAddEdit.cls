/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
  
"Промо-акции вкладка Расписание"

Автор: Рубан Дмитрий Андреевич
Дата создания: 16/07/18
Author: 
Creation date: 16/07/18

*/
using Progress.Windows.UserControl.

block-level on error undo, throw.
CLASS ibs.th.ref.promo.uc_TabAddEdit INHERITS UserControl: 
    { cmp/str-glbl.i class }
  define variable vss-revision    as character no-undo initial "$Revision$":U .
  define variable vss-author      as character no-undo initial "$Author$":U .
  define variable vss-date        as character no-undo initial "$Date$":U .
  define variable vss-workfile    as character no-undo initial "$Workfile$":U .
  define variable vss-archive     as character no-undo initial "$Archive$":U . 
  define variable vss-description as character no-undo initial "Промо-акции вкладка Расписание". 
    
  DEFINE PRIVATE VARIABLE bindingSchedWeek AS Progress.Data.BindingSource NO-UNDO.
  DEFINE PRIVATE VARIABLE bindPromoActionOne AS Progress.Data.BindingSource NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox8 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox7 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox6 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox5 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox4 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox3 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE checkBox2 AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE button9 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button8 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE textBox2 AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE textBox1 AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel9 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel13 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel12 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableL_Easily AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableL_Detailed AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton6 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton5 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton4 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE radioButton3 AS System.Windows.Forms.RadioButton NO-UNDO.
    DEFINE PRIVATE VARIABLE label9 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label8 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label7 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label13 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label12 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label11 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label10 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE flowLayoutPanel1 AS System.Windows.Forms.FlowLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE dateTimePicker2 AS System.Windows.Forms.DateTimePicker NO-UNDO.
    DEFINE PRIVATE VARIABLE dateTimePicker1 AS System.Windows.Forms.DateTimePicker NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.

    define private variable m-promo-trg as class ibs.th.ref.promo.promo_trg no-undo.
    
    
    method Public VOID SetPromoTrg(input v-promo-trg as class ibs.th.ref.promo.promo_trg  ):
        m-promo-trg = v-promo-trg.
        SetBind().
    end.
    
    method Public VOID SetBind( ):
        bindPromoActionOne:handle = m-promo-trg:getQuery("promoActionOne3").
        bindingSchedWeek:handle   = m-promo-trg:getQuery("promoSchedWeek").
    end.
        
    CONSTRUCTOR PUBLIC uc_TabAddEdit (  ):
        SUPER().
        InitializeComponent().
        THIS-OBJECT:ComponentsCollection:ADD(THIS-OBJECT:components).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC uc_TabAddEdit ( ):
      bindingSchedWeek:Assign().
      bindingSchedWeek:Dispose().
      bindPromoActionOne:Assign().
      bindPromoActionOne:Dispose().
    END DESTRUCTOR.

    METHOD PRIVATE VOID InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
    THIS-OBJECT:components = NEW System.ComponentModel.Container().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    DEFINE VARIABLE tableDesc1 AS Progress.Data.TableDesc NO-UNDO.
    tableDesc1 = NEW Progress.Data.TableDesc("tt-promoaction-one").
    @VisualDesigner.FormMember (NeedsInitialize="true").
    DEFINE VARIABLE tableDesc2 AS Progress.Data.TableDesc NO-UNDO.
    tableDesc2 = NEW Progress.Data.TableDesc("tt-promo-schedule-week").
    THIS-OBJECT:tableLayoutPanel9 = NEW System.Windows.Forms.TableLayoutPanel().
    THIS-OBJECT:tableL_Detailed = NEW System.Windows.Forms.TableLayoutPanel().
    THIS-OBJECT:radioButton4 = NEW System.Windows.Forms.RadioButton().
    THIS-OBJECT:radioButton3 = NEW System.Windows.Forms.RadioButton().
    THIS-OBJECT:dataGridView1 = NEW System.Windows.Forms.DataGridView().
    THIS-OBJECT:label7 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:button9 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:label8 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:label9 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:textBox1 = NEW System.Windows.Forms.TextBox().
    THIS-OBJECT:bindPromoActionOne = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
    THIS-OBJECT:label10 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:tableLayoutPanel12 = NEW System.Windows.Forms.TableLayoutPanel().
    THIS-OBJECT:radioButton5 = NEW System.Windows.Forms.RadioButton().
    THIS-OBJECT:radioButton6 = NEW System.Windows.Forms.RadioButton().
    THIS-OBJECT:tableLayoutPanel13 = NEW System.Windows.Forms.TableLayoutPanel().
    THIS-OBJECT:label11 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:textBox2 = NEW System.Windows.Forms.TextBox().
    THIS-OBJECT:button8 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:tableL_Easily = NEW System.Windows.Forms.TableLayoutPanel().
    THIS-OBJECT:flowLayoutPanel1 = NEW System.Windows.Forms.FlowLayoutPanel().
    THIS-OBJECT:checkBox2 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:bindingSchedWeek = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
    THIS-OBJECT:checkBox3 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox4 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox5 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox6 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox7 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox8 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:label12 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:dateTimePicker1 = NEW System.Windows.Forms.DateTimePicker().
    THIS-OBJECT:label13 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:dateTimePicker2 = NEW System.Windows.Forms.DateTimePicker().
    THIS-OBJECT:tableLayoutPanel9:SuspendLayout().
    THIS-OBJECT:tableL_Detailed:SuspendLayout().
    CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
    CAST(THIS-OBJECT:bindPromoActionOne, System.ComponentModel.ISupportInitialize):BeginInit().
    THIS-OBJECT:tableLayoutPanel12:SuspendLayout().
    THIS-OBJECT:tableLayoutPanel13:SuspendLayout().
    THIS-OBJECT:tableL_Easily:SuspendLayout().
    THIS-OBJECT:flowLayoutPanel1:SuspendLayout().
    CAST(THIS-OBJECT:bindingSchedWeek, System.ComponentModel.ISupportInitialize):BeginInit().
    THIS-OBJECT:SuspendLayout().
    /*  */
    /* tableLayoutPanel9 */
    /*  */
    THIS-OBJECT:tableLayoutPanel9:ColumnCount = 2.
    THIS-OBJECT:tableLayoutPanel9:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
    THIS-OBJECT:tableLayoutPanel9:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:tableL_Detailed, 0, 4).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:label8, 0, 0).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:label9, 0, 1).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:textBox1, 1, 1).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:label10, 0, 2).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:tableLayoutPanel12, 1, 2).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:tableLayoutPanel13, 0, 5).
    THIS-OBJECT:tableLayoutPanel9:Controls:Add(THIS-OBJECT:tableL_Easily, 0, 3).
    THIS-OBJECT:tableLayoutPanel9:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:tableLayoutPanel9:Location = NEW System.Drawing.Point(0, 0).
    THIS-OBJECT:tableLayoutPanel9:Name = "tableLayoutPanel9".
    THIS-OBJECT:tableLayoutPanel9:RowCount = 6.
    THIS-OBJECT:tableLayoutPanel9:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
    THIS-OBJECT:tableLayoutPanel9:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
    THIS-OBJECT:tableLayoutPanel9:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
    THIS-OBJECT:tableLayoutPanel9:RowStyles:Add(NEW System.Windows.Forms.RowStyle()).
    THIS-OBJECT:tableLayoutPanel9:RowStyles:Add(NEW System.Windows.Forms.RowStyle()).
    THIS-OBJECT:tableLayoutPanel9:RowStyles:Add(NEW System.Windows.Forms.RowStyle()).
    THIS-OBJECT:tableLayoutPanel9:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
    THIS-OBJECT:tableLayoutPanel9:Size = NEW System.Drawing.Size(773, 393).
    THIS-OBJECT:tableLayoutPanel9:TabIndex = 5.
    /*  */
    /* tableL_Detailed */
    /*  */
    DEFINE VARIABLE nestedvar0 AS System.Windows.Forms.AnchorStyles NO-UNDO.
    nestedvar0 = CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
    THIS-OBJECT:tableL_Detailed:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    THIS-OBJECT:tableL_Detailed:BackColor = System.Drawing.SystemColors:Control.
    THIS-OBJECT:tableL_Detailed:ColumnCount = 4.
    THIS-OBJECT:tableLayoutPanel9:SetColumnSpan(THIS-OBJECT:tableL_Detailed, 2).
    THIS-OBJECT:tableL_Detailed:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
    THIS-OBJECT:tableL_Detailed:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(130))).
    THIS-OBJECT:tableL_Detailed:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(130))).
    THIS-OBJECT:tableL_Detailed:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableL_Detailed:Controls:Add(THIS-OBJECT:radioButton4, 2, 0).
    THIS-OBJECT:tableL_Detailed:Controls:Add(THIS-OBJECT:radioButton3, 1, 0).
    THIS-OBJECT:tableL_Detailed:Controls:Add(THIS-OBJECT:dataGridView1, 0, 2).
    THIS-OBJECT:tableL_Detailed:Controls:Add(THIS-OBJECT:label7, 0, 0).
    THIS-OBJECT:tableL_Detailed:Controls:Add(THIS-OBJECT:button9, 0, 1).
    THIS-OBJECT:tableL_Detailed:Location = NEW System.Drawing.Point(0, 120).
    THIS-OBJECT:tableL_Detailed:Margin = NEW System.Windows.Forms.Padding(0).
    THIS-OBJECT:tableL_Detailed:Name = "tableL_Detailed".
    THIS-OBJECT:tableL_Detailed:RowCount = 3.
    THIS-OBJECT:tableL_Detailed:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
    THIS-OBJECT:tableL_Detailed:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
    THIS-OBJECT:tableL_Detailed:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableL_Detailed:Size = NEW System.Drawing.Size(773, 200).
    THIS-OBJECT:tableL_Detailed:TabIndex = 9.
    THIS-OBJECT:tableL_Detailed:Visible = false.
    /*  */
    /* radioButton4 */
    /*  */
    THIS-OBJECT:radioButton4:Appearance = System.Windows.Forms.Appearance:Button.
    THIS-OBJECT:radioButton4:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:radioButton4:Location = NEW System.Drawing.Point(283, 3).
    THIS-OBJECT:radioButton4:Name = "radioButton4".
    THIS-OBJECT:radioButton4:Size = NEW System.Drawing.Size(124, 24).
    THIS-OBJECT:radioButton4:TabIndex = 10.
    THIS-OBJECT:radioButton4:Text = "По вренмени".
    THIS-OBJECT:radioButton4:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    THIS-OBJECT:radioButton4:UseCompatibleTextRendering = true.
    THIS-OBJECT:radioButton4:UseVisualStyleBackColor = true.
    /*  */
    /* radioButton3 */
    /*  */
    THIS-OBJECT:radioButton3:Appearance = System.Windows.Forms.Appearance:Button.
    THIS-OBJECT:radioButton3:Checked = true.
    THIS-OBJECT:radioButton3:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:radioButton3:ForeColor = System.Drawing.Color:Green.
    THIS-OBJECT:radioButton3:Location = NEW System.Drawing.Point(153, 3).
    THIS-OBJECT:radioButton3:Name = "radioButton3".
    THIS-OBJECT:radioButton3:Size = NEW System.Drawing.Size(124, 24).
    THIS-OBJECT:radioButton3:TabIndex = 9.
    THIS-OBJECT:radioButton3:TabStop = true.
    THIS-OBJECT:radioButton3:Text = "По дням недели".
    THIS-OBJECT:radioButton3:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    THIS-OBJECT:radioButton3:UseCompatibleTextRendering = true.
    THIS-OBJECT:radioButton3:UseVisualStyleBackColor = true.
    THIS-OBJECT:radioButton3:CheckedChanged:Subscribe(THIS-OBJECT:radioButton3_CheckedChanged).
    /*  */
    /* dataGridView1 */
    /*  */
    THIS-OBJECT:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
    THIS-OBJECT:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
    THIS-OBJECT:tableL_Detailed:SetColumnSpan(THIS-OBJECT:dataGridView1, 4).
    THIS-OBJECT:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:dataGridView1:Location = NEW System.Drawing.Point(3, 63).
    THIS-OBJECT:dataGridView1:Name = "dataGridView1".
    THIS-OBJECT:dataGridView1:Size = NEW System.Drawing.Size(767, 134).
    THIS-OBJECT:dataGridView1:TabIndex = 0.
    /*  */
    /* label7 */
    /*  */
    THIS-OBJECT:label7:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label7:Location = NEW System.Drawing.Point(3, 0).
    THIS-OBJECT:label7:Name = "label7".
    THIS-OBJECT:label7:Size = NEW System.Drawing.Size(144, 30).
    THIS-OBJECT:label7:TabIndex = 1.
    THIS-OBJECT:label7:Text = "Группировка:".
    THIS-OBJECT:label7:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    THIS-OBJECT:label7:UseCompatibleTextRendering = true.
    /*  */
    /* button9 */
    /*  */
    THIS-OBJECT:button9:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:button9:Location = NEW System.Drawing.Point(3, 33).
    THIS-OBJECT:button9:Name = "button9".
    THIS-OBJECT:button9:Size = NEW System.Drawing.Size(144, 24).
    THIS-OBJECT:button9:TabIndex = 4.
    THIS-OBJECT:button9:Text = "Добавить".
    THIS-OBJECT:button9:UseCompatibleTextRendering = true.
    THIS-OBJECT:button9:UseVisualStyleBackColor = true.
    /*  */
    /* label8 */
    /*  */
    THIS-OBJECT:tableLayoutPanel9:SetColumnSpan(THIS-OBJECT:label8, 2).
    THIS-OBJECT:label8:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label8:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.75), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    THIS-OBJECT:label8:Location = NEW System.Drawing.Point(7, 7).
    THIS-OBJECT:label8:Margin = NEW System.Windows.Forms.Padding(7).
    THIS-OBJECT:label8:Name = "label8".
    THIS-OBJECT:label8:Size = NEW System.Drawing.Size(759, 16).
    THIS-OBJECT:label8:TabIndex = 1.
    THIS-OBJECT:label8:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    THIS-OBJECT:label8:UseCompatibleTextRendering = true.
    /*  */
    /* label9 */
    /*  */
    THIS-OBJECT:label9:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label9:Location = NEW System.Drawing.Point(3, 33).
    THIS-OBJECT:label9:Margin = NEW System.Windows.Forms.Padding(3).
    THIS-OBJECT:label9:Name = "label9".
    THIS-OBJECT:label9:Size = NEW System.Drawing.Size(144, 24).
    THIS-OBJECT:label9:TabIndex = 3.
    THIS-OBJECT:label9:Text = "Наименование:".
    THIS-OBJECT:label9:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    THIS-OBJECT:label9:UseCompatibleTextRendering = true.
    /*  */
    /* textBox1 */
    /*  */
    THIS-OBJECT:textBox1:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bindPromoActionOne, "scheduleName", true)).
    THIS-OBJECT:textBox1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:textBox1:Location = NEW System.Drawing.Point(150, 30).
    THIS-OBJECT:textBox1:Margin = NEW System.Windows.Forms.Padding(0).
    THIS-OBJECT:textBox1:Multiline = true.
    THIS-OBJECT:textBox1:Name = "textBox1".
    THIS-OBJECT:textBox1:Size = NEW System.Drawing.Size(623, 30).
    THIS-OBJECT:textBox1:TabIndex = 4.
    THIS-OBJECT:textBox1:TextChanged:Subscribe(THIS-OBJECT:textBox1_TextChanged).
    /*  */
    /* bindPromoActionOne */
    /*  */
    THIS-OBJECT:bindPromoActionOne:MaxDataGuess = 0.
    THIS-OBJECT:bindPromoActionOne:NoLOBs = false.
    THIS-OBJECT:bindPromoActionOne:Position = 0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar0 AS "Progress.Data.TableDesc[]" NO-UNDO.
    arrayvar0 = NEW "Progress.Data.TableDesc[]"(0).
    tableDesc1:ChildTables = arrayvar0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar1 AS Progress.Data.ColumnPropDesc EXTENT 2 NO-UNDO.
    arrayvar1[1] = NEW Progress.Data.ColumnPropDesc("scheduleName", "", Progress.Data.DataType:CHARACTER).
    arrayvar1[2] = NEW Progress.Data.ColumnPropDesc("scheduleType", "", Progress.Data.DataType:INTEGER).
    tableDesc1:Columns = arrayvar1.
    THIS-OBJECT:bindPromoActionOne:TableSchema = tableDesc1.
    /*  */
    /* label10 */
    /*  */
    THIS-OBJECT:label10:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label10:Location = NEW System.Drawing.Point(3, 63).
    THIS-OBJECT:label10:Margin = NEW System.Windows.Forms.Padding(3).
    THIS-OBJECT:label10:Name = "label10".
    THIS-OBJECT:label10:Size = NEW System.Drawing.Size(144, 24).
    THIS-OBJECT:label10:TabIndex = 5.
    THIS-OBJECT:label10:Text = "Вариант расписания:".
    THIS-OBJECT:label10:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    THIS-OBJECT:label10:UseCompatibleTextRendering = true.
    /*  */
    /* tableLayoutPanel12 */
    /*  */
    THIS-OBJECT:tableLayoutPanel12:BackColor = System.Drawing.SystemColors:Control.
    THIS-OBJECT:tableLayoutPanel12:ColumnCount = 3.
    THIS-OBJECT:tableLayoutPanel12:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(130))).
    THIS-OBJECT:tableLayoutPanel12:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(130))).
    THIS-OBJECT:tableLayoutPanel12:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel12:Controls:Add(THIS-OBJECT:radioButton5, 0, 0).
    THIS-OBJECT:tableLayoutPanel12:Controls:Add(THIS-OBJECT:radioButton6, 0, 0).
    THIS-OBJECT:tableLayoutPanel12:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:tableLayoutPanel12:Location = NEW System.Drawing.Point(150, 60).
    THIS-OBJECT:tableLayoutPanel12:Margin = NEW System.Windows.Forms.Padding(0).
    THIS-OBJECT:tableLayoutPanel12:Name = "tableLayoutPanel12".
    THIS-OBJECT:tableLayoutPanel12:RowCount = 1.
    THIS-OBJECT:tableLayoutPanel12:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel12:Size = NEW System.Drawing.Size(623, 30).
    THIS-OBJECT:tableLayoutPanel12:TabIndex = 6.
    /*  */
    /* radioButton5 */
    /*  */
    THIS-OBJECT:radioButton5:Appearance = System.Windows.Forms.Appearance:Button.
    THIS-OBJECT:radioButton5:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindPromoActionOne, "scheduleType", true)).
    THIS-OBJECT:radioButton5:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:radioButton5:Location = NEW System.Drawing.Point(133, 3).
    THIS-OBJECT:radioButton5:Name = "radioButton5".
    THIS-OBJECT:radioButton5:Size = NEW System.Drawing.Size(124, 24).
    THIS-OBJECT:radioButton5:TabIndex = 9.
    THIS-OBJECT:radioButton5:Text = "Детальное".
    THIS-OBJECT:radioButton5:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    THIS-OBJECT:radioButton5:UseCompatibleTextRendering = true.
    THIS-OBJECT:radioButton5:UseVisualStyleBackColor = true.
    /*  */
    /* radioButton6 */
    /*  */
    THIS-OBJECT:radioButton6:Appearance = System.Windows.Forms.Appearance:Button.
    THIS-OBJECT:radioButton6:Checked = true.
    THIS-OBJECT:radioButton6:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:radioButton6:ForeColor = System.Drawing.Color:Green.
    THIS-OBJECT:radioButton6:Location = NEW System.Drawing.Point(3, 3).
    THIS-OBJECT:radioButton6:Name = "radioButton6".
    THIS-OBJECT:radioButton6:Size = NEW System.Drawing.Size(124, 24).
    THIS-OBJECT:radioButton6:TabIndex = 8.
    THIS-OBJECT:radioButton6:TabStop = true.
    THIS-OBJECT:radioButton6:Text = "Простое".
    THIS-OBJECT:radioButton6:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    THIS-OBJECT:radioButton6:UseCompatibleTextRendering = true.
    THIS-OBJECT:radioButton6:UseVisualStyleBackColor = true.
    THIS-OBJECT:radioButton6:CheckedChanged:Subscribe(THIS-OBJECT:radioButton6_CheckedChanged).
    /*  */
    /* tableLayoutPanel13 */
    /*  */
    THIS-OBJECT:tableLayoutPanel13:BackColor = System.Drawing.SystemColors:Control.
    THIS-OBJECT:tableLayoutPanel13:ColumnCount = 3.
    THIS-OBJECT:tableLayoutPanel9:SetColumnSpan(THIS-OBJECT:tableLayoutPanel13, 2).
    THIS-OBJECT:tableLayoutPanel13:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
    THIS-OBJECT:tableLayoutPanel13:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel13:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(70))).
    THIS-OBJECT:tableLayoutPanel13:Controls:Add(THIS-OBJECT:label11, 0, 0).
    THIS-OBJECT:tableLayoutPanel13:Controls:Add(THIS-OBJECT:textBox2, 1, 0).
    THIS-OBJECT:tableLayoutPanel13:Controls:Add(THIS-OBJECT:button8, 2, 0).
    THIS-OBJECT:tableLayoutPanel13:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:tableLayoutPanel13:Location = NEW System.Drawing.Point(0, 320).
    THIS-OBJECT:tableLayoutPanel13:Margin = NEW System.Windows.Forms.Padding(0).
    THIS-OBJECT:tableLayoutPanel13:Name = "tableLayoutPanel13".
    THIS-OBJECT:tableLayoutPanel13:RowCount = 1.
    THIS-OBJECT:tableLayoutPanel13:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel13:Size = NEW System.Drawing.Size(773, 100).
    THIS-OBJECT:tableLayoutPanel13:TabIndex = 7.
    /*  */
    /* label11 */
    /*  */
    THIS-OBJECT:label11:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label11:Location = NEW System.Drawing.Point(3, 3).
    THIS-OBJECT:label11:Margin = NEW System.Windows.Forms.Padding(3).
    THIS-OBJECT:label11:Name = "label11".
    THIS-OBJECT:label11:Size = NEW System.Drawing.Size(144, 94).
    THIS-OBJECT:label11:TabIndex = 0.
    THIS-OBJECT:label11:Text = "Комментарий:".
    THIS-OBJECT:label11:UseCompatibleTextRendering = true.
    /*  */
    /* textBox2 */
    /*  */
    THIS-OBJECT:textBox2:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:textBox2:Location = NEW System.Drawing.Point(150, 0).
    THIS-OBJECT:textBox2:Margin = NEW System.Windows.Forms.Padding(0, 0, 0, 7).
    THIS-OBJECT:textBox2:Multiline = true.
    THIS-OBJECT:textBox2:Name = "textBox2".
    THIS-OBJECT:textBox2:ScrollBars = System.Windows.Forms.ScrollBars:Vertical.
    THIS-OBJECT:textBox2:Size = NEW System.Drawing.Size(553, 93).
    THIS-OBJECT:textBox2:TabIndex = 1.
    /*  */
    /* button8 */
    /*  */
    DEFINE VARIABLE nestedvar1 AS System.Windows.Forms.AnchorStyles NO-UNDO.
    nestedvar1 = System.Windows.Forms.AnchorStyles:Top.
    THIS-OBJECT:button8:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    THIS-OBJECT:button8:Location = NEW System.Drawing.Point(706, 3).
    THIS-OBJECT:button8:Name = "button8".
    THIS-OBJECT:button8:Size = NEW System.Drawing.Size(64, 24).
    THIS-OBJECT:button8:TabIndex = 3.
    THIS-OBJECT:button8:Text = "Еще".
    THIS-OBJECT:button8:UseCompatibleTextRendering = true.
    THIS-OBJECT:button8:UseVisualStyleBackColor = true.
    /*  */
    /* tableL_Easily */
    /*  */
    DEFINE VARIABLE nestedvar2 AS System.Windows.Forms.AnchorStyles NO-UNDO.
    nestedvar2 = CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
    THIS-OBJECT:tableL_Easily:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    THIS-OBJECT:tableL_Easily:BackColor = System.Drawing.SystemColors:Control.
    THIS-OBJECT:tableL_Easily:ColumnCount = 5.
    THIS-OBJECT:tableLayoutPanel9:SetColumnSpan(THIS-OBJECT:tableL_Easily, 2).
    THIS-OBJECT:tableL_Easily:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
    THIS-OBJECT:tableL_Easily:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
    THIS-OBJECT:tableL_Easily:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
    THIS-OBJECT:tableL_Easily:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(50))).
    THIS-OBJECT:tableL_Easily:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(270))).
    THIS-OBJECT:tableL_Easily:Controls:Add(THIS-OBJECT:flowLayoutPanel1, 4, 0).
    THIS-OBJECT:tableL_Easily:Controls:Add(THIS-OBJECT:label12, 2, 0).
    THIS-OBJECT:tableL_Easily:Controls:Add(THIS-OBJECT:dateTimePicker1, 1, 0).
    THIS-OBJECT:tableL_Easily:Controls:Add(THIS-OBJECT:label13, 0, 0).
    THIS-OBJECT:tableL_Easily:Controls:Add(THIS-OBJECT:dateTimePicker2, 3, 0).
    THIS-OBJECT:tableL_Easily:Location = NEW System.Drawing.Point(0, 90).
    THIS-OBJECT:tableL_Easily:Margin = NEW System.Windows.Forms.Padding(0).
    THIS-OBJECT:tableL_Easily:Name = "tableL_Easily".
    THIS-OBJECT:tableL_Easily:RowCount = 1.
    THIS-OBJECT:tableL_Easily:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableL_Easily:Size = NEW System.Drawing.Size(773, 30).
    THIS-OBJECT:tableL_Easily:TabIndex = 8.
    /*  */
    /* flowLayoutPanel1 */
    /*  */
    THIS-OBJECT:flowLayoutPanel1:Controls:Add(THIS-OBJECT:checkBox2).
    THIS-OBJECT:flowLayoutPanel1:Controls:Add(THIS-OBJECT:checkBox3).
    THIS-OBJECT:flowLayoutPanel1:Controls:Add(THIS-OBJECT:checkBox4).
    THIS-OBJECT:flowLayoutPanel1:Controls:Add(THIS-OBJECT:checkBox5).
    THIS-OBJECT:flowLayoutPanel1:Controls:Add(THIS-OBJECT:checkBox6).
    THIS-OBJECT:flowLayoutPanel1:Controls:Add(THIS-OBJECT:checkBox7).
    THIS-OBJECT:flowLayoutPanel1:Controls:Add(THIS-OBJECT:checkBox8).
    THIS-OBJECT:flowLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:flowLayoutPanel1:Location = NEW System.Drawing.Point(509, 0).
    THIS-OBJECT:flowLayoutPanel1:Margin = NEW System.Windows.Forms.Padding(7, 0, 0, 0).
    THIS-OBJECT:flowLayoutPanel1:MinimumSize = NEW System.Drawing.Size(250, 0).
    THIS-OBJECT:flowLayoutPanel1:Name = "flowLayoutPanel1".
    THIS-OBJECT:flowLayoutPanel1:Size = NEW System.Drawing.Size(264, 30).
    THIS-OBJECT:flowLayoutPanel1:TabIndex = 15.
    /*  */
    /* checkBox2 */
    /*  */
    THIS-OBJECT:checkBox2:AutoSize = true.
    THIS-OBJECT:checkBox2:Checked = true.
    THIS-OBJECT:checkBox2:CheckState = System.Windows.Forms.CheckState:Checked.
    THIS-OBJECT:checkBox2:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindingSchedWeek, "isday_mon", true)).
    THIS-OBJECT:checkBox2:Location = NEW System.Drawing.Point(0, 4).
    THIS-OBJECT:checkBox2:Margin = NEW System.Windows.Forms.Padding(0, 4, 0, 0).
    THIS-OBJECT:checkBox2:Name = "checkBox2".
    THIS-OBJECT:checkBox2:Size = NEW System.Drawing.Size(38, 18).
    THIS-OBJECT:checkBox2:TabIndex = 0.
    THIS-OBJECT:checkBox2:Text = "Пн".
    THIS-OBJECT:checkBox2:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox2:UseVisualStyleBackColor = true.
    /*  */
    /* bindingSchedWeek */
    /*  */
    THIS-OBJECT:bindingSchedWeek:MaxDataGuess = 0.
    THIS-OBJECT:bindingSchedWeek:NoLOBs = false.
    THIS-OBJECT:bindingSchedWeek:Position = 0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar2 AS "Progress.Data.TableDesc[]" NO-UNDO.
    arrayvar2 = NEW "Progress.Data.TableDesc[]"(0).
    tableDesc2:ChildTables = arrayvar2.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar3 AS Progress.Data.ColumnPropDesc EXTENT 13 NO-UNDO.
    arrayvar3[1] = NEW Progress.Data.ColumnPropDesc("isday_mon", "", Progress.Data.DataType:LOGICAL).
    arrayvar3[2] = NEW Progress.Data.ColumnPropDesc("isday_tue", "", Progress.Data.DataType:LOGICAL).
    arrayvar3[3] = NEW Progress.Data.ColumnPropDesc("isday_wed", "", Progress.Data.DataType:LOGICAL).
    arrayvar3[4] = NEW Progress.Data.ColumnPropDesc("isday_thu", "", Progress.Data.DataType:LOGICAL).
    arrayvar3[5] = NEW Progress.Data.ColumnPropDesc("isday_fri", "", Progress.Data.DataType:LOGICAL).
    arrayvar3[6] = NEW Progress.Data.ColumnPropDesc("isday_sat", "", Progress.Data.DataType:LOGICAL).
    arrayvar3[7] = NEW Progress.Data.ColumnPropDesc("isday_sun", "", Progress.Data.DataType:LOGICAL).
    arrayvar3[8] = NEW Progress.Data.ColumnPropDesc("promosched-id", "?", Progress.Data.DataType:INTEGER).
    arrayvar3[9] = NEW Progress.Data.ColumnPropDesc("timebeg", "Время с", Progress.Data.DataType:INTEGER).
    arrayvar3[10] = NEW Progress.Data.ColumnPropDesc("timeend", "Время по", Progress.Data.DataType:INTEGER).
    arrayvar3[11] = NEW Progress.Data.ColumnPropDesc("wdaylist", "Дни недели", Progress.Data.DataType:CHARACTER).
    arrayvar3[12] = NEW Progress.Data.ColumnPropDesc("dtime-beg", "время с", Progress.Data.DataType:DATETIME).
    arrayvar3[13] = NEW Progress.Data.ColumnPropDesc("dtime-end", "время по", Progress.Data.DataType:DATETIME).
    tableDesc2:Columns = arrayvar3.
    THIS-OBJECT:bindingSchedWeek:TableSchema = tableDesc2.
    /*  */
    /* checkBox3 */
    /*  */
    THIS-OBJECT:checkBox3:AutoSize = true.
    THIS-OBJECT:checkBox3:Checked = true.
    THIS-OBJECT:checkBox3:CheckState = System.Windows.Forms.CheckState:Checked.
    THIS-OBJECT:checkBox3:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindingSchedWeek, "isday_tue", true)).
    THIS-OBJECT:checkBox3:Location = NEW System.Drawing.Point(38, 4).
    THIS-OBJECT:checkBox3:Margin = NEW System.Windows.Forms.Padding(0, 4, 0, 0).
    THIS-OBJECT:checkBox3:Name = "checkBox3".
    THIS-OBJECT:checkBox3:Size = NEW System.Drawing.Size(36, 18).
    THIS-OBJECT:checkBox3:TabIndex = 1.
    THIS-OBJECT:checkBox3:Text = "Вт".
    THIS-OBJECT:checkBox3:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox3:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox4 */
    /*  */
    THIS-OBJECT:checkBox4:AutoSize = true.
    THIS-OBJECT:checkBox4:Checked = true.
    THIS-OBJECT:checkBox4:CheckState = System.Windows.Forms.CheckState:Checked.
    THIS-OBJECT:checkBox4:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindingSchedWeek, "isday_wed", true)).
    THIS-OBJECT:checkBox4:Location = NEW System.Drawing.Point(74, 4).
    THIS-OBJECT:checkBox4:Margin = NEW System.Windows.Forms.Padding(0, 4, 0, 0).
    THIS-OBJECT:checkBox4:Name = "checkBox4".
    THIS-OBJECT:checkBox4:Size = NEW System.Drawing.Size(38, 18).
    THIS-OBJECT:checkBox4:TabIndex = 2.
    THIS-OBJECT:checkBox4:Text = "Ср".
    THIS-OBJECT:checkBox4:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox4:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox5 */
    /*  */
    THIS-OBJECT:checkBox5:AutoSize = true.
    THIS-OBJECT:checkBox5:Checked = true.
    THIS-OBJECT:checkBox5:CheckState = System.Windows.Forms.CheckState:Checked.
    THIS-OBJECT:checkBox5:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindingSchedWeek, "isday_thu", true)).
    THIS-OBJECT:checkBox5:Location = NEW System.Drawing.Point(112, 4).
    THIS-OBJECT:checkBox5:Margin = NEW System.Windows.Forms.Padding(0, 4, 0, 0).
    THIS-OBJECT:checkBox5:Name = "checkBox5".
    THIS-OBJECT:checkBox5:Size = NEW System.Drawing.Size(36, 18).
    THIS-OBJECT:checkBox5:TabIndex = 3.
    THIS-OBJECT:checkBox5:Text = "Чт".
    THIS-OBJECT:checkBox5:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox5:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox6 */
    /*  */
    THIS-OBJECT:checkBox6:AutoSize = true.
    THIS-OBJECT:checkBox6:Checked = true.
    THIS-OBJECT:checkBox6:CheckState = System.Windows.Forms.CheckState:Checked.
    THIS-OBJECT:checkBox6:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindingSchedWeek, "isday_fri", true)).
    THIS-OBJECT:checkBox6:Location = NEW System.Drawing.Point(148, 4).
    THIS-OBJECT:checkBox6:Margin = NEW System.Windows.Forms.Padding(0, 4, 0, 0).
    THIS-OBJECT:checkBox6:Name = "checkBox6".
    THIS-OBJECT:checkBox6:Size = NEW System.Drawing.Size(37, 18).
    THIS-OBJECT:checkBox6:TabIndex = 4.
    THIS-OBJECT:checkBox6:Text = "Пт".
    THIS-OBJECT:checkBox6:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox6:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox7 */
    /*  */
    THIS-OBJECT:checkBox7:AutoSize = true.
    THIS-OBJECT:checkBox7:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindingSchedWeek, "isday_sat", true)).
    THIS-OBJECT:checkBox7:ForeColor = System.Drawing.Color:Red.
    THIS-OBJECT:checkBox7:Location = NEW System.Drawing.Point(185, 4).
    THIS-OBJECT:checkBox7:Margin = NEW System.Windows.Forms.Padding(0, 4, 0, 0).
    THIS-OBJECT:checkBox7:Name = "checkBox7".
    THIS-OBJECT:checkBox7:Size = NEW System.Drawing.Size(38, 18).
    THIS-OBJECT:checkBox7:TabIndex = 5.
    THIS-OBJECT:checkBox7:Text = "Сб".
    THIS-OBJECT:checkBox7:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox7:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox8 */
    /*  */
    THIS-OBJECT:checkBox8:AutoSize = true.
    THIS-OBJECT:checkBox8:DataBindings:Add(NEW System.Windows.Forms.Binding("Checked", THIS-OBJECT:bindingSchedWeek, "isday_sun", true)).
    THIS-OBJECT:checkBox8:ForeColor = System.Drawing.Color:Red.
    THIS-OBJECT:checkBox8:Location = NEW System.Drawing.Point(223, 4).
    THIS-OBJECT:checkBox8:Margin = NEW System.Windows.Forms.Padding(0, 4, 0, 0).
    THIS-OBJECT:checkBox8:Name = "checkBox8".
    THIS-OBJECT:checkBox8:Size = NEW System.Drawing.Size(36, 18).
    THIS-OBJECT:checkBox8:TabIndex = 6.
    THIS-OBJECT:checkBox8:Text = "Вс".
    THIS-OBJECT:checkBox8:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox8:UseVisualStyleBackColor = true.
    /*  */
    /* label12 */
    /*  */
    THIS-OBJECT:label12:Location = NEW System.Drawing.Point(314, 0).
    THIS-OBJECT:label12:Name = "label12".
    THIS-OBJECT:label12:Size = NEW System.Drawing.Size(24, 23).
    THIS-OBJECT:label12:TabIndex = 14.
    THIS-OBJECT:label12:Text = "по:".
    THIS-OBJECT:label12:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    THIS-OBJECT:label12:UseCompatibleTextRendering = true.
    /*  */
    /* dateTimePicker1 */
    /*  */
    THIS-OBJECT:dateTimePicker1:CustomFormat = "HH:mm".
    THIS-OBJECT:dateTimePicker1:DataBindings:Add(NEW System.Windows.Forms.Binding("Value", THIS-OBJECT:bindingSchedWeek, "dtime-beg", true)).
    THIS-OBJECT:dateTimePicker1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:dateTimePicker1:Format = System.Windows.Forms.DateTimePickerFormat:Custom.
    THIS-OBJECT:dateTimePicker1:Location = NEW System.Drawing.Point(153, 4).
    THIS-OBJECT:dateTimePicker1:Margin = NEW System.Windows.Forms.Padding(3, 4, 0, 0).
    THIS-OBJECT:dateTimePicker1:Name = "dateTimePicker1".
    THIS-OBJECT:dateTimePicker1:ShowUpDown = true.
    THIS-OBJECT:dateTimePicker1:Size = NEW System.Drawing.Size(158, 20).
    THIS-OBJECT:dateTimePicker1:TabIndex = 12.
    /*  */
    /* label13 */
    /*  */
    THIS-OBJECT:label13:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label13:Location = NEW System.Drawing.Point(3, 0).
    THIS-OBJECT:label13:Name = "label13".
    THIS-OBJECT:label13:Size = NEW System.Drawing.Size(144, 30).
    THIS-OBJECT:label13:TabIndex = 0.
    THIS-OBJECT:label13:Text = "Время с:".
    THIS-OBJECT:label13:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    THIS-OBJECT:label13:UseCompatibleTextRendering = true.
    /*  */
    /* dateTimePicker2 */
    /*  */
    THIS-OBJECT:dateTimePicker2:CustomFormat = "HH:mm".
    THIS-OBJECT:dateTimePicker2:DataBindings:Add(NEW System.Windows.Forms.Binding("Value", THIS-OBJECT:bindingSchedWeek, "dtime-end", true)).
    THIS-OBJECT:dateTimePicker2:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:dateTimePicker2:Format = System.Windows.Forms.DateTimePickerFormat:Custom.
    THIS-OBJECT:dateTimePicker2:Location = NEW System.Drawing.Point(344, 4).
    THIS-OBJECT:dateTimePicker2:Margin = NEW System.Windows.Forms.Padding(3, 4, 0, 0).
    THIS-OBJECT:dateTimePicker2:Name = "dateTimePicker2".
    THIS-OBJECT:dateTimePicker2:ShowUpDown = true.
    THIS-OBJECT:dateTimePicker2:Size = NEW System.Drawing.Size(158, 20).
    THIS-OBJECT:dateTimePicker2:TabIndex = 13.
    /*  */
    /* uc_TabAddEdit */
    /*  */
    THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel9).
    THIS-OBJECT:Name = "uc_TabAddEdit".
    THIS-OBJECT:Size = NEW System.Drawing.Size(773, 393).
    THIS-OBJECT:tableLayoutPanel9:ResumeLayout(false).
    THIS-OBJECT:tableLayoutPanel9:PerformLayout().
    THIS-OBJECT:tableL_Detailed:ResumeLayout(false).
    CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
    CAST(THIS-OBJECT:bindPromoActionOne, System.ComponentModel.ISupportInitialize):EndInit().
    THIS-OBJECT:tableLayoutPanel12:ResumeLayout(false).
    THIS-OBJECT:tableLayoutPanel13:ResumeLayout(false).
    THIS-OBJECT:tableLayoutPanel13:PerformLayout().
    THIS-OBJECT:tableL_Easily:ResumeLayout(false).
    THIS-OBJECT:flowLayoutPanel1:ResumeLayout(false).
    THIS-OBJECT:flowLayoutPanel1:PerformLayout().
    CAST(THIS-OBJECT:bindingSchedWeek, System.ComponentModel.ISupportInitialize):EndInit().
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
	METHOD PRIVATE VOID radioButton3_CheckedChanged( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		    if radioButton3:Checked then do:
           radioButton3:ForeColor  = System.Drawing.Color:Green.
           radioButton4:ForeColor  = System.Drawing.Color:Black.
        end.
        else do:
           radioButton3:ForeColor  = System.Drawing.Color:Black.
           radioButton4:ForeColor  = System.Drawing.Color:Green.
        end.
        
		RETURN.
	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID radioButton6_CheckedChanged( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		    if radioButton6:Checked then do:
           radioButton6:ForeColor  = System.Drawing.Color:Green.
           radioButton5:ForeColor  = System.Drawing.Color:Black.
           tableL_Easily:Visible = true.
           tableL_Detailed:Visible = false.
        end.
        else do:
           radioButton6:ForeColor  = System.Drawing.Color:Black.
           radioButton5:ForeColor  = System.Drawing.Color:Green.
           tableL_Easily:Visible = false.
           tableL_Detailed:Visible = true.
        end.

		RETURN.
	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID textBox1_TextChanged( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		label8:Text = textBox1:Text .
		RETURN.
	END METHOD.

END CLASS.