 
 /*------------------------------------------------------------------------
    File        : userhist
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svvtm
    Created     : Fri Nov 15 11:46:29 MSK 2024
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING ibs.th.ref.sobj.*.
USING ibs.th.ref.sobj.sUserFrame.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS ibs.th.ref.sobj.userhist INHERITS sUserFrame: 
    
    DEFINE PRIVATE VARIABLE bindingSource1 AS Progress.Data.BindingSource NO-UNDO.
    DEFINE PRIVATE VARIABLE button1 AS System.Windows.Forms.Button NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView1 AS System.Windows.Forms.DataGridView NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridView150 AS System.Windows.Forms.DataGridView NO-UNDO.
    DEFINE PRIVATE VARIABLE dataGridViewCheckBoxColumn1 AS System.Windows.Forms.DataGridViewCheckBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE flg AS System.Windows.Forms.DataGridViewCheckBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE label1 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE label2 AS System.Windows.Forms.Label NO-UNDO.
    DEFINE PRIVATE VARIABLE nameDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE users AS Progress.Data.BindingSource NO-UNDO.
    DEFINE PRIVATE VARIABLE usernameDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE useridDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    DEFINE PRIVATE VARIABLE dbnumDataGridViewTextBoxColumn AS System.Windows.Forms.DataGridViewTextBoxColumn NO-UNDO.
    /* DEFINE         VARIABLE useracntObj AS CLASS ibs.th.ref.sobj.useracnt no-undo. */
    DEFINE         VARIABLE usertableObj AS CLASS ibs.th.ref.sobj.usertable no-undo.  
    DEFINE         VARIABLE mparamObj AS CLASS ibs.th.ref.sobj.sParamObj no-undo.
     
      
    CONSTRUCTOR PUBLIC userhist (  ):
        
    SUPER().
    InitializeComponent().
    
    /* useracntObj = new useracnt(). */
    
    usertableObj = new usertable (THIS-OBJECT).
    users:Handle = usertableObj:query_user-account.
      
    bindingSource1:Handle = usertableObj:query_user-table.         
        
        
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
 
    END CONSTRUCTOR.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID button1_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		usertableObj:init_tt().
	
    bindingSource1:handle:query-open.
    bindingSource1:RefreshAll() .
    
    users:handle:query-open.
    users:RefreshAll() .
    
		RETURN.
                 
    
	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID dataGridView1_CellContentClick( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.DataGridViewCellEventArgs ):
	usertableObj:mark_user().
	users:Refresh().
		RETURN.

	END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID dataGridView2_CellContentClick( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.DataGridViewCellEventArgs ):
    usertableObj:mark_table() . 
    bindingSource1:Refresh().		
		RETURN.

	END METHOD.

    METHOD PRIVATE VOID InitializeComponent(  ):
        
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        THIS-OBJECT:components = NEW System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE dataGridViewCellStyle13 AS System.Windows.Forms.DataGridViewCellStyle NO-UNDO.
        dataGridViewCellStyle13 = NEW System.Windows.Forms.DataGridViewCellStyle().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE dataGridViewCellStyle14 AS System.Windows.Forms.DataGridViewCellStyle NO-UNDO.
        dataGridViewCellStyle14 = NEW System.Windows.Forms.DataGridViewCellStyle().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE dataGridViewCellStyle15 AS System.Windows.Forms.DataGridViewCellStyle NO-UNDO.
        dataGridViewCellStyle15 = NEW System.Windows.Forms.DataGridViewCellStyle().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc5 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc5 = NEW Progress.Data.TableDesc("tt-user-account").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE tableDesc6 AS Progress.Data.TableDesc NO-UNDO.
        tableDesc6 = NEW Progress.Data.TableDesc("tt-objects").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE dataGridViewCellStyle16 AS System.Windows.Forms.DataGridViewCellStyle NO-UNDO.
        dataGridViewCellStyle16 = NEW System.Windows.Forms.DataGridViewCellStyle().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE dataGridViewCellStyle17 AS System.Windows.Forms.DataGridViewCellStyle NO-UNDO.
        dataGridViewCellStyle17 = NEW System.Windows.Forms.DataGridViewCellStyle().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE dataGridViewCellStyle18 AS System.Windows.Forms.DataGridViewCellStyle NO-UNDO.
        dataGridViewCellStyle18 = NEW System.Windows.Forms.DataGridViewCellStyle().
        THIS-OBJECT:dataGridView1 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:users = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:bindingSource1 = NEW Progress.Data.BindingSource(THIS-OBJECT:components).
        THIS-OBJECT:dataGridView150 = NEW System.Windows.Forms.DataGridView().
        THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:label2 = NEW System.Windows.Forms.Label().
        THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
        THIS-OBJECT:useridDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:usernameDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:dbnumDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:flg = NEW System.Windows.Forms.DataGridViewCheckBoxColumn().
        THIS-OBJECT:nameDataGridViewTextBoxColumn = NEW System.Windows.Forms.DataGridViewTextBoxColumn().
        THIS-OBJECT:dataGridViewCheckBoxColumn1 = NEW System.Windows.Forms.DataGridViewCheckBoxColumn().
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:users, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:bindingSource1, System.ComponentModel.ISupportInitialize):BeginInit().
        CAST(THIS-OBJECT:dataGridView150, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* dataGridView1 */
        /*  */
        THIS-OBJECT:dataGridView1:AccessibleDescription = "".
        THIS-OBJECT:dataGridView1:AccessibleName = "".
        THIS-OBJECT:dataGridView1:AutoGenerateColumns = FALSE.
        dataGridViewCellStyle13:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleLeft.
        dataGridViewCellStyle13:BackColor = System.Drawing.SystemColors:Control.
        dataGridViewCellStyle13:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        dataGridViewCellStyle13:ForeColor = System.Drawing.SystemColors:WindowText.
        dataGridViewCellStyle13:SelectionBackColor = System.Drawing.SystemColors:Highlight.
        dataGridViewCellStyle13:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
        dataGridViewCellStyle13:WrapMode = System.Windows.Forms.DataGridViewTriState:True.
        THIS-OBJECT:dataGridView1:ColumnHeadersDefaultCellStyle = dataGridViewCellStyle13.
        THIS-OBJECT:dataGridView1:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar0 AS System.Windows.Forms.DataGridViewColumn EXTENT 4 NO-UNDO.
        arrayvar0[1] = THIS-OBJECT:useridDataGridViewTextBoxColumn.
        arrayvar0[2] = THIS-OBJECT:usernameDataGridViewTextBoxColumn.
        arrayvar0[3] = THIS-OBJECT:dbnumDataGridViewTextBoxColumn.
        arrayvar0[4] = THIS-OBJECT:flg.
        THIS-OBJECT:dataGridView1:Columns:AddRange(arrayvar0).
        THIS-OBJECT:dataGridView1:DataSource = THIS-OBJECT:users.
        dataGridViewCellStyle14:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleLeft.
        dataGridViewCellStyle14:BackColor = System.Drawing.SystemColors:Window.
        dataGridViewCellStyle14:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        dataGridViewCellStyle14:ForeColor = System.Drawing.SystemColors:ControlText.
        dataGridViewCellStyle14:SelectionBackColor = System.Drawing.SystemColors:Highlight.
        dataGridViewCellStyle14:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
        dataGridViewCellStyle14:WrapMode = System.Windows.Forms.DataGridViewTriState:False.
        THIS-OBJECT:dataGridView1:DefaultCellStyle = dataGridViewCellStyle14.
        THIS-OBJECT:dataGridView1:Location = NEW System.Drawing.Point(23, 32).
        THIS-OBJECT:dataGridView1:Name = "dataGridView1".
        dataGridViewCellStyle15:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleLeft.
        dataGridViewCellStyle15:BackColor = System.Drawing.SystemColors:Control.
        dataGridViewCellStyle15:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        dataGridViewCellStyle15:ForeColor = System.Drawing.SystemColors:WindowText.
        dataGridViewCellStyle15:SelectionBackColor = System.Drawing.SystemColors:Highlight.
        dataGridViewCellStyle15:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
        dataGridViewCellStyle15:WrapMode = System.Windows.Forms.DataGridViewTriState:True.
        THIS-OBJECT:dataGridView1:RowHeadersDefaultCellStyle = dataGridViewCellStyle15.
        THIS-OBJECT:dataGridView1:Size = NEW System.Drawing.Size(420, 202).
        THIS-OBJECT:dataGridView1:TabIndex = 0.
        THIS-OBJECT:dataGridView1:CellContentClick:Subscribe(THIS-OBJECT:dataGridView1_CellContentClick).
        /*  */
        /* users */
        /*  */
        THIS-OBJECT:users:MaxDataGuess = 0.
        THIS-OBJECT:users:NoLOBs = FALSE.
        THIS-OBJECT:users:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar1 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar1 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc5:ChildTables = arrayvar1.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar2 AS Progress.Data.ColumnPropDesc EXTENT 4 NO-UNDO.
        arrayvar2[1] = NEW Progress.Data.ColumnPropDesc("user-id_", "ID", Progress.Data.DataType:CHARACTER).
        arrayvar2[2] = NEW Progress.Data.ColumnPropDesc("user_name", "Имя пользователя", Progress.Data.DataType:CHARACTER).
        arrayvar2[3] = NEW Progress.Data.ColumnPropDesc("db-num", "БД ", Progress.Data.DataType:INTEGER).
        arrayvar2[4] = NEW Progress.Data.ColumnPropDesc("flg", " * ", Progress.Data.DataType:LOGICAL).
        tableDesc5:Columns = arrayvar2.
        THIS-OBJECT:users:TableSchema = tableDesc5.
        /*  */
        /* bindingSource1 */
        /*  */
        THIS-OBJECT:bindingSource1:MaxDataGuess = 0.
        THIS-OBJECT:bindingSource1:NoLOBs = FALSE.
        THIS-OBJECT:bindingSource1:Position = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar3 AS "Progress.Data.TableDesc[]" NO-UNDO.
        arrayvar3 = NEW "Progress.Data.TableDesc[]"(0).
        tableDesc6:ChildTables = arrayvar3.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar4 AS Progress.Data.ColumnPropDesc EXTENT 2 NO-UNDO.
        arrayvar4[1] = NEW Progress.Data.ColumnPropDesc("name_", "", Progress.Data.DataType:CHARACTER).
        arrayvar4[2] = NEW Progress.Data.ColumnPropDesc("flg", "***", Progress.Data.DataType:LOGICAL).
        tableDesc6:Columns = arrayvar4.
        THIS-OBJECT:bindingSource1:TableSchema = tableDesc6.
        /*  */
        /* dataGridView150 */
        /*  */
        THIS-OBJECT:dataGridView150:AutoGenerateColumns = FALSE.
        dataGridViewCellStyle16:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleLeft.
        dataGridViewCellStyle16:BackColor = System.Drawing.SystemColors:Control.
        dataGridViewCellStyle16:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        dataGridViewCellStyle16:ForeColor = System.Drawing.SystemColors:WindowText.
        dataGridViewCellStyle16:SelectionBackColor = System.Drawing.SystemColors:Highlight.
        dataGridViewCellStyle16:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
        dataGridViewCellStyle16:WrapMode = System.Windows.Forms.DataGridViewTriState:True.
        THIS-OBJECT:dataGridView150:ColumnHeadersDefaultCellStyle = dataGridViewCellStyle16.
        THIS-OBJECT:dataGridView150:ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode:AutoSize.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar5 AS System.Windows.Forms.DataGridViewColumn EXTENT 2 NO-UNDO.
        arrayvar5[1] = THIS-OBJECT:nameDataGridViewTextBoxColumn.
        arrayvar5[2] = THIS-OBJECT:dataGridViewCheckBoxColumn1.
        THIS-OBJECT:dataGridView150:Columns:AddRange(arrayvar5).
        THIS-OBJECT:dataGridView150:DataSource = THIS-OBJECT:bindingSource1.
        dataGridViewCellStyle17:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleLeft.
        dataGridViewCellStyle17:BackColor = System.Drawing.SystemColors:Window.
        dataGridViewCellStyle17:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        dataGridViewCellStyle17:ForeColor = System.Drawing.SystemColors:ControlText.
        dataGridViewCellStyle17:SelectionBackColor = System.Drawing.SystemColors:Highlight.
        dataGridViewCellStyle17:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
        dataGridViewCellStyle17:WrapMode = System.Windows.Forms.DataGridViewTriState:False.
        THIS-OBJECT:dataGridView150:DefaultCellStyle = dataGridViewCellStyle17.
        THIS-OBJECT:dataGridView150:Location = NEW System.Drawing.Point(23, 266).
        THIS-OBJECT:dataGridView150:Name = "dataGridView150".
        dataGridViewCellStyle18:Alignment = System.Windows.Forms.DataGridViewContentAlignment:MiddleLeft.
        dataGridViewCellStyle18:BackColor = System.Drawing.SystemColors:Control.
        dataGridViewCellStyle18:Font = NEW System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        dataGridViewCellStyle18:ForeColor = System.Drawing.SystemColors:WindowText.
        dataGridViewCellStyle18:SelectionBackColor = System.Drawing.SystemColors:Highlight.
        dataGridViewCellStyle18:SelectionForeColor = System.Drawing.SystemColors:HighlightText.
        dataGridViewCellStyle18:WrapMode = System.Windows.Forms.DataGridViewTriState:True.
        THIS-OBJECT:dataGridView150:RowHeadersDefaultCellStyle = dataGridViewCellStyle18.
        THIS-OBJECT:dataGridView150:Size = NEW System.Drawing.Size(420, 216).
        THIS-OBJECT:dataGridView150:TabIndex = 1.
        THIS-OBJECT:dataGridView150:CellContentClick:Subscribe(THIS-OBJECT:dataGridView2_CellContentClick).
        /*  */
        /* label1 */
        /*  */
        THIS-OBJECT:label1:Location = NEW System.Drawing.Point(23, 6).
        THIS-OBJECT:label1:Name = "label1".
        THIS-OBJECT:label1:Size = NEW System.Drawing.Size(220, 23).
        THIS-OBJECT:label1:TabIndex = 2.
        THIS-OBJECT:label1:Text = "Пользователи:".
        THIS-OBJECT:label1:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label1:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:label1:Click:Subscribe(THIS-OBJECT:label1_Click).
        /*  */
        /* label2 */
        /*  */
        THIS-OBJECT:label2:Location = NEW System.Drawing.Point(23, 240).
        THIS-OBJECT:label2:Name = "label2".
        THIS-OBJECT:label2:Size = NEW System.Drawing.Size(100, 23).
        THIS-OBJECT:label2:TabIndex = 3.
        THIS-OBJECT:label2:Text = "Типы событий:".
        THIS-OBJECT:label2:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
        THIS-OBJECT:label2:UseCompatibleTextRendering = TRUE.
        /*  */
        /* button1 */
        /*  */
        THIS-OBJECT:button1:Location = NEW System.Drawing.Point(455, 32).
        THIS-OBJECT:button1:Name = "button1".
        THIS-OBJECT:button1:Size = NEW System.Drawing.Size(46, 50).
        THIS-OBJECT:button1:TabIndex = 4.
        THIS-OBJECT:button1:Text = "button1".
        THIS-OBJECT:button1:UseCompatibleTextRendering = TRUE.
        THIS-OBJECT:button1:UseVisualStyleBackColor = TRUE.
        THIS-OBJECT:button1:Click:Subscribe(THIS-OBJECT:button1_Click).
        /*  */
        /* useridDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:useridDataGridViewTextBoxColumn:DataPropertyName = "user-id_".
        THIS-OBJECT:useridDataGridViewTextBoxColumn:HeaderText = " ID".
        THIS-OBJECT:useridDataGridViewTextBoxColumn:Name = "useridDataGridViewTextBoxColumn".
        THIS-OBJECT:useridDataGridViewTextBoxColumn:Width = 60.
        /*  */
        /* usernameDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:usernameDataGridViewTextBoxColumn:DataPropertyName = "user_name".
        THIS-OBJECT:usernameDataGridViewTextBoxColumn:FillWeight = Progress.Util.CastUtil:ToSingle(200).
        THIS-OBJECT:usernameDataGridViewTextBoxColumn:HeaderText = " Имя пользователя".
        THIS-OBJECT:usernameDataGridViewTextBoxColumn:Name = "usernameDataGridViewTextBoxColumn".
        THIS-OBJECT:usernameDataGridViewTextBoxColumn:Width = 290.
        /*  */
        /* dbnumDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:dbnumDataGridViewTextBoxColumn:DataPropertyName = "db-num".
        THIS-OBJECT:dbnumDataGridViewTextBoxColumn:HeaderText = " БД ".
        THIS-OBJECT:dbnumDataGridViewTextBoxColumn:Name = "dbnumDataGridViewTextBoxColumn".
        /*  */
        /* flg */
        /*  */
        THIS-OBJECT:flg:DataPropertyName = "flg".
        THIS-OBJECT:flg:HeaderText = "".
        THIS-OBJECT:flg:Name = "flg".
        THIS-OBJECT:flg:Width = 50.
        /*  */
        /* nameDataGridViewTextBoxColumn */
        /*  */
        THIS-OBJECT:nameDataGridViewTextBoxColumn:DataPropertyName = "name_".
        THIS-OBJECT:nameDataGridViewTextBoxColumn:HeaderText = "Типы событий".
        THIS-OBJECT:nameDataGridViewTextBoxColumn:Name = "nameDataGridViewTextBoxColumn".
        THIS-OBJECT:nameDataGridViewTextBoxColumn:Width = 450.
        /*  */
        /* dataGridViewCheckBoxColumn1 */
        /*  */
        THIS-OBJECT:dataGridViewCheckBoxColumn1:DataPropertyName = "flg".
        THIS-OBJECT:dataGridViewCheckBoxColumn1:HeaderText = "".
        THIS-OBJECT:dataGridViewCheckBoxColumn1:Name = "dataGridViewCheckBoxColumn1".
        THIS-OBJECT:dataGridViewCheckBoxColumn1:Width = 50.
        /*  */
        /* userhist */
        /*  */
        THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:button1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:label2).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:label1).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:dataGridView150).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:dataGridView1).
        THIS-OBJECT:Name = "userhist".
        THIS-OBJECT:Size = NEW System.Drawing.Size(517, 506).
        THIS-OBJECT:Load:Subscribe(THIS-OBJECT:userhist_Load).
        CAST(THIS-OBJECT:dataGridView1, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:users, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:bindingSource1, System.ComponentModel.ISupportInitialize):EndInit().
        CAST(THIS-OBJECT:dataGridView150, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:ResumeLayout(FALSE).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
    END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID label1_Click( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		RETURN.

	END METHOD.
	
	

   method override public void my-report ():
       
    usertableObj:my_report().
      
   END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	METHOD PRIVATE VOID userhist_Load( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
		
		RETURN.

	END METHOD.	 
	

    DESTRUCTOR PUBLIC userhist ( ):

        IF VALID-OBJECT(components) THEN DO:
            CAST(components, System.IDisposable):Dispose().
        END.

    END DESTRUCTOR.

END CLASS.