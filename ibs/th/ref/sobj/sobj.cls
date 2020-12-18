 
 /*------------------------------------------------------------------------
    File        : sobj
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : druban
    Created     : Sun Mar 29 20:45:53 MSK 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.UserControl.
using ibs.th.ref.sobj.sType from propath.

block-level on error undo, throw.

class ibs.th.ref.sobj.sobj inherits UserControl: 
   {cmp\str-glbl.i class}
   {cmp\r-page-pre.i}
   define public  variable BtnObj as System.Windows.Forms.Button no-undo.
   define private variable components as System.ComponentModel.IContainer no-undo.
   define private variable ObjCount as System.Windows.Forms.TextBox no-undo.
   define private variable SelectObjectObjFirm as System.Windows.Forms.RadioButton no-undo.
   define private variable SelectObjectObjCurr as System.Windows.Forms.RadioButton no-undo.
   define private variable SelectObjectObjChoice as System.Windows.Forms.RadioButton no-undo.
   define private variable SelectObjectAll as System.Windows.Forms.RadioButton no-undo.
   define private variable TEXT1 as System.Windows.Forms.Label no-undo.

   define property mTrgLoc as class ibs.th.ref.sobj.sObj_trg no-undo
   get.
   set.
   
   define property mTrgGlb as class ibs.th.ref.sobj.dReportTrg no-undo
   get.
   set.
   
   define public property stype as class ibs.th.ref.sobj.stype no-undo
   get.
   set(iarg as ibs.th.ref.sobj.stype):
      stype = iarg.
      mTrgLoc:stype = iarg.
      SelectObjectObjFirm  :text = iarg:SelectObjectLbl({&obj-firm}).
      SelectObjectObjCurr  :text = iarg:SelectObjectLbl({&obj-currency}).
      SelectObjectObjChoice:text = iarg:SelectObjectLbl({&obj-choice}).
      SelectObjectAll      :text = iarg:SelectObjectLbl({&obj-all}).
   end.

   define public property SelectObject as character  no-undo
   get:
      return if      SelectObjectObjFirm  :checked 
             then    SelectObjectObjFirm  :text
             else if SelectObjectObjCurr  :checked 
             then    SelectObjectObjCurr  :text
             else if SelectObjectObjChoice:checked 
             then    SelectObjectObjChoice:text
             else if SelectObjectAll      :checked 
             then    SelectObjectAll      :text
             else "".
   end.
   set (iarg as character  ):
      if      iarg eq SelectObjectObjFirm  :text
      then            SelectObjectObjFirm  :checked = yes .   
      else if iarg eq SelectObjectObjCurr  :text
      then            SelectObjectObjCurr  :checked = yes . 
      else if iarg eq SelectObjectObjChoice:text
      then            SelectObjectObjChoice:checked = yes. 
      else if iarg eq SelectObjectAll      :text
      then            SelectObjectAll      :checked = yes. 
      else
         message "Нет поля " iarg
         view-as alert-box.  
   end.
   
   define public property SelectObject_disable as character  no-undo
   set (iarg as character  ):
      define variable varg as character  no-undo.
      define variable vi as integer no-undo.
      if not iarg eq "*" 
      then
      do vi = 1 to 4:
         if lookup(string(vi),iarg) eq 0
         then do:
            varg = stype:SelectObjectLbl(vi)no-error.
            if      varg eq SelectObjectObjFirm:Text
            then            SelectObjectObjFirm:Enabled = no .   
            else if varg eq SelectObjectObjCurr:Text
            then            SelectObjectObjCurr:Enabled = no . 
            else if varg eq SelectObjectObjChoice:Text
            then            SelectObjectObjChoice:Enabled = no . 
            else if varg eq SelectObjectAll:Text
            then            SelectObjectAll:Enabled = no .
         end.
      end.
   end.
   
   
   
   define public property ParamObj as class ibs.th.ref.sobj.sParamObj no-undo
   
   set(iarg as ibs.th.ref.sobj.sParamObj):
      mTrgLoc:ParamObj = iarg.
   end.   
   
   define public property ParamForm as class ibs.th.ref.sobj.sParamForm no-undo
   get.
   set(iarg as ibs.th.ref.sobj.sParamForm):
      mTrgLoc:ParamForm = iarg.
      ParamForm = iarg.
   end.
   
   constructor public sobj (  ):
      
      
      super().
      mTrgLoc = new ibs.th.ref.sobj.sObj_trg (). 
      mTrgLoc:ObjForm = this-object.
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
	method private void BtnObj_Click( input sender as System.Object, input e as System.EventArgs ):
		VALUE-CHANGED_SelectObject().
		return.

	end method.

   method private void InitializeComponent(  ):
      
      /* NOTE: The following method is automatically generated.
      
      We strongly suggest that the contents of this method only be modified using the
      Visual Designer to avoid any incompatible modifications.
      
      Modifying the contents of this method using a code editor will invalidate any support for this file. */
      @VisualDesigner.FormMember (NeedsInitialize="true").
      define variable resources as Progress.Util.ResourceManager no-undo.
      resources = new Progress.Util.ResourceManager("ibs.th.ref.sobj.sobj").
      this-object:TEXT1 = new System.Windows.Forms.Label().
      this-object:SelectObjectObjFirm = new System.Windows.Forms.RadioButton().
      this-object:SelectObjectObjCurr = new System.Windows.Forms.RadioButton().
      this-object:SelectObjectObjChoice = new System.Windows.Forms.RadioButton().
      this-object:SelectObjectAll = new System.Windows.Forms.RadioButton().
      this-object:BtnObj = new System.Windows.Forms.Button().
      this-object:ObjCount = new System.Windows.Forms.TextBox().
      this-object:SuspendLayout().
      /*  */
      /* TEXT1 */
      /*  */
      this-object:TEXT1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(12), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:TEXT1:Location = new System.Drawing.Point(14, 12).
      this-object:TEXT1:Name = "TEXT1".
      this-object:TEXT1:Size = new System.Drawing.Size(140, 23).
      this-object:TEXT1:TabIndex = 0.
      this-object:TEXT1:Text = "Выбор объекта".
      this-object:TEXT1:UseCompatibleTextRendering = true.
      /*  */
      /* SelectObjectObjFirm */
      /*  */
      this-object:SelectObjectObjFirm:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.75), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:SelectObjectObjFirm:Location = new System.Drawing.Point(4, 39).
      this-object:SelectObjectObjFirm:Name = "SelectObjectObjFirm".
      this-object:SelectObjectObjFirm:Size = new System.Drawing.Size(130, 20).
      this-object:SelectObjectObjFirm:TabIndex = 1.
      this-object:SelectObjectObjFirm:TabStop = true.
      this-object:SelectObjectObjFirm:Text = "Все по фирме".
      this-object:SelectObjectObjFirm:UseCompatibleTextRendering = true.
      this-object:SelectObjectObjFirm:UseVisualStyleBackColor = true.
      this-object:SelectObjectObjFirm:CheckedChanged:Subscribe(this-object:SelectObjectObjFirm_CheckedChanged).
      /*  */
      /* SelectObjectObjCurr */
      /*  */
      this-object:SelectObjectObjCurr:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.75), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:SelectObjectObjCurr:Location = new System.Drawing.Point(3, 65).
      this-object:SelectObjectObjCurr:Name = "SelectObjectObjCurr".
      this-object:SelectObjectObjCurr:Size = new System.Drawing.Size(104, 20).
      this-object:SelectObjectObjCurr:TabIndex = 2.
      this-object:SelectObjectObjCurr:TabStop = true.
      this-object:SelectObjectObjCurr:Text = "Текущий".
      this-object:SelectObjectObjCurr:UseCompatibleTextRendering = true.
      this-object:SelectObjectObjCurr:UseVisualStyleBackColor = true.
      this-object:SelectObjectObjCurr:CheckedChanged:Subscribe(this-object:SelectObjectObjCurr_CheckedChanged).
      /*  */
      /* SelectObjectObjChoice */
      /*  */
      this-object:SelectObjectObjChoice:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.75), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:SelectObjectObjChoice:Location = new System.Drawing.Point(4, 91).
      this-object:SelectObjectObjChoice:Name = "SelectObjectObjChoice".
      this-object:SelectObjectObjChoice:Size = new System.Drawing.Size(104, 20).
      this-object:SelectObjectObjChoice:TabIndex = 3.
      this-object:SelectObjectObjChoice:TabStop = true.
      this-object:SelectObjectObjChoice:Text = "Выборочно".
      this-object:SelectObjectObjChoice:UseCompatibleTextRendering = true.
      this-object:SelectObjectObjChoice:UseVisualStyleBackColor = true.
      this-object:SelectObjectObjChoice:CheckedChanged:Subscribe(this-object:SelectObjectObjChoice_CheckedChanged).
      /*  */
      /* SelectObjectAll */
      /*  */
      this-object:SelectObjectAll:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.75), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:SelectObjectAll:Location = new System.Drawing.Point(4, 117).
      this-object:SelectObjectAll:Name = "SelectObjectAll".
      this-object:SelectObjectAll:Size = new System.Drawing.Size(104, 20).
      this-object:SelectObjectAll:TabIndex = 4.
      this-object:SelectObjectAll:TabStop = true.
      this-object:SelectObjectAll:Text = "Все".
      this-object:SelectObjectAll:UseCompatibleTextRendering = true.
      this-object:SelectObjectAll:UseVisualStyleBackColor = true.
      this-object:SelectObjectAll:CheckedChanged:Subscribe(this-object:SelectObjectAll_CheckedChanged).
      /*  */
      /* BtnObj */
      /*  */
      this-object:BtnObj:Image = cast(resources:GetObject("BtnObj.Image"), System.Drawing.Image).
      this-object:BtnObj:Location = new System.Drawing.Point(134, 91).
      this-object:BtnObj:Name = "BtnObj".
      this-object:BtnObj:Size = new System.Drawing.Size(20, 20).
      this-object:BtnObj:TabIndex = 5.
      this-object:BtnObj:UseCompatibleTextRendering = true.
      this-object:BtnObj:UseVisualStyleBackColor = true.
      this-object:BtnObj:Click:Subscribe(this-object:BtnObj_Click).
      /*  */
      /* ObjCount */
      /*  */
      define variable nestedvar0 as System.Windows.Forms.AnchorStyles no-undo.
      nestedvar0 = cast(Progress.Util.EnumHelper:Or(cast(Progress.Util.EnumHelper:Or(System.Windows.Forms.AnchorStyles:Top, System.Windows.Forms.AnchorStyles:Bottom), System.Windows.Forms.AnchorStyles), System.Windows.Forms.AnchorStyles:Left), System.Windows.Forms.AnchorStyles).
      this-object:ObjCount:Anchor = cast(Progress.Util.EnumHelper:Or(nestedvar0, System.Windows.Forms.AnchorStyles:Right), System.Windows.Forms.AnchorStyles).
      this-object:ObjCount:Enabled = false.
      this-object:ObjCount:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.75), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:ObjCount:Location = new System.Drawing.Point(4, 143).
      this-object:ObjCount:Multiline = true.
      this-object:ObjCount:Name = "ObjCount".
      this-object:ObjCount:Size = new System.Drawing.Size(167, 34).
      this-object:ObjCount:TabIndex = 6.
      /*  */
      /* sobj */
      /*  */
      this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
      this-object:Controls:Add(this-object:ObjCount).
      this-object:Controls:Add(this-object:BtnObj).
      this-object:Controls:Add(this-object:SelectObjectAll).
      this-object:Controls:Add(this-object:SelectObjectObjChoice).
      this-object:Controls:Add(this-object:SelectObjectObjCurr).
      this-object:Controls:Add(this-object:SelectObjectObjFirm).
      this-object:Controls:Add(this-object:TEXT1).
      this-object:Name = "sobj".
      this-object:Size = new System.Drawing.Size(174, 180).
      this-object:ResumeLayout(false).
      this-object:PerformLayout().
      catch e as Progress.Lang.Error:
         undo, throw e.
      end catch.
   end method.

   destructor public sobj ( ):
      delete object mTrgLoc.
   end destructor.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void SelectObjectAll_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
	   if SelectObjectAll:Checked
	   then
		   VALUE-CHANGED_SelectObject().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void SelectObjectObjChoice_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
		if SelectObjectObjChoice:Checked
      then
         VALUE-CHANGED_SelectObject().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void SelectObjectObjCurr_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
		if SelectObjectObjCurr:Checked
      then
         VALUE-CHANGED_SelectObject().
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void SelectObjectObjFirm_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
		if SelectObjectObjCurr:Checked
      then
         VALUE-CHANGED_SelectObject().
		return.

	end method.

   method private character verify-obj():
      mTrgLoc:verify-obj () no-error.
      if error-status:error then return error.
   end.
   

   method private void CHOOSE_BUTTON-obj ():
