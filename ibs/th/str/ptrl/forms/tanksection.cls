 
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
using ibs.th.gbl.gbl-var from propath.
block-level on error undo, throw.
&global-define list-shape "Без горловины,Квадратная/прямоугольная,Эллиптическая,Круглая"
&global-define list-shape-num 4

class ibs.th.str.ptrl.forms.tanksection inherits UserControl: 
  
  { cmp/str-glbl.i class}
  { cmp/library.i  class}
  { str/lib-rvs.i  class}
  { str/rvsttdef.i rvs  }
  
  define temp-table tt-section no-undo 
      field dif     as integer
      field volume1 as decimal
      index pi dif
      .
  
  define property idSecTabPage as integer no-undo
    get.
    private set.
  
  define private variable bRvsAft as System.Windows.Forms.Button no-undo.
  define private variable bRvsBef as System.Windows.Forms.Button no-undo.
  define private variable button1 as System.Windows.Forms.Button no-undo.
  define private variable buttonCalcResultRvs as System.Windows.Forms.Button no-undo.
  define private variable buttonCalcResultAC as System.Windows.Forms.Button no-undo.
  define private variable buttonCalcWeightRvs as System.Windows.Forms.Button no-undo.
  define private variable buttonCopyPSTemp as System.Windows.Forms.Button no-undo.
  define private variable buttonPl as System.Windows.Forms.Button no-undo.
  define private variable buttonPlSiTemp as System.Windows.Forms.Button no-undo.
  define private variable cbKPnoMeas as System.Windows.Forms.CheckBox no-undo.
  define private variable cbSGDKK as System.Windows.Forms.CheckBox no-undo.
  define private variable comboBoxGroupNP as System.Windows.Forms.ComboBox no-undo.
  define private variable comboBoxPour as System.Windows.Forms.ComboBox no-undo.
  define private variable comboBoxShape as System.Windows.Forms.ComboBox no-undo.
  define private variable dateTimePickerDatePovTemp as System.Windows.Forms.DateTimePicker no-undo.
  define private variable groupBox8 as System.Windows.Forms.GroupBox no-undo.
  define private variable groupBox9 as System.Windows.Forms.GroupBox no-undo.
  define public variable infoSecsObj  as class ibs.th.str.InfoSectionsTotal no-undo.
  
  define private variable label43 as System.Windows.Forms.Label no-undo.
  define private variable label42 as System.Windows.Forms.Label no-undo.
  define private variable label41 as System.Windows.Forms.Label no-undo.
  define private variable label40 as System.Windows.Forms.Label no-undo.
  define private variable label49 as System.Windows.Forms.Label no-undo.
  define private variable label51 as System.Windows.Forms.Label no-undo.
  define private variable maskedTextBoxAukKey as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable label50 as System.Windows.Forms.Label no-undo.
  define private variable maskedTextBoxDocVolume as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable label48 as System.Windows.Forms.Label no-undo.
  define private variable maskedTextBoxPaspDens as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable maskedTextBoxDocDensST as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable label47 as System.Windows.Forms.Label no-undo.
  define private variable label46 as System.Windows.Forms.Label no-undo.
  define private variable label45 as System.Windows.Forms.Label no-undo.
  define private variable label44 as System.Windows.Forms.Label no-undo.
  define private variable maskedTextBoxPassportTemp as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable maskedTextBoxNumTemp as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable maskedTextBoxPlaceSiTemp as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable maskedTextBoxPressure as System.Windows.Forms.MaskedTextBox no-undo.
  define private variable tanksecsObj as class ibs.th.str.ptrl.forms.tanksections no-undo. 
  
  
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
  define private variable textBoxPlSiNameTemp as System.Windows.Forms.TextBox no-undo.
  define private variable TimeProb                     as System.Windows.Forms.DateTimePicker no-undo.

  define private variable setFocusMaskTextDoc          as System.Windows.Forms.MaskedTextBox  no-undo.

  
  define private variable DateTimePickerDateArr        as System.Windows.Forms.DateTimePicker extent 5 no-undo.
  define private variable DateTimePickerTimeArr        as System.Windows.Forms.DateTimePicker extent 3 no-undo.
  
  define private variable maskedTextBoxArr             as System.Windows.Forms.MaskedTextBox  extent 18 no-undo.
  
  define private variable maskedTextBoxDocArr          as System.Windows.Forms.MaskedTextBox  extent 10 no-undo.
  
  define private variable maskedTextBoxOnlyReadOnlyArr as System.Windows.Forms.MaskedTextBox  extent 9 no-undo.
  
  define private variable menuItemRvsAft1 as System.Windows.Forms.MenuItem no-undo .
  define private variable menuItemRvsAft2 as System.Windows.Forms.MenuItem no-undo .
  define private variable menuItemRvsAft3 as System.Windows.Forms.MenuItem no-undo .
  
  define private variable menuItemRvsBef1 as System.Windows.Forms.MenuItem no-undo .
  define private variable menuItemRvsBef2 as System.Windows.Forms.MenuItem no-undo .
  define private variable menuItemRvsBef3 as System.Windows.Forms.MenuItem no-undo .
  
  define private variable rvslog as logical no-undo.
  define private variable list-pl as character no-undo .
  define private variable v-tank-weight-rvs as decimal no-undo .
  define private variable v-tank-vol-pomi-rvs as decimal no-undo .

  define variable v-dop-volume as decimal no-undo.
  define variable var-list-shape as character no-undo init {&list-shape}.
  
  define variable v-sec-fields  as character no-undo .
  
  define variable v-cli-qnty    as decimal no-undo .
  define variable v-doc-qnty    as decimal no-undo .
  define variable v-doc-density as decimal no-undo .
    
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
	method private void bRvsBef_MouseClick( input sender as System.Object, input e as System.Windows.Forms.MouseEventArgs ):
		
		if infoSecsObj:Mode = {&lookup}
    then do :
      ActionRvsSec
        ( input {&lookup}
         ,input "edit":U
         ,input {&rvs-before-doc}
        ) no-error .
      if error-status :error then do:
        return  .
      end.
    end .
    else do :
      bRvsBef:ContextMenu = new ContextMenu() .
      menuItemRvsBef1 = new System.Windows.Forms.MenuItem("Сверка резервуара") .
      menuItemRvsBef2 = new System.Windows.Forms.MenuItem("Просмотр") .
      menuItemRvsBef3 = new System.Windows.Forms.MenuItem("Редактирование") .
      bRvsBef:ContextMenu:MenuItems:Add(menuItemRvsBef1) .
      bRvsBef:ContextMenu:MenuItems:Add(menuItemRvsBef2) .
      bRvsBef:ContextMenu:MenuItems:Add(menuItemRvsBef3) .
      menuItemRvsBef1:Click:Subscribe(onClickRvsBef1) .
      menuItemRvsBef2:Click:Subscribe(onClickRvsBef2) .
      menuItemRvsBef3:Click:Subscribe(onClickRvsBef3) .
      bRvsBef:ContextMenu:Show(bRvsBef, new System.Drawing.Point(e:X, e:Y)) .
      
    end .
    
    return.

	end method.
  
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void buttonCalcResultAC_Click( input sender as System.Object, input e as System.EventArgs ):
		define variable infoSecObj as class ibs.th.str.InfoSection no-undo .
    
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage) . 
    
    if infoSecObj:TankWeight = ?
    or infoSecObj:TankWeight <= 0
    then do :
      if infoSecObj:AccMeth = 0
      then do :
        message 'Расчёт не выполнен. Нажмите кнопку "Рассчитать по замерам в АЦ" и повторите.' view-as alert-box .
      end .
      return no-apply .
    end .
    
    run str/pomi-resultAC.w (input-output infoSecObj) .
    
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void buttonCalcResultRvs_Click( input sender as System.Object, input e as System.EventArgs ):
		define variable infoSecObj as class ibs.th.str.InfoSection no-undo .
    
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage) . 
    v-tank-weight-rvs = infoSecObj:TankWeightRvs .
    
    if v-tank-weight-rvs = ?
    or v-tank-weight-rvs <= 0
    then do :
      if infoSecObj:AccMeth = 1
      then do :
        message 'Расчёт не выполнен. Нажмите кнопку "Рассчитать по данным сверок" и повторите.' view-as alert-box .
      end .
      else do :
        message 'Расчёт будет выполнен при сохранении данных по строке, при условии заполненности сверок.' view-as alert-box .
      end .
      return no-apply .
    end .
    
    run str/pomi-result.w (input-output infoSecObj) .
  
		return.

	end method.



	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void buttonCalcWeightRvs_Click( input sender as System.Object, input e as System.EventArgs ):
		define variable v-new-sec-fact-qnty-kg as decimal no-undo .
    define variable v-calc-density as decimal no-undo .
    define variable infoSecObj as class ibs.th.str.InfoSection no-undo .
  
		infoSecsObj:CalcPomiRvs(input idSecTabPage,
		                        input infoSecsObj:TrnDocNum,
		                        input infoSecsObj:GdsCode,
		                        input-output infoSecsObj,
		                        output v-tank-weight-rvs,
		                        output v-tank-vol-pomi-rvs) .
		
		v-calc-density = v-tank-weight-rvs / v-tank-vol-pomi-rvs .
		if v-calc-density = ?
    or v-calc-density <= 0
    or v-calc-density >= 1
    then do :
      message substitute("По результатам рассчёта модуля ПОкМИ плотность выходит за допустимые значения!&1Масса, кг: &2&1Объём, л: &3", {&new-line}, v-tank-weight-rvs, v-tank-vol-pomi-rvs)
      view-as alert-box error .
      return .
    end .
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage) .                   
    infoSecsObj:RNAlgo (integer(infoSecObj:SectionName), output v-new-sec-fact-qnty-kg).     
    if infoSecObj:IsKP
    then do :
      label51:Visible = true .
    end .   
    infoSecObj:FactQnty = v-new-sec-fact-qnty-kg / v-calc-density .
    infoSecObj:FactDensity = v-calc-density .
    infoSecsObj:SaveDB() .
    infoSecsObj:GetDBAllAttr() .
                          
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void cbKPnoMeas_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
		
		define variable v-log as logical no-undo .
		
		if cbKPnoMeas:Checked
    then do :
      message "При установке флага «Переход к комиссионному приему НП без замеров секции АЦ» будет активирован комиссионный прием. Продолжить?"
      view-as alert-box question buttons yes-no update v-log .
      if not v-log
      then do :
        cbKPnoMeas:checked = no .
      end .
    end .
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void maskedTextBoxAukKey_Leave( input sender as System.Object, input e as System.EventArgs ):
		def var ii as int no-undo.
    
    do ii = 1 to extent (tanksecsObj:tankSectionControl):
      if not valid-object (tanksecsObj:tankSectionControl[ii]) or tanksecsObj:tankSectionControl[ii]:idSecTabPage = this-object:idSecTabPage 
        then next.

      tanksecsObj:tankSectionControl[ii]:GetAukKey(maskedTextBoxAukKey:Text, cbSGDKK:Checked).  

    end.
    
		return.

	end method.

  @VisualDesigner.
  method private void onClickRvsBef1 ( input sender as System.Object, input e as System.EventArgs ) :
    
    define variable v-sec as character no-undo .
    define variable infoSecObj as class InfoSection no-undo .
    
    define buffer buf_rvs-doc for ub.rvs-doc .
    define buffer buf_trn-doc for ub.trn-doc .
    define buffer buf_doc-pl for ub.doc-pl .
    define buffer buf_pl-gds-pump for ub.pl-gds-pump .
    define buffer buf_pl-pump-nozzle for ub.pl-pump-nozzle .

    if infoSecsObj:GetInfoSectionProp(idSecTabPage):isKP
    and not infoSecsObj:IsActnComm
    then do :
      message "Для секции " + infoSecsObj:GetInfoSectionProp(idSecTabPage):SectionName + " установлен флаг комиссионного приема. Работа с сверкой запрещена!"
      view-as alert-box .
      return .
    end .
    
    assign rvslog = no .
    v-sec = infoSecsObj:GetInfoSectionProp(idSecTabPage):SectionName .
    
    find first buf_trn-doc no-lock where buf_trn-doc.doc-code = infoSecsObj:TrnDocNum .
    
    find first buf_rvs-doc
        where buf_rvs-doc.rvs-type = {&rvs-before-doc}
        and buf_rvs-doc.out-code = infoSecsObj:TrnDocNum
        and num-entries(buf_rvs-doc.rvs-code, "-") = 3
        and entry(2, buf_rvs-doc.rvs-code, "-") = v-sec
        and buf_rvs-doc.state-measure-qnty <> ?
    no-error .
    
    if available buf_rvs-doc then 
    do: 
      if not chk-asi-polling (yes)
        then return no-apply .
  
      message
          "Сверка до уже выполнена. Вы уверены, что хотите ее изменить?"  skip
          view-as alert-box question buttons yes-no update rvslog.
      if not rvslog then
        return no-apply .
    end.          
    
    if infoSecsObj:petrol_block-nozzle
    then do :
      list-pl = "" .
      for each buf_doc-pl no-lock where buf_doc-pl.obj-type = buf_trn-doc.obj-type
                                    and buf_doc-pl.obj-code = buf_trn-doc.obj-code
                                    and buf_doc-pl.out-code = buf_trn-doc.doc-code
                                    and buf_doc-pl.gds-code = infoSecsObj:GdsCode,
      each buf_pl-gds-pump no-lock where buf_pl-gds-pump.gds-code = infoSecsObj:GdsCode
                                     and buf_pl-gds-pump.obj-code = buf_doc-pl.obj-code
                                     and buf_pl-gds-pump.obj-type = buf_doc-pl.obj-type
                                     and buf_pl-gds-pump.pl-code = buf_doc-pl.pl-code,
      each buf_pl-pump-nozzle no-lock where buf_pl-pump-nozzle.obj-code = buf_pl-gds-pump.obj-code
                                        and buf_pl-pump-nozzle.obj-type = buf_pl-gds-pump.obj-type
                                        and buf_pl-pump-nozzle.pl-code = buf_pl-gds-pump.pl-code
                                        and buf_pl-pump-nozzle.pump-code = buf_pl-gds-pump.pump-code
      :
        list-pl = substitute("&1&2&3:&4:&5", list-pl, 
                 if list-pl = "" then "" else ";",
                 buf_pl-pump-nozzle.nozzle-code,
                 buf_pl-pump-nozzle.pump-code,
                 buf_pl-pump-nozzle.pl-code).          
      end.
      
      run str/diallog.w ( input infoSecsObj:parentproc
                          ,input infoSecsObj:in-line-handle
                          ,input 'str/get-block-nozzle.p':U
                          ,input (buf_trn-doc.obj-type + {&delim-par} +
                          string(buf_trn-doc.obj-code) + {&delim-par} +
                          string(0) + {&delim-par} +  /*p-remote */
                          string(0) + {&delim-par} + /*p-shft-close*/
                          {&delim-par} +
                          {&delim-par} +
                          {&delim-par} +
                          substitute("&1,&2"
                          ,"block"
                          ,list-pl))
                          ,input yes
                          ,input ''
                          ,input 'Блокировка пистолетов') .
       if error-status :error then 
       do:
         return no-apply .
       end.
       
       if return-value begins "Для кассы" then 
       do:
         message return-value
            view-as alert-box question buttons yes-no update v-ok as logical  .
         if v-ok then run block-nozzle .
         else message "Сообщите в службу поддержки о неуспешной попытке блокировки пистолетов"
               view-as alert-box.
       end.
       else 
       do:
         message "Блокировка пистолетов прошла успешно"
            view-as alert-box.
       end.   
      
    end .
    
    ActionRvsSec
       ( input {&update}
        ,input "meas":U
        ,input {&rvs-before-doc}
        ) no-error .
    if error-status :error then 
    do:
      return no-apply .
    end.
    
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage) .
    groupBox5:Enabled               = yes .
    dateTimePickerDateStart:Enabled = yes .
    dateTimePickerDateStart:Checked = yes .
    dateTimePickerDateStart:Focus() .
    dateTimePickerDateStart:Text      = string (infoSecObj:DateStart) no-error.
    if error-status:error or infoSecObj:DateStart = ?
      then 
    do:
      blank_datetime (dateTimePickerDateStart).
    end.
    dateTimePickerDateStart:Show() .
    dateTimePickerDateStart:Enabled = no .
    
    dateTimePickerTimeStart:Enabled = yes .
    dateTimePickerTimeStart:Checked = yes .
    dateTimePickerTimeStart:visible = yes .
    dateTimePickerTimeStart:Focus() .
    dateTimePickerTimeStart:Text      = GetTimeStr(infoSecObj:TimeStart) no-error.
    if error-status:error or infoSecObj:TimeStart = ? or infoSecObj:TimeStart = 0
      then 
    do:
      blank_datetime (dateTimePickerTimeStart).
    end.
    dateTimePickerTimeStart:Enabled = no .
    groupBox5:Enabled               = no .
    
    infoSecObj:TankWeightRvs = ? .
    
  end method .
  
  @VisualDesigner.
  method private void onClickRvsBef2 ( input sender as System.Object, input e as System.EventArgs ) :
    
    ActionRvsSec
      ( input {&lookup}
       ,input "edit":U
       ,input {&rvs-before-doc}
      ) no-error .
    if error-status :error then do:
      return  .
    end.
    
  end method .
  
  @VisualDesigner.
  method private void onClickRvsBef3 ( input sender as System.Object, input e as System.EventArgs ) :
    
    define variable infoSecObj as class InfoSection no-undo .
    
    define buffer buf_trn-doc for ub.trn-doc .
    define buffer buf_doc-pl for ub.doc-pl .
    define buffer buf_pl-gds-pump for ub.pl-gds-pump .
    define buffer buf_pl-pump-nozzle for ub.pl-pump-nozzle .

    if infoSecsObj:GetInfoSectionProp(idSecTabPage):isKP
    and not infoSecsObj:IsActnComm
    then do :
      message "Для секции " + infoSecsObj:GetInfoSectionProp(idSecTabPage):SectionName + " установлен флаг комиссионного приема. Работа с сверкой запрещена!"
      view-as alert-box .
      return .
    end .
    
    assign rvslog = no .
    
    find first buf_trn-doc no-lock where buf_trn-doc.doc-code = infoSecsObj:TrnDocNum .
    
    ActionRvsSec
    ( input {&update}
     ,input "edit":U
     ,input {&rvs-before-doc}
    ) no-error .
    if error-status :error then do:
      return no-apply .
    end.
    
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage) .
    groupBox5:Enabled               = yes .
    dateTimePickerDateStart:Enabled = yes .
    dateTimePickerDateStart:Checked = yes .
    dateTimePickerDateStart:Focus() .
    dateTimePickerDateStart:Text      = string (infoSecObj:DateStart) no-error.
    if error-status:error or infoSecObj:DateStart = ?
      then 
    do:
      blank_datetime (dateTimePickerDateStart).
    end.
    dateTimePickerDateStart:Show() .
    dateTimePickerDateStart:Enabled = no .
    
    dateTimePickerTimeStart:Enabled = yes .
    dateTimePickerTimeStart:Checked = yes .
    dateTimePickerTimeStart:visible = yes .
    dateTimePickerTimeStart:Focus() .
    dateTimePickerTimeStart:Text      = GetTimeStr(infoSecObj:TimeStart) no-error.
    if error-status:error or infoSecObj:TimeStart = ? or infoSecObj:TimeStart = 0
      then 
    do:
      blank_datetime (dateTimePickerTimeStart).
    end.
    dateTimePickerTimeStart:Enabled = no .
    groupBox5:Enabled               = no .
    
    infoSecObj:TankWeightRvs = ? .
    
    if infoSecsObj:petrol_block-nozzle
    then do :
      list-pl = "" .
      for each buf_doc-pl no-lock where buf_doc-pl.obj-type = buf_trn-doc.obj-type
                                    and buf_doc-pl.obj-code = buf_trn-doc.obj-code
                                    and buf_doc-pl.out-code = buf_trn-doc.doc-code
                                    and buf_doc-pl.gds-code = infoSecsObj:GdsCode,
      each buf_pl-gds-pump no-lock where buf_pl-gds-pump.gds-code = infoSecsObj:GdsCode
                                     and buf_pl-gds-pump.obj-code = buf_doc-pl.obj-code
                                     and buf_pl-gds-pump.obj-type = buf_doc-pl.obj-type
                                     and buf_pl-gds-pump.pl-code = buf_doc-pl.pl-code,
      each buf_pl-pump-nozzle no-lock where buf_pl-pump-nozzle.obj-code = buf_pl-gds-pump.obj-code
                                        and buf_pl-pump-nozzle.obj-type = buf_pl-gds-pump.obj-type
                                        and buf_pl-pump-nozzle.pl-code = buf_pl-gds-pump.pl-code
                                        and buf_pl-pump-nozzle.pump-code = buf_pl-gds-pump.pump-code
      :
        list-pl = substitute("&1&2&3:&4:&5", list-pl, 
                   if list-pl = "" then "" else ";",
                   buf_pl-pump-nozzle.nozzle-code,
                   buf_pl-pump-nozzle.pump-code,
                   buf_pl-pump-nozzle.pl-code).           
      end.
      run str/diallog.w ( input infoSecsObj:parentproc
                          ,input infoSecsObj:in-line-handle
                          ,input 'str/get-block-nozzle.p':U
                          ,input (buf_trn-doc.obj-type + {&delim-par} +
                          string(buf_trn-doc.obj-code) + {&delim-par} +
                          string(0) + {&delim-par} +  /*p-remote */
                          string(0) + {&delim-par} + /*p-shft-close*/
                          {&delim-par} +
                          {&delim-par} +
                          {&delim-par} +
                          substitute("&1,&2"
                          ,"block"
                          ,list-pl))
                          ,input yes
                          ,input ''
                          ,input 'Блокировка пистолетов') .
       if not error-status:error then 
       do:
         if return-value begins "Для кассы" then 
         do:
           message return-value
              view-as alert-box question buttons yes-no update v-ok as logical  .
           if v-ok then run block-nozzle .
           else message "Сообщите в службу поддержки о неуспешной попытке блокировки пистолетов"
                 view-as alert-box.
         end.
         else 
         do:
           message "Блокировка пистолетов прошла успешно"
              view-as alert-box.
         end.   
       end.
       else do:
         return no-apply .
       end.
      
    end .
    
  end method .
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  
  @VisualDesigner.
  method private void bRvsAft_MouseClick( input sender as System.Object, input e as System.Windows.Forms.MouseEventArgs ):
    
    if infoSecsObj:Mode = {&lookup}
    then do :
      ActionRvsSec
        ( input {&lookup}
         ,input "edit":U
         ,input {&rvs-after-doc}
        ) no-error .
      if error-status :error then do:
        return  .
      end.
    end .
    else do :
      bRvsAft:ContextMenu = new ContextMenu() .
      menuItemRvsAft1 = new System.Windows.Forms.MenuItem("Сверка резервуара") .
      menuItemRvsAft2 = new System.Windows.Forms.MenuItem("Просмотр") .
      menuItemRvsAft3 = new System.Windows.Forms.MenuItem("Редактирование") .
      bRvsAft:ContextMenu:MenuItems:Add(menuItemRvsAft1) .
      bRvsAft:ContextMenu:MenuItems:Add(menuItemRvsAft2) .
      bRvsAft:ContextMenu:MenuItems:Add(menuItemRvsAft3) .
      menuItemRvsAft1:Click:Subscribe(onClickRvsAft1) .
      menuItemRvsAft2:Click:Subscribe(onClickRvsAft2) .
      menuItemRvsAft3:Click:Subscribe(onClickRvsAft3) .
      bRvsAft:ContextMenu:Show(bRvsAft, new System.Drawing.Point(e:X, e:Y)) .
      
    end .
    
    return.

  end method.
  
  @VisualDesigner.
  method private void onClickRvsAft1 ( input sender as System.Object, input e as System.EventArgs ) :
    
    define variable infoSecObj as class InfoSection no-undo .
    
    define buffer buf_trn-doc for ub.trn-doc .
    define buffer buf_doc-pl for ub.doc-pl .
    define buffer buf_pl-gds-pump for ub.pl-gds-pump .
    define buffer buf_pl-pump-nozzle for ub.pl-pump-nozzle .
    
    if infoSecsObj:GetInfoSectionProp(idSecTabPage):isKP
    and not infoSecsObj:IsActnComm
    then do :
      message "Для секции " + infoSecsObj:GetInfoSectionProp(idSecTabPage):SectionName + " установлен флаг комиссионного приема. Работа с сверкой запрещена!"
      view-as alert-box .
      return .
    end .
    
    assign rvslog = no .
    
    find first buf_trn-doc no-lock where buf_trn-doc.doc-code = infoSecsObj:TrnDocNum .
    
    if not chk-asi-polling (no)
    then return no-apply .

    ActionRvsSec
      ( input {&update}
       ,input "meas":U
       ,input {&rvs-after-doc}
      ) no-error .
    if error-status :error then do:
      return no-apply .
    end.
    
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage) .
    groupBox5:Enabled                 = yes .
    dateTimePickerDateEnd:Enabled     = yes .
    dateTimePickerDateEnd:Checked     = yes .
    dateTimePickerDateEnd:Focus() .
    dateTimePickerDateEnd:Text        = string (infoSecObj:DateEnd) no-error.
    if error-status:error or infoSecObj:DateEnd = ?
      then 
    do:
      blank_datetime (dateTimePickerDateEnd).
    end.
    dateTimePickerDateEnd:Enabled     = no .
    
    dateTimePickerTimeEnd:Enabled     = yes .
    dateTimePickerTimeEnd:Checked     = yes .
    dateTimePickerTimeEnd:Focus() .
    dateTimePickerTimeEnd:Text        = GetTimeStr(infoSecObj:TimeEnd) no-error.
    if error-status:error or infoSecObj:TimeEnd = ? or infoSecObj:TimeEnd = 0
      then 
    do:
      blank_datetime (dateTimePickerTimeEnd).
    end.
    dateTimePickerTimeEnd:Enabled     = no .
    groupBox5:Enabled                 = no .
    
    infoSecObj:TankWeightRvs = ? .
    
    if infoSecsObj:petrol_block-nozzle
    then do :
      list-pl = "" .
      for each buf_doc-pl no-lock where buf_doc-pl.obj-type = buf_trn-doc.obj-type
                                    and buf_doc-pl.obj-code = buf_trn-doc.obj-code
                                    and buf_doc-pl.out-code = buf_trn-doc.doc-code
                                    and buf_doc-pl.gds-code = infoSecsObj:GdsCode,
      each buf_pl-gds-pump no-lock where buf_pl-gds-pump.gds-code = infoSecsObj:GdsCode
                                     and buf_pl-gds-pump.obj-code = buf_doc-pl.obj-code
                                     and buf_pl-gds-pump.obj-type = buf_doc-pl.obj-type
                                     and buf_pl-gds-pump.pl-code = buf_doc-pl.pl-code,
      each buf_pl-pump-nozzle no-lock where buf_pl-pump-nozzle.obj-code = buf_pl-gds-pump.obj-code
                                        and buf_pl-pump-nozzle.obj-type = buf_pl-gds-pump.obj-type
                                        and buf_pl-pump-nozzle.pl-code = buf_pl-gds-pump.pl-code
                                        and buf_pl-pump-nozzle.pump-code = buf_pl-gds-pump.pump-code
      :
        list-pl = substitute("&1&2&3:&4:&5", list-pl, 
                   if list-pl = "" then "" else ";",
                   buf_pl-pump-nozzle.nozzle-code,
                   buf_pl-pump-nozzle.pump-code,
                   buf_pl-pump-nozzle.pl-code).             
      end.
      run str/diallog.w ( input infoSecsObj:parentproc
          ,input infoSecsObj:in-line-handle
          ,input 'str/get-block-nozzle.p':U
          ,input (buf_trn-doc.obj-type + {&delim-par} +
          string(buf_trn-doc.obj-code) + {&delim-par} +
          string(0) + {&delim-par} +  /*p-remote */
          string(0) + {&delim-par} + /*p-shft-close*/
          {&delim-par} +
          {&delim-par} +
          {&delim-par} +
          substitute("&1,&2"
          ,"unblock"
          ,list-pl))
          ,input yes
          ,input ''
          ,input 'Разблокировка выбранных пистолетов') .
      if not error-status:error then 
      do:
        if return-value begins "Для кассы" then 
        do:
           message return-value
              view-as alert-box question buttons yes-no update v-ok as logical  .
           if v-ok then run unblock-nozzle .
           else message "Сообщите в службу поддержки о неуспешной попытке разблокировки пистолетов"
                 view-as alert-box.
                 
        end.
        else 
        do:
           message if return-value begins "Ошибка" then return-value else "Разблокировка пистолетов прошла успешно" 
             view-as alert-box.
        end.   
      end.
      else 
      do:
        return no-apply .   
      end.
    end .
    
  end method .
  
  @VisualDesigner.
  method private void onClickRvsAft2 ( input sender as System.Object, input e as System.EventArgs ) :
    
    ActionRvsSec
      ( input {&lookup}
       ,input "edit":U
       ,input {&rvs-after-doc}
      ) no-error .
    if error-status :error then do:
      return  .
    end.
    
  end method .
  
  @VisualDesigner.
  method private void onClickRvsAft3 ( input sender as System.Object, input e as System.EventArgs ) :
    
    define variable infoSecObj as class InfoSection no-undo .
    
    define buffer buf_trn-doc for ub.trn-doc .
    define buffer buf_doc-pl for ub.doc-pl .
    define buffer buf_pl-gds-pump for ub.pl-gds-pump .
    define buffer buf_pl-pump-nozzle for ub.pl-pump-nozzle .
    
    if infoSecsObj:GetInfoSectionProp(idSecTabPage):isKP
    and not infoSecsObj:IsActnComm
    then do :
      message "Для секции " + infoSecsObj:GetInfoSectionProp(idSecTabPage):SectionName + " установлен флаг комиссионного приема. Работа с сверкой запрещена!"
      view-as alert-box .
      return .
    end .
    
    find first buf_trn-doc no-lock where buf_trn-doc.doc-code = infoSecsObj:TrnDocNum .
    
    ActionRvsSec
    ( input {&update}
     ,input "edit":U
     ,input {&rvs-after-doc}
    ) no-error .
    if error-status :error then do:
      return no-apply .
    end.
    
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage) .
    groupBox5:Enabled                 = yes .
    dateTimePickerDateEnd:Enabled     = yes .
    dateTimePickerDateEnd:Checked     = yes .
    dateTimePickerDateEnd:Focus() .
    dateTimePickerDateEnd:Text        = string (infoSecObj:DateEnd) no-error.
    if error-status:error or infoSecObj:DateEnd = ?
      then 
    do:
      blank_datetime (dateTimePickerDateEnd).
    end.
    dateTimePickerDateEnd:Enabled     = no .
    
    dateTimePickerTimeEnd:Enabled     = yes .
    dateTimePickerTimeEnd:Checked     = yes .
    dateTimePickerTimeEnd:Focus() .
    dateTimePickerTimeEnd:Text        = GetTimeStr(infoSecObj:TimeEnd) no-error.
    if error-status:error or infoSecObj:TimeEnd = ? or infoSecObj:TimeEnd = 0
      then 
    do:
      blank_datetime (dateTimePickerTimeEnd).
    end.
    dateTimePickerTimeEnd:Enabled     = no .
    groupBox5:Enabled                 = no .
    
    infoSecObj:TankWeightRvs = ? .
    
    if infoSecsObj:petrol_block-nozzle
    then do :
      list-pl = "" .
      for each buf_doc-pl no-lock where buf_doc-pl.obj-type = buf_trn-doc.obj-type
                                    and buf_doc-pl.obj-code = buf_trn-doc.obj-code
                                    and buf_doc-pl.out-code = buf_trn-doc.doc-code
                                    and buf_doc-pl.gds-code = infoSecsObj:GdsCode,
      each buf_pl-gds-pump no-lock where buf_pl-gds-pump.gds-code = infoSecsObj:GdsCode
                                     and buf_pl-gds-pump.obj-code = buf_doc-pl.obj-code
                                     and buf_pl-gds-pump.obj-type = buf_doc-pl.obj-type
                                     and buf_pl-gds-pump.pl-code = buf_doc-pl.pl-code,
      each buf_pl-pump-nozzle no-lock where buf_pl-pump-nozzle.obj-code = buf_pl-gds-pump.obj-code
                                        and buf_pl-pump-nozzle.obj-type = buf_pl-gds-pump.obj-type
                                        and buf_pl-pump-nozzle.pl-code = buf_pl-gds-pump.pl-code
                                        and buf_pl-pump-nozzle.pump-code = buf_pl-gds-pump.pump-code
      :
        list-pl = substitute("&1&2&3:&4:&5", list-pl, 
                   if list-pl = "" then "" else ";",
                   buf_pl-pump-nozzle.nozzle-code,
                   buf_pl-pump-nozzle.pump-code,
                   buf_pl-pump-nozzle.pl-code).             
      end.
      run str/diallog.w ( input infoSecsObj:parentproc
          ,input infoSecsObj:in-line-handle
          ,input 'str/get-block-nozzle.p':U
          ,input (buf_trn-doc.obj-type + {&delim-par} +
          string(buf_trn-doc.obj-code) + {&delim-par} +
          string(0) + {&delim-par} +  /*p-remote */
          string(0) + {&delim-par} + /*p-shft-close*/
          {&delim-par} +
          {&delim-par} +
          {&delim-par} +
          substitute("&1,&2"
          ,"unblock"
          ,list-pl))
          ,input yes
          ,input ''
          ,input 'Разблокировка выбранных пистолетов') .
      if not error-status:error then 
      do:
        if return-value begins "Для кассы" then 
        do:
           message return-value
              view-as alert-box question buttons yes-no update v-ok as logical  .
           if v-ok then run unblock-nozzle .
           else message "Сообщите в службу поддержки о неуспешной попытке разблокировки пистолетов"
                 view-as alert-box.
                 
        end.
        else 
        do:
           message if return-value begins "Ошибка" then return-value else "Разблокировка пистолетов прошла успешно" 
             view-as alert-box.
        end.   
      end.
      else 
      do:
        return no-apply .   
      end.
    end .
    
  end method .
  
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void button1_Click( input sender as System.Object, input e as System.EventArgs ):
		
    define variable ii as integer no-undo.
    define variable v-section as character no-undo.
    define variable v-mode as character no-undo.
    define variable varauto-tank-par as character no-undo.
    define variable inum-ComboBoxShape as integer no-undo.
    
    if ComboBoxShape:Text = ""
    then do:
      message
        "Вначале задайте тип горловины."  skip
      view-as alert-box error.
      undo, return no-apply.
    end.
    varauto-tank-par = replace(maskedTextBoxDiameter:Text, "/", {&delim-par}). 
    if (infoSecsObj:Mode = {&update} or infoSecsObj:Mode = {&add-def})
    and (not infoSecsObj:FlagTrn or (infoSecsObj:FlagTrn and infoSecsObj:IsSGDKK and infoSecsObj:IsKP and not infoSecsObj:IsKPrvs))
    and maskedTextBoxCarVol:Enabled = true
    then v-mode = {&update}.
    else v-mode = {&lookup}.
    
    inum-ComboBoxShape = lookup (comboBoxShape:Text, var-list-shape, ",") - 1.
    
    run str/autotncs.w
      ( input        v-mode
       ,input-output varauto-tank-par
       ,input        1
       ,input        decimal (maskedTextBoxCarVol:Text)
       ,input        inum-ComboBoxShape
       ,input        integer (maskedTextBoxSecName:Text)
      ) no-error.
    
    if integer (ComboBoxShape) = 0
    then do:
      v-dop-volume = decimal(entry(1, varauto-tank-par, {&delim-par}) ) no-error.
      create tt-section .
      tt-section.dif     = 0 .  
      tt-section.volume1 = 0 .
      do ii = 2 to num-entries (varauto-tank-par,{&delim-par}):
          v-section = entry(ii, varauto-tank-par, {&delim-par}) .
          create tt-section .
          tt-section.dif     = integer(entry (1,v-section,{&delim-cmd})) no-error .  
          tt-section.volume1 = decimal(entry (2,v-section,{&delim-cmd})) no-error . 
      end.
    end.
  
    maskedTextBoxDiameter:Text = replace(varauto-tank-par,{&delim-par}, "/").
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void buttonCopyPSTemp_Click( input sender as System.Object, input e as System.EventArgs ):
		
    define variable v-place-si as integer no-undo.
    define variable v-num-temp as character no-undo.
    define variable v-date-pov-temp as date no-undo.
    define variable v-passport-temp as character no-undo.
    define buffer buf_sr-izmerenia for ub.sr-izmerenia .    

    run str/in-copy-iz.w
      ( input        infoSecsObj:Parentproc
       ,input        infoSecsObj:Mode
       ,input        infoSecsObj:GdsCode
       ,output       v-place-si
       ,output       v-num-temp
       ,output       v-passport-temp
       ,output       v-date-pov-temp       
      ) no-error.
    
    if v-place-si <> 0 and v-place-si <> ? 
    then
      assign
        maskedTextBoxNumTemp:Text = v-num-temp
        maskedTextBoxPlaceSiTemp:Text = string (v-place-si)
        dateTimePickerDatePovTemp:Text = string (v-date-pov-temp)
        maskedTextBoxPassportTemp:Text = v-passport-temp.
    return.

	end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void buttonPl_Click( input sender as System.Object, input e as System.EventArgs ):
    
    define buffer buf_place for ub.place .
    define buffer buf2_place for ub.place .
    define buffer buf_place-attr for ub.place-attr .
    define buffer buf2_place-attr for ub.place-attr .
    
    define variable ii as integer no-undo .
    define variable v-str as character no-undo .
    define variable v-is-main as logical no-undo .
    define variable v-com-tanks as character no-undo .
    
    run str/place-list.w 
    ( input infoSecsObj:ObjType,
      input infoSecsObj:ObjCode,
      input infoSecsObj:GdsCode,
      input-output v-str
    ).
    
    if maskedTextBoxListTank:text = v-str
    then do :
      return .
    end .
    
    find first buf_place no-lock where buf_place.obj-type = infoSecsObj:ObjType
                                   and buf_place.obj-code = infoSecsObj:ObjCode
                                   and buf_place.loc1     = v-str
                                   and buf_place.status_  = ""
                                   no-error .
    if not available buf_place
    then do :
      return error .
    end .
    
    for first buf_place-attr no-lock where buf_place-attr.attr-code = "place-is-main"
                                        and buf_place-attr.obj-code = buf_place.obj-code
                                        and buf_place-attr.obj-type = buf_place.obj-type
                                        and buf_place-attr.pl-code  = buf_place.pl-code
    :
      v-is-main = logical(buf_place-attr.attr-value) .
    end .
    if not v-is-main
    then do :
      for first buf_place-attr no-lock where buf_place-attr.attr-code = "place-com-tanks"
                                          and buf_place-attr.obj-code = buf_place.obj-code
                                          and buf_place-attr.obj-type = buf_place.obj-type
                                          and buf_place-attr.pl-code  = buf_place.pl-code
      :
        assign v-com-tanks = buf_place-attr.attr-value .
      end .
      do ii = 1 to num-entries(v-com-tanks) :
        find first buf2_place no-lock where buf2_place.obj-type = buf_place.obj-type
                                        and buf2_place.obj-code = buf_place.obj-code
                                        and buf2_place.loc1     = entry(ii, v-com-tanks)
                                        and buf2_place.status_  = ""
                                        no-error .
        if available buf2_place
        then do :
          for first buf2_place-attr no-lock where buf2_place-attr.attr-code = "place-is-main"
                                              and buf2_place-attr.obj-code  = buf2_place.obj-code
                                              and buf2_place-attr.obj-type  = buf2_place.obj-type
                                              and buf2_place-attr.pl-code   = buf2_place.pl-code
          :
            if logical(buf2_place-attr.attr-value) /* Главный СР */
            then do :
              v-str = buf2_place.loc1 .
              leave .
            end .
          end .
        end .
      end .
    end .
    
    if maskedTextBoxListTank:text = v-str
    then do :
      return .
    end .
    
    infoSecsObj:PlChanged = yes .
    maskedTextBoxListTank:text = v-str.
    
    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecsObj:InfoSectionCurr:ListTank = maskedTextBoxListTank:text .
    
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
                      input "0,1",
                      input "dnst",
                      input-output v-node-code,
                      output v-sr-type) no-error.   
    if v-node-code <> 0 and v-node-code <> ? then do :
      infoSecsObj:GetInfoSectionProp(idSecTabPage).
      infoSecsObj:InfoSectionCurr:PlaceSi = v-node-code.
      textBoxPlSiName:Text = infoSecsObj:InfoSectionCurr:PlSiName.
      maskedTextBoxPlaceSi:Text = string (infoSecsObj:InfoSectionCurr:PlaceSi).
  
      find first ub.sr-izmerenia no-lock where ub.sr-izmerenia.node-code = v-node-code no-error.
      if available (ub.sr-izmerenia)
      and (ub.sr-izmerenia.sr-temperature)
      and (textBoxPlSiNameTemp:text = "0" or textBoxPlSiNameTemp:text = "")
      then do:
        infoSecsObj:GetInfoSectionProp(idSecTabPage).
        maskedTextBoxPlaceSiTemp:Text = string(v-node-code).
        infoSecsObj:InfoSectionCurr:PlaceSiTemp = v-node-code.
        textBoxPlSiNameTemp:Text = infoSecsObj:InfoSectionCurr:PlSiNameTemp.
      end.
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
    define variable v-new-sec-fact-qnty-kg as decimal no-undo .
    define variable v-calc-density as decimal no-undo .
    define variable infoSecObj as class ibs.th.str.InfoSection no-undo .
    
    SetInfoSec ().
    if not CheckSec(no, yes, no)
    then do:
      SetForcus().
      return.
    end.
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecsObj:CalcWeight().
    v-calc-density = infoSecObj:TankDensityPomi .
    if v-calc-density = ?
    or v-calc-density <= 0
    or v-calc-density >= 1
    then do :
      message "По результатам рассчёта модуля ПОкМИ плотность выходит за допустимые значения!"
      view-as alert-box error .
      return .
    end .
    infoSecsObj:RNAlgo (integer(infoSecObj:SectionName), output v-new-sec-fact-qnty-kg).   
    if infoSecObj:IsKP
    then do :
      label51:Visible = true .
    end .      
    infoSecObj:FactQnty = v-new-sec-fact-qnty-kg / v-calc-density .
    infoSecObj:FactDensity = v-calc-density .
    infoSecsObj:SaveDB() .
    infoSecsObj:GetDBAllAttr() .
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
	method private void buttonPlSiTemp_Click( input sender as System.Object, input e as System.EventArgs ):
		
    define variable v-node-code as integer no-undo.
    define variable v-sr-type as integer no-undo.
    run ref/sr-izm.w (input infoSecsObj:Parentproc ,
                      input ""            ,
                      input {&lookup}     ,
                      input "0,1",
                      input "tmp",
                      input-output v-node-code,
                      output v-sr-type) no-error.   
    if v-node-code <> 0 and v-node-code <> ? then do :
      infoSecsObj:GetInfoSectionProp(idSecTabPage).
      infoSecsObj:InfoSectionCurr:PlaceSiTemp = v-node-code.
      textBoxPlSiNameTemp:Text = infoSecsObj:InfoSectionCurr:PlSiNameTemp.
      maskedTextBoxPlaceSiTemp:Text = string (infoSecsObj:InfoSectionCurr:PlaceSiTemp).
      
      infoSecsObj:GetInfoSectionProp(idSecTabPage).
      infoSecsObj:InfoSectionCurr:PlaceSiTemp = v-node-code.
      textBoxPlSiNameTemp:Text = infoSecsObj:InfoSectionCurr:PlSiNameTemp.
      
      find first ub.sr-izmerenia no-lock where ub.sr-izmerenia.node-code = v-node-code no-error.
      if available (ub.sr-izmerenia)
      and (ub.sr-izmerenia.sr-density)
      and (textBoxPlSiName:text = "0" or textBoxPlSiName:text = "")
      then do:
        infoSecsObj:GetInfoSectionProp(idSecTabPage).
        maskedTextBoxPlaceSi:Text = string(v-node-code).
        infoSecsObj:InfoSectionCurr:PlaceSi = v-node-code.
        textBoxPlSiName:Text = infoSecsObj:InfoSectionCurr:PlSiName.
      end.
    end.
    
    return.

	end method.



	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void cbSGDKK_CheckedChanged( input sender as System.Object, input e as System.EventArgs ):
		
		define variable v-log as logical no-undo .
		define buffer bf_doc-line-attr for ub.doc-line-attr .
		
		if infoSecsObj:FlagTrn
		then do :
		  if cbSGDKK:Checked
      then do :
        message "Установлен флаг «Тревожное событие СЭП». Для продолжения работы с документом потребуется ввести Идентификатор доступа (ключа) «верхнего уровня» или одноразовый код.?" skip
                "Вы уверены в правильности установки флага «Тревожное событие СЭП»?"
        view-as alert-box question buttons yes-no update v-log .
        if v-log
        then do :
          maskedTextBoxAukKey:text = "" .
          label50:text = "Идентификатор доступа (ключ) «верхнего уровня» или одноразовый код:" .
