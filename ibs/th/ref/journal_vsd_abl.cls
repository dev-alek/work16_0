 
 /*------------------------------------------------------------------------
    File        : journal_vsd_abl
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Sat Jun 09 17:30:18 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/
/*

$Revision$
$Author$
$Date$
$Workfile$
$Archive$
 
Журнал ВСД
 
Автор: Рубан Дмитрий Андреевич
Дата создания: 30.05.2018
Author: Dmitriy Ruban
Creation date: 30/05/18

*/
USING Progress.Lang.*.
USING Progress.Windows.Form.

USING ibs.th.ref.journal_vsd_trg.

BLOCK-LEVEL ON ERROR UNDO, THROW.

     
CLASS ibs.th.ref.journal_vsd_abl INHERITS Form: 
    
    DEFINE PRIVATE VARIABLE bindttFilt AS Progress.Data.BindingSource NO-UNDO.
    DEFINE PRIVATE VARIABLE Btn_clen AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btn_edit AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE Btn_Cancel AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btn_Filt AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE Btn_gds AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btn_gds_merc AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE Btn_lookup AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btn_prn AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btn_ref AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE btn_trndoc AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE dateTimePicker1 AS System.Windows.Forms.DateTimePicker NO-UNDO.
    DEFINE PRIVATE VARIABLE dateTimePicker2 AS System.Windows.Forms.DateTimePicker NO-UNDO.
    DEFINE PRIVATE VARIABLE FalVerif AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE FalExting AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE gdscode AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE gdsguid AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE gdsmercguid AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE gdsname AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE gdsnamemerc AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label2 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label3 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label4 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label5 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label7 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label6 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE msgerr AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE NomTTH AS System.Windows.Forms.TextBox NO-UNDO.
    DEFINE PRIVATE VARIABLE numericUpDown1 AS System.Windows.Forms.NumericUpDown NO-UNDO.
    DEFINE PRIVATE VARIABLE panel1 AS System.Windows.Forms.Panel NO-UNDO.
    DEFINE PRIVATE VARIABLE panel2 AS System.Windows.Forms.Panel NO-UNDO.
    DEFINE PRIVATE VARIABLE Rep AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE ReqVerif AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE Sent AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE tableLayoutPanel1 AS System.Windows.Forms.TableLayoutPanel NO-UNDO.
    DEFINE PRIVATE VARIABLE ToExtin AS System.Windows.Forms.CheckBox NO-UNDO.
    DEFINE PRIVATE VARIABLE unitcliDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE unitbaseDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE statusvsdDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE prodcodeDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE postDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE ojdDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE nomTTHpostDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE nomTTHDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE nomAZSDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE gdsnameDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE dateTTHDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE cOLobjDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE articDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE uUIDDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE COLobj AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE vsdtypelblDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE uUIDDataGridViewTextBoxColumn1 AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE VARIABLE vss-revision       AS CHARACTER NO-UNDO INIT "$Revision$":U .
    DEFINE VARIABLE vss-author         AS CHARACTER NO-UNDO INIT "$Author$":U .
    DEFINE VARIABLE vss-date           AS CHARACTER NO-UNDO INIT "$Date$":U .
    DEFINE VARIABLE vss-workfile       AS CHARACTER NO-UNDO INIT "$Workfile$":U .
    DEFINE VARIABLE vss-archive        AS CHARACTER NO-UNDO INIT "$Archive$":U .
    DEFINE VARIABLE vss-description    AS CHARACTER NO-UNDO INIT "Журнал ВСД". 
    
    DEFINE PRIVATE VARIABLE bingvsd AS Progress.Data.BindingSource NO-UNDO.
    DEFINE PRIVATE VARIABLE hbingvsd AS HANDLE NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.
    DEFINE PRIVATE VARIABLE hDSFILt   AS HANDLE    NO-UNDO.
    DEFINE PRIVATE VARIABLE hDSVSd    AS HANDLE    NO-UNDO.
    DEFINE VARIABLE parparentproc     AS HANDLE    NO-UNDO.
    DEFINE STREAM OutStr-html.
    
    { cmp/library.i class} 
    { cmp/str-glbl.i class}
    { gbl/getcntxt.i def }
   //  { gbl/prn-lib.i   }
   /* { gbl/userobjs.i }*/
  
    { bge/ds-vsd-set.i }  
      
    
    DEFINE DATASET dsVSd FOR ttVSd. /* tt-altvsd */ 
    
    DEFINE VARIABLE v-object-available    AS LOGICAL   NO-UNDO .
    DEFINE VARIABLE vjournalvsdTrg AS CLASS journal_vsd_trg.

        
    CONSTRUCTOR PUBLIC journal_vsd_abl ( INPUT p-paparparentproc AS HANDLE  ):
        SUPER().
        
        
        InitializeComponent().
        THIS-OBJECT:ComponentsCollection:ADD(THIS-OBJECT:components).
        
        vjournalvsdTrg = NEW ibs.th.ref.journal_vsd_trg (p-paparparentproc).
        
        parparentproc = p-paparparentproc.
        { gbl/getcntxt.i get }
        CREATE tt-vsd-filt.
        ASSIGN 
            tt-vsd-filt.date-end   = TODAY
            tt-vsd-filt.date-start = TODAY
            tt-vsd-filt.FalExting  = YES
            tt-vsd-filt.FalVerif   = YES 
            tt-vsd-filt.Rep        = YES 
            tt-vsd-filt.ReqVerif   = YES 
            tt-vsd-filt.ToExtin    = YES
            tt-vsd-filt.Sent    = YES
            tt-vsd-filt.fTime      = 0
                    
            . 
        FOR EACH db NO-LOCK
            ON ERROR UNDO, RETURN NO-APPLY
            :
            FOR EACH clients NO-LOCK
                WHERE clients.db-num = db.db-num
                ON ERROR UNDO, RETURN NO-APPLY
                :
                { gbl/usobjava.i
                v-cntxt-db-num
                {&action-head-code-main}
                v-cntxt-userid
                clients.obj-type
                clients.obj-code
                v-object-available
                no-error
              }
                IF ERROR-STATUS :ERROR
                    THEN 
                DO:
                    MESSAGE
                        vss-workfile vss-revision vss-description SKIP
                        "Ошибка при вызове процедуры gbl/usobjava.i" SKIP
                        ERROR-STATUS :GET-MESSAGE(1) SKIP
                        RETURN-VALUE SKIP
                        VIEW-AS ALERT-BOX ERROR .
                    UNDO, RETURN NO-APPLY .
                END.
    
                IF v-object-available = TRUE
                    THEN 
                DO:
                    CREATE t-obj-list .
                    ASSIGN
                        t-obj-list.obj-type = clients.obj-type
                        t-obj-list.obj-code = clients.obj-code
                        .
                END.
            END.
        END. 
        vjournalvsdTrg:CreateTT(INPUT DATASET ds-vsd-set, OUTPUT TABLE ttvsd).
        
        hDSVSd = DATASET dsVSd:HANDLE.
        bingvsd:HANDLE =  hDSvsd:TOP-NAV-QUERY.
        hbingvsd = bingvsd:HANDLE.
        hDSFILt = DATASET ds-vsd-set:HANDLE.
        bindttfilt:HANDLE = hDSFILt:TOP-NAV-QUERY. 
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.

    END CONSTRUCTOR.
    



	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID Btn_Cancel_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		THIS-OBJECT:DialogResult = System.Windows.Forms.DialogResult:Ok.
        THIS-OBJECT:Close ( ).
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID Btn_clen_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		vjournalvsdTrg:filt-clen(OUTPUT DATASET ds-vsd-set).
		bindttfilt:Refresh().
        vjournalvsdTrg:CreateTT(INPUT DATASET ds-vsd-set, OUTPUT TABLE ttvsd).
        hbingvsd:QUERY-OPEN ().
        bingvsd:RefreshAll().
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btn_edit_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
	    IF AVAILABLE ttvsd THEN
		  vjournalvsdTrg:VSD_edit(ttvsd.id, ttvsd.db-num, ttvsd.vsdsubs).
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btn_Filt_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
	    bindttfilt:Assign().
		RUN bge/vsd-filt.w(parparentproc,INPUT-OUTPUT DATASET ds-vsd-set ).
		bindttfilt:Refresh().
		vjournalvsdTrg:CreateTT(INPUT DATASET ds-vsd-set, OUTPUT TABLE ttvsd).
        hbingvsd:QUERY-OPEN ().
        bingvsd:RefreshAll().
		RETURN.

	END METHOD.

    /*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID Btn_gds_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
	    IF AVAILABLE ttvsd THEN
		  vjournalvsdTrg:gds_lock(ttvsd.gds-code, ttvsd.obj-type, ttvsd.obj-code). 
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btn_gds_merc_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
	    IF AVAILABLE ttvsd THEN 
		  vjournalvsdTrg:gds_merc_lock(ttvsd.gds-code).
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID Btn_lookup_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		IF AVAILABLE ttvsd THEN 
        vjournalvsdTrg:VSD_lock(ttvsd.id, ttvsd.db-num, ttvsd.vsdsubs).
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btn_prn_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		bindttfilt:Assign().
		RUN rep/printvsd.p ( parparentproc,
		                      tt-vsd-filt.date-start,
		                        tt-vsd-filt.date-end,
		                        INPUT TABLE ttvsd).
		/*{rep/r-statusvsd.p &only_print = YES 
                   &date-start = tt-vsd-filt.date-start 
                   &date-end   = tt-vsd-filt.date-end }*/
		
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	DEFINE VARIABLE vssss AS INTEGER NO-UNDO INIT 190.
	
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btn_ref_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		bindttfilt:Assign(). 
		vjournalvsdTrg:CreateTT(INPUT DATASET ds-vsd-set, OUTPUT TABLE ttvsd).
        hbingvsd:QUERY-OPEN ().
        bingvsd:RefreshAll().
        
		RETURN.

	END METHOD.


	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID btn_trndoc_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
	    vjournalvsdTrg:trn_doc_lock(ttvsd.part-key,ttvsd.gds-code).
		RETURN.

	END METHOD.

	METHOD PRIVATE VOID button1_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
	    
	    vjournalvsdTrg:CreateTT(INPUT DATASET ds-vsd-set, OUTPUT TABLE ttvsd).
	    hbingvsd:QUERY-OPEN ().
	    bingvsd:RefreshAll().
         
	    IF AVAILABLE ttvsd THEN DO:
	    vjournalvsdTrg:VSD_lock(ttvsd.id, ttvsd.db-num, ttvsd.vsdsubs).
	    END.
	    ELSE 
	    MESSAGE "Не выбран объект для отображения."
        VIEW-AS ALERT-BOX.
	    RETURN.

	END METHOD.





	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID dataGridView1_CellContentClick( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.DataGridViewCellEventArgs ):
		
		RETURN.

	END METHOD.
    
    
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.

    METHOD PRIVATE VOID InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        THIS-OBJECT:components = NEW System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc1 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc1 = NEW Progress.Data.TableDesc("vsd").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE resources AS Progress.Util.ResourceManager NO-UNDO.
        resources = NEW Progress.Util.ResourceManager("ibs.th.ref.journal_vsd_abl").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc2 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc2 = NEW Progress.Data.TableDesc("ttfilt").
        THIS-OBJECT:Btn_lookup = NEW System.Windows.Forms.Button().
        THIS-OBJECT:dataGridView1 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:dateTTHDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:nomTTHDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:nomAZSDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:articDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:vsdtypelblDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn1 = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:statusvsdDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:nomTTHpostDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:postDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:gdsnameDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:prodcodeDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:cOLobjDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:unitbaseDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:unitcliDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:ojdDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:bingvsd = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:COLobj = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:tableLayoutPanel1 = NEW System.Windows.Forms.TableLayoutPanel().
        THIS-OBJECT:gdsname = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:gdsnamemerc = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:gdscode = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:gdsmercguid = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:label2 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:gdsguid = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:Btn_gds = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btn_gds_merc = NEW System.Windows.Forms.Button().
        THIS-OBJECT:NomTTH = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:label3 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:btn_trndoc = NEW System.Windows.Forms.Button().
        THIS-OBJECT:panel1 = NEW System.Windows.Forms.Panel().
        THIS-OBJECT:panel2 = NEW System.Windows.Forms.Panel().
        THIS-OBJECT:Btn_clen = NEW System.Windows.Forms.Button().
        THIS-OBJECT:Sent = NEW System.Windows.Forms.CheckBox().
        THIS-OBJECT:bindttFilt = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:btn_Filt = NEW System.Windows.Forms.Button().
        THIS-OBJECT:numericUpDown1 = NEW System.Windows.Forms.NumericUpDown().
        THIS-OBJECT:btn_ref = NEW System.Windows.Forms.Button().
        THIS-OBJECT:Rep = NEW System.Windows.Forms.CheckBox().
        THIS-OBJECT:FalVerif = NEW System.Windows.Forms.CheckBox().
        THIS-OBJECT:ToExtin = NEW System.Windows.Forms.CheckBox().
        THIS-OBJECT:FalExting = NEW System.Windows.Forms.CheckBox().
        THIS-OBJECT:ReqVerif = NEW System.Windows.Forms.CheckBox().
        THIS-OBJECT:dateTimePicker2 = NEW System.Windows.Forms.DateTimePicker().
        THIS-OBJECT:label7 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:label6 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:dateTimePicker1 = NEW System.Windows.Forms.DateTimePicker().
        THIS-OBJECT:label5 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:btn_prn = NEW System.Windows.Forms.Button().
        THIS-OBJECT:btn_edit = NEW System.Windows.Forms.Button().
        THIS-OBJECT:Btn_Cancel = NEW System.Windows.Forms.Button().
        THIS-OBJECT:msgerr = NEW System.Windows.Forms.TextBox().
        THIS-OBJECT:label4 = NEW System.Windows.Forms.Label().
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:bingvsd, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:tableLayoutPanel1:SuspendLayout().
        THIS-OBJECT:panel1:SuspendLayout().
        THIS-OBJECT:panel2:SuspendLayout().
        CAST(THIS-OBJECT:bindttFilt, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:numericUpDown1, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* Btn_lookup */
        /*  */
        THIS-OBJECT:Btn_lookup:Location = NEW System.Drawing.Point(204, 12).
        THIS-OBJECT:Btn_lookup:Name = "Btn_lookup".
        THIS-OBJECT:Btn_lookup:Size = NEW System.Drawing.Size(75, 23).
        THIS-OBJECT:Btn_lookup:TabIndex = 0.
        THIS-OBJECT:Btn_lookup:Text = "Просмотр".
        THIS-OBJECT:Btn_lookup:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:Btn_lookup:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:Btn_lookup:Click:Subscribe(THIS-OBJECT:Btn_lookup_Click).
        /*  */
        /* dataGridView1 */
        /*  */
        THIS-OBJECT:dataGridView1:AllowUserToAddRows = FALSE.
        THIS-OBJECT:dataGridView1:AllowUserToDeleteRows = FALSE.
        THIS-OBJECT:dataGridView1:AllowUserToOrderColumns = TRUE.
        DEFINE VARIABLE nestedvar0 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar0 = CAST(Progress.Util.EnumHelper:Or(CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:dataGridView1:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:dataGridView1:AutoGenerateColumns = FALSE.
        THIS-OBJECT:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar0 AS System.Windows.Forms.DataGridViewColumn EXTENT 15 NO-UNDO.
        arrayvar0[1] = THIS-OBJECT:dateTTHDataGridViewTextBoxColumn.
        arrayvar0[2] = THIS-OBJECT:nomTTHDataGridViewTextBoxColumn.
        arrayvar0[3] = THIS-OBJECT:nomAZSDataGridViewTextBoxColumn.
        arrayvar0[4] = THIS-OBJECT:articDataGridViewTextBoxColumn.
        arrayvar0[5] = THIS-OBJECT:vsdtypelblDataGridViewTextBoxColumn.
        arrayvar0[6] = THIS-OBJECT:uUIDDataGridViewTextBoxColumn1.
        arrayvar0[7] = THIS-OBJECT:statusvsdDataGridViewTextBoxColumn.
        arrayvar0[8] = THIS-OBJECT:nomTTHpostDataGridViewTextBoxColumn.
        arrayvar0[9] = THIS-OBJECT:postDataGridViewTextBoxColumn.
        arrayvar0[10] = THIS-OBJECT:gdsnameDataGridViewTextBoxColumn.
        arrayvar0[11] = THIS-OBJECT:prodcodeDataGridViewTextBoxColumn.
        arrayvar0[12] = THIS-OBJECT:cOLobjDataGridViewTextBoxColumn.
        arrayvar0[13] = THIS-OBJECT:unitbaseDataGridViewTextBoxColumn.
        arrayvar0[14] = THIS-OBJECT:unitcliDataGridViewTextBoxColumn.
        arrayvar0[15] = THIS-OBJECT:ojdDataGridViewTextBoxColumn.
        THIS-OBJECT:dataGridView1:Columns:AddRange(arrayvar0).
        THIS-OBJECT:dataGridView1:DataSource = THIS-OBJECT:bingvsd.
        THIS-OBJECT:dataGridView1:Location = NEW System.Drawing.Point(-2, 103).
        THIS-OBJECT:dataGridView1:Name = "dataGridView1".
        THIS-OBJECT:dataGridView1:ReadOnly = TRUE.
        THIS-OBJECT:dataGridView1:Size = NEW System.Drawing.Size(852, 273).
        THIS-OBJECT:dataGridView1:TabIndex = 1.
        THIS-OBJECT:dataGridView1:CellContentClick:Subscribe(THIS-OBJECT:dataGridView1_CellContentClick).
        /*  */
        /* dateTTHDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:dateTTHDataGridViewTextBoxColumn:DataPropertyName = "dateTTH".
        THIS-OBJECT:dateTTHDataGridViewTextBoxColumn:HeaderText = "Дата ТТН".
        THIS-OBJECT:dateTTHDataGridViewTextBoxColumn:Name = "dateTTHDataGridViewTextBoxColumn".
        THIS-OBJECT:dateTTHDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* nomTTHDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:nomTTHDataGridViewTextBoxColumn:DataPropertyName = "NomTTH".
        THIS-OBJECT:nomTTHDataGridViewTextBoxColumn:HeaderText = "Номер ТТН".
        THIS-OBJECT:nomTTHDataGridViewTextBoxColumn:Name = "nomTTHDataGridViewTextBoxColumn".
        THIS-OBJECT:nomTTHDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* nomAZSDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:nomAZSDataGridViewTextBoxColumn:DataPropertyName = "NomAZS".
        THIS-OBJECT:nomAZSDataGridViewTextBoxColumn:HeaderText = "Объект".
        THIS-OBJECT:nomAZSDataGridViewTextBoxColumn:Name = "nomAZSDataGridViewTextBoxColumn".
        THIS-OBJECT:nomAZSDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* articDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:articDataGridViewTextBoxColumn:DataPropertyName = "artic".
        THIS-OBJECT:articDataGridViewTextBoxColumn:HeaderText = "Артикул товара".
        THIS-OBJECT:articDataGridViewTextBoxColumn:Name = "articDataGridViewTextBoxColumn".
        THIS-OBJECT:articDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* vsdtypelblDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:vsdtypelblDataGridViewTextBoxColumn:DataPropertyName = "vsdtypelbl".
        THIS-OBJECT:vsdtypelblDataGridViewTextBoxColumn:HeaderText = "Тип".
        THIS-OBJECT:vsdtypelblDataGridViewTextBoxColumn:Name = "vsdtypelblDataGridViewTextBoxColumn".
        THIS-OBJECT:vsdtypelblDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* uUIDDataGridViewTextBoxColumn1 */
        /*  */
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn1:DataPropertyName = "UUID".
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn1:HeaderText = "Номер ВСД".
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn1:Name = "uUIDDataGridViewTextBoxColumn1".
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn1:ReadOnly = TRUE.
        /*  */
        /* statusvsdDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:statusvsdDataGridViewTextBoxColumn:DataPropertyName = "statusvsd".
        THIS-OBJECT:statusvsdDataGridViewTextBoxColumn:HeaderText = "Статус ВСД".
        THIS-OBJECT:statusvsdDataGridViewTextBoxColumn:Name = "statusvsdDataGridViewTextBoxColumn".
        THIS-OBJECT:statusvsdDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* nomTTHpostDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:nomTTHpostDataGridViewTextBoxColumn:DataPropertyName = "NomTTHpost".
        THIS-OBJECT:nomTTHpostDataGridViewTextBoxColumn:HeaderText = "Номер ТТН поставщика".
        THIS-OBJECT:nomTTHpostDataGridViewTextBoxColumn:Name = "nomTTHpostDataGridViewTextBoxColumn".
        THIS-OBJECT:nomTTHpostDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* postDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:postDataGridViewTextBoxColumn:DataPropertyName = "Post".
        THIS-OBJECT:postDataGridViewTextBoxColumn:HeaderText = "Поставщик".
        THIS-OBJECT:postDataGridViewTextBoxColumn:Name = "postDataGridViewTextBoxColumn".
        THIS-OBJECT:postDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* gdsnameDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:gdsnameDataGridViewTextBoxColumn:DataPropertyName = "gdsname".
        THIS-OBJECT:gdsnameDataGridViewTextBoxColumn:HeaderText = "Наименование товара".
        THIS-OBJECT:gdsnameDataGridViewTextBoxColumn:Name = "gdsnameDataGridViewTextBoxColumn".
        THIS-OBJECT:gdsnameDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* prodcodeDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:prodcodeDataGridViewTextBoxColumn:DataPropertyName = "prod-code".
        THIS-OBJECT:prodcodeDataGridViewTextBoxColumn:HeaderText = "Производитель".
        THIS-OBJECT:prodcodeDataGridViewTextBoxColumn:Name = "prodcodeDataGridViewTextBoxColumn".
        THIS-OBJECT:prodcodeDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* cOLobjDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:cOLobjDataGridViewTextBoxColumn:DataPropertyName = "COLobj".
        THIS-OBJECT:cOLobjDataGridViewTextBoxColumn:HeaderText = "Кол-во ВСД".
        THIS-OBJECT:cOLobjDataGridViewTextBoxColumn:Name = "cOLobjDataGridViewTextBoxColumn".
        THIS-OBJECT:cOLobjDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* unitbaseDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:unitbaseDataGridViewTextBoxColumn:DataPropertyName = "unit-base".
        THIS-OBJECT:unitbaseDataGridViewTextBoxColumn:HeaderText = "Ед.изм.уч.".
        THIS-OBJECT:unitbaseDataGridViewTextBoxColumn:Name = "unitbaseDataGridViewTextBoxColumn".
        THIS-OBJECT:unitbaseDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* unitcliDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:unitcliDataGridViewTextBoxColumn:DataPropertyName = "unit-cli".
        THIS-OBJECT:unitcliDataGridViewTextBoxColumn:HeaderText = "Ед.изм.пост.".
        THIS-OBJECT:unitcliDataGridViewTextBoxColumn:Name = "unitcliDataGridViewTextBoxColumn".
        THIS-OBJECT:unitcliDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* ojdDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:ojdDataGridViewTextBoxColumn:DataPropertyName = "ojd".
        THIS-OBJECT:ojdDataGridViewTextBoxColumn:HeaderText = "Ожидает гашения(Ч.)".
        THIS-OBJECT:ojdDataGridViewTextBoxColumn:Name = "ojdDataGridViewTextBoxColumn".
        THIS-OBJECT:ojdDataGridViewTextBoxColumn:ReadOnly = TRUE.
        /*  */
        /* bingvsd */
        /*  */
        THIS-OBJECT:bingvsd:AutoSort = TRUE.
        THIS-OBJECT:bingvsd:AutoUpdate = TRUE.
        THIS-OBJECT:bingvsd:MaxDataGuess = 0.
        THIS-OBJECT:bingvsd:NoLOBs = FALSE.
        THIS-OBJECT:bingvsd:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar1 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar1 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc1:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar2 AS Progress.Data.ColumnPropDesc EXTENT 41 NO-UNDO.
        arrayvar2[1] = NEW Progress.Data.ColumnPropDesc("cli-code", "?", Progress.Data.DataType:INTEGER).
        arrayvar2[2] = NEW Progress.Data.ColumnPropDesc("cli-type", "?", Progress.Data.DataType:CHARACTER).
        arrayvar2[3] = NEW Progress.Data.ColumnPropDesc("date-cr", "Дата оформления", Progress.Data.DataType:DATE).
        arrayvar2[4] = NEW Progress.Data.ColumnPropDesc("date-out", "Дата выробатки", Progress.Data.DataType:CHARACTER).
        arrayvar2[5] = NEW Progress.Data.ColumnPropDesc("db-num", "База данных создания", Progress.Data.DataType:INTEGER).
        arrayvar2[6] = NEW Progress.Data.ColumnPropDesc("economic-sub", "Хоз. субъект", Progress.Data.DataType:CHARACTER).
        arrayvar2[7] = NEW Progress.Data.ColumnPropDesc("expiry-date", "Срок годности", Progress.Data.DataType:CHARACTER).
        arrayvar2[8] = NEW Progress.Data.ColumnPropDesc("expiry-date-2", "Срок годости 2", Progress.Data.DataType:CHARACTER).
        arrayvar2[9] = NEW Progress.Data.ColumnPropDesc("expiry-out-date", "Срок выпуска", Progress.Data.DataType:CHARACTER).
        arrayvar2[10] = NEW Progress.Data.ColumnPropDesc("fact-datetime", "?", Progress.Data.DataType:DATETIME_TZ).
        arrayvar2[11] = NEW Progress.Data.ColumnPropDesc("gds-code", "?", Progress.Data.DataType:INTEGER).
        arrayvar2[12] = NEW Progress.Data.ColumnPropDesc("gds-guid", "GUID товара", Progress.Data.DataType:CHARACTER).
        arrayvar2[13] = NEW Progress.Data.ColumnPropDesc("gds-name-merc", "Наименование товара в Меркурии", Progress.Data.DataType:CHARACTER).
        arrayvar2[14] = NEW Progress.Data.ColumnPropDesc("ID", "?", Progress.Data.DataType:INTEGER).
        arrayvar2[15] = NEW Progress.Data.ColumnPropDesc("msg-err", "Описание ошибки", Progress.Data.DataType:CHARACTER).
        arrayvar2[16] = NEW Progress.Data.ColumnPropDesc("note", "Примечание", Progress.Data.DataType:CHARACTER).
        arrayvar2[17] = NEW Progress.Data.ColumnPropDesc("num-part", "Номер партии", Progress.Data.DataType:CHARACTER).
        arrayvar2[18] = NEW Progress.Data.ColumnPropDesc("obj-code", "?", Progress.Data.DataType:INTEGER).
        arrayvar2[19] = NEW Progress.Data.ColumnPropDesc("obj-type", "?", Progress.Data.DataType:CHARACTER).
        arrayvar2[20] = NEW Progress.Data.ColumnPropDesc("part-key", "Ключ партии", Progress.Data.DataType:CHARACTER).
        arrayvar2[21] = NEW Progress.Data.ColumnPropDesc("qnty", "Количество", Progress.Data.DataType:DECIMAL).
        arrayvar2[22] = NEW Progress.Data.ColumnPropDesc("status_", "Статус ВСД", Progress.Data.DataType:INTEGER).
        arrayvar2[23] = NEW Progress.Data.ColumnPropDesc("type-prod", "?", Progress.Data.DataType:CHARACTER).
        arrayvar2[24] = NEW Progress.Data.ColumnPropDesc("UUID", "Номер ВСД", Progress.Data.DataType:CHARACTER).
        arrayvar2[25] = NEW Progress.Data.ColumnPropDesc("vsd-num", "Номер ВСД", Progress.Data.DataType:CHARACTER).
        arrayvar2[26] = NEW Progress.Data.ColumnPropDesc("vsd-type", "Тип ВСД", Progress.Data.DataType:INTEGER).
        arrayvar2[27] = NEW Progress.Data.ColumnPropDesc("dateTTH", "Дата ТТН", Progress.Data.DataType:DATE).
        arrayvar2[28] = NEW Progress.Data.ColumnPropDesc("NomTTH", "Номер ТТН", Progress.Data.DataType:CHARACTER).
        arrayvar2[29] = NEW Progress.Data.ColumnPropDesc("NomAZS", "Объект", Progress.Data.DataType:CHARACTER).
        arrayvar2[30] = NEW Progress.Data.ColumnPropDesc("artic", "Артикул товара", Progress.Data.DataType:CHARACTER).
        arrayvar2[31] = NEW Progress.Data.ColumnPropDesc("vsdtypelbl", "Тип", Progress.Data.DataType:CHARACTER).
        arrayvar2[32] = NEW Progress.Data.ColumnPropDesc("statusvsd", "Статус ВСД", Progress.Data.DataType:CHARACTER).
        arrayvar2[33] = NEW Progress.Data.ColumnPropDesc("NomTTHpost", "Номер ТТН поставщика", Progress.Data.DataType:CHARACTER).
        arrayvar2[34] = NEW Progress.Data.ColumnPropDesc("Post", "Поставщик", Progress.Data.DataType:CHARACTER).
        arrayvar2[35] = NEW Progress.Data.ColumnPropDesc("gdsname", "Наименование товара", Progress.Data.DataType:CHARACTER).
        arrayvar2[36] = NEW Progress.Data.ColumnPropDesc("prod-code", "Производитель", Progress.Data.DataType:CHARACTER).
        arrayvar2[37] = NEW Progress.Data.ColumnPropDesc("COLobj", "Кол-во ВСД", Progress.Data.DataType:DECIMAL).
        arrayvar2[38] = NEW Progress.Data.ColumnPropDesc("unit-base", "Ед.изм.уч.", Progress.Data.DataType:CHARACTER).
        arrayvar2[39] = NEW Progress.Data.ColumnPropDesc("unit-cli", "Ед.изм.пост.", Progress.Data.DataType:CHARACTER).
        arrayvar2[40] = NEW Progress.Data.ColumnPropDesc("ojd", "Ожидает гашения(Ч.)", Progress.Data.DataType:DECIMAL).
        arrayvar2[41] = NEW Progress.Data.ColumnPropDesc("gdsmercguid", "gdsmercguid", Progress.Data.DataType:CHARACTER).
        tableDesc1:Columns = arrayvar2.
        THIS-OBJECT:bingvsd:TableSchema = tableDesc1.
        /*  */
        /* uUIDDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn:DataPropertyName = "UUID".
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn:HeaderText = "Номер ВСД".
        THIS-OBJECT:uUIDDataGridViewTextBoxColumn:Name = "uUIDDataGridViewTextBoxColumn".
        /*  */
        /* COLobj */
        /*  */
        THIS-OBJECT:COLobj:DataPropertyName = "COLobj".
        THIS-OBJECT:COLobj:HeaderText = "Кол-во ВСД".
        THIS-OBJECT:COLobj:Name = "COLobj".
        THIS-OBJECT:COLobj:ReadOnly = TRUE.
        /*  */
        /* tableLayoutPanel1 */
        /*  */
        DEFINE VARIABLE nestedvar1 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar1 = CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Bottom, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:tableLayoutPanel1:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:tableLayoutPanel1:ColumnCount = 5.
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(120))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(33))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Percent, Progress.Util.CastUtil:ToSingle(34))).
        THIS-OBJECT:tableLayoutPanel1:ColumnStyles:Add(NEW System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:gdsname, 2, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:gdsnamemerc, 2, 1).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:gdscode, 1, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:gdsmercguid, 3, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label1, 0, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label2, 0, 1).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:gdsguid, 3, 1).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:Btn_gds, 4, 0).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:btn_gds_merc, 4, 1).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:NomTTH, 1, 2).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:label3, 0, 2).
        THIS-OBJECT:tableLayoutPanel1:Controls:Add(THIS-OBJECT:btn_trndoc, 4, 2).
        THIS-OBJECT:tableLayoutPanel1:Location = NEW System.Drawing.Point(2, 384).
        THIS-OBJECT:tableLayoutPanel1:Name = "tableLayoutPanel1".
        THIS-OBJECT:tableLayoutPanel1:RowCount = 3.
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel1:RowStyles:Add(NEW System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType:Absolute, Progress.Util.CastUtil:ToSingle(30))).
        THIS-OBJECT:tableLayoutPanel1:Size = NEW System.Drawing.Size(848, 90).
        THIS-OBJECT:tableLayoutPanel1:TabIndex = 2.
        /*  */
        /* gdsname */
        /*  */
        DEFINE VARIABLE nestedvar2 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar2 = System.Windows.Forms.AnchorStyles:Left.
        THIS-OBJECT:gdsname:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:gdsname:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bingvsd, "gdsname", TRUE)).
        THIS-OBJECT:gdsname:Location = NEW System.Drawing.Point(353, 5).
        THIS-OBJECT:gdsname:Name = "gdsname".
        THIS-OBJECT:gdsname:ReadOnly = TRUE.
        THIS-OBJECT:gdsname:Size = NEW System.Drawing.Size(224, 20).
        THIS-OBJECT:gdsname:TabIndex = 1.
        /*  */
        /* gdsnamemerc */
        /*  */
        DEFINE VARIABLE nestedvar3 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar3 = System.Windows.Forms.AnchorStyles:Left.
        THIS-OBJECT:gdsnamemerc:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:gdsnamemerc:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bingvsd, "gds-name-merc", TRUE)).
        THIS-OBJECT:gdsnamemerc:Location = NEW System.Drawing.Point(353, 35).
        THIS-OBJECT:gdsnamemerc:Name = "gdsnamemerc".
        THIS-OBJECT:gdsnamemerc:ReadOnly = TRUE.
        THIS-OBJECT:gdsnamemerc:Size = NEW System.Drawing.Size(224, 20).
        THIS-OBJECT:gdsnamemerc:TabIndex = 3.
        /*  */
        /* gdscode */
        /*  */
        DEFINE VARIABLE nestedvar4 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar4 = System.Windows.Forms.AnchorStyles:Left.
        THIS-OBJECT:gdscode:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar4, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:gdscode:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bingvsd, "gds-code", TRUE, System.Windows.Forms.DataSourceUpdateMode:OnValidation, ?, "N0")).
        THIS-OBJECT:gdscode:Location = NEW System.Drawing.Point(123, 5).
        THIS-OBJECT:gdscode:Name = "gdscode".
        THIS-OBJECT:gdscode:ReadOnly = TRUE.
        THIS-OBJECT:gdscode:Size = NEW System.Drawing.Size(224, 20).
        THIS-OBJECT:gdscode:TabIndex = 0.
        /*  */
        /* gdsmercguid */
        /*  */
        DEFINE VARIABLE nestedvar5 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar5 = System.Windows.Forms.AnchorStyles:Left.
        THIS-OBJECT:gdsmercguid:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar5, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:gdsmercguid:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bingvsd, "gdsmercguid", TRUE)).
        THIS-OBJECT:gdsmercguid:Location = NEW System.Drawing.Point(583, 5).
        THIS-OBJECT:gdsmercguid:Name = "gdsmercguid".
        THIS-OBJECT:gdsmercguid:ReadOnly = TRUE.
        THIS-OBJECT:gdsmercguid:Size = NEW System.Drawing.Size(231, 20).
        THIS-OBJECT:gdsmercguid:TabIndex = 2.
        /*  */
        /* label1 */
        /*  */
        THIS-OBJECT:label1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label1:Location = NEW System.Drawing.Point(3, 0).
        THIS-OBJECT:label1:Name = "label1".
        THIS-OBJECT:label1:Size = NEW System.Drawing.Size(114, 30).
        THIS-OBJECT:label1:TabIndex = 4.
        THIS-OBJECT:label1:Text = "Товар TH".
        THIS-OBJECT:label1:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label1:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:label1:Click:Subscribe(THIS-OBJECT:label1_Click_1).
        /*  */
        /* label2 */
        /*  */
        THIS-OBJECT:label2:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:label2:Location = NEW System.Drawing.Point(3, 30).
        THIS-OBJECT:label2:Name = "label2".
        THIS-OBJECT:label2:Size = NEW System.Drawing.Size(114, 30).
        THIS-OBJECT:label2:TabIndex = 5.
        THIS-OBJECT:label2:Text = "Товар ВСД".
        THIS-OBJECT:label2:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label2:UseCompatibleTextRendering = TRUE.
        /*  */
        /* gdsguid */
        /*  */
        DEFINE VARIABLE nestedvar6 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar6 = System.Windows.Forms.AnchorStyles:Left.
        THIS-OBJECT:gdsguid:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar6, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:gdsguid:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bingvsd, "gds-guid", TRUE)).
        THIS-OBJECT:gdsguid:Location = NEW System.Drawing.Point(583, 35).
        THIS-OBJECT:gdsguid:Name = "gdsguid".
        THIS-OBJECT:gdsguid:ReadOnly = TRUE.
        THIS-OBJECT:gdsguid:Size = NEW System.Drawing.Size(231, 20).
        THIS-OBJECT:gdsguid:TabIndex = 6.
        /*  */
        /* Btn_gds */
        /*  */
        THIS-OBJECT:Btn_gds:Anchor = System.Windows.Forms.AnchorStyles:Left.
        THIS-OBJECT:Btn_gds:Image = CAST(resources:GetObject("Btn_gds.Image"), System.Drawing.Image).
        THIS-OBJECT:Btn_gds:Location = NEW System.Drawing.Point(820, 3).
        THIS-OBJECT:Btn_gds:Name = "Btn_gds".
        THIS-OBJECT:Btn_gds:Size = NEW System.Drawing.Size(25, 23).
        THIS-OBJECT:Btn_gds:TabIndex = 7.
        THIS-OBJECT:Btn_gds:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:Btn_gds:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:Btn_gds:Click:Subscribe(THIS-OBJECT:Btn_gds_Click).
        /*  */
        /* btn_gds_merc */
        /*  */
        THIS-OBJECT:btn_gds_merc:Image = CAST(resources:GetObject("btn_gds_merc.Image"), System.Drawing.Image).
        THIS-OBJECT:btn_gds_merc:Location = NEW System.Drawing.Point(820, 33).
        THIS-OBJECT:btn_gds_merc:Name = "btn_gds_merc".
        THIS-OBJECT:btn_gds_merc:Size = NEW System.Drawing.Size(25, 23).
        THIS-OBJECT:btn_gds_merc:TabIndex = 8.
        THIS-OBJECT:btn_gds_merc:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btn_gds_merc:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btn_gds_merc:Click:Subscribe(THIS-OBJECT:btn_gds_merc_Click).
        /*  */
        /* NomTTH */
        /*  */
        DEFINE VARIABLE nestedvar7 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar7 = System.Windows.Forms.AnchorStyles:Left.
        THIS-OBJECT:NomTTH:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar7, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:NomTTH:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bingvsd, "NomTTH", TRUE)).
        THIS-OBJECT:NomTTH:Location = NEW System.Drawing.Point(123, 65).
        THIS-OBJECT:NomTTH:Name = "NomTTH".
        THIS-OBJECT:NomTTH:ReadOnly = TRUE.
        THIS-OBJECT:NomTTH:Size = NEW System.Drawing.Size(224, 20).
        THIS-OBJECT:NomTTH:TabIndex = 9.
        /*  */
        /* label3 */
        /*  */
        THIS-OBJECT:label3:Location = NEW System.Drawing.Point(3, 60).
        THIS-OBJECT:label3:Name = "label3".
        THIS-OBJECT:label3:Size = NEW System.Drawing.Size(100, 23).
        THIS-OBJECT:label3:TabIndex = 10.
        THIS-OBJECT:label3:Text = "Накладная".
        THIS-OBJECT:label3:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label3:UseCompatibleTextRendering = TRUE.
        /*  */
        /* btn_trndoc */
        /*  */
        THIS-OBJECT:btn_trndoc:Image = CAST(resources:GetObject("btn_trndoc.Image"), System.Drawing.Image).
        THIS-OBJECT:btn_trndoc:Location = NEW System.Drawing.Point(820, 63).
        THIS-OBJECT:btn_trndoc:Name = "btn_trndoc".
        THIS-OBJECT:btn_trndoc:Size = NEW System.Drawing.Size(25, 23).
        THIS-OBJECT:btn_trndoc:TabIndex = 11.
        THIS-OBJECT:btn_trndoc:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btn_trndoc:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btn_trndoc:Click:Subscribe(THIS-OBJECT:btn_trndoc_Click).
        /*  */
        /* panel1 */
        /*  */
        THIS-OBJECT:panel1:Controls:Add(THIS-OBJECT:panel2).
        THIS-OBJECT:panel1:Controls:Add(THIS-OBJECT:btn_prn).
        THIS-OBJECT:panel1:Controls:Add(THIS-OBJECT:btn_edit).
        THIS-OBJECT:panel1:Controls:Add(THIS-OBJECT:Btn_Cancel).
        THIS-OBJECT:panel1:Controls:Add(THIS-OBJECT:Btn_lookup).
        THIS-OBJECT:panel1:Dock = System.Windows.Forms.DockStyle:Top.
        THIS-OBJECT:panel1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:panel1:Name = "panel1".
        THIS-OBJECT:panel1:Size = NEW System.Drawing.Size(850, 100).
        THIS-OBJECT:panel1:TabIndex = 3.
        /*  */
        /* panel2 */
        /*  */
        THIS-OBJECT:panel2:BackColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:Btn_clen).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:Sent).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:btn_Filt).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:numericUpDown1).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:btn_ref).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:Rep).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:FalVerif).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:ToExtin).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:FalExting).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:ReqVerif).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:dateTimePicker2).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:label7).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:label6).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:dateTimePicker1).
        THIS-OBJECT:panel2:Controls:Add(THIS-OBJECT:label5).
        THIS-OBJECT:panel2:Location = NEW System.Drawing.Point(41, 42).
        THIS-OBJECT:panel2:Name = "panel2".
        THIS-OBJECT:panel2:Size = NEW System.Drawing.Size(765, 55).
        THIS-OBJECT:panel2:TabIndex = 5.
        /*  */
        /* Btn_clen */
        /*  */
        THIS-OBJECT:Btn_clen:Location = NEW System.Drawing.Point(575, 5).
        THIS-OBJECT:Btn_clen:Name = "Btn_clen".
        THIS-OBJECT:Btn_clen:Size = NEW System.Drawing.Size(75, 23).
        THIS-OBJECT:Btn_clen:TabIndex = 15.
        THIS-OBJECT:Btn_clen:Text = "Сброс".
        THIS-OBJECT:Btn_clen:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:Btn_clen:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:Btn_clen:Click:Subscribe(THIS-OBJECT:Btn_clen_Click).
        /*  */
        /* Sent */
        /*  */
        THIS-OBJECT:Sent:DataBindings:Add(NEW System.Windows.Forms.Binding("CheckState", THIS-OBJECT:bindttFilt, "sent", TRUE)).
        THIS-OBJECT:Sent:Location = NEW System.Drawing.Point(575, 29).
        THIS-OBJECT:Sent:Name = "Sent".
        THIS-OBJECT:Sent:Size = NEW System.Drawing.Size(82, 18).
        THIS-OBJECT:Sent:TabIndex = 14.
        THIS-OBJECT:Sent:Text = "Отправлен".
        THIS-OBJECT:Sent:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:Sent:UseVisualStyleBackColor = TRUE.
        /*  */
        /* bindttFilt */
        /*  */
        THIS-OBJECT:bindttFilt:MaxDataGuess = 0.
        THIS-OBJECT:bindttFilt:NoLOBs = FALSE.
        THIS-OBJECT:bindttFilt:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar3 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar3 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc2:ChildTables = arrayvar3.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar4 AS Progress.Data.ColumnPropDesc EXTENT 10 NO-UNDO.
        arrayvar4[1] = NEW Progress.Data.ColumnPropDesc("date-end", "date-end", Progress.Data.DataType:DATE).
        arrayvar4[2] = NEW Progress.Data.ColumnPropDesc("date-start", "date-start", Progress.Data.DataType:DATE).
        arrayvar4[3] = NEW Progress.Data.ColumnPropDesc("fTime", "fTime", Progress.Data.DataType:INTEGER).
        arrayvar4[4] = NEW Progress.Data.ColumnPropDesc("FalExting", "FalExting", Progress.Data.DataType:LOGICAL).
        arrayvar4[5] = NEW Progress.Data.ColumnPropDesc("FalVerif", "FalVerif", Progress.Data.DataType:LOGICAL).
        arrayvar4[6] = NEW Progress.Data.ColumnPropDesc("Rep", "Rep", Progress.Data.DataType:LOGICAL).
        arrayvar4[7] = NEW Progress.Data.ColumnPropDesc("ReqVerif", "ReqVerif", Progress.Data.DataType:LOGICAL).
        arrayvar4[8] = NEW Progress.Data.ColumnPropDesc("ToExtin", "ToExtin", Progress.Data.DataType:LOGICAL).
        arrayvar4[9] = NEW Progress.Data.ColumnPropDesc("doc-code", "doc-code", Progress.Data.DataType:CHARACTER).
        arrayvar4[10] = NEW Progress.Data.ColumnPropDesc("sent", " отправлен", Progress.Data.DataType:LOGICAL).
        tableDesc2:Columns = arrayvar4.
        THIS-OBJECT:bindttFilt:TableSchema = tableDesc2.
        /*  */
        /* btn_Filt */
        /*  */
        THIS-OBJECT:btn_Filt:Location = NEW System.Drawing.Point(663, 26).
        THIS-OBJECT:btn_Filt:Name = "btn_Filt".
        THIS-OBJECT:btn_Filt:Size = NEW System.Drawing.Size(99, 23).
        THIS-OBJECT:btn_Filt:TabIndex = 13.
        THIS-OBJECT:btn_Filt:Text = "Расшир. фильтр".
        THIS-OBJECT:btn_Filt:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btn_Filt:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btn_Filt:Click:Subscribe(THIS-OBJECT:btn_Filt_Click).
        /*  */
        /* numericUpDown1 */
        /*  */
        THIS-OBJECT:numericUpDown1:DataBindings:Add(NEW System.Windows.Forms.Binding("Value", THIS-OBJECT:bindttFilt, "fTime", TRUE, System.Windows.Forms.DataSourceUpdateMode:OnValidation, ?, "N0")).
        THIS-OBJECT:numericUpDown1:Location = NEW System.Drawing.Point(109, 3).
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true", Type="System.Int32").
        DEFINE VARIABLE arrayvar5 AS INTEGER EXTENT 4 NO-UNDO.
        arrayvar5[1] = 999999.
        arrayvar5[2] = 0.
        arrayvar5[3] = 0.
        arrayvar5[4] = 0.
        THIS-OBJECT:numericUpDown1:Maximum = Progress.Util.DecimalHelper:Create(arrayvar5).
        THIS-OBJECT:numericUpDown1:Name = "numericUpDown1".
        THIS-OBJECT:numericUpDown1:Size = NEW System.Drawing.Size(79, 20).
        THIS-OBJECT:numericUpDown1:TabIndex = 12.
        /*  */
        /* btn_ref */
        /*  */
        THIS-OBJECT:btn_ref:Location = NEW System.Drawing.Point(663, 3).
        THIS-OBJECT:btn_ref:Name = "btn_ref".
        THIS-OBJECT:btn_ref:Size = NEW System.Drawing.Size(99, 23).
        THIS-OBJECT:btn_ref:TabIndex = 11.
        THIS-OBJECT:btn_ref:Text = "Обновить".
        THIS-OBJECT:btn_ref:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btn_ref:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btn_ref:Click:Subscribe(THIS-OBJECT:btn_ref_Click).
        /*  */
        /* Rep */
        /*  */
        THIS-OBJECT:Rep:DataBindings:Add(NEW System.Windows.Forms.Binding("CheckState", THIS-OBJECT:bindttFilt, "Rep", TRUE)).
        THIS-OBJECT:Rep:Location = NEW System.Drawing.Point(500, 26).
        THIS-OBJECT:Rep:Name = "Rep".
        THIS-OBJECT:Rep:Size = NEW System.Drawing.Size(78, 24).
        THIS-OBJECT:Rep:TabIndex = 10.
        THIS-OBJECT:Rep:Text = "Погашен".
        THIS-OBJECT:Rep:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:Rep:UseVisualStyleBackColor = TRUE.
        /*  */
        /* FalVerif */
        /*  */
        THIS-OBJECT:FalVerif:DataBindings:Add(NEW System.Windows.Forms.Binding("CheckState", THIS-OBJECT:bindttFilt, "FalVerif", TRUE)).
        THIS-OBJECT:FalVerif:Location = NEW System.Drawing.Point(130, 26).
        THIS-OBJECT:FalVerif:Name = "FalVerif".
        THIS-OBJECT:FalVerif:Size = NEW System.Drawing.Size(152, 24).
        THIS-OBJECT:FalVerif:TabIndex = 9.
        THIS-OBJECT:FalVerif:Text = "Ошибка проверки ВСД".
        THIS-OBJECT:FalVerif:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:FalVerif:UseVisualStyleBackColor = TRUE.
        /*  */
        /* ToExtin */
        /*  */
        THIS-OBJECT:ToExtin:DataBindings:Add(NEW System.Windows.Forms.Binding("CheckState", THIS-OBJECT:bindttFilt, "ToExtin", TRUE)).
        THIS-OBJECT:ToExtin:Location = NEW System.Drawing.Point(288, 26).
        THIS-OBJECT:ToExtin:Name = "ToExtin".
        THIS-OBJECT:ToExtin:Size = NEW System.Drawing.Size(82, 24).
        THIS-OBJECT:ToExtin:TabIndex = 8.
        THIS-OBJECT:ToExtin:Text = "К гашению".
        THIS-OBJECT:ToExtin:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:ToExtin:UseVisualStyleBackColor = TRUE.
        /*  */
        /* FalExting */
        /*  */
        THIS-OBJECT:FalExting:DataBindings:Add(NEW System.Windows.Forms.Binding("CheckState", THIS-OBJECT:bindttFilt, "FalExting", TRUE)).
        THIS-OBJECT:FalExting:Location = NEW System.Drawing.Point(376, 26).
        THIS-OBJECT:FalExting:Name = "FalExting".
        THIS-OBJECT:FalExting:Size = NEW System.Drawing.Size(118, 24).
        THIS-OBJECT:FalExting:TabIndex = 7.
        THIS-OBJECT:FalExting:Text = "Ошибка гашения".
        THIS-OBJECT:FalExting:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:FalExting:UseVisualStyleBackColor = TRUE.
        /*  */
        /* ReqVerif */
        /*  */
        THIS-OBJECT:ReqVerif:DataBindings:Add(NEW System.Windows.Forms.Binding("CheckState", THIS-OBJECT:bindttFilt, "ReqVerif", TRUE)).
        THIS-OBJECT:ReqVerif:Location = NEW System.Drawing.Point(3, 26).
        THIS-OBJECT:ReqVerif:Name = "ReqVerif".
        THIS-OBJECT:ReqVerif:Size = NEW System.Drawing.Size(121, 24).
        THIS-OBJECT:ReqVerif:TabIndex = 6.
        THIS-OBJECT:ReqVerif:Text = "Требует проверки".
        THIS-OBJECT:ReqVerif:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:ReqVerif:UseVisualStyleBackColor = TRUE.
        /*  */
        /* dateTimePicker2 */
        /*  */
        THIS-OBJECT:dateTimePicker2:DataBindings:Add(NEW System.Windows.Forms.Binding("Value", THIS-OBJECT:bindttFilt, "date-end", TRUE, System.Windows.Forms.DataSourceUpdateMode:OnValidation, ?, "D")).
        THIS-OBJECT:dateTimePicker2:Location = NEW System.Drawing.Point(408, 4).
        THIS-OBJECT:dateTimePicker2:Name = "dateTimePicker2".
        THIS-OBJECT:dateTimePicker2:Size = NEW System.Drawing.Size(137, 20).
        THIS-OBJECT:dateTimePicker2:TabIndex = 5.
        /*  */
        /* label7 */
        /*  */
        THIS-OBJECT:label7:Location = NEW System.Drawing.Point(368, 4).
        THIS-OBJECT:label7:Name = "label7".
        THIS-OBJECT:label7:Size = NEW System.Drawing.Size(34, 20).
        THIS-OBJECT:label7:TabIndex = 4.
        THIS-OBJECT:label7:Text = "По:".
        THIS-OBJECT:label7:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
        THIS-OBJECT:label7:UseCompatibleTextRendering = TRUE.
        /*  */
        /* label6 */
        /*  */
        THIS-OBJECT:label6:ImageAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label6:Location = NEW System.Drawing.Point(194, 3).
        THIS-OBJECT:label6:Name = "label6".
        THIS-OBJECT:label6:Size = NEW System.Drawing.Size(23, 20).
        THIS-OBJECT:label6:TabIndex = 3.
        THIS-OBJECT:label6:Text = "C:".
        THIS-OBJECT:label6:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
        THIS-OBJECT:label6:UseCompatibleTextRendering = TRUE.
        /*  */
        /* dateTimePicker1 */
        /*  */
        THIS-OBJECT:dateTimePicker1:DataBindings:Add(NEW System.Windows.Forms.Binding("Value", THIS-OBJECT:bindttFilt, "date-start", TRUE, System.Windows.Forms.DataSourceUpdateMode:OnValidation, ?, "D")).
        THIS-OBJECT:dateTimePicker1:Location = NEW System.Drawing.Point(223, 4).
        THIS-OBJECT:dateTimePicker1:Name = "dateTimePicker1".
        THIS-OBJECT:dateTimePicker1:Size = NEW System.Drawing.Size(139, 20).
        THIS-OBJECT:dateTimePicker1:TabIndex = 2.
        THIS-OBJECT:dateTimePicker1:Value = Progress.Util.DateTimeHelper:Create(2018, 6, 15, 0, 0, 0, 0).
        /*  */
        /* label5 */
        /*  */
        THIS-OBJECT:label5:ImageAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label5:Location = NEW System.Drawing.Point(3, 3).
        THIS-OBJECT:label5:Name = "label5".
        THIS-OBJECT:label5:Size = NEW System.Drawing.Size(100, 20).
        THIS-OBJECT:label5:TabIndex = 0.
        THIS-OBJECT:label5:Text = "Время гашения :".
        THIS-OBJECT:label5:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label5:UseCompatibleTextRendering = TRUE.
        /*  */
        /* btn_prn */
        /*  */
        THIS-OBJECT:btn_prn:Location = NEW System.Drawing.Point(285, 12).
        THIS-OBJECT:btn_prn:Name = "btn_prn".
        THIS-OBJECT:btn_prn:Size = NEW System.Drawing.Size(75, 23).
        THIS-OBJECT:btn_prn:TabIndex = 4.
        THIS-OBJECT:btn_prn:Text = "Печать".
        THIS-OBJECT:btn_prn:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btn_prn:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btn_prn:Click:Subscribe(THIS-OBJECT:btn_prn_Click).
        /*  */
        /* btn_edit */
        /*  */
        THIS-OBJECT:btn_edit:Location = NEW System.Drawing.Point(123, 12).
        THIS-OBJECT:btn_edit:Name = "btn_edit".
        THIS-OBJECT:btn_edit:Size = NEW System.Drawing.Size(75, 23).
        THIS-OBJECT:btn_edit:TabIndex = 2.
        THIS-OBJECT:btn_edit:Text = "Изменить".
        THIS-OBJECT:btn_edit:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:btn_edit:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:btn_edit:Click:Subscribe(THIS-OBJECT:btn_edit_Click).
        /*  */
        /* Btn_Cancel */
        /*  */
        THIS-OBJECT:Btn_Cancel:Location = NEW System.Drawing.Point(41, 13).
        THIS-OBJECT:Btn_Cancel:Name = "Btn_Cancel".
        THIS-OBJECT:Btn_Cancel:Size = NEW System.Drawing.Size(75, 23).
        THIS-OBJECT:Btn_Cancel:TabIndex = 1.
        THIS-OBJECT:Btn_Cancel:Text = "Выход".
        THIS-OBJECT:Btn_Cancel:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:Btn_Cancel:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:Btn_Cancel:Click:Subscribe(THIS-OBJECT:Btn_Cancel_Click).
        /*  */
        /* msgerr */
        /*  */
        DEFINE VARIABLE nestedvar8 AS System.Windows.Forms.AnchorStyles NO-UNDO.
        nestedvar8 = CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Bottom, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:msgerr:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar8, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
        THIS-OBJECT:msgerr:DataBindings:Add(NEW System.Windows.Forms.Binding("Text", THIS-OBJECT:bingvsd, "msg-err", TRUE)).
        THIS-OBJECT:msgerr:Location = NEW System.Drawing.Point(12, 503).
        THIS-OBJECT:msgerr:Multiline = TRUE.
        THIS-OBJECT:msgerr:Name = "msgerr".
        THIS-OBJECT:msgerr:ReadOnly = TRUE.
        THIS-OBJECT:msgerr:Size = NEW System.Drawing.Size(826, 40).
        THIS-OBJECT:msgerr:TabIndex = 4.
        /*  */
        /* label4 */
        /*  */
        THIS-OBJECT:label4:Anchor = System.Windows.Forms.AnchorStyles:Bottom.
        THIS-OBJECT:label4:Location = NEW System.Drawing.Point(24, 477).
        THIS-OBJECT:label4:Name = "label4".
        THIS-OBJECT:label4:Size = NEW System.Drawing.Size(792, 23).
        THIS-OBJECT:label4:TabIndex = 5.
        THIS-OBJECT:label4:Text = "Описание ошибки".
        THIS-OBJECT:label4:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
        THIS-OBJECT:label4:UseCompatibleTextRendering = TRUE.
        /*  */
        /* journal_vsd_abl */
        /*  */
        THIS-OBJECT:ClientSize = NEW System.Drawing.Size(850, 546).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:label4).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:msgerr).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:tableLayoutPanel1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:dataGridView1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:panel1).
        THIS-OBJECT:Name = "journal_vsd_abl".
        THIS-OBJECT:Text = "Журнал ВСД".
        THIS-OBJECT:Load:Subscribe(THIS-OBJECT:journal_vsd_abl_Load).
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:bingvsd, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:tableLayoutPanel1:ResumeLayout(FALSE).
        THIS-OBJECT:tableLayoutPanel1:PerformLayout().
        THIS-OBJECT:panel1:ResumeLayout(FALSE).
        THIS-OBJECT:panel2:ResumeLayout(FALSE).
        CAST(THIS-OBJECT:bindttFilt, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:numericUpDown1, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:ResumeLayout(FALSE).
        THIS-OBJECT:PerformLayout().
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID journal_vsd_abl_Load( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		RETURN.

	END METHOD.
	


	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID label1_Click_1( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		RETURN.

	END METHOD.





	METHOD PUBLIC VOID ShowModalDialog(  ):
    
      WAIT-FOR THIS-OBJECT:ShowDialog().

    END METHOD.



    DESTRUCTOR PUBLIC journal_vsd_abl ( ):
        DELETE  OBJECT vjournalvsdTrg NO-ERROR.
    END DESTRUCTOR.

END CLASS.