/*      assign SelectObject.*/
/*      my-request = false .*/
      mtrgloc:select-objects-proc (false) .
   end.
  
   method private void VALUE-CHANGED_SelectObject():
      /*Assign SelectObject.*/
      mtrgloc:select-objects-proc (no) .
      val-obj () .
      mtrgloc:VALUE-CHANGED_SelectObject(stype:SelectObjectchar(SelectObject)).
      ObjCount:text = mTrgLoc:Assign-frame(SelectObject).
   end.

   method private void display-obj ():
      /*Обработка 3 параметра - ОБЬЕКТЫ - как показывать блок с выбором объектов */

      define variable v-temp-str  as character no-undo .
      define variable J#          as integer   no-undo .
      define variable L#          as integer   no-undo .
      define variable RET#        as logical   no-undo .
      define variable R#          as integer   no-undo .

      /* IF temp-param-obj = ""
       then DO:
          disable TEXT-1 BUTTON-obj SelectObject Obj-count   with frame {&FRAME-NAME} .
          hide    TEXT-1  BUTTON-obj SelectObject Obj-count   in frame {&FRAME-NAME} .
       End.
       Else DO:  enable TEXT-1 with frame {&FRAME-NAME} .
                 display TEXT-1  SelectObject Obj-count  with frame {&FRAME-NAME} .
      */           
   /* disable radio-set по номеру */
     SelectObject_disable = mTrgLoc:ParamForm:temp-param-obj.