/*          groupBox2:Enabled = true.*/
/*          groupBox3:Enabled = true.*/
/*          groupBox4:Enabled = true.*/
/*          groupBox5:Enabled = true.*/
/*          groupBox6:Enabled = true.*/
/*          groupBox7:Enabled = true.*/
/*          groupBox8:Enabled = true.*/
/*          this-object:maskedTextBoxCarVol:Enabled = true.*/
/*          comboBoxPour:Enabled = true.                   */
/*          comboBoxShape:Enabled = true.                  */
        end .
        else do :
          cbSGDKK:checked = no .
        end .
      end .
      else do :
        label50:text = "Идентификатор доступа (ключ) «нижнего уровня»:" .
/*        groupBox2:Enabled = false.*/
/*        groupBox3:Enabled = false.*/
/*        groupBox4:Enabled = false.*/
/*        groupBox5:Enabled = false.*/
/*        groupBox6:Enabled = false.*/
/*        groupBox7:Enabled = false.*/
/*        groupBox8:Enabled = false.*/
/*        this-object:maskedTextBoxCarVol:Enabled = false.*/
/*        comboBoxPour:Enabled = false.                   */
/*        comboBoxShape:Enabled = false.                  */
      end .
		end .
		else do :
  		if cbSGDKK:Checked
      then do :
        message "При установке флага «Тревожное событие СЭП» будет активирован комиссионный прием. Продолжить?"
        view-as alert-box question buttons yes-no update v-log .
        if v-log
        then do :
          label50:text = "Идентификатор доступа (ключ) «верхнего уровня» или одноразовый код:" .
        end .
        else do :
          cbSGDKK:checked = no .
        end .
      end .
      else do :
        label50:text = "Идентификатор доступа (ключ) «нижнего уровня»:" .
      end .
    end .
    
