 
/*------------------------------------------------------------------------
   File        : Сover_Sheet
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : eshklyar
   Created     : Tue Nov 05 09:17:49 MSK 2019
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.Form.
using System.ComponentModel.RefreshEventHandler from assembly.
using ibs.th.ref.*.

block-level on error undo, throw.

class ibs.th.ref.Cover_Sheet inherits Form: 

  {cmp/str-glbl.i class}
  { gbl/getcntxt.i def }
  { ibs/th/ref/Coins_Bank_tt.i }
  
  define private variable b_bank_recip   as System.Windows.Forms.Button      no-undo.
  define private variable b_deposit_bank as System.Windows.Forms.Button      no-undo.
  define private variable b_save         as System.Windows.Forms.Button      no-undo.
  define private variable b_print        as System.Windows.Forms.Button      no-undo.
  define private variable b_exit         as System.Windows.Forms.Button      no-undo.
  define private variable bank_recip     as System.Windows.Forms.TextBox     no-undo.
  define private variable components     as System.ComponentModel.IContainer no-undo.
  define private variable label6         as System.Windows.Forms.Label       no-undo.
  define private variable label5         as System.Windows.Forms.Label       no-undo.
  define private variable label4         as System.Windows.Forms.Label       no-undo.
  define private variable label3         as System.Windows.Forms.Label       no-undo.
  define private variable num_bag        as System.Windows.Forms.TextBox     no-undo.
  define private variable label2         as System.Windows.Forms.Label       no-undo.
  define private variable deposit_bank   as System.Windows.Forms.TextBox     no-undo.
  define private variable label1         as System.Windows.Forms.Label       no-undo.
  define private variable total_sum      as System.Windows.Forms.TextBox     no-undo.
  define private variable source_receipt as System.Windows.Forms.TextBox     no-undo.
  define private variable pin02          as System.Windows.Forms.TextBox     no-undo.
  define private variable v-host-code    as integer                          no-undo .
  define private variable v-status       as character                        no-undo .
  define private variable v-rid-list     as character                        no-undo . 
  DEFINE BUFFER find_fin-bank      FOR ub.fin-bank.
  DEFINE BUFFER find_fin-bank-attr FOR ub.fin-bank-attr.
  define private variable v-deposit_bank as integer no-undo .
  define private variable v-recip_bank   as integer no-undo .
  
  define property parparentproc as handle no-undo
    private get.
    set(input iH as handle):
      parparentproc = ih.
    end.
        
  constructor public Cover_Sheet (p-host-code as integer ):
    super().
    v-host-code = p-host-code .    
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
  method private void b_bank_recip_Click( input sender as System.Object, input e as System.EventArgs ):

    run ref/finbanks.w (input parParentProc
      , input v-cntxt-host-code-obj
      , input "b-sel":U
      , input {&company}
      , input v-host-code
      , input-output v-status
      , input-output v-rid-list) no-error .
    if v-rid-list <> "" then 
    do:
      FIND FIRST find_fin-bank No-LOCK where
        recid(find_fin-bank) = integer(entry(1, v-rid-list)) No-ERROR.
      if not avail find_fin-bank then 
      do:
        message
          "Неверное значение параметра вызова v-rid-list" v-rid-list
          view-as alert-box error .
        return error.
      end.
      this-object:bank_recip:Text = find_fin-bank.bank-name.
      v-recip_bank = find_fin-bank.code-bank .
    end.         
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void b_deposit_bank_Click( input sender as System.Object, input e as System.EventArgs ):
	  
    run ref/finbanks.w (input parParentProc
      , input v-cntxt-host-code-obj
      , input "b-sel":U
      , input {&company}
      , input v-host-code
      , input-output v-status
      , input-output v-rid-list) no-error .
    if v-rid-list <> "" then 
    do:
      FIND FIRST find_fin-bank No-LOCK where
        recid(find_fin-bank) = integer(entry(1, v-rid-list)) No-ERROR.
      if not avail find_fin-bank then 
      do:
        message
          "Неверное значение параметра вызова v-rid-list" v-rid-list
          view-as alert-box error .
        return error.
      end.
      this-object:deposit_bank:Text = find_fin-bank.bank-name.
      v-deposit_bank = find_fin-bank.code-bank .
    end.              
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void Cover_Sheet_Load( input sender as System.Object, input e as System.EventArgs ):
    define variable ii as integer no-undo .
    define variable CSJson as longchar no-undo .
    define variable CShtt   as handle no-undo .
    
	  find first find_fin-bank-attr no-lock where find_fin-bank-attr.host-code = v-host-code and find_fin-bank-attr.attr-code = "cover_sheet" no-error .
	  if available (find_fin-bank-attr) then do:
	    dataset ds-banknots:handle:read-json ("longchar",CSJson) .
	    
	    this-object:num_bag:Text = string(tt-cover-sheet.num-bag) .
	    this-object:deposit_bank:Text = tt-cover-sheet.depos-bank .
	    this-object:bank_recip:Text = tt-cover-sheet.repos-bank . 
	    this-object:pin02:Text = tt-cover-sheet.pin02 .
	    this-object:source_receipt:Text = tt-cover-sheet.source_ .
	    this-object:total_sum:Text = string(tt-cover-sheet.total-sum) .
	    
	    
	  end.   
		
    return.

  end method.

  method private void InitializeComponent(  ):
    
    /* NOTE: The following method is automatically generated.
    
    We strongly suggest that the contents of this method only be modified using the
    Visual Designer to avoid any incompatible modifications.
    
    Modifying the contents of this method using a code editor will invalidate any support for this file. */
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable resources as Progress.Util.ResourceManager no-undo.
    resources = new Progress.Util.ResourceManager("ibs.th.ref.Cover_Sheet").
    this-object:b_exit = new System.Windows.Forms.Button().
    this-object:b_save = new System.Windows.Forms.Button().
    this-object:b_print = new System.Windows.Forms.Button().
    this-object:num_bag = new System.Windows.Forms.TextBox().
    this-object:label1 = new System.Windows.Forms.Label().
    this-object:deposit_bank = new System.Windows.Forms.TextBox().
    this-object:b_deposit_bank = new System.Windows.Forms.Button().
    this-object:label2 = new System.Windows.Forms.Label().
    this-object:label3 = new System.Windows.Forms.Label().
    this-object:b_bank_recip = new System.Windows.Forms.Button().
    this-object:bank_recip = new System.Windows.Forms.TextBox().
    this-object:label4 = new System.Windows.Forms.Label().
    this-object:pin02 = new System.Windows.Forms.TextBox().
    this-object:label5 = new System.Windows.Forms.Label().
    this-object:source_receipt = new System.Windows.Forms.TextBox().
    this-object:label6 = new System.Windows.Forms.Label().
    this-object:total_sum = new System.Windows.Forms.TextBox().
    
    this-object:SuspendLayout().
    /*  */
    /* b_exit */
    /*  */
    this-object:b_exit:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:b_exit:Location = new System.Drawing.Point(493, 2).
    this-object:b_exit:Name = "b_exit".
    this-object:b_exit:Size = new System.Drawing.Size(100, 25).
    this-object:b_exit:TabIndex = 0.
    this-object:b_exit:Text = "Выход".
    this-object:b_exit:UseCompatibleTextRendering = true.
    this-object:b_exit:UseVisualStyleBackColor = true.
    /*  */
    /* b_save */
    /*  */
    this-object:b_save:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:b_save:Location = new System.Drawing.Point(392, 2).
    this-object:b_save:Name = "b_save".
    this-object:b_save:Size = new System.Drawing.Size(100, 25).
    this-object:b_save:TabIndex = 1.
    this-object:b_save:Text = "Сохранить".
    this-object:b_save:UseCompatibleTextRendering = true.
    this-object:b_save:UseVisualStyleBackColor = true.
    /*  */
    /* b_print */
    /*  */
    this-object:b_print:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:b_print:Location = new System.Drawing.Point(291, 2).
    this-object:b_print:Name = "b_print".
    this-object:b_print:Size = new System.Drawing.Size(100, 25).
    this-object:b_print:TabIndex = 2.
    this-object:b_print:Text = "Печать".
    this-object:b_print:UseCompatibleTextRendering = true.
    this-object:b_print:UseVisualStyleBackColor = true.
    /*  */
    /* num_bag */
    /*  */
    this-object:num_bag:Location = new System.Drawing.Point(173, 44).
    this-object:num_bag:Name = "num_bag".
    this-object:num_bag:Size = new System.Drawing.Size(177, 20).
    this-object:num_bag:TabIndex = 3.
    /*  */
    /* label1 */
    /*  */
    this-object:label1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label1:Location = new System.Drawing.Point(41, 44).
    this-object:label1:Name = "label1".
    this-object:label1:Size = new System.Drawing.Size(100, 20).
    this-object:label1:TabIndex = 4.
    this-object:label1:Text = "Номер сумки:".
    this-object:label1:UseCompatibleTextRendering = true.
    /*  */
    /* deposit_bank */
    /*  */
    this-object:deposit_bank:Location = new System.Drawing.Point(173, 70).
    this-object:deposit_bank:Name = "deposit_bank".
    this-object:deposit_bank:ReadOnly = true.
    this-object:deposit_bank:Size = new System.Drawing.Size(177, 20).
    this-object:deposit_bank:TabIndex = 5.
    /*  */
    /* b_deposit_bank */
    /*  */
    this-object:b_deposit_bank:Image = cast(resources:GetObject("b_deposit_bank.Image"), System.Drawing.Image).
    this-object:b_deposit_bank:Location = new System.Drawing.Point(356, 70).
    this-object:b_deposit_bank:Name = "b_deposit_bank".
    this-object:b_deposit_bank:Size = new System.Drawing.Size(25, 23).
    this-object:b_deposit_bank:TabIndex = 14.
    this-object:b_deposit_bank:UseCompatibleTextRendering = true.
    this-object:b_deposit_bank:UseVisualStyleBackColor = true.
    this-object:b_deposit_bank:Visible = false.
    this-object:b_deposit_bank:Click:Subscribe(this-object:b_deposit_bank_Click).
    /*  */
    /* label2 */
    /*  */
    this-object:label2:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label2:Location = new System.Drawing.Point(41, 67).
    this-object:label2:Name = "label2".
    this-object:label2:Size = new System.Drawing.Size(119, 23).
    this-object:label2:TabIndex = 15.
    this-object:label2:Text = "Банк-вноситель:".
    this-object:label2:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label2:UseCompatibleTextRendering = true.
    /*  */
    /* label3 */
    /*  */
    this-object:label3:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label3:Location = new System.Drawing.Point(41, 93).
    this-object:label3:Name = "label3".
    this-object:label3:Size = new System.Drawing.Size(119, 23).
    this-object:label3:TabIndex = 18.
    this-object:label3:Text = "Банк-получатель:".
    this-object:label3:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label3:UseCompatibleTextRendering = true.
    /*  */
    /* b_bank_recip */
    /*  */
    this-object:b_bank_recip:Image = cast(resources:GetObject("b_bank_recip.Image"), System.Drawing.Image).
    this-object:b_bank_recip:Location = new System.Drawing.Point(356, 96).
    this-object:b_bank_recip:Name = "b_bank_recip".
    this-object:b_bank_recip:Size = new System.Drawing.Size(25, 23).
    this-object:b_bank_recip:TabIndex = 17.
    this-object:b_bank_recip:UseCompatibleTextRendering = true.
    this-object:b_bank_recip:UseVisualStyleBackColor = true.
    this-object:b_bank_recip:Visible = false.
    this-object:b_bank_recip:Click:Subscribe(this-object:b_bank_recip_Click).
    /*  */
    /* bank_recip */
    /*  */
    this-object:bank_recip:Location = new System.Drawing.Point(173, 96).
    this-object:bank_recip:Name = "bank_recip".
    this-object:bank_recip:ReadOnly = true.
    this-object:bank_recip:Size = new System.Drawing.Size(177, 20).
    this-object:bank_recip:TabIndex = 16.
    /*  */
    /* label4 */
    /*  */
    this-object:label4:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label4:Location = new System.Drawing.Point(41, 122).
    this-object:label4:Name = "label4".
    this-object:label4:Size = new System.Drawing.Size(100, 20).
    this-object:label4:TabIndex = 20.
    this-object:label4:Text = "ПИН (02):".
    this-object:label4:UseCompatibleTextRendering = true.
    /*  */
    /* pin02 */
    /*  */
    this-object:pin02:Location = new System.Drawing.Point(173, 122).
    this-object:pin02:Name = "pin02".
    this-object:pin02:Size = new System.Drawing.Size(177, 20).
    this-object:pin02:TabIndex = 19.
    /*  */
    /* label5 */
    /*  */
    this-object:label5:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label5:Location = new System.Drawing.Point(12, 148).
    this-object:label5:Name = "label5".
    this-object:label5:Size = new System.Drawing.Size(155, 20).
    this-object:label5:TabIndex = 22.
    this-object:label5:Text = "Источник поступления:".
    this-object:label5:UseCompatibleTextRendering = true.
    /*  */
    /* source_receipt */
    /*  */
    this-object:source_receipt:Location = new System.Drawing.Point(173, 148).
    this-object:source_receipt:Name = "source_receipt".
    this-object:source_receipt:Size = new System.Drawing.Size(420, 20).
    this-object:source_receipt:TabIndex = 21.
    /*  */
    /* label6 */
    /*  */
    this-object:label6:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label6:Location = new System.Drawing.Point(380, 430).
    this-object:label6:Name = "label6".
    this-object:label6:Size = new System.Drawing.Size(100, 20).
    this-object:label6:TabIndex = 24.
    this-object:label6:Text = "Общая сумма:".
    this-object:label6:UseCompatibleTextRendering = true.
    /*  */
    /* total_sum */
    /*  */
    this-object:total_sum:Location = new System.Drawing.Point(486, 429).
    this-object:total_sum:Name = "total_sum".
    this-object:total_sum:Size = new System.Drawing.Size(107, 20).
    this-object:total_sum:TabIndex = 23.
    /*  */
   
    /* Cover_Sheet */
    /*  */
    this-object:ClientSize = new System.Drawing.Size(600, 457).
    
    this-object:Controls:Add(this-object:label6).
    this-object:Controls:Add(this-object:total_sum).
    this-object:Controls:Add(this-object:label5).
    this-object:Controls:Add(this-object:source_receipt).
    this-object:Controls:Add(this-object:label4).
    this-object:Controls:Add(this-object:pin02).
    this-object:Controls:Add(this-object:label3).
    this-object:Controls:Add(this-object:b_bank_recip).
    this-object:Controls:Add(this-object:bank_recip).
    this-object:Controls:Add(this-object:label2).
    this-object:Controls:Add(this-object:b_deposit_bank).
    this-object:Controls:Add(this-object:deposit_bank).
    this-object:Controls:Add(this-object:label1).
    this-object:Controls:Add(this-object:num_bag).
    this-object:Controls:Add(this-object:b_print).
    this-object:Controls:Add(this-object:b_save).
    this-object:Controls:Add(this-object:b_exit).
    this-object:Name = "Cover_Sheet".
    this-object:Text = "Сover_Sheet".
    this-object:Load:Subscribe(this-object:Cover_Sheet_Load).
    this-object:ResumeLayout(false).
    this-object:PerformLayout().
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
  end method.

  destructor public Cover_Sheet ( ):

  end destructor.

end class.