/*    { rep/radiohid.i temp-param-obj SelectObject}*/
  /*    if stype:SelectObjectchar(SelectObject) = {&obj-choice} 
      then do:
        if not can-find (first userobjs_temp-user-obj) then do:
         /*
         message 'заполняем из X-init_obj-list ' skip 'qqq' .
         */
          for each X-init_obj-list:
                create userobjs_temp-user-obj.
                assign
                  userobjs_temp-user-obj.obj-code = X-init_obj-list.obj-code
                  userobjs_temp-user-obj.obj-type = X-init_obj-list.obj-type
                .
          end.
         end.
    end.
*/
      if (mTrgLoc:ParamObj:my-cntxt-obj-type = {&stock} and mTrgLoc:ParamForm:temp-param-obj-type = 'shop')
      or (mTrgLoc:ParamObj:my-cntxt-obj-type = {&shop}  and mTrgLoc:ParamForm:temp-param-obj-type = 'stock')
      then do:
         SelectObject_disable = sType:SelectObjectchar(3).
         value-changed_selectobject().
      end.
   end.

   
   method private void val-obj ():
      BtnObj:enabled = selectobject eq stype:SelectObjectLbl({&obj-choice}).
   end.
   
   method public void Assign-frame():
      mTrgLoc:set_SelectObject(SelectObject).
      mTrgLoc:set_TextLb( TEXT1:text).
      ObjCount:text = mTrgLoc:Assign-frame(SelectObject).
   end.
   
   method public void local-apply-layout(iparamObj as class ibs.th.ref.sobj.sParamObj):
      if     iparamObj:X-SelectObject ne ?
         and iparamObj:X-SelectObject ne ""
      then 
         SelectObject = stype:SelectObjectLbl(iparamObj:X-SelectObject).
      display-obj ().
      val-obj () .
      if iparamObj:X-SelectObject = {&obj-all} then mTrgLoc:sss().
      if iparamObj:X-SelectObject = {&obj-firm} then mTrgLoc:sss().
      mTrgLoc:verify-check-currency () .
      if iparamObj:params-only-mode  = {&lookup} 
      then 
         SelectObject_disable = "".
   end method.

   method public void local-initialize(iparamObj as class ibs.th.ref.sobj.sParamObj):
      if    iparamObj:my-cntxt-level = {&cntxt-firm}  
         or iparamObj:my-cntxt-level = {&cntxt-global}   
      then do:
        assign
          SelectObjectObjCurr:visible = no.
      end.
      /* else do:
       assign
          SelectObject :radio-buttons =
              "Все по фирме" + {&comma-char} + {&obj-firm}
            + {&comma-char} + "Текущий" + {&comma-char} + {&obj-currency}
            + {&comma-char} + "Выборочно" + {&comma-char} + {&obj-choice}
            + {&comma-char} + "Все" + {&comma-char} + {&obj-all}
        .
        
      end.*/
      if ParamForm:temp-param-obj <> ""  
      then do:
         if not (    iparamObj:my-cntxt-level = {&cntxt-firm}  
                 or  iparamObj:my-cntxt-level = {&cntxt-global} )
         then    SelectObject =  stype:SelectObjectLbl({&obj-currency}) .

/*      Display SelectObject with frame {&frame-name}.*/
         if SelectObject =  stype:SelectObjectLbl({&obj-choice}) 
         then do:
            iparamObj:empty-obj-list().
         end.
         else do:
            iparamObj:create_obj-list(iparamObj:my-cntxt-obj-type, iparamObj:my-cntxt-obj-code ).
         end.
      end.
   end method.
   
   method public char AssignParam ():
       verify-obj() no-error.
       if error-status:error then return error.
   end method.
end class.