/*    infoSecsObj:GetInfoSectionProp(idSecTabPage).              */
/*    infoSecsObj:InfoSectionCurr:alarm-SGDKK = cbSGDKK:Checked .*/
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void comboBox1_SelectedIndexChanged( input sender as System.Object, input e as System.EventArgs ):
		
		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void comboBox2_SelectedIndexChanged( input sender as System.Object, input e as System.EventArgs ):

		return.

	end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void comboBoxShape_SelectedValueChanged( input sender as System.Object, input e as System.EventArgs ):
		
/*		if comboBoxShape:Text = "Без горловины"    */
/*		  then comboBoxPour:Text = "Нижний налив" .*/
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
  
  method public void GetAukKey(inAukKey as character, inSGDKK as logical) :
    
    if cbSGDKK:checked = inSGDKK
    then do :
      maskedTextBoxAukKey:text = inAukKey .
    end .
    return .
    
  end method.

  method public void GetCopy(a as char, b as char, c as char, d as char ) :
    
    assign
      maskedTextBoxNumPassport:Text = a
      maskedTextBoxNormDoc:Text = b
      maskedTextBoxCertifFuel:Text = c
      maskedTextBoxValidityCertif:Text = d
    .
    
    return.

  end method.


	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void groupBox4_Enter( input sender as System.Object, input e as System.EventArgs ):
		
		return.

	end method.

  method private void InitializeComponentCust(  ):

    def var ii as int no-undo.
    
    define variable v-tth             as handle    no-undo .
    define variable par-type          as character no-undo .
    define variable v-value-char      as character no-undo .
    define variable v-value-date      as date      no-undo .
    define variable v-value-decimal   as decimal   no-undo .
    define variable v-value-integer   as integer   no-undo .
    define variable v-value-logical   as logical   no-undo .
    define variable v-field           as character no-undo .
    define variable v-rvd-own-nb      as logical   no-undo .
    define variable tmpInfoSecs       as class InfoSectionsTotal no-undo .
    define variable v-num-sec-pl      as integer   no-undo .
    
    define buffer buf_trn-doc for ub.trn-doc .
    define buffer buf_rvs-doc for ub.rvs-doc .
    
    run adm/shattri.p (
               input "get":U
              ,input  infoSecsObj:ObjType
              ,input  infoSecsObj:ObjCode
              ,input  {&attr-petrol}
              ,input  {&attr-petrol_sec-fields} /*p-param-code*/
              ,output v-sec-fields
              ,output v-value-date
              ,output v-value-decimal
              ,output v-value-integer
              ,output v-value-logical
              ,output par-type
              ,input-output table-handle v-tth
              ) no-error .
    if error-status:error then do:
        if valid-object(v-tth) then delete object v-tth.
        undo, return error return-value + error-status :get-message(1) .
    end.
    
    run adm/shattri.p (
               input "get":U
              ,input  infoSecsObj:ObjType
              ,input  infoSecsObj:ObjCode
              ,input  {&attr-petrol}
              ,input  {&attr-petrol_rvd-own-nb} /*p-param-code*/
              ,output v-value-char
              ,output v-value-date
              ,output v-value-decimal
              ,output v-value-integer
              ,output v-rvd-own-nb
              ,output par-type
              ,input-output table-handle v-tth
              ) no-error .
    if error-status:error then do:
        if valid-object(v-tth) then delete object v-tth.
        v-rvd-own-nb = false .
    end.
    
    define variable arrayShape as System.Object extent {&list-shape-num} no-undo.
    do ii = 1 to {&list-shape-num}:
      arrayShape[ii] = entry (ii, {&list-shape}).
    end.
    this-object:comboBoxShape:Items:AddRange(arrayShape).
    
    v-tank-weight-rvs = ? .
    v-tank-vol-pomi-rvs = ? .
  
    SetControls().
    
    assign
      maskedTextBoxArr[1] = this-object:maskedTextBoxNormDoc    
      maskedTextBoxArr[2] = this-object:maskedTextBoxCertifFuel     
      maskedTextBoxArr[3] = this-object:maskedTextBoxValidityCertif 
      maskedTextBoxArr[4] = this-object:maskedTextBoxABTArir        
      maskedTextBoxArr[5] = this-object:maskedTextBoxTankDens       
      maskedTextBoxArr[6] = this-object:maskedTextBoxTankWater      
      maskedTextBoxArr[7] = this-object:maskedTextBoxTankTemp       
      maskedTextBoxArr[8] = this-object:maskedTextBoxDensTemp
      maskedTextBoxArr[9] = this-object:maskedTextBoxCarVol
      maskedTextBoxArr[10] = this-object:maskedTextBoxDiameter       
      maskedTextBoxArr[11] = this-object:maskedTextBoxListTank       
      maskedTextBoxArr[12] = this-object:maskedTextBoxPlaceSi        
      maskedTextBoxArr[13] = this-object:maskedTextBoxNumPlot        
      maskedTextBoxArr[14] = this-object:maskedTextBoxPassportPlotn  
      maskedTextBoxArr[15] = this-object:maskedTextBoxTests          
      maskedTextBoxArr[16] = this-object:maskedTextBoxKolProb        
      maskedTextBoxArr[17] = this-object:maskedTextBoxNumPrintProb
      maskedTextBoxArr[18] = this-object:maskedTextBoxPlaceSiTemp
      .
    assign    
      maskedTextBoxDocArr[1] = this-object:maskedTextBoxDocDens
      maskedTextBoxDocArr[2] = this-object:maskedTextBoxDocQnty
      maskedTextBoxDocArr[3] = this-object:maskedTextBoxSecName
      maskedTextBoxDocArr[4] = this-object:maskedTextBoxCliQnty
      maskedTextBoxDocArr[5] = this-object:maskedTextBoxTTNTemp
      maskedTextBoxDocArr[6] = this-object:maskedTextBoxAccShip
      maskedTextBoxDocArr[7] = this-object:maskedTextBoxDocDensST
      maskedTextBoxDocArr[8] = this-object:maskedTextBoxPaspDens
      maskedTextBoxDocArr[9] = this-object:maskedTextBoxPressure
      maskedTextBoxDocArr[10] = this-object:maskedTextBoxNumPassport
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
      maskedTextBoxOnlyReadOnlyArr[9 ] = this-object:maskedTextBoxDiameter          
    .
    
    assign
      DateTimePickerDateArr[1] = this-object:dateTimePickerDatePovPlotn
      DateTimePickerDateArr[2] = this-object:dateTimePickerDateStart   
      DateTimePickerDateArr[3] = this-object:dateTimePickerDateEnd     
      DateTimePickerDateArr[4] = this-object:DateTimeDateProb
      DateTimePickerDateArr[5] = this-object:dateTimePickerDatePovTemp
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
    
    label51:Visible = false.

    if infoSecsObj:RdcDnstvalue = "not"
    then do:
      groupBox7:Visible = false.
      groupBox8:Visible = false.
      groupBox9:Visible = false.
      groupBox6:Visible = false.
      
      maskedTextBoxTankTemp:Visible = false.
      maskedTextBoxTankVolPomi:Visible = false.
      maskedTextBoxTankDensityPomi:Visible = false.
      maskedTextBoxAccWeight:Visible = false.
      label23:Visible = false.
      label22:Visible = false.
      label24:Visible = false.
      
      groupBox4:Location = groupBox7:Location.
      groupBox5:Location = new System.Drawing.Point(10, 530).
      buttonCalcWeight:Visible = false.
      label20:Visible = false.      

      maskedTextBoxTankWater:Enabled = false.
    end.

    if infoSecsObj:RdcDnstvalue = "manual"
    then do:
      //groupBox7:Visible = false.
      maskedTextBoxTankVolPomi:Enabled = true.
      maskedTextBoxTankDensityPomi:Enabled = true.
      maskedTextBoxTankDensityPomi:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_4).
      groupBox6:Visible = false.
      groupBox9:Visible = false.
      
      maskedTextBoxAccWeight:Visible = false.
      
      label24:Visible = false.
      
      //groupBox4:Location = groupBox7:Location.
      maskedTextBoxTankWater:Enabled = false.
    end.
    
    if infoSecsObj:IsSGDKK
    then do :
      cbSGDKK:Visible = true.
      cbKPnoMeas:Visible = false.
    end .
    else do :
      cbSGDKK:Visible = false.
      cbKPnoMeas:Visible = true.
    end .

    if infoSecsObj:Mode = {&lookup}
      then 
    do:
      
      maskedTextBoxTankVolPomi:Enabled = false.
      maskedTextBoxTankDensityPomi:Enabled = false.
      comboBoxShape:Enabled = false.
      comboBoxPour:Enabled = false.
      comboBoxGroupNP:Enabled = false.
      maskedTextBoxDocVolume:Enabled = false.
      cbSGDKK:Enabled = false.
      maskedTextBoxAukKey:Enabled = false.
      cbKPnoMeas:Enabled = false.
      
      if infoSecsObj:IsSGDKK
      then do :
        if cbSGDKK:Checked
        then do :
          label50:text = "Идентификатор доступа (ключ) «верхнего уровня» или одноразовый код:" .
        end .
        else do :
          label50:text = "Идентификатор доступа (ключ) «нижнего уровня»:" .
        end .
      end .
      
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
      buttonPlSiTemp:Visible = false.
      buttonCopyPSTemp:Visible = false.
      bRvsBef:enabled = false .
      bRvsAft:enabled = false .
      buttonCalcWeightRvs:Enabled = false.
      
      if infoSecsObj:IsKP
      then do :
        tmpInfoSecs = new InfoSectionsTotal () .
        tmpInfoSecs:Initialization(infoSecsObj:TrnDocNum, infoSecsObj:GdsCode) .
        do ii = 1 to tmpInfoSecs:SectionNum : 
          if tmpInfoSecs:GetInfoSectionProp(ii):ListTank = infoSecsObj:InfoSectionCurr:ListTank
          and tmpInfoSecs:GetInfoSectionProp(ii):SectionName <> infoSecsObj:InfoSectionCurr:SectionName
          and (infoSecsObj:InfoSectionCurr:AccMeth = 1 or tmpInfoSecs:GetInfoSectionProp(ii):AccMeth = 1)
          then do :
            bRvsBef:enabled = true .
            bRvsAft:enabled = true .
          end .
        end .
        delete object tmpInfoSecs .
      end .
      if infoSecsObj:InfoSectionCurr:IsKP
      then do :
        bRvsBef:enabled = true .
        bRvsAft:enabled = true .
        label51:Visible = true .
      end .
      
      if infoSecsObj:InfoSectionCurr:AccMeth = 1
      then do :
        buttonCalcResultAC:enabled = false .
      end .
      
      if infoSecsObj:InfoSectionCurr:TankWeightRvs = ?
      then do :
        buttonCalcResultRvs:enabled = false .
      end .
      
    end.
    
    if not infoSecsObj:FlagTrn and not infoSecsObj:Sts = "ФАКТ"
    then do:
      groupBox2:Visible = false.
      groupBox3:Visible = false.
      groupBox4:Visible = false.
      groupBox5:Visible = false.
      groupBox6:Visible = false.
      groupBox7:Visible = false.
      groupBox8:Visible = false.
      groupBox9:Visible = false.
      label50:Visible   = false.
      maskedTextBoxAukKey:visible = false.
      bRvsBef:visible   = false.
      bRvsAft:visible   = false.
      buttonCalcResultAC:visible   = false.
    end.
    
    if (infoSecsObj:Mode = "ДОБАВЛЕНИЕ" or infoSecsObj:Mode = "ИЗМЕНЕНИЕ") and not infoSecsObj:FlagTrn
    then do:
      
      find first ub.auto-tank no-lock where ub.auto-tank.auto-num = infoSecsObj:CarNum no-error.
      if available (ub.auto-tank)
      then do:
        comboBoxShape:Enabled = false.
        /*comboBoxPour:Enabled = false.*/ 
        maskedTextBoxCarVol:Enabled = false.       
      end.
      else do:
        comboBoxShape:Enabled = true.
        /*comboBoxPour:Enabled = true.*/
        maskedTextBoxCarVol:Enabled = true.
      end.

      comboBoxPour:Enabled = true.
      
      do ii = 1 to extent (maskedTextBoxDocArr):
        
        this-object:maskedTextBoxDocArr[ii]:BackColor = this-object:maskedTextBoxArr[ii]:BackColor.
        maskedTextBoxDocArr[ii]:ReadOnly = false.
/*        maskedTextBoxDocArr[ii]:TextChanged:Subscribe(this-object:ValueChgMaskTBox_5_3).*/
/*        this-object:maskedTextBoxCarVol:Visible = false.*/
/*        this-object:maskedTextBoxDiameter:Visible = false.*/
/*        label2:Visible = false.                           */
/*        label6:Visible = false.                           */
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
    
      if v-rvd-own-nb = false
      then do :
        find first buf_trn-doc no-lock where buf_trn-doc.doc-code = infoSecsObj:TrnDocNum no-error .
        if available buf_trn-doc
        then do :
          find first ub.clients-attr no-lock where ub.clients-attr.obj-type = buf_trn-doc.cli-type
                                               and ub.clients-attr.obj-code = buf_trn-doc.cli-code
                                               and ub.clients-attr.attr-code = {&attr-owner-code}
                                               no-error .
          if available ub.clients-attr
          and ub.clients-attr.attr-value > ""
          then do :
            if ub.clients-attr.attr-value = "орг" + string(buf_trn-doc.host-code)
            then do : 
              this-object:maskedTextBoxCliQnty:Enabled = false.    
              this-object:maskedTextBoxDocQnty:Enabled = false.
              this-object:maskedTextBoxDocDens:Enabled = false.
              this-object:maskedTextBoxSecName:Enabled = false.
              this-object:comboBoxGroupNP:Enabled = false.
              this-object:maskedTextBoxTTNTemp:Enabled = false.
              this-object:maskedTextBoxDocDensST:Enabled = false.
              this-object:maskedTextBoxAccShip:Enabled = false.
              this-object:maskedTextBoxDocVolume:Enabled = false.
              this-object:maskedTextBoxPressure:Enabled = false.
              this-object:comboBoxShape:Enabled = false.
              this-object:comboBoxPour:Enabled = false.
              this-object:button1:Enabled = false.
              this-object:maskedTextBoxNumPassport:Enabled = false.
              this-object:maskedTextBoxCarVol:Enabled = false.
              this-object:maskedTextBoxPaspDens:Enabled = false.
            end .
          end .
        end .
      end .
      
      this-object:label44:ForeColor = System.Drawing.Color:Red.
      
      do ii = 1 to num-entries(v-sec-fields) :
        v-field = entry(ii, v-sec-fields) .
        case v-field :
          when "section-name"
          then do :
            this-object:label7:ForeColor = System.Drawing.Color:Red.
          end .
          when "cli-qnty"
          then do :
            this-object:label4:ForeColor = System.Drawing.Color:Red.
          end .
          when "doc-dens"
          then do :
            this-object:label1:ForeColor = System.Drawing.Color:Red.
          end .
          when "group-np"
          then do :
            this-object:label46:ForeColor = System.Drawing.Color:Red.
            this-object:label47:ForeColor = System.Drawing.Color:Red.
            this-object:label49:ForeColor = System.Drawing.Color:Red.
          end .
          when "ttn-temp"
          then do :
            this-object:label5:ForeColor = System.Drawing.Color:Red.
          end .
          when "acc-ship"
          then do :
            this-object:label8:ForeColor = System.Drawing.Color:Red.
          end .
          when "doc-dens-st"
          then do :
            this-object:label45:ForeColor = System.Drawing.Color:Red.
          end .
          when "doc-qnty"
          then do :
            this-object:label3:ForeColor = System.Drawing.Color:Red.
          end .
          when "doc-volume"
          then do :
            this-object:label48:ForeColor = System.Drawing.Color:Red.
          end .
          when "shape"
          then do :
            this-object:comboBoxShape:ForeColor = System.Drawing.Color:Red.
          end .
          when "pour"
          then do :
            this-object:comboBoxPour:ForeColor = System.Drawing.Color:Red.
          end .
          when "num-passport"
          then do :
            this-object:label9:ForeColor = System.Drawing.Color:Red.
          end .
          when "car-vol"
          then do :
            this-object:label2:ForeColor = System.Drawing.Color:Red.
          end .
          when "pasp-dens"
          then do :
            this-object:label44:ForeColor = System.Drawing.Color:Red.
          end .
          when "list-tank"
          then do :
            this-object:label19:ForeColor = System.Drawing.Color:Red.
          end .
        end case .
      end .
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
      maskedTextBoxPlaceSiTemp:TextChanged:Subscribe(this-object:ClWght).
      comboBoxShape:Enabled = false .
      comboBoxPour:Enabled = false .
      maskedTextBoxCarVol:Enabled = false .
      comboBoxGroupNP:Enabled = false .
      maskedTextBoxDocVolume:Enabled = false .
      bRvsBef:enabled = false .
      bRvsAft:enabled = false .
      buttonCalcWeightRvs:Enabled = false .
      buttonCalcResultAC:Enabled = false .
      
      do ii = 1 to extent (maskedTextBoxDocArr):
        this-object:maskedTextBoxArr[ii]:BackColor = this-object:maskedTextBoxArr[ii]:BackColor.
        this-object:maskedTextBoxDocArr[ii]:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
        maskedTextBoxDocArr[ii]:Enabled = false.
      end.
      
      if infoSecsObj:IsSGDKK
      then do :
        if cbSGDKK:Checked
        then do :
          if infoSecsObj:InfoSectionCurr:AccMeth >= 0
          then do :
            cbSGDKK:Enabled = false.
          end .
          label50:text = "Идентификатор доступа (ключ) «верхнего уровня» или одноразовый код:" .
          label50:ForeColor = System.Drawing.Color:Red.
        end .
        else do :
          label50:text = "Идентификатор доступа (ключ) «нижнего уровня»:" .
          label50:ForeColor = System.Drawing.Color:Black.
        end .
        
        groupBox2:Enabled = false.
        groupBox3:Enabled = false.
        groupBox4:Enabled = false.
        groupBox5:Enabled = false.
        groupBox6:Enabled = false.
        groupBox7:Enabled = false.
        groupBox8:Enabled = false.
        buttonCalcResultAC:Enabled = false.
      end .
      else do :
        cbKPnoMeas:Enabled = false.
        if cbKPnoMeas:Checked
        then do :
          groupBox2:Enabled = false.
          groupBox3:Enabled = false.
          groupBox4:Enabled = false.
          groupBox5:Enabled = false.
          groupBox6:Enabled = false.
          groupBox7:Enabled = false.
          groupBox8:Enabled = false.
          buttonCalcResultAC:Enabled = false.
        end .
      end .
      
      if infoSecsObj:InfoSectionCurr:AccMeth = 1
      then do :
        buttonCalcWeightRvs:Enabled = true.
        buttonCalcWeight:Enabled = false.
        buttonCalcResultAC:Enabled = false.
        groupBox3:Enabled = false.
        groupBox7:Enabled = false.
        groupBox8:Enabled = false.
      end .
      
      if infoSecsObj:IsKP
      then do :
        if cbSGDKK:Checked
        and infoSecsObj:InfoSectionCurr:AccMeth = 0
        then do :
          groupBox2:Enabled = true.
          groupBox3:Enabled = true.
          groupBox4:Enabled = true.
          groupBox5:Enabled = true.
          groupBox6:Enabled = true.
          groupBox7:Enabled = true.
          groupBox8:Enabled = true.
