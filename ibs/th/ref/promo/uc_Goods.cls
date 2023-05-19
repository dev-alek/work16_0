 
 /*------------------------------------------------------------------------
    File        : uc_Goods
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : mshavlov
    Created     : Tue Jul 31 13:00:01 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Windows.UserControl.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ibs.th.ref.promo.uc_Goods INHERITS UserControl: 
  { cmp/str-glbl.i class }     
  define private variable bccodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable bindGoods as Progress.Data.BindingSource no-undo.
    DEFINE PRIVATE VARIABLE button3 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button2 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
  define private variable button4 as System.Windows.Forms.Button no-undo.
  define private variable button6 as System.Windows.Forms.Button no-undo.
  define private variable button5 as System.Windows.Forms.Button no-undo.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.
  define private variable gdscodeDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsName as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable gdsNameDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable qntyDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable priceDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    define private variable nameSetDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
    DEFINE PRIVATE VARIABLE tableLayoutPanel2 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    define variable mCrit as logical no-undo.
    define variable PromoSet as logical no-undo.
    define variable PromoSetFix as logical no-undo.
    define variable PromoSetGoods as logical no-undo.
    define variable Promovisa as logical no-undo.
    define variable PromoBarCode as logical no-undo .
    define variable PromoBarCodeFix as logical no-undo .
    define variable PromoGoodsApplFix as logical no-undo .

    define property pCrit as logical no-undo
    private get.

    set(input iCrit as logical):
       mCrit = iCrit.
       this-object:PromoSet = no.
       this-object:PromoSetGoods = no.
       this-object:Promovisa = no.
       this-object:PromoBarCode = no.
       this-object:PromoBarCodeFix = no.
       this-object:PromoGoodsApplFix = no .
    end.
    define property pPromoSet as logical no-undo
    private get.
    set(input iPromoSet as logical):
       this-object:mCrit = no.
       PromoSet = iPromoSet.
       this-object:PromoSetFix = no.
       this-object:PromoSetGoods = no.
       this-object:Promovisa = no.
       this-object:PromoBarCode = no.
       this-object:PromoBarCodeFix = no.
       this-object:PromoGoodsApplFix = no .
    end.
    define property pPromoSetFix as logical no-undo
    private get.
    set(input iPromoSetFix as logical):
       this-object:mCrit = no.
       this-object:PromoSet = no.
       PromoSetFix = iPromoSetFix.
       this-object:PromoSetGoods = no.
       this-object:Promovisa = no.
       this-object:PromoBarCode = no.
       this-object:PromoBarCodeFix = no.
       this-object:PromoGoodsApplFix = no .
    end.    
    define property pPromoSetGoods as logical no-undo
    private get.
    set(input iPromoSetGoods as logical):
       this-object:mCrit = no.
       this-object:PromoSet = no.
       this-object:PromoSetFix = no.
       PromoSetGoods = iPromoSetGoods.
       this-object:Promovisa = no.
       this-object:PromoBarCode = no.
       this-object:PromoBarCodeFix = no.
       this-object:PromoGoodsApplFix = no .
    end.
    define property pPromovisa as logical no-undo
    private get.
    set(input iPromovisa as logical):
       this-object:mCrit = no.
       this-object:PromoSet = no.
       this-object:PromoSetFix = no.
       this-object:PromoSetGoods = no.
       Promovisa = iPromovisa.
       this-object:PromoBarCodeFix = no.
       this-object:PromoBarCode = no.
       this-object:PromoGoodsApplFix = no .
    end.
    define property pPromoBarCode as logical no-undo
    private get.
    set(input iPromobarcode as logical):
       this-object:mCrit = no.
       this-object:PromoSet = no.
       this-object:PromoSetFix = no.
       this-object:PromoSetGoods = no.
       this-object:Promovisa = no.
       this-object:PromoBarCodeFix = no.
       PromoBarCode = iPromobarcode.
       this-object:PromoGoodsApplFix = no .
    end.     
    define property pPromoBarCodeFix as logical no-undo
    private get.
    set(input iPromobarcodeFix as logical):
       this-object:mCrit = no.
       this-object:PromoSet = no.
       this-object:PromoSetFix = no.
       this-object:PromoSetGoods = no.
       this-object:Promovisa = no.
       this-object:PromoBarCode = no.
       PromoBarCodeFix = iPromobarcodeFix.
       this-object:PromoGoodsApplFix = no .
    end.     
    define property pPromoGoodsApplFix as logical no-undo
    private get.
    set(input iPromoGoodsApplFix as logical):
       this-object:mCrit = no.
       this-object:PromoSet = no.
       this-object:PromoSetFix = no.
       this-object:PromoSetGoods = no.
       this-object:Promovisa = no.
       this-object:PromoBarCode = no.
       this-object:PromoBarCodeFix = no.
       PromoGoodsApplFix = iPromoGoodsApplFix.
    end.      
    define private variable mBind  as character no-undo.
    
    {ibs/th/ref/promo/promo_trg_heder.i }  
      
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button1_Click( input sender as System.Object, input e as System.EventArgs ):
	  bindGoods:Assign(). 
	  m-promo-trg:addgds(mBind).
  	bindGoods:handle:query-open.
  	bindGoods:RefreshAll().
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button2_Click( input sender as System.Object, input e as System.EventArgs ):
		m-promo-trg:delgds(mBind).
		bindGoods:handle:query-open.
    bindGoods:RefreshAll().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button5_Click( input sender as System.Object, input e as System.EventArgs ):
    m-promo-trg:printgds(mBind).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_CellContentClick( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_CellMouseClick( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellMouseEventArgs ):
		bindGoods:Assign().
		if promoset or promosetfix
		then
		    m-promo-trg:PublicEventForForm("changePromoset", "").
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView1_RowsAdded( input sender as System.Object, input e as System.Windows.Forms.DataGridViewRowsAddedEventArgs ):
		/*if PromoSet 
		then
		    m-promo-trg:addPromoSet().*/ 
		return.

	end method.

    method Public VOID SetBind( ):
        define variable vLable as character no-undo.
        if mCrit 
        then assign
            mBind  = "PromoGoodsCrit"
            vLable = "Независимые условия"
        .
        else if PromoSet 
        then assign
            mBind  = "PromoSet"
            vLable = "Промо набор"
        .
        else if PromoSetFix 
        then assign
            mBind  = "PromoSet"
            vLable = "Промо набор"
        .
        else if PromoSetgoods 
        then assign
            mBind  = "PromoSetgoods"
            vLable = "Товары"
        .
        else if Promovisa
        then  assign
            mBind  = "PromoCardsBin"
            vLable = "Карты Visa"
        .
        else if PromoBarCode
        then assign
            mBind  = "PromoBarCode"
            vLable = "Штрих коды"        
        .
        else if PromoBarCodeFix
        then assign
            mBind  = "PromoBarCode"
            vLable = "Штрих коды"        
        .        
        else if PromoGoodsApplFix
        then assign
            mBind  = "PromoGoodsApplFix"
            vLable = "Товары"        
        . 
        else assign
            mBind  = "PromoGoodsAppl"
            vLable = "Товары"
        .
        
        SetBind(no).
        label1:text = vLable.
        if PromoSet 
        then assign
            THIS-OBJECT:dataGridView1:Columns[0]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[1]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[2]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[3]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[4]:HeaderText = "Количество"
            THIS-OBJECT:dataGridView1:Columns[3]:HeaderText = "Скидка, %"
            THIS-OBJECT:dataGridView1:Columns[5]:Visible = no
     
            /* this-object:button1:Visible = no
            this-object:button2:Visible = no */
           // THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
        .
        else if PromoSetFix 
        then assign
            THIS-OBJECT:dataGridView1:Columns[0]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[1]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[2]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[3]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[4]:HeaderText = "Количество"
            THIS-OBJECT:dataGridView1:Columns[5]:Visible = no
     
            /* this-object:button1:Visible = no
            this-object:button2:Visible = no */
           // THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
        .        
        else if Promovisa then assign
            THIS-OBJECT:dataGridView1:Columns[0]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[1]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[2]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[2]:HeaderText = "Бины карт"
            THIS-OBJECT:dataGridView1:Columns[3]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[5]:Visible = no
                        
            
           // THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
        .
        else if PromoBarCode then
        assign
            THIS-OBJECT:dataGridView1:Columns[0]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[1]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[2]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[3]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[5]:Visible = yes
            
            this-object:button3:Visible = no
            this-object:button4:Visible = no
            
            this-object:button5:Visible = yes
            this-object:button6:Visible = yes
            
           // THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
        .        
        else if PromoBarCodeFix then
        assign
            THIS-OBJECT:dataGridView1:Columns[0]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[1]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[2]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[3]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[5]:Visible = yes
            
            this-object:button3:Visible = no
            this-object:button4:Visible = no
            this-object:button5:Visible = yes
            this-object:button6:Visible = yes
            
           // THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
        . 
        else if PromoGoodsApplFix then
        assign
            THIS-OBJECT:dataGridView1:Columns[0]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[1]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[2]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[3]:Visible = yes
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = no
            THIS-OBJECT:dataGridView1:Columns[5]:Visible = no
            
            this-object:button3:Visible = no
            this-object:button4:Visible = no
            this-object:button5:Visible = no
            this-object:button6:Visible = no
            
           // THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes
        . 
    end.
    method Public VOID SetBind(input iflag as logical ):
        bindGoods:handle = m-promo-trg:getQuery(mBind,iflag).
        setDisable(m-promo-trg:modeVIEW). 
        if iflag 
        then
            bindGoods:RefreshAll().
            
    end method.
    method Public VOID LocalEvent(input iEvent as character, input iEventParam as character  ):
        if iEvent eq "changePromoSet" and promosetgoods
        then
            SetBind(yes).
        else if iEvent eq "showDiscontForset" and promoset
        then assign 
            THIS-OBJECT:dataGridView1:Columns[4]:HeaderText = "Скидка, %"
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes .
        else if iEvent eq "showPrice" and not promoset and not mCrit and not promosetgoods
        then assign 
            THIS-OBJECT:dataGridView1:Columns[4]:HeaderText = "Цена, руб"
            THIS-OBJECT:dataGridView1:Columns[4]:Visible = yes .
    end.
    method public VOID setDisable(input iModeView as logical  ):
        assign
            button1:enabled = not iModeview 
            button2:enabled = not iModeview
            button3:enabled = not iModeview

            button6:enabled = not iModeview
            THIS-OBJECT:dataGridView1:Columns[2]:ReadOnly = iModeview
            THIS-OBJECT:dataGridView1:Columns[3]:ReadOnly = iModeview
            THIS-OBJECT:dataGridView1:Columns[4]:ReadOnly = iModeview
            
         //   THIS-OBJECT:dataGridView1:Columns[6]:ReadOnly = pMode
        .
    end.
        
    CONSTRUCTOR PUBLIC uc_Goods (  ):
        
        
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
    tableDesc1 = new Progress.Data.TableDesc("tt-PromoGoods").
    this-object:tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel().
    this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
    this-object:gdscodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:gdsNameDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:nameSetDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:priceDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:qntyDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:bccodeDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:bindGoods = new Progress.Data.BindingSource(this-object:components).
    this-object:tableLayoutPanel2 = new System.Windows.Forms.TableLayoutPanel().
    this-object:button5 = new System.Windows.Forms.Button().
    this-object:button6 = new System.Windows.Forms.Button().
    this-object:button3 = new System.Windows.Forms.Button().
    this-object:button2 = new System.Windows.Forms.Button().
    this-object:button1 = new System.Windows.Forms.Button().
    this-object:button4 = new System.Windows.Forms.Button().
    this-object:label1 = new System.Windows.Forms.Label().
    this-object:gdsName = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:tableLayoutPanel1:SuspendLayout().
    cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
    cast(this-object:bindGoods, System.ComponentModel.ISupportInitialize):BeginInit().
    this-object:tableLayoutPanel2:SuspendLayout().
    this-object:SuspendLayout().
    /*  */
    /* tableLayoutPanel1 */
    /*  */
    this-object:tableLayoutPanel1:ColumnCount = 1.
    this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
    this-object:tableLayoutPanel1:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(20))).
    this-object:tableLayoutPanel1:Controls:Add(this-object:dataGridView1, 0, 2).
    this-object:tableLayoutPanel1:Controls:Add(this-object:tableLayoutPanel2, 0, 1).
    this-object:tableLayoutPanel1:Controls:Add(this-object:label1, 0, 0).
    this-object:tableLayoutPanel1:Dock = System.Windows.Forms.DockStyle:Fill.
    this-object:tableLayoutPanel1:Location = new System.Drawing.Point(0, 0).
    this-object:tableLayoutPanel1:Name = "tableLayoutPanel1".
    this-object:tableLayoutPanel1:RowCount = 3.
    this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
    this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(25))).
    this-object:tableLayoutPanel1:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    this-object:tableLayoutPanel1:Size = new System.Drawing.Size(500, 400).
    this-object:tableLayoutPanel1:TabIndex = 4.
    /*  */
    /* dataGridView1 */
    /*  */
    this-object:dataGridView1:AllowUserToAddRows = false.
    this-object:dataGridView1:AllowUserToDeleteRows = false.
    this-object:dataGridView1:AutoGenerateColumns = false.
    this-object:dataGridView1:AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode:Fill.
    this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 6 no-undo.
    arrayvar0[1] = this-object:gdscodeDataGridViewTextBoxColumn.
    arrayvar0[2] = this-object:gdsNameDataGridViewTextBoxColumn.
    arrayvar0[3] = this-object:nameSetDataGridViewTextBoxColumn.
    arrayvar0[4] = this-object:priceDataGridViewTextBoxColumn.
    arrayvar0[5] = this-object:qntyDataGridViewTextBoxColumn.
    arrayvar0[6] = this-object:bccodeDataGridViewTextBoxColumn.
    this-object:dataGridView1:Columns:AddRange(arrayvar0).
    this-object:dataGridView1:DataSource = this-object:bindGoods.
    this-object:dataGridView1:Dock = System.Windows.Forms.DockStyle:Fill.
    this-object:dataGridView1:Location = new System.Drawing.Point(3, 53).
    this-object:dataGridView1:Name = "dataGridView1".
    this-object:dataGridView1:RowHeadersVisible = false.
    this-object:dataGridView1:Size = new System.Drawing.Size(494, 344).
    this-object:dataGridView1:TabIndex = 8.
    this-object:dataGridView1:CellContentClick:Subscribe(this-object:dataGridView1_CellContentClick).
    this-object:dataGridView1:CellMouseClick:Subscribe(this-object:dataGridView1_CellMouseClick).
    this-object:dataGridView1:RowsAdded:Subscribe(this-object:dataGridView1_RowsAdded).
    /*  */
    /* gdscodeDataGridViewTextBoxColumn */
    /*  */
    this-object:gdscodeDataGridViewTextBoxColumn:DataPropertyName = "gds-code".
    this-object:gdscodeDataGridViewTextBoxColumn:HeaderText = "Код товара".
    this-object:gdscodeDataGridViewTextBoxColumn:Name = "gdscodeDataGridViewTextBoxColumn".
    /*  */
    /* gdsNameDataGridViewTextBoxColumn */
    /*  */
    this-object:gdsNameDataGridViewTextBoxColumn:DataPropertyName = "gdsName".
    this-object:gdsNameDataGridViewTextBoxColumn:HeaderText = "Номенклатура".
    this-object:gdsNameDataGridViewTextBoxColumn:Name = "gdsNameDataGridViewTextBoxColumn".
    /*  */
    /* nameSetDataGridViewTextBoxColumn */
    /*  */
    this-object:nameSetDataGridViewTextBoxColumn:DataPropertyName = "NameSet".
    this-object:nameSetDataGridViewTextBoxColumn:HeaderText = "Наименование промо набора".
    this-object:nameSetDataGridViewTextBoxColumn:Name = "nameSetDataGridViewTextBoxColumn".
    this-object:nameSetDataGridViewTextBoxColumn:Visible = false.
    /*  */
    /* priceDataGridViewTextBoxColumn */
    /*  */
    this-object:priceDataGridViewTextBoxColumn:DataPropertyName = "price".
    this-object:priceDataGridViewTextBoxColumn:HeaderText = "Цена".
    this-object:priceDataGridViewTextBoxColumn:Name = "priceDataGridViewTextBoxColumn".
    this-object:priceDataGridViewTextBoxColumn:Visible = false.
    /*  */
    /* qntyDataGridViewTextBoxColumn */
    /*  */
    this-object:qntyDataGridViewTextBoxColumn:DataPropertyName = "qnty".
    this-object:qntyDataGridViewTextBoxColumn:HeaderText = "Количество".
    this-object:qntyDataGridViewTextBoxColumn:Name = "qntyDataGridViewTextBoxColumn".
    this-object:qntyDataGridViewTextBoxColumn:Visible = false.
    /*  */
    /* bccodeDataGridViewTextBoxColumn */
    /*  */
    this-object:bccodeDataGridViewTextBoxColumn:DataPropertyName = "bc-code".
    this-object:bccodeDataGridViewTextBoxColumn:HeaderText = "ШК".
    this-object:bccodeDataGridViewTextBoxColumn:Name = "bccodeDataGridViewTextBoxColumn".
    this-object:bccodeDataGridViewTextBoxColumn:Visible = false.
    /*  */
    /* bindGoods */
    /*  */
    this-object:bindGoods:AutoUpdate = true.
    this-object:bindGoods:MaxDataGuess = 0.
    this-object:bindGoods:NoLOBs = false.
    this-object:bindGoods:Position = 0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
    arrayvar1 = new "Progress.Data.TableDesc[]"(0).
    tableDesc1:ChildTables = arrayvar1.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 6 no-undo.
    arrayvar2[1] = new Progress.Data.ColumnPropDesc("gdsName", "Номенклатура", Progress.Data.DataType:CHARACTER).
    arrayvar2[2] = new Progress.Data.ColumnPropDesc("gds-code", "gds-code", Progress.Data.DataType:INTEGER).
    arrayvar2[3] = new Progress.Data.ColumnPropDesc("NameSet", "Наименование промо набора", Progress.Data.DataType:CHARACTER).
    arrayvar2[4] = new Progress.Data.ColumnPropDesc("price", "Цена", Progress.Data.DataType:DECIMAL).
    arrayvar2[5] = new Progress.Data.ColumnPropDesc("qnty", "Количество", Progress.Data.DataType:DECIMAL).
    arrayvar2[6] = new Progress.Data.ColumnPropDesc("bc-code", "ШК", Progress.Data.DataType:CHARACTER).
    tableDesc1:Columns = arrayvar2.
    this-object:bindGoods:TableSchema = tableDesc1.
    /*  */
    /* tableLayoutPanel2 */
    /*  */
    this-object:tableLayoutPanel2:ColumnCount = 6.
    this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
    this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
    this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
    this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
    this-object:tableLayoutPanel2:ColumnStyles:Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(80))).
    this-object:tableLayoutPanel2:Controls:Add(this-object:button5, 4, 0).
    this-object:tableLayoutPanel2:Controls:Add(this-object:button6, 5, 0).
    this-object:tableLayoutPanel2:Controls:Add(this-object:button3, 2, 0).
    this-object:tableLayoutPanel2:Controls:Add(this-object:button2, 1, 0).
    this-object:tableLayoutPanel2:Controls:Add(this-object:button1, 0, 0).
    this-object:tableLayoutPanel2:Controls:Add(this-object:button4, 3, 0).
    this-object:tableLayoutPanel2:Dock = System.Windows.Forms.DockStyle:Fill.
    this-object:tableLayoutPanel2:Location = new System.Drawing.Point(3, 25).
    this-object:tableLayoutPanel2:Margin = new System.Windows.Forms.Padding(3, 0, 0, 0).
    this-object:tableLayoutPanel2:Name = "tableLayoutPanel2".
    this-object:tableLayoutPanel2:RowCount = 1.
    this-object:tableLayoutPanel2:RowStyles:Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(100))).
    this-object:tableLayoutPanel2:Size = new System.Drawing.Size(497, 25).
    this-object:tableLayoutPanel2:TabIndex = 0.
    /*  */
    /* button5 */
    /*  */
    this-object:button5:Dock = System.Windows.Forms.DockStyle:Fill.
    this-object:button5:Location = new System.Drawing.Point(337, 0).
    this-object:button5:Margin = new System.Windows.Forms.Padding(0).
    this-object:button5:Name = "button5".
    this-object:button5:Size = new System.Drawing.Size(80, 25).
    this-object:button5:TabIndex = 5.
    this-object:button5:Text = "Печать ШК".
    this-object:button5:UseCompatibleTextRendering = true.
    this-object:button5:UseVisualStyleBackColor = true.
    this-object:button5:Visible = false.
    this-object:button5:Click:Subscribe(this-object:button5_Click).
    /*  */
    /* button6 */
    /*  */
    this-object:button6:Dock = System.Windows.Forms.DockStyle:Fill.
    this-object:button6:Location = new System.Drawing.Point(417, 0).
    this-object:button6:Margin = new System.Windows.Forms.Padding(0).
    this-object:button6:Name = "button6".
    this-object:button6:Size = new System.Drawing.Size(80, 25).
    this-object:button6:TabIndex = 4.
    this-object:button6:Text = "Удалить ШК".
    this-object:button6:UseCompatibleTextRendering = true.
    this-object:button6:UseVisualStyleBackColor = true.
    this-object:button6:Visible = false.
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
    this-object:button3:Visible = false.
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
    this-object:button2:Click:Subscribe(this-object:button2_Click).
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
    this-object:button1:Click:Subscribe(this-object:button1_Click).
    /*  */
    /* button4 */
    /*  */
    this-object:button4:Dock = System.Windows.Forms.DockStyle:Fill.
    this-object:button4:Location = new System.Drawing.Point(280, 0).
    this-object:button4:Margin = new System.Windows.Forms.Padding(0).
    this-object:button4:Name = "button4".
    this-object:button4:Size = new System.Drawing.Size(57, 25).
    this-object:button4:TabIndex = 3.
    this-object:button4:Text = "button4".
    this-object:button4:UseCompatibleTextRendering = true.
    this-object:button4:UseVisualStyleBackColor = true.
    this-object:button4:Visible = false.
    /*  */
    /* label1 */
    /*  */
    this-object:label1:Dock = System.Windows.Forms.DockStyle:Fill.
    this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label1:Location = new System.Drawing.Point(3, 0).
    this-object:label1:Name = "label1".
    this-object:label1:Size = new System.Drawing.Size(494, 25).
    this-object:label1:TabIndex = 4.
    this-object:label1:Text = "Товар".
    this-object:label1:UseCompatibleTextRendering = true.
    /*  */
    /* gdsName */
    /*  */
    this-object:gdsName:DataPropertyName = "gds-code".
    this-object:gdsName:FillWeight = Progress.Util.CastUtil:ToSingle(55.8375626).
    this-object:gdsName:HeaderText = "Код товара".
    this-object:gdsName:Name = "gdsName".
    this-object:gdsName:ReadOnly = true.
    this-object:gdsName:Width = 176.
    /*  */
    /* uc_Goods */
    /*  */
    this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
    this-object:Controls:Add(this-object:tableLayoutPanel1).
    this-object:Margin = new System.Windows.Forms.Padding(0).
    this-object:Name = "uc_Goods".
    this-object:Size = new System.Drawing.Size(500, 400).
    this-object:tableLayoutPanel1:ResumeLayout(false).
    cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
    cast(this-object:bindGoods, System.ComponentModel.ISupportInitialize):EndInit().
    this-object:tableLayoutPanel2:ResumeLayout(false).
    this-object:ResumeLayout(false).
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
    END METHOD.

    DESTRUCTOR PUBLIC uc_Goods ( ):
        bindGoods:Assign().
        bindGoods:Dispose().
    END DESTRUCTOR.

END CLASS.