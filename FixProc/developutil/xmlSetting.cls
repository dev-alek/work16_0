 
 /*------------------------------------------------------------------------
    File        : xmlSetting
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daru
    Created     : Tue Feb 22 01:05:40 MSK 2022
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.Form.

block-level on error undo, throw.

class fixproc.developutil.xmlSetting inherits Form: 
   
   define private variable chPumpTxtRead as System.Windows.Forms.CheckBox no-undo.
   define private variable chGetCashCurl as System.Windows.Forms.CheckBox no-undo.
   define private variable chDeveloperMode as System.Windows.Forms.CheckBox no-undo.
   define private variable bxPswd as System.Windows.Forms.TextBox no-undo.
   define private variable bxLogin as System.Windows.Forms.TextBox no-undo.
   define private variable btSave as System.Windows.Forms.Button no-undo.
   define private variable btLoad as System.Windows.Forms.Button no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
   define private variable openFileDialog as System.Windows.Forms.OpenFileDialog no-undo.
   define private variable pnUser as System.Windows.Forms.Panel no-undo.
   define private variable lbPSWD as System.Windows.Forms.Label no-undo.
   define private variable lbLogin as System.Windows.Forms.Label no-undo.
   define private variable LbUser as System.Windows.Forms.Label no-undo.
   define private variable saveFileDialog as System.Windows.Forms.SaveFileDialog no-undo.

   define variable vss-revision    as character no-undo init "$Revision:$":U .
   define variable vss-author      as character no-undo init "$Author:$":U .
   define variable vss-date        as character no-undo init "$Date:$":U .
   define variable vss-workfile    as character no-undo init "$Workfile:$":U .
   define variable vss-archive     as character no-undo init "$Archive:$":U .
   define variable vss-description as character no-undo init "".
   
   constructor public xmlSetting (  ):
      
      
      super().
      InitializeComponent().
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
	method private void btLoad_Click( input sender as System.Object, input e as System.EventArgs ):
		load_file().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void btSave_Click( input sender as System.Object, input e as System.EventArgs ):
		save_file().
		return.

	end method.

   method private void InitializeComponent(  ):
      
      /* NOTE: The following method is automatically generated.
      
      We strongly suggest that the contents of this method only be modified using the
      Visual Designer to avoid any incompatible modifications.
      
      Modifying the contents of this method using a code editor will invalidate any support for this file. */
      this-object:btSave = new System.Windows.Forms.Button().
      this-object:btLoad = new System.Windows.Forms.Button().
      this-object:lbLogin = new System.Windows.Forms.Label().
      this-object:chPumpTxtRead = new System.Windows.Forms.CheckBox().
      this-object:chGetCashCurl = new System.Windows.Forms.CheckBox().
      this-object:chDeveloperMode = new System.Windows.Forms.CheckBox().
      this-object:pnUser = new System.Windows.Forms.Panel().
      this-object:LbUser = new System.Windows.Forms.Label().
      this-object:bxPswd = new System.Windows.Forms.TextBox().
      this-object:lbPSWD = new System.Windows.Forms.Label().
      this-object:bxLogin = new System.Windows.Forms.TextBox().
      this-object:saveFileDialog = new System.Windows.Forms.SaveFileDialog().
      this-object:openFileDialog = new System.Windows.Forms.OpenFileDialog().
      this-object:pnUser:SuspendLayout().
      this-object:SuspendLayout().
      /*  */
      /* btSave */
      /*  */
      this-object:btSave:Location = new System.Drawing.Point(93, 12).
      this-object:btSave:Name = "btSave".
      this-object:btSave:Size = new System.Drawing.Size(75, 23).
      this-object:btSave:TabIndex = 1.
      this-object:btSave:Text = "Сохранить".
      this-object:btSave:UseCompatibleTextRendering = true.
      this-object:btSave:UseVisualStyleBackColor = true.
      this-object:btSave:Click:Subscribe(this-object:btSave_Click).
      /*  */
      /* btLoad */
      /*  */
      this-object:btLoad:Location = new System.Drawing.Point(12, 12).
      this-object:btLoad:Name = "btLoad".
      this-object:btLoad:Size = new System.Drawing.Size(75, 23).
      this-object:btLoad:TabIndex = 2.
      this-object:btLoad:Text = "Загрузить".
      this-object:btLoad:UseCompatibleTextRendering = true.
      this-object:btLoad:UseVisualStyleBackColor = true.
      this-object:btLoad:Click:Subscribe(this-object:btLoad_Click).
      /*  */
      /* lbLogin */
      /*  */
      this-object:lbLogin:Location = new System.Drawing.Point(7, 52).
      this-object:lbLogin:Name = "lbLogin".
      this-object:lbLogin:Size = new System.Drawing.Size(82, 23).
      this-object:lbLogin:TabIndex = 3.
      this-object:lbLogin:Text = "Логин".
      this-object:lbLogin:UseCompatibleTextRendering = true.
      /*  */
      /* chPumpTxtRead */
      /*  */
      this-object:chPumpTxtRead:Location = new System.Drawing.Point(12, 41).
      this-object:chPumpTxtRead:Name = "chPumpTxtRead".
      this-object:chPumpTxtRead:Size = new System.Drawing.Size(250, 24).
      this-object:chPumpTxtRead:TabIndex = 4.
      this-object:chPumpTxtRead:Text = "Загрузка данных ТРК из файла pump.txt".
      this-object:chPumpTxtRead:UseCompatibleTextRendering = true.
      this-object:chPumpTxtRead:UseVisualStyleBackColor = true.
      /*  */
      /* chGetCashCurl */
      /*  */
      this-object:chGetCashCurl:Location = new System.Drawing.Point(12, 72).
      this-object:chGetCashCurl:Name = "chGetCashCurl".
      this-object:chGetCashCurl:Size = new System.Drawing.Size(233, 24).
      this-object:chGetCashCurl:TabIndex = 5.
      this-object:chGetCashCurl:Text = "Загрузка spool файлов".
      this-object:chGetCashCurl:UseCompatibleTextRendering = true.
      this-object:chGetCashCurl:UseVisualStyleBackColor = true.
      /*  */
      /* chDeveloperMode */
      /*  */
      this-object:chDeveloperMode:Location = new System.Drawing.Point(13, 103).
      this-object:chDeveloperMode:Name = "chDeveloperMode".
      this-object:chDeveloperMode:Size = new System.Drawing.Size(232, 24).
      this-object:chDeveloperMode:TabIndex = 6.
      this-object:chDeveloperMode:Text = "Режим разработчика".
      this-object:chDeveloperMode:UseCompatibleTextRendering = true.
      this-object:chDeveloperMode:UseVisualStyleBackColor = true.
      /*  */
      /* pnUser */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:pnUser:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:pnUser:BorderStyle = System.Windows.Forms.BorderStyle:Fixed3D.
      this-object:pnUser:Controls:Add(this-object:LbUser).
      this-object:pnUser:Controls:Add(this-object:bxPswd).
      this-object:pnUser:Controls:Add(this-object:lbPSWD).
      this-object:pnUser:Controls:Add(this-object:bxLogin).
      this-object:pnUser:Controls:Add(this-object:lbLogin).
      this-object:pnUser:Location = new System.Drawing.Point(12, 133).
      this-object:pnUser:Name = "pnUser".
      this-object:pnUser:Size = new System.Drawing.Size(318, 143).
      this-object:pnUser:TabIndex = 7.
      /*  */
      /* LbUser */
      /*  */
      define variable nestedvar1 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar1 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:LbUser:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar1, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:LbUser:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(11.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:LbUser:Location = new System.Drawing.Point(-1, 0).
      this-object:LbUser:Name = "LbUser".
      this-object:LbUser:Size = new System.Drawing.Size(317, 46).
      this-object:LbUser:TabIndex = 7.
      this-object:LbUser:Text = "Создать пользоваателя при входе".
      this-object:LbUser:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
      this-object:LbUser:UseCompatibleTextRendering = true.
      /*  */
      /* bxPswd */
      /*  */
      define variable nestedvar2 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar2 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:bxPswd:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar2, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:bxPswd:Location = new System.Drawing.Point(96, 93).
      this-object:bxPswd:Name = "bxPswd".
      this-object:bxPswd:Size = new System.Drawing.Size(200, 20).
      this-object:bxPswd:TabIndex = 6.
      /*  */
      /* lbPSWD */
      /*  */
      this-object:lbPSWD:Location = new System.Drawing.Point(7, 93).
      this-object:lbPSWD:Name = "lbPSWD".
      this-object:lbPSWD:Size = new System.Drawing.Size(82, 39).
      this-object:lbPSWD:TabIndex = 5.
      this-object:lbPSWD:Text = "Пароль, если не задан равен логину".
      this-object:lbPSWD:UseCompatibleTextRendering = true.
      /*  */
      /* bxLogin */
      /*  */
      define variable nestedvar3 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar3 = cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:bxLogin:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar3, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:bxLogin:Location = new System.Drawing.Point(95, 49).
      this-object:bxLogin:Name = "bxLogin".
      this-object:bxLogin:Size = new System.Drawing.Size(201, 20).
      this-object:bxLogin:TabIndex = 4.
      /*  */
      /* openFileDialog */
      /*  */
      this-object:openFileDialog:FileName = "openFileDialog1".
      /*  */
      /* xmlSetting */
      /*  */
      this-object:ClientSize = new System.Drawing.Size(342, 300).
      this-object:Controls:Add(this-object:pnUser).
      this-object:Controls:Add(this-object:chDeveloperMode).
      this-object:Controls:Add(this-object:chGetCashCurl).
      this-object:Controls:Add(this-object:chPumpTxtRead).
      this-object:Controls:Add(this-object:btLoad).
      this-object:Controls:Add(this-object:btSave).
      this-object:Name = "xmlSetting".
      this-object:Text = "xmlSetting".
      this-object:pnUser:ResumeLayout(false).
      this-object:pnUser:PerformLayout().
      this-object:ResumeLayout(false).
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method.


   destructor public xmlSetting ( ):

   end destructor.

   method private void load_file ():
      define variable vresult as System.Windows.Forms.DialogResult no-undo.
      define variable vFilesetting as character no-undo.
      define variable vtext as character no-undo.
      define variable vfound as logical no-undo.
      openFileDialog:filename = "systemsetting.xml".
      wait-for this-object:openFileDialog:ShowDialog() set vresult.
      if   vresult eq System.Windows.Forms.DialogResult:Ok
      then do:
         vFilesetting = SearchFile(this-object:openFileDialog:FileName).
         if vFileSetting ne ?
         then do:
            xmldom-clear().
            xmldom-load(vFileSetting).
            xmldom-read-unique("settings","PumpTxtRead",output vText, output vFound).
            chPumpTxtRead:Checked = logical(vText)no-error.
            xmldom-read-unique("settings","GetCashCurl",output vText, output vFound).
            chGetCashCurl:Checked = logical(vText)no-error.
            xmldom-read-unique("settings","DeveloperMode",output vText, output vFound).
            chDeveloperMode:Checked = logical(vText)no-error.
            xmldom-read-unique("settings","CrLogin",output vText, output vFound).
            bxLogin:text = vtext.
            xmldom-read-unique("settings","CrPswd",output vText, output vFound).
            bxPswd:text = vtext.
            xmldom-clear().
         end.
      end.
   end.
   { cmp/str-glbl.i class }  
   { GBL/xmldom.i class }
   
   method private void save_file ():
      define variable vresult as System.Windows.Forms.DialogResult no-undo.
      saveFileDialog:Filter = "xml files (*.xml)|*.xml|All files (*.*)|*.*"  .
      saveFileDialog:filename = "systemsetting.xml".
      wait-for this-object:saveFileDialog:ShowDialog() set vresult.
      if   vresult eq System.Windows.Forms.DialogResult:Ok
      then do:
          define variable hSAXWriter as handle no-undo.
           create sax-writer hSAXWriter.
           hSAXWriter:set-output-destination("file", saveFileDialog:filename) no-error.
           hSAXWriter:formatted = true.
           hSAXWriter:encoding = "windows-1251".
         
           hSAXWriter:start-document() no-error.
         
           hSAXWriter:start-element("System") no-error.
              hSAXWriter:start-element("settings") no-error.
                 hSAXWriter:write-data-element("PumpTxtRead",     string(chPumpTxtRead:Checked)   ) no-error.
                 hSAXWriter:write-data-element("GetCashCurl",     string(chGetCashCurl:Checked)   ) no-error.
                 hSAXWriter:write-data-element("DeveloperMode",   string(chDeveloperMode:Checked) ) no-error.
                 hSAXWriter:write-data-element("CrLogin",         bxLogin:text                    ) no-error.
                 hSAXWriter:write-data-element("CrPswd",          bxPswd:text                     ) no-error.
              hSAXWriter:end-element("settings") no-error.
           hSAXWriter:end-element("System") no-error.
         
           hSAXWriter:end-document() no-error.
           if hSAXWriter:write-status = 7 then do:
             delete object hSAXWriter no-error.
             return error.
           end.
           delete object hSAXWriter no-error.
      end.
   end.
   { utl/search.i class }
end class.