/*          this-object:maskedTextBoxCarVol:Enabled = true.*/
/*          comboBoxPour:Enabled = true.                   */
/*          comboBoxShape:Enabled = true.                  */
        end .
        if infoSecsObj:InfoSectionCurr:AccMeth = 0
        then do :
          buttonCalcResultAC:Enabled = true.
        end .
        tmpInfoSecs = new InfoSectionsTotal () .
        tmpInfoSecs:Initialization(infoSecsObj:TrnDocNum, infoSecsObj:GdsCode) .
        do ii = 1 to tmpInfoSecs:SectionNum : 
          if tmpInfoSecs:GetInfoSectionProp(ii):ListTank = infoSecsObj:InfoSectionCurr:ListTank
          and tmpInfoSecs:GetInfoSectionProp(ii):SectionName <> infoSecsObj:InfoSectionCurr:SectionName
          and (infoSecsObj:InfoSectionCurr:IsKP or tmpInfoSecs:GetInfoSectionProp(ii):IsKP)
          then do :
            bRvsBef:enabled = true .
            bRvsAft:enabled = true .
          end .
        end .
        delete object tmpInfoSecs .
      end .
      
      if infoSecsObj:InfoSectionCurr:IsKP
      then do :
        label51:Visible = true .
        if infoSecsObj:IsActnComm
        then do :
          find first buf_rvs-doc no-lock where buf_rvs-doc.out-code = infoSecsObj:TrnDocNum no-error .
          if available buf_rvs-doc
          then do :
            bRvsBef:enabled = true .
            bRvsAft:enabled = true .
          end .
        end .
        else do :
          groupBox2:Enabled = false.
          groupBox3:Enabled = false.
          groupBox4:Enabled = false.
          groupBox5:Enabled = false.
          groupBox6:Enabled = false.
          groupBox7:Enabled = false.
          groupBox8:Enabled = false.
          buttonCalcResultAC:Enabled = false.
          if infoSecsObj:IsSGDKK
          then do :
            cbSGDKK:Enabled = false.
            maskedTextBoxAukKey:Enabled = false.
          end .
        end .
      end .
      
      
      if infoSecsObj:RdcDnstvalue = "not"
      then do:
        this-object:maskedTextBoxTankVol:Leave:Subscribe(this-object:calc-weight-vol).
        this-object:maskedTextBoxTankVol:Enabled = false.
        this-object:maskedTextBoxTankVol:ReadOnly = true.
        this-object:maskedTextBoxTankWeight:ForeColor = System.Drawing.Color:Red.
        this-object:maskedTextBoxTankVol:ForeColor = System.Drawing.Color:Red.
        this-object:maskedTextBoxTankWeight:Enabled = false.
        this-object:maskedTextBoxTankWater:Enabled = false.
