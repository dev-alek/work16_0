 /*------------------------------------------------------------------------
    File        : cashbookfrm
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : sslivenko
    Created     : Thu Dec 06 09:59:03 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Windows.Form.
using ibs.th.ref.cashbookstorage from propath.
  
block-level on error undo, throw.
class ibs.th.ref.cashbookfrm inherits Form : 
  { cmp/str-glbl.i   class}
  
  { ibs/th/ref/ttCashBook.i }
  
  define private variable bChooseCli as System.Windows.Forms.Button no-undo.
  define private variable bChooseCredit as System.Windows.Forms.Button no-undo.
  define private variable bChooseDebit as System.Windows.Forms.Button no-undo.
  define private variable bindingSource1 as Progress.Data.BindingSource no-undo.
  define private variable components as System.ComponentModel.IContainer no-undo.
  define private variable buttonOk as System.Windows.Forms.Button no-undo.
  define private variable buttonCancel as System.Windows.Forms.Button no-undo.
  define private variable fExtCode as System.Windows.Forms.TextBox no-undo.
  define private variable fDebet as System.Windows.Forms.TextBox no-undo.
  define private variable fCredit as System.Windows.Forms.TextBox no-undo.
  define private variable FlagSepFuel as System.Windows.Forms.CheckBox no-undo.
  define private variable FlagSepCash as System.Windows.Forms.CheckBox no-undo.
  define private variable fRulePril as System.Windows.Forms.ComboBox no-undo.
  define private variable fRuleOsn as System.Windows.Forms.TextBox no-undo.
  define private variable fName as System.Windows.Forms.TextBox no-undo.
  define private variable fTakenFrom as System.Windows.Forms.TextBox no-undo.
  define private variable label1 as System.Windows.Forms.Label no-undo.
  define private variable label2 as System.Windows.Forms.Label no-undo.
  define private variable label4 as System.Windows.Forms.Label no-undo.
  define private variable label3 as System.Windows.Forms.Label no-undo.
  define private variable label6 as System.Windows.Forms.Label no-undo.
  define private variable label5 as System.Windows.Forms.Label no-undo.
  define private variable label7 as System.Windows.Forms.Label no-undo.
  
  define private variable label8 as System.Windows.Forms.Label no-undo.
  define private variable lCli as System.Windows.Forms.Label no-undo.
  define         variable mCashBook as class ibs.th.ref.cashbookstorage no-undo .
  define variable v-cashbookId as int64 no-undo .
  
  define buffer buf_cashbook for ub.cashbook .
  define buffer buf_cashbookrule for ub.cashbookrule .
  
  define property parparentproc as handle no-undo
  private get.
  set(input iH as handle):
        parparentproc = ih.
  end.
  
  /*define property host-code as integer no-undo
  private get.
  set(input iH as integer):
        host-code = ih.
  end.*/
  
  constructor public cashbookfrm (Mode as character, p-id as int64 ):
    
    super().
    
    mCashBook = new cashbookstorage () .
    
    empty temp-table tt-cashbook .
    create tt-CashBook .
    case Mode: 
      when {&add-def} then 
      do:
        tt-cashbook.id = ? .
      end.
      when {&update}
      or when {&lookup} then 
      do:
        find first buf_cashbook no-lock where buf_cashbook.id = p-id .
        buffer-copy buf_cashbook to tt-cashbook .
      end. 
    end case .

    InitializeComponent().
    Visual_form(Mode).
    bindingSource1:Handle = buffer tt-CashBook:handle . 
    
    this-object:ComponentsCollection:ADD(this-object:components).
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.

  end constructor.
   
  constructor public cashbookfrm( ):
   
      super().
      InitializeComponent ( ).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.      

  end constructor.

  destructor public cashbookfrm( ):
    
    delete object mCashBook no-error .

      if valid-object(components) then do:
         cast(components, System.IDisposable):Dispose().
      end.

  end destructor.   



	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void bChooseCli_Click( input sender as System.Object, input e as System.EventArgs ):
		
		define variable ref-rec as recid no-undo .
    define variable ref-list as character no-undo.
    
    run ref/cli-all.w ( input parParentProc
                     ,input "b-add,b-sel"
                     ,input {&all}
                     ,input ?
                     ,input ?
                     ,input ?
                     ,input ?
                     ,input ?
                     ,output ref-list) .
    if ref-list = "" then do:
      return .
    end.
    ref-rec = integer( ref-list ).
    FIND ub.clients WHERE recid (ub.clients) = ref-rec NO-LOCK .
    this-object:lCli:Text = ub.clients.obj-type + string(ub.clients.obj-code) + "   " + ub.clients.obj-name .
    this-object:lCli:Focus().
    assign
      tt-CashBook.cli-type = ub.clients.obj-type
      tt-CashBook.cli-code = ub.clients.obj-code
    .  
    
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void bChooseCredit_Click( input sender as System.Object, input e as System.EventArgs ):
		define variable rid-list as character no-undo.
    rid-list = "":U .
    run ref/fwcode-1.w (
                    parParentProc
                  ,"b-sel"
                  ,{&all}
                  ,input ?
                  ,input ?
                  ,output rid-list ).
    
    if rid-list <> "":U then do:
      FIND FIRST fin-code-cor-acc WHERE
          recid( fin-code-cor-acc ) = integer(entry(1, rid-list)) NO-LOCK .
      if fin-code-cor-acc.status_ <> integer({&current-status-int}) then do:
        message
        "Нельзя выбрать удаленный корр счет"
        view-as alert-box error .
        return .
      end.
      this-object:fCredit:Text = fin-code-cor-acc.code-value .
      this-object:fCredit:focus() .
    end.
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void bChooseDebit_Click( input sender as System.Object, input e as System.EventArgs ):
		define variable rid-list as character no-undo.
    rid-list = "":U .
    run ref/fwcode-1.w (
                    parParentProc
                  ,"b-sel"
                  ,{&all}
                  ,input ?
                  ,input ?
                  ,output rid-list ).
    
    if rid-list <> "":U then do:
      FIND FIRST fin-code-cor-acc WHERE
          recid( fin-code-cor-acc ) = integer(entry(1, rid-list)) NO-LOCK .
      if fin-code-cor-acc.status_ <> integer({&current-status-int}) then do:
        message
        "Нельзя выбрать удаленный корр счет"
        view-as alert-box error .
        return .
      end.
      this-object:fDebet:Text = fin-code-cor-acc.code-value .
      this-object:fDebet:focus() .
    end.
		return.

	end method.

  method private void okButton_Click (sender as System.Object, e as System.EventArgs):
      bindingSource1:Assign().
      if tt-cashbook.id = ?
      then do :
        mCashBook:insertDB(buffer tt-cashbook, output v-cashbookId) .
      end.
      else do :
        mCashBook:updateDB(buffer tt-cashbook) .
      end.
      if mCashBook:Msg <> ""
      then do :
        message mCashBook:Msg view-as alert-box .
        return .
      end.
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
    tableDesc1 = new Progress.Data.TableDesc("tt-CashBook").
    this-object:buttonOk = new System.Windows.Forms.Button().
    this-object:buttonCancel = new System.Windows.Forms.Button().
    this-object:label1 = new System.Windows.Forms.Label().
    this-object:fName = new System.Windows.Forms.TextBox().
    this-object:bindingSource1 = new Progress.Data.BindingSource(this-object:components).
    this-object:label5 = new System.Windows.Forms.Label().
    this-object:label6 = new System.Windows.Forms.Label().
    this-object:FlagSepFuel = new System.Windows.Forms.CheckBox().
    this-object:FlagSepCash = new System.Windows.Forms.CheckBox().
    this-object:label3 = new System.Windows.Forms.Label().
    this-object:fExtCode = new System.Windows.Forms.TextBox().
    this-object:label4 = new System.Windows.Forms.Label().
    this-object:label7 = new System.Windows.Forms.Label().
    this-object:fCredit = new System.Windows.Forms.TextBox().
    this-object:fDebet = new System.Windows.Forms.TextBox().
    this-object:fRulePril = new System.Windows.Forms.ComboBox().
    this-object:bChooseCredit = new System.Windows.Forms.Button().
    this-object:bChooseDebit = new System.Windows.Forms.Button().
    this-object:label2 = new System.Windows.Forms.Label().
    this-object:label8 = new System.Windows.Forms.Label().
    this-object:fTakenFrom = new System.Windows.Forms.TextBox().
    this-object:bChooseCli = new System.Windows.Forms.Button().
    this-object:lCli = new System.Windows.Forms.Label().
    this-object:fRuleOsn = new System.Windows.Forms.TextBox().
    cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):BeginInit().
    this-object:SuspendLayout().
    /*  */
    /* buttonOk */
    /*  */
    this-object:buttonOk:Location = new System.Drawing.Point(12, 12).
    this-object:buttonOk:Name = "buttonOk".
    this-object:buttonOk:Size = new System.Drawing.Size(75, 23).
    this-object:buttonOk:TabIndex = 0.
    this-object:buttonOk:Text = "Ввод".
    this-object:buttonOk:UseCompatibleTextRendering = true.
    this-object:buttonOk:Click:Subscribe(this-object:okButton_Click).
    /*  */
    /* buttonCancel */
    /*  */
    define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
    nestedvar0 = System.Windows.Forms.AnchorStyles:Bottom.
    this-object:buttonCancel:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    this-object:buttonCancel:DialogResult = System.Windows.Forms.DialogResult:Cancel.
    this-object:buttonCancel:Location = new System.Drawing.Point(93, 12).
    this-object:buttonCancel:Name = "buttonCancel".
    this-object:buttonCancel:Size = new System.Drawing.Size(75, 23).
    this-object:buttonCancel:TabIndex = 1.
    this-object:buttonCancel:Text = "Отмена".
    this-object:buttonCancel:UseCompatibleTextRendering = true.
    this-object:buttonCancel:Click:Subscribe(this-object:cancelButton_Click).
    /*  */
    /* label1 */
    /*  */
    this-object:label1:Location = new System.Drawing.Point(12, 38).
    this-object:label1:Name = "label1".
    this-object:label1:Size = new System.Drawing.Size(199, 23).
    this-object:label1:TabIndex = 2.
    this-object:label1:Text = "Наименование типа кассовой книги:".
    this-object:label1:UseCompatibleTextRendering = true.
    /*  */
    /* fName */
    /*  */
    this-object:fName:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindingSource1, "CashBookName", true)).
    this-object:fName:Location = new System.Drawing.Point(264, 35).
    this-object:fName:Name = "fName".
    this-object:fName:Size = new System.Drawing.Size(100, 20).
    this-object:fName:TabIndex = 3.
    /*  */
    /* bindingSource1 */
    /*  */
    this-object:bindingSource1:MaxDataGuess = 0.
    this-object:bindingSource1:NoLOBs = false.
    this-object:bindingSource1:Position = 0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar0 as "Progress.Data.TableDesc[]" no-undo.
    arrayvar0 = new "Progress.Data.TableDesc[]"(0).
    tableDesc1:ChildTables = arrayvar0.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar1 as Progress.Data.ColumnPropDesc extent 11 no-undo.
    arrayvar1[1] = new Progress.Data.ColumnPropDesc("CashBookName", "Наименование", Progress.Data.DataType:CHARACTER).
    arrayvar1[2] = new Progress.Data.ColumnPropDesc("Credit", "кредит", Progress.Data.DataType:CHARACTER).
    arrayvar1[3] = new Progress.Data.ColumnPropDesc("Debit", "дебит", Progress.Data.DataType:CHARACTER).
    arrayvar1[4] = new Progress.Data.ColumnPropDesc("ext-code", "ext-code", Progress.Data.DataType:CHARACTER).
    arrayvar1[5] = new Progress.Data.ColumnPropDesc("FlagSepCash", "Отд. для кажд. кассы", Progress.Data.DataType:LOGICAL).
    arrayvar1[6] = new Progress.Data.ColumnPropDesc("FlagSepFull", "Раздельно НП и ТНП", Progress.Data.DataType:LOGICAL).
    arrayvar1[7] = new Progress.Data.ColumnPropDesc("id", "id", Progress.Data.DataType:INT64).
    arrayvar1[8] = new Progress.Data.ColumnPropDesc("RuleOsn", "Прав. запол.", Progress.Data.DataType:CHARACTER).
    arrayvar1[9] = new Progress.Data.ColumnPropDesc("RulePril", "Прав. запол.", Progress.Data.DataType:CHARACTER).
    arrayvar1[10] = new Progress.Data.ColumnPropDesc("Status_", "Статус", Progress.Data.DataType:INTEGER).
    arrayvar1[11] = new Progress.Data.ColumnPropDesc("takenfrom", "Принято от", Progress.Data.DataType:CHARACTER).
    tableDesc1:Columns = arrayvar1.
    this-object:bindingSource1:TableSchema = tableDesc1.
    /*  */
    /* label5 */
    /*  */
    this-object:label5:Location = new System.Drawing.Point(12, 130).
    this-object:label5:Name = "label5".
    this-object:label5:Size = new System.Drawing.Size(233, 23).
    this-object:label5:TabIndex = 10.
    this-object:label5:Text = "Правило заполнения графы ~"Основание~":".
    this-object:label5:UseCompatibleTextRendering = true.
    /*  */
    /* label6 */
    /*  */
    this-object:label6:Location = new System.Drawing.Point(12, 153).
    this-object:label6:Name = "label6".
    this-object:label6:Size = new System.Drawing.Size(242, 23).
    this-object:label6:TabIndex = 12.
    this-object:label6:Text = "Правило заполнения графы ~"Приложение~":".
    this-object:label6:UseCompatibleTextRendering = true.
    /*  */
    /* FlagSepFuel */
    /*  */
    this-object:FlagSepFuel:DataBindings:Add(new System.Windows.Forms.Binding("Checked", this-object:bindingSource1, "FlagSepFull", true)).
    this-object:FlagSepFuel:Location = new System.Drawing.Point(12, 252).
    this-object:FlagSepFuel:Name = "FlagSepFuel".
    this-object:FlagSepFuel:Size = new System.Drawing.Size(147, 24).
    this-object:FlagSepFuel:TabIndex = 10.
    this-object:FlagSepFuel:Text = "Раздельно НП и ТНП".
    this-object:FlagSepFuel:UseCompatibleTextRendering = true.
    this-object:FlagSepFuel:UseVisualStyleBackColor = true.
    /*  */
    /* FlagSepCash */
    /*  */
    this-object:FlagSepCash:DataBindings:Add(new System.Windows.Forms.Binding("Checked", this-object:bindingSource1, "FlagSepCash", true)).
    this-object:FlagSepCash:Location = new System.Drawing.Point(12, 222).
    this-object:FlagSepCash:Name = "FlagSepCash".
    this-object:FlagSepCash:Size = new System.Drawing.Size(226, 24).
    this-object:FlagSepCash:TabIndex = 9.
    this-object:FlagSepCash:Text = "Отдельный ПКО для каждой кассы".
    this-object:FlagSepCash:UseCompatibleTextRendering = true.
    this-object:FlagSepCash:UseVisualStyleBackColor = true.
    /*  */
    /* label3 */
    /*  */
    this-object:label3:Location = new System.Drawing.Point(12, 61).
    this-object:label3:Name = "label3".
    this-object:label3:Size = new System.Drawing.Size(199, 23).
    this-object:label3:TabIndex = 19.
    this-object:label3:Text = "Код/номер типа кассовой книги:".
    this-object:label3:UseCompatibleTextRendering = true.
    /*  */
    /* fExtCode */
    /*  */
    this-object:fExtCode:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindingSource1, "id", true)).
    this-object:fExtCode:Location = new System.Drawing.Point(264, 58).
    this-object:fExtCode:Name = "fExtCode".
    this-object:fExtCode:ReadOnly = true.
    this-object:fExtCode:Size = new System.Drawing.Size(100, 20).
    this-object:fExtCode:TabIndex = 4.
    /*  */
    /* label4 */
    /*  */
    this-object:label4:Location = new System.Drawing.Point(12, 84).
    this-object:label4:Name = "label4".
    this-object:label4:Size = new System.Drawing.Size(199, 23).
    this-object:label4:TabIndex = 21.
    this-object:label4:Text = "Кредит:".
    this-object:label4:UseCompatibleTextRendering = true.
    /*  */
    /* label7 */
    /*  */
    this-object:label7:Location = new System.Drawing.Point(12, 107).
    this-object:label7:Name = "label7".
    this-object:label7:Size = new System.Drawing.Size(199, 23).
    this-object:label7:TabIndex = 22.
    this-object:label7:Text = "Дебет:".
    this-object:label7:UseCompatibleTextRendering = true.
    /*  */
    /* fCredit */
    /*  */
    this-object:fCredit:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindingSource1, "Credit", true)).
    this-object:fCredit:Location = new System.Drawing.Point(264, 81).
    this-object:fCredit:Name = "fCredit".
    this-object:fCredit:Size = new System.Drawing.Size(100, 20).
    this-object:fCredit:TabIndex = 5.
    /*  */
    /* fDebet */
    /*  */
    this-object:fDebet:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindingSource1, "Debit", true)).
    this-object:fDebet:Location = new System.Drawing.Point(264, 104).
    this-object:fDebet:Name = "fDebet".
    this-object:fDebet:Size = new System.Drawing.Size(100, 20).
    this-object:fDebet:TabIndex = 6.
    /*  */
    /* fRulePril */
    /*  */
    this-object:fRulePril:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindingSource1, "RulePril", true)).
    this-object:fRulePril:DropDownStyle = System.Windows.Forms.ComboBoxStyle:DropDownList.
    this-object:fRulePril:FormattingEnabled = true.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar2 as System.Object extent 2 no-undo.
    arrayvar2[1] = "Номера Z-отчетов".
    arrayvar2[2] = "Не заполнять".
    this-object:fRulePril:Items:AddRange(arrayvar2).
    this-object:fRulePril:Location = new System.Drawing.Point(264, 150).
    this-object:fRulePril:Name = "fRulePril".
    this-object:fRulePril:Size = new System.Drawing.Size(146, 21).
    this-object:fRulePril:TabIndex = 24.
    /*  */
    /* bChooseCredit */
    /*  */
    this-object:bChooseCredit:Location = new System.Drawing.Point(370, 79).
    this-object:bChooseCredit:Name = "bChooseCredit".
    this-object:bChooseCredit:Size = new System.Drawing.Size(24, 23).
    this-object:bChooseCredit:TabIndex = 25.
    this-object:bChooseCredit:UseCompatibleTextRendering = true.
    this-object:bChooseCredit:UseVisualStyleBackColor = true.
    this-object:bChooseCredit:Click:Subscribe(this-object:bChooseCredit_Click).
    /*  */
    /* bChooseDebit */
    /*  */
    this-object:bChooseDebit:Location = new System.Drawing.Point(370, 102).
    this-object:bChooseDebit:Name = "bChooseDebit".
    this-object:bChooseDebit:Size = new System.Drawing.Size(24, 23).
    this-object:bChooseDebit:TabIndex = 26.
    this-object:bChooseDebit:UseCompatibleTextRendering = true.
    this-object:bChooseDebit:UseVisualStyleBackColor = true.
    this-object:bChooseDebit:Click:Subscribe(this-object:bChooseDebit_Click).
    /*  */
    /* label2 */
    /*  */
    this-object:label2:Location = new System.Drawing.Point(12, 176).
    this-object:label2:Name = "label2".
    this-object:label2:Size = new System.Drawing.Size(103, 23).
    this-object:label2:TabIndex = 27.
    this-object:label2:Text = "Контрагент (авто):".
    this-object:label2:UseCompatibleTextRendering = true.
    /*  */
    /* label8 */
    /*  */
    this-object:label8:Location = new System.Drawing.Point(12, 199).
    this-object:label8:Name = "label8".
    this-object:label8:Size = new System.Drawing.Size(103, 23).
    this-object:label8:TabIndex = 28.
    this-object:label8:Text = "Принято от (авто):".
    this-object:label8:UseCompatibleTextRendering = true.
    /*  */
    /* fTakenFrom */
    /*  */
    this-object:fTakenFrom:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindingSource1, "takenfrom", true)).
    this-object:fTakenFrom:Location = new System.Drawing.Point(114, 196).
    this-object:fTakenFrom:Name = "fTakenFrom".
    this-object:fTakenFrom:Size = new System.Drawing.Size(250, 20).
    this-object:fTakenFrom:TabIndex = 29.
    /*  */
    /* bChooseCli */
    /*  */
    this-object:bChooseCli:Location = new System.Drawing.Point(370, 171).
    this-object:bChooseCli:Name = "bChooseCli".
    this-object:bChooseCli:Size = new System.Drawing.Size(24, 23).
    this-object:bChooseCli:TabIndex = 30.
    this-object:bChooseCli:UseCompatibleTextRendering = true.
    this-object:bChooseCli:UseVisualStyleBackColor = true.
    this-object:bChooseCli:Click:Subscribe(this-object:bChooseCli_Click).
    /*  */
    /* lCli */
    /*  */
    this-object:lCli:Location = new System.Drawing.Point(114, 176).
    this-object:lCli:Name = "lCli".
    this-object:lCli:Size = new System.Drawing.Size(250, 23).
    this-object:lCli:TabIndex = 31.
    this-object:lCli:UseCompatibleTextRendering = true.
    /*  */
    /* fRuleOsn */
    /*  */
    this-object:fRuleOsn:DataBindings:Add(new System.Windows.Forms.Binding("Text", this-object:bindingSource1, "RuleOsn", true)).
    this-object:fRuleOsn:Location = new System.Drawing.Point(264, 127).
    this-object:fRuleOsn:Name = "fRuleOsn".
    this-object:fRuleOsn:Size = new System.Drawing.Size(146, 20).
    this-object:fRuleOsn:TabIndex = 32.
    /*  */
    /* cashbookfrm */
    /*  */
    this-object:AcceptButton = this-object:buttonOk.
    this-object:CancelButton = this-object:buttonCancel.
    this-object:ClientSize = new System.Drawing.Size(428, 277).
    this-object:Controls:Add(this-object:fRuleOsn).
    this-object:Controls:Add(this-object:lCli).
    this-object:Controls:Add(this-object:bChooseCli).
    this-object:Controls:Add(this-object:fTakenFrom).
    this-object:Controls:Add(this-object:label8).
    this-object:Controls:Add(this-object:label2).
    this-object:Controls:Add(this-object:bChooseDebit).
    this-object:Controls:Add(this-object:bChooseCredit).
    this-object:Controls:Add(this-object:fRulePril).
    this-object:Controls:Add(this-object:fDebet).
    this-object:Controls:Add(this-object:fCredit).
    this-object:Controls:Add(this-object:label7).
    this-object:Controls:Add(this-object:label4).
    this-object:Controls:Add(this-object:fExtCode).
    this-object:Controls:Add(this-object:label3).
    this-object:Controls:Add(this-object:FlagSepCash).
    this-object:Controls:Add(this-object:FlagSepFuel).
    this-object:Controls:Add(this-object:label6).
    this-object:Controls:Add(this-object:label5).
    this-object:Controls:Add(this-object:fName).
    this-object:Controls:Add(this-object:label1).
    this-object:Controls:Add(this-object:buttonCancel).
    this-object:Controls:Add(this-object:buttonOk).
    this-object:FormBorderStyle = System.Windows.Forms.FormBorderStyle:FixedDialog.
    this-object:MaximizeBox = false.
    this-object:MinimizeBox = false.
    this-object:Name = "cashbookfrm".
    this-object:ShowInTaskbar = false.
    this-object:StartPosition = System.Windows.Forms.FormStartPosition:CenterParent.
    this-object:Text = "Кассовая книга".
    cast(this-object:bindingSource1, System.ComponentModel.ISupportInitialize):EndInit().
    this-object:ResumeLayout(false).
    this-object:PerformLayout().
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
   end method. 
 
  method public void ShowModalDialog(  ):
      
      wait-for this-object:ShowDialog().

  end method.

  method public void Visual_form( input iChange AS character ): 
    
    find first ub.clients no-lock where ub.clients.obj-type = tt-cashbook.cli-type
                                    and ub.clients.obj-code = tt-cashbook.cli-code
                                    no-error .
    if available ub.clients
    then do :
      this-object:lCli:Text = ub.clients.obj-type + string(ub.clients.obj-code) + "   " + ub.clients.obj-name .
    end.                                
      
    if iChange = {&lookup} then 
    do:  
      assign
        this-object:fExtCode:ReadOnly = true
        this-object:fName:ReadOnly = true
        this-object:fCredit:ReadOnly = true
        this-object:fDebet:ReadOnly = true
        this-object:fTakenFrom:ReadOnly = true
        this-object:fRuleOsn:Enabled = false
        this-object:fRulePril:Enabled = false
        this-object:FlagSepCash:Enabled = false
        this-object:FlagSepFuel:Enabled = false
        this-object:buttonOk:Enabled = false
        this-object:bChooseCredit:Enabled = false
        this-object:bChooseDebit:Enabled = false
        this-object:bChooseCli:Enabled = false
      .
    end.
    return.
  end method .
 
end class.
