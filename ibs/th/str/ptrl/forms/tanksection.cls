 
/*------------------------------------------------------------------------
   File        : tanksection
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : asmorozov
   Created     : Sat Oct 27 19:00:32 MSK 2018
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Windows.UserControl.
using ibs.th.str.* from propath.
using OpenEdge.Core.* from propath.
using System.Windows.Forms.* from assembly.
using ibs.th.str.ptrl.forms.* from propath.


class ibs.th.str.ptrl.forms.tanksection inherits UserControl: 
  
  { cmp/str-glbl.i class}
  
  define property idSecTabPage as integer no-undo
    get.
    private set.
  
  define private variable buttonPl as System.Windows.Forms.Button no-undo.
  define public variable infoSecsObj  as class ibs.th.str.InfoSectionsTotal no-undo.
  
  
  define private variable tanksecsObj as class tanksections                 no-undo. 
  
  
  define private variable textBoxPlSiName as System.Windows.Forms.TextBox no-undo.
    
  define private variable buttonCalcWeight             as System.Windows.Forms.Button         no-undo.
  define private variable buttonPlSi                   as System.Windows.Forms.Button         no-undo.
  define private variable buttonCopy                   as System.Windows.Forms.Button         no-undo.
  define private variable buttonCopySec                as System.Windows.Forms.Button         no-undo.
  define private variable components                   as System.ComponentModel.IContainer    no-undo.
  define private variable dateTimePickerDateEnd        as System.Windows.Forms.DateTimePicker no-undo.
  define private variable dateTimePickerDatePovPlotn   as System.Windows.Forms.DateTimePicker no-undo.
  define private variable dateTimePickerTimeStart      as System.Windows.Forms.DateTimePicker no-undo.
  define private variable dateTimePickerTimeEnd        as System.Windows.Forms.DateTimePicker no-undo.
  define private variable dateTimePickerDateStart      as System.Windows.Forms.DateTimePicker no-undo.
  define private variable label12                      as System.Windows.Forms.Label          no-undo.
  define private variable label11                      as System.Windows.Forms.Label          no-undo.
  define private variable label10                      as System.Windows.Forms.Label          no-undo.
  define private variable label21                      as System.Windows.Forms.Label          no-undo.
  define private variable label20                      as System.Windows.Forms.Label          no-undo.
  define private variable label19                      as System.Windows.Forms.Label          no-undo.
  define private variable label18                      as System.Windows.Forms.Label          no-undo.
  define private variable label17                      as System.Windows.Forms.Label          no-undo.
  define private variable label16                      as System.Windows.Forms.Label          no-undo.
  define private variable label15                      as System.Windows.Forms.Label          no-undo.
  define private variable label14                      as System.Windows.Forms.Label          no-undo.
  define private variable label13                      as System.Windows.Forms.Label          no-undo.
  define private variable label23                      as System.Windows.Forms.Label          no-undo.
  define private variable label22                      as System.Windows.Forms.Label          no-undo.
  define private variable label25                      as System.Windows.Forms.Label          no-undo.
  define private variable label24                      as System.Windows.Forms.Label          no-undo.
  define private variable label26                      as System.Windows.Forms.Label          no-undo.
  define private variable label27                      as System.Windows.Forms.Label          no-undo.
  define private variable label35                      as System.Windows.Forms.Label          no-undo.
  define private variable label34                      as System.Windows.Forms.Label          no-undo.
  define private variable label33                      as System.Windows.Forms.Label          no-undo.
  define private variable label32                      as System.Windows.Forms.Label          no-undo.
  define private variable label31                      as System.Windows.Forms.Label          no-undo.
  define private variable label30                      as System.Windows.Forms.Label          no-undo.
  define private variable label29                      as System.Windows.Forms.Label          no-undo.
  define private variable label28                      as System.Windows.Forms.Label          no-undo.
  define private variable label38                      as System.Windows.Forms.Label          no-undo.
  define private variable label37                      as System.Windows.Forms.Label          no-undo.
  define private variable label36                      as System.Windows.Forms.Label          no-undo.
  define private variable label39                      as System.Windows.Forms.Label          no-undo.
  define private variable label4                       as System.Windows.Forms.Label          no-undo.
  define private variable label8                       as System.Windows.Forms.Label          no-undo.
  define private variable label7                       as System.Windows.Forms.Label          no-undo.
  define private variable label6                       as System.Windows.Forms.Label          no-undo.
  define private variable label5                       as System.Windows.Forms.Label          no-undo.
  define private variable label9                       as System.Windows.Forms.Label          no-undo.
  define private variable groupBox7                    as System.Windows.Forms.GroupBox       no-undo.
  define private variable groupBox6                    as System.Windows.Forms.GroupBox       no-undo.
  define private variable groupBox5                    as System.Windows.Forms.GroupBox       no-undo.
  define private variable groupBox4                    as System.Windows.Forms.GroupBox       no-undo.
  define private variable maskedTextBoxAccShip         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxCertifFuel      as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable DateTimeDateProb             as System.Windows.Forms.DateTimePicker no-undo.
  define private variable maskedTextBoxDiameter        as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxKolProb         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxNaturLoss       as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxNumPlot         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxNumPrintProb    as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxPassportPlotn   as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxPlaceSi         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxSecName         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTankVolPomi     as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTankDensityPomi as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTests           as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTPNorm          as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxValidityCertif  as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxCarVol          as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTankWeight      as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTankWater       as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTankVol         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTankTemp        as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTankDens        as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxTTNTemp         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxNumPassport     as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxNormDoc         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxMouth           as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxListTank        as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxDocQnty         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxDocDens         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxDensTemp        as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxCliQnty         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxAccWeight       as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable maskedTextBoxABTArir         as System.Windows.Forms.MaskedTextBox  no-undo.
  define private variable label3                       as System.Windows.Forms.Label          no-undo.
  define private variable label2                       as System.Windows.Forms.Label          no-undo.
  define private variable label1                       as System.Windows.Forms.Label          no-undo.
  define private variable groupBox3                    as System.Windows.Forms.GroupBox       no-undo.
  define private variable groupBox2                    as System.Windows.Forms.GroupBox       no-undo.
  define private variable groupBox1                    as System.Windows.Forms.GroupBox       no-undo.
  define private variable TimeProb                     as System.Windows.Forms.DateTimePicker no-undo.

  define private variable setFocusMaskTextDoc          as System.Windows.Forms.MaskedTextBox  no-undo.

  
  define private variable DateTimePickerDateArr        as System.Windows.Forms.DateTimePicker extent 4 no-undo.
  define private variable DateTimePickerTimeArr        as System.Windows.Forms.DateTimePicker extent 3 no-undo.
  
  define private variable maskedTextBoxArr             as System.Windows.Forms.MaskedTextBox  extent 18 no-undo.
  
  define private variable maskedTextBoxDocArr          as System.Windows.Forms.MaskedTextBox  extent 6 no-undo.
  
  define private variable maskedTextBoxOnlyReadOnlyArr as System.Windows.Forms.MaskedTextBox  extent 8 no-undo.

    
  constructor public tanksection ( infoSecs as class InfoSectionsTotal, idSec as int, inTanksecs as class tanksections):
    
    super().
    
    tanksecsObj = inTanksecs.
    idSecTabPage = idSec.
    infoSecsObj = infoSecs.
    InitializeComponent().
    InitializeComponentCust().
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
  method private void buttonPl_Click( input sender as System.Object, input e as System.EventArgs ):
    
    def var v-str as char no-undo.
    
    run str/place-list.w 
    ( input infoSecsObj:TrnDocNum,
      input infoSecsObj:GdsCode,
      input-output v-str
    ).
    
    maskedTextBoxListTank:text = v-str.
    
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void buttonPlSi_Click( input sender as System.Object, input e as System.EventArgs ):
    
    define variable v-node-code as integer no-undo.
    define variable v-sr-type as integer no-undo.
    run ref/sr-izm.w (input infoSecsObj:Parentproc ,
                      input ""            ,
                      input {&lookup}     ,
                      input-output v-node-code,
                      output v-sr-type) no-error.   
    if v-node-code <> 0 and v-node-code <> ? then do :
      infoSecsObj:GetInfoSectionProp(idSecTabPage).
      infoSecsObj:InfoSectionCurr:PlaceSi = v-node-code.
      textBoxPlSiName:Text = infoSecsObj:InfoSectionCurr:PlSiName.
      maskedTextBoxPlaceSi:Text = string (infoSecsObj:InfoSectionCurr:PlaceSi).
    end.
    
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void buttonCopy_Click( input sender as System.Object, input e as System.EventArgs ):
    
    define variable v-place-si as integer no-undo.
    define variable v-num-plotn as character no-undo.
    define variable v-date-pov-plotn as date no-undo.
    define variable v-passport-plotn as character no-undo.
    define buffer buf_sr-izmerenia for ub.sr-izmerenia .    

    run str/in-copy-iz.w
      ( input        infoSecsObj:Parentproc
       ,input        infoSecsObj:Mode
       ,input        infoSecsObj:GdsCode
       ,output       v-place-si
       ,output       v-num-plotn
       ,output       v-passport-plotn
       ,output       v-date-pov-plotn       
      ) no-error.
    
    if v-place-si <> 0 and v-place-si <> ? 
    then
      assign
        maskedTextBoxNumPlot:Text = v-num-plotn
        maskedTextBoxPlaceSi:Text = string (v-place-si)
        dateTimePickerDatePovPlotn:Text = string (v-date-pov-plotn)
        maskedTextBoxPassportPlotn:Text = v-passport-plotn.
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void buttonCalcWeight_Click( input sender as System.Object, input e as System.EventArgs ):
    
    SetInfoSec ().
    if not CheckSec()
    then do:
      SetForcus().
      return.
    end.
    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecsObj:CalcWeight().
    SetControls ().
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void buttonCopySec_Click( input sender as System.Object, input e as System.EventArgs ):
    def var ii as int no-undo.
    do ii = 1 to extent (tanksecsObj:tankSectionControl):
      if not valid-object (tanksecsObj:tankSectionControl[ii]) or tanksecsObj:tankSectionControl[ii]:idSecTabPage = this-object:idSecTabPage 
        then next.

      tanksecsObj:tankSectionControl[ii]:GetCopy(maskedTextBoxNumPassport:Text, maskedTextBoxNormDoc:Text, maskedTextBoxCertifFuel:Text, maskedTextBoxValidityCertif:Text).  

    end.
    
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void dateTimePickerDate_Enter( input sender as System.Object, input e as System.EventArgs ):
    
    def var v-dtp as DateTimePicker no-undo.
    
    v-dtp = cast(sender, System.Windows.Forms.DateTimePicker).
    v-dtp:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void dateTimePickerTime_Enter( input sender as System.Object, input e as System.EventArgs ):
    
    def var v-dtp as DateTimePicker no-undo.
    
    v-dtp = cast(sender, System.Windows.Forms.DateTimePicker).
    v-dtp:Format = System.Windows.Forms.DateTimePickerFormat:Time.
    
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void dateTimePicker_KeyPress( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs ):
    
    /*asc = e:KeyChar*/
    
    return.

  end method.

  method public void GetCopy(a as char, b as char, c as char, d as char ):
    
    assign
      maskedTextBoxNumPassport:Text = a
      maskedTextBoxNormDoc:Text = b
      maskedTextBoxCertifFuel:Text = c
      maskedTextBoxValidityCertif:Text = d
    .
    
    return.

  end method.


  method private void InitializeComponentCust(  ):

    def var ii as int no-undo.
    
    SetControls().

    assign
      maskedTextBoxArr[1] = this-object:maskedTextBoxNumPassport
      maskedTextBoxArr[2] = this-object:maskedTextBoxNormDoc    
      maskedTextBoxArr[3] = this-object:maskedTextBoxCertifFuel     
      maskedTextBoxArr[4] = this-object:maskedTextBoxValidityCertif 
      maskedTextBoxArr[5] = this-object:maskedTextBoxABTArir        
      maskedTextBoxArr[6] = this-object:maskedTextBoxTankDens       
      maskedTextBoxArr[7] = this-object:maskedTextBoxTankWater      
      maskedTextBoxArr[8] = this-object:maskedTextBoxTankTemp       
      maskedTextBoxArr[9] = this-object:maskedTextBoxDensTemp
      maskedTextBoxArr[10] = this-object:maskedTextBoxCarVol
      maskedTextBoxArr[11] = this-object:maskedTextBoxDiameter       
      maskedTextBoxArr[12] = this-object:maskedTextBoxListTank       
      maskedTextBoxArr[13] = this-object:maskedTextBoxPlaceSi        
      maskedTextBoxArr[14] = this-object:maskedTextBoxNumPlot        
      maskedTextBoxArr[15] = this-object:maskedTextBoxPassportPlotn  
      maskedTextBoxArr[16] = this-object:maskedTextBoxTests          
      maskedTextBoxArr[17] = this-object:maskedTextBoxKolProb        
      maskedTextBoxArr[18] = this-object:maskedTextBoxNumPrintProb
   
      .
    assign    
      maskedTextBoxDocArr[1] = this-object:maskedTextBoxDocDens
      maskedTextBoxDocArr[2] = this-object:maskedTextBoxDocQnty
      maskedTextBoxDocArr[3] = this-object:maskedTextBoxSecName
      maskedTextBoxDocArr[4] = this-object:maskedTextBoxCliQnty
      maskedTextBoxDocArr[5] = this-object:maskedTextBoxTTNTemp
      maskedTextBoxDocArr[6] = this-object:maskedTextBoxAccShip
    .
    
    assign
      maskedTextBoxOnlyReadOnlyArr[1 ] = this-object:maskedTextBoxTPNorm    
      maskedTextBoxOnlyReadOnlyArr[2 ] = this-object:maskedTextBoxNaturLoss     
      maskedTextBoxOnlyReadOnlyArr[3 ] = this-object:maskedTextBoxTankVolPomi    
      maskedTextBoxOnlyReadOnlyArr[4 ] = this-object:maskedTextBoxTankDensityPomi    
      maskedTextBoxOnlyReadOnlyArr[5 ] = this-object:maskedTextBoxAccWeight    
      maskedTextBoxOnlyReadOnlyArr[6 ] = this-object:maskedTextBoxTankWeight
      maskedTextBoxOnlyReadOnlyArr[7 ] = this-object:maskedTextBoxTankVol
      maskedTextBoxOnlyReadOnlyArr[8 ] = this-object:maskedTextBoxMouth          
    .
    
    assign
      DateTimePickerDateArr[1] = this-object:dateTimePickerDatePovPlotn
      DateTimePickerDateArr[2] = this-object:dateTimePickerDateStart   
      DateTimePickerDateArr[3] = this-object:dateTimePickerDateEnd     
      DateTimePickerDateArr[4] = this-object:DateTimeDateProb
      .

    assign
      DateTimePickerTimeArr[1] = this-object:dateTimePickerTimeStart   
      DateTimePickerTimeArr[2] = this-object:dateTimePickerTimeEnd  
      DateTimePickerTimeArr[3] = this-object:TimeProb                 
      .
      
      
    do ii = 1 to extent (DateTimePickerDateArr):
      this-object:DateTimePickerDateArr[ii]:Enter:Subscribe(this-object:dateTimePickerDate_Enter).
      this-object:DateTimePickerDateArr[ii]:KeyPress:Subscribe(this-object:dateTimePicker_KeyPress).
    end.
    
    do ii = 1 to extent (DateTimePickerTimeArr):
      this-object:DateTimePickerTimeArr[ii]:Enter:Subscribe(this-object:dateTimePickerTime_Enter).
      this-object:DateTimePickerTimeArr[ii]:KeyPress:Subscribe(this-object:dateTimePicker_KeyPress).
    end.
      
    do ii = 1 to extent (maskedTextBoxOnlyReadOnlyArr):
      
      this-object:maskedTextBoxOnlyReadOnlyArr[ii]:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
      this-object:maskedTextBoxOnlyReadOnlyArr[ii]:BackColor = this-object:maskedTextBoxOnlyReadOnlyArr[ii]:BackColor.
      maskedTextBoxOnlyReadOnlyArr[ii]:Enabled = false.
      
    end.

    if infoSecsObj:Mode = "ПРОСМОТР"
      then 
    do:
      do ii = 1 to extent (maskedTextBoxArr):
        this-object:maskedTextBoxArr[ii]:BackColor = this-object:maskedTextBoxArr[ii]:BackColor.
        this-object:maskedTextBoxArr[ii]:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        maskedTextBoxArr[ii]:Enabled = false.
      end.

      do ii = 1 to extent (maskedTextBoxDocArr):
        this-object:maskedTextBoxDocArr[ii]:BackColor = this-object:maskedTextBoxDocArr[ii]:BackColor.
        this-object:maskedTextBoxDocArr[ii]:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        maskedTextBoxDocArr[ii]:Enabled = false.
      end.
      
      do ii = 1 to extent (DateTimePickerTimeArr):
        DateTimePickerTimeArr[ii]:Enabled = false.
      end.
      do ii = 1 to extent (DateTimePickerDateArr):
        DateTimePickerDateArr[ii]:Enabled = false.
      end.
      
      buttonCalcWeight:Visible = false.
      buttonCopy:Visible =  false.
      buttonCopySec:Visible = false.
      buttonPl:Visible = false.
      buttonPlSi:Visible = false.
      
    end.
    
    if not infoSecsObj:FlagTrn and not infoSecsObj:Sts = "ФАКТ"
    then do:
      groupBox2:Visible = false.
      groupBox3:Visible = false.
      groupBox4:Visible = false.
      groupBox5:Visible = false.
      groupBox6:Visible = false.
      groupBox7:Visible = false.
    end.

    if infoSecsObj:RdcDnstvalue = "not"
    then do:
      groupBox7:Visible = false.
      
      
      groupBox6:Visible = false.
      
      maskedTextBoxTankTemp:Visible = false.
      maskedTextBoxTankVolPomi:Visible = false.
      maskedTextBoxTankDensityPomi:Visible = false.
      maskedTextBoxAccWeight:Visible = false.
      label23:Visible = false.
      label22:Visible = false.
      label24:Visible = false.
      
      groupBox4:Location = groupBox7:Location.
      groupBox5:Location = new System.Drawing.Point(10, 470).
      buttonCalcWeight:Visible = false.
      label20:Visible = false.      
      label23:Visible = false.
      label23:Visible = false.
    
    end.

    
    if (infoSecsObj:Mode = "ДОБАВЛЕНИЕ" or infoSecsObj:Mode = "ИЗМЕНЕНИЕ") and not infoSecsObj:FlagTrn
    then do:
      
      do ii = 1 to extent (maskedTextBoxDocArr):
        
        this-object:maskedTextBoxDocArr[ii]:BackColor = this-object:maskedTextBoxArr[ii]:BackColor.
        maskedTextBoxDocArr[ii]:ReadOnly = false.