/*        if not infoSecsObj:CliQntyInput                                                                                                                                                                                                     */
/*          then do:                                                                                                                                                                                                                          */
/*            this-object:maskedTextBoxTankWeight:ForeColor = System.Drawing.Color:Maroon.                                                                                                                                                    */
/*            this-object:maskedTextBoxTankWeight:Enabled = false.                                                                                                                                                                            */
/*            this-object:maskedTextBoxTankWeight:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).*/
/*            this-object:maskedTextBoxTankWeight:Leave:Unsubscribe(this-object:calc-weight-vol).                                                                                                                                             */
/*/*          this-object:maskedTextBoxDocDens:TextChanged:Subscribe(this-object:CalcDoc).*/                                                                                                                                                  */
/*/*          this-object:maskedTextBoxDocQnty:TextChanged:Subscribe(this-object:CalcDoc).*/                                                                                                                                                  */
/*          end.                                                                                                                                                                                                                              */
/*        if not infoSecsObj:DocQntyInput                                                                                                                                                                                                     */
/*          then do:                                                                                                                                                                                                                          */
/*            this-object:maskedTextBoxTankVol:Enabled = false.                                                                                                                                                                               */
/*            this-object:maskedTextBoxTankVol:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).   */
/*            this-object:maskedTextBoxTankVol:Leave:Unsubscribe(this-object:calc-weight-vol).                                                                                                                                                */
/*/*          this-object:maskedTextBoxDocDens:TextChanged:Subscribe(this-object:CalcDoc).   */                                                                                                                                               */
/*/*          this-object:maskedTextBoxTankWeight:TextChanged:Subscribe(this-object:CalcDoc).*/                                                                                                                                               */
/*          end.                                                                                                                                                                                                                              */
/*        if not infoSecsObj:DensityInput                                                                                                                                                                                                     */
/*          then do:                                                                                                                                                                                                                          */
/*            this-object:maskedTextBoxTankDens:Enabled = false.                                                                                                                                                                              */
/*            this-object:maskedTextBoxTankDens:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).  */
/*            this-object:maskedTextBoxTankDens:Leave:Unsubscribe(this-object:calc-weight-vol).                                                                                                                                               */
/*/*          this-object:maskedTextBoxDocQnty:TextChanged:Subscribe(this-object:CalcDoc).*/                                                                                                                                                  */
/*/*          this-object:maskedTextBoxCliQnty:TextChanged:Subscribe(this-object:CalcDoc).*/                                                                                                                                                  */
/*          end.                                                                                                                                                                                                                              */
      end.
      else do :
        this-object:maskedTextBoxTankWater:Visible = false.
        this-object:label18:Visible = false.
      end .
      maskedTextBoxListTank:Enabled = false.
      
      do ii = 1 to num-entries(v-sec-fields) :
        v-field = entry(ii, v-sec-fields) .
        case v-field :
          when "a-b-tarir"
          then do :
            this-object:label13:ForeColor = System.Drawing.Color:Red.
          end .
          when "tank-density"
          then do :
            this-object:label39:ForeColor = System.Drawing.Color:Red.
          end .
          when "tank-temp"
          then do :
            this-object:label20:ForeColor = System.Drawing.Color:Red.
          end .
          when "dens-temp"
          then do :
            this-object:label21:ForeColor = System.Drawing.Color:Red.
          end .
          when "place-si"
          then do :
            this-object:label26:ForeColor = System.Drawing.Color:Red.
          end .
          when "place-si-temp"
          then do :
            this-object:label43:ForeColor = System.Drawing.Color:Red.
          end .
          when "accessIDLowerLevel"
          then do :
            this-object:label50:ForeColor = System.Drawing.Color:Red.
          end .
        end case .
      end .
    end.

    if not infoSecsObj:IsSGDKK
    then do :
      label50:Visible             = false.
      maskedTextBoxAukKey:visible = false.
      cbSGDKK:enabled             = false.
    end .
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
    this-object:maskedTextBoxTPNorm = new System.Windows.Forms.MaskedTextBox().
    this-object:label39 = new System.Windows.Forms.Label().
    this-object:label21 = new System.Windows.Forms.Label().
    this-object:label20 = new System.Windows.Forms.Label().
    this-object:label18 = new System.Windows.Forms.Label().
    this-object:label17 = new System.Windows.Forms.Label().
    this-object:label16 = new System.Windows.Forms.Label().
    this-object:label15 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNaturLoss = new System.Windows.Forms.MaskedTextBox().
    this-object:label14 = new System.Windows.Forms.Label().
    this-object:label13 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxTankVol = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxDiameter = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankDens = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxDensTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankWater = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxABTArir = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxMouth = new System.Windows.Forms.MaskedTextBox().
    this-object:buttonPl = new System.Windows.Forms.Button().
    this-object:label19 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxListTank = new System.Windows.Forms.MaskedTextBox().
    this-object:groupBox2 = new System.Windows.Forms.GroupBox().
    this-object:buttonCopySec = new System.Windows.Forms.Button().
    this-object:maskedTextBoxValidityCertif = new System.Windows.Forms.MaskedTextBox().
    this-object:label12 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxCertifFuel = new System.Windows.Forms.MaskedTextBox().
    this-object:label11 = new System.Windows.Forms.Label().
    this-object:label10 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNormDoc = new System.Windows.Forms.MaskedTextBox().
    this-object:label9 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNumPassport = new System.Windows.Forms.MaskedTextBox().
    this-object:groupBox1 = new System.Windows.Forms.GroupBox().
    this-object:label51 = new System.Windows.Forms.Label().
    this-object:label49 = new System.Windows.Forms.Label().
    this-object:label48 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxDocVolume = new System.Windows.Forms.MaskedTextBox().
    this-object:label47 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxPressure = new System.Windows.Forms.MaskedTextBox().
    this-object:comboBoxGroupNP = new System.Windows.Forms.ComboBox().
    this-object:label46 = new System.Windows.Forms.Label().
    this-object:label45 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxDocDensST = new System.Windows.Forms.MaskedTextBox().
    this-object:label44 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxPaspDens = new System.Windows.Forms.MaskedTextBox().
    this-object:button1 = new System.Windows.Forms.Button().
    this-object:comboBoxPour = new System.Windows.Forms.ComboBox().
    this-object:comboBoxShape = new System.Windows.Forms.ComboBox().
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
    this-object:label31 = new System.Windows.Forms.Label().
    this-object:TimeProb = new System.Windows.Forms.DateTimePicker().
    this-object:label32 = new System.Windows.Forms.Label().
    this-object:DateTimeDateProb = new System.Windows.Forms.DateTimePicker().
    this-object:label33 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxKolProb = new System.Windows.Forms.MaskedTextBox().
    this-object:label34 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxTests = new System.Windows.Forms.MaskedTextBox().
    this-object:label35 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNumPrintProb = new System.Windows.Forms.MaskedTextBox().
    this-object:groupBox6 = new System.Windows.Forms.GroupBox().
    this-object:label27 = new System.Windows.Forms.Label().
    this-object:label28 = new System.Windows.Forms.Label().
    this-object:label29 = new System.Windows.Forms.Label().
    this-object:label30 = new System.Windows.Forms.Label().
    this-object:dateTimePickerDateStart = new System.Windows.Forms.DateTimePicker().
    this-object:dateTimePickerDateEnd = new System.Windows.Forms.DateTimePicker().
    this-object:dateTimePickerTimeStart = new System.Windows.Forms.DateTimePicker().
    this-object:dateTimePickerTimeEnd = new System.Windows.Forms.DateTimePicker().
    this-object:groupBox5 = new System.Windows.Forms.GroupBox().
    this-object:bRvsAft = new System.Windows.Forms.Button().
    this-object:bRvsBef = new System.Windows.Forms.Button().
    this-object:maskedTextBoxAccWeight = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankWeight = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankVolPomi = new System.Windows.Forms.MaskedTextBox().
    this-object:maskedTextBoxTankDensityPomi = new System.Windows.Forms.MaskedTextBox().
    this-object:label22 = new System.Windows.Forms.Label().
    this-object:label23 = new System.Windows.Forms.Label().
    this-object:label24 = new System.Windows.Forms.Label().
    this-object:label25 = new System.Windows.Forms.Label().
    this-object:buttonCalcWeight = new System.Windows.Forms.Button().
    this-object:groupBox4 = new System.Windows.Forms.GroupBox().
    this-object:groupBox8 = new System.Windows.Forms.GroupBox().
    this-object:textBoxPlSiNameTemp = new System.Windows.Forms.TextBox().
    this-object:dateTimePickerDatePovTemp = new System.Windows.Forms.DateTimePicker().
    this-object:buttonCopyPSTemp = new System.Windows.Forms.Button().
    this-object:label40 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxPassportTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:label41 = new System.Windows.Forms.Label().
    this-object:label42 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxNumTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:buttonPlSiTemp = new System.Windows.Forms.Button().
    this-object:maskedTextBoxPlaceSiTemp = new System.Windows.Forms.MaskedTextBox().
    this-object:label43 = new System.Windows.Forms.Label().
    this-object:cbSGDKK = new System.Windows.Forms.CheckBox().
    this-object:label50 = new System.Windows.Forms.Label().
    this-object:maskedTextBoxAukKey = new System.Windows.Forms.MaskedTextBox().
    this-object:buttonCalcResultRvs = new System.Windows.Forms.Button().
    this-object:buttonCalcWeightRvs = new System.Windows.Forms.Button().
    this-object:groupBox9 = new System.Windows.Forms.GroupBox().
    this-object:cbKPnoMeas = new System.Windows.Forms.CheckBox().
    this-object:buttonCalcResultAC = new System.Windows.Forms.Button().
    this-object:groupBox3:SuspendLayout().
    this-object:groupBox2:SuspendLayout().
    this-object:groupBox1:SuspendLayout().
    this-object:groupBox7:SuspendLayout().
    this-object:groupBox6:SuspendLayout().
    this-object:groupBox5:SuspendLayout().
    this-object:groupBox4:SuspendLayout().
    this-object:groupBox8:SuspendLayout().
    this-object:groupBox9:SuspendLayout().
    this-object:SuspendLayout().
    /*  */
    /* groupBox3 */
    /*  */
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTPNorm).
    this-object:groupBox3:Controls:Add(this-object:label39).
    this-object:groupBox3:Controls:Add(this-object:label21).
    this-object:groupBox3:Controls:Add(this-object:label20).
    this-object:groupBox3:Controls:Add(this-object:label18).
    this-object:groupBox3:Controls:Add(this-object:label17).
    this-object:groupBox3:Controls:Add(this-object:label16).
    this-object:groupBox3:Controls:Add(this-object:label15).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxNaturLoss).
    this-object:groupBox3:Controls:Add(this-object:label14).
    this-object:groupBox3:Controls:Add(this-object:label13).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankVol).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxDiameter).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankDens).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxDensTemp).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankTemp).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxTankWater).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxABTArir).
    this-object:groupBox3:Controls:Add(this-object:maskedTextBoxMouth).
    this-object:groupBox3:Location = new System.Drawing.Point(10, 353).
    this-object:groupBox3:Name = "groupBox3".
    this-object:groupBox3:Size = new System.Drawing.Size(682, 140).
    this-object:groupBox3:TabIndex = 2.
    this-object:groupBox3:TabStop = false.
    this-object:groupBox3:UseCompatibleTextRendering = true.
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
    this-object:label39:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label39:ForeColor = System.Drawing.SystemColors:ControlText.
    this-object:label39:Location = new System.Drawing.Point(23, 63).
    this-object:label39:Name = "label39".
    this-object:label39:Size = new System.Drawing.Size(162, 20).
    this-object:label39:TabIndex = 25.
    this-object:label39:Text = "Плотность топлива,г/см3:".
    this-object:label39:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label39:UseCompatibleTextRendering = true.
    /*  */
    /* label21 */
    /*  */
    this-object:label21:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label21:ForeColor = System.Drawing.SystemColors:ControlText.
    this-object:label21:Location = new System.Drawing.Point(297, 84).
    this-object:label21:Name = "label21".
    this-object:label21:Size = new System.Drawing.Size(117, 27).
    this-object:label21:TabIndex = 26.
    this-object:label21:Text = "Температура замера плотности,C:".
    this-object:label21:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label21:UseCompatibleTextRendering = true.
    /*  */
    /* label20 */
    /*  */
    this-object:label20:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label20:ForeColor = System.Drawing.SystemColors:ControlText.
    this-object:label20:Location = new System.Drawing.Point(297, 57).
    this-object:label20:Name = "label20".
    this-object:label20:Size = new System.Drawing.Size(117, 26).
    this-object:label20:TabIndex = 27.
    this-object:label20:Text = "Температура замера объема,C:".
    this-object:label20:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label20:UseCompatibleTextRendering = true.
    /*  */
    /* label18 */
    /*  */
    this-object:label18:Location = new System.Drawing.Point(297, 34).
    this-object:label18:Name = "label18".
    this-object:label18:Size = new System.Drawing.Size(117, 20).
    this-object:label18:TabIndex = 29.
    this-object:label18:Text = "Объем воды,л:".
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
    this-object:label16:Text = "Масса ЕУ,кг:".
    this-object:label16:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label16:UseCompatibleTextRendering = true.
    /*  */
    /* label15 */
    /*  */
    this-object:label15:Location = new System.Drawing.Point(68, 38).
    this-object:label15:Name = "label15".
    this-object:label15:Size = new System.Drawing.Size(117, 20).
    this-object:label15:TabIndex = 32.
    this-object:label15:Text = "Объем топлива,л:".
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
    this-object:label14:Text = "Объем горловины,л:".
    this-object:label14:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label14:UseCompatibleTextRendering = true.
    /*  */
    /* label13 */
    /*  */
    this-object:label13:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label13:ForeColor = System.Drawing.SystemColors:ControlText.
    this-object:label13:Location = new System.Drawing.Point(6, 9).
    this-object:label13:Name = "label13".
    this-object:label13:Size = new System.Drawing.Size(179, 28).
    this-object:label13:TabIndex = 34.
    this-object:label13:Text = "Отклонение от тарировочной планки, мм:".
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
    /* maskedTextBoxDiameter */
    /*  */
    this-object:maskedTextBoxDiameter:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxDiameter:Location = new System.Drawing.Point(570, 38).
    this-object:maskedTextBoxDiameter:Name = "maskedTextBoxDiameter".
    this-object:maskedTextBoxDiameter:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxDiameter:TabIndex = 8.
    this-object:maskedTextBoxDiameter:Visible = false.
    this-object:maskedTextBoxDiameter:Leave:Subscribe(this-object:calc-weight-vol).
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
    this-object:maskedTextBoxABTArir:KeyPress:Subscribe(this-object:KeyPressMaskTBIntNegNum_4).
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
    /* buttonPl */
    /*  */
    this-object:buttonPl:Location = new System.Drawing.Point(632, 136).
    this-object:buttonPl:Name = "buttonPl".
    this-object:buttonPl:Size = new System.Drawing.Size(47, 23).
    this-object:buttonPl:TabIndex = 24.
    this-object:buttonPl:Text = "Выбор".
    this-object:buttonPl:UseCompatibleTextRendering = true.
    this-object:buttonPl:UseVisualStyleBackColor = true.
    this-object:buttonPl:Click:Subscribe(this-object:buttonPl_Click).
    /*  */
    /* label19 */
    /*  */
    this-object:label19:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label19:ForeColor = System.Drawing.SystemColors:ControlText.
    this-object:label19:Location = new System.Drawing.Point(534, 140).
    this-object:label19:Name = "label19".
    this-object:label19:Size = new System.Drawing.Size(70, 18).
    this-object:label19:TabIndex = 28.
    this-object:label19:Text = "Резервуар:".
    this-object:label19:TextAlign = System.Drawing.ContentAlignment:TopRight.
    this-object:label19:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxListTank */
    /*  */
    this-object:maskedTextBoxListTank:Enabled = false.
    this-object:maskedTextBoxListTank:Location = new System.Drawing.Point(603, 138).
    this-object:maskedTextBoxListTank:Name = "maskedTextBoxListTank".
    this-object:maskedTextBoxListTank:Size = new System.Drawing.Size(29, 20).
    this-object:maskedTextBoxListTank:TabIndex = 23.
    this-object:maskedTextBoxListTank:KeyPress:Subscribe(this-object:KeyPressMaskTBIntNegNum_2).
    /*  */
    /* groupBox2 */
    /*  */
    this-object:groupBox2:Controls:Add(this-object:buttonCopySec).
    this-object:groupBox2:Controls:Add(this-object:maskedTextBoxValidityCertif).
    this-object:groupBox2:Controls:Add(this-object:label12).
    this-object:groupBox2:Controls:Add(this-object:maskedTextBoxCertifFuel).
    this-object:groupBox2:Controls:Add(this-object:label11).
    this-object:groupBox2:Controls:Add(this-object:label10).
    this-object:groupBox2:Controls:Add(this-object:maskedTextBoxNormDoc).
    this-object:groupBox2:Location = new System.Drawing.Point(10, 217).
    this-object:groupBox2:Name = "groupBox2".
    this-object:groupBox2:Size = new System.Drawing.Size(682, 132).
    this-object:groupBox2:TabIndex = 1.
    this-object:groupBox2:TabStop = false.
    this-object:groupBox2:UseCompatibleTextRendering = true.
    /*  */
    /* buttonCopySec */
    /*  */
    this-object:buttonCopySec:Location = new System.Drawing.Point(595, 102).
    this-object:buttonCopySec:Name = "buttonCopySec".
    this-object:buttonCopySec:Size = new System.Drawing.Size(75, 29).
    this-object:buttonCopySec:TabIndex = 13.
    this-object:buttonCopySec:Text = "Копировать в секции".
    this-object:buttonCopySec:UseCompatibleTextRendering = true.
    this-object:buttonCopySec:UseVisualStyleBackColor = true.
    this-object:buttonCopySec:Click:Subscribe(this-object:buttonCopySec_Click).
    /*  */
    /* maskedTextBoxValidityCertif */
    /*  */
    this-object:maskedTextBoxValidityCertif:Location = new System.Drawing.Point(420, 105).
    this-object:maskedTextBoxValidityCertif:Name = "maskedTextBoxValidityCertif".
    this-object:maskedTextBoxValidityCertif:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxValidityCertif:TabIndex = 12.
    /*  */
    /* label12 */
    /*  */
    this-object:label12:Location = new System.Drawing.Point(8, 102).
    this-object:label12:Name = "label12".
    this-object:label12:Size = new System.Drawing.Size(406, 29).
    this-object:label12:TabIndex = 14.
    this-object:label12:Text = "Срок действия сертификата соответствия завода-изготовителя (на марку моторного топлива) из паспорта качества:".
    this-object:label12:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label12:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxCertifFuel */
    /*  */
    this-object:maskedTextBoxCertifFuel:Location = new System.Drawing.Point(7, 79).
    this-object:maskedTextBoxCertifFuel:Name = "maskedTextBoxCertifFuel".
    this-object:maskedTextBoxCertifFuel:Size = new System.Drawing.Size(663, 20).
    this-object:maskedTextBoxCertifFuel:TabIndex = 11.
    /*  */
    /* label11 */
    /*  */
    this-object:label11:Location = new System.Drawing.Point(8, 59).
    this-object:label11:Name = "label11".
    this-object:label11:Size = new System.Drawing.Size(664, 20).
    this-object:label11:TabIndex = 15.
    this-object:label11:Text = "Сертификат соответствия завода-изготовителя (на марку моторного топлива) № :".
    this-object:label11:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label11:UseCompatibleTextRendering = true.
    /*  */
    /* label10 */
    /*  */
    this-object:label10:Location = new System.Drawing.Point(7, 16).
    this-object:label10:Name = "label10".
    this-object:label10:Size = new System.Drawing.Size(664, 20).
    this-object:label10:TabIndex = 16.
    this-object:label10:Text = "Нормативный документ завода-изготовителя (ГОСТ, ТУ на марку моторного топлива) из паспорта качества:".
    this-object:label10:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label10:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNormDoc */
    /*  */
    this-object:maskedTextBoxNormDoc:Location = new System.Drawing.Point(8, 37).
    this-object:maskedTextBoxNormDoc:Name = "maskedTextBoxNormDoc".
    this-object:maskedTextBoxNormDoc:Size = new System.Drawing.Size(663, 20).
    this-object:maskedTextBoxNormDoc:TabIndex = 10.
    /*  */
    /* label9 */
    /*  */
    this-object:label9:Location = new System.Drawing.Point(12, 114).
    this-object:label9:Name = "label9".
    this-object:label9:Size = new System.Drawing.Size(188, 20).
    this-object:label9:TabIndex = 17.
    this-object:label9:Text = "Дата и номер паспорта качества:".
    this-object:label9:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label9:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNumPassport */
    /*  */
    this-object:maskedTextBoxNumPassport:Location = new System.Drawing.Point(206, 114).
    this-object:maskedTextBoxNumPassport:Name = "maskedTextBoxNumPassport".
    this-object:maskedTextBoxNumPassport:Size = new System.Drawing.Size(464, 20).
    this-object:maskedTextBoxNumPassport:TabIndex = 9.
    /*  */
    /* groupBox1 */
    /*  */
    this-object:groupBox1:AccessibleName = "".
    this-object:groupBox1:Controls:Add(this-object:label51).
    this-object:groupBox1:Controls:Add(this-object:label49).
    this-object:groupBox1:Controls:Add(this-object:buttonPl).
    this-object:groupBox1:Controls:Add(this-object:label48).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxDocVolume).
    this-object:groupBox1:Controls:Add(this-object:label47).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxPressure).
    this-object:groupBox1:Controls:Add(this-object:comboBoxGroupNP).
    this-object:groupBox1:Controls:Add(this-object:label19).
    this-object:groupBox1:Controls:Add(this-object:label46).
    this-object:groupBox1:Controls:Add(this-object:label45).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxDocDensST).
    this-object:groupBox1:Controls:Add(this-object:label44).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxPaspDens).
    this-object:groupBox1:Controls:Add(this-object:button1).
    this-object:groupBox1:Controls:Add(this-object:comboBoxPour).
    this-object:groupBox1:Controls:Add(this-object:comboBoxShape).
    this-object:groupBox1:Controls:Add(this-object:label8).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxAccShip).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxSecName).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxListTank).
    this-object:groupBox1:Controls:Add(this-object:label9).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxNumPassport).
    this-object:groupBox1:Controls:Add(this-object:label7).
    this-object:groupBox1:Controls:Add(this-object:label6).
    this-object:groupBox1:Controls:Add(this-object:label5).
    this-object:groupBox1:Controls:Add(this-object:label4).
    this-object:groupBox1:Controls:Add(this-object:label3).
    this-object:groupBox1:Controls:Add(this-object:label2).
    this-object:groupBox1:Controls:Add(this-object:label1).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxCliQnty).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxDocQnty).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxCarVol).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxTTNTemp).
    this-object:groupBox1:Controls:Add(this-object:maskedTextBoxDocDens).
    this-object:groupBox1:Location = new System.Drawing.Point(10, 3).
    this-object:groupBox1:Name = "groupBox1".
    this-object:groupBox1:Size = new System.Drawing.Size(682, 177).
    this-object:groupBox1:TabIndex = 0.
    this-object:groupBox1:TabStop = false.
    this-object:groupBox1:UseCompatibleTextRendering = true.
    /*  */
    /* label51 */
    /*  */
    this-object:label51:BackColor = System.Drawing.Color:Yellow.
    this-object:label51:Font = new System.Drawing.Font("Times New Roman", Progress.Util.CastUtil:ToSingle(10), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label51:ForeColor = System.Drawing.Color:FromArgb(System.Convert:ToInt32(System.Convert:ToByte(192)), System.Convert:ToInt32(System.Convert:ToByte(0)), System.Convert:ToInt32(System.Convert:ToByte(0))).
    this-object:label51:Location = new System.Drawing.Point(589, 162).
    this-object:label51:Name = "label51".
    this-object:label51:Size = new System.Drawing.Size(94, 13).
    this-object:label51:TabIndex = 30.
    this-object:label51:Text = "Комис. приём".
    this-object:label51:TextAlign = System.Drawing.ContentAlignment:MiddleCenter.
    this-object:label51:UseCompatibleTextRendering = true.
    /*  */
    /* label49 */
    /*  */
    this-object:label49:Location = new System.Drawing.Point(12, 161).
    this-object:label49:Name = "label49".
    this-object:label49:Size = new System.Drawing.Size(634, 14).
    this-object:label49:TabIndex = 29.
    this-object:label49:Text = "*Обязательным для заполнения является либо Группа нефтепродуктов, либо Давление насыщенных паров".
    this-object:label49:UseCompatibleTextRendering = true.
    /*  */
    /* label48 */
    /*  */
    this-object:label48:Location = new System.Drawing.Point(497, 58).
    this-object:label48:Name = "label48".
    this-object:label48:Size = new System.Drawing.Size(95, 20).
    this-object:label48:TabIndex = 27.
    this-object:label48:Text = "Объем по док.,л:".
    this-object:label48:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label48:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxDocVolume */
    /*  */
    this-object:maskedTextBoxDocVolume:Location = new System.Drawing.Point(596, 58).
    this-object:maskedTextBoxDocVolume:Name = "maskedTextBoxDocVolume".
    this-object:maskedTextBoxDocVolume:Size = new System.Drawing.Size(77, 20).
    this-object:maskedTextBoxDocVolume:TabIndex = 26.
    this-object:maskedTextBoxDocVolume:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* label47 */
    /*  */
    this-object:label47:Location = new System.Drawing.Point(0, 87).
    this-object:label47:Name = "label47".
    this-object:label47:Size = new System.Drawing.Size(203, 20).
    this-object:label47:TabIndex = 25.
    this-object:label47:Text = "Давление насыщенных паров, кПа:*".
    this-object:label47:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label47:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxPressure */
    /*  */
    this-object:maskedTextBoxPressure:ForeColor = System.Drawing.SystemColors:WindowText.
    this-object:maskedTextBoxPressure:Location = new System.Drawing.Point(206, 87).
    this-object:maskedTextBoxPressure:Name = "maskedTextBoxPressure".
    this-object:maskedTextBoxPressure:Size = new System.Drawing.Size(74, 20).
    this-object:maskedTextBoxPressure:TabIndex = 24.
    this-object:maskedTextBoxPressure:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_3_1).
    this-object:maskedTextBoxPressure:Leave:Subscribe(this-object:PressureLeave).
    /*  */
    /* comboBoxGroupNP */
    /*  */
    this-object:comboBoxGroupNP:FormattingEnabled = true.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar0 as System.Object extent 5 no-undo.
    arrayvar0[1] = "".
    arrayvar0[2] = "I".
    arrayvar0[3] = "II".
    arrayvar0[4] = "III".
    arrayvar0[5] = "IV".
    this-object:comboBoxGroupNP:Items:AddRange(arrayvar0).
    this-object:comboBoxGroupNP:Location = new System.Drawing.Point(104, 60).
    this-object:comboBoxGroupNP:Name = "comboBoxGroupNP".
    this-object:comboBoxGroupNP:Size = new System.Drawing.Size(81, 21).
    this-object:comboBoxGroupNP:TabIndex = 23.
    /*  */
    /* label46 */
    /*  */
    this-object:label46:Location = new System.Drawing.Point(33, 60).
    this-object:label46:Name = "label46".
    this-object:label46:Size = new System.Drawing.Size(80, 20).
    this-object:label46:TabIndex = 22.
    this-object:label46:Text = "Группа НП:*".
    this-object:label46:TextAlign = System.Drawing.ContentAlignment:MiddleLeft.
    this-object:label46:UseCompatibleTextRendering = true.
    /*  */
    /* label45 */
    /*  */
    this-object:label45:Location = new System.Drawing.Point(191, 59).
    this-object:label45:Name = "label45".
    this-object:label45:Size = new System.Drawing.Size(234, 20).
    this-object:label45:TabIndex = 21.
    this-object:label45:Text = "Плотность по док. (при станд. темп.),г/см3:".
    this-object:label45:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label45:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxDocDensST */
    /*  */
    this-object:maskedTextBoxDocDensST:ForeColor = System.Drawing.SystemColors:WindowText.
    this-object:maskedTextBoxDocDensST:Location = new System.Drawing.Point(432, 59).
    this-object:maskedTextBoxDocDensST:Name = "maskedTextBoxDocDensST".
    this-object:maskedTextBoxDocDensST:Size = new System.Drawing.Size(76, 20).
    this-object:maskedTextBoxDocDensST:TabIndex = 20.
    this-object:maskedTextBoxDocDensST:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_4).
    /*  */
    /* label44 */
    /*  */
    this-object:label44:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label44:Location = new System.Drawing.Point(241, 138).
    this-object:label44:Name = "label44".
    this-object:label44:Size = new System.Drawing.Size(238, 20).
    this-object:label44:TabIndex = 19.
    this-object:label44:Text = "Плотность по пасп. (при станд. темп.),г/см3:".
    this-object:label44:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label44:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxPaspDens */
    /*  */
    this-object:maskedTextBoxPaspDens:ForeColor = System.Drawing.SystemColors:WindowText.
    this-object:maskedTextBoxPaspDens:Location = new System.Drawing.Point(482, 138).
    this-object:maskedTextBoxPaspDens:Name = "maskedTextBoxPaspDens".
    this-object:maskedTextBoxPaspDens:Size = new System.Drawing.Size(58, 20).
    this-object:maskedTextBoxPaspDens:TabIndex = 18.
    this-object:maskedTextBoxPaspDens:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_4).
    /*  */
    /* button1 */
    /*  */
    this-object:button1:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:button1:ImageAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:button1:Location = new System.Drawing.Point(643, 82).
    this-object:button1:Name = "button1".
    this-object:button1:Size = new System.Drawing.Size(27, 27).
    this-object:button1:TabIndex = 14.
    this-object:button1:Text = "...".
    this-object:button1:TextAlign = System.Drawing.ContentAlignment:TopCenter.
    this-object:button1:UseCompatibleTextRendering = true.
    this-object:button1:UseVisualStyleBackColor = true.
    this-object:button1:Click:Subscribe(this-object:button1_Click).
    /*  */
    /* comboBoxPour */
    /*  */
    this-object:comboBoxPour:FormattingEnabled = true.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar1 as System.Object extent 2 no-undo.
    arrayvar1[1] = "Верхний налив".
    arrayvar1[2] = "Нижний налив".
    this-object:comboBoxPour:Items:AddRange(arrayvar1).
    this-object:comboBoxPour:Location = new System.Drawing.Point(357, 86).
    this-object:comboBoxPour:Name = "comboBoxPour".
    this-object:comboBoxPour:Size = new System.Drawing.Size(100, 21).
    this-object:comboBoxPour:TabIndex = 13.
    this-object:comboBoxPour:Text = "Верхний налив".
    this-object:comboBoxPour:SelectedIndexChanged:Subscribe(this-object:comboBox2_SelectedIndexChanged).
    /*  */
    /* comboBoxShape */
    /*  */
    this-object:comboBoxShape:FormattingEnabled = true.
    @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
    define variable arrayvar2 as System.Object extent 1 no-undo.
    arrayvar2[1] = "".
    this-object:comboBoxShape:Items:AddRange(arrayvar2).
    this-object:comboBoxShape:Location = new System.Drawing.Point(464, 86).
    this-object:comboBoxShape:Name = "comboBoxShape".
    this-object:comboBoxShape:Size = new System.Drawing.Size(172, 21).
    this-object:comboBoxShape:TabIndex = 12.
    this-object:comboBoxShape:Text = "Квадратная/прямоугольная".
    this-object:comboBoxShape:SelectedIndexChanged:Subscribe(this-object:comboBox1_SelectedIndexChanged).
    this-object:comboBoxShape:SelectedValueChanged:Subscribe(this-object:comboBoxShape_SelectedValueChanged).
    /*  */
    /* label8 */
    /*  */
    this-object:label8:Location = new System.Drawing.Point(496, 8).
    this-object:label8:Name = "label8".
    this-object:label8:Size = new System.Drawing.Size(96, 20).
    this-object:label8:TabIndex = 0.
    this-object:label8:Text = "Погр. изм. пост.:".
    this-object:label8:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label8:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxAccShip */
    /*  */
    this-object:maskedTextBoxAccShip:Location = new System.Drawing.Point(595, 8).
    this-object:maskedTextBoxAccShip:Name = "maskedTextBoxAccShip".
    this-object:maskedTextBoxAccShip:Size = new System.Drawing.Size(77, 20).
    this-object:maskedTextBoxAccShip:TabIndex = 3.
    this-object:maskedTextBoxAccShip:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_2).
    /*  */
    /* maskedTextBoxSecName */
    /*  */
    this-object:maskedTextBoxSecName:Location = new System.Drawing.Point(104, 8).
    this-object:maskedTextBoxSecName:Name = "maskedTextBoxSecName".
    this-object:maskedTextBoxSecName:Size = new System.Drawing.Size(81, 20).
    this-object:maskedTextBoxSecName:TabIndex = 1.
    this-object:maskedTextBoxSecName:KeyPress:Subscribe(this-object:KeyPressMaskTBInt).
    this-object:maskedTextBoxSecName:Leave:Subscribe(this-object:maskedTextBoxSecName_Leave).
    /*  */
    /* label7 */
    /*  */
    this-object:label7:Location = new System.Drawing.Point(7, 8).
    this-object:label7:Name = "label7".
    this-object:label7:Size = new System.Drawing.Size(96, 15).
    this-object:label7:TabIndex = 4.
    this-object:label7:Text = "Номер секции:".
    this-object:label7:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label7:UseCompatibleTextRendering = true.
    /*  */
    /* label6 */
    /*  */
    this-object:label6:Location = new System.Drawing.Point(278, 86).
    this-object:label6:Name = "label6".
    this-object:label6:Size = new System.Drawing.Size(71, 20).
    this-object:label6:TabIndex = 5.
    this-object:label6:Text = "Горловина:".
    this-object:label6:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label6:UseCompatibleTextRendering = true.
    /*  */
    /* label5 */
    /*  */
    this-object:label5:Location = new System.Drawing.Point(216, 8).
    this-object:label5:Name = "label5".
    this-object:label5:Size = new System.Drawing.Size(197, 20).
    this-object:label5:TabIndex = 6.
    this-object:label5:Text = "Температура по ТТН,C:".
    this-object:label5:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label5:UseCompatibleTextRendering = true.
    /*  */
    /* label4 */
    /*  */
    this-object:label4:Location = new System.Drawing.Point(7, 32).
    this-object:label4:Name = "label4".
    this-object:label4:Size = new System.Drawing.Size(95, 20).
    this-object:label4:TabIndex = 7.
    this-object:label4:Text = "Масса по док.,кг:".
    this-object:label4:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label4:UseCompatibleTextRendering = true.
    /*  */
    /* label3 */
    /*  */
    this-object:label3:Location = new System.Drawing.Point(496, 32).
    this-object:label3:Name = "label3".
    this-object:label3:Size = new System.Drawing.Size(95, 20).
    this-object:label3:TabIndex = 8.
    this-object:label3:Text = "Кол-во по док.,л:".
    this-object:label3:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label3:UseCompatibleTextRendering = true.
    /*  */
    /* label2 */
    /*  */
    this-object:label2:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label2:Location = new System.Drawing.Point(-7, 139).
    this-object:label2:Name = "label2".
    this-object:label2:Size = new System.Drawing.Size(200, 20).
    this-object:label2:TabIndex = 9.
    this-object:label2:Text = "Объем по свидетельству о поверке:".
    this-object:label2:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label2:UseCompatibleTextRendering = true.
    /*  */
    /* label1 */
    /*  */
    this-object:label1:Location = new System.Drawing.Point(191, 32).
    this-object:label1:Name = "label1".
    this-object:label1:Size = new System.Drawing.Size(222, 20).
    this-object:label1:TabIndex = 10.
    this-object:label1:Text = "Плотность по док. (при раб. темп.),г/см3:".
    this-object:label1:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label1:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxCliQnty */
    /*  */
    this-object:maskedTextBoxCliQnty:ForeColor = System.Drawing.SystemColors:WindowText.
    this-object:maskedTextBoxCliQnty:Location = new System.Drawing.Point(104, 32).
    this-object:maskedTextBoxCliQnty:Name = "maskedTextBoxCliQnty".
    this-object:maskedTextBoxCliQnty:Size = new System.Drawing.Size(81, 20).
    this-object:maskedTextBoxCliQnty:TabIndex = 4.
    this-object:maskedTextBoxCliQnty:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* maskedTextBoxDocQnty */
    /*  */
    this-object:maskedTextBoxDocQnty:Location = new System.Drawing.Point(595, 32).
    this-object:maskedTextBoxDocQnty:Name = "maskedTextBoxDocQnty".
    this-object:maskedTextBoxDocQnty:Size = new System.Drawing.Size(77, 20).
    this-object:maskedTextBoxDocQnty:TabIndex = 6.
    this-object:maskedTextBoxDocQnty:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* maskedTextBoxCarVol */
    /*  */
    this-object:maskedTextBoxCarVol:ForeColor = System.Drawing.SystemColors:WindowText.
    this-object:maskedTextBoxCarVol:Location = new System.Drawing.Point(191, 139).
    this-object:maskedTextBoxCarVol:Name = "maskedTextBoxCarVol".
    this-object:maskedTextBoxCarVol:Size = new System.Drawing.Size(55, 20).
    this-object:maskedTextBoxCarVol:TabIndex = 7.
    this-object:maskedTextBoxCarVol:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    this-object:maskedTextBoxCarVol:Leave:Subscribe(this-object:calc-weight-vol).
    /*  */
    /* maskedTextBoxTTNTemp */
    /*  */
    this-object:maskedTextBoxTTNTemp:Location = new System.Drawing.Point(417, 8).
    this-object:maskedTextBoxTTNTemp:Name = "maskedTextBoxTTNTemp".
    this-object:maskedTextBoxTTNTemp:Size = new System.Drawing.Size(78, 20).
    this-object:maskedTextBoxTTNTemp:TabIndex = 2.
    this-object:maskedTextBoxTTNTemp:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimalNegNum_2_1).
    /*  */
    /* maskedTextBoxDocDens */
    /*  */
    this-object:maskedTextBoxDocDens:ForeColor = System.Drawing.SystemColors:WindowText.
    this-object:maskedTextBoxDocDens:Location = new System.Drawing.Point(417, 32).
    this-object:maskedTextBoxDocDens:Name = "maskedTextBoxDocDens".
    this-object:maskedTextBoxDocDens:Size = new System.Drawing.Size(78, 20).
    this-object:maskedTextBoxDocDens:TabIndex = 5.
    this-object:maskedTextBoxDocDens:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_1_4).
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
    this-object:groupBox7:Location = new System.Drawing.Point(10, 496).
    this-object:groupBox7:Name = "groupBox7".
    this-object:groupBox7:Size = new System.Drawing.Size(682, 70).
    this-object:groupBox7:TabIndex = 3.
    this-object:groupBox7:TabStop = false.
    this-object:groupBox7:UseCompatibleTextRendering = true.
    /*  */
    /* textBoxPlSiName */
    /*  */
    this-object:textBoxPlSiName:Enabled = false.
    this-object:textBoxPlSiName:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:textBoxPlSiName:Location = new System.Drawing.Point(243, 17).
    this-object:textBoxPlSiName:Name = "textBoxPlSiName".
    this-object:textBoxPlSiName:Size = new System.Drawing.Size(265, 20).
    this-object:textBoxPlSiName:TabIndex = 0.
    /*  */
    /* dateTimePickerDatePovPlotn */
    /*  */
    this-object:dateTimePickerDatePovPlotn:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:dateTimePickerDatePovPlotn:Location = new System.Drawing.Point(370, 43).
    this-object:dateTimePickerDatePovPlotn:Name = "dateTimePickerDatePovPlotn".
    this-object:dateTimePickerDatePovPlotn:Size = new System.Drawing.Size(81, 20).
    this-object:dateTimePickerDatePovPlotn:TabIndex = 28.
    /*  */
    /* buttonCopy */
    /*  */
    this-object:buttonCopy:Location = new System.Drawing.Point(596, 14).
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
    this-object:label38:Location = new System.Drawing.Point(455, 42).
    this-object:label38:Name = "label38".
    this-object:label38:Size = new System.Drawing.Size(134, 20).
    this-object:label38:TabIndex = 33.
    this-object:label38:Text = "Паспорт ср. изм. №:".
    this-object:label38:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label38:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxPassportPlotn */
    /*  */
    this-object:maskedTextBoxPassportPlotn:Location = new System.Drawing.Point(589, 42).
    this-object:maskedTextBoxPassportPlotn:Name = "maskedTextBoxPassportPlotn".
    this-object:maskedTextBoxPassportPlotn:Size = new System.Drawing.Size(81, 20).
    this-object:maskedTextBoxPassportPlotn:TabIndex = 29.
    /*  */
    /* label37 */
    /*  */
    this-object:label37:Location = new System.Drawing.Point(286, 43).
    this-object:label37:Name = "label37".
    this-object:label37:Size = new System.Drawing.Size(80, 20).
    this-object:label37:TabIndex = 34.
    this-object:label37:Text = "Дата поверки:".
    this-object:label37:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label37:UseCompatibleTextRendering = true.
    /*  */
    /* label36 */
    /*  */
    this-object:label36:Location = new System.Drawing.Point(9, 43).
    this-object:label36:Name = "label36".
    this-object:label36:Size = new System.Drawing.Size(42, 20).
    this-object:label36:TabIndex = 35.
    this-object:label36:Text = "Номер:".
    this-object:label36:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label36:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNumPlot */
    /*  */
    this-object:maskedTextBoxNumPlot:Location = new System.Drawing.Point(51, 43).
    this-object:maskedTextBoxNumPlot:Name = "maskedTextBoxNumPlot".
    this-object:maskedTextBoxNumPlot:Size = new System.Drawing.Size(229, 20).
    this-object:maskedTextBoxNumPlot:TabIndex = 27.
    /*  */
    /* buttonPlSi */
    /*  */
    this-object:buttonPlSi:Location = new System.Drawing.Point(179, 16).
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
    this-object:maskedTextBoxPlaceSi:Location = new System.Drawing.Point(136, 17).
    this-object:maskedTextBoxPlaceSi:Name = "maskedTextBoxPlaceSi".
    this-object:maskedTextBoxPlaceSi:Size = new System.Drawing.Size(37, 20).
    this-object:maskedTextBoxPlaceSi:TabIndex = 25.
    this-object:maskedTextBoxPlaceSi:Leave:Subscribe(this-object:maskedTextBoxPlaceSiHndler).
    /*  */
    /* label26 */
    /*  */
    this-object:label26:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label26:ForeColor = System.Drawing.SystemColors:ControlText.
    this-object:label26:Location = new System.Drawing.Point(9, 13).
    this-object:label26:Name = "label26".
    this-object:label26:Size = new System.Drawing.Size(120, 27).
    this-object:label26:TabIndex = 36.
    this-object:label26:Text = "Средство измерения плотности:".
    this-object:label26:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label26:UseCompatibleTextRendering = true.
    /*  */
    /* label31 */
    /*  */
    this-object:label31:Location = new System.Drawing.Point(95, 9).
    this-object:label31:Name = "label31".
    this-object:label31:Size = new System.Drawing.Size(105, 20).
    this-object:label31:TabIndex = 45.
    this-object:label31:Text = "№ печати (пробы):".
    this-object:label31:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label31:UseCompatibleTextRendering = true.
    /*  */
    /* TimeProb */
    /*  */
    this-object:TimeProb:CustomFormat = "".
    this-object:TimeProb:Format = System.Windows.Forms.DateTimePickerFormat:Time.
    this-object:TimeProb:Location = new System.Drawing.Point(488, 9).
    this-object:TimeProb:Name = "TimeProb".
    this-object:TimeProb:ShowUpDown = true.
    this-object:TimeProb:Size = new System.Drawing.Size(50, 20).
    this-object:TimeProb:TabIndex = 43.
    /*  */
    /* label32 */
    /*  */
    this-object:label32:Location = new System.Drawing.Point(401, 8).
    this-object:label32:Name = "label32".
    this-object:label32:Size = new System.Drawing.Size(85, 20).
    this-object:label32:TabIndex = 44.
    this-object:label32:Text = "Время отбора:".
    this-object:label32:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label32:UseCompatibleTextRendering = true.
    /*  */
    /* DateTimeDateProb */
    /*  */
    this-object:DateTimeDateProb:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:DateTimeDateProb:Location = new System.Drawing.Point(315, 9).
    this-object:DateTimeDateProb:Name = "DateTimeDateProb".
    this-object:DateTimeDateProb:Size = new System.Drawing.Size(81, 20).
    this-object:DateTimeDateProb:TabIndex = 41.
    /*  */
    /* label33 */
    /*  */
    this-object:label33:Location = new System.Drawing.Point(236, 9).
    this-object:label33:Name = "label33".
    this-object:label33:Size = new System.Drawing.Size(75, 20).
    this-object:label33:TabIndex = 43.
    this-object:label33:Text = "Дата отбора:".
    this-object:label33:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label33:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxKolProb */
    /*  */
    this-object:maskedTextBoxKolProb:Location = new System.Drawing.Point(634, 8).
    this-object:maskedTextBoxKolProb:Name = "maskedTextBoxKolProb".
    this-object:maskedTextBoxKolProb:Size = new System.Drawing.Size(36, 20).
    this-object:maskedTextBoxKolProb:TabIndex = 42.
    this-object:maskedTextBoxKolProb:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_2_2).
    /*  */
    /* label34 */
    /*  */
    this-object:label34:Location = new System.Drawing.Point(538, 8).
    this-object:label34:Name = "label34".
    this-object:label34:Size = new System.Drawing.Size(93, 20).
    this-object:label34:TabIndex = 42.
    this-object:label34:Text = "Кол-во пробы,л:".
    this-object:label34:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label34:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxTests */
    /*  */
    this-object:maskedTextBoxTests:Location = new System.Drawing.Point(68, 10).
    this-object:maskedTextBoxTests:Name = "maskedTextBoxTests".
    this-object:maskedTextBoxTests:Size = new System.Drawing.Size(23, 20).
    this-object:maskedTextBoxTests:TabIndex = 39.
    this-object:maskedTextBoxTests:KeyPress:Subscribe(this-object:KeyPressMaskTBInt).
    /*  */
    /* label35 */
    /*  */
    this-object:label35:Location = new System.Drawing.Point(12, 9).
    this-object:label35:Name = "label35".
    this-object:label35:Size = new System.Drawing.Size(55, 20).
    this-object:label35:TabIndex = 41.
    this-object:label35:Text = "№ пробы:".
    this-object:label35:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label35:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNumPrintProb */
    /*  */
    this-object:maskedTextBoxNumPrintProb:Location = new System.Drawing.Point(202, 10).
    this-object:maskedTextBoxNumPrintProb:Name = "maskedTextBoxNumPrintProb".
    this-object:maskedTextBoxNumPrintProb:Size = new System.Drawing.Size(29, 20).
    this-object:maskedTextBoxNumPrintProb:TabIndex = 40.
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
    this-object:groupBox6:Location = new System.Drawing.Point(10, 771).
    this-object:groupBox6:Name = "groupBox6".
    this-object:groupBox6:Size = new System.Drawing.Size(682, 33).
    this-object:groupBox6:TabIndex = 6.
    this-object:groupBox6:TabStop = false.
    this-object:groupBox6:UseCompatibleTextRendering = true.
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
    /* dateTimePickerDateStart */
    /*  */
    this-object:dateTimePickerDateStart:Enabled = false.
    this-object:dateTimePickerDateStart:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:dateTimePickerDateStart:Location = new System.Drawing.Point(150, 10).
    this-object:dateTimePickerDateStart:Name = "dateTimePickerDateStart".
    this-object:dateTimePickerDateStart:Size = new System.Drawing.Size(81, 20).
    this-object:dateTimePickerDateStart:TabIndex = 35.
    /*  */
    /* dateTimePickerDateEnd */
    /*  */
    this-object:dateTimePickerDateEnd:Enabled = false.
    this-object:dateTimePickerDateEnd:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:dateTimePickerDateEnd:Location = new System.Drawing.Point(150, 37).
    this-object:dateTimePickerDateEnd:Name = "dateTimePickerDateEnd".
    this-object:dateTimePickerDateEnd:Size = new System.Drawing.Size(81, 20).
    this-object:dateTimePickerDateEnd:TabIndex = 37.
    /*  */
    /* dateTimePickerTimeStart */
    /*  */
    this-object:dateTimePickerTimeStart:CustomFormat = "".
    this-object:dateTimePickerTimeStart:Enabled = false.
    this-object:dateTimePickerTimeStart:Format = System.Windows.Forms.DateTimePickerFormat:Time.
    this-object:dateTimePickerTimeStart:Location = new System.Drawing.Point(373, 10).
    this-object:dateTimePickerTimeStart:Name = "dateTimePickerTimeStart".
    this-object:dateTimePickerTimeStart:ShowUpDown = true.
    this-object:dateTimePickerTimeStart:Size = new System.Drawing.Size(50, 20).
    this-object:dateTimePickerTimeStart:TabIndex = 36.
    /*  */
    /* dateTimePickerTimeEnd */
    /*  */
    this-object:dateTimePickerTimeEnd:CustomFormat = "".
    this-object:dateTimePickerTimeEnd:Enabled = false.
    this-object:dateTimePickerTimeEnd:Format = System.Windows.Forms.DateTimePickerFormat:Time.
    this-object:dateTimePickerTimeEnd:Location = new System.Drawing.Point(373, 37).
    this-object:dateTimePickerTimeEnd:Name = "dateTimePickerTimeEnd".
    this-object:dateTimePickerTimeEnd:ShowUpDown = true.
    this-object:dateTimePickerTimeEnd:Size = new System.Drawing.Size(50, 20).
    this-object:dateTimePickerTimeEnd:TabIndex = 38.
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
    this-object:groupBox5:Location = new System.Drawing.Point(10, 715).
    this-object:groupBox5:Name = "groupBox5".
    this-object:groupBox5:Size = new System.Drawing.Size(588, 56).
    this-object:groupBox5:TabIndex = 5.
    this-object:groupBox5:TabStop = false.
    this-object:groupBox5:UseCompatibleTextRendering = true.
    /*  */
    /* bRvsAft */
    /*  */
    this-object:bRvsAft:Location = new System.Drawing.Point(605, 748).
    this-object:bRvsAft:Name = "bRvsAft".
    this-object:bRvsAft:Size = new System.Drawing.Size(75, 23).
    this-object:bRvsAft:TabIndex = 44.
    this-object:bRvsAft:Text = "Св.после".
    this-object:bRvsAft:UseCompatibleTextRendering = true.
    this-object:bRvsAft:UseVisualStyleBackColor = true.
    this-object:bRvsAft:MouseClick:Subscribe(this-object:bRvsAft_MouseClick).
    /*  */
    /* bRvsBef */
    /*  */
    this-object:bRvsBef:Location = new System.Drawing.Point(605, 722).
    this-object:bRvsBef:Name = "bRvsBef".
    this-object:bRvsBef:Size = new System.Drawing.Size(75, 23).
    this-object:bRvsBef:TabIndex = 43.
    this-object:bRvsBef:Text = "Св.до".
    this-object:bRvsBef:UseCompatibleTextRendering = true.
    this-object:bRvsBef:UseVisualStyleBackColor = true.
    this-object:bRvsBef:MouseClick:Subscribe(this-object:bRvsBef_MouseClick).
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
    this-object:maskedTextBoxTankWeight:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_1).
    /*  */
    /* maskedTextBoxTankVolPomi */
    /*  */
    this-object:maskedTextBoxTankVolPomi:Location = new System.Drawing.Point(150, 34).
    this-object:maskedTextBoxTankVolPomi:Name = "maskedTextBoxTankVolPomi".
    this-object:maskedTextBoxTankVolPomi:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankVolPomi:TabIndex = 32.
    this-object:maskedTextBoxTankVolPomi:KeyPress:Subscribe(this-object:KeyPressMaskTBDecimal_5_3).
    /*  */
    /* maskedTextBoxTankDensityPomi */
    /*  */
    this-object:maskedTextBoxTankDensityPomi:Location = new System.Drawing.Point(150, 9).
    this-object:maskedTextBoxTankDensityPomi:Name = "maskedTextBoxTankDensityPomi".
    this-object:maskedTextBoxTankDensityPomi:Size = new System.Drawing.Size(100, 20).
    this-object:maskedTextBoxTankDensityPomi:TabIndex = 30.
    /*  */
    /* label22 */
    /*  */
    this-object:label22:ForeColor = System.Drawing.SystemColors:HotTrack.
    this-object:label22:Location = new System.Drawing.Point(0, 34).
    this-object:label22:Name = "label22".
    this-object:label22:Size = new System.Drawing.Size(144, 20).
    this-object:label22:TabIndex = 38.
    this-object:label22:Text = "Объем топлива привед.,л:".
    this-object:label22:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label22:UseCompatibleTextRendering = true.
    /*  */
    /* label23 */
    /*  */
    this-object:label23:ForeColor = System.Drawing.SystemColors:HotTrack.
    this-object:label23:Location = new System.Drawing.Point(-10, 15).
    this-object:label23:Name = "label23".
    this-object:label23:Size = new System.Drawing.Size(155, 20).
    this-object:label23:TabIndex = 37.
    this-object:label23:Text = "Плотность приведенная,г/см3:".
    this-object:label23:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label23:UseCompatibleTextRendering = true.
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
    /* label25 */
    /*  */
    this-object:label25:ForeColor = System.Drawing.SystemColors:HotTrack.
    this-object:label25:Location = new System.Drawing.Point(256, 8).
    this-object:label25:Name = "label25".
    this-object:label25:Size = new System.Drawing.Size(111, 20).
    this-object:label25:TabIndex = 35.
    this-object:label25:Text = "Масса топлива,кг:".
    this-object:label25:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label25:UseCompatibleTextRendering = true.
    /*  */
    /* buttonCalcWeight */
    /*  */
    this-object:buttonCalcWeight:Location = new System.Drawing.Point(570, 17).
    this-object:buttonCalcWeight:Name = "buttonCalcWeight".
    this-object:buttonCalcWeight:Size = new System.Drawing.Size(100, 34).
    this-object:buttonCalcWeight:TabIndex = 34.
    this-object:buttonCalcWeight:Text = "Рассчитать по замерам в АЦ".
    this-object:buttonCalcWeight:UseCompatibleTextRendering = true.
    this-object:buttonCalcWeight:UseVisualStyleBackColor = true.
    this-object:buttonCalcWeight:Click:Subscribe(this-object:buttonCalcWeight_Click).
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
    this-object:groupBox4:Location = new System.Drawing.Point(10, 636).
    this-object:groupBox4:Name = "groupBox4".
    this-object:groupBox4:Size = new System.Drawing.Size(682, 61).
    this-object:groupBox4:TabIndex = 4.
    this-object:groupBox4:TabStop = false.
    this-object:groupBox4:UseCompatibleTextRendering = true.
    this-object:groupBox4:Enter:Subscribe(this-object:groupBox4_Enter).
    /*  */
    /* groupBox8 */
    /*  */
    this-object:groupBox8:Controls:Add(this-object:textBoxPlSiNameTemp).
    this-object:groupBox8:Controls:Add(this-object:dateTimePickerDatePovTemp).
    this-object:groupBox8:Controls:Add(this-object:buttonCopyPSTemp).
    this-object:groupBox8:Controls:Add(this-object:label40).
    this-object:groupBox8:Controls:Add(this-object:maskedTextBoxPassportTemp).
    this-object:groupBox8:Controls:Add(this-object:label41).
    this-object:groupBox8:Controls:Add(this-object:label42).
    this-object:groupBox8:Controls:Add(this-object:maskedTextBoxNumTemp).
    this-object:groupBox8:Controls:Add(this-object:buttonPlSiTemp).
    this-object:groupBox8:Controls:Add(this-object:maskedTextBoxPlaceSiTemp).
    this-object:groupBox8:Controls:Add(this-object:label43).
    this-object:groupBox8:Location = new System.Drawing.Point(10, 568).
    this-object:groupBox8:Name = "groupBox8".
    this-object:groupBox8:Size = new System.Drawing.Size(682, 70).
    this-object:groupBox8:TabIndex = 37.
    this-object:groupBox8:TabStop = false.
    this-object:groupBox8:UseCompatibleTextRendering = true.
    /*  */
    /* textBoxPlSiNameTemp */
    /*  */
    this-object:textBoxPlSiNameTemp:Enabled = false.
    this-object:textBoxPlSiNameTemp:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Bold, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:textBoxPlSiNameTemp:Location = new System.Drawing.Point(243, 17).
    this-object:textBoxPlSiNameTemp:Name = "textBoxPlSiNameTemp".
    this-object:textBoxPlSiNameTemp:Size = new System.Drawing.Size(265, 20).
    this-object:textBoxPlSiNameTemp:TabIndex = 0.
    /*  */
    /* dateTimePickerDatePovTemp */
    /*  */
    this-object:dateTimePickerDatePovTemp:Format = System.Windows.Forms.DateTimePickerFormat:Short.
    this-object:dateTimePickerDatePovTemp:Location = new System.Drawing.Point(370, 40).
    this-object:dateTimePickerDatePovTemp:Name = "dateTimePickerDatePovTemp".
    this-object:dateTimePickerDatePovTemp:Size = new System.Drawing.Size(81, 20).
    this-object:dateTimePickerDatePovTemp:TabIndex = 28.
    /*  */
    /* buttonCopyPSTemp */
    /*  */
    this-object:buttonCopyPSTemp:Location = new System.Drawing.Point(596, 15).
    this-object:buttonCopyPSTemp:Name = "buttonCopyPSTemp".
    this-object:buttonCopyPSTemp:Size = new System.Drawing.Size(75, 23).
    this-object:buttonCopyPSTemp:TabIndex = 32.
    this-object:buttonCopyPSTemp:Text = "Копировать".
    this-object:buttonCopyPSTemp:UseCompatibleTextRendering = true.
    this-object:buttonCopyPSTemp:UseVisualStyleBackColor = true.
    this-object:buttonCopyPSTemp:Click:Subscribe(this-object:buttonCopyPSTemp_Click).
    /*  */
    /* label40 */
    /*  */
    this-object:label40:Location = new System.Drawing.Point(454, 42).
    this-object:label40:Name = "label40".
    this-object:label40:Size = new System.Drawing.Size(134, 20).
    this-object:label40:TabIndex = 33.
    this-object:label40:Text = "Паспорт ср. изм. №:".
    this-object:label40:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label40:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxPassportTemp */
    /*  */
    this-object:maskedTextBoxPassportTemp:Location = new System.Drawing.Point(589, 43).
    this-object:maskedTextBoxPassportTemp:Name = "maskedTextBoxPassportTemp".
    this-object:maskedTextBoxPassportTemp:Size = new System.Drawing.Size(81, 20).
    this-object:maskedTextBoxPassportTemp:TabIndex = 29.
    /*  */
    /* label41 */
    /*  */
    this-object:label41:Location = new System.Drawing.Point(286, 41).
    this-object:label41:Name = "label41".
    this-object:label41:Size = new System.Drawing.Size(80, 20).
    this-object:label41:TabIndex = 34.
    this-object:label41:Text = "Дата поверки:".
    this-object:label41:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label41:UseCompatibleTextRendering = true.
    /*  */
    /* label42 */
    /*  */
    this-object:label42:Location = new System.Drawing.Point(9, 43).
    this-object:label42:Name = "label42".
    this-object:label42:Size = new System.Drawing.Size(42, 20).
    this-object:label42:TabIndex = 35.
    this-object:label42:Text = "Номер:".
    this-object:label42:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label42:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxNumTemp */
    /*  */
    this-object:maskedTextBoxNumTemp:Location = new System.Drawing.Point(51, 43).
    this-object:maskedTextBoxNumTemp:Name = "maskedTextBoxNumTemp".
    this-object:maskedTextBoxNumTemp:Size = new System.Drawing.Size(229, 20).
    this-object:maskedTextBoxNumTemp:TabIndex = 27.
    /*  */
    /* buttonPlSiTemp */
    /*  */
    this-object:buttonPlSiTemp:Location = new System.Drawing.Point(179, 16).
    this-object:buttonPlSiTemp:Name = "buttonPlSiTemp".
    this-object:buttonPlSiTemp:Size = new System.Drawing.Size(57, 23).
    this-object:buttonPlSiTemp:TabIndex = 26.
    this-object:buttonPlSiTemp:Text = "Выбор".
    this-object:buttonPlSiTemp:UseCompatibleTextRendering = true.
    this-object:buttonPlSiTemp:UseVisualStyleBackColor = true.
    this-object:buttonPlSiTemp:Click:Subscribe(this-object:buttonPlSiTemp_Click).
    /*  */
    /* maskedTextBoxPlaceSiTemp */
    /*  */
    this-object:maskedTextBoxPlaceSiTemp:ForeColor = System.Drawing.Color:Red.
    this-object:maskedTextBoxPlaceSiTemp:Location = new System.Drawing.Point(136, 17).
    this-object:maskedTextBoxPlaceSiTemp:Name = "maskedTextBoxPlaceSiTemp".
    this-object:maskedTextBoxPlaceSiTemp:Size = new System.Drawing.Size(37, 20).
    this-object:maskedTextBoxPlaceSiTemp:TabIndex = 25.
    this-object:maskedTextBoxPlaceSiTemp:Leave:Subscribe(this-object:maskedTextBoxPlaceSiTemp_Leave).
    /*  */
    /* label43 */
    /*  */
    this-object:label43:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(8.25), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label43:ForeColor = System.Drawing.SystemColors:ControlText.
    this-object:label43:Location = new System.Drawing.Point(7, 12).
    this-object:label43:Name = "label43".
    this-object:label43:Size = new System.Drawing.Size(120, 27).
    this-object:label43:TabIndex = 36.
    this-object:label43:Text = "Средство измерения температуры:".
    this-object:label43:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:label43:UseCompatibleTextRendering = true.
    /*  */
    /* cbSGDKK */
    /*  */
    this-object:cbSGDKK:BackColor = System.Drawing.Color:OrangeRed.
    this-object:cbSGDKK:Location = new System.Drawing.Point(507, 181).
    this-object:cbSGDKK:Name = "cbSGDKK".
    this-object:cbSGDKK:Padding = new System.Windows.Forms.Padding(5, 0, 0, 0).
    this-object:cbSGDKK:Size = new System.Drawing.Size(182, 20).
    this-object:cbSGDKK:TabIndex = 38.
    this-object:cbSGDKK:Text = "Тревожное событие СЭП".
    this-object:cbSGDKK:UseCompatibleTextRendering = true.
    this-object:cbSGDKK:UseVisualStyleBackColor = false.
    /*  */
    /* label50 */
    /*  */
    this-object:label50:Font = new System.Drawing.Font("Microsoft Sans Serif", Progress.Util.CastUtil:ToSingle(9), System.Drawing.FontStyle:Regular, System.Drawing.GraphicsUnit:Point, System.Convert:ToByte(204)).
    this-object:label50:Location = new System.Drawing.Point(16, 182).
    this-object:label50:Name = "label50".
    this-object:label50:Size = new System.Drawing.Size(434, 20).
    this-object:label50:TabIndex = 39.
    this-object:label50:Text = "Идентификатор доступа (ключ) «нижнего уровня»:".
    this-object:label50:UseCompatibleTextRendering = true.
    /*  */
    /* maskedTextBoxAukKey */
    /*  */
    this-object:maskedTextBoxAukKey:Location = new System.Drawing.Point(19, 200).
    this-object:maskedTextBoxAukKey:Name = "maskedTextBoxAukKey".
    this-object:maskedTextBoxAukKey:Size = new System.Drawing.Size(661, 20).
    this-object:maskedTextBoxAukKey:TabIndex = 40.
    this-object:maskedTextBoxAukKey:Leave:Subscribe(this-object:maskedTextBoxAukKey_Leave).
    /*  */
    /* buttonCalcResultRvs */
    /*  */
    this-object:buttonCalcResultRvs:Location = new System.Drawing.Point(32, 3).
    this-object:buttonCalcResultRvs:Name = "buttonCalcResultRvs".
    this-object:buttonCalcResultRvs:Size = new System.Drawing.Size(171, 22).
    this-object:buttonCalcResultRvs:TabIndex = 45.
    this-object:buttonCalcResultRvs:Text = "Результат расчета сверок".
    this-object:buttonCalcResultRvs:UseCompatibleTextRendering = true.
    this-object:buttonCalcResultRvs:UseVisualStyleBackColor = true.
    this-object:buttonCalcResultRvs:Click:Subscribe(this-object:buttonCalcResultRvs_Click).
    /*  */
    /* buttonCalcWeightRvs */
    /*  */
    this-object:buttonCalcWeightRvs:Location = new System.Drawing.Point(255, 3).
    this-object:buttonCalcWeightRvs:Name = "buttonCalcWeightRvs".
    this-object:buttonCalcWeightRvs:Size = new System.Drawing.Size(211, 22).
    this-object:buttonCalcWeightRvs:TabIndex = 46.
    this-object:buttonCalcWeightRvs:Text = "Рассчитать по данным сверок".
    this-object:buttonCalcWeightRvs:UseCompatibleTextRendering = true.
    this-object:buttonCalcWeightRvs:UseVisualStyleBackColor = true.
    this-object:buttonCalcWeightRvs:Click:Subscribe(this-object:buttonCalcWeightRvs_Click).
    /*  */
    /* groupBox9 */
    /*  */
    this-object:groupBox9:Controls:Add(this-object:buttonCalcResultRvs).
    this-object:groupBox9:Controls:Add(this-object:buttonCalcWeightRvs).
    this-object:groupBox9:Location = new System.Drawing.Point(10, 694).
    this-object:groupBox9:Name = "groupBox9".
    this-object:groupBox9:Size = new System.Drawing.Size(473, 24).
    this-object:groupBox9:TabIndex = 47.
    this-object:groupBox9:TabStop = false.
    this-object:groupBox9:UseCompatibleTextRendering = true.
    /*  */
    /* cbKPnoMeas */
    /*  */
    this-object:cbKPnoMeas:BackColor = System.Drawing.Color:OrangeRed.
    this-object:cbKPnoMeas:Location = new System.Drawing.Point(326, 181).
    this-object:cbKPnoMeas:Name = "cbKPnoMeas".
    this-object:cbKPnoMeas:Padding = new System.Windows.Forms.Padding(5, 0, 0, 0).
    this-object:cbKPnoMeas:Size = new System.Drawing.Size(361, 20).
    this-object:cbKPnoMeas:TabIndex = 48.
    this-object:cbKPnoMeas:Text = "Переход к комиссионному приему НП без замеров секции АЦ".
    this-object:cbKPnoMeas:UseCompatibleTextRendering = true.
    this-object:cbKPnoMeas:UseVisualStyleBackColor = false.
    /*  */
    /* buttonCalcResultAC */
    /*  */
    this-object:buttonCalcResultAC:Location = new System.Drawing.Point(510, 697).
    this-object:buttonCalcResultAC:Name = "buttonCalcResultAC".
    this-object:buttonCalcResultAC:Size = new System.Drawing.Size(171, 22).
    this-object:buttonCalcResultAC:TabIndex = 48.
    this-object:buttonCalcResultAC:Text = "Результат расчета АЦ".
    this-object:buttonCalcResultAC:TextAlign = System.Drawing.ContentAlignment:MiddleRight.
    this-object:buttonCalcResultAC:UseCompatibleTextRendering = true.
    this-object:buttonCalcResultAC:UseVisualStyleBackColor = true.
    this-object:buttonCalcResultAC:Click:Subscribe(this-object:buttonCalcResultAC_Click).
    /*  */
    /* tanksection */
    /*  */
    this-object:AutoScaleDimensions = new System.Drawing.SizeF(Progress.Util.CastUtil:ToSingle(6), Progress.Util.CastUtil:ToSingle(13)).
    this-object:BackgroundImage = cast(resources:GetObject("$this.BackgroundImage"), System.Drawing.Image).
    this-object:Controls:Add(this-object:buttonCalcResultAC).
    this-object:Controls:Add(this-object:cbKPnoMeas).
    this-object:Controls:Add(this-object:groupBox9).
    this-object:Controls:Add(this-object:bRvsAft).
    this-object:Controls:Add(this-object:maskedTextBoxAukKey).
    this-object:Controls:Add(this-object:label50).
    this-object:Controls:Add(this-object:bRvsBef).
    this-object:Controls:Add(this-object:cbSGDKK).
    this-object:Controls:Add(this-object:groupBox7).
    this-object:Controls:Add(this-object:groupBox8).
    this-object:Controls:Add(this-object:groupBox1).
    this-object:Controls:Add(this-object:groupBox2).
    this-object:Controls:Add(this-object:groupBox3).
    this-object:Controls:Add(this-object:groupBox4).
    this-object:Controls:Add(this-object:groupBox5).
    this-object:Controls:Add(this-object:groupBox6).
    this-object:Name = "tanksection".
    this-object:Size = new System.Drawing.Size(700, 805).
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
    this-object:groupBox8:ResumeLayout(false).
    this-object:groupBox8:PerformLayout().
    this-object:groupBox9:ResumeLayout(false).
    this-object:ResumeLayout(false).
    this-object:PerformLayout().
    catch e as Progress.Lang.Error:
      undo, throw e.
    end catch.
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


    find first ub.sr-izmerenia no-lock where ub.sr-izmerenia.node-code = integer (v-maskTextBox:Text) no-error.
    if available (ub.sr-izmerenia)
    and (ub.sr-izmerenia.sr-temperature)
    and (textBoxPlSiNameTemp:text = "0" or textBoxPlSiNameTemp:text = "")
    then do:
      infoSecsObj:GetInfoSectionProp(idSecTabPage).
      maskedTextBoxPlaceSiTemp:Text = v-maskTextBox:Text.
      infoSecsObj:InfoSectionCurr:PlaceSiTemp = integer (v-maskTextBox:Text).
      textBoxPlSiNameTemp:Text = infoSecsObj:InfoSectionCurr:PlSiNameTemp.
      
      v-maskTextBox:Text = string(infoSecsObj:InfoSectionCurr:PlaceSiTemp).
    end.
    
    return.

  end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
	method private void maskedTextBoxPlaceSiTemp_Leave( input sender as System.Object, input e as System.EventArgs ):
		
    def var v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    
    v-maskTextBox = cast(sender, System.Windows.Forms.MaskedTextBox).

    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecsObj:InfoSectionCurr:PlaceSiTemp = integer (v-maskTextBox:Text).
    textBoxPlSiNameTemp:Text = infoSecsObj:InfoSectionCurr:PlSiNameTemp.
    v-maskTextBox:Text = string(infoSecsObj:InfoSectionCurr:PlaceSiTemp). /* если не удачно вернется старое значение*/.
    
    find first ub.sr-izmerenia no-lock where ub.sr-izmerenia.node-code = integer (v-maskTextBox:Text) no-error.
    if available (ub.sr-izmerenia)
    and (ub.sr-izmerenia.sr-density)
    and (textBoxPlSiName:text = "0" or textBoxPlSiName:text = "")
    then do:
      infoSecsObj:GetInfoSectionProp(idSecTabPage).
      maskedTextBoxPlaceSi:Text = v-maskTextBox:Text.
      infoSecsObj:InfoSectionCurr:PlaceSi = integer (v-maskTextBox:Text).
      textBoxPlSiName:Text = infoSecsObj:InfoSectionCurr:PlSiName.
      
      v-maskTextBox:Text = string(infoSecsObj:InfoSectionCurr:PlaceSi).
    end.

    
    return.

	end method.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  method private void maskedTextBoxSecName_Leave( input sender as System.Object, input e as System.EventArgs ):
    define variable ii as integer no-undo.
    
    define variable v-maskTextBox as System.Windows.Forms.MaskedTextBox no-undo.
    
    define buffer buf_auto-section for ub.auto-section .
    define buffer sec_auto-section for ub.auto-section .
    
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
    
    find first buf_auto-section no-lock where buf_auto-section.auto-num = infoSecsObj:InfoSectionCurr:infoSectionTotal:CarNum no-error .
    find first sec_auto-section no-lock where sec_auto-section.auto-num = infoSecsObj:InfoSectionCurr:infoSectionTotal:CarNum
                                          and sec_auto-section.section-num = integer(v-maskTextBox:Text)
                                          no-error .
    if available sec_auto-section   
    then do : 
      infoSecsObj:GetInfoSectionProp(idSecTabPage).  
      infoSecsObj:InfoSectionCurr:SetCarVol(maskedTextBoxSecName:Text).
      comboBoxShape:Text = infoSecsObj:InfoSectionCurr:Shape.
      maskedTextBoxDiameter:Text = infoSecsObj:InfoSectionCurr:Diameter.
      maskedTextBoxCarVol:Enabled = false.
      comboBoxShape:Enabled = false.
      maskedTextBoxSecName:Enabled = false.
      /*if infoSecsObj:DocQntyInput
        then maskedTextBoxDocQnty:Text = format_round_3(infoSecsObj:InfoSectionCurr:DocQnty).*/
      maskedTextBoxCarVol:Text = format_round_3(infoSecsObj:InfoSectionCurr:CarVol).
    end .
    else do :
      if available buf_auto-section
      and v-maskTextBox:Text > ""
      then do :
        message ("В АЦ с номером " + infoSecsObj:InfoSectionCurr:infoSectionTotal:CarNum + " не найдена секция " + v-maskTextBox:Text) view-as alert-box title "Сообщение".
        v-maskTextBox:Text = "".
        v-maskTextBox:Focus().
        return .
      end .
    end .
    
    tanksecsObj:SetSecName (v-maskTextBox:Text).
    

    
    return.

  end method.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	@VisualDesigner.
  method private void PressureLeave( input sender as System.Object, input e as System.EventArgs ):
		
		infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecsObj:InfoSectionCurr:Pressure = decimal(maskedTextBoxPressure:text) .
		
    return.

  end method.

  method private void SetControls ():

    def var infoSecObj as class InfoSection no-undo.
    infoSecObj = infoSecsObj:GetInfoSectionProp(idSecTabPage).
    infoSecObj:UserMode = true.
    this-object:maskedTextBoxSecName:Text         = infoSecObj:SectionName.
    this-object:maskedTextBoxCarVol:Text          = format_round_0 (infoSecObj:CarVol).
    this-object:maskedTextBoxDocDens:Text         = format_dens (infoSecObj:DocDensity).
    v-doc-density = infoSecObj:DocDensity no-error .
    this-object:maskedTextBoxDocDensST:Text       = format_dens (infoSecObj:DocDensST).
    this-object:maskedTextBoxPaspDens:Text        = format_dens (infoSecObj:PaspDens).
    this-object:maskedTextBoxPressure:Text        = if infoSecObj:Pressure = 0 or infoSecObj:Pressure = ? then "0." else format_pressure (infoSecObj:Pressure).
    this-object:maskedTextBoxDocQnty:Text         = format_round_0 (infoSecObj:DocQnty).
    this-object:maskedTextBoxDocVolume:Text       = format_round_0 (infoSecObj:DocVolume).
    v-doc-qnty = infoSecObj:DocQnty no-error .
    this-object:maskedTextBoxTTNTemp:Text         = if infoSecObj:TTNTemp = ? then "" else format_temper (infoSecObj:TTNTemp).
    this-object:maskedTextBoxAccShip:Text         = format_round_3 (if infoSecObj:AccShip > 0 then infoSecObj:AccShip else 0.25).
    this-object:maskedTextBoxDiameter:Text        = (infoSecObj:Diameter).
    this-object:maskedTextBoxCliQnty:Text         = format_round_1 (infoSecObj:CliQnty).
    v-cli-qnty = infoSecObj:CliQnty no-error .
    this-object:maskedTextBoxNumPassport:Text     = (infoSecObj:NumPassport).
    this-object:maskedTextBoxNormDoc:Text         = (infoSecObj:NormDoc).
    this-object:maskedTextBoxCertifFuel:Text      = (infoSecObj:CertifFuel).
    this-object:maskedTextBoxValidityCertif:Text  = (infoSecObj:ValidityCertif).
    this-object:maskedTextBoxABTArir:Text         = format_int (integer (infoSecObj:ABTarir)).
    this-object:maskedTextBoxMouth:Text           = format_round_0 (infoSecObj:Mouth).
    this-object:maskedTextBoxTankVol:Text         = format_round_0 (infoSecObj:TankVol).
    this-object:maskedTextBoxTankDens:Text        = format_dens (infoSecObj:TankDensity).
    this-object:maskedTextBoxNaturLoss:Text       = format_round_3 (infoSecObj:NaturalLoss).
    this-object:maskedTextBoxTPNorm:Text          = format_int (integer (infoSecObj:TPNorm)).
    this-object:maskedTextBoxTankWater:Text       = format_round_3 (infoSecObj:TankWater).
    this-object:maskedTextBoxTankTemp:Text        = if infoSecObj:TankTemp = ? then format_temper (0.0) else format_temper (infoSecObj:TankTemp).
    this-object:maskedTextBoxDensTemp:Text        = if infoSecObj:DensTemp = ? then format_temper (0.0) else format_temper (infoSecObj:DensTemp).
    this-object:maskedTextBoxListTank:Text        = (infoSecObj:ListTank).
    this-object:maskedTextBoxPlaceSi:Text         = format_int (infoSecObj:PlaceSi).
    this-object:maskedTextBoxNumPlot:Text         = (infoSecObj:NumPlotn).
    this-object:maskedTextBoxPassportPlotn:Text   = (infoSecObj:PassportPlotn).
    this-object:maskedTextBoxTests:Text           = (infoSecObj:Tests).
    this-object:maskedTextBoxKolProb:Text         = format_round_3 (infoSecObj:KolProb).
    this-object:maskedTextBoxNumPrintProb:Text    = (infoSecObj:NumPrintProb).
    this-object:textBoxPlSiName:Text              =  infoSecObj:PlSiName.
    this-object:maskedTextBoxPlaceSiTemp:Text     = format_int (infoSecObj:PlaceSiTemp).
    this-object:textBoxPlSiNameTemp:Text          =  infoSecObj:PlSiNameTemp.


    this-object:maskedTextBoxAccWeight:Text       = format_round_3 (infoSecObj:AccPomi).
    this-object:maskedTextBoxTankDensityPomi:Text = format_dens (infoSecObj:TankDensityPomi).
    this-object:maskedTextBoxTankVolPomi:Text     = format_round_0 (infoSecObj:TankVolPomi).
    this-object:maskedTextBoxTankWeight:Text      = format_round_1 (infoSecObj:TankWeight).
    this-object:comboBoxPour:Text                 = infoSecObj:Pour.
    this-object:comboBoxShape:Text                = infoSecObj:Shape.
    this-object:comboBoxGroupNP:Text              = infoSecObj:GroupNP.
    
    this-object:cbSGDKK:Checked                   = infoSecObj:alarm-SGDKK.
    this-object:cbSGDKK:CheckedChanged:Subscribe(this-object:cbSGDKK_CheckedChanged) no-error.
    this-object:maskedTextBoxAukKey:Text          = infoSecObj:AukKey.
    
    this-object:cbKPnoMeas:Checked                 = infoSecObj:KPnoMeas.
    this-object:cbKPnoMeas:CheckedChanged:Subscribe(this-object:cbKPnoMeas_CheckedChanged) no-error.

    v-tank-weight-rvs = infoSecObj:TankWeightRvs .
    v-tank-vol-pomi-rvs = infoSecObj:TankVolPomiRvs .
    
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
    this-object:dateTimePickerDatePovTemp:Text   = string (infoSecObj:DatePovPlotnTemp) no-error.
    if error-status:error or infoSecObj:DatePovPlotnTemp = ?
      then 
    do:
      blank_datetime (dateTimePickerDatePovTemp).
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
    infoSecObj:FillTTSection(infoSecObj:Diameter).
    if ((infoSecsObj:Mode = "ДОБАВЛЕНИЕ" or infoSecsObj:Mode = "ИЗМЕНЕНИЕ") 
      and (maskedTextBoxListTank:Text = ""))
    then do:
      def var v-bool as log no-undo.
      def buffer buf_pl-gds for ub.pl-gds.
      v-bool = false.
      for each buf_pl-gds no-lock where buf_pl-gds.obj-type = infoSecsObj:ObjType
                                    and buf_pl-gds.obj-code = infoSecsObj:ObjCode
                                    and buf_pl-gds.gds-code = infoSecsObj:GdsCode
                                    :
        if v-bool
        then do: 
          v-bool = false. 
          leave. 
        end.
        v-bool = true.
      end.
      if v-bool
      then do:
        for first buf_pl-gds no-lock where buf_pl-gds.obj-type = infoSecsObj:ObjType
                                       and buf_pl-gds.obj-code = infoSecsObj:ObjCode
                                       and buf_pl-gds.gds-code = infoSecsObj:GdsCode
                                       :
          find first ub.place no-lock where ub.place.pl-code = buf_pl-gds.pl-code no-error.
          maskedTextBoxListTank:Text = ub.place.loc1.
          infoSecsObj:InfoSectionCurr:ListTank = maskedTextBoxListTank:text .
        end.
      end.
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
  method private void KeyPressMaskTBDecimal_5_1( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimal (sender, e, 5, 1).

  end method.
  
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
  method private void KeyPressMaskTBDecimal_3_1( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBDecimal (sender, e, 3, 1).

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
  method private void KeyPressMaskTBIntNegNum_4( input sender as System.Object, input e as System.Windows.Forms.KeyPressEventArgs):

    KeyPressMaskTBIntNegativeNum (sender, e, 4).

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
          then do :
            if num-entries(v-maskTextBox:Text, ".") = 2
            and length (entry (2, v-maskTextBox:Text, ".")) = maxLenthFractional
            and startcursor >= index (v-maskTextBox:Text, ".")
            then do :
              v-maskTextBox:Text = substring (v-maskTextBox:Text, 1, length (v-maskTextBox:Text) - 1 ) + e:KeyChar .
              e:KeyChar = "" .
              v-maskTextBox:SelectionStart = startcursor .
            end .
            return.
          end .
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
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
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
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  method public void SetInfoSec ():
    
    def var infoSecObj as class InfoSection no-undo.
    
    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    
    infoSecObj = infoSecsObj:InfoSectionCurr.

    infoSecObj:SectionName = (this-object:maskedTextBoxSecName:Text).                        
    infoSecObj:CarVol          = decimal(this-object:maskedTextBoxCarVol:Text).          
/*    infoSecObj:DocDensity      = decimal(this-object:maskedTextBoxDocDens:Text).*/
    infoSecObj:DocDensity      = v-doc-density .         
/*    infoSecObj:DocQnty         = decimal(this-object:maskedTextBoxDocQnty:Text).*/
    infoSecObj:DocQnty         = v-doc-qnty .    
    infoSecObj:DocVolume       = decimal(this-object:maskedTextBoxDocVolume:Text).  
    infoSecObj:TTNTemp         = (if trim (this-object:maskedTextBoxTTNTemp:Text) = "" then ? else decimal(this-object:maskedTextBoxTTNTemp:Text) ).         
    infoSecObj:AccShip         = decimal(this-object:maskedTextBoxAccShip:Text).         
    infoSecObj:Diameter        = (this-object:maskedTextBoxDiameter:Text).        
/*    infoSecObj:CliQnty         = decimal(this-object:maskedTextBoxCliQnty:Text).*/
    infoSecObj:CliQnty         = v-cli-qnty .    
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
    infoSecObj:PlaceSiTemp     = decimal(this-object:maskedTextBoxPlaceSiTemp:Text).
    infoSecObj:Shape           = this-object:comboBoxShape:Text.
    infoSecObj:Pour            = this-object:comboBoxPour:Text.
        
    infoSecObj:DateProb        = date ((this-object:DateTimeDateProb:Text)).
    infoSecObj:DateStart       = date ((this-object:dateTimePickerDateStart:Text)).
    infoSecObj:DateEnd         = date ((this-object:dateTimePickerDateEnd:Text)).
    infoSecObj:TimeStart       = GetTimeInt((this-object:dateTimePickerTimeStart:Text)).
    infoSecObj:TimeEnd         = GetTimeInt((this-object:dateTimePickerTimeEnd:Text)).
    infoSecObj:DatePovPlotn    = date ((this-object:dateTimePickerDatePovPlotn:Text)).
    infoSecObj:DatePovPlotnTemp = date ((this-object:dateTimePickerDatePovTemp:Text)).
    
    infoSecObj:DocDensST       = decimal(this-object:maskedTextBoxDocDensST:Text).
    infoSecObj:PaspDens        = decimal(this-object:maskedTextBoxPaspDens:Text).
    infoSecObj:Pressure        = decimal(this-object:maskedTextBoxPressure:Text).
    infoSecObj:GroupNP         = this-object:comboBoxGroupNP:Text.
    
    infoSecObj:alarm-SGDKK     = this-object:cbSGDKK:Checked.
    infoSecObj:AukKey          = this-object:maskedTextBoxAukKey:Text.
    
    infoSecObj:KPnoMeas         = this-object:cbKPnoMeas:Checked.
    
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
    
    maskedTextBoxTankWeight:text = "" .
    maskedTextBoxTankVolPomi:text = "" .
    maskedTextBoxTankDensityPomi:text = "" .
    maskedTextBoxAccWeight:text = "" .
    
    assign
      v-doc-qnty      = a
      v-doc-density   = b
      v-cli-qnty      = c
    no-error .
    
    if not infoSecsObj:CliQntyInput
      then do:
        this-object:maskedTextBoxCliQnty:Text = format_round_1(a * b) no-error.
        v-cli-qnty = a * b .
      end.
    if not infoSecsObj:DocQntyInput
      then do:
        this-object:maskedTextBoxDocQnty:Text = format_round_0(c / b) no-error.
        v-doc-qnty = c / b .
      end.
    if not infoSecsObj:DensityInput
      then do:
        this-object:maskedTextBoxDocDens:Text = format_dens(c / a) no-error.
        v-doc-density = c / a .
      end.
    
  end.
  
  method private char format_round_3 (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 3), "->>>>>>>>9.999")).
    return str.
  end.

  method private char format_round_1 (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 1), "->>>>>>>>9.9")).
    return str.
  end.

  method private char format_round_0 (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 0), "->>>>>>>>9")).
    return str.
  end.

  method private char format_int (arg as integer):
    def var str as char no-undo.
    str = string (arg).
    return str. 
  end.

  method private char format_dens (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 4), "->>>>>>>>9.9999")) no-error.
    if error-status:error
      then return "".
    return str.
  end.
  
  method private char format_pressure (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 1), "->>>>>>>>9.<")) no-error.
    if error-status:error
      then return "".
    return str.
  end.
  
  method private char format_temper (arg as decimal):
    def var str as char no-undo.
    str = trim (string (round(arg, 1), "->>9.<")).
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
    
    v-str = v-str-2 + ":" + string (integer( truncate(( arg - integer (v-str-2) * 3600 ) / 60 , 0 ))) + ":00" no-error.
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
    calc-weight-vol ().
  end.

  method private void calc-weight-vol ( ):
  
    define variable v-area as decimal no-undo.
    define variable inum-ComboBoxShape as integer no-undo.

    if not infoSecsObj:FlagTrn 
      then return.
    
    infoSecsObj:GetInfoSectionProp(idSecTabPage).
    /*  assign                                                                              */
    /*    maskedTextBoxMouth:Text = string (decimal (maskedTextBoxMouth:Text))              */
    /*    maskedTextBoxMouth:Text:screen-value  = string (decimal (maskedTextBoxMouth:Text))*/
    /*    no-error.                                                                         */

    inum-ComboBoxShape = lookup (comboBoxShape:Text, var-list-shape, ",") - 1 no-error.
    
    infoSecsObj:GetArea (output v-area, input inum-ComboBoxShape, input maskedTextBoxDiameter:Text)
      no-error.
    if error-status:error then 
    do:
      message "Неверно указан размер горловины. Берется по умолчанию 0" view-as alert-box.
      maskedTextBoxDiameter:Text = "0".
      v-area = 0.
    end.
    infoSecsObj:InfoSectionCurr:NeckArea = v-area.
    
    if inum-ComboBoxShape = 0
    and infoSecsObj:RdcDnstvalue = "not"
    then do :
      maskedTextBoxMouth:Text = "0" .
    end .
    else do :
      maskedTextBoxMouth:Text = format_round_0 (   infoSecsObj:InfoSectionCurr:getMouth(decimal (maskedTextBoxABTArir:Text), v-area)) no-error.
      if error-status:error
      then do:
        message "Неверно указано отклонение от планки. Берется по умолчанию 0" view-as alert-box.
        maskedTextBoxDiameter:Text = "0".
        v-area = 0.
      end.
    end .
    
    if     not infoSecsObj:RdcDnstvalue = "not"
       and ((not infoSecsObj:IsSGDKK)
            or (    infoSecsObj:IsSGDKK 
                and cbSGDKK:checked
                and infoSecsObj:InfoSectionCurr:AccMeth = 0)
           )
    then do: 
      maskedTextBoxTankVol:Text = format_round_0 ((decimal (maskedTextBoxCarVol:Text)) + decimal (maskedTextBoxMouth:Text) - decimal(maskedTextBoxTankWater:Text) + (if comboBoxPour:Text = "Нижний налив" then infoSecsObj:InfoSectionCurr:DopVolume else 0)).
    end.
    
    /*  if maskedTextBoxMouth:Text <> decimal (maskedTextBoxMouth:Text) then      */
    /*    apply "value-changed" to maskedTextBoxMouth:Text in frame {&FRAME-NAME}.*/
      

    if infoSecsObj:RdcDnstvalue = "not" then 
    do:
      maskedTextBoxTankVol:Text = format_round_0 ((decimal (maskedTextBoxCarVol:Text)) + decimal (maskedTextBoxMouth:Text) - decimal(maskedTextBoxTankWater:Text) + (if comboBoxPour:Text = "Нижний налив" then infoSecsObj:InfoSectionCurr:DopVolume else 0)).
      if infoSecsObj:RdcDnstvalue = "not"
      then do:
        maskedTextBoxTankWeight:Text = format_round_3 (decimal(maskedTextBoxTankVol:Text) * decimal ( maskedTextBoxTankDens:Text)).
