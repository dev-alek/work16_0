 
 /*------------------------------------------------------------------------
    File        : draw_utility
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Mon Oct 22 02:27:27 MSK 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.Form.

block-level on error undo, throw.

class ibs.th.utl.draw_utility inherits Form: 
  
  DEFINE PRIVATE VARIABLE button10 AS System.Windows.Forms.Button NO-UNDO.
  define private variable button2 as System.Windows.Forms.Button no-undo.
  define private variable button3 as System.Windows.Forms.Button no-undo.
  define private variable button4 as System.Windows.Forms.Button no-undo.
  define private variable button5 as System.Windows.Forms.Button no-undo.
    define private variable button6 as System.Windows.Forms.Button no-undo.
   define private variable button7 as System.Windows.Forms.Button no-undo.
   define private variable button9 as System.Windows.Forms.Button no-undo.
   define private variable button8 as System.Windows.Forms.Button no-undo.
  define private variable checkBox18 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox17 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox16 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox15 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox14 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox13 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox12 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox11 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox10 as System.Windows.Forms.CheckBox no-undo.
    define private variable checkBox19 as System.Windows.Forms.CheckBox no-undo.
    define private variable checkBox21 as System.Windows.Forms.CheckBox no-undo.
    define private variable checkBox20 as System.Windows.Forms.CheckBox no-undo.
    define private variable checkBox22 as System.Windows.Forms.CheckBox no-undo.
    define private variable checkBox24 as System.Windows.Forms.CheckBox no-undo.
    define private variable checkBox23 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox25 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox26 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox6 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox5 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox4 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox3 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox2 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox1 as System.Windows.Forms.CheckBox no-undo.
  define private variable button1 as System.Windows.Forms.Button no-undo.
  define private variable checkBox8 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox7 as System.Windows.Forms.CheckBox no-undo.
  define private variable checkBox9 as System.Windows.Forms.CheckBox no-undo.
  define private variable components as System.ComponentModel.IContainer no-undo.
  define private variable label2 as System.Windows.Forms.Label no-undo.
  define private variable label3 as System.Windows.Forms.Label no-undo.
   define private variable label4 as System.Windows.Forms.Label no-undo.
    define private variable listBox1 as System.Windows.Forms.ListBox no-undo.
  define private variable openFileDialog1 as System.Windows.Forms.OpenFileDialog no-undo.
   define private variable tabPage4 as System.Windows.Forms.TabPage no-undo.
   define private variable tabPage5 as System.Windows.Forms.TabPage no-undo.
  define private variable textBox1 as System.Windows.Forms.TextBox no-undo.
  define private variable tabPage3 as System.Windows.Forms.TabPage no-undo.
  define private variable tabPage2 as System.Windows.Forms.TabPage no-undo.
  define private variable tabPage1 as System.Windows.Forms.TabPage no-undo.
  define private variable tabControl1 as System.Windows.Forms.TabControl no-undo.
  define private variable label1 as System.Windows.Forms.Label no-undo.
  define private variable mUtil  as class ibs.th.utl.method-for-draw-utility no-undo.
  define private variable textBox2 as System.Windows.Forms.TextBox no-undo.
  define private variable textBox3 as System.Windows.Forms.TextBox no-undo.
   define private variable textBox4 as System.Windows.Forms.TextBox no-undo.
  define property parparentproc as handle no-undo
  get.
  set(input iH as handle):
     parparentproc = iH.
     mUtil:parparentproc = parparentproc.
     InitChekBox().
  end.
     
  constructor public draw_utility (  ):
    
    
    super().
    InitializeComponent().
    this-object:ComponentsCollection:ADD(this-object:components).
    mUtil  = new ibs.th.utl.method-for-draw-utility().
    mutil:write-log:SUBSCRIBE (this-object:write-log).
      textBox1:text = getPARAM("host").
      if textBox1:text eq ""
      then 
         textBox1:text = "localhost:8080".
      textBox2:text = getPARAM("correspondence_gds").
      textBox3:text = getPARAM("correspondence_supp").
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.

  end constructor.
  
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button10_Click( input sender as System.Object, input e as System.EventArgs ):
    mutil:verify_rest(textbox1:Text, textbox2:text).
    return.
  end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button1_Click( input sender as System.Object, input e as System.EventArgs ):
	    
		BtnStart().
		return.

	end method.


	

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button7_Click( input sender as System.Object, input e as System.EventArgs ):
		close_shift().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button8_Click( input sender as System.Object, input e as System.EventArgs ):
		mutil:sendcleanCash(textBox4:text).
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button9_Click( input sender as System.Object, input e as System.EventArgs ):
		textBox4:text = mutil:cangecash(textBox4:text).
		return.

	end method.

    method public void write-log (iText as char ):
       listBox1:Items:Add(iText).
        listBox1:SelectedIndex =listBox1:Items:Count - 1.  
    end method . 
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button2_Click( input sender as System.Object, input e as System.EventArgs ):
	  assign
  	  checkBox7:checked  = no
  	  checkBox8:checked  = no
  	  checkBox9:checked  = no
  	  checkBox10:checked = no
  	  checkBox11:checked = no
  	  checkBox12:checked = no
  	  checkBox13:checked = no
  	  checkBox14:checked = no
  	  checkBox15:checked = no
  	  checkBox16:checked = no
  	  checkBox17:checked = no
  	  checkBox18:checked = no
      checkBox23:checked = no
      checkBox24:checked = no
	  .
	   define variable vtestlg as logical no-undo init no.
      mUtil:put-log("Начато   : удаление кассиров с касс").
      checkBox7:checked =mutil:sendcode(1).
      mUtil:put-log("Выполнено: удаление кассиров с касс").
      
      if vtestlg then message "выполнено "   checkBox7:text         view-as alert-box.
      
      mUtil:put-log("Начато   : передача кассиров на кассы").
      checkBox8:checked = mutil:sendcode(2).
      mUtil:put-log("Выполнено: передача кассиров на кассы").
      if vtestlg then message "выполнено "   checkBox8:text view-as alert-box.
      
      mUtil:put-log("Начато   : удаление налогов с касс").
        checkBox10:checked = mutil:sendcode(3).
      mUtil:put-log("Выполнено: удаление налогов с касс").
      if vtestlg then message "выполнено "   checkBox10:text view-as alert-box.
      
      mUtil:put-log("Начато   : передача налогов на кассы").
      checkBox9:checked = mutil:sendcode(4).
        mUtil:put-log("Выполнено: передача налогов на кассы").
      if vtestlg then message "выполнено "   checkBox9:text view-as alert-box.
      
      mUtil:put-log("Начато   : удаление типов платежей с касс").
      checkBox11:checked = mutil:sendcode(5).
      mUtil:put-log("Выполнено: удаление типов платежей с касс").
      if vtestlg then message "выполнено "   checkBox11:text view-as alert-box.
     
        mUtil:put-log("Начато   : передача типов платежей на кассы").
      checkBox12:checked = mutil:sendcode(6).
        mUtil:put-log("Выполнено: передача типов платежей на кассы").
      if vtestlg then message "выполнено "   checkBox12:Text view-as alert-box.
     
        mUtil:put-log("Начато   : удаление клиентов с касс").
      checkBox13:checked = mutil:sendcode(7). 
        mUtil:put-log("Выполнено: удаление клиентов с касс").
      if vtestlg then message "выполнено "   checkBox13:text view-as alert-box.
    
        mUtil:put-log("Начато   : передача клиентов на кассы").
      checkBox14:checked = mutil:sendcode(8).
        mUtil:put-log("Выполнено: передача клиентов на кассы").
      if vtestlg then message "выполнено "   checkBox14:text view-as alert-box.
    
        mUtil:put-log("Начато   : удаление масок карт с касс").
      checkBox15:checked = mutil:sendcode(9).
        mUtil:put-log("Выполнено: удаление масок карт с касс").
      if vtestlg then message "выполнено "   checkBox15:text view-as alert-box.
      
        mUtil:put-log("Начато   : передача масок карт на кассы").
      checkBox16:checked = mutil:sendcode(10).
        mUtil:put-log("Выполнено: передача масок карт на кассы").
      if vtestlg then message "выполнено "   checkBox16:text view-as alert-box.
    
      /*  mUtil:put-log("Начато   : удаление справочника ОСС с касс").
       checkBox17:checked = mutil:sendcode(11).
        mUtil:put-log("Выполнено: удаление справочника ОСС с касс").
      if vtestlg then message "выполнено "   checkBox17:text view-as alert-box.
    */
        mUtil:put-log("Начато   : удаление и передача справочника ОСС на кассы").
      checkBox17:checked = mutil:sendcode(12).
        checkBox18:checked = checkBox17:checked.
        mUtil:put-log("Выполнено: удаление и  передача справочника ОСС на кассы").
      if vtestlg then message "выполнено "   checkBox18:text view-as alert-box.
      
        mUtil:put-log("Начато   : удаление товаров с касс").
      checkBox23:checked = mutil:sendcode(13).
        mUtil:put-log("Выполнено: удаление товаров с касс").
      if vtestlg then message "выполнено "   checkBox23:text view-as alert-box.
      
        mUtil:put-log("Начато   : передача товаров на кассы").
      checkBox24:checked = mutil:sendcode(14).
        mUtil:put-log("Выполнено: передача товаров на кассы").
      if vtestlg then message "выполнено "   checkBox24:text view-as alert-box.
        
      return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button3_Click( input sender as System.Object, input e as System.EventArgs ):
	   this-object:openFileDialog1:FileName=this-object:textBox2:Text.
		wait-for this-object:openFileDialog1:ShowDialog().
		
		this-object:textBox2:Text = this-object:openFileDialog1:FileName.
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button4_Click( input sender as System.Object, input e as System.EventArgs ):
	   this-object:openFileDialog1:FileName = this-object:textBox3:Text.
		wait-for this-object:openFileDialog1:ShowDialog().
    this-object:textBox3:Text = this-object:openFileDialog1:FileName.
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button5_Click( input sender as System.Object, input e as System.EventArgs ):
		load_rest().
		return.

	end method.
  method private void load_rest(  ):
    if not mutil:chek_rvs()
    then do:
       message "Выполните этап 1"
       view-as alert-box.
       return.
    end.      
    mutil:mAddr = textbox1:Text.
    checkBox19:checked = mutil:chek_rest().
    checkBox20:checked = checkBox19:checked.
    if not checkBox19:checked
    then
       checkBox19:checked = mutil:load_rest(textbox3:text,textbox2:text,"").
    if not checkBox19:checked
      then return.
    if not checkBox20:checked
    then
       checkBox20:checked = mutil:load_rest_ptrl(textbox3:text,textbox2:text,"").
    if not checkBox20:checked
      then return.
   end method.
   
   method private void close_shift(  ):
    if not checkBox20:checked
    then do:
       message "Выполните этап 3"
       view-as alert-box.
       return.
    end.    
    checkBox21:checked =  mutil:chek_rvs-shift().
    if not checkBox21:checked
    then
       checkBox21:checked = mutil:load_rvs(textbox2:text).
    if    checkBox21:checked
    then
       checkBox22:checked =  mutil:chek_rvs-close().
    if        checkBox21:checked 
      and not checkBox22:checked
    then
        checkBox22:checked = mutil:close-rvs-all ().
    return.

  end method.
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void checkBox7_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
		
		return.

	end method.

  method private void InitChekBox():
     checkBox1:checked = mutil:Chek_Shem().
     checkBox2:checked = mutil:chek_cash_desk().
     checkBox3:checked = mutil:chek-sht-open().
     checkBox4:checked = mutil:chek_rvs().
     checkBox5:checked = mutil:chek_price().
     checkBox6:checked = mutil:chek_pumpdoc().
     
     define variable v-log-param as logical no-undo .
     /* Перед переносом паролей кассиров таблица с кассирами уже заполнена:
        пароль кассира обязательное поле БД,
        поэтому при приеме нулевого пакета от 1С пароль кассира тоже заполнен и равен номеру кассира. 
     */
     v-log-param = logical( getPARAM("darw_util_pswd") ) no-error .      
     checkBox25:checked = if v-log-param then true else false.
     /* и таблица с пользователями тоже заполнена, но, возможно, не полностью */
     v-log-param = logical( getPARAM("darw_util_user") ) no-error .      
     checkBox26:checked = if v-log-param then true else false.
     
     checkBox19:checked = mutil:chek_rest().
     checkBox20:checked = checkBox19:checked.
  end method .  
  
  method private void BtnStart():
    mutil:mAddr = textbox1:Text.
    
    checkBox1:checked = mutil:Chek_Shem().
    if not checkBox1:checked
    then do:
       mutil:load_schem(textBox2:text).
       checkBox1:checked = mutil:Chek_Shem(). 
    end. 
      
     checkBox2:checked = mutil:chek_cash_desk().
     if         checkBox1:checked
        and not checkBox2:checked
     then do:
        mutil:load_cashdesk().
        checkBox2:checked = mutil:chek_cash_desk().
     end.
     checkBox3:checked = mutil:chek-sht-open().
     if         checkBox2:checked
        and not checkBox3:checked
     then do:
        mutil:sht-open().
        checkBox3:checked = mutil:chek-sht-open().
        
        
     end.
      checkBox5:checked = mutil:chek_price().
     if         checkBox3:checked
        and not checkBox5:checked
     then do:
        mutil:load_price(textBox2:text).
       checkBox5:checked = mutil:chek_price(). 
    end.
     checkBox4:checked = mutil:chek_rvs().
      if        checkBox5:checked
        and not checkBox4:checked       
     then do:
           mutil:rvs-auto().
           checkBox4:checked = mutil:chek_rvs().
     end.
     //checkBox4:checked = mutil:chek-sht-open().
    
     checkBox6:checked = mutil:chek_pumpdoc().
     if         checkBox4:checked
        and not checkBox6:checked
    then do:
       mutil:load_pumpdoc(textBox2:text).
       checkBox6:checked = mutil:chek_pumpdoc(). 
    end.
   
    if        checkBox4:checked
      and not checkBox25:checked then do :
       mutil:load_cash_passwd () .
       checkBox25:checked = mutil:chek_cash_passwd().
    end .
    
    if        checkBox4:checked
      and not checkBox26:checked then do :
       mutil:load_user () .
       checkBox26:checked = mutil:chek_user().
    end .    
  end.  
  method private void InitializeComponent(  ):
    
    /* NOTE: The following method is automatically generated.
    
    We strongly suggest that the contents of this method only be modified using the
    Visual Designer to avoid any incompatible modifications.
    
    Modifying the contents of this method using a code editor will invalidate any support for this file. */
    @VisualDesigner.FormMember (NeedsInitialize="true").
    DEFINE VARIABLE resources AS Progress.Util.ResourceManager NO-UNDO.
    resources = NEW Progress.Util.ResourceManager("ibs.th.utl.draw_utility").
    THIS-OBJECT:label1 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:textBox1 = NEW System.Windows.Forms.TextBox().
    THIS-OBJECT:tabControl1 = NEW System.Windows.Forms.TabControl().
    THIS-OBJECT:tabPage1 = NEW System.Windows.Forms.TabPage().
    THIS-OBJECT:checkBox25 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox26 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox6 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox5 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox4 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox3 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox2 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox1 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:button1 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:tabPage2 = NEW System.Windows.Forms.TabPage().
    THIS-OBJECT:checkBox24 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox23 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox17 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox18 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox15 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox16 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox13 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox14 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox11 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox12 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox10 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox9 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox8 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox7 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:button2 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:tabPage3 = NEW System.Windows.Forms.TabPage().
    THIS-OBJECT:checkBox20 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox19 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:button5 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:tabPage4 = NEW System.Windows.Forms.TabPage().
    THIS-OBJECT:button7 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:checkBox22 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:checkBox21 = NEW System.Windows.Forms.CheckBox().
    THIS-OBJECT:tabPage5 = NEW System.Windows.Forms.TabPage().
    THIS-OBJECT:label4 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:button9 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:textBox4 = NEW System.Windows.Forms.TextBox().
    THIS-OBJECT:button8 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:openFileDialog1 = NEW System.Windows.Forms.OpenFileDialog().
    THIS-OBJECT:textBox2 = NEW System.Windows.Forms.TextBox().
    THIS-OBJECT:button3 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:label2 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:label3 = NEW System.Windows.Forms.Label().
    THIS-OBJECT:button4 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:textBox3 = NEW System.Windows.Forms.TextBox().
    THIS-OBJECT:listBox1 = NEW System.Windows.Forms.ListBox().
    THIS-OBJECT:button6 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:button10 = NEW System.Windows.Forms.Button().
    THIS-OBJECT:tabControl1:SuspendLayout().
    THIS-OBJECT:tabPage1:SuspendLayout().
    THIS-OBJECT:tabPage2:SuspendLayout().
    THIS-OBJECT:tabPage3:SuspendLayout().
    THIS-OBJECT:tabPage4:SuspendLayout().
    THIS-OBJECT:tabPage5:SuspendLayout().
    THIS-OBJECT:SuspendLayout().
    /*  */
    /* label1 */
    /*  */
    THIS-OBJECT:label1:Location = NEW System.Drawing.Point(97, 18).
    THIS-OBJECT:label1:Name = "label1".
    THIS-OBJECT:label1:Size = NEW System.Drawing.Size(196, 23).
    THIS-OBJECT:label1:TabIndex = 0.
    THIS-OBJECT:label1:Text = "Адрес сокет-сервера".
    THIS-OBJECT:label1:UseCompatibleTextRendering = true.
    /*  */
    /* textBox1 */
    /*  */
    THIS-OBJECT:textBox1:Location = NEW System.Drawing.Point(328, 15).
    THIS-OBJECT:textBox1:Name = "textBox1".
    THIS-OBJECT:textBox1:Size = NEW System.Drawing.Size(209, 20).
    THIS-OBJECT:textBox1:TabIndex = 1.
    THIS-OBJECT:textBox1:Text = "localhost:8080".
    /*  */
    /* tabControl1 */
    /*  */
    THIS-OBJECT:tabControl1:Controls:Add(THIS-OBJECT:tabPage1).
    THIS-OBJECT:tabControl1:Controls:Add(THIS-OBJECT:tabPage2).
    THIS-OBJECT:tabControl1:Controls:Add(THIS-OBJECT:tabPage3).
    THIS-OBJECT:tabControl1:Controls:Add(THIS-OBJECT:tabPage4).
    THIS-OBJECT:tabControl1:Controls:Add(THIS-OBJECT:tabPage5).
    THIS-OBJECT:tabControl1:Location = NEW System.Drawing.Point(12, 111).
    THIS-OBJECT:tabControl1:Name = "tabControl1".
    THIS-OBJECT:tabControl1:SelectedIndex = 0.
    THIS-OBJECT:tabControl1:Size = NEW System.Drawing.Size(404, 455).
    THIS-OBJECT:tabControl1:TabIndex = 2.
    /*  */
    /* tabPage1 */
    /*  */
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox25).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox26).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox6).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox5).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox4).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox3).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox2).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:checkBox1).
    THIS-OBJECT:tabPage1:Controls:Add(THIS-OBJECT:button1).
    THIS-OBJECT:tabPage1:Location = NEW System.Drawing.Point(4, 22).
    THIS-OBJECT:tabPage1:Name = "tabPage1".
    THIS-OBJECT:tabPage1:Padding = NEW System.Windows.Forms.Padding(3).
    THIS-OBJECT:tabPage1:Size = NEW System.Drawing.Size(396, 429).
    THIS-OBJECT:tabPage1:TabIndex = 0.
    THIS-OBJECT:tabPage1:Text = "Этап 1".
    THIS-OBJECT:tabPage1:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox25 */
    /*  */
    THIS-OBJECT:checkBox25:Enabled = false.
    THIS-OBJECT:checkBox25:Location = NEW System.Drawing.Point(118, 211).
    THIS-OBJECT:checkBox25:Name = "checkBox25".
    THIS-OBJECT:checkBox25:Size = NEW System.Drawing.Size(249, 24).
    THIS-OBJECT:checkBox25:TabIndex = 8.
    THIS-OBJECT:checkBox25:Text = "Перенос паролей кассиров".
    THIS-OBJECT:checkBox25:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox25:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox26 */
    /*  */
    THIS-OBJECT:checkBox26:Enabled = false.
    THIS-OBJECT:checkBox26:Location = NEW System.Drawing.Point(118, 241).
    THIS-OBJECT:checkBox26:Name = "checkBox26".
    THIS-OBJECT:checkBox26:Size = NEW System.Drawing.Size(249, 24).
    THIS-OBJECT:checkBox26:TabIndex = 8.
    THIS-OBJECT:checkBox26:Text = "Перенос пользователей".
    THIS-OBJECT:checkBox26:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox26:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox6 */
    /*  */
    THIS-OBJECT:checkBox6:Enabled = false.
    THIS-OBJECT:checkBox6:Location = NEW System.Drawing.Point(118, 181).
    THIS-OBJECT:checkBox6:Name = "checkBox6".
    THIS-OBJECT:checkBox6:Size = NEW System.Drawing.Size(249, 24).
    THIS-OBJECT:checkBox6:TabIndex = 6.
    THIS-OBJECT:checkBox6:Text = "Перенос инвентаризация счетчиков ТРК ".
    THIS-OBJECT:checkBox6:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox6:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox5 */
    /*  */
    THIS-OBJECT:checkBox5:Enabled = false.
    THIS-OBJECT:checkBox5:Location = NEW System.Drawing.Point(118, 121).
    THIS-OBJECT:checkBox5:Name = "checkBox5".
    THIS-OBJECT:checkBox5:Size = NEW System.Drawing.Size(104, 24).
    THIS-OBJECT:checkBox5:TabIndex = 5.
    THIS-OBJECT:checkBox5:Text = "Перенос цен".
    THIS-OBJECT:checkBox5:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox5:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox4 */
    /*  */
    THIS-OBJECT:checkBox4:Enabled = false.
    THIS-OBJECT:checkBox4:Location = NEW System.Drawing.Point(118, 151).
    THIS-OBJECT:checkBox4:Name = "checkBox4".
    THIS-OBJECT:checkBox4:Size = NEW System.Drawing.Size(233, 24).
    THIS-OBJECT:checkBox4:TabIndex = 4.
    THIS-OBJECT:checkBox4:Text = "Создание нулевой контрольной сверки ".
    THIS-OBJECT:checkBox4:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox4:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox3 */
    /*  */
    THIS-OBJECT:checkBox3:Enabled = false.
    THIS-OBJECT:checkBox3:Location = NEW System.Drawing.Point(118, 91).
    THIS-OBJECT:checkBox3:Name = "checkBox3".
    THIS-OBJECT:checkBox3:Size = NEW System.Drawing.Size(219, 24).
    THIS-OBJECT:checkBox3:TabIndex = 3.
    THIS-OBJECT:checkBox3:Text = "Открытие технологической смены ".
    THIS-OBJECT:checkBox3:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox3:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox2 */
    /*  */
    THIS-OBJECT:checkBox2:Enabled = false.
    THIS-OBJECT:checkBox2:Location = NEW System.Drawing.Point(118, 61).
    THIS-OBJECT:checkBox2:Name = "checkBox2".
    THIS-OBJECT:checkBox2:Size = NEW System.Drawing.Size(190, 24).
    THIS-OBJECT:checkBox2:TabIndex = 2.
    THIS-OBJECT:checkBox2:Text = "Перенос справочника касс".
    THIS-OBJECT:checkBox2:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox2:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox1 */
    /*  */
    THIS-OBJECT:checkBox1:Enabled = false.
    THIS-OBJECT:checkBox1:Location = NEW System.Drawing.Point(118, 31).
    THIS-OBJECT:checkBox1:Name = "checkBox1".
    THIS-OBJECT:checkBox1:Size = NEW System.Drawing.Size(206, 24).
    THIS-OBJECT:checkBox1:TabIndex = 1.
    THIS-OBJECT:checkBox1:Text = "Перенос топологии".
    THIS-OBJECT:checkBox1:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox1:UseVisualStyleBackColor = true.
    /*  */
    /* button1 */
    /*  */
    THIS-OBJECT:button1:Location = NEW System.Drawing.Point(7, 32).
    THIS-OBJECT:button1:Name = "button1".
    THIS-OBJECT:button1:Size = NEW System.Drawing.Size(75, 23).
    THIS-OBJECT:button1:TabIndex = 0.
    THIS-OBJECT:button1:Text = "Старт".
    THIS-OBJECT:button1:UseCompatibleTextRendering = true.
    THIS-OBJECT:button1:UseVisualStyleBackColor = true.
    THIS-OBJECT:button1:Click:Subscribe(THIS-OBJECT:button1_Click).
    /*  */
    /* tabPage2 */
    /*  */
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox24).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox23).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox17).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox18).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox15).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox16).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox13).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox14).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox11).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox12).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox10).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox9).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox8).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:checkBox7).
    THIS-OBJECT:tabPage2:Controls:Add(THIS-OBJECT:button2).
    THIS-OBJECT:tabPage2:Location = NEW System.Drawing.Point(4, 22).
    THIS-OBJECT:tabPage2:Name = "tabPage2".
    THIS-OBJECT:tabPage2:Padding = NEW System.Windows.Forms.Padding(3).
    THIS-OBJECT:tabPage2:Size = NEW System.Drawing.Size(396, 429).
    THIS-OBJECT:tabPage2:TabIndex = 1.
    THIS-OBJECT:tabPage2:Text = "Этап 2".
    THIS-OBJECT:tabPage2:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox24 */
    /*  */
    THIS-OBJECT:checkBox24:Enabled = false.
    THIS-OBJECT:checkBox24:Location = NEW System.Drawing.Point(149, 396).
    THIS-OBJECT:checkBox24:Name = "checkBox24".
    THIS-OBJECT:checkBox24:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox24:TabIndex = 14.
    THIS-OBJECT:checkBox24:Text = "Товары переданы на кассы".
    THIS-OBJECT:checkBox24:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox24:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox23 */
    /*  */
    THIS-OBJECT:checkBox23:Enabled = false.
    THIS-OBJECT:checkBox23:Location = NEW System.Drawing.Point(149, 366).
    THIS-OBJECT:checkBox23:Name = "checkBox23".
    THIS-OBJECT:checkBox23:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox23:TabIndex = 13.
    THIS-OBJECT:checkBox23:Text = "Товары удалены с касс".
    THIS-OBJECT:checkBox23:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox23:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox17 */
    /*  */
    THIS-OBJECT:checkBox17:Enabled = false.
    THIS-OBJECT:checkBox17:Location = NEW System.Drawing.Point(149, 306).
    THIS-OBJECT:checkBox17:Name = "checkBox17".
    THIS-OBJECT:checkBox17:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox17:TabIndex = 12.
    THIS-OBJECT:checkBox17:Text = "Справочник ОСС удалены с касс".
    THIS-OBJECT:checkBox17:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox17:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox18 */
    /*  */
    THIS-OBJECT:checkBox18:Enabled = false.
    THIS-OBJECT:checkBox18:Location = NEW System.Drawing.Point(149, 336).
    THIS-OBJECT:checkBox18:Name = "checkBox18".
    THIS-OBJECT:checkBox18:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox18:TabIndex = 11.
    THIS-OBJECT:checkBox18:Text = "Справочник ОСС переданы на кассы".
    THIS-OBJECT:checkBox18:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox18:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox15 */
    /*  */
    THIS-OBJECT:checkBox15:Enabled = false.
    THIS-OBJECT:checkBox15:Location = NEW System.Drawing.Point(149, 246).
    THIS-OBJECT:checkBox15:Name = "checkBox15".
    THIS-OBJECT:checkBox15:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox15:TabIndex = 10.
    THIS-OBJECT:checkBox15:Text = "Маски карт удалены с касс".
    THIS-OBJECT:checkBox15:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox15:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox16 */
    /*  */
    THIS-OBJECT:checkBox16:Enabled = false.
    THIS-OBJECT:checkBox16:Location = NEW System.Drawing.Point(149, 276).
    THIS-OBJECT:checkBox16:Name = "checkBox16".
    THIS-OBJECT:checkBox16:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox16:TabIndex = 9.
    THIS-OBJECT:checkBox16:Text = "Маски карт переданы на кассы".
    THIS-OBJECT:checkBox16:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox16:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox13 */
    /*  */
    THIS-OBJECT:checkBox13:Enabled = false.
    THIS-OBJECT:checkBox13:Location = NEW System.Drawing.Point(149, 186).
    THIS-OBJECT:checkBox13:Name = "checkBox13".
    THIS-OBJECT:checkBox13:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox13:TabIndex = 8.
    THIS-OBJECT:checkBox13:Text = "Клиенты удалены с касс".
    THIS-OBJECT:checkBox13:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox13:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox14 */
    /*  */
    THIS-OBJECT:checkBox14:Enabled = false.
    THIS-OBJECT:checkBox14:Location = NEW System.Drawing.Point(149, 216).
    THIS-OBJECT:checkBox14:Name = "checkBox14".
    THIS-OBJECT:checkBox14:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox14:TabIndex = 7.
    THIS-OBJECT:checkBox14:Text = "Клиенты переданы на кассы".
    THIS-OBJECT:checkBox14:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox14:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox11 */
    /*  */
    THIS-OBJECT:checkBox11:Enabled = false.
    THIS-OBJECT:checkBox11:Location = NEW System.Drawing.Point(149, 126).
    THIS-OBJECT:checkBox11:Name = "checkBox11".
    THIS-OBJECT:checkBox11:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox11:TabIndex = 6.
    THIS-OBJECT:checkBox11:Text = "Типы платежей удалены с касс".
    THIS-OBJECT:checkBox11:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox11:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox12 */
    /*  */
    THIS-OBJECT:checkBox12:Enabled = false.
    THIS-OBJECT:checkBox12:Location = NEW System.Drawing.Point(149, 156).
    THIS-OBJECT:checkBox12:Name = "checkBox12".
    THIS-OBJECT:checkBox12:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox12:TabIndex = 5.
    THIS-OBJECT:checkBox12:Text = "Типы платежей переданы на кассы".
    THIS-OBJECT:checkBox12:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox12:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox10 */
    /*  */
    THIS-OBJECT:checkBox10:Enabled = false.
    THIS-OBJECT:checkBox10:Location = NEW System.Drawing.Point(149, 66).
    THIS-OBJECT:checkBox10:Name = "checkBox10".
    THIS-OBJECT:checkBox10:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox10:TabIndex = 4.
    THIS-OBJECT:checkBox10:Text = "Налоги удалены с касс".
    THIS-OBJECT:checkBox10:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox10:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox9 */
    /*  */
    THIS-OBJECT:checkBox9:Enabled = false.
    THIS-OBJECT:checkBox9:Location = NEW System.Drawing.Point(149, 96).
    THIS-OBJECT:checkBox9:Name = "checkBox9".
    THIS-OBJECT:checkBox9:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox9:TabIndex = 3.
    THIS-OBJECT:checkBox9:Text = "Налоги переданы на кассы".
    THIS-OBJECT:checkBox9:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox9:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox8 */
    /*  */
    THIS-OBJECT:checkBox8:Enabled = false.
    THIS-OBJECT:checkBox8:Location = NEW System.Drawing.Point(149, 36).
    THIS-OBJECT:checkBox8:Name = "checkBox8".
    THIS-OBJECT:checkBox8:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox8:TabIndex = 2.
    THIS-OBJECT:checkBox8:Text = "Кассиры переданы на кассы".
    THIS-OBJECT:checkBox8:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox8:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox7 */
    /*  */
    THIS-OBJECT:checkBox7:Enabled = false.
    THIS-OBJECT:checkBox7:Location = NEW System.Drawing.Point(149, 6).
    THIS-OBJECT:checkBox7:Name = "checkBox7".
    THIS-OBJECT:checkBox7:Size = NEW System.Drawing.Size(228, 24).
    THIS-OBJECT:checkBox7:TabIndex = 1.
    THIS-OBJECT:checkBox7:Text = "Кассиры удалены с касс".
    THIS-OBJECT:checkBox7:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox7:UseVisualStyleBackColor = true.
    THIS-OBJECT:checkBox7:CheckedChanged:Subscribe(THIS-OBJECT:checkBox7_CheckedChanged).
    /*  */
    /* button2 */
    /*  */
    THIS-OBJECT:button2:Location = NEW System.Drawing.Point(23, 48).
    THIS-OBJECT:button2:Name = "button2".
    THIS-OBJECT:button2:Size = NEW System.Drawing.Size(91, 53).
    THIS-OBJECT:button2:TabIndex = 0.
    THIS-OBJECT:button2:Text = "Отправить данные на кассы".
    THIS-OBJECT:button2:UseCompatibleTextRendering = true.
    THIS-OBJECT:button2:UseVisualStyleBackColor = true.
    THIS-OBJECT:button2:Click:Subscribe(THIS-OBJECT:button2_Click).
    /*  */
    /* tabPage3 */
    /*  */
    THIS-OBJECT:tabPage3:Controls:Add(THIS-OBJECT:checkBox20).
    THIS-OBJECT:tabPage3:Controls:Add(THIS-OBJECT:checkBox19).
    THIS-OBJECT:tabPage3:Controls:Add(THIS-OBJECT:button5).
    THIS-OBJECT:tabPage3:Location = NEW System.Drawing.Point(4, 22).
    THIS-OBJECT:tabPage3:Name = "tabPage3".
    THIS-OBJECT:tabPage3:Size = NEW System.Drawing.Size(396, 429).
    THIS-OBJECT:tabPage3:TabIndex = 2.
    THIS-OBJECT:tabPage3:Text = "Этап 3".
    THIS-OBJECT:tabPage3:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox20 */
    /*  */
    THIS-OBJECT:checkBox20:Enabled = false.
    THIS-OBJECT:checkBox20:Location = NEW System.Drawing.Point(117, 58).
    THIS-OBJECT:checkBox20:Name = "checkBox20".
    THIS-OBJECT:checkBox20:Size = NEW System.Drawing.Size(223, 24).
    THIS-OBJECT:checkBox20:TabIndex = 2.
    THIS-OBJECT:checkBox20:Text = "Перенос остатков по топливу".
    THIS-OBJECT:checkBox20:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox20:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox19 */
    /*  */
    THIS-OBJECT:checkBox19:Enabled = false.
    THIS-OBJECT:checkBox19:Location = NEW System.Drawing.Point(117, 27).
    THIS-OBJECT:checkBox19:Name = "checkBox19".
    THIS-OBJECT:checkBox19:Size = NEW System.Drawing.Size(223, 24).
    THIS-OBJECT:checkBox19:TabIndex = 1.
    THIS-OBJECT:checkBox19:Text = "Перенос остатков".
    THIS-OBJECT:checkBox19:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox19:UseVisualStyleBackColor = true.
    /*  */
    /* button5 */
    /*  */
    THIS-OBJECT:button5:Location = NEW System.Drawing.Point(24, 27).
    THIS-OBJECT:button5:Name = "button5".
    THIS-OBJECT:button5:Size = NEW System.Drawing.Size(75, 55).
    THIS-OBJECT:button5:TabIndex = 0.
    THIS-OBJECT:button5:Text = "Перенести остатки".
    THIS-OBJECT:button5:UseCompatibleTextRendering = true.
    THIS-OBJECT:button5:UseVisualStyleBackColor = true.
    THIS-OBJECT:button5:Click:Subscribe(THIS-OBJECT:button5_Click).
    /*  */
    /* tabPage4 */
    /*  */
    THIS-OBJECT:tabPage4:Controls:Add(THIS-OBJECT:button7).
    THIS-OBJECT:tabPage4:Controls:Add(THIS-OBJECT:checkBox22).
    THIS-OBJECT:tabPage4:Controls:Add(THIS-OBJECT:checkBox21).
    THIS-OBJECT:tabPage4:Location = NEW System.Drawing.Point(4, 22).
    THIS-OBJECT:tabPage4:Name = "tabPage4".
    THIS-OBJECT:tabPage4:Size = NEW System.Drawing.Size(396, 429).
    THIS-OBJECT:tabPage4:TabIndex = 3.
    THIS-OBJECT:tabPage4:Text = "Этап 4".
    THIS-OBJECT:tabPage4:UseVisualStyleBackColor = true.
    /*  */
    /* button7 */
    /*  */
    THIS-OBJECT:button7:Location = NEW System.Drawing.Point(22, 30).
    THIS-OBJECT:button7:Name = "button7".
    THIS-OBJECT:button7:Size = NEW System.Drawing.Size(75, 59).
    THIS-OBJECT:button7:TabIndex = 13.
    THIS-OBJECT:button7:Text = "Закрыть смену".
    THIS-OBJECT:button7:UseCompatibleTextRendering = true.
    THIS-OBJECT:button7:UseVisualStyleBackColor = true.
    THIS-OBJECT:button7:Click:Subscribe(THIS-OBJECT:button7_Click).
    /*  */
    /* checkBox22 */
    /*  */
    THIS-OBJECT:checkBox22:Enabled = false.
    THIS-OBJECT:checkBox22:Location = NEW System.Drawing.Point(110, 61).
    THIS-OBJECT:checkBox22:Name = "checkBox22".
    THIS-OBJECT:checkBox22:Size = NEW System.Drawing.Size(104, 28).
    THIS-OBJECT:checkBox22:TabIndex = 12.
    THIS-OBJECT:checkBox22:Text = "Закрытие смены".
    THIS-OBJECT:checkBox22:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox22:UseVisualStyleBackColor = true.
    /*  */
    /* checkBox21 */
    /*  */
    THIS-OBJECT:checkBox21:Enabled = false.
    THIS-OBJECT:checkBox21:Location = NEW System.Drawing.Point(110, 30).
    THIS-OBJECT:checkBox21:Name = "checkBox21".
    THIS-OBJECT:checkBox21:Size = NEW System.Drawing.Size(223, 24).
    THIS-OBJECT:checkBox21:TabIndex = 11.
    THIS-OBJECT:checkBox21:Text = "Сменная сверка ".
    THIS-OBJECT:checkBox21:UseCompatibleTextRendering = true.
    THIS-OBJECT:checkBox21:UseVisualStyleBackColor = true.
    /*  */
    /* tabPage5 */
    /*  */
    THIS-OBJECT:tabPage5:Controls:Add(THIS-OBJECT:button10).
    THIS-OBJECT:tabPage5:Controls:Add(THIS-OBJECT:label4).
    THIS-OBJECT:tabPage5:Controls:Add(THIS-OBJECT:button9).
    THIS-OBJECT:tabPage5:Controls:Add(THIS-OBJECT:textBox4).
    THIS-OBJECT:tabPage5:Controls:Add(THIS-OBJECT:button8).
    THIS-OBJECT:tabPage5:Location = NEW System.Drawing.Point(4, 22).
    THIS-OBJECT:tabPage5:Name = "tabPage5".
    THIS-OBJECT:tabPage5:Size = NEW System.Drawing.Size(396, 429).
    THIS-OBJECT:tabPage5:TabIndex = 4.
    THIS-OBJECT:tabPage5:Text = "Утилиты".
    THIS-OBJECT:tabPage5:UseVisualStyleBackColor = true.
    /*  */
    /* label4 */
    /*  */
    THIS-OBJECT:label4:Location = NEW System.Drawing.Point(145, 36).
    THIS-OBJECT:label4:Name = "label4".
    THIS-OBJECT:label4:Size = NEW System.Drawing.Size(153, 23).
    THIS-OBJECT:label4:TabIndex = 3.
    THIS-OBJECT:label4:Text = "Номера выбранных касс".
    THIS-OBJECT:label4:UseCompatibleTextRendering = true.
    /*  */
    /* button9 */
    /*  */
    THIS-OBJECT:button9:AllowDrop = true.
    THIS-OBJECT:button9:AutoSize = true.
    THIS-OBJECT:button9:Image = CAST(resources:GetObject("button9.Image"), System.Drawing.Image).
    THIS-OBJECT:button9:ImageAlign = System.Drawing.ContentAlignment:TopCenter.
    THIS-OBJECT:button9:Location = NEW System.Drawing.Point(345, 62).
    THIS-OBJECT:button9:Name = "button9".
    THIS-OBJECT:button9:Size = NEW System.Drawing.Size(33, 22).
    THIS-OBJECT:button9:TabIndex = 2.
    THIS-OBJECT:button9:TextAlign = System.Drawing.ContentAlignment:BottomCenter.
    THIS-OBJECT:button9:UseCompatibleTextRendering = true.
    THIS-OBJECT:button9:UseVisualStyleBackColor = true.
    THIS-OBJECT:button9:Click:Subscribe(THIS-OBJECT:button9_Click).
    /*  */
    /* textBox4 */
    /*  */
    THIS-OBJECT:textBox4:Location = NEW System.Drawing.Point(124, 62).
    THIS-OBJECT:textBox4:Name = "textBox4".
    THIS-OBJECT:textBox4:Size = NEW System.Drawing.Size(215, 20).
    THIS-OBJECT:textBox4:TabIndex = 1.
    /*  */
    /* button8 */
    /*  */
    THIS-OBJECT:button8:Location = NEW System.Drawing.Point(20, 36).
    THIS-OBJECT:button8:Name = "button8".
    THIS-OBJECT:button8:Size = NEW System.Drawing.Size(98, 59).
    THIS-OBJECT:button8:TabIndex = 0.
    THIS-OBJECT:button8:Text = "Резервное копирование базы кассы и удаление чеков".
    THIS-OBJECT:button8:UseCompatibleTextRendering = true.
    THIS-OBJECT:button8:UseVisualStyleBackColor = true.
    THIS-OBJECT:button8:Click:Subscribe(THIS-OBJECT:button8_Click).
    /*  */
    /* openFileDialog1 */
    /*  */
    THIS-OBJECT:openFileDialog1:FileName = "openFileDialog1".
    /*  */
    /* textBox2 */
    /*  */
    THIS-OBJECT:textBox2:Location = NEW System.Drawing.Point(328, 42).
    THIS-OBJECT:textBox2:Name = "textBox2".
    THIS-OBJECT:textBox2:Size = NEW System.Drawing.Size(209, 20).
    THIS-OBJECT:textBox2:TabIndex = 3.
    /*  */
    /* button3 */
    /*  */
    THIS-OBJECT:button3:Image = CAST(resources:GetObject("button3.Image"), System.Drawing.Image).
    THIS-OBJECT:button3:Location = NEW System.Drawing.Point(553, 42).
    THIS-OBJECT:button3:Name = "button3".
    THIS-OBJECT:button3:Size = NEW System.Drawing.Size(28, 23).
    THIS-OBJECT:button3:TabIndex = 4.
    THIS-OBJECT:button3:UseCompatibleTextRendering = true.
    THIS-OBJECT:button3:UseVisualStyleBackColor = true.
    THIS-OBJECT:button3:Click:Subscribe(THIS-OBJECT:button3_Click).
    /*  */
    /* label2 */
    /*  */
    THIS-OBJECT:label2:Location = NEW System.Drawing.Point(97, 47).
    THIS-OBJECT:label2:Name = "label2".
    THIS-OBJECT:label2:Size = NEW System.Drawing.Size(196, 14).
    THIS-OBJECT:label2:TabIndex = 5.
    THIS-OBJECT:label2:Text = "Файл соответствия товаров".
    THIS-OBJECT:label2:UseCompatibleTextRendering = true.
    /*  */
    /* label3 */
    /*  */
    THIS-OBJECT:label3:Location = NEW System.Drawing.Point(97, 73).
    THIS-OBJECT:label3:Name = "label3".
    THIS-OBJECT:label3:Size = NEW System.Drawing.Size(196, 14).
    THIS-OBJECT:label3:TabIndex = 8.
    THIS-OBJECT:label3:Text = "Файл соответствия поставщиков".
    THIS-OBJECT:label3:UseCompatibleTextRendering = true.
    /*  */
    /* button4 */
    /*  */
    THIS-OBJECT:button4:Image = CAST(resources:GetObject("button4.Image"), System.Drawing.Image).
    THIS-OBJECT:button4:Location = NEW System.Drawing.Point(553, 68).
    THIS-OBJECT:button4:Name = "button4".
    THIS-OBJECT:button4:Size = NEW System.Drawing.Size(28, 23).
    THIS-OBJECT:button4:TabIndex = 7.
    THIS-OBJECT:button4:UseCompatibleTextRendering = true.
    THIS-OBJECT:button4:UseVisualStyleBackColor = true.
    THIS-OBJECT:button4:Click:Subscribe(THIS-OBJECT:button4_Click).
    /*  */
    /* textBox3 */
    /*  */
    THIS-OBJECT:textBox3:Location = NEW System.Drawing.Point(328, 68).
    THIS-OBJECT:textBox3:Name = "textBox3".
    THIS-OBJECT:textBox3:Size = NEW System.Drawing.Size(209, 20).
    THIS-OBJECT:textBox3:TabIndex = 6.
    THIS-OBJECT:textBox3:TextChanged:Subscribe(THIS-OBJECT:textBox3_TextChanged).
    /*  */
    /* listBox1 */
    /*  */
    DEFINE VARIABLE nestedvar0 AS System.Windows.Forms.AnchorStyles NO-UNDO.
    nestedvar0 = CAST(Progress.Util.EnumHelper:Or(CAST(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
    THIS-OBJECT:listBox1:Anchor = CAST(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
    THIS-OBJECT:listBox1:FormattingEnabled = true.
    THIS-OBJECT:listBox1:Location = NEW System.Drawing.Point(449, 133).
    THIS-OBJECT:listBox1:Name = "listBox1".
    THIS-OBJECT:listBox1:Size = NEW System.Drawing.Size(326, 433).
    THIS-OBJECT:listBox1:TabIndex = 9.
    /*  */
    /* button6 */
    /*  */
    THIS-OBJECT:button6:DialogResult = System.Windows.Forms.DialogResult:Cancel.
    THIS-OBJECT:button6:Location = NEW System.Drawing.Point(16, 13).
    THIS-OBJECT:button6:Name = "button6".
    THIS-OBJECT:button6:Size = NEW System.Drawing.Size(75, 23).
    THIS-OBJECT:button6:TabIndex = 10.
    THIS-OBJECT:button6:Text = "Выход".
    THIS-OBJECT:button6:UseCompatibleTextRendering = true.
    THIS-OBJECT:button6:UseVisualStyleBackColor = true.
    THIS-OBJECT:button6:Click:Subscribe(THIS-OBJECT:button6_Click).
    /*  */
    /* button10 */
    /*  */
    THIS-OBJECT:button10:Location = NEW System.Drawing.Point(20, 101).
    THIS-OBJECT:button10:Name = "button10".
    THIS-OBJECT:button10:Size = NEW System.Drawing.Size(98, 59).
    THIS-OBJECT:button10:TabIndex = 4.
    THIS-OBJECT:button10:Text = "Сравнение остатков".
    THIS-OBJECT:button10:UseCompatibleTextRendering = true.
    THIS-OBJECT:button10:UseVisualStyleBackColor = true.
    THIS-OBJECT:button10:Click:Subscribe(THIS-OBJECT:button10_Click).
    /*  */
    /* draw_utility */
    /*  */
    THIS-OBJECT:CancelButton = THIS-OBJECT:button6.
    THIS-OBJECT:ClientSize = NEW System.Drawing.Size(795, 604).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:button6).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:listBox1).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:label3).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:button4).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:textBox3).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:label2).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:button3).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:textBox2).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:tabControl1).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:textBox1).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:label1).
    THIS-OBJECT:Name = "draw_utility".
    THIS-OBJECT:Text = "Тиражная утилита".
    THIS-OBJECT:tabControl1:ResumeLayout(false).
    THIS-OBJECT:tabPage1:ResumeLayout(false).
    THIS-OBJECT:tabPage2:ResumeLayout(false).
    THIS-OBJECT:tabPage3:ResumeLayout(false).
    THIS-OBJECT:tabPage4:ResumeLayout(false).
    THIS-OBJECT:tabPage5:ResumeLayout(false).
    THIS-OBJECT:tabPage5:PerformLayout().
    THIS-OBJECT:ResumeLayout(false).
    THIS-OBJECT:PerformLayout().
    CATCH e AS Progress.Lang.Error:
      UNDO, THROW e.
    END CATCH.
  end method.


	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void textBox3_TextChanged( input sender as System.Object, input e as System.EventArgs ):
		
		return.

    end method.
	
   &GLOBAL-DEFINE PARAM-BEG-TAG SUBSTITUTE("<PARAM name='&1'>", iName)
   &GLOBAL-DEFINE PARAM-END-TAG SUBSTITUTE("</PARAM name='&1'>", iName)
   &GLOBAL-DEFINE filename "draw-util-param.txt"
    method public  void SavePARAMs ():
        SavePARAMs({&filename }).
    end method.    
    method public  void SavePARAMs (  input iFile as char ):
        output to value (iFile).
        SavePARAM("host",textBox1:Text).
        SavePARAM("correspondence_gds",  textBox2:Text).
        SavePARAM("correspondence_supp", textBox3:Text).
        SavePARAM("darw_util_pswd",      string(checkBox25:checked)).
        SavePARAM("darw_util_user",      string(checkBox26:checked)).
        output close.
    end method.
    method public  void SavePARAM ( input iName as char, input iValue as char ):
        put unformatted {&PARAM-BEG-TAG}.
        put unformatted iValue.
        put unformatted {&PARAM-END-TAG} skip.
    end method.
    method public char GetPARAM (  input iName as char ):
         return GetPARAM ( {&filename }, iName  ).
    end method.         
    method public char GetPARAM ( input iFile as char, input iName as char ):
        def var vLob  as longchar no-undo.
        def var vFrom as int64    no-undo.
        def var vTo   as int64    no-undo.
        if not FileExists (iFile) then return ?.
        copy-lob file iFile to vLob no-error.
        vFrom = index(vLob, {&PARAM-BEG-TAG}).
        if vFrom <= 0 then return ?.
        assign
            vTo = index(vLob, {&PARAM-END-TAG})
            vFrom = vFrom + LENGTH({&PARAM-BEG-TAG}). 
        if vTo < vFrom then return ?.
        return string(substring(vLob, vFrom, vTo - vFrom)).
    end method.
    method public logical FileExists  (input  ifolder as character ):
        return objExists(ifolder,"F") ne ?.
    end.   
    method public character  objExists  (input  ifolder as character,
        input  iType   as character  ):
        define variable vPureName  as character no-undo.
        define variable vFullPath as character no-undo.
        define variable vFileType as character no-undo.                                  
        file-information:file-name = ifolder.
        if index( file-information:file-type, iType ) > 0 then return file-information:full-pathname .
        file-information:file-name = "./" + ifolder.
        if index( file-information:file-type, iType ) > 0 then return file-information:full-pathname .
    
        return ? .
   end method.
    /*------------------------------------------------------------------------------
      Purpose:
      Notes:
     ------------------------------------------------------------------------------*/
    @VisualDesigner.
    method private void button6_Click( input sender as System.Object, input e as System.EventArgs ):
        SavePARAMs().
        return.

    end method.
   	 

  destructor public draw_utility ( ):
      mutil:write-log:unSUBSCRIBE (this-object:write-log).
      
     delete object mUtil.
  end destructor.

end class.