/*        maskedTextBoxDocArr[ii]:TextChanged:Subscribe(this-object:ValueChgMaskTBox_5_3).*/
        this-object:maskedTextBoxCarVol:Visible = false.
        this-object:maskedTextBoxDiameter:Visible = false.
        label2:Visible = false.
        label6:Visible = false.
      end.
      
      if not infoSecsObj:CliQntyInput
        then do: 
          this-object:maskedTextBoxCliQnty:Enabled = false.
          this-object:maskedTextBoxCliQnty:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
          this-object:maskedTextBoxDocDens:TextChanged:Subscribe(this-object:CalcDoc).
          this-object:maskedTextBoxDocQnty:TextChanged:Subscribe(this-object:CalcDoc).
        end.
      if not infoSecsObj:DocQntyInput
        then do: 
          this-object:maskedTextBoxDocQnty:Enabled = false.
          this-object:maskedTextBoxDocQnty:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
          this-object:maskedTextBoxDocDens:TextChanged:Subscribe(this-object:CalcDoc).
          this-object:maskedTextBoxCliQnty:TextChanged:Subscribe(this-object:CalcDoc).
        end.
      if not infoSecsObj:DensityInput
        then do: 
          this-object:maskedTextBoxDocDens:Enabled = false.
          this-object:maskedTextBoxDocDens:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
          this-object:maskedTextBoxDocQnty:TextChanged:Subscribe(this-object:CalcDoc).
          this-object:maskedTextBoxCliQnty:TextChanged:Subscribe(this-object:CalcDoc).
        end.
      

            
    end.  
    if (infoSecsObj:Mode = "ДОБАВЛЕНИЕ" or infoSecsObj:Mode = "ИЗМЕНЕНИЕ") and infoSecsObj:FlagTrn
    then do:
      
      maskedTextBoxDiameter:TextChanged:Subscribe(this-object:ClWght).
      maskedTextBoxCarVol:TextChanged:Subscribe(this-object:ClWght).
      maskedTextBoxABTArir:TextChanged:Subscribe(this-object:ClWght).
      maskedTextBoxTankDens:TextChanged:Subscribe(this-object:ClWght).
      maskedTextBoxTankTemp:TextChanged:Subscribe(this-object:ClWght).
      maskedTextBoxDensTemp:TextChanged:Subscribe(this-object:ClWght).
      maskedTextBoxPlaceSi:TextChanged:Subscribe(this-object:ClWght).
      
      do ii = 1 to extent (maskedTextBoxDocArr):
        this-object:maskedTextBoxArr[ii]:BackColor = this-object:maskedTextBoxArr[ii]:BackColor.
        this-object:maskedTextBoxDocArr[ii]:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        maskedTextBoxDocArr[ii]:Enabled = false.
      end.
    end.

    
  end.


  method private void InitializeComponent(  ):
    
    /* NOTE: The following method is automatically generated.
    
    We strongly suggest that the contents of this method only be modified using the
    Visual Designer to avoid any incompatible modifications.
    
    Modifying the contents of this method using a code editor will invalidate any support for this file. */
    @VisualDesigner.FormMember (NeedsInitialize="true").
    define variable resources as Progress.Util.ResourceManager no-undo.
    resources = new Progress.Util.ResourceManager("ibs.th.str.ptrl.forms.tanksection").
    this-object:groupBox3 = new System.Windows.Forms.GroupBox().
    this-object:buttonPl = new System.Windows.Forms.Button().
    this-object:maskedTextBoxTPNorm = new System.Windows.Forms.MaskedTextBox().
    this-object:label39 = new System.Windows.Forms.Label().
    this-object:label21 = new System.Windows.Forms.Label().
    this-object:label20 = new System.Windows.Forms.Label().
    this-object:label19 = new System.Windows.Forms.Label().
    this-object:label18 = new System.Windows.Forms.Label().
    this-object:label17 = new System.Windows.Forms.Label().
    this-object:label16 = new System.Windows.Forms.Label().
    this-object:label15 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNaturLoss = new System.Windows.Forms.MaskedTextBox().
    this-object:label14 = new System.Windows.Forms.Label().
    this-object:label13 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxTankVol = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankDens = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxDensTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxListTank = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankWater = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxABTArir = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxMouth = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxAccWeight = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankWeight = new System.Windows.Forms.MaskedTextBox().
    this-object:groupBox2 = new System.Windows.Forms.GroupBox().
    this-object:buttonCopySec = new System.Windows.Forms.Button().
    this-object:maskedTextBoxValidityCertif = new System.Windows.Forms.MaskedTextBox().
    this-object:label12 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxCertifFuel = new System.Windows.Forms.MaskedTextBox().
    this-object:label11 = new System.Windows.Forms.Label().
    this-object:label10 = new System.Windows.Forms.Label().
    this-object:label9 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNumPassport = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxNormDoc = new System.Windows.Forms.MaskedTextBox().
    this-object:groupBox1 = new System.Windows.Forms.GroupBox().
    this-object:label8 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxAccShip = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxSecName = new System.Windows.Forms.MaskedTextBox().
    this-object:label7 = new System.Windows.Forms.Label().
    this-object:label6 = new System.Windows.Forms.Label().
    this-object:label5 = new System.Windows.Forms.Label().
    this-object:label4 = new System.Windows.Forms.Label().
    this-object:label3 = new System.Windows.Forms.Label().
    this-object:label2 = new System.Windows.Forms.Label().
    this-object:label1 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxCliQnty = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxDiameter = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxDocQnty = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxCarVol = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTTNTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxDocDens = new System.Windows.Forms.MaskedTextBox().
    this-object:groupBox7 = new System.Windows.Forms.GroupBox().
    this-object:textBoxPlSiName = new System.Windows.Forms.TextBox().
    this-object:dateTimePickerDatePovPlotn = new System.Windows.Forms.DateTimePicker().
    this-object:buttonCopy = new System.Windows.Forms.Button().
    this-object:label38 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxPassportPlotn = new System.Windows.Forms.MaskedTextBox().
    this-object:label37 = new System.Windows.Forms.Label().
    this-object:label36 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNumPlot = new System.Windows.Forms.MaskedTextBox().
    this-object:buttonPlSi = new System.Windows.Forms.Button().
    this-object:maskedTextBoxPlaceSi = new System.Windows.Forms.MaskedTextBox().
    this-object:label26 = new System.Windows.Forms.Label().
    this-object:groupBox6 = new System.Windows.Forms.GroupBox().
    this-object:maskedTextBoxNumPrintProb = new System.Windows.Forms.MaskedTextBox().
    this-object:label35 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxTests = new System.Windows.Forms.MaskedTextBox().
    this-object:label34 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxKolProb = new System.Windows.Forms.MaskedTextBox().
    this-object:label33 = new System.Windows.Forms.Label().
    this-object:DateTimeDateProb = new System.Windows.Forms.DateTimePicker().
    this-object:label32 = new System.Windows.Forms.Label().
    this-object:TimeProb = new System.Windows.Forms.DateTimePicker().
    this-object:label31 = new System.Windows.Forms.Label().
    this-object:groupBox5 = new System.Windows.Forms.GroupBox().
    this-object:dateTimePickerTimeEnd = new System.Windows.Forms.DateTimePicker().
    this-object:dateTimePickerTimeStart = new System.Windows.Forms.DateTimePicker().
    this-object:dateTimePickerDateEnd = new System.Windows.Forms.DateTimePicker().
    this-object:dateTimePickerDateStart = new System.Windows.Forms.DateTimePicker().
    this-object:label30 = new System.Windows.Forms.Label().
    this-object:label29 = new System.Windows.Forms.Label().
    this-object:label28 = new System.Windows.Forms.Label().
    this-object:label27 = new System.Windows.Forms.Label().
    this-object:groupBox4 = new System.Windows.Forms.GroupBox().
    this-object:buttonCalcWeight = new System.Windows.Forms.Button().
    this-object:label25 = new System.Windows.Forms.Label().
    this-object:label24 = new System.Windows.Forms.Label().
    this-object:label23 = new System.Windows.Forms.Label().
    this-object:label22 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxTankDensityPomi = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankVolPomi = new System.Windows.Forms.MaskedTextBox().
    this-object:groupBox3:SuspendLayout().
    this-object:groupBox2:SuspendLayout().
    this-object:groupBox1:SuspendLayout().
    this-object:groupBox7:SuspendLayout().
    this-object:groupBox6:SuspendLayout().
    this-object:groupBox5:SuspendLayout().
    this-object:groupBox4:SuspendLayout().
    this-object:SuspendLayout().
    /*  */
    /* groupBox3 */
    /*  */
    this-object:groupBox3:Controls:Add(this-object:buttonPl).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTPNorm).
    this-object:groupBox3:Controls:Add(this-object:label39).
    this-object:groupBox3:Controls:Add(this-object:label21).
    this-object:groupBox3:Controls:Add(this-object:label20).
    this-object:groupBox3:Controls:Add(this-object:label19).
    this-object:groupBox3:Controls:Add(this-object:label18).
    this-object:groupBox3:Controls:Add(this-object:label17).
    this-object:groupBox3:Controls:Add(this-object:label16).
    this-object:groupBox3:Controls:Add(this-object:label15).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxNaturLoss).
    this-object:groupBox3:Controls:Add(this-object:label14).
    this-object:groupBox3:Controls:Add(this-object:label13).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankVol).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankDens).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxDensTemp).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxListTank).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankTemp).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankWater).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxABTArir).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxMouth).
    this-object:groupBox3:Location = new System.Drawing.Point(10, 256).
    this-object:groupBox3:Name = "groupBox3".
    this-object:groupBox3:Size = new System.Drawing.Size(682, 140).
    this-object:groupBox3:TabIndex = 2.
    this-object:groupBox3:TabStop = false.
    this-object:groupBox3:UseCompatibleTextRendering = true.
    /*  */
    /* buttonPl */
    /*  */
    this-object:buttonPl:Location = new System.Drawing.Point(526, 109).
    this-object:buttonPl:Name = "buttonPl".
    this-object:buttonPl:Size = new System.Drawing.Size(57, 23).
    this-object:buttonPl:TabIndex = 24.
    this-object:buttonPl:Text = "Выбор".
    this-object:buttonPl:UseCompatibleTextRendering = true.
    this-object:buttonPl:UseVisualStyleBackColor = true.
    this-object:buttonPl:Click:Subscribe(this-object:buttonPl_Click).
    /*  */
    /* maskedTextBoxTPNorm */
    /*  */
    this-object:maskedTextBoxTPNorm:ForeColor = System.Drawing.Color:Maroon.
    this-object:maskedTextBoxTPNorm:Location = new System.Drawing.Point(191, 111).
    this-object:maskedTextBoxTPNorm:Name = "maskedTextBoxTPNorm".
    this-object:maskedTextBoxTPNorm:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTPNorm:TabIndex = 22.
    /*  */
    /* label39 */
    /*  */
    this-object:label39:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label39:ForeColor = System.Drawing.Color:Red.
    this-object:label39:Location = new System.Drawing.Point(68, 63).
    this-object:label39:Name = "label39".
    this-object:label39:Size = new System.Drawing.Size(117, 20).
    this-object:label39:TabIndex = 25.
    this-object:label39:Text = "Плотность топлива:".
    this-object:label39:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label39:UseCompatibleTextRendering = true.
    /*  */
    /* label21 */
    /*  */
    this-object:label21:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label21:ForeColor = System.Drawing.Color:Red.
    this-object:label21:Location = new System.Drawing.Point(297, 84).
    this-object:label21:Name = "label21".
    this-object:label21:Size = new System.Drawing.Size(117, 27).
    this-object:label21:TabIndex = 26.
    this-object:label21:Text = "Температура замера плотности:".
    this-object:label21:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label21:UseCompatibleTextRendering = true.
    /*  */
    /* label20 */
    /*  */
    this-object:label20:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label20:ForeColor = System.Drawing.Color:Red.
    this-object:label20:Location = new System.Drawing.Point(297, 57).
    this-object:label20:Name = "label20".
    this-object:label20:Size = new System.Drawing.Size(117, 26).
    this-object:label20:TabIndex = 27.
    this-object:label20:Text = "Температура замера объема:".
    this-object:label20:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label20:UseCompatibleTextRendering = true.
    /*  */
    /* label19 */
    /*  */
    this-object:label19:Location = new System.Drawing.Point(297, 113).
    this-object:label19:Name = "label19".
    this-object:label19:Size = new System.Drawing.Size(117, 20).
    this-object:label19:TabIndex = 28.
    this-object:label19:Text = "Резервуар:".
    this-object:label19:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label19:UseCompatibleTextRendering = true.
    /*  */
    /* label18 */
    /*  */
    this-object:label18:Location = new System.Drawing.Point(297, 34).
    this-object:label18:Name = "label18".
    this-object:label18:Size = new System.Drawing.Size(117, 20).
    this-object:label18:TabIndex = 29.
    this-object:label18:Text = "Объем воды:".
    this-object:label18:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label18:UseCompatibleTextRendering = true.
    /*  */
    /* label17 */
    /*  */
    this-object:label17:Location = new System.Drawing.Point(68, 109).
    this-object:label17:Name = "label17".
    this-object:label17:Size = new System.Drawing.Size(117, 27).
    this-object:label17:TabIndex = 30.
    this-object:label17:Text = "Тех. потери по нормам, кг:".
    this-object:label17:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label17:UseCompatibleTextRendering = true.
    /*  */
    /* label16 */
    /*  */
    this-object:label16:Location = new System.Drawing.Point(68, 88).
    this-object:label16:Name = "label16".
    this-object:label16:Size = new System.Drawing.Size(117, 20).
    this-object:label16:TabIndex = 31.
    this-object:label16:Text = "Масса ЕУ:".
    this-object:label16:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label16:UseCompatibleTextRendering = true.
    /*  */
    /* label15 */
    /*  */
    this-object:label15:Location = new System.Drawing.Point(68, 38).
    this-object:label15:Name = "label15".
    this-object:label15:Size = new System.Drawing.Size(117, 20).
    this-object:label15:TabIndex = 32.
    this-object:label15:Text = "Объем топлива:".
    this-object:label15:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label15:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNaturLoss */
    /*  */
    this-object:maskedTextBoxNaturLoss:ForeColor = System.Drawing.Color:Maroon.
    this-object:maskedTextBoxNaturLoss:Location = new System.Drawing.Point(191, 88).
    this-object:maskedTextBoxNaturLoss:Name = "maskedTextBoxNaturLoss".
    this-object:maskedTextBoxNaturLoss:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxNaturLoss:TabIndex = 20.
    this-object:maskedTextBoxNaturLoss:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* label14 */
    /*  */
    this-object:label14:Location = new System.Drawing.Point(297, 9).
    this-object:label14:Name = "label14".
    this-object:label14:Size = new System.Drawing.Size(117, 20).
    this-object:label14:TabIndex = 33.
    this-object:label14:Text = "Объем горловины:".
    this-object:label14:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label14:UseCompatibleTextRendering = true.
    /*  */
    /* label13 */
    /*  */
    this-object:label13:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label13:ForeColor = System.Drawing.Color:Red.
    this-object:label13:Location = new System.Drawing.Point(6, 9).
    this-object:label13:Name = "label13".
    this-object:label13:Size = new System.Drawing.Size(179, 28).
    this-object:label13:TabIndex = 34.
    this-object:label13:Text = "Уровень цистерны относит. тарировочной планки:".
    this-object:label13:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label13:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxTankVol */
    /*  */
    this-object:maskedTextBoxTankVol:Location = new System.Drawing.Point(191, 35).
    this-object:maskedTextBoxTankVol:Name = "maskedTextBoxTankVol".
    this-object:maskedTextBoxTankVol:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankVol:TabIndex = 16.
    this-object:maskedTextBoxTankVol:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* maskedTextBoxTankDens */
    /*  */
    this-object:maskedTextBoxTankDens:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxTankDens:Location = new System.Drawing.Point(191, 61).
    this-object:maskedTextBoxTankDens:Name = "maskedTextBoxTankDens".
    this-object:maskedTextBoxTankDens:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankDens:TabIndex = 18.
    this-object:maskedTextBoxTankDens:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_4).
    this-object:maskedTextBoxTankDens:Leave:Subscribe(this-object:calc-weight-vol).
    /*  */
    /* maskedTextBoxDensTemp */
    /*  */
    this-object:maskedTextBoxDensTemp:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxDensTemp:Location = new System.Drawing.Point(420, 87).
    this-object:maskedTextBoxDensTemp:Name = "maskedTextBoxDensTemp".
    this-object:maskedTextBoxDensTemp:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxDensTemp:TabIndex = 21.
    this-object:maskedTextBoxDensTemp:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimalNegNum_2_1).
    /*  */
    /* maskedTextBoxListTank */
    /*  */
    this-object:maskedTextBoxListTank:Location = new System.Drawing.Point(420, 111).
    this-object:maskedTextBoxListTank:Name = "maskedTextBoxListTank".
    this-object:maskedTextBoxListTank:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxListTank:TabIndex = 23.
    this-object:maskedTextBoxListTank:KeyPress:Subscribe(this-object:KeyPressMaskTBIntNegNum_2).
    /*  */
    /* maskedTextBoxTankTemp */
    /*  */
    this-object:maskedTextBoxTankTemp:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxTankTemp:Location = new System.Drawing.Point(420, 61).
    this-object:maskedTextBoxTankTemp:Name = "maskedTextBoxTankTemp".
    this-object:maskedTextBoxTankTemp:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankTemp:TabIndex = 19.
    this-object:maskedTextBoxTankTemp:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimalNegNum_2_1).
    /*  */
    /* maskedTextBoxTankWater */
    /*  */
    this-object:maskedTextBoxTankWater:Location = new System.Drawing.Point(420, 33).
    this-object:maskedTextBoxTankWater:Name = "maskedTextBoxTankWater".
    this-object:maskedTextBoxTankWater:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankWater:TabIndex = 17.
    this-object:maskedTextBoxTankWater:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    this-object:maskedTextBoxTankWater:Leave:Subscribe(this-object:calc-weight-vol).
    /*  */
    /* maskedTextBoxABTArir */
    /*  */
    this-object:maskedTextBoxABTArir:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxABTArir:Location = new System.Drawing.Point(191, 9).
    this-object:maskedTextBoxABTArir:Name = "maskedTextBoxABTArir".
    this-object:maskedTextBoxABTArir:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxABTArir:TabIndex = 14.
    this-object:maskedTextBoxABTArir:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimalNegNum_5_2).
    this-object:maskedTextBoxABTArir:Leave:Subscribe(this-object:calc-weight-vol).
    /*  */
    /* maskedTextBoxMouth */
    /*  */
    this-object:maskedTextBoxMouth:Location = new System.Drawing.Point(420, 9).
    this-object:maskedTextBoxMouth:Name = "maskedTextBoxMouth".
    this-object:maskedTextBoxMouth:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxMouth:TabIndex = 15.
    this-object:maskedTextBoxMouth:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    this-object:maskedTextBoxMouth:Leave:Subscribe(this-object:calc-weight-vol).
    /*  */
    /* maskedTextBoxAccWeight */
    /*  */
    this-object:maskedTextBoxAccWeight:Location = new System.Drawing.Point(373, 35).
    this-object:maskedTextBoxAccWeight:Name = "maskedTextBoxAccWeight".
    this-object:maskedTextBoxAccWeight:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxAccWeight:TabIndex = 33.
    this-object:maskedTextBoxAccWeight:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_2).
    /*  */
    /* maskedTextBoxTankWeight */
    /*  */
    this-object:maskedTextBoxTankWeight:ForeColor = System.Drawing.Color:Maroon.
    this-object:maskedTextBoxTankWeight:Location = new System.Drawing.Point(373, 10).
    this-object:maskedTextBoxTankWeight:Name = "maskedTextBoxTankWeight".
    this-object:maskedTextBoxTankWeight:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankWeight:TabIndex = 31.
    this-object:maskedTextBoxTankWeight:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* groupBox2 */
    /*  */
    this-object:groupBox2:Controls:Add(this-object:buttonCopySec).
    this-object:groupBox2:Controls:Add(this-object:maskedTextBoxValidityCertif).
    this-object:groupBox2:Controls:Add(this-object:label12).
    this-object:groupBox2:Controls:Add(this-object:maskedTextBoxCertifFuel).
    this-object:groupBox2:Controls:Add(this-object:label11).
    this-object:groupBox2:Controls:Add(this-object:label10).
    this-object:groupBox2:Controls:Add(this-object:label9).
    this-object:groupBox2:Controls:Add(this-object:maskedTextBoxNumPassport).
    this-object:groupBox2:Controls:Add(this-object:maskedTextBoxNormDoc).
    this-object:groupBox2:Location = new System.Drawing.Point(10, 95).
    this-object:groupBox2:Name = "groupBox2".
    this-object:groupBox2:Size = new System.Drawing.Size(682, 155).
    this-object:groupBox2:TabIndex = 1.
    this-object:groupBox2:TabStop = false.
    this-object:groupBox2:UseCompatibleTextRendering = true.
    /*  */
    /* buttonCopySec */
    /*  */
    this-object:buttonCopySec:Location = new System.Drawing.Point(595, 120).
    this-object:buttonCopySec:Name = "buttonCopySec".
    this-object:buttonCopySec:Size = new System.Drawing.Size(75, 29).
    this-object:buttonCopySec:TabIndex = 13.
    this-object:buttonCopySec:Text = "Копировать в секцию".
    this-object:buttonCopySec:UseCompatibleTextRendering = true.
    this-object:buttonCopySec:UseVisualStyleBackColor = true.
    this-object:buttonCopySec:Click:Subscribe(this-object:buttonCopySec_Click).
    /*  */
    /* maskedTextBoxValidityCertif */
    /*  */
    this-object:maskedTextBoxValidityCertif:Location = new System.Drawing.Point(420, 123).
    this-object:maskedTextBoxValidityCertif:Name = "maskedTextBoxValidityCertif".
    this-object:maskedTextBoxValidityCertif:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxValidityCertif:TabIndex = 12.
    /*  */
    /* label12 */
    /*  */
    this-object:label12:Location = new System.Drawing.Point(8, 120).
    this-object:label12:Name = "label12".
    this-object:label12:Size = new System.Drawing.Size(406, 29).
    this-object:label12:TabIndex = 14.
    this-object:label12:Text = "Срок действия сертификата соответствия завода-изготовителя (на марку моторного топлива) из паспорта качества:".
    this-object:label12:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label12:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxCertifFuel */
    /*  */
    this-object:maskedTextBoxCertifFuel:Location = new System.Drawing.Point(7, 97).
    this-object:maskedTextBoxCertifFuel:Name = "maskedTextBoxCertifFuel".
    this-object:maskedTextBoxCertifFuel:Size = new System.Drawing.Size(663, 20).
    this-object:maskedTextBoxCertifFuel:TabIndex = 11.
    /*  */
    /* label11 */
    /*  */
    this-object:label11:Location = new System.Drawing.Point(8, 77).
    this-object:label11:Name = "label11".
    this-object:label11:Size = new System.Drawing.Size(664, 20).
    this-object:label11:TabIndex = 15.
    this-object:label11:Text = "Сертификат соответствия завода-изготовителя (на марку моторного топлива) № :".
    this-object:label11:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label11:UseCompatibleTextRendering = true.
    /*  */
    /* label10 */
    /*  */
    this-object:label10:Location = new System.Drawing.Point(7, 34).
    this-object:label10:Name = "label10".
    this-object:label10:Size = new System.Drawing.Size(664, 20).
    this-object:label10:TabIndex = 16.
    this-object:label10:Text = "Нормативный документ завода-изготовителя (ГОСТ, ТУ на марку моторного топлива) из паспорта качества:".
    this-object:label10:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label10:UseCompatibleTextRendering = true.
    /*  */
    /* label9 */
    /*  */
    this-object:label9:Location = new System.Drawing.Point(6, 13).
    this-object:label9:Name = "label9".
    this-object:label9:Size = new System.Drawing.Size(108, 20).
    this-object:label9:TabIndex = 17.
    this-object:label9:Text = "Паспорт качества:".
    this-object:label9:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label9:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNumPassport */
    /*  */
    this-object:maskedTextBoxNumPassport:Location = new System.Drawing.Point(120, 12).
    this-object:maskedTextBoxNumPassport:Name = "maskedTextBoxNumPassport".
    this-object:maskedTextBoxNumPassport:Size = new System.Drawing.Size(552, 20).
    this-object:maskedTextBoxNumPassport:TabIndex = 9.
    /*  */
    /* maskedTextBoxNormDoc */
    /*  */
    this-object:maskedTextBoxNormDoc:Location = new System.Drawing.Point(8, 55).
    this-object:maskedTextBoxNormDoc:Name = "maskedTextBoxNormDoc".
    this-object:maskedTextBoxNormDoc:Size = new System.Drawing.Size(663, 20).
    this-object:maskedTextBoxNormDoc:TabIndex = 10.
    /*  */
    /* groupBox1 */
    /*  */
    this-object:groupBox1:AccessibleName = "".
    this-object:groupBox1:Controls:Add(this-object:label8).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxAccShip).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxSecName).
    this-object:groupBox1:Controls:Add(this-object:label7).
    this-object:groupBox1:Controls:Add(this-object:label6).
    this-object:groupBox1:Controls:Add(this-object:label5).
    this-object:groupBox1:Controls:Add(this-object:label4).
    this-object:groupBox1:Controls:Add(this-object:label3).
    this-object:groupBox1:Controls:Add(this-object:label2).
    this-object:groupBox1:Controls:Add(this-object:label1).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxCliQnty).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxDiameter).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxDocQnty).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxCarVol).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxTTNTemp).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxDocDens).
    this-object:groupBox1:Location = new System.Drawing.Point(10, 3).
    this-object:groupBox1:Name = "groupBox1".
    this-object:groupBox1:Size = new System.Drawing.Size(682, 86).
    this-object:groupBox1:TabIndex = 0.
    this-object:groupBox1:TabStop = false.
    this-object:groupBox1:UseCompatibleTextRendering = true.
    /*  */
    /* label8 */
    /*  */
    this-object:label8:Location = new System.Drawing.Point(474, 10).
    this-object:label8:Name = "label8".
    this-object:label8:Size = new System.Drawing.Size(95, 20).
    this-object:label8:TabIndex = 0.
    this-object:label8:Text = "Погр. изм. пост.:".
    this-object:label8:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label8:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxAccShip */
    /*  */
    this-object:maskedTextBoxAccShip:Location = new System.Drawing.Point(575, 10).
    this-object:maskedTextBoxAccShip:Name = "maskedTextBoxAccShip".
    this-object:maskedTextBoxAccShip:Size = new System.Drawing.Size(97, 20).
    this-object:maskedTextBoxAccShip:TabIndex = 3.
    this-object:maskedTextBoxAccShip:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_2).
    /*  */
    /* maskedTextBoxSecName */
    /*  */
    this-object:maskedTextBoxSecName:Location = new System.Drawing.Point(148, 10).
    this-object:maskedTextBoxSecName:Name = "maskedTextBoxSecName".
    this-object:maskedTextBoxSecName:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxSecName:TabIndex = 1.
    this-object:maskedTextBoxSecName:KeyPress:Subscribe(this-object:KeyPressMaskTBInt).
    this-object:maskedTextBoxSecName:Leave:Subscribe(this-object:maskedTextBoxSecName_Leave).
    /*  */
    /* label7 */
    /*  */
    this-object:label7:Location = new System.Drawing.Point(17, 10).
    this-object:label7:Name = "label7".
    this-object:label7:Size = new System.Drawing.Size(126, 20).
    this-object:label7:TabIndex = 4.
    this-object:label7:Text = "Номер секции:".
    this-object:label7:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label7:UseCompatibleTextRendering = true.
    /*  */
    /* label6 */
    /*  */
    this-object:label6:Location = new System.Drawing.Point(255, 61).
    this-object:label6:Name = "label6".
    this-object:label6:Size = new System.Drawing.Size(112, 20).
    this-object:label6:TabIndex = 5.
    this-object:label6:Text = "Размер горловины:".
    this-object:label6:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label6:UseCompatibleTextRendering = true.
    /*  */
    /* label5 */
    /*  */
    this-object:label5:Location = new System.Drawing.Point(247, 11).
    this-object:label5:Name = "label5".
    this-object:label5:Size = new System.Drawing.Size(120, 20).
    this-object:label5:TabIndex = 6.
    this-object:label5:Text = "Температура по ТТН:".
    this-object:label5:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label5:UseCompatibleTextRendering = true.
    /*  */
    /* label4 */
    /*  */
    this-object:label4:Location = new System.Drawing.Point(55, 35).
    this-object:label4:Name = "label4".
    this-object:label4:Size = new System.Drawing.Size(88, 20).
    this-object:label4:TabIndex = 7.
    this-object:label4:Text = "Масса по док.:".
    this-object:label4:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label4:UseCompatibleTextRendering = true.
    /*  */
    /* label3 */
    /*  */
    this-object:label3:Location = new System.Drawing.Point(483, 35).
    this-object:label3:Name = "label3".
    this-object:label3:Size = new System.Drawing.Size(86, 20).
    this-object:label3:TabIndex = 8.
    this-object:label3:Text = "Кол-во по док.:".
    this-object:label3:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label3:UseCompatibleTextRendering = true.
    /*  */
    /* label2 */
    /*  */
    this-object:label2:Location = new System.Drawing.Point(17, 61).
    this-object:label2:Name = "label2".
    this-object:label2:Size = new System.Drawing.Size(126, 20).
    this-object:label2:TabIndex = 9.
    this-object:label2:Text = "Объем по паспорту, л:".
    this-object:label2:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label2:UseCompatibleTextRendering = true.
    /*  */
    /* label1 */
    /*  */
    this-object:label1:Location = new System.Drawing.Point(262, 35).
    this-object:label1:Name = "label1".
    this-object:label1:Size = new System.Drawing.Size(105, 20).
    this-object:label1:TabIndex = 10.
    this-object:label1:Text = "Плотность по док.:".
    this-object:label1:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label1:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxCliQnty */
    /*  */
    this-object:maskedTextBoxCliQnty:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxCliQnty:Location = new System.Drawing.Point(149, 35).
    this-object:maskedTextBoxCliQnty:Name = "maskedTextBoxCliQnty".
    this-object:maskedTextBoxCliQnty:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxCliQnty:TabIndex = 4.
    this-object:maskedTextBoxCliQnty:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