/*        this-object:maskedTextBoxTankWeight:Enabled = true.                                                                            */
/*        this-object:maskedTextBoxTankVol:ReadOnly = false.                                                                             */
/*        if not infoSecsObj:CliQntyInput                                                                                                */
/*          then do:                                                                                                                     */
/*            maskedTextBoxTankWeight:Text = format_round_3 (decimal(maskedTextBoxTankVol:Text) * decimal ( maskedTextBoxTankDens:Text)).*/
/*          end.                                                                                                                         */
/*        if not infoSecsObj:DocQntyInput                                                                                                */
/*          then do:                                                                                                                     */
/*            maskedTextBoxTankVol:Text = format_round_0 (decimal(maskedTextBoxTankWeight:Text) / decimal ( maskedTextBoxTankDens:Text)).*/
/*          end.                                                                                                                         */
/*        if not infoSecsObj:DensityInput                                                                                                */
/*          then do:                                                                                                                     */
/*            maskedTextBoxTankDens:Text = format_round_3 (decimal(maskedTextBoxTankWeight:Text) / decimal ( maskedTextBoxTankVol:Text)).*/
/*          end.                                                                                                                         */
      end.
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
    
/*    if infoSecsObj:IsSGDKK                            */
/*    and not (infoSecsObj:InfoSectionCurr:AccMeth = 0) */
/*    then do :                                         */
/*      maskedTextBoxTankVol:Text = format_round_0 (0) .*/
/*    end .                                             */

  end method.
  
  method private logical valid-density (input p-density as decimal) :
    define variable v-answ as logical no-undo .
    if (p-density <> ? and p-density > 0.0 and p-density < 1.0)
    then do:
      assign
        v-answ = true
      .
    end.
    else do:
      assign
        v-answ = false
      .
    end.
    return v-answ.
  end method . /* valid-density */

  method public void SetForcus ():
    
