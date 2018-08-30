/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 
Список промо-акций

Автор: Рубан Дмитрий Андреевич
Дата создания: 11/07/18
Author: 
Creation date: 11/07/18

*/
using Progress.Lang.*.
using Progress.Windows.Form.
USING System.Windows.Forms.Keys FROM ASSEMBLY.

block-level on error undo, throw.

class ibs.th.ref.promo.wListActions inherits Form: 
    { cmp/str-glbl.i class }
    
    define private variable begdateDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable begdateDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable bindAction as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    define private variable Chang as System.Windows.Forms.DataGridViewCheckBoxColumn no-undo.
    define private variable changDataGridViewCheckBoxColumn as System.Windows.Forms.DataGridViewCheckBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE comboBox1 AS System.Windows.Forms.ComboBox NO-UNDO.
    define private variable components as System.ComponentModel.IContainer no-undo.
    define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
    define private variable dataGridViewTextBoxColumn2 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE dateTimePicker1 AS System.Windows.Forms.DateTimePicker NO-UNDO.
    define private variable enddateDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable dataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable extcodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable enddateDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable id as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable idDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE label2 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    define private variable NameAction as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable nameActionDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable status_lbl as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable statuslblDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable tableLayoutPanel1 as System.Windows.Forms.TableLayoutPanel no-undo.

    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    define private variable toolSBtn_Exit as System.Windows.Forms.ToolStripButton no-undo.
    DEFINE PRIVATE VARIABLE toolSBtn_Print AS System.Windows.Forms.ToolStripButton NO-UNDO.
    DEFINE PRIVATE VARIABLE toolSBtn_Star AS System.Windows.Forms.ToolStripButton NO-UNDO.
    DEFINE PRIVATE VARIABLE toolSBtn_Ok AS System.Windows.Forms.ToolStripButton NO-UNDO.
    define private variable toolSBtn_View as System.Windows.Forms.ToolStripButton no-undo.
    define private variable toolSBtn_Main as System.Windows.Forms.ToolStripButton no-undo.
    define private variable toolSBtn_Edit as System.Windows.Forms.ToolStripButton no-undo.
    define private variable toolSBtn_Delete as System.Windows.Forms.ToolStripButton no-undo.
    define private variable toolSBtn_Add as System.Windows.Forms.ToolStripButton no-undo.
    define private variable toolStrip1 as System.Windows.Forms.ToolStrip no-undo.
    define variable vDeleteTRG as logical no-undo.
  /* --- для cmp/vssrevis.i --- */
    define variable vss-revision       as character no-undo init "$Revision$":U .
    define variable vss-author         as character no-undo init "$Author$":U .
    define variable vss-date           as character no-undo init "$Date$":U .
    define variable vss-workfile       as character no-undo init "$Workfile$":U .
    define variable vss-archive        as character no-undo init "$Archive$":U .
    define variable vss-description    as character no-undo init "Список промо-акций". 
  /* --- end_of для cmp/vssrevis.i --- */
  
  
  
  /* --- собственные переменные --- */
    define variable m-promo-trg   as class  ibs.th.ref.promo.promo_trg no-undo .
    define public variable oPromoActionSubs as class  ibs.th.ref.promo.promoActionSubs no-undo .
  /* --- end_of собственные переменные --- */
    define private variable m-promo-type as class ibs.th.ref.promo.promoType no-undo.
    {ibs/th/ref/promo/promoType.def ttStatus}
    
    
    //{ bge/ds-promo.i &ref }  
     //define query q-action for tt-promoaction scrolling.
    
     constructor public wListActions ():
          super().
          InitializeComponent().
          Visual_Columns(FALSE).
          THIS-OBJECT:KeyPreview = true.
          this-object:ComponentsCollection:ADD(this-object:components).
          m-promo-trg = new ibs.th.ref.promo.promo_trg().
          vDeleteTRG = yes.
          //m-promo-trg:SetBrwPromoAction(this-object).
          prepareobj () .
    end.
    constructor public wListActions (
    input pPromoTrg as ibs.th.ref.promo.promo_trg
   // ,    input table tt-promoaction bind
    ):
        //method public void SetPromoTrg (input pPromoTrg as ibs.th.ref.promo.promo_trg ) :
        
        super().
        InitializeComponent().
        Visual_Columns(FALSE).
        THIS-OBJECT:KeyPreview = true.
        this-object:ComponentsCollection:ADD(this-object:components).
        m-promo-trg = pPromoTrg.
       prepareobj ( ) .
        catch e as Progress.Lang.Error:
            undo, throw e.
        end catch.
    end constructor.
    
     
    /*method public void SetPromoBind (input table tt-promoaction bind ) :
     
    end method .
    */
    destructor public wListActions ( ):
        bindAction:Dispose().
      if     vDeleteTRG 
         and valid-object(m-promo-trg) 
      then 
         delete object m-promo-trg .
    end destructor.




	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button1_Click( input sender as System.Object, input e as System.EventArgs ):
	    find first ttstatus where ttstatus.item eq comboBox1:text no-error.
		m-promo-trg:getListTable(date(dateTimePicker1:value),(if available ttstatus then ttstatus.code else ? )).
		define variable vha as handle no-undo.
        vha = m-promo-trg:getQuery("promoActionAll",yes).
        bindAction:handle = vha.
        bindAction:Refreshall().
        return.
		

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_CellContentClick( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):
		m-promo-trg:changeRow(no).
        bindAction:Refresh().
        return.
		

	end method.

   METHOD PRIVATE VOID Init_comboBox1():
        define variable v-promo-type as class ibs.th.ref.promo.promotype no-undo.
        v-promo-type = new ibs.th.ref.promo.promoType().
        v-promo-type:Status_refresh().
        v-promo-type:typeTable("status_",output table ttStatus).
        for each ttStatus:
            comboBox1:Items:Add(ttStatus.item).
        end. 
        comboBox1:Items:Add("*").
        delete object v-promo-type.
    end.



	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_CellContentDoubleClick( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):
		
		m-promo-trg:viewOnePromo().
         bindAction:Refresh().
        return.

	end method.

  method public void prepareobj ( ) :
     find first ttstatus where ttstatus.item eq comboBox1:text no-error.
     m-promo-trg:getListTable(date(dateTimePicker1:value),(if available ttstatus then ttstatus.code else ? )).
     Init_comboBox1().  
     bindAction:handle = m-promo-trg:getQuery("promoActionAll").
     
     //hQuery:query-open.
     // bindAction:handle:query-open.
       bindAction:RefreshAll().
            
     
     // после заполнения find first tt-promoaction здесь available 
  end method .
  
      method private void InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
    THIS-OBJECT:components = NEW System.ComponentModel.Container().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    DEFINE VARIABLE tableDesc1 AS Progress.Data.TableDesc NO-UNDO.
    tableDesc1 = NEW Progress.Data.TableDesc("tt-promoaction").
    @VisualDesigner.FormMember (NeedsInitialize="true").
    DEFINE VARIABLE resources AS Progress.Util.ResourceManager NO-UNDO.
    resources = NEW Progress.Util.ResourceManager("ibs.th.ref.promo.wListActions").
    THIS-OBJECT:tableLayoutPanel1 = NEW System.Windows.Forms.TableLayoutPanel().
    THIS-OBJECT:dataGridView1 = NEW System.Windows.Forms.DataGridView().
    THIS-OBJECT:changDataGridViewCheckBoxColumn = NEW System.Windows.Forms.DataGridViewCheckBoxColumn().
    THIS-OBJECT:nameActionDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:begdateDataGridViewTextBoxColumn1 = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:enddateDataGridViewTextBoxColumn1 = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:statuslblDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:idDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:extcodeDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:bindAction = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
    THIS-OBJECT:tableLayoutPanel2 = NEW System.Windows.Forms.TableLayoutPanel().
    THIS-OBJECT:toolStrip1 = NEW System.Windows.Forms.ToolStrip().
    THIS-OBJECT:toolSBtn_Exit = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_Ok = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_Star = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_Add = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_Main = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_View = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_Edit = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_Delete = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:toolSBtn_Print = NEW System.Windows.Forms.ToolStripButton().
    THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:dateTimePicker1 = NEW System.Windows.Forms.DateTimePicker().
    THIS-OBJECT:label2 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:comboBox1 = NEW System.Windows.Forms.ComboBox().
    THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:NameAction = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:dataGridViewTextBoxColumn1 = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:Chang = NEW System.Windows.Forms.DataGridViewCheckBoxColumn().
    THIS-OBJECT:dataGridViewTextBoxColumn2 = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:begdateDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:enddateDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:status_lbl = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:id = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
    THIS-OBJECT:tableLayoutPanel1:SuspendLayout().
    CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
    CAST(THIS-OBJECT:bindAction, System.ComponentModel.ISupportInitialize):BeginInit().
    THIS-OBJECT:tableLayoutPanel2:SuspendLayout().
    THIS-OBJECT:toolStrip1:SuspendLayout().
    THIS-OBJECT:SuspendLayout().
    /*  */
    /* tableLayoutPanel1 */
    /*  */
    THIS-OBJECT:tableLayoutPanel1:ColumnCount = 1.
    THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:dataGridView1, 0, 1).
    THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:tableLayoutPanel2, 0, 0).
    THIS-OBJECT:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:tableLayoutPanel1:Location = NEW System.Drawing.Point(0, 0).
    THIS-OBJECT:tableLayoutPanel1:Name = "tableLayoutPanel1".
    THIS-OBJECT:tableLayoutPanel1:RowCount = 2.
    THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(40))).
    THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel1:Size = NEW System.Drawing.Size(792, 512).
    THIS-OBJECT:tableLayoutPanel1:TabIndex = 0.
    /*  */
    /* dataGridView1 */
    /*  */
    THIS-OBJECT:dataGridView1:AllowUserToAddRows = false.
    THIS-OBJECT:dataGridView1:AllowUserToDeleteRows = false.
    THIS-OBJECT:dataGridView1:AllowUserToOrderColumns = true.
    THIS-OBJECT:dataGridView1:AutoGenerateColumns = false.
    THIS-OBJECT:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
    THIS-OBJECT:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar0 AS System.Windows.Forms.DataGridViewColumn EXTENT 7 NO-UNDO.
    arrayvar0[1] = THIS-OBJECT:changDataGridViewCheckBoxColumn.
    arrayvar0[2] = THIS-OBJECT:nameActionDataGridViewTextBoxColumn.
    arrayvar0[3] = THIS-OBJECT:begdateDataGridViewTextBoxColumn1.
    arrayvar0[4] = THIS-OBJECT:enddateDataGridViewTextBoxColumn1.
    arrayvar0[5] = THIS-OBJECT:statuslblDataGridViewTextBoxColumn.
    arrayvar0[6] = THIS-OBJECT:idDataGridViewTextBoxColumn.
    arrayvar0[7] = THIS-OBJECT:extcodeDataGridViewTextBoxColumn.
    THIS-OBJECT:dataGridView1:Columns:AddRange(arrayvar0).
    THIS-OBJECT:dataGridView1:DataSource = THIS-OBJECT:bindAction.
    THIS-OBJECT:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:dataGridView1:Location = NEW System.Drawing.Point(3, 43).
    THIS-OBJECT:dataGridView1:MultiSelect = false.
    THIS-OBJECT:dataGridView1:Name = "dataGridView1".
    THIS-OBJECT:dataGridView1:ReadOnly = true.
    THIS-OBJECT:dataGridView1:SelectionMode = System.Windows.Forms.DataGridViewSelectionMode:FullRowSelect.
    THIS-OBJECT:dataGridView1:Size = NEW System.Drawing.Size(786, 466).
    THIS-OBJECT:dataGridView1:TabIndex = 0.
    THIS-OBJECT:dataGridView1:CellContentClick:Subscribe(THIS-OBJECT:dataGridView1_CellContentClick).
    THIS-OBJECT:dataGridView1:CellContentDoubleClick:Subscribe(THIS-OBJECT:dataGridView1_CellContentDoubleClick).
    /*  */
    /* changDataGridViewCheckBoxColumn */
    /*  */
    THIS-OBJECT:changDataGridViewCheckBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:None.
    THIS-OBJECT:changDataGridViewCheckBoxColumn:DataPropertyName = "Chang".
    THIS-OBJECT:changDataGridViewCheckBoxColumn:HeaderText = "".
    THIS-OBJECT:changDataGridViewCheckBoxColumn:Name = "changDataGridViewCheckBoxColumn".
    THIS-OBJECT:changDataGridViewCheckBoxColumn:ReadOnly = true.
    THIS-OBJECT:changDataGridViewCheckBoxColumn:Width = 20.
    /*  */
    /* nameActionDataGridViewTextBoxColumn */
    /*  */
    THIS-OBJECT:nameActionDataGridViewTextBoxColumn:DataPropertyName = "nameAction".
    THIS-OBJECT:nameActionDataGridViewTextBoxColumn:HeaderText = "Наим. акции".
    THIS-OBJECT:nameActionDataGridViewTextBoxColumn:Name = "nameActionDataGridViewTextBoxColumn".
    THIS-OBJECT:nameActionDataGridViewTextBoxColumn:ReadOnly = true.
    /*  */
    /* begdateDataGridViewTextBoxColumn1 */
    /*  */
    THIS-OBJECT:begdateDataGridViewTextBoxColumn1:DataPropertyName = "beg-date".
    THIS-OBJECT:begdateDataGridViewTextBoxColumn1:HeaderText = "Дата начала".
    THIS-OBJECT:begdateDataGridViewTextBoxColumn1:Name = "begdateDataGridViewTextBoxColumn1".
    THIS-OBJECT:begdateDataGridViewTextBoxColumn1:ReadOnly = true.
    /*  */
    /* enddateDataGridViewTextBoxColumn1 */
    /*  */
    THIS-OBJECT:enddateDataGridViewTextBoxColumn1:DataPropertyName = "end-date".
    THIS-OBJECT:enddateDataGridViewTextBoxColumn1:HeaderText = "Дата конца".
    THIS-OBJECT:enddateDataGridViewTextBoxColumn1:Name = "enddateDataGridViewTextBoxColumn1".
    THIS-OBJECT:enddateDataGridViewTextBoxColumn1:ReadOnly = true.
    /*  */
    /* statuslblDataGridViewTextBoxColumn */
    /*  */
    THIS-OBJECT:statuslblDataGridViewTextBoxColumn:DataPropertyName = "status_lbl".
    THIS-OBJECT:statuslblDataGridViewTextBoxColumn:HeaderText = "Статус".
    THIS-OBJECT:statuslblDataGridViewTextBoxColumn:Name = "statuslblDataGridViewTextBoxColumn".
    THIS-OBJECT:statuslblDataGridViewTextBoxColumn:ReadOnly = true.
    /*  */
    /* idDataGridViewTextBoxColumn */
    /*  */
    THIS-OBJECT:idDataGridViewTextBoxColumn:DataPropertyName = "id".
    THIS-OBJECT:idDataGridViewTextBoxColumn:HeaderText = "id".
    THIS-OBJECT:idDataGridViewTextBoxColumn:Name = "idDataGridViewTextBoxColumn".
    THIS-OBJECT:idDataGridViewTextBoxColumn:ReadOnly = true.
    /*  */
    /* extcodeDataGridViewTextBoxColumn */
    /*  */
    THIS-OBJECT:extcodeDataGridViewTextBoxColumn:DataPropertyName = "ext-code".
    THIS-OBJECT:extcodeDataGridViewTextBoxColumn:HeaderText = "Id во внеш.Сист".
    THIS-OBJECT:extcodeDataGridViewTextBoxColumn:Name = "extcodeDataGridViewTextBoxColumn".
    THIS-OBJECT:extcodeDataGridViewTextBoxColumn:ReadOnly = true.
    /*  */
    /* bindAction */
    /*  */
    THIS-OBJECT:bindAction:AutoSort = true.
    THIS-OBJECT:bindAction:AutoUpdate = true.
    THIS-OBJECT:bindAction:MaxDataGuess = 0.
    THIS-OBJECT:bindAction:NoLOBs = false.
    THIS-OBJECT:bindAction:Position = 0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar1 AS "Progress.Data.TableDesc[]" NO-UNDO.
    arrayvar1 = NEW "Progress.Data.TableDesc[]"(0).
    tableDesc1:ChildTables = arrayvar1.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar2 AS Progress.Data.ColumnPropDesc EXTENT 7 NO-UNDO.
    arrayvar2[1] = NEW Progress.Data.ColumnPropDesc("status_lbl", "", Progress.Data.DataType:CHARACTER).
    arrayvar2[2] = NEW Progress.Data.ColumnPropDesc("Chang", "", Progress.Data.DataType:LOGICAL).
    arrayvar2[3] = NEW Progress.Data.ColumnPropDesc("beg-date", "Дата начала", Progress.Data.DataType:DATE).
    arrayvar2[4] = NEW Progress.Data.ColumnPropDesc("end-date", "Дата конца", Progress.Data.DataType:DATE).
    arrayvar2[5] = NEW Progress.Data.ColumnPropDesc("ext-code", "?", Progress.Data.DataType:CHARACTER).
    arrayvar2[6] = NEW Progress.Data.ColumnPropDesc("id", "id", Progress.Data.DataType:INT64).
    arrayvar2[7] = NEW Progress.Data.ColumnPropDesc("nameAction", "Наим. акции", Progress.Data.DataType:CHARACTER).
    tableDesc1:Columns = arrayvar2.
    THIS-OBJECT:bindAction:TableSchema = tableDesc1.
    /*  */
    /* tableLayoutPanel2 */
    /*  */
    THIS-OBJECT:tableLayoutPanel2:ColumnCount = 8.
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(250))).
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(66.6666565))).
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(50))).
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(60))).
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(150))).
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(35))).
    THIS-OBJECT:tableLayoutPanel2:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33.3333397))).
    THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:toolStrip1, 0, 0).
    THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:label1, 2, 0).
    THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:dateTimePicker1, 3, 0).
    THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:label2, 4, 0).
    THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:comboBox1, 5, 0).
    THIS-OBJECT:tableLayoutPanel2:Controls:Add(THIS-OBJECT:button1, 6, 0).
    THIS-OBJECT:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:tableLayoutPanel2:Location = NEW System.Drawing.Point(3, 3).
    THIS-OBJECT:tableLayoutPanel2:Name = "tableLayoutPanel2".
    THIS-OBJECT:tableLayoutPanel2:RowCount = 1.
    THIS-OBJECT:tableLayoutPanel2:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    THIS-OBJECT:tableLayoutPanel2:Size = NEW System.Drawing.Size(786, 34).
    THIS-OBJECT:tableLayoutPanel2:TabIndex = 3.
    /*  */
    /* toolStrip1 */
    /*  */
    THIS-OBJECT:toolStrip1:AutoSize = false.
    THIS-OBJECT:toolStrip1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:toolStrip1:ImageScalingSize = NEW System.Drawing.Size(32, 32).
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    DEFINE VARIABLE arrayvar3 AS System.Windows.Forms.ToolStripItem EXTENT 9 NO-UNDO.
    arrayvar3[1] = THIS-OBJECT:toolSBtn_Exit.
    arrayvar3[2] = THIS-OBJECT:toolSBtn_Ok.
    arrayvar3[3] = THIS-OBJECT:toolSBtn_Star.
    arrayvar3[4] = THIS-OBJECT:toolSBtn_Add.
    arrayvar3[5] = THIS-OBJECT:toolSBtn_Main.
    arrayvar3[6] = THIS-OBJECT:toolSBtn_View.
    arrayvar3[7] = THIS-OBJECT:toolSBtn_Edit.
    arrayvar3[8] = THIS-OBJECT:toolSBtn_Delete.
    arrayvar3[9] = THIS-OBJECT:toolSBtn_Print.
    THIS-OBJECT:toolStrip1:Items:AddRange(arrayvar3).
    THIS-OBJECT:toolStrip1:Location = NEW System.Drawing.Point(0, 0).
    THIS-OBJECT:toolStrip1:Name = "toolStrip1".
    THIS-OBJECT:toolStrip1:Size = NEW System.Drawing.Size(250, 34).
    THIS-OBJECT:toolStrip1:TabIndex = 2.
    THIS-OBJECT:toolStrip1:Text = "toolStrip1".
    THIS-OBJECT:toolStrip1:DoubleClick:Subscribe(THIS-OBJECT:toolStrip1_DoubleClick).
    /*  */
    /* toolSBtn_Exit */
    /*  */
    THIS-OBJECT:toolSBtn_Exit:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Exit:Image = CAST(resources:GetObject("toolSBtn_Exit.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Exit:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Exit:Name = "toolSBtn_Exit".
    THIS-OBJECT:toolSBtn_Exit:Size = NEW System.Drawing.Size(36, 31).
    THIS-OBJECT:toolSBtn_Exit:Text = "Выход".
    THIS-OBJECT:toolSBtn_Exit:Click:Subscribe(THIS-OBJECT:toolSBtn_Exit_Click).
    /*  */
    /* toolSBtn_Ok */
    /*  */
    THIS-OBJECT:toolSBtn_Ok:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Ok:Image = CAST(resources:GetObject("toolSBtn_Ok.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Ok:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Ok:Name = "toolSBtn_Ok".
    THIS-OBJECT:toolSBtn_Ok:Size = NEW System.Drawing.Size(36, 31).
    THIS-OBJECT:toolSBtn_Ok:Text = "Выбор".
    THIS-OBJECT:toolSBtn_Ok:Visible = false.
    THIS-OBJECT:toolSBtn_Ok:Click:Subscribe(THIS-OBJECT:toolSBtn_Ok_Click).
    /*  */
    /* toolSBtn_Star */
    /*  */
    THIS-OBJECT:toolSBtn_Star:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Star:Image = CAST(resources:GetObject("toolSBtn_Star.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Star:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Star:Name = "toolSBtn_Star".
    THIS-OBJECT:toolSBtn_Star:Size = NEW System.Drawing.Size(36, 31).
    THIS-OBJECT:toolSBtn_Star:Text = "Выделить все".
    THIS-OBJECT:toolSBtn_Star:Visible = false.
    THIS-OBJECT:toolSBtn_Star:Click:Subscribe(THIS-OBJECT:toolSBtn_Star_Click).
    /*  */
    /* toolSBtn_Add */
    /*  */
    THIS-OBJECT:toolSBtn_Add:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Add:Image = CAST(resources:GetObject("toolSBtn_Add.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Add:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Add:Name = "toolSBtn_Add".
    THIS-OBJECT:toolSBtn_Add:Size = NEW System.Drawing.Size(36, 31).
    THIS-OBJECT:toolSBtn_Add:Text = "Создать Акцию".
    THIS-OBJECT:toolSBtn_Add:Click:Subscribe(THIS-OBJECT:toolSBtn_Add_Click).
    /*  */
    /* toolSBtn_Main */
    /*  */
    THIS-OBJECT:toolSBtn_Main:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Main:Image = CAST(resources:GetObject("toolSBtn_Main.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Main:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Main:Name = "toolSBtn_Main".
    THIS-OBJECT:toolSBtn_Main:Size = NEW System.Drawing.Size(36, 31).
    THIS-OBJECT:toolSBtn_Main:Text = "Главная".
    THIS-OBJECT:toolSBtn_Main:Visible = false.
    THIS-OBJECT:toolSBtn_Main:Click:Subscribe(THIS-OBJECT:toolSBtn_Main_Click).
    /*  */
    /* toolSBtn_View */
    /*  */
    THIS-OBJECT:toolSBtn_View:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_View:Image = CAST(resources:GetObject("toolSBtn_View.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_View:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_View:Name = "toolSBtn_View".
    THIS-OBJECT:toolSBtn_View:Size = NEW System.Drawing.Size(36, 31).
    THIS-OBJECT:toolSBtn_View:Text = "Просмотр Акции".
    THIS-OBJECT:toolSBtn_View:Click:Subscribe(THIS-OBJECT:toolSBtn_View_Click).
    /*  */
    /* toolSBtn_Edit */
    /*  */
    THIS-OBJECT:toolSBtn_Edit:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Edit:Image = CAST(resources:GetObject("toolSBtn_Edit.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Edit:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Edit:Name = "toolSBtn_Edit".
    THIS-OBJECT:toolSBtn_Edit:Size = NEW System.Drawing.Size(36, 36).
    THIS-OBJECT:toolSBtn_Edit:Text = "Редактировать Акцию".
    THIS-OBJECT:toolSBtn_Edit:Click:Subscribe(THIS-OBJECT:toolSBtn_Edit_Click).
    /*  */
    /* toolSBtn_Delete */
    /*  */
    THIS-OBJECT:toolSBtn_Delete:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Delete:Image = CAST(resources:GetObject("toolSBtn_Delete.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Delete:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Delete:Name = "toolSBtn_Delete".
    THIS-OBJECT:toolSBtn_Delete:Size = NEW System.Drawing.Size(36, 36).
    THIS-OBJECT:toolSBtn_Delete:Text = "Удалить Акцию".
    THIS-OBJECT:toolSBtn_Delete:Click:Subscribe(THIS-OBJECT:toolSBtn_Delete_Click).
    /*  */
    /* toolSBtn_Print */
    /*  */
    THIS-OBJECT:toolSBtn_Print:DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle:Image.
    THIS-OBJECT:toolSBtn_Print:Image = CAST(resources:GetObject("toolSBtn_Print.Image"), System.Drawing.Image).
    THIS-OBJECT:toolSBtn_Print:ImageTransparentColor = System.Drawing.Color:Magenta.
    THIS-OBJECT:toolSBtn_Print:Name = "toolSBtn_Print".
    THIS-OBJECT:toolSBtn_Print:Size = NEW System.Drawing.Size(36, 36).
    THIS-OBJECT:toolSBtn_Print:Text = "Печать".
    THIS-OBJECT:toolSBtn_Print:Click:Subscribe(THIS-OBJECT:toolSBtn_Print_Click).
    /*  */
    /* label1 */
    /*  */
    THIS-OBJECT:label1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label1:Location = NEW System.Drawing.Point(313, 0).
    THIS-OBJECT:label1:Name = "label1".
    THIS-OBJECT:label1:Size = NEW System.Drawing.Size(44, 34).
    THIS-OBJECT:label1:TabIndex = 3.
    THIS-OBJECT:label1:Text = "Дата :".
    THIS-OBJECT:label1:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    THIS-OBJECT:label1:UseCompatibleTextRendering = true.
    /*  */
    /* dateTimePicker1 */
    /*  */
    THIS-OBJECT:dateTimePicker1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:dateTimePicker1:Location = NEW System.Drawing.Point(363, 3).
    THIS-OBJECT:dateTimePicker1:Name = "dateTimePicker1".
    THIS-OBJECT:dateTimePicker1:Size = NEW System.Drawing.Size(144, 20).
    THIS-OBJECT:dateTimePicker1:TabIndex = 4.
    /*  */
    /* label2 */
    /*  */
    THIS-OBJECT:label2:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:label2:Location = NEW System.Drawing.Point(513, 0).
    THIS-OBJECT:label2:Name = "label2".
    THIS-OBJECT:label2:Size = NEW System.Drawing.Size(54, 34).
    THIS-OBJECT:label2:TabIndex = 5.
    THIS-OBJECT:label2:Text = "Статус :".
    THIS-OBJECT:label2:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    THIS-OBJECT:label2:UseCompatibleTextRendering = true.
    /*  */
    /* comboBox1 */
    /*  */
    THIS-OBJECT:comboBox1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:comboBox1:FormattingEnabled = true.
    THIS-OBJECT:comboBox1:Location = NEW System.Drawing.Point(573, 3).
    THIS-OBJECT:comboBox1:Name = "comboBox1".
    THIS-OBJECT:comboBox1:Size = NEW System.Drawing.Size(144, 21).
    THIS-OBJECT:comboBox1:TabIndex = 6.
    /*  */
    /* button1 */
    /*  */
    THIS-OBJECT:button1:Image = CAST(resources:GetObject("button1.Image"), System.Drawing.Image).
    THIS-OBJECT:button1:Location = NEW System.Drawing.Point(720, 0).
    THIS-OBJECT:button1:Margin = NEW System.Windows.Forms.Padding(0).
    THIS-OBJECT:button1:Name = "button1".
    THIS-OBJECT:button1:Size = NEW System.Drawing.Size(35, 34).
    THIS-OBJECT:button1:TabIndex = 7.
    THIS-OBJECT:button1:UseCompatibleTextRendering = true.
    THIS-OBJECT:button1:UseVisualStyleBackColor = true.
    THIS-OBJECT:button1:Click:Subscribe(THIS-OBJECT:button1_Click).
    /*  */
    /* NameAction */
    /*  */
    THIS-OBJECT:NameAction:DataPropertyName = "NameAction".
    THIS-OBJECT:NameAction:FillWeight = Progress.Util.CastUtil:ToSingle(300).
    THIS-OBJECT:NameAction:HeaderText = "Наименование акции".
    THIS-OBJECT:NameAction:Name = "NameAction".
    THIS-OBJECT:NameAction:Width = 407.
    /*  */
    /* dataGridViewTextBoxColumn1 */
    /*  */
    THIS-OBJECT:dataGridViewTextBoxColumn1:DataPropertyName = "NameAction".
    THIS-OBJECT:dataGridViewTextBoxColumn1:HeaderText = "NameAction".
    THIS-OBJECT:dataGridViewTextBoxColumn1:Name = "dataGridViewTextBoxColumn1".
    /*  */
    /* Chang */
    /*  */
    THIS-OBJECT:Chang:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:None.
    THIS-OBJECT:Chang:DataPropertyName = "Chang".
    THIS-OBJECT:Chang:FillWeight = Progress.Util.CastUtil:ToSingle(40.6091385).
    THIS-OBJECT:Chang:HeaderText = "".
    THIS-OBJECT:Chang:Name = "Chang".
    THIS-OBJECT:Chang:Width = 20.
    /*  */
    /* dataGridViewTextBoxColumn2 */
    /*  */
    THIS-OBJECT:dataGridViewTextBoxColumn2:DataPropertyName = "nameAction".
    THIS-OBJECT:dataGridViewTextBoxColumn2:FillWeight = Progress.Util.CastUtil:ToSingle(101.9434814).
    THIS-OBJECT:dataGridViewTextBoxColumn2:HeaderText = "Наименование".
    THIS-OBJECT:dataGridViewTextBoxColumn2:Name = "dataGridViewTextBoxColumn2".
    THIS-OBJECT:dataGridViewTextBoxColumn2:Width = 138.
    /*  */
    /* begdateDataGridViewTextBoxColumn */
    /*  */
    THIS-OBJECT:begdateDataGridViewTextBoxColumn:DataPropertyName = "beg-date".
    THIS-OBJECT:begdateDataGridViewTextBoxColumn:FillWeight = Progress.Util.CastUtil:ToSingle(122.1251755).
    THIS-OBJECT:begdateDataGridViewTextBoxColumn:HeaderText = "Дата начала".
    THIS-OBJECT:begdateDataGridViewTextBoxColumn:Name = "begdateDataGridViewTextBoxColumn".
    THIS-OBJECT:begdateDataGridViewTextBoxColumn:Width = 166.
    /*  */
    /* enddateDataGridViewTextBoxColumn */
    /*  */
    THIS-OBJECT:enddateDataGridViewTextBoxColumn:DataPropertyName = "end-date".
    THIS-OBJECT:enddateDataGridViewTextBoxColumn:FillWeight = Progress.Util.CastUtil:ToSingle(122.1251755).
    THIS-OBJECT:enddateDataGridViewTextBoxColumn:HeaderText = "Дата окончания".
    THIS-OBJECT:enddateDataGridViewTextBoxColumn:Name = "enddateDataGridViewTextBoxColumn".
    THIS-OBJECT:enddateDataGridViewTextBoxColumn:Width = 166.
    /*  */
    /* status_lbl */
    /*  */
    THIS-OBJECT:status_lbl:DataPropertyName = "status_lbl".
    THIS-OBJECT:status_lbl:FillWeight = Progress.Util.CastUtil:ToSingle(101.9434814).
    THIS-OBJECT:status_lbl:HeaderText = "Статус".
    THIS-OBJECT:status_lbl:Name = "status_lbl".
    THIS-OBJECT:status_lbl:Width = 138.
    /*  */
    /* id */
    /*  */
    THIS-OBJECT:id:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:None.
    THIS-OBJECT:id:DataPropertyName = "id".
    THIS-OBJECT:id:FillWeight = Progress.Util.CastUtil:ToSingle(91.456604).
    THIS-OBJECT:id:HeaderText = "id".
    THIS-OBJECT:id:Name = "id".
    THIS-OBJECT:id:Width = 50.
    /*  */
    /* wListActions */
    /*  */
    THIS-OBJECT:ClientSize = NEW System.Drawing.Size(792, 512).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel1).
    THIS-OBJECT:Name = "wListActions".
    THIS-OBJECT:Text = "Список акций".
    THIS-OBJECT:KeyDown:Subscribe(THIS-OBJECT:wListActions_KeyDown).
    THIS-OBJECT:tableLayoutPanel1:ResumeLayout(false).
    CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
    CAST(THIS-OBJECT:bindAction, System.ComponentModel.ISupportInitialize):EndInit().
    THIS-OBJECT:tableLayoutPanel2:ResumeLayout(false).
    THIS-OBJECT:toolStrip1:ResumeLayout(false).
    THIS-OBJECT:toolStrip1:PerformLayout().
    THIS-OBJECT:ResumeLayout(false).
    CATCH e AS Progress.Lang.Error:
      UNDO, THROW e.
    END CATCH.
    end method.

    /*------------------------------------------------------------------------------
     Purpose: Резерв!
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void toolSBtn_Main_Click( input sender as System.Object, input e as System.EventArgs ):
        
        return.

    end method.

	/*------------------------------------------------------------------------------
     Purpose: вызвать в _trg метод создания и запуска формы редактирования с экземпляром класса редактируемой записи на входе
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void toolSBtn_Add_Click( input sender as System.Object, input e as System.EventArgs ):
		
    /* текущая строка data-grid автоматом позиционирует буффер по строке temp-table;
       позиционируется буффер, рамположенный в _trg по экземпляру таблицы tt-promoaction из _trg;
       записи в локальном экземпляре таблицы tt-promoaction отсутствуют
    */
      viewaction().
      return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void toolSBtn_Print_Click( input sender as System.Object, input e as System.EventArgs ):
    m-promo-trg:printPromoActionList() .
		return.
	end method.

    method private void viewaction():
        
    /* текущая строка data-grid автоматом позиционирует буффер по строке temp-table;
       позиционируется буффер, рамположенный в _trg по экземпляру таблицы tt-promoaction из _trg;
       записи в локальном экземпляре таблицы tt-promoaction отсутствуют
    */
    m-promo-trg:addOnePromo() . 
      /* получает созданную запись. Либо он её получит, либо мы его рефрешим.
        добавть запись - assignItem()
      */
      bindAction:handle:query-open.
      bindAction:Refreshall().
      return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void toolSBtn_Edit_Click( input sender as System.Object, input e as System.EventArgs ):
	    m-promo-trg:editOnePromo().
	    
	    bindAction:Refresh().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID toolSBtn_Ok_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		bindAction:Assign().
		oPromoActionSubs = m-promo-trg:ReturnSubsPromoAction(). 
		Close().
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void toolSBtn_Star_Click( input sender as System.Object, input e as System.EventArgs ):
		m-promo-trg:changeRow(yes).
		bindAction:Refreshall().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void toolSBtn_View_Click( input sender as System.Object, input e as System.EventArgs ):
		 m-promo-trg:viewOnePromo().
		 bindAction:Refresh().
		return.

	end method.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void toolSBtn_Delete_Click( input sender as System.Object, input e as System.EventArgs ):
        
        return.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void toolSBtn_Exit_Click( input sender as System.Object, input e as System.EventArgs ):
        Close().
        return.

    end method.



	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID toolStrip1_DoubleClick( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		Visual_Columns(NOT THIS-OBJECT:dataGridView1:Columns[6]:Visible).
		RETURN.

	END METHOD.


    METHOD PUBLIC VOID Visual_Buttons(INPUT sender AS LOGICAL): 
        
        assign
            THIS-OBJECT:toolSBtn_Add:Visible                = not sender
            THIS-OBJECT:toolSBtn_Edit:Visible               = not sender
            THIS-OBJECT:toolSBtn_Add:Visible                = not sender
            THIS-OBJECT:toolSBtn_Delete:Visible             = not sender
            THIS-OBJECT:toolSBtn_Print:Visible              = not sender
            THIS-OBJECT:toolSBtn_Ok:Visible                 =     sender
            THIS-OBJECT:toolSBtn_Star:Visible               =     sender
            THIS-OBJECT:dataGridView1:Columns[0]:Visible    = sender
        .
        

    END METHOD.
    METHOD PUBLIC VOID Visual_Columns(INPUT sender AS LOGICAL): 
        
        assign
            THIS-OBJECT:dataGridView1:Columns[6]:Visible = sender.
            THIS-OBJECT:dataGridView1:Columns[5]:Visible = sender.
        .
        

    END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void wListActions_KeyPress( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs ):
		message e:KeyChar
        view-as alert-box.
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID wListActions_KeyDown( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.KeyEventArgs ):
	    
		IF   e:KeyCode = Keys:F3 AND e:Shift AND e:Alt 
         THEN
        DO:
          MESSAGE "Тест F3  Shift Alt"
            VIEW-AS ALERT-BOX.
        END.
		RETURN.

	END METHOD.

end class.