/*    this-object:maskedTextBoxCliQnty:Leave:Subscribe(this-object:CalcDoc).*/
    /*  */
    /* maskedTextBoxDiameter */
    /*  */
    this-object:maskedTextBoxDiameter:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxDiameter:Location = new System.Drawing.Point(373, 58).
    this-object:maskedTextBoxDiameter:Name = "maskedTextBoxDiameter".
    this-object:maskedTextBoxDiameter:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxDiameter:TabIndex = 8.
    this-object:maskedTextBoxDiameter:Leave:Subscribe(this-object:calc-weight-vol).
    /*  */
    /* maskedTextBoxDocQnty */
    /*  */
    this-object:maskedTextBoxDocQnty:Location = new System.Drawing.Point(575, 34).
    this-object:maskedTextBoxDocQnty:Name = "maskedTextBoxDocQnty".
    this-object:maskedTextBoxDocQnty:Size = new System.Drawing.Size(97, 20).
    this-object:maskedTextBoxDocQnty:TabIndex = 6.
    this-object:maskedTextBoxDocQnty:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
/*    this-object:maskedTextBoxDocQnty:Leave:Subscribe(this-object:CalcDoc).*/
    /*  */
    /* maskedTextBoxCarVol */
    /*  */
    this-object:maskedTextBoxCarVol:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxCarVol:Location = new System.Drawing.Point(149, 61).
    this-object:maskedTextBoxCarVol:Name = "maskedTextBoxCarVol".
    this-object:maskedTextBoxCarVol:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxCarVol:TabIndex = 7.
    this-object:maskedTextBoxCarVol:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    this-object:maskedTextBoxCarVol:Leave:Subscribe(this-object:calc-weight-vol).
    /*  */
    /* maskedTextBoxTTNTemp */
    /*  */
    this-object:maskedTextBoxTTNTemp:Location = new System.Drawing.Point(373, 11).
    this-object:maskedTextBoxTTNTemp:Name = "maskedTextBoxTTNTemp".
    this-object:maskedTextBoxTTNTemp:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTTNTemp:TabIndex = 2.
    this-object:maskedTextBoxTTNTemp:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimalNegNum_2_1).
    /*  */
    /* maskedTextBoxDocDens */
    /*  */
    this-object:maskedTextBoxDocDens:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxDocDens:Location = new System.Drawing.Point(373, 34).
    this-object:maskedTextBoxDocDens:Name = "maskedTextBoxDocDens".
    this-object:maskedTextBoxDocDens:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxDocDens:TabIndex = 5.
    this-object:maskedTextBoxDocDens:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_4).