/*    if infoSecsObj:FlagTrn                   */
/*    then do:                                 */
/*      maskedTextBoxTankDensityPomi:Text = "".*/
/*      maskedTextBoxTankVolPomi:Text = "".    */
/*      maskedTextBoxTankWeight:Text = "".     */
/*      maskedTextBoxAccWeight:Text = "".      */
/*    end.                                     */
    
    setFocusMaskTextDoc:Focus() no-error .
    
  end.

  method public void ClWght ( input sender as System.Object, input e as System.EventArgs ):
    if not infoSecsObj:RdcDnstvalue = "not"
    then do:
      maskedTextBoxTankDensityPomi:Text = "".
      maskedTextBoxTankVolPomi:Text = "".
      maskedTextBoxTankWeight:Text = "".
      maskedTextBoxAccWeight:Text = "".
    end.
  end.

  method public logical CheckSec (input p-save as logical, input p-ShowMsg as logical, input p-exit as logical):
    
    define variable v-dec as decimal no-undo.
    define variable v-str as character no-undo.
    define variable v-sec as character no-undo .
    
    define buffer buf_rvs-doc for ub.rvs-doc .
    
    v-str = "Не заполнено обязательное поле ".

    if infoSecsObj:FlagTrn
    then do:
      if not infoSecsObj:RdcDnstvalue = "not"
      then do:
        if not infoSecsObj:IsSGDKK
        then do :
          
          if p-save
          and p-exit
          and infoSecsObj:GetInfoSectionProp(idSecTabPage):AccMeth = 1
          and infoSecsObj:IsActnComm
          then do :
            find first buf_rvs-doc no-lock where buf_rvs-doc.out-code = infoSecsObj:TrnDocNum no-error .
            if available buf_rvs-doc
            then do :
              v-dec = decimal (v-tank-weight-rvs) no-error.
              if (error-status:error or v-dec = 0 or v-dec = ?)
              then do:
