 
 /*------------------------------------------------------------------------
    File        : Coins_Banknot
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : eshklyar
    Created     : Sat Nov 02 13:33:04 MSK 2019
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.Form.

block-level on error undo, throw.

class ibs.th.ref.Coins_Banknot inherits Form: 
  { ibs\th\ref\Coins_Bank_tt.i }
    
  define private variable bindingSource_Coins as Progress.Data.BindingSource no-undo.
  define private variable bindingSource_Bank as Progress.Data.BindingSource no-undo.
  define private variable components as System.ComponentModel.IContainer no-undo.
  define private variable dataGridView2 as System.Windows.Forms.DataGridView no-undo.
  define private variable dataGridView1 as System.Windows.Forms.DataGridView no-undo.
  define private variable sumqntyDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  define private variable sumqntyDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  define private variable qntyDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  define private variable qntyDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  define private variable idDataGridViewTextBoxColumn1 as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  define private variable idDataGridViewTextBoxColumn as System.Windows.Forms.DataGridViewTextBoxColumn no-undo.
  define         variable hQuery1                               as handle                                         no-undo .
  define         variable hQuery2                               as handle                                         no-undo .

    
  constructor public Coins_Banknot (  ):
    
    
    super().
    InitializeComponent().
    bindingSource_Coins:Handle = browse_Coints().
    bindingSource_Bank:Handle = browse_Banknot().
    this-object:ComponentsCollection:ADD(this-object:components).
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.

  end constructor.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void click_change_( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):
	
	define variable vi as integer no-undo.
	for each tt-banknots by tt-banknots.id:
	  vi = vi + 1.
	  if vi =	e:RowIndex then
	  tt-banknots.sum-qnty = tt-banknots.id * tt-banknots.qnty .
  end.
  bindingSource_Coins:Refresh().	  
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void Coins_Banknot_Load( input sender as System.Object, input e as System.EventArgs ):
		
		return.

	end method.


	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView2_CellContentClick( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void dataGridView2_CellValueChanged( input sender as System.Object, input e as System.Windows.Forms.DataGridViewCellEventArgs ):

  define variable vi as integer no-undo.
  for each tt-coins by tt-coins.id:
    vi = vi + 1.
    if vi = e:RowIndex then
    tt-coins.sum-qnty = tt-coins.id * tt-coins.qnty .
  end.
  bindingSource_Coins:Refresh().
		return.

	end method.

  method private void InitializeComponent(  ):
    
    /* NOTE: The following method is automatically generated.
    
    We strongly suggest that the contents of this method only be modified using the
    Visual Designer to avoid any incompatible modifications.
    
    Modifying the contents of this method using a code editor will invalidate any support for this file. */
    this-object:components = new System.ComponentModel.Container().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle1 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle1 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle2 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle2 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle3 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle3 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle4 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle4 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable tableDesc1 as Progress.Data.TableDesc no-undo.
    tableDesc1 = new Progress.Data.TableDesc("tt-banknots").
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle5 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle5 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle6 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle6 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle7 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable dataGridViewCellStyle8 as System.Windows.Forms.DataGridViewCellStyle no-undo.
    dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle().
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable tableDesc2 as Progress.Data.TableDesc no-undo.
    tableDesc2 = new Progress.Data.TableDesc("tt-coins").
    this-object:dataGridView1 = new System.Windows.Forms.DataGridView().
    this-object:idDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:qntyDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:sumqntyDataGridViewTextBoxColumn1 = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:bindingSource_Bank = new Progress.Data.BindingSource(this-object:components).
    this-object:dataGridView2 = new System.Windows.Forms.DataGridView().
    this-object:idDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:qntyDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:sumqntyDataGridViewTextBoxColumn = new System.Windows.Forms.DataGridViewTextBoxColumn().
    this-object:bindingSource_Coins = new Progress.Data.BindingSource(this-object:components).
    cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
    cast(this-object:bindingSource_Bank, System.ComponentModel.ISupportInitialize):BeginInit().
    cast(this-object:dataGridView2, System.ComponentModel.ISupportInitialize):BeginInit().
    cast(this-object:bindingSource_Coins, System.ComponentModel.ISupportInitialize):BeginInit().
    this-object:SuspendLayout().
    /*  */
    /* dataGridView1 */
    /*  */
    this-object:dataGridView1:AllowUserToAddRows = false.
    this-object:dataGridView1:AllowUserToDeleteRows = false.
    this-object:dataGridView1:AutoGenerateColumns = false.
    this-object:dataGridView1:BackgroundColor = System.Drawing.SystemColors:ButtonFace.
    dataGridViewCellStyle1:Alignment = System.Windows.Forms.DataGridViewContentAlignment:TopCenter.
    dataGridViewCellStyle1:BackColor = System.Drawing.SystemColors:ControlDark.
    dataGridViewCellStyle1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    dataGridViewCellStyle1:ForeColor = System.Drawing.SystemColors:WindowText.
    dataGridViewCellStyle1:SelectionBackColor = System.Drawing.SystemColors:HighlightText.
    dataGridViewCellStyle1:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
    dataGridViewCellStyle1:WrapMode = System.Windows.Forms.DataGridViewTriState:True.
    this-object:dataGridView1:ColumnHeadersDefaultCellStyle = dataGridViewCellStyle1.
    this-object:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar0 as System.Windows.Forms.DataGridViewColumn extent 3 no-undo.
    arrayvar0[1] = this-object:idDataGridViewTextBoxColumn1.
    arrayvar0[2] = this-object:qntyDataGridViewTextBoxColumn1.
    arrayvar0[3] = this-object:sumqntyDataGridViewTextBoxColumn1.
    this-object:dataGridView1:Columns:AddRange(arrayvar0).
    this-object:dataGridView1:DataSource = this-object:bindingSource_Bank.
    this-object:dataGridView1:Location = new System.Drawing.Point(12, 13).
    this-object:dataGridView1:Name = "dataGridView1".
    this-object:dataGridView1:RowHeadersVisible = false.
    this-object:dataGridView1:RowTemplate:Height = 26.
    this-object:dataGridView1:RowTemplate:ReadOnly = true.
    this-object:dataGridView1:Size = new System.Drawing.Size(300, 231).
    this-object:dataGridView1:TabIndex = 0.
    this-object:dataGridView1:CellContentClick:Subscribe(this-object:dataGridView2_CellContentClick).
    this-object:dataGridView1:CellValueChanged:Subscribe(this-object:click_change_).
    /*  */
    /* idDataGridViewTextBoxColumn1 */
    /*  */
    this-object:idDataGridViewTextBoxColumn1:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
    this-object:idDataGridViewTextBoxColumn1:DataPropertyName = "id".
    dataGridViewCellStyle2:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleCenter.
    dataGridViewCellStyle2:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:idDataGridViewTextBoxColumn1:DefaultCellStyle = dataGridViewCellStyle2.
    this-object:idDataGridViewTextBoxColumn1:HeaderText = "Банкноты".
    this-object:idDataGridViewTextBoxColumn1:Name = "idDataGridViewTextBoxColumn1".
    this-object:idDataGridViewTextBoxColumn1:ReadOnly = true.
    /*  */
    /* qntyDataGridViewTextBoxColumn1 */
    /*  */
    this-object:qntyDataGridViewTextBoxColumn1:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
    this-object:qntyDataGridViewTextBoxColumn1:DataPropertyName = "qnty".
    dataGridViewCellStyle3:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleCenter.
    this-object:qntyDataGridViewTextBoxColumn1:DefaultCellStyle = dataGridViewCellStyle3.
    this-object:qntyDataGridViewTextBoxColumn1:HeaderText = "Кол-во".
    this-object:qntyDataGridViewTextBoxColumn1:Name = "qntyDataGridViewTextBoxColumn1".
    this-object:qntyDataGridViewTextBoxColumn1:Resizable = System.Windows.Forms.DataGridViewTriState:False.
    /*  */
    /* sumqntyDataGridViewTextBoxColumn1 */
    /*  */
    this-object:sumqntyDataGridViewTextBoxColumn1:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:Fill.
    this-object:sumqntyDataGridViewTextBoxColumn1:DataPropertyName = "sum-qnty".
    dataGridViewCellStyle4:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleCenter.
    this-object:sumqntyDataGridViewTextBoxColumn1:DefaultCellStyle = dataGridViewCellStyle4.
    this-object:sumqntyDataGridViewTextBoxColumn1:HeaderText = "Сумма".
    this-object:sumqntyDataGridViewTextBoxColumn1:Name = "sumqntyDataGridViewTextBoxColumn1".
    this-object:sumqntyDataGridViewTextBoxColumn1:ReadOnly = true.
    /*  */
    /* bindingSource_Bank */
    /*  */
    this-object:bindingSource_Bank:MaxDataGuess = 0.
    this-object:bindingSource_Bank:NoLOBs = false.
    this-object:bindingSource_Bank:Position = 0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar1 as "Progress.Data.TableDesc[]" no-undo.
    arrayvar1 = new "Progress.Data.TableDesc[]"(0).
    tableDesc1:ChildTables = arrayvar1.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar2 as Progress.Data.ColumnPropDesc extent 3 no-undo.
    arrayvar2[1] = new Progress.Data.ColumnPropDesc("id", "", Progress.Data.DataType:INTEGER).
    arrayvar2[2] = new Progress.Data.ColumnPropDesc("qnty", "", Progress.Data.DataType:INTEGER).
    arrayvar2[3] = new Progress.Data.ColumnPropDesc("sum-qnty", "", Progress.Data.DataType:INTEGER).
    tableDesc1:Columns = arrayvar2.
    this-object:bindingSource_Bank:TableSchema = tableDesc1.
    /*  */
    /* dataGridView2 */
    /*  */
    this-object:dataGridView2:AllowUserToAddRows = false.
    this-object:dataGridView2:AllowUserToDeleteRows = false.
    this-object:dataGridView2:AutoGenerateColumns = false.
    this-object:dataGridView2:BackgroundColor = System.Drawing.SystemColors:ButtonFace.
    dataGridViewCellStyle5:Alignment = System.Windows.Forms.DataGridViewContentAlignment:TopCenter.
    dataGridViewCellStyle5:BackColor = System.Drawing.SystemColors:ControlDark.
    dataGridViewCellStyle5:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    dataGridViewCellStyle5:ForeColor = System.Drawing.SystemColors:WindowText.
    dataGridViewCellStyle5:SelectionBackColor = System.Drawing.SystemColors:HighlightText.
    dataGridViewCellStyle5:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
    dataGridViewCellStyle5:WrapMode = System.Windows.Forms.DataGridViewTriState:True.
    this-object:dataGridView2:ColumnHeadersDefaultCellStyle = dataGridViewCellStyle5.
    this-object:dataGridView2:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar3 as System.Windows.Forms.DataGridViewColumn extent 3 no-undo.
    arrayvar3[1] = this-object:idDataGridViewTextBoxColumn.
    arrayvar3[2] = this-object:qntyDataGridViewTextBoxColumn.
    arrayvar3[3] = this-object:sumqntyDataGridViewTextBoxColumn.
    this-object:dataGridView2:Columns:AddRange(arrayvar3).
    this-object:dataGridView2:DataSource = this-object:bindingSource_Coins.
    this-object:dataGridView2:Location = new System.Drawing.Point(359, 12).
    this-object:dataGridView2:Name = "dataGridView2".
    this-object:dataGridView2:RowHeadersVisible = false.
    this-object:dataGridView2:RowTemplate:Height = 30.
    this-object:dataGridView2:Size = new System.Drawing.Size(300, 233).
    this-object:dataGridView2:TabIndex = 1.
    this-object:dataGridView2:CellContentClick:Subscribe(this-object:dataGridView2_CellContentClick).
    this-object:dataGridView2:CellValueChanged:Subscribe(this-object:dataGridView2_CellValueChanged).
    /*  */
    /* idDataGridViewTextBoxColumn */
    /*  */
    this-object:idDataGridViewTextBoxColumn:AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode:None.
    this-object:idDataGridViewTextBoxColumn:DataPropertyName = "id".
    dataGridViewCellStyle6:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleCenter.
    dataGridViewCellStyle6:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:idDataGridViewTextBoxColumn:DefaultCellStyle = dataGridViewCellStyle6.
    this-object:idDataGridViewTextBoxColumn:HeaderText = "Монеты".
    this-object:idDataGridViewTextBoxColumn:Name = "idDataGridViewTextBoxColumn".
    this-object:idDataGridViewTextBoxColumn:ReadOnly = true.
    this-object:idDataGridViewTextBoxColumn:Width = 97.
    /*  */
    /* qntyDataGridViewTextBoxColumn */
    /*  */
    this-object:qntyDataGridViewTextBoxColumn:DataPropertyName = "qnty".
    dataGridViewCellStyle7:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleCenter.
    this-object:qntyDataGridViewTextBoxColumn:DefaultCellStyle = dataGridViewCellStyle7.
    this-object:qntyDataGridViewTextBoxColumn:HeaderText = "Кол-во".
    this-object:qntyDataGridViewTextBoxColumn:Name = "qntyDataGridViewTextBoxColumn".
    /*  */
    /* sumqntyDataGridViewTextBoxColumn */
    /*  */
    this-object:sumqntyDataGridViewTextBoxColumn:DataPropertyName = "sum-qnty".
    dataGridViewCellStyle8:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleCenter.
    this-object:sumqntyDataGridViewTextBoxColumn:DefaultCellStyle = dataGridViewCellStyle8.
    this-object:sumqntyDataGridViewTextBoxColumn:HeaderText = "Сумма".
    this-object:sumqntyDataGridViewTextBoxColumn:Name = "sumqntyDataGridViewTextBoxColumn".
    this-object:sumqntyDataGridViewTextBoxColumn:ReadOnly = true.
    /*  */
    /* bindingSource_Coins */
    /*  */
    this-object:bindingSource_Coins:MaxDataGuess = 0.
    this-object:bindingSource_Coins:NoLOBs = false.
    this-object:bindingSource_Coins:Position = 0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar4 as "Progress.Data.TableDesc[]" no-undo.
    arrayvar4 = new "Progress.Data.TableDesc[]"(0).
    tableDesc2:ChildTables = arrayvar4.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar5 as Progress.Data.ColumnPropDesc extent 3 no-undo.
    arrayvar5[1] = new Progress.Data.ColumnPropDesc("id", "", Progress.Data.DataType:DECIMAL).
    arrayvar5[2] = new Progress.Data.ColumnPropDesc("qnty", "", Progress.Data.DataType:DECIMAL).
    arrayvar5[3] = new Progress.Data.ColumnPropDesc("sum-qnty", "", Progress.Data.DataType:DECIMAL).
    tableDesc2:Columns = arrayvar5.
    this-object:bindingSource_Coins:TableSchema = tableDesc2.
    /*  */
    /* Coins_Banknot */
    /*  */
    this-object:ClientSize = new System.Drawing.Size(668, 253).
    this-object:Controls:Add(this-object:dataGridView2).
    this-object:Controls:Add(this-object:dataGridView1).
    this-object:Name = "Coins_Banknot".
    this-object:Text = "Coins_Banknot".
    this-object:Load:Subscribe(this-object:Coins_Banknot_Load).
    cast(this-object:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
    cast(this-object:bindingSource_Bank, System.ComponentModel.ISupportInitialize):EndInit().
    cast(this-object:dataGridView2, System.ComponentModel.ISupportInitialize):EndInit().
    cast(this-object:bindingSource_Coins, System.ComponentModel.ISupportInitialize):EndInit().
    this-object:ResumeLayout(false).
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
  end method.

  method private handle browse_Coints():
    define variable v-list-coints as character no-undo .
    define variable ii  as integer no-undo .
    
    v-list-coints = "10;5;2;1;0.5;0.1;0.05" .
    /*Посмотреть, есть ли данные в атрибуте*/
    /*если нет заполняем пустую таблицу*/
    do ii = 1 to num-entries (v-list-coints,";"):
      create tt-coins .
      assign
      tt-coins.id = decimal(entry(ii,v-list-coints,";"))
      tt-coins.qnty = 0
      tt-coins.sum-qnty = 0 
      .
    end.  
           
    if valid-handle(hQuery2)  THEN DELETE object hQuery2.
    create query hQuery2. 
    hQuery2:set-buffers(buffer tt-coins:HANDLE).
    hQuery2:query-prepare("FOR EACH tt-coins by tt-coins.id desc").
    hQuery2:query-open.
    bindingSource_Coins:Refresh() .
    return hQuery2 .                        
      
  end method .  

  method private handle browse_Banknot():
    define variable v-list-banknot as character no-undo .
    define variable ii  as integer no-undo .
    
    v-list-banknot = "5000;2000;1000;500;200;100;50;10" .
    /*Посмотреть, есть ли данные в атрибуте*/
    /*если нет заполняем пустую таблицу*/
    do ii = 1 to num-entries (v-list-banknot,";"):
      create tt-banknots .
      assign
      tt-banknots.id = integer(entry(ii,v-list-banknot,";"))
      tt-banknots.qnty = 0
      tt-banknots.sum-qnty = 0 
      .
    end.  
           
    if valid-handle(hQuery1)  THEN DELETE object hQuery1.
    create query hQuery1. 
    hQuery1:set-buffers(buffer tt-banknots:HANDLE).
    hQuery1:query-prepare("FOR EACH tt-banknots by tt-banknots.id desc").
    hQuery1:query-open.
    bindingSource_Bank:Refresh() .
    return hQuery1 .                        
      
  end method .  
  
  destructor public Coins_Banknot ( ):

  end destructor.

end class.