/*    this-object:maskedTextBoxDocDens:Leave:Subscribe(this-object:CalcDoc).*/
    /*  */
    /* groupBox7 */
    /*  */
    this-object:groupBox7:Controls:Add(this-object:textBoxPlSiName).
    this-object:groupBox7:Controls:Add(this-object:dateTimePickerDatePovPlotn).
    this-object:groupBox7:Controls:Add(this-object:buttonCopy).
    this-object:groupBox7:Controls:Add(this-object:label38).
    this-object:groupBox7:Controls:Add(this-object:maskedTextBoxPassportPlotn).
    this-object:groupBox7:Controls:Add(this-object:label37).
    this-object:groupBox7:Controls:Add(this-object:label36).
    this-object:groupBox7:Controls:Add(this-object:maskedTextBoxNumPlot).
    this-object:groupBox7:Controls:Add(this-object:buttonPlSi).
    this-object:groupBox7:Controls:Add(this-object:maskedTextBoxPlaceSi).
    this-object:groupBox7:Controls:Add(this-object:label26).
    this-object:groupBox7:Location = new System.Drawing.Point(10, 402).
    this-object:groupBox7:Name = "groupBox7".
    this-object:groupBox7:Size = new System.Drawing.Size(682, 97).
    this-object:groupBox7:TabIndex = 3.
    this-object:groupBox7:TabStop = false.
    this-object:groupBox7:UseCompatibleTextRendering = true.
    /*  */
    /* textBoxPlSiName */
    /*  */
    this-object:textBoxPlSiName:Enabled = false.
    this-object:textBoxPlSiName:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:textBoxPlSiName:Location = new System.Drawing.Point(255, 17).
    this-object:textBoxPlSiName:Name = "textBoxPlSiName".
    this-object:textBoxPlSiName:Size = new System.Drawing.Size(265, 20).
    this-object:textBoxPlSiName:TabIndex = 0.
    /*  */
    /* dateTimePickerDatePovPlotn */
    /*  */
    this-object:dateTimePickerDatePovPlotn:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:dateTimePickerDatePovPlotn:Location = new System.Drawing.Point(148, 69).
    this-object:dateTimePickerDatePovPlotn:Name = "dateTimePickerDatePovPlotn".
    this-object:dateTimePickerDatePovPlotn:Size = new System.Drawing.Size(81, 20).
    this-object:dateTimePickerDatePovPlotn:TabIndex = 28.
    /*  */
    /* buttonCopy */
    /*  */
    this-object:buttonCopy:Location = new System.Drawing.Point(595, 30).
    this-object:buttonCopy:Name = "buttonCopy".
    this-object:buttonCopy:Size = new System.Drawing.Size(75, 23).
    this-object:buttonCopy:TabIndex = 32.
    this-object:buttonCopy:Text = "Копировать".
    this-object:buttonCopy:UseCompatibleTextRendering = true.
    this-object:buttonCopy:UseVisualStyleBackColor = true.
    this-object:buttonCopy:Click:Subscribe(this-object:buttonCopy_Click).
    /*  */
    /* label38 */
    /*  */
    this-object:label38:Location = new System.Drawing.Point(271, 68).
    this-object:label38:Name = "label38".
    this-object:label38:Size = new System.Drawing.Size(143, 20).
    this-object:label38:TabIndex = 33.
    this-object:label38:Text = "Паспорт полтномера №:".
    this-object:label38:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label38:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxPassportPlotn */
    /*  */
    this-object:maskedTextBoxPassportPlotn:Location = new System.Drawing.Point(420, 69).
    this-object:maskedTextBoxPassportPlotn:Name = "maskedTextBoxPassportPlotn".
    this-object:maskedTextBoxPassportPlotn:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxPassportPlotn:TabIndex = 29.
    /*  */
    /* label37 */
    /*  */
    this-object:label37:Location = new System.Drawing.Point(58, 69).
    this-object:label37:Name = "label37".
    this-object:label37:Size = new System.Drawing.Size(86, 20).
    this-object:label37:TabIndex = 34.
    this-object:label37:Text = "Дата поверки:".
    this-object:label37:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label37:UseCompatibleTextRendering = true.
    /*  */
    /* label36 */
    /*  */
    this-object:label36:Location = new System.Drawing.Point(9, 43).
    this-object:label36:Name = "label36".
    this-object:label36:Size = new System.Drawing.Size(135, 20).
    this-object:label36:TabIndex = 35.
    this-object:label36:Text = "Номер:".
    this-object:label36:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label36:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNumPlot */
    /*  */
    this-object:maskedTextBoxNumPlot:Location = new System.Drawing.Point(148, 43).
    this-object:maskedTextBoxNumPlot:Name = "maskedTextBoxNumPlot".
    this-object:maskedTextBoxNumPlot:Size = new System.Drawing.Size(372, 20).
    this-object:maskedTextBoxNumPlot:TabIndex = 27.
    /*  */
    /* buttonPlSi */
    /*  */
    this-object:buttonPlSi:Location = new System.Drawing.Point(191, 16).
    this-object:buttonPlSi:Name = "buttonPlSi".
    this-object:buttonPlSi:Size = new System.Drawing.Size(57, 23).
    this-object:buttonPlSi:TabIndex = 26.
    this-object:buttonPlSi:Text = "Выбор".
    this-object:buttonPlSi:UseCompatibleTextRendering = true.
    this-object:buttonPlSi:UseVisualStyleBackColor = true.
    this-object:buttonPlSi:Click:Subscribe(this-object:buttonPlSi_Click).
    /*  */
    /* maskedTextBoxPlaceSi */
    /*  */
    this-object:maskedTextBoxPlaceSi:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxPlaceSi:Location = new System.Drawing.Point(148, 17).
    this-object:maskedTextBoxPlaceSi:Name = "maskedTextBoxPlaceSi".
    this-object:maskedTextBoxPlaceSi:Size = new System.Drawing.Size(37, 20).
    this-object:maskedTextBoxPlaceSi:TabIndex = 25.
    this-object:maskedTextBoxPlaceSi:Leave:Subscribe(this-object:maskedTextBoxPlaceSiHndler).
    /*  */
    /* label26 */
    /*  */
    this-object:label26:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label26:ForeColor = System.Drawing.Color:Red.
    this-object:label26:Location = new System.Drawing.Point(7, 16).
    this-object:label26:Name = "label26".
    this-object:label26:Size = new System.Drawing.Size(135, 20).
    this-object:label26:TabIndex = 36.
    this-object:label26:Text = "Средство измерения:".
    this-object:label26:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label26:UseCompatibleTextRendering = true.
    /*  */
    /* groupBox6 */
    /*  */
    this-object:groupBox6:Controls:Add(this-object:maskedTextBoxNumPrintProb).
    this-object:groupBox6:Controls:Add(this-object:label35).
    this-object:groupBox6:Controls:Add(this-object:maskedTextBoxTests).
    this-object:groupBox6:Controls:Add(this-object:label34).
    this-object:groupBox6:Controls:Add(this-object:maskedTextBoxKolProb).
    this-object:groupBox6:Controls:Add(this-object:label33).
    this-object:groupBox6:Controls:Add(this-object:DateTimeDateProb).
    this-object:groupBox6:Controls:Add(this-object:label32).
    this-object:groupBox6:Controls:Add(this-object:TimeProb).
    this-object:groupBox6:Controls:Add(this-object:label31).
    this-object:groupBox6:Location = new System.Drawing.Point(10, 644).
    this-object:groupBox6:Name = "groupBox6".
    this-object:groupBox6:Size = new System.Drawing.Size(682, 68).
    this-object:groupBox6:TabIndex = 6.
    this-object:groupBox6:TabStop = false.
    this-object:groupBox6:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNumPrintProb */
    /*  */
    this-object:maskedTextBoxNumPrintProb:Location = new System.Drawing.Point(391, 14).
    this-object:maskedTextBoxNumPrintProb:Name = "maskedTextBoxNumPrintProb".
    this-object:maskedTextBoxNumPrintProb:Size = new System.Drawing.Size(41, 20).
    this-object:maskedTextBoxNumPrintProb:TabIndex = 40.
    /*  */
    /* label35 */
    /*  */
    this-object:label35:Location = new System.Drawing.Point(9, 14).
    this-object:label35:Name = "label35".
    this-object:label35:Size = new System.Drawing.Size(135, 20).
    this-object:label35:TabIndex = 41.
    this-object:label35:Text = "Номер пробы:".
    this-object:label35:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label35:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxTests */
    /*  */
    this-object:maskedTextBoxTests:Location = new System.Drawing.Point(149, 15).
    this-object:maskedTextBoxTests:Name = "maskedTextBoxTests".
    this-object:maskedTextBoxTests:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTests:TabIndex = 39.
    /*  */
    /* label34 */
    /*  */
    this-object:label34:Location = new System.Drawing.Point(9, 39).
    this-object:label34:Name = "label34".
    this-object:label34:Size = new System.Drawing.Size(135, 20).
    this-object:label34:TabIndex = 42.
    this-object:label34:Text = "Кол-во пробы (л):".
    this-object:label34:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label34:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxKolProb */
    /*  */
    this-object:maskedTextBoxKolProb:Location = new System.Drawing.Point(149, 40).
    this-object:maskedTextBoxKolProb:Name = "maskedTextBoxKolProb".
    this-object:maskedTextBoxKolProb:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxKolProb:TabIndex = 42.
    this-object:maskedTextBoxKolProb:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_2_2).
    /*  */
    /* label33 */
    /*  */
    this-object:label33:Location = new System.Drawing.Point(458, 12).
    this-object:label33:Name = "label33".
    this-object:label33:Size = new System.Drawing.Size(125, 20).
    this-object:label33:TabIndex = 43.
    this-object:label33:Text = "Дата отбора пробы:".
    this-object:label33:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label33:UseCompatibleTextRendering = true.
    /*  */
    /* DateTimeDateProb */
    /*  */
    this-object:DateTimeDateProb:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:DateTimeDateProb:Location = new System.Drawing.Point(589, 12).
    this-object:DateTimeDateProb:Name = "DateTimeDateProb".
    this-object:DateTimeDateProb:Size = new System.Drawing.Size(81, 20).
    this-object:DateTimeDateProb:TabIndex = 41.
    /*  */
    /* label32 */
    /*  */
    this-object:label32:Location = new System.Drawing.Point(463, 40).
    this-object:label32:Name = "label32".
    this-object:label32:Size = new System.Drawing.Size(120, 20).
    this-object:label32:TabIndex = 44.
    this-object:label32:Text = "Время отбора пробы:".
    this-object:label32:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label32:UseCompatibleTextRendering = true.
    /*  */
    /* TimeProb */
    /*  */
    this-object:TimeProb:CustomFormat = "".
    this-object:TimeProb:Format = System.Windows.Forms.DateTimePickerFormat:Time.
    this-object:TimeProb:Location = new System.Drawing.Point(589, 39).
    this-object:TimeProb:Name = "TimeProb".
    this-object:TimeProb:ShowUpDown = true.
    this-object:TimeProb:Size = new System.Drawing.Size(50, 20).
    this-object:TimeProb:TabIndex = 43.
    /*  */
    /* label31 */
    /*  */
    this-object:label31:Location = new System.Drawing.Point(255, 14).
    this-object:label31:Name = "label31".
    this-object:label31:Size = new System.Drawing.Size(130, 20).
    this-object:label31:TabIndex = 45.
    this-object:label31:Text = "Номер печати (пробы):".
    this-object:label31:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label31:UseCompatibleTextRendering = true.
    /*  */
    /* groupBox5 */
    /*  */
    this-object:groupBox5:Controls:Add(this-object:dateTimePickerTimeEnd).
    this-object:groupBox5:Controls:Add(this-object:dateTimePickerTimeStart).
    this-object:groupBox5:Controls:Add(this-object:dateTimePickerDateEnd).
    this-object:groupBox5:Controls:Add(this-object:dateTimePickerDateStart).
    this-object:groupBox5:Controls:Add(this-object:label30).
    this-object:groupBox5:Controls:Add(this-object:label29).
    this-object:groupBox5:Controls:Add(this-object:label28).
    this-object:groupBox5:Controls:Add(this-object:label27).
    this-object:groupBox5:Location = new System.Drawing.Point(10, 574).
    this-object:groupBox5:Name = "groupBox5".
    this-object:groupBox5:Size = new System.Drawing.Size(682, 64).
    this-object:groupBox5:TabIndex = 5.
    this-object:groupBox5:TabStop = false.
    this-object:groupBox5:UseCompatibleTextRendering = true.
    /*  */
    /* dateTimePickerTimeEnd */
    /*  */
    this-object:dateTimePickerTimeEnd:CustomFormat = "".
    this-object:dateTimePickerTimeEnd:Format = System.Windows.Forms.DateTimePickerFormat:Time.
    this-object:dateTimePickerTimeEnd:Location = new System.Drawing.Point(373, 37).
    this-object:dateTimePickerTimeEnd:Name = "dateTimePickerTimeEnd".
    this-object:dateTimePickerTimeEnd:ShowUpDown = true.
    this-object:dateTimePickerTimeEnd:Size = new System.Drawing.Size(50, 20).
    this-object:dateTimePickerTimeEnd:TabIndex = 38.
    /*  */
    /* dateTimePickerTimeStart */
    /*  */
    this-object:dateTimePickerTimeStart:CustomFormat = "".
    this-object:dateTimePickerTimeStart:Format = System.Windows.Forms.DateTimePickerFormat:Time.
    this-object:dateTimePickerTimeStart:Location = new System.Drawing.Point(373, 10).
    this-object:dateTimePickerTimeStart:Name = "dateTimePickerTimeStart".
    this-object:dateTimePickerTimeStart:ShowUpDown = true.
    this-object:dateTimePickerTimeStart:Size = new System.Drawing.Size(50, 20).
    this-object:dateTimePickerTimeStart:TabIndex = 36.
    /*  */
    /* dateTimePickerDateEnd */
    /*  */
    this-object:dateTimePickerDateEnd:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:dateTimePickerDateEnd:Location = new System.Drawing.Point(150, 37).
    this-object:dateTimePickerDateEnd:Name = "dateTimePickerDateEnd".
    this-object:dateTimePickerDateEnd:Size = new System.Drawing.Size(81, 20).
    this-object:dateTimePickerDateEnd:TabIndex = 37.
    /*  */
    /* dateTimePickerDateStart */
    /*  */
    this-object:dateTimePickerDateStart:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:dateTimePickerDateStart:Location = new System.Drawing.Point(150, 10).
    this-object:dateTimePickerDateStart:Name = "dateTimePickerDateStart".
    this-object:dateTimePickerDateStart:Size = new System.Drawing.Size(81, 20).
    this-object:dateTimePickerDateStart:TabIndex = 35.
    /*  */
    /* label30 */
    /*  */
    this-object:label30:Location = new System.Drawing.Point(255, 37).
    this-object:label30:Name = "label30".
    this-object:label30:Size = new System.Drawing.Size(112, 20).
    this-object:label30:TabIndex = 39.
    this-object:label30:Text = "Время конца слива:".
    this-object:label30:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label30:UseCompatibleTextRendering = true.
    /*  */
    /* label29 */
    /*  */
    this-object:label29:Location = new System.Drawing.Point(249, 10).
    this-object:label29:Name = "label29".
    this-object:label29:Size = new System.Drawing.Size(118, 20).
    this-object:label29:TabIndex = 40.
    this-object:label29:Text = "Время начала слива:".
    this-object:label29:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label29:UseCompatibleTextRendering = true.
    /*  */
    /* label28 */
    /*  */
    this-object:label28:Location = new System.Drawing.Point(8, 36).
    this-object:label28:Name = "label28".
    this-object:label28:Size = new System.Drawing.Size(135, 20).
    this-object:label28:TabIndex = 41.
    this-object:label28:Text = "Дата конца слива:".
    this-object:label28:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label28:UseCompatibleTextRendering = true.
    /*  */
    /* label27 */
    /*  */
    this-object:label27:Location = new System.Drawing.Point(7, 10).
    this-object:label27:Name = "label27".
    this-object:label27:Size = new System.Drawing.Size(135, 20).
    this-object:label27:TabIndex = 42.
    this-object:label27:Text = "Дата начала слива:".
    this-object:label27:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label27:UseCompatibleTextRendering = true.
    /*  */
    /* groupBox4 */
    /*  */
    this-object:groupBox4:Controls:Add(this-object:buttonCalcWeight).
    this-object:groupBox4:Controls:Add(this-object:label25).
    this-object:groupBox4:Controls:Add(this-object:label24).
    this-object:groupBox4:Controls:Add(this-object:label23).
    this-object:groupBox4:Controls:Add(this-object:label22).
    this-object:groupBox4:Controls:Add(this-object:maskedTextBoxTankDensityPomi).
    this-object:groupBox4:Controls:Add(this-object:maskedTextBoxTankVolPomi).
    this-object:groupBox4:Controls:Add(this-object:maskedTextBoxTankWeight).
    this-object:groupBox4:Controls:Add(this-object:maskedTextBoxAccWeight).
    this-object:groupBox4:Location = new System.Drawing.Point(10, 505).
    this-object:groupBox4:Name = "groupBox4".
    this-object:groupBox4:Size = new System.Drawing.Size(682, 63).
    this-object:groupBox4:TabIndex = 4.
    this-object:groupBox4:TabStop = false.
    this-object:groupBox4:UseCompatibleTextRendering = true.
    /*  */
    /* buttonCalcWeight */
    /*  */
    this-object:buttonCalcWeight:Location = new System.Drawing.Point(595, 19).
    this-object:buttonCalcWeight:Name = "buttonCalcWeight".
    this-object:buttonCalcWeight:Size = new System.Drawing.Size(75, 23).
    this-object:buttonCalcWeight:TabIndex = 34.
    this-object:buttonCalcWeight:Text = "Рассчитать".
    this-object:buttonCalcWeight:UseCompatibleTextRendering = true.
    this-object:buttonCalcWeight:UseVisualStyleBackColor = true.
    this-object:buttonCalcWeight:Click:Subscribe(this-object:buttonCalcWeight_Click).
    /*  */
    /* label25 */
    /*  */
    this-object:label25:ForeColor = System.Drawing.SystemColors:HotTrack.
    this-object:label25:Location = new System.Drawing.Point(271, 8).
    this-object:label25:Name = "label25".
    this-object:label25:Size = new System.Drawing.Size(96, 20).
    this-object:label25:TabIndex = 35.
    this-object:label25:Text = "Масса топлива:".
    this-object:label25:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label25:UseCompatibleTextRendering = true.
    /*  */
    /* label24 */
    /*  */
    this-object:label24:ForeColor = System.Drawing.SystemColors:HotTrack.
    this-object:label24:Location = new System.Drawing.Point(266, 33).
    this-object:label24:Name = "label24".
    this-object:label24:Size = new System.Drawing.Size(101, 20).
    this-object:label24:TabIndex = 36.
    this-object:label24:Text = "Погр.изм.массы:".
    this-object:label24:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label24:UseCompatibleTextRendering = true.
    /*  */
    /* label23 */
    /*  */
    this-object:label23:ForeColor = System.Drawing.SystemColors:HotTrack.
    this-object:label23:Location = new System.Drawing.Point(9, 9).
    this-object:label23:Name = "label23".
    this-object:label23:Size = new System.Drawing.Size(135, 20).
    this-object:label23:TabIndex = 37.
    this-object:label23:Text = "Плотность приведенная:".
    this-object:label23:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label23:UseCompatibleTextRendering = true.
    /*  */
    /* label22 */
    /*  */
    this-object:label22:ForeColor = System.Drawing.SystemColors:HotTrack.
    this-object:label22:Location = new System.Drawing.Point(9, 34).
    this-object:label22:Name = "label22".
    this-object:label22:Size = new System.Drawing.Size(135, 20).
    this-object:label22:TabIndex = 38.
    this-object:label22:Text = "Объем топлива привед.:".
    this-object:label22:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label22:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxTankDensityPomi */
    /*  */
    this-object:maskedTextBoxTankDensityPomi:Location = new System.Drawing.Point(150, 9).
    this-object:maskedTextBoxTankDensityPomi:Name = "maskedTextBoxTankDensityPomi".
    this-object:maskedTextBoxTankDensityPomi:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankDensityPomi:TabIndex = 30.
    /*  */
    /* maskedTextBoxTankVolPomi */
    /*  */
    this-object:maskedTextBoxTankVolPomi:Location = new System.Drawing.Point(150, 34).
    this-object:maskedTextBoxTankVolPomi:Name = "maskedTextBoxTankVolPomi".
    this-object:maskedTextBoxTankVolPomi:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankVolPomi:TabIndex = 32.
    this-object:maskedTextBoxTankVolPomi:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* tanksection */
    /*  */
    this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
    this-object:BackgroundImage = cast(resources:GetObject("$this.BackgroundImage"), System.Drawing.Image).
    this-object:Controls:Add(this-object:groupBox1).
    this-object:Controls:Add(this-object:groupBox2).
    this-object:Controls:Add(this-object:groupBox3).
    this-object:Controls:Add(this-object:groupBox7).
    this-object:Controls:Add(this-object:groupBox4).
    this-object:Controls:Add(this-object:groupBox5).
    this-object:Controls:Add(this-object:groupBox6).
    this-object:Name = "tanksection".
    this-object:Size = new System.Drawing.Size(700, 720).
    this-object:groupBox3:ResumeLayout(false).
    this-object:groupBox3:PerformLayout().
    this-object:groupBox2:ResumeLayout(false).
    this-object:groupBox2:PerformLayout().
    this-object:groupBox1:ResumeLayout(false).
    this-object:groupBox1:PerformLayout().
    this-object:groupBox7:ResumeLayout(false).
    this-object:groupBox7:PerformLayout().
    this-object:groupBox6:ResumeLayout(false).
    this-object:groupBox6:PerformLayout().
    this-object:groupBox5:ResumeLayout(false).
    this-object:groupBox4:ResumeLayout(false).
    this-object:groupBox4:PerformLayout().
    this-object:ResumeLayout(false).
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
  end method.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void EnableChangedMaskTBox( input sender as System.Object, input e as System.EventArgs ):
    
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void maskedTextBoxPlaceSiHndler( input sender as System.Object, input e as System.EventArgs ):
    
    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).

    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecsObj:InfoSectionCurr:PlaceSi = integer (v-maskTextBox:Text).
    textBoxPlSiName:Text = infoSecsObj:InfoSectionCurr:PlSiName.
    v-maskTextBox:Text = string(infoSecsObj:InfoSectionCurr:PlaceSi). /* если не удачно вернется старое значение*/.

    
    return.

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void maskedTextBoxSecName_Leave( input sender as System.Object, input e as System.EventArgs ):
    def var ii as int no-undo.
    
    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).
    
    v-maskTextBox:Text = left-trim (v-maskTextBox:Text, "0").
    
    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecsObj:InfoSectionCurr:UserMode = true.

    infoSecsObj:InfoSectionCurr:SectionName = maskedTextBoxSecName:Text.
    
    
    if not infoSecsObj:CheckNameSec(idSecTabPage, v-maskTextBox:Text)
    then do:
      message "Такой номер уже есть." view-as alert-box title "Сообщение".
      v-maskTextBox:Text = "".
      v-maskTextBox:Focus().
      return.
    end.
    
    infoSecsObj:GetInfoSectionProp(idSecTabPage).    
    maskedTextBoxDiameter:Text = infoSecsObj:InfoSectionCurr:Diameter.
    /*if infoSecsObj:DocQntyInput
      then maskedTextBoxDocQnty:Text = format_round_3(infoSecsObj:InfoSectionCurr:DocQnty).*/
    maskedTextBoxCarVol:Text = format_round_3(infoSecsObj:InfoSectionCurr:CarVol).
    tanksecsObj:SetSecName (v-maskTextBox:Text).

    return.

  end method.

  method private void SetControls ():

    def var infoSecObj as class InfoSection no-undo.
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecObj:UserMode = true.
    
    this-object:maskedTextBoxSecName:Text         = infoSecObj:SectionName.
    this-object:maskedTextBoxCarVol:Text          = format_round_3 (infoSecObj:CarVol).
    this-object:maskedTextBoxDocDens:Text         = format_dens (infoSecObj:DocDensity).
    this-object:maskedTextBoxDocQnty:Text         = format_round_3 (infoSecObj:DocQnty).
    this-object:maskedTextBoxTTNTemp:Text         = if infoSecObj:TTNTemp = ? then "" else format_temper (infoSecObj:TTNTemp).
    this-object:maskedTextBoxAccShip:Text         = format_round_3 (infoSecObj:AccShip).
    this-object:maskedTextBoxDiameter:Text        = (infoSecObj:Diameter).
    this-object:maskedTextBoxCliQnty:Text         = format_round_3 (infoSecObj:CliQnty).
    this-object:maskedTextBoxNumPassport:Text     = (infoSecObj:NumPassport).
    this-object:maskedTextBoxNormDoc:Text         = (infoSecObj:NormDoc).
    this-object:maskedTextBoxCertifFuel:Text      = (infoSecObj:CertifFuel).
    this-object:maskedTextBoxValidityCertif:Text  = (infoSecObj:ValidityCertif).
    this-object:maskedTextBoxABTArir:Text         = format_round_3 (infoSecObj:ABTarir).
    this-object:maskedTextBoxMouth:Text           = format_round_3 (infoSecObj:Mouth).
    this-object:maskedTextBoxTankVol:Text         = format_round_3 (infoSecObj:TankVol).
    this-object:maskedTextBoxTankDens:Text        = format_dens (infoSecObj:TankDensity).
    this-object:maskedTextBoxNaturLoss:Text       = format_round_3 (infoSecObj:NaturalLoss).
    this-object:maskedTextBoxTPNorm:Text          = format_int (integer (infoSecObj:TPNorm)).
    this-object:maskedTextBoxTankWater:Text       = format_round_3 (infoSecObj:TankWater).
    this-object:maskedTextBoxTankTemp:Text        = if infoSecObj:TankTemp = ? then "" else format_temper (infoSecObj:TankTemp).
    this-object:maskedTextBoxDensTemp:Text        = if infoSecObj:DensTemp = ? then "" else format_temper (infoSecObj:DensTemp).
    this-object:maskedTextBoxListTank:Text        = (infoSecObj:ListTank).
    this-object:maskedTextBoxPlaceSi:Text         = format_int (infoSecObj:PlaceSi).
    this-object:maskedTextBoxNumPlot:Text         = (infoSecObj:NumPlotn).
    this-object:maskedTextBoxPassportPlotn:Text   = (infoSecObj:PassportPlotn).
    this-object:maskedTextBoxTests:Text           = (infoSecObj:Tests).
    this-object:maskedTextBoxKolProb:Text         = format_round_3 (infoSecObj:KolProb).
    this-object:maskedTextBoxNumPrintProb:Text    = (infoSecObj:NumPrintProb).
    this-object:textBoxPlSiName:Text              =  infoSecObj:PlSiName.

    this-object:maskedTextBoxAccWeight:Text       = format_round_3 (infoSecObj:AccPomi).
    this-object:maskedTextBoxTankDensityPomi:Text = format_dens (infoSecObj:TankDensityPomi).
    this-object:maskedTextBoxTankVolPomi:Text     = format_round_3 (infoSecObj:TankVolPomi).
    this-object:maskedTextBoxTankWeight:Text      = format_round_3 (infoSecObj:TankWeight).

    this-object:TimeProb:Text                     = string (infoSecObj:HourProb) + ":" + string (infoSecObj:MinProb) + ":00" no-error.
    if error-status:error or string (infoSecObj:HourProb) + string (infoSecObj:MinProb) = "" or string (infoSecObj:HourProb) + string (infoSecObj:MinProb) = ?
      then 
    do:
      blank_datetime (TimeProb).
    end.
    
    this-object:dateTimePickerDatePovPlotn:Text   = string (infoSecObj:DatePovPlotn) no-error.
    if error-status:error or infoSecObj:DatePovPlotn = ?
      then 
    do:
      blank_datetime (dateTimePickerDatePovPlotn).
    end.
    this-object:dateTimePickerDateStart:Text      = string (infoSecObj:DateStart) no-error.
    if error-status:error or infoSecObj:DateStart = ?
      then 
    do:
      blank_datetime (dateTimePickerDateStart).
    end.
    this-object:dateTimePickerDateEnd:Text        = string (infoSecObj:DateEnd) no-error.
    if error-status:error or infoSecObj:DateEnd = ?
      then 
    do:
      blank_datetime (dateTimePickerDateEnd).
    end.
    this-object:dateTimePickerTimeStart:Text      = GetTimeStr(infoSecObj:TimeStart) no-error.
    if error-status:error or infoSecObj:TimeStart = ? or infoSecObj:TimeStart = 0
      then 
    do:
      blank_datetime (dateTimePickerTimeStart).
    end.
    this-object:dateTimePickerTimeEnd:Text        = GetTimeStr(infoSecObj:TimeEnd) no-error.
    if error-status:error or infoSecObj:TimeEnd = ? or infoSecObj:TimeEnd = 0
      then 
    do:
      blank_datetime (dateTimePickerTimeEnd).
    end.
    this-object:DateTimeDateProb:Text             = string (infoSecObj:DateProb) no-error.
    if error-status:error or infoSecObj:DateProb = ?
      then 
    do:
      blank_datetime (DateTimeDateProb).
    end.
    
    catch e as Progress.Lang.AppError:
      undo, throw e.
    end catch.
    
  end.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimal_5_3( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimal (sender, e, 5, 3).

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimal_2_2( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimal (sender, e, 2, 2).

  end method.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimal_1_2( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimal (sender, e, 1, 2).

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimalNegNum_5_2( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimalNegativeNum (sender, e, 5, 2).

  end method.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimalNegNum_2_2( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimalNegativeNum (sender, e, 2, 2).

  end method.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimalNegNum_2_1( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimalNegativeNum (sender, e, 2, 1).

  end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimal_1_4( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimal (sender, e, 1, 4).

  end method.  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBInt( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBInt (sender, e, 9).

  end method.  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBIntNegNum_2( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBIntNegativeNum (sender, e, 2).

  end method.  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBInt( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs, maxLenthInt as int):  
    
    def var v-asc as int no-undo.
    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    def var startcursor as int no-undo.    
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).
        
    startcursor = v-maskTextBox:SelectionStart.

    e:Handled = true.
    e:Handled = not isSpecKey(e:KeyChar).
    if not e:Handled
      then return.
    

    e:Handled = not isNumeral(e:KeyChar).
    if not e:Handled 
    then do:
      
      if length (v-maskTextBox:Text) < maxLenthInt
      then do:
        return.
      end.
      else do:
        if length (v-maskTextBox:Text) > maxLenthInt - 1
        then do:
          v-maskTextBox:Text = substring (v-maskTextBox:Text, 1, length (v-maskTextBox:Text) - 1 ).
          if v-maskTextBox:Text = ""
            then v-maskTextBox:Text = "0".
          if startcursor = maxLenthInt
            then startcursor = startcursor - 1.
        end.
        v-maskTextBox:Text = this-object:ValueChgToInt (v-maskTextBox:Text, maxLenthInt, input-output startcursor).          
      end.

      
      v-maskTextBox:SelectionStart = startcursor.
    end.

  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBIntNegativeNum( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs, maxLenthInt as int):

    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    def var startcursor as int no-undo.    
    
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).    
    startcursor = v-maskTextBox:SelectionStart.
    
    if index (v-maskTextBox:Text, "-") > 0 and startcursor = 0
      then startcursor = 1.
    
    if (e:KeyChar) = "-"
    then do:
      if index (v-maskTextBox:Text, "-") > 0
        then do:
          v-maskTextBox:Text = replace (v-maskTextBox:Text, "-", "").
          v-maskTextBox:SelectionStart = startcursor - 1.
          e:Handled = true.
        end.
        else do:
          v-maskTextBox:Text = "-" + v-maskTextBox:Text.
          v-maskTextBox:SelectionStart = startcursor + 1.
          e:Handled = true.
        end.
    end.
    else do:
      if index (v-maskTextBox:Text, "-") > 0
      then do:
        v-maskTextBox:Text = replace (v-maskTextBox:Text, "-", "").
        v-maskTextBox:SelectionStart = startcursor - 1.
        KeyPressMaskTBInt(sender, e, maxLenthInt).
        startcursor = v-maskTextBox:SelectionStart.
        v-maskTextBox:Text = "-" + v-maskTextBox:Text.
        v-maskTextBox:SelectionStart = startcursor + 1.        
      end.
      else do:
        KeyPressMaskTBInt(sender, e, maxLenthInt).
      end.
    end.
    
    
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimalNegativeNum( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs, maxLenthInt as int, maxLenthFractional as int):

    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    def var startcursor as int no-undo.    
    
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).    
    startcursor = v-maskTextBox:SelectionStart.
    
    if index (v-maskTextBox:Text, "-") > 0 and startcursor = 0
      then startcursor = 1.
    
    if (e:KeyChar) = "-"
    then do:
      if index (v-maskTextBox:Text, "-") > 0
        then do:
          v-maskTextBox:Text = replace (v-maskTextBox:Text, "-", "").
          v-maskTextBox:SelectionStart = startcursor - 1.
          e:Handled = true.
        end.
        else do:
          v-maskTextBox:Text = "-" + v-maskTextBox:Text.
          v-maskTextBox:SelectionStart = startcursor + 1.
          e:Handled = true.
        end.
    end.
    else do:
      if index (v-maskTextBox:Text, "-") > 0
      then do:
        v-maskTextBox:Text = replace (v-maskTextBox:Text, "-", "").
        v-maskTextBox:SelectionStart = startcursor - 1.
        KeyPressMaskTBDecimal(sender, e, maxLenthInt, maxLenthFractional).
        startcursor = v-maskTextBox:SelectionStart.
        v-maskTextBox:Text = "-" + v-maskTextBox:Text.
        v-maskTextBox:SelectionStart = startcursor + 1.        
      end.
      else do:
        KeyPressMaskTBDecimal(sender, e, maxLenthInt, maxLenthFractional).
      end.
      
      
    end.
    
    
  end.
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void KeyPressMaskTBDecimal( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs, maxLenthInt as int, maxLenthFractional as int ):
    
    def var v-asc as int no-undo.
    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    def var startcursor as int no-undo.    
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).
        
    startcursor = v-maskTextBox:SelectionStart.
    

    e:Handled = true.
    e:Handled = not isSpecKey(e:KeyChar).
    if not e:Handled
      then return.
    if asc (e:KeyChar) = 46
    then do:
      e:Handled = not isOnePoint(v-maskTextBox:Text).
      if not e:Handled
        then do:
          return.
        end.
      v-maskTextBox:SelectionStart = index (v-maskTextBox:Text, ".").
      return.
    end. 

    if isNumeral(e:KeyChar)
    then do:
      e:Handled = false.
      if not e:Handled
      then do:
        
    
    
        if startcursor = 0 and v-maskTextBox:Text begins "0"
        then do:
          v-maskTextBox:Text = substring (v-maskTextBox:Text, 2, length (v-maskTextBox:Text) - 1 ).
          v-maskTextBox:SelectionStart = 0.
          return.
        end.
        
        if startcursor <> 0 and startcursor = index (v-maskTextBox:Text, ".") - 1
          then startcursor = startcursor + 1.
        if (length (entry (1, v-maskTextBox:Text, ".")) < maxLenthInt or startcursor < index (v-maskTextBox:Text, ".") ) and (index (v-maskTextBox:Text, ".") = 0 or startcursor <= index (v-maskTextBox:Text, ".") or startcursor = 0) 
        then do:
          if length (entry (1, v-maskTextBox:Text, ".")) < maxLenthInt
            then return.
          v-maskTextBox:Text = this-object:ValueChgToInt (v-maskTextBox:Text, maxLenthInt, input-output startcursor).
        end.
        else do:
          if index (v-maskTextBox:Text, ".") = 0
          then do:
            v-maskTextBox:Text = v-maskTextBox:Text + '.'.
            startcursor = startcursor + 1.
          end.
          if startcursor < index (v-maskTextBox:Text, ".")
            then do: 
              v-maskTextBox:SelectionStart = index (v-maskTextBox:Text, ".").
              startcursor = v-maskTextBox:SelectionStart.
            end.
          v-maskTextBox:Text = this-object:ValueChgToFractional (v-maskTextBox:Text, maxLenthFractional, input-output startcursor).
        end.
        
      end.
      v-maskTextBox:SelectionStart = startcursor.
    end.
    
  end.
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private logical isSpecKey ( input arg as char):
    
    def var v-asc as int no-undo.
    
    v-asc = asc(arg).
    
    if lookup (string (v-asc), "13,8") = 0
    then do:
      return false.
    end.
    return true.
    
  end.
  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private logical isOnePoint (input tBoxText as char):
    
    if index (tBoxText, ".") > 0
      then do:
        return false.
      end.
    return true.
    
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private logical isNumeral ( input arg as char):
    if not ( asc (arg) >= 48 and asc (arg) <= 57) 
    then do:
      return false.
    end. 
    return true.
  end.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
/*  @VisualDesigner.                                                                                       */
/*  method private void ValueChgMaskTBox_5_3( input sender as System.Object, input e as System.EventArgs ):*/
/*    def var v-asc as int no-undo.                                       */
/*    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.*/
/*    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).   */
/*    v-maskTextBox:Text = ValueChgTo5_3 (v-maskTextBox:Text).            */
/*    return.                                                             */

/*  end method.*/
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private char ValueChgToInt( input arg as char, maxLenthInt as int, input-output pStartcursor as int ):
  
    def var v-str as char extent 2 no-undo.
    def var v-cursor as int no-undo.
    
    v-cursor = pStartcursor.
        
    v-str[1] = entry (1, arg, ".").
    
    if num-entries (arg, ".") = 2
    then do:
      v-str[2] = entry (2, arg, ".").
    end.
    
    if length (v-str[1]) > maxLenthInt - 1
    then do:
      v-str[1] = substring (v-str[1], 1, length (v-str[1]) - 1 ).
      v-cursor = v-cursor - 1.
      return v-str[1] + "." + v-str[2].
    end.
    pStartcursor = v-cursor.
    return arg.

  
  end.
  
  /*Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private char ValueChgToFractional( input arg as char, maxLenthFractional as int, input-output pStartcursor as int  ):
  
    def var v-str as char extent 2 no-undo.
    def var v-cursor as int no-undo.
    v-cursor = pStartcursor.
    
    v-str[1] = entry (1, arg, ".").
    if num-entries (arg, ".") = 2
    then do:
      v-str[2] = entry (2, arg, ".").
    end.
    
    if length (v-str[2]) > maxLenthFractional - 1
    then do:
      v-str[2] = substring (v-str[2], 1, length (v-str[2]) - 1 ).
      v-cursor = v-cursor - 1.
      return v-str[1] + "." + v-str[2].
    end.
    pStartcursor = v-cursor.
    return arg.
  
  end.
  
  
  method private void ValueChgMaskTBox( input sender as System.Object, input e as System.EventArgs ):
    
    def var v-asc as int no-undo.
    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    def var v-str as char extent 2 no-undo.
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).
    
    v-str[1] = entry (1, v-maskTextBox:Text, ".").
    if num-entries (v-maskTextBox:Text, ".") = 2
    then do:
      v-str[2] = entry (2, v-maskTextBox:Text, ".").
    end.
    
    if length (v-str[1]) > 10
    then do:
      v-str[1] = substring (v-str[1], 1, length (v-str[1]) - 1 ).
    end.
    
    if length (v-str[2]) > 3
    then do:
      v-str[2] = substring (v-str[2], 1, length (v-str[2]) - 1 ).
    end.
    v-maskTextBox:Text = v-str[1] + "." + v-str[2].
    return.     

  end method.
  
  
  method public void SetInfoSec ():
    
    def var infoSecObj as class InfoSection no-undo.
    
    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    
    infoSecObj = infoSecsObj:InfoSectionCurr.

    infoSecObj:SectionName = (this-object:maskedTextBoxSecName:Text).                        
    infoSecObj:CarVol          = decimal(this-object:maskedTextBoxCarVol:Text).          
    infoSecObj:DocDensity      = decimal(this-object:maskedTextBoxDocDens:Text).         
    infoSecObj:DocQnty         = decimal(this-object:maskedTextBoxDocQnty:Text).         
    infoSecObj:TTNTemp         = (if trim (this-object:maskedTextBoxTTNTemp:Text) = "" then ? else decimal(this-object:maskedTextBoxTTNTemp:Text) ).         
    infoSecObj:AccShip         = decimal(this-object:maskedTextBoxAccShip:Text).         
    infoSecObj:Diameter        = (this-object:maskedTextBoxDiameter:Text).        
    infoSecObj:CliQnty         = decimal(this-object:maskedTextBoxCliQnty:Text).         
    infoSecObj:NumPassport     = (this-object:maskedTextBoxNumPassport:Text).     
    infoSecObj:NormDoc         = (this-object:maskedTextBoxNormDoc:Text).         
    infoSecObj:CertifFuel      = (this-object:maskedTextBoxCertifFuel:Text).      
    infoSecObj:ValidityCertif  = (this-object:maskedTextBoxValidityCertif:Text).  
    infoSecObj:ABTarir         = if trim (this-object:maskedTextBoxABTArir:Text) = "" then ? else decimal(this-object:maskedTextBoxABTArir:Text).         
    infoSecObj:Mouth           = decimal(this-object:maskedTextBoxMouth:Text).           
    infoSecObj:TankVol         = decimal(this-object:maskedTextBoxTankVol:Text).         
    infoSecObj:TankDensity     = decimal(this-object:maskedTextBoxTankDens:Text).        
    infoSecObj:NaturalLoss     = decimal(this-object:maskedTextBoxNaturLoss:Text).       
    infoSecObj:TankWater       = decimal(this-object:maskedTextBoxTankWater:Text).       
    infoSecObj:TankTemp        = (if trim (this-object:maskedTextBoxTankTemp:Text) = "" then ? else decimal(this-object:maskedTextBoxTankTemp:Text) ).        
    infoSecObj:DensTemp        = (if trim (this-object:maskedTextBoxDensTemp:Text) = "" then ? else decimal(this-object:maskedTextBoxDensTemp:Text) ).        
    infoSecObj:ListTank        = (this-object:maskedTextBoxListTank:Text).        
    infoSecObj:PlaceSi         = decimal(this-object:maskedTextBoxPlaceSi:Text).         
    infoSecObj:NumPlotn        = (this-object:maskedTextBoxNumPlot:Text).         
    infoSecObj:PassportPlotn   = (this-object:maskedTextBoxPassportPlotn:Text).   
    infoSecObj:TankDensityPomi = decimal(this-object:maskedTextBoxTankDensityPomi:Text). 
    infoSecObj:TankVolPomi     = decimal(this-object:maskedTextBoxTankVolPomi:Text).     
    infoSecObj:TankWeight      = decimal(this-object:maskedTextBoxTankWeight:Text).      
    infoSecObj:AccPomi         = decimal(this-object:maskedTextBoxAccWeight:Text).       
    infoSecObj:Tests           = (this-object:maskedTextBoxTests:Text).           
    infoSecObj:KolProb         = decimal(this-object:maskedTextBoxKolProb:Text).         
    infoSecObj:NumPrintProb    = (this-object:maskedTextBoxNumPrintProb:Text).    

    infoSecObj:DateProb        = date ((this-object:DateTimeDateProb:Text)).
    infoSecObj:DateStart       = date ((this-object:dateTimePickerDateStart:Text)).
    infoSecObj:DateEnd         = date ((this-object:dateTimePickerDateEnd:Text)).
    infoSecObj:TimeStart       = GetTimeInt((this-object:dateTimePickerTimeStart:Text)).
    infoSecObj:TimeEnd         = GetTimeInt((this-object:dateTimePickerTimeEnd:Text)).
    infoSecObj:DatePovPlotn    = date ((this-object:dateTimePickerDatePovPlotn:Text)).
    
    if num-entries (this-object:TimeProb:Text, ":") >= 2
    then do:
      infoSecObj:HourProb = integer (entry (1, this-object:TimeProb:Text, ":")).
      infoSecObj:MinProb  = integer (entry (2, this-object:TimeProb:Text, ":")).
    end.
    else do:
      infoSecObj:HourProb = ?.
      infoSecObj:MinProb = ?.
    end.
    
 
  end.
  
  
  method private void CalcDoc ( input sender as System.Object, input e as System.EventArgs ):
    def var a as dec no-undo.
    def var b as dec no-undo.
    def var c as dec no-undo.
    
    a = decimal (maskedTextBoxDocQnty:Text) no-error.
    b = decimal (maskedTextBoxDocDens:Text) no-error.
    c = decimal (maskedTextBoxCliQnty:Text) no-error.
    
    if not infoSecsObj:CliQntyInput
      then do: 
        this-object:maskedTextBoxCliQnty:Text = format_round_3(a * b) no-error.  
      end.
    if not infoSecsObj:DocQntyInput
      then do: 
        this-object:maskedTextBoxDocQnty:Text = format_round_3(c / b) no-error.
      end.
    if not infoSecsObj:DensityInput
      then do: 
        this-object:maskedTextBoxDocDens:Text = format_dens(c / a) no-error.
      end.
    
  end.
  
  method private char format_round_3 (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 3), "->>>>>>>>9.999")).
    return str.
  end.

  method private char format_int (arg as integer):
    def var str as char no-undo.
    str = string (arg).
    return str. 
  end.

  method private char format_dens (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 4), "9.9999")) no-error.
    if error-status:error
      then return "".
    return str.
  end.
  
  method private char format_temper (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 1), "->>9.9")).
    return str.
  end.
  
  
  
  method private void blank_datetime (arg as DateTimePicker):
    arg:visible = true.
    arg:Format = DateTimePickerFormat:Custom.
    arg:CustomFormat = "    " .
  end.

  method private char GetTimeStr (arg as int):
    def var v-str as char no-undo.
    def var v-str-2 as char no-undo.
    v-str-2 = string (integer( truncate( arg / 3600 , 0 ) )) no-error.
    if error-status:error
      then return "".
    
    v-str = v-str-2 + ":" + string (integer( ( arg - integer (v-str-2) * 3600 ) / 60 )) + ":00" no-error.
    if error-status:error
      then return "".
    return v-str.
    
  end.

  method private int GetTimeInt (arg as char):
    
    def var v-int as int no-undo.
    
    if arg <> "" and num-entries (arg, ":") >= 2
    then do:
      v-int = integer (entry (1, arg, ":")) * 3600 + integer (entry (2, arg, ":")) * 60 no-error.
      if not error-status:error
        then return v-int. 
    end.
    return ?.

    
  end.  

  method private void calc-weight-vol ( input sender as System.Object, input e as System.EventArgs ):
  
    define variable v-area as decimal no-undo.

    if not infoSecsObj:FlagTrn 
      then return.
    
    maskedTextBoxMouth:Text = string (decimal (maskedTextBoxMouth:Text)) no-error.
    
    /*  assign                                                                              */
    /*    maskedTextBoxMouth:Text = string (decimal (maskedTextBoxMouth:Text))              */
    /*    maskedTextBoxMouth:Text:screen-value  = string (decimal (maskedTextBoxMouth:Text))*/
    /*    no-error.                                                                         */
    if error-status:error then 
    do:
      assign
        v-area = decimal (entry (1,maskedTextBoxDiameter:Text, "/")) * decimal (entry (2,maskedTextBoxDiameter:Text, "/")) * 0.000001
      no-error.
      if error-status:error then 
      do:
        message "Неверно указан размер горловины (либо значение диаметра, либо значение сторон для прямоугольной горловины в виде a/b). Берется по умолчанию 0" view-as alert-box.
        maskedTextBoxDiameter:Text = "0".
        v-area = 0.
      end.
    end.
    else 
    do:
      v-area = 3.14159 * decimal (maskedTextBoxDiameter:Text) * decimal (maskedTextBoxDiameter:Text) * 0.000001 / 4 no-error.
    end.
     
    maskedTextBoxMouth:Text = string (   round (decimal (maskedTextBoxABTArir:Text) * v-area, 2) ) .
    
    /*  if maskedTextBoxMouth:Text <> decimal (maskedTextBoxMouth:Text) then      */
    /*    apply "value-changed" to maskedTextBoxMouth:Text in frame {&FRAME-NAME}.*/
      
    maskedTextBoxTankVol:Text = format_round_3 (decimal (maskedTextBoxCarVol:Text) + decimal (maskedTextBoxMouth:Text) - decimal(maskedTextBoxTankWater:Text)).

    if infoSecsObj:RdcDnstvalue = "not" then 
    do:
      maskedTextBoxTankWeight:Text = format_round_3 (decimal(maskedTextBoxTankVol:Text) * decimal ( maskedTextBoxTankDens:Text)).
    end.
    else 
    do:
      if infoSecsObj:RdcDnstvalue = "pomi-rn" or infoSecsObj:RdcDnstvalue = "th" then 
      do :
        /*      display input frame {&frame-name} maskedTextBoxTankWeight:Text /                                                      */
        /*        input frame {&frame-name} maskedTextBoxTankVol:Text-pomi @ maskedTextBoxTankDens:Text-pomi with frame {&frame-name}.*/
        assign
          maskedTextBoxTankDensityPomi:Text = format_dens (decimal (maskedTextBoxTankWeight:Text) / decimal (maskedTextBoxTankVolPomi:Text)).
      end.
      else 
      do:
    
        maskedTextBoxTankWeight:Text = format_round_3 (decimal(maskedTextBoxTankVolPomi:Text) * decimal ( maskedTextBoxTankDensityPomi:Text)).  
      
      /*    display input frame {&frame-name} maskedTextBoxTankVol:Text-pomi *                                                  */
      /*      input frame {&frame-name} maskedTextBoxTankDens:Text-pomi @ maskedTextBoxTankWeight:Text with frame {&frame-name}.*/
      end.
    end.

  end method.

  method public void SetForcus ():
    
    if infoSecsObj:FlagTrn
    then do:
      maskedTextBoxTankDensityPomi:Text = "".
      maskedTextBoxTankVolPomi:Text = "".
      maskedTextBoxTankWeight:Text = "".
      maskedTextBoxAccWeight:Text = "".
    end.
    
    setFocusMaskTextDoc:Focus().
    
  end.

  method public void ClWght ( input sender as System.Object, input e as System.EventArgs ):
    maskedTextBoxTankDensityPomi:Text = "".
    maskedTextBoxTankVolPomi:Text = "".
    maskedTextBoxTankWeight:Text = "".
    maskedTextBoxAccWeight:Text = "".
  end.

  method public logical CheckSec ():
    
    def var v-dec as decimal no-undo.
    def var v-str as character no-undo.
    
    v-str = "Не заполенено обязательное поле ".
    
    if infoSecsObj:FlagTrn
    then do:
      
      
      if not infoSecsObj:RdcDnstvalue = "not"
      then do:
        v-dec = decimal (maskedTextBoxDiameter:Text) no-error.
        if trim (maskedTextBoxDiameter:Text) = ""
        then do:
          ShowMsg( v-str + "размер горловины" ).
          setFocusMaskTextDoc = maskedTextBoxDiameter.
          return false.
        end.
        
        v-dec = decimal (maskedTextBoxCarVol:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          ShowMsg( v-str + "объем по паспорту" ).
          setFocusMaskTextDoc = maskedTextBoxCarVol.
          return false.
        end.
  
        if trim (maskedTextBoxABTArir:Text) = ""
        then do:
          ShowMsg( v-str + "уровень цистерны отност. тарировочной пл." ).
          setFocusMaskTextDoc = maskedTextBoxABTArir.
          return false.
        end.
  
        v-dec = decimal (maskedTextBoxTankDens:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          ShowMsg( v-str + "плотность топлива" ).
          setFocusMaskTextDoc = maskedTextBoxTankDens.
          return false.
        end.
        
        v-dec = decimal (maskedTextBoxTankTemp:Text) no-error.
        if (error-status:error or trim (maskedTextBoxTankTemp:Text) = "")
        then do:
          ShowMsg( v-str + "температура замера объема" ).
          setFocusMaskTextDoc = maskedTextBoxTankTemp.
          return false.
        end.
        
        v-dec = decimal (maskedTextBoxDensTemp:Text) no-error.
        if (error-status:error or trim (maskedTextBoxDensTemp:Text) = "")
        then do:
          ShowMsg( v-str + "температура замера плотности" ).
          setFocusMaskTextDoc = maskedTextBoxDensTemp.
          return false.
        end.
        
        v-dec = decimal (maskedTextBoxPlaceSi:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          ShowMsg( v-str + "средство измерения" ).
          setFocusMaskTextDoc = maskedTextBoxPlaceSi.
          return false.
        end.
      end.
      else do:
        v-dec = decimal (maskedTextBoxDiameter:Text) no-error.
        if trim (maskedTextBoxDiameter:Text) = ""
        then do:
          ShowMsg( v-str + "размер горловины" ).
          setFocusMaskTextDoc = maskedTextBoxDiameter.
          return false.
        end.
        
        v-dec = decimal (maskedTextBoxCarVol:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          ShowMsg( v-str + "объем по паспорту" ).
          setFocusMaskTextDoc = maskedTextBoxCarVol.
          return false.
        end.
  
        if trim (maskedTextBoxABTArir:Text) = ""
        then do:
          ShowMsg( v-str + "уровень цистерны отност. тарировочной пл." ).
          setFocusMaskTextDoc = maskedTextBoxABTArir.
          return false.
        end.
  
        v-dec = decimal (maskedTextBoxTankDens:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          ShowMsg( v-str + "плотность топлива" ).
          setFocusMaskTextDoc = maskedTextBoxTankDens.
          return false.
        end.
        
        v-dec = decimal (maskedTextBoxDensTemp:Text) no-error.
        if (error-status:error or trim (maskedTextBoxDensTemp:Text) = "")
        then do:
          ShowMsg( v-str + "температура замера плотности" ).
          setFocusMaskTextDoc = maskedTextBoxDensTemp.
          return false.
        end.

      end.
      
    end.
    else do:

      if trim (maskedTextBoxSecName:Text) = "" or int (maskedTextBoxSecName:Text) = 0
      then do:
        ShowMsg( v-str + "номер секции" ).
        setFocusMaskTextDoc = maskedTextBoxSecName.
        return false.
      end.
      
      
      v-dec = decimal (maskedTextBoxDocQnty:Text) no-error.
      if (error-status:error or v-dec = 0) and infoSecsObj:DocQntyInput
      then do:
        ShowMsg( v-str + "кол-во по документу" ).
        setFocusMaskTextDoc = maskedTextBoxDocQnty.
        return false.
      end.

      v-dec = decimal (maskedTextBoxCliQnty:Text) no-error.
      if (error-status:error or v-dec = 0) and infoSecsObj:CliQntyInput
      then do:
        ShowMsg( v-str + "масса по документу" ).
        setFocusMaskTextDoc = maskedTextBoxCliQnty.
        return false.
      end.
      
      v-dec = decimal (maskedTextBoxDocDens:Text) no-error.
      if ( error-status:error or v-dec = 0) and infoSecsObj:DensityInput
      then do:
        ShowMsg( v-str + "плотность по документу" ).
        setFocusMaskTextDoc = maskedTextBoxDocDens.
        return false.
      end.
    end.
    
  end.


  method private void ShowMsg (arg as char):
    
    message arg view-as alert-box information title "Сообщение".
  
  end.

  destructor public tanksection ( ):

  end destructor.

end class.