/*                if p-ShowMsg or infoSecsObj:SectionNum = 1 then*/
                ShowMsg( "Сохранение параметров секции невозможно." + {&new-line} +
                         "Не выполнен расчет массы принимаемого НП."  + {&new-line} + 
                         "Введите данные и нажмите кнопку Рассчитать по данным сверок." ).
                return false.
              end .
            end .
          end .
          
          if cbKPnoMeas:Checked then return true .
  
          if lookup("a-b-tarir", v-sec-fields) > 0
          then do :
            if trim (maskedTextBoxABTArir:Text) = ""
            then do:
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( v-str + "отклонение от тарировочной пл." ).
              setFocusMaskTextDoc = maskedTextBoxABTArir.
              return false.
            end.
          end.
      
          if lookup("tank-density", v-sec-fields) > 0
          then do :
            v-dec = decimal (maskedTextBoxTankDens:Text) no-error.
            if (error-status:error or v-dec = 0)
            then do:
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( v-str + "плотность топлива" ).
              setFocusMaskTextDoc = maskedTextBoxTankDens.
              return false.
            end.
            if not valid-density(v-dec)
            then do :
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( "Неверно введена плотность топлива" ).
              setFocusMaskTextDoc = maskedTextBoxTankDens.
              return false.
            end .
          end.
           
          if lookup("tank-temp", v-sec-fields) > 0
          then do : 
            v-dec = decimal (maskedTextBoxTankTemp:Text) no-error.
            if (error-status:error or trim (maskedTextBoxTankTemp:Text) = "")
            then do:
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( v-str + "температура замера объема" ).
              setFocusMaskTextDoc = maskedTextBoxTankTemp.
              return false.
            end.
          end.
            
          if lookup("dens-temp", v-sec-fields) > 0
          then do :
            v-dec = decimal (maskedTextBoxDensTemp:Text) no-error.
            if (error-status:error or trim (maskedTextBoxDensTemp:Text) = "")
            then do:
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( v-str + "температура замера плотности" ).
              setFocusMaskTextDoc = maskedTextBoxDensTemp.
              return false.
            end.
          end.
            
          if lookup("place-si", v-sec-fields) > 0
          then do :
            v-dec = decimal (maskedTextBoxPlaceSi:Text) no-error.
            if (error-status:error or v-dec = 0)
            then do:
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( v-str + "средство измерения плотности" ).
              setFocusMaskTextDoc = maskedTextBoxPlaceSi.
              return false.
            end.
          end.
            
          if lookup("place-si-temp", v-sec-fields) > 0
          then do :
            v-dec = decimal (maskedTextBoxPlaceSiTemp:Text) no-error.
            if (error-status:error or v-dec = 0)
            then do:
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( v-str + "средство измерения температуры" ).
              setFocusMaskTextDoc = maskedTextBoxPlaceSiTemp.
              return false.
            end.
          end.
          
          if p-save
          then do :
            v-dec = decimal (maskedTextBoxTankWeight:Text) no-error.
            if (error-status:error or v-dec = 0)
            then do:
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( "Сохранение параметров секции невозможно." + {&new-line} +
                       "Не выполнен расчет массы принимаемого НП."  + {&new-line} + 
                       "Введите данные и нажмите кнопку Рассчитать по замерам в АЦ." ).
              return false.
            end.
            if infoSecsObj:GetInfoSectionProp(idSecTabPage):AccMeth = 1
            and infoSecsObj:IsActnComm
            then do :
              v-dec = decimal (v-tank-weight-rvs) no-error.
              if (error-status:error or v-dec = 0 or v-dec = ?)
              then do:
                if p-ShowMsg or infoSecsObj:SectionNum = 1
                then ShowMsg( "Сохранение параметров секции невозможно." + {&new-line} +
                         "Не выполнен расчет массы принимаемого НП."  + {&new-line} + 
                         "Введите данные и нажмите кнопку Рассчитать по данным сверок." ).
                return false.
              end .
            end .
          end .
        
        end .
        else do : /* infoSecsObj:IsSGDKK */
          if cbSGDKK:Checked
          then do :
            if not infoSecsObj:IsActnComm
            and infoSecsObj:isKP
            and trim(maskedTextBoxAukKey:text) > ""
            then do :
              if p-ShowMsg or infoSecsObj:SectionNum = 1
              then ShowMsg( "По накладной установлен флаг комиссионного приема. Недостаточно прав для ввода идентификатора доступа (ключа) верхнего уровня или одноразового кода!" ).
              setFocusMaskTextDoc = maskedTextBoxAukKey.
              return false.
            end .
            if length(trim(maskedTextBoxAukKey:text)) < 4
            and maskedTextBoxAukKey:Enabled
            and p-exit
            then do :
              ShowMsg( "Некорректная длина идентификатора доступа (ключа) верхнего уровня или одноразового кода для разблокировки API-адаптера. Проверьте введенное значение и скорректируйте." ).
              setFocusMaskTextDoc = maskedTextBoxAukKey.
              return false.
            end .
          end .
          else do :
            if lookup("accessIDLowerLevel", v-sec-fields) > 0
            then do :
              if length(trim(maskedTextBoxAukKey:text)) < 4
              and maskedTextBoxAukKey:Enabled
              then do :
                if p-ShowMsg then ShowMsg( "Некорректная длина идентификатора доступа (ключа) нижнего уровня. Проверьте введенное значение и скорректируйте." ).
                setFocusMaskTextDoc = maskedTextBoxAukKey.
                return false.
              end .
            end.
          end .
          
          if p-save
          and p-exit
          then do :
            if infoSecsObj:IsKPrvs
            then do :
              if infoSecsObj:GetInfoSectionProp(idSecTabPage):AccMeth = 1
              then do :
                v-dec = decimal (v-tank-weight-rvs) no-error.
                if (error-status:error or v-dec = 0 or v-dec = ?)
                then do:
                  ShowMsg( "Сохранение параметров секции невозможно." + {&new-line} +
                           "Не выполнен расчет массы принимаемого НП."  + {&new-line} + 
                           "Введите данные и нажмите кнопку Рассчитать по данным сверок." ).
                  return false.
                end .
              end .
            end .
            else
            if infoSecsObj:IsKP
            then do :
              if infoSecsObj:GetInfoSectionProp(idSecTabPage):AccMeth = 0
              then do :
                v-dec = decimal (maskedTextBoxTankWeight:Text) no-error.
                if (error-status:error or v-dec = 0)
                then do:
                  ShowMsg( "Сохранение параметров секции невозможно." + {&new-line} +
                           "Не выполнен расчет массы принимаемого НП."  + {&new-line} + 
                           "Введите данные и нажмите кнопку Рассчитать по замерам в АЦ." ).
                  return false.
                end .
              end .
            end .
          end .
          
        end .
        
      end.
      else do:
        
        if lookup("car-vol", v-sec-fields) > 0
        then do :
          v-dec = decimal (maskedTextBoxCarVol:Text) no-error.
          if (error-status:error or v-dec = 0)
          then do:
            if p-ShowMsg or infoSecsObj:SectionNum = 1
            then ShowMsg( v-str + "объем по свидетельству о поверке" ).
            setFocusMaskTextDoc = maskedTextBoxCarVol.
            return false.
          end.
        end.
    
        if lookup("a-b-tarir", v-sec-fields) > 0
        then do :
          if trim (maskedTextBoxABTArir:Text) = ""
          then do:
            if p-ShowMsg or infoSecsObj:SectionNum = 1
            then ShowMsg( v-str + "отклонение от тарировочной пл." ).
            setFocusMaskTextDoc = maskedTextBoxABTArir.
            return false.
          end.
        end.
    
        if lookup("tank-density", v-sec-fields) > 0
        then do :
          v-dec = decimal (maskedTextBoxTankDens:Text) no-error.
          if (error-status:error or v-dec = 0)
          then do:
            if p-ShowMsg or infoSecsObj:SectionNum = 1
            then ShowMsg( v-str + "плотность топлива" ).
            setFocusMaskTextDoc = maskedTextBoxTankDens.
            return false.
          end.
          if not valid-density(v-dec)
          then do :
            if p-ShowMsg or infoSecsObj:SectionNum = 1
            then ShowMsg( "Неверно введена плотность топлива" ).
            setFocusMaskTextDoc = maskedTextBoxTankDens.
            return false.
          end .
        end.
          
        if lookup("dens-temp", v-sec-fields) > 0
        then do :
          v-dec = decimal (maskedTextBoxDensTemp:Text) no-error.
          if (error-status:error or trim (maskedTextBoxDensTemp:Text) = "")
          then do:
            if p-ShowMsg or infoSecsObj:SectionNum = 1
            then ShowMsg( v-str + "температура замера плотности" ).
            setFocusMaskTextDoc = maskedTextBoxDensTemp.
            return false.
          end.
        end.

      end.
      if not infoSecsObj:GetInfoSectionProp(idSecTabPage):AccMeth = 1
      then do :
        calc-weight-vol().
      end .
    end.
    else do:
      if lookup("shape", v-sec-fields) > 0
      then do :
        v-dec = decimal (maskedTextBoxDiameter:Text) no-error.
        if trim (maskedTextBoxDiameter:Text) = ""
        then do:
          if p-ShowMsg then ShowMsg( v-str + "размер горловины" ).
/*          setFocusMaskTextDoc = maskedTextBoxDiameter.*/
          return false.
        end.
        
        if trim (comboBoxShape:Text) = ""
        then do:
          if p-ShowMsg then ShowMsg( v-str + "форма горловины" ).
/*          maskedTextBoxSecName:Focus().*/
          return false.
        end.
      end.
      
      if lookup("pour", v-sec-fields) > 0
      then do :
        if trim (comboBoxPour:Text) = ""
        then do:
          if p-ShowMsg then ShowMsg( v-str + "тип налива" ).
/*          maskedTextBoxSecName:Focus().*/
          return false.
        end.
      end.
  
      if lookup("section-name", v-sec-fields) > 0
      then do :
        if trim (maskedTextBoxSecName:Text) = "" or int (maskedTextBoxSecName:Text) = 0
        then do:
          if p-ShowMsg then ShowMsg( v-str + "номер секции" ).
          setFocusMaskTextDoc = maskedTextBoxSecName.
          return false.
        end.
      end.  
        
      if lookup("doc-qnty", v-sec-fields) > 0
      then do :
        v-dec = decimal (maskedTextBoxDocQnty:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "кол-во по документу" ).
          setFocusMaskTextDoc = maskedTextBoxDocQnty.
          return false.
        end.
      end.
  
      if lookup("cli-qnty", v-sec-fields) > 0
      then do :
        v-dec = decimal (maskedTextBoxCliQnty:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "масса по документу" ).
          setFocusMaskTextDoc = maskedTextBoxCliQnty.
          return false.
        end.
      end.
       
      if lookup("doc-dens", v-sec-fields) > 0
      then do : 
        v-dec = decimal (maskedTextBoxDocDens:Text) no-error.
        if ( error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "плотность по док. (при раб. темп.)" ).
          setFocusMaskTextDoc = maskedTextBoxDocDens.
          return false.
        end.
        if not valid-density(v-dec)
        then do :
          if p-ShowMsg then ShowMsg( "Неверно введена плотность по док. (при раб. темп.)" ).
          setFocusMaskTextDoc = maskedTextBoxDocDens.
          return false.
        end .
      end .
      
      if lookup("doc-dens-st", v-sec-fields) > 0
      then do : 
        v-dec = decimal (maskedTextBoxDocDensST:Text) no-error.
        if ( error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "плотность по док. (при станд. темп.)" ).
          setFocusMaskTextDoc = maskedTextBoxDocDensST.
          return false.
        end.
        if not valid-density(v-dec)
        then do :
          if p-ShowMsg then ShowMsg( "Неверно введена плотность по док. (при станд. темп.)" ).
          setFocusMaskTextDoc = maskedTextBoxDocDensST.
          return false.
        end .
      end .
      
      if lookup("acc-ship", v-sec-fields) > 0
      then do : 
        v-dec = decimal (maskedTextBoxAccShip:Text) no-error.
        if ( error-status:error or v-dec = ?)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "погрешность измерения поставщика" ).
          setFocusMaskTextDoc = maskedTextBoxAccShip.
          return false.
        end.
      end .
        
      if lookup("ttn-temp", v-sec-fields) > 0
      then do :
        v-dec = decimal (maskedTextBoxTTNTemp:Text) no-error.
        if ( error-status:error or v-dec = ?)
        or trim(maskedTextBoxTTNTemp:Text) = ""
        then do:
          if p-ShowMsg then ShowMsg( v-str + "температура по ТТН" ).
          setFocusMaskTextDoc = maskedTextBoxTTNTemp.
          return false.
        end.
      end .
      
      if lookup("doc-volume", v-sec-fields) > 0
      then do :
        v-dec = decimal (maskedTextBoxDocVolume:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "объем по документу" ).
          setFocusMaskTextDoc = maskedTextBoxDocVolume.
          return false.
        end.
      end.
      
      if lookup("group-np", v-sec-fields) > 0
      then do :
        if trim (comboBoxGroupNP:Text) = ""
        then do:
          v-dec = decimal (maskedTextBoxPressure:Text) no-error.
          if (error-status:error or v-dec = 0)
          then do:
            if p-ShowMsg then ShowMsg( v-str + "группа НП/давление насыщенных паров" ).
            setFocusMaskTextDoc = maskedTextBoxPressure.
            return false.
          end.
        end.
      end. 
      
      if lookup("num-passport", v-sec-fields) > 0
      then do :
        if trim (maskedTextBoxNumPassport:Text) = ""
        then do:
          if p-ShowMsg then ShowMsg( v-str + "дата и номер паспорта качества" ).
          setFocusMaskTextDoc = maskedTextBoxNumPassport.
          return false.
        end.
      end.
      
      if lookup("car-vol", v-sec-fields) > 0
      then do :
        v-dec = decimal (maskedTextBoxCarVol:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "объем по свидетельству о поверке" ).
          setFocusMaskTextDoc = maskedTextBoxCarVol.
          return false.
        end.
      end.
      
/*      if lookup("pasp-dens", v-sec-fields) > 0*/
/*      then do :                               */
        v-dec = decimal (maskedTextBoxPaspDens:Text) no-error.
        if ( error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "плотность по паспорту" ).
          setFocusMaskTextDoc = maskedTextBoxPaspDens.
          return false.
        end.
        if not valid-density(v-dec)
        then do :
          if p-ShowMsg then ShowMsg( "Неверно введена плотность по паспорту" ).
          setFocusMaskTextDoc = maskedTextBoxPaspDens.
          return false.
        end .
/*      end .*/
      
      if lookup("list-tank", v-sec-fields) > 0
      then do :
        v-dec = decimal (maskedTextBoxListTank:Text) no-error.
        if (error-status:error or v-dec = 0)
        then do:
          if p-ShowMsg then ShowMsg( v-str + "резервуар" ).
          setFocusMaskTextDoc = maskedTextBoxListTank.
          return false.
        end.
      end.
      
    end.
    
  end.
  
  method private void ShowMsg (arg as char):
    
    message arg view-as alert-box information title "Сообщение".
  
  end.
  
  { gbl/cur-time.i class}
  
  { ibs/th/str/ptrl/in-ptrl-cls.i }

  destructor public tanksection ( ):

  end destructor.

end class.


